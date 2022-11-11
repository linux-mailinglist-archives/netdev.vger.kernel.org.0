Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D5625310
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 06:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiKKF3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 00:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKF3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 00:29:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2909B10B7F
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:29:51 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1otMbh-0004ec-SX; Fri, 11 Nov 2022 06:29:37 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1otMbh-0007dU-Hp; Fri, 11 Nov 2022 06:29:37 +0100
Date:   Fri, 11 Nov 2022 06:29:37 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: microchip: ksz8: add MTU
 configuration support
Message-ID: <20221111052937.GD27099@pengutronix.de>
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-5-o.rempel@pengutronix.de>
 <20221110130325.eklhybumv7naehxe@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221110130325.eklhybumv7naehxe@skbuf>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 03:03:25PM +0200, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 01:22:25PM +0100, Oleksij Rempel wrote:
> > Make MTU configurable on KSZ87xx and KSZ88xx series of switches.
> > 
> > Before this patch, pre-configured behavior was different on different
> > switch series, due to opposite meaning of the same bit:
> > - KSZ87xx: Reg 4, Bit 1 - if 1, max frame size is 1532; if 0 - 1514
> > - KSZ88xx: Reg 4, Bit 1 - if 1, max frame size is 1514; if 0 - 1532
> > 
> > Since the code was telling "... SW_LEGAL_PACKET_DISABLE, true)", I
> > assume, the idea was to set max frame size to 1532.
> > 
> > With this patch, by setting MTU size 1500, both switch series will be
> > configured to the 1532 frame limit.
> > 
> > This patch was tested on KSZ8873.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> As an extension to this patch set, you might also want to set
> ds->mtu_enforcement_ingress = true, to activate the bridge MTU
> normalization logic, since you have one MTU global to the entire switch.

Ok, I'll include it in to a different patch set. There are more patches
to mainline :)

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
