Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7992AD5818
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfJMU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:29:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58272 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:29:35 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46rtb104R5z1rGRh;
        Sun, 13 Oct 2019 22:29:33 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46rtb06LqKz1qqkC;
        Sun, 13 Oct 2019 22:29:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ULJiYB0RK7Ol; Sun, 13 Oct 2019 22:29:31 +0200 (CEST)
X-Auth-Info: nUlUfl0uyWy43jjVkJK3ln1Q7Oc2N9EsmK8Y9Av9XJ4=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Oct 2019 22:29:31 +0200 (CEST)
Subject: Re: [PATCH V3 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191013193403.1921-1-marex@denx.de>
 <61012315-cbe0-c738-2e8d-0080ec382af9@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <174ba346-b87d-d928-5ef2-59287d5280be@denx.de>
Date:   Sun, 13 Oct 2019 22:29:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <61012315-cbe0-c738-2e8d-0080ec382af9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/19 10:15 PM, Heiner Kallweit wrote:
> On 13.10.2019 21:34, Marek Vasut wrote:
>> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
>> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
>> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
>> is wrong, since the KSZ8051 configures registers of the PHY which are
>> not present on the simplified KSZ87xx switch PHYs and misconfigures
>> other registers of the KSZ87xx switch PHYs.
>>
>> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
>> KSZ87xx switch by checking the Basic Status register Bit 0, which is
>> read-only and indicates presence of the Extended Capability Registers.
>> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
>>
>> This patch implements simple check for the presence of this bit for
>> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
>> PHY driver instance.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: George McCollister <george.mccollister@gmail.com>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
>> Cc: Tristram Ha <Tristram.Ha@microchip.com>
>> Cc: Woojung Huh <woojung.huh@microchip.com>
>> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
> 
> The Fixes tag has to be the first one. And patch still misses
> the "net" annotation. For an example just see other fix submissions
> on the mailing list.

The "net" annotation ? The net: tag is right there in the subject.
