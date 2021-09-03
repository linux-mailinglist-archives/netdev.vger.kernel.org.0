Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA68E3FFE3F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 12:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349004AbhICKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbhICKfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 06:35:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FB2C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 03:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X6qTSuFEou5/DuLlUPepVqrS8+Zg64mueXYVbmVQFG4=; b=wvH5aY4SSizG6Gk+2gLprsUrl
        6/dEEuGfqC4QwLODODjdIPIZKdr45gFNaE9Qy6mfajiQbel3v9mBkmxtIP4HdxXXW3ZBnfw9fW1oT
        dPNVG+AZomTou7vXTonM3uK8sMB8EX/QqGET2Y0HMUSkq1p/y7PGPxNNR6EolDljop5hFXlT26C4Q
        cV4GAIM4CQp8YeO/B8Man8uKQZLhCnukFsQ8RZpXnWBq+i7t8qWcNtLxrrgl8dePzsV1EdN32b5c9
        x69+9wNHgpA+bGgmkX6GeD7gNCXDCqhyQLCzbT+65x7AELj13FeJLx2FU5ubklDM6M81n/ncVFHPp
        qZY+K+m9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48142)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mM6WG-0002s1-K0; Fri, 03 Sep 2021 11:34:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mM6WE-0000QV-TL; Fri, 03 Sep 2021 11:33:58 +0100
Date:   Fri, 3 Sep 2021 11:33:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210903103358.GU22278@shell.armlinux.org.uk>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
 <20210816144752.vxliq642uipdsmdd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816144752.vxliq642uipdsmdd@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 05:47:52PM +0300, Ioana Ciornei wrote:
> On Tue, Jul 20, 2021 at 03:11:34PM +0100, Russell King (Oracle) wrote:
> > On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> > > On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > > > Phylink documentation says:
> > > >   Note that the PHY may be able to transform from one connection
> > > >   technology to another, so, eg, don't clear 1000BaseX just
> > > >   because the MAC is unable to BaseX mode. This is more about
> > > >   clearing unsupported speeds and duplex settings. The port modes
> > > >   should not be cleared; phylink_set_port_modes() will help with this.
> > > > 
> > > > So add the missing 10G modes.
> > > 
> > > Hi Russell
> > > 
> > > Would a phylink_set_10g(mask) helper make sense? As you say, it is
> > > about the speed, not the individual modes.
> > 
> > Yes, good point, and that will probably help avoid this in the future.
> > We can't do that for things like e.g. SGMII though, because 1000/half
> > isn't universally supported.
> > 
> > Shall we get this patch merged anyway and then clean it up - as such
> > a change will need to cover multiple drivers anyway?
> > 
> 
> This didn't get merged unfortunately.
> 
> Could you please resend it? Alternatively, I can take a look into adding
> that phylink_set_10g() helper if that is what's keeping it from being
> merged.

It looks like the original patch didn't appear in patchwork for some
reason - at least google can find it in lore's netdev archives, but
not in patchwork. I can only put this down to some kernel.org
unreliability - we've seen this unreliability in the past with netdev,
and it seems to be an ongoing issue.

It's now too late to re-send for this merge window - net-next is
currently closed. Whether I remember in a fortnight or so time when
net-next re-opens is another problem.

And yes, I also have the phylink_set_10g() patches in my tree, which
was waiting for this patch to have been merged.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
