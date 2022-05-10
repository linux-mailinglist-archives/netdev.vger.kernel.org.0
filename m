Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B55222A0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348151AbiEJRdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348141AbiEJRdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:33:13 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64FA283A1E
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:29:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id z2so32790590ejj.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sHJzMSyNu+INKz+56QDv1Z0TjlV7hVoRp5SivF6m3d0=;
        b=NiMJ3NYFXVdVydaVihO66CNLH02MQeVw4wGR/tYwPWGOameeQ48CI3+4GHd5ddb4EB
         1SkvuLZ09bUkaVMpxr0XEj0zNx4mZnE8S+Qqv52thc5GSCD4OF2p505e5QqtY9enEoxR
         7OnfgIOaUMU2njE4gf72yBV2OT6NlZBeJ0iAI/qiTbHUU1igKi8V3pfR0v+VCz/ZWBSF
         g6HyRMQuDYuZ1+kgCbhyvWyd/epWW/4pXRFtTTIjKlfz3G+SbYphlGp1JUMTBE02UCEK
         IhSiI5aCz/asFOy3i4XHpXVtKNYvxMgGxBLeQHzO77aWDjL4Po/KKqwWyjNFIQLXwPVd
         KJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sHJzMSyNu+INKz+56QDv1Z0TjlV7hVoRp5SivF6m3d0=;
        b=UMXATe9DVcTzDptIR3fs7E2CvaV3NlgPn8fKTetrT4CIciYc07uTR9dOadnjOMsdNS
         Csr6nTclU3j9rH3I8djks0ggXaBsQT13gORSGnv8nx+vT+DL84RZ94RVkOkAMYi3veRd
         WStGNBpkrGP4Op7b1hQGTxCQ/uTa1Gu4l2NsiUadIIWGkQDMAZ5VR0y+sTWxPcZvirZ5
         OXUDHVCKtNCDdsRJyu6PRaTwQ9FEUiFbX7VA7ViXdOfNGJK/n4pjIDYu4QhbsQ4OuSgD
         v5vKm8h3T4dpBBG2eSnP2CQD/nM3cApjYt9S6JuHxcZJJvaoOZrTS6D7YWl0R6gqOYkf
         hBBw==
X-Gm-Message-State: AOAM5338tQY9y/QqEcn6FHgI4mPAjK26lvmOMEpRgvnL3yQPgmg22xUT
        rm1mtTG3iXfgZho7D2GE6BU=
X-Google-Smtp-Source: ABdhPJz1cQHTsLNKy+xv47A4fdvK7rHON2XGtiTkSq2kip7i5pWNMev8t71tEdS6eI+XMb6paRxsKg==
X-Received: by 2002:a17:906:9b8a:b0:6f3:fcc9:f863 with SMTP id dd10-20020a1709069b8a00b006f3fcc9f863mr21255964ejc.672.1652203753132;
        Tue, 10 May 2022 10:29:13 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id t13-20020a056402524d00b0041d527833b9sm7990189edd.3.2022.05.10.10.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 10:29:12 -0700 (PDT)
