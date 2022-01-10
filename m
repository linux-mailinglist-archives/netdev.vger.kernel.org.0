Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E44489AEB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiAJN4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiAJN4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:56:38 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7801DC06173F;
        Mon, 10 Jan 2022 05:56:38 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so5105028wmb.1;
        Mon, 10 Jan 2022 05:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7heg+71uBrQhXC+hNkzRtnZ8MTgnA1dGRJdxtU7wamk=;
        b=cLA7bvd1r3QQA+lY1hK+z5ZcWGIqsbVCPhdDEwkd6xhtyzPEJbrqbiJ2PoGrnNdSkX
         GZeQbM09042bxJo33BjeYgMuNv3pxanHz3TgfjwDsmRO5GDUuqMHNJoKjp9S1F5OpPzC
         0jYE0vIBscQqspAF2cNsl4+ceeFVdODFn60SFWLsZiwwExvXgRX34BXqSEiFoah45c35
         psHiszvjHpqofJXek5TrUPea/5aagA8hdMTonj3SzQbknEzBdHnLou+2wvRoHsns0NTo
         Axr6IYJ+zN3p9Yzx9FZelr8XiNmH18xZdIpenV/wbbI5Uc48BiAMT3Me/gKgZmm2kGLh
         4XFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7heg+71uBrQhXC+hNkzRtnZ8MTgnA1dGRJdxtU7wamk=;
        b=xq+bS9x0nA5fCKr1yy/nQLL9dbjkT+npxVSSvIdVp6n0mBfh7WU15r+nYMar4uSOFb
         R7T8pqUIOD0dpPsj7dru9WfZqyKDbtDBlX1FEH8NKBfzz/5mr44KYMmMPV4gOmdS0Bwl
         6rQvd5A7wdQ6mh/FKOQTXDVzzxOjR9lFiEifts6bHPXTpHxDHd4DdW6UyYYNB1NIFd0+
         b2VuXoVu93FcAgHK3oD5zABop6iXScYNCkuzpBQLWzOgILHG8yeFOrfgvkgesZTga9iI
         wj84H3e66Cy//AqWc+xQOhTAKcjrgWeRoxZZQ8lPQ/hB5DIgwfIpwWQCsw6gzVlz3w7+
         bwBQ==
X-Gm-Message-State: AOAM532Hby4brTXKRBVMPvS09z6Jj9PW1VW7mGnMhbE08d5WQLKMNcA6
        IeGvx1PPkMr686EVrh9Sp1o=
X-Google-Smtp-Source: ABdhPJxgi9RYk4+oynzM45mnhTF9RDnRgjCGG7Q2uv8G+2AfwE8arbzdsTLIcd1HvEieK4hhbZtRhQ==
X-Received: by 2002:a7b:c921:: with SMTP id h1mr8294640wml.66.1641822997093;
        Mon, 10 Jan 2022 05:56:37 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id r206sm3145419wma.2.2022.01.10.05.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:56:36 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:56:35 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
