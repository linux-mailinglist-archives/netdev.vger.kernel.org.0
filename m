Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520443FF4FC
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhIBUfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhIBUe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:34:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38747C061575;
        Thu,  2 Sep 2021 13:34:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso2375743pjb.3;
        Thu, 02 Sep 2021 13:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/bfjN48Z09yXV4KccPup9W0U2yVe6pNdsmk7960L1N8=;
        b=J88wLlImNGuaCGqsHnsA4XkqlqcmEuUD62qb19XqSvBF0cKWJinQZvTMGlMGkdhOKz
         rPte5RLBrrImOImoCpGp2Ao+tLjtkU+08dq9p8Ov2qLxw5mQYq/B2NynEy2hnAQ27z2y
         V+rC/Yt3FYHAYoraNf/GKr8KjdJuA/2JRDaVFMyu/+vczpsLnRii5y/0DI6XBQc+RRsQ
         TPO46cqguBD6yEKq1qmtXOrrD2Oc1av8z6EZB0NuDbo2DmcIt7upAqR2n6I7pqTo9dgM
         ca6cMke/UPT++Atl2Kkr7mRoWai3xoDhsxGrCw4E2/CBFgVJ0Fg4FI6Yh372IPl/2JO8
         rBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/bfjN48Z09yXV4KccPup9W0U2yVe6pNdsmk7960L1N8=;
        b=NQUvD4MzVmrxRr4W5tcCKxua8hXNaXv1v6gjfCcyxQ95nZA2nOquVJoh4prQRVIfpd
         IdlzsUuYTmWpzVoDsFORpnXRSPX7ZtZMfuou2/YMFQo3iLPFrNzCy4CQMQoiyEJk3Q20
         gnj03W09npbkv23tQYOlDZs1WmbBFOXnGAxSEz/ZtKPxqjJ+Nvm0FlCTHXtVbBvYghqx
         SfJZGArsOsfcHf9MtBm2Zkeuw2V9/SNd8/ydaIwMgXIKvn6Znrq5iCxjE3+hmc3K63eD
         NiRs+Q0IbcLhdZ6URcMntWvSiaHJYGIljwbHoJW618+ePBGGWUkNt+y7MflyH5vWoA6N
         0OyQ==
X-Gm-Message-State: AOAM531RIdqcrexluewr3ImBGlmINIzk1OuR5PPKqfGpMSw0jOTeNsaP
        Q9ZRuQrmWeRTlmQSo4W4Sx8=
X-Google-Smtp-Source: ABdhPJwICHHXt7n0nNltVC7hsLNg3fqbTzq8J76wmDWi2wz7pv73q1VR8Y2/wXLKSpoxlRuhKZdPvw==
X-Received: by 2002:a17:90b:3603:: with SMTP id ml3mr37303pjb.96.1630614840591;
        Thu, 02 Sep 2021 13:34:00 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y4sm2977057pjw.57.2021.09.02.13.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 13:34:00 -0700 (PDT)
Message-ID: <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
Date:   Thu, 2 Sep 2021 13:33:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk> <YTErTRBnRYJpWDnH@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YTErTRBnRYJpWDnH@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2021 12:51 PM, Andrew Lunn wrote:
> On Thu, Sep 02, 2021 at 07:50:16PM +0100, Russell King (Oracle) wrote:
>> On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 52310df121de..2c22a32f0a1c 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>>>   
>>>   	/* Assume that if there is no driver, that it doesn't
>>>   	 * exist, and we should use the genphy driver.
>>> +	 * The exception is during probing, when the PHY driver might have
>>> +	 * attempted a probe but has requested deferral. Since there might be
>>> +	 * MAC drivers which also attach to the PHY during probe time, try
>>> +	 * harder to bind the specific PHY driver, and defer the MAC driver's
>>> +	 * probing until then.
>>>   	 */
>>>   	if (!d->driver) {
>>> +		if (device_pending_probe(d))
>>> +			return -EPROBE_DEFER;
>>
>> Something else that concerns me here.
>>
>> As noted, many network drivers attempt to attach their PHY when the
>> device is brought up, and not during their probe function.
> 
> Yes, this is going to be a problem. I agree it is too late to return
> -EPROBE_DEFER. Maybe phy_attach_direct() needs to wait around, if the
> device is still on the deferred list, otherwise use genphy. And maybe
> a timeout and return -ENODEV, which is not 100% correct, we know the
> device exists, we just cannot drive it.

Is it really going to be a problem though? The two cases where this will 
matter is if we use IP auto-configuration within the kernel, which this 
patchset ought to be helping with, if we are already in user-space and 
the PHY is connected at .ndo_open() time, there is a whole lot of things 
that did happen prior to getting there, such as udevd using modaliases 
in order to load every possible module we might, so I am debating 
whether we will really see a probe deferral at all.

> 
> Can we tell we are in the context of a driver probe? Or do we need to
> add a parameter to the various phy_attach API calls to let the core
> know if this is probe or open?

Actually we do the RTNL lock will be held during ndo_open and it won't 
during driver probe.

> 
> This is more likely to be a problem with NFS root, with the kernel
> bringing up an interface as soon as its registered. userspace bringing
> up interfaces is generally much later, and udev tends to wait around
> until there are no more driver load requests before the boot
> continues.

See my point above, with Vladimir's change, we should have fw_devlink do 
its job such that by the time the network interface is needed for IP 
auto-configuration, all of its depending resources should also be ready, 
would not they?
-- 
Florian
