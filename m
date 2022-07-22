Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B75D57E4E3
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiGVQ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiGVQ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:56:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF182E9D8;
        Fri, 22 Jul 2022 09:56:06 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l23so9584692ejr.5;
        Fri, 22 Jul 2022 09:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bCCVZJD1F1AcTeIBqyOAocweazZ/RraHo4w2VrYlJ2s=;
        b=dtdtW3ocw3aNifDm7jMacYS96T4AbvkKZdyzA8ej7BdHFlri/H3W57YOIt7BxouDtS
         E3o7itaRNG4xlQ6lrO/Sldi8dNJvAsiEx86PLxvIbudKu1UMSeesqTIRxHdNNJqWM/PV
         lpkRTTogpusRKxPsLX4MNZIsAdieSB/isXfaEzqTQMj/zrr/uSYOnWWOUageEQ4SYiTQ
         gLWT/TxumD2tXxQYszI9bdljNysRgoe9L2jYWFW2qCnc+tYj38C6iWSZktnJQ2NXew1w
         q1f7hoHaHe5rMrzNiqLOUntjDuNo4D8JO4ASY3/fCScg2AfbrW519Xsy0e6tcaJxlL6C
         kqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bCCVZJD1F1AcTeIBqyOAocweazZ/RraHo4w2VrYlJ2s=;
        b=ZajBVmflXRu++piDV0YAsK0TP7U/YpHFXVGX+hOtmFWKzF6ygDPbupKBdLTdKY8eNU
         kEgZguNMSXcK3KeiobBbhd6VbzQ0BOj1iuOQiOkMd370XBVcqfOlGkmM8mvi2JoW9Ww4
         ZCsYyhya4Y+bTfqcsmiUfTwEFf9vfWhFQqLyyIZDLDGwlAnBYeStpLgmuO63hTlxuYW/
         EmU2FG+Bzrk+ja4vfNqOw3KahQ5m4V/hjankhtRi4zpZbTLd3pobK1yyytzzBa6jw/0F
         PjCZpjlgLYh29nUJq9/7EbYNgCBOafOUiRF+A8EImypfCcTMHVIPVKM4etemekL2n9Kg
         fYIg==
X-Gm-Message-State: AJIora8a21NPBpGYBHhxcy95YupOUtLjWi0mnncYBgVga5S8qy9HNy00
        N2jLUPfYGntNiopKoofraX8=
X-Google-Smtp-Source: AGRyM1sPvKcOZuVOmfloFHy+ScQriw4i+pjUdqnCs7a8tdzaxWKRhoP216rxoPLFgsXlsloRh3OTNg==
X-Received: by 2002:a17:906:7482:b0:722:edf9:e72f with SMTP id e2-20020a170906748200b00722edf9e72fmr639414ejl.92.1658508965120;
        Fri, 22 Jul 2022 09:56:05 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id eg47-20020a05640228af00b0043bbcd94ee4sm2822943edb.51.2022.07.22.09.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 09:56:03 -0700 (PDT)
Date:   Fri, 22 Jul 2022 19:56:00 +0300
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
Message-ID: <20220722165600.lldukpdflv7cjp4j@skbuf>
References: <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 02:16:04PM +0100, Russell King (Oracle) wrote:
> > So mvneta at the stage of the commit you've mentioned calls
> > mvneta_set_autoneg() with the value of pp->use_inband_status. There is
> > then the exception to be made for the PCS being what's exposed to the
> > medium, and in that case, ethtool may also override the pp->use_inband_status
> > variable (which in turn affects the autoneg).
> > 
> > So if we take mvneta at this commit as the reference, what we learn is
> > that using in-band status essentially depends on using in-band autoneg
> > in the first place.
> > 
> > What is hard for me to comprehend is how we ever came to conclude that
> > for SERDES protocols where clause 37 is possible (2500base-x should be
> > part of this group), managed = "in-band-status" does not imply in-band
> > autoneg, considering the mvneta precedent.
> 
> That is a recent addition, since the argument was made that when using
> a 1000base-X fibre transceiver, using ethtool to disable autoneg is a
> reasonable thing to do - and something that was supported with
> mvneta_ethtool_set_link_ksettings() as it stands at the point in the
> commit above.

I'm sorry, I don't understand. What is the recent addition, and recent
relative to what? The 2500base-x link mode? Ok, but this is only
tangentially related to the point overall, more below.

> > And why would we essentially redefine its meaning by stating that no,
> > it is only about the status, not about the autoneg, even though the
> > status comes from the autoneg for these protocols.
> 
> I'm not sure I understand what you're getting at there.

Sorry if I haven't made my point clear.

My point is that drivers may have more restrictive interpretations of
managed = "in-band-status", and the current logic of automatically
create a fixed-link for DSA's CPU ports is going to cause problems when
matched up with a DSA master that expects in-band autoneg for whatever
SERDES protocol.

What I'd like to happen as a result is that no DSA driver except Marvell
opts into this by default, and no driver opts into it without its maintainer
understanding the implications. Otherwise we're going to normalize the
expectation that a managed = "in-band-status" DSA master should be able
to interoperate with a fixed-link CPU port, but during this discussion
there was no argument being brought that a strict interpretation of
"in-band-status" as "enable autoneg" is incorrect in any way.

