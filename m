Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB68D63C7DC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiK2TMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiK2TMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:12:42 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D3556557;
        Tue, 29 Nov 2022 11:12:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w23so14364572ply.12;
        Tue, 29 Nov 2022 11:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7AY+x+BqSAgv6bctYieVMG5MdhqOFV9IbNSXdj3hvH4=;
        b=DvNSwUlQOeNhQKkxpzz/paEzNJib6Fvka5wtsHI9ZkYTTYLo9oB9H7+tqRxVi9Xd1x
         mlPw0+vhikmiOn/cf7oGXWNEtw7dyOQKE9zQmW+2M0ESnh3+gOHqp2lwgY4Ab58KcHX0
         6ni9h8wkbC+K5KcNATvIyMOoFK8kg/U/xULooAiTfpKmWst2YwIX+DbUGsCXm6CDnysQ
         R0kUwCScnYbiHoOmhJPJal2wiQ8+3DkuQCm2tfvVBne7pKtM4DyAOdqHkZnyAxcEB2Zf
         6+p4Pf0DZKiecAtHYNnTWD3Cn+pEH5kz2D+fsB0m0WINchau2V3DR97gH8LwCQiwEzAp
         jmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7AY+x+BqSAgv6bctYieVMG5MdhqOFV9IbNSXdj3hvH4=;
        b=UYmjK5M8ZWWJe1Vl+rZif/lEVRYbc5/iGZJKpiVLicX2VIR9bjN4OJaA8xhivjrVm0
         hk+kf0kaqMX8ciOndJpu3JFxPn7FcuEtonH3B3QabUtIZrAeNjYfPGHVT8DnhDZRBZW2
         M+cJiv+TacjxTqlSjEhXkbe+wHFJbcu4JdQFoMNBVSilgKC4kkFgPlXVfHuUsD/2BMRO
         QssU2iide00pCfNtnpnmg2ncWXG6nMyyDYf4Wc21qq64hxia9T4rmG4WDPyBeKkX7Ae8
         1j0dypk454UQweoXsZsI2WutwtaH8rRTyg4D05yYD03NVXFZ/AdOgtc/jax0roJIOIlu
         FybQ==
X-Gm-Message-State: ANoB5pkHUXZEKOD94yXiicIiTTikGgnoK8KiCoRNe1Q5xntgrrnJKc6Z
        FZ9O1P5cvjC+rH6VYCdGEcc=
X-Google-Smtp-Source: AA0mqf6hKFn2LV/4C8OmPHsCq3uMT4+m4nMkOsLc08GYFbuwY7D/O7rbm7tL1nTvbUv1r7z4xNUF+w==
X-Received: by 2002:a17:902:f643:b0:187:3c62:5837 with SMTP id m3-20020a170902f64300b001873c625837mr40934615plg.123.1669749157763;
        Tue, 29 Nov 2022 11:12:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pl7-20020a17090b268700b0020bfd6586c6sm1710771pjb.7.2022.11.29.11.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 11:12:36 -0800 (PST)
Message-ID: <e8a0b66d-4b13-3c07-6ba8-cec40a6c4422@gmail.com>
Date:   Tue, 29 Nov 2022 11:12:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for
 BCMGENET under ARCH_BCM2835
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20221125115003.30308-1-yuehaibing@huawei.com>
 <20221128191828.169197be@kernel.org>
 <92671929-46fb-4ea8-9e98-1a01f8d6375e@app.fastmail.com>
 <10c264a3-019e-4473-9c20-9bb0c9af97c3@app.fastmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <10c264a3-019e-4473-9c20-9bb0c9af97c3@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 03:58, Arnd Bergmann wrote:
> [Florian's broadcom.com address bounces, adding him to Cc
> with his gmail address]

Yes, because it's not a valid email address :) it's either lastname, or 
first.lastname.

> 
> On Tue, Nov 29, 2022, at 12:56, Arnd Bergmann wrote:
>> On Tue, Nov 29, 2022, at 04:18, Jakub Kicinski wrote:
>>> On Fri, 25 Nov 2022 19:50:03 +0800 YueHaibing wrote:
>>>> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
>>>> index 55dfdb34e37b..f4ca0c6c0f51 100644
>>>> --- a/drivers/net/ethernet/broadcom/Kconfig
>>>> +++ b/drivers/net/ethernet/broadcom/Kconfig
>>>> @@ -71,13 +71,14 @@ config BCM63XX_ENET
>>>>   config BCMGENET
>>>>   	tristate "Broadcom GENET internal MAC support"
>>>>   	depends on HAS_IOMEM
>>>> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
>>>>   	select MII
>>>>   	select PHYLIB
>>>>   	select FIXED_PHY
>>>>   	select BCM7XXX_PHY
>>>>   	select MDIO_BCM_UNIMAC
>>>>   	select DIMLIB
>>>> -	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
>>>> +	select BROADCOM_PHY if ARCH_BCM2835
>>>>   	help
>>>>   	  This driver supports the built-in Ethernet MACs found in the
>>>>   	  Broadcom BCM7xxx Set Top Box family chipset.
>>>
>>> What's the code path that leads to the failure? I want to double check
>>> that the driver is handling the PTP registration return codes correctly.
>>> IIUC this is a source of misunderstandings in the PTP API.
>>>
>>> Richard, here's the original report:
>>> https://lore.kernel.org/all/CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com
>>
>> The original report was for a different bug that resulted in the
>> BROADCOM_PHY driver not being selectable at all.
>>
>> The remaining problem here is this configuration:
>>
>> CONFIG_ARM=y
>> CONFIG_BCM2835=y
>> CONFIG_BCMGENET=y
>> CONFIG_PTP_1588_CLOCK=m
>> CONFIG_PTP_1588_CLOCK_OPTIONAL=m
>> CONFIG_BROADCOM_PHY=m
>>
>> In this case, BCMGENET should 'select BROADCOM_PHY' to make the
>> driver work correctly, but fails to do this because of the
>> dependency. During early boot, this means it cannot access the
>> PHY because that is in a loadable module, despite commit
>> 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
>> trying to ensure that it could.

I don't believe this is the failure mechanism because there is always a 
fallback to the Generic PHY driver, the issue is that we have configured 
a specific RGMII mode in the Device Tree that is acted on by both the 
Ethernet MAC and the PHY in a way that is electrically incompatible 
unless the proper PHY driver is also enabled such that the RGMII mode is 
enabled on the PHY side.
-- 
Florian

