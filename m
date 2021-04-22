Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB0736831F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbhDVPPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbhDVPPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:15:35 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7EC06174A;
        Thu, 22 Apr 2021 08:15:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y32so33044445pga.11;
        Thu, 22 Apr 2021 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RHIZEjGySYdq+Z1v6q34x38LxGZ3mTIQiHyS1ORws1o=;
        b=NQR23WRcMJxXLn5zajba5CVVOJ4lyRVzs4T2oFNlKQgf0HfoBvkEuTLjcUpNz7c9nm
         j2T66WBiRdFKyGk/1KrEne3Tj6iw2L2Pyt4iUz3/+Eqlyq+toxvFgyUVqD+e/Ka0P/+G
         fcH+1JlZLRyB+TUZ1NpgYPAqsDffJEiBhw5Aglau0K/xVjJUy8FtlwnJOrs6oG0iVXku
         8lYRGtvimLbBCm3UCNxI8te4U23kwESA2V3Zov1OscPrVLmzq7dn865jJyYVGtaiOOHc
         ZSgd/KyipqzPS/kDliSenTVkdIE3ftZt+yCAlq2mSs2DyepkBU4IiBmYUA89QTgbNOLb
         xBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RHIZEjGySYdq+Z1v6q34x38LxGZ3mTIQiHyS1ORws1o=;
        b=KMdYsH7+UFlmOS9xWrsBZ8Fcwys6pAot9xETBtVs8YJxgHS08A17d0AuaOIIz3RlLp
         /UJfktLL3pDh0KFt8gZQfopsCOdkRRfAwuCqFbebs2O/aNuKod2Uickrcjw3kWq0D9aT
         Tbgo/6rDElwsy7zpaavhe9iy1ifi3Up5UjnzDjICYIxPF6Qd0z9R1wUvxCRmsfNdfV59
         35+u9y4emfe700ZprqXAPb5SUqUe1/MF82d3BBXCQ1zrxqZcGK31/X61I9ijC+E2dZR4
         vogKBrulKBKL8w41rpeDp5Nlwp/O/PkbzddbhpUcZSAvyUmjORrXxnFrJ6B0I6tnrxYF
         pIPw==
X-Gm-Message-State: AOAM533/8orh78m8e3InpCuBUCA+D2k1qz26/bY+8lBEIIwteY/e2kvu
        u9JsHSY6bFzPUWpBBHFfK3M=
X-Google-Smtp-Source: ABdhPJz7ZA/kYC0E3k4v1Vtk6zDuODL6XzhQUdCQPBDovUVYrdhxnlss9NgdTMzHGEZKjB91wjABdA==
X-Received: by 2002:a62:52c7:0:b029:255:e78e:5069 with SMTP id g190-20020a6252c70000b0290255e78e5069mr3643997pfb.45.1619104500681;
        Thu, 22 Apr 2021 08:15:00 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id c125sm2362195pfa.74.2021.04.22.08.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:15:00 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:14:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH] [net-next] net: enetc: fix link error again
Message-ID: <20210422151451.hp6w2jlgdt53lq4j@skbuf>
References: <20210422133518.1835403-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422133518.1835403-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:35:11PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A link time bug that I had fixed before has come back now that
> another sub-module was added to the enetc driver:
> 
> ERROR: modpost: "enetc_ierb_register_pf" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!
> 
> The problem is that the enetc Makefile is not actually used for
> the ierb module if that is the only built-in driver in there
> and everything else is a loadable module.
> 
> Fix it by always entering the directory this time, regardless
> of which symbols are configured. This should reliably fix the
> problem and prevent it from coming back another time.
> 
> Fixes: 112463ddbe82 ("net: dsa: felix: fix link error")
> Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/freescale/Makefile | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
> index 67c436400352..de7b31842233 100644
> --- a/drivers/net/ethernet/freescale/Makefile
> +++ b/drivers/net/ethernet/freescale/Makefile
> @@ -24,6 +24,4 @@ obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
>  
>  obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
>  
> -obj-$(CONFIG_FSL_ENETC) += enetc/
> -obj-$(CONFIG_FSL_ENETC_MDIO) += enetc/
> -obj-$(CONFIG_FSL_ENETC_VF) += enetc/
> +obj-y += enetc/
> -- 
> 2.29.2
> 

I feel so bad that I'm incapable of troubleshooting even the most
elementary Kconfig issues... I did not even once think of opening that
Makefile.

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
