Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF609202CED
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 23:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgFUVR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 17:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgFUVR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 17:17:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCBCC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 14:17:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c4so3855974iot.4
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 14:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4S2v8b/u9tVsl1QDg+4r8Ybq9bRaX8v8wtaa3gyP2mQ=;
        b=gdJ6qoCLPFZs8v7ZGEL8zyEu2oXij9tJIFYHbjwxdPmMzvMBwTlb7wK0NiVTQyUG0y
         47Wy7s72xt8q9kWEe8xBDb0EVSn+gV+24ZauOO9b9Hr3VfYaVG+XlMWiRS9qgmZViy1U
         YG/i5d9iJhgScVkFptOHHXkVjjZkJHO8SWYk7sof2Z7xS3TFG6IuakKU7cSasbtKYlfd
         VFX6f3/qQdpya5tF1imUA2OI7zKkO7re8ZIeacT8y6oMqN1Pel/G2D0jV5r/SWR12i52
         UEPzB6bpIo573/3IA23uUpsx1m6oEE7Gall3nlyqBdnklUzNmasLmSvwH5ydjhydWSqN
         VADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4S2v8b/u9tVsl1QDg+4r8Ybq9bRaX8v8wtaa3gyP2mQ=;
        b=q7E6mFn+wokXxWgdmLVhcO4rKvOyEFycJlOkMGOKeQUFk9DNiI/MQffQ8zOyg0xoVK
         HmFfcAkeUNxLrTYoOE+4Rc9PkVKHjVePnBFryOaH/qXPBlP93lqRARpF1EcUNkuvXMah
         9KKfFsLh1y0iTkftTE/MokUufS/5B0grjXV9E664awzwvE0fLduMQN2LqM3QeiJ3ExMy
         T5FD+/dbRS7RLPodADiatzdByO6BvNgzR8dzfz3LtpN78TzTnSy0Yqm1KYzZCMea/PJh
         6bXMINHkTNr1fssU5GZwV79GQiGGYcXysvyyoIAbPAWMAPU2fi4SpQOw24QZUbdgs4WK
         84hw==
X-Gm-Message-State: AOAM532StRXSvuSkZTFVrPviawFzmSOdF7dMgcQUHoSz71bpE/aK7iWK
        XbVrUX5+Dgwh+VlPtiNJWBk=
X-Google-Smtp-Source: ABdhPJwiZit+PC/QzEVIWZhckFLg0/KxO7uCnB9ceMjif3ZZUs7vzhsnhYetnyKi63sCzJ0rdWpZBw==
X-Received: by 2002:a02:93ea:: with SMTP id z97mr10891996jah.40.1592774247793;
        Sun, 21 Jun 2020 14:17:27 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.googlemail.com with ESMTPSA id p5sm6807817ilg.88.2020.06.21.14.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 14:17:26 -0700 (PDT)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Felix Fietkau <nbd@openwrt.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <20200621143340.GI1605@shell.armlinux.org.uk>
 <CA+h21ho2Papr2gXqap2LGE3N4LJAbor2WxzX1quDckVvw-mQ5Q@mail.gmail.com>
 <20200621200231.GX1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Subject: Re: [CFT 0/8] rework phylink interface for split MAC/PCS support
Message-ID: <41ed8e2a-5c8e-7dce-42db-8c088be9528c@gmail.com>
Date:   Sun, 21 Jun 2020 14:17:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200621200231.GX1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 2020-06-21 à 13:02, Russell King - ARM Linux admin a écrit :
> On Sun, Jun 21, 2020 at 10:37:43PM +0300, Vladimir Oltean wrote:
>> Hi Russell,
>>
>> On Sun, 21 Jun 2020 at 17:34, Russell King - ARM Linux admin
>> <linux@armlinux.org.uk> wrote:
>>>
>>> All,
>>>
>>> This is now almost four months old, but I see that I didn't copy the
>>> message to everyone who should've been, especially for the five
>>> remaining drivers.
>>>
>>> I had asked for input from maintainers to help me convert their
>>> phylink-using drivers to the new style where mac_link_up() performs
>>> the speed, duplex and pause setup rather than mac_config(). So far,
>>> I have had very little assistance with this, and it is now standing
>>> in the way of further changes to phylink, particularly with proper
>>> PCS support. You are effectively blocking this work; I can't break
>>> your code as that will cause a kernel regression.
>>>
>>> This is one of the reasons why there were not many phylink patches
>>> merged for the last merge window.
>>>
>>> The following drivers in current net-next remain unconverted:
>>>
>>> drivers/net/ethernet/mediatek/mtk_eth_soc.c
>>> drivers/net/dsa/ocelot/felix.c
>>> drivers/net/dsa/qca/ar9331.c
>>> drivers/net/dsa/bcm_sf2.c
>>> drivers/net/dsa/b53/b53_common.c
>>>
>>> These can be easily identified by grepping for conditionals where the
>>> expression matches the "MLO_PAUSE_.X" regexp.
>>>
>>> I have an untested patch that I will be sending out today for
>>> mtk_eth_soc.c, but the four DSA ones definitely require their authors
>>> or maintainers to either make the changes, or assist with that since
>>> their code is not straight forward.
>>>
>>> Essentially, if you are listed in this email's To: header, then you
>>> are listed as a maintainer for one of the affected drivers, and I am
>>> requesting assistance from you for this task please.
>>>
>>> Thanks.
>>>
>>> Russell.
>>>
>>
>> If forcing MAC speed is to be moved in mac_link_up(), and if (as you
>> requested in the mdio-lynx-pcs thread) configuring the PCS is to be
>> moved in pcs_link_up() and pcs_config() respectively, then what
>> remains to be done in mac_config()?
> 
> Hopefully very little, but I suspect there will still be a need for
> some kind of interface to configure the MAC interface type at the MAC.
> 
> Note that I have said many many many times that using state->{speed,
> duplex,pause} in mac_config() when in in-band mode is unreliable, yet
> still people insist on using them.  There _are_ and always _have been_
> paths in phylink where these members will be passed with an unresolved
> state, and they will corrupt the link settings when that happens.
> 
> I know that phylink was deficient in its handling of a split PCS, but
> I have worked to correct that.  That job still is not complete, because
> because I'm held up by these drivers that have not yet converted.  I've
> already waited a kernel cycle, despite having the next series of
> phylink patches ready and waiting since early February.
> 
> I'm getting to the point of wishing that phylink did not have users
> except my own.

You have to realize that most people are not capable of working at your
pace either because they just do not have your intellect or because
their day job is not supporting a switch driver 100% of the time. The
other thing to realize is that PHYLINK has seen a fair amount of churn
since its introduction which makes it really hard to follow what is
needed, what was bogus, what ended up working when it should not etc.
You have clearly worked on improving both code and documentation, there
is however inertia for people to catch up.

So please stop with this attitude, just send the patches if it breaks it
will take many cycles for people to realize it and that is on them, not
you, they do not get to complain at all and should have been more
reactive since you warned them.

Thank you
-- 
Florian
