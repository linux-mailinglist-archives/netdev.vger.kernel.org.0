Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C644E3DE3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiCVL7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiCVL7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:59:43 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A005A2615;
        Tue, 22 Mar 2022 04:58:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id yy13so35686877ejb.2;
        Tue, 22 Mar 2022 04:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3iZV15ZtVYOUmV8EiLudZttlT0NsfmQmzWRM1AYdhO4=;
        b=F26Qju0rPRAL3uHEr5yZFSZAIU7iJmzXRa6OaU3ZOOVo+p318GXHvEnPS1QJgaLsiv
         ydB7AZSguagbKQa0Iy7zL7+GCyXcHgf6i3i2QVM5cXc6uOawQtoh7q0tp41z1nMj97rO
         3+vIJtT2VxpMLFwhAyy5Tjocxcxtbph43XVvmCi9ln643Sn4+ducIcVAkI6WsUgKevHk
         U1uamnTlMttO2Y6YwA8m6vNHVFLl2GAu6udrqMDqRTeSM2+8O9rlUw6ESsgPZfvCufvG
         Bhj8AqEyLAEbogSRAyP6euHC8YVtXOaCTJxGewWo0ZXZIILElnP34z1nlnrb5CNT1MEF
         q2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3iZV15ZtVYOUmV8EiLudZttlT0NsfmQmzWRM1AYdhO4=;
        b=qld9obB2SQyr+HwMsVmmX8pgqsE2puckM6BWEq8pdZWUesa+KVD1cdvEzbx+Jyjine
         doTKHxUu9zjmoDRfJHe0Jnj772K4hIFdd2VEY9o746cX8k57Q2zqGnGAuZv09T/RHB6U
         UKOLSufUx8DEBn4DdFuDhL4MA4LHwphKch7v2IofvDmmZ7vlu/Meu3Zzw56NdrwSIn7I
         f69HaVuO/oY4S+bdhGia+jK3woUHeykIXQQIu/QOh1Y3/d+m26/fR/p3JwMaFDkm5NfK
         aWnLgRoXbQyZvU5We/NMhm4zAvvu+1dQ0hgkyGCbo6pnEciSyVvhFPEXz6CTSWV/1g5N
         jnNg==
X-Gm-Message-State: AOAM531rLgvvIgCwJoKwNoo327ePSFfjkV3OrszNs+HLoeu99iUVbthJ
        C18HkVpUFgDlqmLp96JRvxM=
X-Google-Smtp-Source: ABdhPJxaiBKfmey1QVLLfKFJzt1ON7lVxPQNGNL0VdxWSQC79PoJCAS5iz+KxowKmNlUCsGHAAG5jg==
X-Received: by 2002:a17:906:c107:b0:6df:c114:e286 with SMTP id do7-20020a170906c10700b006dfc114e286mr17908187ejc.216.1647950294112;
        Tue, 22 Mar 2022 04:58:14 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id a1-20020a1709063e8100b006ce06ed8aa7sm8327040ejj.142.2022.03.22.04.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:58:13 -0700 (PDT)
Date:   Tue, 22 Mar 2022 13:58:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <20220322115812.mwue2iu2xxrmknxg@skbuf>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322014506.27872-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> Drop the MTU array from qca8k_priv and use slave net dev to get the max
> MTU across all user port. CPU port can be skipped as DSA already make
> sure CPU port are set to the max MTU across all ports.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

I hardly find this to be an improvement and I would rather not see such
unjustified complexity in a device driver. What are the concrete
benefits, size wise?

>  drivers/net/dsa/qca8k.c | 38 +++++++++++++++++++++++---------------
>  drivers/net/dsa/qca8k.h |  1 -
>  2 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d3ed0a7f8077..4366d87b4bbd 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2367,13 +2367,31 @@ static int
>  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> -	int i, mtu = 0;
> +	struct dsa_port *dp;
> +	int mtu = new_mtu;
>  
> -	priv->port_mtu[port] = new_mtu;
> +	/* We have only have a general MTU setting. So check
> +	 * every port and set the max across all port.
> +	 */
> +	list_for_each_entry(dp, &ds->dst->ports, list) {
> +		/* We can ignore cpu port, DSA will itself chose
> +		 * the max MTU across all port
> +		 */
> +		if (!dsa_port_is_user(dp))
> +			continue;
>  
> -	for (i = 0; i < QCA8K_NUM_PORTS; i++)
> -		if (priv->port_mtu[i] > mtu)
> -			mtu = priv->port_mtu[i];
> +		if (dp->index == port)
> +			continue;
> +
> +		/* Address init phase where not every port have
> +		 * a slave device
> +		 */
> +		if (!dp->slave)
> +			continue;
> +
> +		if (mtu < dp->slave->mtu)
> +			mtu = dp->slave->mtu;
> +	}
>  
>  	/* Include L2 header / FCS length */
>  	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> @@ -3033,16 +3051,6 @@ qca8k_setup(struct dsa_switch *ds)
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

