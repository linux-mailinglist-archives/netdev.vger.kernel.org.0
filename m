Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4183132F4D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgAGTWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:22:33 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34177 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 14:22:33 -0500
Received: by mail-ed1-f66.google.com with SMTP id l8so570762edw.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 11:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i1b85XP7jYPsUG6P1B/l7q7mdL1Mfe3kQkwElRIQA7g=;
        b=QJsTl/lneKXgGQToCNZLwxPj8ZxSzhZF4swUPAUIrh1f9frs2WIEdP+3nvGtvTeS9c
         t+xpmTLLHO9cc/z1RfkuWWUrxfW9BBp/TZv+yPz2vs7WZCMiYsBo4/jZHu0LZLMdCKKF
         31HxNtJ6enoFTC+B7nvJToYQLxWJuvOgMK8crRvzViylNf5AGkZzOOXR5lDOe++EkN+5
         Ke/SgRL3mvrEU7uOpe+ebMlL8NEsdVX97FouQh6KqOh3j1AMSoSceFzLXo64l8oXYtBd
         j1W9eze4dwWDB+Im1XkCE9T+DM8XP5SLKf2UsSvrF3pVuUhbKDnTAOCSeGYp0l7/1QwV
         pQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=i1b85XP7jYPsUG6P1B/l7q7mdL1Mfe3kQkwElRIQA7g=;
        b=BzvRS0epKi7/Q2hCMX8geiX5rjWhUHSUv8UwsIdhOY/8BFqQ16sJ9kb1p0jE+K5ybU
         VD+WChGcuCgsK4EUjgsMLHec11yHEMpBXqBiMf9ID/jwZjmoElDF5sB0JDAnzQ9srPH2
         zf/YcEXJxjZ600IKPTwI1FJJPTtNsbNYlNm0ajTp03k0jYNPtJnxSwJOM4xlcW2rRhUK
         4yFJ9wkvlw0pFME2+DKN+/r0c+upPC7z+fhl1wBPDsGCafR0jkkRzgVrbWpzqU6sACGp
         qbzeX5weFEfdna2zVxutD5hp/NZlFgWw1TGkU7Meb4hL5zYKajxszlznDceeI0y53QCs
         w20g==
X-Gm-Message-State: APjAAAX1UWDFHTa1vlZJnWHaq3PN56a3HIBV/9z/Xud6GZUYdpVdwJlk
        /p9vuT7eXxGFKyJ9TqINQS4=
X-Google-Smtp-Source: APXvYqyr8nnQdV6ih8WUBeOsmJJwkoY0iYFgelpDxEoHlbxIeUNt8AZjJABxjcifk6j86Q/hJvR/Lg==
X-Received: by 2002:a17:906:f0d6:: with SMTP id dk22mr930362ejb.307.1578424950993;
        Tue, 07 Jan 2020 11:22:30 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m2sm19184edp.85.2020.01.07.11.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 11:22:30 -0800 (PST)
Subject: Re: [PATCH v5 net-next 5/9] enetc: Make MDIO accessors more generic
 and export to include/linux/fsl
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
 <20200106013417.12154-6-olteanv@gmail.com>
 <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com>
 <CA+h21hotFQ9UbxbsQRk2TvTb4H27hfqYK+mX=3urqOoTnaLMDg@mail.gmail.com>
 <86c9b320-bed5-a00b-24aa-494a1d7f91d0@gmail.com>
 <CA+h21hqMtH12W8ZWw9iFdCJFsX2RCv4hO=9nfa0SDKCHar8i9Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <0e884172-4f20-5638-4c58-48d013d82baf@gmail.com>
Date:   Tue, 7 Jan 2020 11:22:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hqMtH12W8ZWw9iFdCJFsX2RCv4hO=9nfa0SDKCHar8i9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 1:46 AM, Vladimir Oltean wrote:
> 
> So we don't typically have the external MDIO controller be part of the
> memory map of an Ethernet port, it has its own region in the SoC. But
> this is not an external MDIO controller, and it's a completely
> separate hardware instance with its own memory region not shared with
> anybody else.

OK, I do not think I managed to express myself correctly, by external
MDIO controller I meant a controller that is used to interface with
off-chip (and sometimes on-chip, too) MDIO devices. That is an on-chip
MDIO controller technically, pardon me for not expressing myself more
clearly here.

> 
> And I think your need for registering the slave MDIO bus in the
> Starfighter 2 switch driver, on top of the same memory region as the
> GENET's MDIO bus, is just to work around the fact that the switch
> pseudo-PHY MDIO address is fixed at 30 on some chips, and you need to
> intercept those transactions by wrapping the mii_bus->read and
> mii_bus->write methods of the master, otherwise none of this would
> have been needed.

You are conflating two things that are not related to the point being
discussed. The SF2 switch used on 7445 and 7278 has some wrapping around
the Roboswitch original IP. The roboswitch has an internal MDIO
controller which is managed through the register space within the
switch. We added a MDIO controller to interface with both our internal
Gigabit PHYs as well as external MDIO devices would such thing exist.
The binding show the MDIO node as part of "switch_top" but not being
part of "core":
Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt.

The same IP used as the MDIO controller (those two 32-bit words with CFG
and CMD) are the same as those that are used on GENET, hence the desire
to re-use the same piece of driver.

> If I understand correctly, couldn't you have just overridden the
> mii_bus->read and mii_bus->write ops of the master MDIO bus, without
> registering another one?

Yes maybe, I do not think this is particularly relevant to this
discussion though.

> 
>>>
>>>> Your commit message does not provide a justification for why this
>>>> abstraction (mii_bus) was not suitable or considered here. Do you think
>>>> that could be changed?
>>>>
>>>
>>> I'm sorry, was the mii_bus abstraction really not considered here?
>>> Based on the stuff exported in this patch, an mii_bus is exactly what
>>> I'm registering in 9/9, no?
>>
>> I meat in the commit message, there is no justification why this was not
>> considered or used, by asking you ended up providing one, that is
>> typically what one would expect to find to explain why something was/was
>> not considered. It's fine, the code is merge, I won't object or require
>> you to use a mii_bus abstraction.
> 
> So I answered your question? If so, it was by mistake, because I still
> don't exactly understand your point (although I would like to).
> The difference is that we don't register a new platform device for the
> mii_bus (we use mii_bus->dev = ocelot->dev), and that it's not in
> drivers/net/phy/mdio-fsl-enetc.c, although it could be, but I don't
> see a clear benefit.

To go back to the original point, I suppose the answer is no: we did not
consider using a mii_bus abstraction and in hindsight, we do not see the
point but it was interesting you brought that up. Case closed from my
side, thank you.
-- 
Florian
