Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D630C5F4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhBBQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhBBQdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:33:00 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC42C061573;
        Tue,  2 Feb 2021 08:28:01 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e70so20342320ote.11;
        Tue, 02 Feb 2021 08:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LDgn1SWNf0wdSg79ulwE3dp31gPMMknk60I4YXAyX/U=;
        b=I0Vk99hXLVShvyTDdHUmBfjqYZ+gzW08ZP79/2EVNaHxQPpJ+bf+1xQk2fU6mocd3D
         qRCYVaEu58j5PIJJ+MEDpbJL8uHCvdInI5Er8rSEVOYrJxH3Zaw104i/PwsjTpx8Mxnu
         0RZYnwezyQvQuKyFq2IbRYITb19zt+Tuucwx0tMvuBnUDDArFSSKMuyBkLUKmSc9FPJj
         2L5C8jPCpvnq4/r2XyRcSIBcx/nZw6mKHM8tM/hDVk/P9QB46oJsUaLYVzUf0Q4QFfnX
         oKj9j7UMT78JuCiGFzVrAHTWyLNo3up+yOzIsVCu4it+nrHAcpRWTEm1u1wPFG/qDtl0
         eYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=LDgn1SWNf0wdSg79ulwE3dp31gPMMknk60I4YXAyX/U=;
        b=atn3MTo9N73IlPtmudQfBDimTntbv+afpQMIVfGX3qEm3jhrcP/bVbW2F/d05sybuM
         BKBQAnhlqhMN9qDhpXVO+oVUwYXOAVLVZL9z90KDWkkl0tJr0uwrYRWlPzcP55HZDn3J
         6Th/ERNj0UNk405fOkXo9zhUNfjjNuo+sc9mn/QrYPZS1GqAWdvzrc+C5lABEKEBx0zq
         YEs0HJIGVaxqQCWT4rtxR9M6sFbvqPEB1jfkYVJV/bqWI6xSkfxPW47OesPWG0fVYK/Z
         w+VVSTLHNJYgoeP1flYP9Y/xKR9ygKYNl8QJ9zx6gTIRugZv7MPJNnMortnH/KbNYFVz
         dESQ==
X-Gm-Message-State: AOAM531cAYC7fjlEiud6UA8IfBLn4XUlZziTN6smwkAZr6t69qaec6WJ
        VELktPyW4bi5twQVlTV4WeY=
X-Google-Smtp-Source: ABdhPJw22UCJZeQrbyeJq+KwF3PVuOvt5fNhj7g/A6PaUTp2SvnOSZTCqekJXXq/On84+Dcnx517Rg==
X-Received: by 2002:a9d:7151:: with SMTP id y17mr15921335otj.39.1612283281433;
        Tue, 02 Feb 2021 08:28:01 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a22sm4685260otp.53.2021.02.02.08.28.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Feb 2021 08:28:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 2 Feb 2021 08:27:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Ungerer <gerg@linux-m68k.org>, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: Silence M5272 build warnings
Message-ID: <20210202162759.GD159455@roeck-us.net>
References: <20210202130650.865023-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202130650.865023-1-geert@linux-m68k.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 02:06:50PM +0100, Geert Uytterhoeven wrote:
> If CONFIG_M5272=y:
> 
>     drivers/net/ethernet/freescale/fec_main.c: In function ‘fec_restart’:
>     drivers/net/ethernet/freescale/fec_main.c:948:6: warning: unused variable ‘val’ [-Wunused-variable]
>       948 |  u32 val;
> 	  |      ^~~
>     drivers/net/ethernet/freescale/fec_main.c: In function ‘fec_get_mac’:
>     drivers/net/ethernet/freescale/fec_main.c:1667:28: warning: unused variable ‘pdata’ [-Wunused-variable]
>      1667 |  struct fec_platform_data *pdata = dev_get_platdata(&fep->pdev->dev);
> 	  |                            ^~~~~
> 
> Fix this by moving the variable declarations inside the existing #ifdef
> blocks.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/net/ethernet/freescale/fec_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 9ebdb0e54291b204..3db882322b2bd3e8 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -945,7 +945,6 @@ static void
>  fec_restart(struct net_device *ndev)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> -	u32 val;
>  	u32 temp_mac[2];
>  	u32 rcntl = OPT_FRAME_SIZE | 0x04;
>  	u32 ecntl = 0x2; /* ETHEREN */
> @@ -997,7 +996,8 @@ fec_restart(struct net_device *ndev)
>  
>  #if !defined(CONFIG_M5272)
>  	if (fep->quirks & FEC_QUIRK_HAS_RACC) {
> -		val = readl(fep->hwp + FEC_RACC);
> +		u32 val = readl(fep->hwp + FEC_RACC);
> +
>  		/* align IP header */
>  		val |= FEC_RACC_SHIFT16;
>  		if (fep->csum_flags & FLAG_RX_CSUM_ENABLED)
> @@ -1664,7 +1664,6 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
>  static void fec_get_mac(struct net_device *ndev)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> -	struct fec_platform_data *pdata = dev_get_platdata(&fep->pdev->dev);
>  	unsigned char *iap, tmpaddr[ETH_ALEN];
>  
>  	/*
> @@ -1695,6 +1694,8 @@ static void fec_get_mac(struct net_device *ndev)
>  		if (FEC_FLASHMAC)
>  			iap = (unsigned char *)FEC_FLASHMAC;
>  #else
> +		struct fec_platform_data *pdata = dev_get_platdata(&fep->pdev->dev);
> +
>  		if (pdata)
>  			iap = (unsigned char *)&pdata->mac;
>  #endif
> -- 
> 2.25.1
> 
