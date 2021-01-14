Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D745B2F5B59
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbhANHbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbhANHbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:31:18 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C29C061786;
        Wed, 13 Jan 2021 23:30:32 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id a6so3633462wmc.2;
        Wed, 13 Jan 2021 23:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cdxwErbbAeIf+2FOu3AWts0mwQKXpMiwnQeXg8yT60A=;
        b=mHk+mT/oUN5j4so5gqyCdCOLVG4FLnjsQtis+vRHXHhgdWniIS5cE7zMDDAGSzMEbt
         fpG55RhVoN2MtxPg+4xeNixe/dzEKnggSGrIb3I7oSshxPHy97VJU4W9Obc+N0pHQlqu
         WbFj3ailiVIxBg4CGVhV95YKSmUFClyV3Tmkropv7I7txKchCxp5oSEtFW+6jOczRVKE
         dPGxUbzOwiDWq+6En4eE9LMf2/q+9fObLE/jKNyPjspKcpAHq7hrJIDVWHQA8Q8QpKpe
         DS7A7IDNxFHapn2yftsIukDzB8BEd7+ulcEqGcl4rvXBmkiE+c9ECXFi8+A+EsiR6Tqv
         BOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdxwErbbAeIf+2FOu3AWts0mwQKXpMiwnQeXg8yT60A=;
        b=KV82aHSS2amwVPSw3L8uWWwaEJvIKSA5W8R8i4izWkgZJgmakmSPstTl3b3fJuAcye
         0JmDrkcVQcJgYsmWbLIzuDXfHvyd+Y28P1rUv5vv985eTb5oZnTXp/NXmeuddGEX0PDs
         6bsIh/5I2Rj++ga+ZQqkRu0fxCl+YQmzVwp5wcpiKIStSogvkRKKlc3aO8qtAx97bpQ3
         YIhcGMadlFvNQhlRepj9Hg9vgFZuNLAfcE0laHod7Bv0ECVnT+MT1jJyFQ9VB7rX6EhK
         Rp3zF3L8zo4owwcHwUHOBf/uKCPjUqIWGtsdTgiR6Ys+hXhtuZxt2qLu9isCLFG3B5e+
         SC8Q==
X-Gm-Message-State: AOAM533VYkEBXT282prLVpT89iKOHE82Nt6E/0f9PaIIO6Q3Jt8qUiB2
        QPXoOzQHPX2+xowzbW4UlVgRy+6m5ZQ=
X-Google-Smtp-Source: ABdhPJx2aOuj/q0jWfFQ9thVui43LNjcY39uqmnYK5gJkU2yMGjlhNVCPgr3lopOlzWrtPSluKVF3w==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr2601654wml.50.1610609430531;
        Wed, 13 Jan 2021 23:30:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:3037:2ac5:86bd:e008? (p200300ea8f06550030372ac586bde008.dip0.t-ipconnect.de. [2003:ea:8f06:5500:3037:2ac5:86bd:e008])
        by smtp.googlemail.com with ESMTPSA id k10sm7280482wrq.38.2021.01.13.23.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 23:30:30 -0800 (PST)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Claudiu.Beznea@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <20210113220107.GN1551@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <8c14937b-1b8c-807c-516c-8dcfb19294f1@gmail.com>
Date:   Thu, 14 Jan 2021 08:30:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210113220107.GN1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.01.2021 23:01, Russell King - ARM Linux admin wrote:
> On Wed, Jan 13, 2021 at 10:34:53PM +0100, Heiner Kallweit wrote:
>> On 13.01.2021 13:36, Claudiu.Beznea@microchip.com wrote:
>>> On 13.01.2021 13:09, Heiner Kallweit wrote:
>>>> On 13.01.2021 10:29, Claudiu.Beznea@microchip.com wrote:
>>>>> It could enter in this mode based on request for standby or suspend-to-mem:
>>>>> echo mem > /sys/power/state
>>>>> echo standby > /sys/power/state
> 
> This is a standard way to enter S2R - I've used it many times in the
> past on platforms that support it.
> 
>> I'm not a Linux PM expert, to me it seems your use case is somewhere in the
>> middle between s2r and hibernation. I *think* the assumption with s2r is
>> that one component shouldn't simply cut the power to another component,
>> and the kernel has no idea about it.
> 
> When entering S2R, power can (and probably will) be cut to all system
> components, certainly all components that do not support wakeup. If
> the system doesn't support WoL, then that will include the ethernet
> PHY.
> 
I'm with you if we talk about a driver's suspend callback cutting power
to the component it controls, or at least putting it to a power-saving
state. However a driver shouldn't have to expect that during S2R somebody
else cuts the power. If this would be the case, then I think we wouldn't
need separate resume and restore pm callbacks in general.

> When resuming, the responsibility is of the kernel and each driver's
> .resume function to ensure that the hardware state is restored. Only
> each device driver that knows the device itself can restore the state
> of that device. In the case of an ethernet PHY, that is phylib and
> its associated PHY driver.
> 
Also in phylib we have separate functions mdio_bus_phy_resume() and
mdio_bus_phy_restore(), with the first one not fully reconfiguring
the PHY.

> One has to be a tad careful with phylib and PHYs compared to their
> MAC devices in terms of the resume order - it has not been unheard
> of over the years for a MAC device to be resumed before its connected
> PHY has been.
> 
Right.
