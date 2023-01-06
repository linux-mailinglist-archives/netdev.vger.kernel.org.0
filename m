Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF6A66067D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjAFSkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjAFSkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:40:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048B17CDDA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:40:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id z5so1023119wrt.6
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 10:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BFEW4yrcdwRU/6ZtZOzv/SSwJrjEMx6Ekdaf5pFPeu8=;
        b=KKZNVg8HeGCQPPemg1AcLhTnfEmcj+PrBL0kowwy93N6okyo8JyVn1bmvpLJNBbGJ4
         +9CncPMbpiJyec/ngUKEg1LyjTgWCAC8zA/d1awleg4L7jDjxzgi2q3J1GyuK8sHlUxh
         lTel72SHcU8GBn5Zcc9nD7LBp4qW7fZiIapn2qhOk+T1sY7Gw6CmlwWqO50S+6ypCkuW
         UKHNTCcT1UTYIrUAbwe+9jjuoIOiE0xuZsrWbpFA0C9lCmGD9EEgrtI5EWHlfLMpT9Y8
         XpxfEEwlC2u9h2xR1dajIvismeEvP97wB0DmCcxlkAOgWgPXdeyzEIEpbBY20IZKV62C
         NsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFEW4yrcdwRU/6ZtZOzv/SSwJrjEMx6Ekdaf5pFPeu8=;
        b=liEktWqB5LK3WDlnDzbNHJvu6kVSVZyMlRIXXZGfiibNYyeg6kPkI/6AyMvgA5e5if
         cZON/m3G5Mq7KZul4rmVngDVixeqHSWeHmSact0kkcVNNADKyLSmbe6JTT3Holi0awH0
         KbLzy+lEBRxwvimCHJZL6owo1+M0GCR6fQinq2irVr1hIlt9zZmbZlbtxKRKz+CH72MK
         RSfuSX0FrXfrDotJpJ2tUvk9CyZmYkTQlg/m44Yt/jCRaLdEC1AqzjSoqpkdfzTE2ouy
         Set6gH55rojNYN8PXk2AEJKTJt+Y2MGhDkCpJHv/CBAN2fF3wt51TamkP3E7Fqb1dZ7Y
         zWqg==
X-Gm-Message-State: AFqh2krGVI//51PrCDeE95djXOdxU7NJ2IsDaE/BRlkCXWg97nfJIRh+
        HhkgP9zFbY/opghGOfCmT9Q=
X-Google-Smtp-Source: AMrXdXsRqGyfU7vMUJynavdw8lAoJmxSfliwChBdkmUXvzjRUr93E2gWZr6G0GItM7EBmaUJ9GiVxA==
X-Received: by 2002:a5d:6f0f:0:b0:298:7fc:60ac with SMTP id ay15-20020a5d6f0f000000b0029807fc60acmr14881807wrb.59.1673030449463;
        Fri, 06 Jan 2023 10:40:49 -0800 (PST)
Received: from ?IPV6:2a02:3100:910b:4e00:fdba:e980:e1d0:74b2? (dynamic-2a02-3100-910b-4e00-fdba-e980-e1d0-74b2.310.pool.telefonica.de. [2a02:3100:910b:4e00:fdba:e980:e1d0:74b2])
        by smtp.googlemail.com with ESMTPSA id s2-20020adff802000000b00241bd7a7165sm1812310wrp.82.2023.01.06.10.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 10:40:48 -0800 (PST)
Message-ID: <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
Date:   Fri, 6 Jan 2023 19:40:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
In-Reply-To: <9ee2f626bab3481697b71c58091e7def@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2023 07:53, Hau wrote:
>>>> rtl8168h has an application that it will connect to rtl8211fs
>>>> through mdi interface. And rtl8211fs will connect to fiber through serdes
>> interface.
>>>> In this application, rtl8168h revision id will be set to 0x2a.
>>>>
>>>> Because rtl8211fs's firmware will set link capability to 100M and
>>>> GIGA when link is from off to on. So when system suspend and wol is
>>>> enabled, rtl8168h will speed down to 100M (because rtl8211fs
>>>> advertise 100M and GIGA to rtl8168h). If the link speed between
>> rtl81211fs and fiber is GIGA.
>>>> The link speed between rtl8168h and fiber will mismatch. That will
>>>> cause wol fail.
>>>>
>>>> In this patch, if rtl8168h is in this kind of application, driver
>>>> will not speed down phy when wol is enabled.
>>>>
>>> I think the patch title is inappropriate because WoL works normally on
>>> RTL8168h in the standard setup.
>>> What you add isn't a fix but a workaround for a firmware bug in RTL8211FS.
>>> As mentioned in a previous review comment: if speed on fibre side is
>>> 1Gbps then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.
>>> Last but not least the user can still use e.g. ethtool to change the
>>> speed to 100Mbps thus breaking the link.
>>
>> I agree with Heiner here. I assume you cannot fix the firmware?
>>
>> So can we detect the broken firmware and correctly set
>> phydev->advertising? That will fix WoL and should prevent the user
>> from using ethtool to select a slower speed.
>>
> It is a rtl8211fs's firmware bug. Because in this application it will support both 100M and GIGA
> fiber module, so it cannot just set phydev->advertising to 100M or GIGA. We  may need to 
> use bit-bang MDIO to detect fiber link speed and set phydev->advertising properly. But it will
> let this patch become more complicated.
> 
I think there's also a userspace workaround for your problem.
You can use "ethtool -s <if> advertise .." to adjust what the internal PHY advertises.
phy_speed_down() considers only modes that are currently advertised.

In your case with a 1Gbps fibre module you could set the advertisement to 1Gbps/full only.
Then phy_speed_down() wouldn't change the speed.

