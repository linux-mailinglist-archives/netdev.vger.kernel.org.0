Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0997584C42
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiG2HAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiG2HAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:00:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B21E3C
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:00:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ez10so6890526ejc.13
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mwmHuLtF9G2EKODNbwTWiEpF4Sr2BhGxktiOGdwitQQ=;
        b=usBS4rgvXuy+sJxNC+QJXAnpQETBKSXJvLHaQrfLvFa7XRaa3LPSXOFKVqNow43eTc
         KNiJ6ArbLaWLEuuSSqL3JguiFIhqBleecXijNMpzsO7WiMxkONj+eczEFxsD3KkjYjhN
         eWANkL5QIkONppjks4jjlgGGD8nenrSE6pWIhVRvVJIeL2KggjtauuIb1vAKeaacqp0F
         +/5KvJhDA75INWx+q0RytS5XNPal/bNbmmcFn6IJw+pGdo5I6YDtu7+8F5xvct18IOZ9
         jrXSDSRZScXdNJZPRWuSycff+3CEKxVzBpifDhG1UL0qWnmhggGiNdqPSEPDDSa5251p
         nOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mwmHuLtF9G2EKODNbwTWiEpF4Sr2BhGxktiOGdwitQQ=;
        b=QN7ybFcM3k9qMtp0/r7Al5yziuGsBZtpPeUDFEU/R1chLi3Nho+XpFMBOKIsdyTpaG
         Y1NY3kI0uO4w6LPqzw2364CE78Z0yW2HrXnM+ecUANcQZhYu5DIBFyqC0atM5Mx0M/rj
         KOHZOVprAGSAjYJ+pFjox0zSgl7q+7Us5nK0qhbEqRRDFEu1bjivQ0Il2adRZZx5Dq7R
         QzlVcEqbGfmdw+OmhRsXR3Kbe6RKq5HcglGEiemZaCvJu1GYxGXu1UdgaV6UGFT2Ni0u
         YiVrNui901cGbbSDUR/U0o314beazl2HQvwvGSHH0M0V5Ism6+iGm6B/+2NoDOy7ix5n
         IMeA==
X-Gm-Message-State: AJIora9aQZN8x8KqG7ppxX4ctxpNOXCZQJ+HDK5zxqBzPme4xQLKe+lQ
        iZDNnXwTqAbn2IWPu/vQqKj2Rg==
X-Google-Smtp-Source: AGRyM1v7XxiRD+Ovqiy+Qb4zbzzo0ihjFJmtt45i2tVcNdyqYOzftdqePHq7shdpWsyykKpvtJtnpQ==
X-Received: by 2002:a17:906:5d16:b0:72f:248d:525a with SMTP id g22-20020a1709065d1600b0072f248d525amr1940654ejt.441.1659078009966;
        Fri, 29 Jul 2022 00:00:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o22-20020a170906769600b0072f5fa175b2sm1295648ejm.8.2022.07.29.00.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:00:08 -0700 (PDT)
Date:   Fri, 29 Jul 2022 09:00:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li zeming <zeming@nfschina.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/net/act: Remove temporary state variables
Message-ID: <YuOFd2oqA1Cbl+at@nanopsycho>
References: <20220727094146.5990-1-zeming@nfschina.com>
 <20220728201556.230b9efd@kernel.org>
 <YuN+i2WtzfA0wDQb@nanopsycho>
 <20220728235121.43bedc43@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728235121.43bedc43@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 29, 2022 at 08:51:21AM CEST, kuba@kernel.org wrote:
>On Fri, 29 Jul 2022 08:30:35 +0200 Jiri Pirko wrote:
>>> How many case like this are there in the kernel?
>>> What tool are you using to find this?
>>> We should focus on creating CI tools which can help catch instances of
>>> this pattern in new code before it gets added, rather than cleaning up
>>> old code. It just makes backports harder for hardly any gain.  
>> 
>> What backports do you have in mind exactly?
>
>Code backports. I don't understand the question.

Code backports of what where?
Are you talking about:
1) mainline kernels
2) distrubutions kernels? Or even worse, in-house kernels of companies?

If 2), I believe it is not relevant for the upstream discussion, at all.



>There's little benefit and we're getting multiple such patches a day.
