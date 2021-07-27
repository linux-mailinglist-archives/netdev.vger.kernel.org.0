Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49A53D724F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhG0Jrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:47:35 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41227 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236074AbhG0Jrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:47:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5B661320079B;
        Tue, 27 Jul 2021 05:47:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 27 Jul 2021 05:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-id:content-type:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gY4UTeqi38qVevjiESPFwl2OdxktiSNqxtqK3cUHOio=; b=jg4CBx/S
        v3Z6dyIz7AY3SOHbLxOViTe+aFIbPs9XVnS8SgmAHpv92YZU1jpz7wzIZkImvpvT
        Cus/z9nBY2RzPBKRwUOnUCpC2MkkI+IO31VDZ40N0CESjtMBwfFO5CAnSPHWqiK/
        LtS6jWVWtQ8rRF0/E01El5jfT9Jc04jMi/7Sg6tDsWoOsv6uDhCzpUMpGs1x4enO
        Fbr+cf3z2BZj6sArbsDzciN0szSqS3Ld+AvpORmoMDcjtW1uTonpr5T2Iznuq1BC
        7eKRoF21ddpqzDZmVEmXRhYU7Kq81p6l/bH6BQkKYz5YuR2DW4AE0EwbITPfI2Dw
        BumtkbbMp2PeXQ==
X-ME-Sender: <xms:MNb_YEv1qWq8CNlMBF5EtMQplVHMoRZUMQU92xZNNKgCSnCCkZnKpQ>
    <xme:MNb_YBfv2I9cU5CEW_D0bCRM776zOKeqjVNdswzxC9fSLnvicc-MnUXGCBc02zDFr
    AycMvh-NZZsEWVtwuo>
X-ME-Received: <xmr:MNb_YPzOwHjyZnCV0zxhis-RG7T-Shc-SPFAvqD4DySw54CbOo3pMmpSDvdg-Se3l4Fl0eh_kDfGEYIIrNfHyh1IcKYQd2zscGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeejgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehmtderredttdejnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefffejiefgheevheefvefhteeggfeijeeiveeihfffffdugfefkeelfffhgfeh
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:MNb_YHP1QUG41yPCkYUfVoLQVFsz6bN8RoJsjwNIw5zAEhxNlPR-9w>
    <xmx:MNb_YE-Y4kfXMQPoBiE4uA6I6txfq72C_O-I8-b0vMJ1XxKGh772BQ>
    <xmx:MNb_YPVvDJyjMAqWFSJbmWQHTW66qRB7GDy2j0dJVFLZyDRKd_ioDw>
    <xmx:Mtb_YBNtyCAMcv8ITE2dzfuHa73O3JOgAzsgXYQxZe3x71Pa5qzuOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Jul 2021 05:47:26 -0400 (EDT)
Date:   Tue, 27 Jul 2021 19:47:30 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 2/5] nubus: Make struct nubus_driver::remove return
 void
In-Reply-To: <20210727080840.3550927-3-u.kleine-koenig@pengutronix.de>
Message-ID: <59bc4bf-7e8e-24be-5a7a-d165e6b73c32@linux-m68k.org>
References: <20210727080840.3550927-1-u.kleine-koenig@pengutronix.de> <20210727080840.3550927-3-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811774-1321263043-1627379041=:27"
Content-ID: <5c95884-21f4-a5b0-c5ad-12dc7ae6ffc8@nippy.intranet>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-1321263043-1627379041=:27
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <4427256-e4b9-b8ee-c183-114bc2c5c61e@nippy.intranet>

On Tue, 27 Jul 2021, Uwe Kleine-K=C3=B6nig wrote:

> The nubus core ignores the return value of the remove callback (in
> nubus_device_remove()) and all implementers return 0 anyway.
>=20
> So make it impossible for future drivers to return an unused error code
> by changing the remove prototype to return void.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Finn Thain <fthain@linux-m68k.org>

> ---
>  drivers/net/ethernet/8390/mac8390.c     | 3 +--
>  drivers/net/ethernet/natsemi/macsonic.c | 4 +---
>  include/linux/nubus.h                   | 2 +-
>  3 files changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8=
390/mac8390.c
> index 9aac7119d382..91b04abfd687 100644
> --- a/drivers/net/ethernet/8390/mac8390.c
> +++ b/drivers/net/ethernet/8390/mac8390.c
> @@ -428,13 +428,12 @@ static int mac8390_device_probe(struct nubus_board =
*board)
>  =09return err;
>  }
> =20
> -static int mac8390_device_remove(struct nubus_board *board)
> +static void mac8390_device_remove(struct nubus_board *board)
>  {
>  =09struct net_device *dev =3D nubus_get_drvdata(board);
> =20
>  =09unregister_netdev(dev);
>  =09free_netdev(dev);
> -=09return 0;
>  }
> =20
>  static struct nubus_driver mac8390_driver =3D {
> diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethern=
et/natsemi/macsonic.c
> index 2289e1fe3741..8709d700e15a 100644
> --- a/drivers/net/ethernet/natsemi/macsonic.c
> +++ b/drivers/net/ethernet/natsemi/macsonic.c
> @@ -603,7 +603,7 @@ static int mac_sonic_nubus_probe(struct nubus_board *=
board)
>  =09return err;
>  }
> =20
> -static int mac_sonic_nubus_remove(struct nubus_board *board)
> +static void mac_sonic_nubus_remove(struct nubus_board *board)
>  {
>  =09struct net_device *ndev =3D nubus_get_drvdata(board);
>  =09struct sonic_local *lp =3D netdev_priv(ndev);
> @@ -613,8 +613,6 @@ static int mac_sonic_nubus_remove(struct nubus_board =
*board)
>  =09=09=09  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
>  =09=09=09  lp->descriptors, lp->descriptors_laddr);
>  =09free_netdev(ndev);
> -
> -=09return 0;
>  }
> =20
>  static struct nubus_driver mac_sonic_nubus_driver =3D {
> diff --git a/include/linux/nubus.h b/include/linux/nubus.h
> index eba50b057f6f..392fc6c53e96 100644
> --- a/include/linux/nubus.h
> +++ b/include/linux/nubus.h
> @@ -86,7 +86,7 @@ extern struct list_head nubus_func_rsrcs;
>  struct nubus_driver {
>  =09struct device_driver driver;
>  =09int (*probe)(struct nubus_board *board);
> -=09int (*remove)(struct nubus_board *board);
> +=09void (*remove)(struct nubus_board *board);
>  };
> =20
>  extern struct bus_type nubus_bus_type;
>=20
---1463811774-1321263043-1627379041=:27--
