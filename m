Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA20D2968D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390841AbfEXLFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:05:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33018 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390808AbfEXLFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:05:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so947592wmh.0
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/eS3RTAKM0LL7cIXF4vFCDyf24nO8llG5kMtsKxQHOo=;
        b=sLtyQ12qN101+xOrJHPqWD2osMl7K/GT/v+oqLHcOGyN7ouQDqpBlSp4ZefD/3erfY
         0+okGsRqbc5v7R/Kq5jO3hqJ9+4wPW/EUyfNTAwF09fy2768s0choZbls7uGqk9GlPyc
         pGMBIY+lGJzpftbmyGckKv7EBgZnCaIlz011oz9Qph5fb2DNuThuj0wWxnhLMmFMNwOG
         3ifd95id55R8WDQM1Ma4vFY/mWS8063tU83VGtnEAE5I605ztUYmoUSRLKwuGb+js1sp
         G9pzPhIO90tWkoVzjshrCrb23ClojNJawoxdfLJQ5N7o5bc6ytKt/NJLaS7rro5JIHnD
         WTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/eS3RTAKM0LL7cIXF4vFCDyf24nO8llG5kMtsKxQHOo=;
        b=aFs1NoA32DqsXKxP42UlcHKXYI8j4lUGyodWDdfWzm7yYYWfMSaEbMBBSiXX4dsP5R
         AgoWq59tIhfdCRkMcsF110kUOz1Ww5Is/JQtd1yh04cQwUOVdq4rGWEyKhtz0bcSRGWp
         rMi+pKuWL2ZeTSNnNaRYfu29MQZGCu2qzzblecB4rRZ3/1O+E/9DDphXTWH1tl76Qhnh
         yfg1GKxONeyimjponUzOvygLk7KTjJui44d16I5VwzeHHiYfDq0PIlPHzxgMae1J32fU
         DQrA3/v3qswvBhdNanLukrL0Fj/BsaCX7u0z9r1Kc3Q84k7y/pOxttA1i58zKNpBHuNc
         RlIw==
X-Gm-Message-State: APjAAAWRHF0/+jT52bKo1+EO/6cff1IrnkDaoO1s/FLFtiCLbd5N8Vr8
        SuF3MS8a2UGl1i+vS0IQAL2aRA==
X-Google-Smtp-Source: APXvYqwR5irqh4JGuzkJTTkqtsB8HjfEqPAwWrhkicRWqO7U4RfzqockNvcCOGM36d7YS8FmNUWDUQ==
X-Received: by 2002:a1c:9c42:: with SMTP id f63mr16490119wme.23.1558695914853;
        Fri, 24 May 2019 04:05:14 -0700 (PDT)
Received: from apalos (ppp-94-66-229-5.home.otenet.gr. [94.66.229.5])
        by smtp.gmail.com with ESMTPSA id b18sm2086662wrx.75.2019.05.24.04.05.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 04:05:14 -0700 (PDT)
