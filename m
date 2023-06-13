Return-Path: <netdev+bounces-10361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB42972E1CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B03361C20C6E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70114294F4;
	Tue, 13 Jun 2023 11:38:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D8129114
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:38:13 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC32F7;
	Tue, 13 Jun 2023 04:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686656290; x=1718192290;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sIZrY5TljSFD0HBXV6l1MOaL4rgBtNOPn6wu8/2Gd+Y=;
  b=F0KW/lCeplfkxSTqBYEdsFubzQcyAjqKP+W+WTTDU0msZYykyf75LALr
   hc3ACeoyfblPZp57RuoIyG4IFE8eQWQQ+zFUhiCoc1jVd8Hu/TfBYY9uR
   fK2E7mXFDQpL5hSgFjitIsthnW2i3bFi6tOtCOAgA/5UnLaGJ3W75dEc7
   V1hHDMPmaD22oi3At727lLfpU45Mf/KC6stbVvlnX3nwKoBd52rkaH8R7
   hXudNr/nlZc6eiGE9llniZvAgzHwc/urYUkYfAx6cB7SGYl2QtL6CJrPi
   aqz1A4dPNqb3Pa0G6kNuYcI1BNpi0rmlqprHlnljWrvKP0cMvkbSBEqBB
   w==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="156740761"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2023 04:38:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 13 Jun 2023 04:38:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 13 Jun 2023 04:38:09 -0700
Date: Tue, 13 Jun 2023 13:38:08 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v2 0/2] net: micrel: Change how to read TX
 timestamp
Message-ID: <20230613113808.mqasva7fuoxuurab@soft-dev3-1>
References: <20230613094526.69532-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230613094526.69532-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/13/2023 11:45, Horatiu Vultur wrote:

Argh... I forgot add Richard to this thread. Therefore CC him now.

> Change how to read the timestamp of the received frames. Currently it is
> required to read over the MDIO bus each of the timestamps but it is
> possible to change to receive the timestamp (the nanosecond part and the
> least significant two bits of the second) in the frame.
> The first patch makes this change, while the second patch optimized the
> read of second part. Because it is not required to read the second part
> of the timestmap for each received frame but it is OK to read the second
> part twice per second and then cache it.
> 
> v1->v2:
> - create a patch series instead of single patch
> - add optimization for reading the second part of the received timestamp,
>   read the second twice per second instead of for each frame
> 
> Horatiu Vultur (2):
>   net: micrel: Change to receive timestamp in the frame for lan8841
>   net: micrel: Schedule work to read seconds for lan8841
> 
>  drivers/net/phy/micrel.c | 272 ++++++++++++++++++++++++++-------------
>  1 file changed, 180 insertions(+), 92 deletions(-)
> 
> -- 
> 2.38.0
> 

-- 
/Horatiu

