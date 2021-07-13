Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9093C6FEA
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhGMLpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbhGMLpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:45:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7041C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:42:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w14so21074079edc.8
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 04:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2wPp/1soT9726IbCKk+567N+cbV3rHR5v7IOzW1ypiI=;
        b=fIQgx0hxRAC50u/HUbxsBEtfdCMx+1ued3aXxXSsD0rEoGUsvQzTwXmzqpY7sK3yg7
         xMNODBMH5YZDG4YwYBzlbQwvE8k07dM62W+/bHALO7vVPshNsd4A23SUKuyzzpeSmT87
         QipmGK+1BO8jMEY+PPyebD+A0nAglhuKigQmNwya+fb569RZaN20GMRBmc4xT1W4XYv/
         WnuAZMoRGrPojTjOdQC1TJZrvOonNiCtmqhzp03IVV3aBM6SCJGutg+PKpn+UfND6hfB
         6K/gzSm+iyvKriulkZL7ztKScO/tNcsqRQiEHbOshe00WZ8W3bZAOTYZEeTtO4aqK2u0
         tfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2wPp/1soT9726IbCKk+567N+cbV3rHR5v7IOzW1ypiI=;
        b=WWxq0KYu/JPn3TNaeAa6DaVm1nQRjDG15uFMBjOaorB2bbWHrCI2SMnR08hHGrmGAB
         I3aBmXKnDZ5452XaL2EodeXjYpDyys1EaZsErbzDeSGkIjyGFbfApxQKVyi/Wjfxi5YE
         dSORe4mgZqPfSvPjzGgNr8Vqxg4pT2n0y63mnRoguQzIzFCcTgBaoHVUUul7jrMTv7Ot
         Z/5BR0tHlZdv5Bg5ZdYmOpXAKMMboIE+ieBd2AHK9JFv/3409OpbJTAFRye7+P/gCamF
         E/acsP5snL+MVXRUt+lZv1kFsM8Y0Zq6vtGdI8Tvr8bo+AvOMsh63eOSBq/T2cSU9nhp
         hrWQ==
X-Gm-Message-State: AOAM5305uSwJumP93jzkhqoiTkqJtLRU0OeHueNG2Bwj2ThtckIPJAY9
        4qTLiLP0QxxYzTPCddX/yuDDhlWdSv4e/3dn7yT+iA==
X-Google-Smtp-Source: ABdhPJyrsO+9BrKJPpzba2LtuODxZBtarbd4Xr+LHn6dldRpsS4jst0GpxdXuXZaZOIYrxzkFKFndKS2uf2rhzadgHI=
X-Received: by 2002:aa7:cacd:: with SMTP id l13mr5227672edt.218.1626176539269;
 Tue, 13 Jul 2021 04:42:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:2486:0:0:0:0:0 with HTTP; Tue, 13 Jul 2021 04:42:18
 -0700 (PDT)
X-Originating-IP: [5.35.23.161]
In-Reply-To: <1626168272-25622-5-git-send-email-linyunsheng@huawei.com>
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com> <1626168272-25622-5-git-send-email-linyunsheng@huawei.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 13 Jul 2021 14:42:18 +0300
Message-ID: <CAOJe8K33OM0_FpMtE_iDqRHYNGoKrZyBaoe6TiSHumcAoMsFnQ@mail.gmail.com>
Subject: Re: [PATCH rfc v4 4/4] net: hns3: support skb's frag page recycling
 based on page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        linux@armlinux.org.uk, mw@semihalf.com, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, will@kernel.org, willy@infradead.org,
        vbabka@suse.cz, fenghua.yu@intel.com, guro@fb.com,
        peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/21, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> This patch adds skb's frag page recycling support based on
> the elevated refcnt support in page pool.
>
> The performance improves above 10~20% with IOMMU disabled.
> The performance improves about 200% when IOMMU is enabled
> and iperf server shares the same cpu with irq/NAPI.

Could you share workload details?

