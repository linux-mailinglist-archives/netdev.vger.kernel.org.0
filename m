Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55BF57DC5B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbiGVI2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiGVI2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:28:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA20E9E7BB;
        Fri, 22 Jul 2022 01:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QLrh58h0nH62BcjtmQ41KjLQPmjdtK+wuA23xz7N7Hw=; b=wsRSlcIAm96BOcQgLoUB1Rctu2
        VBvN2i39dm3Ox8/A0Yp5X1vGD91EmGSLTKOHblCmqU5/xDBPgUOTKJM412jiv9Mc3uoiBtx6wIPcF
        kPsBKQ1a4Yq/tTceiU+BVYHrdteMgM6Gvgul/SdgEXyzR+yxf/pDrhsybKU+9e4Y5RYwjnLhLJFNt
        VzaMxKujLy+vHa/Q+G97cFtGMYvlR3o+cfVkg9NT7jVzfsl6dzA0/8/nyDGoledVIBOLOzkHuSvay
        Xb0DtU7O5t5PRtmZswmXYddAOjMvGMPmWanKfzqzlY6HueuQnXOzeEP8ADNh/d5Oc8+3hph6uLDd8
        dLHKR4aQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33500)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEo18-0006dm-6X; Fri, 22 Jul 2022 09:28:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEo12-0005g7-KG; Fri, 22 Jul 2022 09:28:08 +0100
Date:   Fri, 22 Jul 2022 09:28:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
References: <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721213645.57ne2jf7f6try4ec@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 12:36:45AM +0300, Vladimir Oltean wrote:
> On Thu, Jul 21, 2022 at 10:14:00PM +0100, Russell King (Oracle) wrote:
> > > > So currently we try to enable C37 AN in 2500base-x mode, although
> > > > the standard says that it shouldn't be there, and it shouldn't be there
> > > > presumably because they want it to work with C73 AN.
> > > > 
> > > > I don't know how to solve this issue. Maybe declare a new PHY interface
> > > > mode constant, 2500base-x-no-c37-an ?
> > > 
> > > So this is essentially what I'm asking, and you didn't necessarily fully
> > > answer. I take it that there exist Marvell switches which enable in-band
> > > autoneg for 2500base-x and switches which don't, and managed = "in-band-status"
> > > has nothing to do with that decision. Right?
> > 
> > I think we're getting a little too het up over this.
> 
> No, I think it's relevant to this patch set.
> 
> > We have 1000base-X where, when we're not using in-band-status, we don't
> > use autoneg (some drivers that weren't caught in review annoyingly do
> > still use autoneg, but they shouldn't). We ignore the ethtool autoneg
> > bit.
> > 
> > We also have 1000base-X where we're using in-band-status, and we then
> > respect the ethtool autoneg bit.
> > 
> > So, wouldn't it be logical if 2500base-X were implemented the same way,
> > and on setups where 2500base-X does not support clause 37 AN, we
> > clear the ethtool autoneg bit? If we have 2500base-X being used as the
> > media link, surely this is the right behaviour?
> 
> The ethtool autoneg bit is only relevant when the PCS is the last thing
> before the medium. But if the SERDES protocol connects the MAC to the PHY,
> or the MAC to another MAC (such as the case here, CPU or DSA ports),
> there won't be any ethtool bit to take into consideration, and that's
> where my question is. Is there any expected correlation between enabling
> in-band autoneg and the presence or absence of managed = "in-band-status"?

This topic is something I was looking at back in November 2021, trying
to work out what the most sensible way of indicating to a PCS whether
it should enable in-band or not:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e4ea7d035e7e04e87dfd86702f59952e0cecc18d
http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e454bf101fa457dd5c2cea0b1aaab7ba33048089
http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e2c57490f205ae7c0e11fcf756675937f933be5e

The intention there was to move the decision about whether a PCS should
enable autoneg out of the PCS and into phylink, but doing that one comes
immediately on the problem of (e.g.) Marvell NETA/PP2 vs Lynx having
different interpretations for 2500base-X. There are also a number of
drivers that do not follow MLO_AN_INBAND-means-use-inband or not for
things such as SGMII or 1000base-X.

This means we have no standard interpretation amongst phylink users
about when in-band signalling should be enabled or disabled, which
means moving that decision into phylink today isn't possible.

The only thing we could do is provide the PCS with an additional bit
of information so it can make the decision - something like a boolean
"pcs_connects_to_medium" flag, and keep the decision making in the
PCS-specific code - sadly keeping the variability between different
PCS implementations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
