Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9746E4152FD
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbhIVVmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbhIVVmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:42:31 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC5C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:41:01 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n71so5500222iod.0
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YFw6Oj9OH6m31FgVPacTe96NIVk7QLcGAadHUfJhkZE=;
        b=pQpYcrtRFEJweO5fQGb37wJlNFbEMOp7uQJPQYHd0G2kgccQRcRQh7ZGw2XTYNIN93
         aTOe80c0CjaoRUWERpqNsYs1tOVw9yMDAnQEGuqQKy1BTl4KBgJb75DIwOmWHmZODbpm
         qQ0wuEetPdePMN2VqwalBp1LGreFFkFTRtDn4/l5UZ9NDGrPdZEjBA31Ugls6vWxpGVn
         53DlCtlasmgTn0JBNdk5vZ5b+1RsbfkifhjZHHW79hK5Ak4D/7ugcoGSaBDVbhBfn+fe
         x/lm3pkt3YrJWABKjbe/672p3d9nZ1lMqHdJ8qwXt932Vg/VcrPDvPaTvkfmsNFjk8dV
         KwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YFw6Oj9OH6m31FgVPacTe96NIVk7QLcGAadHUfJhkZE=;
        b=Bp5AYsN2vR1U++udyUBHRMrzD9ffLAIGxMTyWt2KvRPSv5k9rFv7+zi/ECnBLxQy8K
         JwWjmXUtm9Mk+7cisffyrmEc8vKA/Dkw3Ky6QF8xVCA1AugzpDLSaNq1RvPk5gynyOWg
         olf+vlIxpUrm4FcyzccjfhW4FLFAwOd1VrPltBFmCCRtj5Rp3mZHxVSuJlIOcpegYkv2
         4JgtJwQ7ElkOvqEMmo1sQmfZg4UqjKR5R7kdcxXcTnZuxkUA4iu/bxPzzJGVTgfftEqq
         AZRQVg8w5B0P3D+XhurmG+XYxBPwmrvyzOUCLe8ZgKGr7+Zll8mFu5BFd1BIPkgQyGpR
         Z2oQ==
X-Gm-Message-State: AOAM531TYd2HgxVbL8p0c/mIAzaURQS5oDVOPsqBEHRm+xKThVhjUpIN
        027SEB9eu23MhztfOFqTyVo=
X-Google-Smtp-Source: ABdhPJxuMeLghd99Z+/+ZJWyu7ZsAJb5Z2PJH+6K37DkqFMLi4A8ObOf4y/7VibWdlNroIMg/uKjOA==
X-Received: by 2002:a6b:f604:: with SMTP id n4mr956140ioh.99.1632346860477;
        Wed, 22 Sep 2021 14:41:00 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r11sm1541908ila.17.2021.09.22.14.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:40:59 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:40:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tom Herbert <tom@sipanda.io>,
        Simon Horman <simon.horman@corigine.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch>
In-Reply-To: <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
 <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com>
 <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
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
> On Wed, Sep 22, 2021 at 11:00 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Wed, Sep 22, 2021 at 10:28:41AM -0700, Tom Herbert wrote:
> > > On Wed, Sep 22, 2021 at 8:49 AM Simon Horman <simon.horman@corigine.com> wrote:
> > > >
> > > > On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> > > > > On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > > >
> > > > > > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > > > > > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > > > > > ><felipe@sipanda.io> wrote:
> > > > > > >>
> > > > > > >> The PANDA parser, introduced in [1], addresses most of these problems
> > > > > > >> and introduces a developer friendly highly maintainable approach to
> > > > > > >> adding extensions to the parser. This RFC patch takes a known consumer
> > > > > > >> of flow dissector - tc flower - and  shows how it could make use of
> > > > > > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > > > > > >> classifier is called "flower2". The control semantics of flower are
> > > > > > >> maintained but the flow dissector parser is replaced with a PANDA
> > > > > > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > > > > > >> other than replacing the user space tc commands with "flower2"  the
> > > > > > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > > > > > >> show a simple use case of the issues described in [2] when flower
> > > > > > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > > > > > >> model for network datapaths, this is described in
> > > > > > >> https://github.com/panda-net/panda.
> > > > > > >
> > > > > > >My only concern is that is there any way to reuse flower code instead
> > > > > > >of duplicating most of them? Especially when you specifically mentioned
> > > > > > >flower2 has the same user-space syntax as flower, this makes code
> > > > > > >reusing more reasonable.
> > > > > >
> > > > > > Exactly. I believe it is wrong to introduce new classifier which would
> > > > > > basically behave exacly the same as flower, only has different parser
> > > > > > implementation under the hood.
> > > > > >
> > > > > > Could you please explore the possibility to replace flow_dissector by
> > > > > > your dissector optionally at first (kernel config for example)? And I'm
> > > > > > not talking only about flower, but about the rest of the flow_dissector
> > > > > > users too.
> > > >
> > > > +1

