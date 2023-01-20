Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8C6755F8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjATNiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjATNiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:38:09 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A0249037;
        Fri, 20 Jan 2023 05:38:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id kt14so14059008ejc.3;
        Fri, 20 Jan 2023 05:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BncwWmxqW+84mqxgyYf9Sxyq1qQG5dqQ2KZ6PEmYiwo=;
        b=fMThkOaZ7BNLx9zzo/D1ogmbTSqYuSXmB0UIR7KBxsWrdbZNkesrbC0YeSlkBHC9LE
         AqOKS/0IBT0VPcO2bzEyaP96+DSWp5BCIvUPSif72smrKa5tl7jRLg3Opl+9lPtYhr27
         3ircReqRQnJRH5pJIGjnqaxcT/AWXJ/fJhbxUvoltzt6W8YaYEx9z1XOnYshrds3XZ7p
         2zUC2zjsndN0kLVt37ZQipxmzbIGZy87hG8/w7DZLITQreC1u1bJyB+zYadBDhWlxhHJ
         G1vSq1rCJVnCHyJ2Lk+owq6QkifIcayXjWbzMUI3irD+6kTKIhBS+C3KI1yRQ7Sy1MRX
         LGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BncwWmxqW+84mqxgyYf9Sxyq1qQG5dqQ2KZ6PEmYiwo=;
        b=cpC1iOD5kkTOPmt4AoIWU5I9ej2KEoHlWCiRLUIWvAAxz2KqhCOeosLNJZWyVecYHI
         xk8U8/Lou1DnswzUuPKUxpEo6MiHGj1tPrDB1cgO//Byd5Em7Wo4pIKC4VVxNfmgdbGL
         22oLg704FGtM99pe3xGAVZI7btaJgfjUwnNdNqCzI457Vr1TnTzRh3YFZtLtH2wA8SJ0
         4Ho5VmLmazcagVy0kX6fnF0Ve8J6HZS3exIKm/gcyW2aIamqve9w9gO7P6Nd6SCjbK5L
         yoWP51T0/+XaZFGbMSUo9Fhl6MKUlr2KgU7g7FFnNZruJcap7PVncAsAv1mhSfmcEqPz
         nfLQ==
X-Gm-Message-State: AFqh2kr+4wgGzXMQPJ+Np8W6w38P5WPbAtSjpLr0vUVfWgGF1gTLzHkU
        ejdr1uiml3nM2LlMn+zlUZ8=
X-Google-Smtp-Source: AMrXdXvTVZ/k33W79E84WnQBi+PCetHQA1n9Hu9bUQwW9inGYovef+t+N1t7rg6haeK8hxb2gjyc5g==
X-Received: by 2002:a17:907:6294:b0:86a:1afa:6dd8 with SMTP id nd20-20020a170907629400b0086a1afa6dd8mr41487837ejc.69.1674221884302;
        Fri, 20 Jan 2023 05:38:04 -0800 (PST)
Received: from localhost (tor-exit-16.zbau.f3netze.de. [185.220.100.243])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709063d2200b0087276f66c6asm5779377ejf.115.2023.01.20.05.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 05:38:03 -0800 (PST)
Date:   Fri, 20 Jan 2023 15:37:58 +0200
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
Message-ID: <Y8qZNhUgsdOMavC4@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com>
 <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
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

On Fri, Jan 20, 2023 at 08:50:16AM +0000, Hariprasad Kelam wrote:
> 
> On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> > All VFs and PF netdev shares same TL1 schedular, each interface PF or 
> > VF will have different TL2 schedulars having same parent TL1. The TL1 
> > RR_PRIO value is static and PF/VFs use the same value to configure its 
> > TL2 node priority in case of DWRR children.
> > 
> > This patch adds support to configure TL1 RR_PRIO value using devlink.
> > The TL1 RR_PRIO can be configured for each PF. The VFs are not allowed 
> > to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO value from 
> > the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.
> 
> I asked this question under v1, but didn't get an answer, could you shed some light?
> 
> "Could you please elaborate how these priorities of Transmit Levels are related to HTB priorities? I don't seem to understand why something has to be configured with devlink in addition to HTB.
> 
> SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are the first transmit levels.
> Each send queue is mapped with SMQ.
>  
> As mentioned in cover letter, each egress packet needs to traverse all transmit levels starting from TL5 to TL1.

Yeah, I saw that, just some details about your hardware which might be
obvious to you aren't so clear to me...

Do these transmit levels map to "layers" of HTB hierarchy? Does it look
like this, or is my understanding completely wrong?

TL1                 [HTB root node]
                   /               \
TL2          [HTB node]         [HTB node]
            /          \             |
TL3    [HTB node]  [HTB node]   [HTB node]
...                       ...


> This applies to non-QOS Send queues as well.
>  
>                        SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1
> 
> By default non QOS queues use a default hierarchy  with round robin priority. 
> To avoid conflict with QOS tree priorities, with devlink user can choose round-robin priority before Qos tree formation.

So, this priority that you set with devlink is basically a weight of
unclassified (default) traffic for round robin between unclassified and
classified traffic, right? I.e. you have two hierarchies (one for HTB,
another for non-QoS queue), and you do DWRR between them, according to
this priority?

> BTW, why did you remove the paragraphs with an example and a limitation?
> I think they are pretty useful.
> 
> Ok , removed them accidentally will correct in the next version.
> 
> Another question unanswered under v1 was:
> 
> "Is there any technical difficulty or hardware limitation preventing from implementing modifications?" (TC_HTB_NODE_MODIFY)
> 
> There is no hardware limitation, we are currently implementing it.  once it's implemented we will submit for review.

Great, that's nice to hear, looking forward to it.
