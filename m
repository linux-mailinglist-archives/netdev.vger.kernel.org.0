Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3D463EC7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 20:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhK3Ttv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 14:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhK3Ttu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 14:49:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48BC061574;
        Tue, 30 Nov 2021 11:46:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD2F5CE1AF9;
        Tue, 30 Nov 2021 19:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740A3C53FC7;
        Tue, 30 Nov 2021 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638301586;
        bh=ApZc1+OcZnLq0/E95Na9o4zYk/Nz5een41TdSnFrjdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UJX2bh+4xhNCn2QNWlJFipczmrFgKctmhXJ7Nz17F+8gO7gray2WfXcyTAilE0wBQ
         49r2iTfeFnSSMq06q5ZgOg8ReXMaZLeRad2GqxdGlfXzlz6iIfRif/j2l+aJffEjmt
         juOonOC8+vT9yjmM48WOyBIWl71TjKGBv+iay+GDPe+l28AcZ08clUbPWqvSNruXVI
         xbvE+ucHkDg1hAIMV9mzO/873wdfxJm5ga/BfgDsyiB9bPsSC2nE5xPQZEjaoIBywm
         AXzPCwrR//xXsBrnHzWd3ZMncm4gkZdXrMNyIuRFi4GMdhIfLfKYqP1aBCvMeVFWcq
         z7VjsQNHR/1+A==
Date:   Tue, 30 Nov 2021 11:46:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
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
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Message-ID: <20211130114624.5b1f5f61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <18655462-c72e-1d26-5b59-d03eb993d832@gmail.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211130155612.594688-1-alexandr.lobakin@intel.com>
        <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211130163454.595897-1-alexandr.lobakin@intel.com>
        <20211130090449.58a8327d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <18655462-c72e-1d26-5b59-d03eb993d832@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 10:38:14 -0700 David Ahern wrote:
> On 11/30/21 10:04 AM, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 17:34:54 +0100 Alexander Lobakin wrote:  
> >> I know about ETHTOOL_STAT_NOT_SET, but RTNL xstats doesn't use this,
> >> does it?  
> > 
> > Not sure if you're asking me or Dave but no, to my knowledge RTNL does
> > not use such semantics today. But the reason is mostly because there
> > weren't many driver stats added there. Knowing if an error counter is
> > not supported or supporter and 0 is important for monitoring. Even if
> > XDP stats don't have a counter which may not be supported today it's
> > not a good precedent to make IMO.
> 
> Today, stats are sent as a struct so skipping stats whose value is 0 is
> not an option. When using individual attributes for the counters this
> becomes an option. Given there is no value in sending '0' why do it?

To establish semantics of what it means that the statistic is not
reported. If we need to save space we'd need an extra attr with 
a bitmap of "these stats were skipped because they were zero".
Or conversely some way of querying supported stats.

> Is your pushback that there should be a uapi to opt-in to this behavior?

Not where I was going with it, but it is an option. If skipping 0s was
controlled by a flag a dump without such flag set would basically serve
as a way to query supported stats.
