Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933854481AB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhKHO2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhKHO2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:28:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6283C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 06:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vB3lGTKeXlkwPt1uW+zIv45y5eq/L48p/G5oE4G69cQ=; b=el7KfnOcZzyOI2msWn885gGF/G
        Sa78dybaSyn1kpmLx3kYpTwqtJ9mdku7Zc4eW7zY8oiaRrUWbkIHMQcflkgI0Zn8RCrADfNuL1Jlp
        S2YsOE21CaNeTIkgsQr574CsD5OqIkWA7g+veHrV8BzyzXqk57g1krTav870WCygM3Ed9HKn598Re
        wtdDQC8ZoQa8X+Lo4/BMNU/sYGUTVpN4Ntl1Kb3Rhxv5SNR5eq8HSY9tcl6zU0O1vEboKgqMnS/Rm
        9WXROBq2Dm0bt6sSs947UEFfnjFN9wZJtT0Xw6eJkajG0KKwTmbRzEit2onpEUs3GUncEJhb5HcEW
        4tFjZa0Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55536)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mk5ao-0000pA-MF; Mon, 08 Nov 2021 14:25:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mk5an-0002sB-0o; Mon, 08 Nov 2021 14:25:49 +0000
Date:   Mon, 8 Nov 2021 14:25:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     bage@linutronix.de
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, b.spranger@linutronix.de
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108141834.19105-1-bage@linutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:18:34PM +0100, bage@linutronix.de wrote:
> From: Bastian Germann <bage@linutronix.de>
> 
> Take the return of phy_start_aneg into account so that ethtool will handle
> negotiation errors and not silently accept invalid input.

I don't think this description is accurate. If we get to call
phy_start_aneg() with invalid input, then something has already
gone wrong. As Andrew has already explained, an error from this
function means that something went wrong with PHY communication.
All validation should have happened prior to this function being
called.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
