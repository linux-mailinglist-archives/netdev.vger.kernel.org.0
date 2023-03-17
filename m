Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8506BF044
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCQR7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCQR7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:59:11 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B582942A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:59:09 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3ed5cf9a455so56725e9.1
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679075948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjvTte7bz790I4DeoccGypf45T5SSdILVtKRKvCiFOI=;
        b=EiNd16NuxHMFHB8ctHAXApT18HqEP/MdXDPr2xnMxoD1lwuNdMZhlZjzYNoP5JAhye
         jPCSCKpLbjXQq5dSNifqsuUuHUYIP2o8tyNXn9Xj6a9Hm30Fm5nITDHlOfbB5y9djsSU
         n24l0ALbmhr/8jlrXM9LAcnxiVwzIOs0hRiCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679075948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjvTte7bz790I4DeoccGypf45T5SSdILVtKRKvCiFOI=;
        b=mM4UX4EptitoT/lgLzogbAHMB/CQSKDJOFRgbcYI3IBGka6yKlyU7ZybuK9TpkrkAw
         mj5A4w/OcELJnZOZCfUv5RyRWQYz2wjzp9m8XwUgRmnrEQYBNnTAC9ZgKoOtsh3ukOLS
         UBZdJ6nj+zxFW6mL67n1TlHjJ1pEtIeSWxGNskEDVVLgJl5BsuSIDbnYahhfcMJrRqXO
         n2gLryTx5zeICptejFrR89mVjyMPDKGYRrGiRGKcRKpwmG0EsWv3awWgKIEaNfHbUuqk
         f4DqAf5iagF3VACieSV2pCj+8/w95Lr1GXPrOJJCPIvU2W6uMRCiz31Z0h+p6wVGDevD
         TXAQ==
X-Gm-Message-State: AO0yUKWHsfBGH2t43OH5ZfCbs8d7R0j92uxCk6wd/mnjmCyX1EK2afgv
        oSFcu+Lb+vwq7BQbgCjEr4YZVWvXDE6nVlNT2ZzKEw==
X-Google-Smtp-Source: AK7set9e34KRiIz2HRwC5yN5XBvua7H4JERtmCm0RF+b7/ldiI4eo4W76D8K0TRd0iAc0fFvvaZyKu5z80jjulMa5QU=
X-Received: by 2002:a05:600c:3589:b0:3e2:1a5e:b13c with SMTP id
 p9-20020a05600c358900b003e21a5eb13cmr961wmq.2.1679075947629; Fri, 17 Mar 2023
 10:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230314055410.3329480-1-grundler@chromium.org> <20230315220822.6d8cf7ed@kernel.org>
In-Reply-To: <20230315220822.6d8cf7ed@kernel.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 17 Mar 2023 10:58:55 -0700
Message-ID: <CANEJEGv0fSa9ZqArTDJcSwUpjKrOS=502Uz6C6LRh3gptfTs9g@mail.gmail.com>
Subject: Re: [PATCHv4 net] net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
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

On Wed, Mar 15, 2023 at 10:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Mon, 13 Mar 2023 22:54:10 -0700 Grant Grundler wrote:
> > @@ -690,6 +704,7 @@ static int ax88772_init_phy(struct usbnet *dev)
> >       priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> >       if (!priv->phydev) {
> >               netdev_err(dev->net, "Could not find PHY\n");
> > +             ax88772_mdio_unregister(priv);
>
> this line needs to go now..
>
> >               return -ENODEV;
>
> .. since if we return error here ..
>
> >       }
> >
> > @@ -896,16 +911,23 @@ static int ax88772_bind(struct usbnet *dev, struc=
t usb_interface *intf)
> >
> >       ret =3D ax88772_init_mdio(dev);
> >       if (ret)
> > -             return ret;
> > +             goto mdio_err;
> >
> >       ret =3D ax88772_phylink_setup(dev);
> >       if (ret)
> > -             return ret;
> > +             goto phylink_err;
> >
> >       ret =3D ax88772_init_phy(dev);
>
> .. it will pop out here ..
>
> >       if (ret)
> > -             phylink_destroy(priv->phylink);
> > +             goto initphy_err;
> >
> > +     return 0;
> > +
> > +initphy_err:
> > +     phylink_destroy(priv->phylink);
> > +phylink_err:
> > +     ax88772_mdio_unregister(priv);
>
> .. and then call ax88772_mdio_unregister() a second time.

Doh! Yes - good catch. Let me fix that.

cheers,
grant

>
> > +mdio_err:
> >       return ret;
> >  }
