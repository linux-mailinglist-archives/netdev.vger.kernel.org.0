Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088C26D3B46
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDCBLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCBLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:11:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B519EFD
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 18:11:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so30893834pjp.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 18:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680484263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOU3YS3W/wFeFbPhXHeFuN8oqnD4yVZI5UUR6fWqZc0=;
        b=ZKv2418GA567crpQXsE6vHredG7wvNRH19ClgpHwS5ngTEGpAkeKwWPQ9dicl1QWFL
         xILlxaIHn9su3m9StuCgezZBKwUrHQ6BRl73wKXYsC77uzztN9ILG5ehfKirWWp46xf2
         egmNixsqy6yYAioTGSFeBqGe42obo2nTzq0nCSVGTOBrqIiDWc0bhFV5TrbuXoH2LUMX
         /Q9qHlKlCO+yTjV/pM3sOs28mHvdU3JN9ksxdZ5IpVxwYQbzCgi1OlwlDYIYHeY+NN/V
         KMqpHkdmV+QvGrFp76WdddiXRLo5r5Etk6pCZqFrSgVH2hS5AZo1Thi0XF01oU/QfV1c
         NV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680484263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rOU3YS3W/wFeFbPhXHeFuN8oqnD4yVZI5UUR6fWqZc0=;
        b=YMFKthtDsXn1GLL0ueOJfANpbSYzp4FY2GK/c/yeGMmQo2OSd32dkH4ZcEasNsVJoM
         IgGMdGi43NK7cpqf5Um9t109smZV3hpoVRQDKCWW/zZeMrxiTwYGzl4DsclaMTiMYbxU
         2zelzoSq9KTB8y0uNxrTjZuMf8Dq9kfBbpcfdfdevccVEcBxRdeO/LRKhh/n/7mTzzCB
         4fyDzYAA2z6hqBRfzM3oU+++QTx5sPPJDr2Ib693T4XEpfHRYd7RHn8RiEwaavwuuW3D
         +/bZ2JS5ncRC2tHqIUenDxSsJQf/RGp12PzxDd4UtvzqnknCrurz4TTaxOIcnL0YByzh
         DoVA==
X-Gm-Message-State: AAQBX9fbBuJApmvh2NBByUlS833HVZ3tqH9EiXRKl4Ci1tynT4GgTDZw
        SvK/gV7S+Vd7oitJ51pIvJDqHyv2XP5ijORNlgg=
X-Google-Smtp-Source: AKy350YDhsWF0RKPgOMfYBXBL1W2cjH7kIWe53/FbjZSx5uXZR22NvfUNI6ReOvzdmTko5fRuxPdrR3qJV40fXn4lYA=
X-Received: by 2002:a17:902:aa48:b0:1a0:4847:864c with SMTP id
 c8-20020a170902aa4800b001a04847864cmr12334801plr.13.1680484263163; Sun, 02
 Apr 2023 18:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230402142435.47105-1-glipus@gmail.com> <a9f0f57f-a73c-72dd-3fc6-fe22e2d3e466@engleder-embedded.com>
In-Reply-To: <a9f0f57f-a73c-72dd-3fc6-fe22e2d3e466@engleder-embedded.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Sun, 2 Apr 2023 19:10:52 -0600
Message-ID: <CAP5jrPEAFHGm3uN9c_zHrbZFJDE=b8d6SwmbE8h7-iSJrzhkZQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
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

On Sun, Apr 2, 2023 at 12:23=E2=80=AFPM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> On 02.04.23 16:24, Maxim Georgiev wrote:
> > Current NIC driver API demands drivers supporting hardware timestamping
> > to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
> > requires dirivers to implement request parameter structure translation
>
> dirivers -> drivers

Thank you for catching it!

>
> > between user and kernel address spaces, handling possible
> > translation failures, etc. This translation code is pretty much
> > identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> > SIOCSHWTSTAMP.
> > This patch extends NDO functiuon set with ndo_hwtstamp_get/set
>
> functiuon -> function

My bad. Thank you for catching it!

