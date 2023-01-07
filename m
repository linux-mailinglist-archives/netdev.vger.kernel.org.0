Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34D2660D3F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAGJX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjAGJXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:23:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B025F63
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:23:52 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b2so4200306pld.7
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJcr1o3EdZ1/zMPCA+HFmdVb9vG8ctZnuTQujRdta1E=;
        b=brBfgQA4zfbadqm197i3GVgk605MknSmTFZ+v9scvIdFY3hrnf76qOooE7SltTPvC+
         C7+nNXjqpUscGrkA4xHWo1wJytKITk7EL3DTchkF5cCNo4Pt9Bh+gOQLudXx6GfGfzf7
         2Hv1oUQ+dIInlarAM9yPj2w/WVDBr5xDdgNXkveMNGT0P2i/aZxhep1sibTm9zs/Nv6d
         XqqEsgT0czLMYieymXpP0lG+CpzUc+AQRMOXPl/DBgbahRLWwEyZm/1x+z9NwEM7adF1
         JXc/fmvAjzA5G3hqzYtDQjV9fVYI4M1vAq6C/k2GAsIyC0MDpQ7RxwtytcWVkx0Hk/jY
         5Qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJcr1o3EdZ1/zMPCA+HFmdVb9vG8ctZnuTQujRdta1E=;
        b=nckjNBCug+BgmJTo3jbcrxUVmgcJEmw0nUziKx1ADK4Ii7jb3Ja7MR0YfA5E8zLKzb
         yZc3Wu7E+9Et4OH1y9C+2woMAM43xlt8dZh8pcxsRpdQ/1Owxa/t7d84CpmOBfK1qN+X
         8iGDQrsD5Fweiwu0pM8G/moskSOKpMykqZkq3ByXnHbjcAQQFKDyNLsAYRFcIcTiHu/f
         DvdVQDt/ezC4wbsmrYo31Rc60kSZvfKJ+rovjAbLqJ+t0UQjPHMUHGYrCfCptwvgR5M4
         4d1GIgTrTxsnDR6tTNrTrICi0dKInd1wTjdrS+Stu7BxLqsWfotWljfZdHLjVuMBw//u
         V8PQ==
X-Gm-Message-State: AFqh2krUan1kqygvUdkmrBIa/sePGhTd8ArvipaZ3PDXJ2m7LH+PhAbo
        QorRtRvamwZCYL8agQjdW4dvxQ==
X-Google-Smtp-Source: AMrXdXvdYAjVJWUMoa2JnCI5dqMLOLjQ4TtVYoZ7O4B6p6BJl4EZxs9GAZKoJEEXUKLDmslSSgeiXg==
X-Received: by 2002:a17:902:d4ce:b0:185:44b3:24d with SMTP id o14-20020a170902d4ce00b0018544b3024dmr73635867plg.61.1673083432150;
        Sat, 07 Jan 2023 01:23:52 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902d48100b00189c9f7fac1sm2339189plg.62.2023.01.07.01.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:23:51 -0800 (PST)
Date:   Sat, 7 Jan 2023 10:23:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y7k6JLAiqMQFKtWt@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
 <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org>
 <Y7aSPuRPQxxQKQGN@nanopsycho>
 <20230105102437.0d2bf14e@kernel.org>
 <Y7fiRHoucfua+Erz@nanopsycho>
 <20230106131214.79abb95c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106131214.79abb95c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 10:12:14PM CET, kuba@kernel.org wrote:
>On Fri, 6 Jan 2023 09:56:36 +0100 Jiri Pirko wrote:
>>> Oh, just the "it" at the end? Sorry, I don't see the point.  
>> 
>> The point is simple. Ops is a struct of callback by name X. If someone
>> implements this ops struct, it is nice to assign the callbacks functions
>> of name y_X so it is obvious from the first sight, what the function
>> is related to.
>> 
>> I'm not sure what's wrong about having this sort of consistency. I
>> believe that you as a maintainer should rather enforce it than to be
>> against it. Am I missing something?
>
>IMO you have a tendency to form names by concatenating adjacent
>information rather than reflecting on what matters to the reader.
>I believe the low readability of the devlink code is sufficient 
>evidence to disagree with that direction.

Hmm.
1) What is wrong of having:
   .dumpit = devlink_instance_iter_dumpit
   instead of
   .dumpit = devlink_instance_iter_dump
   ?
   How exactly that decreases readability?

2) Why exactly you find devlink code hard to read?

