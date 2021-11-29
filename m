Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05FF462254
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhK2UoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhK2UmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:42:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE63C0698E5;
        Mon, 29 Nov 2021 09:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A04DCE131E;
        Mon, 29 Nov 2021 17:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE23C53FC7;
        Mon, 29 Nov 2021 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638206235;
        bh=EJ/491y2sXQi1g7e++9dtTCnZ+NIW/pxkeKhPGvQhr4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r5sBkG6jS8z1zsNlYMyawzFPioGjVixsVOw0Ii/uoxSHvPUJ8zkb9vwhsUGZB1SjC
         b5EPq7n6lHSPSWRbJI5Wim0jnfb4TpFra84ABPIm40GZIbacR4r0CjUUUOUA0Q7URx
         mKyzQC07M5H2ZvE3JrUq4r5HxdQrt04MiTLdNQ5icIIqiAMoT35yQCNlZW46XMphD/
         bDOvL8HxJJ/DT9H6LkybSYXMQ/OSKO4aynUXfIJXJNT3hbNwneqPcxnOCH/nec0Fw/
         nYyQDuf7GwKxHFHh10RyPRwPGoQHEEqL19lCbB6BFGNV4F4jf+S5XYpKzUl2NqfTeg
         MYL0mKOyVagGg==
Date:   Mon, 29 Nov 2021 09:17:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
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
Message-ID: <20211129091713.2dc8462f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sfveq48z.fsf@nvidia.com>
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
        <20211129080502.53f7d316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87sfveq48z.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 18:08:12 +0100 Petr Machata wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Mon, 29 Nov 2021 16:51:02 +0100 Petr Machata wrote:  
> >> IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest. Currently it carries just
> >> CPU_HIT stats. The idea is to carry HW stats as well in that group.  
> >
> > Hm, the expectation was that the HW stats == total - SW. I believe that
> > still holds true for you, even if HW stats are not "complete" (e.g.
> > user enabled them after device was already forwarding for a while).
> > Is the concern about backward compat or such?  
> 
> I guess you could call it backward compat. But not only. I think a
> typical user doing "ip -s l sh", including various scripts, wants to see
> the full picture and not worry what's going on where. Physical
> netdevices already do that, and by extension bond and team of physical
> netdevices. It also makes sense from the point of view of an offloaded
> datapath as an implementation detail that you would ideally not notice.

Agreed.

> For those who care to know about the offloaded datapath, it would be
> nice to have the option to request either just the SW stats, or just the
> HW stats. A logical place to put these would be under the OFFLOAD_XSTATS
> nest of the RTM_GETSTATS message, but maybe the SW ones should be up
> there next to IFLA_STATS_LINK_64. (After all it's going to be
> independent from not only offload datapath, but also XDP.)

What I'm getting at is that I thought IFLA_OFFLOAD_XSTATS_CPU_HIT
should be sufficient from uAPI perspective in terms of reporting.
User space can do the simple math to calculate the "SW stats" if 
it wants to. We may well be talking about the same thing, so maybe
let's wait for the code?

> This way you get the intuitive default behavior, but still have a way to
> e.g. request just the SW stats without hitting the HW, or just request
> the HW stats if that's what you care about.

