Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6046798D9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjAXNCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAXNCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:02:39 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40C2132;
        Tue, 24 Jan 2023 05:02:38 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vw16so38764846ejc.12;
        Tue, 24 Jan 2023 05:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAvuDW74OPZh1h9grz8bITx0Gg1E0b20n7bNbMIV6hI=;
        b=HVdnsi7ls0oRQ2fRY5Cnh/CDfACr8/IXLxbXf81T1mk3VLW5s6X0iy8pYcXxPjLyqY
         Csx1K/6i8ZuMF2z+EUf2Zq15M85jWUgTyky5TwLWGiaRkhyfinhiNw3Hvp/muHddGtSe
         LDDN+ODIi2tzt9GbFw9ySD2yAl/jrz7ee1E6Pw96wNXibonrAexSzWWmV3yLysxVG5BJ
         cqzzK49nC2IO2vAKfVyoD4zjT2b+xJNT45HmVxdezglZ6PVYAInDxNz//llmQf+6NuLI
         AFsuUY9lsn0WQ4k3JepmEloEv1bEYedtMGBap6hraZRJhF0xk9MlV731LRbOcRAPJ7kg
         Gr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAvuDW74OPZh1h9grz8bITx0Gg1E0b20n7bNbMIV6hI=;
        b=aW0og48J13oGhqzagEHaEKSgZQJsTxl6DZUmOLfcWhiLaNkmatraQ2mPhB04RhMpte
         xIHO2Lvf1y2sluCqaBKMfX9C2h0rDtO5MtAD7WSpx3x3+s/uDMx1Ur/fvXCa8CIjh8AL
         ApudN1yZQxwd8SwcQodBTgpTqcKaPoOb1CLJUwRX7P6vHhJuKAjyNNCKAnHz4/cSRCE9
         YyHtA67tnr+MLe6Z3kPcTAOvbaXAjsGmN42/gm6829Ys4tGPW9xzTJoK7qOQ65nSsPoU
         T/gGc/dbUggUHDctzKvCSJe2h2jJUhiqakqDj35Sn5nLa7KYAwPKI2iFJoFZuYG5nkoz
         LEEg==
X-Gm-Message-State: AFqh2kpWQy/j1IRsQNgsyVosV6y117QbgH5xkGnJZy0zayd0vWaY/pkq
        NiHSKwprL4akTYoqZkwjLQQ=
X-Google-Smtp-Source: AMrXdXsHKuG58iJrwYbWLCfGrskbqkMVL6HyvLwGRl86EPx+Yg+Ed6GCWYWbIbXUwq1BNuBNmTs8SA==
X-Received: by 2002:a17:907:11cd:b0:870:b950:18e7 with SMTP id va13-20020a17090711cd00b00870b95018e7mr30650043ejb.19.1674565356284;
        Tue, 24 Jan 2023 05:02:36 -0800 (PST)
Received: from localhost ([185.246.188.67])
        by smtp.gmail.com with ESMTPSA id jp9-20020a170906f74900b00877800030f2sm851309ejb.169.2023.01.24.05.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:02:35 -0800 (PST)
Date:   Tue, 24 Jan 2023 15:02:29 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y8/W5dMmkqkYFNEb@mail.gmail.com>
References: <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
 <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y87onaDuo8NkFNqC@mail.gmail.com>
 <20230123144548.4a2c06ae@kernel.org>
 <Y88Rug7iaC0nOGvu@mail.gmail.com>
 <PH0PR18MB44748DFCCABCDC2806A2DC2CDEC99@PH0PR18MB4474.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB44748DFCCABCDC2806A2DC2CDEC99@PH0PR18MB4474.namprd18.prod.outlook.com>
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 11:49:48AM +0000, Hariprasad Kelam wrote:
> 
> 
> > On Mon, Jan 23, 2023 at 02:45:48PM -0800, Jakub Kicinski wrote:
> > > On Mon, 23 Jan 2023 22:05:58 +0200 Maxim Mikityanskiy wrote:
> > > > OK, I seem to get it now, thanks for the explanation!
> > > >
> > > > How do you set the priority for HTB, though? You mentioned this
> > > > command to set priority of unclassified traffic:
> > > >
> > > > devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
> > > > cmode runtime
> > > >
> > > > But what is the command to change priority for HTB?
> > > >
> > > > What bothers me about using devlink to configure HTB priority is:
> > > >
> > > > 1. Software HTB implementation doesn't have this functionality, and
> > > > it always prioritizes unclassified traffic. As far as I understand,
> > > > the rule for tc stuff is that all features must have a reference
> > > > implementation in software.
> > > >
> > > > 2. Adding a flag (prefer unclassified vs prefer classified) to HTB
> > > > itself may be not straightforward, because your devlink command has
> > > > a second purpose of setting priorities between PFs/VFs, and it may
> > > > conflict with the HTB flag.
> > >
> > > If there is a two-stage hierarchy the lower level should be controlled
> > > by devlink-rate, no?
> > 
> > From the last picture by Hariprasad, I understood that the user sets all
> > priorities (for unclassified traffic per PF and VF, and for HTB traffic) on the
> > same TL2 level, i.e. it's not two-stage. (Maybe I got it all wrong again?)
> > 
> > I asked about the command to change the HTB priority, cause the
> > parameters aren't easily guessed, but I assume it's also devlink (i.e.
> > driver-specific).
> > 
> Currently, we don't support changing HTB priority since TC_HTB_MODIFY is not yet supported.
> The driver implementation is inline with htb tc framework, below are commands we use for setting htb priority
> 
> ethtool -K eth0 hw-tc-offload on
> tc qdisc replace dev eth0 root handle 1: htb offload
> tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio 2
> tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio 3

