Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066464C56D0
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiBZQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 11:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiBZQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 11:32:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5AE24DECC;
        Sat, 26 Feb 2022 08:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6OjByrZL/8WN1XwAV8cA5zlopGQjph2v70guM/ZhHrY=; b=wrgqqkrMVWZpQ2F7HPiyR4Y6fI
        jrY2BXk+vHM6o0e/2+zlEqqbQFiuLORisxaZ93IZR0FbdSwPh7NNw3Sw9XFGyLIAIm7uVlYGBv4my
        lDCMT36GIPLX3bRN/5uDLl5cQ7cNFGKFw9WtACxzWZJkX6gaL7/N6zQF4zHCFJe1YiyhJyiINBndc
        tFyYQHpK11SSsMxUUy/MncvXEsBElh5droIeDW5E/sp9LdUZd5ArYXCDIUTWGkORVj2JdqYW/6llu
        Ssi9uUy+FXpaTxOlh+kjZ8Y0zXKkD6VQZ56dXpu1mT7M/62HOeRUVw5tyAT+m97pI/FSAdtsC4vdu
        xR2BqFKg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57524)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNzzF-0006m6-6I; Sat, 26 Feb 2022 16:32:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNzzB-0004G5-Sk; Sat, 26 Feb 2022 16:31:57 +0000
Date:   Sat, 26 Feb 2022 16:31:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <YhpV/Q8Pnv+OZ3Fr@shell.armlinux.org.uk>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
 <20220226072327.GA6830@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226072327.GA6830@localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 12:53:27PM +0530, Raag Jadav wrote:
> On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
> > Sorry for the late comment on this patch.
> > 
> > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> > > +{
> > > +	int rc;
> > > +	u16 reg_val = 0;
> > > +
> > > +	if (enabled)
> > > +		reg_val = MSCC_PHY_SERDES_ANEG;
> > > +
> > > +	mutex_lock(&phydev->lock);
> > > +
> > > +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> > > +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> > > +			      reg_val);
> > > +
> > > +	mutex_unlock(&phydev->lock);
> > 
> > What is the reason for the locking here?
> > 
> > phy_modify_paged() itself is safe due to the MDIO bus lock, so you
> > shouldn't need locking around it.
> > 
> 
> True.
> 
> My initial thought was to have serialized access at PHY level,
> as we have multiple ports to work with.
> But I guess MDIO bus lock could do the job as well.

The MDIO bus lock is the only lock that will guarantee that no other
users can nip onto the bus and possibly access your PHY in the middle
of an operation that requires more than one access to complete. Adding
local locking at PHY driver level does not give you those guarantees.
This is exactly why phy_modify() etc was added - because phy_read()..
phy_write() does not give that guarantee.

As an example of something that could interfere - the userspace MII
ioctls.

> I've gone through Vladimir's patches and they look more promising
> than this approach.
> Let me know if I could be of any help.

I haven't seen them - so up to you.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
