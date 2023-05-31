Return-Path: <netdev+bounces-6860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DD4718733
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBA321C20E0D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDD417ADE;
	Wed, 31 May 2023 16:19:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E571773E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:19:13 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ECCE2;
	Wed, 31 May 2023 09:19:10 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b065154b79so9036175ad.1;
        Wed, 31 May 2023 09:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685549950; x=1688141950;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ay5rAxOHfx/B8chzAfePvV7fqVFxOZ0CT09CDjE+6L4=;
        b=JeNxbciEz2rTFdTBq/gT0vdHwMILZznBuPzm1VfrgeuuHMMBZ78mwGTc0DioxN/7VI
         myMgQEJ4sfU9b4WfeFaGEZaOcGOX8dB0UEIjzh4847ir3di0vEXu2R23kYGM1vuXmelj
         If+lMxxUEpA831fWc4jXJrF18OoDCLfpDBGdnVogbPtzU2BZH0ln8eKxVYqJt4za2F34
         IIz0cPFVChFQGFqcmYxF5b5dRh0xfB5HSVNZykEzp3IT+VxMMsE8p5i4ajw3utGldD+0
         UA8Cp0AeMip+FFz8SCUYZyQgbbMJyBk4rFDOMhlBTCloKAYLUFLI7pjZNX3xrinc4RAu
         jSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685549950; x=1688141950;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ay5rAxOHfx/B8chzAfePvV7fqVFxOZ0CT09CDjE+6L4=;
        b=LA2StZM2CLioD1xAxxPYmtK63A55s3MZmJWe04/S1QMQ/m1kqt63BV1HaX8aEwPdW8
         IScJPZ9YTzp02R/H5pxREdjGoqPU5XKCB7bil5D4JpYJfpxym/DhejG9UESlfLBLxLy0
         KjM84xMByUSwBubSdb4YwspsvrHWGzQl2C1AEMPEVAMyDfFVvol+t5DvjrfdaFgImKB1
         U+EfD/pBbuxgxb03I/0rRuCMjvO2/sGEAHGxxbMf+dD4mtcuU2EeuKc9BE1LKO5zkNPr
         M0YKmCdllWPg0mDE0UUo9ZjTQIl/4WF+yGEQobSjBy4chH6wnBZBL0PXagxqzhSGdNtj
         aXmw==
X-Gm-Message-State: AC+VfDysGj9vMEo/j/TCSeDCw5Aopc9ywwibB7L6JKNnsuqEkojxmXDz
	PRczqSn+gxQhpDdzRNALY+I=
X-Google-Smtp-Source: ACHHUZ5mvO2SCwb+DkvQbEPPRjJArQgeeDDOKTxxCXL+aX0cwcvFMlyEEQoROraG+/PB/xyExoe1+w==
X-Received: by 2002:a17:902:e542:b0:1ac:6fc3:6beb with SMTP id n2-20020a170902e54200b001ac6fc36bebmr7362934plf.9.1685549949845;
        Wed, 31 May 2023 09:19:09 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id v5-20020a170902b7c500b001a98f844e60sm1562981plz.263.2023.05.31.09.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:19:09 -0700 (PDT)
Message-ID: <0962a8a8493f0c892775cda8affb93c20f8b78f7.camel@gmail.com>
Subject: Re: [PATCH net-next v3 09/12] iavf: switch to Page Pool
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
 netdev@vger.kernel.org,  intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Date: Wed, 31 May 2023 09:19:06 -0700
In-Reply-To: <20230530150035.1943669-10-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
	 <20230530150035.1943669-10-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 17:00 +0200, Alexander Lobakin wrote:
> Now that the IAVF driver simply uses dev_alloc_page() + free_page() with
> no custom recycling logics and one whole page per frame, it can easily
> be switched to using Page Pool API instead.
> Introduce libie_rx_page_pool_create(), a wrapper for creating a PP with
> the default libie settings applicable to all Intel hardware, and replace
> the alloc/free calls with the corresponding PP functions, including the
> newly added sync-for-CPU helpers. Use skb_mark_for_recycle() to bring
> back the recycling and restore the initial performance.
>=20
> From the important object code changes, worth mentioning that
> __iavf_alloc_rx_pages() is now inlined due to the greatly reduced size.
> The resulting driver is on par with the pre-series code and 1-2% slower
> than the "optimized" version right before the recycling removal.
> But the number of locs and object code bytes slaughtered is much more
> important here after all, not speaking of that there's still a vast
> space for optimization and improvements.
>=20
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/Kconfig          |   1 +
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 126 +++++---------------
>  drivers/net/ethernet/intel/iavf/iavf_txrx.h |   8 +-
>  drivers/net/ethernet/intel/libie/rx.c       |  28 +++++
>  include/linux/net/intel/libie/rx.h          |   5 +-
>  5 files changed, 69 insertions(+), 99 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/in=
tel/Kconfig
> index cec4a938fbd0..a368afc42b8d 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -86,6 +86,7 @@ config E1000E_HWTS
> =20
>  config LIBIE
>  	tristate
> +	select PAGE_POOL
>  	help
>  	  libie (Intel Ethernet library) is a common library containing
>  	  routines shared by several Intel Ethernet drivers.
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/et=
hernet/intel/iavf/iavf_txrx.c
> index c33a3d681c83..1de67a70f045 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> @@ -3,7 +3,6 @@
> =20
>  #include <linux/net/intel/libie/rx.h>
>  #include <linux/prefetch.h>
> -#include <net/page_pool.h>
> =20
>  #include "iavf.h"
>  #include "iavf_trace.h"
> @@ -691,8 +690,6 @@ int iavf_setup_tx_descriptors(struct iavf_ring *tx_ri=
ng)
>   **/
>  void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
>  {
> -	u16 i;
> -
>  	/* ring already cleared, nothing to do */
>  	if (!rx_ring->rx_pages)
>  		return;
> @@ -703,28 +700,17 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
>  	}
> =20
>  	/* Free all the Rx ring sk_buffs */
> -	for (i =3D 0; i < rx_ring->count; i++) {
> +	for (u32 i =3D 0; i < rx_ring->count; i++) {

Did we make a change to our coding style to allow declaration of
variables inside of for statements? Just wondering if this is a change
since the recent updates to the ISO C standard, or if this doesn't
match up with what we would expect per the coding standard.

>  		struct page *page =3D rx_ring->rx_pages[i];
> -		dma_addr_t dma;
> =20
>  		if (!page)
>  			continue;
> =20
> -		dma =3D page_pool_get_dma_addr(page);
> -
>  		/* Invalidate cache lines that may have been written to by
>  		 * device so that we avoid corrupting memory.
>  		 */
> -		dma_sync_single_range_for_cpu(rx_ring->dev, dma,
> -					      LIBIE_SKB_HEADROOM,
> -					      LIBIE_RX_BUF_LEN,
> -					      DMA_FROM_DEVICE);
> -
> -		/* free resources associated with mapping */
> -		dma_unmap_page_attrs(rx_ring->dev, dma, LIBIE_RX_TRUESIZE,
> -				     DMA_FROM_DEVICE, IAVF_RX_DMA_ATTR);
> -
> -		__free_page(page);
> +		page_pool_dma_sync_full_for_cpu(rx_ring->pool, page);
> +		page_pool_put_full_page(rx_ring->pool, page, false);
>  	}
> =20
>  	rx_ring->next_to_clean =3D 0;
> @@ -739,10 +725,15 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
>   **/
>  void iavf_free_rx_resources(struct iavf_ring *rx_ring)
>  {
> +	struct device *dev =3D rx_ring->pool->p.dev;
> +
>  	iavf_clean_rx_ring(rx_ring);
>  	kfree(rx_ring->rx_pages);
>  	rx_ring->rx_pages =3D NULL;
> =20
> +	page_pool_destroy(rx_ring->pool);
> +	rx_ring->dev =3D dev;
> +
>  	if (rx_ring->desc) {
>  		dma_free_coherent(rx_ring->dev, rx_ring->size,
>  				  rx_ring->desc, rx_ring->dma);

Not a fan of this switching back and forth between being a page pool
pointer and a dev pointer. Seems problematic as it is easily
misinterpreted. I would say that at a minimum stick to either it is
page_pool(Rx) or dev(Tx) on a ring type basis.

> @@ -759,13 +750,15 @@ void iavf_free_rx_resources(struct iavf_ring *rx_ri=
ng)
>  int iavf_setup_rx_descriptors(struct iavf_ring *rx_ring)
>  {
>  	struct device *dev =3D rx_ring->dev;
> +	struct page_pool *pool;
> +	int ret =3D -ENOMEM;
> =20
>  	/* warn if we are about to overwrite the pointer */
>  	WARN_ON(rx_ring->rx_pages);
>  	rx_ring->rx_pages =3D kcalloc(rx_ring->count, sizeof(*rx_ring->rx_pages=
),
>  				    GFP_KERNEL);
>  	if (!rx_ring->rx_pages)
> -		return -ENOMEM;
> +		return ret;
> =20
>  	u64_stats_init(&rx_ring->syncp);
> =20
> @@ -781,15 +774,27 @@ int iavf_setup_rx_descriptors(struct iavf_ring *rx_=
ring)
>  		goto err;
>  	}
> =20
> +	pool =3D libie_rx_page_pool_create(&rx_ring->q_vector->napi,
> +					 rx_ring->count);
> +	if (IS_ERR(pool)) {
> +		ret =3D PTR_ERR(pool);
> +		goto err_free_dma;
> +	}
> +
> +	rx_ring->pool =3D pool;
> +
>  	rx_ring->next_to_clean =3D 0;
>  	rx_ring->next_to_use =3D 0;
> =20
>  	return 0;
> +
> +err_free_dma:
> +	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
>  err:
>  	kfree(rx_ring->rx_pages);
>  	rx_ring->rx_pages =3D NULL;
> =20
> -	return -ENOMEM;
> +	return ret;
>  }
> =20
>  /**

This setup works for iavf, however for i40e/ice you may run into issues
since the setup_rx_descriptors call is also used to setup the ethtool
loopback test w/o a napi struct as I recall so there may not be a
q_vector.

> @@ -810,40 +815,6 @@ static inline void iavf_release_rx_desc(struct iavf_=
ring *rx_ring, u32 val)
>  	writel(val, rx_ring->tail);
>  }
> =20
> -/**
> - * iavf_alloc_mapped_page - allocate and map a new page
> - * @dev: device used for DMA mapping
> - * @gfp: GFP mask to allocate page
> - *
> - * Returns a new &page if the it was successfully allocated, %NULL other=
wise.
> - **/
> -static struct page *iavf_alloc_mapped_page(struct device *dev, gfp_t gfp=
)
> -{
> -	struct page *page;
> -	dma_addr_t dma;
> -
> -	/* alloc new page for storage */
> -	page =3D __dev_alloc_page(gfp);
> -	if (unlikely(!page))
> -		return NULL;
> -
> -	/* map page for use */
> -	dma =3D dma_map_page_attrs(dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE,
> -				 IAVF_RX_DMA_ATTR);
> -
> -	/* if mapping failed free memory back to system since
> -	 * there isn't much point in holding memory we can't use
> -	 */
> -	if (dma_mapping_error(dev, dma)) {
> -		__free_page(page);
> -		return NULL;
> -	}
> -
> -	page_pool_set_dma_addr(page, dma);
> -
> -	return page;
> -}
> -
>  /**
>   * iavf_receive_skb - Send a completed packet up the stack
>   * @rx_ring:  rx ring in play
> @@ -877,7 +848,7 @@ static void iavf_receive_skb(struct iavf_ring *rx_rin=
g,
>  static u32 __iavf_alloc_rx_pages(struct iavf_ring *rx_ring, u32 to_refil=
l,
>  				 gfp_t gfp)
>  {
> -	struct device *dev =3D rx_ring->dev;
> +	struct page_pool *pool =3D rx_ring->pool;
>  	u32 ntu =3D rx_ring->next_to_use;
>  	union iavf_rx_desc *rx_desc;
> =20
> @@ -891,7 +862,7 @@ static u32 __iavf_alloc_rx_pages(struct iavf_ring *rx=
_ring, u32 to_refill,
>  		struct page *page;
>  		dma_addr_t dma;
> =20
> -		page =3D iavf_alloc_mapped_page(dev, gfp);
> +		page =3D page_pool_alloc_pages(pool, gfp);
>  		if (!page) {
>  			rx_ring->rx_stats.alloc_page_failed++;
>  			break;
> @@ -900,11 +871,6 @@ static u32 __iavf_alloc_rx_pages(struct iavf_ring *r=
x_ring, u32 to_refill,
>  		rx_ring->rx_pages[ntu] =3D page;
>  		dma =3D page_pool_get_dma_addr(page);
> =20
> -		/* sync the buffer for use by the device */
> -		dma_sync_single_range_for_device(dev, dma, LIBIE_SKB_HEADROOM,
> -						 LIBIE_RX_BUF_LEN,
> -						 DMA_FROM_DEVICE);
> -
>  		/* Refresh the desc even if buffer_addrs didn't change
>  		 * because each write-back erases this info.
>  		 */
> @@ -1091,21 +1057,6 @@ static void iavf_add_rx_frag(struct sk_buff *skb, =
struct page *page, u32 size)
>  			LIBIE_SKB_HEADROOM, size, LIBIE_RX_TRUESIZE);
>  }
> =20
> -/**
> - * iavf_sync_rx_page - Synchronize received data for use
> - * @dev: device used for DMA mapping
> - * @page: Rx page containing the data
> - * @size: size of the received data
> - *
> - * This function will synchronize the Rx buffer for use by the CPU.
> - */
> -static void iavf_sync_rx_page(struct device *dev, struct page *page, u32=
 size)
