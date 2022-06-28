Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE4D55DA43
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbiF1MHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238286AbiF1MHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:07:35 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E842B252;
        Tue, 28 Jun 2022 05:06:52 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 99E5D1C0003;
        Tue, 28 Jun 2022 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656418001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XlX9ERJmg7cC3AkJQeMdny26Pdns8t34JvkB+XE5gyc=;
        b=m+1FJ8iO8oFZ5uIfj+dYWDKny3tQZosgAUIQL1F7mZnu9S9bM2V7V3EFx6BQHpWo8JCind
        YROxNiVVz1Ciq8/mB/AVbcRb6WY5wXhm2+6tvlzzkAGu43GQh+BPqVT5KrIxVzAcYGc1ZM
        WNBY/lScn+/Jf63NYsenDZU+Kf6lKz81ImGcZtXX7khdGgHBrrI/kwzTDfGKsQYhDnptzr
        P95MryH/gCbuhS+1r2unZZUAGQSQ0Z5EU3GNruBiPDsnIwGS8uig0zZrl2yldblvjC8/3d
        Wa4DEay9XdgFyDVwWwPiOJ08u8kpT7aJb7WvVi/cdFVenJ9CDEPUcnPeuzLdEg==
Date:   Tue, 28 Jun 2022 14:05:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <olteanv@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next] net: pcs-rzn1-miic: fix return value check in
 miic_probe()
Message-ID: <20220628140553.5174825b@fixe.home>
In-Reply-To: <20220628120850.3425568-1-yangyingliang@huawei.com>
References: <20220628120850.3425568-1-yangyingliang@huawei.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 28 Jun 2022 20:08:50 +0800,
Yang Yingliang <yangyingliang@huawei.com> a =C3=A9crit :

> If devm_platform_ioremap_resource() fails, it never return
> NULL pointer, replace NULL test with IS_ERR().

Thanks for your patch, maybe this description would be better:

"On failure, devm_platform_ioremap_resource() returns a ERR_PTR() value
and not NULL. Fix return value checking by using IS_ERR() and
return PTR_ERR() as error value."

Cl=C3=A9ment

>=20
> Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/pcs/pcs-rzn1-miic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-m=
iic.c
> index 8f5e910f443d..d896961e48cc 100644
> --- a/drivers/net/pcs/pcs-rzn1-miic.c
> +++ b/drivers/net/pcs/pcs-rzn1-miic.c
> @@ -461,8 +461,8 @@ static int miic_probe(struct platform_device *pdev)
>  	spin_lock_init(&miic->lock);
>  	miic->dev =3D dev;
>  	miic->base =3D devm_platform_ioremap_resource(pdev, 0);
> -	if (!miic->base)
> -		return -EINVAL;
> +	if (IS_ERR(miic->base))
> +		return PTR_ERR(miic->base);
> =20
>  	ret =3D devm_pm_runtime_enable(dev);
>  	if (ret < 0)

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
