Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2312EE9DC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbhAGXgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:36:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAGXgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 18:36:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxeoN-00GlzS-I0; Fri, 08 Jan 2021 00:35:23 +0100
Date:   Fri, 8 Jan 2021 00:35:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next 03/10] net: dsa: add ops for devlink-sb
Message-ID: <X/eauzr3d7es/YpH@lunn.ch>
References: <20210107172726.2420292-1-olteanv@gmail.com>
 <20210107172726.2420292-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107172726.2420292-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct dsa_port *devlink_to_dsa_port(struct devlink_port *dlp)
> +{
> +	return container_of(dlp, struct dsa_port, devlink_port);
> +}

I wonder if this should be moved to include/net/dsa.h next to the
other little helpers used to convert between devlink structures and
DSA structures?

> +
> +static int dsa_devlink_sb_pool_get(struct devlink *dl,
> +				   unsigned int sb_index, u16 pool_index,
> +				   struct devlink_sb_pool_info *pool_info)
> +{
> +	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
> +	struct dsa_switch *ds = dl_priv->ds;

dsa_devlink_to_ds()

> +
> +	if (!ds->ops->devlink_sb_pool_get)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->devlink_sb_pool_get(ds, sb_index, pool_index,
> +					    pool_info);
> +}
> +

	Andrew
