Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D79C4585E4
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhKUSVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhKUSVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:21:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857EC061574;
        Sun, 21 Nov 2021 10:18:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y13so66556578edd.13;
        Sun, 21 Nov 2021 10:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bGbNyAX2Fs5vsP5QJCSxUMBTfLwlHWYGJQMhvmMF4aw=;
        b=Pm7tgy2MCbtREcj4EGIVSQN2EBkOZGJUAgaPh9bpo5Lln4FfVOOryZm2psxiXQ2+e8
         aPxqkuXmX8Z/jutCEjRZTy194H6qpfK2Z3Nzj75FKIu+hNY9qPMf4eigjFsPWe2vQN21
         bJTStPXxKD0Llf0NdMMtoeuja9Uf2OEfH6sCPd7x/OjzsyDlEimZhhCnPclmtPxmOERl
         iYPCQr2HuFBB3gGY4kwvynCzbLPVftDyZkhz4CYCQsyx0cR2snChYLJFQfRzCNAPqYzH
         rRwq03vTPbLY5AUE7DWVfcQkbTcI6NkxtFX+S7PueiQfYbvXfOaSLmWmHuizLMn4YfAl
         bvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bGbNyAX2Fs5vsP5QJCSxUMBTfLwlHWYGJQMhvmMF4aw=;
        b=AXjq4TeLuqQS+v0qcCwjExk7JcHU7wtfmNeM+4BRbJflMIfWt5uJpG2hJyT2LZPcrm
         wJURHOW6Dq+fZXTvGp7Lg5pi9dGx6aLprc08rQGXceb5Xf5PW3cLi/4K6Td2uAV5zm5s
         PkoQ8YHAghT+HD2rY6m2zIlHTkwAJ4dFofSecKdToZd7CRu1nKmG0YvZod15UQxO5/zH
         x4n3r3pPHVm7WrP4IGlDNgLImrMSTp1pTii0J6dxvOzgd4z1wNPrvOMrAgbiwl9XruYl
         y3ZMFejb4wrlbxaBwp/3H/knFaK1O+Udtr8T6UB58Ur3c8EP3wp2eu+vH+NRMt1Egba1
         zhsg==
X-Gm-Message-State: AOAM530YrI5ME2PMBYOg3qkI1Hl7Gmv8oRUsR8wHj2vlNrrwjLjHHg/c
        0ns6ioA3aSvYIbUIE4gwPFg=
X-Google-Smtp-Source: ABdhPJxmMJx8FlD6ja9OjvnBYOuW6VxRno7SIqIMENaPOjWShD41OD6RErzJ4azbrRmxM/3A8PUV4A==
X-Received: by 2002:a05:6402:5156:: with SMTP id n22mr55277086edd.222.1637518711539;
        Sun, 21 Nov 2021 10:18:31 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id jy28sm2618199ejc.118.2021.11.21.10.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:18:31 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:18:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix internal delay applied to
 the wrong PAD config
Message-ID: <20211121181829.qymovkzzhxj2fn3v@skbuf>
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020350.32324-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:03:49AM +0100, Ansuel Smith wrote:
> With SGMII phy the internal delay is always applied to the PAD0 config.
> This is caused by the falling edge configuration that hardcode the reg
> to PAD0 (as the falling edge bits are present only in PAD0 reg)
> Move the delay configuration before the reg overwrite to correctly apply
> the delay.
> 
> Fixes: cef08115846e ("net: dsa: qca8k: set internal delay also for sgmii")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

This removes the need for your other patch "net: dsa: qca8k: skip sgmii
delay on double cpu conf", right?

>  drivers/net/dsa/qca8k.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a429c9750add..d7bcecbc1c53 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1433,6 +1433,12 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  
>  		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
>  
> +		/* From original code is reported port instability as SGMII also
> +		 * require delay set. Apply advised values here or take them from DT.
> +		 */
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
> +
>  		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
>  		 * falling edge is set writing in the PORT0 PAD reg
>  		 */
> @@ -1455,12 +1461,6 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
>  					val);
>  
> -		/* From original code is reported port instability as SGMII also
> -		 * require delay set. Apply advised values here or take them from DT.
> -		 */
> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> -			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
> -
>  		break;
>  	default:
>  		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> -- 
> 2.32.0
> 
