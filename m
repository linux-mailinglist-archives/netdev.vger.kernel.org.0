Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE0463C7D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244595AbhK3RIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:08:18 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46448 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhK3RIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:08:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B837CE1864;
        Tue, 30 Nov 2021 17:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1551BC53FC1;
        Tue, 30 Nov 2021 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291891;
        bh=OwidfSW2eyYiSRE2to5Ao1OE7NiUkBX8Dsp7SyFe8H4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GZ9FpobHR1VenCoBsv/N04Ey8CaA+XLa/SidDhpPRqdva1X1mznwA5OsEEGRpqR+Q
         SeFfPmxpx0gigYWwqyPb/vuY0NDxkSk7NacHoQeLYuxMohzEJHBRH9Sw1M3p0jjZjC
         liK2qf+T8orhAxpshfA4uwCgibJJqkGRXgHc81d/BZg9Bo0xJ+B9Yhm2+3uxRmcAqx
         BfqDz0qHEB8T4dqB+Ehc29rFx0nAYtr/ly+d6xAfKobI5io9ZzMGxfaMAmfOFtFjoR
         Qo7oMK6XtqTvenGIaPH4kA926lvz1sO0/7ISs7IsdAhoxCVOzA9XZmZKuHT5jKTyh3
         7dns1uhjvqbqg==
Date:   Tue, 30 Nov 2021 09:04:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20211130090449.58a8327d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130163454.595897-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211130155612.594688-1-alexandr.lobakin@intel.com>
        <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211130163454.595897-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 17:34:54 +0100 Alexander Lobakin wrote:
> > Another thought on this patch: with individual attributes you could save
> > some overhead by not sending 0 counters to userspace. e.g., define a
> > helper that does:  
> 
> I know about ETHTOOL_STAT_NOT_SET, but RTNL xstats doesn't use this,
> does it?

Not sure if you're asking me or Dave but no, to my knowledge RTNL does
not use such semantics today. But the reason is mostly because there
weren't many driver stats added there. Knowing if an error counter is
not supported or supporter and 0 is important for monitoring. Even if
XDP stats don't have a counter which may not be supported today it's
not a good precedent to make IMO.
