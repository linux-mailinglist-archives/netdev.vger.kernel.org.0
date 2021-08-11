Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7BB3E9714
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhHKRxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:53:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21027 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhHKRxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628704359; x=1660240359;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YvLsHg/EptJ2LvMJ2mhuOEkSOGfZFINShOVVjydMfTQ=;
  b=dMshmNB00YL5incch5ZmboUUEd8VU0p5IA6LvVNgZTHo2rA0tFsxhw+n
   xz8rGgQdDfOkPelAxDgckZA0ymZhyz95udWmoiwVBd703xv6bYPTA0HL6
   6lk2LNKsYbUii0+PRvk9cZ5IrvdSul2uvFicGxp91U/Fu7h6t4bQMIhxN
   GPSLcHG92tP3TgplqrSTxVAenLGSaWlmNxyPIwv8A0RnNo/LvcxwV5vJ0
   rfqimYCt5PTTKhvpl2sqm0/4/nuIgdHF15/zsWkpYW+4Lz6wQdt7e8o0o
   UPYgrNMSizT5RpDsKG3YBx0AjgEZtuEoeRflrmP3xI4nPOCoQpUJGSUDI
   A==;
IronPort-SDR: qNGjdwFKDI+SOaSLk7ptUluxc82Y00Tu9YHqtBifeHUfu5wKOjdpccBkExuEdPnuf8r/dv4A8Q
 K1yrVn8cpvPCJ1wSCfkJNXN3mWXEr3/GxRJeDesnHVdgm6kHAATIEKU/uP9tP6MGyB7YeQZa9y
 hfxrevvgLWhnGFVTAUpJxasRLStirZSssSXUD+6HCamhu18I9q3EbtN1IUmydhc6hiTTcrIsSv
 2lXW4Huv22qv4/i9wg+WZL+E+fdmzL0fGG8iH9TLJhH/w4ZTyEBVTV0mWwIOVDNJMTFsapU9ZO
 OI4wvxLekKig6HpddjPEZw8i
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="132446740"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Aug 2021 10:52:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 10:52:38 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 11 Aug 2021 10:52:33 -0700
Message-ID: <90899ba866a198ce60ac02f990200f0335759446.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 03/10] net: phy: Add support for LAN937x T1
 phy driver
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Wed, 11 Aug 2021 23:22:32 +0530
In-Reply-To: <20210723173108.459770-4-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-4-prasanna.vengateshan@microchip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Fri, 2021-07-23 at 23:01 +0530, Prasanna Vengateshan wrote:
> Added support for Microchip LAN937x T1 phy driver. The sequence of
> initialization is used commonly for both LAN87xx and LAN937x
> drivers. The new initialization sequence is an improvement to
> existing LAN87xx and it is shared with LAN937x.
> 
> Also relevant comments are added in the existing code and existing
> soft-reset customized code has been replaced with
> genphy_soft_reset().
> 
> access_ereg_clr_poll_timeout() API is introduced for polling phy
> bank write and this is linked with PHYACC_ATTR_MODE_POLL.
> 
> Finally introduced function table for LAN937X_T1_PHY_ID along with
> microchip_t1_phy_driver struct.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/phy/microchip_t1.c | 319 +++++++++++++++++++++++++++------
>  1 file changed, 260 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
> index 4dc00bd5a8d2..a3f1b5d123ce 100644
> --- a/drivers/net/phy/microchip_t1.c
> +++ b/drivers/net/phy/microchip_t1.c
> @@ -30,15 +30,53 @@
>  #define        PHYACC_ATTR_MODE_READ           0
>  #define        PHYACC_ATTR_MODE_WRITE          1
>  #define        PHYACC_ATTR_MODE_MODIFY         2
> +#define        PHYACC_ATTR_MODE_POLL           3
>  
>  #define        PHYACC_ATTR_BANK_SMI            0
>  #define        PHYACC_ATTR_BANK_MISC           1
>  #define        PHYACC_ATTR_BANK_PCS            2
>  #define        PHYACC_ATTR_BANK_AFE            3
> +#define        PHYACC_ATTR_BANK_DSP            4
>  #define        PHYACC_ATTR_BANK_MAX            7
 

Are there any items that need a change in this patch? It will be helpful for me
to include them in the next version. Thanks.


Prasanna V 


