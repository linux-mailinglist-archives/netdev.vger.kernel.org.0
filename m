Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E936F58772B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 08:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiHBGm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiHBGm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 02:42:58 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EC139BAC;
        Mon,  1 Aug 2022 23:42:55 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc30b.ng.seznam.cz (email-smtpc30b.ng.seznam.cz [10.23.18.45])
        id 2a1a3f02ceb6ec3c2bc79e6c;
        Tue, 02 Aug 2022 08:42:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659422537; bh=XHMpjL0L10lsnl2ndjwdmRBJbFxa5xkb4v0a2KjE41M=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:
         Content-Transfer-Encoding:In-Reply-To:X-szn-frgn:X-szn-frgc;
        b=XI/HtwDsR6IXGP2JQqFerhw5ZoXN7cejrqkOGrQWvPGM8fjKsxCqZqJ/QDSO5Ouv3
         8Fb9PXgipHdSrY7WwUkqW8j2EbT9sozamGPKLnt8pu28EBGJfdxKuFeE1pX6I8JHSt
         2Y4KWoS33AoHOrNh5eBCEPVjtWaxG+bCWldLcwBs=
Received: from hopium (2a02:8308:900d:2400:3e72:6e2:58c0:367d [2a02:8308:900d:2400:3e72:6e2:58c0:367d])
        by email-relay23.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Tue, 02 Aug 2022 08:42:13 +0200 (CEST)  
Date:   Tue, 2 Aug 2022 08:42:11 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Vincent Mailhol <vincent.mailhol@gmail.com>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220802064211.GA4294@hopium>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZ6RqJEBV=1iUN3dH-ZZVujOFEoJ-U1FaJ5OOJzw+aM_mkUvA@mail.gmail.com>
X-szn-frgn: <6b1bc025-f904-4833-8d4d-9d236e3a4d2e>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 12:43:38PM +0900, Vincent Mailhol wrote:
> Hi Matej,
> 
> I just send a series last week which a significant amount of changes
> for CAN timestamping tree-wide:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=12a18d79dc14c80b358dbd26461614b97f2ea4a6
> 
> I suggest you have a look at this series and harmonize it with the new
> features (e.g. Hardware TX timestamp).

Hi Vincent,

thanks for your review! I saw your patch series, but I've only skimmed
through it. I'll read it fully in the evening.

> > @@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv *priv, enum ctu_can_fd_can_r
> >         priv->write_reg(priv, buf_base + offset, val);
> >  }
> >
> > +static u64 concatenate_two_u32(u32 high, u32 low)
> 
> Might be good to add the "namespace" prefix. I suggest:
> 
> static u64 ctucan_concat_tstamp(u32 high, u32 low)
> 
> Because, so far, the function is to be used exclusively with timestamps.
> 
> Also, I was surprised that no helper functions in include/linux/
> headers already do that. But this is another story.
I agree, it is more specific, thanks for the suggestion.

> > +{
> > +       return ((u64)high << 32) | ((u64)low);
> > +}
> > +
> > +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> > +{
> > +       u32 ts_low;
> > +       u32 ts_high;
> > +       u32 ts_high2;
> > +
> > +       ts_high = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> > +       ts_low = ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> > +       ts_high2 = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> > +
> > +       if (ts_high2 != ts_high)
> > +               ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> > +
> > +       return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> > +}
> > +
> >  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS)))
> >  #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
> 
> 
> #define CTU_CAN_FD_TXTNF(priv) \
>         (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS)))
> 
> #define CTU_CAN_FD_ENABLED(priv) \
>         (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
> 
> Even if the rule is now more relaxed, the soft limit remains 80
> characters per line:
> 
> https://www.kernel.org/doc/html/latest/process/coding-style.html#breaking-long-lines-and-strings
Not from my patch but no problem, I'll fix it in the next version.
Thanks for spotting this.

> > @@ -1295,15 +1341,117 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
> >         return 0;
> >  }
> >
> > +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +       struct ctucan_priv *priv = netdev_priv(dev);
> > +       struct hwtstamp_config cfg;
> > +
> > +       if (!priv->timestamp_possible)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +               return -EFAULT;
> > +
> > +       if (cfg.flags)
> > +               return -EINVAL;
> > +
> > +       if (cfg.tx_type != HWTSTAMP_TX_OFF)
> > +               return -ERANGE;
> 
> I have a great news: your driver now also support hardware TX timestamps:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=8bdd1112edcd3edce2843e03826204a84a61042d
Yes, I'll read your patch series and update accordingly.

