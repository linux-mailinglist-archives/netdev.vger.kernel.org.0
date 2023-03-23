Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29C6C6B03
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjCWObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCWObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:31:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8021EBFA;
        Thu, 23 Mar 2023 07:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zoc3J9NgFLjB0ATS9BzpKxrQklksXAoihpHo0uKZNK8=; b=l1oXk9uDrL7IzexBx75aiGsTnq
        fuHmFr/Oel9UZMyfBQZCE+cDPz49mzU/BUp0TwKLdUEnkp/cGxO4HzCPvrYLg34ondRmWRGsF/68Z
        JfJXSqh12urdSETl2ymm3kdxxYsai/LhTKE06NPmhZJmdPRvoVYIJbA7r3zFqrHq4sJNHWAxvrnDr
        uk9bAaVj/wfFuCP/uZVuKj+kOTCY7j9OA4U1+WGrxUJ04oV9zgeb6FvgcyFjMRgfSigV32mzDx5OY
        S+m9NjGy36jQvu45TnPwa0JKTvW2XAz10jjLs/1RWw754RTM2JgEOzFcbD7aQjwIiM6MgZKIkUFdF
        myl7DUQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35276)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfLy5-0005GV-9I; Thu, 23 Mar 2023 14:31:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfLy4-0001Rx-F9; Thu, 23 Mar 2023 14:31:04 +0000
Date:   Thu, 23 Mar 2023 14:31:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:
> > In preparation for supporting the use of software nodes to setup
> > phylink, switch DSA to use fwnode_get_phy_mode() to retrieve the
> > phy interface mode, rather than using of_get_phy_mode() which is
> > DT specific.
> 
> ...
> 
> > +	struct fwnode_handle *fwnode;
> 
> > +	fwnode = of_fwnode_handle(dp->dn);
> 
> 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> 
> ?

Why const?

Why do you want it on one line? The code as written conforms to
netdev coding standards which as you well know are different from
the rest of the kernel.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
