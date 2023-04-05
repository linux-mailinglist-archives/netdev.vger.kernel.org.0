Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755166D8376
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjDEQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDEQTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:19:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3812410D8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:19:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q102so34477991pjq.3
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 09:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680711562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsNKztUwvrgNAyta9cArzHzTsVyuxlP7iqWLvxSy6Jw=;
        b=WuVeC81hkhGoHLMoHtvVU7VUPB5bBFGc8cK8QK6yXy64mfr5zN8RSFsSFDFycImtfo
         y6QjvpXMEiIAkxDEZlM6nAaEFYzBKx8Ru4tw6iuxWRaPJbx11fGkH9Lxyj2nOuh+9ZAc
         /htwgGAqollEB8PMksvc6FC0E03nWNJpUxQ3HxVbDc2Ufyt7VdbglC/VCw7VfwuBsFeQ
         NovbACJG+tIoggaoq+EzWjT5+ghEpMNUnY4OiobLeysDI57aui68j6Q4GSAIkfKLoRT6
         1K0Rbrht62mN/2BT4xgaVIKvzOzsVdx9RUy3K/FTpUzTZIqJaCMSR05GFxp1eykBnnDF
         NzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsNKztUwvrgNAyta9cArzHzTsVyuxlP7iqWLvxSy6Jw=;
        b=psSE5H5i5GWbt+2dqOF64ONJ+SqClIqwPuf2cQcdqm1HLJIRlT/f4uUOdPyitnqvI9
         opugrOI5iZr7Tcbkqz0CAvEVi0kRv1HNzP3ZpQaIwyxByYe8bNr/1jG2ka+Aw0NBpde6
         tmJqlBVMqBDeEh6WjJKQqf4Rfe8bq+s77aohGPy24fAGDRIzIz4GZGBX3KUmjP6Rq3QQ
         XSEoyZ2BnHx4imd3Xp/A9rUO0EFzFhjMTkf4ZTcN6SNMGcr5l5gsv8EnLN3gPAgWVPUX
         /kNiccyGaPcJ16ZGdI3hbrcqeSUUlMlp5gK17aJa7CwW40Csn4jg7eu0IrCTPA/8kD9k
         tKkw==
X-Gm-Message-State: AAQBX9d/P9+YUTXO5lXVU8JJHvdLAF/JVbLLTMgYFUvr+y7vIfkiC0gH
        wZTwgdNi7lq20vLf5d1Ui/DUWbGZFogK989QUZI=
X-Google-Smtp-Source: AKy350ZaMEai1148HhgIgb2QcWzHD4deyusc40FV7ynYTvUBja5fgVcfEyd3xENG6Yc9tc8zV2xZeHqDidrgpok/0U4=
X-Received: by 2002:a17:90b:1014:b0:23f:695a:1355 with SMTP id
 gm20-20020a17090b101400b0023f695a1355mr2521347pjb.5.1680711562439; Wed, 05
 Apr 2023 09:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063323.36270-1-glipus@gmail.com> <20230405122628.4nxnja3hts4axzt5@skbuf>
In-Reply-To: <20230405122628.4nxnja3hts4axzt5@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 5 Apr 2023 10:19:11 -0600
Message-ID: <CAP5jrPEcO8Xdjby=BHwPjBdCHaY1ajg6EZch=ZMx40DTFV0gLA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code path
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 6:26=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Wed, Apr 05, 2023 at 12:33:23AM -0600, Maxim Georgiev wrote:
> > This patch makes VLAN subsystem to use the newly introduced
> > ndo_hwtstamp_get/set API to pass hw timestamp requests to
> > underlying NIC drivers in case if these drivers implement
> > ndo_hwtstamp_get/set functions. Otherwise VLAN=E2=94=AC=C4=9Asubsystem
>
> Strange symbols (=E2=94=AC=C4=9A).

Bad copy-paste, sorry. Fixed.

