Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA5D132F93
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgAGTgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:36:46 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37470 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 14:36:46 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so490528qky.4
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 11:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9emnWVn6fdbyt5OHrTTV1pJ5etm6w1z+N1r1HysS9Nw=;
        b=kc2R6HjQeUN4dKMZufdB0V5uasHj7uHWCoBW+5oKBVb8j5D6wNNNaakZSIGoT2Sa7x
         0Hmper4NTbYl+m8SiybuolGD4rqDYyPDiVrv4jYacaFsYdpQfSYox4DA+NDl7cD8r7AC
         UZAKhtY+Q+NWuOjM5isx0OVFoeLc56oOpBbvqVCZC66Ofc0wwmcdLLBzSGB+DmSaL2kX
         9I6dMwBNN4TVqnTz6g8gguhguluLxR71tJcT2dfwuaXaAgjgM76WkYofrAPbmEeIBuvI
         OSUV8gUxJJZf81hpOSPgLjayuSP0vyxqbrDuKLLPXuYHqh5weLdR4s5BjUgC90FFbxxp
         ZpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9emnWVn6fdbyt5OHrTTV1pJ5etm6w1z+N1r1HysS9Nw=;
        b=QC5BKnmZiyJJWknz0EPrzlScolvhYHEAphaEGM/pQwX7vONHut0Vpb/CYxOXNj0+CE
         3PR/BxBfQcAu7GKAhwSwrwzBNYEQwqKK9Xr2TspuZ2qIs5oaN+ZyCn2ZNRzbCM1BHYS5
         YVD+m8jegTRsZQRG9y+FU2CrbSuSSSlbXP5gj97xCFZMVgLssTYvTAPkfGamUmphXb16
         B+EG0t/FwMWiT8HXalZdYd/VnyoR/rTnKPtIXaHsJWv525I3/GPrmTbvb7/T5Wel9V5c
         A09czoqdODUeRRnLh6SACwTb0r0/2nukWB5WmmYX3l8tjgJ1wO8csolhaUA7LICRf2+f
         aJ1g==
X-Gm-Message-State: APjAAAVCwpBevLh5IXzwNtjBqhbZvMvCdLSV3tQg5eiYj49l/4ly0DzX
        fmkgFNLfH+exzHe41aYuKnvqUDD81LU=
X-Google-Smtp-Source: APXvYqzl+Pia+60R3eRxk0YVEAgd+1oDSvr7Uplkl7OVRqGJ6g46OPUVhU3artYFVuXUTTTw1Ng0hw==
X-Received: by 2002:ae9:c316:: with SMTP id n22mr945425qkg.72.1578425804780;
        Tue, 07 Jan 2020 11:36:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 11sm275711qko.76.2020.01.07.11.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 11:36:44 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ioueh-0004m2-Q1; Tue, 07 Jan 2020 15:36:43 -0400
Date:   Tue, 7 Jan 2020 15:36:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 4/5] IB/mlx5: Introduce VAR object and its
 alloc/destroy methods
Message-ID: <20200107193643.GA18256@ziepe.ca>
References: <20191212110928.334995-1-leon@kernel.org>
 <20191212110928.334995-5-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212110928.334995-5-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:09:27PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> Introduce VAR object and its alloc/destroy KABI methods. The internal
