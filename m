Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D278415799
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 06:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhIWEgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 00:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbhIWEgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 00:36:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365F8C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 21:35:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w11so3162023plz.13
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 21:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=psPtPNwf7ECNFNtf6j4eIoxq481whvXG0AGvs++EU5E=;
        b=7WwHxpjdpn35jn9mTDMyF2g+6PRe8yt14dz/HrMgaEfFde/FXKpQ53M3Mi5Omlydhe
         hKiAhejtL+24s8ef76Oht/SVpJ/WJUn4wVKAupnTVHdf5gmITg04MCtV1PMUDe/mJBkH
         soC//hiI2tMh+abYN2rKf3i31twSwyg3+1cxBbXJcLkfcYS0B2uJUyKUnR0A8Zxm5sD6
         bRIlHpAtFunpjFbHygkyjSr8cCkRB7bB38QZWEqfF6hSJqoMAsFEL4rabW/377grzMLF
         9hbFB3O3wy4hjH/Li6bF+eMURBcnsKeI/g39q7JXw3on4qjQ3R0j8RcU5RFMO9ogYqDs
         Htbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=psPtPNwf7ECNFNtf6j4eIoxq481whvXG0AGvs++EU5E=;
        b=367ykRLdz1F85P72PkhBIu3DY9vBiIV7z2wuDylyV70Ljv/2Uc1shKwlN0tT1Gjx8b
         nn5IT4nU0ajzQqiI2c1BN+UzUQkrxt/oPPfi2OYgD9gLmtrS4WxJR7SlhNskwRsMrXpg
         1g8VYN09dNuSf6KZzcsdqv6E5u2SQmJDnT/sHWhEbXx73hMLOIvaeasH1sgNJ8AtN3jn
         UmgYQrx9ZJLwLt4YK3KX2uTbOlESTDpKSUvIBUOS3cWes6f9VcAGYWSpaEplp4bA1ycm
         2/4k2bk6nfYTh3ozCz+UI8YDjaI6Nrw28WnK1vfapMmtpsPF40Yw2Vz5aMn5pApR1eOO
         l8Kg==
X-Gm-Message-State: AOAM5308NUoH02afxVcY+wfIBRAk6izJkdi8M+h2L4YyMyJf5AlrpSgS
        ahkWrV8DcV9YB0RH6oGZaEjbgh4NyIZbgkTV3qWvSg==
X-Google-Smtp-Source: ABdhPJx4BknyxIKBDFq3un6U3pQL3sxDfD2pN1VW8CkYjm3UfSrZtpjTi+ZkvSc91/5fYFKb7LSJbPW/gnS0zdocF4U=
X-Received: by 2002:a17:90a:588f:: with SMTP id j15mr15648720pji.177.1632371709254;
 Wed, 22 Sep 2021 21:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev> <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho> <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com> <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com> <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
 <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch> <CAOuuhY_Z63qeWhJpqbvXyk3pK+sc5=7MfOpMju94pSjtsqyuOg@mail.gmail.com>
 <614bd85690919_b58b72085d@john-XPS-13-9370.notmuch> <CAOuuhY-ujF_EPm6qeHAfgs6O0_-yyfZLMryYx4pS=Yd1XLor+A@mail.gmail.com>
 <614bf3bc4850_b9b1a208e2@john-XPS-13-9370.notmuch>
In-Reply-To: <614bf3bc4850_b9b1a208e2@john-XPS-13-9370.notmuch>
From:   Tom Herbert <tom@sipanda.io>
Date:   Wed, 22 Sep 2021 21:34:58 -0700
Message-ID: <CAOuuhY-L7Y_V7kn9RjXD_YmhDKCfdh1cM7vB2F_cMBWEmt7pqw@mail.gmail.com>
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

