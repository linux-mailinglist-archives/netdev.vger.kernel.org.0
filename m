Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1411E394164
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhE1K4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:56:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236170AbhE1K4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622199296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUHBlvf58/m1+0bdfopi5k6+RO92MQelPRuJ7bCd7+c=;
        b=XuFNV8FqRnbdlodLX6ib8itFcXsgb32vTq8aqzwkYqSPEEVlkVYonRBoZ+0kmDCZMrjuYd
        m9WiltMNBiftrnAYwAuN1usMG0HggzfMeqCredlxievwNOb6vhDMiNkIibEf3eNvmsqVHX
        dQ8vccUkHMmNq98sVYRyayj02024smo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-LEJ9Dg21PjWOgDDw4mBz0w-1; Fri, 28 May 2021 06:54:52 -0400
X-MC-Unique: LEJ9Dg21PjWOgDDw4mBz0w-1
Received: by mail-ed1-f70.google.com with SMTP id j13-20020aa7de8d0000b029038fc8e57037so519791edv.0
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 03:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vUHBlvf58/m1+0bdfopi5k6+RO92MQelPRuJ7bCd7+c=;
        b=KgtiT7k7k9I3Ok72DYSQ+5jnsYFzywKhET0FEb0SYKq4wXBk4DcZMiTAWxWhfGrCaJ
         MdEBsF2tXjC1KxxbUbo5JGrZHC8f/vQzqEvizgKRguRoySqCraw+OMkEe5Puae9ewTgP
         N8N43072fCaWDIOa2+QBnA3siWa2Q5lH7s1Mc2YCS+vShZoMm0H9vs4hZQJxFy3XtiT4
         MVgQry5MqhgC6j1tzOUzKJlQSKL9QtIlzSb8KlsgtsExGboryAT0/XFir91HkMc3A4j5
         Ui0CSaW++XAwetV+woMcn1DUCSQU7MgXYAZy+Mtkhk8ZNZS4viO+bv2l0EUZPGxqdYea
         s7Og==
X-Gm-Message-State: AOAM532lVLOFb4r+N/zAukXc4gMVI9j54I17I+8IXiKyk0Eiuxp2YF7Z
        ju6RvSv1iNAOlkGlyivF6QDfs+1LIA/4ZQbtbr1lTqlx8jur4iavix8Vq0HIXHtFHgJgeZlLA2v
        x9z1loc1IZ6QThes0
X-Received: by 2002:a05:6402:1052:: with SMTP id e18mr9377863edu.366.1622199291652;
        Fri, 28 May 2021 03:54:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKPlowlteoA21X2ExE/xl0e23P4UV6FzqNHeU7XLx84Ru2OTIy1r7dHfxTdFmCl/doCGsmkQ==
X-Received: by 2002:a05:6402:1052:: with SMTP id e18mr9377820edu.366.1622199291229;
        Fri, 28 May 2021 03:54:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y20sm1259600ejd.33.2021.05.28.03.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 03:54:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0BD9A18071B; Fri, 28 May 2021 12:54:50 +0200 (CEST)
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
In-Reply-To: <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
References: <87im33grtt.fsf@toke.dk>
 <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
 <20210528115003.37840424@carbon>
 <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
 <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 May 2021 12:54:49 +0200
Message-ID: <87a6ofgmbq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 5/28/21 12:00 PM, Magnus Karlsson wrote:
>> On Fri, May 28, 2021 at 11:52 AM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>>> On Fri, 28 May 2021 17:02:01 +0800
>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>>> On Fri, 28 May 2021 10:55:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
>>>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
>>>>>
>>>>>> In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the curr=
ent
>>>>>> rx/tx data packets. This feature is very important in many cases. So
>>>>>> this patch allows AF_PACKET to obtain xsk packages.
>>>>>
>>>>> You can use xdpdump to dump the packets from the XDP program before it
>>>>> gets redirected into the XSK:
>>>>> https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump
>>>>
>>>> Wow, this is a good idea.
>>>
>>> Yes, it is rather cool (credit to Eelco).  Notice the extra info you
>>> can capture from 'exit', like XDP return codes, if_index, rx_queue.
>>>
>>> The tool uses the perf ring-buffer to send/copy data to userspace.
>>> This is actually surprisingly fast, but I still think AF_XDP will be
>>> faster (but it usually 'steals' the packet).
>>>
>>> Another (crazy?) idea is to extend this (and xdpdump), is to leverage
>>> Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
>>> xdp_redirect_map with broadcast support").  We now have a
>>> xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
>>> BPF_F_CLONE_PASS flag?
>>>
>>> The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
>>> packet for the specified map target index (e.g AF_XDP map), but
>>> afterwards it does like veth/cpumap and creates an SKB from the
>>> xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
>>> (Feel free to kick me if this doesn't make any sense)
>>=20
>> This would be a smooth way to implement clone support for AF_XDP. If
>> we had this and someone added AF_XDP support to libpcap, we could both
>> capture AF_XDP traffic with tcpdump (using this clone functionality in
>> the XDP program) and speed up tcpdump for dumping traffic destined for
>> regular sockets. Would that solve your use case Xuan? Note that I have
>> not looked into the BPF_F_CLONE_PASS code, so do not know at this
>> point what it would take to support this for XSKMAPs.
>
> Recently also ended up with something similar for our XDP LB to record pc=
aps [0] ;)
> My question is.. tcpdump doesn't really care where the packet data comes =
from,
> so why not extending libpcap's Linux-related internals to either capture =
from
> perf RB or BPF ringbuf rather than AF_PACKET sockets? Cloning is slow, an=
d if
> you need to end up creating an skb which is then cloned once again inside=
 AF_PACKET
> it's even worse. Just relying and reading out, say, perf RB you don't nee=
d any
> clones at all.

We discussed this when creating xdpdump and decided to keep it as a
separate tool for the time being. I forget the details of the
discussion, maybe Eelco remembers.

Anyway, xdpdump does have a "pipe pcap to stdout" feature so you can do
`xdpdump | tcpdump` and get the interactive output; and it will also
save pcap information to disk, of course (using pcap-ng so it can also
save metadata like XDP program name and return code).

-Toke

