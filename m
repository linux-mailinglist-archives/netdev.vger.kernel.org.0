Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F303C54C4CB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348336AbiFOJhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347380AbiFOJhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:37:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA92D3BA61;
        Wed, 15 Jun 2022 02:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655285834; x=1686821834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sXjo+CBZcLczWq1l68m95bjBeMb9Ku4hb9i+j3EAZTw=;
  b=1H+4jVag5mIvJpt1OG0/HQ6o7rkKheWxuMKohdKIX0kM+itDL8CVuRMA
   YOlBfks/h/Gfio4Nw/AY4Dxbg/63jIt3YUU3jJGKDpvrOLoawuJErunxD
   4H5l7z8GdFyeGuqxWt+sXZ2BgWEqVUQnUn2RftI3tQUdndjPnEpr/0isK
   yc5Oje+NvaHVjFs7GxJBrDiFfz3VATQswKnimAPU4tW2NdzGrd0FWJEZm
   BrFPBv13sLm0/hJHm+2YmcUW3IK34iMKAyqVlzX5/GT6cECnyBNoblK92
   b0nLgX34m1GtV9+6oTsdqHeJFx0sSdRmEB7xFNQXq36z3PQYgLpPc9I04
   g==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="160408543"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 02:37:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 02:36:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Jun 2022 02:36:58 -0700
Date:   Wed, 15 Jun 2022 15:06:56 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 3/5] net: lan743x: Add support to SGMII block
 access functions
Message-ID: <20220615093656.tahj3ncojeh6slmq@microsemi.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-4-Raju.Lakkaraju@microchip.com>
 <Yqj3qpq5Ew+JT+28@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yqj3qpq5Ew+JT+28@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 06/14/2022 23:03, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Jun 14, 2022 at 04:04:22PM +0530, Raju Lakkaraju wrote:
> > Add SGMII access read and write functions
> >
> > Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/lan743x_main.c | 69 +++++++++++++++++++
> >  drivers/net/ethernet/microchip/lan743x_main.h | 12 ++++
> >  2 files changed, 81 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> > index 6352cba19691..e496769efb54 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> > @@ -909,6 +909,74 @@ static int lan743x_mdiobus_c45_write(struct mii_bus *bus,
> >       return ret;
> >  }
> >
> > +static int lan743x_sgmii_wait_till_not_busy(struct lan743x_adapter *adapter)
> > +{
> > +     u32 data;
> > +     int ret;
> > +
> > +     ret = readx_poll_timeout(LAN743X_CSR_READ_OP, SGMII_ACC, data,
> > +                              !(data & SGMII_ACC_SGMII_BZY_), 100, 1000000);
> > +     if (unlikely(ret < 0))
> 
> unlikely() seems pointless here. You have just done a blocking poll,
> so you don't care about high performance, this is not the fast path.
> 
>    Andrew

Accepted. 
I will remove the unlinkely().

-- 

Thanks,
Raju