>
> > falls back to calling ndo_eth_ioctl.
> >
> > Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> > ---
> >  net/8021q/vlan_dev.c | 42 +++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> > index 5920544e93e8..66d54c610aa5 100644
> > --- a/net/8021q/vlan_dev.c
> > +++ b/net/8021q/vlan_dev.c
> > @@ -353,6 +353,44 @@ static int vlan_dev_set_mac_address(struct net_dev=
ice *dev, void *p)
> >       return 0;
> >  }
> >
> > +static int vlan_dev_hwtstamp(struct net_device *dev, struct ifreq *ifr=
, int cmd)
> > +{
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     struct kernel_hwtstamp_config kernel_config =3D {};
> > +     struct hwtstamp_config config;
> > +     int err;
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     if ((cmd =3D=3D SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set) ||
> > +         (cmd =3D=3D SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get)) {
> > +             if (ops->ndo_eth_ioctl) {
> > +                     return ops->ndo_eth_ioctl(real_dev, &ifr, cmd);
> > +             else
> > +                     return -EOPNOTSUPP;
> > +     }
> > +
> > +     kernel_config.ifr =3D ifr;
> > +     if (cmd =3D=3D SIOCSHWTSTAMP) {
> > +             if (copy_from_user(&config, ifr->ifr_data, sizeof(config)=
))
> > +                     return -EFAULT;
> > +
> > +             hwtstamp_config_to_kernel(&kernel_config, &config);
> > +             err =3D ops->ndo_hwtstamp_set(dev, &kernel_config, NULL);
> > +     } else if (cmd =3D=3D SIOCGHWTSTAMP) {
> > +             err =3D ops->ndo_hwtstamp_get(dev, &kernel_config, NULL);
> > +     }
> > +
> > +     if (err)
> > +             return err;
> > +
> > +     hwtstamp_kernel_to_config(&config, &kernel_config);
> > +     if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> > +             return -EFAULT;
> > +     return 0;
> > +}
> > +
> >  static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, i=
nt cmd)
> >  {
> >       struct net_device *real_dev =3D vlan_dev_priv(dev)->real_dev;
> > @@ -368,10 +406,12 @@ static int vlan_dev_ioctl(struct net_device *dev,=
 struct ifreq *ifr, int cmd)
> >               if (!net_eq(dev_net(dev), dev_net(real_dev)))
> >                       break;
> >               fallthrough;
> > +     case SIOCGHWTSTAMP:
> > +             err =3D vlan_dev_hwtstamp(real_dev, &ifrr, cmd);
> > +             break;
> >       case SIOCGMIIPHY:
> >       case SIOCGMIIREG:
> >       case SIOCSMIIREG:
> > -     case SIOCGHWTSTAMP:
>
> I would recommend also making vlan_dev_hwtstamp() be called from the
> VLAN driver's ndo_hwtstamp_set() rather than from ndo_eth_ioctl().

Vladimir, could you please elaborate here a bit?
Are you saying that I should go all the way with vlan NDO conversion,
implement ndo_hwtstamp_get/set() for vlan, and stop handling
SIOCGHWTSTAMP/SIOCSHWTSTAMP in vlan_dev_ioctl()?

>
> My understanding of Jakub's suggestion to (temporarily) stuff ifr
> inside kernel_config was to do that from top-level net/core/dev_ioctl.c,
> not from the VLAN driver.

[RFC PATCH v3 2/5] in this patch stack changes net/core/dev_ioctl.c
to insert ifr inside kernel_config. I assumed that I should do it here too
so underlying drivers could rely on ifr pointer in kernel_config being
always initialized.
If the plan is to stop supporting SIOCGHWTSTAMP/SIOCSHWTSTAMP
in vlan_dev_ioctl() all together and move the hw timestamp handling
logic to vlan_get/set_hwtstamp() functions, then this ifr initialization
code will be removed from net/8021q/vlan_dev.c anyway.

>
> >               if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
> >                       err =3D ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
> >               break;
> > --
> > 2.39.2
> >