>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 79
> +++++++++++++++++++++++--
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +
>  2 files changed, 77 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index cdb5f14..c799129 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -3205,6 +3205,21 @@ static int hns3_alloc_buffer(struct hns3_enet_ring
> *ring,
>  	unsigned int order = hns3_page_order(ring);
>  	struct page *p;
>
> +	if (ring->page_pool) {
> +		p = page_pool_dev_alloc_frag(ring->page_pool,
> +					     &cb->page_offset,
> +					     hns3_buf_size(ring));
> +		if (unlikely(!p))
> +			return -ENOMEM;
> +
> +		cb->priv = p;
> +		cb->buf = page_address(p);
> +		cb->dma = page_pool_get_dma_addr(p);
> +		cb->type = DESC_TYPE_FRAG;
> +		cb->reuse_flag = 0;
> +		return 0;
> +	}
> +
>  	p = dev_alloc_pages(order);
>  	if (!p)
>  		return -ENOMEM;
> @@ -3227,8 +3242,12 @@ static void hns3_free_buffer(struct hns3_enet_ring
> *ring,
>  	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_BOUNCE_HEAD |
>  			DESC_TYPE_BOUNCE_ALL | DESC_TYPE_SGL_SKB))
>  		napi_consume_skb(cb->priv, budget);
> -	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
> -		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
> +	else if (!HNAE3_IS_TX_RING(ring)) {
> +		if (cb->type & DESC_TYPE_PAGE && cb->pagecnt_bias)
> +			__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
> +		else if (cb->type & DESC_TYPE_FRAG)
> +			page_pool_put_full_page(ring->page_pool, cb->priv, false);
> +	}
>  	memset(cb, 0, sizeof(*cb));
>  }
>
> @@ -3315,7 +3334,7 @@ static int hns3_alloc_and_map_buffer(struct
> hns3_enet_ring *ring,
>  	int ret;
>
>  	ret = hns3_alloc_buffer(ring, cb);
> -	if (ret)
> +	if (ret || ring->page_pool)
>  		goto out;
>
>  	ret = hns3_map_buffer(ring, cb);
> @@ -3337,7 +3356,8 @@ static int hns3_alloc_and_attach_buffer(struct
> hns3_enet_ring *ring, int i)
>  	if (ret)
>  		return ret;
>
> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
> +					 ring->desc_cb[i].page_offset);
>
>  	return 0;
>  }
> @@ -3367,7 +3387,8 @@ static void hns3_replace_buffer(struct hns3_enet_ring
> *ring, int i,
>  {
>  	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
>  	ring->desc_cb[i] = *res_cb;
> -	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma);
> +	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
> +					 ring->desc_cb[i].page_offset);
>  	ring->desc[i].rx.bd_base_info = 0;
>  }
>
> @@ -3539,6 +3560,12 @@ static void hns3_nic_reuse_page(struct sk_buff *skb,
> int i,
>  	u32 frag_size = size - pull_len;
>  	bool reused;
>
> +	if (ring->page_pool) {
> +		skb_add_rx_frag(skb, i, desc_cb->priv, frag_offset,
> +				frag_size, truesize);
> +		return;
> +	}
> +
>  	/* Avoid re-using remote or pfmem page */
>  	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
>  		goto out;
> @@ -3856,6 +3883,9 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring,
> unsigned int length,
>  		/* We can reuse buffer as-is, just make sure it is reusable */
>  		if (dev_page_is_reusable(desc_cb->priv))
>  			desc_cb->reuse_flag = 1;
> +		else if (desc_cb->type & DESC_TYPE_FRAG)
> +			page_pool_put_full_page(ring->page_pool, desc_cb->priv,
> +						false);
>  		else /* This page cannot be reused so discard it */
>  			__page_frag_cache_drain(desc_cb->priv,
>  						desc_cb->pagecnt_bias);
> @@ -3863,6 +3893,10 @@ static int hns3_alloc_skb(struct hns3_enet_ring
> *ring, unsigned int length,
>  		hns3_rx_ring_move_fw(ring);
>  		return 0;
>  	}
> +
> +	if (ring->page_pool)
> +		skb_mark_for_recycle(skb);
> +
>  	u64_stats_update_begin(&ring->syncp);
>  	ring->stats.seg_pkt_cnt++;
>  	u64_stats_update_end(&ring->syncp);
> @@ -3901,6 +3935,10 @@ static int hns3_add_frag(struct hns3_enet_ring
> *ring)
>  					    "alloc rx fraglist skb fail\n");
>  				return -ENXIO;
>  			}
> +
> +			if (ring->page_pool)
> +				skb_mark_for_recycle(new_skb);
> +
>  			ring->frag_num = 0;
>
>  			if (ring->tail_skb) {
> @@ -4705,6 +4743,29 @@ static void hns3_put_ring_config(struct hns3_nic_priv
> *priv)
>  	priv->ring = NULL;
>  }
>
> +static void hns3_alloc_page_pool(struct hns3_enet_ring *ring)
> +{
> +	struct page_pool_params pp_params = {
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG,
> +		.order = hns3_page_order(ring),
> +		.pool_size = ring->desc_num * hns3_buf_size(ring) / PAGE_SIZE,
> +		.nid = dev_to_node(ring_to_dev(ring)),
> +		.dev = ring_to_dev(ring),
> +		.dma_dir = DMA_FROM_DEVICE,
> +		.offset = 0,
> +		.max_len = 0,
> +	};
> +
> +	ring->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(ring->page_pool)) {
> +		dev_warn(ring_to_dev(ring), "page pool creation failed: %ld\n",
> +			 PTR_ERR(ring->page_pool));
> +		ring->page_pool = NULL;
> +	} else {
> +		dev_info(ring_to_dev(ring), "page pool creation succeeded\n");
> +	}
> +}
> +
>  static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
>  {
>  	int ret;
> @@ -4724,6 +4785,8 @@ static int hns3_alloc_ring_memory(struct
> hns3_enet_ring *ring)
>  		goto out_with_desc_cb;
>
>  	if (!HNAE3_IS_TX_RING(ring)) {
> +		hns3_alloc_page_pool(ring);
> +
>  		ret = hns3_alloc_ring_buffers(ring);
>  		if (ret)
>  			goto out_with_desc;
> @@ -4764,6 +4827,12 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
>  		devm_kfree(ring_to_dev(ring), tx_spare);
>  		ring->tx_spare = NULL;
>  	}
> +
> +	if (!HNAE3_IS_TX_RING(ring) && ring->page_pool) {
> +		page_pool_destroy(ring->page_pool);
> +		ring->page_pool = NULL;
> +		dev_info(ring_to_dev(ring), "page pool destroyed\n");
> +	}
>  }
>
>  static int hns3_buf_size2type(u32 buf_size)
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 15af3d9..115c0ce 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -6,6 +6,7 @@
>
>  #include <linux/dim.h>
>  #include <linux/if_vlan.h>
> +#include <net/page_pool.h>
>
>  #include "hnae3.h"
>
> @@ -307,6 +308,7 @@ enum hns3_desc_type {
>  	DESC_TYPE_BOUNCE_ALL		= 1 << 3,
>  	DESC_TYPE_BOUNCE_HEAD		= 1 << 4,
>  	DESC_TYPE_SGL_SKB		= 1 << 5,
> +	DESC_TYPE_FRAG			= 1 << 6,
>  };
>
>  struct hns3_desc_cb {
> @@ -451,6 +453,7 @@ struct hns3_enet_ring {
>  	struct hnae3_queue *tqp;
>  	int queue_index;
>  	struct device *dev; /* will be used for DMA mapping of descriptors */
> +	struct page_pool *page_pool;
>
>  	/* statistic */
>  	struct ring_stats stats;
> --
> 2.7.4
>
>
