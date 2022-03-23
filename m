Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4901D4E4FC8
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiCWJyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 05:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241170AbiCWJyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 05:54:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466E941315;
        Wed, 23 Mar 2022 02:52:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id qx21so1660293ejb.13;
        Wed, 23 Mar 2022 02:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g1j3QaJfU8qeuiCsSbkKdkVm/9jgLAYyU1jVDoQTArk=;
        b=cbjXTfm1kiiTn5jphmGVgQgCdkCclOaeE8QNpxq90be6QVhVd7VL6IDTidBmyAs8+o
         Fdz7dxj7hJNfPtU4dExwA47sq6+1hSfqAgc7GrehDKT4CrJWCZKlaaU1oOqiHQrtYFZ3
         qAxmRdePPsmuyoG0p51F0JDKY10f6aofntln8DFReZNpsDPbYzHkc3gGfg7dOy18DjI8
         lmEhoAPgXTPMt/uZP/KgHnRpKBBAOnUKZNkM6eKwL0C6uxPV9rMp2Ol+PnS33YW/3xx/
         v9/X6pky4lr50hyhH+z13NNtUAzNgAv6HN/HGbzObR34v6GYh3QzeK8xAPwtDhUGwzuZ
         GKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g1j3QaJfU8qeuiCsSbkKdkVm/9jgLAYyU1jVDoQTArk=;
        b=z8Dp/ziOdTeMsmEYEIvJo/tjrWnyvM4a/WA114xJ89RtfsLRwmtk04ovieAxx5Yy3F
         LwlJbkolfrhOckrZhg9Yq2TlKfy26JUSqxVM8MfOqFs/plVuVgUuOkwmhOVt28woiunP
         K+sMyDch5R/fk6AWwR8Rx+S+bgloMaM2MrtYaldPen/OiyOv/vbpRebgoS5BcFjfcmHd
         R00vR5IG9TRG7MaJi8yWc/AnNOO4Mh8nZ7Eh78PvOXhrip5JgCezsh58nI4SXaExGgeF
         2+XrLBL2NsfgAaRQ8gv+FQUmWvyYUu/JXC04aPvUjS9+UnSeS0eEr81WdtM1Hy+4XyvZ
         C6gQ==
X-Gm-Message-State: AOAM5317azMRfEQx/33DTXvx3Gayaaisl4f2jmuN5R92x9PFImiOP4op
        5AzUntFNVaYuO4DvFBupmjI=
X-Google-Smtp-Source: ABdhPJw+s2CWDk9HRphMq93oXWt4VU4Sp6efJAuhWSrKlPgBCSMUm0H8XNz1vWbclIGav+R3JCG/9Q==
X-Received: by 2002:a17:906:3117:b0:6cd:f81b:e295 with SMTP id 23-20020a170906311700b006cdf81be295mr29357488ejx.511.1648029162650;
        Wed, 23 Mar 2022 02:52:42 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id bm23-20020a170906c05700b006d597fd51c6sm9738191ejb.145.2022.03.23.02.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 02:52:41 -0700 (PDT)
Date:   Wed, 23 Mar 2022 11:52:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: sja1105q: proper way to solve PHY clk dependecy
Message-ID: <20220323095240.y4xnp6ivz57obyvv@skbuf>
References: <20220323060331.GA4519@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323060331.GA4519@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oleksij,

On Wed, Mar 23, 2022 at 07:03:31AM +0100, Oleksij Rempel wrote:
> Hi Vladimir,
> 
> I have SJA1105Q based switch with 3 T1L PHYs connected over RMII
> interface. The clk input "XI" of PHYs is connected to "MII0_TX_CLK/REF_CLK/TXC"
> pins of the switch. Since this PHYs can't be configured reliably over MDIO
> interface without running clk on XI input, i have a dependency dilemma:
> i can't probe MDIO bus, without enabling DSA ports.
> 
> If I see it correctly, following steps should be done:
> - register MDIO bus without scanning for PHYs
> - define SJA1105Q switch as clock provider and PHYs as clk consumer
> - detect and attach PHYs on port enable if clks can't be controlled
>   without enabling the port.
> - HW reset line of the PHYs should be asserted if we disable port and
>   deasserted with proper reinit after port is enabled.
> 
> Other way would be to init and enable switch ports and PHYs by a bootloader and
> keep it enabled.
> 
> What is the proper way to go?
> 
> Regards,
> Oleksij
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

The facts, as I see them, are as follows, feel free to debate them.

1. Scanning the bus is not the problem, but PHY probing is.

If the MDIO bus is registered with of_mdiobus_register() - which is to
be expected, since the sja1105 driver only connects to a PHY using a
phy-handle - that should set mdio->phy_mask = ~0; which should disable
PHY scanning.

But of_mdiobus_register() will still call of_mdiobus_register_phy()
which will probe the phy_device. Here, depending on the code path,
_some_ PHY reads might be performed - which will return an error if the
PHY is missing its clock. For example, if the PHY ID isn't part of the
compatible string, fwnode_mdiobus_register_phy() will attempt to read it
from the PHY via get_phy_device(). Alternatively, you could put the PHY
ID in the DT and this will end up calling phy_device_create().

Then there's the probe() method of the T1L PHY driver, which is the
reason why it would be good to know what that driver is. Since its clock
might not be available, I expect that this driver doesn't access
hardware from probe(), knowing that it is an RMII PHY driver and this is
a generic problem for RMII PHYs.

2. The sja1105 driver already does all it reasonably can to make the
   RMII PHY happy.

The clocks of a port are enabled/configured from sja1105_clocking_setup_port()
which has 3 call paths:
(a) during sja1105_setup(), aka during switch initialization, all ports
    except RGMII ports have their clocks configured and enabled, via
    priv->info->clocking_setup(). The RGMII ports have a clock that
    depends upon the link speed, and we don't know the link speed.
(b) during sja1105_static_config_reload(). The sja1105 switch needs to
    dynamically reset itself at runtime, and this cuts off the clocks
    for a while. Again there is a call to priv->info->clocking_setup()
    here.
(c) during phylink_mac_link_up -> sja1105_adjust_port_config(), a call
    is made to sja1105_clocking_setup_port() for RGMII PHYs, because the
    speed is now known.

Since DSA calls dsa_slave_phy_setup() _after_ dsa_switch_setup(), this
means that by the time the PHY is attached, its config_init() runs, etc,
the RMII clock configured by sja1105_setup() should be running.

3. Clock gating the PHY won't make it lose its settings.

I expect that during the time when the sja1105 switch needs to reset,
the PHY just sees this as a few hundreds of ms during which there are no
clock edges on the crystal input pin. Sure, the PHY won't do anything
during that time, but this is quite different from a reset, is it not?
So asserting the hardware reset line of the PHY during the momentary
loss of clock, which is what you seem to suggest, will actively do more
harm than good.

4. Making the sja1105 driver a clock provider doesn't solve the problem
   in the general sense.

If you make this PHY driver expect the MAC to be a clock provider,
are you going to expect that all RMII-capable MAC drivers be patched?
For this reason I am in principle opposed to making the sja1105 driver
a clock provider, you won't be able to generalize this solution and it
would just create a huge mess going forward.
