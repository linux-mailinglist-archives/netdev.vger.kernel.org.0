Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4D6D4C34
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjDCPmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjDCPmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:42:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577EB270A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:42:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bt19so19478331pfb.3
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680536541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E60LF0ckubopoWQMOkaqnj8ZOfmGD3ECAXsYSe+bAns=;
        b=VgIarTfVzAc+DJGrOnsIpkIWlWgkwoE5HXxSRuj+p9FzBJmw4ayfPHiPsdY8iYRpCl
         UOJ8Q6OIzFD6aPoNBfYBYe+/ppBJFNxBJ3P3EjmejJTKx3hAgQ1kyV2LrwmYyw/jQJyu
         f1RuEbmUI1uTUWJr06eMSITDwsuNGKPwp4Y4nfd1YWAdWbsgZV5DKdDvxHpFWePZ4xcy
         0xQGA4J7ETqZWjTTc4kvvGQLaaIg0TuUDVhyUEyePHZ7N65Tz2ATUsYJVJBNQC2XdVuB
         5Otzi1vV9L4ShUaik87clXTpGrBZ4h3T2pNYo9yzZBsU6T9H6Hhv4E/MjXjJovO+hrzj
         gMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680536541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E60LF0ckubopoWQMOkaqnj8ZOfmGD3ECAXsYSe+bAns=;
        b=mUNrJFqSdj99xJvkC+kw5ria5cjOu9Mbw2xUIt//i1u9Q9X5aBgwUGP+/VLsOT+JQ1
         ysnhLxzsDJf+NA0S3WOTel/h64y7R5jdEtq83iwQYAe+DjrwDrwbSOontVfQE8mAeFlg
         tmyocRYCNk4/mO2AvyXJKJ8wiUqD6sj9MDj+dTBTh+FPXLRSoka9g5r/INWVjWMBWuXv
         JQwYu6OP0GfI8qQMdRlR/vMEFmKF4KeCmW3eIEFh3rDhhVg9s01gI5+kt+CUvVwy0fml
         K75JO8BIKnyZOI4N+h0/1Z98HT5Ng/oXt/Zy/DQcny9q9zLqBXVAgVIcKlaI+S9q6a9j
         cGzw==
X-Gm-Message-State: AAQBX9ef05gbA3hg5cGTAeL+VzdLIogkHsqMheYCc1Ek+YAkkfOWiCuD
        cIVTGBRCtcUXsWL3hdjglYHecSjJETAiYSriAhUMPgjE4eCY4g==
X-Google-Smtp-Source: AKy350ZxcHmD+Hdg/QwSZEjhNCIX3pVXNl4HJ4wks9RqJIWcRfnXY8BCd5w4MML3JatqGqoeMlaWrHQeAXlhQuh29P4=
X-Received: by 2002:a05:6a00:a0a:b0:62e:25f8:c1c3 with SMTP id
 p10-20020a056a000a0a00b0062e25f8c1c3mr682654pfh.3.1680536540440; Mon, 03 Apr
 2023 08:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230402142435.47105-1-glipus@gmail.com> <20230403122622.ixpiy2o7irxb3xpp@skbuf>
In-Reply-To: <20230403122622.ixpiy2o7irxb3xpp@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Mon, 3 Apr 2023 09:42:09 -0600
Message-ID: <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com
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

On Mon, Apr 3, 2023 at 6:26=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Sun, Apr 02, 2023 at 08:24:35AM -0600, Maxim Georgiev wrote:
> > Current NIC driver API demands drivers supporting hardware timestamping
> > to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
> > requires dirivers to implement request parameter structure translation
> > between user and kernel address spaces, handling possible
> > translation failures, etc. This translation code is pretty much
> > identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> > SIOCSHWTSTAMP.
> > This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> > functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> > to ndo_hwtstamp_get/set function calls including parameter structure
> > translation and translation error handling.
> >
> > This patch is sent out as RFC.
> > It still pending on basic testing.
>
> Who should do that testing? Do you have any NIC with the hardware
> timestamping capability?

I'm planning to do the testing with netdevsim. I don't have access to
any NICs with
hardware timestamping support.

>
> > Implementing ndo_hwtstamp_get/set in netdevsim driver should allow
> > manual testing of the request translation logic. Also is there a way
> > to automate this testing?
>
> Automatic testing would require manual testing as a first step, to iron
> out the procedure, right?

Yes, absolutely.

>
> The netdevsim driver should be testable by anyone using 'echo "0 1" >
> /sys/bus/netdevsim/new_device', and then 'hwstamp_ctl -i eni0np1 -t 1'
> (or 'testptp', or 'ptp4l', or whatever). Have you tried doing at least
> that, did it work?

