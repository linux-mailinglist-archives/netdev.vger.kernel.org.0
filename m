Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49FA4119E4
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhITQhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhITQhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:37:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E80AC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 09:36:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so11437978plp.7
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 09:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=t0RuOra3DA3fNTP8kHXDDv52lBgpTUwqeXqUJQsNryE=;
        b=Ya7qRJmiPPVK5HsidpvkogqHgd6A+dLcwNKi9eOYKKreuWbQpacBWSE5zQQf3M1sOm
         cPAHY2kPgZu3ucY+c4ihIuIIJkAqzUDIooPhgH31FJiby8RVr4H8mOLLh/xCSmZBL36S
         kz/WMIP5XNk6oRU5It0HrjrIDnQyvWyBxsZLH4gxKcaGhOSd2ukDt/zrfyFeCKYoo8jr
         Fk8eD2CHRHUKeFHl1O55tD99r9S7YJZLeHCamg9Yf5wrG1bKimwKXTHKc+jtmitRC177
         PWB3Z34oWug8e34FP2sAYCaQW+WwC4Qp5gCro26sKE6gzvb+OGZc2G8UW2k3vwD2X69B
         sFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t0RuOra3DA3fNTP8kHXDDv52lBgpTUwqeXqUJQsNryE=;
        b=mtFc4xNygRI+uJ3RJK0ZYVqM0DJv2YjaRyehuqMGwwmyFKyZ8Zp57YKvObHZxwiw4z
         Axl/6wl2FdVXc02bAl03Vsikq7rIEKA8eLOqgtCt2A9vYSMB0tUM4wkp1y9QgavEhiXt
         BD2A8np278smPBvUSGeTt6x+BB7HbIcopJTOwHn604Ee1HJwE1l5tSk6OLMVzIhgKXXT
         nC1nvYhhgf63ALwCGFWT9hdETCDJTWj+nvKGpr51bculaqGWcI3p6ytLKBNWciHruSQ8
         NUMHUqeVoGEqYV49cFSI+kepGhdLZ8luRyypvc9yhFOetmHwlK5byZtlArU4Wy7AFZT0
         X8iQ==
X-Gm-Message-State: AOAM531pE1nD3mDbAM+sqUrnMhXKxosh9TmmVYMRKORrLXvxXWWwRPRs
        iTkROyI6BKHVSXDppdV82pI=
X-Google-Smtp-Source: ABdhPJy1yCHbtxEgVQPEwA/2J06o2uiR5qO5IcZdg1H5xCTK7/YmgbxYn33MgQ2L02CAFp7j7TsygQ==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr38960709pjb.155.1632155785642;
        Mon, 20 Sep 2021 09:36:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b7sm16259503pgs.64.2021.09.20.09.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 09:36:25 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
Date:   Mon, 20 Sep 2021 09:36:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Andrew, Vladimir, Heiner, Russell, Saravana,

On 9/20/21 5:52 AM, Rafał Miłecki wrote:
> I have problem using a switch b53 MDIO driver with an Ethernet bgmac
> driver.
> 
> bgmac registers MDIO bus before registering Ethernet controller. That
> results in kernel probing switch (available as MDIO device) early which
> results in dsa_port_parse_of() returning -EPROBE_DEFER.

Yes, putting the big picture together and assuming you have applied
these 3 patches which is how you observed that:

https://lore.kernel.org/linux-devicetree/20210920123441.9088-1-zajec5@gmail.com/
https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/
https://lore.kernel.org/linux-devicetree/20210920141024.1409-2-zajec5@gmail.com/

This is somewhat expected unfortunately and I don't know how we can
break the circular dependencies here.

> 
> It's OK so far but then in goes like this:
> 
> [    1.306884] bus: 'bcma': driver_probe_device: matched device bcma0:5
> with driver bgmac_bcma
> [    1.315427] bus: 'bcma': really_probe: probing driver bgmac_bcma with
> device bcma0:5
> [    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS)
> [    1.329722] libphy: bcma_mdio mii bus: probed
> [    1.334468] bus: 'mdio_bus': driver_probe_device: matched device
> bcma_mdio-0-0:1e with driver bcm53xx
> [    1.343877] bus: 'mdio_bus': really_probe: probing driver bcm53xx
> with device bcma_mdio-0-0:1e
> [    1.353174] bcm53xx bcma_mdio-0-0:1e: found switch: BCM53125, rev 4
> [    1.359595] bcm53xx bcma_mdio-0-0:1e: failed to register switch: -517
> [    1.366212] mdio_bus bcma_mdio-0-0:1e: Driver bcm53xx requests probe
> deferral
> [    1.373499] mdio_bus bcma_mdio-0-0:1e: Added to deferred list
> [    1.379362] bgmac_bcma bcma0:5: Support for Roboswitch not implemented
> [    1.387067] bgmac_bcma bcma0:5: Timeout waiting for reg 0x1E0
> [    1.393600] driver: 'Generic PHY': driver_bound: bound to device
> 'bcma_mdio-0-0:1e'
> [    1.401390] Generic PHY bcma_mdio-0-0:1e: Removed from deferred list
> 
> I can't drop "Generic PHY" driver as it's required for non-CPU switch
> ports. I just need kernel to prefer b53 MDIO driver over the "Generic
> PHY" one.
> 
> Can someone help me fix that, please?

I don't think that you have a race condition, but you have the Ethernet
switch's pseudo PHY which is accessible via MDIO and the Generic PHY
driver happily goes on trying to read the MII_PHYSID1/PHYS_ID2 which do
not map to anything on that switch, but still you will get a
non-zero/non-all Fs value from there, hence the Generic PHY is happy to
take over.

Given that the MDIO node does have a compatible string which is not in
the form of an Ethernet PHY's compatible string, I wonder if we can
somewhat break the circular dependency using that information.
-- 
Florian
