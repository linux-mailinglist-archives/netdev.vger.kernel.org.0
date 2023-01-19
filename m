Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B009767316C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 06:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjASF4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 00:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjASF4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 00:56:05 -0500
Received: from out28-194.mail.aliyun.com (out28-194.mail.aliyun.com [115.124.28.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6049F10B;
        Wed, 18 Jan 2023 21:56:00 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0744085|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0161519-0.00312963-0.980718;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.QwzW1nf_1674107754;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QwzW1nf_1674107754)
          by smtp.aliyun-inc.com;
          Thu, 19 Jan 2023 13:55:56 +0800
Message-ID: <50e59ffd-aa52-4fde-c2b5-f5ce1dc64c95@motor-comm.com>
Date:   Thu, 19 Jan 2023 13:56:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com> <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
 <Y7goXXiRBE6XHuCc@lunn.ch>
 <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
 <Y8f254xNPdtR8gq1@lunn.ch>
Content-Language: en-US
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <Y8f254xNPdtR8gq1@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/18 21:40, Andrew Lunn wrote:
> On Wed, Jan 11, 2023 at 05:20:18PM +0800, Frank.Sae wrote:
>> Hi Andrew,
>>
>> On 2023/1/6 21:55, Andrew Lunn wrote:
>>>>> Why is this needed? When the MAC driver connects to the PHY, it passes
>>>>> phy-mode. For RGMII, this is one of:
>>>>
>>>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
>>>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
>>>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
>>>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,
>>>>>
>>>>> This tells you if you need to add a delay for the RX clock line, the
>>>>> TX clock line, or both. That is all you need to know for basic RGMII
>>>>> delays.
>>>>>
>>>>
>>>> This basic delay can be controlled by hardware or the phy-mode which
>>>> passes from MAC driver.
>>>> Default value depends on power on strapping, according to the voltage
>>>> of RXD0 pin (low = 0, turn off;   high = 1, turn on).
>>>>
>>>> Add this for the case that This basic delay is controlled by hardware,
>>>> and software don't change this.
>>>
>>> You should always do what phy-mode contains. Always. We have had
>>> problems in the past where a PHY driver ignored the phy-mode, and left
>>> the PHY however it was strapped. Which worked. But developers put the
>>> wrong phy-mode value in DT. Then somebody had a board which actually
>>> required that the DT value really did work, because the strapping was
>>> wrong. So the driver was fixed to respect the PHY mode, made that
>>> board work, and broke all the other boards which had the wrong
>>> phy-mode in DT.
>>>
>>> If the user want the driver to leave the mode alone, use the
>>> strapping, they should use PHY_INTERFACE_MODE_NA. It is not well
>>> documented, but it is used in a few places. However, i don't recommend
>>> it.
>>>
>>
>> RX delay = rx-delay-basic (0ns or 1.9ns) + x-delay-additional-ps
>> (N*150ps, N = 0 ~ 15)
>>  If rx-delay-basic is removed and controlled by phy-mode.
>>  when phy-mode is  rgmii-id or rgmii-rxid, RX delay is 1.9ns + N*150ps.
>>  But sometimes 1.9ns is still too big, we just need  0ns + N*150ps.
>>
>> For this case, can we do like following ?
>> rx-internal-delay-ps:
>>     enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500,
>> 1650, 1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
>> 2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
>>     default: 0
>>  rx-internal-delay-ps is 0ns + N*150ps and  1.9ns + N*150ps.
>>  And check whether need rx-delay-basic (1.9ns) by the val of
>> rx-internal-delay-ps?
> 
> Please take a look at phy_get_internal_delay() and the drivers which
> use it.
> 
>     Andrew

 Thanks. But it may be not suitable.

rx-internal-delay-ps has two part:
0ns + N*150ps =
0,150,300,450,600,750,900,1050,1200,1350,1500,1650,1800,1950,2100,2250

1.9ns + N*150ps =
1900,2050,2200,2350,2500,2650,2800,2950,3100,3250,3400,3550,3700,3850,4000,4150

The problem is "1900,2050,2200" is less than "2250".

If I take this two parts in one sorted table, there will be three
tables, one for tx-internal-delay-ps, one for rx-internal-delay-ps and
one for the rx index to reg(delay value and 1.9ns on or off) value.

So we tend to use the following methods.

#define YT8521_CCR_RXC_DLY_1_900_NS		1900

#define YT8521_RC1R_RGMII_0_000_NS		0
#define YT8521_RC1R_RGMII_0_150_NS		1
...
#define	YT8521_RC1R_RGMII_2_250_NS		15

struct ytphy_cfg_reg_map {
	u32 cfg;
	u32 reg;
};

static const struct ytphy_cfg_reg_map ytphy_rgmii_delays[] = {
	/* for tx delay / rx delay with YT8521_CCR_RXC_DLY_EN is not set. */
	{ 0,	YT8521_RC1R_RGMII_0_000_NS },
	{ 150,	YT8521_RC1R_RGMII_0_150_NS },
	...
	{ 2250,	YT8521_RC1R_RGMII_2_250_NS },

	/* only for rx delay with YT8521_CCR_RXC_DLY_EN is set. */
	{ 0    + YT8521_CCR_RXC_DLY_1_900_NS,YT8521_RC1R_RGMII_0_000_NS },
	{ 150  + YT8521_CCR_RXC_DLY_1_900_NS,YT8521_RC1R_RGMII_0_150_NS },
	...
	{ 2250 + YT8521_CCR_RXC_DLY_1_900_NS,YT8521_RC1R_RGMII_2_250_NS }
};


static u32 ytphy_get_delay_reg_value(struct phy_device *phydev,
				     const char *prop_name,
				     const struct ytphy_cfg_reg_map *tbl,
				     int tb_size,
				     u16 *rxc_dly_en,
				     u32 dflt)
{
	struct device_node *node = phydev->mdio.dev.of_node;
	int tb_size_half = tb_size / 2;
	u32 val;
	int i;

	if (of_property_read_u32(node, prop_name, &val))
		return dflt;

	/* when rxc_dly_en is NULL, it is get the delay for tx, only half of
	 * tb_size is valid.
	 */
	if (!rxc_dly_en)
		tb_size = tb_size_half;

	for (i = 0; i < tb_size; i++) {
		if (tbl[i].cfg == val) {
			if (rxc_dly_en && i < tb_size_half)
				*rxc_dly_en = 0;
			return tbl[i].reg;
		}
	}

	phydev_warn(phydev, "Unsupported value %d for %s using default (%u)\n",
		    val, prop_name, dflt);
	return dflt;
}

static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
{
	int tb_size = ARRAY_SIZE(ytphy_rgmii_delays);
	u16 rxc_dly_en = YT8521_CCR_RXC_DLY_EN;
	u32 rx_reg, tx_reg;
	u16 mask, val = 0;
	int ret;

	rx_reg = ytphy_get_delay_reg_value(phydev, "rx-internal-delay-ps",
					   ytphy_rgmii_delays, tb_size,
					   &rxc_dly_en,
					   YT8521_RC1R_RGMII_0_000_NS);
	tx_reg = ytphy_get_delay_reg_value(phydev, "tx-internal-delay-ps",
					   ytphy_rgmii_delays, tb_size, NULL,
					   YT8521_RC1R_RGMII_0_150_NS);

	switch (phydev->interface) {
	case PHY_INTERFACE_MODE_RGMII:
		rxc_dly_en = 0;
		break;
	case PHY_INTERFACE_MODE_RGMII_RXID:
		val |= FIELD_PREP(YT8521_RC1R_RX_DELAY_MASK, rx_reg);
		break;
	case PHY_INTERFACE_MODE_RGMII_TXID:
		rxc_dly_en = 0;
		val |= FIELD_PREP(YT8521_RC1R_GE_TX_DELAY_MASK, tx_reg);
		break;
	case PHY_INTERFACE_MODE_RGMII_ID:
		val |= FIELD_PREP(YT8521_RC1R_RX_DELAY_MASK, rx_reg) |
		       FIELD_PREP(YT8521_RC1R_GE_TX_DELAY_MASK, tx_reg);
		break;
	default: /* do not support other modes */
		return -EOPNOTSUPP;
	}

	ret = ytphy_modify_ext(phydev, YT8521_CHIP_CONFIG_REG,
			       YT8521_CCR_RXC_DLY_EN, rxc_dly_en);
	if (ret < 0)
		return ret;

	/* Generally, it is not necessary to adjust YT8521_RC1R_FE_TX_DELAY */
	mask = YT8521_RC1R_RX_DELAY_MASK | YT8521_RC1R_GE_TX_DELAY_MASK;
	return ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG, mask, val);
}
