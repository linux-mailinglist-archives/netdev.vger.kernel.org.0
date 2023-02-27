Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F966A477E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjB0RD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB0RDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:03:24 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FE91A64D;
        Mon, 27 Feb 2023 09:03:24 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id a1so4287923iln.9;
        Mon, 27 Feb 2023 09:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3PQbL1qmUs2LgzEdZBJJorG5CguGjku/dl0Axwoc0Hg=;
        b=iB7l4fE+XtfoZb1/W5Y2H9qNZQPK6kZ9bHQy+VxvlOugTYjyRoUztESJEabpb9NEzF
         WlTJfe+EjYDFl6znYSm8WOExmrlwTwvaPx3m260xP8x5RKV7D8bquFAGSHN4KMgZCHUz
         ZC4ShQBs8Egff+9lqtSbyIHYs7mi9tEDCM8Vdji6O1Fc+V2l230ZGfLx7QPj5zzA6+Hu
         MG/94NZ+sNgfVzURLdeG2ArGcH3l4pmev+XunKQVr3Ssis3wIwsu/fnOAw2BRIlVsBt1
         E8JTZ47nqd4DpV1H5iKXozN0PhENIPJgShMIgGDnuzDcMK+BFi9i/TK6LFPWWg5pFvy9
         HxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3PQbL1qmUs2LgzEdZBJJorG5CguGjku/dl0Axwoc0Hg=;
        b=Ls/oUFXuf0lLpcTVXPPYtIG7gGkHC/hHWyi8TWj+RLqBCURjPBDs6vuStdV+7amWvx
         dsxxs+YNiim3B+697eaTuHsJN0YHgUtf9AM26p71+/b6WLGdZKgIgVTvp2bBVIuKzsN1
         XiPNgyeuuvNLN5tu6lHMLQ4SSkSHA987Q8XRK12h6X0pMcjt8+8ksF2YCNTJoXkhO79K
         9r1MPMfU7atgDyprovVI0atJwR7ATSEnbeMyhr8jww0Zjb/3Ffoj9N2HtIodivU3D9Lt
         MSKRytCcRa6O720pJ2Frvah95lvUcouwjiD5XUB1xB1pCjHUbrlZLUyAi1OzUcOs8zV5
         /TBg==
X-Gm-Message-State: AO0yUKVxePpI8cNQPZRArk36SAUNsnpGMGFFjZAQk78BjzlDWvvuFaUR
        IAfeM53n1LQsR5++56497i8=
X-Google-Smtp-Source: AK7set9CKjWTMYwqg06S+1PfRE5x9tDfWD/vxcVAwi9D8kRExY/U4idrTg7ZqsWu6O1ShnhnDPm+8g==
X-Received: by 2002:a05:6e02:19c9:b0:315:352e:d5d0 with SMTP id r9-20020a056e0219c900b00315352ed5d0mr52085ill.32.1677517403411;
        Mon, 27 Feb 2023 09:03:23 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n6-20020a02a906000000b0039df8e7af39sm2360208jam.41.2023.02.27.09.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 09:03:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <b7df91c0-a5e6-2a0f-7c04-479c4fbb7f82@roeck-us.net>
Date:   Mon, 27 Feb 2023 09:03:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
 <20230224174132.GA1224969@roeck-us.net>
 <20230224183646.GA26307@pengutronix.de>
 <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
 <Y/yrS65V7h5vG7xN@lunn.ch>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
In-Reply-To: <Y/yrS65V7h5vG7xN@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 05:08, Andrew Lunn wrote:
>>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>>> index f595acd0a895..67dac9f0e71d 100644
>>> --- a/drivers/net/phy/phy-c45.c
>>> +++ b/drivers/net/phy/phy-c45.c
>>> @@ -799,6 +799,7 @@ static int genphy_c45_read_eee_cap1(struct phy_device *phydev)
>>>            * (Register 3.20)
>>>            */
>>>           val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
>>> +       printk("MDIO_PCS_EEE_ABLE = 0x%04x", val);
>>>           if (val < 0)
>>>                   return val;
>>>
>>
>> For cubieboard:
>>
>> MDIO_PCS_EEE_ABLE = 0x0000
>>
>> qemu reports attempts to access unsupported registers.
> 
> MDIO is a serial bus with two lines, clock driven by the bus master
> and data. There is a pull up on the data line, so if the device does
> not respond to a read request, you get 0xffff. That value is all i've
> ever seen a real PHY do when asked to read a register which does not
> exist. So i would say QEMU could be better emulate this.
> 
> The code actually looks for the value 0xffff and then decides that EEE
> is not supporting in the PHY.
> 
> The value of 0x0 is probably being interpreted as meaning EEE is
> supported, but none of the link modes, 10Mbps, 100Mbps etc support
> EEE. I would say it is then legitimate to read/write other EEE
> registers, so long as those writes take into account that no link
> modes are actually supported.
> 
> Reading the other messages in this thread, a bug has been found in the
> patches. But i would also say QEMU could do better.
> 

Sure, it could. Always. That is why I checked the qemu code and
actually tried to implement some of the EEE handling, only to
realize that it didn't help. The emulated PHY does support EEE
and would return either 0x0001 or 0x0003 depending on the
underlying hardware. However, returning that and returning/
accepting reasonable values for other EEE registers didn't make
a difference due to the kernel bug.

Thanks,
Guenter

