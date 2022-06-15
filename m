Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084AB54C4EB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346715AbiFOJnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiFOJnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:43:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3D142A0B;
        Wed, 15 Jun 2022 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655286194; x=1686822194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TdB7rxW9ngmUPbM9Ksn1bxzuws/RVhakXn65Pezg3GQ=;
  b=wu5xzlNp2a6BMHAsoBB6qcGvkxRUEXVbB99tAlhi1kKV2F6UC7Rdz4XK
   C4UOhA16crqe4kD+PSJy0lvD6kgyQmD5hQw3zVz6vMzi0bNsix4kKQtYj
   QLKtQx5ApItUZ++e5pCBTmQSNuL3h9fH6QZrxenDJ0HF/4cMScRoFXkIK
   Akv12RMmhdMxYcozuqzIEXVEQNh2rQKhto3kVxS1Yyj3O0F2TKYCsotxQ
   jp5Esf34qhWjgCh8xk+rcGUfk4JIia/p/G0KxmRP+IJVrRTKSH+Bx4ald
   HA9SJNtonUyEou9f7Ed/lMwuyjSdI6jebrApB/BM6zpcgQ20Oj9ir6M23
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="163440616"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 02:43:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 02:43:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Jun 2022 02:43:13 -0700
Date:   Wed, 15 Jun 2022 15:13:12 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 5/5] net: phy: add support to get Master-Slave
 configuration
Message-ID: <20220615094312.35xgnsyw64ogowa2@microsemi.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-6-Raju.Lakkaraju@microchip.com>
 <Yqj7x3b8nfG4GvIS@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yqj7x3b8nfG4GvIS@lunn.ch>
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

The 06/14/2022 23:21, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Jun 14, 2022 at 04:04:24PM +0530, Raju Lakkaraju wrote:
> > Implement reporting the Master-Slave configuration and state
> >
> > Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> > ---
> >  drivers/net/phy/mxl-gpy.c | 55 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> >
> > diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> > index 5ce1bf03bbd7..cf625ced4ec1 100644
> > --- a/drivers/net/phy/mxl-gpy.c
> > +++ b/drivers/net/phy/mxl-gpy.c
> > @@ -27,11 +27,19 @@
> >  #define PHY_ID_GPY241BM              0x67C9DE80
> >  #define PHY_ID_GPY245B               0x67C9DEC0
> >
> > +#define PHY_STD_GCTRL                0x09    /* Gbit ctrl */
> > +#define PHY_STD_GSTAT                0x0A    /* Gbit status */
> 
> #define MII_CTRL1000            0x09    /* 1000BASE-T control          */
> #define MII_STAT1000            0x0a    /* 1000BASE-T status           */
> 
> from mii.h
> 

I can use generic master-slave function.
I will remove these changes

> >  #define PHY_MIISTAT          0x18    /* MII state */
> >  #define PHY_IMASK            0x19    /* interrupt mask */
> >  #define PHY_ISTAT            0x1A    /* interrupt status */
> >  #define PHY_FWV                      0x1E    /* firmware version */
> >
> > +#define PHY_STD_GCTRL_MS     BIT(11)
> > +#define PHY_STD_GCTRL_MSEN   BIT(12)
> > +
> > +#define PHY_STD_GSTAT_MSRES  BIT(14)
> > +#define PHY_STD_GSTAT_MSFAULT        BIT(15)
> 
> If the device is just following the standard, there should not be any
> need to add defines, they should already exist. And if it does follow
> the standard there are probably helpers you can use.
> 

Accepted. 
Device following the standard. I will use generic master-slave function

> >  #define PHY_MIISTAT_SPD_MASK GENMASK(2, 0)
> >  #define PHY_MIISTAT_DPX              BIT(3)
> >  #define PHY_MIISTAT_LS               BIT(10)
> > @@ -160,6 +168,48 @@ static bool gpy_2500basex_chk(struct phy_device *phydev)
> >       return true;
> >  }
> >
> > +static int gpy_master_slave_cfg_get(struct phy_device *phydev)
> > +{
> > +     int state;
> > +     int cfg;
> > +     int ret;
> > +
> > +     ret = phy_read(phydev, PHY_STD_GCTRL);
> > +     if (ret < 0) {
> > +             phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> > +                        ret);
> > +             return ret;
> > +     }
> > +
> > +     if (ret & PHY_STD_GCTRL_MSEN)
> > +             if (ret & PHY_STD_GCTRL_MS)
> > +                     cfg = MASTER_SLAVE_CFG_MASTER_FORCE;
> > +             else
> > +                     cfg = MASTER_SLAVE_CFG_SLAVE_FORCE;
> > +     else
> > +             cfg = MASTER_SLAVE_CFG_MASTER_PREFERRED;
> > +
> > +     ret = phy_read(phydev, PHY_STD_GSTAT);
> > +     if (ret < 0) {
> > +             phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> > +                        ret);
> > +             return ret;
> > +     }
> > +
> > +     if (ret & PHY_STD_GSTAT_MSFAULT)
> > +             state = MASTER_SLAVE_STATE_ERR;
> > +     else
> > +             if (ret & PHY_STD_GSTAT_MSRES)
> > +                     state = MASTER_SLAVE_STATE_MASTER;
> > +             else
> > +                     state = MASTER_SLAVE_STATE_SLAVE;
> > +
> > +     phydev->master_slave_get = cfg;
> > +     phydev->master_slave_state = state;
> > +
> > +     return 0;
> 
> Would genphy_read_master_slave() work?

Yes. 
I can use genphy_read_master_slave() function.

> 
>       Andrew

-- 

Thanks,
Raju

