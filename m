Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD626C7027
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCWSZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCWSZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:25:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17E1212B8;
        Thu, 23 Mar 2023 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wsJuB1mGkf26mbLdBUS/cSW1mH+r9hLTNZ2z3JvPoEc=; b=CP54IJuZeYCkONyPf8ZkSxVcgs
        mwVDrHGdsGXUzywTL1QO8ouL5KPl4OR9CBExXkJLXz7LRbVQ4pVjI0gfkt5Eq409yC7Ylq22V8plX
        SUzmaVqAaTekx8qFYtkFQmdQol4b2Vyh23sME7LEJDqmRyaidJDewDcJli2nAF4axbhiFwsGaGDzr
        vrk8lKm7z7Dqe0kct79AZU0XCvuGml+PUMul6nNGEg0XakpP4+s6S1SDCw4CCncpzqLbQtgQO4Hji
        OitU5BwNUEQL9d+Mz4/e1AV7mjcC6sRE3rHSNSqYUsgY7m4FNf79Qmfs3VYdzf9DtACYJiRyVl3+a
        MXwrax7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45254)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfPcw-0005dW-FL; Thu, 23 Mar 2023 18:25:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfPct-0001bd-TB; Thu, 23 Mar 2023 18:25:27 +0000
Date:   Thu, 23 Mar 2023 18:25:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZByZl181eQZ24nwd@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
 <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
 <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
 <8133635f-8d19-4899-83e2-0bf9b7b644b2@lunn.ch>
 <ZBwQoU4Mw6egvCEl@shell.armlinux.org.uk>
 <4ae939e1-8d11-4308-ace3-7e862f0bd24a@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ae939e1-8d11-4308-ace3-7e862f0bd24a@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:17:27PM +0100, Andrew Lunn wrote:
> > So, given that this is only supposed to be used for mv88e6xxx because
> > of it's legacy, maybe the check in dsa_port_phylink_create() should
> > be:
> > 
> >         fwnode = of_fwnode_handle(dp->dn);
> >         if (fwnode && ds->ops->port_get_fwnode) {
> > 
> > In other words, we only allow the replacement of the firmware
> > description if one already existed.
> 
> That sounds reasonable.
> 
> > Alternatively, we could use:
> > 
> > 	if (!dsa_port_is_user(dp) && ds->ops->port_get_fwnode) {
> > 
> > since mv88e6xxx today only does this "max speed" thing for CPU and
> > DSA ports, and thus we only need to replace the firmware description
> > for these ports - and we can document that port_get_fwnode is only
> > for CPU and DSA ports.
> 
> Also reasonable.
> 
> The first seems better for the Non-DT, where as the second makes it
> clear it is supposed to be for CPU and DSA ports only.
> 
> Is it over the top to combine them?

To be clear, you're suggesting:

	if (!dsa_port_is_user(dp) && fwnode && ds->ops->port_get_fwnode) {

?

If so, yes - you know better than I how these bits are supposed to work.
Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
