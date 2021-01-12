Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613962F3512
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392575AbhALQGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392162AbhALQGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:06:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B1BC061575;
        Tue, 12 Jan 2021 08:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hOFBZhH3J+gHIt66r8myaNSTFolZ8lAHUWcJqfKFprs=; b=mU8pUjk/TvGr4KoITbdz3SjXj
        bM9XV/Da0nO88tjuoSo0Ba17+Fms0zoL7DOy3bL+5vJGu0cUMJ+PmlJEEY1bFoaoQnGXkNwLrRsAV
        BWJAR2SBHeJKTkkqmsV6F/3oIXl99i4cIzP4upNabYTa/wFe0W4UOhqsmb47fI/0sD3MrRung8lAJ
        VnJa1nT0P5rRAHDHZSom2XaX+tHsGxDf133iG/JVxiFGIFQcNdjK98sFX9+uvt6NkfSyyPQP9mE6d
        pqCLgA02AJGrS6o+vZw9NdbcypI5dr2qh/IOukQXbZ0j0ko7orvn9/sLMH2APm2RonhMIX6oQ6Wuq
        OItIR8h9g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47078)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzMAn-00005s-Bq; Tue, 12 Jan 2021 16:05:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzMAm-0006Oo-9w; Tue, 12 Jan 2021 16:05:32 +0000
Date:   Tue, 12 Jan 2021 16:05:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 0/2] Add 100 base-x mode
Message-ID: <20210112160532.GC1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111141847.GU1551@shell.armlinux.org.uk>
 <a727ddabfed0dbd0cf75a045076df7a66d4d6a67.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a727ddabfed0dbd0cf75a045076df7a66d4d6a67.camel@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 03:33:34PM +0100, Bjarni Jonasson wrote:
> On Mon, 2021-01-11 at 14:18 +0000, Russell King - ARM Linux admin
> wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > On Mon, Jan 11, 2021 at 02:06:55PM +0100, Bjarni Jonasson wrote:
> > > Adding support for 100 base-x in phylink.
> > > The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause 24)
> > > 4b5b encoded.
> > > These patches adds phylink support for that mode.
> > > 
> > > Tested in Sparx5, using sfp modules:
> > > Axcen 100fx AXFE-1314-0521
> > > Cisco GLC-FE-100LX
> > > HP SFP 100FX J9054C
> > > Excom SFP-SX-M1002
> > 
> > For each of these modules, please send me:
> > 
> > ethtool -m ethx raw on > module.bin
> > 
> > so I can validate future changes with these modules. Thanks.
> > 
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> I've included the dump from ethtool for:
> Axcen 100fx AXFE-1314-0521
> Axcen 100lx AXFE-1314-0551
> Excom SFP-SX-M1002
> HP SFP 100FX J9054C
> The "ethtool raw" output seems a bit garbled so I added the hex output
> as well.

It is exactly the command that I quoted above that I require. Yes,
the output will be "garbled" as it is a raw binary dump of the EEPROM
contents - it's not meant to be displayed directly on the console.

Please resend.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
