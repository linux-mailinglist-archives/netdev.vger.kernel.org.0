Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258CA6E7DBF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjDSPNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjDSPNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:13:06 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F0B4EC0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:13:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dm2so82701217ejc.8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917179; x=1684509179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W4tAfOyzlo/AiL8XmHFYet50M4kqPgt6dUJ37GoV4eQ=;
        b=bNJ6cPz+pL9ObBtl1h3mJz/Z2AK/jCPHfjaoBNcL+OO9y24fRNxpqoVeCy/hAAzWKI
         8ZdEDqo2/WLvRMlEmrH91zo/tCOdpvQnTnjKVPxczUoZ1qicMp7rE6QxDxv+fXrZAH3j
         4PBhE1yk/Z1L2LBPiHe5k/tVjg4I4AapClNUac3zL/+ZllGUbLYSQjfqk1z2SLOlrMI5
         7NhECGALvTPivFImsPPaSIC5p+16pgmF3dW/gWOwU5hFWinKbdMUPzE/qEVRywrOK2as
         GxYkpYhNgmWXUynOM+Lnu9D6n9g7Gb5bsxJ1cwL2OHiX5xCc6tc8Ch5T+sUlYy6PhmDp
         ZuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917179; x=1684509179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4tAfOyzlo/AiL8XmHFYet50M4kqPgt6dUJ37GoV4eQ=;
        b=jGFPDBN6PtN6LZZKyXZwi63SKjpzqhzXEd4ZGlViKnipzUlwO/4glZXz2NpzMGOWG3
         NTVUmAztSWjof4iGiZUUJKGkDMy13iNJYnhf30juzNqjypeveS1cXWcQRxGPzO5gK5Is
         EqhiIO+qocnHGZMppieFvYQJcjkCKHvqHnDJxMnSaCAfbrItJwPzkTAYpNYS7EYShO4x
         hsBg0lRVyZezb8cYxYtkHy0Y7bjy4M/VREDlezszI67V3qwbzEM9C93E4fFHrG1NIlR/
         e+NiFw39TqfUsB1y2kaA4h8BmcserMIKofmWOP9NbLvS0reTVnMKBvv1y7sJDQJOuXBR
         tjzg==
X-Gm-Message-State: AAQBX9cDxpbMFKEZBrWL7Ex5hat2nPWL2zwu7Ezd0sHP1yv+aIg8QrSG
        tbKIABms3q4rPdAL56aU1Lg=
X-Google-Smtp-Source: AKy350YZvxACiHc/JwMKfCPcDUBC5fOFqzJLmydZy9/tjX3XE0tKUCH3M5hkkiBd4qWQoBwvh4KYmQ==
X-Received: by 2002:a17:906:564e:b0:94e:ec0f:455 with SMTP id v14-20020a170906564e00b0094eec0f0455mr14650400ejr.54.1681917179409;
        Wed, 19 Apr 2023 08:12:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e16-20020a170906045000b009534603453dsm1153263eja.131.2023.04.19.08.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:12:59 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:12:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?UmFtw7Nu?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH v2] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <20230419151257.etde4jit4pquec6c@skbuf>
References: <ZD/Nl+4JAmW2VTzh@debian>
 <ZD/Nl+4JAmW2VTzh@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZD/Nl+4JAmW2VTzh@debian>
 <ZD/Nl+4JAmW2VTzh@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 01:16:39PM +0200, Ramón Nordin Rodriguez wrote:
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> ---
>  drivers/net/phy/Kconfig         |   5 ++
>  drivers/net/phy/Makefile        |   1 +
>  drivers/net/phy/microchip_t1s.c | 136 ++++++++++++++++++++++++++++++++
>  3 files changed, 142 insertions(+)
>  create mode 100644 drivers/net/phy/microchip_t1s.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 54874555c921..c12e30f83b4f 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -235,6 +235,11 @@ config MICREL_PHY
>  	help
>  	  Supports the KSZ9021, VSC8201, KS8001 PHYs.
>  
> +config MICROCHIP_T1S_PHY
> +	tristate "Microchip 10BASE-T1S Ethernet PHY"
> +	help
> +		Currently supports the LAN8670, LAN8671, LAN8672

I believe there is an explicit convention documented somewhere (can't
remember where, sorry) that help texts are indented with 2 spaces from
the "help" word. Just like above, basically.

> +
>  config MICROCHIP_PHY
>  	tristate "Microchip PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b5138066ba04..64f649f2f62f 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
>  obj-$(CONFIG_MICREL_PHY)	+= micrel.o
>  obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
>  obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
> +obj-$(CONFIG_MICROCHIP_T1S_PHY) += microchip_t1s.o
>  obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
>  obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
> diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
> new file mode 100644
> index 000000000000..edb50ce63c63
> --- /dev/null
> +++ b/drivers/net/phy/microchip_t1s.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Driver for Microchip 10BASE-T1S LAN867X PHY
> + *
> + * Support: Microchip Phys:

Supports Microchip PHYs:

