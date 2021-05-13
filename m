Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D174D37FD2C
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEMSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 14:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEMSWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 14:22:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F081C061574;
        Thu, 13 May 2021 11:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6uuUzWl9VoRjV4bYv78VUB4CdgmlKH2pNJlIUhKulm8=; b=NXExP0SppRPIfcFl8xuZPZ/8q
        hwe9BNAHh1LWQyN8f0WG69abeL20BRHNjHdIWBAjV562Qz8kygXokRSvmaIxpdQpF04UxzIgbhBpV
        B5p1PSXFWaqwaP5yH3k0LOOVEvLH+nxjQEY/xus4sZ8FKQkm4jpcMJeNLulqReZ4HYDNdR0KF2hzt
        1CBVDHmCo5F246dT7ExCUYhyYq8lWeBWGm12AJNvpE7JHDHKxqrygJ01jdF99yF1qGvkNcL76dtN7
        Ns+FC/97V1uJuX4o159qH2rJMbhddBqoxIu5AJnL/zBFfnWz/2CeM0vrrZ4AnpO6SYI1Zfmujx//g
        nc9kMlz+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43946)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhFxE-0006az-P5; Thu, 13 May 2021 19:21:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhFx2-0003ED-8H; Thu, 13 May 2021 19:20:48 +0100
Date:   Thu, 13 May 2021 19:20:48 +0100
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
Subject: Re: [PATCH net-next v5 4/5] mvpp2: recycle buffers
Message-ID: <20210513182048.GA12395@shell.armlinux.org.uk>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-5-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513165846.23722-5-mcroce@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 06:58:45PM +0200, Matteo Croce wrote:
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index b2259bf1d299..9dceabece56c 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3847,6 +3847,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  	struct mvpp2_pcpu_stats ps = {};
>  	enum dma_data_direction dma_dir;
>  	struct bpf_prog *xdp_prog;
> +	struct xdp_rxq_info *rxqi;
>  	struct xdp_buff xdp;
>  	int rx_received;
>  	int rx_done = 0;
> @@ -3912,15 +3913,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		else
>  			frag_size = bm_pool->frag_size;
>  
> +		if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
> +			rxqi = &rxq->xdp_rxq_short;
> +		else
> +			rxqi = &rxq->xdp_rxq_long;
>  
> +		if (xdp_prog) {
> +			xdp.rxq = rxqi;
>  
> +			xdp_init_buff(&xdp, PAGE_SIZE, rxqi);
>  			xdp_prepare_buff(&xdp, data,
>  					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
>  					 rx_bytes, false);
> @@ -3964,7 +3965,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		}
>  
>  		if (pp)
> +			skb_mark_for_recycle(skb, virt_to_page(data), pp);
>  		else
>  			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
>  					       bm_pool->buf_size, DMA_FROM_DEVICE,

Looking at the above, which I've only quoted the _resulting_ code after
your patch above, I don't see why you have moved the
"bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE" conditional outside of
the test for xdp_prog - I don't see rxqi being used except within that
conditional. Please can you explain the reasoning there?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
