Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18727652399
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiLTPTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLTPTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:19:47 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603231CFCC
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:19:45 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jo4so21051105ejb.7
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+Zkah96Pjz8jfTvfRhmAhIR4v6LAZDvIadqc+xbwqk=;
        b=lOLn35xMpFg2t5H4KfxOkcUzuzo0yXZNPdTHXI538rNgcrQDsIJjEDmALBVSclVlQ+
         Wxa1Poj3M8KcrZJDP24sDfoGxcsuhgysTIrIw3P7eWQjqXMhjM3PQ9SDCBz5NtMxEvO6
         ORQcgYRUPjclYtCueeuMio9f5EXBPPKMlPuZXO1hGatcEKYGJdRIFDRcSmVjXLOPucSX
         tpaO/yZnWOW62Sq/SqIGoIolneE8qBiXSzeWQHtdo91D1IGRKpT2mcbFKfUE4hLYYWkx
         Y0il0ZV8DCG9gh7VOnYsBwsbFFXzg4Q3Fsqi//Y+EZUSrFchf0jKV6HHZ6yPkSvEHJS9
         Tp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+Zkah96Pjz8jfTvfRhmAhIR4v6LAZDvIadqc+xbwqk=;
        b=u7xlbW9rtcmTfH2maB5N+kX94FnqoL6U+a/RcX7V5wX6mpK6IjIBMrXO1MkS79ZytQ
         J4MNxqMVcPwMyucz7tTE5rvx8unDASnv2Afufc0QLBPtktoD0dZOT/dIX5RjYfQvxobm
         D5z3wX3PE2iXXdlDoc1EgkHewuxbmFPqoA9P3OwoDiyh3kGhWkPnOHxiUx72RrWOO3fw
         JgO9oesP2GW11RKYkRMgtM0vm+wXlQe6hjbuP8SYi0rMpjGBVLEzfXRLY+nFVw8Q99Em
         K0Hacd5WJvxeJfi7DK7JkRbPZhb27PGpPBG0xJCDMZ6BLcwpDdoMyerswfcO1l5jn0P8
         Jhbw==
X-Gm-Message-State: ANoB5pn2yeildQEMsst/kDYmnFjxE1mrhnioJHSvM21sd/TfTpXKMq/E
        HzZHxpAVqfvBvmAHVpmz5nQ=
X-Google-Smtp-Source: AA0mqf6vP7QqK6gaotpmVjy3qYFZJ63X2v4bZBemHXCuQE+YEHe717ePAh5Er1YSsl7XQLiEG4hRWA==
X-Received: by 2002:a17:906:3055:b0:7aa:76a:fb3 with SMTP id d21-20020a170906305500b007aa076a0fb3mr39130281ejd.66.1671549583899;
        Tue, 20 Dec 2022 07:19:43 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8e2:dc00:9c4:70b9:1e65:a7a9? (dynamic-2a01-0c23-b8e2-dc00-09c4-70b9-1e65-a7a9.c23.pool.telefonica.de. [2a01:c23:b8e2:dc00:9c4:70b9:1e65:a7a9])
        by smtp.googlemail.com with ESMTPSA id cm12-20020a0564020c8c00b00463b9d47e1fsm5872399edb.71.2022.12.20.07.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 07:19:43 -0800 (PST)
Message-ID: <cc720a28-9e73-7c88-86af-8814b02ee580@gmail.com>
Date:   Tue, 20 Dec 2022 16:19:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
In-Reply-To: <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.12.2022 16:02, Enguerrand de Ribaucourt wrote:
>> From: "Heiner Kallweit" <hkallweit1@gmail.com>
>> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>,
>> "netdev" <netdev@vger.kernel.org>
>> Cc: "Paolo Abeni" <pabeni@redhat.com>, "woojung huh"
>> <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
>> <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>, "Russell King -
>> ARM Linux" <linux@armlinux.org.uk>
>> Sent: Tuesday, December 20, 2022 3:40:15 PM
>> Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
>> phy_disable_interrupts()
> 
>> On 20.12.2022 14:19, Enguerrand de Ribaucourt wrote:
>>> It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
>>> made non static. For consistency with the other exported functions in
>>> this file, EXPORT_SYMBOL should be used.
> 
>> No, it wasn't forgotten. It's intentional. The function is supposed to
>> be used within phylib only.
> 
>> None of the phylib maintainers was on the addressee list of your patch.
>> Seems you didn't check with get_maintainers.pl.
> 
>> You should explain your use case to the phylib maintainers. Maybe lan78xx
>> uses phylib in a wrong way, maybe an extension to phylib is needed.
>> Best start with explaining why lan78xx_link_status_change() needs to
>> fiddle with the PHY interrupt. It would help be helpful to understand
>> what "chip" refers to in the comment. The MAC, or the PHY?
>> Does the lan78xx code assume that a specific PHY is used, and the
>> functionality would actually belong to the respective PHY driver?
> 
> Thank you for your swift reply,
> 
> The requirement to toggle the PHY interrupt in lan78xx_link_status_change() (the
> LAN7801 MAC driver) comes from a workaround by the original author which resets
> the fixed speed in the PHY when the Ethernet cable is swapped. According to his
> message, the link could not be correctly setup without this workaround.
> 
> Unfortunately, I don't have the cables to test the code without the workaround
> and it's description doesn't explain what problem happens more precisely.
> 
> The PHY the original author used is a LAN8835. The workaround code directly
> modified the interrupt configuration registers of this LAN8835 PHY within
> lan78xx_link_status_change(). This caused problems if a different PHY was used
> because the register at this address did not correspond to the interrupts
> configuration. As suggested by the lan78xx.c maintainer, a generic function
> should be used instead to toggle the interrupts of the PHY. However, it seems
> that maybe the MAC driver shouldn't meddle with the PHY's interrupts according
> to you. Would you consider this use case a valid one?
> 
So this workaround works around a silicon bug in LAN8835?
Then the code supposedly should go to the link_change_notify handler of the
Microchip PHY driver for LAN8835.
There's just a generic PHY driver for LAN88xx. Would be helpful to know
which Microchip PHY's are affected.

> Enguerrand
> 
>>> Fixes: 3dd4ef1bdbac ("net: phy: make phy_disable_interrupts() non-static")
>>> Signed-off-by: Enguerrand de Ribaucourt
>>> <enguerrand.de-ribaucourt@savoirfairelinux.com>
>>> ---
>>> drivers/net/phy/phy.c | 1 +
>>> 1 file changed, 1 insertion(+)
> 
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index e5b6cb1a77f9..33250da76466 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -992,6 +992,7 @@ int phy_disable_interrupts(struct phy_device *phydev)
>>> /* Disable PHY interrupts */
>>> return phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
>>> }
>>> +EXPORT_SYMBOL(phy_disable_interrupts);
> 
>>> /**
>>> * phy_interrupt - PHY interrupt handler

