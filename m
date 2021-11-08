Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27C6449D06
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhKHUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhKHUXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:23:46 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CD0C061570;
        Mon,  8 Nov 2021 12:21:01 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b15so48054286edd.7;
        Mon, 08 Nov 2021 12:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2raeEYO2y3XQ2jU6ONRcEG9/m1+1okRMvrXzlni4CBM=;
        b=PFiiLBTeJAM5tzGqDOx2BolQP3/sCxnVWi+Cs7M+XZmDOQUDtyPXPER3KEBisDiVni
         sI9fb1kVS+Z9go6sEpKM4CaZW23sjPnGiP72oYbpid8rcphUtUkwGrm2XaBcX33KBxs8
         dEV6Pu4HV9k6GU2WS1jeVwBoiXsSgQCrBQCt7AbogQ9esbZ14Gfoav2rZRXjshr76Hl3
         wFsdTQq0B2OVfzoyoiTAs558EgzAUOGb8tT+GxIWgXipkWQ6MBlRbXlL9vNv30YeO1da
         MObNKWO5ySP3uZsPraPnG8gH2ixFi4OiiuqkvculV1+hIIZ+Exzzz2bQ2ZdmWzzR2rH9
         rUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2raeEYO2y3XQ2jU6ONRcEG9/m1+1okRMvrXzlni4CBM=;
        b=WZan65RqGWpeot7xXomRKFTxSkOs9OSvwH+CmS+bgZjNqGB/bFqOp1oajOoJtA2mDx
         eK8+BPM/3DabM3gNy8XMg8PHnW1L38lMNwWx+Fw2PKg30kBGVb5HBea1QjBm/jPdVa5R
         02olbGJDP8ZCvs7PVKfUDLiPNdW6cYxHZWim6RcF9xr2zIOLrU/3RTCi/y5zqJoycfD3
         GcQi0QX07YDrg05d9CbSGgH3IrEJLWX7CgSoM+TzNyaaDWTYQGViPx3T6DuS18vm+82D
         +OQB0aKXFvpekUqWilP2xGJL2eIu4STn5XEX22nNdMBnUCiJqc/0EgnLwY5lDGGT1bqO
         L7rQ==
X-Gm-Message-State: AOAM533U9aj9165XRvp97Ku7csli7hvPlMoW9nhKaCjmF0wW/hQDKFoE
        YBzk3+BK7tqWa67G07Wncyk=
X-Google-Smtp-Source: ABdhPJy/Wd8W58Kb+ZMxuMK6nyyTduCVyQBDIqdzrCERNa96q1jawIKbRCfMDLPkR9BucC0srlweLQ==
X-Received: by 2002:a05:6402:2756:: with SMTP id z22mr2459289edd.88.1636402860225;
        Mon, 08 Nov 2021 12:21:00 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id h17sm11278345ede.38.2021.11.08.12.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:20:59 -0800 (PST)
Date:   Mon, 8 Nov 2021 22:20:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gabor Juhos <j4g8y7@gmail.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
Message-ID: <20211108202058.th7vjq4sjca3encz@skbuf>
References: <20211104124927.364683-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104124927.364683-1-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Timed out waiting for ACK/NACK from John.

On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> From: Gabor Juhos <j4g8y7@gmail.com>
> 
> The MIB module needs to be enabled in the MODULE_EN register in
> order to make it to counting. This is done in the qca8k_mib_init()
> function. However instead of only changing the MIB module enable
> bit, the function writes the whole register. As a side effect other
> internal modules gets disabled.

Please be more specific.
The MODULE_EN register contains these other bits:
BIT(0): MIB_EN
BIT(1): ACL_EN (ACL module enable)
BIT(2): L3_EN (Layer 3 offload enable)
BIT(10): SPECIAL_DIP_EN (Enable special DIP (224.0.0.x or ff02::1) broadcast
0 = Use multicast DP
1 = Use broadcast DP)

> 
> Fix up the code to only change the MIB module specific bit.

Clearing which one of the above bits bothers you? The driver for the
qca8k switch supports neither layer 3 offloading nor ACLs, and I don't
really know what this special DIP packet/header is).

Generally the assumption for OF-based drivers is that one should not
rely on any configuration done by prior boot stages, so please explain
what should have worked but doesn't.

> 
> Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  drivers/net/dsa/qca8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a984f06f6f04..a229776924f8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -583,7 +583,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
>  	if (ret)
>  		goto exit;
>  
> -	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> +	ret = qca8k_reg_set(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
>  
>  exit:
>  	mutex_unlock(&priv->reg_mutex);
> -- 
> 2.33.1
> 
