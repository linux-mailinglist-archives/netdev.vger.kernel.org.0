Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1229ECBF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgJ2NWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgJ2NWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:22:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A962CC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qnNuc+Q4zm9I9Hk5SLspxv5x30VByZY9NTRPEOGdNuM=; b=WvTKhCcEN58zDBuTBe8fFpJ3V
        l2qTwu6B3/f1Jiys9HiyMxvEM+EQ89VTCubjfnKbqX/CIEiR0KLgZ79X6WJ0SdeXgMcOTMGRvv5l9
        Q4zJyluY1ta4L/nD4WycfnGyEWDswfXECCDB7fvOh3qoHcsn8rbb7YWmMGOlCdZEEiuAU9ahBOzUK
        gyyCZDHMLEKoTN7Ty1e3NRydAz9Vyme3IQG/9tDKxtkNnauQ3x408B1H+IlVY3Ls3M6AhaTHxf+NI
        uMXjsPhoW/Pwsdd1urzTQmcXFdZOXUdBEneeJW0Y5bW4V5UYm4a3E5HI+3wWCB5lyU4df3hVjA6+w
        058TWjI3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52466)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY7sL-0004Og-Eo; Thu, 29 Oct 2020 13:21:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY7sL-00068t-8U; Thu, 29 Oct 2020 13:21:57 +0000
Date:   Thu, 29 Oct 2020 13:21:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 4/5] net: phy: marvell10g: change MACTYPE if
 underlying MAC does not support it
Message-ID: <20201029132157.GT1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028221427.22968-5-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:14:26PM +0100, Marek Behún wrote:
> RollBall SFPs contain a Marvell 88X3310 PHY, but by default the MACTYPE
> is set to 10GBASE-R with Rate Matching.
> 
> Some devices (for example those based on Armada 38x) only support up to
> 2500base-x SerDes modes.
> 
> Change the PHY's MACTYPE to 4 (which means changing between 10gbase-r,
> 5gbase-r, 2500base-x ans SGMII depending on copper speed) if this is the
> case (which is infered from phydev->interface).
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

This'll do as a stop-gap until we have a better way to determine which
MACTYPE mode we should be using.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
