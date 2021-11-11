Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379B444D8FB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhKKPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhKKPTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:19:05 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27984C061766;
        Thu, 11 Nov 2021 07:16:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id f8so25696123edy.4;
        Thu, 11 Nov 2021 07:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ou8kCYUrKezhxjUCVTwslzRMIDu5Ne8n1+te9ytVH1s=;
        b=ha2RFjuLPyJjOO/XAgtI1XNgbhhh73dNA1bgqZYKQMOavR4nq58c3R9R3f2FhtlBqU
         gxvJaQpd4Gp7+kQFaCAmgDBo4C821hKFdJsv/VGJR8eeVFcUc1wvm/MkbGy5+yfshBZ/
         qGygvgaxmc4e0Pir77I7F7bXkzeW6meeQ2jn11Wkh++Q+E9j2Fgy28PQuKKXM2TyqDqy
         tzd1BaY27ze1khP10ES/E3hE1wFHOpiKZoVm9WDSMLSbGWWakeR0Bs36SFA5acRCTbBK
         iJQUfriRhv3iJwvHWRXxj/JEVOGoD/Cmpt3UCzXXVRCEfJ0llNmlTec0ajtgPZ3yvUVD
         KoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ou8kCYUrKezhxjUCVTwslzRMIDu5Ne8n1+te9ytVH1s=;
        b=248dIGSeeJJvMdPxEYssBtZgGCs7vXBWp/cwmkZaRpM/oSDI/of3Hs0dFf+GXJ+Srh
         qu0jwfXuiriVOmReh2aCDNhVMx8mLJXN0Hb4z1S/hFQR8Smxmorhgv7b3KL8F0RCO7iD
         43F2++vtE2huYADToaMDaZG4C1vuo27C42BwqPwhf6hIMH+ng/Z7+0gfq70S7kClAW/E
         aOViYkA6jg7pbTrZIKwaa1H+2dIHYVNFArUGepXCMK/NvJEKf+qGbgUuQQo7dEZ/Bs3E
         hGzPRFr1/k51h/e71hmZJMr/1haE1yTTLLBB+Ln6xnn+aiwlwDmpvuUXME0/a9dmzKQ5
         DyYw==
X-Gm-Message-State: AOAM531VzchzLt/mTSZ8YhZhDUMlJn1VQO5BNjZstOvG+xMZlGLYWIX9
        VHAI1o3iO8PUQ7Qm6HCkwBg=
X-Google-Smtp-Source: ABdhPJw3TE8kuz8/k2xHXoMAQnGCP1Hdm83xKiUi1uoYtYuKz1hWQMZXVJhwj+kbBVe1G9GlPMGy8Q==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr10828710edt.177.1636643774626;
        Thu, 11 Nov 2021 07:16:14 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id g21sm1499129ejt.87.2021.11.11.07.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:16:14 -0800 (PST)
Date:   Thu, 11 Nov 2021 17:16:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: fix system hang caused by
 eee_ctrl_timer during suspend/resume
