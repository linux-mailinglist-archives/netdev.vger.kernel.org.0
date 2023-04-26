Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F26EFBF1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjDZUxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbjDZUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:53:48 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5342709
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:53:40 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4eff055d4d3so4964216e87.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1682542419; x=1685134419;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zYTGlF4reb5biwxdhBgRAfvhCVq3/dLR7jn2tMrGb8w=;
        b=fnMD4QicB9rYnESsvc/GNbGPSsGsmlO7BwNIhf2pPBdHGDAOxnL4KwEJNw03hxtTk5
         tuE3YkeSh44Cm7v5HZhpntndsuVgkDcdH11sVUV9eue7ktn0LHG5LJCtjAHBNaHRVSL2
         Bj9rqru8G6War5V6Hy828S8/OF2AByT0DWMAtMNuV3Yrg1hQ16GgWImAilsaISfDPFVV
         fiutMtqlkddTvwsUX7mkr29S9ZT5kV9jtidZfgNZWO+y+C8dfYmW8B1Aw60+yt+La14p
         /F+13FZm2mITmMuzhdpIcOeNZ/sPp9RXjVtrM6POqpdFZijtHz+WbaXTcfkSmfdlFDzc
         Judg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542419; x=1685134419;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYTGlF4reb5biwxdhBgRAfvhCVq3/dLR7jn2tMrGb8w=;
        b=b5kA6u9QgiZREeumRi61SV6BJcV1Kdqj55BjT9PWsWfwBIb4YKFUmRoiRBdq1RHaJd
         b2El01YE9KpOzG07EiTkeIHI+wO9verVSmn2dCH5wZb4TV1y0Aw5q1KDfRPRFj2sZvg7
         V7F5aIoZE+wPD/aR6RqZtzgKcVFl+9muFHxwcUUPiRyqLuOMazbHlz1X/hGMaek4cyx8
         6+xkBO4dOzMfjwvdqrhstRuddf4InvyCTvBc2XUgmiQe3wyY0Ky7blgt+6IQ5sAKLFtl
         5xQaNQDmXVLvjmdSuLlU54cIFLELEwH6wJyPsdG2IKkLr0KMKqevIL7cTXY4QS8pRh2c
         iLug==
X-Gm-Message-State: AAQBX9ebGCjd3/zzRxTQzsSuGMSMmkWEbiiL6F4D52WRZo/1oupwN1N6
        /4StAPA8ihtgZgOmrLQ2bQU/ow==
X-Google-Smtp-Source: AKy350b+g6HQ7YwQHozAeCZxrpB0p+IiYLub3Iz/Torg6XWQ77dvLAa38y3/uNaEkRc2b6hSs7wMXw==
X-Received: by 2002:a05:6512:259:b0:4ef:f01d:5aa0 with SMTP id b25-20020a056512025900b004eff01d5aa0mr3101015lfo.29.1682542418921;
        Wed, 26 Apr 2023 13:53:38 -0700 (PDT)
Received: from debian (c188-148-248-178.bredband.tele2.se. [188.148.248.178])
        by smtp.gmail.com with ESMTPSA id o22-20020ac24356000000b004edd490cf77sm2569849lfl.275.2023.04.26.13.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 13:53:37 -0700 (PDT)
