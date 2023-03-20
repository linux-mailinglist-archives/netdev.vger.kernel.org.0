Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5F6C0E64
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCTKMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCTKMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:12:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2A0A259
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AZ684MN0v5DRrB1yZ57+IpWbIr6VM693y+qGJp8b17E=; b=kqO8HMs7Riy3FbqgPMBD/gEIY+
        +dkzvQsCQ9a0Uug7JbQ+mMk4C5lJ8N8QJdDEIFJcmW3chWV+eNU6hjrNS2p4TCxvWKx9NfNFRpxWy
        WWrB44/quoUZcFqtPVf6UeeCfGbCyTrWzEoGQEVHWiqEqfs82FSt2Dy2ZoT091kd4roztgFiTubjp
        oCthWfjUkcpKPwPaPmxPX54CJvr6zqoyniBVtOPbsdMMHZJeoHOmjcQJ7w8aXCdM0DelQB0cMmtb5
        BHIXeHEdglAd8iO5WhBbiCDTS+COGaGHBLhDBbBDB+hfOWTAm/jownhjlZcDhz+31XUKgdTxDBl2Y
        JUArsP7w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52918)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peCUt-00079O-JN; Mon, 20 Mar 2023 10:12:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peCUs-0006R3-Jk; Mon, 20 Mar 2023 10:12:10 +0000
Date:   Mon, 20 Mar 2023 10:12:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <ZBgxel31tqJGD1j2@shell.armlinux.org.uk>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:45:38AM +0000, Buzarra, Arturo wrote:
> Hi,
> 
> I will try to answer all your questions:
> 
> - "We need more specifics here, what type of PHY device are you seeing this with?"
> - " So best start with some details about your use case, which MAC, which PHY, etc"
> I'm using a LAN8720A PHY (10/100 on RMII mode) with a ST MAC ( in particular is a stm32mp1 processor).

I can only find:

arch/arm/boot/dts/rk3066a-marsboard.dts:        lan8720a {
arch/arm/boot/dts/rk3188-radxarock.dts: lan8720a  {
arch/arm/boot/dts/imx6sx-softing-vining-2000.dts:                       /* LAN8720 PHY Reset */
arch/arm/boot/dts/imx6sx-softing-vining-2000.dts:                       /* LAN8720 PHY Reset */
arch/mips/boot/dts/ingenic/cu1000-neo.dts:      phy-handle = <&lan8720a>;
arch/mips/boot/dts/ingenic/cu1000-neo.dts:      lan8720a: ethernet-phy@0 {

using this PHY in the mainline kernel, none of them look like a stm32mp1
processor.

Please can you give details of how the MDIO bus is connected to this
PHY, in particular the hardware setup, and which driver is being used?

> We have two PHYs one is a Gigabit PHY (RGMII mode) and the another one is a 10/100 (RMII mode).
> In the boot process, I think that there is a race condition between configuring the Ethernet MACs and the two PHYs. At same point the RGMII Ethernet MAC is configured and starts the PHY probes.
> When the 10/100 PHY starts the probe, it tries to read the genphy_read_abilities() and always reads 0xFFFF ( I assume that this is the default electrical values for that lines before it are configured).
> At that point, the PHY initialization assumes like a valid value 0xFFFF and obviously it reports capabilities that the LAN8720A PHY does not have, like for example gigabit support.

So the questions that need to be asked are:

  What is causing 0xffff to be returned?

and two sub-questions on that which may help you answer it in a way
that is most relevant:

  Is it the PHY itself that is not responding?

  Is the MDIO driver not functional because the MAC or some resource it
  needs hasn't been setup, and thus is returning 0xffff?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
