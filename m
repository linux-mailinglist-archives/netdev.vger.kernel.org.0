Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471322F0464
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 00:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAIXVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 18:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAIXVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 18:21:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C1AC061786;
        Sat,  9 Jan 2021 15:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o/+NVcgrx8JqxXvcbVLVPO61C9UbG6h6mmTwddD0Gr4=; b=gsQph+Lwv6uhcr9c8jxJtkdV3
        amHs55Qny3BrsypHppdCL8mzydhBf4HY9Lpb7Dbg69Efrf/HbyqoWjcE8Gr4dGmXtWHYz9WWhEiJ+
        SD3Nx225rDT+t/CBmE2tNFeWTC4s2wQrTOZzcqIEJd69YrEhd50U9zi2qzTdmj9J2ytuADVL6Egmz
        oimyRbwnlfbdeK/PyfjmLidgejqBv5QVhuiOBf8G27wEx3xqw92DHfPWmvdZyi5V7Edl8YBVq3O12
        XVh7J7eIZj3Rxm5EBclH1dvBK5F1sax67xGdM3A24zi1t//qxhyB1U+nCpEfcXVdhUlUlIczMoTip
        cZTdPA9dA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45904)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyNWW-0005SU-3p; Sat, 09 Jan 2021 23:19:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyNWU-0003aS-Kg; Sat, 09 Jan 2021 23:19:54 +0000
Date:   Sat, 9 Jan 2021 23:19:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <20210109231954.GC1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
 <20210109154601.GZ1551@shell.armlinux.org.uk>
 <20210109191447.hunwx4fc4d4lox5f@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210109191447.hunwx4fc4d4lox5f@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 08:14:47PM +0100, Pali Rohár wrote:
> On Saturday 09 January 2021 15:46:01 Russell King - ARM Linux admin wrote:
> > On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> > > On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > > 
> > > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > > 
> > > > Such combination of bits is meaningless so assume that LOS signal is not
> > > > implemented.
> > > > 
> > > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > > 
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > 
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > I'd like to send this patch irrespective of discussion on the other
> > patches - I already have it committed in my repository with a different
> > description, but the patch content is the same.
> > 
> > Are you happy if I transfer Andrew's r-b tag, and convert yours to an
> > acked-by before I send it?
> > 
> > I'd also like to add a patch that allows 2.5G if no other modes are
> > found, but the bitrate specified by the module allows 2.5G speed - much
> > like we do for 1G speeds.
> 
> Russell, should I send a new version of patch series without this patch?

I think there's some work to be done for patch 1, so I was thinking of
sending this with another SFP patch. It's really a bug fix since the
existing code doesn't behave very well if both bits are set - it will
toggle state on every RX_LOS event received irrespective of the RX_LOS
state.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
