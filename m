Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7257E04A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiGVKwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiGVKwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:52:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B11DBB5CE;
        Fri, 22 Jul 2022 03:52:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b11so7864407eju.10;
        Fri, 22 Jul 2022 03:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8oO26QITnNnz86jTpLQRTD9YzDTs7VLXexgBSlRwHW8=;
        b=p/OOE4XQLOM13YWrmmwgw2zQiMvYKy03p6tXdjfzGPP9/j5LMAaV75LLGPm+RScBR8
         oOw9mOH8U8y33OEINn1Kxq7vH7iZHahK32VGc1lX+hCSZlXIrs74ZKF2jluJcyDCo3lV
         IQxJhajObxzSSBtcD2ZtEzwJAsNn/FdUaNXvMvJ/jk6gCLKvDAgAt235+f43+ZS38JcK
         CfN78UoQsLe4QJSHq8qSg/WUAFw+y9CEEBnZcBn7BHaCmmUMyI6AGUIYOOAt8OBRS7Vr
         xYLqsDnco71hvjp2fvfZ/380oDiaBl9W1y7yPNjweEX2QIbEzQfXpLqiG4D/px0kIXhf
         ee2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8oO26QITnNnz86jTpLQRTD9YzDTs7VLXexgBSlRwHW8=;
        b=ACU4UHhHbIPdX5jDkbuDPDWFYPML9Kf3Y445dawnae8Atk9wGtTVk6tMBM8CsLWXx2
         QWjXLrI2mn70kPaKMZHn96RZeUpwKXbtLHwPlUMIe7cfylkPpMZgb1lRCyWvve8ON/vJ
         7cKIhRQaRalStGL0TOGLmEl2bLWtcRqQ6nwSKeaX/ZxhEeOFwl/PWt+1rIG5ASpSPrM4
         9gMqzJNGP2edTrkhE+u3f8mNOiOjM7rpZm2TiTv5UWBWoUcxweThLDy5o9/Ni1Kx839/
         bURK8NI/Wiq5vVohwXOV350ZYRFQUfsIc57oSZ06L0SBywmAm5r+dOHy038/2WWb+9DE
         1iEw==
X-Gm-Message-State: AJIora8rRUrjKJLfBgbnkOOurkg2JjBzVj5/SIBr8HjuEhyFtMjMq6Rg
        Udgnel6Fag+ggnoWWlTyNUY=
X-Google-Smtp-Source: AGRyM1uAPPwD5Kbel8STNYdBRwDBHKPie4uNrBswumP9eJWgNjHA2KuihxFqJZ1qh87OX5H/bHiPNw==
X-Received: by 2002:a17:907:2d12:b0:72b:67fb:89a5 with SMTP id gs18-20020a1709072d1200b0072b67fb89a5mr2635507ejc.507.1658487162635;
        Fri, 22 Jul 2022 03:52:42 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id bv4-20020a170906b1c400b0072f0dbaf2f7sm1854947ejb.214.2022.07.22.03.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 03:52:41 -0700 (PDT)
