Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB654C4DE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346460AbiFOJkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346513AbiFOJj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:39:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB736B76;
        Wed, 15 Jun 2022 02:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655285996; x=1686821996;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WzYLHyjSwhugUXtVRNrbyU96QfQSkrdPL05c3jK9Q9A=;
  b=Zy96EmO4L9wy+vB1oKGOql8k2fWmh0LSkZWU6d8dBC2SHbn6gVHbSmUd
   R5qBnBEXTwryMhhL0VTsmBNAZMp7x0MYUF95E/QW76ivNk/ii6ZJaTSDV
   vd0J7vUpmLhTcC6U0bakk83mduv3C1Q2u2V3OsKbk1/VJR76JUjQOCDDn
   9rkO0NTFjHJ247GF+9REd5zfM3GSIAKuiNsh70bjdoz2rQJQS10B1rzgZ
   zn5Yao73eHNwRBw33Sat5MknYdYB9v7zH4Ld/CxegI2WTlgT6KxHSTqok
   36mqOxNjHDKoEhJC2nV0w2Yn2a3Jj1TBcCC2ExZUTtVCFjKwGlJmPxrQJ
   w==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="168194071"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 02:39:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 02:39:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Jun 2022 02:39:44 -0700
Date:   Wed, 15 Jun 2022 15:09:43 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support to SGMII 1G and
 2.5G
Message-ID: <20220615093943.jkq7mme5u36pzytl@microsemi.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-5-Raju.Lakkaraju@microchip.com>
 <Yqj575Z/tYXsRHHK@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yqj575Z/tYXsRHHK@lunn.ch>
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

The 06/14/2022 23:13, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +/* MMD Device IDs */
> > +#define STD_DEVID                    (0x0)
> > +#define MMD_PMAPMD                   (0x1)
> > +#define MMD_PCS                              (0x3)
> > +#define MMD_ANEG                     (0x7)
> > +#define MMD_VSPEC1                   (0x1E)
> > +#define MMD_VSPEC2                   (0x1F)
> 
> Please use the values from include/uapi/mdio.h
> 

Accepted. Will fix this.

> > +
> > +/* Vendor Specific SGMII MMD details */
> > +#define SR_MII_DEV_ID1                       0x0002
> > +#define SR_MII_DEV_ID2                       0x0003
> 
> MDIO_DEVID1 & MDIO_DEVID2

Not used these definitions. I will remote.

> 
> > +#define SR_VSMMD_PCS_ID1             0x0004
> > +#define SR_VSMMD_PCS_ID2             0x0005
> > +#define SR_VSMMD_STS                 0x0008
> > +#define SR_VSMMD_CTRL                        0x0009
> > +
> > +#define SR_MII_CTRL                  0x0000
> > +#define SR_MII_CTRL_RST_             BIT(15)
> > +#define SR_MII_CTRL_LBE_             BIT(14)
> > +#define SR_MII_CTRL_SS13_            BIT(13)
> > +#define SR_MII_CTRL_AN_ENABLE_               BIT(12)
> > +#define SR_MII_CTRL_LPM_             BIT(11)
> > +#define SR_MII_CTRL_RESTART_AN_              BIT(9)
> > +#define SR_MII_CTRL_DUPLEX_MODE_     BIT(8)
> > +#define SR_MII_CTRL_SS6_             BIT(6)
> 
> These look like standard BMCR registers. Please use the values from
> mii.h
> 

Accepted. Will fix this.

> > +#define SR_MII_STS                   0x0001
> > +#define SR_MII_STS_ABL100T4_         BIT(15)
> > +#define SR_MII_STS_FD100ABL_         BIT(14)
> > +#define SR_MII_STS_HD100ABL_         BIT(13)
> > +#define SR_MII_STS_FD10ABL_          BIT(12)
> > +#define SR_MII_STS_HD10ABL_          BIT(11)
> > +#define SR_MII_STS_FD100T_           BIT(10)
> > +#define SR_MII_STS_HD100T_           BIT(9)
> > +#define SR_MII_STS_EXT_STS_ABL_              BIT(8)
> > +#define SR_MII_STS_UN_DIR_ABL_               BIT(7)
> > +#define SR_MII_STS_MF_PRE_SUP_               BIT(6)
> > +#define SR_MII_STS_AN_CMPL_          BIT(5)
> > +#define SR_MII_STS_RF_                       BIT(4)
> > +#define SR_MII_STS_AN_ABL_           BIT(3)
> > +#define SR_MII_STS_LINK_STS_         BIT(2)
> > +#define SR_MII_STS_EXT_REG_CAP_              BIT(0)
> 
> These look like BMSR.
> 

Accepted. Will fix this.

> It could even be, you can just use generic code for these.
> 
>    Andrew

-- 

Thanks,
Raju

