Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBB76EF1E1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbjDZK0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbjDZK0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:26:01 -0400
Received: from out28-101.mail.aliyun.com (out28-101.mail.aliyun.com [115.124.28.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D9A3C0C;
        Wed, 26 Apr 2023 03:25:59 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1189686|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0275812-0.000346042-0.972073;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.SRCgG.0_1682504752;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.SRCgG.0_1682504752)
          by smtp.aliyun-inc.com;
          Wed, 26 Apr 2023 18:25:53 +0800
Message-ID: <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
Date:   Wed, 26 Apr 2023 18:24:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
Content-Language: en-US
To:     Samin Guo <samin.guo@starfivetech.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-3-samin.guo@starfivetech.com>
From:   Frank Sae <Frank.Sae@motor-comm.com>
In-Reply-To: <20230426063541.15378-3-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/26 14:35, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, and the default strength may not be
> suitable for all boards. So add configurable options to better match
> the boards.(e.g. StarFive VisionFive 2)
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  drivers/net/phy/motorcomm.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 2fa5a90e073b..08f28ed83e60 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -236,6 +236,11 @@
>   */
>  #define YTPHY_WCR_TYPE_PULSE			BIT(0)
>  
> +#define YTPHY_PAD_DRIVE_STRENGTH_REG		0xA010
> +#define YTPHY_RGMII_RXC_DS			GENMASK(15, 13)
> +#define YTPHY_RGMII_RXD_DS			GENMASK(5, 4)	/* Bit 1 and 0 of rgmii_rxd_ds */
> +#define YTPHY_RGMII_RXD_DS2			BIT(12) 	/* Bit 2 of rgmii_rxd_ds */
> +

Please  change YTPHY_RGMII_XXX  to YT8531_RGMII_XXX. YT8521's reg (0xA010) is not same as this.
Keep bit order.

>  #define YTPHY_SYNCE_CFG_REG			0xA012
>  #define YT8521_SCR_SYNCE_ENABLE			BIT(5)
>  /* 1b0 output 25m clock
> @@ -1495,6 +1500,7 @@ static int yt8531_config_init(struct phy_device *phydev)
>  {
>  	struct device_node *node = phydev->mdio.dev.of_node;
>  	int ret;
> +	u32 val;
>  
>  	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
>  	if (ret < 0)
> @@ -1518,6 +1524,32 @@ static int yt8531_config_init(struct phy_device *phydev)
>  			return ret;
>  	}
>  
> +	if (!of_property_read_u32(node, "rx-clk-driver-strength", &val)) {

Please check the val of "val", add the handle of default value.

> +		ret = ytphy_modify_ext_with_lock(phydev,
> +						 YTPHY_PAD_DRIVE_STRENGTH_REG,
> +						 YTPHY_RGMII_RXC_DS,
> +						 FIELD_PREP(YTPHY_RGMII_RXC_DS, val));
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (!of_property_read_u32(node, "rx-data-driver-strength", &val)) {
> +		if (val > FIELD_MAX(YTPHY_RGMII_RXD_DS)) {
> +			val &= FIELD_MAX(YTPHY_RGMII_RXD_DS);
> +			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
> +			val |= YTPHY_RGMII_RXD_DS2;
> +		} else {
> +			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
> +		}
> +
> +		ret = ytphy_modify_ext_with_lock(phydev,
> +						 YTPHY_PAD_DRIVE_STRENGTH_REG,
> +						 YTPHY_RGMII_RXD_DS | YTPHY_RGMII_RXD_DS2,
> +						 val);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	return 0;
>  }
>  
