Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D52678733
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjAWUGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbjAWUGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:06:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866A15CBD;
        Mon, 23 Jan 2023 12:06:05 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id az20so33638121ejc.1;
        Mon, 23 Jan 2023 12:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVxXYLf6dJRKFw4C39s87f7GX4Jn+DpaX4qoTjZeP88=;
        b=OMW2dgMwahTWnaDzUuLt8vh9H494PaXQ/+nlROqyU9YWIiCq8xi9aoG//wjioB0vPF
         eeoeesPy3KoMdm/adWiS/mcU5z7XugIsEU/kAZY1zSHak5smEtjCVH/9DzMm0v0g+40M
         lyO2Nf6IS+tVYKbZHM9vOCZaMUt6Xo4aCdQC9faxadLnTmDyCE6BdGGk49rPz5Af/39v
         Nt+6nzdmUme8UijgLgcjB6nzGKSrsPOmiAyRUf4wkwy5BtvryuvCxlZ5zJ8n+5zCsdhh
         rUU33moQBzFGTIJR/CpHVbEW+Its2GJQTCsvdDiQBW1FNNOSj+RGY4nmgZBYGoJ5mv9R
         x5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVxXYLf6dJRKFw4C39s87f7GX4Jn+DpaX4qoTjZeP88=;
        b=AnQqK0lW3oFshisi/HDd1H6ZbaWzGghKWvtVIjwQiwDbc3pGFxFIWh+vEbaLC8NYf1
         uZFkMETFWoW4igkPFbLLdzOZ1fzfNcy+JKGbqW+mvNosePoVVcSAd/Y51IBRrNVQVeu3
         oKJg1lLMzULOPpFNlaxfgu7zqKQ8c5lNWpwN1k9LrV5MVSzgCIKmzA4U6W2ZJGq60wC2
         knGIz1ahKjpbrjES2BSGQK/LjX2P/3RDgPfCew/F7rOH6BBmtvmKG8Qv50zRqcQhVdxW
         1vGf+9MbpJ1CDwEllftCSzLvYBWccCW6cRK6e8pIc5v/HOdn+KIyCOtBdPD9DetlD4ie
         ZUQw==
X-Gm-Message-State: AFqh2konuAy5zhjk2mFF7MHm5TspD9Fgyrd+DfYnIqqrKM5V9ujTHsXx
        ijRz11XVuJZW90vCxbGRKks=
X-Google-Smtp-Source: AMrXdXtIiM0lLosbbCEwDKJxUjSDfI35h6t2yIueMcf7qJ80v2jO/4JhTlIr/CqwY8jMmWbff+dm+Q==
X-Received: by 2002:a17:906:4754:b0:871:8cb:14e8 with SMTP id j20-20020a170906475400b0087108cb14e8mr21131013ejs.9.1674504364073;
        Mon, 23 Jan 2023 12:06:04 -0800 (PST)
Received: from localhost ([45.154.98.176])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007a4e02e32ffsm22685479ejc.60.2023.01.23.12.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 12:06:03 -0800 (PST)
Date:   Mon, 23 Jan 2023 22:05:58 +0200
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y87onaDuo8NkFNqC@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com>
 <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
 <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
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