Date:   Wed, 26 Apr 2023 22:53:35 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        jan.huber@microchip.com, thorsten.kummermehr@microchip.com
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <ZEmPT1El342j7O8I@debian>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 05:16:55PM +0530, Parthiban Veerasooran wrote:
> This patch adds support for the Microchip LAN865x Rev.B0 10BASE-T1S
> Internal PHYs (LAN8650/1). The LAN865x combines a Media Access Controller
> (MAC) and an internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S
> networks.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---
>  drivers/net/phy/microchip_t1s.c | 200 ++++++++++++++++++++++++++++++--
>  1 file changed, 191 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
> index 793fb0210605..3d8d285b3c34 100644
> --- a/drivers/net/phy/microchip_t1s.c
> +++ b/drivers/net/phy/microchip_t1s.c
> @@ -4,6 +4,7 @@
>   *
>   * Support: Microchip Phys:
>   *  lan8670/1/2 Rev.B1
> + *  lan8650/1 Rev.B0 Internal PHYs
>   */
>  
>  #include <linux/kernel.h>
> @@ -11,9 +12,10 @@
>  #include <linux/phy.h>
>  
>  #define PHY_ID_LAN867X_REVB1 0x0007C162
> +#define PHY_ID_LAN865X_REVB0 0x0007C1B3
>  
> -#define LAN867X_REG_IRQ_1_CTL 0x001C
> -#define LAN867X_REG_IRQ_2_CTL 0x001D
> +#define LAN86XX_REG_IRQ_1_CTL 0x001C
> +#define LAN86XX_REG_IRQ_2_CTL 0x001D
>  
>  /* The arrays below are pulled from the following table from AN1699
>   * Access MMD Address Value Mask
> @@ -49,6 +51,174 @@ static const int lan867x_revb1_fixup_masks[12] = {
>  	0x0600, 0x7F00, 0x2000, 0xFFFF,
>  };
>  
> +/* LAN865x Rev.B0 configuration parameters from AN1760
> + */
> +static const int lan865x_revb0_fixup_registers[28] = {
> +	0x0091, 0x0081, 0x0043, 0x0044,
> +	0x0045, 0x0053, 0x0054, 0x0055,
> +	0x0040, 0x0050, 0x00D0, 0x00E9,
> +	0x00F5, 0x00F4, 0x00F8, 0x00F9,
> +	0x00B0, 0x00B1, 0x00B2, 0x00B3,
> +	0x00B4, 0x00B5, 0x00B6, 0x00B7,
> +	0x00B8, 0x00B9, 0x00BA, 0x00BB,
> +};
> +
> +static const int lan865x_revb0_fixup_values[28] = {
> +	0x9660, 0x00C0, 0x00FF, 0xFFFF,
> +	0x0000, 0x00FF, 0xFFFF, 0x0000,
> +	0x0002, 0x0002, 0x5F21, 0x9E50,
> +	0x1CF8, 0xC020, 0x9B00, 0x4E53,
> +	0x0103, 0x0910, 0x1D26, 0x002A,
> +	0x0103, 0x070D, 0x1720, 0x0027,
> +	0x0509, 0x0E13, 0x1C25, 0x002B,
> +};
> +
> +/* indirect read pseudocode from AN1760
> + * write_register(0x4, 0x00D8, addr)
> + * write_register(0x4, 0x00DA, 0x2)
> + * return (int8)(read_register(0x4, 0x00D9))
> + */

I suggest this comment block is slightly changed to

/* Pulled from AN1760 describing 'indirect read'
 *
 * write_register(0x4, 0x00D8, addr)
 * write_register(0x4, 0x00DA, 0x2)
 * return (int8)(read_register(0x4, 0x00D9))
 *
 * 0x4 refers to memory map selector 4, which maps to MDIO_MMD_VEND2
 */

> +static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
> +{
> +	int ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xD8, addr);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xDA, 0x0002);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0xD9);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ret;
> +}

The func itself might get a bit more readable by naming the magic regs
and value, below is a suggestion.

static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
{
	int ret;
	static const u16 fixup_w0_reg = 0x00D8;
	static const u16 fixup_r0_reg = 0x00D9;
	static const u16 fixup_w1_val = 0x0002;
	static const u16 fixup_w1_reg = 0x00DA;

	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, fixup_w0_reg, addr);
	if (ret)
		return ret;

	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, fixup_w1_reg, fixup_w1_val);
	if (ret)
		return ret;

	return phy_read_mmd(phydev, MDIO_MMD_VEND2, fixup_r0_reg);
}

> +
> +static int lan865x_setup_cfgparam(struct phy_device *phydev)
> +{
> +	s8 offset1;
> +	s8 offset2;
> +	s8 value;
> +	u16 cfgparam;
> +	int ret;
> +
> +	ret = lan865x_revb0_indirect_read(phydev, 0x0004);
> +	if (ret < 0)
> +		return ret;
> +	value = (s8)ret;
> +	/* Calculation of configuration offset 1 from AN1760
> +	 */
> +	if ((value & 0x10) != 0)
> +		offset1 = value | 0xE0;
> +	else
> +		offset1 = value;
> +
> +	ret = lan865x_revb0_indirect_read(phydev, 0x0008);
> +	if (ret < 0)
> +		return ret;
> +	value = (s8)ret;
> +	/* Calculation of configuration offset 2 from AN1760
> +	 */
> +	if ((value & 0x10) != 0)
> +		offset2 = value | 0xE0;
> +	else
> +		offset2 = value;
> +
> +	/* calculate and write the configuration parameters in the
> +	 * 0x0084, 0x008A, 0x00AD, 0x00AE and 0x00AF registers (from AN1760)
> +	 */
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x0084);
> +	if (ret < 0)
> +		return ret;
> +	cfgparam = (ret & 0xF) | (((9 + offset1) << 10) |
> +		    ((14 + offset1) << 4));
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x84, cfgparam);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x008A);
> +	if (ret < 0)
> +		return ret;
> +	cfgparam = (ret & 0x3FF) | ((40 + offset2) << 10);
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x8A, cfgparam);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AD);
> +	if (ret < 0)
> +		return ret;
> +	cfgparam = (ret & 0xC0C0) | (((5 + offset1) << 8) | (9 + offset1));
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAD, cfgparam);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AE);
> +	if (ret < 0)
> +		return ret;
> +	cfgparam = (ret & 0xC0C0) | (((9 + offset1) << 8) | (14 + offset1));
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAE, cfgparam);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0x00AF);
> +	if (ret < 0)
> +		return ret;
> +	cfgparam = (ret & 0xC0C0) | (((17 + offset1) << 8) | (22 + offset1));
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xAF, cfgparam);
> +}
> +

