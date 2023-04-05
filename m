Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4153B6D82BA
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbjDEPzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbjDEPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:54:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1337C0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 08:54:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so37733869pjt.5
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 08:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680710079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/5UBm27GZKM3EkuZCkFzeZVNo0sTRXRQ+IN0GcXsno=;
        b=S7DsmHV7Gg9eQv6xP0UYhcW3t0QvtuwFoYeZXMUiAajo75f2KGfkVzcZcK1gwbUHwf
         DnatgumrKtmK+0tz2Xw1X0qVcpnTrBkQT2efIh2Y4C5Aj+a2/QbCy7ugWji55Jo5htCp
         +PJd6suvh1XADYgJhbWQ7cEy73Eghnmj5AtrbdOH7ZBJJXIlkA/jMH35KgT4sriXf3iU
         I/nEVFT1VCN/OPRcTkqcrObB8UvSrUOhUjsXgtL3fTkXLKNoBkU6kyTNlf1faMOAu9fx
         C+yychjlxbv8dvfR+N4LdFGsFl1WPl06naqHr/cFxxUTkwPW+A/jUAPzZTz8jusDGFQb
         pKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/5UBm27GZKM3EkuZCkFzeZVNo0sTRXRQ+IN0GcXsno=;
        b=nYQxG62nLlS1irFM9XMYIzSvWh6nmKnAfeaejrxX4y0cvvASEl75H6HP9iBDG2VMNH
         CC1gC0Ynq98cQMC/uLk7od8QvPK2mWD6U+0wNhabwjeFASfOZPQit0YsbN/iJAJV/VlV
         UKICN2KMJPf5dZIWrota9wDiGtYkjYu5TLf66/1ffCENA2GUll23zjPLPwlZPXxyPbFe
         QcFesXKgX4ib0TeAIgQPnISO3v3VvDfgrDCRSUzmnHZD+r3FBKkHVmwpa3YSDdj7XWWO
         GvE66vfDrXe8VA6kfwiM69/6aKOPQKXxFUZ6fd6zzT+IuPt7+ser2OemrPJawP3zETAD
         jQDQ==
X-Gm-Message-State: AAQBX9dkh3sGBh/OEi7WhdBVzpPkIMhO3d/dtcfLvbY0yCMQAwbL8SC/
        KW75BgiFs2YjOCwugdkiLpPuFOpHxRhWNnqYkxg=
X-Google-Smtp-Source: AKy350YiytzqyXrwxcY9FlyEu9MWYSRT8MSpn8mMd5mngrGf0JPLXA+qUfZI1k20P2fOvsF/ys2XQ5RuYFt10ZhO52c=
X-Received: by 2002:a17:903:453:b0:1a2:6e4d:782c with SMTP id
 iw19-20020a170903045300b001a26e4d782cmr2615567plb.13.1680710078920; Wed, 05
 Apr 2023 08:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063144.36231-1-glipus@gmail.com> <20230405123130.5wjeiienp5m6odhr@skbuf>
In-Reply-To: <20230405123130.5wjeiienp5m6odhr@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 5 Apr 2023 09:54:27 -0600
Message-ID: <CAP5jrPH__dJpGepM6Vs45PH+Pppx6KOVnUDS5f44DGeyseghfQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
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

On Wed, Apr 5, 2023 at 6:31=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Wed, Apr 05, 2023 at 12:31:44AM -0600, Maxim Georgiev wrote:
> > Current NIC driver API demands drivers supporting hardware timestamping
> > to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> > Handling these IOCTLs requires dirivers to implement request parameter
> > structure translation between user and kernel address spaces, handling
> > possible translation failures, etc. This translation code is pretty muc=
h
> > identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> > SIOCSHWTSTAMP.
> > This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> > functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> > to ndo_hwtstamp_get/set function calls including parameter structure
> > translation and translation error handling.
> >
> > This patch is sent out as RFC.
> > It still pending on basic testing.
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> > ---
> > Changes in v3:
> > - Moved individual driver conversions to separate patches
> >
> > Changes in v2:
> > - Introduced kernel_hwtstamp_config structure
> > - Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestam=
p
> >   function parameters
> > - Reodered function variable declarations in dev_hwtstamp()
> > - Refactored error handling logic in dev_hwtstamp()
> > - Split dev_hwtstamp() into GET and SET versions
> > - Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
> >   as a parameter
> > ---
> >  include/linux/net_tstamp.h |  8 ++++++++
> >  include/linux/netdevice.h  | 16 ++++++++++++++++
> >  net/core/dev_ioctl.c       | 36 ++++++++++++++++++++++++++++++++++--
> >  3 files changed, 58 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
> > index fd67f3cc0c4b..063260475e77 100644
> > --- a/include/linux/net_tstamp.h
> > +++ b/include/linux/net_tstamp.h
> > @@ -30,4 +30,12 @@ static inline void hwtstamp_config_to_kernel(struct =
kernel_hwtstamp_config *kern
> >       kernel_cfg->rx_filter =3D cfg->rx_filter;
> >  }
> >
> > +static inline void hwtstamp_kernel_to_config(struct hwtstamp_config *c=
fg,
> > +                                          const struct kernel_hwtstamp=
_config *kernel_cfg)
>
> The reason why I suggested the name "hwtstamp_config_from_kernel()" was
> to not break apart "hwtstamp" and "config", which together form the name
> of one structure (hwtstamp_config).
>

