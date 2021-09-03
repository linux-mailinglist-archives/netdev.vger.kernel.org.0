Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA0D3FFF41
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhICLfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbhICLfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 07:35:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB56AC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 04:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ieTQsWw6aTme0mg+VPJunkBQb9jSaYqHjwFd+kPnrI4=; b=gGjnJ53sBgATahRQkyLWSIG6N
        smXBJGvM30o3V+GJdoTdYG02TFTm5vzIb1QSosBqPJvAYjXgGg4icp6AyIZxuWcpWzjWXMzAR7Yr0
        yaSEMekzAQqxDJf+yNFHFWEIgCVPBeKJR5GZhmHAtV3GV5a1JpqyEUUuyH+2CuZChjQUTLoU9vvu/
        3X5oCVXSX2hn4aLWYt5m+bDxPs+6Cm/txNn+cgikyfSySgIMWsuKP9ok7MmrAqsdYAep22mdAdYDL
        mcUxHdStCoRKh4fsm+SztkHGKOCmE0Mn1b4G5KUjej5f3suFxl/bXCROukGI8MYN/iSyF2M6LIYSI
        0mGR0rXGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48144)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mM7St-0002xR-TR; Fri, 03 Sep 2021 12:34:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mM7Ss-0000Sl-Op; Fri, 03 Sep 2021 12:34:34 +0100
Date:   Fri, 3 Sep 2021 12:34:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210903113434.GV22278@shell.armlinux.org.uk>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
 <20210816144752.vxliq642uipdsmdd@skbuf>
 <20210903103358.GU22278@shell.armlinux.org.uk>
 <20210903110916.bjjm6x3h4l4raf27@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903110916.bjjm6x3h4l4raf27@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 02:09:16PM +0300, Ioana Ciornei wrote:
> On Fri, Sep 03, 2021 at 11:33:58AM +0100, Russell King (Oracle) wrote:
> > On Mon, Aug 16, 2021 at 05:47:52PM +0300, Ioana Ciornei wrote:
> > > On Tue, Jul 20, 2021 at 03:11:34PM +0100, Russell King (Oracle) wrote:
> > > > On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> > > > > On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > > > > > Phylink documentation says:
> > > > > >   Note that the PHY may be able to transform from one connection
> > > > > >   technology to another, so, eg, don't clear 1000BaseX just
> > > > > >   because the MAC is unable to BaseX mode. This is more about
> > > > > >   clearing unsupported speeds and duplex settings. The port modes
> > > > > >   should not be cleared; phylink_set_port_modes() will help with this.
> > > > > > 
> > > > > > So add the missing 10G modes.
> > > > > 
> > > > > Hi Russell
> > > > > 
> > > > > Would a phylink_set_10g(mask) helper make sense? As you say, it is
> > > > > about the speed, not the individual modes.
> > > > 
> > > > Yes, good point, and that will probably help avoid this in the future.
> > > > We can't do that for things like e.g. SGMII though, because 1000/half
> > > > isn't universally supported.
> > > > 
> > > > Shall we get this patch merged anyway and then clean it up - as such
> > > > a change will need to cover multiple drivers anyway?
> > > > 
> > > 
> > > This didn't get merged unfortunately.
> > > 
> > > Could you please resend it? Alternatively, I can take a look into adding
> > > that phylink_set_10g() helper if that is what's keeping it from being
> > > merged.
> > 
> > It looks like the original patch didn't appear in patchwork for some
> > reason - at least google can find it in lore's netdev archives, but
> > not in patchwork. I can only put this down to some kernel.org
> > unreliability - we've seen this unreliability in the past with netdev,
> > and it seems to be an ongoing issue.
> > 
> 
> Yes, it cannot be found though google but the patch appears in
> patchwork, it was tagged with 'Changes requested'.
> https://patchwork.kernel.org/project/netdevbpf/patch/E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk/

Thanks. I wonder why searching for it via google and also via patchworks
search facility didn't find it.

So, it got incorrectly tagged by netdev maintainers, presumably because
they're too quick to classify a patch while discussion on the patch was
still ongoing - and there's no way for those discussing that to ever
know without finding it in patchwork. Which is pretty much impossible
unless you know the patchwork URL format and message ID, and are
prepared to regularly poll the patchwork website.

The netdev process, as a patch submitter or reviewer, is really very
unfriendly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
