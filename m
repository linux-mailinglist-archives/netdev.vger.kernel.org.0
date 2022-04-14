Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B47501363
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344634AbiDNOZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346981AbiDNN6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:58:10 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18C4B3DD9;
        Thu, 14 Apr 2022 06:48:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z12so6456493edl.2;
        Thu, 14 Apr 2022 06:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gP0+DXghKcf2qXvcW1JZOCtSqa2MqphfThUN2zjo/Q4=;
        b=HYvpG8UzdAG6LoGZ9qjTgDXsg31DQ7UqcdZiUgRNKT7bAo3UgCHYYkGtZB43Xic69N
         PAav5JmoT8bzlA5yxVn2ZoQW6A93kIbkMcNikdIWaaUp1+2w4BuyLCtDM2z+kYRC8YZd
         7F0DghZn4eUEQYRPG4WrgyqKdVXYTQOBwp1futUrCevJPQEy6wqjloPJlWBxIrkh+y2s
         1yqEM+GlfrfDUyID6a7K7EKY7bYJ+5wuTTDZBVl6U/Eyzqy1wulwmitWkaTJDlPWhDG5
         z0y0vn6Te0PXE74LCTi49vCMsbbO8KVIlfIkr1UhWJn9QR45GJmxQm7JuAdr7nvqx/bY
         z2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gP0+DXghKcf2qXvcW1JZOCtSqa2MqphfThUN2zjo/Q4=;
        b=1pWYAS6bxh1SXjtVEDtY83FyfYJHTnjVrFvXUxajT3fpfuxjduTjiV70oYTUY4gzfV
         jCtxTlLkGbeimf9hzTdqsJYDjgE7XE36Xr5e/rxA6aA+zFqzWzBdKZ/VmhCNKpjjKlfv
         0S0OAnCwTqXQX6g28kY14Z40ANIpFmm2nzsmATfpzpia5IDs75W/l8ORjE5pY+BfME9C
         uVzctb/uE4LbRrFasyGGru0De4mDHrhfY1JymYsbeAI0pFQTDfEMLQj4C5pMXLy6SEiO
         nrQZA+jCNBi9vCylv7bfboiaD4PSA1I8VhM5zp4atGuPqQi7nyXRwNt5y0JIpVp6CJVL
         qLnA==
X-Gm-Message-State: AOAM533LLEn6+Yhdu2OBeVa51qcG3QyXGOGhpHJ8LUZOtgzrvL3WWQ44
        hpYjMKgL7L/ovb4zM1Cl+pk=
X-Google-Smtp-Source: ABdhPJxeXqlrsaTsutnOIVvQkRr7u2i4EUXnV8AW+2cmGmjtpodIFs3uxdOpS1pGJNgEBYYbUo4ZNw==
X-Received: by 2002:aa7:c40b:0:b0:41d:9886:90a0 with SMTP id j11-20020aa7c40b000000b0041d988690a0mr3003328edq.275.1649944100273;
        Thu, 14 Apr 2022 06:48:20 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id e35-20020a056402332300b004209638cb94sm1013954eda.6.2022.04.14.06.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 06:48:19 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:48:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 1/4] drivers: net: dsa: qca8k: drop MTU
 tracking from qca8k_priv
Message-ID: <20220414134818.xesotjnlbhe4ewvc@skbuf>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173019.4189-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 07:30:16PM +0200, Ansuel Smith wrote:
> DSA set the CPU port based on the largest MTU of all the slave ports.
> Based on this we can drop the MTU array from qca8k_priv and set the
> port_change_mtu logic on DSA changing MTU of the CPU port as the switch
> have a global MTU settingfor each port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 25 ++++++++-----------------
>  drivers/net/dsa/qca8k.h |  1 -
>  2 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d3ed0a7f8077..820eeab19873 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2367,16 +2367,17 @@ static int
>  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> -	int i, mtu = 0;
>  
> -	priv->port_mtu[port] = new_mtu;
> -
> -	for (i = 0; i < QCA8K_NUM_PORTS; i++)
> -		if (priv->port_mtu[i] > mtu)
> -			mtu = priv->port_mtu[i];
> +	/* We have only have a general MTU setting.
> +	 * DSA always set the CPU port's MTU to the largest MTU of the salve ports.

s/salve/slave/

Also watch for the 80 characters limit.

> +	 * Setting MTU just for the CPU port is sufficient to correctly set a
> +	 * value for every port.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))
> +		return 0;
>  
>  	/* Include L2 header / FCS length */
> -	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> +	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
>  }
>  
>  static int
> @@ -3033,16 +3034,6 @@ qca8k_setup(struct dsa_switch *ds)
>  				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
>  				  mask);
>  		}
> -
> -		/* Set initial MTU for every port.
> -		 * We have only have a general MTU setting. So track
> -		 * every port and set the max across all port.
> -		 * Set per port MTU to 1500 as the MTU change function
> -		 * will add the overhead and if its set to 1518 then it
> -		 * will apply the overhead again and we will end up with
> -		 * MTU of 1536 instead of 1518
> -		 */
> -		priv->port_mtu[i] = ETH_DATA_LEN;
>  	}
>  
>  	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index f375627174c8..562d75997e55 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -398,7 +398,6 @@ struct qca8k_priv {
>  	struct device *dev;
>  	struct dsa_switch_ops ops;
>  	struct gpio_desc *reset_gpio;
> -	unsigned int port_mtu[QCA8K_NUM_PORTS];
>  	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
>  	struct qca8k_mgmt_eth_data mgmt_eth_data;
>  	struct qca8k_mib_eth_data mib_eth_data;
> -- 
> 2.34.1
> 

