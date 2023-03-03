Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00AE6AA5FF
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCCX7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCCX7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:59:21 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2A5CA12;
        Fri,  3 Mar 2023 15:59:19 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id h19so4807316qtk.7;
        Fri, 03 Mar 2023 15:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677887958;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1nTNHMYdyHCaoekkizYh9XLLLFdRS3SAJPYKEnkyUU=;
        b=OMl5RyFRfMexLL3jZVjSn4vNHqSs6pOcR9iseiK4FVpD7nTZZEIugqCPYU8YwJJavo
         MwOMK8HhyfMrcIfoKmnIWS+tqgBmBDBo3tP5IFMcc16Iaywc5MlyBzeS/QdpuT9GjUl9
         MM3Rll3Z+gY9v4p3WH52L7XJLjLPo1AvXPoKs9CITCd/8H+4Gw2txDZ/SubHiAp7jdJ6
         1yfQWpzkq4RzOJc+akc0tRYne5YD4uZdv2F24Ydn3KC2NgcgF9wSdU6MxccfPot6MLzG
         7aJdLTAFahZtMumw7Ml6nZB/5BMEdJTDUhb2Y4YBkVr4Oz3Jy/31FNXQuWeOUoycO/x/
         85xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677887958;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U1nTNHMYdyHCaoekkizYh9XLLLFdRS3SAJPYKEnkyUU=;
        b=hii+3nr7QB2FGDtfVZFcLQJB+sBnwW/zPzxRvfhIr7Yc+OAIJAzUmQzedyVZNXrq5x
         v3fZPD4O8uPnd5epoeUChIRe9haj478b2om3YyKSULE+rD1gXKkQdn/LD4vx6DRonwno
         MMmdtdTc4+2ovY9bAY02p9+Ooo7G8zyWngGauLJpCuz7mA1cSjJXhaVTbB07zhGwsCt6
         AcOlcH0idmdU7JxP0mn7TSLrpXEwVL3fGDnqHejlRJQGkWYwNggHRALjpFw5he8aPTtA
         4+LLOzwUSSFlVX4+P4K6PuZEEsCym9sSr066p1+84syunkkPxyvFj15KyiiKkr5w+iJU
         BApQ==
X-Gm-Message-State: AO0yUKUExMVk8TjIfkIz0CB2/7Pw/2wdwC+c26coW+//1SqqdxtVVZGz
        aH0txZoDAin85iFbX/b3GtA=
X-Google-Smtp-Source: AK7set8xw48pmJapZtqFLrxVJ1J3zmGyHxh/cPnKxjzP11vXxYezWIpDrw5FtZ07a+K9I5YAdtNSwA==
X-Received: by 2002:a05:622a:1354:b0:3bf:c474:df98 with SMTP id w20-20020a05622a135400b003bfc474df98mr5755019qtk.56.1677887958503;
        Fri, 03 Mar 2023 15:59:18 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id y9-20020ac87089000000b003bfaae103f6sm2674891qto.89.2023.03.03.15.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 15:59:18 -0800 (PST)
Date:   Fri, 03 Mar 2023 18:59:17 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?S8O2cnkgTWFpbmNlbnQ=?= <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <640289d5ef54c_cc8e2087a@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230303164248.499286-4-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-4-kory.maincent@bootlin.com>
Subject: RE: [PATCH v2 3/4] net: Let the active time stamping layer be
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

> Make the sysfs knob writable, and add checks in the ioctl and time
> stamping paths to respect the currently selected time stamping layer.
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
> =

>  .../ABI/testing/sysfs-class-net-timestamping  |  5 +-
>  drivers/net/phy/phy_device.c                  |  6 +++
>  include/linux/netdevice.h                     | 10 ++++
>  net/core/dev_ioctl.c                          | 44 ++++++++++++++--
>  net/core/net-sysfs.c                          | 50 +++++++++++++++++--=

>  net/core/timestamping.c                       |  6 +++
>  net/ethtool/common.c                          | 18 +++++--
>  7 files changed, 127 insertions(+), 12 deletions(-)
> =

> diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/D=
ocumentation/ABI/testing/sysfs-class-net-timestamping
> index 529c3a6eb607..6dfd59740cad 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-timestamping
> +++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
> @@ -11,7 +11,10 @@ What:		/sys/class/net/<iface>/current_timestamping_p=
rovider
>  Date:		January 2022
>  Contact:	Richard Cochran <richardcochran@gmail.com>
>  Description:
> -		Show the current SO_TIMESTAMPING provider.
> +		Shows or sets the current SO_TIMESTAMPING provider.
> +		When changing the value, some packets in the kernel
> +		networking stack may still be delivered with time
> +		stamps from the previous provider.
>  		The possible values are:
>  		- "mac"  The MAC provides time stamping.
>  		- "phy"  The PHY or MII device provides time stamping.
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.=
c
> index 8cff61dbc4b5..8dff0c6493b5 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1451,6 +1451,11 @@ int phy_attach_direct(struct net_device *dev, st=
ruct phy_device *phydev,
>  =

>  	phydev->phy_link_change =3D phy_link_change;
>  	if (dev) {
> +		if (phy_has_hwtstamp(phydev))
> +			dev->selected_timestamping_layer =3D PHY_TIMESTAMPING;
> +		else
> +			dev->selected_timestamping_layer =3D MAC_TIMESTAMPING;
> +
>  		phydev->attached_dev =3D dev;
>  		dev->phydev =3D phydev;
>  =

> @@ -1762,6 +1767,7 @@ void phy_detach(struct phy_device *phydev)
>  =

>  	phy_suspend(phydev);
>  	if (dev) {
> +		dev->selected_timestamping_layer =3D MAC_TIMESTAMPING;
>  		phydev->attached_dev->phydev =3D NULL;
>  		phydev->attached_dev =3D NULL;
>  	}
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ba2bd604359d..d8e9da2526f0 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1742,6 +1742,11 @@ enum netdev_ml_priv_type {
>  	ML_PRIV_CAN,
>  };
>  =

> +enum timestamping_layer {
> +	MAC_TIMESTAMPING,
> +	PHY_TIMESTAMPING,
> +};
> +
>  /**
>   *	struct net_device - The DEVICE structure.
>   *
> @@ -1981,6 +1986,9 @@ enum netdev_ml_priv_type {
>   *
>   *	@threaded:	napi threaded mode is enabled
>   *
> + *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
> + *					performs packet time stamping.
> + *
>   *	@net_notifier_list:	List of per-net netdev notifier block
>   *				that follow this device when it is moved
>   *				to another network namespace.
> @@ -2339,6 +2347,8 @@ struct net_device {
>  	unsigned		wol_enabled:1;
>  	unsigned		threaded:1;
>  =

> +	enum timestamping_layer selected_timestamping_layer;
> +
>  	struct list_head	net_notifier_list;
>  =

>  #if IS_ENABLED(CONFIG_MACSEC)
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 7674bb9f3076..cc7cf2a542fb 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -262,6 +262,43 @@ static int dev_eth_ioctl(struct net_device *dev,
>  	return err;
>  }
>  =

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
> +
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
> +		}
> +		break;
> +	}
> +
> +	return err;
> +}
> +
>  static int dev_siocbond(struct net_device *dev,
>  			struct ifreq *ifr, unsigned int cmd)
>  {
> @@ -397,6 +434,9 @@ static int dev_ifsioc(struct net *net, struct ifreq=
 *ifr, void __user *data,
>  			return err;
>  		fallthrough;
>  =

> +	case SIOCGHWTSTAMP:
> +		return dev_hwtstamp_ioctl(dev, ifr, cmd);
> +
>  	/*
>  	 *	Unknown or private ioctl
>  	 */
> @@ -407,9 +447,7 @@ static int dev_ifsioc(struct net *net, struct ifreq=
 *ifr, void __user *data,
>  =

>  		if (cmd =3D=3D SIOCGMIIPHY ||
>  		    cmd =3D=3D SIOCGMIIREG ||
> -		    cmd =3D=3D SIOCSMIIREG ||
> -		    cmd =3D=3D SIOCSHWTSTAMP ||
> -		    cmd =3D=3D SIOCGHWTSTAMP) {
> +		    cmd =3D=3D SIOCSMIIREG) {
>  			err =3D dev_eth_ioctl(dev, ifr, cmd);
>  		} else if (cmd =3D=3D SIOCBONDENSLAVE ||
>  		    cmd =3D=3D SIOCBONDRELEASE ||
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 26095634fb31..66079424b100 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -666,17 +666,59 @@ static ssize_t current_timestamping_provider_show=
(struct device *dev,
>  	if (!rtnl_trylock())
>  		return restart_syscall();
>  =

> -	if (phy_has_tsinfo(phydev)) {
> -		ret =3D sprintf(buf, "%s\n", "phy");
> -	} else {
> +	switch (netdev->selected_timestamping_layer) {
> +	case MAC_TIMESTAMPING:
>  		ret =3D sprintf(buf, "%s\n", "mac");
> +		break;
> +	case PHY_TIMESTAMPING:
> +		ret =3D sprintf(buf, "%s\n", "phy");
> +		break;
>  	}
>  =

>  	rtnl_unlock();
>  =

>  	return ret;
>  }
> -static DEVICE_ATTR_RO(current_timestamping_provider);
> +
> +static ssize_t current_timestamping_provider_store(struct device *dev,=

> +						   struct device_attribute *attr,
> +						   const char *buf, size_t len)
> +{
> +	struct net_device *netdev =3D to_net_dev(dev);
> +	struct net *net =3D dev_net(netdev);
> +	enum timestamping_layer flavor;
> +
> +	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	if (sysfs_streq(buf, "mac"))
> +		flavor =3D MAC_TIMESTAMPING;
> +	else if (sysfs_streq(buf, "phy"))
> +		flavor =3D PHY_TIMESTAMPING;
> +	else
> +		return -EINVAL;

Should setting netdev->selected_timestamping_layer be limited to
choices that the device supports?

At a higher level, this series assumes that any timestamp not through
phydev is a MAC timestamp. I don't think that is necessarily true for
all devices. Some may timestamp at the phy, but not expose a phydev.
This is a somewhat pedantic point. I understand that the purpose of
the series is to select from among two sets of APIs.