On Mon, Jan 23, 2023 at 05:03:01PM +0000, Hariprasad Kelam wrote:
> 
> 
> > 
> > On Fri, Jan 20, 2023 at 08:50:16AM +0000, Hariprasad Kelam wrote:
> > > 
> > > On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> > > > All VFs and PF netdev shares same TL1 schedular, each interface PF 
> > > > or VF will have different TL2 schedulars having same parent TL1. 
> > > > The
> > > > TL1 RR_PRIO value is static and PF/VFs use the same value to 
> > > > configure its
> > > > TL2 node priority in case of DWRR children.
> > > > 
> > > > This patch adds support to configure TL1 RR_PRIO value using devlink.
> > > > The TL1 RR_PRIO can be configured for each PF. The VFs are not 
> > > > allowed to configure TL1 RR_PRIO value. The VFs can get the 
> > > > RR_PRIO value from the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.
> > > 
> > > I asked this question under v1, but didn't get an answer, could you shed some light?
> > > 
> > > "Could you please elaborate how these priorities of Transmit Levels are related to HTB priorities? I don't seem to understand why something has to be configured with devlink in addition to HTB.
> > > 
> > > SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are the first transmit levels.
> > > Each send queue is mapped with SMQ.
> > >  
> > > As mentioned in cover letter, each egress packet needs to traverse all transmit levels starting from TL5 to TL1.
> > 
> > Yeah, I saw that, just some details about your hardware which might be obvious to you aren't so clear to me...
> > 
> > Do these transmit levels map to "layers" of HTB hierarchy? Does it look like this, or is my understanding completely wrong?
> > 
> > TL1                 [HTB root node]
> >                    /               \
> > TL2          [HTB node]         [HTB node]
> >             /          \             |
> > TL3    [HTB node]  [HTB node]   [HTB node]
> > ...                       ...
> > 
> > Transmit levels to HTB mapping is correct.
> > 
> > 
> > 
> > > This applies to non-QOS Send queues as well.
> > >  
> > >                        SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1
> > > 
> > > By default non QOS queues use a default hierarchy  with round robin priority. 
> > > To avoid conflict with QOS tree priorities, with devlink user can choose round-robin priority before Qos tree formation.
> > 
> > So, this priority that you set with devlink is basically a weight of unclassified (default) traffic for round robin between unclassified and classified traffic, right? I.e. you have two hierarchies (one for HTB, another for non-QoS queue), and you do DWRR between them, according to this priority?
> > 
> > 
> >  Not exactly, In the given scenario where  multiple vfs are attached to PF netdev.
> >  each VF unclassified traffic forms a hierarchy and PF also forms a hierarchy for unclassified traffic.
> >  
> > Now traffic from these all tress(multiple vfs and PFs) are aggregated at TL1. HW performs DWRR among them since these TL2 queues (belonging to each pf and vf netdevs) will be configured with the same priority by the driver.
> > 
> > Currently, this priority is hard coded. Now we are providing this as a configurable value to the user.
> > 
> > Now if a user adds a HTB node, this will have strict priority at TL2 level since DWRR priority is different this traffic won't be affected by DWRR unclassified traffic.
> 
> So, did I get it right now?
> 
>                                      [strict priority**]
>                            /---------/                 \-----\
>                            |                                 |
>                         [DWRR*]                              |
>         /---------------/  |   \---------------\             |
>         |                  |                   |             |
> [ Hierarchy for ]  [ Hierarchy for  ]  [ Hierarchy for  ]    |
> [ unclassified  ]  [  unclassified  ]  [  unclassified  ]    |
> [traffic from PF]  [traffic from VF1]  [traffic from VF2]    |
> [      ***      ]  [      ***       ]  [      ***       ]    |
>                                                              |
>                                                 [HTB hierarchy using]
>                                                 [  strict priority  ]
>                                                 [   between nodes   ]
> 
> 
> 
>         Adjusted picture
> 
>                         /--------------------------------------------------------------------------------/       Transmit level 1
>                             |                                                                                      | 
>                         [DWRR*] [ priority 6 ]                                      [strict priority** ]      [ priority 0 ]  Transmit level 2
>         /---------------/  |   \-----------------------------------\                           |
>              |                   |                                   |                                           |
> [ Hierarchy for ]  [ Hierarchy for  ]  [ Hierarchy for  ]                 [ Hierarchy for  ] 
> [ unclassified  ]  [  unclassified  ]  [  unclassified  ]                      [ strict priority  ]
> [traffic from PF]  [traffic from VF1]  [traffic from VF2]   
> [      ***      ]  [      ***       ]  [      ***       ]    
>                                                 
> 
> 
> As far as I understand, you set priorities at ***, which affect DWRR balancing at *, but it's not clear to me how the selection at ** works.
> Does the HTB hierarchy have some fixed priority,  ?
> 
> Hardware supports priorities from 0 to 7. lower value has high priority.
> nodes having the same priority are treated as DWRR childs.
> 
> i.e. the user can set priority for unclassified traffic to be higher or lower than HTB traffic?
> 
> Yes its user configurable, unclassified traffic priority can be higher or lower than HTB traffic if a user wishes to configure it.
> 
> Please also point me at any inaccuracies in my picture, I really want to understand the algorithm here, because configuring additional priorities outside of HTB looks unusual to me.
> 
>   Please check the adjusted picture. Let us assume a user has set the priority as 6 for DWRR (unclassified traffic)  and  HTB strict priority as 0.
> Once all traffic reaches  TL2,  Now hardware algorithm first pics HTB strict priority and processes DWRR later according to their priorities.

OK, I seem to get it now, thanks for the explanation!

How do you set the priority for HTB, though? You mentioned this command
to set priority of unclassified traffic:

devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
cmode runtime

But what is the command to change priority for HTB?

What bothers me about using devlink to configure HTB priority is:

1. Software HTB implementation doesn't have this functionality, and it
always prioritizes unclassified traffic. As far as I understand, the
rule for tc stuff is that all features must have a reference
implementation in software.

2. Adding a flag (prefer unclassified vs prefer classified) to HTB
itself may be not straightforward, because your devlink command has a
second purpose of setting priorities between PFs/VFs, and it may
conflict with the HTB flag.

> 
> > 
> > Thanks,
> > Hariprasad k