Date:   Tue, 10 May 2022 20:29:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Message-ID: <20220510172910.kthpd7kokb2qk27l@skbuf>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-5-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220508224848.2384723-5-hauke@hauke-m.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 12:48:48AM +0200, Hauke Mehrtens wrote:
> This adds support for SGMII and HSGMII on RTL8367S switches.
> HSGMII is configured using the 2500BASEX mode.
> This is baed on the rtl8367c driver found in OpenWrt.
> 
> For (H)SGMII mode we have to load a firmware into some memory which gets
> executed on the integrated 8051. The firmware binary was added as a
> array into the driver with a GPL license notice on top.
> 
> This was tested on RTL8367S (ver=0x00a0, opt=0x0001).
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 356 +++++++++++++++++++++++++++-
>  1 file changed, 345 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index f9b690251155..5504a34fffeb 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2021 Alvin Šipraga <alsi@bang-olufsen.dk>
>   * Copyright (C) 2021 Michael Rasmussen <mir@bang-olufsen.dk>
> + * Copyright (C) 2022 Hauke Mehrtens <hauke@hauke-m.de>
>   *
>   * The RTL8365MB-VC is a 4+1 port 10/100/1000M switch controller. It includes 4
>   * integrated PHYs for the user facing ports, and an extension interface which
> @@ -98,6 +99,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/regmap.h>
>  #include <linux/if_bridge.h>
> +#include <linux/firmware.h>
>  
>  #include "realtek.h"
>  
> @@ -135,6 +137,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
>  
>  /* Chip reset register */
>  #define RTL8365MB_CHIP_RESET_REG	0x1322
> +#define RTL8365MB_CHIP_RESET_DW8051	BIT(4)
>  #define RTL8365MB_CHIP_RESET_SW_MASK	0x0002
>  #define RTL8365MB_CHIP_RESET_HW_MASK	0x0001
>  
> @@ -278,6 +281,29 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
>  #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_DUPLEX_MASK		0x0004
>  #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK		0x0003
>  
> +#define RTL8365MB_SDS_MISC			0x1d11
> +#define  RTL8365MB_CFG_SGMII_RXFC		0x4000
> +#define  RTL8365MB_CFG_SGMII_TXFC		0x2000
> +#define  RTL8365MB_INB_ARB			0x1000
> +#define  RTL8365MB_CFG_MAC8_SEL_HSGMII		0x0800
> +#define  RTL8365MB_CFG_SGMII_FDUP		0x0400
> +#define  RTL8365MB_CFG_SGMII_LINK		0x0200
> +#define  RTL8365MB_CFG_SGMII_SPD		0x0180
> +#define  RTL8365MB_CFG_MAC8_SEL_SGMII		0x0040
> +#define  RTL8365MB_CFG_INB_SEL			0x0038
> +#define  RTL8365MB_CFG_SDS_MODE_18C		0x0007
> +
> +#define RTL8365MB_SDS_INDACS_CMD		0x6600
> +#define RTL8365MB_SDS_INDACS_ADR		0x6601
> +#define RTL8365MB_SDS_INDACS_DATA		0x6602
> +
> +#define RTL8365MB_MISC_CFG0			0x130c
> +#define  RTL8365MB_MISC_CFG0_DW8051_EN		BIT(5)
> +
> +#define RTL8365MB_DW8051_RDY			0x1336
> +#define  RTL8365MB_DW8051_RDY_IROM_MSB		BIT(2)
> +#define  RTL8365MB_DW8051_RDY_ACS_IROM_EN	BIT(1)
> +
>  /* CPU port mask register - controls which ports are treated as CPU ports */
>  #define RTL8365MB_CPU_PORT_MASK_REG	0x1219
>  #define   RTL8365MB_CPU_PORT_MASK_MASK	0x07FF
> @@ -296,6 +322,8 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
>  #define RTL8365MB_CFG0_MAX_LEN_REG	0x088C
>  #define   RTL8365MB_CFG0_MAX_LEN_MASK	0x3FFF
>  
> +#define RTL8365MB_BYPASS_LINE_RATE		0x03f7
> +
>  /* Port learning limit registers */
>  #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE		0x0A20
>  #define RTL8365MB_LUT_PORT_LEARN_LIMIT_REG(_physport) \
> @@ -493,6 +521,39 @@ static const struct rtl8365mb_jam_tbl_entry rtl8365mb_init_jam_common[] = {
>  	{ 0x1D32, 0x0002 },
>  };
>  
> +struct rtl8365mb_sds_init {
> +	unsigned int data;
> +	unsigned int addr;
> +};
> +
> +static const struct rtl8365mb_sds_init redData[] = {
> +	{0x04D7, 0x0480}, {0xF994, 0x0481}, {0x21A2, 0x0482}, {0x6960, 0x0483},
> +	{0x9728, 0x0484}, {0x9D85, 0x0423}, {0xD810, 0x0424}, {0x83F2, 0x002E}
> +};
> +
> +static const struct rtl8365mb_sds_init redDataSB[] = {
> +	{0x04D7, 0x0480}, {0xF994, 0x0481}, {0x31A2, 0x0482}, {0x6960, 0x0483},
> +	{0x9728, 0x0484}, {0x9D85, 0x0423}, {0xD810, 0x0424}, {0x83F2, 0x002E}
> +};
> +
> +static const struct rtl8365mb_sds_init redData1_5_6[] = {
> +	{0x82F1, 0x0500}, {0xF195, 0x0501}, {0x31A2, 0x0502}, {0x796C, 0x0503},
> +	{0x9728, 0x0504}, {0x9D85, 0x0423}, {0xD810, 0x0424}, {0x0F80, 0x0001},
> +	{0x83F2, 0x002E}
> +};
> +
> +static const struct rtl8365mb_sds_init redData8_9[] = {
> +	{0x82F1, 0x0500}, {0xF995, 0x0501}, {0x31A2, 0x0502}, {0x796C, 0x0503},
> +	{0x9728, 0x0504}, {0x9D85, 0x0423}, {0xD810, 0x0424}, {0x0F80, 0x0001},
> +	{0x83F2, 0x002E}
> +};
> +
> +static const struct rtl8365mb_sds_init redDataHB[] = {
> +	{0x82F0, 0x0500}, {0xF195, 0x0501}, {0x31A2, 0x0502}, {0x7960, 0x0503},
> +	{0x9728, 0x0504}, {0x9D85, 0x0423}, {0xD810, 0x0424}, {0x0F80, 0x0001},
> +	{0x83F2, 0x002E}
> +};
> +
>  enum rtl8365mb_stp_state {
>  	RTL8365MB_STP_STATE_DISABLED = 0,
>  	RTL8365MB_STP_STATE_BLOCKING = 1,
> @@ -801,6 +862,232 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>  	return DSA_TAG_PROTO_RTL8_4;
>  }
>  
> +static int rtl8365mb_sds_indacs_write(struct realtek_priv *priv, unsigned int addr,
> +				      unsigned int data)
> +{
> +	int ret;
> +
> +	ret = regmap_write(priv->map, RTL8365MB_SDS_INDACS_DATA, data);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(priv->map, RTL8365MB_SDS_INDACS_ADR, addr);
> +	if (ret)
> +		return ret;
> +
> +	return regmap_write(priv->map, RTL8365MB_SDS_INDACS_CMD, 0x00C0);
> +}
> +
> +static int rtl8365mb_sds_indacs_read(struct realtek_priv *priv, unsigned int addr,
> +				     unsigned int *data)
> +{
> +	int ret;
> +
> +	ret = regmap_write(priv->map, RTL8365MB_SDS_INDACS_ADR, addr);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(priv->map, RTL8365MB_SDS_INDACS_CMD, 0x00C0);
> +	if (ret)
> +		return ret;
> +
> +	return regmap_write(priv->map, RTL8365MB_SDS_INDACS_DATA, *data);
> +}
> +
> +static int rtl8365mb_ext_init_sgmii_fw(struct realtek_priv *priv)
> +{
> +	struct device *dev = priv->dev;
> +	const struct firmware *fw;
> +	int ret;
> +	int i;
> +
> +	ret = request_firmware(&fw, "rtl_switch/rtl8367s-sgmii.bin", dev);
> +	if (ret) {
> +		dev_err(dev, "failed to load firmware rtl_switch/rtl8367s-sgmii.bin, error: %i\n",

Can you put the firmware name here and in the MODULE_FIRMWARE definition
behind a common macro?

> +			ret);
> +		return ret;
> +	}
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_CHIP_RESET_REG,
> +				 RTL8365MB_CHIP_RESET_DW8051,
> +				 FIELD_PREP(RTL8365MB_CHIP_RESET_DW8051, 1));
> +	if (ret)
> +		goto release_fw;
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_MISC_CFG0,
> +				 RTL8365MB_MISC_CFG0_DW8051_EN,
> +				 FIELD_PREP(RTL8365MB_MISC_CFG0_DW8051_EN, 1));
> +	if (ret)
> +		goto release_fw;
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_DW8051_RDY,
> +				 RTL8365MB_DW8051_RDY_ACS_IROM_EN,
> +				 FIELD_PREP(RTL8365MB_DW8051_RDY_ACS_IROM_EN, 1));
> +	if (ret)
> +		goto release_fw;
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_DW8051_RDY,
> +				 RTL8365MB_DW8051_RDY_IROM_MSB,
> +				 FIELD_PREP(RTL8365MB_DW8051_RDY_IROM_MSB, 0));
> +	if (ret)
> +		goto release_fw;
> +
> +	for (i = 0; i < fw->size; i++) {
> +		ret = regmap_write(priv->map, 0xE000 + i, fw->data[i]);
> +		if (ret)
> +			goto release_fw;
> +	}
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_DW8051_RDY,
> +				 RTL8365MB_DW8051_RDY_IROM_MSB,
> +				 FIELD_PREP(RTL8365MB_DW8051_RDY_IROM_MSB, 0));
> +	if (ret)
> +		goto release_fw;
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_DW8051_RDY,
> +				 RTL8365MB_DW8051_RDY_ACS_IROM_EN,
> +				 FIELD_PREP(RTL8365MB_DW8051_RDY_ACS_IROM_EN, 0));
> +	if (ret)
> +		goto release_fw;
> +
> +	ret = regmap_update_bits(priv->map, RTL8365MB_CHIP_RESET_REG,
> +				 RTL8365MB_CHIP_RESET_DW8051,
> +				 FIELD_PREP(RTL8365MB_CHIP_RESET_DW8051, 0));
> +
> +release_fw:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +static int rtl8365mb_ext_init_sgmii(struct realtek_priv *priv, int port, phy_interface_t interface)
> +{
> +	struct rtl8365mb *mb;
> +	int interface_mode;
> +	int sds_mode;
> +	const struct rtl8365mb_sds_init *sds_init;
> +	size_t sds_init_len;
> +	int ext_int;
> +	int ret;
> +	int i;
> +	int val;
> +	int mask;

Please keep variables sorted longest to shortest.

> +
> +	mb = priv->chip_data;
> +
> +	if (mb->chip_id != RTL8365MB_CHIP_ID_8365MB_VC)
> +		return -EINVAL;
> +
> +	ext_int = rtl8365mb_extint_port_map[port];
> +	if (ext_int != 1)
> +		return -EINVAL;
> +
> +	if (interface == PHY_INTERFACE_MODE_SGMII) {
> +		sds_mode = FIELD_PREP(RTL8365MB_CFG_MAC8_SEL_SGMII, 1);
> +		interface_mode = RTL8365MB_EXT_PORT_MODE_SGMII;
> +
> +		if (mb->chip_option == 0) {
> +			sds_init = redData;
> +			sds_init_len = ARRAY_SIZE(redData);
> +		} else {
> +			sds_init = redDataSB;
> +			sds_init_len = ARRAY_SIZE(redDataSB);
> +		}
> +	} else if (interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		sds_mode = FIELD_PREP(RTL8365MB_CFG_MAC8_SEL_HSGMII, 1);
> +		interface_mode = RTL8365MB_EXT_PORT_MODE_HSGMII;
> +
> +		if (mb->chip_option == 0) {
> +			switch (mb->chip_ver & 0x00F0) {
> +			case 0x0010:
> +			case 0x0050:
> +			case 0x0060:
> +				sds_init = redData1_5_6;
> +				sds_init_len = ARRAY_SIZE(redData1_5_6);
> +				break;
> +			case 0x0080:
> +			case 0x0090:
> +				sds_init = redData8_9;
> +				sds_init_len = ARRAY_SIZE(redData8_9);
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +		} else {
> +			sds_init = redDataHB;
> +			sds_init_len = ARRAY_SIZE(redDataHB);
> +		}
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < sds_init_len; i++) {
> +		ret = rtl8365mb_sds_indacs_write(priv, sds_init[i].addr, sds_init[i].data);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	mask = RTL8365MB_CFG_MAC8_SEL_SGMII | RTL8365MB_CFG_MAC8_SEL_HSGMII;
> +	ret = regmap_update_bits(priv->map,
> +				 RTL8365MB_SDS_MISC,
> +				 mask,
> +				 sds_mode);
> +	if (ret)
> +		return ret;
> +
> +	mask = RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int);
> +	val = interface_mode << RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(ext_int);
> +	ret = regmap_update_bits(priv->map,
> +				 RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_int),
> +				 mask,
> +				 val);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(priv->map, RTL8365MB_BYPASS_LINE_RATE, 0x0);
> +	if (ret)
> +		return ret;
> +
> +	/* Serdes not reset */
> +	ret = rtl8365mb_sds_indacs_write(priv, 0x0003, 0x7106);
> +	if (ret)
> +		return ret;
> +
> +	return rtl8365mb_ext_init_sgmii_fw(priv);
> +}
> +
> +static int rtl8365mb_ext_sgmii_nway(struct realtek_priv *priv, bool state)

