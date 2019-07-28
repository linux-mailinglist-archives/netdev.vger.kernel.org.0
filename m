Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966A577ED1
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfG1Ja7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 05:30:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38882 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfG1Ja5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 05:30:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so58623314wrr.5;
        Sun, 28 Jul 2019 02:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vP+Yv4IlGNmTl4m/xdvYnOL6jVDZD3DhStv7DRaQH48=;
        b=q9KftavwK2Rs/y8zu4wVS4P1HTl9yA9vkghgQDTgT+xuT0NCkamdWRdygnmR8sMbQL
         CNaGAKV7QfkltAG1gb/i5CuXdez1Zpq2gJOMGjLNFIYN1GSNlhwSvrZfIBGwkWqSLQWG
         DEtxB4IPs0rise9PYWX/sjtD33AkkdnPQpQ4Ru7TFyXUHyEOyLjaa+MWUX67kfwpS9Mw
         wZSF5FpjU2GxE4tZe1dKH7Riz5m304pmMdz8LhCn78bNUEUHb/w24v6dwl3qBSvY0Xoc
         kLCYb1/HMKQuUdWXsiF6a8/p7RV0O6p+amRsxw+XVXp4Wa0Pi5Axa0Kqpu7Jszh/sqxE
         +H5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vP+Yv4IlGNmTl4m/xdvYnOL6jVDZD3DhStv7DRaQH48=;
        b=sxBXDQsjzSy0Ae7IR3fBR4pKQRXFYG196n0UbqjX4aB5mAOcbYXiAIzrkauIfUsj7c
         /i+ri98tGrzfEZ9mj3AhoIGpk3+IXNnvXePzrL3T1QhyqZaaIEll7FFdBBqePH74VIbZ
         PJ9XjosUAQbXFS16zHLWNS/cgq46xMZOWRWdedAtfReBTXx8qNhtZJ/PF7sGqCnd1Lkh
         /LM59OxaHj5xLdC1rq220CDhzE9ibFRUnr4i73f+Cm+ypo4nmxjyEWEPnmgR77FLe6Mv
         8bP+aksSz7znFWqIwBMd6ypNFSV/xPCARsGltdYoPFcQRNc7C4zrds/4erkdUq2ZqzfX
         iNrQ==
X-Gm-Message-State: APjAAAV3dcPVZcVJqqvaqRXp0lCfDs5q4NMOS/VJB+zoKwwHiobKjudm
        s4nzqsrrREpbiyHVF5ZnNXM=
X-Google-Smtp-Source: APXvYqzRDJ/FI4TAVJq12Of2iut+PRLGm33zN8YNTyeWis/rxHy41EK3+ZCBGc4Xb+K6Ay1YFaBWog==
X-Received: by 2002:adf:e483:: with SMTP id i3mr72383842wrm.210.1564306255133;
        Sun, 28 Jul 2019 02:30:55 -0700 (PDT)
Received: from kheib-workstation (bzq-79-176-65-36.red.bezeqint.net. [79.176.65.36])
        by smtp.gmail.com with ESMTPSA id h1sm43364717wrt.20.2019.07.28.02.30.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 02:30:54 -0700 (PDT)
Date:   Sun, 28 Jul 2019 12:30:51 +0300
From:   Kamal Heib <kamalheib1@gmail.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        ariel.elior@marvell.com, dledford@redhat.com, galpress@amazon.com,
        linux-rdma@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190728093051.GB5250@kheib-workstation>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725175540.GA18757@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 02:55:40PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 09, 2019 at 05:17:30PM +0300, Michal Kalderon wrote:
