Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3F25699A
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgH2SBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 14:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgH2SBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 14:01:34 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F0C061236
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 11:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sk7dtwSpvIHwa4uSn2oXdJqpGwW9c+RXTcL1LcLzKes=; b=CrY/ZKeasKnORoD/e/5aOxFWaF
        FrAO4AAnh6g0rxB72p7jtWkCaGpqqtDeUrQnKqx3IznjvGYB969kLkNdUz1+do3Z+XW1FPBWXNUCC
        koiiCuOahtTgEL7gSzu29eN/26D0FCNxsTK2b7Wep5kcPSY5/iJARohbGHsV7Cfgx0ey0lxjahDC1
        R7OBcP7zojSCSWG8faV7Ns9lPvIIVe7Yt05g1GyavotZbN8wpEswIMBfatnns4w1X5j1/UQ793H/Q
        hAwZGlwGQpTLkOwLJWU4OvBfNJEkrt4dtMxgr599gI5yG0KRPLjU/k5wpDgVRdMW5cCDKt9hS75Zs
        sH1NNGpA==;
Received: from [205.201.55.51] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kC5AS-009grf-CL; Sat, 29 Aug 2020 20:01:32 +0200
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
 <20200829151553.GB2912863@lunn.ch>
 <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
 <20200829160047.GD2912863@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <79bcab16-5802-c075-1615-06c64078b6c9@arf.net.pl>
Date:   Sat, 29 Aug 2020 20:01:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829160047.GD2912863@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-08-29 o 18:00, Andrew Lunn pisze:
>> This is true assuming that the PHYs are always and forever connected to one
>> specific MDIO bus. This is probably reasonable. Although, in i.MX the MDIO
>> bus of FEC1 and FEC2 shares the pins.
> In general, they do not. In fact, i don't see how that can work. The
> FEC drive provides no mutual exclusion between MDIO operations on
> different MDIO controllers.
> (...)
> You have to decide which gets to control the bus, and the other
> controller is isolated.

Yes, true, but that was not what I meant. In i.MX6ULL MDIO buses of both 
FECs share the same pins, but of course only one can be active. It makes 
no sense to try to use both MDIO buses if the PHYs are connected to the 
same wires. I agree, the current state is good from this point of view.

I meant that with the split description of the mdio node the mdio bus 
for use in the system would be selected almost automatically. Suppose 
that I can do the device tree "my way":
&fec2 {
...
     mdio { phy2 ... };
...
};
&fec1 {
...
     mdio { phy1 ... };
...
};
This emphasizes which PHY is intended for use by which FEC, that's why 
it looks more natural for me.
Here, at least the FEC driver will automatically use MDIO bus from FEC2 
for all the PHYs.

Now suppose that I want to have a cheaper version, with only one 
Ethernet interface on board:
//&fec2 {
//...
//    mdio { phy2 ... };
//...
//};
&fec1 {
...
     mdio { phy1 ... };
...
};
Now, the system will use MDIO bus from FEC1.

This is just less playing with the device tree. But I agree, that you 
don't do that frequently, so that doesn't save much effort.
And, what this example doesn't show, is that the pin assignment has to 
be modfied - mdio pins have to get to fec1 now.

This way of building the device tree results from my proposition, but it 
was not my motivation.

Maybe it would be more useful if the device tree would be preprocessed 
and then compiled based on some conditions:

#if defined(CONFIG_USE_FEC2)
&fec2 {
...
     mdio { phy2 ... };
...
};
#endif
#if defined(CONFIG_USE_FEC1)
&fec1 {
...
     mdio { phy1 ... };
...
};
#endif

Best regards,
Adam

