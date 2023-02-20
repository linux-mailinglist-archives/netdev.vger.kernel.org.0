Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBD169D126
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBTQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBTQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:13:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2DD6193
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:13:50 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU8nM-0003Zk-CS; Mon, 20 Feb 2023 17:13:40 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU8nL-00062p-5j; Mon, 20 Feb 2023 17:13:39 +0100
Date:   Mon, 20 Feb 2023 17:13:39 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <20230220161339.GC19238@pengutronix.de>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
 <20230220150720.GA19238@pengutronix.de>
 <Y/OWSjQ0m65fF5dk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/OWSjQ0m65fF5dk@lunn.ch>
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

On Mon, Feb 20, 2023 at 04:48:26PM +0100, Andrew Lunn wrote:
> > Hm.. ethtool do not provide enough information about expected behavior.
> > Here is my expectation:
> > - "ethtool --set-eee lan1 eee on" should enable EEE if it is disabled.
> > - "ethtool --set-eee lan1 advertise 0x10" should change set of
> >   advertised modes.
> > - a sequence of "..advertise 0x10", "..eee on", "eee off" should restore
> >   preconfigured advertise modes. advertising_eee instead of
> >   supported_eee.
> 
> I agree ethtool is not very well documented. However, i would follow
> what -s does. You can pass link modes you want to advertise, and you
> can turn auto-neg on and off. Does turning auto-neg off and on again
> reset the links modes which are advertised? I don't actually know, but
> i think the behaviour should be consistent for link modes and EEE
> modes.

Hm.. "ethtool -s lan1 autoneg on" will restore supported values. Even
without switching it off.
In this case "eee on", supported_eee should be used.
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
