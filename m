Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228AB416AA6
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 05:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhIXD5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 23:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244031AbhIXD5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 23:57:03 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019E6C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 20:55:31 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b8so8853879ilh.12
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 20:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HUvwffg7NzH062Jb90LLLxH/QJa/BpIPf44N6U8cfhc=;
        b=LiVPPTHqWofmJgAL6ylv77FuN7HcKhUZNm+H4Dxyaxx4RX9r3hgf3U5KeQhiXox63+
         /5czRuKhcyTB0lngUzno5bjnX0or3fq1phKgFHXGOhvUQkM4cwBVtmyVX8D1Q5KOUUqj
         K3+8o93myUPDfZcn5tJ8cZXClzMUX0tky3gAssN3AMeepPIsB47E46+0wYEVNXq49dbM
         jmh8GxAv6ZBy18b7Exdu63ONmRXxt5QrdTd82XZ/njUxcjkcvgYKUh46F1MMvRgm1Gxl
         4F647qx3I9pPvanBPAY7/rTeL0aLbZf4Az4J4QbsoI0IYBoOt97mGdFLOOyB+vJ/J4MI
         iZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HUvwffg7NzH062Jb90LLLxH/QJa/BpIPf44N6U8cfhc=;
        b=h/mUyUBpkKemgwb/QTnn52R+n+Mu8b87PjK6VLDQ8eqZwb+chNH9Y1lcO41qQWEow3
         45+1Fqkru2l3hMA7kxuEllxR2HnYKPqxA3+xqagqle7Efu3i7qx+JFcv4rAmpJD+91q9
         LstjLz/yVY6Y9aydN61xidM0ApaUXaDL4U9Gf2x85Hm0rFtgnN9aKt3Hm7itpDhfsikp
         OUEdL1i0NFpRaj3rfIC8VlOWf61Qh63lIyJ6MucoRyTkIO29XFaF5ddmgY+0a32OjCOW
         ekEGB9Y3QgWaBnomCJXDE4/d4JT+hkKtm2LAeQ61B5olTev/1SQKW9PQM2QDm3S0Jt1M
         u4ww==
X-Gm-Message-State: AOAM531Fs9RSY1nFo1mKovkLS8O2jOjygrfDfxrLjGSuEK4hQU8n+ryF
        qtH7NGC2ZugXu4FkvHbKEME=
X-Google-Smtp-Source: ABdhPJy6Qw/+P0V+p+DD2hCPtj7R3rniJYyZZGqvfvoUSEmc6MdhDw7xcKH9uZGnBBFhPqLrqyn4lQ==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr6228898ilj.37.1632455730326;
        Thu, 23 Sep 2021 20:55:30 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id a25sm3108337ioq.46.2021.09.23.20.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 20:55:29 -0700 (PDT)
Date:   Thu, 23 Sep 2021 20:55:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Tom Herbert <tom@sipanda.io>
Cc:     Simon Horman <simon.horman@corigine.com>,
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
Message-ID: <614d4c2954b0_dc7fd208aa@john-XPS-13-9370.notmuch>
In-Reply-To: <e88e7925-db6b-97a3-bf30-aa2b286ab625@mojatatu.com>
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
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim wrote:
> Geez, I missed all the fun ;->
> 
> On 2021-09-22 11:25 p.m., John Fastabend wrote:
> > Tom Herbert wrote:
> >> On Wed, Sep 22, 2021, 6:29 PM John Fastabend <john.fastabend@gmail.com>
> >> wrote:
> 
> [..]
> 
> >> John,
> >>
> >> Please look at patch log, there are number of problems that have come up
> >> flow dissector over the years. Most of this is related to inherent
> >> inflexibility, limitations, missing support for fairly basic protocols, and
> >> there's a lot of information loss because of the fixed monolithic data
> >> structures. I've said it many times: skb_flow_dissect is the function we
> >> love to hate. Maybe it's arguable, bit I claim it's 2000 lines of spaghetti
> >> code. I don't think there's anyone to blame for that, this was a
> >> consequence of evolving very useful feature that isn't really amenable to
> >> being written in sequence of imperative instructions (if you recall it used
> >> to be even worse with something like 20 goto's scattered about that defied
> >> any semblance of logical program flow :-) ).
> > 
> > OK, but if thats the goal then shouldn't this series target replacing the
> > flow_dissector code directly? I don't see any edits to ./net/core.
> > 
> 
> Agreed, replacement of flow dissector should be a focus. Jiri's
> suggestion of a followup patch which shows how the rest of the consumers
> of flow dissector could be made to use PANDA is a good idea.

I'de almost propose starting with flow_dissector.c first so we see that the
./net/core user for the SW only case looks good. Although I like the idea
of doing it all in BPF directly so could take a crack at that as well. Then
compare them.

