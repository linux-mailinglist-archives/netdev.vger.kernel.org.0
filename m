Return-Path: <netdev+bounces-5154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1577C70FD4E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF8901C20C78
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154E620699;
	Wed, 24 May 2023 17:56:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F161C76B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:56:30 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C45EB6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:56:29 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1sip-0000nx-Ee; Wed, 24 May 2023 19:56:27 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1sio-0002iZ-TK; Wed, 24 May 2023 19:56:26 +0200
Date: Wed, 24 May 2023 19:56:26 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
	Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 4/5] net: dsa: microchip: ksz8: Prepare
 ksz8863_smi for regmap register access validation
Message-ID: <20230524175626.GC7074@pengutronix.de>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-5-o.rempel@pengutronix.de>
 <584bb123-28c7-4d56-bad7-efcc2c343ecb@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <584bb123-28c7-4d56-bad7-efcc2c343ecb@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
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

On Wed, May 24, 2023 at 06:59:28PM +0200, Andrew Lunn wrote:
> On Wed, May 24, 2023 at 02:32:19PM +0200, Oleksij Rempel wrote:
> > This patch prepares the ksz8863_smi part of ksz8 driver to utilize the
> > regmap register access validation feature.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8863_smi.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
> > index 2af807db0b45..303a4707c759 100644
> > --- a/drivers/net/dsa/microchip/ksz8863_smi.c
> > +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> > @@ -104,6 +104,7 @@ static const struct regmap_config ksz8863_regmap_config[] = {
> >  		.cache_type = REGCACHE_NONE,
> >  		.lock = ksz_regmap_lock,
> >  		.unlock = ksz_regmap_unlock,
> > +		.max_register = BIT(8) - 1,
> 
> Maybe SZ_256 - 1 is more readable?

It is the same way used in other regmap_config in this driver.

As for me, U8_MAX is probably more understandable way, since addressing
since is 8bit.

> >  	},
> >  	{
> >  		.name = "#16",
> > @@ -113,6 +114,7 @@ static const struct regmap_config ksz8863_regmap_config[] = {
> >  		.cache_type = REGCACHE_NONE,
> >  		.lock = ksz_regmap_lock,
> >  		.unlock = ksz_regmap_unlock,
> > +		.max_register = BIT(8) - 2,
> 
> - 2?
> 
> Is this the 16 bit regmap? So it has 1/2 the number of registers of
> the 8 bit regmap? So i would of thought it should be BIT(7)-1, or
> SZ_128-1 ?

Sorry, it is a typo.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