Message-ID: <Ydw7EzPvwArW/siQ@Red>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, Jan 10, 2022 at 07:35:49PM +0800, Conley Lee a écrit :
> This patch remove magic numbers in sun4i-emac.c and replace with macros
> defined in sun4i-emac.h
> 
> Change since v1
> ---------------
> - reformat
> - merge commits
> - add commit message
> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>
> ---
>  drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
>  drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
>  2 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
> index 849de4564709..98fd98feb439 100644
> --- a/drivers/net/ethernet/allwinner/sun4i-emac.c
> +++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
> @@ -106,9 +106,9 @@ static void emac_update_speed(struct net_device *dev)
>  
>  	/* set EMAC SPEED, depend on PHY  */
>  	reg_val = readl(db->membase + EMAC_MAC_SUPP_REG);
> -	reg_val &= ~(0x1 << 8);
> +	reg_val &= ~EMAC_MAC_SUPP_100M;
>  	if (db->speed == SPEED_100)
> -		reg_val |= 1 << 8;
> +		reg_val |= EMAC_MAC_SUPP_100M;
>  	writel(reg_val, db->membase + EMAC_MAC_SUPP_REG);
>  }
>  
> @@ -264,7 +264,7 @@ static void emac_dma_done_callback(void *arg)
>  
>  	/* re enable interrupt */
>  	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -	reg_val |= (0x01 << 8);
> +	reg_val |= EMAC_INT_CTL_RX_EN;
>  	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  
>  	db->emacrx_completed_flag = 1;
> @@ -429,7 +429,7 @@ static unsigned int emac_powerup(struct net_device *ndev)
>  	/* initial EMAC */
>  	/* flush RX FIFO */
>  	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> -	reg_val |= 0x8;
> +	reg_val |= EMAC_RX_CTL_FLUSH_FIFO;
>  	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
>  	udelay(1);
>  
> @@ -441,8 +441,8 @@ static unsigned int emac_powerup(struct net_device *ndev)
>  
>  	/* set MII clock */
>  	reg_val = readl(db->membase + EMAC_MAC_MCFG_REG);
> -	reg_val &= (~(0xf << 2));
> -	reg_val |= (0xD << 2);
> +	reg_val &= ~EMAC_MAC_MCFG_MII_CLKD_MASK;
> +	reg_val |= EMAC_MAC_MCFG_MII_CLKD_72;
>  	writel(reg_val, db->membase + EMAC_MAC_MCFG_REG);
>  
>  	/* clear RX counter */
> @@ -506,7 +506,7 @@ static void emac_init_device(struct net_device *dev)
>  
>  	/* enable RX/TX0/RX Hlevel interrup */
>  	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -	reg_val |= (0xf << 0) | (0x01 << 8);
> +	reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
>  	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  
>  	spin_unlock_irqrestore(&db->lock, flags);
> @@ -637,7 +637,9 @@ static void emac_rx(struct net_device *dev)
>  		if (!rxcount) {
>  			db->emacrx_completed_flag = 1;
>  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -			reg_val |= (0xf << 0) | (0x01 << 8);
> +			reg_val |=
> +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> +				 EMAC_INT_CTL_RX_EN);
>  			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  
>  			/* had one stuck? */
> @@ -669,7 +671,9 @@ static void emac_rx(struct net_device *dev)
>  			writel(reg_val | EMAC_CTL_RX_EN,
>  			       db->membase + EMAC_CTL_REG);
>  			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -			reg_val |= (0xf << 0) | (0x01 << 8);
> +			reg_val |=
> +				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
> +				 EMAC_INT_CTL_RX_EN);
>  			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  
>  			db->emacrx_completed_flag = 1;
> @@ -783,20 +787,20 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
>  	}
>  
>  	/* Transmit Interrupt check */
> -	if (int_status & (0x01 | 0x02))
> +	if (int_status & EMAC_INT_STA_TX_COMPLETE)
>  		emac_tx_done(dev, db, int_status);
>  
> -	if (int_status & (0x04 | 0x08))
> +	if (int_status & EMAC_INT_STA_TX_ABRT)
>  		netdev_info(dev, " ab : %x\n", int_status);
>  
>  	/* Re-enable interrupt mask */
>  	if (db->emacrx_completed_flag == 1) {
>  		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -		reg_val |= (0xf << 0) | (0x01 << 8);
> +		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
>  		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  	} else {
>  		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> -		reg_val |= (0xf << 0);
> +		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN);
>  		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
>  	}
>  
> diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.h b/drivers/net/ethernet/allwinner/sun4i-emac.h
> index 38c72d9ec600..90bd9ad77607 100644
> --- a/drivers/net/ethernet/allwinner/sun4i-emac.h
> +++ b/drivers/net/ethernet/allwinner/sun4i-emac.h
> @@ -38,6 +38,7 @@
>  #define EMAC_RX_CTL_REG		(0x3c)
>  #define EMAC_RX_CTL_AUTO_DRQ_EN		(1 << 1)
>  #define EMAC_RX_CTL_DMA_EN		(1 << 2)
> +#define EMAC_RX_CTL_FLUSH_FIFO		(1 << 3)
>  #define EMAC_RX_CTL_PASS_ALL_EN		(1 << 4)
>  #define EMAC_RX_CTL_PASS_CTL_EN		(1 << 5)
>  #define EMAC_RX_CTL_PASS_CRC_ERR_EN	(1 << 6)
> @@ -61,7 +62,21 @@
>  #define EMAC_RX_IO_DATA_STATUS_OK	(1 << 7)
>  #define EMAC_RX_FBC_REG		(0x50)
>  #define EMAC_INT_CTL_REG	(0x54)
> +#define EMAC_INT_CTL_RX_EN	(1 << 8)
> +#define EMAC_INT_CTL_TX0_EN	(1)
> +#define EMAC_INT_CTL_TX1_EN	(1 << 1)
> +#define EMAC_INT_CTL_TX_EN	(EMAC_INT_CTL_TX0_EN | EMAC_INT_CTL_TX1_EN)
> +#define EMAC_INT_CTL_TX0_ABRT_EN	(0x1 << 2)
> +#define EMAC_INT_CTL_TX1_ABRT_EN	(0x1 << 3)
> +#define EMAC_INT_CTL_TX_ABRT_EN	(EMAC_INT_CTL_TX0_ABRT_EN | EMAC_INT_CTL_TX1_ABRT_EN)
>  #define EMAC_INT_STA_REG	(0x58)
> +#define EMAC_INT_STA_TX0_COMPLETE	(0x1)
> +#define EMAC_INT_STA_TX1_COMPLETE	(0x1 << 1)
> +#define EMAC_INT_STA_TX_COMPLETE	(EMAC_INT_STA_TX0_COMPLETE | EMAC_INT_STA_TX1_COMPLETE)
> +#define EMAC_INT_STA_TX0_ABRT	(0x1 << 2)
> +#define EMAC_INT_STA_TX1_ABRT	(0x1 << 3)
> +#define EMAC_INT_STA_TX_ABRT	(EMAC_INT_STA_TX0_ABRT | EMAC_INT_STA_TX1_ABRT)
> +#define EMAC_INT_STA_RX_COMPLETE	(0x1 << 8)

Hello

As proposed by checkpatch, I thing there are several place (like all EMAC_INT_STA) where you could use BIT(x) instead of (0xX << x)

Regards
