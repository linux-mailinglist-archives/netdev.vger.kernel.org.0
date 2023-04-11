Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD26DDC0C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjDKN1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDKN1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:27:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791DB49DC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6S2NHl0BvfAqpSaFGFaK37SJl+MkwL7+Z0/B+3QKwcI=; b=cqExamOdYyp/gEiDFSv8HjT5E4
        LED8QXoW1KQpC43Epi9E7oz1BUV5D6+YEqvSUYDhbxnkR6cnl43nAihhJLXuTfa/MVbPeJqI+LMON
        TxUFXjDYeb4Qjt0vAa9GYqJLJH4ceYjYjAbHHHeyvu9YUgAiHqnKz3wu2BjG5OL8DFrcP+KsrF+xy
        MsUHDUO4FjR7B2sJ/+LV45FgTyG4my8Q28LY9cJw3sKp77sldFNoq3g0TiXBfSpIFc9Nguug9mPvi
        Wi7YiwCLWf5lG9n4FJfVt3arNvi1agH706UG0BoL1Aq5cfx9MbEUFgRl0e7duEdwYjFp+2VhUQRt9
        424F28mA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55720)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmE1P-0005ws-AM; Tue, 11 Apr 2023 14:26:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmE1N-000495-A9; Tue, 11 Apr 2023 14:26:53 +0100
Date:   Tue, 11 Apr 2023 14:26:53 +0100
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
Message-ID: <ZDVgHbF0IZV/v2D4@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <ZDVJhN4vyK9ldurD@shell.armlinux.org.uk>
 <20230411131215.gt3lxq7ldaox3cfd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411131215.gt3lxq7ldaox3cfd@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 04:12:15PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 11, 2023 at 12:50:28PM +0100, Russell King (Oracle) wrote:
> > On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> > > On Tue, Apr 11, 2023 at 10:17:47AM +0100, Russell King (Oracle) wrote:
> > > > Since we can't manually control the tx and rx pause enables, I think
> > > > the only sensible way forward with this would be to either globally
> > > > disable pause on the device, and not report support for any pause
> > > > modes,
> > > 
> > > This implies restarting autoneg on all the other switch ports when one
> > > port's flow control mode is changed?
> > 
> > From my reading of these global register descriptions, no it doesn't,
> > and even if we did restart aneg, it would have no overall system effect
> > because the advertisements for each port haven't been changed. It's
> > mad hardware.
> > 
> > What I was meaning above is that we configure the entire switch to
> > either do autonegotiated flow control at setup time, or we configure
> > the switch to never do flow control.
> 
> I was thinking you were suggesting to also modify the advertisement in
> software from those other ports to 00 when the flow control was forced
> off on one. Otherwise (it seems you weren't), I think it's a bit
> counter-productive to configure the switch to never do flow control,
> when the only problem seems to be with the forced modes but autoneg is fine.

As I see it, there's essentially two possible options with this
hardware:

1. treat the switch as something that can negotiate pause modes.
2. treat the switch as something that doesn't support pause modes.

You are absolutely right that if (1) then its possible through the
advertisement to have (2) but the reverse is not true, so clearly
(1) is the better approach here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
