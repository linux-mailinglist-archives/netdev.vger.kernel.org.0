Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D936445B94D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbhKXLmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhKXLmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:42:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B00C061574;
        Wed, 24 Nov 2021 03:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vQDl3mdmA1En5CvP0uWx5PMM4Duf3hQWi+uoJkI1zBo=; b=gDBlttai/MvnO2Jnc8JXk3q8LQ
        rMO0EWrsuGJEhyWFh5BXTWwmCWoOddFvvXm/uA/gQq9hSsOZ1o9D+VPqSXvEAV9jEOeeK6xOQoAfx
        tjfKXRUCykdrVvQQOebb36UhhDBYbcR8GTzFWcOIwXnv56/7hCrLbe4ahkw03/fU/vp1NS94IDB8L
        9xTMR6VRrUC76UcPFITy0RureR/fRfYGDWGiSXDL3f/b0al0+xtoCK+Kslp3o0A1xc55vkSBV2TTs
        7tYaSdyUq+Qtf3tCvsLcPvb7bHQ/QleMz8BihlcLg5ntxmbTrf8H+huZ+XlO1zgQsHJGqfEvu71Rw
        a6VGqrLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55846)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpqcF-0000YR-B8; Wed, 24 Nov 2021 11:39:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpqcD-00019y-KO; Wed, 24 Nov 2021 11:39:05 +0000
Date:   Wed, 24 Nov 2021 11:39:05 +0000
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
Subject: Re: [PATCH v2 net-next 07/26] mvneta: add .ndo_get_xdp_stats()
 callback
Message-ID: <YZ4kWXnqZQhSu+mw@shell.armlinux.org.uk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-8-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123163955.154512-8-alexandr.lobakin@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 05:39:36PM +0100, Alexander Lobakin wrote:
> +	for_each_possible_cpu(cpu) {
> +		const struct mvneta_pcpu_stats *stats;
> +		const struct mvneta_stats *ps;
> +		u64 xdp_xmit_err;
> +		u64 xdp_redirect;
> +		u64 xdp_tx_err;
> +		u64 xdp_pass;
> +		u64 xdp_drop;
> +		u64 xdp_xmit;
> +		u64 xdp_tx;
> +		u32 start;
> +
> +		stats = per_cpu_ptr(pp->stats, cpu);
> +		ps = &stats->es.ps;
> +
> +		do {
> +			start = u64_stats_fetch_begin_irq(&stats->syncp);
> +
> +			xdp_drop = ps->xdp_drop;
> +			xdp_pass = ps->xdp_pass;
> +			xdp_redirect = ps->xdp_redirect;
> +			xdp_tx = ps->xdp_tx;
> +			xdp_tx_err = ps->xdp_tx_err;
> +			xdp_xmit = ps->xdp_xmit;
> +			xdp_xmit_err = ps->xdp_xmit_err;
> +		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> +
> +		xdp_stats->drop += xdp_drop;
> +		xdp_stats->pass += xdp_pass;
> +		xdp_stats->redirect += xdp_redirect;
> +		xdp_stats->tx += xdp_tx;
> +		xdp_stats->tx_errors += xdp_tx_err;
> +		xdp_stats->xmit_packets += xdp_xmit;
> +		xdp_stats->xmit_errors += xdp_xmit_err;

Same comment as for mvpp2 - this could share a lot of code from
mvneta_ethtool_update_pcpu_stats() (although it means we end up
calculating a little more for the alloc error and refill error
that this API doesn't need) but I think sharing that code would be
a good idea.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
