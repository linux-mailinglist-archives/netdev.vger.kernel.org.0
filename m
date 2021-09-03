Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58403FF839
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 02:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346503AbhICAF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 20:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343948AbhICAF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 20:05:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E47C061575;
        Thu,  2 Sep 2021 17:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1aZwa45lKhrAFfmSsnRqBX5rvfTJ2itANvtSd+k2ghc=; b=cY5MmrfGcs4Cg8XSd8qHh+G2f
        4o/wEHJZkxIhUwlMw0e/JO5IWeOuFpsZnJzCWKjns0+LCTGdQS57fNXfv0Jh3MLTolhDk92xgKtAv
        V89d5GXoFx3IH9GVru3vJnGekckGLY/Zl9ZxluTMGj5UMhh/lrgFomSi0URHRI6xeQt1QePv99v+E
        939HYZmCMzpjb/hqTV5ZovKYhm7msFuixkR0dRY4ena+Pc9qpCQ7Q3himRBB+r4rv5a4CkyWJSC+/
        FvC8Ft+hxCriJqgJ2jPNXb0uM3/gkO32vjBiHI/nQEZlIlA0KGUGVSc/901xNFLuBWy5nKz8HSRyP
        JVUrhNYlA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48126)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLwgw-0002Ew-Jr; Fri, 03 Sep 2021 01:04:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLwgt-0008MM-Av; Fri, 03 Sep 2021 01:04:19 +0100
Date:   Fri, 3 Sep 2021 01:04:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210903000419.GR22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
 <20210902232607.v7uglvpqi5hyoudq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902232607.v7uglvpqi5hyoudq@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 02:26:07AM +0300, Vladimir Oltean wrote:
> On Fri, Sep 03, 2021 at 01:02:06AM +0200, Andrew Lunn wrote:
> > We should try to keep phylink_create and phylink_destroy symmetrical:
> > 
> > /**
> >  * phylink_create() - create a phylink instance
> >  * @config: a pointer to the target &struct phylink_config
> >  * @fwnode: a pointer to a &struct fwnode_handle describing the network
> >  *      interface
> >  * @iface: the desired link mode defined by &typedef phy_interface_t
> >  * @mac_ops: a pointer to a &struct phylink_mac_ops for the MAC.
> >  *
> >  * Create a new phylink instance, and parse the link parameters found in @np.
> >  * This will parse in-band modes, fixed-link or SFP configuration.
> >  *
> >  * Note: the rtnl lock must not be held when calling this function.
> > 
> > Having different locking requirements will catch people out.
> > 
> > Interestingly, there is no ASSERT_NO_RTNL(). Maybe we should add such
> > a macro.
> 
> In this case, the easiest might be to just take a different mutex in
> dpaa2 which serializes all places that access the priv->mac references.
> I don't know exactly why the SFP bus needs the rtnl_mutex, I've removed
> those locks and will see what fails tomorrow, but I don't think dpaa2
> has a good enough justification to take the rtnl_mutex just so that it
> can connect and disconnect to the MAC freely at runtime.

It needs it to ensure that the sfp-bus code is safe. sfp-bus code
sits between phylink and the sfp stuff, and will be called from
either side. It can't have its own lock, because that gives lockdep
splats.

Removing a lock and then running the kernel is a down right stupid
way to test to see if a lock is necessary.

That approach is like having built a iron bridge, covered it in paint,
then you remove most the bolts, and then test to see whether it's safe
for vehicles to travel over it by riding your bicycle across it and
declaring it safe.

Sorry, but if you think "remove lock, run kernel, if it works fine
the lock is unnecessary" is a valid approach, then you've just
disqualified yourself from discussing this topic any further.
Locking is done by knowing the code and code analysis, not by
playing "does the code fail if I remove it" games. I am utterly
shocked that you think that this is a valid approach.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
