Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59CC3CFBCB
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhGTNeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbhGTNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:31:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3522FC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 07:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iZ5zvgxoEjdcG0HU0iGSfd1vn3rjBD2oImNiDOKtdoU=; b=II/P6jgYByJ3li1mukbYEHh41
        iyJoMZYArQv3sHbxkHibmgLui6vlJFWGDvgExUm3ovnJG20sJVH8OJZn2VxyRwGBT83CDcUyy0gKA
        HXG2Rv4m6FNcQe9nnS69sB6QiERO0zgHkHUKnItJa7Mg8HkVOoFJrvDgCRNjECrO4e1eN9BiplVgh
        +ojzE2B0RnHNun9tBBQEyCeGRv22ThRX1SFee4D9S0trZ2mHPALmnpFppZoYkIEvmqkvZr7zZXyeg
        768J55lEgwDuCJWhEYIwdzT6UNevVjIwFrTivQOx/+uV9NWcro4sDMQ8sQuAgk8hDtiDNG7oPATur
        9jCUSRkFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46372)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5qTA-0006SS-HK; Tue, 20 Jul 2021 15:11:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5qT8-0006yf-Rl; Tue, 20 Jul 2021 15:11:34 +0100
Date:   Tue, 20 Jul 2021 15:11:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210720141134.GT22278@shell.armlinux.org.uk>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPbU59Kmpk0NvlQH@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > Phylink documentation says:
> >   Note that the PHY may be able to transform from one connection
> >   technology to another, so, eg, don't clear 1000BaseX just
> >   because the MAC is unable to BaseX mode. This is more about
> >   clearing unsupported speeds and duplex settings. The port modes
> >   should not be cleared; phylink_set_port_modes() will help with this.
> > 
> > So add the missing 10G modes.
> 
> Hi Russell
> 
> Would a phylink_set_10g(mask) helper make sense? As you say, it is
> about the speed, not the individual modes.

Yes, good point, and that will probably help avoid this in the future.
We can't do that for things like e.g. SGMII though, because 1000/half
isn't universally supported.

Shall we get this patch merged anyway and then clean it up - as such
a change will need to cover multiple drivers anyway?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
