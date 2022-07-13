Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75420573F29
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiGMVwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGMVwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:52:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2983631206
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657749134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N78MFrYLRsLtgFRz+P4RGsP+AFQio+2vYruYX0qto+U=;
        b=f0+0y3cawDMYptTM6d9ZsJPllVy7YOkwloaP6wrN6SGSYlj3ZGXEk4xC9IcWUtBRnWjtbO
        6HCirDkpXj+MUFYXDDHDtV+3bTXoL3V6YLT/qoXt48AnKgZMdy1Vmi94HOGWj+6ipmE5oA
        mQYp7cfqc51VBIFEgDa9FRPfhzHkHwg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-q3cx2yRwNEmE_oBCQ8l-5w-1; Wed, 13 Jul 2022 17:52:13 -0400
X-MC-Unique: q3cx2yRwNEmE_oBCQ8l-5w-1
Received: by mail-ed1-f69.google.com with SMTP id w15-20020a056402268f00b0043ac600a6bcso42755edd.6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=N78MFrYLRsLtgFRz+P4RGsP+AFQio+2vYruYX0qto+U=;
        b=VapQ9WnaKCZnyftFPu2s+Rs5uvaiFtTOF9blZWx0h7wXM4CAhn7UMKtSnN0fF2rDnF
         qe9kbuBoeqFepfGhUZ1B0hcNfJ9JkHsF/wbcVppmgsxvrpmQvLx8qxwQcxeAizeck59v
         zVlV0zwr6ZTFFcjJcS7We6NfK+ibC0nBCp/bphhr0JRFzLUpMdVZZJcKGypH2qwU+GjF
         JNDPOa3H5m1F0Y03Jz8blXJYK2LtHNojiruAGFafSaTV6pE6sQ11NN4UTz9fjMQ31KwU
         VKrOKEKjvSV0tRYwSBKYNeB5Mv6fzHaA0s+e8r5MJQ1mK4BtJOVR7oVlGFllRgw9RdbP
         ZoNQ==
X-Gm-Message-State: AJIora8ZoAc1r9IvVno4u1k9hQtfvmziUpQ+tTgcL2srPv8YEAwV3SLq
        gK0/oD6F8KNZ6KBIH9vmhbMZYgKpdu2NjZK03qjt/p82eOghkpUHzQMzjvjfPEle8kaHO7XDQZL
        bO+uB5FfuXC2g0adT
X-Received: by 2002:a17:907:9621:b0:72e:d9a3:3f7a with SMTP id gb33-20020a170907962100b0072ed9a33f7amr1161631ejc.260.1657749130605;
        Wed, 13 Jul 2022 14:52:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vr6viE2LemzROwzYQJ10Lr8/7j4SaobNuHLqy3cjp1Ap/ndwsxVzqGMlBkv6dGCzInc2H99g==
X-Received: by 2002:a17:907:9621:b0:72e:d9a3:3f7a with SMTP id gb33-20020a170907962100b0072ed9a33f7amr1161566ejc.260.1657749129656;
        Wed, 13 Jul 2022 14:52:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id kv20-20020a17090778d400b0072af6f166c2sm5479080ejc.82.2022.07.13.14.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 14:52:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 083D84D99CA; Wed, 13 Jul 2022 23:52:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Jul 2022 23:52:07 +0200
Message-ID: <877d4gpto8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Packet forwarding is an important use case for XDP, which offers
>> significant performance improvements compared to forwarding using the
>> regular networking stack. However, XDP currently offers no mechanism to
>> delay, queue or schedule packets, which limits the practical uses for
>> XDP-based forwarding to those where the capacity of input and output lin=
ks
>> always match each other (i.e., no rate transitions or many-to-one
>> forwarding). It also prevents an XDP-based router from doing any kind of
>> traffic shaping or reordering to enforce policy.
>>
>> This series represents a first RFC of our attempt to remedy this lack. T=
he
>> code in these patches is functional, but needs additional testing and
>> polishing before being considered for merging. I'm posting it here as an
>> RFC to get some early feedback on the API and overall design of the
>> feature.
>>
>> DESIGN
>>
>> The design consists of three components: A new map type for storing XDP
>> frames, a new 'dequeue' program type that will run in the TX softirq to
>> provide the stack with packets to transmit, and a set of helpers to dequ=
eue
>> packets from the map, optionally drop them, and to schedule an interface
>> for transmission.
>>
>> The new map type is modelled on the PIFO data structure proposed in the
>> literature[0][1]. It represents a priority queue where packets can be
>> enqueued in any priority, but is always dequeued from the head. From the
>> XDP side, the map is simply used as a target for the bpf_redirect_map()
>> helper, where the target index is the desired priority.
>
> I have the same question I asked on the series from Cong:
> Any considerations for existing carousel/edt-like models?

