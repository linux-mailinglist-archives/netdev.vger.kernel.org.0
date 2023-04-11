Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363006DDA32
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDKMAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjDKMAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:00:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE1F30C8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gOC6ChiXHuU7FsyERkq8NMPzJW8fRVvn6fROASOvir8=; b=oTLOCafLHeZekDBgr2cPEWyhxj
        0qA9bWXKDtIA9YFDIIPWDzNjebkCUaUAGUdjL39zVFeYpfUB4GmhWlRAWK+y9OZNR/lavFgKLwKLP
        /K83bWyL8Vn+vVv8lYd1DYU+g21FRRu3tqhQ1e2i6R4Kw0wCRxp8sF3/u8NdfQu99BtImdSRnVj05
        mqX/7Q2TWijQQsuLW50f6VfDSQrIxZXeVVH2E7zJdI3z43NX2fFM0JzwZziRc2sqLcrpWArQemEJX
        oK3Nyh1vwq4hdry+Wg9dNPZUlVvDPeutjlMXxOnpEubRATyRKM95aBjwfDoq6GRDz9ma1Y3FfY0YO
        29cHjSbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41474)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmCg0-0005rl-DM; Tue, 11 Apr 2023 13:00:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmCfz-00045u-3L; Tue, 11 Apr 2023 13:00:43 +0100
Date:   Tue, 11 Apr 2023 13:00:43 +0100
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
Message-ID: <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <20230411113516.ez5cm4262ttec2z7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411113516.ez5cm4262ttec2z7@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:35:16PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> > I may have missed something.
> 
> Maybe I'm wrong, but my blind intuition says that when autoneg is
> disabled in the integrated PHYs, flow control _is_ by default forced off
> per port, unless the "Force Flow Control" bit from Port N Control 2
> registers is set. So that can be used to still support:
> - ethtool --pause swp0 autoneg off rx on tx on
> - ethtool --pause swp0 autoneg off rx off tx off
> - ethtool --pause swp0 autoneg on # asymmetric RX/TX combinations depend upon autoneg
> 
> I may be wrong; I don't have the hardware and the ethtool pause autoneg
> bit is not 100% clear to me.

Stage 1 (per port, force bit):
- If zero, the flow control result from aneg is used, and thus depends on
  what both ends advertise.
- If one, flow control is force-enabled.

Stage 2 (global):
Transmit and receive flow control can be masked off.

Basically, the best we could do is:

	ethtool --pause ... autoneg on

depends on the negotiation result (correct).

	ethtool --pause ... autoneg off rx off tx off

if we *only* program the local advertisement to 00, but leave the
force bit as 0, then this can work.

	ethtool --pause ... autoneg off rx on tx on

if we program the force bit to 1, then this can work, and it doesn't
matter what we do with the advertisement.

Anything else wouldn't give the result the user wants, because there's
no way to independently force rx and tx flow control per port.

That said, phylink doesn't give enough information to make the above
possible since the force bit depends on (tx && rx &&!permit_pause_to_mac)

So, because this hardware is that crazy, I suggest that it *doesn't*
even attempt to support ethtool --pause, and either is programmed
at setup time to use autonegotiated pause (with the negotiation state
programmed via ethtool -s) or it's programmed to have pause globally
disabled. Essentially, I'm saying the hardware is too broken in its
design to be worth bothering trying to work around its weirdness.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
