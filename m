Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9A2F5F79
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhANLGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhANLGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:06:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1402FC061575;
        Thu, 14 Jan 2021 03:05:32 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t30so5340973wrb.0;
        Thu, 14 Jan 2021 03:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qY7UfjfyOyVy4TxyfB8diKh+Cr2eV9OL3b/7LpArq6Q=;
        b=mztol9d2yyRB66mzQ2YydbrgVk3/W2Ej3T9zEE651nFQZo4GN6V9r18l3M5Xi3HWvQ
         OQ6wxvqctiGzBaLZm3u+JCsexiVgZWdYQEsMNZ5afNbuB71kgoSxeZNO1GzpYo7NuEQh
         nOTYqmE4ZHtpTWbcZ2lgbHdVOQwx5aQNDY0bpHzomcNXBNNzstgSiDs6Jckh3nMBccJc
         USHJsLEVCG0eB4PeueI5arSr82O+Wdc8Kstzs6u68PHqojazLJKfSrhs2gzE/bctueEj
         3wBe64Vlr7qiiXeTaw3fCwBCbtWzZQx4yGtWvKdIETA+c5t3nfV8SwVLxMVu841uh4d4
         pdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qY7UfjfyOyVy4TxyfB8diKh+Cr2eV9OL3b/7LpArq6Q=;
        b=LHqvWFTEHYoEXAWyilZpAGdZGbYiopbsqRUDQHTKVrvI0Ab6x/YTU6GBLDxVL6bAxC
         rc3S6wvUydXAPwOqf/pRpQKjAJ9Og5CX/vkznSU+uwXUgcmOUOmQGo6j+ZT5ytNVGJHP
         BncdPXMIwyrQr+Dalfxsc44UGT/aP2m2gnEZymhIZf+rk2G1pv5jiPSvfrhC4Vg8ZGHs
         ByURYiy95Bziw+LK01f5IqfwNcJfn5Ouxckv4Rp7jeljOtLSxpUKHwyF46rDczu+ckcr
         SgTY9h8lHg+KZVFeqoL/Q2lT5/86usJzV7n1qdy4aEbQomYXYCd6wedQVPSeuy+lt03M
         RDxw==
X-Gm-Message-State: AOAM533aDFae7sOE/jD0diXPIZvDJCTP3VrvwBnswsMbiAVFBhbvAc2H
        OIR2wpZ5wOl+376GiULxmTwKU3oRWF8=
X-Google-Smtp-Source: ABdhPJy9vA7UtOgW3/xEA/01Xxp02SuIq3XuvQDe2G0pXmasFG2A0wt27pAVcltlKPNOxYtKtfgTaQ==
X-Received: by 2002:a05:6000:101:: with SMTP id o1mr7239239wrx.211.1610622330352;
        Thu, 14 Jan 2021 03:05:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:3037:2ac5:86bd:e008? (p200300ea8f06550030372ac586bde008.dip0.t-ipconnect.de. [2003:ea:8f06:5500:3037:2ac5:86bd:e008])
        by smtp.googlemail.com with ESMTPSA id h15sm8951824wru.4.2021.01.14.03.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 03:05:29 -0800 (PST)
To:     Claudiu.Beznea@microchip.com, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        rjw@rjwysocki.net, pavel@ucw.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
 <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <56366231-4a1f-48c3-bc29-6421ed834bdf@gmail.com>
Date:   Thu, 14 Jan 2021 12:05:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.01.2021 11:41, Claudiu.Beznea@microchip.com wrote:
> 
> 
> On 14.01.2021 12:25, Russell King - ARM Linux admin wrote:
>>
>> As I've said, if phylib/PHY driver is not restoring the state of the
>> PHY on resume from suspend-to-ram, then that's an issue with phylib
>> and/or the phy driver.
> 
> In the patch I proposed in this thread the restoring is done in PHY driver.
> Do you think I should continue the investigation and check if something
> should be done from the phylib itself?
> 
It was the right move to approach the PM maintainers to clarify whether
the resume PM callback has to assume that power had been cut off and
it has to completely reconfigure the device. If they confirm this
understanding, then:
- the general question remains why there's separate resume and restore
  callbacks, and what restore is supposed to do that resume doesn't
  have to do
- it should be sufficient to use mdio_bus_phy_restore also as resume
  callback (instead of changing each and every PHY driver's resume),
  because we can expect that somebody cutting off power to the PHY
  properly suspends the MDIO bus before

> Thank you,
> Claudiu Beznea
> 
>>
>> --
>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

