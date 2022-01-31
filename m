Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF744A4DBC
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiAaSJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:09:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:27098 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiAaSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643652588; x=1675188588;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x6yaY4StNMdXrCgCbPbNcnBl/bpoaxGnZ4bhM97K7CM=;
  b=D6fHT5lIcsojst8ixShsJ9hyST8XBV7rcU0kaj8+3YiGlq4fC9NAZgh0
   BgHEFn2llHs9jsxNgtt2YlWhILuj6pa4by3w3YncYJVsj6pSuwr4U1eGY
   UFU9fU6rjxJMpx88lAw4TFPXSm4Yyq+Ps92pCTttG1F6arOxiC0ycK25u
   QdH8MVEe8J0kYdrTQrR4orklHhVk3AdQS+QtnGLkP5VUWETH0/LZkeGoh
   OYen75ndPw3x5DiQiYxQu51tXrA0acYH/IvMElwiu6UWDK06fPG552Jom
   CX+V4HttWcFUkiCtsvJvLcRcZEbV07q3NXtkf9hD3oIOGKoHc9VdLUpTW
   w==;
IronPort-SDR: HCx7xHhv6nLAa9Zw4alkD0PROjhcP6/VhOD9CkhAJ0UYqBaf+rkpVVsJX0BUPw3DerJDXMG6Wr
 LgI7XzVGcPKkQ9iSkT3Ez9bUrTFqAYp74V7rT3N8OyzZXkTeo2a7791lw5Zk+8k17Vykd6hV1l
 Symql/6LOxt1mCuoXKxk99uyAx3XtKXUWqhcAmaFYI9vASYl4UcCF0vOqHhZVF6BfjH6vOa0kU
 SWtw3c55MyCdaybqpi0qHmlhR5KZ64iZmw20PbhubcEvf8gCuFEZB7camGMB00dp3/k5e+3DN4
 fQmQc8HANmIoxDhuMFFk/ybT
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="144431478"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 11:09:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 11:09:47 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 31 Jan 2022 11:09:47 -0700
Date:   Mon, 31 Jan 2022 23:39:46 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support of selection
 between SGMII and GMII Interface
Message-ID: <20220131180946.sqxcbnhu54ajc5am@microsemi.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
 <20220127173055.308918-5-Raju.Lakkaraju@microchip.com>
 <YfMX1ob3+1RT+d8/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YfMX1ob3+1RT+d8/@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 01/27/2022 23:08, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +     /* GPY211 Interface enable */
> > +     chip_ver = lan743x_csr_read(adapter, FPGA_REV);
> > +     if (chip_ver) {
> > +             netif_info(adapter, drv, adapter->netdev,
> > +                        "FPGA Image version: 0x%08X\n", chip_ver);
> 
> We try to avoid spamming the kernel logs, so:
> 
> netif_dbg()
> 

Accepted. I will change

> > +             if (chip_ver & FPGA_SGMII_OP) {
> > +                     sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> > +                     sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
> > +                     sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> > +                     lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> > +                     netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> > +             } else {
> > +                     sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> > +                     sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> > +                     sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> > +                     lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> > +                     netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> > +             }
> > +     } else {
> > +             chip_ver = lan743x_csr_read(adapter, STRAP_READ);
> > +             netif_info(adapter, drv, adapter->netdev,
> > +                        "ASIC Image version: 0x%08X\n", chip_ver);
> 
> Here as well
> 

Accepted. I will change.

> > +             if (chip_ver & STRAP_READ_SGMII_EN_) {
> > +                     sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> > +                     sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
> > +                     sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
> > +                     lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> > +                     netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> 
> And def initially this and the next one.
> 

I did not get "def initially" means ?
Can you please some more information about this comment ?


> > +             } else {
> > +                     sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
> > +                     sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
> > +                     sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
> > +                     lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
> > +                     netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> > +             }
> > +     }
> 
>   Andrew

-- 

Thanks,
Raju

