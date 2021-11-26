Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04E45F4EC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbhKZSwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:52:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237644AbhKZSuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637952442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O6rbfWik1xYZrbAijVAfDmHvfjyDH76LNjEVf+e9aLQ=;
        b=hFYhAlP8GBhz1FEbf9TUfzXegT6lTYNO0hepumm/3tKmIUczzqaeBMKqaMLgBYrdz5/YgX
        +X3GajNh6ju/+fAzU99wssE2dVrrvqoKj+5lbKFSGGiTr7CNNYDlgMTSeXYvHHmpK1n4f8
        n5D59rsg3QumljgB6Cou/fG97aGr07w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-BMCshXxaNR62UdQpuqP-lw-1; Fri, 26 Nov 2021 13:47:21 -0500
X-MC-Unique: BMCshXxaNR62UdQpuqP-lw-1
Received: by mail-ed1-f69.google.com with SMTP id d13-20020a056402516d00b003e7e67a8f93so8692005ede.0
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 10:47:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=O6rbfWik1xYZrbAijVAfDmHvfjyDH76LNjEVf+e9aLQ=;
        b=T6HRv0yND4Y6ZO2T4g1+O2tdoiJrRDn8cFzSv34Wh+ce9n/QpCpvKamhVNx5mCS+y0
         AaEGkvoW9zdEpszy6gW6clgMoaszxjBLaIwRmer3q/hQDUdY6QktiZHHuDkibs4addlx
         ATDqSxnOsy+J4XLpGq4OtpEtDRnyXoo4yNWNZztoWk0lODJXolP/8JD9as66keSvSO8D
         Ez0xXRAFEUufP7jLmAkzeHhcmbdAlRoC6BBPF8bA2/jiGdBagSm8YWOKJNrqZosstZ+y
         iC+FH4/OtQu5H0HsbqF8JlAnsDpgKJLGjlG6vzwa6CyA3UBQsyO+flbCqlDXPlaQ86iz
         huVQ==
X-Gm-Message-State: AOAM531iL+buEws9BwRJNdr2kq9evi2EQBGw7MpeoY1lIU4VVx8KIGoV
        H4t8C4PansLwPtxM3JjmeobecnmYwlNhN679YiULm5dKmZvb+kQfhatGGX2F2EL7PaBK2tNsxji
        8IyudULm748ZqLRvU
X-Received: by 2002:a50:f09b:: with SMTP id v27mr50640043edl.53.1637952439510;
        Fri, 26 Nov 2021 10:47:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysqEUXaashQMp696tzO9iR2R9x+kWsok2AbHg4/IoknOktCZ+sa6SV7IRItNNVUIbLVIF90Q==
X-Received: by 2002:a50:f09b:: with SMTP id v27mr50639967edl.53.1637952439132;
        Fri, 26 Nov 2021 10:47:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z6sm4779036edc.76.2021.11.26.10.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 10:47:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB3281802A0; Fri, 26 Nov 2021 19:47:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
In-Reply-To: <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
 <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com>
 <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Nov 2021 19:47:17 +0100
Message-ID: <87ee72ah56.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 26 Nov 2021 13:30:16 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> TBH I wasn't following this thread too closely since I saw Daniel
>> >> nacked it already. I do prefer rtnl xstats, I'd just report them=20
>> >> in -s if they are non-zero. But doesn't sound like we have an agreeme=
nt
>> >> whether they should exist or not.=20=20
>> >
>> > Right, just -s is fine, if we drop the per-channel approach.=20=20
>>=20
>> I agree that adding them to -s is fine (and that resolves my "no one
>> will find them" complain as well). If it crowds the output we could also
>> default to only output'ing a subset, and have the more detailed
>> statistics hidden behind a verbose switch (or even just in the JSON
>> output)?
>>=20
>> >> Can we think of an approach which would make cloudflare and cilium
>> >> happy? Feels like we're trying to make the slightly hypothetical=20
>> >> admin happy while ignoring objections of very real users.=20=20
>> >
>> > The initial idea was to only uniform the drivers. But in general
>> > you are right, 10 drivers having something doesn't mean it's
>> > something good.=20=20
>>=20
>> I don't think it's accurate to call the admin use case "hypothetical".
>> We're expending a significant effort explaining to people that XDP can
>> "eat" your packets, and not having any standard statistics makes this
>> way harder. We should absolutely cater to our "early adopters", but if
>> we want XDP to see wider adoption, making it "less weird" is critical!
>
> Fair. In all honesty I said that hoping to push for a more flexible
> approach hidden entirely in BPF, and not involving driver changes.
> Assuming the XDP program has more fine grained stats we should be able
> to extract those instead of double-counting. Hence my vague "let's work
> with apps" comment.
>
> For example to a person familiar with the workload it'd be useful to
> know if program returned XDP_DROP because of configured policy or
> failure to parse a packet. I don't think that sort distinction is
> achievable at the level of standard stats.
>
> The information required by the admin is higher level. As you say the
> primary concern there is "how many packets did XDP eat".

Right, sure, I am also totally fine with having only a somewhat
restricted subset of stats available at the interface level and make
everything else be BPF-based. I'm hoping we can converge of a common
understanding of what this "minimal set" should be :)

> Speaking of which, one thing that badly needs clarification is our
> expectation around XDP packets getting counted towards the interface
> stats.

Agreed. My immediate thought is that "XDP packets are interface packets"
but that is certainly not what we do today, so not sure if changing it
at this point would break things?

>> > Maciej, I think you were talking about Cilium asking for those stats
>> > in Intel drivers? Could you maybe provide their exact usecases/needs
>> > so I'll orient myself? I certainly remember about XSK Tx packets and
>> > bytes.
>> > And speaking of XSK Tx, we have per-socket stats, isn't that enough?=
=20=20
>>=20
>> IMO, as long as the packets are accounted for in the regular XDP stats,
>> having a whole separate set of stats only for XSK is less important.
>>=20
>> >> Please leave the per-channel stats out. They make a precedent for
>> >> channel stats which should be an attribute of a channel. Working for=
=20
>> >> a large XDP user for a couple of years now I can tell you from my own
>> >> experience I've not once found them useful. In fact per-queue stats a=
re
>> >> a major PITA as they crowd the output.=20=20
>> >
>> > Oh okay. My very first iterations were without this, but then I
>> > found most of the drivers expose their XDP stats per-channel. Since
>> > I didn't plan to degrade the functionality, they went that way.=20=20
>>=20
>> I personally find the per-channel stats quite useful. One of the primary
>> reasons for not achieving full performance with XDP is broken
>> configuration of packet steering to CPUs, and having per-channel stats
>> is a nice way of seeing this.
>
> Right, that's about the only thing I use it for as well. "Is the load
> evenly distributed?"  But that's not XDP specific and not worth
> standardizing for, yet, IMO, because..
>
>> I can see the point about them being way too verbose in the default
>> output, though, and I do generally filter the output as well when
>> viewing them. But see my point above about only printing a subset of
>> the stats by default; per-channel stats could be JSON-only, for
>> instance?
>
> we don't even know what constitutes a channel today. And that will
> become increasingly problematic as importance of application specific
> queues increases (zctap etc). IMO until the ontological gaps around
> queues are filled we should leave per-queue stats in ethtool -S.

Hmm, right, I see. I suppose that as long as the XDP packets show up in
one of the interface counters in ethtool -S, it's possible to answer the
load distribution issue, and any further debugging (say, XDP drops on a
certain queue due to CPU-based queue indexing on TX) can be delegated to
BPF-based tools...

-Toke

