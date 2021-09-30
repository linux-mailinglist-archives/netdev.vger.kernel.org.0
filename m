Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D43E41DB50
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351748AbhI3Noc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350042AbhI3NoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:44:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B2DC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:42:42 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b20so25732159lfv.3
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 06:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eTRefFo5/QzXg0uBhtcLXKSIQ+F8sK8Pt8UvnFqWI2k=;
        b=dbCvbs/tZStxPLieHW9TVauSoVKYUgfd/+G2gX6Rsewrcioqkg8gkQA6rCwvvAGRlJ
         76g6LV3B2YXjvrFVsA40vHZ720enoZqWSOG0PlXbUJVXArjUc08v7pI7sXfeWkGiP4t+
         qw3/MeKlTwMJuKI09rix7seUgtf6hm8vCl50lA2FlZlKg9v6BANgPp0uJNleVFrT1bFh
         71mr+9zAtPTWmWPZAZUrH0TAZ4xuQP8Lsj7QLsAYq6yz68WW0H3lkOKPRFXB9BXQTuVu
         FJfpt0zlKvSS102YamHphjxQjAnImhBznkuSl42Nyo2n59F5SIGiA7pbcqJY2LC1EBVK
         tUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eTRefFo5/QzXg0uBhtcLXKSIQ+F8sK8Pt8UvnFqWI2k=;
        b=474XMboi3APRCqMnF4A0rMANGml7hB5ntuX8+5aNvuPNBrRn5+Izc0I5SmPPUZ0lfz
         00Xa1B9cjlzkXo0jotpQEFbeCKra3R8diOcKnHh2MPieSXhrj0oAYXDMua25avZpvy6v
         vXGCZRzFtAWN4p6JfsHkkGnfV9I1fxe2/s6kmUmBBgkjVNkRT/oXY0cJgvG8T8PUbeDP
         1aq5LZqXqKEU8pqSgrXUZtH5yYTTk53xy0jsWVOYNAnu/g5HDpMOxlveFz8jXnqAn0Nm
         po/kWRBIv+vGeGnSYGh6RM7eHDraVztbqhn0INevdPO6ADE03EGll7D2jD+Sg+g8XH9C
         Qbxg==
X-Gm-Message-State: AOAM531Nbm9ZpM0o/C8kVz22V5hOLLW7n/h+WWNw9wvB+kppLk+9Q9nJ
        8BcY/zUeD2OqKfhH1PKtg3w=
X-Google-Smtp-Source: ABdhPJwUAWPA1WRTbjufdR7aObuPSL2OK+zpNv9jMM8AXFvUgX342LHKVwzvVkuXGH99z8ipBketaw==
X-Received: by 2002:a2e:a553:: with SMTP id e19mr6417822ljn.420.1633009360320;
        Thu, 30 Sep 2021 06:42:40 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id e3sm351784ljo.2.2021.09.30.06.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 06:42:39 -0700 (PDT)
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
 <955416fe-4da4-b1ec-aadb-9b816f02d7f2@gmail.com>
 <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <dcfb52cb-2d28-a3a9-8a79-7a522e05ce92@gmail.com>