On Wed, Sep 22, 2021 at 8:25 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Tom Herbert wrote:
> > On Wed, Sep 22, 2021, 6:29 PM John Fastabend <john.fastabend@gmail.com>
> > wrote:
> >
> > > Tom Herbert wrote:
> > > > On Wed, Sep 22, 2021 at 2:41 PM John Fastabend <john.fastabend@gmail.com>
> > > wrote:
> > > > >
> > > > > Tom Herbert wrote:
> > > > > > On Wed, Sep 22, 2021 at 11:00 AM Simon Horman <
> > > simon.horman@corigine.com> wrote:
> > > > > > >
> > > > > > > On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> > > > > > > > On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <
> > > simon.horman@corigine.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > > > > > > > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us>
> > > wrote:
> > > > > > > > > > >
> > > > > > > > > > > Wed, Sep 22, 2021 at 06:38:20AM CEST,
> > > xiyou.wangcong@gmail.com wrote:
> > > > > > > > > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > > > > > > > > ><felipe@sipanda.io> wrote:
> > > > > > > > > > > >>
> > > > > > > > > > > >> The PANDA parser, introduced in [1], addresses most of
> > > these problems
> > > > > > > > > > > >> and introduces a developer friendly highly maintainable
> > > approach to
> > > > > > > > > > > >> adding extensions to the parser. This RFC patch takes a
> > > known consumer
> > > > > > > > > > > >> of flow dissector - tc flower - and  shows how it could
> > > make use of
> > > > > > > > > > > >> the PANDA Parser by mostly cutnpaste of the flower
> > > code. The new
> > > > > > > > > > > >> classifier is called "flower2". The control semantics
> > > of flower are
> > > > > > > > > > > >> maintained but the flow dissector parser is replaced
> > > with a PANDA
> > > > > > > > > > > >> Parser. The iproute2 patch is sent separately - but
> > > you'll notice
> > > > > > > > > > > >> other than replacing the user space tc commands with
> > > "flower2"  the
> > > > > > > > > > > >> syntax is exactly the same. To illustrate the
> > > flexibility of PANDA we
> > > > > > > > > > > >> show a simple use case of the issues described in [2]
> > > when flower
> > > > > > > > > > > >> consumes PANDA. The PANDA Parser is part of the PANDA
> > > programming
> > > > > > > > > > > >> model for network datapaths, this is described in
> > > > > > > > > > > >> https://github.com/panda-net/panda.
> > > > > > > > > > > >
> > > > > > > > > > > >My only concern is that is there any way to reuse flower
> > > code instead
> > > > > > > > > > > >of duplicating most of them? Especially when you
> > > specifically mentioned
> > > > > > > > > > > >flower2 has the same user-space syntax as flower, this
> > > makes code
> > > > > > > > > > > >reusing more reasonable.
> > > > > > > > > > >
> > > > > > > > > > > Exactly. I believe it is wrong to introduce new classifier
> > > which would
> > > > > > > > > > > basically behave exacly the same as flower, only has
> > > different parser
> > > > > > > > > > > implementation under the hood.
> > > > > > > > > > >
> > > > > > > > > > > Could you please explore the possibility to replace
> > > flow_dissector by
> > > > > > > > > > > your dissector optionally at first (kernel config for
> > > example)? And I'm
> > > > > > > > > > > not talking only about flower, but about the rest of the
> > > flow_dissector
> > > > > > > > > > > users too.
> > > > > > > > >
> > > > > > > > > +1
> > > > >
> > > > > Does the existing BPF flow dissector not work for some reason? If its
> > > purely
> > > > > a hardware mapping problem, couple questions below.
> > > >
> > > > Hi John,
> > > >
> > > > eBPF in its current form is un-acceleratable is a primary problem,
> > >
> > > We have no disagreement here. Offloading a general purpose instruction
> > > set into an architecture (switch, etc.) that looks nothing like this
> > > is a losing game.
> > >
> > > > however an eBPF flow dissector would still have the same issues in
> > > > complexity and manageability that the kernel flow dissector. PANDA
> > >
> > > PANDA is a DSL and runtime, similarly P4 is another DSL and runtime
> > > environment. P4 can compile to BPF, PANDA can as well. I don't think
> > > PANDA or P4 belong in kernel. We can argue about preferred DSLs but
> > > I don't think that is a @netdev @bpf concern.
> > >
> > > > pretty much can address that since the same source code for flow
> > > > dissector used in tc-flower could be compiled into eBPF and used with
> > > > TC (that gives extensibility at some incremental performance
> > > > degradation). There is an interesting caveat there in that to satisfy
> > > > verifier we had to break up the parser to avoid being flagged for
> > > > complexity. The parser code however already started with a restricted
> > > > structure that enforces rules that prevent the issues the verified is
> > > > checking for, when we get to verifier though it doesn't have any that
> > > > context and hence views it as general purpose code. Introducing domain
> > > > specific constructs into eBPF, like the byte code I mentioned, would
> > > > simplify the verifier in that case.
> > >
> > > We have some type specific constructs already. For example we know
> > > certain helpers will return a max value, etc. and can avoid extra
> > > bounds checks. If we can safely make more assumptions based on
> > > the types of the program and/or types of variables lets do it. I'm
> > > all in for optimizations in the verifier side.
> > >
> > > If you have specific complexity problems we can work to solve those
> > > either in the clang backend or in verifier itself. Solving these
> > > will help all use cases so again happy to help here.
> > >
> > > >
> > > > > > > > >
> > > > > > > > > > Hi Jiri,
> > > > > > > > > >
> > > > > > > > > > Yes, the intent is to replace flow dissector with a parser
> > > that is
> > > > > > > > > > more extensible, more manageable and can be accelerated in
> > > hardware
> > > > > > > > > > (good luck trying to HW accelerate flow dissector as is ;-)
> > > ). I did a
> > > > > > > > > > presentation on this topic at the last Netdev conf:
> > > > > > > > > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst
> > > introducing this
> > > > > > > > > > with a kernel config is a good idea.
> > > > > > > > >
> > > > > > > > > Can we drop hyperbole? There are several examples of hardware
> > > that
> > > > > > > > > offload (a subset of) flower. That the current kernel
> > > implementation has
> > > > > > > > > the properties you describe is pretty much irrelevant for
> > > current hw
> > > > > > > > > offload use-cases.
> > > > > > > >
> > > > > > > > Simon,
> > > > > > > >
> > > > > > > > "current hw offload use-cases" is the problem; these models
> > > offer no
> > > > > > > > extensibility. For instance, if a new protocol appears or a user
> > > wants
> > > > > > > > to support their own custom protocol in things like tc-flower
> > > there is
> > > > > > > > no feasible way to do this. Unfortunately, as of today it seems,
> > > we
> > > > > > > > are still bound by the marketing department at hardware vendors
> > > that
> > > > > > > > pick and choose the protocols that they think their customers
> > > want and
> > > > > > > > are willing to invest in-- we need to get past this once and for
> > > all!
> > > > > > > > IMO, what we need is a common way to extend the kernel, tc, and
> > > other
> > > > > > > > applications for new protocols and features, but also be able to
> > > apply
> > > > > > > > that method to extend to the hardware which is _offloading_
> > > kernel
> > > > > > > > functionality which in this case is flow dissector. The
> > > technology is
> > > > > > > > there to do this as programmable NICs for instance are the rage,
> > > but
> > > > > > > > we do need to create common APIs to be able to do that. Note this
> > > > > > > > isn't just tc, but a whole space of features; for instance, XDP
> > > hints
> > > > > > > > is nice idea for the NIC to provide information about protocols
> > > in a
> > > > > > > > packet, but unless/until there is a way to program the device to
> > > pull
> > > > > > > > out arbitrary information that the user cares about like
> > > something
> > > > > > > > from their custom protocol, then it's very limited utility...
> > > > >
> > > > > Vendors have the ability to code up arbitrary hints today. They just
> > > > > haven't open sourced it or made it widely available. I don't see how
> > > >
> > > > Vendors can do this, but can I do this as a user? If I have a custom
> > > > protocol can I write some code for that without calling my vendor and
> > > > can I use that with tc-flower offload as easily as any other protocol?
> > > > I believe this is what is needed.
> > >
> > > I agree it would be great for the vendors to expose this, but I don't
> > > see how flower2 gets us there yet. Said vendors could give us the
> > > tools needed now, but haven't.
> > >
> > > >
> > > > > a 'tc' interface would help with this. I suspect most hardware could
> > > > > prepend hints or put other arbitrary data in the descriptor or
> > > elsewhere.
> > > > > The compelling reason to open source it is missing.
> > > >
> > > > I'm not sure about that. It's not so much a question of the mechanisms
> > > > to convey the data (although being restricted to just a few bytes in a
> > > > receive descriptor for XDP Hints is an obvious limitation), the
> > >
> > > We have multi-buffer support coming so we could use pages of data
> > > for metadata if we wanted fairly easily once that lands. We could
> > > even have hardware DMA the metadata into a page and just add that
> > > to the frag list without any copying.
> > >
> > > > problem is the generation of the hints themself. For instance, suppose
> > > > I want to extract the QUIC connection identifier as an XDP Hint? To do
> > > > this we would need the device to be able to parse in UDP payload and
> > > > extract the connection identifier. I don't believe that capability is
> > > > widespread yet, vendors have parsers but generally they have not made
> > > > them user programmable. And even if they did do that, then we need a
> > > > common interface to program that functionality-- proprietary APIs are
> > > > right out due to risk of vendor lockin. I imagine the P4 advocates
> > > > think they are the solution, but then we have to absorb the
> > > > maintenance cost of yet another domain specific language and P4 isn't
> > > > part of the kernel so it really isn't offloading kernel functionality.
> > > > This is the gap the PANDA fills.
> > >
> > > I don't think P4 or Panda should be in-kernel. The kernel has a BPF
> > > parser that can do arbitrary protocol parsing today. I don't see
> > > a reason to add another thing on the chance a hardware offload
> > > might come around. Anyways P4/Panda can compile to the BPF parser
> > > or flower if they want and do their DSL magic on top. And sure
> > > we might want to improve the clang backends, the existing flower
> > > classifier, and BPF verifier.
> > >
> > > BPF knows about skbs and its attach points. If it can assume
> > > bounds lengths or other simplifying constraints automatically
> > > lets do it.
> > >
> > > Without hardware support I can't see any advantage to flower2.
> >
> >
> > John,
> >
> > Please look at patch log, there are number of problems that have come up
> > flow dissector over the years. Most of this is related to inherent
> > inflexibility, limitations, missing support for fairly basic protocols, and
> > there's a lot of information loss because of the fixed monolithic data
> > structures. I've said it many times: skb_flow_dissect is the function we
> > love to hate. Maybe it's arguable, bit I claim it's 2000 lines of spaghetti
> > code. I don't think there's anyone to blame for that, this was a
> > consequence of evolving very useful feature that isn't really amenable to
> > being written in sequence of imperative instructions (if you recall it used
> > to be even worse with something like 20 goto's scattered about that defied
> > any semblance of logical program flow :-) ).
>
> OK, but if thats the goal then shouldn't this series target replacing the
> flow_dissector code directly? I don't see any edits to ./net/core.
>
John,

