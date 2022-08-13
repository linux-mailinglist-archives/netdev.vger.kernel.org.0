Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2419591BF9
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 18:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiHMQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239677AbiHMQSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 12:18:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5889E1277B
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 09:18:53 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oMtqd-0004Hp-N9; Sat, 13 Aug 2022 18:18:51 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oMtqc-0005va-Da; Sat, 13 Aug 2022 18:18:50 +0200
Date:   Sat, 13 Aug 2022 18:18:50 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220813161850.GB12534@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
 <20220805134234.ps4qfjiachzm7jv4@skbuf>
 <20220813143215.GA12534@pengutronix.de>
 <Yve/MSMc/4klJPFL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yve/MSMc/4klJPFL@lunn.ch>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 05:11:45PM +0200, Andrew Lunn wrote:
> On Sat, Aug 13, 2022 at 04:32:15PM +0200, Oleksij Rempel wrote:
> > On Fri, Aug 05, 2022 at 04:42:34PM +0300, Vladimir Oltean wrote:
> > > On Fri, Aug 05, 2022 at 01:56:01PM +0200, Oleksij Rempel wrote:
> > > > Hm, if we will have any random not support OF property in the switch
> > > > node. We won't be able to warn about it anyway. So, if it is present
> > > > but not supported, we will just ignore it.
> > > > 
> > > > I'll drop this patch.
> > > 
> > > To continue, I think the right way to go about this is to edit the
> > > dt-schema to say that these properties are only applicable to certain
> > > compatible strings, rather than for all. Then due to the
> > > "unevaluatedProperties: false", you'd get the warnings you want, at
> > > validation time.
> > 
> > Hm, with "unevaluatedProperties: false" i have no warnings. Even if I
> > create examples with random strings as properties. Are there some new
> > json libraries i should use?
> 
> Try
> 
> additionalProperties: False

Yes, it works. But in this case I'll do more changes. Just wont to make
sure I do not fix not broken things.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
