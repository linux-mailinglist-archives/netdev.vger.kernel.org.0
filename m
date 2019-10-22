Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06E2E09CC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbfJVQzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:55:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35481 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVQzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:55:06 -0400
Received: by mail-io1-f65.google.com with SMTP id t18so17160617iog.2;
        Tue, 22 Oct 2019 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=f1Zd2L7wkfG4QadxHrwbztFgdzcj7S7DQBtQubAbyVc=;
        b=MntQoTWsXSWzoB9CKtC9nOrNKOOng1c6gefwEhVnuvIxeZdJiqpc7BviwqsOQQhrXz
         RjeX0tTa/hP/Vuve/BFLxYSlSBzOzOUFfp7mzthgFKoOc3kcyYYpFmZ2w3yeClcLwioh
         sMhRFY0dLxkGI6kYxA6+H7aEA9jBHsvrtCIXW7uzdGfa33Eo1FmFfP/eiopvix+3awdy
         cKbXXXsI9WLmrFbN2VWM8Q/XrJvU0ruwpMSl39JCnSUMGczFI/oRnXZG56QOHcCAohku
         TzoXbgAHmiCVgfrkU4XxwCynLUYIKtIsFuycVoxMGq5+31y8M11UZgQt/8/Ld5TsT4N8
         BTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=f1Zd2L7wkfG4QadxHrwbztFgdzcj7S7DQBtQubAbyVc=;
        b=MeCGUoF5W9t3CDKnz3o5Vxw5dw6whMJ/KDty/CZr/ogrebIrReYAjFqTsIAMq5CJ4h
         dgwULcjy4SL51uysbuz46KEd5t7W/GOlB4NIElNV0sPPWk3W0pOzbP4V9yZssCaI/PP2
         2wYXB/M5uFf6ulBf7+HjUtsbogdIfbliH7Am1IbjocfDjiM/veN1sJl+Mq5BL06gabat
         6Ylr7C1+h04dtYHSTZsdBEYRfu7VRmoLwkZy/1qoMQUqwbbI9eUer36KpZoSYv7F/c9q
         N5ZZcZntGhd0FhOgVhZKKhzi8K+o3YFvLrtaTlNiaDurJIbiHH2M/1Ik0OzqhvgpMZkz
         tfVg==
X-Gm-Message-State: APjAAAWTi9/DOHrpfeNRurdFRryx+5DPr3W3e4LOJlJhlP5dBPicOK6B
        MiIQVHPRHvkBnH02YzWLtO4=
X-Google-Smtp-Source: APXvYqzroOX+XGbj8ISXqRI5FvxqV1zwKTub2DjqBhGYOy7ctTuSKXh3ZkKI2wmmB7IhqXK1dHihOQ==
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr2481456ioj.296.1571763305305;
        Tue, 22 Oct 2019 09:55:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o1sm7054454ilm.18.2019.10.22.09.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 09:55:04 -0700 (PDT)
Date:   Tue, 22 Oct 2019 09:54:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Message-ID: <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
In-Reply-To: <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita wrote:
> On 2019/10/19 0:22, John Fastabend wrote:
> > Toshiaki Makita wrote:
> >> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
> >> to XDP.
> >>
> > 
> > I've only read the cover letter so far but...
> 
> Thank you for reading this long cover letter.
> 
> > 
> >> * Motivation
> >>
> >> The purpose is to speed up flow based network features like TC flower and
> >> nftables by making use of XDP.
> >>
> >> I chose flow feature because my current interest is in OVS. OVS uses TC
> >> flower to offload flow tables to hardware, so if TC can offload flows to
> >> XDP, OVS also can be offloaded to XDP.
> > 
> > This adds a non-trivial amount of code and complexity so I'm
> > critical of the usefulness of being able to offload TC flower to
> > XDP when userspace can simply load an XDP program.
> > 
> > Why does OVS use tc flower at all if XDP is about 5x faster using
> > your measurements below? Rather than spend energy adding code to
> > a use case that as far as I can tell is narrowly focused on offload
> > support can we enumerate what is missing on XDP side that blocks
> > OVS from using it directly?
> 
> I think nothing is missing for direct XDP use, as long as XDP datapath
> only partially supports OVS flow parser/actions like xdp_flow.
> The point is to avoid duplicate effort when someone wants to use XDP
> through TC flower or nftables transparently.

