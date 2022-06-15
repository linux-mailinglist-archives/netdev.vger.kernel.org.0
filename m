Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E39554C4EE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347337AbiFOJoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347328AbiFOJoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:44:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B684550B;
        Wed, 15 Jun 2022 02:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655286252; x=1686822252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rTe92a/bs9IkgUgoRhKlJ8xhgRui05xFuusVGu40pq0=;
  b=ERoQCGthYpgtH3sptZOnXVu934Bd7tAuNAU1OobU42PvgFAAykp8UZgX
   4WFLBgpEB+KWPvHEK/waVdpX9QNFn3VgvquGKelkLwWI8Fo0R2z81CCsw
   +UvjBDFs8v8f6iVoxH4+IVaUdCTWBn9N2BgdxAuadV8oURjTQEELnCVFg
   Lu0x4wALQMmqmIbf09CjSOSVMnCZ1qnVC+gfwIzrpM1y8t7eppYF0p1LP
   e1xfsi/UVSNS3alL7BUfPnlsF9950ns7CulgUF1qXkHCrRI4lJO0aTvoX
   UXeEhbz388Z0+WiS2lmES6iBERy48W/WqCC2jIVMUBZwORV8Ds8Nl0VLc
   w==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="178035279"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 02:44:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 02:44:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Jun 2022 02:44:13 -0700
Date:   Wed, 15 Jun 2022 15:14:11 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 2/5] net: lan743x: Add support to Secure-ON WOL
Message-ID: <20220615094411.237uekup24skoeu4@microsemi.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-3-Raju.Lakkaraju@microchip.com>
 <Yqj2qegsJ7UTEr0K@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yqj2qegsJ7UTEr0K@lunn.ch>
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

The 06/14/2022 22:59, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Jun 14, 2022 at 04:04:21PM +0530, Raju Lakkaraju wrote:
> > Add support to Magic Packet Detection with Secure-ON for PCI11010/PCI11414 chips
> >
> > Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> > ---
> >  .../net/ethernet/microchip/lan743x_ethtool.c  | 14 +++++++++
> >  drivers/net/ethernet/microchip/lan743x_main.c | 29 +++++++++++++++++++
> >  drivers/net/ethernet/microchip/lan743x_main.h | 10 +++++++
> >  3 files changed, 53 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > index 48b19dcd4351..b591a7aea937 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > @@ -1149,7 +1149,13 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
> >       wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
> >               WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
> >
> > +     if (adapter->is_pci11x1x)
> > +             wol->supported |= WAKE_MAGICSECURE;
> > +
> >       wol->wolopts |= adapter->wolopts;
> > +     if (adapter->wolopts & WAKE_MAGICSECURE)
> > +             memcpy(wol->sopass, adapter->sopass,
> > +                    SOPASS_MAX * sizeof(wol->sopass[0]));
> 
> sizeof(wol->sopass) is simpler. That is what other drivers use.
> 

Accepted. I'll change.

> > +     if (wol->wolopts & WAKE_MAGICSECURE &&
> > +         wol->wolopts & WAKE_MAGIC) {
> > +             memcpy(adapter->sopass, wol->sopass,
> > +                    SOPASS_MAX * sizeof(wol->sopass[0]));
> > +             adapter->wolopts |= WAKE_MAGICSECURE;
> > +     } else {
> > +             memset(adapter->sopass, 0, sizeof(u8) * SOPASS_MAX);
> > +     }
> 
> Same here.
> 

Accepted. I'll change.

>      Andrew

-- 

Thanks,
Raju

