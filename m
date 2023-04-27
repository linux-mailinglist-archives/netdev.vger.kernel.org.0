Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1956F0008
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjD0EA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjD0EA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:00:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2D2683
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:00:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-51f6461af24so6097315a12.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 21:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682568054; x=1685160054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwIr2LPsWLJs5DRlGWIGEYU7rcj7kBOfNRBmW6TdTPc=;
        b=FMiDwv6MN6i+9OnFPVUrKYZLoKukoNHGcbGTCnTWfOpiuzi8rW+K49oDMjRii4Kp0T
         QtFvqW+bsMvqaSCsNQeWaire7rLhyv1fz+hkgKMgub93qZ0Gh9gBgYVV4jAz6pYKWr11
         egTWQmIno136Rd1jEI3/dJV3qPUcfZIsxrpTdrE4gISejEdEWfG8MvBmCOMl9JTD6IHx
         YHtSGGVTkdgYqn2DR6WcPQVT/k9RdXndxAwuWpi5+Ipm8kDEKHvcfhnk4wdwbYaHEgvI
         0H7Xj9BFUr4GQCxKJMd5kpJu+/52K4jTam5xmt3OEMyZ5NLbpFHAgld7CdHLEHwqld37
         CWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682568054; x=1685160054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zwIr2LPsWLJs5DRlGWIGEYU7rcj7kBOfNRBmW6TdTPc=;
        b=S39RbwZYoyjCRp4+iOeCuTTNXU0YGTZbNqxQjElc1jVvH+s0C/2vd1tr9ui3Tm8CeH
         PBZzzmJb1zoFSUTHY7fZnSzp9YNSL645TvLIOioZqqBWBR3MZ19vS1lQEsz+kn3QvVNL
         2iFl2Ubt9XbqzsevMULjtgbwDfGaQLczEWlY1KYJ4+OW/+7GU28jtfz0UMdT0OtYQRBZ
         R2leS2p0UT+A/+2uTs2GYpRqimJ8UBe7g359SBA/PNnrYfAgvPZZfXtaoWtNju8DmnM2
         K9Ew6fE9+HfgFrEzy3rZmBucC2dXJb3ozZ+o2seUCrBQAN3+TKLtyn2mtHdmjsN6UDdK
         8qSQ==
X-Gm-Message-State: AC+VfDxXJRAgyms4YeMtI+17gK300I0ho6cBwOKaEq6oBa7khQmBwABh
        RlgLwFT574KhzHdv9s7X56yB5GQzvwsl5hF5850=
X-Google-Smtp-Source: ACHHUZ6Lb1Sl8+Cy3qy702qohkgXq1ZPPuXnFq3Gbv6redV204P0SiDpevwGWFjFQV+CClETJ6DeI1tIQSm4UKDS2Vk=
X-Received: by 2002:a17:90a:e516:b0:23d:29c7:916f with SMTP id
 t22-20020a17090ae51600b0023d29c7916fmr390174pjy.32.1682568054135; Wed, 26 Apr
 2023 21:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032437.285014-1-glipus@gmail.com> <20230426165835.443259-1-kory.maincent@bootlin.com>
