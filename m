Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085764AD6C5
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbiBHL3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355545AbiBHJpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:45:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E403C03FEC0;
        Tue,  8 Feb 2022 01:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ENzT/RzkRmS/DYmUEXIfRgv3NjIzEKRzAqT9YgQoCgY=; b=Endl4vNlP+MiAxjcwTTB300pzx
        XEiU9Pw5DTd+cLTuKVE+nBViNEMcyypASHvYt+DmPHUXYtr9AVC1fetom5+AyTvj551sCr9m5tGmk
        HSNquIumVFx5I9KUogbn4sbsKKM3/uohWvZY651083QYgkgzKbaivDg0Lp68WATSVDmnXLxmewIso
        aFke0Xg+PB0spouEso4SyYU541F6STghZ+3KT7henUcC472V5tgVxqfzwgs0kokxwAvlILI1JylRx
        ssM0S5+V6w9i1cPRqnhCTyusyrmIancx0EcTA8C9YO7WA54KaTHcwpOgThR4thkATpH2c4bV0b8JP
        QrDuTksw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57150)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHN3k-0002wf-3I; Tue, 08 Feb 2022 09:45:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHN3h-0000TF-SB; Tue, 08 Feb 2022 09:45:13 +0000
Date:   Tue, 8 Feb 2022 09:45:13 +0000
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
Message-ID: <YgI7qcO1qjicYqUm@shell.armlinux.org.uk>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220207174948.GA5183@localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 11:19:48PM +0530, Raag Jadav wrote:
> On Sun, Feb 06, 2022 at 07:01:41PM +0100, Andrew Lunn wrote:
> > On Sun, Feb 06, 2022 at 10:42:34PM +0530, Raag Jadav wrote:
> > > On Sat, Feb 05, 2022 at 03:57:49PM +0100, Andrew Lunn wrote:
> > > > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > > > Enable MAC SerDes autonegotiation to distinguish between
> > > > > 1000BASE-X, SGMII and QSGMII MAC.
> > > > 
> > > > How does autoneg help you here? It just tells you about duplex, pause
> > > > etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
> > > > using whatever mode it was passed in phydev->interface, which the MAC
> > > > sets when it calls the connection function. If the PHY dynamically
> > > > changes its host side mode as a result of what that line side is
> > > > doing, it should also change phydev->interface. However, as far as i
> > > > can see, the mscc does not do this.
> > > >
> > > 
> > > Once the PHY auto-negotiates parameters such as speed and duplex mode
> > > with its link partner over the copper link as per IEEE 802.3 Clause 27,
> > > the link partner’s capabilities are then transferred by PHY to MAC
> > > over 1000BASE-X or SGMII link using the auto-negotiation functionality
> > > defined in IEEE 802.3z Clause 37.
> > 
> > None of this allows you to distinguish between 1000BASE-X, SGMII and
> > QSGMII, which is what the commit message says.
> > 
> 
> I agree, the current commit message is misleading.
> 
> > It does allow you to get duplex, pause, and maybe speed via in band
> > signalling. But you should also be getting the same information out of
> > band, via the phylib callback.
> > 
> > There are some MACs which don't seem to work correctly without the in
> > band signalling, so maybe that is your problem? Please could you give
> > more background about your problem, what MAC and PHY combination are
> > you using, what problem you are seeing, etc.
> > 
> 
> MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> by default, and it does expect Clause 37 auto-negotiation to complete
> between MAC and PHY before the actual data transfer happens.
> 
> [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> 
> I faced such issue while integrating VSC85xx PHY
> with one of the recent NXP SoC having similar MAC implementation.
> Not sure if this is a problem on MAC side or PHY side,
> But having Clause 37 support should help in most cases I believe.

Clause 37 is 1000BASE-X negotiation, which is different from SGMII - a
point which is even made in your PDF above in section 1.1.

You will need both ends to be operating in SGMII mode for 10M and 100M
to work. If one end is in 1000BASE-X mdoe and the other is in SGMII,
it can appear to work, but it won't be working correctly.

Please get the terminology correct here when talking about SGMII or
1000BASE-X.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