Date:   Fri, 22 Jul 2022 13:52:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
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
Message-ID: <20220722105238.qhfq5myqa4ixkvy4@skbuf>
References: <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 09:28:08AM +0100, Russell King (Oracle) wrote:
> On Fri, Jul 22, 2022 at 12:36:45AM +0300, Vladimir Oltean wrote:
> > On Thu, Jul 21, 2022 at 10:14:00PM +0100, Russell King (Oracle) wrote:
> > > > > So currently we try to enable C37 AN in 2500base-x mode, although
> > > > > the standard says that it shouldn't be there, and it shouldn't be there
> > > > > presumably because they want it to work with C73 AN.
> > > > > 
> > > > > I don't know how to solve this issue. Maybe declare a new PHY interface
> > > > > mode constant, 2500base-x-no-c37-an ?
> > > > 
> > > > So this is essentially what I'm asking, and you didn't necessarily fully
> > > > answer. I take it that there exist Marvell switches which enable in-band
> > > > autoneg for 2500base-x and switches which don't, and managed = "in-band-status"
> > > > has nothing to do with that decision. Right?
> > > 
> > > I think we're getting a little too het up over this.
> > 
> > No, I think it's relevant to this patch set.
> > 
> > > We have 1000base-X where, when we're not using in-band-status, we don't
> > > use autoneg (some drivers that weren't caught in review annoyingly do
> > > still use autoneg, but they shouldn't). We ignore the ethtool autoneg
> > > bit.
> > > 
> > > We also have 1000base-X where we're using in-band-status, and we then
> > > respect the ethtool autoneg bit.
> > > 
> > > So, wouldn't it be logical if 2500base-X were implemented the same way,
> > > and on setups where 2500base-X does not support clause 37 AN, we
> > > clear the ethtool autoneg bit? If we have 2500base-X being used as the
> > > media link, surely this is the right behaviour?
> > 
> > The ethtool autoneg bit is only relevant when the PCS is the last thing
> > before the medium. But if the SERDES protocol connects the MAC to the PHY,
> > or the MAC to another MAC (such as the case here, CPU or DSA ports),
> > there won't be any ethtool bit to take into consideration, and that's
> > where my question is. Is there any expected correlation between enabling
> > in-band autoneg and the presence or absence of managed = "in-band-status"?
> 
> This topic is something I was looking at back in November 2021, trying
> to work out what the most sensible way of indicating to a PCS whether
> it should enable in-band or not:
> 
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e4ea7d035e7e04e87dfd86702f59952e0cecc18d
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e454bf101fa457dd5c2cea0b1aaab7ba33048089
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e2c57490f205ae7c0e11fcf756675937f933be5e
> 
> The intention there was to move the decision about whether a PCS should
> enable autoneg out of the PCS and into phylink, but doing that one comes
> immediately on the problem of (e.g.) Marvell NETA/PP2 vs Lynx having
> different interpretations for 2500base-X. There are also a number of
> drivers that do not follow MLO_AN_INBAND-means-use-inband or not for
> things such as SGMII or 1000base-X.
> 
> This means we have no standard interpretation amongst phylink users
> about when in-band signalling should be enabled or disabled, which
> means moving that decision into phylink today isn't possible.
> 
> The only thing we could do is provide the PCS with an additional bit
> of information so it can make the decision - something like a boolean
> "pcs_connects_to_medium" flag, and keep the decision making in the
> PCS-specific code - sadly keeping the variability between different
> PCS implementations.

The way I understand what you're saying is that there is no guarantee
that the DSA master and CPU port will agree whether to use in-band
autoneg or not here (and implicitly, there is no guarantee that this
link will work):

	&eth0 {
		phy-mode = "2500base-x";
		managed = "in-band-status";
	};

	&switch_cpu_port {
		ethernet = <&eth0>;
		phy-mode = "25000base-x";
		managed = "in-band-status";
	};

similarly, there is a good chance that the DT description below might
result in a functional link:

	&eth0 {
		phy-mode = "2500base-x";
		managed = "in-band-status";
	};

	&switch_cpu_port {
		ethernet = <&eth0>;
		phy-mode = "25000base-x";

		fixed-link {
			speed = <2500>;
			full-duplex;
		};
	};

There is no expectation from either DT description to use in-band
autoneg or not.

The fact that of_phy_is_fixed_link() was made by Stas Sergeev to say
that a 'managed' link with the value != 'auto' is fixed prompted me to
study exactly what those changes were about.

Was the managed = "in-band-status" property introduced by Stas Sergeev
in this commit:

commit 4cba5c2103657d43d0886e4cff8004d95a3d0def
Author: Stas Sergeev <stsp@list.ru>
Date:   Mon Jul 20 17:49:57 2015 -0700

    of_mdio: add new DT property 'managed' to specify the PHY management type

    Currently the PHY management type is selected by the MAC driver arbitrary.
    The decision is based on the presence of the "fixed-link" node and on a
    will of the driver's authors.
    This caused a regression recently, when mvneta driver suddenly started
    to use the in-band status for auto-negotiation on fixed links.
    It appears the auto-negotiation may not work when expected by the MAC driver.
    Sebastien Rannou explains:
    << Yes, I confirm that my HW does not generate an in-band status. AFAIK, it's
    a PHY that aggregates 4xSGMIIs to 1xQSGMII ; the MAC side of the PHY (with
    inband status) is connected to the switch through QSGMII, and in this context
    we are on the media side of the PHY. >>
    https://lkml.org/lkml/2015/7/10/206

    This patch introduces the new string property 'managed' that allows
    the user to set the management type explicitly.
    The supported values are:
    "auto" - default. Uses either MDIO or nothing, depending on the presence
    of the fixed-link node
    "in-band-status" - use in-band status

    Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>

    CC: Rob Herring <robh+dt@kernel.org>
    CC: Pawel Moll <pawel.moll@arm.com>
    CC: Mark Rutland <mark.rutland@arm.com>
    CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
    CC: Kumar Gala <galak@codeaurora.org>
    CC: Florian Fainelli <f.fainelli@gmail.com>
    CC: Grant Likely <grant.likely@linaro.org>
    CC: devicetree@vger.kernel.org
    CC: linux-kernel@vger.kernel.org
    CC: netdev@vger.kernel.org
    Signed-off-by: David S. Miller <davem@davemloft.net>

not added specifically to mean whether the MAC should use in-band
autoneg or not? See commit f8af8e6eb950 ("mvneta: use inband status only
when explicitly enabled") for the mvneta change, after which the code
became:

mvneta_probe:

	err = of_property_read_string(dn, "managed", &managed);
	pp->use_inband_status = (err == 0 &&
				 strcmp(managed, "in-band-status") == 0);

mvneta_defaults_set:

	if (pp->use_inband_status) {
		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
		val &= ~(MVNETA_GMAC_FORCE_LINK_PASS |
			 MVNETA_GMAC_FORCE_LINK_DOWN |
			 MVNETA_GMAC_AN_FLOW_CTRL_EN);
		val |= MVNETA_GMAC_INBAND_AN_ENABLE |
		       MVNETA_GMAC_AN_SPEED_EN |
		       MVNETA_GMAC_AN_DUPLEX_EN;
		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
	} else {
		val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
		val &= ~(MVNETA_GMAC_INBAND_AN_ENABLE |
		       MVNETA_GMAC_AN_SPEED_EN |
		       MVNETA_GMAC_AN_DUPLEX_EN);
		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
	}

mvneta_port_power_up:

	if (pp->use_inband_status)
		ctrl |= MVNETA_GMAC2_INBAND_AN_ENABLE;

This is why I am asking whether there is any formal definition of what
managed = "in-band-status" means. You've said it means about retrieving
link status from the PCS. What are you basing upon when you are saying that?