Does the existing BPF flow dissector not work for some reason? If its purely
a hardware mapping problem, couple questions below.

> > > >
> > > > > Hi Jiri,
> > > > >
> > > > > Yes, the intent is to replace flow dissector with a parser that is
> > > > > more extensible, more manageable and can be accelerated in hardware
> > > > > (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> > > > > presentation on this topic at the last Netdev conf:
> > > > > https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> > > > > with a kernel config is a good idea.
> > > >
> > > > Can we drop hyperbole? There are several examples of hardware that
> > > > offload (a subset of) flower. That the current kernel implementation has
> > > > the properties you describe is pretty much irrelevant for current hw
> > > > offload use-cases.
> > >
> > > Simon,
> > >
> > > "current hw offload use-cases" is the problem; these models offer no
> > > extensibility. For instance, if a new protocol appears or a user wants
> > > to support their own custom protocol in things like tc-flower there is
> > > no feasible way to do this. Unfortunately, as of today it seems, we
> > > are still bound by the marketing department at hardware vendors that
> > > pick and choose the protocols that they think their customers want and
> > > are willing to invest in-- we need to get past this once and for all!
> > > IMO, what we need is a common way to extend the kernel, tc, and other
> > > applications for new protocols and features, but also be able to apply
> > > that method to extend to the hardware which is _offloading_ kernel
> > > functionality which in this case is flow dissector. The technology is
> > > there to do this as programmable NICs for instance are the rage, but
> > > we do need to create common APIs to be able to do that. Note this
> > > isn't just tc, but a whole space of features; for instance, XDP hints
> > > is nice idea for the NIC to provide information about protocols in a
> > > packet, but unless/until there is a way to program the device to pull
> > > out arbitrary information that the user cares about like something
> > > from their custom protocol, then it's very limited utility...

Vendors have the ability to code up arbitrary hints today. They just
haven't open sourced it or made it widely available. I don't see how
a 'tc' interface would help with this. I suspect most hardware could
prepend hints or put other arbitrary data in the descriptor or elsewhere.
The compelling reason to open source it is missing.

Then the flwo is fairly straight forward the XDP program reads the
hints. Then if the rest of the stack needs this in the skb we have
the hash and skb extensions.

> >
> > ... the NIC could run a BPF program if its programmable to that extent.
> >
> Simon,
> 
> True, but that implies that the NIC would just be running code in one
> CPU instead of another-- i.e., that is doing offload and not
> acceleration. Hardware parses are more likely to be very specialized
> and might look something like a parameterized FSM that runs 10x faster
> than software in a CPU. In order to be able to accelerate, we need to
> start with a parser representation that is more declarative than

Agree, but I don't see how configuration of this hardware makes sense
over 'tc'. This is likely to require compiler tools to generate the
microcode or *CAM entries running on the hardware. Having 'tc' run
a few link, add-header commands that can be converted into reconfigured
hardware (thats not just a CPU on a NIC) seems like we will be asking
a lot of firmware. Probably too much for my taste, fixing bugs in
firmware is going to be harder then if vendors just give us the
compiler tools to generate the parsing logic for their hardware.

Show me the hardware that can create new parse trees using flower2,
do they exist?

If not the flow is like this,

 0. build new parse graph and hardware logic using DSL (P4 or otherwise)
 1. apply blob output from 0 onto hardware
 2. build out flower2 graph
 3. flower2 populates hardware but hardware already got it from 0?

I'm missing the point here?


> imperative. This is what PANDA provides, the user writes a parser in a
> declarative representation (but still in C). Given the front end
> representation is declarative, we can compile that to a type of byte
> code that is digestible to instantiate a reasonably programmable
> hardware parser. This fits well with eBPF where the byte code is
> domain specific instructions to eBPF, so when the eBPF program runs
> they can be JIT compiled into CPU instructions for running on the
> host, but they can be given to driver that can translate or JIT
> compile the byte code into their hardware parser (coud JIT compile to
> P4 backend for instance).

I'm not sure hardware exists that can or will take arbitrary 'tc'
commands and build a graph of a new protocols? Also we already have
a SW path for arbitrary flow parser with BPF so I see no reasons
we need to support yet another one. Even PANDA could produce BPF
codes for sofwtare and hardware codes to program the hardware so
why is this needed?

Also yes I saw the netdevconf but still missed the point Sorry.

Thanks
.John