Date:   Thu, 30 Sep 2021 15:42:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 15:07, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 02:51:40PM +0200, Rafał Miłecki wrote:
>> On 30.09.2021 14:30, Russell King (Oracle) wrote:
>>>> It's actually OpenWrt's downstream swconfig-based b53 driver that
>>>> matches this device.
>>>>
>>>> I'm confused as downstream b53_mdio.c calls phy_driver_register(). Why
>>>> does it match MDIO device then? I thought MDIO devices should be
>>>> matches only with drivers using mdio_driver_register().
>>>
>>> Note that I've no idea what he swconfig-based b53 driver looks like,
>>> I don't have the source for that to hand.
>>>
>>> If it calls phy_driver_register(), then it is registering a driver for
>>> a MDIO device wrapped in a struct phy_device. If this driver has a
>>> .of_match_table member set, then this is wrong - the basic rule is
>>>
>>> 	PHY drivers must never match using DT compatibles.
>>>
>>> because this is exactly what will occur - it bypasses the check that
>>> the mdio_device being matched is in fact wrapped by a struct phy_device,
>>> and we will access members of the non-existent phy_device, including
>>> the "uninitialised" mutex.
>>>
>>> If the swconfig-based b53 driver does want to bind to a phy_device based
>>> DT node, then it needs to match using either a custom .match_phy_device
>>> method in the PHY driver, or it needs to match using the PHY IDs.
>>
>> Sorry, I should have linked downstream b53_mdio.c . It's:
>> https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/files/drivers/net/phy/b53/b53_mdio.c;h=98cdbffe73c7354f4401389dfcc96014bff62588;hb=HEAD
> 
> Yes, I just found a version of the driver
> 
>> You can see that is *uses* of_match_table.
>>
>> What about refusing bugged drivers like above b53 with something like:
> 
> That will break all the MDIO based DSA and other non-PHY drivers,
> sorry.
> 
> I suppose we could detect if the driver has the MDIO_DEVICE_IS_PHY flag
> set, and reject any device that does not have MDIO_DEVICE_IS_PHY set:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..7bc06126ce10 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -939,6 +939,12 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
>   static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>   {
>   	struct mdio_device *mdio = to_mdio_device(dev);
> +	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
> +
> +	/* Both the driver and device must type-match */
> +	if (!(mdiodrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) ==
> +	    !(mdio->flags & MDIO_DEVICE_FLAG_PHY))
> +		return 0;
>   
>   	if (of_driver_match_device(dev, drv))
>   		return 1;
> 

In OpenWrt & bugged b53 case we have:
1. Device without MDIO_DEVICE_FLAG_PHY
2. Driver with MDIO_DEVICE_IS_PHY

I think the logic should be to return 0 on mismatch (reverted).

Above code doesn't prevent probing bugged b53 driver.


> In other words, the driver's state of the MDIO_DEVICE_IS_PHY flag
> must match the device's MDIO_DEVICE_FLAG_PHY flag before we attempt
> any matches.
> 
> If that's not possible, then we need to prevent phylib drivers from
> using .of_match_table:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index e62f7a232307..dacf0b31b167 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2501,6 +2501,16 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
>   		return -EINVAL;
>   	}
>   
> +	/* PHYLIB device drivers must not match using a DT compatible table
> +	 * as this bypasses our checks that the mdiodev that is being matched
> +	 * is backed by a struct phy_device. If such a case happens, we will
> +	 * make out-of-bounds accesses and lockup in phydev->lock.
> +	 */
> +	if (WARN(new_driver->mdiodrv.driver.of_match_table,
> +		 "%s: driver must not provide a DT match table\n",
> +		 new_driver->name))
> +		return -EINVAL;
> +
>   	new_driver->mdiodrv.flags |= MDIO_DEVICE_IS_PHY;
>   	new_driver->mdiodrv.driver.name = new_driver->name;
>   	new_driver->mdiodrv.driver.bus = &mdio_bus_type;

FWIW it prevents probing b53:

[    6.226037] ------------[ cut here ]------------
[    6.230687] WARNING: CPU: 1 PID: 1 at drivers/net/phy/phy_device.c:2964 phy_driver_register+0xe4/0x108
[    6.240073] Broadcom B53 (1): driver must not provide a DT match table
[    6.246627] Modules linked in:
[    6.249696] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.10.64 #0
[    6.255714] Hardware name: BCM5301X
[    6.259229] [<c0108410>] (unwind_backtrace) from [<c0104bc4>] (show_stack+0x10/0x14)
[    6.266999] [<c0104bc4>] (show_stack) from [<c03dc6a8>] (dump_stack+0x94/0xa8)
[    6.274249] [<c03dc6a8>] (dump_stack) from [<c01183e8>] (__warn+0xb8/0x114)
[    6.281230] [<c01183e8>] (__warn) from [<c01184ac>] (warn_slowpath_fmt+0x68/0x78)
[    6.288736] [<c01184ac>] (warn_slowpath_fmt) from [<c04b7278>] (phy_driver_register+0xe4/0x108)
[    6.297464] [<c04b7278>] (phy_driver_register) from [<c081b72c>] (b53_phy_driver_register+0x14/0x6c)
[    6.306622] [<c081b72c>] (b53_phy_driver_register) from [<c01017e4>] (do_one_initcall+0x54/0x1e8)
[    6.315526] [<c01017e4>] (do_one_initcall) from [<c0801118>] (kernel_init_freeable+0x23c/0x290)
[    6.324246] [<c0801118>] (kernel_init_freeable) from [<c065acd8>] (kernel_init+0x8/0x118)
[    6.332445] [<c065acd8>] (kernel_init) from [<c0100128>] (ret_from_fork+0x14/0x2c)
[    6.340031] Exception stack(0xc1035fb0 to 0xc1035ff8)
[    6.345089] 5fa0:                                     00000000 00000000 00000000 00000000
[    6.353280] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.361470] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    6.368119] ---[ end trace efac8022c3486581 ]---
