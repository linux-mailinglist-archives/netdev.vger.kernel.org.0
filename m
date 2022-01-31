Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF14A4DD9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbiAaSPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:15:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:29059 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiAaSO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643652900; x=1675188900;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mDEoL8aQufpdgsTsSCCRElc7xa5gLInyDUWuNlFFguo=;
  b=gHRmLV7kMm1UStS3DeQTg0EnRMb9MLUJm0G7TcKrYfllilV4KbzIcA6R
   Q4PZqeBmiZ3UxzZY5sKbVfiVuxB8U8YQ5B+YvenHKCM/JzsytrXGKpiJl
   bWPHN75lelxcPYSBErHp1JLunKYBWY455ZP2siCTKfPYmPSD+QvuspCEH
   aEaMMLw/4QMflzpX9gLNzf5LrBvm2yOybnbpeE/i7FgF1y3EguC1im7uF
   p6JT/FwdV1An8A0bklwwl2WxkDMBSCpfJW69gLoEjFTh0TKD0L0miWtU5
   9sLJOVSmR/2FxCsVCDyuXt053t4LzCU+aYw0tifp4Igkt1bZuLZdEZe3s
   A==;
IronPort-SDR: fgjD7IKRRfOms0MuPlpz2/57prxNaM64qqLN3lkchd0SWHQrWHo/CflODMeL9p+4DP6y1/elQo
 ozbEuEXeNrIHSZUBtC2fj9cBuc0NOrqa45T4RXNslwYE7+Y2Dy9hwihrF/fB17lZHypgdxoHsH
 8EIlAZVVLVx2k9m9DpNt9or3qbaUkrZUkLI4mxrXiqjuNsOsxnYpuIKEVXbvSzvFdeftHdzzYu
 mt4E+DNL7U5DY7wo7YHmVZUspiDnPzZaUKNDJwvH643FbCVRvSvEFG2066dBAKgYoHKc3xPSDH
 wCb3IQu2xJvRWyxYbtGARJy1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="151482077"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 11:14:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 11:14:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 31 Jan 2022 11:14:58 -0700
Date:   Mon, 31 Jan 2022 23:44:57 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 5/5] net: lan743x: Add Clause-45 MDIO access
Message-ID: <20220131181457.v6sqhvv2jrewisxm@microsemi.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
 <20220127173055.308918-6-Raju.Lakkaraju@microchip.com>
 <YfMbZC8PIZ/8vwGJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YfMbZC8PIZ/8vwGJ@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 01/27/2022 23:23, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Thu, Jan 27, 2022 at 11:00:55PM +0530, Raju Lakkaraju wrote:
> > PCI1A011/PCI1A041 chip support the MDIO Clause-45 access
> >
> > Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/lan743x_main.c | 110 +++++++++++++++++-
> >  drivers/net/ethernet/microchip/lan743x_main.h |  16 +++
> >  2 files changed, 123 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> > index 6f6655eb6438..98d346aaf627 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> > @@ -793,6 +793,95 @@ static int lan743x_mdiobus_write(struct mii_bus *bus,
> >       return ret;
> >  }
> >
> > +static u32 lan743x_mac_mmd_access(int id, int index, int op, u8 freq)
> > +{
> > +     u16 dev_addr;
> > +     u32 ret;
> > +
> > +     dev_addr = (index >> 16) & 0x1f;
> > +     ret = (id << MAC_MII_ACC_PHY_ADDR_SHIFT_) &
> > +             MAC_MII_ACC_PHY_ADDR_MASK_;
> > +     ret |= (dev_addr << MAC_MII_ACC_MIIMMD_SHIFT_) &
> > +             MAC_MII_ACC_MIIMMD_MASK_;
> > +     if (freq)
> > +             ret |= (freq << MAC_MII_ACC_MDC_CYCLE_SHIFT_) &
> > +                     MAC_MII_ACC_MDC_CYCLE_MASK_;
> 
> All callers of this function appear to pass freq as 0. So you can
> remove this.
> 

Accepted.
Yes. Currently frequency is not programming.
I will change.

> > +     if (op == 1)
> > +             ret |= MAC_MII_ACC_MIICMD_WRITE_;
> > +     else if (op == 2)
> > +             ret |= MAC_MII_ACC_MIICMD_READ_;
> > +     else if (op == 3)
> > +             ret |= MAC_MII_ACC_MIICMD_READ_INC_;
> > +     else
> > +             ret |= MAC_MII_ACC_MIICMD_ADDR_;
> 
> > +             mmd_access = lan743x_mac_mmd_access(phy_id, index, 0, 0);
> 
> It is pretty opaque what the 0 means here. How about you actually pass
> MAC_MII_ACC_MIICMD_ values?
> 
> lan743x_mac_mmd_access(phy_id, index, );
> 

Accepted. I will change

> > +             if (adapter->mdiobus->probe_capabilities == MDIOBUS_C45)
> > +                     phydev->c45_ids.devices_in_package &= ~BIT(0);
> >       }
> 
> A MAC driver should not be modifying the phydev structure.
> 

Accepted. I will remove this change.

> >       /* MAC doesn't support 1000T Half */
> > @@ -2822,12 +2914,14 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
> >                       sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> >                       lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> >                       netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> > +                     adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
> >               } else {
> >                       sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> >                       sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> >                       sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> >                       lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> >                       netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> > +                     adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
> >               }
> >       } else {
> >               chip_ver = lan743x_csr_read(adapter, STRAP_READ);
> > @@ -2839,19 +2933,29 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
> >                       sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> >                       lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> >                       netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> > +                     adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
> >               } else {
> >                       sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> >                       sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> >                       sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> >                       lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> >                       netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> > +                     adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
> 
> This manipulation of adapter->mdiobus->probe_capabilities based on
> SGMII vs RGMII makes no sense. It should be set based on what the bus
> master can actually do. I assume the PCI1A011/PCI1A041 can do both C22
> and C45. So it should look at the reg value and either do a C45
> transaction, or a C22 transaction. Do the older chips not support C45?
> In that case, return -EOPNOTSUPP if asked to do a C45 transaction.
> 

Yes, Older chip does not suuport C45.
I will change code such that without upate the
"adapter->mdiobus->probe_capabilities" variable, assign the read/write
functions based chip id.

>         Andrew

-- 

Thanks,
Raju

