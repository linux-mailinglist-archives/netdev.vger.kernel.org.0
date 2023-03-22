Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFE56C57AC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjCVUdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjCVUcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:32:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7497DFB1;
        Wed, 22 Mar 2023 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FJqzfMELp3aHXabyFcLYx72JXlBinAe4aH0QSo1TiCY=; b=qPJARAFsrEBJcdOL+b8XAAK0Y1
        zgzx827W7EHC5/g91D9yTxbgW78sCRyfyl6ZZQJsIBdA8dsAkZT2QEndVkOtLxw7OI0DFWUbQBIKl
        r/fMA2vyanj/lPjGvQdL5e5FIQ7bVNTYGEZ8USCv+sOxDQEd0hcO0doXkd/pop79Rn/lPX8+p/54l
        J2xFFLyod3UwvBPcKuoulukpxXXI/d0x1jSQswr1aKgaIAmMyHRzLPSEyxhbUzU3x0PW4HC2alHc5
        cO+O64saW+Ivt8Nq9L6ck6cW0sJ73aIcSJD3c3GEfMcEStGXXTdtHixz+vaJZneXiTNJwp5wSII6j
        4vu7G6BA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42306)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pf4lo-0003qQ-Ao; Wed, 22 Mar 2023 20:09:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pf4lk-0000de-SY; Wed, 22 Mar 2023 20:09:12 +0000
Date:   Wed, 22 Mar 2023 20:09:12 +0000
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
Subject: Re: [PATCH RFC net-next 5/7] net: dsa: avoid DT validation for
 drivers which provide default config
Message-ID: <ZBtgaAGkqQ7JVvoP@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8a-00Dvo3-G7@rmk-PC.armlinux.org.uk>
 <db06c9d7-9ad7-42f0-9b40-6e325f6bcc62@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db06c9d7-9ad7-42f0-9b40-6e325f6bcc62@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 07:51:22PM +0100, Andrew Lunn wrote:
> On Wed, Mar 22, 2023 at 12:00:16PM +0000, Russell King (Oracle) wrote:
> > When a DSA driver (e.g. mv88e6xxx) provides a default configuration,
> > avoid validating the DT description as missing elements will be
> > provided by the DSA driver.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  net/dsa/port.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index c30e3a7d2145..23d9970c02d3 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -1951,6 +1951,9 @@ static void dsa_shared_port_validate_of(struct dsa_port *dp,
> >  	*missing_phy_mode = false;
> >  	*missing_link_description = false;
> >  
> > +	if (dp->ds->ops->port_get_fwnode)
> > +		return;
> 
> I wounder if you should actually call it for the given port, and
> ensure it does not return -EOPNOTSUPP, or -EINVAL, etc, because it is
> not going to override that port? Then the DT values should be
> validated?

Won't that mean that we need to implement the method for all DSA
drivers?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
