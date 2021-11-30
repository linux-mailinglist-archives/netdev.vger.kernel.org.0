Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B97463B5B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhK3QPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238305AbhK3QPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:15:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00E1C061574;
        Tue, 30 Nov 2021 08:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72FD4B81A55;
        Tue, 30 Nov 2021 16:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD8FC53FC7;
        Tue, 30 Nov 2021 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638288730;
        bh=iRdgTv4fN/JJUCrVtzWqiHGVLzWVk8tfWKpHJzXEUao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b1C1uEbeyoakg5ft0e7U89RtvrQemU7cb3fAxWzD8uQetk+bhMLZ6k0fMTG2nc7gN
         D6HcVQWuf3UPVcs8yLfRg03vhxF2cUr0iv9UVCgZkjKEKAsTfOH3+DYRtM0IAXDHEp
         IlnOgZsRZUynEOMvh9WfWXb5w7/6lgGF71jPj79Y5D/NOY1NrEiUXe8Grw1T3uZyjr
         PduPxpNiHbriEqhiHDyBabThWy+P9L9VoOsw/f7cFuseoFkPK5F6osbyuDBux2hLDj
         ssgWqbWgwIGnBm2UnQVkCRQnhcntuXQMoRvNGOMEVnLWKegyYMpupbW6B/gAjrHZiy
         XzW9gw+Ar73HQ==
Date:   Tue, 30 Nov 2021 08:12:07 -0800
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
Message-ID: <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130155612.594688-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211130155612.594688-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 16:56:12 +0100 Alexander Lobakin wrote:
> 3. XDP and XSK ctrs separately or not.
> 
> My PoV is that those are two quite different worlds.
> However, stats for actions on XSK really make a little sense since
> 99% of time we have xskmap redirect. So I think it'd be fine to just
> expand stats structure with xsk_{rx,tx}_{packets,bytes} and count
> the rest (actions, errors) together with XDP.
> 
> 
> Rest:
>  - don't create a separate `ip` command and report under `-s`;
>  - save some RTNL skb space by skipping zeroed counters.

Let me ruin this point of clarity for you. I think that stats should 
be skipped when they are not collected (see ETHTOOL_STAT_NOT_SET).
If messages get large user should use the GETSTATS call and avoid 
the problem more effectively.

> Also, regarding that I count all on the stack and then add to the
> storage once in a polling cycle -- most drivers don't do that and
> just increment the values in the storage directly, but this can be
> less performant for frequently updated stats (or it's just my
> embedded past).
> Re u64 vs u64_stats_t -- the latter is more universal and
> architecture-friendly, the former is used directly in most of the
> drivers primarily because those drivers and the corresponding HW
> are being run on 64-bit systems in the vast majority of cases, and
> Ethtools stats themselves are not so critical to guard them with
> anti-tearing. Anyways, local64_t is cheap on ARM64/x86_64 I guess?

