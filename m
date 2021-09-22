Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6935741543E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhIVXx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhIVXx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 19:53:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA2C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 16:51:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z14-20020a17090a8b8e00b0019cc29ceef1so5696716pjn.1
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 16:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8avmft3mUKwFNxeAgsBeYRkIR688D9NXvmaLwN96+P0=;
        b=CJsC5H8/AKp+O0Ieh4nUIlBu+lYUV2GFp/nL+4lt3P7C82fSZVRm+xcdxqC4pr0PPo
         8FKxLmskLdsfvWCnrDJTt4GOb54G2WyqCJOD/qUpuVj/k7jZWo9E8OBehSJmkQdLmfjk
         cPHNcgCUJwT1IAz4M091Yt0ZIz7sf5q+O+/Td1ZNEPMBP/TF9Kxvzn67bSThsId/fQsY
         1IO4HGJqb/RbN7iwyizDneBhmg0U9Ne7NZokj9UhKMZjzhHK0T7DIyK2lFucRydbRDkJ
         D7K5j54enK/akRkEUcsYeu23b1tExm02a0OUyQnmqfIO9h/bq/bkOflN44fGL1f9NObd
         cDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8avmft3mUKwFNxeAgsBeYRkIR688D9NXvmaLwN96+P0=;
        b=ZdvO27hMYbxtAkgAxe/5nUvUlxmHdwBAY5wU0DdFzoo/w9+Icl3L9X0JdXkFmOANKY
         TFWDV3VeYvsmVznvkM/tZPGRaaVR/UOB5Fyyoe7RMcrcGs7MiWfbwSA5lUwdqLmAkQMZ
         kJlIBgr7LvGXr0VSW3R+LeJUeM4Jls0EfwsJi5xYwe2cBjNA6CQcRsoH791E6AhRTofY
         wk1mwFxfezVQP86MDvEqsmxEB+4KiKcu9eNdLuVpWof69lGq6gz63cSIXZDtUs7bcSQB
         qe5qHI1648aKNFGGNypXQY5SW3eMe2Pe9nwX4dlq9GNItyoUhAaGxACz5163TgkhiFfd
         t7TA==
X-Gm-Message-State: AOAM533e5UnNibQbHzfz4PVQUnpq2lHiHcwYQcS0pwmIzE/axFSdrun9
        o70SrlWFj25qd2H6aMLRl3UHMJ/OCHqPwyZiPiAvHg==
X-Google-Smtp-Source: ABdhPJwRsKbgoi8mf1NfhpTKBuYuENCPuDVAnCp7EWhWEhDVaRPnXraEEBnzyr5x+Me1IyKx2pp7s0tOp2Im5seSKDY=
X-Received: by 2002:a17:902:7103:b0:13d:c2d4:f0ef with SMTP id
 a3-20020a170902710300b0013dc2d4f0efmr1330378pll.32.1632354715522; Wed, 22 Sep
 2021 16:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho> <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com> <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com> <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
 <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch>
In-Reply-To: <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 16:51:44 -0700
Message-ID: <CAOuuhY_Z63qeWhJpqbvXyk3pK+sc5=7MfOpMju94pSjtsqyuOg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 2:41 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Tom Herbert wrote:
> > On Wed, Sep 22, 2021 at 11:00 AM Simon Horman <simon.horman@corigine.com> wrote:
> > >
> > > On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> > > > On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> > > > >
> > > > > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > > > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > > > >
> > > > > > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > > > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > > > > ><felipe@sipanda.io> wrote:
> > > > > > > >>
> > > > > > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > > > > > >> and introduces a developer friendly highly maintainable approach to
> > > > > > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > > > > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > > > > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > > > > > >> classifier is called "flower2". The control semantics of flower are
> > > > > > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > > > > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > > > > > >> other than replacing the user space tc commands with "flower2"  the
> > > > > > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > > > > > >> show a simple use case of the issues described in [2] when flower
> > > > > > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > > > > > >> model for network datapaths, this is described in
> > > > > > > >> https://github.com/panda-net/panda.
> > > > > > > >
> > > > > > > >My only concern is that is there any way to reuse flower code instead
> > > > > > > >of duplicating most of them? Especially when you specifically mentioned
> > > > > > > >flower2 has the same user-space syntax as flower, this makes code
> > > > > > > >reusing more reasonable.
> > > > > > >
> > > > > > > Exactly. I believe it is wrong to introduce new classifier which would
> > > > > > > basically behave exacly the same as flower, only has different parser
> > > > > > > implementation under the hood.
> > > > > > >
> > > > > > > Could you please explore the possibility to replace flow_dissector by
> > > > > > > your dissector optionally at first (kernel config for example)? And I'm
> > > > > > > not talking only about flower, but about the rest of the flow_dissector
> > > > > > > users too.
> > > > >
> > > > > +1
>
> Does the existing BPF flow dissector not work for some reason? If its purely
> a hardware mapping problem, couple questions below.

