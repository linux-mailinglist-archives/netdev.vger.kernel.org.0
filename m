Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D335585
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFEDGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:06:18 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44066 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:06:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id c5so9135955pll.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lq2KPsVn1G7UxmlsfbrYCu46ovz+1h2pOB6kOlKT0Hs=;
        b=ojLi9FQwJRBqZr3aT0NViEMdpjFGgS6+iOVZtHYUwvVaufmxu9mAZIri1x6tEyqd6x
         mRubrvL4LfC/qFMZ4vi90DdxPQXGn+MKoPu1VTfBqwGWTusKj0DlKVD90k4Osd3MNCzq
         c5FWnTNP3fgM0YE8EuvGgN7S7RUXGWzefXvkKczkabnGCcQDS8/R8d6XVEk5VPwniqDF
         WgzD4wIkSV+wXm5HcWXf6mkfMipBsV6rYIvhiKqNT56ck9t720+59WSbByiDBy1oSm+k
         R8bVcxaEorVCKdIT3y9pNAaHEva5fpIzbI5aS+Adgpmm6UNBWEk+fKC3UEtIbG5DALQE
         /tGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lq2KPsVn1G7UxmlsfbrYCu46ovz+1h2pOB6kOlKT0Hs=;
        b=JDWPILw5Mo1KYEVIUIbmZfz/+EjjxPMphaP+WnMAlrJ4EjzYQsMTiNwa802MVVClpj
         RxPy8P5BCpRlP1cd2GTq4vjYsVQEsZgtu1pOe7Xp6Kl6BDREyXsSY8wqa1Pdf9jgXc7a
         ttussdNGMj7RKT8QcMAnnYsEwmXFkjzY36iQ7yCo8VZ8A/ipO3YVo/zHvQH4I8AmphH8
         b6d3m1ZQonoQbw5yV5u8aoAmSr1oJ4Sflk1WCqMJIaEVgl/Cj9RX3fngGdu5NDd6smX5
         BpZseYKxHGSNhsebpzjkQdjYAlODBvUAqldTq3Sk91CCjdMw95Ox0A3/vtuu9HlD4MPm
         0bAQ==
X-Gm-Message-State: APjAAAVoPGgHWQceVdfnHF4VKvhrJRzzbWJ6YiXQySMf6eAxMdhZAs9P
        Kl85zf2FDk40WO81vcLtk9c=
X-Google-Smtp-Source: APXvYqwzWOF5eDM4WO6Woag4gve/QSe6Qr6Ru7fC1bIRv3OkSYykYFvaTfADq0JEi8e5msm9wV08+g==
X-Received: by 2002:a17:902:9b85:: with SMTP id y5mr39759538plp.313.1559703976834;
        Tue, 04 Jun 2019 20:06:16 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id d9sm16378018pgl.20.2019.06.04.20.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 20:06:16 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
 <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
 <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <262dfc0e-c248-23e7-cd34-d13e104afe91@gmail.com>
Date:   Tue, 4 Jun 2019 20:06:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 4:46 PM, Vladimir Oltean wrote:
> On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
>>
>> On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
>>> On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
>>> <linux@armlinux.org.uk> wrote:
>>>>
>>>> On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
>>>>> You caught me.
>>>>>
>>>>> But even ignoring the NIC case, isn't the PHY state machine
>>>>> inconsistent with itself? It is ok with callink phy_suspend upon
>>>>> ndo_stop, but it won't call phy_suspend after phy_connect, when the
>>>>> netdev is implicitly stopped?
>>>>
>>>> The PHY state machine isn't inconsistent with itself, but it does
>>>> have strange behaviour.
>>>>
>>>> When the PHY is attached, the PHY is resumed and the state machine
>>>> is in PHY_READY state.  If it goes through a start/stop cycle, the
>>>> state machine transitions to PHY_HALTED and attempts to place the
>>>> PHY into a low power state.  So the PHY state is consistent with
>>>> the state machine state (we don't end up in the same state but with
>>>> the PHY in a different state.)
>>>>
>>>> What we do have is a difference between the PHY state (and state
>>>> machine state) between the boot scenario, and the interface up/down
>>>> scenario, the latter behaviour having been introduced by a commit
>>>> back in 2013:
>>>>
>>>>     net: phy: suspend phydev when going to HALTED
>>>>
>>>>     When phydev is going to HALTED state, we can try to suspend it to
>>>>     safe more power. phy_suspend helper will check if PHY can be suspended,
>>>>     so just call it when entering HALTED state.
>>>>
>>>> --
>>>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>>>> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
>>>> According to speedtest.net: 11.9Mbps down 500kbps up
>>>
>>> I am really not into the PHYLIB internals, but basically what you're
>>> telling me is that running "ip link set dev eth0 down" is a
>>> stronger/more imperative condition than not running "ip link set dev
>>> eth0 up"... Does it also suspend the PHY if I put the interface down
>>> while it was already down?
>>
>> No - but that has nothing to do with phylib internals, more to do with
>> the higher levels of networking.  ndo_stop() will not be called unless
>> ndo_open() has already been called.  In other words, setting an already
>> down device down via "ip link set dev eth0 down" is a no-op.
>>
>> So, let's a common scenario.  You power up a board.  The PHY comes up
>> and establishes a link.  The boot loader runs, loads the kernel, which
> 
> This may or may not be the case. As you pointed out a few emails back,
> this is a system-level issue that requires a system-level solution -
> so cutting the link in U-boot is not out of the question.
> 
>> then boots.  Your network driver is a module, and hasn't been loaded
>> yet.  The link is still up.
>>
>> The modular network driver gets loaded, and initialises.  Userspace
>> does not bring the network device up, and the network driver does not
>> attach or connect to the PHY (which is actually quite common).  So,
>> the link is still up.
>>
>> The modular PHY driver gets loaded, and binds to the PHY.  The link
>> is still up.
> 
> I would rather say, 'even if the link is not up, Linux brings it up
> (possibly prematurely) via phy_resume'.
> But let's consider the case where the link *was* up. The general idea
> is 'implement your workarounds in whatever other way, that link is
> welcome!'.

With the systems that I work with, we have enforced the following
behavior to happen: the boot loader and kernel only turn on what they
needs, at the time they need it, and nothing more, once done, they put
the blocks back into lowest power mode (clock and power gated if
available). So yes, there are multiple link re-negotiations throughput
the boot process, but when there is no device bound to a driver the
system conserves power by default which is deemed a higher goal than
speed. Your mileage may vary of course.

There is not exactly a simple way of enforcing that kind (or another
kind for that matter) of policy kernel wide, so it's unfortunately up to
the driver writer to propose something that is deemed sensible.

We could however, extend existing tools like iproute2 to offer the
ability to control whether the PHY should be completely powered off, in
a low power state allowing WoL, or remain UP when the network device is
brought down. That would not cover the case that Russell explained, but
it would be another monkey wrench you can throw at the system.
-- 
Florian
