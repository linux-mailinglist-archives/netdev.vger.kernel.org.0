Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892ED41D891
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350374AbhI3LYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350303AbhI3LYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:24:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00B6C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:22:54 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u18so23804925lfd.12
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M8LRQsZ0EshnHPz8PyHyiiiSfpREFwqLez3eu+ixTOk=;
        b=CVvqm0dJKa77A8ePWIYiJOJVk/YmGjDcjiELu+DvOMSU55F4hKdMt3GY0dPDgBomUa
         oDH/gnF9SK/nuWqDpa6rrp1uNXRdhB+j7JRRo82Vul92iN/NDfNy1rcKnHYQxz8+lwRW
         308Ms886vDLSmHmTS8UYDAckOvFRyzRkjo8epKkK21upW8ucedqVxgehqpiz0gKxeFn7
         THlrpPsSdOSgjR7H5YAQ8sJTouB+0ehWGUTWkZkCeSX56BtsxzteMeneGwZLqLHCQ5RW
         jT6R2ArQizShcv5Dv0Py72hCvHlNOq1OwpXJQazh6CXDbi1ExSa+Lu+aZN/bsgnxAyYv
         YPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8LRQsZ0EshnHPz8PyHyiiiSfpREFwqLez3eu+ixTOk=;
        b=L/JHTzYpVFfISorVXpZG1HIi/Ncr6adfQVkaCqyLi2d0kulOe3hn0ws+cQyVA7izHw
         eEpbLrbDmvxEUMyZNj/CJN4+Cj7No11NH1f98cw6CF4LPeaydaNEViGTpHTNfg3C509i
         ehQ66bXiqpuVrZEaQMb+dfmbdRV2qIdu5A7dgAFVyMitqUuUMprpPPCOHwuh0HdjN1O1
         skmD/8CHT0Ju6/T9jz7qQIb5+0vk2vx8n7GlO6dagPFxrDvMFVvsjF4h2DQWQNUnKIjv
         pVJUiGwqvflSUTLtxBYS4RF3SvZ7umwJWP1+K691GBZnnTN9Drz5gTYHPE9EIgfU6gtB
         OBOg==
X-Gm-Message-State: AOAM532gNmhHwHIxxLEGsxnMUcN4K5WcPqbTKRhBFHY92uZDxd3cdhd8
        uFbV3TG78gdPFiFlaPIszRU=
X-Google-Smtp-Source: ABdhPJxa/7oKxrCxSlC4K0i+9rgoFTFAdUszMFD5pJKTuq/Asc1EHelqQUgekovjbAaoZZrplIK2Zw==
X-Received: by 2002:a05:651c:178e:: with SMTP id bn14mr5655164ljb.521.1633000973003;
        Thu, 30 Sep 2021 04:22:53 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id 8sm306929ljf.39.2021.09.30.04.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 04:22:52 -0700 (PDT)
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
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
Message-ID: <118886b0-43c3-5211-1474-97adf006c1a3@gmail.com>
Date:   Thu, 30 Sep 2021 13:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 12:30, Rafał Miłecki wrote:
> On 30.09.2021 12:17, Russell King (Oracle) wrote:
>> On Thu, Sep 30, 2021 at 11:58:21AM +0200, Rafał Miłecki wrote:
>>> This isn't necessarily a PHY / MDIO regression. It could be some core
>>> change that exposed a PHY / MDIO bug.
>>
>> I think what's going on is that the switch device is somehow being
>> probed by phylib. It looks to me like we don't check that the mdio
>> device being matched in phy_bus_match() is actually a PHY (by
>> checking whether mdiodev->flags & MDIO_DEVICE_FLAG_PHY is true
>> before proceeding with any matching.)
>>
>> We do, however, check the driver side. This looks to me like a problem
>> especially when the mdio bus can contain a mixture of PHY devices and
>> non-PHY devices. However, I would expect this to also be blowing up in
>> the mainline kernel as well - but it doesn't seem to.
>>
>> Maybe Andrew can provide a reason why this doesn't happen - maybe we've
>> just been lucky with out-of-bounds read accesses (to the non-existent
>> phy_device wrapped around the mdio_device?)
> 
> I'll see if I can use buildroot to test unmodified kernel.

I've used buildroot to use unmodified 5.10.57 kernel.


Let me start with explaining that there are 2 b53 drivers.

1. OpenWrt downstream swconfig-based b53 driver
Its b53_mdio.c registers as PHY driver by calling phy_driver_register()

2. Upstream DSA-based b53 driver
Its b53_mdio.c registers as MDIO driver by using mdio_module_driver()


With buildroot + kernel 5.10.57 + upstream DSA-based b53 driver I can't
see phy_probe() called for the /mdio-mux@18003000/mdio@200/switch@0 .
I'm not sure why as I have CONFIG_B53_MDIO_DRIVER=y . Maybe it's some
PHY device vs. MDIO device thing?

I'll proceed with Russell's request for checking MDIO_DEVICE_FLAG_PHY
now.
