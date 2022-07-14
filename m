Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369015753FC
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbiGNRZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGNRZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:25:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5044599D9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:25:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f11so1006130plr.4
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=luNkTChAscIIt43BEbkh9kPKxaw5z6djoXOZpLmxUP4=;
        b=G2AX2KEqQLAaVaxPYkldqpyljQsi/HnzT+QXTIethgvfwZR8ts7udGZcLYgUUm9uH4
         feeN97A/+fT1hkJGZtf4VoVrV5s6woh+9Id9dDOqkOHr9uGn5cqVnfATr+Bx0FaF1O8w
         jNx03KO2IM6Kvvi4FeH+RUYYjTUKc3hYz87bpJKApqmxmuCTk4sWmxUoMKSRP13t5T8+
         dDh9CtWzRVEYLuttIPwsYI8awHdrmFvkdAqd9Ud9+jujmfUwjlpcLoWv0OuTmD2VHXjo
         vBAH6vAJzq8mQKM1GecyuqKYvy4ljQL0oA3IDFy7DGzsaBRBqUwWeHMIC8SN3317hXjb
         gz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=luNkTChAscIIt43BEbkh9kPKxaw5z6djoXOZpLmxUP4=;
        b=U+oQcCSiOFnlR3KjJ6yuS77lRsMNeZw6WYFs/DIN3N6YL5ey/5Iu10Neg2jywiv09c
         EmZiTM7wgT4pJVEx5DuHJzIekX93lseqJbXLHzZFgSGLgVaIcNxDfO/EFa2r8EVVgjVS
         +ahMrZga3hhBEok2avO1l/2ztFUOCezXgFQb1aT+NHGnm+GmqUZIyy0R9HUvlyTqeAAJ
         SlcziBNTaxfw8N0pfz3v/tBDusmSzw1F01sgSFwEMn5+04Y4NdgBWG3KpnjaSue2kJBR
         Abk7bTHqK3jF9D+bdjPAvpOT3FmHEnsC1C6eSgQGRTsm6uxUZsMA0vIQA2AuOM0jY9lt
         7rZg==
X-Gm-Message-State: AJIora9JlMFmETI/4pHk5S/meBwJsMwY1DWrBIfygVtflSuPpcoV5j6F
        76dtlNxtg/EJxq+I56h6mD2GbpL4rBVxEcart017Hw==
X-Google-Smtp-Source: AGRyM1vid9ky7VWXl+2X2TYH+xeH6ywn0Jz9aSBntK+2St5tgf/y8YRbBDT3A4ftrznr5i5rz2T0HLs3TtAlVvmg8b0=
X-Received: by 2002:a17:903:244d:b0:16c:5bfe:2e87 with SMTP id
 l13-20020a170903244d00b0016c5bfe2e87mr9412751pls.148.1657819506022; Thu, 14
 Jul 2022 10:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk> <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
 <87v8s0nf8h.fsf@toke.dk>
In-Reply-To: <87v8s0nf8h.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 Jul 2022 10:24:54 -0700
Message-ID: <CAKH8qBuLKfye8=jSrQPv_YLr7x8p-TTPmgB+eWUhM7H70hZ=aQ@mail.gmail.com>
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

On Thu, Jul 14, 2022 at 3:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Wed, Jul 13, 2022 at 2:52 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Packet forwarding is an important use case for XDP, which offers
> >> >> significant performance improvements compared to forwarding using t=
he
> >> >> regular networking stack. However, XDP currently offers no mechanis=
m to
> >> >> delay, queue or schedule packets, which limits the practical uses f=
or
> >> >> XDP-based forwarding to those where the capacity of input and outpu=
t links
> >> >> always match each other (i.e., no rate transitions or many-to-one
> >> >> forwarding). It also prevents an XDP-based router from doing any ki=
nd of
> >> >> traffic shaping or reordering to enforce policy.
> >> >>
> >> >> This series represents a first RFC of our attempt to remedy this la=
ck. The
> >> >> code in these patches is functional, but needs additional testing a=
nd
> >> >> polishing before being considered for merging. I'm posting it here =
as an
> >> >> RFC to get some early feedback on the API and overall design of the
> >> >> feature.
> >> >>
> >> >> DESIGN
> >> >>
> >> >> The design consists of three components: A new map type for storing=
 XDP
> >> >> frames, a new 'dequeue' program type that will run in the TX softir=
q to
> >> >> provide the stack with packets to transmit, and a set of helpers to=
 dequeue
> >> >> packets from the map, optionally drop them, and to schedule an inte=
rface
> >> >> for transmission.
> >> >>
> >> >> The new map type is modelled on the PIFO data structure proposed in=
 the
