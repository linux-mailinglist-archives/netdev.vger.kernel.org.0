Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A49A3DC574
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 11:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhGaJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 05:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhGaJgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 05:36:13 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E6EC0613CF
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 02:36:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k4so3743563wrc.0
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 02:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:cc:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C9ov3MJAWUdQko+QOq/edc4aQkJlBaVbNLpQYpgPblU=;
        b=kgAGKynGZY73uUrI68VdEVfWWlYaEwAhJX/9HkimXKTisxYfd7QED6WIVOKolrmgzV
         9sNdZSYujFAc0Zuh4JSHDV9kIiOuGKaMM3x1vjanSmbrrxbMVXYD6QtyDG0ga9FWPFl1
         tRlGcCXMXEvUTn+UEuaFpG4fRl1l0uNjPqKPREqLI+FF5U1GBe/PLkEwCvLLPiFtTIGH
         ME8rq8rMygwzXHjqFK6fM0NhfkZ6cCfwLME6txwANLukjNmy+vzElCHcg4qz6Vad/2GA
         gg9JI8HmuKq41Ppa5OAzpLHFiENz6RypusH7VUoalLNEuRvmbcw9PT4hNLyOz2I/ISxl
         vVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:cc:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C9ov3MJAWUdQko+QOq/edc4aQkJlBaVbNLpQYpgPblU=;
        b=nWKySpHI06vIpcKde6dPZdjkj9tRQo3YUyMWoeI1G8c3ZJ6t8ZR1sK9yfSYSD9ewRY
         C7VPJqN07ZSdjbT6u0k4rOCLmApS89ye/CB4Fm8ZYcD5HE/gXV54m38S19+En+xYa3Ic
         Zl/QHQRMN/nMfY1exWpCoTFbNn48CrFwO8g7F8cXrpSSP0/ftbjKIfuiRipnLPmNvmyd
         dLoZlhhJkKpcNrS8lzapv+M6RYK30DTlsngbUxpi0WD6MCRLAebbhZyckSwWcg5QUgGH
         c+WSB3abFrou9E1fNDLDJPYNYH0ZyQYFk9d4m50JbbIYTAP1GhBzrBV/LANm73UFVDxA
         EZiw==
X-Gm-Message-State: AOAM532T4u4De+R9Lfinjt49FgJFvpJ2TjEcpaEqZ3jhYok+fjpwkTt9
        fLuIuYMt3U77Q27Q/HXA3Dak32uZ8Zw=
X-Google-Smtp-Source: ABdhPJz5VagU1YWhl9Ga1GenyP2GpeveFDNPvSw5M/Om4BoGNm4FPdHdB/2ujosVy0VJwuvjgbt1iw==
X-Received: by 2002:a05:6000:100a:: with SMTP id a10mr7516095wrx.42.1627724164972;
        Sat, 31 Jul 2021 02:36:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3a:f500:f1df:24d3:e1a5:168a? (p200300ea8f3af500f1df24d3e1a5168a.dip0.t-ipconnect.de. [2003:ea:8f3a:f500:f1df:24d3:e1a5:168a])
        by smtp.googlemail.com with ESMTPSA id u11sm4235516wrp.26.2021.07.31.02.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 02:36:04 -0700 (PDT)
To:     Hao Chen <chenhaoa@uniontech.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210731050928.32242-1-chenhaoa@uniontech.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net,v7] net: stmmac: fix 'ethtool -P' return -EBUSY
Message-ID: <8d1b5896-da9f-954f-6d43-061b75863961@gmail.com>
Date:   Sat, 31 Jul 2021 11:35:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210731050928.32242-1-chenhaoa@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.07.2021 07:09, Hao Chen wrote:
> I want to get permanent MAC address when the card is down. And I think
"card is down" isn't precise. The interface is down, and the NIC may be
runtime-suspended.

> it is more convenient to get statistics in the down state by 'ethtool -S'.
> But current all of the ethool command return -EBUSY.
> 
> I don't think we should detect that the network card is up in '. Begin',

