Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E066DDA10
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjDKLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjDKLul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:50:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37560A3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OZ8fzCDBpazBx4KekvkPk2PcMMqzCkGuS3ndPi7+gXc=; b=BKv1iNPwZqr4byZp/AQeGh46ew
        U8hYhbfxbdxkLROxi4dMWMv5kqgP+7mHnQHtHo839Qb9NAQBs8yxtqOOcW46oukRxQIalbjyXZDmn
        fnwXB0lioB4jMkQz5XjLZ4CEo1PkUuj9M6K03bFwO0px5Mmo56uSGjjtE8LFvpnCcROwbITbel6Lj
        jvtlmDhr7tZUOgYmfbpRk4ZPdKcj7b1HDbrdXX+vJXkRvTp6aTS2EhHW7jLw1bCflYVkPqS9W2xiO
        3m0XGHxxqi2vkIm12uZF9MdK3KgKAON8LpHMni3W1iWSEQeyglv5dfUULkmNWzvrNY+ei5oAUl2cy
        U/L8nsGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57752)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmCW7-0005rC-Mq; Tue, 11 Apr 2023 12:50:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmCW4-00045S-Ne; Tue, 11 Apr 2023 12:50:28 +0100
Date:   Tue, 11 Apr 2023 12:50:28 +0100
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
Message-ID: <ZDVJhN4vyK9ldurD@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411111609.jhfcvvxbxbkl47ju@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 11, 2023 at 10:17:47AM +0100, Russell King (Oracle) wrote:
> > Since we can't manually control the tx and rx pause enables, I think
> > the only sensible way forward with this would be to either globally
> > disable pause on the device, and not report support for any pause
> > modes,
> 
> This implies restarting autoneg on all the other switch ports when one
> port's flow control mode is changed?

From my reading of these global register descriptions, no it doesn't,
and even if we did restart aneg, it would have no overall system effect
because the advertisements for each port haven't been changed. It's
mad hardware.

What I was meaning above is that we configure the entire switch to
either do autonegotiated flow control at setup time, or we configure
the switch to never do flow control.

> > or report support for all pause modes, advertise '11' and
> > let the hardware control it (which means the ethtool configuration
> > for pause would not be functional.)
> > 
> > This needs to be commented in the driver so that in the future we
> > remember why this has been done.
> > 
> > Maybe Andrew and/or Vladimir also have an opinion to share about the
> > best approach here?
> 
> I don't object to documenting that manually forcing flow control off is
> broken and leaving it at that (and the way to force it off would be to
> not advertise any of the 2 bits).
> 
> But why advertise only 11 (Asym_Pause | Pause) when the PHYs integrated
> here have the advertisement configurable (presumably also through the
> micrel.c PHY driver)? They would advertise in accordance with ethtool, no?
> 
> I may have missed something.

I think you have. I'm only talking about the ability to control flow
control manually via ethtool -A. Changing it via the advertisement
(ethtool -s) would still work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
