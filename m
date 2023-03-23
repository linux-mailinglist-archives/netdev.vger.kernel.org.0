Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937D16C6B7C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjCWOtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjCWOtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:49:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F4C113C0;
        Thu, 23 Mar 2023 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kq/ue7wGgTFGUzW69Vf2Bw/C+gOE5WPwtv5TM9ErifE=; b=g+x3wPOcQBmEbr/fo+Ii280r+c
        a3wpLw1a3jiqC0cxpflxZXhqL0DbumsUQe5xktkglhPjV6OCzcQ6TQ22rmAlUU5AzJKujiKGR1v8M
        16gbjuu7oP/ySSXvmJYBEysTkVBbZ8ehZRxKn4MeNTZbxdeYgUyogdFUn5ja3HGeCfdOzN++vPN+o
        U8nkZig0SA9qSelcKomk6jMGMTgu2zCH7oSo0hKY6sMl8BeWzyy/7VESZJIOeqqmUvQKKbGgQrBtg
        2BX+nNs8VeI22EA4teVmWekNzEs9/pGwBNILtWUFIH8J1/r9fUVlrlOczrV2zRn92ujieX+lqfm6U
        L6CxiQHw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45254)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfMFT-0005IM-CQ; Thu, 23 Mar 2023 14:49:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfMFR-0001T9-9Q; Thu, 23 Mar 2023 14:49:01 +0000
Date:   Thu, 23 Mar 2023 14:49:01 +0000
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
Message-ID: <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 04:38:29PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 23, 2023 at 02:31:04PM +0000, Russell King (Oracle) wrote:
> > On Thu, Mar 23, 2023 at 04:03:05PM +0200, Andy Shevchenko wrote:
> > > On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:
> 
> ...
> 
> > > > +	struct fwnode_handle *fwnode;
> > > 
> > > > +	fwnode = of_fwnode_handle(dp->dn);
> > > 
> > > 	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);
> > > 
> > > ?
> > 
> > Why const?
> 
> Do you modify its content on the fly?

Do you want to litter code with casts to get rid of the const?

> For fwnode as a basic object type we want to reduce the scope of the possible
> modifications. If you don't modify and APIs you call do not require non-const
> object, use const for fwnode.

Let's start here. We pass this fwnode to fwnode_get_phy_mode():

include/linux/property.h:int fwnode_get_phy_mode(struct fwnode_handle *fwnode);

Does fwnode_get_phy_mode() alter the contents of the fwnode? Probably
not, but it doesn't take a const pointer. Therefore, to declare my
fwnode as const, I'd need to cast the const-ness away before calling
this.

Then there's phylink_create(). Same problem.

So NAK to this const - until such time that we have a concerted effort
to making functions we call which do not modify the "fwnode" argument
constify that argument. Otherwise it's just rediculously crazy to
declare a variable const only to then litter the code with casts to get
rid of it at every call site.

Please do a bit of research before making suggestions. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
