Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A85145F8B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAVX4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:56:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43261 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVX4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:56:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id x6so592487pfo.10
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=cCUsdj/fZYwNN192nrue22afyzRZAQtb0Bq+RK6T7n8=;
        b=Ri0IcXw57gZiaEwAVrFx7No5+7en+4TehQHRwWbKCEqldQbtMfnfW6EZuTtGgX5Cb3
         Lm1a+PGl5BLXa1r+5rjTW5oHFJ0JVM0AgfndPlja0Ep8PEtTtzk6WVzuvKaqn7P87Gku
         wiEz3wygmiAFEk73UezHVlySvHjepgfqzgehaaRIjD0UifT3IWYxkfY49gobkruN+4gY
         CIt55fHrJjz1ugrqp/mCP8ZZDRZLePBXBo+Xm2NdUHgrh3AH40LGUue67Y8AVIWDuPhk
         b1qIKKZXY5Xl5I/2EzwU28A2gLoqXrwDWPwZdPJIVsVH5XLgO+tIj8+c9Tdth9J/D56f
         XmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=cCUsdj/fZYwNN192nrue22afyzRZAQtb0Bq+RK6T7n8=;
        b=AdHDWoCvkAnWTdiefE4T5vUDSS63hu/we0OvWmupcgB7i+e9SC31zjcPFooarhve2J
         vGRF8W2u+wLqo5ltEvYRpXo0M/JVBZ71Jd5iX5dK260mj5sB+8xVrfRGWZ4RiXla7E6m
         koY13HJFm+TCYVTL3ERewe66pXDMWzTk/cx0il/Uwe1wC1s+IJfoKojzfJwf+cSU1WA7
         gkwB+Boy0PnJdkKIOnkdnmTqQqPjtF//phdUdDhsoFkZG4dHgMpbUlatRTHB5QTShY46
         ngv8BhLMhuyH8v+FWHCd2Z176QsxpatAg2Kwi3l2hwWmuRGmNF+4N6Q3YAPUAPLUGaMw
         OV4g==
X-Gm-Message-State: APjAAAXtcKueLMl0ARqTaB1gOaQRyQ/2aJ7Awlnp9ApR68jFrmrDeK+4
        b5GQbvSDF8k9byggU+vIruG+EA==
X-Google-Smtp-Source: APXvYqwdwBCzqkc4UQB3eGdqOHqI/e4q1PdOcvp33Okdte4nGO+ldcr3OcZHs74ztieN7MdlwUJSYg==
X-Received: by 2002:a63:4824:: with SMTP id v36mr855635pga.343.1579737366177;
        Wed, 22 Jan 2020 15:56:06 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id b1sm69151pfp.44.2020.01.22.15.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 15:56:05 -0800 (PST)
Date:   Wed, 22 Jan 2020 15:56:05 -0800 (PST)
X-Google-Original-Date: Wed, 22 Jan 2020 15:54:50 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH] macb: Don't unregister clks unconditionally
CC:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        yash.shah@sifive.com, linux@roeck-us.net
To:     sboyd@kernel.org
In-Reply-To: <20200104001921.225529-1-sboyd@kernel.org>
References: <20200104001921.225529-1-sboyd@kernel.org>
Message-ID: <mhng-f3191662-fd7d-4bd4-8179-0338fb742dc2@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Jan 2020 16:19:21 PST (-0800), sboyd@kernel.org wrote:
> The only clk init function in this driver that register a clk is
> fu540_c000_clk_init(), and thus we need to unregister the clk when this
> driver is removed on that platform. Other init functions, for example
> macb_clk_init(), don't register clks and therefore we shouldn't
> unregister the clks when this driver is removed. Convert this
> registration path to devm so it gets auto-unregistered when this driver
> is removed and drop the clk_unregister() calls in driver remove (and
> error paths) so that we don't erroneously remove a clk from the system
> that isn't registered by this driver.
>
> Otherwise we get strange crashes with a use-after-free when the
> devm_clk_get() call in macb_clk_init() calls clk_put() on a clk pointer
> that has become invalid because it is freed in clk_unregister().
>
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Yash Shah <yash.shah@sifive.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 9c767ee252ac..7dce403fd27c 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4069,7 +4069,7 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
>  	mgmt->rate = 0;
>  	mgmt->hw.init = &init;
>
> -	*tx_clk = clk_register(NULL, &mgmt->hw);
> +	*tx_clk = devm_clk_register(&pdev->dev, &mgmt->hw);
>  	if (IS_ERR(*tx_clk))
>  		return PTR_ERR(*tx_clk);
>
> @@ -4397,7 +4397,6 @@ static int macb_probe(struct platform_device *pdev)
>
>  err_disable_clocks:
>  	clk_disable_unprepare(tx_clk);
> -	clk_unregister(tx_clk);
>  	clk_disable_unprepare(hclk);
>  	clk_disable_unprepare(pclk);
>  	clk_disable_unprepare(rx_clk);
> @@ -4427,7 +4426,6 @@ static int macb_remove(struct platform_device *pdev)
>  		pm_runtime_dont_use_autosuspend(&pdev->dev);
>  		if (!pm_runtime_suspended(&pdev->dev)) {
>  			clk_disable_unprepare(bp->tx_clk);
> -			clk_unregister(bp->tx_clk);
>  			clk_disable_unprepare(bp->hclk);
>  			clk_disable_unprepare(bp->pclk);
>  			clk_disable_unprepare(bp->rx_clk);

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>

Thanks!
