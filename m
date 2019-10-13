Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9CD5842
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 23:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbfJMVOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 17:14:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfJMVOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 17:14:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B0E14A8C121;
        Sun, 13 Oct 2019 14:14:53 -0700 (PDT)
Date:   Sun, 13 Oct 2019 14:14:50 -0700 (PDT)
Message-Id: <20191013.141450.1430066442611592842.davem@davemloft.net>
To:     marex@denx.de
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, george.mccollister@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH V3 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795
 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <174ba346-b87d-d928-5ef2-59287d5280be@denx.de>
References: <20191013193403.1921-1-marex@denx.de>
        <61012315-cbe0-c738-2e8d-0080ec382af9@gmail.com>
        <174ba346-b87d-d928-5ef2-59287d5280be@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 14:14:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 13 Oct 2019 22:29:31 +0200

> On 10/13/19 10:15 PM, Heiner Kallweit wrote:
>> On 13.10.2019 21:34, Marek Vasut wrote:
>>> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
>>> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
>>> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
>>> is wrong, since the KSZ8051 configures registers of the PHY which are
>>> not present on the simplified KSZ87xx switch PHYs and misconfigures
>>> other registers of the KSZ87xx switch PHYs.
>>>
>>> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
>>> KSZ87xx switch by checking the Basic Status register Bit 0, which is
>>> read-only and indicates presence of the Extended Capability Registers.
>>> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
>>>
>>> This patch implements simple check for the presence of this bit for
>>> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
>>> PHY driver instance.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: George McCollister <george.mccollister@gmail.com>
>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>>> Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
>>> Cc: Tristram Ha <Tristram.Ha@microchip.com>
>>> Cc: Woojung Huh <woojung.huh@microchip.com>
>>> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
>> 
>> The Fixes tag has to be the first one. And patch still misses
>> the "net" annotation. For an example just see other fix submissions
>> on the mailing list.
> 
> The "net" annotation ? The net: tag is right there in the subject.

It also belongs in the [ PATCH ...] area as an indicator of the target
GIT tree.