Well, the reason for the addition in patch 5 (continuously increasing
priorities) is exactly to be able to implement EDT-like behaviour, where
the priority is used as time units to clock out packets.

> Can we make the map flexible enough to implement different qdisc
> policies?

That's one of the things we want to be absolutely sure about. We are
starting out with the PIFO map type because the literature makes a good
case that it is flexible enough to implement all conceivable policies.
The goal of the test harness linked as note [4] is to actually examine
this; Frey is our PhD student working on this bit.

Thus far we haven't hit any limitations on this, but we'll need to add
more policies before we are done with this. Another consideration is
performance, of course, so we're also planning to do a comparison with a
more traditional "bunch of FIFO queues" type data structure for at least
a subset of the algorithms. Kartikeya also had an idea for an
alternative way to implement a priority queue using (semi-)lockless
skiplists, which may turn out to perform better.

If there's any particular policy/algorithm you'd like to see included in
this evaluation, please do let us know, BTW! :)

>> The dequeue program type is a new BPF program type that is attached to an
>> interface; when an interface is scheduled for transmission, the stack wi=
ll
>> execute the attached dequeue program and, if it returns a packet to
>> transmit, that packet will be transmitted using the existing ndo_xdp_xmi=
t()
>> driver function.
>>
>> The dequeue program can obtain packets by pulling them out of a PIFO map
>> using the new bpf_packet_dequeue() helper. This returns a pointer to an
>> xdp_md structure, which can be dereferenced to obtain packet data and
>> data_meta pointers like in an XDP program. The returned packets are also
>> reference counted, meaning the verifier enforces that the dequeue program
>> either drops the packet (with the bpf_packet_drop() helper), or returns =
it
>> for transmission. Finally, a helper is added that can be used to actually
>> schedule an interface for transmission using the dequeue program type; t=
his
>> helper can be called from both XDP and dequeue programs.
>>
>> PERFORMANCE
>>
>> Preliminary performance tests indicate about 50ns overhead of adding
>> queueing to the xdp_fwd example (last patch), which translates to a 20% =
PPS
>> overhead (but still 2x the forwarding performance of the netstack):
>>
>> xdp_fwd :     4.7 Mpps  (213 ns /pkt)
>> xdp_fwd -Q:   3.8 Mpps  (263 ns /pkt)
>> netstack:       2 Mpps  (500 ns /pkt)
>>
>> RELATION TO BPF QDISC
>>
>> Cong Wang's BPF qdisc patches[2] share some aspects of this series, in
>> particular the use of a map to store packets. This is no accident, as we=
've
>> had ongoing discussions for a while now. I have no great hope that we can
>> completely converge the two efforts into a single BPF-based queueing
>> API (as has been discussed before[3], consolidating the SKB and XDP paths
>> is challenging). Rather, I'm hoping that we can converge the designs eno=
ugh
>> that we can share BPF code between XDP and qdisc layers using common
>> functions, like it's possible to do with XDP and TC-BPF today. This would
>> imply agreeing on the map type and API, and possibly on the set of helpe=
rs
>> available to the BPF programs.
>
> What would be the big difference for the map wrt xdp_frame vs sk_buff
> excluding all obvious stuff like locking/refcnt?

I expect it would be quite straight-forward to just add a second subtype
of the PIFO map in this series that holds skbs. In fact, I think that
from the BPF side, the whole model implemented here would be possible to
carry over to the qdisc layer more or less wholesale. Some other
features of the qdisc layer, like locking, classes, and
multi-CPU/multi-queue management may be trickier, but I'm not sure how
much of that we should expose in a BPF qdisc anyway (as you may have
noticed I commented on Cong's series to this effect regarding the
classful qdiscs).

>> PATCH STRUCTURE
>>
>> This series consists of a total of 17 patches, as follows:
>>
>> Patches 1-3 are smaller preparatory refactoring patches used by subseque=
nt
>> patches.
>
> Seems like these can go separately without holding the rest?

Yeah, guess so? They don't really provide much benefit without the users
alter in the series, though, so not sure there's much point in sending
them separately?

>> Patches 4-5 introduce the PIFO map type, and patch 6 introduces the dequ=
eue
>> program type.
>
> [...]
>
>> Patches 7-10 adds the dequeue helpers and the verifier features needed to
>> recognise packet pointers, reference count them, and allow dereferencing
>> them to obtain packet data pointers.
>
> Have you considered using kfuncs for these instead of introducing new
> hooks/contexts/etc?

I did, but I'm not sure it's such a good fit? In particular, the way the
direct packet access is implemented for dequeue programs (where you can
get an xdp_md pointer and deref that to get data and data_end pointers)
is done this way so programs can share utility functions between XDP and
dequeue programs. And having a new program type for the dequeue progs
seem like the obvious thing to do since they're doing something new?

Maybe I'm missing something, though; could you elaborate on how you'd
use kfuncs instead?

-Toke

