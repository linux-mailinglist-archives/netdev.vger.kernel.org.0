Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB13ECB77
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 23:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhHOVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhHOVgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 17:36:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3642FC061764;
        Sun, 15 Aug 2021 14:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lf6ZqlaldTQ8/H5hBqLtGjFsnJoVtCAQJrwngOOoJ8g=; b=zO2ttehAHQMPGuZYqeXF1ccyc
        QY+ggWdtm2O9v6KjOvr24YtEGBs1xzDOsADsS7j/VnZ/Lk1mOCP4m686+OkJXJUpEXMkdIFoa+hgb
        6vrjgtmyki5S96XET3rmuIx0DIjKWqpPfrpukY0GmD2+UufX33Wv0xFzjBFtFRjRTPXWFYiOD/QaH
        P9XC067p0fa5Ml9DCIsde7CK6N+TE1G6+VQNvn5mP27rSfNWrgB0rxZRxwLvOCBW3KqOah4FRl318
        CU1CUei38d5PVYhNIlK1ViE3o65JjOELuU821ob2fs7oJpB4CPWslnY/drRvZcl3svZ5v9RZ86gTc
        /51odPzyw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47336)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFNnA-0006ot-62; Sun, 15 Aug 2021 22:35:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFNn7-0007Ji-Lk; Sun, 15 Aug 2021 22:35:37 +0100
Date:   Sun, 15 Aug 2021 22:35:37 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210815213537.GC22278@shell.armlinux.org.uk>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814120211.v2qjqgi6l3slnkq2@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 03:02:11PM +0300, Vladimir Oltean wrote:
> In fact I do notice now that as long as you don't use any of the
> optional phylink_mii_c22_pcs_* helpers in your PCS driver, then
> struct phylink_pcs has pretty much zero dependency on struct mdio_device,
> which means that I'm wrong and it should be completely within reach to
> write a dedicated PCS driver for this hardware.

Yes, this was one of the design goals when I created phylink_pcs, as I
have exactly this situation with my hardware - PCS that do not have a
MDIO interface and do not conform to MDIO register layouts. So, I
explicitly ensured that phylink_pcs, just like the rest of phylink,
is not tied to any particular model of how hardware should look like.

Glad to see that this design decision is coming in handy for other
people now. :)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
