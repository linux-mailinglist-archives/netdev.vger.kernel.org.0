Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278686C6AEF
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCWO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCWO3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:29:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B549756;
        Thu, 23 Mar 2023 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lxEWxpzOY4LJygvTGhMtmdDomHrkMWj+mRCVORlP7MM=; b=oWIULdi7Ub0sSWYxf1dm4bhvgm
        X3lvYtpFVGQH0FQM3ZEZkuErNQhyF29b1LbRA+A4V9m4jI78+oaZMpo+6XH8suQWZeb6APsQGLDXN
        vhjn32TAfIZ+R+mRIpJSzeCdojeO8PaD9uUBTBfiqJVEZTXrN6D9LijTq8+Hc5gUmkdt8omqByAly
        fSDf9XSRbCGnixBiy5TVDHfW8/gl0vNcFbbxLTEQ0pSEpLvQ8OY+YdMXm2y1nT/CrS/MXw0ZXiKGv
        tCn1EbhPQNcDHt9X5xD2Kzyhmcz+3NKSXYGdWU1zGvcPTyf9ZxOwovA1Z60TSffCn5+9PUgjlfEzb
        xAcnGCsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50744)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfLwW-0005G3-EE; Thu, 23 Mar 2023 14:29:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfLwS-0001Rp-Ts; Thu, 23 Mar 2023 14:29:24 +0000
Date:   Thu, 23 Mar 2023 14:29:24 +0000
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
Subject: Re: [PATCH RFC net-next 1/7] software node: allow named software
 node to be created
Message-ID: <ZBxiRJXMqjrOl9TE@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8F-00Dvnf-Sm@rmk-PC.armlinux.org.uk>
 <ZBxbKxAcAKznIVJ2@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxbKxAcAKznIVJ2@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 03:59:07PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 22, 2023 at 11:59:55AM +0000, Russell King wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Allow a named software node to be created, which is needed for software
> > nodes for a fixed-link specification for DSA.
> 
> ...
> 
> > +fwnode_create_named_software_node(const struct property_entry *properties,
> > +				  const struct fwnode_handle *parent,
> > +				  const char *name)
> >  {
> >  	struct fwnode_handle *fwnode;
> >  	struct software_node *node;
> > @@ -930,6 +931,7 @@ fwnode_create_software_node(const struct property_entry *properties,
> >  		return ERR_CAST(node);
> >  
> >  	node->parent = p ? p->node : NULL;
> > +	node->name = name;
> 
> The same question stays as before: how can we be sure that the name is unique
> and we won't have a collision?

This got discussed at length last time around, starting here:

https://lore.kernel.org/all/YtHGwz4v7VWKhIXG@smile.fi.intel.com/

My conclusion is that your concern is invalid, because we're creating
this tree:

	node%d
	+- phy-mode property
	`- fixed-link node
	   +- speed property
	   `- full-duplex (optional) property

Given that node%d will be allocated against the swnode_root_ids IDA,
then how can there possibly be a naming collision.

You would be correct if the "fixed-link" node were to be created at
root level, or if we were intentionally creating two swnodes under
the same parent with the same name, but we aren't.

Plus, the code _already_ allows for e.g. multiple "node1" names - for
example, one in root and one as a child node, since the code uses
separate IDAs to allocate those.

Hence, I do not recognise the conern you are raising, and I believe
your concern is not valid.

Your concern would be valid if it was a general concern about
fwnode_create_named_software_node() being used to create the same
named node under the same parent, but that IMHO is a programming
bug, no different from trying to create two devices under the same
parent with the same name.

So, unless you can be more expansive about _precisely_ what your
concern is, then I don't think there exists any problem with this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
