Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D30B3185AF
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBKHcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBKHbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:31:53 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1CDC061574;
        Wed, 10 Feb 2021 23:31:13 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id w4so4240425wmi.4;
        Wed, 10 Feb 2021 23:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XtbI9v4khyRs8JwVyZgW9h25eiZw429zMUcaRL61TSQ=;
        b=kWFx8ssYRVCx+En/7zNWSC44dqkIVpkDf2fCxIBTwnyr/1SJ18onTW2PqRcAcl6L3q
         IG/4FwvZXrl1GJWkBWSZnfxcGbTNKl64gbcXUJ42tAmjPuNtK8K4sM1nI+uuFyzXQNm4
         T1MhabGCxN/NJs0DkOQQGSSSwJgOTSVzudw3JkPQV7ak8P6AvJ5nCJLIgVJ8XCV8x3Za
         GZm67qgCidrpRXP97jAOxqo//322wykj+D+CgBwvr8Gw/475bD8wnuk+ljGEb63rASxO
         01rEyM+HfgI8TjGcP/tvZ+N/EwPKIuHro26DKlUMj85F9m2INkvrqIwBtijh6QQD0fGY
         GY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XtbI9v4khyRs8JwVyZgW9h25eiZw429zMUcaRL61TSQ=;
        b=h4WPz7eSmUzRYq+WxhTOyJZN/hSXzVshi0Rb5pDYqkSDB24yJO/Ra8gPJBEYYUI2ef
         paSMEmQTWkLAYNhBn56/xCQNe+NtMTCRXRt3QXbpXFSy2cwrPJpaIED/1vigRwQPo9UZ
         aQiJJSosmbkB/Qb9pwRyuv4uYrnL73+qrepzX3EEYPD8P+Qx2txitw2uTne6yKD8+rQV
         VC8D423HatwZhBhbs8e7OK44R7YSySE7DYvXp0Ylbeu4xjShEWc/ZwtNino6SmtsWAw9
         a0RjPVVk4qbD4qTpCV29cvp77F9EXWJnnvU+oiEfMKCEOAG+FKjkgA/IxvsDNuwrjCqp
         bf4A==
X-Gm-Message-State: AOAM532L1dtGE4UjuC1ZgaZdjl6u/3kQgfYF23ByRqEkDb+X9F1qiOiU
        KgMu4YspZRbavpBP2jZeT28=
X-Google-Smtp-Source: ABdhPJzCfqNKRB+oQof/x/mPTQCgw3Y+8dbzGaVRG8OJj4g4HEIR4zeb3RY4zeVuc7z8fU5aMhjhyQ==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr3489965wmc.103.1613028671728;
        Wed, 10 Feb 2021 23:31:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:60ca:853:df03:450e? (p200300ea8f1fad0060ca0853df03450e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:60ca:853:df03:450e])
        by smtp.googlemail.com with ESMTPSA id z185sm9076648wmb.0.2021.02.10.23.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 23:31:11 -0800 (PST)
To:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRjmpKjK0pxKTCP@lunn.ch>
 <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <4f0086ad-1258-063d-0ace-fe4c6c114991@gmail.com>
Date:   Thu, 11 Feb 2021 08:31:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAGETcx-tBw_=VPvQVYcpPJBJjgQvp8UASrdMdSbSduahZpJf9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2021 00:29, Saravana Kannan wrote:
> On Wed, Feb 10, 2021 at 2:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
>>> Hi,
>>>
>>> This email was triggered by this other email[1].
>>>
>>> Why is phy_attach_direct() directly calling device_bind_driver()
>>> instead of using bus_probe_device()?
>>
>> Hi Saravana
>>
>> So this is to do with the generic PHY, which is a special case.
>>
>> First the normal case. The MDIO bus driver registers an MDIO bus using
>> mdiobus_register(). This will enumerate the bus, finding PHYs on
>> it. Each PHY device is registered with the device core, using the
>> usual device_add(). The core will go through the registered PHY
>> drivers and see if one can drive this hardware, based on the ID
>> registers the PHY has at address 2 and 3. If a match is found, the
>> driver probes the device, all in the usual way.
>>
>> Sometime later, the MAC driver wants to make use of the PHY
>> device. This is often in the open() call of the MAC driver, when the
>> interface is configured up. The MAC driver asks phylib to associate a
>> PHY devices to the MAC device. In the normal case, the PHY has been
>> probed, and everything is good to go.
>>
>> However, sometimes, there is no driver for the PHY. There is no driver
>> for that hardware. Or the driver has not been built, or it is not on
>> the disk, etc. So the device core has not been able to probe
>> it. However, IEEE 802.3 clause 22 defines a minimum set of registers a
>> PHY should support. And most PHY devices have this minimum. So there
>> is a fall back driver, the generic PHY driver. It assumes the minimum
>> registers are available, and does its best to drive the hardware. It
>> often works, but not always. So if the MAC asks phylib to connect to a
>> PHY which does not have a driver, we forcefully bind the generic
>> driver to the device, and hope for the best.
> 
> Thanks for the detailed answer Andrew! I think it gives me enough
> info/context to come up with a proper fix.
> 
>> We don't actually recommend using the generic driver. Use the specific
>> driver for the hardware. But the generic driver can at least get you
>> going, allow you to scp the correct driver onto the system, etc.
> 
> I'm not sure if I can control what driver they use. If I can fix this
> warning, I'll probably try to do that.
> 
The genphy driver is a last resort, at least they lose functionality like
downshift detection and control. Therefore they should go with the
dedicated Marvell PHY driver.

But right, this avoids the warning, but the underlying issue (probably
in device_bind_driver()) still exists. Would be good if you can fix it.

> -Saravana
> 

Heiner
