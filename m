Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD7325CC84
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgICVn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgICVn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:43:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E809EC061244;
        Thu,  3 Sep 2020 14:43:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 67so3147951pgd.12;
        Thu, 03 Sep 2020 14:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V92xY93ay3p0tLda42GkDjEmnhwDliz8N8pgqvhF7+s=;
        b=PHLvIm5hbFhCvXRs5BO3wMJXfUzjPaYHinZGP2t4oDLxmZLr5d0uc1cfjQ3F5Nlsjz
         ikcNbeLx2DiM4+gUit9sJJVAzRBlHSRjLXxJlH4+fi16aruapsRZmi6sL8KmzXXcELCw
         1Z5nMKuxOAd7S6wxYiZzfh6ABVQwxK7dUqlLrwoZbl8l2sgtSKfk8jYiW0nAwhJKt4+B
         mw+vJA9xOY4vYmpPMP6qwLrm4vXuQi0fmkkc4jduayiicGEqFD6ux12XeQM/djWWe2MA
         VwMQ6/vYBuU7lJjuCfT61+5gKh7D93JGzD1Ja0SmAVaXnwfeLUydp7AAeLsLSwIe+qBH
         GRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V92xY93ay3p0tLda42GkDjEmnhwDliz8N8pgqvhF7+s=;
        b=aY06q2fHgIaq4AbFHtuhUBzBsT5xwa4oOihiGlq5jBpBdB0nKh0lkyU8jetlSV5nBV
         KkiWA3yQ1Wv0VhVO0AXBoc6URBt821wM5iAp2Broj2Ut7T2KS7MD2+HbnwMwSl9bE9y5
         Xhi9PmbMlqYW7BQ9OWyN8fX5cGmOKmfwI6rdwUZYwDVOqU8obVmBlZ2qyWdISWtmrTJV
         csBUULNBT4iT8vRIEgT/2Y1uGcW/c0JZzyyI+1QpQNIouShfQnoWBGfImdQaOp761dcV
         /4Unc3NkUl2EuspU+D6TxwGaKR4tydazoxiUbGFvoM6DP27DwL3WYw9qbOihB7Nah+fg
         s/EA==
X-Gm-Message-State: AOAM531K+s6yv6oyOnerFHpD6JHSea07Aq/23LlvExp/xHfSN1Vaosxa
        akQTanAsIpA0ZmIjyWxDEaoVM4Gy+eU=
X-Google-Smtp-Source: ABdhPJz56lxf/BZ3Hci/rmQB2r24HK425lMwQc6QHK0uz12aCTLgCj9IZpjeNmfZrETxtAesujlZPw==
X-Received: by 2002:a62:4dc1:: with SMTP id a184mr5773414pfb.203.1599169437285;
        Thu, 03 Sep 2020 14:43:57 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r144sm4608323pfc.63.2020.09.03.14.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 14:43:56 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: Support enabling clocks prior to
 bus probe
To:     Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        adam.rudzinski@arf.net.pl, Marco Felsch <m.felsch@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        devicetree@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-2-f.fainelli@gmail.com>
 <CAL_JsqL=XLJo9nrX+AMs41QvA3qpW6zoyB8qNwRx3V-+U-+uLg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <81972e9c-c664-08b4-a9f2-636df3cd801d@gmail.com>
Date:   Thu, 3 Sep 2020 14:43:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <CAL_JsqL=XLJo9nrX+AMs41QvA3qpW6zoyB8qNwRx3V-+U-+uLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 2:28 PM, Rob Herring wrote:
> On Wed, Sep 2, 2020 at 10:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> Some Ethernet PHYs may require that their clock, which typically drives
>> their logic to respond to reads on the MDIO bus be enabled before
>> issusing a MDIO bus scan.
>>
>> We have a chicken and egg problem though which is that we cannot enable
>> a given Ethernet PHY's device clock until we have a phy_device instance
>> create and called the driver's probe function. This will not happen
>> unless we are successful in probing the PHY device, which requires its
>> clock(s) to be turned on.
>>
>> For DT based systems we can solve this by using of_clk_get() which
>> operates on a device_node reference, and make sure that all clocks
>> associaed with the node are enabled prior to doing any reads towards the
>> device. In order to avoid drivers having to know the a priori reference
>> count of the resources, we drop them back to 0 right before calling
>> ->probe() which is then supposed to manage the resources normally.
> 
> What if a device requires clocks enabled in a certain order or timing?
> It's not just clocks, you could have some GPIOs or a regulator that
> need enabling first. It's device specific, so really needs a per
> device solution. This is not just an issue with MDIO. I think we
> really need some sort of pre-probe hook in the driver model in order
> to do any non-discoverable init for discoverable buses. Or perhaps
> forcing probe when there are devices defined in DT if they're not
> discovered by normal means.

I like the pre-probe hook idea, and there are other devices that I have 
access to that would benefit from that, like PCIe end-points that 
require regulators to be turned on in order for them to be discoverable.

For MDIO we might actually be able to create the backing device 
reference without having read the device ID yet, provided that we know 
its address on the bus, which DT can tell us.

Bartosz attempted to do that not so long ago and we sort of stalled 
there, too:

https://lkml.org/lkml/2020/6/22/253

Let me see if I can just add a pre-probe hook, make use of it in the 
MDIO layer, and we see how we can apply it to other subsystems?
-- 
Florian
