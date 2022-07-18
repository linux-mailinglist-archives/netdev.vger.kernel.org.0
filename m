Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E17578921
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiGRSBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbiGRSBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:01:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4912E6A1;
        Mon, 18 Jul 2022 11:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fvDvYNh033IOlQjqYKmG7DkfegtAnkMbbjHUTcpexCw=; b=Mkf+EnOO5lL4TN07vG/v1CkFSK
        O9h2x7xk2EK3aIgRnG4AwBANgxMawFV8s5A/9WP9DRo8lxNkhDCVrYA8ELqmaZyJ9O/BfhdRQ8l6Z
        yzkVB5uAXV5KRLG28A3gtiEPabNpKDH28R8EPRrlO2YFRtqcZO5N+HVYxUYzl3FSi9Dw/olJPlqwn
        1Uc5OlexNfAlnU+PPOKLHFEMxTV+gZwXCPmw2oDdrRPJdxVH1xo7cYn/P3YEreDdQ/UUGAfPOjLbe
        7HlNRrEailyn6mm3h1EYu94Ii94VpJE9o4I+1ly4EGFJE00+eo1I7vwrZWPfmm5icIJGiT2O3qSB4
        jDzo7BsQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33428)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDV3j-0001xD-MR; Mon, 18 Jul 2022 19:01:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDV3i-0002A1-Oo; Mon, 18 Jul 2022 19:01:30 +0100
Date:   Mon, 18 Jul 2022 19:01:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
Message-ID: <YtWf+u7GP2bQzNwv@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com>
 <YtMaKWZyC/lgAQ0i@lunn.ch>
 <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
 <b1c3fc9f-71af-6610-6f58-64a0297347dd@seco.com>
 <YtWYWhAm/n5mnw4I@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWYWhAm/n5mnw4I@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 07:28:58PM +0200, Andrew Lunn wrote:
> > > I am rather worried that we have drivers using ->speed today in their
> > > mac_config and we're redefining what that means in this patch.
> > 
> > Well, kind of. Previously, interface speed was defined to be link speed,
> > and both were just "speed". The MAC driver doesn't really care what the
> > link speed is if there is a phy, just how fast the phy interface mode
> > speed is.
> 
> I'm not sure that is true. At least for SGMII, the MAC is passed the
> line side speed, which can be 10, 100, or 1G. The PHY interface mode
> speed is fixed at 1G, since it is SGMII, but the MAC needs to know if
> it needs to repeat symbols because the line side speed is lower than
> the host side speed.

... and passing the SGMII link speed (1G) will break a lot of stuff
where the MAC/PCS may need to know the media speed to do the right
number of symbol replication.

So I don't think we can get away with just saying ->speed is the link
speed which will prevent drivers breaking. I don't think it's that
simple. Like everything with phylink, all the drivers need to be looked
at and tweaked with every damn change, which makes phylink development
painfully slow.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