Well this is just an RFC ;-). We'll follow with the patch series that
more directly illustrates replacing kernel flow dissector.

> >
> > The equivalent code in PANDA is far simpler, extensible, and maintainable
> > and there are opportunities for context aware optimizations that achieve
> > higher performance (we'll post performance numbers showing that shortly).
> > It's also portable to different environments both SW and HW.
>
> If so replace flow_dissector then I think and lets debate that.
>
> My first question as a flow dissector replacement would be the BPF
> flow dissector was intended to solve the generic parsing problem.
> Why would Panda be better?

To be clear PANDA is a programming model for the datapath not an
execution environment-- I view it as complementary to kernel, eBPF,
DPDK, etc. Similar to how we are suggesting to replace the kernel flow
dissector with a PANDA derived flow dissector, we can implement a BPF
flow dissector in PANDA as well. This should be as simple as
recompiling the parser we're using in this patch for eBPF (we'll do
that experiment). As I mentioned the immediate benefits are a
simplified code base and improved program structure in the source
source. With a context aware optimizing compiler we can output C code
that has higher performance than the equivalent handwritten imperative
code. The longer term benefits are that the same exact parser code is
now accleratable and a more user-friendly interface for users adding
their own custom protocols to generic tc-flower.

> My assumption here is that BPF should
> solve the generic parsing problem, but as we noted isn't very
> friendly to HW offload.

