Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3945F50F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhKZTTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:19:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56306 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhKZTRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:17:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74AE7622DE;
        Fri, 26 Nov 2021 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165FCC9305B;
        Fri, 26 Nov 2021 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637954074;
        bh=+nhGICWJsd+aB+/kny95kMmh4ozyIUj/GYIKSit7jPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H17Adt7eVq/zWrESvaVF96l0cxNH5c9QpPTAkKXRFd6BssbhDBOoDVcXei9WahPGu
         VoZagFZTJH6H5lK2Vz6KzqwilW8EF/9gmqrLEXawz6OaOWuTIvyeeX4jCjd17GQqPR
         r3UxsajHuP68vEAKqu4VG68ZXUtFiysGXJJJ+B8es4MdX7jlAU4gNm77c9gS3MYkdw
         Svu8hLrqcsueFu/liiwcl+SS3QuuTQyOtQ0XFnh0ieJ6ryCBiaYHBzhY9HH+7VLLgA
         WHhBUAUVME3lcd6Ah56newvqk22x1kTyzpW5ofGDYifSajp+Hc9qB1qZO+OSYzh5ji
         MnXBPWWuuxYOQ==
Date:   Fri, 26 Nov 2021 11:14:31 -0800
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
Message-ID: <20211126111431.4a2ed007@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87ee72ah56.fsf@toke.dk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211123163955.154512-22-alexandr.lobakin@intel.com>
        <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
        <87bl28bga6.fsf@toke.dk>
        <20211125170708.127323-1-alexandr.lobakin@intel.com>
        <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125204007.133064-1-alexandr.lobakin@intel.com>
        <87sfvj9k13.fsf@toke.dk>
        <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87ee72ah56.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 19:47:17 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Fair. In all honesty I said that hoping to push for a more flexible
> > approach hidden entirely in BPF, and not involving driver changes.
> > Assuming the XDP program has more fine grained stats we should be able
> > to extract those instead of double-counting. Hence my vague "let's work
> > with apps" comment.
> >
> > For example to a person familiar with the workload it'd be useful to
> > know if program returned XDP_DROP because of configured policy or
> > failure to parse a packet. I don't think that sort distinction is
> > achievable at the level of standard stats.
> >
> > The information required by the admin is higher level. As you say the
> > primary concern there is "how many packets did XDP eat". =20
>=20
> Right, sure, I am also totally fine with having only a somewhat
> restricted subset of stats available at the interface level and make
> everything else be BPF-based. I'm hoping we can converge of a common
> understanding of what this "minimal set" should be :)
>=20
> > Speaking of which, one thing that badly needs clarification is our
> > expectation around XDP packets getting counted towards the interface
> > stats. =20
>=20
> Agreed. My immediate thought is that "XDP packets are interface packets"
> but that is certainly not what we do today, so not sure if changing it
> at this point would break things?

I'd vote for taking the risk and trying to align all the drivers.