I don't know who this "someone" is that wants to use XDP through TC
flower or nftables transparently. TC at least is not known for a
great uapi. It seems to me that it would be a relatively small project
to write a uapi that ran on top of a canned XDP program to add
flow rules. This could match tc cli if you wanted but why not take
the opportunity to write a UAPI that does flow management well.

Are there users of tc_flower in deployment somewhere? I don't have
lots of visibility but my impression is these were mainly OVS
and other switch offload interface.

OVS should be sufficiently important that developers can right a
native solution in my opinion. Avoiding needless layers of abstraction
in the process. The nice thing about XDP here is you can write
an XDP program and set of maps that matches OVS perfectly so no
need to try and fit things in places.

> 
> > Additionally for hardware that can
> > do XDP/BPF offload you will get the hardware offload for free.
> 
> This is not necessary as OVS already uses TC flower to offload flows.

But... if you have BPF offload hardware that doesn't support TCAM
style flow based offloads direct XDP offload would seem easier IMO.
Which is better? Flow table based offloads vs BPF offloads likely
depends on your use case in my experience.

> 
> > Yes I know XDP is bytecode and you can't "offload" bytecode into
> > a flow based interface likely backed by a tcam but IMO that doesn't
> > mean we should leak complexity into the kernel network stack to
> > fix this. Use the tc-flower for offload only (it has support for
> > this) if you must and use the best (in terms of Mpps) software
> > interface for your software bits. And if you want auto-magic
> > offload support build hardware with BPF offload support.
> > 
> > In addition by using XDP natively any extra latency overhead from
> > bouncing calls through multiple layers would be removed.
> 
> To some extent yes, but not completely. Flow insertion from userspace
> triggered by datapath upcall is necessary regardless of whether we use
> TC or not.

Right but these are latency involved with OVS architecture not
kernel implementation artifacts. Actually what would be an interesting
metric would be to see latency of a native xdp implementation.

I don't think we should add another implementation to the kernel
that is worse than what we have.


 xdp_flow  TC        ovs kmod
 --------  --------  --------
 22ms      6ms       0.6ms

