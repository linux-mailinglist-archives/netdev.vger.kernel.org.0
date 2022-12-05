Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55ED642C78
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiLEQE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiLEQE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:04:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C951B9DC
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4TFNbHd/y278uPyuReDI5Ti4FwFRgqeWgIzc6/bn1c4=; b=Y+rcPXIZ+jC1SB9voy0buS1ete
        LdxfBr6/n9LrneXy0CHthpRgXvvSi6TiwZHJ+hDg+713yVXkfsQnqmhId7zpwOwhkUnV02fLanAve
        nN8H+88XOCx4EZVY8ZV+JFMAztYvugeOgsy/cgU/stvdRsFB2EedtP4lRBdAij/AvFwGgDyTJwaK7
        F/uecs7BT9ugxylihXY8jGmlkxcjWw30gq1Uqjbfw3ogrkMTwvwOub/XM0HLgRMV2NEGtJ/F3Cg70
        FUhir1vY6N0aWrLxlw9CHPgi0sNihF4j30Zr8cpifSSqfFJ3lBDoV6+Mq4eRLyJ/W/iAkeqEhCTRr
        zyiuRZSg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35582)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2Dx8-0006wN-Nm; Mon, 05 Dec 2022 16:04:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2Dx7-0007MK-Ah; Mon, 05 Dec 2022 16:04:21 +0000
Date:   Mon, 5 Dec 2022 16:04:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: swphy: Support all normal speeds when
 link down
Message-ID: <Y44WhXU+Lq+MEM7A@shell.armlinux.org.uk>
References: <20221204174103.1033005-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221204174103.1033005-1-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 06:41:03PM +0100, Andrew Lunn wrote:
> The software PHY emulator validation function is happy to accept any
> link speed if the link is down. swphy_read_reg() however triggers a
> WARN_ON(). Change this to report all the standard 1G link speeds are
> supported. Once the speed is known the supported link modes will
> change, which is a bit odd, but for emulation is probably O.K.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>

This isn't what I suggested. I suggested restoring the old behaviour of
fixed_phy before commit 5ae68b0ce134 ("phy: move fixed_phy MII register
generation to a library") which did _not_ report all speeds, but
reported no supported speeds in BMSR.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
