Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820B92B9733
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgKSP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:57:40 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:34746 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgKSP5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:57:40 -0500
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id A7FD53B1EB3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:46:10 +0000 (UTC)
X-Originating-IP: 90.55.104.168
Received: from bootlin.com (atoulouse-258-1-33-168.w90-55.abo.wanadoo.fr [90.55.104.168])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6F969E000D;
        Thu, 19 Nov 2020 15:45:45 +0000 (UTC)
Date:   Thu, 19 Nov 2020 16:45:44 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201119164544.69b87307@bootlin.com>
In-Reply-To: <20201119151641.GJ1853236@lunn.ch>
References: <20201119152246.085514e1@bootlin.com>
        <20201119151641.GJ1853236@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 19 Nov 2020 16:16:41 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

>Hi Maxime
>
>> The way this works is that the PHY is internally configured by chaining
>> 2 internal PHYs back to back. One PHY deals with the Host interface and
>> is configured as an SGMII to QSGMII converter (the QSGMII is only used
>> from within the PHY), and the other PHY acts as the Media-side PHY,
>> configured in QSGMII to auto-media (RJ45 or Fiber (SFP)) :
>> 
>>                 +- 88e1543 -----------------------+
>> +-----+         | +--------+          +--------+  |  /-- Copper (RJ45)
>> |     |--SGMII----| Port 0 |--QSGMII--| Port 1 |----<
>> |     |         | +--------+          +--------+  |  \--- Fiber
>> | MAC |         |                                 |
>> |     |         | +--------+          +--------+  |  /-- Copper (RJ45)
>> |     |--SGMII----| Port 2 |--QSGMII--| Port 3 |----<
>> +-----+         | +--------+          +--------+  |  \-- Fiber
>>                 +---------------------------------+  
>
>Does this mean you need a dual port MAC as well?
>
>Do we need to configure the MUX in the MAC?

No, it's my schematic that is misleading in that case :) The 2
ports are independent of each other. There isn't any configuration on
the MAC part for that setup.

Thanks,

Maxime



-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
