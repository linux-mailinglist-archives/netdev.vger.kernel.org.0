Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2976D644DC3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiLFVIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLFVIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:08:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2884E32BB3;
        Tue,  6 Dec 2022 13:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ABgRbmmr7f7xzI4U+tOCzhaFlMBbCqKuoZEs9uCHGQ4=; b=KatyzSBXCfmhnvui1awGU9QHYf
        Qr8jmGrJCOpSF8MpRUCAmtq/Aiql578dzhWRzezIZ0+HvBzvIFc/Hzxo+G1IxyMRYexemwo/kbr8/
        ZZ4laJD7GVzRuas1UkTMx810gfsMq5asg3rtDckHDTliO8vFNLeWD9ZT3R9KOuIFBpPQQvX3786Nu
        iPnfs2KLKO43LOMrRfPw/LpMZPePF9OtY31dZQCcsQMzNozjJ+6H9wLHsf+r7Rwc+ewouBqDXP/X8
        STzfFxByWOP/XepQJL4VHftyWaT3ro3NENAMAxZkiVMcAndswHNuzQfBRjI8SdoTutoYq2qvqXZez
        tVa6aOSQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35606)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2fAS-0008OM-AP; Tue, 06 Dec 2022 21:07:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2fAQ-0008VN-3N; Tue, 06 Dec 2022 21:07:54 +0000
Date:   Tue, 6 Dec 2022 21:07:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] dsa: lan9303: Move to PHYLINK
Message-ID: <Y4+vKh8EfA9vtC2B@shell.armlinux.org.uk>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206183500.6898-3-jerry.ray@microchip.com>
 <20221206193224.f3obnsjtphbxole4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206193224.f3obnsjtphbxole4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:32:24PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 06, 2022 at 12:35:00PM -0600, Jerry Ray wrote:
> > This patch replaces the .adjust_link api with the .phylink_get_caps api.
> 
> Am I supposed to read this commit description and understand what the
> change does?
> 
> You can't "replace" adjust_link with phylink_get_caps, since they don't
> do the same thing. The equivalent set of operations are roughly
> phylink_mac_config and phylink_mac_link_up, probably just the latter in
> your case.
> 
> By deleting adjust_link and not replacing with any of the above, the
> change is telling me that nothing from adjust_link was needed?

...

> > -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> > -				struct phy_device *phydev)
> > -{
> > -	struct lan9303 *chip = ds->priv;
> > -	int ctl;
> > -
> > -	if (!phy_is_pseudo_fixed_link(phydev))
> > -		return;

If this is a not a fixed link, adjust_link does nothing.

> > -
> > -	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> > -
> > -	ctl &= ~BMCR_ANENABLE;
> > -
> > -	if (phydev->speed == SPEED_100)
> > -		ctl |= BMCR_SPEED100;
> > -	else if (phydev->speed == SPEED_10)
> > -		ctl &= ~BMCR_SPEED100;
> > -	else
> > -		dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed);
> > -
> > -	if (phydev->duplex == DUPLEX_FULL)
> > -		ctl |= BMCR_FULLDPLX;
> > -	else
> > -		ctl &= ~BMCR_FULLDPLX;
> > -
> > -	lan9303_phy_write(ds, port, MII_BMCR, ctl);
> 
> Are you going to explain why modifying this register is no longer needed?

... otherwise it is a fixed link, so the PHY is configured for the fixed
link setting - which I think would end up writing to the an emulation of
the PHY, and would end up writing the same settings back to the PHY as
the PHY was already configured.

So, I don't think adjust_link does anything useful, and I think this is
an entirely appropriate change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