What is "nway"? In-band autoneg by any chance? If so, could you pass
"phylink_autoneg_inband(mode)" rather than "false" as "state"?

> +{
> +	u32 running;
> +	u32 regValue;
> +	int ret;
> +
> +	ret = regmap_read(priv->map, RTL8365MB_MISC_CFG0, &running);
> +	if (running & RTL8365MB_MISC_CFG0_DW8051_EN) {
> +		ret = regmap_update_bits(priv->map, RTL8365MB_MISC_CFG0,
> +					 RTL8365MB_MISC_CFG0_DW8051_EN,
> +					 FIELD_PREP(RTL8365MB_MISC_CFG0_DW8051_EN, 0));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = rtl8365mb_sds_indacs_read(priv, 0x0002, &regValue);
> +	if (ret)
> +		return ret;
> +
> +	if (state)
> +		regValue |= 0x0200;
> +	else
> +		regValue &= ~0x0200;

No camelCase please.

> +	regValue |= 0x0100;
> +
> +	ret = rtl8365mb_sds_indacs_write(priv, 0x0002, regValue);

Any idea what the magic numbers are? At least 0x0200 looks like BIT(9).

> +	if (ret)
> +		return ret;
> +	return regmap_update_bits(priv->map, RTL8365MB_MISC_CFG0,
> +				  RTL8365MB_MISC_CFG0_DW8051_EN,
> +				  FIELD_PREP(RTL8365MB_MISC_CFG0_DW8051_EN, 1));
> +}
> +
>  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
>  				      phy_interface_t interface)
>  {
> @@ -886,6 +1173,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
>  }
>  
>  static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
> +					  phy_interface_t interface,
>  					  bool link, int speed, int duplex,
>  					  bool tx_pause, bool rx_pause)
>  {
> @@ -911,7 +1199,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
>  		r_rx_pause = rx_pause ? 1 : 0;
>  		r_tx_pause = tx_pause ? 1 : 0;
>  
> -		if (speed == SPEED_1000) {
> +		if (speed == SPEED_1000 || speed == SPEED_2500) {
>  			r_speed = RTL8365MB_PORT_SPEED_1000M;
>  		} else if (speed == SPEED_100) {
>  			r_speed = RTL8365MB_PORT_SPEED_100M;
> @@ -941,6 +1229,25 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
>  		r_duplex = 0;
>  	}
>  
> +	if (interface == PHY_INTERFACE_MODE_SGMII ||
> +	    interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		val = FIELD_PREP(RTL8365MB_CFG_SGMII_FDUP, r_duplex) |
> +		      FIELD_PREP(RTL8365MB_CFG_SGMII_SPD, r_speed) |
> +		      FIELD_PREP(RTL8365MB_CFG_SGMII_LINK, r_link) |
> +		      FIELD_PREP(RTL8365MB_CFG_SGMII_TXFC, r_tx_pause) |
> +		      FIELD_PREP(RTL8365MB_CFG_SGMII_RXFC, r_rx_pause);
> +		ret = regmap_update_bits(priv->map,
> +					 RTL8365MB_SDS_MISC,
> +					 RTL8365MB_CFG_SGMII_FDUP |
> +					 RTL8365MB_CFG_SGMII_SPD |
> +					 RTL8365MB_CFG_SGMII_LINK |
> +					 RTL8365MB_CFG_SGMII_TXFC |
> +					 RTL8365MB_CFG_SGMII_RXFC,
> +					 val);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	val = FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_EN_MASK, 1) |
>  	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_TXPAUSE_MASK,
>  			 r_tx_pause) |
> @@ -972,10 +1279,15 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
>  	     interface == PHY_INTERFACE_MODE_GMII))
>  		/* Internal PHY */
>  		return true;
> -	else if ((ext_int >= 1) &&
> -		 phy_interface_mode_is_rgmii(interface))
> +	else if ((ext_int == 1) &&
> +		 (phy_interface_mode_is_rgmii(interface) ||
> +		  interface == PHY_INTERFACE_MODE_SGMII ||
> +		  interface == PHY_INTERFACE_MODE_2500BASEX))
>  		/* Extension MAC */
>  		return true;
> +	else if ((ext_int >= 2) &&
> +		 phy_interface_mode_is_rgmii(interface))
> +		return true;
>  
>  	return false;
>  }
> @@ -983,14 +1295,25 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
>  static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
>  				       struct phylink_config *config)
>  {
> -	if (dsa_is_user_port(ds, port))
> +	int ext_int = rtl8365mb_extint_port_map[port];
> +
> +	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> +				   MAC_10 | MAC_100 | MAC_1000FD;
> +
> +	if (dsa_is_user_port(ds, port)) {
>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
> -	else if (dsa_is_cpu_port(ds, port))
> +	} else if (dsa_is_cpu_port(ds, port)) {

What does the quality of being a user port or a CPU port have to do with
which interfaces are supported?

> +		if (ext_int == 1) {
> +			__set_bit(PHY_INTERFACE_MODE_SGMII,
> +				  config->supported_interfaces);
> +			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
> +				  config->supported_interfaces);
> +			config->mac_capabilities |= MAC_2500FD;
> +		}
>  		phy_interface_set_rgmii(config->supported_interfaces);
> +	}
>  
> -	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> -				   MAC_10 | MAC_100 | MAC_1000FD;
>  }
>  
>  static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
> @@ -1020,6 +1343,10 @@ static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
>  				"failed to configure RGMII mode on port %d: %d\n",
>  				port, ret);
>  		return;
> +	} else if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> +		   state->interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		rtl8365mb_ext_init_sgmii(priv, port, state->interface);
> +		rtl8365mb_ext_sgmii_nway(priv, false);
>  	}
>  
>  	/* TODO: Implement MII and RMII modes, which the RTL8365MB-VC also
> @@ -1040,8 +1367,11 @@ static void rtl8365mb_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  	p = &mb->ports[port];
>  	cancel_delayed_work_sync(&p->mib_work);
>  
> -	if (phy_interface_mode_is_rgmii(interface)) {
> -		ret = rtl8365mb_ext_config_forcemode(priv, port, false, 0, 0,
> +	if (phy_interface_mode_is_rgmii(interface) ||
> +	    interface == PHY_INTERFACE_MODE_SGMII ||
> +	    interface == PHY_INTERFACE_MODE_2500BASEX) {

If in-band autoneg is possible, there will have to be an additional
condition here, to only force the mode if it is disabled (which it now is)

> +		ret = rtl8365mb_ext_config_forcemode(priv, port, interface,
> +						     false, 0, 0,
>  						     false, false);
>  		if (ret)
>  			dev_err(priv->dev,
> @@ -1068,8 +1398,11 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  	p = &mb->ports[port];
>  	schedule_delayed_work(&p->mib_work, 0);
>  
> -	if (phy_interface_mode_is_rgmii(interface)) {
> -		ret = rtl8365mb_ext_config_forcemode(priv, port, true, speed,
> +	if (phy_interface_mode_is_rgmii(interface) ||
> +	    interface == PHY_INTERFACE_MODE_SGMII ||
> +	    interface == PHY_INTERFACE_MODE_2500BASEX) {
> +		ret = rtl8365mb_ext_config_forcemode(priv, port, interface,
> +						     true, speed,
>  						     duplex, tx_pause,
>  						     rx_pause);
>  		if (ret)
> @@ -2156,6 +2489,7 @@ const struct realtek_variant rtl8365mb_variant = {
>  };
>  EXPORT_SYMBOL_GPL(rtl8365mb_variant);
>  
> +MODULE_FIRMWARE("rtl_switch/rtl8367s-sgmii.bin");
>  MODULE_AUTHOR("Alvin Šipraga <alsi@bang-olufsen.dk>");
>  MODULE_DESCRIPTION("Driver for RTL8365MB-VC ethernet switch");
>  MODULE_LICENSE("GPL");
> -- 
> 2.30.2
> 

