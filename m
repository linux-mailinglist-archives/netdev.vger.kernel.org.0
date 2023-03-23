Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEA06C6223
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCWIms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjCWImc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:42:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AF210420;
        Thu, 23 Mar 2023 01:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fwpxPxavMF9pRmW3FZBqnX/hq3q3T11OticmIkCRIgg=; b=J7BaWbJwUn8sQUJ4PD5uq/rdgK
        Bzepqzx5FM96OjmF4BoxIYszCLkFgctwfqNz0/buly/c/pscWaE4YgPDtrmPtD+oYnSEZ6tQ6sNeS
        Zh+HV8SnEwdD9P9GTFK6lsUWc4JhZBZJtrIXXOI0a9qzYCBSbaruPJ6tfWTTuviCoACvbkX68DkLZ
        jzHhBxJJ2aKg3fugMVkp5ZvH6gTEp1vmmovn4ckb0Z8F3v/18StlZEiL3dZ3LRdusNO6XdeEY1hv6
        Ua6Xb8exG17QAs4Jr9FiFGz6DsSLEjOilIjDY5F3odm+i8pKDl3P/Z2s5IaD1nfkGUjlFlI/YwdLd
        JDvDMcKQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53138)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pfGVQ-0004i1-U6; Thu, 23 Mar 2023 08:41:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pfGVN-0001F1-HO; Thu, 23 Mar 2023 08:41:05 +0000
Date:   Thu, 23 Mar 2023 08:41:05 +0000
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
Message-ID: <ZBwQoU4Mw6egvCEl@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
 <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
 <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
 <8133635f-8d19-4899-83e2-0bf9b7b644b2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8133635f-8d19-4899-83e2-0bf9b7b644b2@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 10:40:26PM +0100, Andrew Lunn wrote:
> > What I'm trying to find out is what you think the behaviour should be
> > in this case. Are you suggesting we should fall back to what we do now
> > which is let the driver do it internally without phylink.
> > 
> > The problem is that if we don't go down the phylink route for everything
> > then we /can't/ convert mv88e6xxx to phylink_pcs, because the "serdes"
> > stuff will be gone, and the absence of phylink will mean those won't be
> > called e.g. to power up the serdes.
> 
> I'm pretty sure non-DT systems have never used SERDES. They are using
> a back to back PHY, or maybe RGMII. So long as this keeps working, we
> can convert to phylink.
> 
> And i have such a amd64 system, using back to back PHYs so i can test
> it does not regress.

Reading the code, I don't think we have any issue with the DSA and CPU
ports, as these check whether dp->dn is not NULL before calling
dsa_shared_port_link_register_of() and the validator. This means these
paths will only be used for setups that have DT.

For the user ports, we can end up calling dsa_port_phylink_create()
with a NULL dp->dn, and must not fail.

So, given that this is only supposed to be used for mv88e6xxx because
of it's legacy, maybe the check in dsa_port_phylink_create() should
be:

        fwnode = of_fwnode_handle(dp->dn);
        if (fwnode && ds->ops->port_get_fwnode) {

In other words, we only allow the replacement of the firmware
description if one already existed.

Alternatively, we could use:

	if (!dsa_port_is_user(dp) && ds->ops->port_get_fwnode) {

since mv88e6xxx today only does this "max speed" thing for CPU and
DSA ports, and thus we only need to replace the firmware description
for these ports - and we can document that port_get_fwnode is only
for CPU and DSA ports.

Hmm?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
