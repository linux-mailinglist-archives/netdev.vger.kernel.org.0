Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B042461A50
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbhK2Oxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:53:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345713AbhK2OvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:51:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E929F6155F;
        Mon, 29 Nov 2021 14:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD3C004E1;
        Mon, 29 Nov 2021 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638197277;
        bh=CoopZV0b/bKiDlV+HhvUfNkMdjiGJvIMlADMRIGNB4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYabvzP1gx9omCtgDIauPYZdStR3jR6UpWkgTE6hmLhH4cRWrQHf6TxS28YeH+RKr
         SRcur0lcx5xMeZ+8gBonuXpPN+wFYA1Lnq5+OdnzLkc8KNVKvQ8FTjiUENH4dADxoG
         /CQRR1zslN7soB04e2Atkf4XOvb5euaKzwtxmB7CrfEi+/pw8J501IDFdgTQfoX+qh
         aU4MOGaSBGWP/0MNcgDm38CsdUb3iakU5Lv602Tqilqvw1F59jAhtD4rzXmCOi1oyk
         ChqJVkhxVGeMImLerX7GfVKOyFo1URKOnTAfJ/U54kUQVPz3vbu3h0tj4JGlrxsuaC
         gexT8LLb6/BNw==
Date:   Mon, 29 Nov 2021 06:47:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
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
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
        virtualization@lists.linux-foundation.org, petrm@nvidia.com,
        nikolay@nvidia.com
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <20211129064755.539099c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaPCbaMVaVlxXcHC@shredder>
References: <20211123163955.154512-22-alexandr.lobakin@intel.com>
        <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
        <87bl28bga6.fsf@toke.dk>
        <20211125170708.127323-1-alexandr.lobakin@intel.com>
        <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125204007.133064-1-alexandr.lobakin@intel.com>
        <87sfvj9k13.fsf@toke.dk>
        <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87ee72ah56.fsf@toke.dk>
        <20211126111431.4a2ed007@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaPCbaMVaVlxXcHC@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Nov 2021 19:54:53 +0200 Ido Schimmel wrote:
> > > Right, sure, I am also totally fine with having only a somewhat
> > > restricted subset of stats available at the interface level and make
> > > everything else be BPF-based. I'm hoping we can converge of a common
> > > understanding of what this "minimal set" should be :)
> > > 
> > > Agreed. My immediate thought is that "XDP packets are interface packets"
> > > but that is certainly not what we do today, so not sure if changing it
> > > at this point would break things?  
> > 
> > I'd vote for taking the risk and trying to align all the drivers.  
> 
> I agree. I think IFLA_STATS64 in RTM_NEWLINK should contain statistics
> of all the packets seen by the netdev. The breakdown into software /
> hardware / XDP should be reported via RTM_NEWSTATS.

Hm, in the offload case "seen by the netdev" may be unclear. For 
the offload case I believe our recommendation was phrased more like 
"all packets which would be seen by the netdev if there was no
routing/tc offload", right?

> Currently, for soft devices such as VLANs, bridges and GRE, user space
> only sees statistics of packets forwarded by software, which is quite
> useless when forwarding is offloaded from the kernel to hardware.
> 
> Petr is working on exposing hardware statistics for such devices via
> rtnetlink. Unlike XDP (?), we need to be able to let user space enable /
> disable hardware statistics as we have a limited number of hardware
> counters and they can also reduce the bandwidth when enabled. We are
> thinking of adding a new RTM_SETSTATS for that:
> 
> # ip stats set dev swp1 hw_stats on

Does it belong on the switch port? Not the netdev we want to track?

> For query, something like (under discussion):
> 
> # ip stats show dev swp1 // all groups
> # ip stats show dev swp1 group link
> # ip stats show dev swp1 group offload // all sub-groups
> # ip stats show dev swp1 group offload sub-group cpu
> # ip stats show dev swp1 group offload sub-group hw
> 
> Like other iproute2 commands, these follow the nesting of the
> RTM_{NEW,GET}STATS uAPI.

But we do have IFLA_STATS_LINK_OFFLOAD_XSTATS, isn't it effectively 
the same use case?

> Looking at patch #1 [1], I think that whatever you decide to expose for
> XDP can be queried via:
> 
> # ip stats show dev swp1 group xdp
> # ip stats show dev swp1 group xdp sub-group regular
> # ip stats show dev swp1 group xdp sub-group xsk
> 
> Regardless, the following command should show statistics of all the
> packets seen by the netdev:
> 
> # ip -s link show dev swp1
> 
> There is a PR [2] for node_exporter to use rtnetlink to fetch netdev
> statistics instead of the old proc interface. It should be possible to
> extend it to use RTM_*STATS for more fine-grained statistics.
> 
> [1] https://lore.kernel.org/netdev/20211123163955.154512-2-alexandr.lobakin@intel.com/
> [2] https://github.com/prometheus/node_exporter/pull/2074

Nice!