TC is already order of magnitude off it seems :(

If ovs_kmod is .6ms why am I going to use something that is 6ms or
22ms. I expect a native xdp implementation using a hash map to be
inline with ovs kmod if not better. So if we have already have
an implementation in kernel that is 5x faster and better at flow
insertion another implementation that doesn't meet that threshold
should probably not go in kernel.

Additionally, for the OVS use case I would argue the XDP native
solution is straight forward to implement. Although I will defer
to OVS datapath experts here but above you noted nothing is
missing on the feature side?

> 
> >> When TC flower filter is offloaded to XDP, the received packets are
> >> handled by XDP first, and if their protocol or something is not
> >> supported by the eBPF program, the program returns XDP_PASS and packets
> >> are passed to upper layer TC.
> >>
> >> The packet processing flow will be like this when this mechanism,
> >> xdp_flow, is used with OVS.
> > 
> > Same as obove just cross out the 'TC flower' box and add support
> > for your missing features to 'XDP prog' box. Now you have less
> > code to maintain and less bugs and aren't pushing packets through
> > multiple hops in a call chain.
> 
> If we cross out TC then we would need similar code in OVS userspace.
> In total I don't think it would be less code to maintain.

Yes but I think minimizing kernel code and complexity is more important
than minimizing code in a specific userspace application/use-case.
Just think about the cost of a bug in kernel vs user space side. In
user space you have ability to fix and release your own code in kernel
side you will have to fix upstream, manage backports, get distributions
involved, etc.

I have no problem adding code if its a good use case but in this case
I'm still not seeing it.

> 
> > 
> >>
> >>   +-------------+
> >>   | openvswitch |
> >>   |    kmod     |
> >>   +-------------+
> >>          ^
> >>          | if not match in filters (flow key or action not supported by TC)
> >>   +-------------+
> >>   |  TC flower  |
> >>   +-------------+
> >>          ^
> >>          | if not match in flow tables (flow key or action not supported by XDP)
> >>   +-------------+
> >>   |  XDP prog   |
> >>   +-------------+
> >>          ^
> >>          | incoming packets
> >>
> >> Of course we can directly use TC flower without OVS to speed up TC.
> > 
> > huh? TC flower is part of TC so not sure what 'speed up TC' means. I
> > guess this means using tc flower offload to xdp prog would speed up
> > general tc flower usage as well?
> 
> Yes.
> 
> > 
> > But again if we are concerned about Mpps metrics just write the XDP
> > program directly.
> 
> I guess you mean any Linux users who want TC-like flow handling should develop
> their own XDP programs? (sorry if I misunderstand you.)
> I want to avoid such a situation. The flexibility of eBPF/XDP is nice and it's
> good to have any program each user wants, but not every sysadmin can write low
> level good performance programs like us. For typical use-cases like flow handling
> easy use of XDP through existing kernel interface (here TC) is useful IMO.

For OVS the initial use case I suggest write a XDP program tailored and
optimized for OVS. Optimize it for this specific use case.

If you want a general flow based XDP program write one, convince someone
to deploy and build a user space application to manage it. No sysadmin
has to touch this. Toke and others at RedHat appear to have this exact
use case in mind.

> 
> > 
> ...
> >> * About alternative userland (ovs-vswitchd etc.) implementation
> >>
> >> Maybe a similar logic can be implemented in ovs-vswitchd offload
> >> mechanism, instead of adding code to kernel. I just thought offloading
> >> TC is more generic and allows wider usage with direct TC command.
> >>
> >> For example, considering that OVS inserts a flow to kernel only when
> >> flow miss happens in kernel, we can in advance add offloaded flows via
> >> tc filter to avoid flow insertion latency for certain sensitive flows.
> >> TC flower usage without using OVS is also possible.
> > 
> > I argue to cut tc filter out entirely and then I think non of this
> > is needed.
> 
> Not correct. Even with native XDP use, multiple map lookup/modification
> from userspace is necessary for flow miss handling, which will lead to
> some latency.

I have not done got the data but I suspect the latency will be much
closer to the ovs kmod .6ms than the TC or xdp_flow latency.

> 
> And there are other use-cases for direct TC use, like packet drop or
> redirection for certain flows.

But these can be implemented in XDP correct?

> 
> > 
> >>
> >> Also as written above nftables can be offloaded to XDP with this
> >> mechanism as well.
> > 
> > Or same argument use XDP directly.
> 
> I'm thinking it's useful for sysadmins to be able to use XDP through
> existing kernel interfaces.

I agree its perhaps friendly to do so but for OVS not necessary and
if sysadmins want a generic XDP flow interface someone can write one.
Tell admins using your new tool gives 5x mpps improvement and orders
of magnitude latency reduction and I suspect converting them over
should be easy. Or if needed write an application in userspace that
converts tc commands to native XDP map commands.

I think for sysadmins in general (not OVS) use case I would work
with Jesper and Toke. They seem to be working on this specific problem.

> 
> > 
> >>
> >> Another way to achieve this from userland is to add notifications in
> >> flow_offload kernel code to inform userspace of flow addition and
> >> deletion events, and listen them by a deamon which in turn loads eBPF
> >> programs, attach them to XDP, and modify eBPF maps. Although this may
> >> open up more use cases, I'm not thinking this is the best solution
> >> because it requires emulation of kernel behavior as an offload engine
> >> but flow related code is heavily changing which is difficult to follow
> >> from out of tree.
> > 
> > So if everything was already in XDP why would we need these
> > notifications? I think a way to poll on a map from user space would
> > be a great idea e.g. everytime my XDP program adds a flow to my
> > hash map wake up my userspace agent with some ctx on what was added or
> > deleted so I can do some control plane logic.
> 
> I was talking about TC emulation above, so map notification is not related
> to this problem, although it may be a nice feature.

OK

> 
> > 
> > [...]
> > 
> > Lots of code churn...
> 
> Note that most of it is TC offload driver implementation. So it should add
> little complexity to network/XDP/TC core.

Maybe but I would still like the TC offload driver implementation to
be as straight forward as possible.

> 
> > 
> >>   24 files changed, 2864 insertions(+), 30 deletions(-)
> > 
> > Thanks,
> > John
> > 
> 
> Toshiaki Makita


