Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C55D4ADDDC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382625AbiBHQBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382600AbiBHQBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:01:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FFAC061579;
        Tue,  8 Feb 2022 08:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G8d9XT4bl8XpGnnrhh9W2ll+8LVIFjC7omdTT8KDyIw=; b=G06wp3ldf/2hq5KaIhgCznyxLr
        1eRODIqoka8a2jjEzzdrjYQY5znwjc5jZRk7brORqM/DIJT7mEGrUpWxmajkB6XEnOzWDLpH4qlQW
        1tlGGk00JLv/rSimj+ga93WaVgc49AMYhbj+IklQTribY1unrBotumNR0HLq9Vgxn2bFguXDWx8Ki
        DyCoBY6Uq84DxYeP77yrwjVO+uoA91bVVcn1sHlVlpKbMWfJCwvixfl32xZqEBzKSS4IE4dHD6cXl
        7H+5UaQT56S/BwuUuCdyPH/cc5BIwbeCTxgYuboMlbxsEKcXFWM+PJpyWgVOrWNDtPl/wId7f7g+o
        PFHD/qog==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57158)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHSw6-0003OK-TH; Tue, 08 Feb 2022 16:01:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHSw5-0000gN-C5; Tue, 08 Feb 2022 16:01:45 +0000
Date:   Tue, 8 Feb 2022 16:01:45 +0000
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
Message-ID: <YgKT6W7y69AGiFd7@shell.armlinux.org.uk>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
 <YgHQ7Kf+2c9knxk3@lunn.ch>
 <20220208155752.GB3003@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208155752.GB3003@localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 09:27:52PM +0530, Raag Jadav wrote:
> On Tue, Feb 08, 2022 at 03:09:48AM +0100, Andrew Lunn wrote:
> > > MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> > > by default, and it does expect Clause 37 auto-negotiation to complete
> > > between MAC and PHY before the actual data transfer happens.
> > > 
> > > [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> > > 
> > > I faced such issue while integrating VSC85xx PHY
> > > with one of the recent NXP SoC having similar MAC implementation.
> > > Not sure if this is a problem on MAC side or PHY side,
> > > But having Clause 37 support should help in most cases I believe.
> > 
> > So please use this information in the commit message.
> > 
> > The only danger with this change is, is the PHY O.K with auto-neg
> > turned on, with a MAC which does not actually perform auto-neg? It
> > could be we have boards which work now because PHY autoneg is turned
> > off.
> > 
> 
> Introducing an optional device tree property could be of any help?

Preferably not. We do need some way that the MAC and PHY can co-operate
to work out whether inband should be used or not. Vladimir had some
patches for that a while back which were touching phylib and phylink
which may be worth looking into to see whether some of that can be
applied to your situation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