> > Create some common API's for adding entries to a xa_mmap.
> > Searching for an entry and freeing one.
> > 
> > The code was copied from the efa driver almost as is, just renamed
> > function to be generic and not efa specific.
> > 
> > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> >  drivers/infiniband/core/device.c      |   1 +
> >  drivers/infiniband/core/rdma_core.c   |   1 +
> >  drivers/infiniband/core/uverbs_cmd.c  |   1 +
> >  drivers/infiniband/core/uverbs_main.c | 135 ++++++++++++++++++++++++++++++++++
> >  include/rdma/ib_verbs.h               |  46 ++++++++++++
> >  5 files changed, 184 insertions(+)
> > 
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 8a6ccb936dfe..a830c2c5d691 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -2521,6 +2521,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
> >  	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
> >  	SET_DEVICE_OP(dev_ops, map_phys_fmr);
> >  	SET_DEVICE_OP(dev_ops, mmap);
> > +	SET_DEVICE_OP(dev_ops, mmap_free);
> >  	SET_DEVICE_OP(dev_ops, modify_ah);
> >  	SET_DEVICE_OP(dev_ops, modify_cq);
> >  	SET_DEVICE_OP(dev_ops, modify_device);
> > diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> > index ccf4d069c25c..1ed01b02401f 100644
> > +++ b/drivers/infiniband/core/rdma_core.c
> > @@ -816,6 +816,7 @@ static void ufile_destroy_ucontext(struct ib_uverbs_file *ufile,
> >  
> >  	rdma_restrack_del(&ucontext->res);
> >  
> > +	rdma_user_mmap_entries_remove_free(ucontext);
> >  	ib_dev->ops.dealloc_ucontext(ucontext);
> >  	kfree(ucontext);
> >  
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index 7ddd0e5bc6b3..44c0600245e4 100644
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -254,6 +254,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
> >  
> >  	mutex_init(&ucontext->per_mm_list_lock);
> >  	INIT_LIST_HEAD(&ucontext->per_mm_list);
> > +	xa_init(&ucontext->mmap_xa);
> >  
> >  	ret = get_unused_fd_flags(O_CLOEXEC);
> >  	if (ret < 0)
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> > index 11c13c1381cf..4b909d7b97de 100644
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -965,6 +965,141 @@ int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
> >  }
> >  EXPORT_SYMBOL(rdma_user_mmap_io);
> >  
> > +static inline u64
> > +rdma_user_mmap_get_key(const struct rdma_user_mmap_entry *entry)
> > +{
> > +	return (u64)entry->mmap_page << PAGE_SHIFT;
> > +}
> > +
> > +/**
> > + * rdma_user_mmap_entry_get() - Get an entry from the mmap_xa.
> > + *
> > + * @ucontext: associated user context.
> > + * @key: The key received from rdma_user_mmap_entry_insert which
> > + *     is provided by user as the address to map.
> > + * @len: The length the user wants to map
> > + *
> > + * This function is called when a user tries to mmap a key it
> > + * initially received from the driver. They key was created by
> > + * the function rdma_user_mmap_entry_insert.
> > + *
> > + * Return an entry if exists or NULL if there is no match.
> > + */
> > +struct rdma_user_mmap_entry *
> > +rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len)
> > +{
> > +	struct rdma_user_mmap_entry *entry;
> > +	u64 mmap_page;
> > +
> > +	mmap_page = key >> PAGE_SHIFT;
> > +	if (mmap_page > U32_MAX)
> > +		return NULL;
> > +
> > +	entry = xa_load(&ucontext->mmap_xa, mmap_page);
> > +	if (!entry || entry->length != len)
> > +		return NULL;
> > +
> > +	ibdev_dbg(ucontext->device,
> > +		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
> > +		  entry->obj, key, entry->address, entry->length);
> > +
> > +	return entry;
> > +}
> > +EXPORT_SYMBOL(rdma_user_mmap_entry_get);
> 
> It is a mistake we keep making, and maybe the war is hopelessly lost
> now, but functions called from a driver should not be part of the
> ib_uverbs module - ideally uverbs is an optional module. They should
> be in ib_core.
> 
> Maybe put this in ib_core_uverbs.c ?
> 
> Kamal, you've been tackling various cleanups, maybe making ib_uverbs
> unloadable again is something you'd be keen on?
>

Yes, Could you please give some background on that?


