Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865CC666491
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbjAKUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbjAKUGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:06:48 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522A512AE1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:05:27 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso2927681wmb.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2t4d7hgQ54FBRcp5Nd91rn+Tm9kSY2eQZ+2k/MJlQY=;
        b=OBtU4Ru9oPMcLY17QyS46TxrmHJdnozQJnjNY0E4qu3rOBdZFKJg/Nvwd06wzEc8b+
         OuhCMgRPoMynxppeFG7qsYVUNbRdwI95nncepx0C9ApX6hkaMt49yY1q/QGr95CVZShF
         rI32Er/cqHRZoG9UqNBnzxwpz0w0stVDiibKbJ7OUa5nWDwY2rNSJRrf2ph9EK0TCGkb
         QoFhDiyeLRWUa+JAuq16DHD5Hj5868cFH8Hhjs9o4ieCElj1ZT54zHxfvubQ2JGL7CVP
         ifpLhGde1VVEtMRXTiitak3c7HRpsKrpjMrxmIYIlDkGrj90k4JiPEiOznRj7oTkMbAn
         bnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2t4d7hgQ54FBRcp5Nd91rn+Tm9kSY2eQZ+2k/MJlQY=;
        b=nlvD6F23kkJDC7vWoF9BTRpRr5Lj0ODROl6dK4c6l4chfBptg8KL3roqTuJscYIyE1
         /1xPeisQMcpvgd2mIKbZ6MNmyTUJdAWKPnd4R/ZoO2ULw/qM5CI2wEUcoAzH90NOsoB9
         3LMdNuDkrLyiQ6CAkcD1s75tEt3zLNHm5dfEna3su9moswcxAq88+0Z6rzipCbvcSoaW
         Y7FAZT6fTjuNVi0mVDpppLhv3FYn5d+aDMY3G9KX4BRb/jhfrDTzwDNJQ7ZUsgbwB0XC
         8gpgvmtGOVAxzy3hEIb2IrkFVVyYkuLP+cAVdAYIQn4D4rR9VabSd9Kmbzmc3SBVGBwt
         9a8g==
X-Gm-Message-State: AFqh2koQstx7HCwTHdMCCpukrFlDGn417/epWJaO62RqrVeXndInvP5N
        fqIix8slxLKa5ArbgUn8Li8=
X-Google-Smtp-Source: AMrXdXtWmG/ybeyYgv7R4SfmqBEY9on9DW5Horv5u52cmTbef2ZYy146362PCG3Hb2JcBfw1ST4C6w==
X-Received: by 2002:a05:600c:1d2a:b0:3d3:50b9:b1a1 with SMTP id l42-20020a05600c1d2a00b003d350b9b1a1mr57206544wms.1.1673467525439;
        Wed, 11 Jan 2023 12:05:25 -0800 (PST)
Received: from ?IPV6:2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd? (dynamic-2a01-0c22-76e4-3a00-509b-51f2-b41a-a9cd.c22.pool.telefonica.de. [2a01:c22:76e4:3a00:509b:51f2:b41a:a9cd])
        by smtp.googlemail.com with ESMTPSA id ay13-20020a05600c1e0d00b003d34faca949sm19479002wmb.39.2023.01.11.12.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 12:05:25 -0800 (PST)
Message-ID: <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com>
Date:   Wed, 11 Jan 2023 20:40:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
In-Reply-To: <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
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

On 11.01.2023 18:23, Hau wrote:
>>
>> On 10.01.2023 18:03, Hau wrote:
>>>> On 06.01.2023 07:53, Hau wrote:
>>>>>>>> rtl8168h has an application that it will connect to rtl8211fs
>>>>>>>> through mdi interface. And rtl8211fs will connect to fiber
>>>>>>>> through serdes
>>>>>> interface.
>>>>>>>> In this application, rtl8168h revision id will be set to 0x2a.
>>>>>>>>
>>>>>>>> Because rtl8211fs's firmware will set link capability to 100M and
>>>>>>>> GIGA when link is from off to on. So when system suspend and wol
>>>>>>>> is enabled, rtl8168h will speed down to 100M (because rtl8211fs
>>>>>>>> advertise 100M and GIGA to rtl8168h). If the link speed between
>>>>>> rtl81211fs and fiber is GIGA.
>>>>>>>> The link speed between rtl8168h and fiber will mismatch. That
>>>>>>>> will cause wol fail.
>>>>>>>>
>>>>>>>> In this patch, if rtl8168h is in this kind of application, driver
>>>>>>>> will not speed down phy when wol is enabled.
>>>>>>>>
>>>>>>> I think the patch title is inappropriate because WoL works
>>>>>>> normally on RTL8168h in the standard setup.
>>>>>>> What you add isn't a fix but a workaround for a firmware bug in
>>>> RTL8211FS.
>>>>>>> As mentioned in a previous review comment: if speed on fibre side
>>>>>>> is 1Gbps then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP
>> side.
>>>>>>> Last but not least the user can still use e.g. ethtool to change
>>>>>>> the speed to 100Mbps thus breaking the link.
>>>>>>
>>>>>> I agree with Heiner here. I assume you cannot fix the firmware?
>>>>>>
>>>>>> So can we detect the broken firmware and correctly set
>>>>>> phydev->advertising? That will fix WoL and should prevent the user
>>>>>> from using ethtool to select a slower speed.
>>>>>>
>>>>> It is a rtl8211fs's firmware bug. Because in this application it
>>>>> will support both 100M and GIGA fiber module, so it cannot just set
>>>>> phydev->advertising to 100M or GIGA. We  may need to use bit-bang
>>>> MDIO
>>>>> to detect fiber link speed and set phydev->advertising properly. But
>>>>> it will
>>>> let this patch become more complicated.
>>>>>
>>>> I think there's also a userspace workaround for your problem.
>>>> You can use "ethtool -s <if> advertise .." to adjust what the
>>>> internal PHY advertises.
>>>> phy_speed_down() considers only modes that are currently advertised.
>>>>
>>>> In your case with a 1Gbps fibre module you could set the
>>>> advertisement to 1Gbps/full only.
>>>> Then phy_speed_down() wouldn't change the speed.
>>>>
>>> In this application(rtl8168h + rtl8211fs) it also supports 100Mbps fiber
>> module.
>>
>> Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side in case
>> of a 100Mbps fiber module?
> Yes.
> 
I think in this case internal PHY and RTL8211FS would negotiate 1Gbps,
not matching the speed of the 100Mbps fiber module.
How does this work?

>>> So userspace workaround is good but it may not always work for this issue.
>>
>> When would it not work? If you know the fiber module speed you can set
>> the advertisement accordingly.
> Sure, user can set internal PHY advertisement according to fiber module speed.
> But we would like to have a solution that does not need user to do anything.
> So this userspace workaround may not meet our need.
> 
>>> Not speed down during system suspend may be the simplest workaround
>> for this issue.
>>>

