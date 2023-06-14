Return-Path: <netdev+bounces-10651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 055C372F8E8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111CD1C20C88
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE55B5662;
	Wed, 14 Jun 2023 09:19:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38783FE6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:19:48 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31CA1FC3;
	Wed, 14 Jun 2023 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686734383; x=1718270383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y0XZw+j/FdvN2xh0GYQ60fvo/5fvviEYz34uuugDuqY=;
  b=DaJShv7kOx7lhYaStKwgx0eebev8T3X/3tMPWfSkPzb6kPugxFjFaQ+7
   tXouYNUhGNUYY3x4MQaCJp12NrLdfUPzLoHzdq6CAAefeJYGTQNeWfr2s
   mefX7W6m3CRBAQrs/5GNL86bfZLSs9tUOfbYm9DOtyNNIg4X9LeZgmmte
   DVLfa4WVlIE8tzwuERBB34z5iAYUWIx6R4guVu9mqEwMjjQ1FGEZxGXrv
   iozhEG9ZUWsJ4NcRjnUcAzP1aJHwJ19wKv/L0l/vBy4BS+FjIvB4IRuPV
   kW2liOPyOp7bEAfoaogtLUYtLQP8QyIPdA9+drpPrjtZpuL+qJMXBe261
   w==;
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="230044072"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2023 02:19:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 14 Jun 2023 02:19:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 14 Jun 2023 02:19:29 -0700
Date: Wed, 14 Jun 2023 11:19:28 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] net: micrel: Schedule work to read
 seconds for lan8841
Message-ID: <20230614091928.5oi5r7sw7tac27lt@soft-dev3-1>
References: <20230613094526.69532-1-horatiu.vultur@microchip.com>
 <20230613094526.69532-3-horatiu.vultur@microchip.com>
 <ZIlG4otXfQ7uhMsc@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZIlG4otXfQ7uhMsc@hoboy.vegasvil.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/13/2023 21:49, Richard Cochran wrote:

Hi Richard,

> 
> On Tue, Jun 13, 2023 at 11:45:26AM +0200, Horatiu Vultur wrote:
> > @@ -3840,6 +3847,12 @@ static void lan8841_ptp_enable_processing(struct kszphy_ptp_priv *ptp_priv,
> >                              LAN8841_PTP_INSERT_TS_32BIT,
> >                              LAN8841_PTP_INSERT_TS_EN |
> >                              LAN8841_PTP_INSERT_TS_32BIT);
> > +
> > +             /* Schedule the work to read the seconds, which will be used in
> > +              * the received timestamp
> > +              */
> > +             schedule_delayed_work(&ptp_priv->seconds_work,
> > +                                   nsecs_to_jiffies(LAN8841_GET_SEC_LTC_DELAY));
> 
> Why not do this in the PTP kworker thread?

I presume you mean the work of reading the second part to be done in the
PTP kworker thread and not scheduling the seconds_work.
Because then it make sense to me and I think is a great idea.
> 
> The thread's scheduling can be easily tuned with chrt to give it
> appropriate priority, but work can't.

Nice, I didn't know about this.

> 
> Also, If you have seconds thread, then you don't have to defer the
> received frames.

Exactly, the PTP kworker thread will cache the seconds value while
lan8841_rxtstamp will read this value, so no need to defer these frames.

In this way I can get rid of seconds_work.

> 
> Thanks,
> Richard
> 

-- 
/Horatiu

