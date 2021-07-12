Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CC23C5A72
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhGLJ53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhGLJ52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:57:28 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61A2C0613E8;
        Mon, 12 Jul 2021 02:54:40 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GNfHy2pHbzQk58;
        Mon, 12 Jul 2021 11:54:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1626083674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+7tPSemAYvLcNGYAc+R6iylhPYCgbXPYUoGD293BwI=;
        b=fs9YBoZK4RAQP7In8z3xC2OSwMseotD77zvLF4vGJrijiwSz47JURCEomb5gU3rGweL0NN
        T6aXm2KDrAtD9oktSYa5nU8ALZE1GaecZJv/wsyxBGJmsA/DkvajSRVlGn3k3WerIvt3EC
        qzVAIxKbQUm/ANyk393g/7YCuAA4nEEE5ozD/paXAZDAMbUkxFPYxMXsyE6ObmR2yxat/C
        d7WQCQ514vqqokasH4SoqtSZUw5IfUdG51CyGvDIuXc9lH/OORHmJoYBEqb7NjLb/vLLME
        9FJNb0VpnNA4B9xp9cdfx2y6gBqnRjTIz6fJnEcVA8VQEVuAWNTEDpPjGghqwQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id Uz5qEtT4HP5A; Mon, 12 Jul 2021 11:54:32 +0200 (CEST)
Subject: Re: [PATCH net-next v5] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Martin Schiller <ms@dev.tdt.de>,
        martin.blumenstingl@googlemail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210712072413.11490-1-ms@dev.tdt.de>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <e7b84ec3-2ef3-9ad0-b5e3-10ced20e433f@hauke-m.de>
Date:   Mon, 12 Jul 2021 11:54:30 +0200
MIME-Version: 1.0
In-Reply-To: <20210712072413.11490-1-ms@dev.tdt.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.77 / 15.00 / 15.00
X-Rspamd-Queue-Id: C82C0184A
X-Rspamd-UID: 47149b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/21 9:24 AM, Martin Schiller wrote:
> This adds the possibility to configure the RGMII RX/TX clock skew via
> devicetree.
> 
> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> devicetree.
> 
> Furthermore, a warning is now issued if the phy mode is configured to
> "rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
> as in the dp83867 driver.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
> 
> Changes to v4:
> o Fix Alignment to match open parenthesis
> 
> Changes to v3:
> o Fix typo in commit message
> o use FIELD_PREP() and FIELD_GET() macros
> o further code cleanups
> o always mask rxskew AND txskew value in the register value
> 
> Changes to v2:
> o Fix missing whitespace in warning.
> 
> Changes to v1:
> o code cleanup and use phy_modify().
> o use default of 2.0ns if delay property is absent instead of returning
>    an error.
> 
> ---
>   drivers/net/phy/intel-xway.c | 85 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 85 insertions(+)
> 
> diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
> index d453ec016168..bc7e2fdb8ea7 100644
> --- a/drivers/net/phy/intel-xway.c
> +++ b/drivers/net/phy/intel-xway.c
> @@ -8,11 +8,16 @@
>   #include <linux/module.h>
>   #include <linux/phy.h>
>   #include <linux/of.h>
> +#include <linux/bitfield.h>
>   
> +#define XWAY_MDIO_MIICTRL		0x17	/* mii control */
>   #define XWAY_MDIO_IMASK			0x19	/* interrupt mask */
>   #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
>   #define XWAY_MDIO_LED			0x1B	/* led control */
>   
> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK	GENMASK(14, 12)
> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK	GENMASK(10, 8)
> +
>   /* bit 15:12 are reserved */
>   #define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function of LED3 */
>   #define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function of LED2 */
> @@ -157,6 +162,82 @@
>   #define PHY_ID_PHY11G_VR9_1_2		0xD565A409
>   #define PHY_ID_PHY22F_VR9_1_2		0xD565A419
>   
> +#if IS_ENABLED(CONFIG_OF_MDIO)
> +static const int xway_internal_delay[] = {0, 500, 1000, 1500, 2000, 2500,
> +					 3000, 3500};
> +
> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	unsigned int delay_size = ARRAY_SIZE(xway_internal_delay);
> +	s32 int_delay;
> +	int val = 0;
> +
> +	if (!phy_interface_is_rgmii(phydev))
> +		return 0;
> +
> +	/* Existing behavior was to use default pin strapping delay in rgmii
> +	 * mode, but rgmii should have meant no delay.  Warn existing users,
> +	 * but do not change anything at the moment.
> +	 */
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
> +		u16 txskew, rxskew;
> +
> +		val = phy_read(phydev, XWAY_MDIO_MIICTRL);
> +		if (val < 0)
> +			return val;
> +
> +		txskew = FIELD_GET(XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> +		rxskew = FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, val);
> +
> +		if (txskew > 0 || rxskew > 0)
> +			phydev_warn(phydev,
> +				    "PHY has delays (e.g. via pin strapping), but phy-mode = 'rgmii'\n"
> +				    "Should be 'rgmii-id' to use internal delays txskew:%d ps rxskew:%d ps\n",
> +				    xway_internal_delay[txskew],
> +				    xway_internal_delay[rxskew]);
> +		return 0;
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		int_delay = phy_get_internal_delay(phydev, dev,
> +						   xway_internal_delay,
> +						   delay_size, true);
> +
> +		if (int_delay < 0) {
> +			phydev_warn(phydev, "rx-internal-delay-ps is missing, use default of 2.0 ns\n");
> +			int_delay = 4; /* 2000 ps */
> +		}
> +
> +		val |= FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, int_delay);
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		int_delay = phy_get_internal_delay(phydev, dev,
> +						   xway_internal_delay,
> +						   delay_size, false);
> +
> +		if (int_delay < 0) {
> +			phydev_warn(phydev, "tx-internal-delay-ps is missing, use default of 2.0 ns\n");
> +			int_delay = 4; /* 2000 ps */
> +		}
> +
> +		val |= FIELD_PREP(XWAY_MDIO_MIICTRL_TXSKEW_MASK, int_delay);
> +	}
> +
> +	return phy_modify(phydev, XWAY_MDIO_MIICTRL,
> +			  XWAY_MDIO_MIICTRL_RXSKEW_MASK |
> +			  XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> +}
> +#else
> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_OF_MDIO */
> +
>   static int xway_gphy_config_init(struct phy_device *phydev)
>   {
>   	int err;
> @@ -204,6 +285,10 @@ static int xway_gphy_config_init(struct phy_device *phydev)
>   	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
>   	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
>   
> +	err = xway_gphy_of_reg_init(phydev);
> +	if (err)
> +		return err;
> +
>   	return 0;
>   }
>   
> 

