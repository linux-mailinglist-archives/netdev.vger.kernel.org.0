Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FDF62CF70
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiKQAVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiKQAV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:21:27 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EFE45EFD;
        Wed, 16 Nov 2022 16:21:26 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so498447pgh.4;
        Wed, 16 Nov 2022 16:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EOTHwBvfn3j46S98TnUtdZvMLvXtq/JOOvCrOFMYfc0=;
        b=SyOm+L0eF8cS7odyS/+IVdV+CobT8Af23hLQxh2DHW8EaivP2joAE1qPJ2mhopG+xi
         iOTnQJqAq/0yZFeEKCJOmncw+28P1XMjJHU2KS/xby9W3f4K1bTPUQzScU3bNVffUuvq
         buAfr0Re5/A/CG6682OHChxpn6e4SiIccXqFqwpuqm7tviFhbIRvYD1Q4nT6cEM40d8u
         wupkg5y0/5KcQ997VHO6XGZKGBP+uOhcSJ9gSQn8fIuc2HkkrezdvKgWBoE+7QshG6j0
         V+QHrbdyMO69j4+I5HKtQOStsV3cl+n0g4pK5GbLtF+APPG9LTfXYFEFspmHsjT/zymY
         HaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOTHwBvfn3j46S98TnUtdZvMLvXtq/JOOvCrOFMYfc0=;
        b=wLCaMo7lRFu1w4R9vazj8Z0KTyNMcItuxet6bzYn4kal9Cmc6z/qWgHm0tFFxRr7DT
         kMoF3mz0xyLeRWT0/f6jbcYOEKfGZA98cbSdtjqxS7G7X0HS/7ArNXYn7RZOOpqm1x6Y
         MNOS+ur39Inc2Ola0hxEKcl55MqiKGsyJHI7oC/V8ZF9hALcsw3BTHstQJVJJoVtDkMS
         cO/pH8YAj/0KV/qWSxsX2/LA4YSCMgpaT2jVGAxuh10GiNJCajmuE+YMXdKGwc6N/p08
         XulVxhVCIQF0bQ0eM5/sUhuNlj4LOtA1/LWnUlHvUA7Ok56B9M/8Vp5F0nGFcgOM2Vh6
         88VQ==
X-Gm-Message-State: ANoB5plDr2n/5cofbL/naVBXNGdiCB7sLd9z24v/WuKdGx6TA26nIHbn
        09fciz21vaNdjhovMY0waMG1E7r+7sicoA==
X-Google-Smtp-Source: AA0mqf5dO1qAI+9h4q1RiOcxT4xwiQJxvdSWPmTFPNPN6JC4eF+UgJnFOpScLOmhuQUdll5e6L6glA==
X-Received: by 2002:a62:1444:0:b0:572:d54:9647 with SMTP id 65-20020a621444000000b005720d549647mr417129pfu.82.1668644485780;
        Wed, 16 Nov 2022 16:21:25 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nl8-20020a17090b384800b0020d48bc6661sm2232416pjb.31.2022.11.16.16.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 16:21:25 -0800 (PST)
Message-ID: <9c9643e3-db53-bd35-6028-1c8b718e1cc2@gmail.com>
Date:   Wed, 16 Nov 2022 16:21:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
 <Y3T8wliAKdl/paS6@lunn.ch> <355a8611-b60e-1166-0f7b-87a194debd07@gmail.com>
 <Y3V5AgBMBOx/ptwx@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y3V5AgBMBOx/ptwx@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 15:57, Andrew Lunn wrote:
> On Wed, Nov 16, 2022 at 03:27:39PM -0800, Florian Fainelli wrote:
>> On 11/16/22 07:07, Andrew Lunn wrote:
>>> On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
>>>> On imx6sx, there are two fec interfaces, but the external
>>>> phys can only be configured by fec0 mii_bus. That means
>>>> the fec1 can't work independently, it only work when the
>>>> fec0 is active. It is alright in the normal boot since the
>>>> fec0 will be probed first. But then the fec0 maybe moved
>>>> behind of fec1 in the dpm_list due to various device link.
>>
>> Humm, but if FEC1 depends upon its PHY to be available by the FEC0 MDIO bus
>> provider, then surely we will need to make sure that FEC0's MDIO bus is
>> always functional, and that includes surviving re-ordering as well as any
>> sort of run-time power management that can occur.
> 
> Runtime PM is solved for the FECs MDIO bus, because there are switches
> hanging off it, which have their own life cycle independent of the
> MAC. This is something i had to fix many moons ago, when the FEC would
> power off the MDIO bus when the interface is admin down, stopping
> access to the switch. The mdio read and write functions now do run
> time pm get and put as needed.
> 
> I've never done suspend/resume with a switch, it is not something
> needed in the use cases i've covered.

All of the systems with integrated I worked on had to support 
suspend/resume both with HW maintaining the state, and with HW losing 
the state because of being powered off. The whole thing is IMHO still 
not quite well supported upstream if you have applied some configuration 
more complicated than a bridge or standalone ports. Anyway, this is a 
topic for another 10 years to come :)

> 
>>>> So in system suspend and resume, we would get the following
>>>> warning when configuring the external phy of fec1 via the
>>>> fec0 mii_bus due to the inactive of fec0. In order to fix
>>>> this issue, we create a device link between phy dev and fec0.
>>>> This will make sure that fec0 is always active when fec1
>>>> is in active mode.
>>
>> Still not clear to me how the proposed fix works, let alone how it does not
>> leak device links since there is no device_link_del(), also you are going to
>> be creating guaranteed regressions by putting that change in the PHY
>> library.
> 
> The reference leak is bad, but i think phylib is the correct place to
> fix this general issue. It is not specific to the FEC. There are other
> boards with dual MAC SoCs and they save a couple of pins by putting
> both PHYs on one MDIO bus. Having the link should help better
> represent the device tree so that suspend/resume can do stuff in the
> right order.

My concern is that we already have had a hard time solving the proper 
suspend/resume sequence whether the MAC suspends the PHY or the MDIO bus 
suspends the PHY and throwing device links will either change the 
ordering in subtle ways, or hopefully just provide the same piece of 
information we already have via mac_managed_pm.

It seems like in Xiaolei's case, the MDIO bus should suspend the PHY and 
that ought to take care of all dependencies, one would think.
-- 
Florian

