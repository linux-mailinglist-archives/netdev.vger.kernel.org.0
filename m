Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF6A80BA8
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfHDQWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 12:22:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfHDQWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 12:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kr2uYMmZDpUO1/Oyu8nKDJ6LDea+x/hpCdWyFJ2gDTs=; b=Cs44fTZHL2QOmZcTJs/4ZTf/DF
        cTsDYmlPmbt4OW5rNafTkzyTfqh58YvggPoH6X3zb2cydczTyzvLQyI6NLcWNJf5G3Wh6YtDW/KAh
        9JLxBFZUi3a0gVJZBsjvttQq4Whku/az7H3iS6CP5LryJbVWnHy+b/uCILS/L7VjZmAI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huJGx-0002MZ-U4; Sun, 04 Aug 2019 18:22:15 +0200
Date:   Sun, 4 Aug 2019 18:22:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Tao Ren <taoren@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Message-ID: <20190804162215.GE6800@lunn.ch>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com>
 <20190804145152.GA6800@lunn.ch>
 <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com>
 <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Even if that were the case (patching phy_attach_direct to apply a
> > logical-or to dev_flags), it sounds fishy to me that the genphy code
> > is unable to determine that this PHY is running in 1000Base-X mode.
> > 
> > In my opinion it all boils down to this warning:
> > 
> > "PHY advertising (0,00000200,000062c0) more modes than genphy
> > supports, some modes not advertised".
> > 
> The genphy code deals with Clause 22 + Gigabit BaseT only.
> Question is whether you want aneg at all in 1000Base-X mode and
> what you want the config_aneg callback to do.
> There may be some inspiration in the Marvel PHY drivers.

As far as i know, you cannot actually advertise 1000Base-X. So we
probably should not be setting the bit in advertise, only having it in
supported?

	Andrew