Let me rebase my patch on top of your changes. I'll test it on
netdevsim then.

>
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> > ---
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
> >  drivers/net/ethernet/intel/e1000e/netdev.c | 39 ++++++-----
> >  drivers/net/netdevsim/netdev.c             | 26 +++++++
> >  drivers/net/netdevsim/netdevsim.h          |  1 +
> >  include/linux/netdevice.h                  | 21 ++++++
> >  include/uapi/linux/net_tstamp.h            | 15 ++++
> >  net/core/dev_ioctl.c                       | 81 ++++++++++++++++++----
> >  6 files changed, 149 insertions(+), 34 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/e=
thernet/intel/e1000e/netdev.c
> > index 6f5c16aebcbf..5b98f7257c77 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -6161,7 +6161,9 @@ static int e1000_mii_ioctl(struct net_device *net=
dev, struct ifreq *ifr,
> >  /**
> >   * e1000e_hwtstamp_set - control hardware time stamping
> >   * @netdev: network interface device structure
> > - * @ifr: interface request
> > + * @config: hwtstamp_config structure containing request parameters
> > + * @kernel_config: kernel version of config parameter structure.
> > + * @extack: netlink request parameters.
> >   *
> >   * Outgoing time stamping can be enabled and disabled. Play nice and
> >   * disable it when requested, although it shouldn't cause any overhead
> > @@ -6174,20 +6176,19 @@ static int e1000_mii_ioctl(struct net_device *n=
etdev, struct ifreq *ifr,
> >   * specified. Matching the kind of event packet is not supported, with=
 the
> >   * exception of "all V2 events regardless of level 2 or 4".
> >   **/
> > -static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq=
 *ifr)
> > +static int e1000e_hwtstamp_set(struct net_device *netdev,
> > +                            struct hwtstamp_config *config,
> > +                            struct kernel_hwtstamp_config *kernel_conf=
ig,
> > +                            struct netlink_ext_ack *extack)
> >  {
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
> >  }
> >
> > -static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq=
 *ifr)
> > +static int e1000e_hwtstamp_get(struct net_device *netdev,
> > +                            struct hwtstamp_config *config,
> > +                            struct kernel_hwtstamp_config *kernel_conf=
ig,
> > +                            struct netlink_ext_ack *extack)
> >  {
> >       struct e1000_adapter *adapter =3D netdev_priv(netdev);
> >
> > -     return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> > -                         sizeof(adapter->hwtstamp_config)) ? -EFAULT :=
 0;
> > +     memcpy(config, &adapter->hwtstamp_config,
> > +            sizeof(adapter->hwtstamp_config));
> > +     return 0;
> >  }
> >
> >  static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, i=
nt cmd)
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
> >  };
>
> The conversion per se looks almost in line with what I was expecting to
> see, except for the comments. I guess you can convert a single driver
> first (e1000 seems fine), to get the API merged, then more people could
> work in parallel?

The conversions are going to be easy (that was the point of adding these ND=
O
functions). But there is still a problem of validating these
conversions with testing.
Unfortunately I don't have an e1000 card available to validate this convers=
ion.
I'll let you and Jakub decide what will be the best strategy here.