> -{
> -	dma_sync_single_range_for_cpu(dev, page_pool_get_dma_addr(page),
> -				      LIBIE_SKB_HEADROOM, size,
> -				      DMA_FROM_DEVICE);
> -}
> -
>  /**
>   * iavf_build_skb - Build skb around an existing buffer
>   * @page: Rx page to with the data
> @@ -1128,6 +1079,8 @@ static struct sk_buff *iavf_build_skb(struct page *=
page, u32 size)
>  	if (unlikely(!skb))
>  		return NULL;
> =20
> +	skb_mark_for_recycle(skb);
> +
>  	/* update pointers within the skb to store the data */
>  	skb_reserve(skb, LIBIE_SKB_HEADROOM);
>  	__skb_put(skb, size);
> @@ -1135,19 +1088,6 @@ static struct sk_buff *iavf_build_skb(struct page =
*page, u32 size)
>  	return skb;
>  }
> =20
> -/**
> - * iavf_unmap_rx_page - Unmap used page
> - * @dev: device used for DMA mapping
> - * @page: page to release
> - */
> -static void iavf_unmap_rx_page(struct device *dev, struct page *page)
> -{
> -	dma_unmap_page_attrs(dev, page_pool_get_dma_addr(page),
> -			     LIBIE_RX_TRUESIZE, DMA_FROM_DEVICE,
> -			     IAVF_RX_DMA_ATTR);
> -	page_pool_set_dma_addr(page, 0);
> -}
> -
>  /**
>   * iavf_is_non_eop - process handling of non-EOP buffers
>   * @rx_ring: Rx ring being processed
> @@ -1190,8 +1130,8 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_r=
ing, int budget)
>  	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
>  	const gfp_t gfp =3D GFP_ATOMIC | __GFP_NOWARN;
>  	u32 to_refill =3D IAVF_DESC_UNUSED(rx_ring);
> +	struct page_pool *pool =3D rx_ring->pool;
>  	struct sk_buff *skb =3D rx_ring->skb;
> -	struct device *dev =3D rx_ring->dev;
>  	u32 ntc =3D rx_ring->next_to_clean;
>  	u32 ring_size =3D rx_ring->count;
>  	u32 cleaned_count =3D 0;
> @@ -1240,13 +1180,11 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx=
_ring, int budget)
>  		 * stripped by the HW.
>  		 */
>  		if (unlikely(!size)) {
> -			iavf_unmap_rx_page(dev, page);
> -			__free_page(page);
> +			page_pool_recycle_direct(pool, page);
>  			goto skip_data;
>  		}
> =20
> -		iavf_sync_rx_page(dev, page, size);
> -		iavf_unmap_rx_page(dev, page);
> +		page_pool_dma_sync_for_cpu(pool, page, size);
> =20
>  		/* retrieve a buffer from the ring */
>  		if (skb)
> @@ -1256,7 +1194,7 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_r=
ing, int budget)
> =20
>  		/* exit if we failed to retrieve a buffer */
>  		if (!skb) {
> -			__free_page(page);
> +			page_pool_put_page(pool, page, size, true);
>  			rx_ring->rx_stats.alloc_buff_failed++;
>  			break;
>  		}
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.h b/drivers/net/et=
hernet/intel/iavf/iavf_txrx.h
> index 1421e90c7c4e..8fbe549ce6a5 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> @@ -83,9 +83,6 @@ enum iavf_dyn_idx_t {
> =20
>  #define iavf_rx_desc iavf_32byte_rx_desc
> =20
> -#define IAVF_RX_DMA_ATTR \
> -	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
> -
>  /**
>   * iavf_test_staterr - tests bits in Rx descriptor status and error fiel=
ds
>   * @rx_desc: pointer to receive descriptor (in le64 format)
> @@ -240,7 +237,10 @@ struct iavf_rx_queue_stats {
>  struct iavf_ring {
>  	struct iavf_ring *next;		/* pointer to next ring in q_vector */
>  	void *desc;			/* Descriptor ring memory */
> -	struct device *dev;		/* Used for DMA mapping */
> +	union {
> +		struct page_pool *pool;	/* Used for Rx page management */
> +		struct device *dev;	/* Used for DMA mapping on Tx */
> +	};
>  	struct net_device *netdev;	/* netdev ring maps to */
>  	union {
>  		struct iavf_tx_buffer *tx_bi;

Would it make more sense to have the page pool in the q_vector rather
than the ring? Essentially the page pool is associated per napi
instance so it seems like it would make more sense to store it with the
napi struct rather than potentially have multiple instances per napi.

> diff --git a/drivers/net/ethernet/intel/libie/rx.c b/drivers/net/ethernet=
/intel/libie/rx.c
> index f503476d8eef..d68eab76593c 100644
> --- a/drivers/net/ethernet/intel/libie/rx.c
> +++ b/drivers/net/ethernet/intel/libie/rx.c
> @@ -105,6 +105,34 @@ const struct libie_rx_ptype_parsed libie_rx_ptype_lu=
t[LIBIE_RX_PTYPE_NUM] =3D {
>  };
>  EXPORT_SYMBOL_NS_GPL(libie_rx_ptype_lut, LIBIE);
> =20
> +/* Page Pool */
> +
> +/**
> + * libie_rx_page_pool_create - create a PP with the default libie settin=
gs
> + * @napi: &napi_struct covering this PP (no usage outside its poll loops=
)
> + * @size: size of the PP, usually simply Rx queue len
> + *
> + * Returns &page_pool on success, casted -errno on failure.
> + */
> +struct page_pool *libie_rx_page_pool_create(struct napi_struct *napi,
> +					    u32 size)
> +{
> +	const struct page_pool_params pp =3D {
> +		.flags		=3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.order		=3D LIBIE_RX_PAGE_ORDER,
> +		.pool_size	=3D size,
> +		.nid		=3D NUMA_NO_NODE,
> +		.dev		=3D napi->dev->dev.parent,
> +		.napi		=3D napi,
> +		.dma_dir	=3D DMA_FROM_DEVICE,
> +		.max_len	=3D LIBIE_RX_BUF_LEN,
> +		.offset		=3D LIBIE_SKB_HEADROOM,
> +	};
> +
> +	return page_pool_create(&pp);
> +}
> +EXPORT_SYMBOL_NS_GPL(libie_rx_page_pool_create, LIBIE);
> +
>  MODULE_AUTHOR("Intel Corporation");
>  MODULE_DESCRIPTION("Intel(R) Ethernet common library");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/net/intel/libie/rx.h b/include/linux/net/intel=
/libie/rx.h
> index 3e8d0d5206e1..b86cadd281f1 100644
> --- a/include/linux/net/intel/libie/rx.h
> +++ b/include/linux/net/intel/libie/rx.h
> @@ -5,7 +5,7 @@
>  #define __LIBIE_RX_H
> =20
>  #include <linux/if_vlan.h>
> -#include <linux/netdevice.h>
> +#include <net/page_pool.h>
> =20
>  /* O(1) converting i40e/ice/iavf's 8/10-bit hardware packet type to a pa=
rsed
>   * bitfield struct.
> @@ -160,4 +160,7 @@ static inline void libie_skb_set_hash(struct sk_buff =
*skb, u32 hash,
>  /* Maximum frame size minus LL overhead */
>  #define LIBIE_MAX_MTU		(LIBIE_MAX_RX_FRM_LEN - LIBIE_RX_LL_LEN)
> =20
> +struct page_pool *libie_rx_page_pool_create(struct napi_struct *napi,
> +					    u32 size);
> +
>  #endif /* __LIBIE_RX_H */


