Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12614C29C7
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiBXKmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiBXKmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:42:52 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4D716A587;
        Thu, 24 Feb 2022 02:42:21 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 21OAg0eH081267;
        Thu, 24 Feb 2022 04:42:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1645699320;
        bh=9mbVPX5yGxsgscu/w86Ery9cHYKSihH4xF3AO5vM/3g=;
        h=Date:From:Subject:To:CC:References:In-Reply-To;
        b=quzaTS8v57gU5qNp4wFdpYQlX8eU+jzDtUIHFVxXOKwBU/qL3yzz9LLRIHHPokEXv
         D2CgcYrVQj661wM5FwLZ5FHXKWs3JwKPg+4i1aKgBtg3CUp0OYBb0Uo7BoYGVxJSUJ
         52TBMLJFhlbgNyJF/Mu6RCi0LXZdIJVYuJ1YOc3I=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 21OAg0MS022106
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Feb 2022 04:42:00 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 24
 Feb 2022 04:41:59 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 24 Feb 2022 04:41:59 -0600
Received: from [10.250.232.149] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 21OAftkM124845;
        Thu, 24 Feb 2022 04:41:56 -0600
Message-ID: <220e82d4-1c20-c540-7dcf-a8fb25f8935d@ti.com>
Date:   Thu, 24 Feb 2022 16:11:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Siddharth Narayan Vadapalli <s-vadapalli@ti.com>
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
To:     Raag Jadav <raagjadav@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham <kishon@ti.com>, <s-vadapalli@ti.com>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
Content-Language: en-US
In-Reply-To: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 05/02/22 12:14, Raag Jadav wrote:
> Enable MAC SerDes autonegotiation to distinguish between
> 1000BASE-X, SGMII and QSGMII MAC.
> 
> Signed-off-by: Raag Jadav <raagjadav@gmail.com>
> ---
>   drivers/net/phy/mscc/mscc.h      |  2 ++
>   drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++++++++++++++
>   2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index a50235f..366db14 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -195,6 +195,8 @@ enum rgmii_clock_delay {
>   #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
>   
>   /* Extended Page 3 Registers */
> +#define MSCC_PHY_SERDES_PCS_CTRL	  16
> +#define MSCC_PHY_SERDES_ANEG		  BIT(7)
>   #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
>   #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
>   #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index ebfeeb3..6db43a5 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -1685,6 +1685,25 @@ static int vsc8574_config_host_serdes(struct phy_device *phydev)
>   			   PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
>   }
>   
> +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> +{
> +	int rc;
> +	u16 reg_val = 0;
> +
> +	if (enabled)
> +		reg_val = MSCC_PHY_SERDES_ANEG;
> +
> +	mutex_lock(&phydev->lock);
> +
> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> +			      reg_val);
> +
> +	mutex_unlock(&phydev->lock);
> +
> +	return rc;
> +}
> +
>   static int vsc8584_config_init(struct phy_device *phydev)
>   {
>   	struct vsc8531_private *vsc8531 = phydev->priv;
> @@ -1772,6 +1791,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
>   					      VSC8572_RGMII_TX_DELAY_MASK);
>   		if (ret)
>   			return ret;
> +	} else {
> +		/* Enable clause 37 */
> +		ret = vsc85xx_config_inband_aneg(phydev, true);
> +		if (ret)
> +			return ret;
>   	}
>   
>   	ret = genphy_soft_reset(phydev);

The same auto-negotiation configuration is also required for VSC8514.
The following patch is required to get Ethernet working with the Quad
port Ethernet Add-On card (QSGMII mode) connected to Texas Instruments
J7 common processor board.

Let me know if I should send it as a separate patch.

Thanks and Regards,
Siddharth Vadapalli.

8<------------------SNIP----------------------------

 From 2ab92251ba7a09bc97476cef6c760beefb0d3cae Mon Sep 17 00:00:00 2001
From: Siddharth Vadapalli <s-vadapalli@ti.com>
Date: Thu, 17 Feb 2022 15:45:20 +0530
Subject: [PATCH] net: phy: mscc: Add auto-negotiation feature to VSC8514

Auto-negotiation is currently enabled for VSC8584. It is also required
for VSC8514. Invoke the vsc85xx_config_inband_aneg() function from the
vsc8514_config_init() function present in mscc_main.c to start the
auto-negotiation process. This is required to get Ethernet working with
the Quad port Ethernet Add-On card (QSGMII mode) connected to Texas
Instruments J7 common processor board.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
  drivers/net/phy/mscc/mscc_main.c | 5 +++++
  1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c 
b/drivers/net/phy/mscc/mscc_main.c
index 6db43a5c3b5e..b9a5662e7934 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2119,6 +2119,11 @@ static int vsc8514_config_init(struct phy_device 
*phydev)

  	ret = genphy_soft_reset(phydev);

+	if (ret)
+		return ret;
+
+	ret = vsc85xx_config_inband_aneg(phydev, true);
+
  	if (ret)
  		return ret;