>
> Or do you want netdevsim to cover hardware timestamping from the
> beginning too, Jakub?
>
> >
> >  /**
> > diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/net=
dev.c
> > index 35fa1ca98671..502715c6e9e1 100644
> > --- a/drivers/net/netdevsim/netdev.c
> > +++ b/drivers/net/netdevsim/netdev.c
> > @@ -238,6 +238,30 @@ nsim_set_features(struct net_device *dev, netdev_f=
eatures_t features)
> >       return 0;
> >  }
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
>
> Please keep conversion patches separate from patches which add new
> functionality.

Let me split my monolithic patch into a stack of patches in the next versio=
n.
e1000e and netdevsim should be definitely arranged as separate patches
which could be reviewed and accepted/rejected independently.

>
> Also, does the netdevsim portion even do something useful? Wouldn't
> you need to implement ethtool_ops :: get_ts_info() in order for user
> space to know that there is a PHC, and that the device supports hardware
> timestamping?

I was thinking of exposing hw timestamping settings to testfs, but the etht=
ool
approach can be easier to implement. Let me fix it!

>
> > +
> >  static const struct net_device_ops nsim_netdev_ops =3D {
> >       .ndo_start_xmit         =3D nsim_start_xmit,
> >       .ndo_set_rx_mode        =3D nsim_set_rx_mode,
> > @@ -256,6 +280,8 @@ static const struct net_device_ops nsim_netdev_ops =
=3D {
> >       .ndo_setup_tc           =3D nsim_setup_tc,
> >       .ndo_set_features       =3D nsim_set_features,
> >       .ndo_bpf                =3D nsim_bpf,
> > +     .ndo_hwtstamp_get       =3D nsim_hwtstamp_get,
> > +     .ndo_hwtstamp_set       =3D nsim_hwtstamp_get,
> >  };
> >
> >  static const struct net_device_ops nsim_vf_netdev_ops =3D {
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
> >  };
> >
> >  struct netdevsim *
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index c8c634091a65..078c9284930a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -57,6 +57,8 @@
> >  struct netpoll_info;
> >  struct device;
> >  struct ethtool_ops;
> > +struct hwtstamp_config;
> > +struct kernel_hwtstamp_config;
> >  struct phy_device;
> >  struct dsa_port;
> >  struct ip_tunnel_parm;
> > @@ -1411,6 +1413,17 @@ struct netdev_net_notifier {
> >   *   Get hardware timestamp based on normal/adjustable time or free ru=
nning
> >   *   cycle counter. This function is required if physical clock suppor=
ts a
> >   *   free running cycle counter.
> > + *   int (*ndo_hwtstamp_get)(struct net_device *dev,
> > + *                           struct hwtstamp_config *config,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Get hardware timestamping parameters currently configured  for NI=
C
> > + *   device.
> > + *   int (*ndo_hwtstamp_set)(struct net_device *dev,
> > + *                           struct hwtstamp_config *config,
> > + *                           struct kernel_hwtstamp_config *kernel_con=
fig,
> > + *                           struct netlink_ext_ack *extack);
> > + *   Set hardware timestamping parameters for NIC device.
>
> I would expect that in the next version, you only pass struct
> kernel_hwtstamp_config * to these and not struct hwtstamp_config *,
> since the former was merged in a form that contains all that struct
> hwtstamp_config does, right?

Yes, I guess I'll just follow your lead and use the kernel_hwtstamp_config
you defined to pass parameters to ndo_hwtstamp_get/set. Jakub, do you
have any objections here?

>
> >   */
> >  struct net_device_ops {
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
> >  };
> >
> >  struct xdp_metadata_ops {
> > diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_t=
stamp.h
> > index a2c66b3d7f0f..547f73beb479 100644
> > --- a/include/uapi/linux/net_tstamp.h
> > +++ b/include/uapi/linux/net_tstamp.h
> > @@ -79,6 +79,21 @@ struct hwtstamp_config {
> >       int rx_filter;
> >  };
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
>
> In include/uapi? No-no. That's exported to user space, which contradicts
> the whole point of having a structure visible just to the kernel.
>
> See net-next commit c4bffeaa8d50 ("net: add struct kernel_hwtstamp_config
> and make net_hwtstamp_validate() use it") by the way.

Yes, I realized that I touched the wrong file when I was reading through yo=
ur
patch stack. You already defined kernel_hwtstamp_config, so my changes to
include/uapi/linux/net_tstamp.h should be reverted anyway.

>
> > +
> >  /* possible values for hwtstamp_config->flags */
> >  enum hwtstamp_flags {
> >       /*
> > diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> > index 846669426236..c145afb3f77e 100644
> > --- a/net/core/dev_ioctl.c
> > +++ b/net/core/dev_ioctl.c
> > @@ -183,22 +183,18 @@ static int dev_ifsioc_locked(struct net *net, str=
uct ifreq *ifr, unsigned int cm
> >       return err;
> >  }
> >
> > -static int net_hwtstamp_validate(struct ifreq *ifr)
> > +static int net_hwtstamp_validate(struct hwtstamp_config *cfg)
> >  {
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
> >  }
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
>
> Here, when you rebase over commit 4ee58e1e5680 ("net: promote
> SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated handlers"),
> I expect that you will add another helper function to include/linux/net_t=
stamp.h
> called hwtstamp_config_from_kernel(), which translates back from the
> struct kernel_hwtstamp_config into something on which copy_from_user()
> can be called, correct?

Yes, that's what I'm planning to do as part of rebasing this patch.

>
> > +
> > +     if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> > +             return -EFAULT;
> > +     return 0;
> > +}
> > +
> >  static int dev_siocdevprivate(struct net_device *dev, struct ifreq *if=
r,
> >                             void __user *data, unsigned int cmd)
> >  {
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
> > --
> > 2.39.2
> >
