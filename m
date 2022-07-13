Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6C573FC6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiGMW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGMW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:56:25 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8EB4F666
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:56:22 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31c89653790so473347b3.13
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pOCQS5wERAHihGyDvQZgzh6PVGRQ/LMAOBCenB1Ba+E=;
        b=EzpVrxxNAZ/lc1RUWSakEWwGYe5UdYEAIjUC+CQW2nOSsT6/+fP4UyRelPnquqUlj2
         +iSDeYo0a8+9GdrEY9Lz5wxEFj1EOIS1W5d58ZZb1km6SmUJKFmk9paQX8061XP88M7g
         dfVO5cTfyYyMgAnS1OQT+nnIpn1LmGClr7Cog7KhpsLWkWsBZLRBtL1eh3IhRyytmhRA
         Y/FLGHv1Oht+CZB15NHMqw5V7eXl8DKrIbAPCw3jxmP9r3HXAjpq/MwnsMJ8eChKOTNM
         Ya8nL4uvsekMA1HozaLHMlfL7rLmDO+1JLQJMaEz1tqvAWH40kLOgD3UaokqdGS0Rlxm
         BcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pOCQS5wERAHihGyDvQZgzh6PVGRQ/LMAOBCenB1Ba+E=;
        b=yP3GfI0vs4AHJbNiRJg8SltBpH9hPvw8XAElKltA4kkzO16znBfnbxBR0vfpW/eYxJ
         AnySwtj33liDqKuVchQK+g0HTZ8N9vV8BRZkW0lTCm1r5cGBrKczWnxD9P43FD0Sb4Rj
         6febUKVLrrdxrY7Ydb7VRTq4mzeM7UsCAG1FafLI264oOVTYeX5vpZ4B3LrBfmQF4Rik
         g8eAgKq9x6a+j1B1nWT5BDMxkfYMViXgTpQnBxdEnVnAfWaM2wLzc8vP3xEFnE4/GngL
         qxXwZfYjKYWXJjAHIKDcaTU+9gqNdS7CUNH+RV52cGLrGY6lZf/l2Ts51WgpVkTEJKSj
         JPuw==
X-Gm-Message-State: AJIora82RPJn7PhobPu+IhLN/2Z5lXOu5usHoLjC7yZFalymE8FzAhui
        5f7UiNHF7m5y0gwh4iCBvDZ8pxUbzpH9FphqQqHd2A==
X-Google-Smtp-Source: AGRyM1swflf9WjuXQkvuZmFc4ZobywPM1d01k5JQFfvy5jKyTHT/gMLPPE2ACcSyTeq24z8SrPljwGrjHg46DmC//w4=
X-Received: by 2002:a81:ecc:0:b0:31c:95a3:239c with SMTP id
 195-20020a810ecc000000b0031c95a3239cmr6942623ywo.81.1657752981435; Wed, 13
 Jul 2022 15:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
In-Reply-To: <877d4gpto8.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 13 Jul 2022 15:56:09 -0700
Message-ID: <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling capabilities
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 2:52 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Packet forwarding is an important use case for XDP, which offers
> >> significant performance improvements compared to forwarding using the
> >> regular networking stack. However, XDP currently offers no mechanism t=
o
> >> delay, queue or schedule packets, which limits the practical uses for
> >> XDP-based forwarding to those where the capacity of input and output l=
inks
> >> always match each other (i.e., no rate transitions or many-to-one
> >> forwarding). It also prevents an XDP-based router from doing any kind =
of
> >> traffic shaping or reordering to enforce policy.
> >>
> >> This series represents a first RFC of our attempt to remedy this lack.=
 The
