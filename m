Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16AB6B0CA8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjCHP25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCHP2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:28:55 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80FA73AD7;
        Wed,  8 Mar 2023 07:28:53 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id m4so11313067qvq.3;
        Wed, 08 Mar 2023 07:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678289333;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd0EmI05pCHTfIlBbUfoXj5rvm0Lfpegcu0/RFX07E0=;
        b=oi0vouDb9vTONHCz7DWqrFJLIaUvXJ6V7s2rQfvwtAiJ+Nc3gKa8Dq81cQumK0b0Yv
         qTrTkrQavLsdFb1wAJAGtI5rdU980XCncLXOTcn8Vc5wW3iVt6D4V5hzTXcuwN7ZPAsp
         7cFjREFMPdLhMrof4l9PAAgUiUlIlEeirBsHN9VoM2RZgSmHSrKadxm9LYZSHCzUR8+l
         V2+EFPjDcHOFOouYNGL5Ch7Sl01pVi4+aKmwxOVOIg0ElZZ09VIp91EG0mEG9OtYh2dZ
         6kJ67jcK+nfw8T8rKqsxP8TjqVrHkgWkezaZdfdP6Har3eN/7qlOjyY3Zt8//YiS90aR
         V+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678289333;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bd0EmI05pCHTfIlBbUfoXj5rvm0Lfpegcu0/RFX07E0=;
        b=N6AUWeOd0Cf2W3DsnqBm0tG/sUw9+HZDNkB4VN/mKwCcnhv4Az+P+r5dq8EQs8NofD
         Jm1VGi1zefdHGdYRegiOodCVQOXH9KVny1GlJw2+lXtVlq8uAgY/vyxWphPZ9ijhqCBQ
         lJkRMPNJouJG4BkGqJnfkQnNwGfwsCKdtTb5eBaoxyFH1no2XkIBuK5EP/hj14FbXOXk
         uwik/mRE9HZ06Mhc8m2mvgsiGoDEelbC5ijpwqGNvPNPBXtoNCWN9Y4KiKdjtzTDk4rJ
         CUfkRp9QmXLgx96YKHVTpMC8IWM91XuQlyCeWoWseuCAke9ozu/2O+Sskv4aLBldq7+1
         EbaA==
X-Gm-Message-State: AO0yUKUjVlSVVVBKTamkkS1oTIrw0+EgUN4XRgZ/LKlITQjVl2JjDpUh
        3+DmQEINJT8Lic88nlKJptY=
X-Google-Smtp-Source: AK7set/QwnmzvGEgctgtRzpXygzSgoQMuIMdEi7EGkwdBQ/fUr9GGZ7htQvDCPjxU3tNhW4OMkQOPg==
X-Received: by 2002:a05:6214:238e:b0:56e:bb43:a07c with SMTP id fw14-20020a056214238e00b0056ebb43a07cmr30115921qvb.20.1678289332740;
        Wed, 08 Mar 2023 07:28:52 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id t190-20020a3746c7000000b0074235745fdasm11481891qka.58.2023.03.08.07.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 07:28:52 -0800 (PST)
Date:   Wed, 08 Mar 2023 10:28:51 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?S8O2cnkgTWFpbmNlbnQ=?= <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Message-ID: <6408a9b3c7ae1_13061c2082a@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230308135936.761794-4-kory.maincent@bootlin.com>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
Subject: RE: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

K=C3=B6ry Maincent wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> =

> Add the ETHTOOL_SET_PTP ethtool ioctl, and add checks in the ioctl and =
time
> stamping paths to respect the currently selected time stamping layer.
> =

> Add a preferred-timestamp devicetree binding to select the preferred
> hardware timestamp layer between PHY and MAC. The choice of using
> devicetree binding has been made as the PTP precision and quality depen=
ds
> of external things, like adjustable clock, or the lack of a temperature=

> compensated crystal or specific features. Even if the preferred timesta=
mp
> is a configuration it is hardly related to the design oh the board.

nit: oh -> of

> =

> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> ---
> =

> Notes:
>     Changes in v2:
>     - Move selected_timestamping_layer introduction in this patch.
>     - Replace strmcmp by sysfs_streq.
>     - Use the PHY timestamp only if available.
>     =

>     Changes in v3:
>     - Added a devicetree binding to select the preferred timestamp
>     - Replace the way to select timestamp through ethtool instead of sy=
sfs
>     You can test it with the ethtool source on branch feature_ptp of:
>     https://github.com/kmaincent/ethtool
> =

>  Documentation/networking/ethtool-netlink.rst |  1 +
>  drivers/net/phy/phy_device.c                 | 34 ++++++++++++++++
>  include/linux/netdevice.h                    |  6 +++
>  include/uapi/linux/ethtool.h                 |  1 +
>  net/core/dev_ioctl.c                         | 43 ++++++++++++++++++--=

