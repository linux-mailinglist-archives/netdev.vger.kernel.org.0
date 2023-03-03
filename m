Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201F6AA5F8
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCCX45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCCX4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:56:55 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CFA69079;
        Fri,  3 Mar 2023 15:56:54 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id r5so4825896qtp.4;
        Fri, 03 Mar 2023 15:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677887814;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JgiuUs+kI6A9bFDK+qJcqqvwDWERLFBSfQOrdJ7ueCU=;
        b=O34I+9WJ+zRraDa+vSZMufxtIXBwqSDBTuJF0dl/wAgI/nZPvRTkT+bXA5KSIxFk76
         iGKtZnZtcEw7TV1AFLu4wqi5LyDA9LJ6xNThbVFdbOp/QBRAFAyqulQvFlO67r3f3v71
         GfoqrmPck8Y/CDk8Obvb6CUgEYVdh3OMehhpn/6tXs1KoyVgvnp7mT9AJgezDbOhQGGZ
         3wHJJvGqSbfV7ZwiDq4IppDMvCowHKTU+LCAvXQgHufr3L/RyRnjH/sTgjsl3ezIAZLW
         lojf6NBKyQ+8w+rgOko366n4adtC4DXv8rpMZkm6c9qtv3dFaxw0s+V+DSBFNPrCSoB/
         fvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677887814;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JgiuUs+kI6A9bFDK+qJcqqvwDWERLFBSfQOrdJ7ueCU=;
        b=aACbmRCYu25dhOqCnYmgfGvTMK9eR5ifdAXnvHQnZmy8AhpqMDaPAA7nV7yxK5c7sb
         N/GvoxY+qEoPFjq2N6+81jPpMsfj9AUOOV83Pdj3bbpVltQx5BM8jGPRABVmohuQuR7W
         yzbIwjwjFDQRUxqwxCdsn8GWSPjMhDs01u1rbrF5MWdRfXMr6FlMYsd9FP77M5lVfU7B
         Hb1BarDyCgvHxEZ0TJ2vt2ceBym1fPqddRa3dtAxPiBJq+YOi2iWzmo9yGkXfp8P+n45
         3/73+9/tnOpZieCYcaBQXc2ALQVbdmsMu/kmV+MfHwsFy01GUHyXK6VzgnvW5t1qm4Iq
         rI2w==
X-Gm-Message-State: AO0yUKUYe7+v6GCNaWKPJqFqjyERz5m+BVsxis/vgJeO4/PVchIBJ9YR
        +vz/9G7Xb2DAqGix5LfMMTo=
X-Google-Smtp-Source: AK7set8V0wU9njzuK9soNS7sUfFGDM0FAVkctWtQrnZ9lCklEnE8XAByXQlU6DZ/mAf3FJ+gPkLmjQ==
X-Received: by 2002:ac8:7f49:0:b0:3bf:d184:7ca2 with SMTP id g9-20020ac87f49000000b003bfd1847ca2mr5919964qtk.21.1677887813848;
        Fri, 03 Mar 2023 15:56:53 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id d12-20020ac8614c000000b003b63b8df24asm2692699qtm.36.2023.03.03.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 15:56:53 -0800 (PST)
Date:   Fri, 03 Mar 2023 18:56:53 -0500
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
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Message-ID: <640289453cd8b_cc8e20837@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230303164248.499286-3-kory.maincent@bootlin.com>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-3-kory.maincent@bootlin.com>
Subject: RE: [PATCH v2 2/4] net: Expose available time stamping layers to user
 space.
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

> Time stamping on network packets may happen either in the MAC or in
> the PHY, but not both.  In preparation for making the choice
> selectable, expose both the current and available layers via sysfs.
> =

> In accordance with the kernel implementation as it stands, the current
> layer will always read as "phy" when a PHY time stamping device is
> present.  Future patches will allow changing the current layer
> administratively.
> =

> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> ---
> =

> Notes:
>     Changes in v2:
>     - Move the introduction of selected_timestamping_layer variable in =
next
>       patch.
> =

>  .../ABI/testing/sysfs-class-net-timestamping  | 17 ++++++
>  net/core/net-sysfs.c                          | 60 +++++++++++++++++++=

>  2 files changed, 77 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-net-timestamp=
ing
> =

> diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/D=
ocumentation/ABI/testing/sysfs-class-net-timestamping
> new file mode 100644
> index 000000000000..529c3a6eb607
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
> @@ -0,0 +1,17 @@
> +What:		/sys/class/net/<iface>/available_timestamping_providers
> +Date:		January 2022
> +Contact:	Richard Cochran <richardcochran@gmail.com>
> +Description:
> +		Enumerates the available providers for SO_TIMESTAMPING.
> +		The possible values are:
> +		- "mac"  The MAC provides time stamping.
> +		- "phy"  The PHY or MII device provides time stamping.
> +
> +What:		/sys/class/net/<iface>/current_timestamping_provider
> +Date:		January 2022
> +Contact:	Richard Cochran <richardcochran@gmail.com>
> +Description:
> +		Show the current SO_TIMESTAMPING provider.
> +		The possible values are:
> +		- "mac"  The MAC provides time stamping.
> +		- "phy"  The PHY or MII device provides time stamping.
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 8409d41405df..26095634fb31 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -620,6 +620,64 @@ static ssize_t threaded_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(threaded);
>  =

> +static ssize_t available_timestamping_providers_show(struct device *de=
v,
> +						     struct device_attribute *attr,
> +						     char *buf)
> +{
> +	const struct ethtool_ops *ops;
> +	struct net_device *netdev;
> +	struct phy_device *phydev;
> +	int ret =3D 0;
> +
> +	netdev =3D to_net_dev(dev);
> +	phydev =3D netdev->phydev;
> +	ops =3D netdev->ethtool_ops;
> +
> +	if (!rtnl_trylock())
> +		return restart_syscall();
> +
> +	ret +=3D sprintf(buf, "%s\n", "mac");
> +	buf +=3D 4;
> +

Should advertising mac be subject to having ops->get_ts_info?

> +	if (phy_has_tsinfo(phydev)) {
> +		ret +=3D sprintf(buf, "%s\n", "phy");
> +		buf +=3D 4;
> +	}
> +
> +	rtnl_unlock();
> +
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(available_timestamping_providers);=
