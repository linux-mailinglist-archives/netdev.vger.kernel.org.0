Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654026C58E7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCVVkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCVVkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:40:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4D7199F4;
        Wed, 22 Mar 2023 14:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mXn32usbY28qXPL0LwDEOekJLLI9JaFaQBFZx7OMuL0=; b=ds7awKF4RofwkKR+dt/AQHBwQJ
        x6mwEW7R+FBAE4JhN7h0quMs6tscOWbbdEgOhTkczrNJap2IiKuqOG5lUotDYQbQooNjDA7XgQYH3
        IKcXwTkRZ3BbmBMzpHI4OYqigmrfI+SoN203mBKEm234BfGYCvCkHln1QFCeTpoklaNo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pf6C3-0087SM-00; Wed, 22 Mar 2023 22:40:27 +0100
Date:   Wed, 22 Mar 2023 22:40:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <8133635f-8d19-4899-83e2-0bf9b7b644b2@lunn.ch>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
 <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
 <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I'm trying to find out is what you think the behaviour should be
> in this case. Are you suggesting we should fall back to what we do now
> which is let the driver do it internally without phylink.
> 
> The problem is that if we don't go down the phylink route for everything
> then we /can't/ convert mv88e6xxx to phylink_pcs, because the "serdes"
> stuff will be gone, and the absence of phylink will mean those won't be
> called e.g. to power up the serdes.

I'm pretty sure non-DT systems have never used SERDES. They are using
a back to back PHY, or maybe RGMII. So long as this keeps working, we
can convert to phylink.

And i have such a amd64 system, using back to back PHYs so i can test
it does not regress.

    Andrew