I suggest this func is broken up into multiple funcs, for the sake of
readability. My suggestion is less efficient and would require
allocating some arrays which might not be an ideal solution, but then
readability would be my primary concern here.

//this array should be placed at the top of the file with the other arrs
static const u16 lan865x_revb0_fixup_cfg_regs[5] = { 0x84, 0x8A, 0xAD, 0xAE, 0xAF, };

/* This is pulled straigt from AN1760 from 'calulation of offset 1' & 'calculation of offset 2'
 */
static int lan865x_generate_cfg_offsets(struct phy_device *phydev, s8 offsets[2])
{
	u16 fixup_regs[2] = {0x0004, 0x0008};
	int val;

	for (int i = 0; i < ARRAY_SIZE(fixup_regs); i++) {
		val = (s8)lan865x_revb0_indirect_read(phydev, fixup_regs[i]);
		if (val < 0)
			return val;
		if ((val & 0x10) != 0)
			offsets[i] = val | 0xE0;
		else
			offsets[i] = val;
	}

	return 0;
}

static int lan865x_read_cfg_params(struct phy_device *phydev, s16 cfg_params[5])
{
	int err;

	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs); i++) {
		err = phy_read_mmd(phydev, MDIO_MMD_VEND2, lan865x_revb0_fixup_cfg_regs[i]);
		if (err < 0)
			return err;
		cfg_params[i] = (u16)err;
	}

	return 0;
}

static int lan865x_write_cfg_params(struct phy_device *phydev, u16 cfg_params[5])
{
	int err;

	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs); i++) {
		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, lan865x_revb0_fixup_cfg_regs[i], cfg_params[i]);
		if (err < 0)
			return err;
	}

	return 0;
}

static int lan865x_setup_cfgparam(struct phy_device *phydev)
{
	u16 cfg_results[5];
	u16 cfg_params[5];
	s8 offsets[2];
	int err;

	err = lan865x_generate_cfg_offsets(phydev, offsets);
	if (err < 0)
		return err;
	err = lan865x_read_cfg_params(phydev, cfg_params);
	if (err < 0)
		return err;

	// This block computes the magic values that goes into the magic cfg regs.
	// Maybe there is some way of compacting this into a loop, but this seems like
	// as readable as it's going to get.
	cfg_results[0] = (cfg_params[0] & 0xF) | (((9 + offsets[0]) << 10) |
		    ((14 + offsets[0]) << 4));
	cfg_results[1] = (cfg_params[1] & 0x3FF) | ((40 + offsets[1]) << 10);
	cfg_results[2] = (cfg_params[2] & 0xC0C0) | (((5 + offsets[0]) << 8) | (9 + offsets[0]));
	cfg_results[3] = (cfg_params[3] & 0xC0C0) | (((9 + offsets[0]) << 8) | (14 + offsets[0]));
	cfg_results[4] = (cfg_params[4] & 0xC0C0) | (((17 + offsets[0]) << 8) | (22 + offsets[0]));

	return lan865x_write_cfg_params(phydev, cfg_results);
}

> +static int lan865x_revb0_config_init(struct phy_device *phydev)
> +{
> +	int addr;
> +	int value;
> +	int ret;
> +
> +	/* As per AN1760, the below configuration applies only to the LAN8650/1
> +	 * hardware revision Rev.B0.
> +	 */

I think this is implied by having it the device specific init func, you
can probably drop this comment.

> +	for (int i = 0; i < ARRAY_SIZE(lan865x_revb0_fixup_registers); i++) {
> +		addr = lan865x_revb0_fixup_registers[i];
> +		value = lan865x_revb0_fixup_values[i];
> +		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, addr, value);
> +		if (ret)
> +			return ret;
> +	}
> +	/* function to calculate and write the configuration parameters in the
> +	 * 0x0084, 0x008A, 0x00AD, 0x00AE and 0x00AF registers (from AN1760)
> +	 */
> +	ret = lan865x_setup_cfgparam(phydev);
> +	if (ret < 0)
> +		return ret;

