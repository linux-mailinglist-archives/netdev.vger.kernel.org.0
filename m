Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9926B7146
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 09:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCMIlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 04:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCMIlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 04:41:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6047025E16
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 01:41:12 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbdjy-0008Pl-98; Mon, 13 Mar 2023 09:41:10 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbdjn-00049Y-Tk; Mon, 13 Mar 2023 09:40:59 +0100
Date:   Mon, 13 Mar 2023 09:40:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230313084059.GA11063@pengutronix.de>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 06:44:51PM +0200, Vladimir Oltean wrote:
> On Fri, Mar 10, 2023 at 02:15:29PM +0100, Horatiu Vultur wrote:
> > I was thinking about another scenario (I am sorry if this was already
> > discussed).
> > Currently when setting up to do the timestamp, the MAC will check if the
> > PHY has timestamping support if that is the case the PHY will do the
> > timestamping. So in case the switch was supposed to be a TC then we had
> > to make sure that the HW was setting up some rules not to forward PTP
> > frames by HW but to copy these frames to CPU.
> > With this new implementation, this would not be possible anymore as the
> > MAC will not be notified when doing the timestamping in the PHY.
> > Does it mean that now the switch should allocate these rules at start
> > time?
> 
> I would say no (to the allocation of trapping rules at startup time).
> It was argued before by people present in this thread that it should be
> possible (and default behavior) for switches to forward PTP frames as if
> they were PTP-unaware:
> https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/
> 
> But it raises a really good point about how much care a switch driver
> needs to take, such that with PTP timestamping, it must trap but not
> timestamp the PTP frames.
> 
> There is a huge amount of variability here today.
> 
> The ocelot driver would be broken with PHY timestamping, since it would
> flood the PTP messages (it installs the traps only if it is responsible
> for taking the timestamps too).
> 
> The lan966x driver is very fine-tuned to call lan966x_ptp_setup_traps()
> regardless of what phy_has_hwtstamp() says.
> 
> The sparx5 driver doesn't even seem to install traps at all (unclear if
> they are predefined in hardware or not).
> 
> I guess that we want something like lan966x to keep working, since it
> sounds like it's making the sanest decision about what to do.
> 
> But, as you point out, with Köry's/Richard's proposal, the MAC driver
> will be bypassed when the selected timestamping layer is the PHY, and
> that's a problem currently.
> 
> May I suggest the following? There was another RFC which proposed the
> introduction of a netdev notifier when timestamping is turned on/off:
> https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean@nxp.com/
> 
> It didn't go beyond RFC status, because I started doing what Jakub
> suggested (converting the raw ioctls handlers to NDOs) but quickly got
> absolutely swamped into the whole mess.
> 
> If we have a notifier, then we can make switch drivers do things
> differently. They can activate timestamping per se in the timestamping
> NDO (which is only called when the MAC is the active timestamping layer),
> and they can activate PTP traps in the netdev notifier (which is called
> any time a timestamping status change takes place - the notifier info
> should contain details about which net_device and timestamping layer
> this is, for example).
> 
> It's just a proposal of how to create an alternative notification path
> that doesn't disturb the goals of this patch set.

To make things even more complicated - I  have a project where the DSA master
should be used for time stamping. Due to board specific limitations, we
are forced to use FEC PHC instead of dsa KSZ switch PHC. So, it is not
a choice between MAC and PHY, it is more the MAC before MAC and PHY.
PTP sync in this case will have more jitter, but it still good enough
for this project.
Currently I use quick hack to do so, but mainlinamble solution working for
most use cases will be nice.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
