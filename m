Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05E63DE68B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhHCGFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhHCGFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 02:05:04 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A1CC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 23:04:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so1318654wmb.5
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 23:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sGm3FCVZkYJ9MEmhcrZ/TndsqyhIb5Ljt8KmESDsujQ=;
        b=bZM95XK2jLYPXLU6wjEoHET28N1wprMm8NtA6sb6nvEoXX0SMnkmG55GDUTZybKEOm
         O399XbkOrJnaYJxD00Fw5AxKF3HriqB7++OY90pFEeX0twECbG9PEZyzNN0nvbXS76cP
         xTYtQ/2rJ4M6lVsTo0eg+u4wAo1HRejDs4Ih0KZgqthLBXyo6XbYf/639lz/iIOV5MZy
         uWYd/zQ6KfY7NsG7n899aOdDPUgkj/HVeZvGwTq2Iamnv+I0Y519ZKFKnmre1vYAuc7v
         uCxeZQGyNbxITDJrGG0DJL4K9k912cCruLtWwQvphmMXs4oPszeFi33IQ3ddA0ChiiRo
         H+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sGm3FCVZkYJ9MEmhcrZ/TndsqyhIb5Ljt8KmESDsujQ=;
        b=lC+W90cn2pMwG1QGZNrbiYUt5/StXNVgB9JT9BBiQtkGlreSuLtWetO8ndqKJP4YFZ
         Dgu6EdYzincamMUTCp4uHB7pZ8Q86/khumWE3Ck/4e93FKrTxURIMXmTF6vDnvubXkfm
         zu3PB/yTmpqrgHUJwSL8pksrEP4f1NSETiwoe9t/jmQOHs3ek6p/UTJaocF+NUzLwURX
         f4elxV/3sBQ2C9wjbPdh4ltmqb6GZY5lfedxODXNQ1w8NpgYENOiFaidG334y1s1Qsg9
         MvD+g2eUNnhjN6NvW6LdRkVPM8yS4cldsUqGo/htX8JwmLB515I/2ly0z4SILWw0LT5a
         zsAg==
X-Gm-Message-State: AOAM5331rPsvb0kzNgQ/eYJ+avDLtThsL56qgmmErvW+rlAs9ABCsnxR
        Xc722TpHftsC54tVY6vbing=
X-Google-Smtp-Source: ABdhPJzX65vECvqEoAgztraIvDRYKNKxWLEZ8uOCmGrRKil2roXA/O6WgjzXukrgIrKaJBsiAdV/iw==
X-Received: by 2002:a1c:cc1a:: with SMTP id h26mr19913285wmb.47.1627970691465;
        Mon, 02 Aug 2021 23:04:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:b920:c35d:cc1c:fa5c? (p200300ea8f10c200b920c35dcc1cfa5c.dip0.t-ipconnect.de. [2003:ea:8f10:c200:b920:c35d:cc1c:fa5c])
        by smtp.googlemail.com with ESMTPSA id w13sm15813745wru.72.2021.08.02.23.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 23:04:51 -0700 (PDT)
To:     Hao Chen <chenhaoa@uniontech.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20210803023836.6244-1-chenhaoa@uniontech.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next,v8] net: stmmac: optimize check in ops '.begin'
Message-ID: <b21d425e-d2ec-aa39-16ea-838b638e250e@gmail.com>
Date:   Tue, 3 Aug 2021 08:04:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803023836.6244-1-chenhaoa@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.2021 04:38, Hao Chen wrote:
> I want to get permanent MAC address when the interface is down. And I think
> it is more convenient to get statistics in the down state by 'ethtool -S'.
> But current all of the ethool command return -EBUSY.
> 
> I don't think we should check that the network interface is up in '.begin',
> which will cause that all the ethtool commands can't be used when the
> network interface is down. If some ethtool commands can only be used in the
> up state, check it in the corresponding ethool OPS function is better.
> This is too rude and unreasonable.
> 
> Compile-tested on arm64. Tested on an arm64 system with an on-board
> STMMAC chip.
> 

I doubt it's compile-tested, at least not with rpm enabled.
See comment below.

> Changes v7 ... v8:
> - Optimize commit description information, optimization parameters of
>   pm_runtime function.
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
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c    | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index d0ce608b81c3..8e2ae0ff7f8f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -12,8 +12,9 @@
>  #include <linux/ethtool.h>
>  #include <linux/interrupt.h>
>  #include <linux/mii.h>
> -#include <linux/phylink.h>
>  #include <linux/net_tstamp.h>
> +#include <linux/phylink.h>
> +#include <linux/pm_runtime.h>
>  #include <asm/io.h>
>  
>  #include "stmmac.h"
> @@ -410,11 +411,14 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
>  
>  }
>  
> -static int stmmac_check_if_running(struct net_device *dev)
> +static int stmmac_ethtool_begin(struct net_device *dev)
>  {
> -	if (!netif_running(dev))
> -		return -EBUSY;
> -	return 0;
> +	return pm_runtime_resume_and_get(dev->dev);

This is wrong in two ways:
- There is a type mismatch and the code won't compile.
- I talked about the netdev parent.

> +}
> +
> +static void stmmac_ethtool_complete(struct net_device *dev)
> +{
> +	pm_runtime_put(dev->dev);
>  }
>  
>  static int stmmac_ethtool_get_regs_len(struct net_device *dev)
> @@ -1073,7 +1077,8 @@ static int stmmac_set_tunable(struct net_device *dev,
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

Again you missed to send the patch to the maintainers.
Read the basics about how to submit a patch.

Last but not least please wait for feedback on
https://lore.kernel.org/netdev/106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com/
