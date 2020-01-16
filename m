Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2513EBCF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406335AbgAPRwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:52:44 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42145 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406160AbgAPRwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:52:40 -0500
Received: by mail-ed1-f66.google.com with SMTP id e10so19712880edv.9
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z4qPwQ7o7ExsIYoMQyPgkQuMm/Olu8F819ptv7CI3+Y=;
        b=ZcSSuhuG2fYgdRAu39CTSf7EQWB3VGSCzaTezKDEjDjJjKTRrGYL8NCwAbiLrTB/0c
         KJQZiXZyLQmIdceCjWjGGM2a15vzmU5uIHES7nUYGC4SIuCMAaTeGLXD37R7AmU5FcnQ
         +PtfoZIppWKMHde/dgcAWQST4wBp36X5LKNrKBcwxOLIdijHkgd/+mC5gHmc1B0Nm1NV
         /i8kreUyMQX25dsib7qlhMQIgh916GGLAzv3xfCCMvuvE8oO3Ws9pfCZVxlxW29y+AGL
         lh5X7bZHJNlHIYkShHyW+DbXN9fXWNN4VfjFw4718SugbG+x1fIlI4v7Kii/ojvxv/XX
         saYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=z4qPwQ7o7ExsIYoMQyPgkQuMm/Olu8F819ptv7CI3+Y=;
        b=g+SV61WGViSq7J7M9oFfs/KbGSVJHgXYsqZdymGPdi6/HZXwKKBuVdnbef4w0FTtHk
         M0bZ/tDxhIzH6MNLApiTHLWhNDOQq7VI5RCcoT1MCXkVgH2UP7uaRDIboal2OdbO8R7N
         jXvW2Xswx99Ec3UIFSdFjaaqToDmtDKzerzuHraD23JMVPE8in2qSCTfsMZgCHr01D0u
         Swmd5xZcpUI4TyE80rMBO/itUxBUPaHw4JKZdmnpT9oTk4TMOAvqcohdLrsFOnK/rASB
         61sPw32OLeoRwHhc2nlYnoBb02+a7sZWa6CHnwduKFKUGZ5IL4qpWwLdJK1bJjJDuWbx
         HCrw==
X-Gm-Message-State: APjAAAWOAPabVaaZjeiXOPaR5mafskhViY0LjZQ2lA8OlOMXtCM78jt5
        9j1z+KykptZ7xioyoxb3PDE=
X-Google-Smtp-Source: APXvYqzmZ3hFrPR60OPdL46c5vz/lSkLWBnD/OLWE7uIPB/oXVkvt+Kk2MtJgKZYFo6MluhdZb+eIw==
X-Received: by 2002:a17:906:7e59:: with SMTP id z25mr4072831ejr.130.1579197158492;
        Thu, 16 Jan 2020 09:52:38 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j21sm876706eds.8.2020.01.16.09.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 09:52:37 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: don't crash in phy_read/_write_mmd
 without a PHY driver
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>
References: <20200116174628.16821-1-olteanv@gmail.com>
 <CA+h21hqyna1Fyr3ZQ7mwqUOw7rtUgfC3PqTqxg-HWFbDpNKDhg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <62029162-5a88-a015-90ad-d92bf2dc4d93@gmail.com>
Date:   Thu, 16 Jan 2020 09:52:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hqyna1Fyr3ZQ7mwqUOw7rtUgfC3PqTqxg-HWFbDpNKDhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 9:48 AM, Vladimir Oltean wrote:
> On Thu, 16 Jan 2020 at 19:46, Vladimir Oltean <olteanv@gmail.com> wrote:
>>
>> From: Alex Marginean <alexandru.marginean@nxp.com>
>>
>> The APIs can be used by Ethernet drivers without actually loading a PHY
>> driver. This may become more widespread in the future with 802.3z
>> compatible MAC PCS devices being locally driven by the MAC driver when
>> configuring for a PHY mode with in-band negotiation.
>>
>> Check that drv is not NULL before reading from it.
>>
>> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
>> ---
> 
> Ugh. Can I just add here:
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> without resending?

That's a tag that patchwork understands, so yes, that works:

http://patchwork.ozlabs.org/patch/1224348/mbox/

> 
>> If this hasn't been reported by now I assume it wasn't an issue so far.
>> So I've targeted the patch for net-next and not provided a Fixes: tag.
>>
>>  drivers/net/phy/phy-core.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 769a076514b0..a4d2d59fceca 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -387,7 +387,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
>>         if (regnum > (u16)~0 || devad > 32)
>>                 return -EINVAL;
>>
>> -       if (phydev->drv->read_mmd) {
>> +       if (phydev->drv && phydev->drv->read_mmd) {
>>                 val = phydev->drv->read_mmd(phydev, devad, regnum);
>>         } else if (phydev->is_c45) {
>>                 u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
>> @@ -444,7 +444,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
>>         if (regnum > (u16)~0 || devad > 32)
>>                 return -EINVAL;
>>
>> -       if (phydev->drv->write_mmd) {
>> +       if (phydev->drv && phydev->drv->write_mmd) {
>>                 ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
>>         } else if (phydev->is_c45) {
>>                 u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
>> --
>> 2.17.1
>>
> 
> Sorry,
> -Vladimir
> 


-- 
Florian
