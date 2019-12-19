Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEDD126719
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLSQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:32:09 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:44911 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfLSQcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:32:08 -0500
Received: by mail-pl1-f175.google.com with SMTP id az3so2776150plb.11
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 08:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QZG5dYiI8oM64dR2QXIexuoTL4Hz7S5sRgx4TD3K9uo=;
        b=j/xDR4nQalRWrjfeAVPZaTwwpqxL9BBLna1Hsu4k4ahKVvPINfvs2c8hIOlLLuQwPf
         yPuaDuuDAB72LMgC43ivica01E+xQv5yONC92iARx+tefCBDx5F99mkWELmDR/vFbXix
         9gLSjcsGDGQIGYArm0xU0JxnKezIZli0o6FiTnlx15ovJuhyy5+LhS8lQqTapxh3gJfd
         g+n7hOmkp+NO/PtrCBUDJMvaBNW/D9CtwssdnsoJs9Aw1fzN6f91I/Ao/4XR9GQvxvBn
         ynlqKKES46hb6+xO/LU0ET/h3MUP0ah8at+mrFp2AP00dzLt/wUPyzrCdLIAP9fu26Y9
         z1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QZG5dYiI8oM64dR2QXIexuoTL4Hz7S5sRgx4TD3K9uo=;
        b=ZYTSudagJTeSE/6Q84m4WRGA9NeVoQcRwmo91EeR5b2B9b9qmoOwyFIoiN1hj4tPFO
         kv1+58KMEuR95WFMhcEoDZ8xobc9/iCsZfaIV+1DAsoVYorvCnPEN1B5NhRsR/H/NcUR
         5mjqDBZxNa8hfR3NRYMh0Euz4iDwhxQHT6CquIGAGvNuuiY++HYBesblEYrPlB4vx/mC
         /swXnLR8+fApp2eIq1kemXF5xRUYsJ4hSxLuGji/kMF2wJNVX6nBAG2ay6rjRNogheMH
         vEiGGQFAOJzBI55nptfThLD3bbrPkb44HIC+MY+S3rGTWW4vm+f8z6FnrtugLr0jUlgM
         R6MQ==
X-Gm-Message-State: APjAAAWx4OeGXMyuPaYdvmyVO2nq/Ob08n9MJceQbbKOABLqGN7EQW/v
        GOIzhm2f0RRa1b3EV01l0qBTkZwD
X-Google-Smtp-Source: APXvYqxVNN3cMIAaTCgmmbL70wf74rfCB2uk/09WbGwDgXRcfW1X/ffl8dawrSLtRIoNO1Xlq22pJg==
X-Received: by 2002:a17:90a:6484:: with SMTP id h4mr10097020pjj.84.1576773127198;
        Thu, 19 Dec 2019 08:32:07 -0800 (PST)
Received: from localhost (c-98-246-132-65.hsd1.or.comcast.net. [98.246.132.65])
        by smtp.gmail.com with ESMTPSA id n1sm7651203pfd.47.2019.12.19.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 08:32:06 -0800 (PST)
Date:   Thu, 19 Dec 2019 08:32:09 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Petr Machata <petrm@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Message-ID: <5dfba6091d854_61ae2ac457a865c45f@john-XPS-13-9370.notmuch>
In-Reply-To: <87eex1o528.fsf@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
 <5dfa525bc3674_2dca2afa496f05b86e@john-XPS-13-9370.notmuch>
 <87eex1o528.fsf@mellanox.com>
Subject: Re: [PATCH net-next mlxsw v2 00/10] Add a new Qdisc, ETS
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata wrote:
> 
> John Fastabend <john.fastabend@gmail.com> writes:
> 
> > Petr Machata wrote:
> >> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
> >> transmission selection algorithms: strict priority, credit-based shaper,
> >> ETS (bandwidth sharing), and vendor-specific. All these have their
> >> corresponding knobs in DCB. But DCB does not have interfaces to configure
> >> RED and ECN, unlike Qdiscs.
> >
> > So the idea here (way back when I did this years ago) is that marking ECN
> > traffic was not paticularly CPU intensive on any metrics I came up with.
> > And I don't recall anyone ever wanting to do RED here. The configuration
> > I usually recommended was to use mqprio + SO_PRIORITY + fq per qdisc. Then
> > once we got the BPF egress hook we replaced SO_PRIORITY configurations with
> > the more dynamic BPF action to set it. There was never a compelling perf
> > reason to offload red/ecn.
> >
> > But these use cases were edge nodes. I believe this series is mostly about
> > control path and maybe some light control traffic? This is for switches
> > not for edge nodes right? I'm guessing because I don't see any performance
> > analaysis on why this is useful, intuitively it makes sense if there is
> > a small CPU sitting on a 48 port 10gbps box or something like that.
> 
> Yes.
> 
> Our particular use case is a switch that has throughput in Tbps. There
> simply isn't enough bandwidth to even get all this traffic to the CPU,
> let alone process it on the CPU. You need to offload, or it doesn't make
> sense. 48 x 10Gbps with a small CPU is like that as well, yeah.

Got it so I suspect primary usage will be offload then at least for
the initial usage.