>  net/core/timestamping.c                      |  6 +++
>  net/ethtool/common.c                         | 16 ++++++--
>  net/ethtool/ioctl.c                          | 41 ++++++++++++++-----
>  8 files changed, 131 insertions(+), 17 deletions(-)
> =

> +void of_set_timestamp(struct net_device *netdev, struct phy_device *ph=
ydev)
> +{
> +	struct device_node *node =3D phydev->mdio.dev.of_node;
> +	const struct ethtool_ops *ops =3D netdev->ethtool_ops;
> +	const char *s;
> +	enum timestamping_layer ts_layer =3D 0;
> +
> +	if (phy_has_hwtstamp(phydev))
> +		ts_layer =3D PHY_TIMESTAMPING;
> +	else if (ops->get_ts_info)
> +		ts_layer =3D MAC_TIMESTAMPING;
> +
> +	if (of_property_read_string(node, "preferred-timestamp", &s))
> +		goto out;
> +
> +	if (!s)
> +		goto out;
> +
> +	if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
> +		ts_layer =3D PHY_TIMESTAMPING;
> +
> +	if (ops->get_ts_info && !strcmp(s, "mac"))
> +		ts_layer =3D MAC_TIMESTAMPING;
> +
> +out:
> +	netdev->selected_timestamping_layer =3D ts_layer;
> +}
> +
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ba2bd604359d..d9a1c12fc43c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -47,6 +47,7 @@
>  #include <uapi/linux/netdevice.h>
>  #include <uapi/linux/if_bonding.h>
>  #include <uapi/linux/pkt_cls.h>
> +#include <uapi/linux/net_tstamp.h>
>  #include <linux/hashtable.h>
>  #include <linux/rbtree.h>
>  #include <net/net_trackers.h>
> @@ -1981,6 +1982,9 @@ enum netdev_ml_priv_type {
>   *
>   *	@threaded:	napi threaded mode is enabled
>   *
> + *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
> + *					performs packet time stamping.
> + *
>   *	@net_notifier_list:	List of per-net netdev notifier block
>   *				that follow this device when it is moved
>   *				to another network namespace.
> @@ -2339,6 +2343,8 @@ struct net_device {
>  	unsigned		wol_enabled:1;
>  	unsigned		threaded:1;
>  =

> +	enum timestamping_layer selected_timestamping_layer;
> +

can perhaps be a single bit rather than an enum

> +static int dev_hwtstamp_ioctl(struct net_device *dev,
> +			      struct ifreq *ifr, unsigned int cmd)
> +{
> +	const struct net_device_ops *ops =3D dev->netdev_ops;
> +	int err;
> +
> +	err =3D dsa_ndo_eth_ioctl(dev, ifr, cmd);
> +	if (err =3D=3D 0 || err !=3D -EOPNOTSUPP)
> +		return err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	switch (dev->selected_timestamping_layer) {
> +	case MAC_TIMESTAMPING:
> +		if (ops->ndo_do_ioctl =3D=3D phy_do_ioctl) {
> +			/* Some drivers set .ndo_do_ioctl to phy_do_ioctl. */
> +			err =3D -EOPNOTSUPP;
> +		} else {
> +			err =3D ops->ndo_eth_ioctl(dev, ifr, cmd);
> +		}
> +		break;
> +
> +	case PHY_TIMESTAMPING:
> +		if (phy_has_hwtstamp(dev->phydev)) {
> +			err =3D phy_mii_ioctl(dev->phydev, ifr, cmd);
> +		} else {
> +			err =3D -ENODEV;
> +			WARN_ON(1);

Please no WARN_ON on error cases that are known to be reachable
and can be handled safely and reported to userspace.

> +		}
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 64a7e05cf2c2..e55e70bdbb3c 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -548,10 +548,18 @@ int __ethtool_get_ts_info(struct net_device *dev,=
 struct ethtool_ts_info *info)
>  	memset(info, 0, sizeof(*info));
>  	info->cmd =3D ETHTOOL_GET_TS_INFO;
>  =

> -	if (phy_has_tsinfo(phydev))
> -		return phy_ts_info(phydev, info);
> -	if (ops->get_ts_info)
> -		return ops->get_ts_info(dev, info);
> +	switch (dev->selected_timestamping_layer) {
> +	case MAC_TIMESTAMPING:
> +		if (ops->get_ts_info)
> +			return ops->get_ts_info(dev, info);
> +		break;
> +
> +	case PHY_TIMESTAMPING:
> +		if (phy_has_tsinfo(phydev))
> +			return phy_ts_info(phydev, info);
> +		WARN_ON(1);
> +		return -ENODEV;

same

> +	}
>  =

>  	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>  				SOF_TIMESTAMPING_SOFTWARE;=
