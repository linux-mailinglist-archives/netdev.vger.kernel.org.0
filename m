Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248742FE0A6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbhAUE2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbhAUEV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:21:28 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7DC061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:20:46 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w14so758292pfi.2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GVZNfIJA28VjtrjFkt5/wlNAlEmcGfOL3ZuiJW4VKCk=;
        b=sGcH/8VBkYtgRUpYI44dBBAT/IhPP6bOTDSLW9NnCD2byx4VvliO3njpY1WaPUVVQU
         qAQyJcAqU7cNTB247ZyuIFY65msSvlYSETioKZGq/jfPWrUbuSzXVnRa+cq9e7FQBKZU
         uFI85P/5IiSI8jn7F7c/jiH3mM9/BD11W2ccNs3DK+PyI6iotB5sYVlSFWO+Km5a2OKt
         XndI/vdNHH6rZqT7xd4W5rXPj/uyUMWd/kMrT2+AXJpHP5bHByAYIidixKQPKtVue87+
         2JhYVk1U60A1A1X87KO7chyfxqOMiXGFkoGom8JaYfR7otnLHid6GaxQMxQ/9qLWleAJ
         eQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GVZNfIJA28VjtrjFkt5/wlNAlEmcGfOL3ZuiJW4VKCk=;
        b=FS8O6swcUVqjllo0Xhe+HReVRBQFzVvqGCyBOa7w5HZ4+5mgwghDcBovd6/WFVpYeX
         ioPYSoJGEk8LQnWjrYhvu2n2fTOJ2cRP2EZsKGr1w6hgWGB+4rZhW9ahdGfQiwvOl+X8
         eNNUbZEoXdh0MjqrrAgDWnBeXx9KDmnasx6cGCrqrXkT2VS41tWCJV57S30w7ajPoJcO
         wcJpsjQshhFDlYuRfrf+8Uo/wm632VvOZm6WjE3Zp3h2VVVtuRLEKd3iWj/zsEAzM0NI
         RJzRfkUW6xnC9XQIJe/n/UIlCvCAoNgoD87b6mpql/h/KELYAdEnrooYSJFurU/yjDkg
         Ax5A==
X-Gm-Message-State: AOAM531GcHWjlvBI692lR0H9CiIiZqy57hG0va/QRsUtgyhdDmps9rxh
        s6yvJFMl8g/jspRE2pPM12zlsQMB4ms=
X-Google-Smtp-Source: ABdhPJxC5W4gpoA2JZcbIQU4Sk4EyQiQN+f0Q4wxuGTOiTQykWo71OcY/gvv3Isg/GeQP2gIiAqDSA==
X-Received: by 2002:a05:6a00:80e:b029:1b6:39dd:8b2a with SMTP id m14-20020a056a00080eb02901b639dd8b2amr12071190pfk.23.1611202845601;
        Wed, 20 Jan 2021 20:20:45 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id k9sm3780079pjj.8.2021.01.20.20.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:20:44 -0800 (PST)
Date:   Thu, 21 Jan 2021 12:20:35 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to alloc
 the pool buffers"
Message-ID: <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
References: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 10:32:35AM +0530, sundeep.lkml@gmail.com wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>=20
> Octeontx2 hardware needs buffer pointers which are 128 byte
> aligned. napi_alloc_frag() returns buffer pointers which are
> not 128 byte aligned sometimes because if napi_alloc_skb() is
> called when a packet is received then subsequent napi_alloc_frag()
> returns buffer which is not 128 byte aligned and those buffers
> cannot be issued to NPA hardware. Hence reverting this commit.
>=20
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 52 +++++++++++++---=
------
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 15 ++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  3 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  4 ++
>  4 files changed, 50 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/d=
rivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index bdfa2e2..921cd86 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -483,35 +483,40 @@ void otx2_config_irq_coalescing(struct otx2_nic *pf=
vf, int qidx)
>  		     (pfvf->hw.cq_ecount_wait - 1));
>  }
> =20
> -dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *po=
ol)
> +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> +			   gfp_t gfp)
>  {
>  	dma_addr_t iova;
> -	u8 *buf;
> =20
> -	buf =3D napi_alloc_frag(pool->rbsize);
> -	if (unlikely(!buf))

Hmm, why not?
  buf =3D napi_alloc_frag(pool->rbsize + 128);
  buf =3D PTR_ALIGN(buf, 128);

Or we can teach the napi_alloc_frag to return an aligned addr, something li=
ke this (just build test):
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bdfa2e293531..a2a98a30d18e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -488,7 +488,7 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, str=
uct otx2_pool *pool)
 	dma_addr_t iova;
 	u8 *buf;
=20
-	buf =3D napi_alloc_frag(pool->rbsize);
+	buf =3D napi_alloc_frag_align(pool->rbsize, 128);
 	if (unlikely(!buf))
 		return -ENOMEM;
=20
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 53caa9846854..03eb8f88b714 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -583,6 +583,8 @@ extern void free_pages(unsigned long addr, unsigned int=
 order);
