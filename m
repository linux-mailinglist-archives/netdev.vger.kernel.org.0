Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9A496D8E
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiAVTNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAVTNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:13:32 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AF1C06173B;
        Sat, 22 Jan 2022 11:13:31 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s18so6044016wrv.7;
        Sat, 22 Jan 2022 11:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=IGrbwBAY2PqPYrsLCUhr5A+zN+sKyPj8DP9LEBkON8g=;
        b=YqM0rmRTjqWJ/kJ8P1HxjdmTeq3SVWHSRxN0SOCt6rRjni8p4+ZpveniBPEcAWstea
         K6Azf7RnjPTyW9uyP/DHpMBKM4EOBYhjlaiUfmDnufRn2jm7wCzzphzyr+yHTlq/5yxp
         hNrZH7p/edzAbqQUbpGJNDT9vXZVnoGEjDTnAHoQaXw+kjEdkbZvkzwP5FqcGNDqEWe4
         HgMmhTDVPiCu03De8jX1KG6SUVgHcZVevQwai+qnkBdzq4pHJqXikuwRLNFkuDxcMi90
         o28CDRiU169aWHFQ+GBjJAhxwCoLe+qXnx5BNI0tkY2vdayEUue8r1vhVcRqTQfuIU7F
         2gJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=IGrbwBAY2PqPYrsLCUhr5A+zN+sKyPj8DP9LEBkON8g=;
        b=jBvp+36y0H+Bo9ooytHbwrVrRgPs37Fof6Zl4n0aajXTr0CJmSbbsCOfTjvkjpIxGu
         kBzHZhwC2/kLNiW6bN8E6JAF+pguJanKVRVNZjSUhQmjEVfbTCQKVal0bCFL1rzPH6r6
         m1qoBNotgfRCsr0bCLGLkUE0I5Bk0ufcURgPxPBLnq6IqVnZdVKcBFi12Pisg9ciHTX0
         XtQeGikgyvDj+pe/usApELMTk4q9QGfEV7CVJrJnJAX/mAoApE0oyLgdJDxTWtEskTh+
         YBuWAYMotAeaufo91gfl6AY34HINh/e/y6UJV1HIO4FzVIQC7mdTNaVu54yI6nsq6vKp
         TGTQ==
X-Gm-Message-State: AOAM531n95jpbrFLtVgpD8LNbGuSfdxLOgtvaj24tx3lraeLQwkompZU
        sd+7mO49Bi95b0eKCrZDBl0=
X-Google-Smtp-Source: ABdhPJx6KvurEC1Sff8agfM9QvhFLZ8HsYPnCslEF7aMbZEUW/OHHS4UP0f0pX8Qfy4t3p9JUNUdag==
X-Received: by 2002:a05:6000:180c:: with SMTP id m12mr8206177wrh.581.1642878810200;
        Sat, 22 Jan 2022 11:13:30 -0800 (PST)
Received: from ?IPV6:2003:ea:8f08:c900:8c97:ed5d:c059:d71f? (p200300ea8f08c9008c97ed5dc059d71f.dip0.t-ipconnect.de. [2003:ea:8f08:c900:8c97:ed5d:c059:d71f])
        by smtp.googlemail.com with ESMTPSA id t5sm9534890wrw.92.2022.01.22.11.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 11:13:29 -0800 (PST)
Message-ID: <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
Date:   Sat, 22 Jan 2022 20:13:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux@armlinux.org.uk, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch>
 <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
In-Reply-To: <YerOIXi7afbH/3QJ@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.01.2022 16:15, Andrew Lunn wrote:
>>> They are similar to what DT has, but expressed in an ACPI way. DT has
>>> been used with PHY drivers for a long time, but ACPI is new. The ACPI
>>> standard also says nothing about PHYs. So Linux has defined its own
>>> properties, which we expect all ACPI machine to use. According to the
>>> ACPI maintainers, this is within the ACPI standard. Maybe at some
>>> point somebody will submit the current definitions to the standards
>>> body for approval, or maybe the standard will do something completely
>>> different, but for the moment, this is what we have, and what you
>>> should use.
>>
>> Right, so we can add a new property, document it, and just use it?
> 
> Yes. So long as you follow the scheme documented there, cleanly
> integrate it into the code as needed, you can add a new property.
> 
>> Maybe others will use the new property once we set the precedence?
> 
> Yes, which is why i keep saying you need to think of the general case,
> not your specific machine.
> 
>> How about what Heiner proposed? Maybe we should leave the LED as is,
>> and restore it on system resume?
> 
> I don't think we can change the current code because it will cause
> regressions. The LEDs probably work on some boards because of the
> current code.
> 
One more idea:
The hw reset default for register 16 is 0x101e. If the current value
is different when entering config_init then we could preserve it
because intentionally a specific value has been set.
Only if we find the hw reset default we'd set the values according
to the current code.

> At some point in the future, we hope to be able to control the PHY
> LEDs via /sys/class/LEDs. But until then, telling the PHY driver to
> not touch the LED configuration seems a reasonable request.
> 
>     Andrew
Heiner
