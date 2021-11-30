Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CA7463EDE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 20:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbhK3T4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 14:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhK3T4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 14:56:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1382C061574;
        Tue, 30 Nov 2021 11:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865C5B81C4F;
        Tue, 30 Nov 2021 19:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC40C53FC7;
        Tue, 30 Nov 2021 19:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638302000;
        bh=aTmjCFwSpcBj+onftbaUVHulbaxdXYb3fT3C883v9oc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ameAKKv2VijYEVOMn3HCroz01tHjJdK1bVMWmL4MSb61VBKQvul8dYxtooIYqLUuJ
         WJheIiiQMsFgi2Mtst3hLBIBQ1YsfEA7EniqXZUdBcKxV2LpBgNp++urUPqzOxoyvK
         +Mi24iNN5VCrQ4ADd4Y3azmcXnMQQHaUn9OXq+Xo2dJn5KA0hjqfz4l3M7+Dsuiuon
         wSDbfwnVfTB4GCtrNrHXIoKaMEzuXuGnSqYhUmZa4SNfVEYDbFtfVk7EjeWCBEYMJB
         KFCAPhwmUJji2z0P6+dNi3OAHhedETfqTTAd/qqVipPK1NkeATmmKmWzJKsxIRZH18
         B3XJUMpjQe6cg==
Date:   Tue, 30 Nov 2021 11:53:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
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
Message-ID: <20211130115317.7858b0eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d9be528c-af35-6c10-c458-9e2f7759bbb3@gmail.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211130155612.594688-1-alexandr.lobakin@intel.com>
        <871r2x8vor.fsf@toke.dk>
        <20211130090716.4a557036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d9be528c-af35-6c10-c458-9e2f7759bbb3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 10:56:26 -0700 David Ahern wrote:
> On 11/30/21 10:07 AM, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 17:17:24 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> >> Well, I don't like throwing data away, so in that sense I do like
> >> per-queue stats, but it's not a very strong preference (i.e., I can li=
ve
> >> with either)... =20
> >=20
> > We don't even have a clear definition of a queue in Linux.
> >  =20
>=20
> The summary above says "Jakub: no per-channel", and then you have this
> comment about a clear definition of a queue. What is your preference
> here, Jakub? I think I have gotten lost in all of the coments.

I'm against per-channel and against per-queue stats. I'm not saying "do
one instead of the other". Hope that makes it clear.

> My request was just to not lump Rx and Tx together under a 'channel'
> definition as a new API. Proposals like zctap and 'queues as a first
> class citizen' are examples of intentions / desires to move towards Rx
> and Tx queues beyond what exists today.

Right, and when we have the objects to control those we'll hang the
stats off them. Right now half of the NICs will destroy queue stats
on random reconfiguration requests, others will mix the stats between
queue instantiations.. mlx5 does it's shadow queue thing. It's a mess.
uAPI which is not portable and not usable in production is pure burden.
