Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B21622B02
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKIL5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKIL5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:57:45 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CFB2124F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:57:42 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id h133-20020a1c218b000000b003cf4d389c41so1091077wmh.3
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=85sMoT8EQB7wB5jL13Lt0pA4/Eic7iUU71LVok5zWZ0=;
        b=1UN5CC9bkAMNXtuJQ+NjlYfWg0k8PkcPwwdjixU9CSU3SiQ9el6BxLaZt+hqkCpRdh
         dJkPTwmlc59MlAfBiA1Kl+Cc4m8NY6K4zHD2W/vJoybio+Yg3hjgmrXmMB0ojTzbFUfT
         AH+t9qBUJCf/H16bNs4NQwETeoS7niTU9WxX6KCYX3mEFOpJUgz52TsJwalR5YJzJnZC
         6VcT9tL3R7Z2BmuKkRIUoClWou5LRT96yREQlFq8AD++lMYqkapVnEU21u90BhehJTAD
         WszpAQhoruQGqJMyRU6NzCiKcaskkZ/rHaXz/TBH4kd9V8hHrfFx/liacgVC36Hezpxj
         Vw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85sMoT8EQB7wB5jL13Lt0pA4/Eic7iUU71LVok5zWZ0=;
        b=Iri/t3iNSrk4Ye+vXDg8rMNrwqY8t6HluB5VJugO4ZVZFYZPpLrCL0ILkfCheSiqqF
         JhgLJv5MXXCfWe33N8uao8/+Q8joLgGReiADPKW0KsxxHP/mBdVQCbxSuNEzhENzcmyi
         AITrmzHfFgrQZgV/wceq4gtS9tGVtZutz0OVwugHyxzJWBs46EFTyxKyoOwuqMDn/oaG
         2FVLGE0X8ou50bwGXVKuHpFUA7hkC8gTI8yx1kxBC75FfhlmPR1o31susIDTi2+IM3Jc
         UxdNxqcakTgwkFY24SqsSq998Qw2Vx4+ngrd7ZPRkKM3YjavO5sOwhslQZrHLeRHzso3
         M90Q==
X-Gm-Message-State: ACrzQf02fxWGcVwctkvLLeBlxwTD5ssp98FO9nIpp1d0SiB+YZpWqamu
        RF9GhiHij8mnHH34Gs6YOAwpiXW2SWoQEbbH
X-Google-Smtp-Source: AMsMyM7Flh7wuzHao0u9MYOPN5M3g1d42Eo2/EYPyOjGp0fSOHMTgMuTDDri95u+3MMdDum1sgJC+g==
X-Received: by 2002:a05:600c:350c:b0:3cf:84ea:5e7b with SMTP id h12-20020a05600c350c00b003cf84ea5e7bmr27639084wmq.114.1667995061190;
        Wed, 09 Nov 2022 03:57:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l9-20020a05600c1d0900b003cf878c4468sm1533760wms.5.2022.11.09.03.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:57:40 -0800 (PST)
Date:   Wed, 9 Nov 2022 12:57:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, moshe@nvidia.com
Subject: Re: [patch iproute2-next 1/3] devlink: query ifname for devlink port
 instead of map lookup
Message-ID: <Y2uVszm5PTRGeW2E@nanopsycho>
References: <20221104102327.770260-1-jiri@resnulli.us>
 <20221104102327.770260-2-jiri@resnulli.us>
 <6903f920-dd02-9df0-628a-23d581c4aac6@gmail.com>
 <Y2kqLYEle5oDxfts@nanopsycho>
 <f7e9ba65-bed3-540b-a2d9-879f7205f0c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7e9ba65-bed3-540b-a2d9-879f7205f0c7@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 08, 2022 at 04:59:23PM CET, dsahern@gmail.com wrote:
>On 11/7/22 8:54 AM, Jiri Pirko wrote:
>> Mon, Nov 07, 2022 at 04:16:42PM CET, dsahern@gmail.com wrote:
>>> On 11/4/22 4:23 AM, Jiri Pirko wrote:
>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>
>>>> ifname map is created once during init. However, ifnames can easily
>>>> change during the devlink process runtime (e. g. devlink mon).
>>>
>>> why not update the cache on name changes? Doing a query on print has
>> 
>> We would have to listen on RTNetlink for the changes, as devlink does
>> not send such events on netdev ifname change.
>> 
>> 
>>> extra overhead. And, if you insist a per-print query is needed, why
>>> leave ifname_map_list? what value does it serve if you query each time?
>> 
>> Correct.
>
>"Correct" is not a response to a series of questions.
>
>You followed up that 1 word response with a 2 patch set that has the
>same title as patch 3 in this set. Please elaborate.

Sorry. You are correct, per-print query makes the map needless. That is
what I ment. I'm redoing this, tracking the changes coming from the
kernel (port ifname change actually gets propagated).

I sent v2 without this patch included, that means it contains only patch
3 with the dependency patch. That is why the patchset has the same name
as patch 3.

I'm working on the tracking patchset to replace this patch. Hope this
cleared your concerns.

Thanks!
