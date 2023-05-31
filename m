Return-Path: <netdev+bounces-6719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5D77179B1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C746528142A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C73BE47;
	Wed, 31 May 2023 08:12:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF62BBA26
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:12:34 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C59BE
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:12:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q4GwT-0006Bx-Ry; Wed, 31 May 2023 10:12:25 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q4GwS-0043cp-Ad; Wed, 31 May 2023 10:12:24 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q4GwR-00H83J-9T; Wed, 31 May 2023 10:12:23 +0200
Date: Wed, 31 May 2023 10:12:23 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <ZHcBZ5hGTu7aBCsJ@pengutronix.de>
References: <20230530122621.2142192-1-lukma@denx.de>
 <32aa2c0f-e284-4c5e-ba13-a2ea7783c202@lunn.ch>
 <20230530154039.4552e08a@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230530154039.4552e08a@wsk>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Lukasz,

On Tue, May 30, 2023 at 03:40:39PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> > > One can disable in device tree advertising of EEE capabilities of
> > > PHY when 'eee-broken-100tx' property is present in DTS.
> > > 
> > > With DSA switch it also may happen that one would need to disable
> > > EEE due to some network issues.  
> > 
> > Is EEE actually broken in the MAC/PHY combination?
> > 
> 
> Problem is that when I connect on this project some non-manageable
> switches (which by default have EEE enabled), then I observe very rare
> and sporadic link loss and reconnection.

The interesting question is, do other link partner or local system is
broken?
In some cases, not proper tx-timer was triggering this kind of
symptoms. And timer configuration may depend on the link speed. So,
driver may be need to take care of this.

> Disabling EEE solves the problem.
> 
> > You should not be using this DT option for configuration. It is there
> > because there is some hardware which is truly broken, and needs EEE
> > turned off.
> 
> Yes, I do think that the above sentence sums up my use case.

As Andrew already described, current linux kernel EEE support is not in
the best shape, it is hard to see the difference between broken HW and
SW.

> > If EEE does work, but you need to turn it off because of latency etc,
> > then please use ethtool.
> > 
> 
> Yes, correct - it is possible to disable the EEE with 
> 
> ethtool --set-eee lan2 eee off
> 
> However, as I've stated in the mail, I cannot re-enable EEE once
> disabled with:
> 
> ethtool --set-eee lan2 eee on
> 
> ethtool --show-eee lan2
> EEE Settings for lan2:
>         EEE status: not supported
> 
> 
> As the capability register shows value of 0.

Some PHYs indeed have this issues:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/micrel.c?h=v6.4-rc4#n1402

In case of your older kernel version, you will need to fake access to
the EEE caps register.

Regards,
Oleksij

