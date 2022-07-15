Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD982575FCE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiGOLLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGOLLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:11:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F6987209;
        Fri, 15 Jul 2022 04:11:15 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so11239539pjo.3;
        Fri, 15 Jul 2022 04:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BG9YvC3BwrTAgLXPXrej1WPHud5fipPH0Cx+IwE2jfA=;
        b=i6Px+ViOnCMP9eUExdKaz8dt2Zig5nTm0ixHQLEyGg9Lz77UO2wzZzs6fTCER4Kcnz
         i5U9TVTssrtd9qGpvFScIEZ8i14w8iUzD3Rnz9O040xVTlDTdqKQVtKMEQ4SiW9LJGTF
         mxzYXLwxF8JNw6S41JtYmESd7BO+jwEJpsOhMveMNvLTa1akrK+XhkGikqZMCtMR5Bt4
         4pQNcU0M+XAAbiD5vzTOFgs++eVGbnBFvy/Mwt4Sv3AseHAJQcY+5WsnOdN5/WzbQnx/
         AWeKg29w1ng1EqYxhRNTMzYZ1/rl9X1mZS5UdJbV2Ow/sW7hUrlPmQ2ItMPGVliki+cH
         28Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BG9YvC3BwrTAgLXPXrej1WPHud5fipPH0Cx+IwE2jfA=;
        b=frOraTuYnhAbK/K196jQ90JRiPjxpDWnkvjaJP01c3u2j7rRPJ3kyWxBs7e6uc+KhC
         efGdlc7J/S5Y6IMQRZUzJab6NP8CIJKKQrkwlGctZKFXOQKJmCGMKcHvjspCHGCkYrJb
         eVLyaMt1cfd8DMJppzaF8Q/tt1+33CBL8+1XuszLyIckPNmjqK9sgQEy2l8ehLdZ73hs
         rWPDBwKTdFLguaoiDJr1BN/qWlSX0pGq0uOCUXDgcy8F+Dmt+r8ZE3tbun9jz5VvTuxi
         zrw9ZrF028fbBr+PVuG0O4exgCmzMUOz9Ep/XWe8xCG7PWKzk7Xk1pR+rf+qAgQ2AZ2z
         JTHg==
X-Gm-Message-State: AJIora8QdLcFotq2WgqCGdRSVU/5GLCF5EZZd04c8aIw0k1UDBj2YDJt
        PyX7Kpi8Yy/RmwUL/5ZFZKPeE4dm/lJvazFofAs=
X-Google-Smtp-Source: AGRyM1vwCDdYfNbWsvXniDg+41xlT8lT9N0CC5p9jm8DkzI+RL6GvYFcdtAqW5W3wRkPSjrn+Xyw7lfEeHdhtZ75+9A=
X-Received: by 2002:a17:902:8508:b0:16c:46ff:53cb with SMTP id
 bj8-20020a170902850800b0016c46ff53cbmr13017271plb.168.1657883474509; Fri, 15
 Jul 2022 04:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com> <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com> <87pmij75r1.fsf@toke.dk>
 <20220706135023.1464979-1-alexandr.lobakin@intel.com> <87edyxaks0.fsf@toke.dk>
 <CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com> <bea0164c-53dc-efc7-27f3-d1a1b799d880@redhat.com>
In-Reply-To: <bea0164c-53dc-efc7-27f3-d1a1b799d880@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 15 Jul 2022 13:11:03 +0200
Message-ID: <CAJ8uoz0yZm_b0BW5dR=yMh9m1oXR-qEQ+5LDMoN2NEXu_sXPFg@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 4:15 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 12/07/2022 12.33, Magnus Karlsson wrote:
> > On Thu, Jul 7, 2022 at 1:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> >>
> >>> From: Toke H??iland-J??rgensen <toke@redhat.com>
> >>> Date: Tue, 05 Jul 2022 20:51:14 +0200
> >>>
> >>>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> >>>>
> >>>> [... snipping a bit of context here ...]
> >>>>
> >>>>>>>> Yeah, I'd agree this kind of configuration is something that can=
 be
> >>>>>>>> added later, and also it's sort of orthogonal to the consumption=
 of the