> >> >> literature[0][1]. It represents a priority queue where packets can =
be
> >> >> enqueued in any priority, but is always dequeued from the head. Fro=
m the
> >> >> XDP side, the map is simply used as a target for the bpf_redirect_m=
ap()
> >> >> helper, where the target index is the desired priority.
> >> >
> >> > I have the same question I asked on the series from Cong:
> >> > Any considerations for existing carousel/edt-like models?
> >>
> >> Well, the reason for the addition in patch 5 (continuously increasing
> >> priorities) is exactly to be able to implement EDT-like behaviour, whe=
re
> >> the priority is used as time units to clock out packets.
> >
> > Ah, ok, I didn't read the patches closely enough. I saw some limits
> > for the ranges and assumed that it wasn't capable of efficiently
> > storing 64-bit timestamps..
>
> The goal is definitely to support full 64-bit priorities. Right now you
> have to start out at 0 but can go on for a full 64 bits, but that's a
> bit of an API wart that I'd like to get rid of eventually...
>
> >> > Can we make the map flexible enough to implement different qdisc
> >> > policies?
> >>
> >> That's one of the things we want to be absolutely sure about. We are
> >> starting out with the PIFO map type because the literature makes a goo=
d
> >> case that it is flexible enough to implement all conceivable policies.
> >> The goal of the test harness linked as note [4] is to actually examine
> >> this; Frey is our PhD student working on this bit.
> >>
> >> Thus far we haven't hit any limitations on this, but we'll need to add
> >> more policies before we are done with this. Another consideration is
> >> performance, of course, so we're also planning to do a comparison with=
 a
> >> more traditional "bunch of FIFO queues" type data structure for at lea=
st
> >> a subset of the algorithms. Kartikeya also had an idea for an
> >> alternative way to implement a priority queue using (semi-)lockless
> >> skiplists, which may turn out to perform better.
> >>
> >> If there's any particular policy/algorithm you'd like to see included =
in
> >> this evaluation, please do let us know, BTW! :)
> >
> > I honestly am not sure what the bar for accepting this should be. But
> > on the Cong's series I mentioned Martin's CC bpf work as a great
> > example of what we should be trying to do for qdisc-like maps. Having
> > a bpf version of fq/fq_codel/whatever_other_complex_qdisc might be
> > very convincing :-)
>
> Just doing flow queueing is quite straight forward with PIFOs. We're
> working on fq_codel. Personally I also want to implement something that
> has feature parity with sch_cake (which includes every feature and the
> kitchen sink already) :)

Yeah, sch_cake works too =F0=9F=91=8D

> >> >> The dequeue program type is a new BPF program type that is attached=
 to an
> >> >> interface; when an interface is scheduled for transmission, the sta=
ck will
> >> >> execute the attached dequeue program and, if it returns a packet to
> >> >> transmit, that packet will be transmitted using the existing ndo_xd=
p_xmit()
> >> >> driver function.
> >> >>
> >> >> The dequeue program can obtain packets by pulling them out of a PIF=
O map
> >> >> using the new bpf_packet_dequeue() helper. This returns a pointer t=
o an
> >> >> xdp_md structure, which can be dereferenced to obtain packet data a=
nd
> >> >> data_meta pointers like in an XDP program. The returned packets are=
 also
> >> >> reference counted, meaning the verifier enforces that the dequeue p=
rogram
> >> >> either drops the packet (with the bpf_packet_drop() helper), or ret=
urns it
> >> >> for transmission. Finally, a helper is added that can be used to ac=
tually
> >> >> schedule an interface for transmission using the dequeue program ty=
pe; this
> >> >> helper can be called from both XDP and dequeue programs.
> >> >>
> >> >> PERFORMANCE
> >> >>
> >> >> Preliminary performance tests indicate about 50ns overhead of addin=
g
> >> >> queueing to the xdp_fwd example (last patch), which translates to a=
 20% PPS
> >> >> overhead (but still 2x the forwarding performance of the netstack):
> >> >>
> >> >> xdp_fwd :     4.7 Mpps  (213 ns /pkt)
> >> >> xdp_fwd -Q:   3.8 Mpps  (263 ns /pkt)
> >> >> netstack:       2 Mpps  (500 ns /pkt)
> >> >>
> >> >> RELATION TO BPF QDISC
> >> >>
> >> >> Cong Wang's BPF qdisc patches[2] share some aspects of this series,=
 in
> >> >> particular the use of a map to store packets. This is no accident, =
as we've
> >> >> had ongoing discussions for a while now. I have no great hope that =
we can
> >> >> completely converge the two efforts into a single BPF-based queuein=
g
> >> >> API (as has been discussed before[3], consolidating the SKB and XDP=
 paths
> >> >> is challenging). Rather, I'm hoping that we can converge the design=
s enough
> >> >> that we can share BPF code between XDP and qdisc layers using commo=
n
> >> >> functions, like it's possible to do with XDP and TC-BPF today. This=
 would