> 
> IMO (correct me if i am wrong Tom), flower2 was merely intended to
> illustrate how one would use PANDA i.e there are already two patches
> of which the first one is essentially PANDA...
> IOW,  it is just flower but with flow dissector replaced by PANDA.
> 
> >>
> >> The equivalent code in PANDA is far simpler, extensible, and maintainable
> >> and there are opportunities for context aware optimizations that achieve
> >> higher performance (we'll post performance numbers showing that shortly).
> >> It's also portable to different environments both SW and HW.
> > 
> > If so replace flow_dissector then I think and lets debate that.
> > 
> > My first question as a flow dissector replacement would be the BPF
> > flow dissector was intended to solve the generic parsing problem.
> 
> > Why would Panda be better? My assumption here is that BPF should
> > solve the generic parsing problem, but as we noted isn't very
> > friendly to HW offload. So we jumped immediately into HW offload
> > space. If the problem is tc_flower is not flexible enough
> > couldn't we make tc_flower use the BPF dissector? That should
> > still allow tc flower to do its offload above the sw BPF dissector
> > to hardware just fine.
> > 
> > I guess my first level question is why did BPF flow dissector
> > program not solve the SW generic parsing problem. I read the commit
> > messages and didn't find the answer.
> > 
> 
> Sorry, you cant replace/flowdissector/BPF such that flower can
> consume it;-> You are going to face a huge path explosion with the 
> verifier due to the required branching and then resort to all
> kinds of speacial-cased acrobatics.
> See some samples of XDP code going from trying to parse basic TCP 
> options to resorting to tricking the verifier.
> For shits and giggles, as they say in Eastern Canada, try to do
> IPV6 full parsing with BPF (and handle all the variable length
> fields).

We parse TLVs already and it works just fine. It requires some
careful consideration and clang does some dumb things here and
there, but it is doable. Sure verifier could maybe be improved
around a few cases and C frontend gets in the way sometimes,
but PANDA or P4 or other DSL could rewrite in LLVM-IR directly
to get the correct output.

> Generally:
> BPF is good for specific smaller parsing tasks; the ebpf flow dissector
> hook should be trivial to add to PANDA. And despite PANDA being able
> to generate EBPF - I would still say it depends on the depth of the
> parse tree to be sensible to use eBPF.

Going to disagree. I'm fairly confident we could write a BPF
program to do the flow disection. Anyways we can always improve
the verifier as needed and this helps lots of things not
just this bit. Also flow dissector will be loaded once at early
boot most likely so we can allow it to take a bit longer or
pre-verify it. Just ideas.

> 
> Earlier in the thread you said a couple of things that caught my
> attention:
> 
>  > I don't think P4 or Panda should be in-kernel. The kernel has a BPF
>  > parser that can do arbitrary protocol parsing today. I don't see
>  > a reason to add another thing on the chance a hardware offload
>  > might come around. Anyways P4/Panda can compile to the BPF parser
>  > or flower if they want and do their DSL magic on top. And sure
>  > we might want to improve the clang backends, the existing flower
>  > classifier, and BPF verifier.
>  >
>  >
>  > Vendors have the ability to code up arbitrary hints today. They just
>  > haven't open sourced it or made it widely available. I don't see how
>  > a 'tc' interface would help with this. I suspect most hardware could
>  > prepend hints or put other arbitrary data in the descriptor or elsewhere.
>  > The compelling reason to open source it is missing.
> 
> Please, please _lets not_ encourage vendors to continue
> keep things proprietary!

Fair enough. Some frustration leaking in from my side knowing
the hardware has been around for years and we've seen multiple
proposals but only limited hardware backing. Tom mentioned
he was working on the hardware angle so perhaps its close.

> Statements like "I don't think P4 or Panda should be in-kernel..."
> are just too strong.

Where I wanted to go with this is P4 and Panda are DSLs in my
mind. I think we should keep the kernel non-specific to any
one DSL. We should have a low level generic way to add them
to the kernel, I think this is BPF. Then we let users pick
whatever DSL they like and/or make up their own DSL.

Is the counter-argument that Panda is not a DSL, but rather
a low-level parser builder pattern.

> Instead lets focus on how we can make P4 and other hardware offloads
> work in conjunction with the kernel (instead of totally bypassing
> it which is what vendors are doing enmasse already). There are
> billions of $ invested in these ASICs and lets welcome them into
> our world. It serves and helps grow the Linux community better.
> The efforts of switchdev and tc offloading have proven it is possible.
> Vendors (and i am going to call out Broadcom on the switching side here)
> are not partaking because they see it as an economical advantage not to
> partake.
> 
> We have learnt a lot technically since switchdev/tc offloads happened.
> So it is doable.
> The first rule is: In order to get h/w offload to work lets also have
> digitally equivalent implementation in s/w.

But there is a cost to this its yet another bit of software to
maintain and review and so on. I'm arguing we already have a generic
way to implement h/w equivalence and its BPF. So instead of inventing
another method to do software we can improve the BPF layer. If we need
to build semantics over it that look consumable to hw so be it.

Also the other core question I still don't understand is how a
piece of hardware could consume a parse graph piece-meal through
an interface like proposed in flower2 and generate an arbitrary
parse graph? On the fly none the less. That feels like some very
powerful firmware to me.
And I would prefer open source userspace code (non-kernel) to
deep magic in firmware. At least then I can see it, patch it,
fix it, etc.

Last thing, I'll point out I got back deep into the hardware debate.
I'm still not convinced its the right thing to rip out the flow
dissector piece and replace it with Panda.

Thanks!
John