> >>>>>>>> metadata itself.
> >>>>>>>>
> >>>>>>>> Also, tying this configuration into the loading of an XDP progra=
m is a
> >>>>>>>> terrible interface: these are hardware configuration options, le=
t's just
> >>>>>>>> put them into ethtool or 'ip link' like any other piece of devic=
e
> >>>>>>>> configuration.
> >>>>>>>
> >>>>>>> I don't believe it fits there, especially Ethtool. Ethtool is for
> >>>>>>> hardware configuration, XDP/AF_XDP is 95% software stuff (apart f=
rom
> >>>>>>> offload bits which is purely NFP's for now).
> >>>>>>
> >>>>>> But XDP-hints is about consuming hardware features. When you're
> >>>>>> configuring which metadata items you want, you're saying "please p=
rovide
> >>>>>> me with these (hardware) features". So ethtool is an excellent pla=
ce to
> >>>>>> do that :)
> >>>>>
> >>>>> With Ethtool you configure the hardware, e.g. it won't strip VLAN
> >>>>> tags if you disable rx-cvlan-stripping. With configuring metadata
> >>>>> you only tell what you want to see there, don't you?
> >>>>
> >>>> Ah, I think we may be getting closer to identifying the disconnect
> >>>> between our way of thinking about this!
> >>>>
> >>>> In my mind, there's no separate "configuration of the metadata" step=
.
> >>>> You simply tell the hardware what features you want (say, "enable
> >>>> timestamps and VLAN offload"), and the driver will then provide the
> >>>> information related to these features in the metadata area
> >>>> unconditionally. All XDP hints is about, then, is a way for the driv=
er
> >>>> to inform the rest of the system how that information is actually la=
id
> >>>> out in the metadata area.
> >>>>
> >>>> Having a separate configuration knob to tell the driver "please lay =
out
> >>>> these particular bits of metadata this way" seems like a totally
> >>>> unnecessary (and quite complicated) feature to have when we can just=
 let
> >>>> the driver decide and use CO-RE to consume it?
> >>>
> >>> Magnus (he's currently on vacation) told me it would be useful for
> >>> AF_XDP to enable/disable particular metadata, at least from perf
> >>> perspective. Let's say, just fetching of one "checksum ok" bit in
> >>> the driver is faster than walking through all the descriptor words
> >>> and driver logics (i.e. there's several hundred locs in ice which
> >>> just parse descriptor data and build an skb or metadata from it).
> >>> But if we would just enable/disable corresponding features through
> >>> Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
> >>> what if I want to have only RSS hash in the metadata (and don't
> >>> want to spend cycles on parsing the rest), but at the same time
> >>> still want skb path to have checksum status to not die at CPU
> >>> checksum calculation?
> >>
> >> Hmm, so this feels a little like a driver-specific optimisation? I.e.,
> >> my guess is that not all drivers have a measurable overhead for pullin=
g
> >> out the metadata. Also, once the XDP metadata bits are in place, we ca=
n
> >> move in the direction of building SKBs from the same source, so I'm no=
t
> >> sure it's a good idea to assume that the XDP metadata is separate from
> >> what the stack consumes...
> >>
> >> In any case, if such an optimisation does turn out to be useful, we ca=
n
> >> add it later (backed by rigorous benchmarks, of course), so I think we
> >> can still start with the simple case and iterate from there?
> >
> > Just to check if my intuition was correct or not I ran some benchmarks
> > around this. I ported Jesper's patch set to the zero-copy driver of
> > i40e, which was really simple thanks to Jesper's refactoring. One line
> > of code added to the data path of the zc driver and making
> > i40e_process_xdp_hints() a global function so it can be reached from
> > the zc driver.
>
> Happy to hear it was simple to extend this to AF_XDP in the driver.
> Code design wise I'm trying to keep it simple for drivers to add this.
> I have a co-worker that have already extended ixgbe.
>
> > I also moved the prefetch Jesper added to after the
> > check if xdp_hints are available since it really degrades performance
> > in the xdp_hints off case.
>
> Good to know.
>
> > First number is the throughput change with hints on, and the second
> > number is with hints off. All are compared to the performance without
> > Jesper's patch set applied. The application is xdpsock -r (which used
> > to be part of the samples/bpf directory).
>
> For reviewer to relate to these numbers we need to understand/explain
> the extreme numbers we are dealing with.  In my system with i40e and
> xdpsock --rx-drop I can AF_XDP drop packets with a rate of 33.633.761 pps=
.
>
> This corresponds to a processing time per packet: 29.7 ns (nanosec)
>   - Calc: (1/33633761)*10^9
>
> > Copy mode with all hints: -21% / -2%

On my system, the overhead is 66 cycles/packet or 31 ns/packet (2.1
GHz CPU with TurboBoost disabled). Copy-mode only drops packets at a
rate of 8.5 Mpps or 118 ns/packet on my system. The rate you quote
must be for zero-copy as I see something similar there if I enable
TurboBoost on my system.

> The -21% for enabling all hints does sound like an excessive overhead,
> but time-wise this is a reduction/overhead of 6.2 ns.
>
> The real question: Is this 6.2 ns overhead that gives us e.g.
> RX-checksumming lower than the gain we can obtain from avoiding doin.
> RX-checksumming in software?
>   - A: My previous experiments conclude[1] that for 1500 bytes frames we
>     can save 54 ns (or increase performance with 8% for normal netstack).

If you use Rx-checksumming alone, it is a good idea for packets that
are bigger than something around 500 bytes, if you use copy mode. This
is a very rough estimation since I cannot mix your numbers with mine.
But there is a substantial window where it pays off for sure. For ZC,
this window is even larger, see below.

>
> I was going for zero overhead when disabling xdp-hints, which is almost
> true as the -2% is time-wise a reduction/overhead of 0.59 ns.
>
>   [1]
> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_fra=
me01_checksum.org#measurements-compare-results--conclusion
>
>
> > Zero-copy mode with all hints: -29% / -9%
>
> I'm unsure why the percentages increase here, perhaps because zero-copy
> is faster and thus the overhead becomes a larger percentage?

For zero-copy, the overhead is 31 cycles/packet or 15 ns/packet on my
system. I would have expected the cycles/packet overhead for copy-mode
and zero-copy mode to be about the same since they use the same hints
code, but it is roughly half for zero-copy. Have not examined why. The
packet processing time without your patches on my system is 36
ns/packet or 27.65 Mpps for zero-copy.

>
> > Copy mode rx timestamp only (the rest removed with an #if 0): -11%
> > Zero-copy mode rx timestamp only: -20%
> >
> > So, if you only want rx timestamp, but can only enable every hint or
> > nothing, then you get a 10% performance degradation with copy mode and
> > 9% with zero-copy mode compared to if you were able just to enable rx
> > timestamp alone. With these rough numbers (a real implementation would
> > not have an #if 0) I would say it matters, but that does not mean we
> > should not start simple and just have a big switch to start with. But
> > as we add hints (to the same btfid), this will just get worse.
>
> IMHO we *do* already have individual enable/disable hints features via
> ethtool.
> Have you tried to use the individual ethtool switches. e.g.:
>
>   ethtool -K i40e2 rx-checksumming off
>
> The i40e code uses bitfields for extracting the descriptor, which cause
> code that isn't optimal or fully optimized by the compiler.  On my setup
> I gained 4.2% (or 1.24 ns) by doing this.

Forgot about that one. Will replace the bitfields and rerun the
experiments to get the overhead down.

>
> > Here are some other numbers I got, in case someone is interested. They
> > are XDP numbers from xdp_rxq_info in samples/bpf.
> >
> > hints on / hints off
> > XDP_DROP: -18% / -1.5%
>
> My xdp_rxq_info (no-touch XDP_DROP) nanosec numbers are:
>
>            hints on / hints off
>   XDP_DROP: 35.97ns / 29.80ns  (diff 6.17 ns)
>
> Maybe interesting if I touch data (via option --read), then the overhead
> is reduced to 4.84 ns.

Good point. We should always touch the data. Will include that in the
next set of experiments.

> --Jesper
>
> > XDP_TX: -10% / -2.5%
> >
> >>>>>>> I follow that way:
> >>>>>>>
> >>>>>>> 1) you pick a program you want to attach;
> >>>>>>> 2) usually they are written for special needs and usecases;
> >>>>>>> 3) so most likely that program will be tied with metadata/driver/=
etc
> >>>>>>>     in some way;
> >>>>>>> 4) so you want to enable Hints of a particular format primarily f=
or
> >>>>>>>     this program and usecase, same with threshold and everything
> >>>>>>>     else.
> >>>>>>>
> >>>>>>> Pls explain how you see it, I might be wrong for sure.
> >>>>>>
> >>>>>> As above: XDP hints is about giving XDP programs (and AF_XDP consu=
mers)
> >>>>>> access to metadata that is not currently available. Tying the life=
time
> >>>>>> of that hardware configuration (i.e., which information to provide=
) to
> >>>>>> the lifetime of an XDP program is not a good interface: for one th=
ing,
> >>>>>> how will it handle multiple programs? What about when XDP is not u=
sed at
> >>>>>
> >>>>> Multiple progs is stuff I didn't cover, but will do later (as you
> >>>>> all say to me, "let's start with something simple" :)). Aaaand
> >>>>> multiple XDP progs (I'm not talking about attaching progs in
> >>>>> differeng modes) is not a kernel feature, rather a libpf feature,
> >>>>> so I believe it should be handled there later...
> >>>>
> >>>> Right, but even if we don't *implement* it straight away we still ne=
ed
> >>>> to take it into consideration in the design. And expecting libxdp to
> >>>> arbitrate between different XDP programs' metadata formats sounds li=
ke a
> >>>> royal PITA :)
> >>>>
> >>>>>> all but you still want to configure the same features?
> >>>>>
> >>>>> What's the point of configuring metadata when there are no progs
> >>>>> attached? To configure it once and not on every prog attach? I'm
> >>>>> not saying I don't like it, just want to clarify.
> >>>>
> >>>> See above: you turn on the features because you want the stack to
> >>>> consume them.
> >>>>
> >>>>> Maybe I need opinions from some more people, just to have an
> >>>>> overview of how most of folks see it and would like to configure
> >>>>> it. 'Cause I heard from at least one of the consumers that
> >>>>> libpf API is a perfect place for Hints to him :)
> >>>>
> >>>> Well, as a program author who wants to consume hints, you'd use
> >>>> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
> >>>> macros)...
> >>>>
> >>>>>> In addition, in every other case where we do dynamic data access (=
with
> >>>>>> CO-RE) the BPF program is a consumer that modifies itself to acces=
s the
> >>>>>> data provided by the kernel. I get that this is harder to achieve =
for
> >>>>>> AF_XDP, but then let's solve that instead of making a totally
> >>>>>> inconsistent interface for XDP.
> >>>>>
> >>>>> I also see CO-RE more fitting and convenient way to use them, but
> >>>>> didn't manage to solve two things:
> >>>>>
> >>>>> 1) AF_XDP programs, so what to do with them? Prepare patches for
> >>>>>     LLVM to make it able to do CO-RE on AF_XDP program load? Or
> >>>>>     just hardcode them for particular usecases and NICs? What about
> >>>>>     "general-purpose" programs?
> >>>>
> >>>> You provide a library to read the fields. Jesper actually already
> >>>> implemented this, did you look at his code?
> >>>>
> >>>> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-inter=
action
> >>>>
> >>>> It basically builds a lookup table at load-time using BTF informatio=
n
> >>>> from the kernel, keyed on BTF ID and field name, resolving them into
> >>>> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
> >>>> close and can be improved upon (CO-RE for userspace being one way of
> >>>> doing that).
> >>>
> >>> Aaaah, sorry, I completely missed that. I thought of something
> >>> similar as well, but then thought "variable field offsets, that
> >>> would annihilate optimization and performance", and our Xsk team
> >>> is super concerned about performance hits when using Hints.
> >>>
> >>>>
> >>>>>     And if hardcode, what's the point then to do Generic Hints at
> >>>>>     all? Then all it needs is making driver building some meta in
> >>>>>     front of frames via on-off button and that's it? Why BTF ID in
> >>>>>     the meta then if consumers will access meta hardcoded (via CO-R=
E
> >>>>>     or literally hardcoded, doesn't matter)?
> >>>>
> >>>> You're quite right, we could probably implement all the access to
> >>>> existing (fixed) metadata without using any BTF at all - just define=
 a
> >>>> common struct and some flags to designate which fields are set. In m=
y
> >>>> mind, there are a couple of reasons for going the BTF route instead:
> >>>>
> >>>> - We can leverage CO-RE to get close to optimal efficiency in field
> >>>>    access.
> >>>>
> >>>> and, more importantly:
> >>>>
> >>>> - It's infinitely extensible. With the infrastructure in place to ma=
ke
> >>>>    it really easy to consume metadata described by BTF, we lower the=
 bar
> >>>>    for future innovation in hardware offloads. Both for just adding =
new
> >>>>    fixed-function stuff to hardware, but especially for fully
> >>>>    programmable hardware.
> >>>
> >>> Agree :) That libxdp lookup translator fixed lots of stuff in my
> >>> mind.
> >>
> >> Great! Looks like we're slowly converging towards a shared
> >> understanding, then! :)
> >>
> >>>>> 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
> >>>>>     generic metadata structure they won't be able to benefit from
> >>>>>     Hints. But I guess we still need to provide kernel with meta?
> >>>>>     Or no?
> >>>>
> >>>> In the short term, I think the "generic structure" approach is fine =
for
> >>>> leveraging this in the stack. Both your and Jesper's series include
> >>>> this, and I think that's totally fine. Longer term, if it turns out =
to
> >>>> be useful to have something more dynamic for the stack consumption a=
s
> >>>> well, we could extend it to be CO-RE based as well (most likely by
> >>>> having the stack load a "translator" BPF program or something along
> >>>> those lines).
> >>>
> >>> Oh, that translator prog sounds nice BTW!
> >>
> >> Yeah, it's only a rough idea Jesper and I discussed at some point, but=
 I
> >> think it could have potential (see also point above re: making XDP hin=
ts
> >> *the* source of metadata for the whole stack; wouldn't it be nice if
> >> drivers didn't have to deal with the intricacies of assembling SKBs?).
> >>
> >> -Toke
> >>
> >
>