=20
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
+extern void *page_frag_alloc_align(struct page_frag_cache *nc,
+				   unsigned int fragsz, gfp_t gfp_mask, int align);
 extern void *page_frag_alloc(struct page_frag_cache *nc,
 			     unsigned int fragsz, gfp_t gfp_mask);
 extern void page_frag_free(void *addr);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c9568cf60c2a..6bd15956a39f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2877,6 +2877,7 @@ static inline void skb_free_frag(void *addr)
 	page_frag_free(addr);
 }
=20
+void *napi_alloc_frag_align(unsigned int fragsz, int align);
 void *napi_alloc_frag(unsigned int fragsz);
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
 				 unsigned int length, gfp_t gfp_mask);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b031a5ae0bd5..7e5ff9a7f00c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5137,8 +5137,8 @@ void __page_frag_cache_drain(struct page *page, unsig=
ned int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
=20
-void *page_frag_alloc(struct page_frag_cache *nc,
-		      unsigned int fragsz, gfp_t gfp_mask)
+void *page_frag_alloc_align(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask, int align)
 {
 	unsigned int size =3D PAGE_SIZE;
 	struct page *page;
@@ -5190,10 +5190,17 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 	}
=20
 	nc->pagecnt_bias--;
-	nc->offset =3D offset;
+	nc->offset =3D ALIGN_DOWN(offset, align);
=20
 	return nc->va + offset;
 }
+EXPORT_SYMBOL(page_frag_alloc_align);
+
+void *page_frag_alloc(struct page_frag_cache *nc,
+		      unsigned int fragsz, gfp_t gfp_mask)
+{
+	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
+}
 EXPORT_SYMBOL(page_frag_alloc);
