Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4944EEE44
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346405AbiDANjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiDANjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:39:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB527E84F;
        Fri,  1 Apr 2022 06:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648820275; x=1680356275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qv8FscXyHh5HjbavNwVRDW0UTLUik5p2IFzPgviCoaQ=;
  b=ambMfjm4f8LbCOW4TSD24QEkLMX0+vdNcYprhLmWq8ts8LNkpn0/3raw
   Pgvrajj2q9fYu6yEvB0RmQBPpmUyHl/9BAzljHelG8gIfz/qQLpPIopsR
   eZgXA2xPnPURjiLuEUj7c2SFK1HtXFAtPFkVNZ+dp4Ub0KE6IUGHLUshZ
   RDip4N//2ydOp/+okjHsllmAcIiXx870KotH56tqLLyT9VuIwG4O4uRld
   EhvUzg5T0dyBrSIaTuhAgFLCWQFLnpWqYB9IXVqlUBuFe3YlJirssXd/P
   yYO2RMP/5qwygkzKZx+uQ6E5CmShrC8H3Hg/xmTQhSlWbNy7FNt9fsjT9
   g==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="158971507"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 06:37:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 06:37:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Apr 2022 06:37:50 -0700
Date:   Fri, 1 Apr 2022 15:40:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC PATCH net-next 1/2] ethtool: Extend to allow to set PHY
 latencies
Message-ID: <20220401134059.zef4ltvnux66jl2y@soft-dev3-1.localhost>
References: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
 <20220401093909.3341836-2-horatiu.vultur@microchip.com>
 <YkbxtzE/BRfz0XTW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YkbxtzE/BRfz0XTW@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/01/2022 14:36, Andrew Lunn wrote:
> 
> On Fri, Apr 01, 2022 at 11:39:08AM +0200, Horatiu Vultur wrote:
> > Extend ethtool uapi to allow to configure the latencies for the PHY.
> > Allow to configure the latency per speed and per direction.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/ethtool.h |  6 ++++++
> >  net/ethtool/common.c         |  6 ++++++
> >  net/ethtool/ioctl.c          | 10 ++++++++++
> >  3 files changed, 22 insertions(+)
> >
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 7bc4b8def12c..f120904a4e43 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -296,6 +296,12 @@ enum phy_tunable_id {
> >       ETHTOOL_PHY_DOWNSHIFT,
> >       ETHTOOL_PHY_FAST_LINK_DOWN,
> >       ETHTOOL_PHY_EDPD,
> > +     ETHTOOL_PHY_LATENCY_RX_10MBIT,
> > +     ETHTOOL_PHY_LATENCY_TX_10MBIT,
> > +     ETHTOOL_PHY_LATENCY_RX_100MBIT,
> > +     ETHTOOL_PHY_LATENCY_TX_100MBIT,
> > +     ETHTOOL_PHY_LATENCY_RX_1000MBIT,
> > +     ETHTOOL_PHY_LATENCY_TX_1000MBIT,
> 
> How does this scale with 2.5G, 5G, 10G, 14G, 40G, etc.
> 
> Could half duplex differ to full duplex? What about 1000BaseT vs
> 1000BaseT1 and 1000BaseT2? The Aquantia/Marvell PHY can do both
> 1000BaseT and 1000BaseT2 and will downshift from 4 pairs to 2 pairs if
> you have the correct magic in its firmware blobs.
> 
> A more generic API would pass a link mode, a direction and a
> latency. The driver can then return -EOPNOTSUPP for a mode it does not
> support.

Yes, I can see your point, the proposed solution is not scalable.
I will try implement something like you suggested.

> 
>         Andrew

-- 
/Horatiu
