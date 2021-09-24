Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE849417B9E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 21:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbhIXTPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 15:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbhIXTPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 15:15:52 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1E6C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 12:14:19 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d11so11535778ilc.8
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 12:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UcEyM9iYCmB2EBkkzV8O0tKkaCF6c69o3gkNLcZR+Fs=;
        b=F7AD9MJ3p0JsFepKlIDGXpNOCoS584z5XGFwzdTR9VSbhjYIHT1RqVTvAotIKI5lPY
         SM8TIIug038j/o6FBKVFaKjrd6RdTEbKdH5M5yo4/tcYI3afJf7UXI8xun5i/amYyUB+
         zCGaX4RdOi1mw1BdowgIrXfVJgaMWXBP5hyTVuP4dixNJNR6cDUTf5/VM3j0rhvHzFnz
         yMW1hga1gjyNIqY5ed7Awz0v284G/ipisTtQnPF00oiH4z51ELZO85Vy6/53c2b8XFLh
         z4TfyZQN4Gl4Es4MhIs1+m9Bt91m/c0Xq1U/vwJS95hNCaFQFs1ZaqhFO8BI6XzPhw6Z
         lx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UcEyM9iYCmB2EBkkzV8O0tKkaCF6c69o3gkNLcZR+Fs=;
        b=QCfV6gbBzmGU/VJc85l7j9fFXvzlIrXKiZENOjihn7m/XEsDnwjjuSJ0Ys3y7AoA3h
         nUb2ZHoyQ22BSFwSTaWZfNDWHoH4lzWiB6bkyk0T2/x5+XZxupLrA0HfswvbjjNyoDWC
         ZuJBwznnf9OI1XDnO26b6qZaWV3IFIUsqbYbTvPaE8CqD1z4wKelLaKllyDc6gBgtJzG
         R2srDCFyFatCSMKK/20nedHswkg/p48mJctCzc1rj+5dH3rQrVm1DurM2H6osT0hzu8C
         ldr0Va1i4nDXaBEcLIOvYg3dO3THuXj1dSnLrmXNfBq3Ch76UjdoUkDTWgD9lXe0HdO+
         cGmA==
X-Gm-Message-State: AOAM533qwK2ZDZCapFXQxOSkpU1220f0/QnPFd2gDfym5Al1hJkjccD8
        rnzP0WUf/IGtS6DCTFvhD/Q=
X-Google-Smtp-Source: ABdhPJwJyfWFDkQGERoTzbrLEfUApL6DIrg2W8+Dq/qgprw4xfMV3h/lLXoCHY7q59emipEDbLoHxA==
X-Received: by 2002:a05:6e02:1beb:: with SMTP id y11mr9735828ilv.134.1632510858571;
        Fri, 24 Sep 2021 12:14:18 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id y124sm4334105iof.8.2021.09.24.12.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:14:18 -0700 (PDT)
Date:   Fri, 24 Sep 2021 12:14:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tom Herbert <tom@sipanda.io>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
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
Message-ID: <614e238258a78_f2dc7208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <CAOuuhY_urma1VwZKX12c5bbbj1wwvGLuAjqqBOVpg3g01b0stA@mail.gmail.com>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
 <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com>
 <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
 <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch>
 <CAOuuhY_Z63qeWhJpqbvXyk3pK+sc5=7MfOpMju94pSjtsqyuOg@mail.gmail.com>
 <614bd85690919_b58b72085d@john-XPS-13-9370.notmuch>
 <CAOuuhY-ujF_EPm6qeHAfgs6O0_-yyfZLMryYx4pS=Yd1XLor+A@mail.gmail.com>
 <614bf3bc4850_b9b1a208e2@john-XPS-13-9370.notmuch>
 <e88e7925-db6b-97a3-bf30-aa2b286ab625@mojatatu.com>
 <614d4c2954b0_dc7fd208aa@john-XPS-13-9370.notmuch>
 <CAOuuhY_urma1VwZKX12c5bbbj1wwvGLuAjqqBOVpg3g01b0stA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Herbert wrote:
> On Thu, Sep 23, 2021 at 8:55 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Jamal Hadi Salim wrote:
> > > Geez, I missed all the fun ;->
> > >
> > > On 2021-09-22 11:25 p.m., John Fastabend wrote:
> > > > Tom Herbert wrote:
> > > >> On Wed, Sep 22, 2021, 6:29 PM John Fastabend <john.fastabend@gmail.com>
> > > >> wrote:
> > >
> > > [..]
> > >
> > > >> John,
> > > >>
> > > >> Please look at patch log, there are number of problems that have come up
> > > >> flow dissector over the years. Most of this is related to inherent
> > > >> inflexibility, limitations, missing support for fairly basic protocols, and
> > > >> there's a lot of information loss because of the fixed monolithic data
> > > >> structures. I've said it many times: skb_flow_dissect is the function we
> > > >> love to hate. Maybe it's arguable, bit I claim it's 2000 lines of spaghetti
> > > >> code. I don't think there's anyone to blame for that, this was a
> > > >> consequence of evolving very useful feature that isn't really amenable to
> > > >> being written in sequence of imperative instructions (if you recall it used
> > > >> to be even worse with something like 20 goto's scattered about that defied
> > > >> any semblance of logical program flow :-) ).
> > > >
> > > > OK, but if thats the goal then shouldn't this series target replacing the
> > > > flow_dissector code directly? I don't see any edits to ./net/core.
> > > >
> > >
> > > Agreed, replacement of flow dissector should be a focus. Jiri's
> > > suggestion of a followup patch which shows how the rest of the consumers
> > > of flow dissector could be made to use PANDA is a good idea.
> >
> > I'de almost propose starting with flow_dissector.c first so we see that the
> > ./net/core user for the SW only case looks good. Although I like the idea
> > of doing it all in BPF directly so could take a crack at that as well. Then
> > compare them.
> 
> That's an interesting idea and the intent, but note that one of the
> reasons we are able to outperform flow dissectors is that
> flow_dissector is parameterized to be generalized whereas PANDA Parser
> would provide a customized instance for each use case. This is
> especially evident in the bits to configure what data fields extracts,
> in PANDA the extraction is explicit so a whole bunch of conditionals
> in the datapath are eliminated. Replacing flow dissectors might look
> more like creating a parser instance for each caller instead of
> calling one function that tries to solve all problems.

Can you say a bit more on how a user would configure PANDA parser
from user side? For some reason I was under the impression that
users could push commands down to build the parser, but when I just
read the commit messages again I didn't see the details. Did I
make this up?

It feels like a good fit for BPF under the hood at least. User could
use Panda to build the BPF parser and then "load" it. The BPF parser
is then customized for each user and we already have the hook for
it in flow dissector and in tc.

This is the jump I can't make. I get that writing BPF can be
challenging so we want a parser language on top to help users.
But I'm missing the comparison between C based Panda parser vs
native BPF which we already have support for.