Sorry I missed you referred the exact function name in your previous commen=
ts.
Will be happy to rename.

> > +{
> > +     cfg->flags =3D kernel_cfg->flags;
> > +     cfg->tx_type =3D kernel_cfg->tx_type;
> > +     cfg->rx_filter =3D kernel_cfg->rx_filter;
> > +}
> > +
> >  #endif /* _LINUX_NET_TIMESTAMPING_H_ */
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index a740be3bb911..8356002d0ac0 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -57,6 +57,7 @@
> >  struct netpoll_info;
> >  struct device;
> >  struct ethtool_ops;
> > +struct kernel_hwtstamp_config;
> >  struct phy_device;
> >  struct dsa_port;
> >  struct ip_tunnel_parm;
> > @@ -1412,6 +1413,15 @@ struct netdev_net_notifier {
> >   *   Get hardware timestamp based on normal/adjustable time or free ru=
nning
> >   *   cycle counter. This function is required if physical clock suppor=
ts a
> >   *   free running cycle counter.
> > + *   int (*ndo_hwtstamp_get)(struct net_device *dev,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Get hardware timestamping parameters currently configured for NIC
> > + *   device.
> > + *   int (*ndo_hwtstamp_set)(struct net_device *dev,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Set hardware timestamping parameters for NIC device.
> >   */
> >  struct net_device_ops {
> >       int                     (*ndo_init)(struct net_device *dev);
> > @@ -1646,6 +1656,12 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared=
_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     int                     (*ndo_hwtstamp_get)(struct net_device *de=
v,
> > +                                                 struct kernel_hwtstam=
p_config *kernel_config,
> > +                                                 struct netlink_ext_ac=
k *extack);
> > +     int                     (*ndo_hwtstamp_set)(struct net_device *de=
v,
> > +                                                 struct kernel_hwtstam=
p_config *kernel_config,
> > +                                                 struct netlink_ext_ac=
k *extack);
> >  };
> >
> >  struct xdp_metadata_ops {
> > diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> > index 6d772837eb3f..736f310a0661 100644
> > --- a/net/core/dev_ioctl.c
> > +++ b/net/core/dev_ioctl.c
> > @@ -254,11 +254,30 @@ static int dev_eth_ioctl(struct net_device *dev,
> >
> >  static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> >  {
> > -     return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     struct kernel_hwtstamp_config kernel_cfg;
>
> Should we zero-initialize kernel_cfg (" =3D {}"), in case the driver does
> not bother to populate, say, "flags"?

I've added kernel_cfg zero-initialization in [RFC PATCH v3 2/5].
But your comment makes sense.
Let me move the initialization to this patch.

>
> > +     struct hwtstamp_config config;
> > +     int err;
> > +
> > +     if (!ops->ndo_hwtstamp_get)
> > +             return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     err =3D ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
> > +     if (err)
> > +             return err;
> > +
> > +     hwtstamp_kernel_to_config(&config, &kernel_cfg);
> > +     if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> > +             return -EFAULT;
> > +     return 0;
> >  }
> >
> >  static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> >  {
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> >       struct netdev_notifier_hwtstamp_info info =3D {
> >               .info.dev =3D dev,
> >       };
> > @@ -288,7 +307,20 @@ static int dev_set_hwtstamp(struct net_device *dev=
, struct ifreq *ifr)
> >               return err;
> >       }
> >
> > -     return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> > +     if (!ops->ndo_hwtstamp_set)
> > +             return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     err =3D ops->ndo_hwtstamp_set(dev, &kernel_cfg, NULL);
> > +     if (err)
> > +             return err;
> > +
> > +     hwtstamp_kernel_to_config(&cfg, &kernel_cfg);
>
> Cosmetic blank line here
>
> > +     if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
> > +             return -EFAULT;
>
> and here?
>
> (and in equivalent positions in dev_get_hwtstamp())

Thank you for pointing it out, I'll add the blank lines around these ifs.

>
> > +     return 0;
> >  }
> >
> >  static int dev_siocbond(struct net_device *dev,
> > --
> > 2.39.2
> >

Vladimir, thank you for the feedback!
