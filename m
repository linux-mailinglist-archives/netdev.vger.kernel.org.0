Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB1246144A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242216AbhK2L4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:56:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239362AbhK2Lys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638186690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1hbT83UZyzEpMcYnWEfjfHejJ/ev9mdgbjpKbK1VxE=;
        b=jPSCvnH3AmIEJgnraLey8Z5aFFc8AIeOcFcsX+DzhdtTb0SAGz8twzNMycBFyTfseM1MSS
        8w+KBStygLCLMuokWtNVxaJiSfRKO+isstyAF4hpUsR6KCkexSxNid9nv4QxiUG0bDtO4c
        Kw91vHSrw0dewmGQCdIUe1mphja4ZQA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-RXx7xWQVOYivZVjcebwXEg-1; Mon, 29 Nov 2021 06:51:29 -0500
X-MC-Unique: RXx7xWQVOYivZVjcebwXEg-1
Received: by mail-ed1-f71.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso13415610eds.21
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 03:51:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=o1hbT83UZyzEpMcYnWEfjfHejJ/ev9mdgbjpKbK1VxE=;
        b=38mdNinL27eZAtHPGTXrD87Vb5Dbp1N5Io/4GZAsBkI0rjuUDnH+Dl4I1dtT6whKdd
         JyI/IsgBRd7HESyqSsFZzHNx3JPOxuMaaJ6LsN42P+zGNFqRRYyE+UnWXXcAK5iVOBuY
         P9aD4PoRiztRICPGFCa8Z4rKzOyNSuAmbu8V17okya25mYl6c32Ues4q+mlJTqJGWWv5
         EMC0TesHGPAwMIOcut/DhJSEvRoc8beCTZubO/x7UEVcpXrQXhTfGVcIWhYzAbxsMspi
         SXASPhaXZNAm3x0ynyixo4cuwnM0pyFqnXoN50MF3pGh0DqSZLNxV9XZXDOO+uVFRujt
         iVDg==
X-Gm-Message-State: AOAM532F3Z4pz+rU/O/VavGoiqyiG0JbZZMYta0xV7QcJWoQaxyskU2m
        mwb6xp7tynCrMjJjmADNU30gT5XsnNnfx3cC3JZ/TSyzynoMa7JCvBLApJKM0uhCJqYIiiqgH+g
        GGl7sZbxBT/Nie+O6
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr72820080edz.36.1638186687996;
        Mon, 29 Nov 2021 03:51:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy//h6DqzMZ3cIjns1ItOPHoyCEI8XwGnDfYQ/w255YG7ez18OJaBJc76mESug2RLwzmhwD5w==
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr72820014edz.36.1638186687643;
        Mon, 29 Nov 2021 03:51:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z1sm9056421edq.54.2021.11.29.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 03:51:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6858F1802A0; Mon, 29 Nov 2021 12:51:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
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
In-Reply-To: <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
 <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com>
 <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Nov 2021 12:51:26 +0100
Message-ID: <878rx79o3l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 11/26/21 7:06 PM, Jakub Kicinski wrote:
>> On Fri, 26 Nov 2021 13:30:16 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>>>>> TBH I wasn't following this thread too closely since I saw Daniel
>>>>> nacked it already. I do prefer rtnl xstats, I'd just report them
>>>>> in -s if they are non-zero. But doesn't sound like we have an agreeme=
nt
>>>>> whether they should exist or not.
>>>>
>>>> Right, just -s is fine, if we drop the per-channel approach.
>>>
>>> I agree that adding them to -s is fine (and that resolves my "no one
>>> will find them" complain as well). If it crowds the output we could also
>>> default to only output'ing a subset, and have the more detailed
>>> statistics hidden behind a verbose switch (or even just in the JSON
>>> output)?
>>>
>>>>> Can we think of an approach which would make cloudflare and cilium
>>>>> happy? Feels like we're trying to make the slightly hypothetical
>>>>> admin happy while ignoring objections of very real users.
>>>>
>>>> The initial idea was to only uniform the drivers. But in general
>>>> you are right, 10 drivers having something doesn't mean it's
>>>> something good.
>>>
>>> I don't think it's accurate to call the admin use case "hypothetical".
>>> We're expending a significant effort explaining to people that XDP can
>>> "eat" your packets, and not having any standard statistics makes this
>>> way harder. We should absolutely cater to our "early adopters", but if
>>> we want XDP to see wider adoption, making it "less weird" is critical!
>>=20
>> Fair. In all honesty I said that hoping to push for a more flexible
>> approach hidden entirely in BPF, and not involving driver changes.
>> Assuming the XDP program has more fine grained stats we should be able
>> to extract those instead of double-counting. Hence my vague "let's work
>> with apps" comment.
>>=20
>> For example to a person familiar with the workload it'd be useful to
>> know if program returned XDP_DROP because of configured policy or
>> failure to parse a packet. I don't think that sort distinction is
>> achievable at the level of standard stats.
>
> Agree on the additional context. How often have you looked at tc clsact
> /dropped/ stats specifically when you debug a more complex BPF program
> there?
>
>    # tc -s qdisc show clsact dev foo
>    qdisc clsact ffff: parent ffff:fff1
>     Sent 6800 bytes 120 pkt (dropped 0, overlimits 0 requeues 0)
>     backlog 0b 0p requeues 0
>
> Similarly, XDP_PASS counters may be of limited use as well for same reason
> (and I think we might not even have a tc counter equivalent for it).
>
>> The information required by the admin is higher level. As you say the
>> primary concern there is "how many packets did XDP eat".
>
> Agree. Above said, for XDP_DROP I would see one use case where you compare
> different drivers or bond vs no bond as we did in the past in [0] when
> testing against a packet generator (although I don't see bond driver cove=
red
> in this series here yet where it aggregates the XDP stats from all bond s=
lave
> devs).
>
> On a higher-level wrt "how many packets did XDP eat", it would make sense
> to have the stats for successful XDP_{TX,REDIRECT} given these are out
> of reach from a BPF prog PoV - we can only count there how many times we
> returned with XDP_TX but not whether the pkt /successfully made it/.
>
> In terms of error cases, could we just standardize all drivers on the beh=
avior
> of e.g. mlx5e_xdp_handle(), meaning, a failure from XDP_{TX,REDIRECT} will
> hit the trace_xdp_exception() and then fallthrough to bump a drop counter
> (same as we bump in XDP_DROP then). So the drop counter will account for
> program drops but also driver-related drops.
>
> At some later point the trace_xdp_exception() could be extended with an e=
rror
> code that the driver would propagate (given some of them look quite simil=
ar
> across drivers, fwiw), and then whoever wants to do further processing wi=
th
> them can do so via bpftrace or other tooling.
>
> So overall wrt this series: from the lrstats we'd be /dropping/ the pass,
> tx_errors, redirect_errors, invalid, aborted counters. And we'd be /keepi=
ng/
> bytes & packets counters that XDP sees, (driver-)successful tx & redirect
> counters as well as drop counter. Also, XDP bytes & packets counters shou=
ld
> not be counted twice wrt ethtool stats.

This sounds reasonable to me, and I also like the error code to
tracepoint idea :)

-Toke