>
> > functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> > to ndo_hwtstamp_get/set function calls including parameter structure
> > translation and translation error handling.
> >
> > This patch is sent out as RFC.
> > It still pending on basic testing. Implementing ndo_hwtstamp_get/set
> > in netdevsim driver should allow manual testing of the request
> > translation logic. Also is there a way to automate this testing?
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> > ---
> > Changes in v2:
> > - Introduced kernel_hwtstamp_config structure
> > - Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestam=
p
> >    function parameters
> > - Reodered function variable declarations in dev_hwtstamp()
> > - Refactored error handling logic in dev_hwtstamp()
> > - Split dev_hwtstamp() into GET and SET versions
> > - Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
> >    as a parameter
> > ---
> >   drivers/net/ethernet/intel/e1000e/netdev.c | 39 ++++++-----
> >   drivers/net/netdevsim/netdev.c             | 26 +++++++
> >   drivers/net/netdevsim/netdevsim.h          |  1 +
> >   include/linux/netdevice.h                  | 21 ++++++
> >   include/uapi/linux/net_tstamp.h            | 15 ++++
> >   net/core/dev_ioctl.c                       | 81 ++++++++++++++++++---=
-
> >   6 files changed, 149 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/e=
thernet/intel/e1000e/netdev.c
> > index 6f5c16aebcbf..5b98f7257c77 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -6161,7 +6161,9 @@ static int e1000_mii_ioctl(struct net_device *net=
dev, struct ifreq *ifr,
> >   /**
> >    * e1000e_hwtstamp_set - control hardware time stamping
> >    * @netdev: network interface device structure
> > - * @ifr: interface request
> > + * @config: hwtstamp_config structure containing request parameters
> > + * @kernel_config: kernel version of config parameter structure.
> > + * @extack: netlink request parameters.
>
> '.' at end of parameter line or not? You mixed it.

What was I thinking!
Let me remove the periods since the original parameter descriptions
didn't have them.

>
> >    *
> >    * Outgoing time stamping can be enabled and disabled. Play nice and
> >    * disable it when requested, although it shouldn't cause any overhea=
d
> > @@ -6174,20 +6176,19 @@ static int e1000_mii_ioctl(struct net_device *n=
etdev, struct ifreq *ifr,
> >    * specified. Matching the kind of event packet is not supported, wit=
h the
> >    * exception of "all V2 events regardless of level 2 or 4".
> >    **/
> > -static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq=
 *ifr)
> > +static int e1000e_hwtstamp_set(struct net_device *netdev,
> > +                            struct hwtstamp_config *config,
> > +                            struct kernel_hwtstamp_config *kernel_conf=
ig,
> > +                            struct netlink_ext_ack *extack)
> >   {
> >       struct e1000_adapter *adapter =3D netdev_priv(netdev);
> > -     struct hwtstamp_config config;
> >       int ret_val;
> >
> > -     if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> > -             return -EFAULT;
> > -
> > -     ret_val =3D e1000e_config_hwtstamp(adapter, &config);
> > +     ret_val =3D e1000e_config_hwtstamp(adapter, config);
> >       if (ret_val)
> >               return ret_val;
> >
> > -     switch (config.rx_filter) {
> > +     switch (config->rx_filter) {
> >       case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> >       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> >       case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > @@ -6199,22 +6200,24 @@ static int e1000e_hwtstamp_set(struct net_devic=
e *netdev, struct ifreq *ifr)
> >                * by hardware so notify the caller the requested packets=
 plus
> >                * some others are time stamped.
> >                */
> > -             config.rx_filter =3D HWTSTAMP_FILTER_SOME;
> > +             config->rx_filter =3D HWTSTAMP_FILTER_SOME;
> >               break;
> >       default:
> >               break;
> >       }
> > -
> > -     return copy_to_user(ifr->ifr_data, &config,
> > -                         sizeof(config)) ? -EFAULT : 0;
> > +     return ret_val;
>
> I would expect 'return 0;'.

Makes perfect sense. Let me fix that.

>
> >   }
> >
> > -static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq=
 *ifr)