> 
> >
> > >
> > > IMO (correct me if i am wrong Tom), flower2 was merely intended to
> > > illustrate how one would use PANDA i.e there are already two patches
> > > of which the first one is essentially PANDA...
> > > IOW,  it is just flower but with flow dissector replaced by PANDA.
> > >
> > > >>
> > > >> The equivalent code in PANDA is far simpler, extensible, and maintainable
> > > >> and there are opportunities for context aware optimizations that achieve
> > > >> higher performance (we'll post performance numbers showing that shortly).
> > > >> It's also portable to different environments both SW and HW.
> > > >
> > > > If so replace flow_dissector then I think and lets debate that.
> > > >
> > > > My first question as a flow dissector replacement would be the BPF
> > > > flow dissector was intended to solve the generic parsing problem.
> > >
> > > > Why would Panda be better? My assumption here is that BPF should
> > > > solve the generic parsing problem, but as we noted isn't very
> > > > friendly to HW offload. So we jumped immediately into HW offload
> > > > space. If the problem is tc_flower is not flexible enough
> > > > couldn't we make tc_flower use the BPF dissector? That should
> > > > still allow tc flower to do its offload above the sw BPF dissector
> > > > to hardware just fine.
> > > >
> > > > I guess my first level question is why did BPF flow dissector
> > > > program not solve the SW generic parsing problem. I read the commit
> > > > messages and didn't find the answer.
> > > >
> > >
> > > Sorry, you cant replace/flowdissector/BPF such that flower can
> > > consume it;-> You are going to face a huge path explosion with the
> > > verifier due to the required branching and then resort to all
> > > kinds of speacial-cased acrobatics.
> > > See some samples of XDP code going from trying to parse basic TCP
> > > options to resorting to tricking the verifier.
> > > For shits and giggles, as they say in Eastern Canada, try to do
> > > IPV6 full parsing with BPF (and handle all the variable length
> > > fields).
> >
> > We parse TLVs already and it works just fine. It requires some
> > careful consideration and clang does some dumb things here and
> > there, but it is doable. Sure verifier could maybe be improved
> > around a few cases and C frontend gets in the way sometimes,
> > but PANDA or P4 or other DSL could rewrite in LLVM-IR directly
> > to get the correct output.
> >
> Currently the kernel flow dissector doesn't parse TLVs, for instance
> Hop-by-Hop, DestOpts, IP options, and TCP options are just skipped.
> TLVs are also the bane of router vendors since they despise
> implementing protocols that require serialized processing over
> combinatorial collection of elements. We need to get past this since
> TLVs are a protocol extensibility which means they need to be a first
> class citizen in a programmable parser API. (to be clear I'm not
> saying anyone should add hardcordes TLV processing to
> __skb_flow_dissect, it's already bloated enough!)

No arguments from me here.

> 
> > > Generally:
> > > BPF is good for specific smaller parsing tasks; the ebpf flow dissector
> > > hook should be trivial to add to PANDA. And despite PANDA being able
> > > to generate EBPF - I would still say it depends on the depth of the
> > > parse tree to be sensible to use eBPF.
> >
> > Going to disagree. I'm fairly confident we could write a BPF
> > program to do the flow disection. Anyways we can always improve
> > the verifier as needed and this helps lots of things not
> > just this bit. Also flow dissector will be loaded once at early
> > boot most likely so we can allow it to take a bit longer or
> > pre-verify it. Just ideas.
> 
> Yes, we already have a panda-compiler that converts PANDA-C in
> well-optimized eBPF code. Per Jamal's point, that did require breaking
> up the program into different tails calls. I believe once we hit four
> layers of protocols we do a tail call and also do a tail call for each
> instance of TLV processing. Note the
> tools/testing/selftests/bpf/progs/bpf_flow.c has to deal with this
> also and does this by statically making every L3 protocol into a tail
> call (result is more tail calls than equivalent code PANDA).

Cool, so kernel has everything needed to run the eBPF parser why do
we also need the C parser in kernel? Performance wise they should
be comparable if not lets fix up the BPF side.

> 
> >
> > >
> > > Earlier in the thread you said a couple of things that caught my
> > > attention:
> > >
> > >  > I don't think P4 or Panda should be in-kernel. The kernel has a BPF
> > >  > parser that can do arbitrary protocol parsing today. I don't see
> > >  > a reason to add another thing on the chance a hardware offload
> > >  > might come around. Anyways P4/Panda can compile to the BPF parser
> > >  > or flower if they want and do their DSL magic on top. And sure
> > >  > we might want to improve the clang backends, the existing flower
> > >  > classifier, and BPF verifier.
> > >  >
> > >  >
> > >  > Vendors have the ability to code up arbitrary hints today. They just
> > >  > haven't open sourced it or made it widely available. I don't see how
> > >  > a 'tc' interface would help with this. I suspect most hardware could
> > >  > prepend hints or put other arbitrary data in the descriptor or elsewhere.
> > >  > The compelling reason to open source it is missing.
> > >
> > > Please, please _lets not_ encourage vendors to continue
> > > keep things proprietary!
> >
> > Fair enough. Some frustration leaking in from my side knowing
> > the hardware has been around for years and we've seen multiple
> > proposals but only limited hardware backing. Tom mentioned
> > he was working on the hardware angle so perhaps its close.
> >
> I share that frustration!
> 
> > > Statements like "I don't think P4 or Panda should be in-kernel..."
> > > are just too strong.
> >
> > Where I wanted to go with this is P4 and Panda are DSLs in my
> > mind. I think we should keep the kernel non-specific to any
> > one DSL. We should have a low level generic way to add them
> > to the kernel, I think this is BPF. Then we let users pick
> > whatever DSL they like and/or make up their own DSL.
> >
> > Is the counter-argument that Panda is not a DSL, but rather
> > a low-level parser builder pattern.
> 
> Yes, PANDA is _not_ a DSL in the sense that it uses a new compiler,
> tool chain, or skill sets to write a program all of which are required
> for using P4. PANDA-C (just to make it look like the analogous CUDA-C
> :-) ) is inherently C code that has a program structure for the
> "low-level parser builder pattern".
> 
> >
> > > Instead lets focus on how we can make P4 and other hardware offloads
> > > work in conjunction with the kernel (instead of totally bypassing
> > > it which is what vendors are doing enmasse already). There are
> > > billions of $ invested in these ASICs and lets welcome them into
> > > our world. It serves and helps grow the Linux community better.
> > > The efforts of switchdev and tc offloading have proven it is possible.
> > > Vendors (and i am going to call out Broadcom on the switching side here)
> > > are not partaking because they see it as an economical advantage not to
> > > partake.
> > >
> > > We have learnt a lot technically since switchdev/tc offloads happened.
> > > So it is doable.
> > > The first rule is: In order to get h/w offload to work lets also have
> > > digitally equivalent implementation in s/w.
> >
> > But there is a cost to this its yet another bit of software to
> > maintain and review and so on. I'm arguing we already have a generic
> > way to implement h/w equivalence and its BPF. So instead of inventing
> > another method to do software we can improve the BPF layer. If we need
> > to build semantics over it that look consumable to hw so be it.
> >
> > Also the other core question I still don't understand is how a
> > piece of hardware could consume a parse graph piece-meal through
> > an interface like proposed in flower2 and generate an arbitrary
> > parse graph? On the fly none the less. That feels like some very
> > powerful firmware to me.
> > And I would prefer open source userspace code (non-kernel) to
> > deep magic in firmware. At least then I can see it, patch it,
> > fix it, etc.
> 
> An instance of a parser is inherently a parse graph, so it follows
> that the best representation for a parser is a declarative
> representation of the parse graph. There was a watershed paper on this
> by Nick McKeown and others in "Design principles for packet parsers".
> A common declarative representation is then amenable to instantiation
> in a hardware engine which is designed to consume that representation
> (i.e. hardware parsers are basically programmable FSMs), and it's
> equally straightforward to elicit a parser from a declarative
> representation into imperative code for running in CPU. In this
> regard, the only salient difference between P4 and PANDA-C is that the
> declarative representation can be coded in PANDA as a graph data
> structure in standard C, and in P4 the encoding is in an explicit
> language construct.

Sure agree with all of the above.

> 
> >
> > Last thing, I'll point out I got back deep into the hardware debate.
> > I'm still not convinced its the right thing to rip out the flow
> > dissector piece and replace it with Panda.
> 
> Hardware acceleration is one goal, but there are merits in just
> considering the software especially in regards to performance and
> usability. We'll highlight those benefits in future patch series.

So usability would be the PADNA-C representation. Good I'm all for
better user experience.

From performance side I think it should be almost the same between
your Panda-C runner and the BPF jitted code. If not I would want
to take a close look as to why not. Improving this BPF generated
code would help lots of software running today. For example
our XDP LB does parsing and we would love for it to be faster
if its possible.

I keep coming back to this. For software case use BPF the
infrastructure is there and we already have the hooks in
both flow dissector and 'tc' space. Now BPF is not the
best for offloading OK fine, can we just do this,

 declarative-parse-graph --- sw case -> BPF
                         --- hw case -> hw-cmds

But, the problem I can't understand without more hardware details
is how the declarative parse graph makes the jump from some C
code into a new hw parser instantiation. IMO before we continue
with this RFC we really need to understand that piece. Otherwise
we have no way to see if these patches will work on hw and we
already have the sw case covered as best I can tell.

Also we would want at least multiple hardware vendors to
review it and agree its something that can work across
multiple hardware devices. FWIW I'm not a complete stranger
to how parsers run in the hardware and how they get encoded
even if my info is a few years out of date.

Thanks,
John

> 
> Tom
> 
> >
> > Thanks!
> > John