Hi John,

eBPF in its current form is un-acceleratable is a primary problem,
however an eBPF flow dissector would still have the same issues in
complexity and manageability that the kernel flow dissector. PANDA
pretty much can address that since the same source code for flow
dissector used in tc-flower could be compiled into eBPF and used with
TC (that gives extensibility at some incremental performance
degradation). There is an interesting caveat there in that to satisfy
verifier we had to break up the parser to avoid being flagged for
complexity. The parser code however already started with a restricted
structure that enforces rules that prevent the issues the verified is
checking for, when we get to verifier though it doesn't have any that
context and hence views it as general purpose code. Introducing domain
specific constructs into eBPF, like the byte code I mentioned, would
simplify the verifier in that case.

> > > > >
> > > > > > Hi Jiri,
> > > > > >
> > > > > > Yes, the intent is to replace flow dissector with a parser that is
> > > > > > more extensible, more manageable and can be accelerated in hardware
> > > > > > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > > > > > presentation on this topic at the last Netdev conf:
> > > > > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > > > > > with a kernel config is a good idea.
> > > > >
> > > > > Can we drop hyperbole? There are several examples of hardware that
> > > > > offload (a subset of) flower. That the current kernel implementation has
> > > > > the properties you describe is pretty much irrelevant for current hw
> > > > > offload use-cases.
> > > >
> > > > Simon,
> > > >
> > > > "current hw offload use-cases" is the problem; these models offer no
> > > > extensibility. For instance, if a new protocol appears or a user wants
> > > > to support their own custom protocol in things like tc-flower there is
> > > > no feasible way to do this. Unfortunately, as of today it seems, we
> > > > are still bound by the marketing department at hardware vendors that
> > > > pick and choose the protocols that they think their customers want and
> > > > are willing to invest in-- we need to get past this once and for all!
> > > > IMO, what we need is a common way to extend the kernel, tc, and other
> > > > applications for new protocols and features, but also be able to apply
> > > > that method to extend to the hardware which is _offloading_ kernel
> > > > functionality which in this case is flow dissector. The technology is
> > > > there to do this as programmable NICs for instance are the rage, but
> > > > we do need to create common APIs to be able to do that. Note this
> > > > isn't just tc, but a whole space of features; for instance, XDP hints
> > > > is nice idea for the NIC to provide information about protocols in a
> > > > packet, but unless/until there is a way to program the device to pull
> > > > out arbitrary information that the user cares about like something
> > > > from their custom protocol, then it's very limited utility...
>
> Vendors have the ability to code up arbitrary hints today. They just
> haven't open sourced it or made it widely available. I don't see how

Vendors can do this, but can I do this as a user? If I have a custom
protocol can I write some code for that without calling my vendor and
can I use that with tc-flower offload as easily as any other protocol?
I believe this is what is needed.

> a 'tc' interface would help with this. I suspect most hardware could
> prepend hints or put other arbitrary data in the descriptor or elsewhere.
> The compelling reason to open source it is missing.