> >> code in these patches is functional, but needs additional testing and
> >> polishing before being considered for merging. I'm posting it here as =
an
> >> RFC to get some early feedback on the API and overall design of the
> >> feature.
> >>
> >> DESIGN
> >>
> >> The design consists of three components: A new map type for storing XD=
P
> >> frames, a new 'dequeue' program type that will run in the TX softirq t=
o
> >> provide the stack with packets to transmit, and a set of helpers to de=
queue
> >> packets from the map, optionally drop them, and to schedule an interfa=
ce
> >> for transmission.
> >>
> >> The new map type is modelled on the PIFO data structure proposed in th=
e
> >> literature[0][1]. It represents a priority queue where packets can be
> >> enqueued in any priority, but is always dequeued from the head. From t=
he
> >> XDP side, the map is simply used as a target for the bpf_redirect_map(=
)
> >> helper, where the target index is the desired priority.
> >
> > I have the same question I asked on the series from Cong:
> > Any considerations for existing carousel/edt-like models?
>
> Well, the reason for the addition in patch 5 (continuously increasing
> priorities) is exactly to be able to implement EDT-like behaviour, where
> the priority is used as time units to clock out packets.

Ah, ok, I didn't read the patches closely enough. I saw some limits
for the ranges and assumed that it wasn't capable of efficiently
storing 64-bit timestamps..

> > Can we make the map flexible enough to implement different qdisc
> > policies?
>
> That's one of the things we want to be absolutely sure about. We are
> starting out with the PIFO map type because the literature makes a good
> case that it is flexible enough to implement all conceivable policies.
> The goal of the test harness linked as note [4] is to actually examine
> this; Frey is our PhD student working on this bit.
>
> Thus far we haven't hit any limitations on this, but we'll need to add
> more policies before we are done with this. Another consideration is
> performance, of course, so we're also planning to do a comparison with a
> more traditional "bunch of FIFO queues" type data structure for at least
> a subset of the algorithms. Kartikeya also had an idea for an
> alternative way to implement a priority queue using (semi-)lockless
> skiplists, which may turn out to perform better.
>
> If there's any particular policy/algorithm you'd like to see included in
> this evaluation, please do let us know, BTW! :)

I honestly am not sure what the bar for accepting this should be. But
on the Cong's series I mentioned Martin's CC bpf work as a great
example of what we should be trying to do for qdisc-like maps. Having
a bpf version of fq/fq_codel/whatever_other_complex_qdisc might be
very convincing :-)

> >> The dequeue program type is a new BPF program type that is attached to=
 an
> >> interface; when an interface is scheduled for transmission, the stack =
will
> >> execute the attached dequeue program and, if it returns a packet to
> >> transmit, that packet will be transmitted using the existing ndo_xdp_x=
mit()
> >> driver function.
> >>
> >> The dequeue program can obtain packets by pulling them out of a PIFO m=
ap
> >> using the new bpf_packet_dequeue() helper. This returns a pointer to a=
n
> >> xdp_md structure, which can be dereferenced to obtain packet data and
> >> data_meta pointers like in an XDP program. The returned packets are al=
so
> >> reference counted, meaning the verifier enforces that the dequeue prog=
ram
> >> either drops the packet (with the bpf_packet_drop() helper), or return=
s it
> >> for transmission. Finally, a helper is added that can be used to actua=
lly
> >> schedule an interface for transmission using the dequeue program type;=
 this