> Going back to the mvneta combined PCS+MAC implementation, we read the
> link parameters from the PCS when operating in in-band mode and throw
> them at the fixed PHY so that ethtool works, along with all the usual
> link up/down state reporting, carrier etc.
> 
> If autoneg is disabled, then we effectively operate in fixed-link mode
> (use_inband_status becomes false, and we start forcing the link up/down
> and also force the speed and duplex parameters by disabling autoneg.)
> 
> Note that this version of mvneta does not support 1000base-X mode, only
> SGMII is actually supported.
> 
> There's a few things that are rather confusing in the driver:
> 
> MVNETA_GMAC_INBAND_AN_ENABLE - this controls whether in-band negotiation
> is performed or not.
> MVNETA_GMAC_AN_SPEED_EN - this controls whether the result of in-band
> negotiation for speed is used, or the manually programmed speed in this
> register.
> MVNETA_GMAC_AN_DUPLEX_EN - same for duplex.
> MVNETA_GMAC_AN_FLOW_CTRL_EN - same for pause (only symmetric pause is
> supported)
> 
> MVNETA_GMAC2_INBAND_AN_ENABLE - misnamed, it selects whether SGMII (set)
> or 1000base-X (unset) format for the 16-bit control word is used.
> 
> There is another bit in MVNETA_GMAC_CTRL_0 that selects between
> 1000base-X and SGMII operation mode, and when this bit is set for
> 1000base-X. This version of the driver doesn't support 1000base-X,
> so this bit is never set.

Thanks for this explanation, if nothing else, it seems to support the
way in which I was interpreting managed = "in-band-status" to mean
"enable in-band autoneg", but to be clear, I wasn't debating something
about the way in which mvneta was doing things. But rather, I was
debating why would *other* drivers do things differently such as to come
to expect that a fixed-link master + an in-band-status CPU port, or the
other way around, may be compatible with each other.

Anyway, before I comment any further on the other points, I have a board
using armada-3720-turris-mox.dts on which I wanted to make a test, but I
don't fully understand the results, could you help me do so?

By default, both the mvneta master and my 6390 top-most switch are
configured for inband/2500base-x. In essence I'm perfectly fine with
that. I don't care whether IEEE standardized inband/2500base-x, as long
as both drivers come to expect to enable or disable inband depending on
the device tree.

I've dumped the variables from mvneta_pcs_get_state() and it appears
that the mvneta is reporting AN complete. This would suggest that there
is indeed in-band autoneg taking place with the 6390 switch.

Then I modified the device tree to disable in-band autoneg (I've checked
mv88e6390_serdes_pcs_config and it behaves how I'd expect, enabling
BMCR_ANENABLE strictly according to phylink_autoneg_inband(mode)).
Essentially what I'm trying is to intentionally break in-band autoneg by
causing a mismatch, to prove that it is indeed taking place.

The results are interesting: state->an_complete is still reported as 1
for eth1 (mvneta).

ip link set eth1 up
[   70.809889] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   70.818086] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
[   70.836081] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
[   70.843748] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   70.859944] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_ADVERTISE 0xa0 adv 0x80 changed 1
[   70.878737] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_BMCR 0x140 bmcr 0x140 phylink_autoneg_inband(mode) 0
[   70.898302] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
[   71.069532] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 1 state->speed 2500 state->pause 0x3 state->link 1 state->duplex 1
[   71.083376] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   71.091672] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

Then I studied MVNETA_GMAC_AUTONEG_CONFIG and I noticed that the bit
you're talking about, MVNETA_GMAC_AN_BYPASS_ENABLE (bit 3) is indeed set
by default (the driver doesn't set it).

I've intentionally masked it off in mvneta_pcs_config() by setting it in
the "mask" variable and nowhere else. Now I get:

ip link set eth1 up
[  434.336679] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[  434.342618] mv88e6085 d0032004.mdio-mii:10: Link is Down
[  434.350020] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b44 state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
[  434.350055] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b44 state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
[  434.384794] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_ADVERTISE 0xa0 adv 0x80 changed 1
[  434.403808] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_BMCR 0x140 bmcr 0x140 phylink_autoneg_inband(mode) 0
[  434.423732] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off

so state->an_complete now remains zero, and the link is down on the CPU
port, and indeed I can no longer ping the board from the outside world.


So what this is telling me is that mvneta has some built-in resilience
to in-band autoneg mismatches, via MVNETA_GMAC_AN_BYPASS_ENABLE. But that
(a) doesn't make it valid to mix and match a fixed-link with a managed =
    "in-band-status" mode
(b) doesn't mean it's unspecified whether managed = "in-band-status"
    should dictate whether to enable in-band autoneg or not
(c) doesn't mean that other devices/drivers support "AN bypass" to save
    the day and make an invalid DT description appear to work just fine

This further supports my idea that we should make a better attempt of
matching the DSA master's mode with the node we're faking in DSA for
phylink. For Marvell hardware you or Andrew are surely more knowledgeable
to be able to say whether that's needed right now or not. But in the
general case please don't push this to everyone, it just muddies the
waters.