You don't mean detect but check here.

> which will cause that all the ethtool commands can't be used when the
> network card is down. If some ethtool commands can only be used in the
> up state, check it in the corresponding ethool OPS function is better.
> This is too rude and unreasonable.
> 
> I have checked the '.begin' implementation of other drivers, most of which
> support the submission of NIC driver for the first time.

What do you mean with "submission for the first time"?

> They are too old to know why '.begin' is implemented. I suspect that they
> have not noticed the usage of '.begin'.
> 
> Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet
> 		     controllers.")
> 

IMO it's not a bug that ethtool calls aren't supported if interface is
down. Therefore personally I'd see this for net-next. Final call is with
the maintainers.

> Compile-tested on arm64. Tested on an arm64 system with an on-board
> STMMAC chip.
> 
> Changes v6 ... v7:
> - fix arg type error of 'dev' to 'priv->device'.
> 
> Changes v5 ... v6:
> - The 4.19.90 kernel not support pm_runtime, so implemente '.begin' and
>   '.complete' again. Add return value check of pm_runtime function.
> 
> Changes v4 ... v5:
> - test the '.begin' will return -13 error on my machine based on 4.19.90
>   kernel. The platform driver does not supported pm_runtime. So remove the
>   implementation of '.begin' and '.complete'.
> 
> Changes v3 ... v4:
> - implement '.complete' ethtool OPS.
> 
> Changes v2 ... v3:
> - add linux/pm_runtime.h head file.
> 
> Changes v1 ... v2:
> - fix spell error of dev.
> 
> Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
> ---
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 21 +++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index d0ce608b81c3..fd5b68f6bf53 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -12,8 +12,9 @@
>  #include <linux/ethtool.h>
>  #include <linux/interrupt.h>
>  #include <linux/mii.h>
> -#include <linux/phylink.h>

Why moving the phylink include?

>  #include <linux/net_tstamp.h>
> +#include <linux/phylink.h>
> +#include <linux/pm_runtime.h>
>  #include <asm/io.h>
>  
>  #include "stmmac.h"
> @@ -410,11 +411,18 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
>  
>  }
>  
> -static int stmmac_check_if_running(struct net_device *dev)
> +static int stmmac_ethtool_begin(struct net_device *dev)
>  {
> -	if (!netif_running(dev))
> -		return -EBUSY;
> -	return 0;
> +	struct stmmac_priv *priv = netdev_priv(dev);

Power-managed is the parent of the net_device.
So you could simply use dev->dev.parent.

> +
> +	return pm_runtime_resume_and_get(priv->device);
> +}
> +
> +static void stmmac_ethtool_complete(struct net_device *dev)
> +{
> +	struct stmmac_priv *priv = netdev_priv(dev);
> +
> +	pm_runtime_put(priv->device);
>  }
>  
>  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
> @@ -1073,7 +1081,8 @@ static int stmmac_set_tunable(struct net_device *dev,
>  static const struct ethtool_ops stmmac_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES,
> -	.begin = stmmac_check_if_running,
> +	.begin = stmmac_ethtool_begin,
> +	.complete = stmmac_ethtool_complete,
>  	.get_drvinfo = stmmac_ethtool_getdrvinfo,
>  	.get_msglevel = stmmac_ethtool_getmsglevel,
>  	.set_msglevel = stmmac_ethtool_setmsglevel,
> 

You sent this patch to the mailing list only and missed to address the
maintainers.

I think the question whether an ethtool call should wake a network device
from runtime suspend is a general one (at least for all network drivers
with runtime pm support) and not restricted to stmmac. 
Strictly needed is waking the device only if e.g. a chip register is
accessed that isn't available during runtime-suspend. However personally
I'd be fine with the small overhead of always waking the device.

If there's an agreement that this makes sense in general then we may add
this to core code, by e.g. runtime-resuming netdev->dev.parent (and maybe
netdev->dev if netdev has no parent).
