Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B823A45F392
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhKZSQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:16:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38440 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbhKZSOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:14:51 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 13:14:49 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFDB9B82861;
        Fri, 26 Nov 2021 18:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1D4C93056;
        Fri, 26 Nov 2021 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637949974;
        bh=+d8OmlaKhMRiU+4CBcffEdG0k6jZCzzMDxT/LnP/MGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vJwIVdwCaQKtJRhphr3nXbScrfpfdclV/AYjnvi15Of+T36WHf2/Hiyc44KohWx5r
         Ycr2De+15ptRvu37tHJVUA/o2YHZ8snq9oZSpS3wLxHSoQET3XkVkz61kVM/pXSc55
         +f1lVtMcaWC6aGx0KnrJB9NCmqrxDfnOuU+Wf/ID/FVyKy503XNTGfByS/QtcHUqf7
         m4cCwIxfVanVpRLBF5NGqln6ZB1dz9yQrlAzxdTRCc8qM4YORYix0tCT/+3dhqubxT
         +LCraC7J8RSARSy614o6gutnzMVUMXy6or1wy9R9ZEyGN9ZQUJrNwA4g1cMp5rL2NW
         HX6ZyQeYFGtqQ==
Date:   Fri, 26 Nov 2021 10:06:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
Message-ID: <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sfvj9k13.fsf@toke.dk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211123163955.154512-22-alexandr.lobakin@intel.com>
        <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
        <87bl28bga6.fsf@toke.dk>
        <20211125170708.127323-1-alexandr.lobakin@intel.com>
        <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125204007.133064-1-alexandr.lobakin@intel.com>
        <87sfvj9k13.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 13:30:16 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> TBH I wasn't following this thread too closely since I saw Daniel
> >> nacked it already. I do prefer rtnl xstats, I'd just report them=20
> >> in -s if they are non-zero. But doesn't sound like we have an agreement
> >> whether they should exist or not. =20
> >
> > Right, just -s is fine, if we drop the per-channel approach. =20
>=20
> I agree that adding them to -s is fine (and that resolves my "no one
> will find them" complain as well). If it crowds the output we could also
> default to only output'ing a subset, and have the more detailed
> statistics hidden behind a verbose switch (or even just in the JSON
> output)?
>=20
> >> Can we think of an approach which would make cloudflare and cilium
> >> happy? Feels like we're trying to make the slightly hypothetical=20
> >> admin happy while ignoring objections of very real users. =20
> >
> > The initial idea was to only uniform the drivers. But in general
> > you are right, 10 drivers having something doesn't mean it's
> > something good. =20
>=20
> I don't think it's accurate to call the admin use case "hypothetical".
> We're expending a significant effort explaining to people that XDP can
> "eat" your packets, and not having any standard statistics makes this
> way harder. We should absolutely cater to our "early adopters", but if
> we want XDP to see wider adoption, making it "less weird" is critical!

Fair. In all honesty I said that hoping to push for a more flexible
approach hidden entirely in BPF, and not involving driver changes.
Assuming the XDP program has more fine grained stats we should be able
to extract those instead of double-counting. Hence my vague "let's work
with apps" comment.

For example to a person familiar with the workload it'd be useful to
know if program returned XDP_DROP because of configured policy or
failure to parse a packet. I don't think that sort distinction is
achievable at the level of standard stats.

The information required by the admin is higher level. As you say the
primary concern there is "how many packets did XDP eat".

Speaking of which, one thing that badly needs clarification is our
expectation around XDP packets getting counted towards the interface
stats.

> > Maciej, I think you were talking about Cilium asking for those stats
> > in Intel drivers? Could you maybe provide their exact usecases/needs
> > so I'll orient myself? I certainly remember about XSK Tx packets and
> > bytes.
> > And speaking of XSK Tx, we have per-socket stats, isn't that enough? =20
>=20
> IMO, as long as the packets are accounted for in the regular XDP stats,
> having a whole separate set of stats only for XSK is less important.
>=20
> >> Please leave the per-channel stats out. They make a precedent for
> >> channel stats which should be an attribute of a channel. Working for=20
> >> a large XDP user for a couple of years now I can tell you from my own
> >> experience I've not once found them useful. In fact per-queue stats are
> >> a major PITA as they crowd the output. =20
> >
> > Oh okay. My very first iterations were without this, but then I
> > found most of the drivers expose their XDP stats per-channel. Since
> > I didn't plan to degrade the functionality, they went that way. =20
>=20
> I personally find the per-channel stats quite useful. One of the primary
> reasons for not achieving full performance with XDP is broken
> configuration of packet steering to CPUs, and having per-channel stats
> is a nice way of seeing this.

Right, that's about the only thing I use it for as well. "Is the load
evenly distributed?"  But that's not XDP specific and not worth
standardizing for, yet, IMO, because..

> I can see the point about them being way too verbose in the default
> output, though, and I do generally filter the output as well when
> viewing them. But see my point above about only printing a subset of
> the stats by default; per-channel stats could be JSON-only, for
> instance?

we don't even know what constitutes a channel today. And that will
become increasingly problematic as importance of application specific
queues increases (zctap etc). IMO until the ontological gaps around
queues are filled we should leave per-queue stats in ethtool -S.