> >> helper can be called from both XDP and dequeue programs.
> >>
> >> PERFORMANCE
> >>
> >> Preliminary performance tests indicate about 50ns overhead of adding
> >> queueing to the xdp_fwd example (last patch), which translates to a 20=
% PPS
> >> overhead (but still 2x the forwarding performance of the netstack):
> >>
> >> xdp_fwd :     4.7 Mpps  (213 ns /pkt)
> >> xdp_fwd -Q:   3.8 Mpps  (263 ns /pkt)
> >> netstack:       2 Mpps  (500 ns /pkt)
> >>
> >> RELATION TO BPF QDISC
> >>
> >> Cong Wang's BPF qdisc patches[2] share some aspects of this series, in
> >> particular the use of a map to store packets. This is no accident, as =
we've
> >> had ongoing discussions for a while now. I have no great hope that we =
can
> >> completely converge the two efforts into a single BPF-based queueing
> >> API (as has been discussed before[3], consolidating the SKB and XDP pa=
ths
> >> is challenging). Rather, I'm hoping that we can converge the designs e=
nough
> >> that we can share BPF code between XDP and qdisc layers using common
> >> functions, like it's possible to do with XDP and TC-BPF today. This wo=
uld
> >> imply agreeing on the map type and API, and possibly on the set of hel=
pers
> >> available to the BPF programs.
> >
> > What would be the big difference for the map wrt xdp_frame vs sk_buff
> > excluding all obvious stuff like locking/refcnt?
>
> I expect it would be quite straight-forward to just add a second subtype
> of the PIFO map in this series that holds skbs. In fact, I think that
> from the BPF side, the whole model implemented here would be possible to
> carry over to the qdisc layer more or less wholesale. Some other
> features of the qdisc layer, like locking, classes, and
> multi-CPU/multi-queue management may be trickier, but I'm not sure how
> much of that we should expose in a BPF qdisc anyway (as you may have
> noticed I commented on Cong's series to this effect regarding the
> classful qdiscs).

Maybe a related question here: with the way you do
BPF_MAP_TYPE_PIFO_GENERIC vs BPF_MAP_TYPE_PIFO_XDP, how hard it would
be have support for storing xdp_frames/skb in any map? Let's say we
have generic BPF_MAP_TYPE_RBTREE, where the key is
priority/timestamp/whatever, can we, based on the value's btf_id,
figure out the rest? (that the value is kernel structure and needs
special care and more constraints - can't be looked up from user space
and so on)

Seems like we really need to have two special cases: where we transfer
ownership of xdp_frame/skb to/from the map, any other big
complications?

That way we can maybe untangle the series a bit: we can talk about
efficient data structures for storing frames/skbs independently of
some generic support for storing them in the maps. Any major
complications with that approach?

> >> PATCH STRUCTURE
> >>
> >> This series consists of a total of 17 patches, as follows:
> >>
> >> Patches 1-3 are smaller preparatory refactoring patches used by subseq=
uent
> >> patches.
> >
> > Seems like these can go separately without holding the rest?
>
> Yeah, guess so? They don't really provide much benefit without the users
> alter in the series, though, so not sure there's much point in sending
> them separately?
>
> >> Patches 4-5 introduce the PIFO map type, and patch 6 introduces the de=
queue
> >> program type.
> >
> > [...]
> >
> >> Patches 7-10 adds the dequeue helpers and the verifier features needed=
 to
> >> recognise packet pointers, reference count them, and allow dereferenci=
ng
> >> them to obtain packet data pointers.
> >
> > Have you considered using kfuncs for these instead of introducing new
> > hooks/contexts/etc?
>
> I did, but I'm not sure it's such a good fit? In particular, the way the
> direct packet access is implemented for dequeue programs (where you can
> get an xdp_md pointer and deref that to get data and data_end pointers)
> is done this way so programs can share utility functions between XDP and
> dequeue programs. And having a new program type for the dequeue progs
> seem like the obvious thing to do since they're doing something new?
>
> Maybe I'm missing something, though; could you elaborate on how you'd
> use kfuncs instead?

I was thinking about the approach in general. In networking bpf, we've
been adding new program types, new contexts and new explicit hooks.
This all requires a ton of boiler plate (converting from uapi ctx to
the kernel, exposing hook points, etc, etc). And looking at Benjamin's
HID series, it's so much more elegant: there is no uapi, just kernel
function that allows it to be overridden and a bunch of kfuncs
exposed. No uapi, no helpers, no fake contexts.

For networking and xdp the ship might have sailed, but I was wondering
whether we should be still stuck in that 'old' boilerplate world or we
have a chance to use new nice shiny things :-)

(but it might be all moot if we'd like to have stable upis?)
