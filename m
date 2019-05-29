Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E572E961
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE2X3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:29:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfE2X3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 19:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DqShxMQEhEyHMa5nJ06AIiSuoDkR06vXPgvqd1K07ZQ=; b=0f26D+GPzttJBNim7aCAxOy0rN
        zDAcOMnmZQJDAt13uQoVT4Fj3RuUR8PG2MJovUJoEywQbfKX3Bt9CAm8CZjjpw8dz/uaqmKZUeJBk
        PJ7yhNkT0RqXugv7FoWqtyPSMQQ6t6HsUxwR/r2va9pq6EIbcKFGyneM9s4hTcnOgPJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hW80g-0003II-9l; Thu, 30 May 2019 01:29:30 +0200
Date:   Thu, 30 May 2019 01:29:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
Message-ID: <20190529232930.GF18059@lunn.ch>
References: <20190528192324.28862-1-marex@denx.de>
 <96793717-a55c-7844-f7c0-cc357c774a19@gmail.com>
 <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
 <cc8db234-4534-674d-eece-5a797a530cdf@gmail.com>
 <ca63964a-242c-bb46-bd4e-76a270dbedb3@denx.de>
 <20190528195806.GV18059@lunn.ch>
 <15906cc0-3d8f-7810-27ed-d64bdbcfa7e7@denx.de>
 <20190528212252.GW18059@lunn.ch>
 <fe6c4f2f-812d-61b8-3ffb-7ed7dd89d151@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6c4f2f-812d-61b8-3ffb-7ed7dd89d151@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:33:33PM +0200, Marek Vasut wrote:
> On 5/28/19 11:22 PM, Andrew Lunn wrote:
> >> The link detection on the TJA1100 (not TJA1101) seems unstable at best,
> >> so I better use all the interrupt sources to nudge the PHY subsystem and
> >> have it check the link change.
> > 
> > Then it sounds like you should just ignore interrupts and stay will
> > polling for the TJA1100.
> 
> Polling for the link status change is slow(er) than the IRQ driven
> operation, so I would much rather use the interrupts.

I agree about the speed, but it seems like interrupts on this PHY are
not so reliable. Polling always works. But unfortunately, you cannot
have both interrupts and polling to fix up problems when interrupts
fail. Your call, do you think interrupts really do work?

If you say that tja1101 works as expected, then please just use the
link up/down bits for it.

     Andrew