> + *  lan8670, lan8671, lan8672
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define PHY_ID_LAN867X 0x0007C160
> +
> +#define LAN867X_REG_IRQ_1_CTL 0x001C
> +#define LAN867X_REG_IRQ_2_CTL 0x001D
> +
> +static int lan867x_config_init(struct phy_device *phydev)
> +{
> +	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> +	 * that a set of read-modify-write (rmw) operations has to be performed
> +	 * on a set of seemingly magic registers.
> +	 * The result of these operations is just described as 'optimal performance'
> +	 * Microchip gives no explanation as to what these mmd regs do,
> +	 * in fact they are marked as reserved in the datasheet.
> +	 */
> +
> +	/* The arrays below are pulled from the following table from AN1699
> +	 * Access MMD Address Value Mask
> +	 * RMW 0x1F 0x00D0 0x0002 0x0E03
> +	 * RMW 0x1F 0x00D1 0x0000 0x0300
> +	 * RMW 0x1F 0x0084 0x3380 0xFFC0
> +	 * RMW 0x1F 0x0085 0x0006 0x000F
> +	 * RMW 0x1F 0x008A 0xC000 0xF800
> +	 * RMW 0x1F 0x0087 0x801C 0x801C
> +	 * RMW 0x1F 0x0088 0x033F 0x1FFF
> +	 * W   0x1F 0x008B 0x0404 ------
> +	 * RMW 0x1F 0x0080 0x0600 0x0600
> +	 * RMW 0x1F 0x00F1 0x2400 0x7F00
> +	 * RMW 0x1F 0x0096 0x2000 0x2000
> +	 * W   0x1F 0x0099 0x7F80 ------
> +	 */
> +
> +	const int registers[12] = {
> +		0x00D0, 0x00D1, 0x0084, 0x0085,
> +		0x008A, 0x0087, 0x0088, 0x008B,
> +		0x0080, 0x00F1, 0x0096, 0x0099,
> +	};
> +
> +	const int values[12] = {
> +		0x0002, 0x0000, 0x3380, 0x0006,
> +		0xC000, 0x801C, 0x033F, 0x0404,
> +		0x0600, 0x2400, 0x2000, 0x7F80,
> +	};
> +
> +	const int masks[12] = {
> +		0x0E03, 0x0300, 0xFFC0, 0x000F,
> +		0xF800, 0x801C, 0x1FFF, 0xFFFF,
> +		0x0600, 0x7F00, 0x2000, 0xFFFF,
> +	};

Kernel stack space eventually runs out, and defining large-ish arrays as
local variables is always a problem. These don't appear to be large
enough to cause problems, but it is a good practice to make constants go
to the .rodata section, and that would be achieved by moving them to the
global scope of this file (don't forget to make them static) and to give
them more specific names (lan867x_fixup_regs, lan867x_fixup_values,
lan867x_fixup_masks). Alternatively, if you insist on making them
visible just to the scope of lan867x_config_init(), there is a way of
doing that by making the local variables "static". That is essentially
just syntactic sugar (they aren't put on stack) and is used more rarely.

> +
> +	int reg_value;
> +	int err;
> +	int reg;
> +
> +	/* Read-Modified Write Pseudocode (from AN1699)
> +	 * current_val = read_register(mmd, addr) // Read current register value
> +	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
> +	 * new_val = new_val OR value // Set bits
> +	 * write_register(mmd, addr, new_val) // Write back updated register value
> +	 */
> +	for (int i = 0; i < ARRAY_SIZE(registers); i++) {
> +		reg = registers[i];
> +		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
> +		reg_value &= ~masks[i];
> +		reg_value |= values[i];
> +		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
> +		if (err != 0)
> +			return err;
> +	}
> +
> +	/* None of the interrupts in the lan867x phy seem relevant.
> +	 * Other phys inspect the link status and call phy_trigger_machine
> +	 * in the interrupt handler.
> +	 * This phy does not support link status, and thus has no interrupt
> +	 * for it either.
> +	 * So we'll just disable all interrupts on the chip.
> +	 */
> +	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
> +	if (err != 0)
> +		return err;
> +	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
> +
> +	return err;

return phy_write_mmd()?

> +}
> +
> +static int lan867x_read_status(struct phy_device *phydev)
> +{
> +	/* The phy has some limitations, namely:
> +	 *  - always reports link up
> +	 *  - only supports 10MBit half duplex
> +	 *  - does not support auto negotiate
> +	 */
> +	phydev->link = 1;
> +	phydev->duplex = DUPLEX_HALF;
> +	phydev->speed = SPEED_10;
> +	phydev->autoneg = AUTONEG_DISABLE;

Sounds really suboptimal if phylib has to poll once per second to find
out static information. Does the PHY have an architectural limitation in
that it does not report link status? Is it a T1S thing? Something should
change here, but I'm not really sure what. A PHY that doesn't report
link status seems... strange?

> +
> +	return 0;
> +}
> +
> +static struct phy_driver lan867x_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_LAN867X),
> +		.name               = "LAN867X",
> +		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
> +		.config_init        = lan867x_config_init,
> +		.read_status        = lan867x_read_status,
> +		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
> +		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
> +		.get_plca_status    = genphy_c45_plca_get_status,
> +	}
> +};
> +
> +module_phy_driver(lan867x_driver);
> +
> +static struct mdio_device_id __maybe_unused tbl[] = {
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_LAN867X) },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, tbl);
> +
> +MODULE_DESCRIPTION("Microchip 10BASE-T1S lan867x Phy driver");
> +MODULE_AUTHOR("Ramón Nordin Rodriguez");
> +MODULE_LICENSE("GPL");
> -- 
> 2.39.2
> 

