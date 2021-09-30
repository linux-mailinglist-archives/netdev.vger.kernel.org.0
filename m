Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CC41DA42
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351143AbhI3Mx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351051AbhI3Mx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:53:26 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B7EC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:51:44 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id e15so24833134lfr.10
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FvnQv2PYeeo35BwjfFDwQleHpbs2Kv9Tl0tDLW+bhsc=;
        b=BrREo6qxMiyl4CnjFUP6kL0IS56M1bKu0KsdoyPqfDMKNEzlonFbjhkUU2EYsjle6P
         xiRi7Skhc5lHGNEwzXAOcKSh4Dp2EjNMBbn7/HMgNNam6tJlb5FjrJ017zBr/hSzn8qu
         EtGGHYm26mTSzr/lXFNSDIaew5rK9foQHMbhWxfbLNrSP/GuiG3nbZNENd79jjn8HT+t
         AlzSgL2KyC13iAoEdYHw3T2yzfJ0wAqyFB1Fvv4jXGwWtoQXZ+E5mjYfl+p22jhE6chx
         YNQSFtQwrZkS+EmGSDXSRHT9t01r/9fN8QST+MpUTQr6UhjjiGhYryNvBTyHDvcFxnej
         d8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FvnQv2PYeeo35BwjfFDwQleHpbs2Kv9Tl0tDLW+bhsc=;
        b=n+1LNFspgns+syPT0wUH623G5M859RzMudozUd7RrXgxnRuviN+ur73rLoKBOA/2G/
         7vkZMct9k8EzJ/YBePK9mcauc0p/5b01jdnFiPK7imVU7toA2ppG8rrd8fhk3Z01FSuf
         4+GvQ2fhcHdU0XAJptTXAMpxem2HdE7E3kMH1/9rfJv1aJhfXfiokHobUmn5TKJHRAyF
         9PlnBFMoTCaHU4SiBW1Yx2UA4Cfp2Rd/VncrGNoB46fl7qWTuCoq333KYt0xMi8bzrXK
         qOBzHRCOkcjasbF/YAyLJX44b22HaR4CC2E/bsZAl02kqw7nofPd5qLo9SMloEc8TDeb
         iWrw==
X-Gm-Message-State: AOAM532bFy6cpT5jXK5XHWPJbX7zEZAzHGlVwkhfeijqbk0mdhFFVsQz
        Bga3NqBeIq+O7SJYO4yUJaM=
X-Google-Smtp-Source: ABdhPJwf+f1Q7eKJamx2x4I4cvPCWd50A78PzjZZ8OwLJHb/cTPfBqXsTgXBT1C0XvVmFji9ve199A==
X-Received: by 2002:a19:c741:: with SMTP id x62mr5747128lff.491.1633006302529;
        Thu, 30 Sep 2021 05:51:42 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id q12sm361325lfn.202.2021.09.30.05.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 05:51:42 -0700 (PDT)
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
References: <2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com>
 <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
 <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
 <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
 <f51658fb-0844-93fc-46d0-6b3a7ef36123@gmail.com>
 <YVWt2B7c9YKLlmgT@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <955416fe-4da4-b1ec-aadb-9b816f02d7f2@gmail.com>
Date:   Thu, 30 Sep 2021 14:51:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVWt2B7c9YKLlmgT@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 14:30, Russell King (Oracle) wrote:
>> It's actually OpenWrt's downstream swconfig-based b53 driver that
>> matches this device.
>>
>> I'm confused as downstream b53_mdio.c calls phy_driver_register(). Why
>> does it match MDIO device then? I thought MDIO devices should be
>> matches only with drivers using mdio_driver_register().
> 
> Note that I've no idea what he swconfig-based b53 driver looks like,
> I don't have the source for that to hand.
> 
> If it calls phy_driver_register(), then it is registering a driver for
> a MDIO device wrapped in a struct phy_device. If this driver has a
> .of_match_table member set, then this is wrong - the basic rule is
> 
> 	PHY drivers must never match using DT compatibles.
> 
> because this is exactly what will occur - it bypasses the check that
> the mdio_device being matched is in fact wrapped by a struct phy_device,
> and we will access members of the non-existent phy_device, including
> the "uninitialised" mutex.
> 
> If the swconfig-based b53 driver does want to bind to a phy_device based
> DT node, then it needs to match using either a custom .match_phy_device
> method in the PHY driver, or it needs to match using the PHY IDs.

Sorry, I should have linked downstream b53_mdio.c . It's:
https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/files/drivers/net/phy/b53/b53_mdio.c;h=98cdbffe73c7354f4401389dfcc96014bff62588;hb=HEAD

You can see that is *uses* of_match_table.

What about refusing bugged drivers like above b53 with something like:

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index b848439fa..76c8197d3 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -941,6 +941,10 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
  {
         struct mdio_device *mdio = to_mdio_device(dev);

+       if (WARN_ONCE(!(mdio->flags & MDIO_DEVICE_FLAG_PHY),
+                "Bugged driver %s\n", drv->name))
+               return 0;
+
         if (of_driver_match_device(dev, drv))
                 return 1;

