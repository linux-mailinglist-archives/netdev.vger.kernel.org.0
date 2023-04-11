Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3636DDC1F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDKNdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDKNdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:33:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6E335B3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1IgoBJ4vDO/ax/MPew7OVysBajZgiajTs+DJ60W5huM=; b=lS15DPzsm0mV70oW+P7CSGyjdd
        yEPiOGeibDJj/Oh3luerS17jnUWEqz3/orWIIOc9E/gOjKXSqYM9leom7IUr6JMzCjyyq4iuyJjhA
        EfgyMCeNWeKsUn2QbgswZBKQnGMRtG8zlj/xt4x/iNq57acsrnkCRR3I8Ycn1yGPZIJEPp9j0Bli3
        UMl81xmH8UAdUJBqnj69q2eI4quJuZqrnO6cIQ3yLVHbE1VJ2TcluOFo97vy9iRzwhFR3a8jWqS2P
        NgoQDX8jwbLk0DB2mFzIWUoUSXX/XPwt8zCobDONJByY7wUAEl/uc3uWThPgS9HPlN+xNezxAlYXV
        X2T76Tuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45694)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmE7J-0005xK-6m; Tue, 11 Apr 2023 14:33:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmE7I-00049C-2W; Tue, 11 Apr 2023 14:33:00 +0100
Date:   Tue, 11 Apr 2023 14:33:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <ZDVhjJgEUz7XCdBC@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <20230411113516.ez5cm4262ttec2z7@skbuf>
 <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
 <20230411132617.nonvvtll7xxvadhr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411132617.nonvvtll7xxvadhr@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 04:26:17PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 11, 2023 at 01:00:43PM +0100, Russell King (Oracle) wrote:
> > 	ethtool --pause ... autoneg on
> > 	ethtool --pause ... autoneg off rx off tx off
> > 	ethtool --pause ... autoneg off rx on tx on
> > 
> > Anything else wouldn't give the result the user wants, because there's
> > no way to independently force rx and tx flow control per port.
> 
> Right.
> 
> > That said, phylink doesn't give enough information to make the above
> > possible since the force bit depends on (tx && rx &&!permit_pause_to_mac)
> 
> So, since the "permit_pause_to_mac" information is missing here, I guess
> the next logical step based on what you're saying is that it's a matter
> of not using the pcs_config() API, or am I misunderstanding again? :)

pcs_config() doesn't get the "tx" and "rx" above. mac_link_up() does,
but doesn't get the "permit_pause_to_mac" (since that's supposed to
be a "configuration" thing.)

Anyway, I think this is now moot since I think we've agreed on a way
forward for this hardware.

> > So, because this hardware is that crazy, I suggest that it *doesn't*
> > even attempt to support ethtool --pause, and either is programmed
> > at setup time to use autonegotiated pause (with the negotiation state
> > programmed via ethtool -s) or it's programmed to have pause globally
> > disabled. Essentially, I'm saying the hardware is too broken in its
> > design to be worth bothering trying to work around its weirdness.
> 
> Ok. How can this driver reject changes made through ethtool --pause?

We would need either something in DSA (dsa_slave_set_pauseparam()) to
prevent success, or something in phylink_ethtool_set_pauseparam() to
do the same.

At the phylink level, that could be a boolean in struct phylink_config.
Something like "disable_ethtool_set_pauseparam" (I'd prefer something
a tad shorter) which if set would make phylink_ethtool_set_pauseparam()
return -EOPNOTSUPP.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
