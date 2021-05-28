Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6917F3942AC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhE1Mi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236824AbhE1MhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622205330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OR486GXdMFkK0x/NJNP7fu6e0GPOm2z2tDOoXyVsl+E=;
        b=VMgxOVQSZVp139RKQPccSqBz8uFYsot9hGOA1B4Ad8eL/g+HdOcLtjTiFIXXFVe5WLXNmm
        JsJ2gwtTIVtgBewm93iDNsVEyT58ud3fueuy42hzdZqTO2G/G8Jvq6lFQ9++UQck9mp5KO
        XOifTI0NUnfzBAVe2WmmjuTOfQfuMeU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-QrwIqdIMNpmXgG7ZrQG6Xg-1; Fri, 28 May 2021 08:35:28 -0400
X-MC-Unique: QrwIqdIMNpmXgG7ZrQG6Xg-1
Received: by mail-ed1-f69.google.com with SMTP id u6-20020aa7d0c60000b029038d7337e633so2078797edo.4
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=OR486GXdMFkK0x/NJNP7fu6e0GPOm2z2tDOoXyVsl+E=;
        b=gc31c1UNPYk3alnTsszpYecQi/kCrNGKkkXXzJwfZgQucs7Is1bqhsI0Ble24oB6b+
         Ww3ePtPmWntR8xuVZzzBwqJjSRRITJvyMWQTsjzXEPFvhnOos8V9NlsZEvhmxy7sWqaM
         Gs9BHi1uPS9kHAO+pXPsobBYXa3V0mYD1kd+LzYUNFZVXVXdOxTCZM/NMVC9gAkmO9l0
         UMHVPQjMhs+a91l1JttZI4uASk3P6JTI+gvkww6S6KI+XJhjipXauyx+ViBTzp5kTDnd
         AIlyWs6o1lbhWDwTmRvDYuyroGzobFJZGTUDkOwnFWEyZLvPmGLbSYMB24E6ZKfrgNVJ
         lCpw==
X-Gm-Message-State: AOAM533cm3lt3B/AkNJyUNY0SQT4dK2PXN75rnYHHk/UtwdyvXNh9TIf
        STZAf4mLAltpMp33gQrxD0aDTrbwq79ZuXWll838+LhcZHsCRjB0+B91x92WDTghSKJzuMd4SZW
        H5nINtRlhNdYYxIjP
X-Received: by 2002:aa7:ca49:: with SMTP id j9mr7196982edt.294.1622205327156;
        Fri, 28 May 2021 05:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSVyoeKzjEkP+9tp7a5qWGGJJHZzh4b7BE4RWUW+BBN6FD9u+a6KS/hUJHaUDCF2OPzuqt+A==
X-Received: by 2002:aa7:ca49:: with SMTP id j9mr7196942edt.294.1622205326882;
        Fri, 28 May 2021 05:35:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a6sm2312421ejv.4.2021.05.28.05.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:35:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B75A18071B; Fri, 28 May 2021 14:35:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
In-Reply-To: <066a0c0a-ad48-517a-4bd0-8920bdbf0dd8@iogearbox.net>
References: <87im33grtt.fsf@toke.dk>
 <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
 <20210528115003.37840424@carbon>
 <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
 <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
 <87a6ofgmbq.fsf@toke.dk>
 <066a0c0a-ad48-517a-4bd0-8920bdbf0dd8@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 May 2021 14:35:25 +0200
Message-ID: <8735u7gho2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 5/28/21 12:54 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 5/28/21 12:00 PM, Magnus Karlsson wrote:
>>>> On Fri, May 28, 2021 at 11:52 AM Jesper Dangaard Brouer
>>>> <brouer@redhat.com> wrote:
>>>>> On Fri, 28 May 2021 17:02:01 +0800
>>>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>>>>> On Fri, 28 May 2021 10:55:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@redhat.com> wrote:
>>>>>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
>>>>>>>
>>>>>>>> In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the cu=
rrent
>>>>>>>> rx/tx data packets. This feature is very important in many cases. =
So
>>>>>>>> this patch allows AF_PACKET to obtain xsk packages.
>>>>>>>
>>>>>>> You can use xdpdump to dump the packets from the XDP program before=
 it