Right, not friendly to HW offload but that's also correlated to not
being very friendly programmability in general.

> So we jumped immediately into HW offload
> space. If the problem is tc_flower is not flexible enough
> couldn't we make tc_flower use the BPF dissector?

Yes, in the software model we would use a BPF dissector, I'm just
saying that that for generic tc-flower we would derive that from PANDA
which is going to be better performance and easier to make the changes
in TC flower application for dynamic CLI to use PANDA parser. Without
any additional considerations, all we're really doing is rewriting the
BPF and kernel flow dissector in a simpler model but retaining the
same functionality (although there is a nice advantage that both
instances can be derived from the same code base).

> That should
> still allow tc flower to do its offload above the sw BPF dissector
> to hardware just fine.

Right but we need something to offload, and it really has to be
identical functionality to what kernel does. While we can't offload an
eBPF flow dissector, we can offload a flow dissector which starts from
an expression in PANDA and is also the basis for an eBPF one kernel
uses.

>
> I guess my first level question is why did BPF flow dissector
> program not solve the SW generic parsing problem. I read the commit
> messages and didn't find the answer.

I do think eBPF is key to providing a generic software parser, doing
an eBPF parser in PANDA has the advantages I mentioned. This does lead
to a more profound question with regards to the kernel flow dissector
we have today in the kernel: can the flow dissector be completely
removed and replaced with just an eBPF hook that is populated with a
default parser program as part of kernel compilation? I believe the
major reason to have a kernel flow dissector instead of a default eBPF
flow dissector is for performance, presumably native kernel code is
faster than eBPF code in kernel. But if the eBPF code is actually
faster, like in PANDA where we can optimize the code with context,
then the performance issue might be moot. So now, instead of eBPF
being used as an optional hook, it's actively replacing some core
kernel functionality from boot (hence we're starting to rewrite the
kernel itself in eBPF which is why I call it profound). That is
potentially a big win for extensibility, flexibility, and
accelerability also. I think this is something we should explore, but
maybe take an incremental approach to get there by first moving the
kernel flow dissector to a simpler model.

