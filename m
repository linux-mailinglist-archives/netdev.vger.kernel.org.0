Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D000E66A5ED
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 23:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAMW2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 17:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjAMW2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 17:28:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE5876EC0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:28:20 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 18so33092534edw.7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Prg9wen8hHr+TwHiVvofcU/6UPqxvykb5yVbV/n/JjI=;
        b=du5qj2avKFP++sDfeVchjLLvPMLxguTGIeWssK8Zuyetk9H0BpY1dfhkWAxeWnbEUY
         uDoDt04EJ7+ToSx8shHjnFZsvbAuWnaaVcHDxUgHf48UkUyXr/5EuxNuyd3Ea+qACRwN
         ZYmOMCieyGFkR6kGv/GrRBXb8vTvYns9DSDL22vAoK9Wd2Pa23rmJZ8zRqxnBBBTVtqX
         8s1zGIYGFX1qTI3IKXhZsjVE0VjpqfusKRMTOFc63VWHpjOFwDbZvWinFnZRWyMfAxFB
         Dca+BZ2xZUptK/u45FRuzUk0DDh2lMtz9OknIhWefGC4/c+dc0wkZ9vXb+TYmgRej8f2
         S3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Prg9wen8hHr+TwHiVvofcU/6UPqxvykb5yVbV/n/JjI=;
        b=2eulAFKkFoW9SFQ8aSNIvFmNpBt8bTswIul8xppkzOgxxrOeYwH6fPg1fClW8vpsmO
         BIl7vgVJlSGdzF718Ai7ad20z9WzF72FJ8w2BuYHU9KJ/Pm9atK9ttajVd6SMaebihTV
         xMphUkMNbZCaz5HqxK4D9w/PlZiQdH9L8gMYPnCsWptcYKc+lk8+bPZp+Z/VwoLz5Wrj
         3uZ9WsXTvh8FDXxsloQazVfoytGNrUxDeDIr9BG2KLiwp4zOUnjNsVdWWMK/tJby7uGk
         yJbRrwfdY88ztHURZjVoS5nWKXCC5HLmjkpCUvXJEa6NSc07pShKi+uCLR5kgS2vXQ7+
         K3WA==
X-Gm-Message-State: AFqh2kqFGmcUgrdgM4k2hkbYf4OzaNfYx2E4sY+AP6gmdPiTzwfAjfr9
        VpF8G0ERGVvD+Z9XaDWaN/14Ex7jYps=
X-Google-Smtp-Source: AMrXdXsFFfSN5w/2hoO2E1ncau6EpTmGefr9caJifx3Yb8k7xrx9hACoxfEqSmuenw5mbdZ1FLXygw==
X-Received: by 2002:aa7:da88:0:b0:49c:8650:1a0b with SMTP id q8-20020aa7da88000000b0049c86501a0bmr3066037eds.6.1673648898493;
        Fri, 13 Jan 2023 14:28:18 -0800 (PST)
Received: from ?IPV6:2a01:c23:b9df:eb00:88f6:ddec:da70:8bca? (dynamic-2a01-0c23-b9df-eb00-88f6-ddec-da70-8bca.c23.pool.telefonica.de. [2a01:c23:b9df:eb00:88f6:ddec:da70:8bca])
        by smtp.googlemail.com with ESMTPSA id d3-20020aa7d5c3000000b004835bd8dfe5sm8773130eds.35.2023.01.13.14.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 14:28:17 -0800 (PST)
Message-ID: <939fae88-ab42-132a-81d8-bbedfc20344e@gmail.com>
Date:   Fri, 13 Jan 2023 23:28:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Andrew Lunn <andrew@lunn.ch>, Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
References: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch> <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com> <Y78ssmMck/eZTpYz@lunn.ch>
 <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com> <Y8GIgXKCtaYzpFdW@lunn.ch>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
In-Reply-To: <Y8GIgXKCtaYzpFdW@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.01.2023 17:36, Andrew Lunn wrote:
> On Fri, Jan 13, 2023 at 04:23:45PM +0000, Hau wrote:
>>>>>>> In this application(rtl8168h + rtl8211fs) it also supports 100Mbps
>>>>>>> fiber
>>>>>> module.
>>>>>>
>>>>>> Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side in
>>>>>> case of a 100Mbps fiber module?
>>>>> Yes.
>>>>>
>>>> I think in this case internal PHY and RTL8211FS would negotiate 1Gbps,
>>>> not matching the speed of the 100Mbps fiber module.
>>>> How does this work?
>>
>> My mistake. With 100Mbps fiber module RTL8211FS will only advertise 100Mbps
>> on the UTP/MDI side. With 1Gbps fiber module it will advertise both 100Mbps and
>> 1Gbps. So issue will only happen with 1Gbps fiber module.
>>
>>> Fibre line side has no autoneg. Both ends need to be using the same speed,
>>> or the SERDES does not synchronise and does not establish link.
>>>
>>> You can ask the SFP module what baud rate it supports, and then use
>>> anything up to that baud rate. I've got systems where the SFP is fast enough
>>> to support a 2.5Gbps link, so the MAC indicates both 2.5G and 1G, defaults to
>>> 2.5G, and fails to connect to a 1G link peer. You need to use ethtool to force
>>> it to the lower speed before the link works.
>>>
>>> But from what i understand, you cannot use a 1000Base-X SFP, set the MAC
>>> to 100Mbps, and expect it to connect to a 100Base-FX SFP. So for me, the
>>> RTL8211FS should not be advertise 100Mbps and 1Gbps, it needs to talk to
>>> the SFP figure out exactly what it is, and only advertise the one mode which
>>> is supported.
>>
>> It is the RTL8211FS firmware bug. This patch is for workaround this issue.
> 
> So if it is advertising both 100Mbps and 1Gbps, we know the SFP is
> actually 1G, and we can remove the 100Mbps advertisement? That should
> then solve all the problems?
> 
Right, that's what I proposed too, removing 1Gbps advertisement of the
RTL8168H-internal PHY via userspace tool, e.g. ethtool. For me this is
the cleanest solution. Adding a workaround for a firmware bug of a
specific external PHY to the r8169 MAC driver would be somewhat hacky.




>      Andrew