In-Reply-To: <20230426165835.443259-1-kory.maincent@bootlin.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 26 Apr 2023 22:00:43 -0600
Message-ID: <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 10:58=E2=80=AFAM K=C3=B6ry Maincent
<kory.maincent@bootlin.com> wrote:
>
> From: Kory Maincent <kory.maincent@bootlin.com>
>
> You patch series work on my side with the macb MAC controller and this
> patch.
> I don't know if you are waiting for more reviews but it seems good enough
> to drop the RFC tag.
>
> ---
>
>  drivers/net/ethernet/cadence/macb.h      | 10 ++++++--
>  drivers/net/ethernet/cadence/macb_main.c | 15 ++++--------
>  drivers/net/ethernet/cadence/macb_ptp.c  | 30 ++++++++++++++----------
>  3 files changed, 29 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/c=
adence/macb.h
> index cfbdd0022764..bc73b080093e 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1350,8 +1350,14 @@ static inline void gem_ptp_do_rxstamp(struct macb =
*bp, struct sk_buff *skb, stru
>
>         gem_ptp_rxstamp(bp, skb, desc);
>  }
> -int gem_get_hwtst(struct net_device *dev, struct ifreq *rq);
> -int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd);
> +
> +int gem_get_hwtst(struct net_device *dev,
> +                 struct kernel_hwtstamp_config *kernel_config,
> +                 struct netlink_ext_ack *extack);
> +int gem_set_hwtst(struct net_device *dev,
> +                 struct kernel_hwtstamp_config *kernel_config,
> +                 struct netlink_ext_ack *extack);
> +
>  #else
>  static inline void gem_ptp_init(struct net_device *ndev) { }
>  static inline void gem_ptp_remove(struct net_device *ndev) { }
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index 45f63df5bdc4..c1d65be88835 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3402,8 +3402,6 @@ static struct macb_ptp_info gem_ptp_info =3D {
>         .get_ptp_max_adj =3D gem_get_ptp_max_adj,
>         .get_tsu_rate    =3D gem_get_tsu_rate,
>         .get_ts_info     =3D gem_get_ts_info,
> -       .get_hwtst       =3D gem_get_hwtst,
> -       .set_hwtst       =3D gem_set_hwtst,
>  };
>  #endif
>
> @@ -3764,15 +3762,6 @@ static int macb_ioctl(struct net_device *dev, stru=
ct ifreq *rq, int cmd)
>         if (!netif_running(dev))
>                 return -EINVAL;
>
> -       if (!phy_has_hwtstamp(dev->phydev) && bp->ptp_info) {
> -               switch (cmd) {
> -               case SIOCSHWTSTAMP:
> -                       return bp->ptp_info->set_hwtst(dev, rq, cmd);
> -               case SIOCGHWTSTAMP:
> -                       return bp->ptp_info->get_hwtst(dev, rq);
> -               }
> -       }
> -
>         return phylink_mii_ioctl(bp->phylink, rq, cmd);
>  }
>
> @@ -3875,6 +3864,10 @@ static const struct net_device_ops macb_netdev_ops=
 =3D {
>  #endif
>         .ndo_set_features       =3D macb_set_features,
>         .ndo_features_check     =3D macb_features_check,
> +#ifdef CONFIG_MACB_USE_HWSTAMP
> +       .ndo_hwtstamp_get       =3D gem_get_hwtst,
> +       .ndo_hwtstamp_set       =3D gem_set_hwtst,
> +#endif
>  };
>
>  /* Configure peripheral capabilities according to device tree
> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethern=
et/cadence/macb_ptp.c
> index 51d26fa190d7..eddacc5df435 100644
> --- a/drivers/net/ethernet/cadence/macb_ptp.c
> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
> @@ -374,19 +374,22 @@ static int gem_ptp_set_ts_mode(struct macb *bp,
>         return 0;
>  }
>
> -int gem_get_hwtst(struct net_device *dev, struct ifreq *rq)
> +int gem_get_hwtst(struct net_device *dev,
> +                 struct kernel_hwtstamp_config *kernel_config,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct hwtstamp_config *tstamp_config;
>         struct macb *bp =3D netdev_priv(dev);
>
> +       if (phy_has_hwtstamp(dev->phydev))
> +               return phylink_mii_ioctl(bp->phylink, kernel_config->ifr,=
 SIOCGHWTSTAMP);
> +
>         tstamp_config =3D &bp->tstamp_config;
>         if ((bp->hw_dma_cap & HW_DMA_CAP_PTP) =3D=3D 0)
>                 return -EOPNOTSUPP;
>
> -       if (copy_to_user(rq->ifr_data, tstamp_config, sizeof(*tstamp_conf=
ig)))
> -               return -EFAULT;
> -       else
> -               return 0;
> +       hwtstamp_config_to_kernel(kernel_config, tstamp_config);
> +       return 0;
>  }
>
>  static void gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
> @@ -401,7 +404,9 @@ static void gem_ptp_set_one_step_sync(struct macb *bp=
, u8 enable)
>                 macb_writel(bp, NCR, reg_val & ~MACB_BIT(OSSMODE));
>  }
>
> -int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
> +int gem_set_hwtst(struct net_device *dev,
> +                 struct kernel_hwtstamp_config *kernel_config,
> +                 struct netlink_ext_ack *extack)
>  {
>         enum macb_bd_control tx_bd_control =3D TSTAMP_DISABLED;
>         enum macb_bd_control rx_bd_control =3D TSTAMP_DISABLED;
> @@ -409,13 +414,14 @@ int gem_set_hwtst(struct net_device *dev, struct if=
req *ifr, int cmd)
>         struct macb *bp =3D netdev_priv(dev);
>         u32 regval;
>
> +       if (phy_has_hwtstamp(dev->phydev))
> +               return phylink_mii_ioctl(bp->phylink, kernel_config->ifr,=
 SIOCSHWTSTAMP);
> +
>         tstamp_config =3D &bp->tstamp_config;
>         if ((bp->hw_dma_cap & HW_DMA_CAP_PTP) =3D=3D 0)
>                 return -EOPNOTSUPP;
>
> -       if (copy_from_user(tstamp_config, ifr->ifr_data,
> -                          sizeof(*tstamp_config)))
> -               return -EFAULT;
> +       hwtstamp_config_from_kernel(tstamp_config, kernel_config);
>
>         switch (tstamp_config->tx_type) {
>         case HWTSTAMP_TX_OFF:
> @@ -466,9 +472,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifre=
q *ifr, int cmd)
>         if (gem_ptp_set_ts_mode(bp, tx_bd_control, rx_bd_control) !=3D 0)
>                 return -ERANGE;
>
> -       if (copy_to_user(ifr->ifr_data, tstamp_config, sizeof(*tstamp_con=
fig)))
> -               return -EFAULT;
> -       else
> -               return 0;
> +       hwtstamp_config_to_kernel(kernel_config, tstamp_config);
> +       return 0;
>  }
>
> --
> 2.25.1
>

Thank you for giving it a try!
I'll drop the RFC tag starting from the next iteration.
