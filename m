Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1846D1E51
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjCaKsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjCaKst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:48:49 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794A21D2C6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 03:48:48 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ek18so87940262edb.6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 03:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680259727;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpCCft7YdpHuCf09F7vhQR6CYdc9D/+J3hCwi5oqvJQ=;
        b=izzl5E5tkpKvcIpKbxJpGQAoCajbHfAw8N7br8U3XwifX4120XNAIwYMTNeV19BpUn
         hm9FgkLRWDGIOZZalX/FqoFdRWQ1XQfUEl2ozVpU++wruqFVMvy2y00IoR72zAAlzgzq
         Q/6Q9r/lLVH+D50B5jfY23bvIjWzOJx/hvRR2wSpTDueCVfJ4c9g1sEiyt/Ogna5VHWy
         6EPnYl9Gk7eB1u/8vDI1D0wHSCraB5DhcbqJhV5PkyApPCdTdHTQOLRxYKwQMQvF62dj
         O/H1o77XypMJfHZ7QdiufJFMdE08Mi3jXGXbY0uuL3iTAZuiH0cl1pIu1hGXLq5HIynI
         WwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680259727;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BpCCft7YdpHuCf09F7vhQR6CYdc9D/+J3hCwi5oqvJQ=;
        b=Pa1KA47jM8cYtpXhQmxKgpd6jN6yfEFrXmpiKAwB5n5Eu1hIFZfK3Ujcm3iqSNTjOG
         sjLwMCBq2PjwUoLCA9A/xc699cfVYJfY54FQVGn0n09shgqenMJtTzMd6axJ8KAAgO/d
         Q4Dt4PTooNrqxy5LnU9a8GglQ/QKc2vy21GUuW7tzcTZAB+Q5VsqDMmPTjJCmpq37XGb
         ZlOFHoPNceZsT4NIlBXSdc7CXR5Li8WJuk27R4X7xct6or3E/NIVaGp9ZdJ8wf0JsE8M
         /l/gNjtiXeQWY31QoR44aX1T/Y/YQzt1vTwsP24BSQ6r6JzstsG/SWdESRIZGAtQpoxZ
         JXiw==
X-Gm-Message-State: AAQBX9dMjl52KhBO6RRFnNaBXpvD+onm6NmCv7SX/Oao33uadW1Fq8Tv
        2ycyqHrNuoCY5fVRUZak7zo=
X-Google-Smtp-Source: AKy350Zd/mGvF7+sH9cFwkaytZBoyPvYgML1vPT3Zi0KgeWUecsZ/d1Q8Cn5uW10yXaKHITE0kdVBg==
X-Received: by 2002:a17:907:25cb:b0:946:f79b:e785 with SMTP id ae11-20020a17090725cb00b00946f79be785mr10916541ejc.2.1680259726804;
        Fri, 31 Mar 2023 03:48:46 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bc49:5c00:14ca:5cc2:a471:3ac3? (dynamic-2a01-0c23-bc49-5c00-14ca-5cc2-a471-3ac3.c23.pool.telefonica.de. [2a01:c23:bc49:5c00:14ca:5cc2:a471:3ac3])
        by smtp.googlemail.com with ESMTPSA id pg1-20020a170907204100b0092b546b57casm830594ejb.195.2023.03.31.03.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:48:46 -0700 (PDT)
Message-ID: <45c43618-3368-f780-c8bb-68db4ed5760f@gmail.com>
Date:   Fri, 31 Mar 2023 12:48:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Corinna Vinschen <vinschen@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
References: <20230331092341.268964-1-vinschen@redhat.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: stmmac: allow ethtool action on PCI devices
 if device is down
In-Reply-To: <20230331092341.268964-1-vinschen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.03.2023 11:23, Corinna Vinschen wrote:
> So far stmmac is only able to handle ethtool commands if the device
> is UP.  However, PCI devices usually just have to be in the active
> state for ethtool commands.
> 
What do mean with "active state" here? D0? Or, as you say "connected
to PCI" a few lines later, do you refer to hot-plugging?

PCI being in D0 often isn't sufficient, especially if interface is down.
Then required resources like clocks may be disabled by the driver.

A driver may runtime-suspend a device for multiple reasons, e.g.
interface down or link down. Then the device may be put to D3hot
to save power.
If we say that it's worth to wake a device for an ethtool command,
then I wonder whether this is something that should be done in net
core. E.g. calling pm_runtime_get_sync() in __dev_ethtool, similar to
what we do in __dev_open() to deal with run-time suspended and
therefore potentially detached devices.

> Rename stmmac_check_if_running to stmmac_ethtool_begin and add a
> stmmac_ethtool_complete action.  Check if the device is connected
> to PCI and if so, just make sure the device is active.  Reset it
> to idle state as complete action.
> 
> Tested on Intel Elkhart Lake system.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 20 +++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index 35c8dd92d369..5a57970dc06a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -14,6 +14,7 @@
>  #include <linux/mii.h>
>  #include <linux/phylink.h>
>  #include <linux/net_tstamp.h>
> +#include <linux/pm_runtime.h>
>  #include <asm/io.h>
>  
>  #include "stmmac.h"
> @@ -429,13 +430,27 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
>  
>  }
>  
> -static int stmmac_check_if_running(struct net_device *dev)
> +static int stmmac_ethtool_begin(struct net_device *dev)
>  {
> +	struct stmmac_priv *priv = netdev_priv(dev);
> +
> +	if (priv->plat->pdev) {
> +		pm_runtime_get_sync(&priv->plat->pdev->dev);
> +		return 0;
> +	}
>  	if (!netif_running(dev))
>  		return -EBUSY;
>  	return 0;
>  }
>  
> +static void stmmac_ethtool_complete(struct net_device *dev)
> +{
> +	struct stmmac_priv *priv = netdev_priv(dev);
> +
> +	if (priv->plat->pdev)
> +		pm_runtime_put(&priv->plat->pdev->dev);
> +}
> +
>  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> @@ -1152,7 +1167,8 @@ static int stmmac_set_tunable(struct net_device *dev,
>  static const struct ethtool_ops stmmac_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES,
> -	.begin = stmmac_check_if_running,
> +	.begin = stmmac_ethtool_begin,
> +	.complete = stmmac_ethtool_complete,
>  	.get_drvinfo = stmmac_ethtool_getdrvinfo,
>  	.get_msglevel = stmmac_ethtool_getmsglevel,
>  	.set_msglevel = stmmac_ethtool_setmsglevel,

