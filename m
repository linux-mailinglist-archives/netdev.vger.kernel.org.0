Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39116AF679
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjCGUNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjCGUNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:13:53 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE4519A8
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 12:13:46 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-536b7ffdd34so265782527b3.6
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 12:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678220025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjGAL4qrsSnlU11pFe+NqHmPaSOhpiqbOMFZKmTdwJk=;
        b=ZQCRA+z6IbB5A9BR3+GiXKBVo0i5HsmP6OcepjeqGDuRAaqWXKAhNfeHl4ERQ7+hdf
         mpxrMOpIV27dQoxpR6wq/6qRhhjoMID5Y8AHTkSNbtumvOzYeQZGaxoY8junXegKzVE7
         iKHuHTYq0Q1XdPTcvyy82Ut94yI1bcf9VPiZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678220025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vjGAL4qrsSnlU11pFe+NqHmPaSOhpiqbOMFZKmTdwJk=;
        b=E+O4dfs9Xz6rjIXEwzBuJKV60jBtI9lKHe3PsGFeHiOFxQYfHgUbs/8dsw83VQLzZO
         EwpFdoMSewMgsYf4FhNbv/5Xf61gMiJyJNpo57kBVriyv7prl+1jLQvSQrbTwuu1klrH
         GmlnLedWOw6mNZEfggx7ImkYRo1x5+NSVr/YZ3aBxCjm2MN3yPj6l1evr/QQdzadubCJ
         2JLbhUxpHgAXYKupHtYpF+pzrfB2rP2bCe1cfiDKz3Nw+ygCuR0FzGpLBMEVrg9XKA16
         X4jYqydnofLIf31pcJ1++9qP5dV1TMaYBGAvPcao5sfNCM8hSiOLJLMSp6NY+XnZ0o5A
         4WZg==
X-Gm-Message-State: AO0yUKV4eftlJuvw1VwpaGpwxLMzbc4IKu8QARZNs9TItSzLb1y3y90i
        POlZC6gIUlR17j38XoWfxychh+lP9ykgezGOQhREvg==
X-Google-Smtp-Source: AK7set8x25qXHmjdLMpukA8IBbcp+jaqrfaDZlGy4YLoE8QUykP0ZTUaQihDzQZycNyyTAQ72mx0Sf40TwO3YHEAQn4=
X-Received: by 2002:a81:ac5f:0:b0:535:a5eb:99d7 with SMTP id
 z31-20020a81ac5f000000b00535a5eb99d7mr8451952ywj.2.1678220025216; Tue, 07 Mar
 2023 12:13:45 -0800 (PST)
MIME-Version: 1.0
References: <20230307200502.2263655-1-grundler@chromium.org> <20230307200502.2263655-2-grundler@chromium.org>
In-Reply-To: <20230307200502.2263655-2-grundler@chromium.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 7 Mar 2023 12:13:33 -0800
Message-ID: <CANEJEGt4RCZX8uPBgGcRPmb=Ws6jHFC8h98phfA4sz-8rdtkkA@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] net: asix: init mdiobus from one function
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 12:05=E2=80=AFPM Grant Grundler <grundler@chromium.o=
rg> wrote:
>
> Make asix driver consistent with other drivers (e.g. tg3 and r8169) which
> use mdiobus calls: setup and tear down be handled in one function each.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/net/usb/asix_devices.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_device=
s.c
> index 21845b88a64b9..d7caab4493d15 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -637,7 +637,7 @@ static int asix_resume(struct usb_interface *intf)
>         return usbnet_resume(intf);
>  }
>
> -static int ax88772_init_mdio(struct usbnet *dev)
> +static int ax88772_mdio_register(struct usbnet *dev)
>  {
>         struct asix_common_private *priv =3D dev->driver_priv;
>         int ret;
> @@ -657,10 +657,22 @@ static int ax88772_init_mdio(struct usbnet *dev)
>         ret =3D mdiobus_register(priv->mdio);
>         if (ret) {
>                 netdev_err(dev->net, "Could not register MDIO bus (err %d=
)\n", ret);
> -               mdiobus_free(priv->mdio);
> -               priv->mdio =3D NULL;
> +               goto mdio_register_err;
>         }
>
> +       priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> +       if (!priv->phydev) {
> +               netdev_err(dev->net, "Could not find PHY\n");
> +               ret=3D-ENODEV;

My apologies: checkpatch wants spaces around "=3D" and especially
because it should be "ret =3D -ENODEV".

I can resend - but is this trivial enough to fix up by maintainer?

cheers,
grant

> +               goto mdio_phy_err;
> +       }
> +
> +       return 0;
> +
> +mdio_phy_err:
> +       mdiobus_unregister(priv->mdio);
> +mdio_register_err:
> +       mdiobus_free(priv->mdio);
>         return ret;
>  }
>
> @@ -675,13 +687,6 @@ static int ax88772_init_phy(struct usbnet *dev)
>         struct asix_common_private *priv =3D dev->driver_priv;
>         int ret;
>
> -       priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> -       if (!priv->phydev) {
> -               netdev_err(dev->net, "Could not find PHY\n");
> -               ax88772_mdio_unregister(priv);
> -               return -ENODEV;
> -       }
> -
>         ret =3D phy_connect_direct(dev->net, priv->phydev, &asix_adjust_l=
ink,
>                                  PHY_INTERFACE_MODE_INTERNAL);
>         if (ret) {
> @@ -799,7 +804,7 @@ static int ax88772_bind(struct usbnet *dev, struct us=
b_interface *intf)
>         priv->presvd_phy_bmcr =3D 0;
>         priv->presvd_phy_advertise =3D 0;
>
> -       ret =3D ax88772_init_mdio(dev);
> +       ret =3D ax88772_mdio_register(dev);
>         if (ret)
>                 return ret;
>
> --
> 2.39.2
>
