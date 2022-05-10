Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455D65223F5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348910AbiEJS22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiEJS2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:28:24 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089A85A153
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:28:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id j6so34622189ejc.13
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mzAR93vbqrXvQJ7/DFzGbzAk6ScCR9qLhMN10kygPO4=;
        b=d7zMO0UUEDfpG2Eu4DejXs97kQPFsZZm93bOHd0ZYSqZNQDLSIbNAhJbNV/tgmFklq
         B9aIRk8irP4UIylyqVQmTZebjI2z1ekE2Co2TS2F0dKVBdgvcAbtu1pmU5Gejz6r9Pi1
         WDj7MmsFCps43O71y030wYgQOro0AzNK2OjUnDfiRqtoUGh91obz+gR203VFIX5KLqfb
         3oS8rNTZdnm8xbSwTg9BAALip1xA83tegM4vC5b+k2bOlYuHeICipzXmPP785ExYVmga
         ZsFAqSWFd0bRnZa6ePKskizaPCEiuynZQhL2qf7l95x8DlPJWImtw8Ab+Z7rb9oskifY
         l3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mzAR93vbqrXvQJ7/DFzGbzAk6ScCR9qLhMN10kygPO4=;
        b=NJ+HTQJsdCCIqhxDgVWjZ+MpRwZncpAWYEZ4GxyQVAXb/PJ2/A2L4rOctpZD0ePaQD
         lZPdrzSNgTryLLj76deRDPah0fWMwQm3awSZMiG99RWoil4BHNSBolgDNm8G116H0eSH
         QSTmvtcEAANpFfaEcBilOqruMmMX7P6v+wp/W2kFgBXeEFaS+ntwaQmRYNTqAgk2sFwi
         L6jTRiTsK8QPsqL+XGyZd99Y2ZG9na1g5DU9r2GkDJ4Noj+AE6nimKbS+ukM5GEvZyj7
         3ckwsmV9QwjwAw3kpi+tYIetBvzSA86nqZ38kT2hOfXiKL21oLHs6k/c2eWfg2ARgEl5
         rv0A==
X-Gm-Message-State: AOAM531CSt+X93BmuJ4NNnPQzB5LbjXLL8IAaLcx7zzye1PBEymDnERX
        74Jayyn8LW/4Gguu3TDuC0E=
X-Google-Smtp-Source: ABdhPJyeSnq3IuM2AH4SIfCPR5YRS7Op5ItaPwb7wZDB0g2fyWuBQ9MagW0imAhvXPX8gDlVL6fCNA==
X-Received: by 2002:a17:906:1e94:b0:6cc:4382:f12e with SMTP id e20-20020a1709061e9400b006cc4382f12emr20475311ejj.482.1652207301314;
        Tue, 10 May 2022 11:28:21 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id z11-20020a170906668b00b006f4fc3850a5sm43280ejo.32.2022.05.10.11.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:28:20 -0700 (PDT)
Date:   Tue, 10 May 2022 21:28:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 07/10] net: ethernet: freescale: xgmac: Separate
 C22 and C45 transactions for xgmac
Message-ID: <20220510182818.w7kl3vmlgvqjjj4u@skbuf>
References: <20220508153049.427227-1-andrew@lunn.ch>
 <20220508153049.427227-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508153049.427227-8-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 05:30:46PM +0200, Andrew Lunn wrote:
> The xgmac MDIO bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new API calls where appropriate.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 154 +++++++++++++++-----
>  1 file changed, 117 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index ec90da1de030..ddfe6bf1f231 100644
> --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> @@ -128,30 +128,59 @@ static int xgmac_wait_until_done(struct device *dev,
>  	return 0;
>  }
>  
> -/*
> - * Write value to the PHY for this device to the register at regnum,waiting
> +/* Write value to the PHY for this device to the register at regnum,waiting
>   * until the write is done before it returns.  All PHY configuration has to be
>   * done through the TSEC1 MIIM regs.
>   */
> -static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
> +static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
> +				u16 value)
>  {
>  	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
>  	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> -	uint16_t dev_addr;
> +	bool endian = priv->is_little_endian;
>  	u32 mdio_ctl, mdio_stat;
> +	u16 dev_addr;
>  	int ret;
> +
> +	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> +	dev_addr = regnum & 0x1f;

Please move this either to the variable declaration, or near the mdio_ctl write,
or just integrate it into the macro argument.

> +	mdio_stat &= ~MDIO_STAT_ENC;
> +

You can remove this empty line during read-modify-write patterns.

> +	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
> +
> +	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> +	if (ret)
> +		return ret;
> +
> +	/* Set the port and dev addr */
> +	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
> +	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
> +
> +	/* Write the value to the register */
> +	xgmac_write32(MDIO_DATA(value), &regs->mdio_data, endian);
> +
> +	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/* Write value to the PHY for this device to the register at regnum,waiting
> + * until the write is done before it returns.  All PHY configuration has to be
> + * done through the TSEC1 MIIM regs.
> + */
> +static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
> +				int regnum, u16 value)
> +{
> +	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
>  	bool endian = priv->is_little_endian;
> +	u32 mdio_ctl, mdio_stat;
> +	int ret;
>  
>  	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> -	if (regnum & MII_ADDR_C45) {
> -		/* Clause 45 (ie 10G) */
> -		dev_addr = (regnum >> 16) & 0x1f;
> -		mdio_stat |= MDIO_STAT_ENC;
> -	} else {
> -		/* Clause 22 (ie 1G) */
> -		dev_addr = regnum & 0x1f;
> -		mdio_stat &= ~MDIO_STAT_ENC;
> -	}
> +	mdio_stat |= MDIO_STAT_ENC;
>  
>  	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
>  
> @@ -164,13 +193,11 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
>  	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
>  
>  	/* Set the register address */
> -	if (regnum & MII_ADDR_C45) {
> -		xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
> +	xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);

Does regnum ever exceed 0xffff now that the MMD is no longer encoded into it?

>  
> -		ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> +	if (ret)
> +		return ret;
>  
>  	/* Write the value to the register */
>  	xgmac_write32(MDIO_DATA(value), &regs->mdio_data, endian);
> @@ -182,31 +209,84 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
>  	return 0;
>  }
>  
> -/*
> - * Reads from register regnum in the PHY for device dev, returning the value.
> +/* Reads from register regnum in the PHY for device dev, returning the value.
>   * Clears miimcom first.  All PHY configuration has to be done through the
>   * TSEC1 MIIM regs.
>   */
> -static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
> +static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
>  {
>  	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
>  	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> +	bool endian = priv->is_little_endian;
>  	unsigned long flags;
> -	uint16_t dev_addr;
>  	uint32_t mdio_stat;
>  	uint32_t mdio_ctl;
> +	u16 dev_addr;
>  	int ret;
> -	bool endian = priv->is_little_endian;
>  
>  	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> -	if (regnum & MII_ADDR_C45) {
> -		dev_addr = (regnum >> 16) & 0x1f;
> -		mdio_stat |= MDIO_STAT_ENC;
> +	dev_addr = regnum & 0x1f;

I'm thinking we could just pass "regnum & 0x1f" (or just regnum) to
MDIO_CTL_DEV_ADDR() for the c22 functions.

> +	mdio_stat &= ~MDIO_STAT_ENC;
> +
> +	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
> +
> +	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> +	if (ret)
> +		return ret;
> +
> +	/* Set the Port and Device Addrs */
> +	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
> +	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
> +
> +	if (priv->has_a009885)
> +		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
> +		 * must read back the data register within 16 MDC cycles.
> +		 */
> +		local_irq_save(flags);
> +
> +	/* Initiate the read */
> +	xgmac_write32(mdio_ctl | MDIO_CTL_READ, &regs->mdio_ctl, endian);
> +
> +	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
> +	if (ret)
> +		goto irq_restore;
> +
> +	/* Return all Fs if nothing was there */
> +	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
> +	    !priv->has_a011043) {
> +		dev_dbg(&bus->dev,
> +			"Error while reading PHY%d reg at %d.%d\n",
> +			phy_id, dev_addr, regnum);
> +		ret = 0xffff;
>  	} else {
> -		dev_addr = regnum & 0x1f;
> -		mdio_stat &= ~MDIO_STAT_ENC;
> +		ret = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
> +		dev_dbg(&bus->dev, "read %04x\n", ret);
>  	}
>  
> +irq_restore:
> +	if (priv->has_a009885)
> +		local_irq_restore(flags);
> +
> +	return ret;
> +}
> +
> +/* Reads from register regnum in the PHY for device dev, returning the value.
> + * Clears miimcom first.  All PHY configuration has to be done through the
> + * TSEC1 MIIM regs.
> + */
> +static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
> +			       int regnum)
> +{
> +	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
> +	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
> +	bool endian = priv->is_little_endian;
> +	u32 mdio_stat, mdio_ctl;
> +	unsigned long flags;
> +	int ret;
> +
> +	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
> +	mdio_stat |= MDIO_STAT_ENC;
> +
>  	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
>  
>  	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> @@ -218,13 +298,11 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>  	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
>  
>  	/* Set the register address */
> -	if (regnum & MII_ADDR_C45) {
> -		xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
> +	xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
>  
> -		ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
> +	if (ret)
> +		return ret;
>  
>  	if (priv->has_a009885)
>  		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
> @@ -326,8 +404,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	bus->name = "Freescale XGMAC MDIO Bus";
> -	bus->read = xgmac_mdio_read;
> -	bus->write = xgmac_mdio_write;
> +	bus->read = xgmac_mdio_read_c22;
> +	bus->write = xgmac_mdio_write_c22;
> +	bus->read_c45 = xgmac_mdio_read_c45;
> +	bus->write_c45 = xgmac_mdio_write_c45;
>  	bus->parent = &pdev->dev;
>  	bus->probe_capabilities = MDIOBUS_C22_C45;
>  	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
> -- 
> 2.36.0
> 
