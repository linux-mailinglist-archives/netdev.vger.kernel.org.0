Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5446880B47
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 16:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfHDOwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 10:52:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfHDOwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 10:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j8VdqIQ8dJCQg66t0XShnIYIOvNwsHrmT7xHQgMAnSQ=; b=ktHMOT70nx8YWSJEVkNw8K/kv2
        wHIlsypDeYfKw0tUOlKLoU1zAqvRRX5JXBoUY99mfGyTh8LcXzSXyA30Td/wJhHdYraetkAXTZtXa
        qLRELuRtqYfPdpBZr45N4o+Wd/LB5QPA1VZm801lifTunI5j/ctHRIKIxE1SKs2ldQQ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huHrU-0001qV-Cu; Sun, 04 Aug 2019 16:51:52 +0200
Date:   Sun, 4 Aug 2019 16:51:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <taoren@fb.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Message-ID: <20190804145152.GA6800@lunn.ch>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The patchset looks better now. But is it ok, I wonder, to keep
> > PHY_BCM_FLAGS_MODE_1000BX in phydev->dev_flags, considering that
> > phy_attach_direct is overwriting it?
> 

> I checked ftgmac100 driver (used on my machine) and it calls
> phy_connect_direct which passes phydev->dev_flags when calling
> phy_attach_direct: that explains why the flag is not cleared in my
> case.

Yes, that is the way it is intended to be used. The MAC driver can
pass flags to the PHY. It is a fragile API, since the MAC needs to
know what PHY is being used, since the flags are driver specific.

One option would be to modify the assignment in phy_attach_direct() to
OR in the flags passed to it with flags which are already in
phydev->dev_flags.

	Andrew
