Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05AC69778D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjBOHuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjBOHuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:50:14 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E126E99
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:50:12 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s13so383415wrw.3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AtLpI3k+6feNjs8zayT5oOIW+yujhrvyzKiQ62ME6Rs=;
        b=ZfZBrSfzyL3lDsyQZu/baDcrt2IYm0uCceUe/T8y8YAR7V0DYtjwEQ4a3IzwDijyVZ
         wOaxflD0knAimBRQrO6U0mwuNjH6H9WsPi7nsqGv3mh1fVkXY2cyj9oxMbqBfB4WBkVd
         aXxcVMTV0FcDA6a+bRixsS6ReXUIRhKIKXqZ3xvGuL4k6/Cb/2z5bwygX0Uh28orMVrU
         QZC4f5eNcjyCcU2L0bCkJ+O228MphaK8f5SijJUH3+YFUUKYW1dspasJkWIYJ3r98Ayx
         HUGu2rQEV1iLun5YiQAsiFrbGRVfbfpaaG38fPxfnJrk7DZAtoLQcQO4TBoCQdTVyV6F
         5Jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtLpI3k+6feNjs8zayT5oOIW+yujhrvyzKiQ62ME6Rs=;
        b=eYbGArNQhkPtDM57xBggAy5OoyoayevtUg2LSEaC+RUdjlGjHBS2bIGAclyDrwRLCa
         5p85BScT5FWlOdJs4lmo0c50yAvnxnP3unRdzoZhPD0a8tuE/est5bn9tCtQt9mdWROL
         7dO8/aj3rc0xwrb3oYqPtdYlb/Xka3hWf4bDsXPHbgtiR2VC63uADvvCY6f1fwimlhcw
         uxCDNAe7Fe5DAFw4Qg0LoU1uH+nYbGjM8/edmVALzaAZ/iIWThMr7P6SAnaZ7HIksyvz
         xYzfcN/JaGlOdYgYyQlsxhr6i+gSMJBp3YfgQySJxO6M2tDeACFmAYRvbhETM4e5Joh+
         X4rg==
X-Gm-Message-State: AO0yUKU7a4NT/q1nNscp+7KIMykRQgWblldLDuJqSo5ZJeIUhB6o6us7
        Vk5kXVseZVXqhH6uywYwepB+vw==
X-Google-Smtp-Source: AK7set/ITUWT4aScGBcx0DP3x7VXxLZyoq+rMcrAiG2uRnkX5orWkRkOAeZ1b5FFU0U8eKnRRRs5Cw==
X-Received: by 2002:adf:cd85:0:b0:2c5:5878:e5ad with SMTP id q5-20020adfcd85000000b002c55878e5admr1061626wrj.33.1676447411066;
        Tue, 14 Feb 2023 23:50:11 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x8-20020adfdd88000000b002c5691f13eesm2914367wrl.50.2023.02.14.23.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 23:50:10 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:50:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <Y+yOsYSRSZV1kwpq@nanopsycho>
References: <20230214134915.199004-1-jhs@mojatatu.com>
 <Y+uZ5LLX8HugO/5+@nanopsycho>
 <20230214134013.0ad390dd@kernel.org>
 <20230214134101.702e9cdf@kernel.org>
 <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 15, 2023 at 12:05:23AM CET, jhs@mojatatu.com wrote:
>On Tue, Feb 14, 2023 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 14 Feb 2023 13:40:13 -0800 Jakub Kicinski wrote:
>> > > I think we have to let the UAPI there to rot in order not to break
>> > > compilation of apps that use those (no relation to iproute2).
>> >
>> > Yeah, I was hoping there's no other users but this is the first match
>> > on GitHub:
>> >
>> > https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c
>> >
>> > :(
>>
>> I mean that in the context of deleting the uAPI, not the support,
>> to be clear.
>
>Looking at that code - the user is keeping their own copy of the uapi
>and listening to generated events from the kernel.
>With new kernels those events will never come, so they wont be able to
>print them. IOW, there's no dependency on the uapi being in the kernel
>- but maybe worth keeping.
>Note, even if they were to send queries - they will just get a failure back.

Guys. I don't think that matters. There might be some non-public code
using this headers and we don't want to break them either. I believe we
have to stick with it. But perhaps we can include some note there.

>
>cheers,
>jamal
