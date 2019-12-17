Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754E9123AFE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLQXj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:39:28 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34444 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQXj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:39:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so287214lfc.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 15:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pfdx4gVnPOyl5tZEyGcgXnZJq2bTo7hynLp5HRZNbP4=;
        b=nldqNSdJFuKfzJfsJ2Fpb4lmORbAfIn0+rY0VrTX93vksbi3wPUvcIZc778/8vtfO2
         LHiJE3p3e+8cJd0fGl8qCd7MTbgzCAsX1JKs6I/fVS/7Wqrxp1p4CcMsFtSovEwBnN3N
         4WF1InkZN+lDvYs0IvasYh/Nl93SEDGDZafuhAE+3ZPcyLsMZw0G9osihVwGo3zIYabK
         tVPMWeAPbPKKU05qCebwaYuJWQuU8FtJlbaDy/u1Sg34+lXBzR1qGWOWR1d2dLYaBSMZ
         AngtW2hzF5lo6rERSK+M0X1sQ2tdQSii9k13k49wQ+dD9e2y92URdQIa/6B7EY+xf15v
         goLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pfdx4gVnPOyl5tZEyGcgXnZJq2bTo7hynLp5HRZNbP4=;
        b=Vtu/j7FSWHaMS6V9Z4HPR/NgonN3yQSY8C8+b2aJQQt6YO4hb5v6Hb2JpzBe3iwJ09
         jFVlLVLqqifij1XoEbikFshe3csknOgFQEcSSSeYAQDuUY96XV3Ow+VnkEiqb6RvyhYN
         KQ3VEa4qSIhftTzbBahMNsLFvGN1bwT1QFdy+Jv7Of6tGBQBbsCtjMhn0vl84nhb1Esy
         AcCDcMkfq0et1GFy7uwuSXb12XKSmTA27+7/hdOAsmb19Gm0RLF9zBtjY5AtbSZgJA/u
         QpCIJ9c8aoDUwZanrRc66ciDGs19QmyEUoLNSFHuyCJdS9uZsTEB4Snw9RtV+YXcXtEV
         HHCA==
X-Gm-Message-State: APjAAAVF+DDi9GUkhVLqRaoUvpiX2Y1bwv+CJLZ0yjLT1CYskf7tLoNX
        Gyqrk2bmMYNh8lNqnReBnQKoOQ==
X-Google-Smtp-Source: APXvYqz/nO4z9QfTMfxSYGcQWQAspEflWH0mYRc1p8btjXDi2e6FrdMClvOPzC8LLVuSx+H0qMSbLA==
X-Received: by 2002:ac2:4c98:: with SMTP id d24mr76741lfl.138.1576625966034;
        Tue, 17 Dec 2019 15:39:26 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t29sm98069lfg.84.2019.12.17.15.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 15:39:25 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:39:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 4/8] enetc: Make MDIO accessors more generic and
 export to include/linux/fsl
Message-ID: <20191217153916.1e8c4f4a@cakuba.netronome.com>
In-Reply-To: <20191217221831.10923-5-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
        <20191217221831.10923-5-olteanv@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 00:18:27 +0200, Vladimir Oltean wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Within the LS1028A SoC, the register map for the ENETC MDIO controller
> is instantiated a few times: for the central (external) MDIO controller,
> for the internal bus of each standalone ENETC port, and for the internal
> bus of the Felix switch.
> 
> Refactoring is needed to support multiple MDIO buses from multiple
> drivers. The enetc_hw structure is made an opaque type and a smaller
> enetc_mdio_priv is created.
> 
> 'mdio_base' - MDIO registers base address - is being parameterized, to
> be able to work with different MDIO register bases.

I'm getting these on a W=1 C=1 allmodconfig build:

WARNING: drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio: 'enetc_mdio_write' exported twice. Previous export was in drivers/net/ethernet/freescale/enetc/fsl-enetc.ko
WARNING: drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio: 'enetc_mdio_read' exported twice. Previous export was in drivers/net/ethernet/freescale/enetc/fsl-enetc.ko
WARNING: drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio: 'enetc_hw_alloc' exported twice. Previous export was in drivers/net/ethernet/freescale/enetc/fsl-enetc.ko

> -#define enetc_mdio_rd(hw, off) \
> -	enetc_port_rd(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET)
> -#define enetc_mdio_wr(hw, off, val) \
> -	enetc_port_wr(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET, val)
> -#define enetc_mdio_rd_reg(off)	enetc_mdio_rd(hw, off)
> +static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
> +{
> +	return enetc_port_rd(mdio_priv->hw, mdio_priv->mdio_base + off);
> +}

Please no static inline in source files. Compiler will know to inline
this.
