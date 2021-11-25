Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8697945DFF2
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbhKYRtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242533AbhKYRry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:47:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F01F46112F;
        Thu, 25 Nov 2021 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637862282;
        bh=jrayRqgF9hhHko6mvZwExBa7LETi0CwTeoZ8P/NuYkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RPKlKSqSXyg4la2jIDGhvO72cMF/0Cy8GmoLYRFMkFObes1bppSi+Hjrof1hi5y8D
         Mo/z3t187x7GBkid6bdmoDQwWJgz5l4Z90cVj34N9kZq0wq0zlk2YyS4a6FDp1/Lnu
         UZdoC7bkFOIIJfRRPCn0JJqtI7xslozdRMn7tzMGffNC1euoguoOzmVbzgBxkOAu9R
         h3zLNImWsMVxhipd5al2IOzC1r9Hc1bCybCGyltZP2WAApkAMBfLbA7kezwl5aGLdu
         HLfH7B82zsuMYsih3K7cygkPlc8jHDt8ey3Oo4SFMkJBVv2Jgkg3PrOOjNIV2ylR80
         aMWz0xGyWNddg==
Date:   Thu, 25 Nov 2021 09:44:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
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
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125170708.127323-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211123163955.154512-22-alexandr.lobakin@intel.com>
        <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
        <87bl28bga6.fsf@toke.dk>
        <20211125170708.127323-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 18:07:08 +0100 Alexander Lobakin wrote:
> > This I agree with, and while I can see the layering argument for putting
> > them into 'ip' and rtnetlink instead of ethtool, I also worry that these
> > counters will simply be lost in obscurity, so I do wonder if it wouldn't
> > be better to accept the "layering violation" and keeping them all in the
> > 'ethtool -S' output?  
> 
> I don't think we should harm the code and the logics in favor of
> 'some of the users can face something'. We don't control anything
> related to XDP using Ethtool at all, but there is some XDP-related
> stuff inside iproute2 code, so for me it's even more intuitive to
> have them there.
> Jakub, may be you'd like to add something at this point?

TBH I wasn't following this thread too closely since I saw Daniel
nacked it already. I do prefer rtnl xstats, I'd just report them 
in -s if they are non-zero. But doesn't sound like we have an agreement
whether they should exist or not.

Can we think of an approach which would make cloudflare and cilium
happy? Feels like we're trying to make the slightly hypothetical 
admin happy while ignoring objections of very real users.

> > > +  xdp-channel0-rx_xdp_redirect: 7
> > > +  xdp-channel0-rx_xdp_redirect_errors: 8
> > > +  xdp-channel0-rx_xdp_tx: 9
> > > +  xdp-channel0-rx_xdp_tx_errors: 10
> > > +  xdp-channel0-tx_xdp_xmit_packets: 11
> > > +  xdp-channel0-tx_xdp_xmit_bytes: 12
> > > +  xdp-channel0-tx_xdp_xmit_errors: 13
> > > +  xdp-channel0-tx_xdp_xmit_full: 14

Please leave the per-channel stats out. They make a precedent for
channel stats which should be an attribute of a channel. Working for 
a large XDP user for a couple of years now I can tell you from my own
experience I've not once found them useful. In fact per-queue stats are
a major PITA as they crowd the output.
