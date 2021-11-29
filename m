Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551FC461B85
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 17:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbhK2QK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 11:10:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhK2QIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 11:08:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B26CB811F5;
        Mon, 29 Nov 2021 16:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F363C53FAD;
        Mon, 29 Nov 2021 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638201905;
        bh=4N87j1xF0qZOK6vkTN+k9+VLDwxHQq/Q1A1VR38B4AQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYd722QiYpC36Bf6Q9uJFPlKPCw4bp52LuJo88+FRlqHBDPZiJV2xxZjo5MUc2moR
         hNcG5kc9SZg08L6NdNQ0reOmJIK1mIvsFygISYhUiJ6MF9siH9EUqUOj7eLQsFWlvc
         73QsXWTh7LmGU+fDc5lAIFUsUpf+NXCnpB4qQASFhFOqBauVjGuzAs991gYajYQElr
         ng6WG+dmtohCxSRwl0esJqyoAD4Ye6lAZMKHbWz1JP10FvCcHktWdX+dRAK2TARvCP
         ek5C6JqhSLqcO9P9xiKcnXSQiLy6RbxYR9QImV2JZIjuBM/KXbDM66Sto0EIB70cHi
         6KEDTLA4Ptsfg==
Date:   Mon, 29 Nov 2021 08:05:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Shay Agroskin" <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David Arinzon" <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        "Saeed Bishara" <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
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
        "Martin Habets" <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <nikolay@nvidia.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <20211129080502.53f7d316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <874k7vq7tl.fsf@nvidia.com>
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
        <20211129064755.539099c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <874k7vq7tl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 16:51:02 +0100 Petr Machata wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Sun, 28 Nov 2021 19:54:53 +0200 Ido Schimmel wrote:  
> >> I agree. I think IFLA_STATS64 in RTM_NEWLINK should contain statistics
> >> of all the packets seen by the netdev. The breakdown into software /
> >> hardware / XDP should be reported via RTM_NEWSTATS.  
> >
> > Hm, in the offload case "seen by the netdev" may be unclear. For 
> > the offload case I believe our recommendation was phrased more like 
> > "all packets which would be seen by the netdev if there was no
> > routing/tc offload", right?  
> 
> Yes. The idea is to expose to Linux stats about traffic at conceptually
> corresponding objects in the HW.

Great.

> >> Currently, for soft devices such as VLANs, bridges and GRE, user space
> >> only sees statistics of packets forwarded by software, which is quite
> >> useless when forwarding is offloaded from the kernel to hardware.
> >> 
> >> Petr is working on exposing hardware statistics for such devices via
> >> rtnetlink. Unlike XDP (?), we need to be able to let user space enable /
> >> disable hardware statistics as we have a limited number of hardware
> >> counters and they can also reduce the bandwidth when enabled. We are
> >> thinking of adding a new RTM_SETSTATS for that:
> >> 
> >> # ip stats set dev swp1 hw_stats on  
> >
> > Does it belong on the switch port? Not the netdev we want to track?  
> 
> Yes, it does, and is designed that way. That was just muscle memory
> typing that "swp1" above :)
> 
> You would do e.g. "ip stats set dev swp1.200 hw_stats on" or, "dev br1",
> or something like that.

I see :)

> >> For query, something like (under discussion):
> >> 
> >> # ip stats show dev swp1 // all groups
> >> # ip stats show dev swp1 group link
> >> # ip stats show dev swp1 group offload // all sub-groups
> >> # ip stats show dev swp1 group offload sub-group cpu
> >> # ip stats show dev swp1 group offload sub-group hw
> >> 
> >> Like other iproute2 commands, these follow the nesting of the
> >> RTM_{NEW,GET}STATS uAPI.  
> >
> > But we do have IFLA_STATS_LINK_OFFLOAD_XSTATS, isn't it effectively 
> > the same use case?  
> 
> IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest. Currently it carries just
> CPU_HIT stats. The idea is to carry HW stats as well in that group.

Hm, the expectation was that the HW stats == total - SW. I believe that
still holds true for you, even if HW stats are not "complete" (e.g.
user enabled them after device was already forwarding for a while).
Is the concern about backward compat or such?
