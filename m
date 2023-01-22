Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C825E676D1B
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 14:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjAVNTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 08:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjAVNS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 08:18:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D216AF3;
        Sun, 22 Jan 2023 05:18:56 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ud5so24392451ejc.4;
        Sun, 22 Jan 2023 05:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hFMHxL9sTmdXjv4LtwVeTzLVTX57xBl1PhL16vB1pco=;
        b=GUW9GHXb/QYUZFeo74w92f63SoZLwuaOLfG1hP0fKApD7WTPY6uX8JuWQAwvSXEpLh
         YSpz5P2Dgq4OLHku2iriVammMTsVQtJ+Fba3BWTpMGdrAPdfcTyb4S8eq2e/jq2heKVZ
         DZ1y1m9xYQwwhWQPlBpHapqk8CDzNQZSy2u8rVkMUl1ZuqWfeHbO8zPXlSjyHz0faWrA
         azaoBJ1X9395bZkR2XuKcbuv48v6j0eW5Hyp4rOOgLjTXGhqxolryA9HW/Q/2DOqx+th
         BCGPmS3NkYpns6stkQBHg9+8fJ+HwNYD0RyIp6fFXkAu97jLmQlC5pSzq7z1LwHnHbOT
         s3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFMHxL9sTmdXjv4LtwVeTzLVTX57xBl1PhL16vB1pco=;
        b=tS0tyUSV3aSnI7oj1hAfWDxrAVgix8p5iWXBoRFeZ8nj4X0ZtmBJRmXeAvnH5hPJZP
         3CpRe4LEuyCPRysxmkYEpCnsBvGQ+NfGcJeiB+NuJBORg0y9LEt6cUP+j/g4JuDD6juV
         5C+ELaouuQG7EjVNYGMVxFWUEaGU02yWjkZGcJjqbW6pZYJUHOYmI5+SKiI/Yo8ChxO0
         4gqlnw4kPrlGJeL2WtGwOz69HwYYJJQCHP5lUaNfU1McBBBTc55RSanqTtYtFP2ZFY7y
         ZI51zzgEmif/Ttmpwsbx2tysauaAliL5M2ioKYmARyrr4c8bZLG5QjmzP2Ce+41BLsMv
         55UA==
X-Gm-Message-State: AFqh2kq7QF8O9z40AzNa7scr5PFyVwJTtGcTnBoYOVlDGbyncalhqB+E
        7aPWA4uFEgwvGjrAGmavcIY9UZ9Kf+fDoAKWHxu+BA==
X-Google-Smtp-Source: AMrXdXuhwyW2ClK79YKnHoPOTe9OFvxhAY8MnyvQp++n384Yp7+RT8k25SGT66iuOMTCOAxa/+K6Ag==
X-Received: by 2002:a17:906:25c5:b0:84d:47e3:fe49 with SMTP id n5-20020a17090625c500b0084d47e3fe49mr21612806ejb.39.1674393535034;
        Sun, 22 Jan 2023 05:18:55 -0800 (PST)
Received: from localhost (tor-exit-at-the.quesadilla.party. [103.251.167.21])
        by smtp.gmail.com with ESMTPSA id la17-20020a170907781100b0084d3f3f9984sm19038892ejc.114.2023.01.22.05.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 05:18:54 -0800 (PST)
Date:   Sun, 22 Jan 2023 15:18:50 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y803rePcLc97CGik@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com>
 <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 05:03:20PM +0000, Hariprasad Kelam wrote:
> 
> 
> On Fri, Jan 20, 2023 at 08:50:16AM +0000, Hariprasad Kelam wrote:
> > 
> > On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> > > All VFs and PF netdev shares same TL1 schedular, each interface PF 
> > > or VF will have different TL2 schedulars having same parent TL1. The 
> > > TL1 RR_PRIO value is static and PF/VFs use the same value to 
> > > configure its
> > > TL2 node priority in case of DWRR children.
> > > 
> > > This patch adds support to configure TL1 RR_PRIO value using devlink.
> > > The TL1 RR_PRIO can be configured for each PF. The VFs are not 
> > > allowed to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO 
> > > value from the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.
> > 
> > I asked this question under v1, but didn't get an answer, could you shed some light?
> > 
> > "Could you please elaborate how these priorities of Transmit Levels are related to HTB priorities? I don't seem to understand why something has to be configured with devlink in addition to HTB.
> > 
> > SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are the first transmit levels.
> > Each send queue is mapped with SMQ.
> >  
> > As mentioned in cover letter, each egress packet needs to traverse all transmit levels starting from TL5 to TL1.
> 
> Yeah, I saw that, just some details about your hardware which might be obvious to you aren't so clear to me...
> 
> Do these transmit levels map to "layers" of HTB hierarchy? Does it look like this, or is my understanding completely wrong?
> 
> TL1                 [HTB root node]
>                    /               \
> TL2          [HTB node]         [HTB node]
>             /          \             |
> TL3    [HTB node]  [HTB node]   [HTB node]
> ...                       ...
> 
> Transmit levels to HTB mapping is correct.
> 
> 
> 
> > This applies to non-QOS Send queues as well.
> >  
> >                        SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1
> > 
> > By default non QOS queues use a default hierarchy  with round robin priority. 
> > To avoid conflict with QOS tree priorities, with devlink user can choose round-robin priority before Qos tree formation.
> 
> So, this priority that you set with devlink is basically a weight of unclassified (default) traffic for round robin between unclassified and classified traffic, right? I.e. you have two hierarchies (one for HTB, another for non-QoS queue), and you do DWRR between them, according to this priority?
> 
> 
>  Not exactly, In the given scenario where  multiple vfs are attached to PF netdev.
>  each VF unclassified traffic forms a hierarchy and PF also forms a hierarchy for unclassified traffic.
>  
> Now traffic from these all tress(multiple vfs and PFs) are aggregated at TL1. HW performs DWRR among them since these TL2 queues (belonging to each pf and vf netdevs) will be configured with the same priority by the driver.
> 
> Currently, this priority is hard coded. Now we are providing this as a configurable value to the user.
> 
> Now if a user adds a HTB node, this will have strict priority at TL2 level since DWRR priority is different this traffic won't be affected by DWRR unclassified traffic.

So, did I get it right now?

                                     [strict priority**]
                           /---------/                 \-----\
                           |                                 |
                        [DWRR*]                              |
        /---------------/  |   \---------------\             |
        |                  |                   |             |
[ Hierarchy for ]  [ Hierarchy for  ]  [ Hierarchy for  ]    |
[ unclassified  ]  [  unclassified  ]  [  unclassified  ]    |
[traffic from PF]  [traffic from VF1]  [traffic from VF2]    |
[      ***      ]  [      ***       ]  [      ***       ]    |
                                                             |
                                                [HTB hierarchy using]
                                                [  strict priority  ]
                                                [   between nodes   ]

As far as I understand, you set priorities at ***, which affect DWRR
balancing at *, but it's not clear to me how the selection at ** works.
Does the HTB hierarchy have some fixed priority, i.e. the user can set
priority for unclassified traffic to be higher or lower than HTB
traffic?

Please also point me at any inaccuracies in my picture, I really want to
understand the algorithm here, because configuring additional priorities
outside of HTB looks unusual to me.

> 
> Thanks,
> Hariprasad k
