Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218CB5222D5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348301AbiEJRfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348292AbiEJRfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:35:46 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5B750053
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t5so20826919edw.11
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SLAhVnwZeOP9o679dQJ0GVTFv7sooYwOPqZ38R1HX/A=;
        b=okaY65v+hVudWS3NSw9GvjwjLJrIKk4QvdEM/vgQ5pUSZw5aYXdagdksb2vK50RB0w
         0z8jAjbcEaMHyUi+MYpH8RfMri6djEQCHQDl+rTZ9Sq5XqLp/O+++qEoOA0nwxAmxcDK
         pw8HSCwE8D7iBSzzwjgBY/ZRwNoCxaZCF7AG9KexxDcftZ8SC8itANgpWwp31MtMPnlG
         /CwLv/6tVgn2m2630+uWfCWbWrGUdO/bCvc5yVgN6Pmo9YS0GNYQofnfPE9El3yCUzGR
         gh9EbPeMbyhp9WRBcsrpeZCKjXoM6x38aubXVGq7waQExgEgjMLxD5K+9lkcVqnYq7JH
         PKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SLAhVnwZeOP9o679dQJ0GVTFv7sooYwOPqZ38R1HX/A=;
        b=Kc2VgQJ/uW8qdPPQER0zzQdX3SbUGlK38cvFL/ScjDsySgZbjmb66Mer5vs/OjbZB6
         QMyfHZSjkBNWznlpg2gyQu8KUbcBLHlcIQ/HZx8XTSir246GfOgTTZEcjx8Is+yHkNSJ
         PNzPJqV62vOhz/z7G69I+rT0Q67A0L3EkzEeRk+qYbp5kDZDrPQLOwDZ53aoN+cr6p6Q
         sBwDn9QvqsX+gTvlsiWAtpZaqggo2Z9zyidlifdP0GPYLIw+zHxfJLdjronK0P6M1Gd1
         mz+zsSxV47pRltDRTpCiNbaPgOhJBYD3bJzA7ZCQh8J19w5jQN0ggfAqPCPRrtemNccL
         Dq9g==
X-Gm-Message-State: AOAM532YfyxEpAi1My1YNukOEPeCEKjUpjQYdNRxmRZrOjwDH9q6ueha
        5FrUjeoPWFTHpwYoBBAcPcI=
X-Google-Smtp-Source: ABdhPJw7IebnTvNn+7pK0Gs7qXn39DAwdB7zILw1ga575Ygy0IEQ70Yzfq56NktMXfLfT7/S+8sarA==
X-Received: by 2002:a05:6402:11c7:b0:428:5fdc:80c5 with SMTP id j7-20020a05640211c700b004285fdc80c5mr23349819edw.332.1652203902930;
        Tue, 10 May 2022 10:31:42 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id qs24-20020a170906459800b006f3ef214e66sm6278818ejc.204.2022.05.10.10.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 10:31:42 -0700 (PDT)
Date:   Tue, 10 May 2022 20:31:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
Message-ID: <20220510173140.mvtqdxr4wuwxxqrt@skbuf>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-4-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508224848.2384723-4-hauke@hauke-m.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 12:48:47AM +0200, Hauke Mehrtens wrote:
> The switch does not support per port MTU setting, but only a MRU
> setting. Implement this by setting the MTU on the CPU port.

Could you also please set ds->mtu_enforcement_ingress, for no other
reason than to have the dev->mtu of all other bridge ports automatically
updated when the user changes one of them?

> 
> Without this patch the MRU was always set to 1536, not it is set by the
> DSA subsystem and the user scan change it.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index be64cfdeccc7..f9b690251155 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -1132,6 +1132,38 @@ static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int port,
>  	return regmap_write(priv->map, RTL8365MB_PORT_ISOLATION_REG(port), mask);
>  }
>  
> +static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
> +				     int new_mtu)
> +{
> +	struct dsa_port *dp = dsa_to_port(ds, port);
> +	struct realtek_priv *priv = ds->priv;
> +	int length;
> +
> +	/* When a new MTU is set, DSA always set the CPU port's MTU to the
> +	 * largest MTU of the slave ports. Because the switch only has a global
> +	 * RX length register, only allowing CPU port here is enough.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))

das_port_is_cpu(dp)

> +		return 0;
> +
> +	length = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> +	length += dp->tag_ops->needed_headroom;
> +	length += dp->tag_ops->needed_tailroom;
> +
> +	if (length > RTL8365MB_CFG0_MAX_LEN_MASK)
> +		return -EINVAL;
> +
> +	return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> +				  RTL8365MB_CFG0_MAX_LEN_MASK,
> +				  FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
> +					     length));
> +}
> +
> +static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return RTL8365MB_CFG0_MAX_LEN_MASK - ETH_HLEN - ETH_FCS_LEN - 8;
> +}
> +
>  static int rtl8365mb_mib_counter_read(struct realtek_priv *priv, int port,
>  				      u32 offset, u32 length, u64 *mibvalue)
>  {
> @@ -1928,13 +1960,6 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		p->index = i;
>  	}
>  
> -	/* Set maximum packet length to 1536 bytes */
> -	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
> -				 RTL8365MB_CFG0_MAX_LEN_MASK,
> -				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
> -	if (ret)
> -		goto out_teardown_irq;
> -
>  	if (priv->setup_interface) {
>  		ret = priv->setup_interface(ds);
>  		if (ret) {
> @@ -2080,6 +2105,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>  	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
>  	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
>  	.port_stp_state_set = rtl8365mb_port_stp_state_set,
> +	.port_change_mtu = rtl8365mb_port_change_mtu,
> +	.port_max_mtu = rtl8365mb_port_max_mtu,
>  	.get_strings = rtl8365mb_get_strings,
>  	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
>  	.get_sset_count = rtl8365mb_get_sset_count,
> @@ -2101,6 +2128,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
>  	.phy_read = rtl8365mb_dsa_phy_read,
>  	.phy_write = rtl8365mb_dsa_phy_write,
>  	.port_stp_state_set = rtl8365mb_port_stp_state_set,
> +	.port_change_mtu = rtl8365mb_port_change_mtu,
> +	.port_max_mtu = rtl8365mb_port_max_mtu,
>  	.get_strings = rtl8365mb_get_strings,
>  	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
>  	.get_sset_count = rtl8365mb_get_sset_count,
> -- 
> 2.30.2
> 

