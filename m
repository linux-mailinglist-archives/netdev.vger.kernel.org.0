Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78923554D
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 06:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgHBEcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 00:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgHBEcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 00:32:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A3A207DF;
        Sun,  2 Aug 2020 04:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596342726;
        bh=pXDV9uj2LRzCO1NSsXAK98Vzu9+OzImTifjwaJwuU0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mV8EvL5lCMxbvM3HYvuQQyNM+dRlQDL1UapSr9D6OcZzc9f9ndEQi9TXkGuUt6Ww5
         IuSn3ZYWAaA9TJ+C14jidcK3Ia3JYwjrskH+zz7xPFdiDp3+yVqWp6LuHs2oTu6MEA
         Is32TyVYFSuVlU1tVEMVJuU74kDD4fXoCC52ugfw=
Date:   Sat, 1 Aug 2020 21:32:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 v2 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200801213204.0a52a865@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200801205242.GA9549@mx-linux-amd>
References: <20200801205242.GA9549@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Aug 2020 22:52:42 +0200 Armin Wolf wrote:
> Replace version string with MODULE_* macros.
>=20
> Include necessary libraries.
>=20
> Fix two minor coding-style issues.
>=20
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

This doesn't build but also

../drivers/net/ethernet/8390/lib8390.c:973:17: error: undefined identifier =
'version'
In file included from ../include/linux/kernel.h:15,
                 from ../drivers/net/ethernet/8390/8390.c:9:
../drivers/net/ethernet/8390/lib8390.c: In function =E2=80=98ethdev_setup=
=E2=80=99:
../drivers/net/ethernet/8390/lib8390.c:973:17: error: =E2=80=98version=E2=
=80=99 undeclared (first use in this function)
  973 |   pr_info("%s", version);
      |                 ^~~~~~~
../include/linux/printk.h:368:34: note: in definition of macro =E2=80=98pr_=
info=E2=80=99
  368 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
      |                                  ^~~~~~~~~~~
../drivers/net/ethernet/8390/lib8390.c:973:17: note: each undeclared identi=
fier is reported only once for each function it appears in
  973 |   pr_info("%s", version);
      |                 ^~~~~~~
../include/linux/printk.h:368:34: note: in definition of macro =E2=80=98pr_=
info=E2=80=99
  368 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
      |                                  ^~~~~~~~~~~
make[5]: *** [../scripts/Makefile.build:281: drivers/net/ethernet/8390/8390=
.o] Error 1
make[4]: *** [../scripts/Makefile.build:497: drivers/net/ethernet/8390] Err=
or 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [../scripts/Makefile.build:497: drivers/net/ethernet] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [../scripts/Makefile.build:497: drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/netdev/net-next/Makefile:1771: drivers] Error 2
make: *** [Makefile:185: __sub-make] Error 2

> diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390=
/8390.c
> index 0e0aa4016858..aabb637c1fbf 100644
> --- a/drivers/net/ethernet/8390/8390.c
> +++ b/drivers/net/ethernet/8390/8390.c
> @@ -1,11 +1,26 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/* 8390 core for usual drivers */
>=20
> -static const char version[] =3D
> -    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)=
\n";
> +#define DRV_NAME "8390"
> +#define DRV_DESCRIPTION "8390 core for usual drivers"
> +#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"
> +#define DRV_VERSION "1.10cvs"
> +#define DRV_RELDATE "9/23/1994"
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/export.h>
> +
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
>=20
>  #include "lib8390.c"
>=20
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESCRIPTION);
> +MODULE_VERSION(DRV_VERSION);

Please drop the driver version, it looks pretty meaningless and we are
moving away from driver versions in general.

> +MODULE_LICENSE("GPL");

Why move this up? It's common to have these at the end.

> +
>  int ei_open(struct net_device *dev)
>  {
>  	return __ei_open(dev);
> @@ -64,7 +79,7 @@ const struct net_device_ops ei_netdev_ops =3D {
>  	.ndo_get_stats		=3D ei_get_stats,
>  	.ndo_set_rx_mode	=3D ei_set_multicast_list,
>  	.ndo_validate_addr	=3D eth_validate_addr,
> -	.ndo_set_mac_address 	=3D eth_mac_addr,
> +	.ndo_set_mac_address	=3D eth_mac_addr,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	=3D ei_poll,
>  #endif
> @@ -74,6 +89,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
>  struct net_device *__alloc_ei_netdev(int size)
>  {
>  	struct net_device *dev =3D ____alloc_ei_netdev(size);
> +
>  	if (dev)
>  		dev->netdev_ops =3D &ei_netdev_ops;
>  	return dev;
> @@ -100,4 +116,3 @@ static void __exit ns8390_module_exit(void)
>  module_init(ns8390_module_init);
>  module_exit(ns8390_module_exit);
>  #endif /* MODULE */
> -MODULE_LICENSE("GPL");
> --
> 2.20.1