The loop and the call to lan865x_setup_cfgparam deviates from AN1760, in
the AN the writes to the cfg regs are mixed into the writes to the fixup
regs. Is this really intended and safe?
I'm guessing this is done out of convenience, if so I'd suggest adding a
comment along the lines

// The writes to the fixup and cfg regs deviate from the recommendation
// in AN1760, where the writes are intermixed. This is done out of
// convenience but works

I'm guessing you've tested it :)

> +
> +	/* disable all the interrupts
> +	 */

Maybe a motivation about why would be helpful here

> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_1_CTL, 0xFFFF);
> +	if (ret)
> +		return ret;
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_2_CTL, 0xFFFF);
> +}
> +
> +static int lan865x_revb0_plca_set_cfg(struct phy_device *phydev,
> +				      const struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +
> +	ret = genphy_c45_plca_set_cfg(phydev, plca_cfg);
> +	if (ret)
> +		return ret;
> +
> +	/* Disable the collision detection when PLCA is enabled and enable
> +	 * collision detection when CSMA/CD mode is enabled.
> +	 */
> +	if (plca_cfg->enabled)
> +		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0000);
> +	else
> +		return phy_write_mmd(phydev, MDIO_MMD_VEND2, 0x0087, 0x0083);

This register is marked as reserved in the datasheet, is this the
intended reg?
If it is intended a more detailed comment about what it does would be
nice, since no one outside microchip will be able to verify it.
Also is something similar relevant for the lan867x phys?

> +}
> +
>  static int lan867x_revb1_config_init(struct phy_device *phydev)
>  {
>  	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> @@ -90,13 +260,13 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
>  	 * for it either.
>  	 * So we'll just disable all interrupts on the chip.
>  	 */
> -	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
> +	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_1_CTL, 0xFFFF);
>  	if (err != 0)
>  		return err;
> -	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN86XX_REG_IRQ_2_CTL, 0xFFFF);
>  }
>  
> -static int lan867x_read_status(struct phy_device *phydev)
> +static int lan86xx_read_status(struct phy_device *phydev)
>  {
>  	/* The phy has some limitations, namely:
>  	 *  - always reports link up
> @@ -111,23 +281,34 @@ static int lan867x_read_status(struct phy_device *phydev)
>  	return 0;
>  }
>  
> -static struct phy_driver lan867x_revb1_driver[] = {
> +static struct phy_driver lan86xx_driver[] = {
>  	{
>  		PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1),
>  		.name               = "LAN867X Rev.B1",
>  		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
>  		.config_init        = lan867x_revb1_config_init,
> -		.read_status        = lan867x_read_status,
> +		.read_status        = lan86xx_read_status,
>  		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
>  		.set_plca_cfg	    = genphy_c45_plca_set_cfg,
>  		.get_plca_status    = genphy_c45_plca_get_status,
> -	}
> +	},
> +	{
> +		PHY_ID_MATCH_EXACT(PHY_ID_LAN865X_REVB0),
> +		.name               = "LAN865X Rev.B0 Internal Phy",
> +		.features           = PHY_BASIC_T1S_P2MP_FEATURES,
> +		.config_init        = lan865x_revb0_config_init,
> +		.read_status        = lan86xx_read_status,
> +		.get_plca_cfg	    = genphy_c45_plca_get_cfg,
> +		.set_plca_cfg	    = lan865x_revb0_plca_set_cfg,
> +		.get_plca_status    = genphy_c45_plca_get_status,
> +	},
>  };
>  
> -module_phy_driver(lan867x_revb1_driver);
> +module_phy_driver(lan86xx_driver);
>  
>  static struct mdio_device_id __maybe_unused tbl[] = {
>  	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN867X_REVB1) },
> +	{ PHY_ID_MATCH_EXACT(PHY_ID_LAN865X_REVB0) },
>  	{ }
>  };
>  
> @@ -135,4 +316,5 @@ MODULE_DEVICE_TABLE(mdio, tbl);
>  
>  MODULE_DESCRIPTION("Microchip 10BASE-T1S Phy driver");
>  MODULE_AUTHOR("Ramón Nordin Rodriguez");
> +MODULE_AUTHOR("Parthiban Veerasooran <parthiban.veerasooran@microchip.com>");
>  MODULE_LICENSE("GPL");
> -- 
> 2.34.1
> 