=20
 /*
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cce237d0ec2e..ee7e6a2bfe55 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -374,18 +374,24 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
=20
-static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
+static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask, int al=
ign)
 {
 	struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
=20
-	return page_frag_alloc(&nc->page, fragsz, gfp_mask);
+	return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align);
 }
=20
-void *napi_alloc_frag(unsigned int fragsz)
+void *napi_alloc_frag_align(unsigned int fragsz, int align)
 {
 	fragsz =3D SKB_DATA_ALIGN(fragsz);
=20
-	return __napi_alloc_frag(fragsz, GFP_ATOMIC);
+	return __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
+}
+EXPORT_SYMBOL(napi_alloc_frag_align);
+
+void *napi_alloc_frag(unsigned int fragsz)
+{
+	return __napi_alloc_frag(fragsz, GFP_ATOMIC, 0);
 }
 EXPORT_SYMBOL(napi_alloc_frag);
=20
@@ -407,7 +413,7 @@ void *netdev_alloc_frag(unsigned int fragsz)
 		data =3D page_frag_alloc(nc, fragsz, GFP_ATOMIC);
 	} else {
 		local_bh_disable();
-		data =3D __napi_alloc_frag(fragsz, GFP_ATOMIC);
+		data =3D __napi_alloc_frag(fragsz, GFP_ATOMIC, 0);
 		local_bh_enable();
 	}
 	return data;
Thanks,
Kevin

> +	/* Check if request can be accommodated in previous allocated page */
> +	if (pool->page && ((pool->page_offset + pool->rbsize) <=3D
> +	    (PAGE_SIZE << pool->rbpage_order))) {
> +		pool->pageref++;
> +		goto ret;
> +	}
> +
> +	otx2_get_page(pool);
> +
> +	/* Allocate a new page */
> +	pool->page =3D alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> +				 pool->rbpage_order);
> +	if (unlikely(!pool->page))
>  		return -ENOMEM;
> =20
> -	iova =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> -				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> -	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> -		page_frag_free(buf);
> +	pool->page_offset =3D 0;
> +ret:
> +	iova =3D (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> +				      pool->rbsize, DMA_FROM_DEVICE);
> +	if (!iova) {
> +		if (!pool->page_offset)
> +			__free_pages(pool->page, pool->rbpage_order);
> +		pool->page =3D NULL;
>  		return -ENOMEM;
>  	}
> -
> +	pool->page_offset +=3D pool->rbsize;
>  	return iova;
>  }
> =20
> -static dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_poo=
l *pool)
> -{
> -	dma_addr_t addr;
> -
> -	local_bh_disable();
> -	addr =3D __otx2_alloc_rbuf(pfvf, pool);
> -	local_bh_enable();
> -	return addr;
> -}
> -
>  void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
>  {
>  	struct otx2_nic *pfvf =3D netdev_priv(netdev);
> @@ -913,7 +918,7 @@ static void otx2_pool_refill_task(struct work_struct =
*work)
>  	free_ptrs =3D cq->pool_ptrs;
> =20
>  	while (cq->pool_ptrs) {
> -		bufptr =3D otx2_alloc_rbuf(pfvf, rbpool);
> +		bufptr =3D otx2_alloc_rbuf(pfvf, rbpool, GFP_KERNEL);
>  		if (bufptr <=3D 0) {
>  			/* Schedule a WQ if we fails to free atleast half of the
>  			 * pointers else enable napi for this RQ.
> @@ -1172,6 +1177,7 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u1=
6 pool_id,
>  		return err;
> =20
>  	pool->rbsize =3D buf_size;
> +	pool->rbpage_order =3D get_order(buf_size);
> =20
>  	/* Initialize this pool's context via AF */
>  	aq =3D otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
> @@ -1259,12 +1265,13 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  			return -ENOMEM;
> =20
>  		for (ptr =3D 0; ptr < num_sqbs; ptr++) {
> -			bufptr =3D otx2_alloc_rbuf(pfvf, pool);
> +			bufptr =3D otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
>  			if (bufptr <=3D 0)
>  				return bufptr;
>  			otx2_aura_freeptr(pfvf, pool_id, bufptr);
>  			sq->sqb_ptrs[sq->sqb_count++] =3D (u64)bufptr;
>  		}
> +		otx2_get_page(pool);
>  	}
> =20
>  	return 0;
> @@ -1310,12 +1317,13 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
>  	for (pool_id =3D 0; pool_id < hw->rqpool_cnt; pool_id++) {
>  		pool =3D &pfvf->qset.pool[pool_id];
>  		for (ptr =3D 0; ptr < num_ptrs; ptr++) {
> -			bufptr =3D otx2_alloc_rbuf(pfvf, pool);
> +			bufptr =3D otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
>  			if (bufptr <=3D 0)
>  				return bufptr;
>  			otx2_aura_freeptr(pfvf, pool_id,
>  					  bufptr + OTX2_HEAD_ROOM);
>  		}
> +		otx2_get_page(pool);
>  	}
> =20
>  	return 0;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/d=
rivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 143ae04..f670da9 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -491,6 +491,18 @@ static inline void otx2_aura_freeptr(struct otx2_nic=
 *pfvf,
>  		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
>  }
> =20
> +/* Update page ref count */
> +static inline void otx2_get_page(struct otx2_pool *pool)
> +{
> +	if (!pool->page)
> +		return;
> +
> +	if (pool->pageref)
> +		page_ref_add(pool->page, pool->pageref);
> +	pool->pageref =3D 0;
> +	pool->page =3D NULL;
> +}
> +
>  static inline int otx2_get_pool_idx(struct otx2_nic *pfvf, int type, int=
 idx)
>  {
>  	if (type =3D=3D AURA_NIX_SQ)
> @@ -636,7 +648,8 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl=
);
>  int otx2_txsch_alloc(struct otx2_nic *pfvf);
>  int otx2_txschq_stop(struct otx2_nic *pfvf);
>  void otx2_sqb_flush(struct otx2_nic *pfvf);
> -dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *po=
ol);
> +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> +			   gfp_t gfp);
>  int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
>  void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
>  int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index d0e2541..7774d9a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -333,7 +333,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
> =20
>  	/* Refill pool with new buffers */
>  	while (cq->pool_ptrs) {
> -		bufptr =3D __otx2_alloc_rbuf(pfvf, cq->rbpool);
> +		bufptr =3D otx2_alloc_rbuf(pfvf, cq->rbpool, GFP_ATOMIC);
>  		if (unlikely(bufptr <=3D 0)) {
>  			struct refill_work *work;
>  			struct delayed_work *dwork;
> @@ -351,6 +351,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
>  		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
>  		cq->pool_ptrs--;
>  	}
> +	otx2_get_page(cq->rbpool);
> =20
>  	return processed_cqe;
>  }
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
> index 73af156..9cd20c7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
> @@ -114,7 +114,11 @@ struct otx2_cq_poll {
>  struct otx2_pool {
>  	struct qmem		*stack;
>  	struct qmem		*fc_addr;
> +	u8			rbpage_order;
>  	u16			rbsize;
> +	u32			page_offset;
> +	u16			pageref;
> +	struct page		*page;
>  };
> =20
>  struct otx2_cq_queue {
> --=20
> 2.7.4
>=20

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAJARMACgkQk1jtMN6u
sXHkQQgAjWV8ZVXLntYtyGluIrcy/IczqH7+0wbYiYiWzS5Iw4Vu6UfZ76MOAx97
Ca5+C6I8yTKshlO1EIUgjw6lJEM41gPgpOP176i5fG43r7x4K4GH82nzfhW/Kyjl
opISX+eKDD/HeuTG2/wQrUGmj+5HZ2JFnTGwQkLYw4NnWiaWHhHPyYlzz5HkrVro
KbAq9Ru8yOGE58dWF7elQRTQGZ6s9kMKbDWmnNB0jqMP3pbqEBkNIcAAtae9d4aH
5u5iHPs1T8oZKGM02aERxQr+GIfu5b9R2Z5ccRPha8l9BD8uTQZ7VrQoqSqa66nv
nSKNhkbgzvmw6OqleOkBkxg0yXBuDA==
=dFpy
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
