Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354E045B92E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbhKXLkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhKXLkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:40:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0023C061574;
        Wed, 24 Nov 2021 03:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G9r7x0IMWPmEtkjUXiisRloX817MmWgYVCedn25iGv8=; b=w/wR+72JeuJ57uMWc+lEqLMRIN
        QqwfVuwY9Q2LY/2s/5Q34+re64hnCOaW7M7+7kgu0rkRM1Hy6eMyeIo801dnOunA5LH/f0jXpMPAQ
        dE5JOy5oGnVGLU4JzTxkBbkMY20uqu4ITG1UDhKkz4izGMecdwP6hjT3JAg71aZNVAQZ7y+Ve6ZJp
        i7VVrGTfz7W64gZ/Ywth3o/9VV+6vio3gXON/V8GmJxalH5+rOp2YHKJHFixiovh6KkPPbSbr5ZG9
        ++LhT0b9FxGioRWnvIPQnLTejOTvQ4E6mHQgmZ81LbPBrcVaszP5U6YoytWP+damJDcQs4pYGckJj
        dQps1lFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55844)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpqZa-0000Xd-4o; Wed, 24 Nov 2021 11:36:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpqZY-00019p-3W; Wed, 24 Nov 2021 11:36:20 +0000
Date:   Wed, 24 Nov 2021 11:36:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 08/26] mvpp2: provide .ndo_get_xdp_stats()
 callback
Message-ID: <YZ4jtImZvOVihtv1@shell.armlinux.org.uk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-9-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123163955.154512-9-alexandr.lobakin@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 05:39:37PM +0100, Alexander Lobakin wrote:
> Same as mvneta, mvpp2 stores 7 XDP counters in per-cpu containers.
> Expose them via generic XDP stats infra.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 97bd2ee8a010..58203cde3b60 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5131,6 +5131,56 @@ mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
>  	stats->tx_dropped	= dev->stats.tx_dropped;
>  }
> 
> +static int mvpp2_get_xdp_stats_ndo(const struct net_device *dev, u32 attr_id,
> +				   void *attr_data)
> +{
> +	const struct mvpp2_port *port = netdev_priv(dev);
> +	struct ifla_xdp_stats *xdp_stats = attr_data;
> +	u32 cpu, start;
> +
> +	switch (attr_id) {
> +	case IFLA_XDP_XSTATS_TYPE_XDP:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	for_each_possible_cpu(cpu) {
> +		const struct mvpp2_pcpu_stats *ps;
> +		u64 xdp_xmit_err;
> +		u64 xdp_redirect;
> +		u64 xdp_tx_err;
> +		u64 xdp_pass;
> +		u64 xdp_drop;
> +		u64 xdp_xmit;
> +		u64 xdp_tx;
> +
> +		ps = per_cpu_ptr(port->stats, cpu);
> +
> +		do {
> +			start = u64_stats_fetch_begin_irq(&ps->syncp);
> +
> +			xdp_redirect = ps->xdp_redirect;
> +			xdp_pass = ps->xdp_pass;
> +			xdp_drop = ps->xdp_drop;
> +			xdp_xmit = ps->xdp_xmit;
> +			xdp_xmit_err = ps->xdp_xmit_err;
> +			xdp_tx = ps->xdp_tx;
> +			xdp_tx_err = ps->xdp_tx_err;
> +		} while (u64_stats_fetch_retry_irq(&ps->syncp, start));
> +
> +		xdp_stats->redirect += xdp_redirect;
> +		xdp_stats->pass += xdp_pass;
> +		xdp_stats->drop += xdp_drop;
> +		xdp_stats->xmit_packets += xdp_xmit;
> +		xdp_stats->xmit_errors += xdp_xmit_err;
> +		xdp_stats->tx += xdp_tx;
> +		xdp_stats->tx_errors  += xdp_tx_err;
> +	}

Actually, the only concern I have here is the duplication between this
function and mvpp2_get_xdp_stats(). It looks to me like these two
functions could share a lot of their code. Please submit a patch to
make that happen. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