> > +
> > +       switch (cfg.rx_filter) {
> > +       case HWTSTAMP_FILTER_NONE:
> > +               priv->timestamp_enabled = false;
> > +               break;
> > +       case HWTSTAMP_FILTER_ALL:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_EVENT:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > +               fallthrough;
> > +       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> > +               priv->timestamp_enabled = true;
> > +               cfg.rx_filter = HWTSTAMP_FILTER_ALL;
> > +               break;
> 
> All those HWTSTAMP_FILTER_PTP_V2_* filters are for UDP, Ethernet or AS1:
> https://elixir.bootlin.com/linux/v5.4.5/source/include/uapi/linux/net_tstamp.h#L106
> 
> Because those layers do not exist in CAN, I suggest treating them all
> as not supported.
> 
> Please have a look at this patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=90f942c5a6d775bad1be33ba214755314105da4a

I followed the Doc/networking/timestamping.txt, and section 3.1 says
"Drivers are free to use a more permissive configuration than the requested
configuration."
So I've added in all the _PTP filters etc. If the consensus is that
_NONE and _ALL filters are enough, I'll gladly remove the dozen of
unnecessary cases.


> > +       default:
> > +               return -ERANGE;
> > +       }
> > +
> > +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > +}
> > +
> > +static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +       struct ctucan_priv *priv = netdev_priv(dev);
> > +       struct hwtstamp_config cfg;
> > +
> > +       if (!priv->timestamp_possible)
> > +               return -EOPNOTSUPP;
> > +
> > +       cfg.flags = 0;
> > +       cfg.tx_type = HWTSTAMP_TX_OFF;
> 
> Hardware TX timestamps are now supported (c.f. supra).
ACK
> 
> > +       cfg.rx_filter = priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
> > +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > +}
> > +
> > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> 
> Please consider using the generic function can_eth_ioctl_hwts()
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=90f942c5a6d775bad1be33ba214755314105da4a
I've seen it, but I have to use a custom ioctl function, if I want to
toggle rx timestamps enabled/disabled.
> > +{
> > +       switch (cmd) {
> > +       case SIOCSHWTSTAMP:
> > +               return ctucan_hwtstamp_set(dev, ifr);
> > +       case SIOCGHWTSTAMP:
> > +               return ctucan_hwtstamp_get(dev, ifr);
> > +       default:
> > +               return -EOPNOTSUPP;
> > +       }
> > +}
> >
> > +static int ctucan_ethtool_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
> 
> Please break the line to meet the 80 columns soft limit.
> 
> Please consider using the generic function can_ethtool_op_get_ts_info_hwts():
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=7fb48d25b5ce3bc488dbb019bf1736248181de9a
> 
> Something like that:
> static int ctucan_ethtool_get_ts_info(struct net_device *ndev,
>                                       struct ethtool_ts_info *inf
> {
>         struct ctucan_priv *priv = netdev_priv(ndev);
> 
>         if (!priv->timestamp_possible)
>                 ethtool_op_get_ts_info(ndev, info);
> 
>         return can_ethtool_op_get_ts_info_hwts(ndev, info);
> }
Sure, this is better, I'll include it in v3. Thank you.
> > +{
> > +       struct ctucan_priv *priv = netdev_priv(ndev);
> > +
> > +       ethtool_op_get_ts_info(ndev, info);
> > +
> > +       if (!priv->timestamp_possible)
> > +               return 0;
> > +
> > +       info->so_timestamping |= SOF_TIMESTAMPING_RX_HARDWARE |
> > +                                SOF_TIMESTAMPING_RAW_HARDWARE;
> > +       info->tx_types = BIT(HWTSTAMP_TX_OFF);
> 
> Hardware TX timestamps are now supported (c.f. supra).
ACK
> > +       info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
> > +                          BIT(HWTSTAMP_FILTER_ALL);
> > +
> > +       return 0;
> > +}
> > +
> > @@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >
> >         /* Getting the can_clk info */
> >         if (!can_clk_rate) {
> > -               priv->can_clk = devm_clk_get(dev, NULL);
> > +               priv->can_clk = devm_clk_get_optional(dev, "core-clk");
> > +               if (!priv->can_clk)
> > +                       priv->can_clk = devm_clk_get(dev, NULL);
> >                 if (IS_ERR(priv->can_clk)) {
> >                         dev_err(dev, "Device clock not found.\n");
> 
> Just a suggestion, but you may want to print the mnemotechnic of the error code:
> dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
Yes the error print might need some tweaking, I'll think about it.

> >                         ret = PTR_ERR(priv->can_clk);
> > @@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >
> >         priv->can.clock.freq = can_clk_rate;