> >> >> imply agreeing on the map type and API, and possibly on the set of =
helpers
> >> >> available to the BPF programs.
> >> >
> >> > What would be the big difference for the map wrt xdp_frame vs sk_buf=
f
> >> > excluding all obvious stuff like locking/refcnt?
> >>
> >> I expect it would be quite straight-forward to just add a second subty=
pe
> >> of the PIFO map in this series that holds skbs. In fact, I think that
> >> from the BPF side, the whole model implemented here would be possible =
to
> >> carry over to the qdisc layer more or less wholesale. Some other
> >> features of the qdisc layer, like locking, classes, and
> >> multi-CPU/multi-queue management may be trickier, but I'm not sure how
> >> much of that we should expose in a BPF qdisc anyway (as you may have
> >> noticed I commented on Cong's series to this effect regarding the
> >> classful qdiscs).
> >
> > Maybe a related question here: with the way you do
> > BPF_MAP_TYPE_PIFO_GENERIC vs BPF_MAP_TYPE_PIFO_XDP, how hard it would
> > be have support for storing xdp_frames/skb in any map? Let's say we
> > have generic BPF_MAP_TYPE_RBTREE, where the key is
> > priority/timestamp/whatever, can we, based on the value's btf_id,
> > figure out the rest? (that the value is kernel structure and needs
> > special care and more constraints - can't be looked up from user space
> > and so on)
> >
> > Seems like we really need to have two special cases: where we transfer
> > ownership of xdp_frame/skb to/from the map, any other big
> > complications?
> >
> > That way we can maybe untangle the series a bit: we can talk about
> > efficient data structures for storing frames/skbs independently of
> > some generic support for storing them in the maps. Any major
> > complications with that approach?
>
> I've had discussions with Kartikeya on this already (based on his 'kptr
> in map' work). That may well end up being feasible, which would be
> fantastic. The reason we didn't use it for this series is that there's
> still some work to do on the generic verifier/infrastructure support
> side of this (the PIFO map is the oldest part of this series), and I
> didn't want to hold up the rest of the queueing work until that landed.

Yes, exactly, kptr seems like a very promising thing that you can leverage.
I'm looking forward to it!

> Now that we have a functional prototype I expect that iterating on the
> data structure will be the next step. One complication with XDP is that
> we probably want to keep using XDP_REDIRECT to place packets into the
> map because that gets us bulking which is important for performance;
> however, in general I like the idea of using BTF to designate the map
> value type, and if we can figure out a way to make it completely generic
> even for packets I'm all for that! :)

As long as we have generic kptr-based-skb-capable-maps and can
add/remove/lookup skbs using existing helpers it seems fine to have
XDP_REDIRECT as some kind of xdp-specific optimization.

> >> >> PATCH STRUCTURE
> >> >>
> >> >> This series consists of a total of 17 patches, as follows:
> >> >>
> >> >> Patches 1-3 are smaller preparatory refactoring patches used by sub=
sequent
> >> >> patches.
> >> >
> >> > Seems like these can go separately without holding the rest?
> >>
> >> Yeah, guess so? They don't really provide much benefit without the use=
rs
> >> alter in the series, though, so not sure there's much point in sending
> >> them separately?
> >>
> >> >> Patches 4-5 introduce the PIFO map type, and patch 6 introduces the=
 dequeue
> >> >> program type.
> >> >
> >> > [...]
> >> >
> >> >> Patches 7-10 adds the dequeue helpers and the verifier features nee=
ded to
> >> >> recognise packet pointers, reference count them, and allow derefere=
ncing
> >> >> them to obtain packet data pointers.
> >> >
> >> > Have you considered using kfuncs for these instead of introducing ne=
w
> >> > hooks/contexts/etc?
> >>
> >> I did, but I'm not sure it's such a good fit? In particular, the way t=
he
> >> direct packet access is implemented for dequeue programs (where you ca=
n
> >> get an xdp_md pointer and deref that to get data and data_end pointers=
)
> >> is done this way so programs can share utility functions between XDP a=
nd
> >> dequeue programs. And having a new program type for the dequeue progs
> >> seem like the obvious thing to do since they're doing something new?
> >>
> >> Maybe I'm missing something, though; could you elaborate on how you'd
> >> use kfuncs instead?
> >
> > I was thinking about the approach in general. In networking bpf, we've
> > been adding new program types, new contexts and new explicit hooks.
> > This all requires a ton of boiler plate (converting from uapi ctx to
> > the kernel, exposing hook points, etc, etc). And looking at Benjamin's
> > HID series, it's so much more elegant: there is no uapi, just kernel
> > function that allows it to be overridden and a bunch of kfuncs
> > exposed. No uapi, no helpers, no fake contexts.
> >
> > For networking and xdp the ship might have sailed, but I was wondering
> > whether we should be still stuck in that 'old' boilerplate world or we
> > have a chance to use new nice shiny things :-)
> >
> > (but it might be all moot if we'd like to have stable upis?)
>
> Right, I see what you mean. My immediate feeling is that having an
> explicit stable UAPI for XDP has served us well. We do all kinds of
> rewrite tricks behind the scenes (things like switching between xdp_buff
> and xdp_frame, bulking, direct packet access, reading ifindexes by
> pointer walking txq->dev, etc) which are important ways to improve
> performance without exposing too many nitty-gritty details into the API.
>
> There's also consistency to consider: I think the addition of queueing
> should work as a natural extension of the existing programming model for
> XDP. So I feel like this is more a case of "if we were starting from
> scratch today we might do things differently (like the HID series), but
> when extending things let's keep it consistent"?

Agreed. If we want to have the ability to inspect/change xdp/skb in
your new dequeue hooks, we might need to keep that fake xdp_buff for
consistency :-(