I'm not sure about that. It's not so much a question of the mechanisms
to convey the data (although being restricted to just a few bytes in a
receive descriptor for XDP Hints is an obvious limitation), the
problem is the generation of the hints themself. For instance, suppose
I want to extract the QUIC connection identifier as an XDP Hint? To do
this we would need the device to be able to parse in UDP payload and
extract the connection identifier. I don't believe that capability is
widespread yet, vendors have parsers but generally they have not made
them user programmable. And even if they did do that, then we need a
common interface to program that functionality-- proprietary APIs are
right out due to risk of vendor lockin. I imagine the P4 advocates
think they are the solution, but then we have to absorb the
maintenance cost of yet another domain specific language and P4 isn't
part of the kernel so it really isn't offloading kernel functionality.
This is the gap the PANDA fills.

>
> Then the flwo is fairly straight forward the XDP program reads the
> hints. Then if the rest of the stack needs this in the skb we have
> the hash and skb extensions.

Again that's the backend mechanism, the frontend problem is the
generation of the hints data itself.

>
> > >
> > > ... the NIC could run a BPF program if its programmable to that extent.
> > >
> > Simon,
> >
> > True, but that implies that the NIC would just be running code in one
> > CPU instead of another-- i.e., that is doing offload and not
> > acceleration. Hardware parses are more likely to be very specialized
> > and might look something like a parameterized FSM that runs 10x faster
> > than software in a CPU. In order to be able to accelerate, we need to
> > start with a parser representation that is more declarative than
>
> Agree, but I don't see how configuration of this hardware makes sense
> over 'tc'. This is likely to require compiler tools to generate the
> microcode or *CAM entries running on the hardware. Having 'tc' run
> a few link, add-header commands that can be converted into reconfigured
> hardware (thats not just a CPU on a NIC) seems like we will be asking
> a lot of firmware. Probably too much for my taste, fixing bugs in
> firmware is going to be harder then if vendors just give us the
> compiler tools to generate the parsing logic for their hardware.
>
> Show me the hardware that can create new parse trees using flower2,
> do they exist?

Working on it :-)

>
> If not the flow is like this,
>
>  0. build new parse graph and hardware logic using DSL (P4 or otherwise)
>  1. apply blob output from 0 onto hardware
>  2. build out flower2 graph
>  3. flower2 populates hardware but hardware already got it from 0?
>
> I'm missing the point here?
>
>
> > imperative. This is what PANDA provides, the user writes a parser in a
> > declarative representation (but still in C). Given the front end
> > representation is declarative, we can compile that to a type of byte
> > code that is digestible to instantiate a reasonably programmable
> > hardware parser. This fits well with eBPF where the byte code is
> > domain specific instructions to eBPF, so when the eBPF program runs
> > they can be JIT compiled into CPU instructions for running on the
> > host, but they can be given to driver that can translate or JIT
> > compile the byte code into their hardware parser (coud JIT compile to
> > P4 backend for instance).
>
> I'm not sure hardware exists that can or will take arbitrary 'tc'
> commands and build a graph of a new protocols? Also we already have
> a SW path for arbitrary flow parser with BPF so I see no reasons
> we need to support yet another one. Even PANDA could produce BPF
> codes for sofwtare and hardware codes to program the hardware so
> why is this needed?

Hardware parsers are not general purpose CPUs, but specialized engines
that expect input in a declarative representation of an annotated
parse graph that includes parameterized functions needed to determine
next protocol and length. If we compile PANDA parser, which is in
declarative representation, into eBPF then we've lost the structure
and essence of the problem so that we can't accelerate the parser in
specialized hardware. The alternative I'm suggesting is to extend eBPF
to include the declarative representation of the parser. So when the
program is downloaded to the kernel it can run in CPU by compiling to
host ISA, the kernel can then give the program to the device that in
turn can instantiate it in the hardware.

A critical aspect of this method also eliminates any sort of side
channel or kernel bypass to program the device, which means the device
programming is visible to the kernel hence there is no ambiguity as to
what the device is actually doing (this lack of transparency is why
protocol specific offloads like LRO have failed to get traction). This
visibility is necessary if we are ever to go beyond just getting a few
disposable hints from the device and are getting actual operational
data for the stack to consume (like accelerated TXDP where we can jump
straight to TCP receive processing routine from the driver because the
device was able to perform all the stateless TCP and IP processing
before giving the packet the host). Generally, I view this direction
as extending the boundary of the stack into the device.

Tom

>
> Also yes I saw the netdevconf but still missed the point Sorry.
>
> Thanks
> .John