Tom

>
> .John
>
> >
> > Tom
> >
> >
> > >
> > > even if we had support the amount of firmware logic going into taking
> > > that parse graph into hardware makes me a bit nervous. I would
> > > prefer to see a proper compiler that generates the microcode and
> > > *CAM table entires necessary to implement said switch logic from
> > > any DSL although I prefer P4. Sure that compiler wont be in
> > > kernel most likely, but I want transparency and I want tools
> > > to configure my software how I want it. Neither requries a
> > > kernel shim.
> > >
> > > >
> > > > >
> > > > > Then the flwo is fairly straight forward the XDP program reads the
> > > > > hints. Then if the rest of the stack needs this in the skb we have
> > > > > the hash and skb extensions.
> > > >
> > > > Again that's the backend mechanism, the frontend problem is the
> > > > generation of the hints data itself.
> > >
> > > Sure, but my point is the mechanism exists today to generate
> > > arbitrary hints and no vendor has stepped up and provide
> > > code to do it. The only conclusion I can come up with is its
> > > not valuable on their side to do it.
> > >
> > > >
> > > > >
> > > > > > >
> > > > > > > ... the NIC could run a BPF program if its programmable to that
> > > extent.
> > > > > > >
> > > > > > Simon,
> > > > > >
> > > > > > True, but that implies that the NIC would just be running code in one
> > > > > > CPU instead of another-- i.e., that is doing offload and not
> > > > > > acceleration. Hardware parses are more likely to be very specialized
> > > > > > and might look something like a parameterized FSM that runs 10x
> > > faster
> > > > > > than software in a CPU. In order to be able to accelerate, we need to
> > > > > > start with a parser representation that is more declarative than
> > > > >
> > > > > Agree, but I don't see how configuration of this hardware makes sense
> > > > > over 'tc'. This is likely to require compiler tools to generate the
> > > > > microcode or *CAM entries running on the hardware. Having 'tc' run
> > > > > a few link, add-header commands that can be converted into reconfigured
> > > > > hardware (thats not just a CPU on a NIC) seems like we will be asking
> > > > > a lot of firmware. Probably too much for my taste, fixing bugs in
> > > > > firmware is going to be harder then if vendors just give us the
> > > > > compiler tools to generate the parsing logic for their hardware.
> > > > >
> > > > > Show me the hardware that can create new parse trees using flower2,
> > > > > do they exist?
> > > >
> > > > Working on it :-)
> > >
> > > OK I think flower2 should wait for the hardware then.
> > >
> > > >
> > > > >
> > > > > If not the flow is like this,
> > > > >
> > > > >  0. build new parse graph and hardware logic using DSL (P4 or
> > > otherwise)
> > > > >  1. apply blob output from 0 onto hardware
> > > > >  2. build out flower2 graph
> > > > >  3. flower2 populates hardware but hardware already got it from 0?
> > > > >
> > > > > I'm missing the point here?
> > > > >
> > > > >
> > > > > > imperative. This is what PANDA provides, the user writes a parser in
> > > a
> > > > > > declarative representation (but still in C). Given the front end
> > > > > > representation is declarative, we can compile that to a type of byte
> > > > > > code that is digestible to instantiate a reasonably programmable
> > > > > > hardware parser. This fits well with eBPF where the byte code is
> > > > > > domain specific instructions to eBPF, so when the eBPF program runs
> > > > > > they can be JIT compiled into CPU instructions for running on the
> > > > > > host, but they can be given to driver that can translate or JIT
> > > > > > compile the byte code into their hardware parser (coud JIT compile to
> > > > > > P4 backend for instance).
> > > > >
> > > > > I'm not sure hardware exists that can or will take arbitrary 'tc'
> > > > > commands and build a graph of a new protocols? Also we already have
> > > > > a SW path for arbitrary flow parser with BPF so I see no reasons
> > > > > we need to support yet another one. Even PANDA could produce BPF
> > > > > codes for sofwtare and hardware codes to program the hardware so
> > > > > why is this needed?
> > > >
> > > > Hardware parsers are not general purpose CPUs, but specialized engines
> > > > that expect input in a declarative representation of an annotated
> > >
> > > Of course.
> > >
> > > > parse graph that includes parameterized functions needed to determine
> > > > next protocol and length. If we compile PANDA parser, which is in
> > > > declarative representation, into eBPF then we've lost the structure
> > > > and essence of the problem so that we can't accelerate the parser in
> > > > specialized hardware. The alternative I'm suggesting is to extend eBPF
> > > > to include the declarative representation of the parser. So when the
> > > > program is downloaded to the kernel it can run in CPU by compiling to
> > > > host ISA, the kernel can then give the program to the device that in
> > > > turn can instantiate it in the hardware.
> > >
> > > This feels like multiple levels of abstraction for no reason.
> > > Why not just open up the device and give it the declaration directly.
> > > I know some people disagree, but why are we creating all this code
> > > when the entire purpose can be done by simply passing the info to
> > > the hardware directly. I see no reason BPF should pick up extra
> > > complexity just so some hardware device can take it and convert
> > > it out of BPF and run some annotations.
> > >
> > > >
> > > > A critical aspect of this method also eliminates any sort of side
> > > > channel or kernel bypass to program the device, which means the device
> > > > programming is visible to the kernel hence there is no ambiguity as to
> > > > what the device is actually doing (this lack of transparency is why
> > > > protocol specific offloads like LRO have failed to get traction). This
> > > > visibility is necessary if we are ever to go beyond just getting a few
> > > > disposable hints from the device and are getting actual operational
> > > > data for the stack to consume (like accelerated TXDP where we can jump
> > > > straight to TCP receive processing routine from the driver because the
> > > > device was able to perform all the stateless TCP and IP processing
> > > > before giving the packet the host). Generally, I view this direction
> > > > as extending the boundary of the stack into the device.
> > >
> > > Agree we need visibility into what the hardware is doing if we want
> > > complex offloads. But, I don't see why we need to complicated the
> > > software stacks to support the offload.
> > >
> > > Anyways IMO we need hardware support to make heads or tails of this.
> > >
> > > >
> > > > Tom
> > > >
> > > > >
> > > > > Also yes I saw the netdevconf but still missed the point Sorry.
> > > > >
> > > > > Thanks
> > > > > .John
> > >
> > >
> > >
>
>
