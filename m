Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA326A255A
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 01:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBYAJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 19:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBYAJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 19:09:45 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5058658E2;
        Fri, 24 Feb 2023 16:09:44 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id t7-20020a9d7487000000b00693d565b852so575534otk.5;
        Fri, 24 Feb 2023 16:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rG5c0uuSbUunUALVODvqeVNmwOesQ/VQeoXgcA7DJXs=;
        b=fgXb8wvgxf5IbFqN//rKtMYLknlIYSo7+RXuCe7GWxq0JNoWRqgJoaYt/ZjxUIsZAr
         E/4PE5YQxC2f4LGr8fWvSedTxXyxEz7LrrHJC891Vs6INgtU0OY7bLMUDbVN+Golf7r2
         sjgYBNhvvO0QbRDnxf6p7xLkXwoewFmuUC2yFhjkzHvas5bJzdYmDHmYqppBRus32KWd
         WVuz3JnKs8iSHAuifAI2ctgYRuBGNulvxo6U/jhypH5SWyLIdT2fkNoORvPD/4MrrbGn
         A4F1TzWCZmI2BMzQCIrtUOmlNtpJYzk71xCwaKZRiY+bcLnyCjZtjQwucMBUWYCgY9DG
         BT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rG5c0uuSbUunUALVODvqeVNmwOesQ/VQeoXgcA7DJXs=;
        b=TXgOO7ndrruUwqum1dd4oJ4SYaGNHnnkzE3Oj+Nhhu1sshYRxHkvEKEFrEMCAJb+zm
         wv1q+2x8RZFyh17qSFT5xwqbjyywmnFiokwgiKwGRgSNPUriAFVWsFbguZBfFp7ci8Uo
         nm9N5NM3mvD0nbp5GcdVzR1AFAvN2YRamK4lGf2Pk1eh07p7vwVY/GG4+exl4ra154Ac
         dh89DtvVTwyGLjDHb01DHXv6BEMcWDlmvxAX28/bMzZxMvsI+faP5ZSgEC8w7RVkcWSU
         9/Tcpi9pAiXDD3WYG7Bf9rrwMGsopRX5vN01sQo6lhhqaj/75dJ/1Ub2Q8mCrKDxJHCd
         hCcQ==
X-Gm-Message-State: AO0yUKUrRLiy7g+no7joCodYD31zusRLGGrVtAZlMr1yuKg73rCM3Zd7
        AzaNwDBg0fUeK98uYXFvJysIV3eGtbI=
X-Google-Smtp-Source: AK7set8WcGhFL+TrMKfRHGHfrLPh6vX0fv2xNcQjbcOGlJ7MVJ+9A8udFuZGh/wrhMp6ft8NowmqPQ==
X-Received: by 2002:a9d:7194:0:b0:68b:d266:e6cc with SMTP id o20-20020a9d7194000000b0068bd266e6ccmr9332800otj.19.1677283784052;
        Fri, 24 Feb 2023 16:09:44 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d13-20020a056830138d00b00690e6d56670sm97789otq.25.2023.02.24.16.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 16:09:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <52f8bb78-0913-6e9a-7816-f32cdad688f2@roeck-us.net>
Date:   Fri, 24 Feb 2023 16:09:40 -0800
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
 <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
 <20230224200207.GA8437@pengutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
In-Reply-To: <20230224200207.GA8437@pengutronix.de>
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

On 2/24/23 12:02, Oleksij Rempel wrote:
[ ... ]
>>
>> For cubieboard:
>>
>> MDIO_PCS_EEE_ABLE = 0x0000
>>
>> qemu reports attempts to access unsupported registers.
>>
>> I had a look at the Allwinner mdio driver. There is no indication suggesting
>> what the real hardware would return when trying to access unsupported registers,
>> and the Ethernet controller datasheet is not public.
> 
> These are PHY accesses over MDIO bus. Ethernet controller should not
> care about content of this operations. But on qemu side, it is implemented as
> part of Ethernet controller emulation...
> 
> Since MDIO_PCS_EEE_ABLE == 0x0000, phydev->supported_eee should prevent
> other EEE related operations. But may be actual phy_read_mmd() went
> wrong. It is a combination of simple phy_read/write to different
> registers.
> 

Adding MDD read/write support in qemu doesn't help. Something else in your patch
prevents the PHY from coming up. After reverting your patch, I see

sun4i-emac 1c0b000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

in the log. This is missing with your patch in place.

Anyway, the key difference is not really the qemu emulation, but the added
unconditional call to genphy_c45_write_eee_adv() in your patch. If you look
closely into that function, you may notice that the 'changed' variable is
never set to 0.

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 3813b86689d0..fee514b96ab1 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -672,7 +672,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
   */
  int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
  {
-       int val, changed;
+       int val, changed = 0;

         if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
                 val = linkmode_to_mii_eee_cap1_t(adv);

fixes the problem, both for cubieboard and xtensa.

Guenter

