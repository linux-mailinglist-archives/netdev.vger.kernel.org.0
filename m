Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1B04ADC9C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbiBHP1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380298AbiBHP1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:27:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A88C06157A
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dV9S0fA7IKy+O6MTVaEjo8BKYg8bXbBSPu8NAK1GOLQ=; b=Sk9g5ryW3XRNMTgotDn0R+4NLC
        +2Mq1ELGj95Z1iRbz7bjE83dyHAuX+7QOVuDIvi1yjOX+nPB531ZyiFIyEOMJIbDUUAufrS4LRomk
        BuQldL8enchayKW0fRyhz9O+yMN6+pGr3v+nbcd0A7/+0BLJTKSP/2Er4erLdfGRIq2Dduxdrj/Dl
        a1sC+6+iTs05mPcFK9qpIIXAVc1ke34dV/zA3lDjkUI6jOIEaCL1DFkP38l1UXhKf/qgLcLNzhrbX
        OdMT27DbrKseszRH+cRG8Flqze1Y/Hfy9siiK4TreH6/5YvGoYy2pNEY2gB0+h0YwxwK7msnb0Bsw
        82J/yMkw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57156)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHSP7-0003KL-VM; Tue, 08 Feb 2022 15:27:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHSP7-0000fF-6W; Tue, 08 Feb 2022 15:27:41 +0000
Date:   Tue, 8 Feb 2022 15:27:41 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH CFT net-next 0/6] net: dsa: qca8k: convert to phylink_pcs
 and mark as non-legacy
Message-ID: <YgKL7VK95d/0UgHS@shell.armlinux.org.uk>
References: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
 <YgKJxKBF6/i2k0tR@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgKJxKBF6/i2k0tR@Ansuel-xps.localdomain>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 04:18:28PM +0100, Ansuel Smith wrote:
> On Tue, Feb 08, 2022 at 03:11:30PM +0000, Russell King (Oracle) wrote:
> > This series adds support into DSA for the mac_select_pcs method, and
> > converts qca8k to make use of this, eventually marking qca8k as non-
> > legacy.
> > 
> > Patch 1 adds DSA support for mac_select_pcs.
> 
> Was thinking... Is it possible to limit the polling just to sgmii/basex?
> Would save some overhead in the case fixed-rate is set and the link
> never change.

With this series, the decision to poll comes from the PCS "poll" member
when in inband mode. The PCS is selected by the mac_select_pcs
callback, which for this DSA device, will only be returned for SGMII or
1000BASE-X. Consequently, phylink will only poll the PCS if we are in
SGMII or 1000BASE-X mode.

Note that this polling has only be done if we're in inband mode and the
PCS requires polling, or in fixed-link mode if we have an IRQ-less GPIO
for link# state, or if poll_fixed_state is set in phylink_config.

PS, if you would like to ensure you're copied on patches to qca8k,
please add an entry in MAINTAINERS for this driver - I had to dig
through git history to try and work out who was maintaining this
driver. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
