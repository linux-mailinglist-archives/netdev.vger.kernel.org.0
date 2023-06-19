Return-Path: <netdev+bounces-11844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9AF734D13
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81790280F9B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7456263DD;
	Mon, 19 Jun 2023 08:07:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C4C290E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:07:10 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3048E1999
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:06:59 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[IPv6:::1])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <l.stach@pengutronix.de>)
	id 1qB9uP-0001g5-TK; Mon, 19 Jun 2023 10:06:45 +0200
Message-ID: <98c429707f067774efe7c2cf7e1f48dc06b00b94.camel@pengutronix.de>
Subject: Re: [PATCH] net: fec: allow to build without PAGE_POOL_STATS
From: Lucas Stach <l.stach@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,  Shenwei Wang
 <shenwei.wang@nxp.com>, Clark Wang <xiaoning.wang@nxp.com>, NXP Linux Team
 <linux-imx@nxp.com>,  netdev@vger.kernel.org, kernel@pengutronix.de,
 patchwork-lst@pengutronix.de
Date: Mon, 19 Jun 2023 10:06:43 +0200
In-Reply-To: <cf2f001a-ffa3-4620-a657-bb6845ca17bf@lunn.ch>
References: <20230616191832.2944130-1-l.stach@pengutronix.de>
	 <cf2f001a-ffa3-4620-a657-bb6845ca17bf@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

Am Samstag, dem 17.06.2023 um 17:48 +0200 schrieb Andrew Lunn:
> On Fri, Jun 16, 2023 at 09:18:32PM +0200, Lucas Stach wrote:
> > Commit 6970ef27ff7f ("net: fec: add xdp and page pool statistics") sele=
cted
> > CONFIG_PAGE_POOL_STATS from the FEC driver symbol, making it impossible
> > to build without the page pool statistics when this driver is enabled. =
The
> > help text of those statistics mentions increased overhead. Allow the us=
er
> > to choose between usefulness of the statistics and the added overhead.
>=20
> Hi Lucas
>=20
> Do you have any sort of numbers?

I don't have any numbers. To be honest I only wrote this patch because
I was surprised to see CONFIG_PAGE_POOL_STATS being enabled via a
select after a kernel update, while the help text of that item suggests
that the user should have a choice here.

>=20
> Object size should be easy to do.  How much difference does the #ifdef
> CONFIG_PAGE_POOL_STATS make to the code segment? Those come with a
> small amount of maintenance cost. And there does appear to be stubs
> for when PAGE_POOL_STATS is disabled.

Stubs aren't sufficient here, as the structures used as parameters to
those functions aren't defined when !CONFIG_PAGE_POOL_STATS.

Regards,
Lucas

