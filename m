Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD67619555
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiKDLY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiKDLYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:24:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0832B199
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GB/esQIKHmGf0biwlVHerM2XyaCQgmWfe0zE5BD7I0w=; b=GWf0VPdERxJwcCRyJWop6lSyel
        A5qdjPqrJXsFHkwwqQEHnC4gMGmXCeo8AwViDSunfElWDSWYQEGB0+rj2eQK02lVBqeIdMeCNRl+/
        oT+1QTVXhJBX0sKMNUdIkOm9apzzkrQwR4WGKARsCmQGp8ETFiLcUgwK3cKEKtBACYYW9e2cQXcNv
        0SSxUeE0rRPQG7q1hOyeQDXn3V8qWKdXI0M2yl7arxVG7zuQ4aoqJdzjaHE7MUEnOjXFMnAiUqzu7
        oa+tH5CRvVTzn5EW2ksiYrV0xH25LqRYUgtAPr9cypkEYR+CUy48U+Onk/i/v6NEsqivCsB8Q/yDJ
        HtonTtXw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35102)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oquoY-0007VD-Vh; Fri, 04 Nov 2022 11:24:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oquoW-0000qa-1k; Fri, 04 Nov 2022 11:24:44 +0000
Date:   Fri, 4 Nov 2022 11:24:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101114806.1186516-5-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> As of now, all DSA drivers use phylink_generic_validate() and there is
> no known use case remaining for a driver-specific link mode validation
> procedure. As such, remove this DSA operation and let phylink determine
> what is supported based on config->mac_capabilities, which all drivers
> provide.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Not all DSA drivers provide config->mac_capabilities, for example
> mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> those drivers on recent kernels and no one reported that they fail to
> establish a link, so I'm guessing that they work (somehow). But I must
> admit I don't understand why phylink_generic_validate() works when
> mac_capabilities=0. Anyway, these drivers did not provide a
> phylink_validate() method before and do not provide one now, so nothing
> changes for them.

There is one remaining issue that needs to be properly addressed,
which is the bcm_sf2 driver, which is basically buggy. The recent
kernel build bot reports reminded me of this.

I've tried talking to Florian about it, and didn't make much progress,
so I'm carrying a patch in my tree which at least makes what is
provided to phylink correct.

See
http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=63d77c1f9db167fd74994860a4a899df5c957aab
and all the FIXME comments in there.

This driver really needs to be fixed before we kill DSA's
phylink_validate method (although doing so doesn't change anything
in mainline, but will remove my reminder that bcm_sf2 is still
technically broken.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