> > +/**
> > + * rdma_user_mmap_entry_insert() - Allocate and insert an entry to the mmap_xa.
> > + *
> > + * @ucontext: associated user context.
> > + * @obj: opaque driver object that will be stored in the entry.
> > + * @address: The address that will be mmapped to the user
> > + * @length: Length of the address that will be mmapped
> > + * @mmap_flag: opaque driver flags related to the address (For
> > + *           example could be used for cachability)
> > + *
> > + * This function should be called by drivers that use the rdma_user_mmap
> > + * interface for handling user mmapped addresses. The database is handled in
> > + * the core and helper functions are provided to insert entries into the
> > + * database and extract entries when the user call mmap with the given key.
> > + * The function returns a unique key that should be provided to user, the user
> > + * will use the key to map the given address.
> > + *
> > + * Note this locking scheme cannot support removal of entries,
> > + * except during ucontext destruction when the core code
> > + * guarentees no concurrency.
> > + *
> > + * Return: unique key or RDMA_USER_MMAP_INVALID if entry was not added.
> > + */
> > +u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
> > +				u64 address, u64 length, u8 mmap_flag)
> > +{
> > +	struct rdma_user_mmap_entry *entry;
> > +	u32 next_mmap_page;
> > +	int err;
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return RDMA_USER_MMAP_INVALID;
> > +
> > +	entry->obj = obj;
> > +	entry->address = address;
> > +	entry->length = length;
> > +	entry->mmap_flag = mmap_flag;
> > +
> > +	xa_lock(&ucontext->mmap_xa);
> > +	if (check_add_overflow(ucontext->mmap_xa_page,
> > +			       (u32)(length >> PAGE_SHIFT),
> 
> Should this be divide round up ?
> 
> > +			       &next_mmap_page))
> > +		goto err_unlock;
> 
> I still don't like that this algorithm latches into a permanent
> failure when the xa_page wraps.
> 
> It seems worth spending a bit more time here to tidy this.. Keep using
> the mmap_xa_page scheme, but instead do something like
> 
> alloc_cyclic_range():
> 
> while () {
>    // Find first empty element in a cyclic way
>    xa_page_first = mmap_xa_page;
>    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
> 
>    // Is there a enough room to have the range?
>    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
>       mmap_xa_page = 0;
>       continue;
>    }
> 
>    // See if the element before intersects 
>    elm = xa_find(xa, &zero, xa_page_end, 0);
>    if (elm && intersects(xa_page_first, xa_page_last, elm->first, elm->last)) {
>       mmap_xa_page = elm->last + 1;
>       continue
>    }
>   
>    // xa_page_first -> xa_page_end should now be free
>    xa_insert(xa, xa_page_start, entry);
>    mmap_xa_page = xa_page_end + 1;
>    return xa_page_start;
> }
> 
> Approximately, please check it.
> 
> > @@ -2199,6 +2201,17 @@ struct iw_cm_conn_param;
> >  
> >  #define DECLARE_RDMA_OBJ_SIZE(ib_struct) size_t size_##ib_struct
> >  
> > +#define RDMA_USER_MMAP_FLAG_SHIFT 56
> > +#define RDMA_USER_MMAP_PAGE_MASK GENMASK(EFA_MMAP_FLAG_SHIFT - 1, 0)
> > +#define RDMA_USER_MMAP_INVALID U64_MAX
> > +struct rdma_user_mmap_entry {
> > +	void *obj;
> > +	u64 address;
> > +	u64 length;
> > +	u32 mmap_page;
> > +	u8 mmap_flag;
> > +};
> > +
> >  /**
> >   * struct ib_device_ops - InfiniBand device operations
> >   * This structure defines all the InfiniBand device operations, providers will
> > @@ -2311,6 +2324,19 @@ struct ib_device_ops {
> >  			      struct ib_udata *udata);
> >  	void (*dealloc_ucontext)(struct ib_ucontext *context);
> >  	int (*mmap)(struct ib_ucontext *context, struct vm_area_struct *vma);
> > +	/**
> > +	 * Memory that is mapped to the user can only be freed once the
> > +	 * ucontext of the application is destroyed. This is for
> > +	 * security reasons where we don't want an application to have a
> > +	 * mapping to phyiscal memory that is freed and allocated to
> > +	 * another application. For this reason, all the entries are
> > +	 * stored in ucontext and once ucontext is freed mmap_free is
> > +	 * called on each of the entries. They type of the memory that
> 
> They -> the
> 
> > +	 * was mapped may differ between entries and is opaque to the
> > +	 * rdma_user_mmap interface. Therefore needs to be implemented
> > +	 * by the driver in mmap_free.
> > +	 */
> > +	void (*mmap_free)(struct rdma_user_mmap_entry *entry);
> >  	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
> >  	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
> >  	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
> > @@ -2709,6 +2735,11 @@ void ib_set_device_ops(struct ib_device *device,
> >  #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
> >  int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
> >  		      unsigned long pfn, unsigned long size, pgprot_t prot);
> > +u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
> > +				u64 address, u64 length, u8 mmap_flag);
> > +struct rdma_user_mmap_entry *
> > +rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len);
> > +void rdma_user_mmap_entries_remove_free(struct ib_ucontext
> > *ucontext);
> 
> Should remove_free should be in the core-priv header?
> 
> Jason