> 
> From what I hear, RED / ECN was not used very widely in these sorts of
> deployments, rather the deal was to have more bandwidth than you need
> and not worry about QoS. This is changing, and people experiment with
> this stuff more. So there is interest in strict vs. DWRR TCs, shapers,
> and RED / ECN.
> 
> >> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
> >> transmission selection algorithm can then be modeled by having e.g. TBF or
> >> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
> >> placing a DRR Qdisc under the last PRIO band.
> >>
> >> The problem with this approach is that DRR on its own, as well as the
> >> combination of PRIO and DRR, are tricky to configure and tricky to offload
> >> to 802.1Qaz-compliant hardware. This is due to several reasons:
> >
> > I would argue the trick to configure part could be hid behind tooling to
> > simplify setup. The more annoying part is it was stuck behind the qdisc
> > lock. I was hoping this would implement a lockless ETS qdisc seeing we
> > have the infra to do lockless qdiscs now. But seems not. I guess software
> > perf analysis might show prio+drr and ets here are about the same performance
> > wise.
> 
> Pretty sure. It's the same algorithm, and I would guess that the one
> extra virtual call will not throw it off.

Yeah small in comparison to other performance issues I would guess.

> 
> > offload is tricky with stacked qdiscs though ;)
> 
> Offload and configuration both.
> 
> Of course there could be a script to somehow generate and parse the
> configuration on the front end, and some sort of library to consolidate
> on the driver side, but it's far cleaner and easier to understand for
> all involved if it's a Qdisc. Qdiscs are tricky, but people still
> understand them well in comparison.

At one point I wrote an app to sit on top of the tc netlink interface
and create common (at least for the customers at the time) setups. But
that tool is probably lost to history at this point.

I don't think its paticularly difficult to build this type of tool
on top of the API but also not against a new qdisc like this that
folds in a more concrete usage and aligns with a spec. And Dave
already merged it so good to see ;)

[...]

> >> The chosen interface makes the overall system both reasonably easy to
> >> configure, and reasonably easy to offload. The extra code to support ETS in
> >> mlxsw (which already supports PRIO) is about 150 lines, of which perhaps 20
> >> lines is bona fide new business logic.
> >
> > Sorry maybe obvious question but I couldn't sort it out. When the qdisc is
> > offloaded if packets are sent via software stack do they also hit the sw
> > side qdisc enqueue logic? Or did I miss something in the graft logic that
> > then skips adding the qdisc to software side? For example taprio has dequeue
> > logic for both offload and software cases but I don't see that here.
> 
> You mean the graft logic in the driver? All that stuff is in there just
> to figure out how to configure the device. SW datapath packets are
> still handled as usual.

Got it just wasn't clear to me when viewing it from the software + smartnic
use case. So is there a bug or maybe just missing feature, where if I
offloaded this on a NIC that both software and hardware would do the ETS
algorithm? How about on the switch would traffic from the CPU be both ETS 
classified in software and in hardware? Or maybe CPU uses different interface
without offload on?

> 
> There even is a selftest for the SW datapath that uses veth pairs to
> implement interconnect and TBF to throttle it (so that the scheduling
> kicks in).

+1

> 
> >>
> >> Credit-based shaping transmission selection algorithm can be configured by
> >> adding a CBS Qdisc under one of the strict bands (e.g. TBF can be used to a
> >> similar effect as well). As a non-work-conserving Qdisc, CBS can't be
> >> hooked under the ETS bands. This is detected and handled identically to DRR
> >> Qdisc at runtime. Note that offloading CBS is not subject of this patchset.
> >
> > Any performance data showing how accurate we get on software side? The
> > advantage of hardware always to me seemed to be precision in the WRR algorithm.
> 
> Quantum is specified as a number of bytes allowed to dequeue before a
> queue loses the medium. Over time, the amount of traffic dequeued from
> individual queues should average out to be the quanta your specified. At
> any point in time, size of the packets matters: if I push 1000B packets
> into a 10000B-quantum queue, it will use 100% of its allocation. If they
> are 800B packets, there will be some waste (and it will compensate next
> round).
> 
> As far as the Qdisc is defined, the SW side is as accurate as possible
> under given traffic patterns. For HW, we translate to %, and rounding
> might lead to artifacts. You kinda get the same deal with DCB, where
> there's no way to split 100% among 8 TCs perfectly fairly.
> 
> > Also data showing how much overhead we get hit with from basic mq case
> > would help me understand if this is even useful for software or just a
> > exercise in building some offload logic.
> 
> So the Qdisc is written to do something reasonable in the SW datapath.
> In that respect it's as useful as PRIO and DRR are. Not sure that as a
> switch operator you really want to handle this much traffic on the CPU
> though.

I was more thinking of using it in the smart nic case.

> 
> > FWIW I like the idea I meant to write an ETS sw qdisc for years with
> > the expectation that it could get close enough to hardware offload case
> > for most use cases, all but those that really need <5% tolerance or something.

Anyways thanks for the answers clears it up on my side. One remaining
question is if software does send packets if they get both classified
via software and hardware. Might be worth thinking about fixing if
that is the case or probably more likely switch knows not to do
this.

Thanks,
John
