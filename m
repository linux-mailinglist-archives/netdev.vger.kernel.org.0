Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395DD522400
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiEJSae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244905AbiEJSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:30:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AAD25F79A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:30:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id k27so21035612edk.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+R6xGZCHgF6mUliqBhKMvijH9u9U1lU+KDiyj4AdCPY=;
        b=UzRT5HeZRQEpJpdgoa04oyeg2Iq+g8F0ULa9tXcXjuJ5YDRWgQBD/MeIk8Kyj163Pa
         7uJECMxdfJAa7Sqt4XSIWQMCJQTCp4hWeUYySxB1HhgoX3qg4+tKcFgAaob57dmBuBsg
         VrFuzKJR0PxiPuU0GPVPNsiyWLLYc9gjadGJQobrG52TmTM3PVyLNrMztbxvQlntYled
         kgyAPWiNvnGoCU6VAsmk5/wjJu88pTVVG82NahjCUsQ2UQMOKH1tGlnkhtTSQ3a+JPx1
         CI0C1ydUwaSc+OfQePR207s9VJahMUwPHijrZonoLoKMEqA/gNcfgXZKJn3c5aapwZD1
         slGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+R6xGZCHgF6mUliqBhKMvijH9u9U1lU+KDiyj4AdCPY=;
        b=7EV0a7CIW1WtBiR2OminjR1Ty9552os2HSvvVZtu57JMb8iSUfyBJEtwbljkWiHRYR
         tbD97sHBVSOP5j5qpTV76upspXCjj05uWNUtwoZJ9IofZ5tJTHbyFHmnFmhYwTW7YoiF
         /mxoW9cVLGzXptowO5u64r7XUsa4qFsNH2Kl90qsjoqC1oKnR3QEKm4H1y/vxYbftKfD
         V3QWfXmHl/jpFDk46Dx7RRj0q/btXrDRvx5PhrkVVWdLQplD7ppLiznhVvYeFL86/jY1
         PktJM2L30P2CKd1Ssf1mxnIvCCkxjm83MKyjv3JOpSHAYjtSZXm45ExYsHFVAQN60yVg
         gM3Q==
X-Gm-Message-State: AOAM530JjhZFMTo6prqEz6p7eyPOEarM9hm49dPO6G19o6atGEya7sBi
        SKMFZ2WL7HRcrfLhjMcSkFU=
X-Google-Smtp-Source: ABdhPJxERJotoHan5o6sK86ZViIfmXaYs3LzEgpjYzSnyZXBKIp0w09UqifimP08Z4BOF2nEyHtgEw==
X-Received: by 2002:a05:6402:84a:b0:423:fe99:8c53 with SMTP id b10-20020a056402084a00b00423fe998c53mr24279206edz.195.1652207428033;
        Tue, 10 May 2022 11:30:28 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id r4-20020aa7d144000000b0042617ba63a4sm7935549edo.46.2022.05.10.11.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:30:27 -0700 (PDT)
Date:   Tue, 10 May 2022 21:30:25 +0300
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
Subject: Re: [PATCH net-next 08/10] net: ethernet: freescale: fec: Separate
 C22 and C45 transactions for xgmac
Message-ID: <20220510183025.gvfxcep6mx4gdmr7@skbuf>
References: <20220508153049.427227-1-andrew@lunn.ch>
 <20220508153049.427227-9-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508153049.427227-9-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 05:30:47PM +0200, Andrew Lunn wrote:
