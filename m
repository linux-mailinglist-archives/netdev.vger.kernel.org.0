Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FAC37FD39
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 20:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhEMS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEMS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 14:27:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB12C061574;
        Thu, 13 May 2021 11:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6mLn4KuZkGwmj8EyTRAdkwrTMuYQZu+zTcF+KB+C+6w=; b=zP+VI5n5VLaL7a2YAmNQaQ6Q/
        h9hC1O6YFU2S+rN8VBJ2dPGExrHr8kpgRUflliOrfgUAKVcryjZvqF0bzzNd4e4f1kFlIPWGMSFKU
        GGwzvaic1hAUBWiMdzcCruB1beWt9v0WUBMupX1t8I3gpX0kccy2AopS9sjdwkWAMy/kWtshR+254
        cD/qQatXHF6hYt0YaLMK8ic+AHf2YrYqmu6y0N90L7ohecaWcYu74WEfrR7jRl6iCuyPc6jflAdSQ
        ujidyExsMhj8G1ls7LdIVNCy1mzto0Q4csgRAEixsy7qnouGzBVobEB16LRiTAVVT4dAjtHjN48Yt
        3KpG3hXmQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43948)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhG20-0006cx-RA; Thu, 13 May 2021 19:25:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhG1y-0003FE-Kv; Thu, 13 May 2021 19:25:54 +0100
Date:   Thu, 13 May 2021 19:25:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v5 5/5] mvneta: recycle buffers
Message-ID: <20210513182554.GB12395@shell.armlinux.org.uk>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-6-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513165846.23722-6-mcroce@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 06:58:46PM +0200, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Use the new recycling API for page_pool.
> In a drop rate test, the packet rate increased di 10%,

Typo - "by" ?

> from 269 Kpps to 296 Kpps.
> 
> perf top on a stock system shows:
> 
> Overhead  Shared Object     Symbol
>   21.78%  [kernel]          [k] __pi___inval_dcache_area
>   21.66%  [mvneta]          [k] mvneta_rx_swbm
>    7.00%  [kernel]          [k] kmem_cache_alloc
>    6.05%  [kernel]          [k] eth_type_trans
>    4.44%  [kernel]          [k] kmem_cache_free.part.0
>    3.80%  [kernel]          [k] __netif_receive_skb_core
>    3.68%  [kernel]          [k] dev_gro_receive
>    3.65%  [kernel]          [k] get_page_from_freelist
>    3.43%  [kernel]          [k] page_pool_release_page
>    3.35%  [kernel]          [k] free_unref_page
> 
> And this is the same output with recycling enabled:
> 
> Overhead  Shared Object     Symbol
>   24.10%  [kernel]          [k] __pi___inval_dcache_area
>   23.02%  [mvneta]          [k] mvneta_rx_swbm
>    7.19%  [kernel]          [k] kmem_cache_alloc
>    6.50%  [kernel]          [k] eth_type_trans
>    4.93%  [kernel]          [k] __netif_receive_skb_core
>    4.77%  [kernel]          [k] kmem_cache_free.part.0
>    3.93%  [kernel]          [k] dev_gro_receive
>    3.03%  [kernel]          [k] build_skb
>    2.91%  [kernel]          [k] page_pool_put_page
>    2.85%  [kernel]          [k] __xdp_return
> 
> The test was done with mausezahn on the TX side with 64 byte raw
> ethernet frames.
> 
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>

Other than the typo, I have no objection to the patch.

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 7d5cd9bc6c99..6d2f8dce4900 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2320,7 +2320,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  }
>  
>  static struct sk_buff *
> -mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> +mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
>  	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> @@ -2331,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  	if (!skb)
>  		return ERR_PTR(-ENOMEM);
>  
> -	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> +	skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
>  
>  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  	skb_put(skb, xdp->data_end - xdp->data);
> @@ -2343,7 +2343,10 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>  				skb_frag_page(frag), skb_frag_off(frag),
>  				skb_frag_size(frag), PAGE_SIZE);
> -		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
> +		/* We don't need to reset pp_recycle here. It's already set, so
> +		 * just mark fragments for recycling.
> +		 */
> +		page_pool_store_mem_info(skb_frag_page(frag), pool);
>  	}
>  
>  	return skb;
> @@ -2425,7 +2428,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
>  			goto next;
>  
> -		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
> +		skb = mvneta_swbm_build_skb(pp, pp, &xdp_buf, desc_status);
>  		if (IS_ERR(skb)) {
>  			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
>  
> -- 
> 2.31.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
