Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E072F00F5
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 16:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbhAIPrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 10:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbhAIPrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 10:47:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3521AC061786;
        Sat,  9 Jan 2021 07:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Klr8Z9mGhIYG+FmhsePSGLHFhacpJApUPilK2uuGrDg=; b=esD0pWHBMiiril6TCjS90N6+k
        SalXumkh9pCJIxbm0D+2Oro7ZBvIsz8Tgs0NTMfz0kbw5A3EPWX+solVzFfx7SnVIrIrh9iPpkEuG
        7Z7/7yyxy36UguWS9thsDnzqQ+//Z26dNe4dVxhpOHXmqB2hwIOGtqLqSX6pokocPN2wMFvAr0bzh
        QrRJ/By7h3aLO7ZKmJZOc2joJPQVCFVAL52jYGuSTILEuoXczzfyWCdZ1ocRnfp+T8qv9uH5lBCFx
        V5NLKFNJj4SNx3G3MVOI/xyBhKsF3PlQyxZPceuUy/ZvRSAGvm/2tS62ATHx6gpQV3zcj/VtiwKyv
        dzQ6OBEVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45772)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyGRG-0005At-Lq; Sat, 09 Jan 2021 15:46:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyGRF-0003IX-Ey; Sat, 09 Jan 2021 15:46:01 +0000
Date:   Sat, 9 Jan 2021 15:46:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <20210109154601.GZ1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/c8xJcwj8Y1t3u4@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > 
> > Such combination of bits is meaningless so assume that LOS signal is not
> > implemented.
> > 
> > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I'd like to send this patch irrespective of discussion on the other
patches - I already have it committed in my repository with a different
description, but the patch content is the same.

Are you happy if I transfer Andrew's r-b tag, and convert yours to an
acked-by before I send it?

I'd also like to add a patch that allows 2.5G if no other modes are
found, but the bitrate specified by the module allows 2.5G speed - much
like we do for 1G speeds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