> implementation uses the IB core API to manage mmap/munamp calls.
> 
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/main.c        | 157 +++++++++++++++++++++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h     |   7 +
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++
>  3 files changed, 181 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 79a5b8824b9d..873480b07686 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -2078,6 +2078,7 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
>  {
>  	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
>  	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
> +	struct mlx5_var_table *var_table = &dev->var_table;
>  	struct mlx5_ib_dm *mdm;
>  
>  	switch (mentry->mmap_flag) {
> @@ -2087,6 +2088,12 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
>  				       mdm->size);
>  		kfree(mdm);
>  		break;
> +	case MLX5_IB_MMAP_TYPE_VAR:
> +		mutex_lock(&var_table->bitmap_lock);
> +		clear_bit(mentry->page_idx, var_table->bitmap);
> +		mutex_unlock(&var_table->bitmap_lock);
> +		kfree(mentry);
> +		break;
>  	default:
>  		WARN_ON(true);
>  	}
> @@ -2255,6 +2262,15 @@ static int mlx5_ib_mmap_offset(struct mlx5_ib_dev *dev,
>  	return ret;
>  }
>  
> +static u64 mlx5_entry_to_mmap_offset(struct mlx5_user_mmap_entry *entry)
> +{
> +	u16 cmd = entry->rdma_entry.start_pgoff >> 16;
> +	u16 index = entry->rdma_entry.start_pgoff & 0xFFFF;
> +
> +	return (((index >> 8) << 16) | (cmd << MLX5_IB_MMAP_CMD_SHIFT) |
> +		(index & 0xFF)) << PAGE_SHIFT;
> +}
> +
>  static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
>  {
>  	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
> @@ -6034,6 +6050,145 @@ static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
>  	mlx5_nic_vport_disable_roce(dev->mdev);
>  }
>  
> +static int var_obj_cleanup(struct ib_uobject *uobject,
> +			   enum rdma_remove_reason why,
> +			   struct uverbs_attr_bundle *attrs)
> +{
> +	struct mlx5_user_mmap_entry *obj = uobject->object;
> +
> +	rdma_user_mmap_entry_remove(&obj->rdma_entry);
> +	return 0;
> +}
> +
> +static struct mlx5_user_mmap_entry *
> +alloc_var_entry(struct mlx5_ib_ucontext *c)
> +{
> +	struct mlx5_user_mmap_entry *entry;
> +	struct mlx5_var_table *var_table;
> +	u32 page_idx;
> +	int err;
> +
> +	var_table = &to_mdev(c->ibucontext.device)->var_table;
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_lock(&var_table->bitmap_lock);
> +	page_idx = find_first_zero_bit(var_table->bitmap,
> +				       var_table->num_var_hw_entries);
> +	if (page_idx >= var_table->num_var_hw_entries) {
> +		err = -ENOSPC;
> +		mutex_unlock(&var_table->bitmap_lock);
> +		goto end;
> +	}
> +
> +	set_bit(page_idx, var_table->bitmap);
> +	mutex_unlock(&var_table->bitmap_lock);
> +
> +	entry->address = var_table->hw_start_addr +
> +				(page_idx * var_table->stride_size);
> +	entry->page_idx = page_idx;
> +	entry->mmap_flag = MLX5_IB_MMAP_TYPE_VAR;
> +
> +	err = rdma_user_mmap_entry_insert_range(
> +		&c->ibucontext, &entry->rdma_entry, var_table->stride_size,
> +		MLX5_IB_MMAP_OFFSET_START << 16,
> +		(MLX5_IB_MMAP_OFFSET_END << 16) + (1UL << 16) - 1);
> +	if (err)
> +		goto err_insert;
> +
> +	return entry;
> +
> +err_insert:
> +	mutex_lock(&var_table->bitmap_lock);
> +	clear_bit(page_idx, var_table->bitmap);
> +	mutex_unlock(&var_table->bitmap_lock);
> +end:
> +	kfree(entry);
> +	return ERR_PTR(err);
> +}
> +
> +static int UVERBS_HANDLER(MLX5_IB_METHOD_VAR_OBJ_ALLOC)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *uobj = uverbs_attr_get_uobject(
> +		attrs, MLX5_IB_ATTR_VAR_OBJ_ALLOC_HANDLE);
> +	struct mlx5_ib_ucontext *c;
> +	struct mlx5_user_mmap_entry *entry;
> +	u64 mmap_offset;
> +	u32 length;
> +	int err;
> +
> +	c = to_mucontext(ib_uverbs_get_ucontext(attrs));
> +	if (IS_ERR(c))
> +		return PTR_ERR(c);
> +
> +	entry = alloc_var_entry(c);
> +	if (IS_ERR(entry))
> +		return PTR_ERR(entry);
> +
> +	mmap_offset = mlx5_entry_to_mmap_offset(entry);
> +	length = entry->rdma_entry.npages * PAGE_SIZE;
> +	uobj->object = entry;
> +
> +	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_VAR_OBJ_ALLOC_MMAP_OFFSET,
> +			     &mmap_offset, sizeof(mmap_offset));
> +	if (err)
> +		goto err;
> +
> +	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_VAR_OBJ_ALLOC_PAGE_ID,
> +			     &entry->page_idx, sizeof(entry->page_idx));
> +	if (err)
> +		goto err;
> +
> +	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_VAR_OBJ_ALLOC_MMAP_LENGTH,
> +			     &length, sizeof(length));
> +	if (err)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	rdma_user_mmap_entry_remove(&entry->rdma_entry);
> +	return err;
> +}
> +
> +DECLARE_UVERBS_NAMED_METHOD(
> +	MLX5_IB_METHOD_VAR_OBJ_ALLOC,
> +	UVERBS_ATTR_IDR(MLX5_IB_ATTR_VAR_OBJ_ALLOC_HANDLE,
> +			MLX5_IB_OBJECT_VAR,
> +			UVERBS_ACCESS_NEW,
> +			UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_VAR_OBJ_ALLOC_PAGE_ID,
> +			   UVERBS_ATTR_TYPE(u32),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_VAR_OBJ_ALLOC_MMAP_LENGTH,
> +			   UVERBS_ATTR_TYPE(u32),
> +			   UA_MANDATORY),
> +	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_VAR_OBJ_ALLOC_MMAP_OFFSET,
> +			    UVERBS_ATTR_TYPE(u64),
> +			    UA_MANDATORY));
> +
> +DECLARE_UVERBS_NAMED_METHOD_DESTROY(
> +	MLX5_IB_METHOD_VAR_OBJ_DESTROY,
> +	UVERBS_ATTR_IDR(MLX5_IB_ATTR_VAR_OBJ_DESTROY_HANDLE,
> +			MLX5_IB_OBJECT_VAR,
> +			UVERBS_ACCESS_DESTROY,
> +			UA_MANDATORY));
> +
> +DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_VAR,
> +			    UVERBS_TYPE_ALLOC_IDR(var_obj_cleanup),
> +			    &UVERBS_METHOD(MLX5_IB_METHOD_VAR_OBJ_ALLOC),
> +			    &UVERBS_METHOD(MLX5_IB_METHOD_VAR_OBJ_DESTROY));
> +
> +static bool var_is_supported(struct ib_device *device)
> +{
> +	struct mlx5_ib_dev *dev = to_mdev(device);
> +
> +	return (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
> +			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q);
> +}
> +
>  ADD_UVERBS_ATTRIBUTES_SIMPLE(
>  	mlx5_ib_dm,
>  	UVERBS_OBJECT_DM,
> @@ -6064,6 +6219,8 @@ static const struct uapi_definition mlx5_ib_defs[] = {
>  	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_FLOW_ACTION,
>  				&mlx5_ib_flow_action),
>  	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DM, &mlx5_ib_dm),
> +	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(MLX5_IB_OBJECT_VAR,
> +				UAPI_DEF_IS_OBJ_SUPPORTED(var_is_supported)),
>  	{}
>  };
>  
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 23ad949e247f..489128fe8603 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -71,6 +71,11 @@
>  
>  #define MLX5_MKEY_PAGE_SHIFT_MASK __mlx5_mask(mkc, log_page_size)
>  
> +enum {
> +	MLX5_IB_MMAP_OFFSET_START = 9,
> +	MLX5_IB_MMAP_OFFSET_END = 255,
> +};
> +
>  enum {
>  	MLX5_IB_MMAP_CMD_SHIFT	= 8,
>  	MLX5_IB_MMAP_CMD_MASK	= 0xff,
> @@ -120,6 +125,7 @@ enum {
>  
>  enum mlx5_ib_mmap_type {
>  	MLX5_IB_MMAP_TYPE_MEMIC = 1,
> +	MLX5_IB_MMAP_TYPE_VAR = 2,
>  };
>  
>  #define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev)                                        \
> @@ -563,6 +569,7 @@ struct mlx5_user_mmap_entry {
>  	struct rdma_user_mmap_entry rdma_entry;
>  	u8 mmap_flag;
>  	u64 address;
> +	u32 page_idx;

Why are we storing this in the global struct when it is never read
except by the caller of alloc_var_entry()? Return it from
alloc_var_entry?

Also the final patch in the series should be here as at this point
mmap will succeed but return the wrong cachability flags.

Since Leon is away I can fix this two things if you agree.

Jason
