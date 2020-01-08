class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.order('created_at DESC').page(params[:page]).per(5)
  end

  def new
    @item = Item.new
    @item.images.new
    @items = Item.includes(:images).order('created_at DESC')
    # @parents = ItemCategory.all.order("id ASC").limit(13)
    # カテゴリーテーブルのidカラム上から１３行目を@parentに代入せよ
  end

  def create
    @item = Item.new(item_params)   
    if @item.save
      redirect_to root_path
    else
      redirect_to new_item_path
    end
  end

  def show
    @images = @item.images
    @items = Item.where(user_id: @item.user_id).order('created_at DESC')
  end
  
  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      redirect_to edit_item_path
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path
    else
      redirect_to edit_item_path
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :price, :discription, images_attributes: [:id, :src]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

end