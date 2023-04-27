Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302FA6EFEB0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbjD0Az0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbjD0AzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:55:24 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A043A92;
        Wed, 26 Apr 2023 17:55:23 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 615F924E1E4;
        Thu, 27 Apr 2023 08:55:16 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 08:55:16 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 08:55:15 +0800
Message-ID: <d67bee22-4706-7958-c002-296b2bdff4a2@starfivetech.com>
Date:   Thu, 27 Apr 2023 08:55:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
Content-Language: en-US
To:     Frank Sae <Frank.Sae@motor-comm.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-3-samin.guo@starfivetech.com>
 <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg support
From: Frank Sae <Frank.Sae@motor-comm.com>
to: Samin Guo <samin.guo@starfivetech.com>, <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>
data: 2023/4/26

> 
> 
> On 2023/4/26 14:35, Samin Guo wrote:
>> The motorcomm phy (YT8531) supports the ability to adjust the drive
>> strength of the rx_clk/rx_data, and the default strength may not be
>> suitable for all boards. So add configurable options to better match
>> the boards.(e.g. StarFive VisionFive 2)
>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  drivers/net/phy/motorcomm.c | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
>> index 2fa5a90e073b..08f28ed83e60 100644
>> --- a/drivers/net/phy/motorcomm.c
>> +++ b/drivers/net/phy/motorcomm.c
>> @@ -236,6 +236,11 @@
>>   */
>>  #define YTPHY_WCR_TYPE_PULSE			BIT(0)
>>  
>> +#define YTPHY_PAD_DRIVE_STRENGTH_REG		0xA010
>> +#define YTPHY_RGMII_RXC_DS			GENMASK(15, 13)
>> +#define YTPHY_RGMII_RXD_DS			GENMASK(5, 4)	/* Bit 1 and 0 of rgmii_rxd_ds */
>> +#define YTPHY_RGMII_RXD_DS2			BIT(12) 	/* Bit 2 of rgmii_rxd_ds */
>> +
> 
> Please  change YTPHY_RGMII_XXX  to YT8531_RGMII_XXX. YT8521's reg (0xA010) is not same as this.
> Keep bit order.

will fix.

> 
>>  #define YTPHY_SYNCE_CFG_REG			0xA012
>>  #define YT8521_SCR_SYNCE_ENABLE			BIT(5)
>>  /* 1b0 output 25m clock
>> @@ -1495,6 +1500,7 @@ static int yt8531_config_init(struct phy_device *phydev)
>>  {
>>  	struct device_node *node = phydev->mdio.dev.of_node;
>>  	int ret;
>> +	u32 val;
>>  
>>  	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
>>  	if (ret < 0)
>> @@ -1518,6 +1524,32 @@ static int yt8531_config_init(struct phy_device *phydev)
>>  			return ret;
>>  	}
>>  
>> +	if (!of_property_read_u32(node, "rx-clk-driver-strength", &val)) {
> 
> Please check the val of "val", add the handle of default value.
> 
Will fix it in the next version, thanks.
>> +		ret = ytphy_modify_ext_with_lock(phydev,
>> +						 YTPHY_PAD_DRIVE_STRENGTH_REG,
>> +						 YTPHY_RGMII_RXC_DS,
>> +						 FIELD_PREP(YTPHY_RGMII_RXC_DS, val));
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	if (!of_property_read_u32(node, "rx-data-driver-strength", &val)) {
>> +		if (val > FIELD_MAX(YTPHY_RGMII_RXD_DS)) {
>> +			val &= FIELD_MAX(YTPHY_RGMII_RXD_DS);
>> +			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
>> +			val |= YTPHY_RGMII_RXD_DS2;
>> +		} else {
>> +			val = FIELD_PREP(YTPHY_RGMII_RXD_DS, val);
>> +		}
>> +
>> +		ret = ytphy_modify_ext_with_lock(phydev,
>> +						 YTPHY_PAD_DRIVE_STRENGTH_REG,
>> +						 YTPHY_RGMII_RXD_DS | YTPHY_RGMII_RXD_DS2,
>> +						 val);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>>  	return 0;
>>  }
>>  

