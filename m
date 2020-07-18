Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AC3224D76
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGRSLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 14:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgGRSLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 14:11:16 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EACCC0619D2;
        Sat, 18 Jul 2020 11:11:16 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so14116458ejb.11;
        Sat, 18 Jul 2020 11:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tpHrxWqPF0UL4BRyQ71Nj1/vDZjMYFN/gx5rmBWKOOU=;
        b=GHeljTHpkUNs7FAYjqc+/M7fI6TY7+tNbbA3zQ4W2LdFdCGT2B87fm2s7LZ+Ha31+Q
         cfduLxCr+zpcqIxzfEMLtINZGvOjwaPgx+EMXuouALUHrjS4sWRwt5gCRxLqG1wGv8Cd
         2zKN75mXNyEvVQnOsJdspa2ezKcGvCmE9LJi/V3wKEUoekHoTtI0oYiUvcz9rojn368a
         yWDzQw/RyJS4GscwL51up44jFBQt6vrNRzA2McffG0m7d3dZduheXq/2jWDB20ZahGe/
         j8Ti9o5OmZOPehJLfD33tSUrHo0bDdLwMtaXDTEdGvp9sFCtbsTjJ2AmHWVb2tzEjQ7E
         4DWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tpHrxWqPF0UL4BRyQ71Nj1/vDZjMYFN/gx5rmBWKOOU=;
        b=mtOyMEORucsMTXl6gS2d2ryL5c1qtokFEsFB3msf7vMWtVeW7+6h4OfqDcDMhlmkXj
         ExE5usCFsxcPIS6kfUOJx1jbALkIaKsY/cqij4KvDEGQxI5Ucwn0BDaQ7F4F01r5QSia
         20nsRR3BcdzK6XhT7k0GObL9g989rQh8hv+68yHIADOeNbwqxno8YlgoByIb1s5Gvd6K
         sRFn8U3Hp2jRer4hTxsMo0aU256BOsvnnHyP3G0qVRX/1orNlAoTGMHiFIymdz+fXhso
         CHyG7saOKFa9aYpl5XRMisednfD2GYcTBMmzYILR1fpN/fZ4ZofkhrfRSpHX++DtvljM
         RXfQ==
X-Gm-Message-State: AOAM533AqXCtKhPELkuPZVdJtgOqJ1hBwCQiEJ9zKvlcvUqB98IildqT
        lF5JEaK38CseV+T76Ozavic=
X-Google-Smtp-Source: ABdhPJxrCna1NBVOns1jb5GKvG6zVPde2yLMTjJzyVzZZZjUl7h8QTlxIfbVrZygpfK225TtEsLR6w==
X-Received: by 2002:a17:906:ccd3:: with SMTP id ot19mr14834472ejb.468.1595095874780;
        Sat, 18 Jul 2020 11:11:14 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id s1sm11637091edy.1.2020.07.18.11.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 11:11:14 -0700 (PDT)
Date:   Sat, 18 Jul 2020 21:11:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: qca8k: implement the port MTU callbacks
Message-ID: <20200718181112.ygtcllbb7nyvmjeh@skbuf>
References: <20200718093555.GA12912@earth.li>
 <20200718163214.GA2634@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718163214.GA2634@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 05:32:14PM +0100, Jonathan McDowell wrote:
> This switch has a single max frame size configuration register, so we
> track the requested MTU for each port and apply the largest.
> 
> v2:
> - Address review feedback from Vladimir Oltean
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---

I think there's still an open question on whether the slave_dev->mtu of
all other ports should be updated to reflect the new, potentially larger
value. But we could always update drivers after the fact, if that ever
becomes required.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 31 +++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  3 +++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 4acad5fa0c84..a5566de82853 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -670,6 +670,11 @@ qca8k_setup(struct dsa_switch *ds)
>  		}
>  	}
>  
> +	/* Setup our port MTUs to match power on defaults */
> +	for (i = 0; i < QCA8K_NUM_PORTS; i++)
> +		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
> +	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
> +
>  	/* Flush the FDB table */
>  	qca8k_fdb_flush(priv);
>  
> @@ -1098,6 +1103,30 @@ qca8k_port_disable(struct dsa_switch *ds, int port)
>  	priv->port_sts[port].enabled = 0;
>  }
>  
> +static int
> +qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	int i, mtu = 0;
> +
> +	priv->port_mtu[port] = new_mtu;
> +
> +	for (i = 0; i < QCA8K_NUM_PORTS; i++)
> +		if (priv->port_mtu[port] > mtu)
> +			mtu = priv->port_mtu[port];
> +
> +	/* Include L2 header / FCS length */
> +	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return QCA8K_MAX_MTU;
> +}
> +
>  static int
>  qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
>  		      u16 port_mask, u16 vid)
> @@ -1174,6 +1203,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.set_mac_eee		= qca8k_set_mac_eee,
>  	.port_enable		= qca8k_port_enable,
>  	.port_disable		= qca8k_port_disable,
> +	.port_change_mtu	= qca8k_port_change_mtu,
> +	.port_max_mtu		= qca8k_port_max_mtu,
>  	.port_stp_state_set	= qca8k_port_stp_state_set,
>  	.port_bridge_join	= qca8k_port_bridge_join,
>  	.port_bridge_leave	= qca8k_port_bridge_leave,
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 10ef2bca2cde..31439396401c 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -13,6 +13,7 @@
>  #include <linux/gpio.h>
>  
>  #define QCA8K_NUM_PORTS					7
> +#define QCA8K_MAX_MTU					9000
>  
>  #define PHY_ID_QCA8337					0x004dd036
>  #define QCA8K_ID_QCA8337				0x13
> @@ -58,6 +59,7 @@
>  #define   QCA8K_MDIO_MASTER_MAX_REG			32
>  #define QCA8K_GOL_MAC_ADDR0				0x60
>  #define QCA8K_GOL_MAC_ADDR1				0x64
> +#define QCA8K_MAX_FRAME_SIZE				0x78
>  #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
>  #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
>  #define   QCA8K_PORT_STATUS_SPEED_10			0
> @@ -189,6 +191,7 @@ struct qca8k_priv {
>  	struct device *dev;
>  	struct dsa_switch_ops ops;
>  	struct gpio_desc *reset_gpio;
> +	unsigned int port_mtu[QCA8K_NUM_PORTS];
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.27.0
> 