> > +static int e1000e_hwtstamp_get(struct net_device *netdev,
> > +                            struct hwtstamp_config *config,
> > +                            struct kernel_hwtstamp_config *kernel_conf=
ig,
> > +                            struct netlink_ext_ack *extack)
> >   {
> >       struct e1000_adapter *adapter =3D netdev_priv(netdev);
> >
> > -     return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> > -                         sizeof(adapter->hwtstamp_config)) ? -EFAULT :=
 0;
> > +     memcpy(config, &adapter->hwtstamp_config,
> > +            sizeof(adapter->hwtstamp_config));
> > +     return 0;
> >   }
> >
> >   static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, =
int cmd)
> > @@ -6224,10 +6227,6 @@ static int e1000_ioctl(struct net_device *netdev=
, struct ifreq *ifr, int cmd)
> >       case SIOCGMIIREG:
> >       case SIOCSMIIREG:
> >               return e1000_mii_ioctl(netdev, ifr, cmd);
> > -     case SIOCSHWTSTAMP:
> > -             return e1000e_hwtstamp_set(netdev, ifr);
> > -     case SIOCGHWTSTAMP:
> > -             return e1000e_hwtstamp_get(netdev, ifr);
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> > @@ -7365,6 +7364,8 @@ static const struct net_device_ops e1000e_netdev_=
ops =3D {
> >       .ndo_set_features =3D e1000_set_features,
> >       .ndo_fix_features =3D e1000_fix_features,
> >       .ndo_features_check     =3D passthru_features_check,
> > +     .ndo_hwtstamp_get       =3D e1000e_hwtstamp_get,
> > +     .ndo_hwtstamp_set       =3D e1000e_hwtstamp_set,
> >   };
> >
> >   /**
> > diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/net=
dev.c
> > index 35fa1ca98671..502715c6e9e1 100644
> > --- a/drivers/net/netdevsim/netdev.c
> > +++ b/drivers/net/netdevsim/netdev.c
> > @@ -238,6 +238,30 @@ nsim_set_features(struct net_device *dev, netdev_f=
eatures_t features)
> >       return 0;
> >   }
> >
> > +static int
> > +nsim_hwtstamp_get(struct net_device *dev,
> > +               struct hwtstamp_config *config,
> > +               struct kernel_hwtstamp_config *kernel_config,
> > +               struct netlink_ext_ack *extack)
> > +{
> > +     struct netdevsim *ns =3D netdev_priv(dev);
> > +
> > +     memcpy(config, &ns->hw_tstamp_config, sizeof(ns->hw_tstamp_config=
));
> > +     return 0;
> > +}
> > +
> > +static int
> > +nsim_hwtstamp_ges(struct net_device *dev,
>
> nsim_hwtstamp_ges -> nsim_hwtstamp_get

This was intended to be nsim_hwtstamp_set(). But nevertheless I got it wron=
g.
Fixing it...

>
> > +               struct hwtstamp_config *config,
> > +               struct kernel_hwtstamp_config *kernel_config,
> > +               struct netlink_ext_ack *extack)
> > +{
> > +     struct netdevsim *ns =3D netdev_priv(dev);
> > +
> > +     memcpy(&ns->hw_tstamp_config, config, sizeof(ns->hw_tstamp_config=
));
> > +     return 0;
> > +}
> > +
> >   static const struct net_device_ops nsim_netdev_ops =3D {
> >       .ndo_start_xmit         =3D nsim_start_xmit,
> >       .ndo_set_rx_mode        =3D nsim_set_rx_mode,
> > @@ -256,6 +280,8 @@ static const struct net_device_ops nsim_netdev_ops =
=3D {
> >       .ndo_setup_tc           =3D nsim_setup_tc,
> >       .ndo_set_features       =3D nsim_set_features,
> >       .ndo_bpf                =3D nsim_bpf,
> > +     .ndo_hwtstamp_get       =3D nsim_hwtstamp_get,
> > +     .ndo_hwtstamp_set       =3D nsim_hwtstamp_get,
>
> nsim_hwtstamp_get -> nsim_hwtstamp_set

Aha, this one masked the previous error you caught.
Thank you for pointing it out!

>
> >   };
> >
> >   static const struct net_device_ops nsim_vf_netdev_ops =3D {
> > diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/=
netdevsim.h
> > index 7d8ed8d8df5c..c6efd2383552 100644
> > --- a/drivers/net/netdevsim/netdevsim.h
> > +++ b/drivers/net/netdevsim/netdevsim.h
> > @@ -102,6 +102,7 @@ struct netdevsim {
> >       } udp_ports;
> >
> >       struct nsim_ethtool ethtool;
> > +     struct hwtstamp_config hw_tstamp_config;
> >   };
> >
> >   struct netdevsim *
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index c8c634091a65..078c9284930a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -57,6 +57,8 @@
> >   struct netpoll_info;
> >   struct device;
> >   struct ethtool_ops;
> > +struct hwtstamp_config;
> > +struct kernel_hwtstamp_config;
> >   struct phy_device;
> >   struct dsa_port;
> >   struct ip_tunnel_parm;
> > @@ -1411,6 +1413,17 @@ struct netdev_net_notifier {
> >    *  Get hardware timestamp based on normal/adjustable time or free ru=
nning
> >    *  cycle counter. This function is required if physical clock suppor=
ts a
> >    *  free running cycle counter.
> > + *   int (*ndo_hwtstamp_get)(struct net_device *dev,
> > + *                           struct hwtstamp_config *config,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Get hardware timestamping parameters currently configured  for NI=
C
>
> 'configured  for' -> 'configured for'

Removing this double whitespace. Thank you!

>
> > + *   device.
> > + *   int (*ndo_hwtstamp_set)(struct net_device *dev,
> > + *                           struct hwtstamp_config *config,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Set hardware timestamping parameters for NIC device.
> >    */
> >   struct net_device_ops {
> >       int                     (*ndo_init)(struct net_device *dev);
> > @@ -1645,6 +1658,14 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared=
_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     int                     (*ndo_hwtstamp_get)(struct net_device *de=
v,
> > +                                                 struct hwtstamp_confi=
g *config,
> > +                                                 struct kernel_hwtstam=
p_config *kernel_config,
> > +                                                 struct netlink_ext_ac=
k *extack);
> > +     int                     (*ndo_hwtstamp_set)(struct net_device *de=
v,
> > +                                                 struct hwtstamp_confi=
g *config,
> > +                                                 struct kernel_hwtstam=
p_config *kernel_config,
> > +                                                 struct netlink_ext_ac=
k *extack);
> >   };
> >
> >   struct xdp_metadata_ops {
> > diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_t=
stamp.h
> > index a2c66b3d7f0f..547f73beb479 100644
> > --- a/include/uapi/linux/net_tstamp.h
> > +++ b/include/uapi/linux/net_tstamp.h
> > @@ -79,6 +79,21 @@ struct hwtstamp_config {
> >       int rx_filter;
> >   };
> >
> > +/**
> > + * struct kernel_hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP p=
arameter
> > + *
> > + * @dummy:   a placeholder field added to work around empty struct lan=
guage
> > + *           restriction
> > + *
> > + * This structure passed as a parameter to NDO methods called in
> > + * response to SIOCGHWTSTAMP and SIOCSHWTSTAMP IOCTLs.
> > + * The structure is effectively empty for now. Before adding new field=
s
> > + * to the structure "dummy" placeholder field should be removed.
> > + */
> > +struct kernel_hwtstamp_config {
> > +     u8 dummy;
> > +};
> > +
> >   /* possible values for hwtstamp_config->flags */
> >   enum hwtstamp_flags {
> >       /*
> > diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> > index 846669426236..c145afb3f77e 100644
> > --- a/net/core/dev_ioctl.c
> > +++ b/net/core/dev_ioctl.c
> > @@ -183,22 +183,18 @@ static int dev_ifsioc_locked(struct net *net, str=
uct ifreq *ifr, unsigned int cm
> >       return err;
> >   }
> >
> > -static int net_hwtstamp_validate(struct ifreq *ifr)
> > +static int net_hwtstamp_validate(struct hwtstamp_config *cfg)
> >   {
> > -     struct hwtstamp_config cfg;
> >       enum hwtstamp_tx_types tx_type;
> >       enum hwtstamp_rx_filters rx_filter;
> >       int tx_type_valid =3D 0;
> >       int rx_filter_valid =3D 0;
> >
> > -     if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > -             return -EFAULT;
> > -
> > -     if (cfg.flags & ~HWTSTAMP_FLAG_MASK)
> > +     if (cfg->flags & ~HWTSTAMP_FLAG_MASK)
> >               return -EINVAL;
> >
> > -     tx_type =3D cfg.tx_type;
> > -     rx_filter =3D cfg.rx_filter;
> > +     tx_type =3D cfg->tx_type;
> > +     rx_filter =3D cfg->rx_filter;
> >
> >       switch (tx_type) {
> >       case HWTSTAMP_TX_OFF:
> > @@ -277,6 +273,63 @@ static int dev_siocbond(struct net_device *dev,
> >       return -EOPNOTSUPP;
> >   }
> >
> > +static int dev_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     struct hwtstamp_config config;
> > +     int err;
> > +
> > +     err =3D dsa_ndo_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> > +     if (err =3D=3D 0 || err !=3D -EOPNOTSUPP)
> > +             return err;
> > +
> > +     if (!ops->ndo_hwtstamp_get)
> > +             return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     err =3D ops->ndo_hwtstamp_get(dev, &config, NULL, NULL);
> > +     if (err)
> > +             return err;
> > +
> > +     if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> > +             return -EFAULT;
> > +     return 0;
> > +}
> > +
> > +static int dev_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     struct hwtstamp_config config;
> > +     int err;
> > +
> > +     if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> > +             return -EFAULT;
> > +
> > +     err =3D net_hwtstamp_validate(&config);
> > +     if (err)
> > +             return err;
> > +
> > +     err =3D dsa_ndo_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> > +     if (err =3D=3D 0 || err !=3D -EOPNOTSUPP)
> > +             return err;
> > +
> > +     if (!ops->ndo_hwtstamp_set)
> > +             return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     err =3D ops->ndo_hwtstamp_set(dev, &config, NULL, NULL);
> > +     if (err)
> > +             return err;
> > +
> > +     if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> > +             return -EFAULT;
> > +     return 0;
> > +}
> > +
> >   static int dev_siocdevprivate(struct net_device *dev, struct ifreq *i=
fr,
> >                             void __user *data, unsigned int cmd)
> >   {
> > @@ -391,11 +444,11 @@ static int dev_ifsioc(struct net *net, struct ifr=
eq *ifr, void __user *data,
> >               rtnl_lock();
> >               return err;
> >
> > +     case SIOCGHWTSTAMP:
> > +             return dev_hwtstamp_get(dev, ifr);
> > +
> >       case SIOCSHWTSTAMP:
> > -             err =3D net_hwtstamp_validate(ifr);
> > -             if (err)
> > -                     return err;
> > -             fallthrough;
> > +             return dev_hwtstamp_set(dev, ifr);
> >
> >       /*
> >        *      Unknown or private ioctl
> > @@ -407,9 +460,7 @@ static int dev_ifsioc(struct net *net, struct ifreq=
 *ifr, void __user *data,
> >
> >               if (cmd =3D=3D SIOCGMIIPHY ||
> >                   cmd =3D=3D SIOCGMIIREG ||
> > -                 cmd =3D=3D SIOCSMIIREG ||
> > -                 cmd =3D=3D SIOCSHWTSTAMP ||
> > -                 cmd =3D=3D SIOCGHWTSTAMP) {
> > +                 cmd =3D=3D SIOCSMIIREG) {
> >                       err =3D dev_eth_ioctl(dev, ifr, cmd);
> >               } else if (cmd =3D=3D SIOCBONDENSLAVE ||
> >                   cmd =3D=3D SIOCBONDRELEASE ||

Gerhard, thank you for reviewing the patch and highlighting all these error=
s!
I'll incorporate the fixes to ver 3 of the patch.
