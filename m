Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FA769AA94
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBQLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQLmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:42:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8D66569C
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xJ+JPptWRtS5ZzuxQ8mpxK3RCbHQ6EOZ7Rm6EKpEzqs=; b=sV5Ldc47XeWomvz33apJ3js+56
        eP7kvDmdbDQIHL2X/VO9MQ6PIDdA3m01u0lsNBGbyFrY71G9iBEY+Ru4sF5WBgnvN3K52ZaMHWP4i
        6R8N0hMkCWRuUjiFv5Iim8Qsdwa1fPiin2wAUZ8MlGnDP2zXFL6bmbCLmOOrhtl2PNv8533XPURpF
        k6/ZAnfS1Yt2URj3OcHVo3u6WGtxzEAnEV1B56OYQ0M9mhAhApGrRsK+YucS7O5eMURmkcYrLIfWk
        J/d7n6Pc+QP5EtYCEzNBPaI3M0N6EZGVq4KZ0nr6rFQjjoAZVPmF+YNwZ/li62TgW0ad4JzPBXGwz
        /3ZnItzA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47820)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSz7z-0000rB-ME; Fri, 17 Feb 2023 11:42:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSz7u-0006lS-9w; Fri, 17 Feb 2023 11:42:06 +0000
Date:   Fri, 17 Feb 2023 11:42:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 00/18] Rework MAC drivers EEE support
Message-ID: <Y+9oDrTXCX6xVKSl@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:12AM +0100, Andrew Lunn wrote:
> phy_init_eee() is supposed to be called once auto-neg has been
> completed to determine if EEE should be used with the current link
> mode. The MAC hardware should then be configured to either enable or
> disable EEE. Many drivers get this wrong, calling phy_init_eee() once,
> or only in the ethtool set_eee callback.
> 
> This patchset changes the API, such that EEE becomes the same as other
> parameters which are determined by auto-neg. As will speed and duplex,
> active EEE is now indicated in the phydev structure, and the
> adjust_link callbacks have been modified to act upon its value.
> 
> eee_set and eee_get have been simplified, given that the phylib
> functions act upon most of the data in eee_set, and fill in most of
> the information needed for eee_set.

This is a very nice cleanup, and removes a bunch of logic from MAC
drivers into the phylib core code that should result in more
uniform behaviour across MAC drivers for this feature. Great!

I'm left wondering about the phylink using drivers, whether we could
go a little further, because there's also the tx_lpi_enabled flag
which should also gate whether EEE is enabled at the MAC - and
whether that logic could be handled entirely within phylink too.
That would mean instead of mac_link_up() being passed the phydev
(and EEE is the reason the phydev is passed) we could instead just
pass an "eee" flag to tell the MAC to program itself appropriately.
Then, the only thing which MAC drivers need to concern themselves
with is setting the TX LPI timer to the appropriate value (which
may need to happen in mac_link_up()).

However, for this series, it's definitely a much needed improvement!

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