I thought there was a concept of a priority of the whole HTB tree in
your implementation...

So, if I run these commands:

devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 2 cmode runtime
tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio 1
tc class add dev eth0 parent 1: classid 1:2 htb rate 10Gbit prio 3

Will it prioritize class 1:1 over unclassified traffic, and unclassified
traffic over class 1:2?

> > If there were two levels (the upper level chooses who goes first: HTB or
> > unclassified, and the lower level sets priorities per PF and VF for unclassified
> > traffic), that would be more straightforward to solve: the upper level should
> > be controlled by a new HTB parameter, and the lower level is device-specific,
> > thus it goes to devlink.
> 
> The PF netdev and VFs share the same physical link and share the same TL1 node.
> Hardware supports one DWRR group and the rest are strict priority nodes. Driver configures
> the priority set by devlink to PF and VF traffic TL2 nodes such that traffic is forwarded
> to TL1 using DWRR algorithm.
> 
> Now that if we add htb command for unclassified traffic, at any given point in time HTB
> rule only applies to a single interface, since we require to set DWRR priority at TL1, 
> which applies to both PF/VFs, we feel it's a different use case altogether.

Thanks, with the example above your explanation makes sense to me now.

So, basically, in your implementation, entities prioritized by hardware
are: each HTB class, each VF and PF; you want to keep user-assigned
priorities for HTB classes, you want to let the user assign a priority
for unclassified traffic, but the latter must be equal for all VFs and
PF (for DWRR to work), correct? And that devlink command is only useful
in the HTB scenario, i.e. it doesn't matter what tl1_rr_prio you set if
HTB is not used, right?

What I don't like in the current implementation is that it adds a
feature to HTB, bypassing HTB (also not providing a software equivalent
of the feature). I would expect the priority of unclassified traffic to
be configured with tc commands that set up HTB (by the way, HTB has a
"default" option to choose a class for unclassified traffic, and a
priority can be set for this class - this functionality can be leveraged
for this purpose, or a new option can be added, whatever looks more
appropriate). On the other hand, I understand your hardware limitation
requiring to have the same priority for all VFs and PF on the same port.

It's hard to suggest something good here, actually... An obvious thought
is to let the first netdev that configures HTB choose the priority for
unclassified traffic, and block attempts from other netdevs to set a
different one, but this approach also has obvious drawbacks: PF has no
special powers here, and it can't set the desired priority if PF itself
doesn't use HTB (or doesn't configure it first, before VFs).

Another idea of mine is to keep the devlink command for enforcement
purpose, and make the behavior as follows:

1. The user will pick a priority for unclassified traffic when attaching
HTB.

2. If tl1_rr_prio was set with devlink, block attempts to attach HTB
with a different default priority.

3. If tl1_rr_prio wasn't set or was reset, allow attaching HTB to PF
with any default priority. 

This way, VFs can't attach HTB with arbitrary priorities, only with the
one that the admin has enforced using devlink. At the same time, if VFs
aren't used, no extra steps are needed to just use HTB on a PF. On the
other hand, it adds some complexity and may sound controversial to
someone. Thoughts?
