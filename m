Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D445811AB8B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfLKNGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:06:04 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55753 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLKNGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:06:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so6991318wmj.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 05:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i+q2Q9t7BNzHgJtBjoQUoIDSAqJ+iisBnqllQCfiLKs=;
        b=fc6JfWoKGnISOcmBzLLz0o5EiKUfvs2p/zr2juiuQhhzQm1LF4muc7f6pMcoDCK9Zg
         TKbsmu+sc/JL+2m2BAEskIZzjfNnMKFbppz7v2DnXPR81Hj1NjvMMoG9v0/2Mzbm5SR4
         ZXRiOoG+fzsQp1L1y8hAh/YnpdiJ2fWthu4xnhzTUkXF8muSBdEgpd0WCAISQqtcOgbm
         gGQcom/i4oJBVmKlqlAkJHdhy/oh/vnOH1Px56tppeBbdAWujIBZaMJ686nXzA6Xz/Dg
         s0riEViU6JYvIHZm5z7tlts3k/ROjbiaGuFuD3wUXhP3nE+2EAsMWjO3M/RMyM+Dz3so
         7ZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i+q2Q9t7BNzHgJtBjoQUoIDSAqJ+iisBnqllQCfiLKs=;
        b=d+2zJ42S94AbIep55hgmS5LVbvRth8hKyifchduyNAdG47VRucaKPo6Jp0+cnAR7EL
         g95sDnkzaTf2c2reuAhoQbui2Vm2VLNVr3yhXWGJ17q+4FPY9RtC5zGRYGj6VyvHqdj8
         LTIK08RDE0dfIhNgpGjG0HaR4ZnmJX74Os9sUjcT1Zhy6Ske0/6/ELaJgJif5Ysqv8hl
         HJH79QIi08GHIspWXjnQaFPUKDT7sokLqFRMfwOUTn3YTU2rPrUHCp1wiQA/+fjy6GIr
         CeMGEE6T1XH0yvFpqIUv/V3TWftZ8Z32UmbOUodkfQjAHEd8O5jw3Aw57/pcyaXy5NuT
         8Vlw==
X-Gm-Message-State: APjAAAWZfrIgjxv8VY7iFIATZVCzPrjTbto73EgI7ZOBp/NJVjTAUohm
        rnH/04iXp45n3+M596wRTQQzTA==
X-Google-Smtp-Source: APXvYqzijnet5cwTavUzZHfJs2p6aAxR6fbsktI1fUCU7gmnI4KNR0dfEoc8Tv5bABDuzVYaXkiS9w==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr3605584wmb.80.1576069562068;
        Wed, 11 Dec 2019 05:06:02 -0800 (PST)
Received: from apalos.home (ppp-94-66-130-5.home.otenet.gr. [94.66.130.5])
        by smtp.gmail.com with ESMTPSA id x11sm2224810wre.68.2019.12.11.05.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 05:06:01 -0800 (PST)
Date:   Wed, 11 Dec 2019 15:05:58 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ethernet: ti: select PAGE_POOL for switchdev
 driver
Message-ID: <20191211130558.GA10304@apalos.home>
References: <20191211125643.1987157-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211125643.1987157-1-arnd@arndb.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:56:09PM +0100, Arnd Bergmann wrote:
> The new driver misses a dependency:
> 
> drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_rx_handler':
> cpsw_new.c:(.text+0x259c): undefined reference to `__page_pool_put_page'
> cpsw_new.c:(.text+0x25d0): undefined reference to `page_pool_alloc_pages'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_fill_rx_channels':
> cpsw_priv.c:(.text+0x22d8): undefined reference to `page_pool_alloc_pages'
> cpsw_priv.c:(.text+0x2420): undefined reference to `__page_pool_put_page'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_create_xdp_rxqs':
> cpsw_priv.c:(.text+0x2624): undefined reference to `page_pool_create'
> drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_run_xdp':
> cpsw_priv.c:(.text+0x2dc8): undefined reference to `__page_pool_put_page'
> 
> Other drivers use 'select' for PAGE_POOL, so do the same here.
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/ti/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index a46f4189fde3..bf98e0fa7d8b 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -63,6 +63,7 @@ config TI_CPSW_SWITCHDEV
>  	tristate "TI CPSW Switch Support with switchdev"
>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>  	depends on NET_SWITCHDEV
> +	select PAGE_POOL
>  	select TI_DAVINCI_MDIO
>  	select MFD_SYSCON
>  	select REGMAP
> -- 
> 2.20.0
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