Date:   Fri, 24 May 2019 14:05:11 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190524110511.GA27885@apalos>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 09:20:35PM +0300, Ivan Khoronzhuk wrote:
> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.
> 
> Due to specific of cpsw, the same TX/RX handler can be used by 2
> network devices, so special fields in buffer are added to identify
> an interface the frame is destined to. Thus XDP works for both
> interfaces, that allows to test xdp redirect between two interfaces
> easily.
> 
> XDP prog is common for all channels till appropriate changes are added
> in XDP infrastructure.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  drivers/net/ethernet/ti/Kconfig        |   1 +
>  drivers/net/ethernet/ti/cpsw.c         | 555 ++++++++++++++++++++++---
>  drivers/net/ethernet/ti/cpsw_ethtool.c |  53 +++
>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>  4 files changed, 554 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index bd05a977ee7e..3cb8c5214835 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -50,6 +50,7 @@ config TI_CPSW
>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>  	select TI_DAVINCI_MDIO
>  	select MFD_SYSCON
> +	select PAGE_POOL
>  	select REGMAP
>  	---help---
>  	  This driver supports TI's CPSW Ethernet Switch.
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 87a600aeee4a..274e6b64ea9e 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -31,6 +31,10 @@
>  #include <linux/if_vlan.h>
>  #include <linux/kmemleak.h>
>  #include <linux/sys_soc.h>
> +#include <net/page_pool.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/filter.h>
>  
>  #include <linux/pinctrl/consumer.h>
>  #include <net/pkt_cls.h>
> @@ -60,6 +64,10 @@ static int descs_pool_size = CPSW_CPDMA_DESCS_POOL_SIZE_DEFAULT;
>  module_param(descs_pool_size, int, 0444);
>  MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>  
> +/* The buf includes headroom compatible with both skb and xdpf */
> +#define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
> +#define CPSW_HEADROOM  ALIGN(CPSW_HEADROOM_NA, sizeof(long))
> +
>  #define for_each_slave(priv, func, arg...)				\
>  	do {								\
>  		struct cpsw_slave *slave;				\
> @@ -74,6 +82,8 @@ MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>  				(func)(slave++, ##arg);			\
>  	} while (0)
>  
> +#define CPSW_XMETA_OFFSET	ALIGN(sizeof(struct xdp_frame), sizeof(long))
> +
>  static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
>  				    __be16 proto, u16 vid);
>  
> @@ -337,24 +347,58 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
>  	return;
>  }
>  
> +static int cpsw_is_xdpf_handle(void *handle)
> +{
> +	return (unsigned long)handle & BIT(0);
> +}
> +
> +static void *cpsw_xdpf_to_handle(struct xdp_frame *xdpf)
> +{
> +	return (void *)((unsigned long)xdpf | BIT(0));
> +}
> +
> +static struct xdp_frame *cpsw_handle_to_xdpf(void *handle)
> +{
> +	return (struct xdp_frame *)((unsigned long)handle & ~BIT(0));
> +}
> +
> +struct __aligned(sizeof(long)) cpsw_meta_xdp {
> +	struct net_device *ndev;
> +	int ch;
> +};
> +
>  int cpsw_tx_handler(void *token, int len, int status)
>  {
> +	struct cpsw_meta_xdp	*xmeta;
> +	struct xdp_frame	*xdpf;
> +	struct net_device	*ndev;
>  	struct netdev_queue	*txq;
> -	struct sk_buff		*skb = token;
> -	struct net_device	*ndev = skb->dev;
> -	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
> +	struct sk_buff		*skb;
> +	int			ch;
> +
> +	if (cpsw_is_xdpf_handle(token)) {
> +		xdpf = cpsw_handle_to_xdpf(token);
> +		xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +		ndev = xmeta->ndev;
> +		ch = xmeta->ch;
> +		xdp_return_frame_rx_napi(xdpf);
> +	} else {
> +		skb = token;
> +		ndev = skb->dev;
> +		ch = skb_get_queue_mapping(skb);
> +		cpts_tx_timestamp(ndev_to_cpsw(ndev)->cpts, skb);
> +		dev_kfree_skb_any(skb);
> +	}
>  
>  	/* Check whether the queue is stopped due to stalled tx dma, if the
>  	 * queue is stopped then start the queue as we have free desc for tx
>  	 */
> -	txq = netdev_get_tx_queue(ndev, skb_get_queue_mapping(skb));
> +	txq = netdev_get_tx_queue(ndev, ch);
>  	if (unlikely(netif_tx_queue_stopped(txq)))
>  		netif_tx_wake_queue(txq);
>  
> -	cpts_tx_timestamp(cpsw->cpts, skb);
>  	ndev->stats.tx_packets++;
>  	ndev->stats.tx_bytes += len;
> -	dev_kfree_skb_any(skb);
>  	return 0;
>  }
>  
> @@ -401,22 +445,229 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
>  	}
>  }
>  
> +static int cpsw_xdp_tx_frame_mapped(struct cpsw_priv *priv,
> +				    struct xdp_frame *xdpf, struct page *page)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct netdev_queue *txq;
> +	struct cpdma_chan *txch;
> +	dma_addr_t dma;
> +	int ret;
> +
> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +	xmeta->ch = 0;
> +
> +	txch = cpsw->txv[0].ch;
> +	dma = (xdpf->data - (void *)xdpf) + page->dma_addr;
> +	ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf), dma,
> +				       xdpf->len,
> +				       priv->emac_port + cpsw->data.dual_emac);
> +	if (ret) {
> +		xdp_return_frame_rx_napi(xdpf);
> +		goto stop;
> +	}
> +
> +	/* no tx desc - stop sending us tx frames */
> +	if (unlikely(!cpdma_check_free_tx_desc(txch)))
> +		goto stop;
> +
> +	return ret;
> +stop:
> +	txq = netdev_get_tx_queue(priv->ndev, 0);
> +	netif_tx_stop_queue(txq);
> +
> +	/* Barrier, so that stop_queue visible to other cpus */
> +	smp_mb__after_atomic();
> +
> +	if (cpdma_check_free_tx_desc(txch))
> +		netif_tx_wake_queue(txq);
> +
> +	return ret;
> +}
> +
> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct netdev_queue *txq;
> +	struct cpdma_chan *txch;
> +	int ret;
> +
> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +	if (sizeof(*xmeta) > xdpf->headroom)
> +		return -EINVAL;
> +
> +	xmeta->ndev = priv->ndev;
> +	xmeta->ch = 0;
> +
> +	txch = cpsw->txv[0].ch;
> +	ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
> +				xdpf->len,
> +				priv->emac_port + cpsw->data.dual_emac);
> +	if (ret) {
> +		xdp_return_frame_rx_napi(xdpf);
> +		goto stop;
> +	}
> +
> +	/* no tx desc - stop sending us tx frames */
> +	if (unlikely(!cpdma_check_free_tx_desc(txch)))
> +		goto stop;
> +
> +	return ret;
> +stop:
> +	txq = netdev_get_tx_queue(priv->ndev, 0);
> +	netif_tx_stop_queue(txq);
> +
> +	/* Barrier, so that stop_queue visible to other cpus */
> +	smp_mb__after_atomic();
> +
> +	if (cpdma_check_free_tx_desc(txch))
> +		netif_tx_wake_queue(txq);
> +
> +	return ret;
> +}
> +
> +static int cpsw_run_xdp(struct cpsw_priv *priv, struct cpsw_vector *rxv,
> +			struct xdp_buff *xdp, struct page *page)
> +{
> +	struct net_device *ndev = priv->ndev;
> +	struct xdp_frame *xdpf;
> +	struct bpf_prog *prog;
> +	int ret = 1;
> +	u32 act;
> +
> +	rcu_read_lock();
> +
> +	prog = READ_ONCE(priv->xdp_prog);
> +	if (!prog) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = 0;
> +		break;
> +	case XDP_TX:
> +		xdpf = convert_to_xdp_frame(xdp);
> +		if (unlikely(!xdpf))
> +			xdp_return_buff(xdp);
> +		else
> +			cpsw_xdp_tx_frame_mapped(priv, xdpf, page);
> +		break;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(ndev, xdp, prog))
> +			xdp_return_buff(xdp);
> +		else
> +			ret = 2;
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(ndev, prog, act);
> +		/* fall through -- handle aborts by dropping packet */
> +	case XDP_DROP:
> +		xdp_return_buff(xdp);
> +		break;
> +	}
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +static unsigned int cpsw_rxbuf_total_len(unsigned int len)
> +{
> +	len += CPSW_HEADROOM;
> +	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	return SKB_DATA_ALIGN(len);
> +}
> +
> +struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw)
> +{
> +	struct page_pool_params pp_params = { 0 };
> +	struct page_pool *pool;
> +
> +	pp_params.order = 0;
> +	pp_params.flags = PP_FLAG_DMA_MAP;
> +
> +	/* set it to number of RX descriptors, but can be more */
> +	pp_params.pool_size = cpdma_get_num_rx_descs(cpsw->dma);
> +	pp_params.nid = NUMA_NO_NODE;
> +	pp_params.dma_dir = DMA_BIDIRECTIONAL;
> +	pp_params.dev = cpsw->dev;
> +
> +	pool = page_pool_create(&pp_params);
> +	if (IS_ERR(pool))
> +		dev_err(cpsw->dev, "cannot create rx page pool\n");
> +
> +	return pool;
> +}
> +
> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
> +{
> +	struct page_pool *pool = cpsw->rx_page_pool;
> +	struct page *page, *prev_page = NULL;
> +	int try = pool->p.pool_size << 2;
> +	int start_free = 0, ret;
> +
> +	do {
> +		page = page_pool_dev_alloc_pages(pool);
> +		if (!page)
> +			return NULL;
> +
> +		/* if netstack has page_pool recycling remove the rest */
> +		if (page_ref_count(page) == 1)
> +			break;
> +
> +		/* start free pages in use, shouldn't happen */
> +		if (prev_page == page || start_free) {
> +			/* dma unmap/puts page if rfcnt != 1 */
> +			page_pool_recycle_direct(pool, page);
> +			start_free = 1;
> +			continue;
> +		}
> +
> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
> +		 * so put it to the ring to be consumed later when fast cash is
s/cash/cache

> +		 * empty. If ring is full then free page by recycling as above.
> +		 */
> +		ret = ptr_ring_produce(&pool->ring, page);
> +		if (ret) {
> +			page_pool_recycle_direct(pool, page);
> +			continue;
> +		}
Although this should be fine since this part won't be called during the driver
init, i think i'd prefer unmapping the buffer and let the network stack free it,
instead of pushing it for recycling. The occurence should be pretty low, so
allocating a buffer every once in a while shouldn't have a noticeable
performance impact

> +
> +		if (!prev_page)
> +			prev_page = page;
> +	} while (try--);
> +
> +	return page;
> +}
> +
>  static int cpsw_rx_handler(void *token, int len, int status)
>  {
> -	struct cpdma_chan	*ch;
> -	struct sk_buff		*skb = token;
> -	struct sk_buff		*new_skb;
> -	struct net_device	*ndev = skb->dev;
> -	int			ret = 0, port;
> -	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
> +	struct page		*new_page, *page = token;
> +	void			*pa = page_address(page);
> +	struct cpsw_meta_xdp	*xmeta = pa + CPSW_XMETA_OFFSET;
> +	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
> +	int			pkt_size = cpsw->rx_packet_max;
> +	int			ret = 0, port, ch = xmeta->ch;
> +	struct page_pool	*pool = cpsw->rx_page_pool;
> +	int			headroom = CPSW_HEADROOM;
> +	struct net_device	*ndev = xmeta->ndev;
> +	int			flush = 0;
>  	struct cpsw_priv	*priv;
> +	struct sk_buff		*skb;
> +	struct xdp_buff		xdp;
> +	dma_addr_t		dma;
>  
>  	if (cpsw->data.dual_emac) {
>  		port = CPDMA_RX_SOURCE_PORT(status);
> -		if (port) {
> +		if (port)
>  			ndev = cpsw->slaves[--port].ndev;
> -			skb->dev = ndev;
> -		}
>  	}
>  
>  	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
> @@ -429,47 +680,101 @@ static int cpsw_rx_handler(void *token, int len, int status)
>  			 * in reducing of the number of rx descriptor in
>  			 * DMA engine, requeue skb back to cpdma.
>  			 */
> -			new_skb = skb;
> +			new_page = page;
>  			goto requeue;
>  		}
>  
>  		/* the interface is going down, skbs are purged */
> -		dev_kfree_skb_any(skb);
> +		page_pool_recycle_direct(pool, page);
>  		return 0;
>  	}
>  
> -	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
> -	if (new_skb) {
> -		skb_copy_queue_mapping(new_skb, skb);
> -		skb_put(skb, len);
> -		if (status & CPDMA_RX_VLAN_ENCAP)
> -			cpsw_rx_vlan_encap(skb);
> -		priv = netdev_priv(ndev);
> -		if (priv->rx_ts_enabled)
> -			cpts_rx_timestamp(cpsw->cpts, skb);
> -		skb->protocol = eth_type_trans(skb, ndev);
> -		netif_receive_skb(skb);
> -		ndev->stats.rx_bytes += len;
> -		ndev->stats.rx_packets++;
> -		kmemleak_not_leak(new_skb);
> -	} else {
> +	new_page = cpsw_alloc_page(cpsw);
> +	if (unlikely(!new_page)) {
> +		new_page = page;
>  		ndev->stats.rx_dropped++;
> -		new_skb = skb;
> +		goto requeue;
>  	}
>  
> +	priv = netdev_priv(ndev);
> +	if (priv->xdp_prog) {
> +		if (status & CPDMA_RX_VLAN_ENCAP) {
> +			xdp.data = (void *)pa + CPSW_HEADROOM +
> +				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +			xdp.data_end = xdp.data + len -
> +				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +		} else {
> +			xdp.data = (void *)pa + CPSW_HEADROOM;
> +			xdp.data_end = xdp.data + len;
> +		}
> +
> +		xdp_set_data_meta_invalid(&xdp);
> +
> +		xdp.data_hard_start = pa;
> +		xdp.rxq = &priv->xdp_rxq[ch];
> +
> +		ret = cpsw_run_xdp(priv, &cpsw->rxv[ch], &xdp, page);
> +		if (ret) {
> +			if (ret == 2)
> +				flush = 1;
> +
> +			goto requeue;
> +		}
> +
> +		/* XDP prog might have changed packet data and boundaries */
> +		len = xdp.data_end - xdp.data;
> +		headroom = xdp.data - xdp.data_hard_start;
> +	}
> +
> +	/* Build skb and pass it to netstack if XDP off or XDP prog
> +	 * returned XDP_PASS
> +	 */
> +	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
> +	if (!skb) {
> +		ndev->stats.rx_dropped++;
> +		page_pool_recycle_direct(pool, page);
> +		goto requeue;
> +	}
> +
> +	skb_reserve(skb, headroom);
> +	skb_put(skb, len);
> +	skb->dev = ndev;
> +	if (status & CPDMA_RX_VLAN_ENCAP)
> +		cpsw_rx_vlan_encap(skb);
> +	if (priv->rx_ts_enabled)
> +		cpts_rx_timestamp(cpsw->cpts, skb);
> +	skb->protocol = eth_type_trans(skb, ndev);
> +
> +	/* recycle page before increasing refcounter, it allows to hold page in
> +	 * page pool cache improving allocation time, see cpsw_alloc_page().
> +	 */
> +	page_pool_recycle_direct(pool, page);
> +
> +	/* remove once ordinary netstack has page_pool recycling */
> +	page_ref_inc(page);
> +
> +	netif_receive_skb(skb);
> +
> +	ndev->stats.rx_bytes += len;
> +	ndev->stats.rx_packets++;
> +
>  requeue:
>  	if (netif_dormant(ndev)) {
> -		dev_kfree_skb_any(new_skb);
> -		return 0;
> +		page_pool_recycle_direct(pool, new_page);
> +		return flush;
>  	}
>  
> -	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
> -	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
> -				skb_tailroom(new_skb), 0);
> +	xmeta = page_address(new_page) + CPSW_XMETA_OFFSET;
> +	xmeta->ndev = ndev;
> +	xmeta->ch = ch;
> +
> +	dma = new_page->dma_addr + CPSW_HEADROOM;
> +	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
> +				       pkt_size, 0);
>  	if (WARN_ON(ret < 0))
> -		dev_kfree_skb_any(new_skb);
> +		page_pool_recycle_direct(pool, new_page);
>  
> -	return 0;
> +	return flush;
>  }
>  
>  void cpsw_split_res(struct cpsw_common *cpsw)
> @@ -644,7 +949,7 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
>  static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>  {
>  	u32			ch_map;
> -	int			num_rx, cur_budget, ch;
> +	int			num_rx, cur_budget, ch, flush;
>  	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
>  	struct cpsw_vector	*rxv;
>  
> @@ -660,8 +965,12 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>  		else
>  			cur_budget = rxv->budget;
>  
> -		cpdma_chan_process(rxv->ch, &cur_budget);
> +		flush = cpdma_chan_process(rxv->ch, &cur_budget);
>  		num_rx += cur_budget;
> +
> +		if (flush)
> +			xdp_do_flush_map();
> +
>  		if (num_rx >= budget)
>  			break;
>  	}
> @@ -677,10 +986,15 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>  static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
>  {
>  	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
> -	int num_rx;
> +	struct cpsw_vector *rxv;
> +	int num_rx, flush;
>  
>  	num_rx = budget;
> -	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
> +	rxv = &cpsw->rxv[0];
> +	flush = cpdma_chan_process(rxv->ch, &num_rx);
> +	if (flush)
> +		xdp_do_flush_map();
> +
>  	if (num_rx < budget) {
>  		napi_complete_done(napi_rx, num_rx);
>  		writel(0xff, &cpsw->wr_regs->rx_en);
> @@ -1042,33 +1356,38 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
>  int cpsw_fill_rx_channels(struct cpsw_priv *priv)
>  {
>  	struct cpsw_common *cpsw = priv->cpsw;
> -	struct sk_buff *skb;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct page_pool *pool;
> +	struct page *page;
>  	int ch_buf_num;
>  	int ch, i, ret;
> +	dma_addr_t dma;
>  
> +	pool = cpsw->rx_page_pool;
>  	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
>  		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
>  		for (i = 0; i < ch_buf_num; i++) {
> -			skb = __netdev_alloc_skb_ip_align(priv->ndev,
> -							  cpsw->rx_packet_max,
> -							  GFP_KERNEL);
> -			if (!skb) {
> -				cpsw_err(priv, ifup, "cannot allocate skb\n");
> +			page = cpsw_alloc_page(cpsw);
> +			if (!page) {
> +				cpsw_err(priv, ifup, "allocate rx page err\n");
>  				return -ENOMEM;
>  			}
>  
> -			skb_set_queue_mapping(skb, ch);
> -			ret = cpdma_chan_submit(cpsw->rxv[ch].ch, skb,
> -						skb->data, skb_tailroom(skb),
> -						0);
> +			xmeta = page_address(page) + CPSW_XMETA_OFFSET;
> +			xmeta->ndev = priv->ndev;
> +			xmeta->ch = ch;
> +
> +			dma = page->dma_addr + CPSW_HEADROOM;
> +			ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, page,
> +						       dma, cpsw->rx_packet_max,
> +						       0);
>  			if (ret < 0) {
>  				cpsw_err(priv, ifup,
>  					 "cannot submit skb to channel %d rx, error %d\n",
>  					 ch, ret);
> -				kfree_skb(skb);
> +				page_pool_recycle_direct(pool, page);
>  				return ret;
>  			}
> -			kmemleak_not_leak(skb);
>  		}
>  
>  		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
> @@ -2011,6 +2330,64 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  	}
>  }
>  
> +static int cpsw_xdp_prog_setup(struct cpsw_priv *priv, struct netdev_bpf *bpf)
> +{
> +	struct bpf_prog *prog = bpf->prog;
> +
> +	if (!priv->xdpi.prog && !prog)
> +		return 0;
> +
> +	if (!xdp_attachment_flags_ok(&priv->xdpi, bpf))
> +		return -EBUSY;
> +
> +	WRITE_ONCE(priv->xdp_prog, prog);
> +
> +	xdp_attachment_setup(&priv->xdpi, bpf);
> +
> +	return 0;
> +}
> +
> +static int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return cpsw_xdp_prog_setup(priv, bpf);
> +
> +	case XDP_QUERY_PROG:
> +		return xdp_attachment_query(&priv->xdpi, bpf);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
> +			     struct xdp_frame **frames, u32 flags)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	struct xdp_frame *xdpf;
> +	int i, drops = 0;
> +
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +		return -EINVAL;
> +
> +	for (i = 0; i < n; i++) {
> +		xdpf = frames[i];
> +		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			drops++;
> +			continue;
> +		}
> +
> +		if (cpsw_xdp_tx_frame(priv, xdpf))
> +			drops++;
> +	}
> +
> +	return n - drops;
> +}
> +
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  static void cpsw_ndo_poll_controller(struct net_device *ndev)
>  {
> @@ -2039,6 +2416,8 @@ static const struct net_device_ops cpsw_netdev_ops = {
>  	.ndo_vlan_rx_add_vid	= cpsw_ndo_vlan_rx_add_vid,
>  	.ndo_vlan_rx_kill_vid	= cpsw_ndo_vlan_rx_kill_vid,
>  	.ndo_setup_tc           = cpsw_ndo_setup_tc,
> +	.ndo_bpf		= cpsw_ndo_bpf,
> +	.ndo_xdp_xmit		= cpsw_ndo_xdp_xmit,
>  };
>  
>  static void cpsw_get_drvinfo(struct net_device *ndev,
> @@ -2335,11 +2714,24 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
>  	ndev->netdev_ops = &cpsw_netdev_ops;
>  	ndev->ethtool_ops = &cpsw_ethtool_ops;
>  
> +	ret = xdp_rxq_info_reg(priv_sl2->xdp_rxq, ndev, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = xdp_rxq_info_reg_mem_model(priv_sl2->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 cpsw->rx_page_pool);
> +	if (ret) {
> +		xdp_rxq_info_unreg(priv_sl2->xdp_rxq);
> +		return ret;
> +	}
> +
>  	/* register the network device */
>  	SET_NETDEV_DEV(ndev, cpsw->dev);
>  	ret = register_netdev(ndev);
> -	if (ret)
> +	if (ret) {
>  		dev_err(cpsw->dev, "cpsw: error registering net device\n");
> +		xdp_rxq_info_unreg(priv_sl2->xdp_rxq);
> +	}
>  
>  	return ret;
>  }
> @@ -2457,19 +2849,25 @@ static int cpsw_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto clean_dt_ret;
>  
> +	cpsw->rx_page_pool = cpsw_create_rx_pool(cpsw);
> +	if (IS_ERR(cpsw->rx_page_pool)) {
> +		ret = PTR_ERR(cpsw->rx_page_pool);
> +		goto clean_cpts;
> +	}
> +
>  	ch = cpsw->quirk_irq ? 0 : 7;
>  	cpsw->txv[0].ch = cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
>  	if (IS_ERR(cpsw->txv[0].ch)) {
>  		dev_err(dev, "error initializing tx dma channel\n");
>  		ret = PTR_ERR(cpsw->txv[0].ch);
> -		goto clean_cpts;
> +		goto clean_pool;
>  	}
>  
>  	cpsw->rxv[0].ch = cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
>  	if (IS_ERR(cpsw->rxv[0].ch)) {
>  		dev_err(dev, "error initializing rx dma channel\n");
>  		ret = PTR_ERR(cpsw->rxv[0].ch);
> -		goto clean_cpts;
> +		goto clean_pool;
>  	}
>  	cpsw_split_res(cpsw);
>  
> @@ -2478,7 +2876,7 @@ static int cpsw_probe(struct platform_device *pdev)
>  				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
>  	if (!ndev) {
>  		dev_err(dev, "error allocating net_device\n");
> -		goto clean_cpts;
> +		goto clean_pool;
>  	}
>  
>  	platform_set_drvdata(pdev, ndev);
> @@ -2499,6 +2897,15 @@ static int cpsw_probe(struct platform_device *pdev)
>  
>  	memcpy(ndev->dev_addr, priv->mac_addr, ETH_ALEN);
>  
> +	ret = xdp_rxq_info_reg(priv->xdp_rxq, ndev, 0);
> +	if (ret)
> +		goto clean_pool;
> +
> +	ret = xdp_rxq_info_reg_mem_model(priv->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 cpsw->rx_page_pool);
> +	if (ret)
> +		goto clean_rxq_info;
> +
>  	cpsw->slaves[0].ndev = ndev;
>  
>  	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
> @@ -2518,7 +2925,7 @@ static int cpsw_probe(struct platform_device *pdev)
>  	if (ret) {
>  		dev_err(dev, "error registering net device\n");
>  		ret = -ENODEV;
> -		goto clean_cpts;
> +		goto clean_rxq_info;
>  	}
>  
>  	if (cpsw->data.dual_emac) {
> @@ -2561,6 +2968,10 @@ static int cpsw_probe(struct platform_device *pdev)
>  
>  clean_unregister_netdev_ret:
>  	unregister_netdev(ndev);
> +clean_rxq_info:
> +	xdp_rxq_info_unreg(priv->xdp_rxq);
> +clean_pool:
> +	page_pool_destroy(cpsw->rx_page_pool);
>  clean_cpts:
>  	cpts_release(cpsw->cpts);
>  	cpdma_ctlr_destroy(cpsw->dma);
> @@ -2572,11 +2983,26 @@ static int cpsw_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> +void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch)
> +{
> +	struct cpsw_slave *slave;
> +	struct cpsw_priv *priv;
> +	int i;
> +
> +	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> +		if (!slave->ndev)
> +			continue;
> +
> +		priv = netdev_priv(slave->ndev);
> +		xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
> +	}
> +}
> +
>  static int cpsw_remove(struct platform_device *pdev)
>  {
>  	struct net_device *ndev = platform_get_drvdata(pdev);
>  	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
> -	int ret;
> +	int i, ret;
>  
>  	ret = pm_runtime_get_sync(&pdev->dev);
>  	if (ret < 0) {
> @@ -2590,6 +3016,11 @@ static int cpsw_remove(struct platform_device *pdev)
>  
>  	cpts_release(cpsw->cpts);
>  	cpdma_ctlr_destroy(cpsw->dma);
> +
> +	for (i = 0; i < cpsw->rx_ch_num; i++)
> +		cpsw_xdp_rxq_unreg(cpsw, i);
> +
> +	page_pool_destroy(cpsw->rx_page_pool);
>  	cpsw_remove_dt(pdev);
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index 0c08ec91635a..dbe4bc5513c6 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -14,6 +14,7 @@
>  #include <linux/phy.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/skbuff.h>
> +#include <net/page_pool.h>
>  
>  #include "cpsw.h"
>  #include "cpts.h"
> @@ -531,6 +532,42 @@ static int cpsw_check_ch_settings(struct cpsw_common *cpsw,
>  	return 0;
>  }
>  
> +static int cpsw_xdp_rxq_reg(struct cpsw_common *cpsw, int ch)
> +{
> +	struct cpsw_slave *slave;
> +	struct cpsw_priv *priv;
> +	int i, ret;
> +
> +	/* As channels are common for both ports sharing same queues, xdp_rxq
> +	 * information also becomes shared and used by every packet on this
> +	 * channel. But exch xdp_rxq holds link on netdev, which by the theory
> +	 * can have different memory model and so, network device must hold it's
> +	 * own set of rxq and thus both netdevs should be prepared
> +	 */
> +	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> +		if (!slave->ndev)
> +			continue;
> +
> +		priv = netdev_priv(slave->ndev);
> +
> +		ret = xdp_rxq_info_reg(&priv->xdp_rxq[ch], priv->ndev, ch);
> +		if (ret)
> +			goto err;
> +
> +		ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[ch],
> +						 MEM_TYPE_PAGE_POOL,
> +						 cpsw->rx_page_pool);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return ret;
> +
> +err:
> +	cpsw_xdp_rxq_unreg(cpsw, ch);
> +	return ret;
> +}
> +
>  static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
>  				    cpdma_handler_fn rx_handler)
>  {
> @@ -562,6 +599,11 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
>  		if (!vec[*ch].ch)
>  			return -EINVAL;
>  
> +		if (rx && cpsw_xdp_rxq_reg(cpsw, *ch)) {
> +			cpdma_chan_destroy(vec[*ch].ch);
> +			return -EINVAL;
> +		}
> +
>  		cpsw_info(priv, ifup, "created new %d %s channel\n", *ch,
>  			  (rx ? "rx" : "tx"));
>  		(*ch)++;
> @@ -570,6 +612,9 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
>  	while (*ch > ch_num) {
>  		(*ch)--;
>  
> +		if (rx)
> +			cpsw_xdp_rxq_unreg(cpsw, *ch);
> +
>  		ret = cpdma_chan_destroy(vec[*ch].ch);
>  		if (ret)
>  			return ret;
> @@ -654,6 +699,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
>  {
>  	struct cpsw_priv *priv = netdev_priv(ndev);
>  	struct cpsw_common *cpsw = priv->cpsw;
> +	struct page_pool *pool;
>  	int ret;
>  
>  	/* ignore ering->tx_pending - only rx_pending adjustment is supported */
> @@ -666,6 +712,10 @@ int cpsw_set_ringparam(struct net_device *ndev,
>  	if (ering->rx_pending == cpdma_get_num_rx_descs(cpsw->dma))
>  		return 0;
>  
> +	pool = cpsw_create_rx_pool(cpsw);
> +	if (IS_ERR(pool))
> +		return PTR_ERR(pool);
> +
>  	cpsw_suspend_data_pass(ndev);
>  
>  	cpdma_set_num_rx_descs(cpsw->dma, ering->rx_pending);
> @@ -673,6 +723,9 @@ int cpsw_set_ringparam(struct net_device *ndev,
>  	if (cpsw->usage_count)
>  		cpdma_chan_split_pool(cpsw->dma);
>  
> +	page_pool_destroy(cpsw->rx_page_pool);
> +	cpsw->rx_page_pool = pool;
> +
>  	ret = cpsw_resume_data_pass(ndev);
>  	if (!ret)
>  		return 0;
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
> index 2ecb3af59fe9..884ce6343a7d 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.h
> +++ b/drivers/net/ethernet/ti/cpsw_priv.h
> @@ -346,6 +346,7 @@ struct cpsw_common {
>  	int				rx_ch_num, tx_ch_num;
>  	int				speed;
>  	int				usage_count;
> +	struct page_pool		*rx_page_pool;
>  };
>  
>  struct cpsw_priv {
> @@ -360,6 +361,10 @@ struct cpsw_priv {
>  	int				shp_cfg_speed;
>  	int				tx_ts_enabled;
>  	int				rx_ts_enabled;
> +	struct bpf_prog			*xdp_prog;
> +	struct xdp_rxq_info		xdp_rxq[CPSW_MAX_QUEUES];
> +	struct xdp_attachment_info	xdpi;
> +
>  	u32 emac_port;
>  	struct cpsw_common *cpsw;
>  };
> @@ -391,6 +396,8 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv);
>  void cpsw_intr_enable(struct cpsw_common *cpsw);
>  void cpsw_intr_disable(struct cpsw_common *cpsw);
>  int cpsw_tx_handler(void *token, int len, int status);
> +void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch);
> +struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw);
>  
>  /* ethtool */
>  u32 cpsw_get_msglevel(struct net_device *ndev);
> -- 
> 2.17.1
> 
