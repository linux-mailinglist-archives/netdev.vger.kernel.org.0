Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA226C875C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCXVQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCXVQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:16:21 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAACD13D77
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:16:19 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id y14so3063912wrq.4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679692578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFw0gcjbpPb7RCBGD/oPtUpiwDQyCgWkp7XLpgefCbw=;
        b=oJJmXMxdOQy46hH65ceKZXkyujl81qrY1b3W+2Bu7SmA5OPxis5uhTA7ChiHaXhWDt
         6tlnDeii0+YZW5MvkR5luGGX5zfgXN3aR5EsQE39TXpZiJjR/43FT2izRSK64c5gLTzS
         ZO8BbJl+78nz0tG7D6bcXFKHzUiPnXO6sjWoBYWaDF/CHdkzcbx5Hehtrz1GX5Qu1OcJ
         IkKv65aiVm8iVZEaXjmivF4xC14Lu+0n5G7aVApliAQOJomLMAS1ULcEAyLVRWRq37Ff
         aVtCVOh1LYAKTxr9KwetHsPD7nX0uHb3RREgBMP1zmjWBcCUPKIOOsZIX5qnnBXC4ta+
         w1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679692578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFw0gcjbpPb7RCBGD/oPtUpiwDQyCgWkp7XLpgefCbw=;
        b=tGir0Fy6v3jm02gLkY3/wc1dyUVxjPbhDKUK1p+hqpscQlCR2D5IHY0brwhFhs0Ub9
         mT2PnkOEYr9yjNLSzBZXlqSvDy9bo/cCvoBCZJ+3b9IZuJBohO8HaL33XDw4tNuVfiDO
         UGHeAhGo4RGTW4Sz2KhGOv+qUXMSIHdW9AwMzBSQFeKIyDgNkv2dBy4G1IBX56eGzG8M
         lIOGU1B4Dw1mzUvF0WNpf4q/Pa+3kkEi5NqTnDHVI2HVXOYz+k1984R9l9h6B//swcpg
         f0T3/OVOXlmDmZ0BC3DGOSng6kUjC3ZNOXJmPWXULRnohphFhIS6+ZX5X5J49pVhGfZo
         u48w==
X-Gm-Message-State: AAQBX9faHH0Z+3BSaVKsonGkoqikkaI3JCaz4uZF9QR6VpZdtGhPgh+L
        is7HSwonPjL7X1qZtzju8Rk=
X-Google-Smtp-Source: AKy350asEVPjxDNpaNJdAw+IHWVuWtgpvmUB9WOPTkp+HUt6FHpiZTmPEb1Yu/hQsvOKf71bDZUN5A==
X-Received: by 2002:adf:db86:0:b0:2d5:2c7b:bc5f with SMTP id u6-20020adfdb86000000b002d52c7bbc5fmr2943251wri.58.1679692578236;
        Fri, 24 Mar 2023 14:16:18 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id p5-20020adfce05000000b002d64fcb362dsm13888772wrn.111.2023.03.24.14.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 14:16:17 -0700 (PDT)
Message-ID: <0c9f262b-0f06-d1d5-636e-8ad6baa3380f@gmail.com>
Date:   Fri, 24 Mar 2023 22:16:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 4/4] net: phy: bcm7xxx: remove getting reference
 clock
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
 <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
 <c3bc1a7e-b80b-cf04-c925-6893d5ac53ae@gmail.com>
 <45afac86-cff6-f695-f02b-a8d711166db0@gmail.com>
 <2e377557-3177-7117-bf00-ad308aabab69@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <2e377557-3177-7117-bf00-ad308aabab69@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.03.2023 21:11, Florian Fainelli wrote:
> On 3/24/23 12:50, Heiner Kallweit wrote:
>> On 24.03.2023 20:03, Florian Fainelli wrote:
>>> On 3/24/23 11:05, Heiner Kallweit wrote:
>>>> Now that getting the reference clock has been moved to phylib,
>>>> we can remove it here.
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>
>>> This is not the reference clock for bcm7xxx this is the SoC internal clock that feeds the Soc internal PHY.
>>
>> Ah, good to know. Then indeed we may have to allow drivers to disable this feature.
>>
>> Another aspect: When looking at ba4ee3c05365 "net: phy: bcm7xxx: request and manage GPHY clock"
>> I stumbled across statement "PHY driver can be probed with the clocks turned off".
>> I interpret this in a way that dynamic PHY detection doesn't work because the PHY ID
>> registers aren't accessible before the PHY driver has been loaded and probed. Is this right?
> 
> Yes this is correct we actually probe with the clock turned off as we try to run as low power as possible upon boot.
> 
>> Should the MDIO bus driver enable the clock for the PHY?
>>
> 
> This is what I had done in our downstream MDIO bus driver initially and this was fine because we were guaranteed to use a specific MDIO bus driver since the PHY is integrated.
> 
> Eventually when this landed upstream I went with specifying the Ethernet PHY compatible with the "ethernet-phy-idAAAA.BBBB" notation which forces the PHY library to match the compatible with the driver directly without requiring to read from MII_PHYSID1/2.
> 
> The problems I saw with the MDIO bus approach was that:
> 
> - you would have to enable the clock prior to scanning the bus which could be done in mii_bus::reset for a driver specific way of doing it, or directly in mdiobus_scan() and then you would have to balance the clock enable count within the PHY driver's probe function which required using __clk_is_enabled() to ensure the clock could be disabled later on when you unbind the PHY device from its driver or during remove, or suspend/resume
> 
> - if the PHY device tree node specified multiple clocks, you would not necessarily know which one(s) to enable and which one(s) not to. Enabling all of them would be a waste of power and could also possibly create sequencing issues if we have a situation similar to the reference clock you are trying to address. Not enabling any would obviously not work at all.
> 
> Using the "ethernet-phy-idAAAA.BBBB" ensured that the PHY driver could enable the clock(s) it needs and ensure that probe() and remove() would have balanced clock enable/disable calls.

I see, thanks for the comprehensive explanation. If we need an additional
PHY driver flag or other measures, then I wonder whether it's worth it
to add refclock handling to phylib for two drivers. Maybe not.

