Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D798456792
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhKSBvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhKSBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:51:04 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E842BC061574;
        Thu, 18 Nov 2021 17:48:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so35648221edb.8;
        Thu, 18 Nov 2021 17:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8SD8ZPeU6EGNuQiAtlRMrvwd5OdoCyHLtTvCII9wdpA=;
        b=eqm7Sezmt9c/ah7wqcTKEDJKgrx4pBDWy5uhpTbV7PPRAASEtZ7yOT+FhrKVs157iP
         g/qMzHXNWFBWbbrsOvYwM5ifE4zt+jC4rrCdRdYanzyccC+d8ke/TT82zi6X6YeQzUNp
         S7YeNT+wACDVBGCB96DP6Dh+DS6p2JDt7YwXqWRgjfUDbkNFZFxTSxYmUv8cUe5wEbMq
         oVCSF56LuITwsFhZu46rK+ydBH6wT5RaytHhwrA/oCA2ukL/pIP5yRLXLto4gs3xL8dp
         JXaZWhxv+35rTJzmsXvxl0X7nzbl7QHZngHjaLSX7tv5oxtVujTqdjZE5CrYdaijWg44
         XzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8SD8ZPeU6EGNuQiAtlRMrvwd5OdoCyHLtTvCII9wdpA=;
        b=FlgPYwPET01ld/yne+cU7THqK+rScTsO849n/uzeaBX6aEeRHtXqQ98lfysR1urIlH
         fvu3bG39hr+ldf3zvtpGGrFS2bvzLhhX2ltTkEw3ZhVenVrEG+lzZAx1xoFoasN0CFME
         b8/4jUbsBOL4GGcT3qt2/WbCqcL6e/uE9pZa+e5sDyhzqzAuIlr5TS1BUX6S3OjXrbyW
         CgRirEiIiT6W4vgobWUhqsUm+XlJ24UnSRuLJdj73he3B0H8VivV4aMj5CmaiwmVOubQ
         D6P81+pG3EedFCi74qczITn/u5a4Rk0ytSxWszbRZMtcs4n19BukYfRhO2pbQSg/Bef/
         S49A==
X-Gm-Message-State: AOAM533tfTjCdPCttpw4WCOW82Uv/Pv/BN+ahmapJ8alxYBeJrxhdRvg
        0FKx2bsvU5nV1DL0Kr2PMq8=
X-Google-Smtp-Source: ABdhPJzTEaZ336neF7bbZKsYK5NWw/otWHGge765qLvWWOaoLQys7DUnZvg3/O6YeRU/g/4aO0XyrQ==
X-Received: by 2002:a05:6402:4396:: with SMTP id o22mr17527554edc.263.1637286481554;
        Thu, 18 Nov 2021 17:48:01 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id b11sm821410edz.50.2021.11.18.17.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:48:00 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:47:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 12/19] net: dsa: qca8k: add set_ageing_time
 support
Message-ID: <20211119014759.ailhsinh5ahqoymg@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:44PM +0100, Ansuel Smith wrote:
> qca8k support setting ageing time in set of 7s. Add support for it and
> return error with value greater than the max value accepted of 7645m.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 18 ++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  3 +++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a74099131e3d..50f19549b97d 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1833,6 +1833,23 @@ qca8k_port_fast_age(struct dsa_switch *ds, int port)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	unsigned int secs = msecs / 1000;
> +	u32 val;
> +
> +	/* AGE_TIME reg is set in 7s step */
> +	val = secs / 7;

A typical bug is when the user gives you an ageing time smaller than 7
seconds, like 6, and you divide and end up writing 0 to hardware, which
effectively disables learning and is not what the user intended.
Maybe DIV_ROUND_UP? Or just catch "val == 0" and replace it with 1.

> +
> +	if (val > FIELD_MAX(QCA8K_ATU_AGE_TIME_MASK))
> +		return -ERANGE;

You can set ds->ageing_time_max and it could do the check for you.

> +
> +	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
> +				  QCA8K_ATU_AGE_TIME(val));
> +}
> +
>  static int
>  qca8k_port_enable(struct dsa_switch *ds, int port,
>  		  struct phy_device *phy)
> @@ -2125,6 +2142,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.get_strings		= qca8k_get_strings,
>  	.get_ethtool_stats	= qca8k_get_ethtool_stats,
>  	.get_sset_count		= qca8k_get_sset_count,
> +	.set_ageing_time	= qca8k_set_ageing_time,
>  	.get_mac_eee		= qca8k_get_mac_eee,
>  	.set_mac_eee		= qca8k_set_mac_eee,
>  	.port_enable		= qca8k_port_enable,
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index d25afdab4dea..e1298179d7cb 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -175,6 +175,9 @@
>  #define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
>  #define   QCA8K_VTU_FUNC1_VID_MASK			GENMASK(27, 16)
>  #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
> +#define QCA8K_REG_ATU_CTRL				0x618
> +#define   QCA8K_ATU_AGE_TIME_MASK			GENMASK(15, 0)
> +#define   QCA8K_ATU_AGE_TIME(x)				FIELD_PREP(QCA8K_ATU_AGE_TIME_MASK, (x))
>  #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
>  #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
>  #define   QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM		GENMASK(7, 4)
> -- 
> 2.32.0
> 
