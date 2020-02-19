Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77441164DCF
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgBSSkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:40:35 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:41410 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSSkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:40:35 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01JIeIVq103516;
        Wed, 19 Feb 2020 12:40:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582137618;
        bh=xdQBLr+CfP+yaUwUQ2EMZd7UoeNHkQT4qEh1vOrBwsw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=s9VaJVcpExyYbY/s14r9Sc+PPu9gg7a4OBHabJ5Cmi3WRq5bR2B5yKzCkj3M5vdDU
         IIV/7Px+sO/CLaxCbA7jVUGFOBwzrSiL7zi6V2Wrpl/oWoFKUljU4ePA2cQFZ8IBVK
         KMwOGMymnZqVQtT/LaIFqc8iI6zPE6DNLLLDTp+w=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01JIeIcH083901
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Feb 2020 12:40:18 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 19
 Feb 2020 12:40:18 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 19 Feb 2020 12:40:18 -0600
Received: from [10.250.73.201] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01JIeHjw041691;
        Wed, 19 Feb 2020 12:40:17 -0600
Subject: Re: [PATCH net-master] net: phy: dp83848: Add the TI TLK05/06 PHY ID
To:     Dan Murphy <dmurphy@ti.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200219181613.5898-1-dmurphy@ti.com>
From:   "Andrew F. Davis" <afd@ti.com>
Message-ID: <f0020418-05d2-8991-0b1c-d99863ce140e@ti.com>
Date:   Wed, 19 Feb 2020 13:40:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219181613.5898-1-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 1:16 PM, Dan Murphy wrote:
> Add the TLK05/06 PHY ID to the DP83848 driver.  The TI website indicates
> that the DP83822 device is a drop in replacement for the TLK05 device
> but the TLK device does not have WoL support.  The TLK device is
> register compatible to the DP83848 and the DP83848 does not support WoL
> either.  So this PHY can be associated with the DP83848 driver.
> 
> The initial TLKx PHY ID in the driver is a legacy ID and the public data
> sheet indicates a new PHY ID.  So not to break any kernels out there
> both IDs will continue to be supported in this driver.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83848.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
> index 54c7c1b44e4d..66907cfa816a 100644
> --- a/drivers/net/phy/dp83848.c
> +++ b/drivers/net/phy/dp83848.c
> @@ -12,6 +12,7 @@
>  #define TI_DP83620_PHY_ID		0x20005ce0
>  #define NS_DP83848C_PHY_ID		0x20005c90
>  #define TLK10X_PHY_ID			0x2000a210
> +#define TLK105_06_PHY_ID		0x2000a211
>  
>  /* Registers */
>  #define DP83848_MICR			0x11 /* MII Interrupt Control Register */
> @@ -85,6 +86,7 @@ static struct mdio_device_id __maybe_unused dp83848_tbl[] = {
>  	{ NS_DP83848C_PHY_ID, 0xfffffff0 },
>  	{ TI_DP83620_PHY_ID, 0xfffffff0 },
>  	{ TLK10X_PHY_ID, 0xfffffff0 },
> +	{ TLK105_06_PHY_ID, 0xfffffff0 },


If the PHY ID masks out the lowest 4 bits here (they are just revision),
wont we still always match on the base TLK10X_PHY_ID? Does this patch
change anything?

Andrew


>  	{ }
>  };
>  MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
> @@ -115,6 +117,8 @@ static struct phy_driver dp83848_driver[] = {
>  			   dp83848_config_init),
>  	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
>  			   NULL),
> +	DP83848_PHY_DRIVER(TLK105_06_PHY_ID, "TI TLK105/06 10/100 Mbps PHY",
> +			   NULL),
>  };
>  module_phy_driver(dp83848_driver);
>  
> 
