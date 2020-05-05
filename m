Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78FC1C52ED
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgEEKRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbgEEKRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 06:17:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CEAC061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 03:17:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so1013149ljg.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 03:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygmLOTV1U7njJHqTlUC06vTXb3ma6xWQuaClwP3ut4w=;
        b=wOH0mOJq1p291nG3SA34CRQFdQTsyYAOwpAEg+H5X0tHm4uwJG++N6pKu8nFomywoX
         UnuREEE0zpBwPxm+A+BUdRDhtDhw5z4HJuvBYIQyNel7azZb6PxSY1FYOJNsV0MXFvVZ
         exkyNKjQRFeQAgLVM7GC6R+QIGr7ldibitrExEOmqCRl2HuWUDyyHCpfTn/DhRpdQHbv
         qVzR3vrWh3RgaGeAHwAEdqQx6PGYGkxIfeqwp2m8MpfKPIs4eTXshW/0d+NivffnOYrd
         Tx/9HLtQSvOMSvIp3BjxvrlHyEURFcGwl9OWkNNammncLxIc3OGi9is2g5gfVF5sC/Lq
         6SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygmLOTV1U7njJHqTlUC06vTXb3ma6xWQuaClwP3ut4w=;
        b=JphKSi3xkP30OvQ76cetD/GYfUDGxibDFhRl1iW1i3s4a8c9AZ7SZYM/cyzsNuwMxn
         3vNroLWppt7d4qH+6SbQxiZ8revQcAveJ+DK4w5QdjXOR9Za3x6EVWebkrfIwwh9dCua
         SPbc5ApNDU4Vgr84YaFHdq/W5hfd505gU6bGg7A2s/KK2C/BJSvV0jEGbNr443SxhiC+
         AfDA0bioX6nO5SM/p6GaGxWqhDOZR/MUF1MUIXLixZhkdORCU3GcPlSj6w9KkPDT54Ms
         BihYHZbMSSDg60MCgtaKmyFn7He01hYEP0GKOiNgWQMqB+3gK8o/udP958s5GgaBBk2M
         9bZA==
X-Gm-Message-State: AGi0Pub9Pdhx0hj9ZboaxwjYosblPrF544+C/sh0pRDBV7a1b4tGmbtn
        XGJOkdJT3AdFkTmi8Q8ujjmXc0GDkjG4h87ZNVgkw32JZbfvNQ==
X-Google-Smtp-Source: APiQypJ4VlUqA0W+jTJ2hsz8a9VHcfYuJygJQwUpGEoMTQnxzLmm30vjiSXn6P3KQaDjlBpDR8AiEFKj4l3ok/emmpY=
X-Received: by 2002:a2e:9a4a:: with SMTP id k10mr1355981ljj.115.1588673870685;
 Tue, 05 May 2020 03:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200501205011.14899-1-grygorii.strashko@ti.com> <20200501205011.14899-4-grygorii.strashko@ti.com>
In-Reply-To: <20200501205011.14899-4-grygorii.strashko@ti.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 5 May 2020 12:17:39 +0200
Message-ID: <CADYN=9L+RtruRYKah0Bomh7UaPGQ==N9trd0ZoVQ3GTc-VY8Dg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] net: ethernet: ti: am65-cpsw-nuss: enable
 packet timestamping support
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Networking <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 at 22:50, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>
> The MCU CPSW Common Platform Time Sync (CPTS) provides possibility to
> timestamp TX PTP packets and all RX packets.
>
> This enables corresponding support in TI AM65x/J721E MCU CPSW driver.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/net/ethernet/ti/Kconfig             |   1 +
>  drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  24 ++-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 172 ++++++++++++++++++++
>  drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   6 +-
>  4 files changed, 201 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 1f4e5b6dc686..2c7bd1ccaaec 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -100,6 +100,7 @@ config TI_K3_AM65_CPSW_NUSS
>         depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
>         select TI_DAVINCI_MDIO
>         imply PHY_TI_GMII_SEL
> +       imply TI_AM65_CPTS

Should this be TI_K3_AM65_CPTS ?

I did an arm64 allmodconfig build on todays next tag: next-20200505
and got this undefined symbol:

aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
function `am65_cpsw_init_cpts':
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:
undefined reference to `am65_cpts_create'
aarch64-linux-gnu-ld:
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
`am65_cpts_create'
aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
function `am65_cpsw_nuss_tx_compl_packets':
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:
undefined reference to `am65_cpts_tx_timestamp'
aarch64-linux-gnu-ld:
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:(.text+0x4cf0):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
`am65_cpts_tx_timestamp'
aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
function `am65_cpsw_nuss_ndo_slave_xmit':
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:
undefined reference to `am65_cpts_prep_tx_timestamp'
aarch64-linux-gnu-ld:
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:(.text+0x58fc):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
`am65_cpts_prep_tx_timestamp'
aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
function `am65_cpsw_nuss_hwtstamp_set':
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:
undefined reference to `am65_cpts_rx_enable'
aarch64-linux-gnu-ld:
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:(.text+0x7564):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
`am65_cpts_rx_enable'
aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-ethtool.o: in
function `am65_cpsw_get_ethtool_ts_info':
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:
undefined reference to `am65_cpts_phc_index'
aarch64-linux-gnu-ld:
/srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:(.text+0xbe8):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
`am65_cpts_phc_index'
make[1]: *** [/srv/src/kernel/next/Makefile:1114: vmlinux] Error 1
make[1]: Target 'Image' not remade because of errors.
make: *** [Makefile:180: sub-make] Error 2
make: Target 'Image' not remade because of errors.


Cheers,
Anders

>         help
>           This driver supports TI K3 AM654/J721E CPSW2G Ethernet SubSystem.
>           The two-port Gigabit Ethernet MAC (MCU_CPSW0) subsystem provides
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> index c3502aa15ea0..23661a6ed426 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> @@ -12,6 +12,7 @@
>
>  #include "am65-cpsw-nuss.h"
>  #include "cpsw_ale.h"
> +#include "am65-cpts.h"
>
>  #define AM65_CPSW_REGDUMP_VER 0x1
>
> @@ -694,6 +695,27 @@ static void am65_cpsw_get_ethtool_stats(struct net_device *ndev,
>                                         hw_stats[i].offset);
>  }
>
> +static int am65_cpsw_get_ethtool_ts_info(struct net_device *ndev,
> +                                        struct ethtool_ts_info *info)
> +{
> +       struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +
> +       if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
> +               return ethtool_op_get_ts_info(ndev, info);
> +
> +       info->so_timestamping =
> +               SOF_TIMESTAMPING_TX_HARDWARE |
> +               SOF_TIMESTAMPING_TX_SOFTWARE |
> +               SOF_TIMESTAMPING_RX_HARDWARE |
> +               SOF_TIMESTAMPING_RX_SOFTWARE |
> +               SOF_TIMESTAMPING_SOFTWARE |
> +               SOF_TIMESTAMPING_RAW_HARDWARE;
> +       info->phc_index = am65_cpts_phc_index(common->cpts);
> +       info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON);
> +       info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
> +       return 0;
> +}
> +
>  static u32 am65_cpsw_get_ethtool_priv_flags(struct net_device *ndev)
>  {
>         struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> @@ -730,7 +752,7 @@ const struct ethtool_ops am65_cpsw_ethtool_ops_slave = {
>         .get_sset_count         = am65_cpsw_get_sset_count,
>         .get_strings            = am65_cpsw_get_strings,
>         .get_ethtool_stats      = am65_cpsw_get_ethtool_stats,
> -       .get_ts_info            = ethtool_op_get_ts_info,
> +       .get_ts_info            = am65_cpsw_get_ethtool_ts_info,
>         .get_priv_flags         = am65_cpsw_get_ethtool_priv_flags,
>         .set_priv_flags         = am65_cpsw_set_ethtool_priv_flags,
>
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 2bf56733ba94..bb391286d89e 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -30,6 +30,7 @@
>  #include "cpsw_sl.h"
>  #include "am65-cpsw-nuss.h"
>  #include "k3-cppi-desc-pool.h"
> +#include "am65-cpts.h"
>
>  #define AM65_CPSW_SS_BASE      0x0
>  #define AM65_CPSW_SGMII_BASE   0x100
> @@ -668,6 +669,18 @@ static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
>         dev_kfree_skb_any(skb);
>  }
>
> +static void am65_cpsw_nuss_rx_ts(struct sk_buff *skb, u32 *psdata)
> +{
> +       struct skb_shared_hwtstamps *ssh;
> +       u64 ns;
> +
> +       ns = ((u64)psdata[1] << 32) | psdata[0];
> +
> +       ssh = skb_hwtstamps(skb);
> +       memset(ssh, 0, sizeof(*ssh));
> +       ssh->hwtstamp = ns_to_ktime(ns);
> +}
> +
>  /* RX psdata[2] word format - checksum information */
>  #define AM65_CPSW_RX_PSD_CSUM_ADD      GENMASK(15, 0)
>  #define AM65_CPSW_RX_PSD_CSUM_ERR      BIT(16)
> @@ -745,6 +758,9 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
>         skb->dev = ndev;
>
>         psdata = cppi5_hdesc_get_psdata(desc_rx);
> +       /* add RX timestamp */
> +       if (port->rx_ts_enabled)
> +               am65_cpsw_nuss_rx_ts(skb, psdata);
>         csum_info = psdata[2];
>         dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
>
> @@ -904,6 +920,8 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
>
>                 ndev = skb->dev;
>
> +               am65_cpts_tx_timestamp(common->cpts, skb);
> +
>                 ndev_priv = netdev_priv(ndev);
>                 stats = this_cpu_ptr(ndev_priv->stats);
>                 u64_stats_update_begin(&stats->syncp);
> @@ -995,6 +1013,10 @@ static netdev_tx_t am65_cpsw_nuss_ndo_slave_xmit(struct sk_buff *skb,
>         /* padding enabled in hw */
>         pkt_len = skb_headlen(skb);
>
> +       /* SKB TX timestamp */
> +       if (port->tx_ts_enabled)
> +               am65_cpts_prep_tx_timestamp(common->cpts, skb);
> +
>         q_idx = skb_get_queue_mapping(skb);
>         dev_dbg(dev, "%s skb_queue:%d\n", __func__, q_idx);
>
> @@ -1158,6 +1180,111 @@ static int am65_cpsw_nuss_ndo_slave_set_mac_address(struct net_device *ndev,
>         return 0;
>  }
>
> +static int am65_cpsw_nuss_hwtstamp_set(struct net_device *ndev,
> +                                      struct ifreq *ifr)
> +{
> +       struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> +       struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +       u32 ts_ctrl, seq_id, ts_ctrl_ltype2, ts_vlan_ltype;
> +       struct hwtstamp_config cfg;
> +
> +       if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
> +               return -EOPNOTSUPP;
> +
> +       if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +               return -EFAULT;
> +
> +       /* TX HW timestamp */
> +       switch (cfg.tx_type) {
> +       case HWTSTAMP_TX_OFF:
> +       case HWTSTAMP_TX_ON:
> +               break;
> +       default:
> +               return -ERANGE;
> +       }
> +
> +       switch (cfg.rx_filter) {
> +       case HWTSTAMP_FILTER_NONE:
> +               port->rx_ts_enabled = false;
> +               break;
> +       case HWTSTAMP_FILTER_ALL:
> +       case HWTSTAMP_FILTER_SOME:
> +       case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +       case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +       case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +       case HWTSTAMP_FILTER_NTP_ALL:
> +               port->rx_ts_enabled = true;
> +               cfg.rx_filter = HWTSTAMP_FILTER_ALL;
> +               break;
> +       default:
> +               return -ERANGE;
> +       }
> +
> +       port->tx_ts_enabled = (cfg.tx_type == HWTSTAMP_TX_ON);
> +
> +       /* cfg TX timestamp */
> +       seq_id = (AM65_CPSW_TS_SEQ_ID_OFFSET <<
> +                 AM65_CPSW_PN_TS_SEQ_ID_OFFSET_SHIFT) | ETH_P_1588;
> +
> +       ts_vlan_ltype = ETH_P_8021Q;
> +
> +       ts_ctrl_ltype2 = ETH_P_1588 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_107 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_129 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_130 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_131 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_132 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_319 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_320 |
> +                        AM65_CPSW_PN_TS_CTL_LTYPE2_TS_TTL_NONZERO;
> +
> +       ts_ctrl = AM65_CPSW_TS_EVENT_MSG_TYPE_BITS <<
> +                 AM65_CPSW_PN_TS_CTL_MSG_TYPE_EN_SHIFT;
> +
> +       if (port->tx_ts_enabled)
> +               ts_ctrl |= AM65_CPSW_TS_TX_ANX_ALL_EN |
> +                          AM65_CPSW_PN_TS_CTL_TX_VLAN_LT1_EN;
> +
> +       writel(seq_id, port->port_base + AM65_CPSW_PORTN_REG_TS_SEQ_LTYPE_REG);
> +       writel(ts_vlan_ltype, port->port_base +
> +              AM65_CPSW_PORTN_REG_TS_VLAN_LTYPE_REG);
> +       writel(ts_ctrl_ltype2, port->port_base +
> +              AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2);
> +       writel(ts_ctrl, port->port_base + AM65_CPSW_PORTN_REG_TS_CTL);
> +
> +       /* en/dis RX timestamp */
> +       am65_cpts_rx_enable(common->cpts, port->rx_ts_enabled);
> +
> +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}
> +
> +static int am65_cpsw_nuss_hwtstamp_get(struct net_device *ndev,
> +                                      struct ifreq *ifr)
> +{
> +       struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +       struct hwtstamp_config cfg;
> +
> +       if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
> +               return -EOPNOTSUPP;
> +
> +       cfg.flags = 0;
> +       cfg.tx_type = port->tx_ts_enabled ?
> +                     HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
> +       cfg.rx_filter = port->rx_ts_enabled ?
> +                       HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
> +
> +       return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}
> +
>  static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
>                                           struct ifreq *req, int cmd)
>  {
> @@ -1166,6 +1293,13 @@ static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
>         if (!netif_running(ndev))
>                 return -EINVAL;
>
> +       switch (cmd) {
> +       case SIOCSHWTSTAMP:
> +               return am65_cpsw_nuss_hwtstamp_set(ndev, req);
> +       case SIOCGHWTSTAMP:
> +               return am65_cpsw_nuss_hwtstamp_get(ndev, req);
> +       }
> +
>         if (!port->slave.phy)
>                 return -EOPNOTSUPP;
>
> @@ -1531,6 +1665,40 @@ static int am65_cpsw_am654_get_efuse_macid(struct device_node *of_node,
>         return 0;
>  }
>
> +static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
> +{
> +       struct device *dev = common->dev;
> +       struct device_node *node;
> +       struct am65_cpts *cpts;
> +       void __iomem *reg_base;
> +
> +       if (!IS_ENABLED(CONFIG_TI_K3_AM65_CPTS))
> +               return 0;
> +
> +       node = of_get_child_by_name(dev->of_node, "cpts");
> +       if (!node) {
> +               dev_err(dev, "%s cpts not found\n", __func__);
> +               return -ENOENT;
> +       }
> +
> +       reg_base = common->cpsw_base + AM65_CPSW_NU_CPTS_BASE;
> +       cpts = am65_cpts_create(dev, reg_base, node);
> +       if (IS_ERR(cpts)) {
> +               int ret = PTR_ERR(cpts);
> +
> +               if (ret == -EOPNOTSUPP) {
> +                       dev_info(dev, "cpts disabled\n");
> +                       return 0;
> +               }
> +
> +               dev_err(dev, "cpts create err %d\n", ret);
> +               return ret;
> +       }
> +       common->cpts = cpts;
> +
> +       return 0;
> +}
> +
>  static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>  {
>         struct device_node *node, *port_np;
> @@ -1899,6 +2067,10 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
>                 goto err_of_clear;
>         }
>
> +       ret = am65_cpsw_init_cpts(common);
> +       if (ret)
> +               goto err_of_clear;
> +
>         /* init ports */
>         for (i = 0; i < common->port_num; i++)
>                 am65_cpsw_nuss_slave_disable_unused(&common->ports[i]);
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> index 41ae5b4c7931..b1cddfd05a45 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
> @@ -10,6 +10,8 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>
> +struct am65_cpts;
> +
>  #define HOST_PORT_NUM          0
>
>  #define AM65_CPSW_MAX_TX_QUEUES        8
> @@ -37,6 +39,8 @@ struct am65_cpsw_port {
>         void __iomem                    *stat_base;
>         bool                            disabled;
>         struct am65_cpsw_slave_data     slave;
> +       bool                            tx_ts_enabled;
> +       bool                            rx_ts_enabled;
>  };
>
>  struct am65_cpsw_host {
> @@ -96,8 +100,8 @@ struct am65_cpsw_common {
>
>         u32                     nuss_ver;
>         u32                     cpsw_ver;
> -
>         bool                    pf_p0_rx_ptype_rrobin;
> +       struct am65_cpts        *cpts;
>  };
>
>  struct am65_cpsw_ndev_stats {
> --
> 2.17.1
>
