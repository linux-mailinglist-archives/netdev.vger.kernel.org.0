Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333D441D977
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350725AbhI3MQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348201AbhI3MQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:16:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7669CC06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:14:57 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y26so24397143lfa.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 05:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LUzm60FGJe4NuzR1lZK50dl85yoRgb/LYB8EuU1ILxs=;
        b=cy9+ZXWqgovOvk8sXhUvNVnPM9cw7vy0MJOLVOmbLinEVgiZQns06RLRPjamfRyKnV
         rBkQjrO9UXXmdOrKoVovz0xlF0L4ZG6q6QZ5IRNcMN+xrAqOIQFV50PYbqRrSFJqT/pH
         5IfGYDr72dRLs6iwgPjF1DyrCmaa1vo3HfvnEJfDEbDfgEUV4bD8onegHhmi1VtsTzwQ
         o1uWirIahiVHU20fOfKNZqhVuXAanEUNlbRUVCEy1II0MZkK0V+u3ojAOB/wqqhv+HZE
         9qYsD9T2chFkOQz6tANyCLxykfUATqK26mubOeKDqYU/7OraRY9o7Ee552W5RA3OnLAs
         08Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUzm60FGJe4NuzR1lZK50dl85yoRgb/LYB8EuU1ILxs=;
        b=vRL8cLjxDM+h1vFTScVuux/aXyOK66C+zA0HQSXbwFDD1RVY9UcdVozmexCjXnobZH
         uU61NBBcErucaLJrB8TObKLMEiCh43CO71T47ozJls9qCFyUPHt8BwOIa3e7UHv48iCH
         fH+mr6Uthgd4R4oo+lXc/+ZdJ+MVi+Qjae1TcfMmmkbJRZa3Jv0aD2/DNaVE6Cn3R/DC
         bfFF2feXn4Ib/hlbTf2PbuKJYGNC+IxWDbT8Lkka8PNI2JP2gDSpuURPfl+XxJfO9xMe
         KM0UEXSW606YUNIHCVnH378ah9wIlNJh8tB9BiS8+MLLWXGavviLXoO9sDLWPxQs3WQo
         1mfw==
X-Gm-Message-State: AOAM530W03bKTAGpfyKkYCT3M5eIIL5dQHT/pqfEF60kpS58dxJ0vOCU
        A6thNsKoDgdTjAFW7PeT61XvU1341FY=
X-Google-Smtp-Source: ABdhPJzzEaFoMD+/3VR73vQjka6uzkvyoin7HlAb3gptothsTiCNiIhLF/9P3FU3L9WLT26VAKaNCA==
X-Received: by 2002:a05:6512:36c5:: with SMTP id e5mr5872722lfs.594.1633004095893;
        Thu, 30 Sep 2021 05:14:55 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id o12sm350551lft.254.2021.09.30.05.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 05:14:55 -0700 (PDT)
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
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <f51658fb-0844-93fc-46d0-6b3a7ef36123@gmail.com>
Date:   Thu, 30 Sep 2021 14:14:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 13:44, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 01:29:33PM +0200, Rafał Miłecki wrote:
>> On 30.09.2021 12:40, Russell King (Oracle) wrote:
>>> In phy_probe, can you add:
>>>
>>> 	WARN_ON(!(phydev->mdio.flags & MDIO_DEVICE_FLAG_PHY));
>>>
>>> just to make sure we have a real PHY device there please? Maybe also
>>> print the value of the flags argument.
>>>
>>> MDIO_DEVICE_FLAG_PHY is set by phy_create_device() before the mutex is
>>> initialised, so if it is set, the lock should be initialised.
>>>
>>> Maybe also print mdiodev->flags in mdio_device_register() as well, so
>>> we can see what is being registered and the flags being used for that
>>> device.
>>>
>>> Could it be that openwrt is carrying a patch that is causing this
>>> issue?
>>
>> I don't think there is any OpenWrt patch affecting that.
>>
>> MDIO_DEVICE_FLAG_PHY seems to be missing.
> 
> Right, so the mdio device being registered is a non-PHY MDIO device.
> It doesn't have a struct phy_device around it - and so any access
> outside of the mdio_device is an out-of-bounds access.

I can confirm that.

of_mdiobus_register() iterates over node children. It calls
of_mdiobus_child_is_phy() for the /mdio-mux@18003000/mdio@200/switch@0
and that returns 0. It results in calling of_mdiobus_register_device().

So we have MDIO device as expected. It's not a PHY device.


> Consequently, phylib should not be matching this device. The only
> remaining way I can see that this could happen is if a PHY driver has
> an OF compatible, which phylib drivers should never have.

It's actually OpenWrt's downstream swconfig-based b53 driver that
matches this device.

I'm confused as downstream b53_mdio.c calls phy_driver_register(). Why
does it match MDIO device then? I thought MDIO devices should be
matches only with drivers using mdio_driver_register().
