Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1943664E66
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjAJV7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjAJV7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:59:32 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537CE5DE74
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:59:31 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso11199353wms.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E5P6gxuRBuQnLyKmewoIwZkVwzYemnG/a2rrAvicXPo=;
        b=Gecijk5eYdRGzp+R/bGY9Gm2YLMJI6VzvmuNMlX8f8xZz5AuJGjbVJDuLT/ts+ZEHU
         gVsby95KymU3/pBl3i7Vm0mDU4G/acr5d2YbUSkUodvYrrZm4+AS/N4Hu7brG67/taUK
         VmN5tdGWYMLfSCl71dAIyrpIxaOjbPlt8kv6A+hYljaWFHKqnvvAM5MT81OZULxm2tCP
         2EaHxr1RRA/G0xsUBL4+B4UWSehPY4y6fleBPnZj+iR3YfGsrDMIfBuFPykRVnqSszWV
         lvHTU9Y9XUgLL7WUalllXCo13G/uxQ+wlI6AgCficZPq3Uz/Kse2+rbtKkGZ9LGMjfOi
         ZZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5P6gxuRBuQnLyKmewoIwZkVwzYemnG/a2rrAvicXPo=;
        b=0Ho2ex3YaaFUKlKjwSkRy+d7VCJJBZI64HcD//LlnpEjSRCtIr3rAV5uM01ch2qD46
         32WL+Eff6qYAqbecgC+N0Fvm+fqzxJZoXoGEurFa8yyGEpzYeKovUB2JmERZzXnnVVSx
         0Sd5fFeTfablQohEnZfVns5ZGIcehSbgRddvv8b9PGMSrLJoNc8okGT96av9bH+T0K1y
         3oTXtn/uF5I2DCNsxDk5ZT/G2G3+yAP3Sk9193prrznkrlSNzu/iegOsUgFWNjpytW47
         mAJJ3Dcnhk7jdwZnlruriMGrHc8Z9ML3tqyaKWHUAJ2GkvXoJueFQvMSW5AsIcPfVaY0
         /v5w==
X-Gm-Message-State: AFqh2kq/RvbSNk0BiWODmtIbhyFlegqamldb7k8KE2ji5Njgz8Pq0VDu
        Jb+VbxXry7NJY+8/rMtYEAc=
X-Google-Smtp-Source: AMrXdXtmqjqHS7En+6qzE3/w7bHJEKFI7QxeZG8KPln2emN3anjm2c0v6vTW7JClgrJkXapj6poxvQ==
X-Received: by 2002:a05:600c:1f0e:b0:3cf:497c:c59e with SMTP id bd14-20020a05600c1f0e00b003cf497cc59emr51544357wmb.6.1673387969650;
        Tue, 10 Jan 2023 13:59:29 -0800 (PST)
Received: from ?IPV6:2a01:c23:c404:0:f91c:b55f:3d6c:d5bd? (dynamic-2a01-0c23-c404-0000-f91c-b55f-3d6c-d5bd.c23.pool.telefonica.de. [2a01:c23:c404:0:f91c:b55f:3d6c:d5bd])
        by smtp.googlemail.com with ESMTPSA id he12-20020a05600c540c00b003d9ddc82450sm15798561wmb.45.2023.01.10.13.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 13:59:29 -0800 (PST)
Message-ID: <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
Date:   Tue, 10 Jan 2023 22:59:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <6ff876a66e154bb4b357b31465c86741@realtek.com>
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

On 10.01.2023 18:03, Hau wrote:
>> On 06.01.2023 07:53, Hau wrote:
>>>>>> rtl8168h has an application that it will connect to rtl8211fs
>>>>>> through mdi interface. And rtl8211fs will connect to fiber through
>>>>>> serdes
>>>> interface.
>>>>>> In this application, rtl8168h revision id will be set to 0x2a.
>>>>>>
>>>>>> Because rtl8211fs's firmware will set link capability to 100M and
>>>>>> GIGA when link is from off to on. So when system suspend and wol is
>>>>>> enabled, rtl8168h will speed down to 100M (because rtl8211fs
>>>>>> advertise 100M and GIGA to rtl8168h). If the link speed between
>>>> rtl81211fs and fiber is GIGA.
>>>>>> The link speed between rtl8168h and fiber will mismatch. That will
>>>>>> cause wol fail.
>>>>>>
>>>>>> In this patch, if rtl8168h is in this kind of application, driver
>>>>>> will not speed down phy when wol is enabled.
>>>>>>
>>>>> I think the patch title is inappropriate because WoL works normally
>>>>> on RTL8168h in the standard setup.
>>>>> What you add isn't a fix but a workaround for a firmware bug in
>> RTL8211FS.
>>>>> As mentioned in a previous review comment: if speed on fibre side is
>>>>> 1Gbps then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.
>>>>> Last but not least the user can still use e.g. ethtool to change the
>>>>> speed to 100Mbps thus breaking the link.
>>>>
>>>> I agree with Heiner here. I assume you cannot fix the firmware?
>>>>
>>>> So can we detect the broken firmware and correctly set
>>>> phydev->advertising? That will fix WoL and should prevent the user
>>>> from using ethtool to select a slower speed.
>>>>
>>> It is a rtl8211fs's firmware bug. Because in this application it will
>>> support both 100M and GIGA fiber module, so it cannot just set
>>> phydev->advertising to 100M or GIGA. We  may need to use bit-bang
>> MDIO
>>> to detect fiber link speed and set phydev->advertising properly. But it will
>> let this patch become more complicated.
>>>
>> I think there's also a userspace workaround for your problem.
>> You can use "ethtool -s <if> advertise .." to adjust what the internal PHY
>> advertises.
>> phy_speed_down() considers only modes that are currently advertised.
>>
>> In your case with a 1Gbps fibre module you could set the advertisement to
>> 1Gbps/full only.
>> Then phy_speed_down() wouldn't change the speed.
>>
> In this application(rtl8168h + rtl8211fs) it also supports 100Mbps fiber module.

Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side in case of a 100Mbps fiber module?

> So userspace workaround is good but it may not always work for this issue.

When would it not work? If you know the fiber module speed you can set the advertisement accordingly.

> Not speed down during system suspend may be the simplest workaround for this issue.
> 