> The fec MDIO bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new API calls where appropriate.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 149 +++++++++++++++-------
>  1 file changed, 101 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 9f33ec838b52..6f749387b5c5 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1860,47 +1860,74 @@ static int fec_enet_mdio_wait(struct fec_enet_private *fep)
>  	return ret;
>  }
>  
> -static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +static int fec_enet_mdio_read_c22(struct mii_bus *bus, int mii_id, int regnum)
>  {
>  	struct fec_enet_private *fep = bus->priv;
>  	struct device *dev = &fep->pdev->dev;
>  	int ret = 0, frame_start, frame_addr, frame_op;
> -	bool is_c45 = !!(regnum & MII_ADDR_C45);
>  
>  	ret = pm_runtime_resume_and_get(dev);
>  	if (ret < 0)
>  		return ret;
>  
> -	if (is_c45) {
> -		frame_start = FEC_MMFR_ST_C45;
> +	/* C22 read */
> +	frame_op = FEC_MMFR_OP_READ;
> +	frame_start = FEC_MMFR_ST;
> +	frame_addr = regnum;
>  
> -		/* write address */
> -		frame_addr = (regnum >> 16);
> -		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> -		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> -		       FEC_MMFR_TA | (regnum & 0xFFFF),
> -		       fep->hwp + FEC_MII_DATA);
> +	/* start a read op */
> +	writel(frame_start | frame_op |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);

You lost the argument alignment to the open parenthesis.

>  
> -		/* wait for end of transfer */
> -		ret = fec_enet_mdio_wait(fep);
> -		if (ret) {
> -			netdev_err(fep->netdev, "MDIO address write timeout\n");
> -			goto out;
> -		}
> +	/* wait for end of transfer */
> +	ret = fec_enet_mdio_wait(fep);
> +	if (ret) {
> +		netdev_err(fep->netdev, "MDIO read timeout\n");
> +		goto out;
> +	}
>  
> -		frame_op = FEC_MMFR_OP_READ_C45;
> +	ret = FEC_MMFR_DATA(readl(fep->hwp + FEC_MII_DATA));
>  
> -	} else {
> -		/* C22 read */
> -		frame_op = FEC_MMFR_OP_READ;
> -		frame_start = FEC_MMFR_ST;
> -		frame_addr = regnum;
> +out:
> +	pm_runtime_mark_last_busy(dev);
> +	pm_runtime_put_autosuspend(dev);
> +
> +	return ret;
> +}
> +
> +static int fec_enet_mdio_read_c45(struct mii_bus *bus, int mii_id,
> +				  int devad, int regnum)
> +{
> +	struct fec_enet_private *fep = bus->priv;
> +	struct device *dev = &fep->pdev->dev;
> +	int ret = 0, frame_start, frame_op;
> +
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	frame_start = FEC_MMFR_ST_C45;
> +
> +	/* write address */
> +	writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
> +	       FEC_MMFR_TA | (regnum & 0xFFFF),
> +	       fep->hwp + FEC_MII_DATA);
> +
> +	/* wait for end of transfer */
> +	ret = fec_enet_mdio_wait(fep);
> +	if (ret) {
> +		netdev_err(fep->netdev, "MDIO address write timeout\n");
> +		goto out;
>  	}
>  
> +	frame_op = FEC_MMFR_OP_READ_C45;
> +
>  	/* start a read op */
>  	writel(frame_start | frame_op |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> -		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
> +	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
> +	       FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
>  
>  	/* wait for end of transfer */
>  	ret = fec_enet_mdio_wait(fep);
> @@ -1918,43 +1945,67 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  	return ret;
>  }
>  
> -static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> -			   u16 value)
> +static int fec_enet_mdio_write_c22(struct mii_bus *bus, int mii_id, int regnum,
> +				   u16 value)
>  {
>  	struct fec_enet_private *fep = bus->priv;
>  	struct device *dev = &fep->pdev->dev;
>  	int ret, frame_start, frame_addr;
> -	bool is_c45 = !!(regnum & MII_ADDR_C45);
>  
>  	ret = pm_runtime_resume_and_get(dev);
>  	if (ret < 0)
>  		return ret;
>  
> -	if (is_c45) {
> -		frame_start = FEC_MMFR_ST_C45;
> +	/* C22 write */
> +	frame_start = FEC_MMFR_ST;
> +	frame_addr = regnum;
>  
> -		/* write address */
> -		frame_addr = (regnum >> 16);
> -		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> -		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> -		       FEC_MMFR_TA | (regnum & 0xFFFF),
> -		       fep->hwp + FEC_MII_DATA);
> +	/* start a write op */
> +	writel(frame_start | FEC_MMFR_OP_WRITE |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		FEC_MMFR_TA | FEC_MMFR_DATA(value),
> +		fep->hwp + FEC_MII_DATA);

Here as well.

>  
> -		/* wait for end of transfer */
> -		ret = fec_enet_mdio_wait(fep);
> -		if (ret) {
> -			netdev_err(fep->netdev, "MDIO address write timeout\n");
> -			goto out;
> -		}
> -	} else {
> -		/* C22 write */
> -		frame_start = FEC_MMFR_ST;
> -		frame_addr = regnum;
> +	/* wait for end of transfer */
> +	ret = fec_enet_mdio_wait(fep);
> +	if (ret)
> +		netdev_err(fep->netdev, "MDIO write timeout\n");
> +
> +	pm_runtime_mark_last_busy(dev);
> +	pm_runtime_put_autosuspend(dev);
> +
> +	return ret;
> +}
> +
> +static int fec_enet_mdio_write_c45(struct mii_bus *bus, int mii_id,
> +				   int devad, int regnum, u16 value)
> +{
> +	struct fec_enet_private *fep = bus->priv;
> +	struct device *dev = &fep->pdev->dev;
> +	int ret, frame_start;
> +
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	frame_start = FEC_MMFR_ST_C45;
> +
> +	/* write address */
> +	writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
> +	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
> +	       FEC_MMFR_TA | (regnum & 0xFFFF),
> +	       fep->hwp + FEC_MII_DATA);
> +
> +	/* wait for end of transfer */
> +	ret = fec_enet_mdio_wait(fep);
> +	if (ret) {
> +		netdev_err(fep->netdev, "MDIO address write timeout\n");
> +		goto out;
>  	}
>  
>  	/* start a write op */
>  	writel(frame_start | FEC_MMFR_OP_WRITE |
> -		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
> +		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
>  		FEC_MMFR_TA | FEC_MMFR_DATA(value),
>  		fep->hwp + FEC_MII_DATA);
>  
> @@ -2254,8 +2305,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	}
>  
>  	fep->mii_bus->name = "fec_enet_mii_bus";
> -	fep->mii_bus->read = fec_enet_mdio_read;
> -	fep->mii_bus->write = fec_enet_mdio_write;
> +	fep->mii_bus->read = fec_enet_mdio_read_c22;
> +	fep->mii_bus->write = fec_enet_mdio_write_c22;
> +	fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
> +	fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
>  	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
>  		pdev->name, fep->dev_id + 1);
>  	fep->mii_bus->priv = fep;
> -- 
> 2.36.0
> 