>>>>>>> gets redirected into the XSK:
>>>>>>> https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump
>>>>>>
>>>>>> Wow, this is a good idea.
>>>>>
>>>>> Yes, it is rather cool (credit to Eelco).  Notice the extra info you
>>>>> can capture from 'exit', like XDP return codes, if_index, rx_queue.
>>>>>
>>>>> The tool uses the perf ring-buffer to send/copy data to userspace.
>>>>> This is actually surprisingly fast, but I still think AF_XDP will be
>>>>> faster (but it usually 'steals' the packet).
>>>>>
>>>>> Another (crazy?) idea is to extend this (and xdpdump), is to leverage
>>>>> Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
>>>>> xdp_redirect_map with broadcast support").  We now have a
>>>>> xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
>>>>> BPF_F_CLONE_PASS flag?
>>>>>
>>>>> The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
>>>>> packet for the specified map target index (e.g AF_XDP map), but
>>>>> afterwards it does like veth/cpumap and creates an SKB from the
>>>>> xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
>>>>> (Feel free to kick me if this doesn't make any sense)
>>>>
>>>> This would be a smooth way to implement clone support for AF_XDP. If
>>>> we had this and someone added AF_XDP support to libpcap, we could both
>>>> capture AF_XDP traffic with tcpdump (using this clone functionality in
>>>> the XDP program) and speed up tcpdump for dumping traffic destined for
>>>> regular sockets. Would that solve your use case Xuan? Note that I have
>>>> not looked into the BPF_F_CLONE_PASS code, so do not know at this
>>>> point what it would take to support this for XSKMAPs.
>>>
>>> Recently also ended up with something similar for our XDP LB to record =
pcaps [0] ;)
>>> My question is.. tcpdump doesn't really care where the packet data come=
s from,
>>> so why not extending libpcap's Linux-related internals to either captur=
e from
>>> perf RB or BPF ringbuf rather than AF_PACKET sockets? Cloning is slow, =
and if
>>> you need to end up creating an skb which is then cloned once again insi=
de AF_PACKET
>>> it's even worse. Just relying and reading out, say, perf RB you don't n=
eed any
>>> clones at all.
>>=20
>> We discussed this when creating xdpdump and decided to keep it as a
>> separate tool for the time being. I forget the details of the
>> discussion, maybe Eelco remembers.
>>=20
>> Anyway, xdpdump does have a "pipe pcap to stdout" feature so you can do
>> `xdpdump | tcpdump` and get the interactive output; and it will also
>> save pcap information to disk, of course (using pcap-ng so it can also
>> save metadata like XDP program name and return code).
>
> Right, and this should yield a significantly better performance compared =
to
> cloning & pushing traffic into AF_PACKET. I presume not many folks are aw=
are
> of xdpdump (yet) which is probably why such patch was created here..

What, are you implying we haven't achieved world domination yet?
Inconceivable! ;)

> a native libpcap implementation could solve that aspect fwiw and
> additionally hook at the same points as AF_PACKET via BPF but without
> the hassle/overhead of things like dev_queue_xmit_nit() in fast path.
> (Maybe another option could be to have a drop-in replacement
> libpcap.so for tcpdump using it transparently.)

I do believe that Michael was open to adding something like this to
tcpdump/libpcap when I last talked to him about it; and I'm certainly
not opposed to it either! Hooking up tcpdump like this may be a bit of a
firehose, though, so it would be nice to be able to carry over the
kernel-side filtering as well. I suppose it should be possible to write
an eBPF bytecode generator that does a bit of setup and then just
translates the cBPF packet filtering ops, no? This would be cool to have
in any case; IIRC Cloudflare did something like that but took a detour
through C code generation?

-Toke

