Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D776A223A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBXTRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjBXTRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:17:31 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B596DD8C;
        Fri, 24 Feb 2023 11:17:28 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id l2so328708ilg.7;
        Fri, 24 Feb 2023 11:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1e26bbruHMjLgHC3kf6AF7TXnsQxoIObs73hciyTTjs=;
        b=Y2prViu7RGnF9nNCSevqbgy0xFGBD2OU4Gl7n1Z282XKpZ6VpFsqIEOrJ1+50Qz/FZ
         UA6DW8d+vL1Y2P7bDhHI2bQg11Nd+KjAEVsW5ykf629u1vTmhs9q3GMEmMSaN6y2CRA7
         s5akANQWGQfP3Q+ZrTBEHAPcXnGfP89v79CnlLeTiKO3cKjWiA+jk2TEwtHI3mI34XqJ
         SmXYTksuFRgBsHU7H//sIdBQTYfGwlmqateUDMFhR05Z4IyfSUZM0G52SAgsKgC1tZMA
         yiOEQAcy9tPmXfPLclcknCU6yx/oUrtYnTpmbwHVbkvIk8uJPAQvaeR9hWDseztBO/Uz
         Oo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1e26bbruHMjLgHC3kf6AF7TXnsQxoIObs73hciyTTjs=;
        b=feceEy+zabpnOd4X4OcUoI+Bf1EmMM0PgZxngKJCg5dV0E2MQGWAmZc6nysFgZHBj5
         5KhikOBN3wvu39VjYEOkKODUQOnO1PxxdDMUzgP2zGqO1xbfA2WC68t5+H4LZMecGZuF
         pBsrG3V/pkc3fUGmwZrl0W0rubqlyV1gs5aazRGlzRJoyNjV5EYY1P+PWondHiPaP8xO
         WIApZpJlUREgkWRmY12q4CV+3rR/0EO/d2YU/Mn7iA0P3AKkaDXV9bWp5l6BI04HnKeg
         yhvWSO1UJq/J9uJ20WCdihx0IY13SdFuoGWOAF6W4Rc/pkRU7+5D67QQa3b5wPO942NV
         gxCg==
X-Gm-Message-State: AO0yUKU7wi3/SAgahvL2la2jN+VntzsWA4Yx6hIg95WHaFfXWtqF6ASZ
        qQVzpQ+T17DPbFRAX+hGmKE=
X-Google-Smtp-Source: AK7set9/+2jpC9sutbrQAAb4mHGfP63HMGv3VXKmzx9OQ5XerDMreNhTQtFdXdSwzaJRw3xZuOEDDA==
X-Received: by 2002:a92:7510:0:b0:315:4793:f7b4 with SMTP id q16-20020a927510000000b003154793f7b4mr10006551ilc.31.1677266247325;
        Fri, 24 Feb 2023 11:17:27 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a1-20020a92d341000000b0031535ce9cc8sm4239248ilh.83.2023.02.24.11.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:17:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
Date:   Fri, 24 Feb 2023 11:17:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
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
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
In-Reply-To: <20230224183646.GA26307@pengutronix.de>
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

On 2/24/23 10:36, Oleksij Rempel wrote:
> On Fri, Feb 24, 2023 at 09:41:32AM -0800, Guenter Roeck wrote:
>> On Fri, Feb 24, 2023 at 05:52:13PM +0100, Oleksij Rempel wrote:
>>> On Fri, Feb 24, 2023 at 08:00:57AM -0800, Guenter Roeck wrote:
>>>> On 2/23/23 20:53, Oleksij Rempel wrote:
>>>>> Hallo Guenter,
>>>>>
>>>>> On Thu, Feb 23, 2023 at 08:16:04PM -0800, Guenter Roeck wrote:
>>>>>> On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
>>>>>>> On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
>>>>>>>> Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
>>>>>>>>
>>>>>>>> It should work as before except write operation to the EEE adv registers
>>>>>>>> will be done only if some EEE abilities was detected.
>>>>>>>>
>>>>>>>> If some driver will have a regression, related driver should provide own
>>>>>>>> .get_features callback. See micrel.c:ksz9477_get_features() as example.
>>>>>>>>
>>>>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>>>>>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>>>>>>
>>>>>>> This patch causes network interface failures with all my xtensa qemu
>>>>>>> emulations. Reverting it fixes the problem. Bisect log is attached
>>>>>>> for reference.
>>>>>>>
>>>>>>
>>>>>> Also affected are arm:cubieboard emulations, with same symptom.
>>>>>> arm:bletchley-bmc emulations crash. In both cases, reverting this patch
>>>>>> fixes the problem.
>>>>>
>>>>> Please test this fixes:
>>>>> https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
>>>>>
>>>>
>>>> Applied and tested
>>>>
>>>> 77c39beb5efa (HEAD -> master) net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
>>>> 068a35a8d62c net: phy: do not force EEE support
>>>> 66d358a5fac6 net: phy: c45: add genphy_c45_an_config_eee_aneg() function
>>>> ecea1bf8b04c net: phy: c45: use "supported_eee" instead of supported for access validation
>>>>
>>>> on top of
>>>>
>>>> d2980d8d8265 (upstream/master, origin/master, origin/HEAD, local/master) Merge tag 'mm-nonmm-stable-2023-02-20-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>>
>>>> No change for xtensa and arm:cubieboard; network interfaces still fail.
>>>
>>> Huh, interesting.
>>>
>>> can you please send me the kernel logs.
>>>
>> There is nothing useful there, or at least I don't see anything useful.
>> The Ethernet interfaces (sun4i-emac for cubieboard and ethoc for xtensa)
>> just don't come up.
>>
>> Sample logs:
>>
>> cubieboard:
>>
>> https://kerneltests.org/builders/qemu-arm-v7-master/builds/531/steps/qemubuildcommand/logs/stdio
>>
>> xtensa:
>>
>> https://kerneltests.org/builders/qemu-xtensa-master/builds/2177/steps/qemubuildcommand/logs/stdio
>>
>> and, for completeness, bletchley-bmc:
>>
>> https://kerneltests.org/builders/qemu-arm-aspeed-master/builds/531/steps/qemubuildcommand/logs/stdio
>>
>> Those logs are without the above set of patches, but I don't see a
>> difference with the patches applied for cubieboard and xtensa. I
>> started a complete test run (for all emulations) with the patches
>> applied; that should take about an hour to complete.
>> I could also add some debug logging, but you'd have to give me
>> some hints about what to add and where.
> 
> OK, interesting. These are emulated PHYs. QEMU seems to return 0 or
> 0xFFFF on unsupported registers. May be I'm wrong.
> All EEE read/write accesses depend on initial capability read
> genphy_c45_read_eee_cap1()
> 
> Can you please add this trace:
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index f595acd0a895..67dac9f0e71d 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -799,6 +799,7 @@ static int genphy_c45_read_eee_cap1(struct phy_device *phydev)
>           * (Register 3.20)
>           */
>          val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
> +       printk("MDIO_PCS_EEE_ABLE = 0x%04x", val);
>          if (val < 0)
>                  return val;
> 

For cubieboard:

MDIO_PCS_EEE_ABLE = 0x0000

qemu reports attempts to access unsupported registers.

I had a look at the Allwinner mdio driver. There is no indication suggesting
what the real hardware would return when trying to access unsupported registers,
and the Ethernet controller datasheet is not public.

For xtensa:

MDIO_PCS_EEE_ABLE = 0x0014

I didn't try to find out what that means.

qemu did not report attempts to access unsupported registers.

Guenter

