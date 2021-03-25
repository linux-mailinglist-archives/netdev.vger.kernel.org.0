Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C150349AFF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCYU3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCYU3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 16:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8713619EE;
        Thu, 25 Mar 2021 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616704150;
        bh=8Z3wPneQx1nb8eF9jL8XdhlaNnh+ArmECjF15PWkgfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISvAfzP/AYdLr0rNzMc101QiC13aBQlC+zjZUAl6obSr+zPk+OMWZ8Dso3p9iSq1K
         1XjHechE4gXVnoYrvdOZ1xgU3M/DVyNZuBAU7wLlaM6QkEjw5w64W3A6v0o08U6OfW
         Bs7p1jMIK82wkiNMnXSXVKdK532IE+tLJylyLArpuAGH1NyA2MjJMCnf+gI/HbkXDi
         szEKm0f9iE20SW3Xn14uliUHq6+gcPIIcgRlUOesFXC1CBDfSl7peJgwqgc/Ht1Gri
         bfDT9ds5UVlY/QKCCcLxVNC70XMMFWM5nMdC5Q0rKScor7G3ZzgB3QTU62sNllrxbG
         vEpmYgFL8GSrg==
Date:   Thu, 25 Mar 2021 21:29:05 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact
 model
Message-ID: <20210325212905.3d8f8b39@thinkpad>
In-Reply-To: <20210325155452.GO1463@shell.armlinux.org.uk>
References: <20210325131250.15901-1-kabel@kernel.org>
        <20210325131250.15901-12-kabel@kernel.org>
        <20210325155452.GO1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 15:54:52 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
> In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
> 0x09a8..0x09af. We could add a separate driver structure, which would
> then allow the kernel to print a more specific string via standard
> methods, like we do for other PHYs. Not sure whether that would work
> for the 88X21x0 family though.

According to release notes it seems that we can also differentiate
88E211X from 88E218X (via bit 3 in register 1.3):
 88E211X has 0x09B9
 88E218X has 0x09B1

but not 88E2110 from 88E2111
    nor 88E2180 from 88E2181.

These can be differentiated via register
  3.0004.7
(bit 7 of MDIO_MMD_PCS.MDIO_SPEED., which says whether device is capable
 of 5g speed)

I propose creating separate structures for mv88x3340 and mv88e218x.
We can then print the remaining info as
  "(not) macsec/ptp capable"
or
  "(not) 5g capable"

What do you think?

Marek