Message-ID: <20211111151612.i7mnye5c3trfptda@skbuf>
References: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On Wed, Sep 08, 2021 at 03:43:35PM +0800, Joakim Zhang wrote:
> commit 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after
> napi disabled"), this patch tries to fix system hang caused by eee_ctrl_timer,
> unfortunately, it only can resolve it for system reboot stress test. System
> hang also can be reproduced easily during system suspend/resume stess test
> when mount NFS on i.MX8MP EVK board.
> 
> In stmmac driver, eee feature is combined to phylink framework. When do
> system suspend, phylink_stop() would queue delayed work, it invokes
> stmmac_mac_link_down(), where to deactivate eee_ctrl_timer synchronizly.
> In above commit, try to fix issue by deactivating eee_ctrl_timer obviously,
> but it is not enough. Looking into eee_ctrl_timer expire callback
> stmmac_eee_ctrl_timer(), it could enable hareware eee mode again. What is
> unexpected is that LPI interrupt (MAC_Interrupt_Enable.LPIEN bit) is always
> asserted. This interrupt has chance to be issued when LPI state entry/exit
> from the MAC, and at that time, clock could have been already disabled.
> The result is that system hang when driver try to touch register from
> interrupt handler.
> 
> The reason why above commit can fix system hang issue in stmmac_release()
> is that, deactivate eee_ctrl_timer not just after napi disabled, further
> after irq freed.
> 
> In conclusion, hardware would generate LPI interrupt when clock has been
> disabled during suspend or resume, since hardware is in eee mode and LPI
> interrupt enabled.
> 
> Interrupts from MAC, MTL and DMA level are enabled and never been disabled
> when system suspend, so postpone clocks management from suspend stage to
> noirq suspend stage should be more safe.
> 
> Fixes: 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after napi disabled")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ------
>  .../ethernet/stmicro/stmmac/stmmac_platform.c | 44 +++++++++++++++++++
>  2 files changed, 44 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index ece02b35a6ce..246f84fedbc8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7118,7 +7118,6 @@ int stmmac_suspend(struct device *dev)
>  	struct net_device *ndev = dev_get_drvdata(dev);
>  	struct stmmac_priv *priv = netdev_priv(ndev);
>  	u32 chan;
> -	int ret;
>  
>  	if (!ndev || !netif_running(ndev))
>  		return 0;
> @@ -7150,13 +7149,6 @@ int stmmac_suspend(struct device *dev)
>  	} else {
>  		stmmac_mac_set(priv, priv->ioaddr, false);
>  		pinctrl_pm_select_sleep_state(priv->device);
> -		/* Disable clock in case of PWM is off */
> -		clk_disable_unprepare(priv->plat->clk_ptp_ref);

This patch looks strange to me. You are basically saying that the LPI
timer for MAC-level EEE is clocked from the clk_ptp_ref clock?! Are you
sure this is correct? I thought this clock is only used for the PTP
timestamping counter. Maybe the clock definitions in imx8mp.dtsi are not
correct?

> -		ret = pm_runtime_force_suspend(dev);
> -		if (ret) {
> -			mutex_unlock(&priv->lock);
> -			return ret;
> -		}
>  	}
>  
>  	mutex_unlock(&priv->lock);
> @@ -7242,12 +7234,6 @@ int stmmac_resume(struct device *dev)
>  		priv->irq_wake = 0;
>  	} else {
>  		pinctrl_pm_select_default_state(priv->device);
> -		/* enable the clk previously disabled */
> -		ret = pm_runtime_force_resume(dev);
> -		if (ret)
> -			return ret;
> -		if (priv->plat->clk_ptp_ref)
> -			clk_prepare_enable(priv->plat->clk_ptp_ref);
>  		/* reset the phy so that it's ready */
>  		if (priv->mii)
>  			stmmac_mdio_reset(priv->mii);
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 5ca710844cc1..4885f9ad1b1e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -9,6 +9,7 @@
>  *******************************************************************************/
>  
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/module.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
> @@ -771,9 +772,52 @@ static int __maybe_unused stmmac_runtime_resume(struct device *dev)
>  	return stmmac_bus_clks_config(priv, true);
>  }
>  
> +static int stmmac_pltfr_noirq_suspend(struct device *dev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(dev);
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int ret;
> +
> +	if (!netif_running(ndev))
> +		return 0;
> +
> +	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> +		/* Disable clock in case of PWM is off */
> +		clk_disable_unprepare(priv->plat->clk_ptp_ref);
> +
> +		ret = pm_runtime_force_suspend(dev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int stmmac_pltfr_noirq_resume(struct device *dev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(dev);
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	int ret;
> +
> +	if (!netif_running(ndev))
> +		return 0;
> +
> +	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> +		/* enable the clk previously disabled */
> +		ret = pm_runtime_force_resume(dev);
> +		if (ret)
> +			return ret;
> +
> +		clk_prepare_enable(priv->plat->clk_ptp_ref);
> +	}
> +
> +	return 0;
> +}
> +
>  const struct dev_pm_ops stmmac_pltfr_pm_ops = {
>  	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
>  	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
> +	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_noirq_suspend, stmmac_pltfr_noirq_resume)
>  };
>  EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
>  
> -- 
> 2.17.1
> 
