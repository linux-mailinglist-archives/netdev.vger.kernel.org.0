Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169C410AE61
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK0LAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:00:31 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44845 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfK0LAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 06:00:31 -0500
Received: by mail-ed1-f65.google.com with SMTP id a67so19254939edf.11;
        Wed, 27 Nov 2019 03:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7yVhTuZZNjpoTXGakcprMEA8nox5i/B4bDVB0Vr09I=;
        b=cph1XzaEC4WoooUmZ8dbdk11tOeNarc2zyVOWHs43hcnb4ZY01f9xFdQe+/4pRd+BI
         IG/JqcM1QBSXy0vBFklJZOjcBX/0VnJGOPotz5iWCkSUnho/nM+qde6AR1cru7gdneSB
         alKGy3yLMzAUV2UlznLUOzdkI7HS7T2G+gn/N8yv0+JHk3U6fAa0QOmi5Hag++JqWadW
         i/6vtnFzn8a8Eb1KgcdcmxBOukm1lMRiYtc9pH64jXjByXQpaBrzlx2dU7bRQKTEKN9R
         luwRS5lKWKKaWaslNmh/1TdYW7Q7jdgmlQ5k6Vto7NfR+YrlySJjcwQOZNCqQJGK882o
         SUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7yVhTuZZNjpoTXGakcprMEA8nox5i/B4bDVB0Vr09I=;
        b=YazjOQiyP563G1VmxnDS7R3uTuv8hVFPg8XSVaMoP1ySTyRVxX0VdKY6cD/Lotu6t4
         Pt1MnfEC7iNIjdR05sRxbkrgzLjXE3OJQq5iP+JhvMbDoBlICHuIl5O16HROaN5mawrB
         p6p0p8ESbAPdh65hJOoiulcRC/SzwW1jMKVpGiNCiTgp1vbOISkzhxIC1466YpNEUcEs
         lcLJOiqHiN8PXHE+DbZS21UeOz4nd+ES+3M2WYjTm8SR3l1VuvHVey57eHXUHJSooBD0
         0v2wEZKVcr4E79kNY9ZgjR/z4EptNCAJNDAcV7xxeHy+16qFkdOsbfVjKYpZoqTvS73q
         iijg==
X-Gm-Message-State: APjAAAXcUCawz1tlG6JwB5zDCBeimI8PG1kYbc3IORk9IsmfN/WAo6UM
        wOys7MGUb0lVCqfDPRVrSx/fSKSrEBSzzMNz/cU=
X-Google-Smtp-Source: APXvYqydyX/o6ru0CwPkb/sTZ1ewQu/L1WhSoDvNv6rHIOfob/TmmxbwyAMXQQTo5aRjRiE3Ql6STSx3ee4xw6Cx2tE=
X-Received: by 2002:a17:906:b819:: with SMTP id dv25mr30613491ejb.182.1574852428213;
 Wed, 27 Nov 2019 03:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20191127094517.6255-1-Po.Liu@nxp.com> <20191127094517.6255-2-Po.Liu@nxp.com>
In-Reply-To: <20191127094517.6255-2-Po.Liu@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 27 Nov 2019 13:00:17 +0200
Message-ID: <CA+h21hpQLh=7aT68_W9yWuU9PA8rD-tpHjpyijUxMWhnz_tj9g@mail.gmail.com>
Subject: Re: [v1,net-next, 2/2] enetc: implement the enetc 802.1Qbu hardware function
To:     Po Liu <po.liu@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

On Wed, 27 Nov 2019 at 12:01, Po Liu <po.liu@nxp.com> wrote:
>
> The interface follow up the ethtool 'preemption' set/get.
> Hardware features also need to set hw_features with
> NETIF_F_PREEMPTION flag. So ethtool could check kernel
> link features if there is preemption capability of port.
>
> There are two MACs in ENETC. One is express MAC which traffic
> classes in it are advanced transmition. Another is preemptable
> MAC which traffic classes are frame preemptable.
>
> The hardware need to initialize the MACs at initial stage.
> And then set the preemption enable registers of traffic
> classes when ethtool set .get_link_ksettings/.set_link_ksettings
> stage.
>
> To test the ENETC preemption capability, user need to set mqprio
> or taprio to mapping the traffic classes with priorities. Then
> use ethtool command to set 'preemption' with a 8 bits value.
> MSB represent high number traffic class.
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---

Just to clarify, the net-next tree is closed during the following 2
weeks or so, for the 5.5 merge window:
http://vger.kernel.org/~davem/net-next.html
Only bugfix and RFC patches (aka for the sake of discussion) patches
should be sent during this time.
So let's treat this series as RFC.

>  drivers/net/ethernet/freescale/enetc/enetc.c  |   3 +
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
>  .../ethernet/freescale/enetc/enetc_ethtool.c  | 142 ++++++++++++++++--
>  .../net/ethernet/freescale/enetc/enetc_hw.h   |  17 +++
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |  15 +-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |   4 +
>  6 files changed, 174 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 9db1b96ed9b9..be0d9916e6ea 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -750,6 +750,8 @@ void enetc_get_si_caps(struct enetc_si *si)
>
>         if (val & ENETC_SIPCAPR0_QBV)
>                 si->hw_features |= ENETC_SI_F_QBV;
> +       if (val & ENETC_SIPCAPR0_QBU)
> +               si->hw_features |= ENETC_SI_F_QBU;
>  }
>
>  static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
> @@ -1448,6 +1450,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
>         num_tc = mqprio->num_tc;
>
>         if (!num_tc) {
> +               enetc_preemption_set(ndev, 0);
>                 netdev_reset_tc(ndev);
>                 netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> index 7ee0da6d0015..cfa74fa326e8 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> @@ -119,6 +119,7 @@ enum enetc_errata {
>  };
>
>  #define ENETC_SI_F_QBV BIT(0)
> +#define ENETC_SI_F_QBU BIT(1)
>
>  /* PCI IEP device data */
>  struct enetc_si {
> @@ -177,6 +178,7 @@ enum enetc_active_offloads {
>         ENETC_F_RX_TSTAMP       = BIT(0),
>         ENETC_F_TX_TSTAMP       = BIT(1),
>         ENETC_F_QBV             = BIT(2),
> +       ENETC_F_QBU             = BIT(3),
>  };
>
>  struct enetc_ndev_priv {
> @@ -261,3 +263,5 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
>  #define enetc_sched_speed_set(ndev) (void)0
>  #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
>  #endif
> +
> +int enetc_preemption_set(struct net_device *ndev, u32 ptvector);
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index 880a8ed8bb47..4c7425539280 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -183,6 +183,21 @@ static const struct {
>         { ENETC_PICDR(3),   "ICM DR3 discarded frames" },
>  };
>
> +static const struct {
> +       int reg;
> +       char name[ETH_GSTRING_LEN];
> +} enetc_pmac_counters[] = {
> +       { ENETC_PM1_RFRM,   "PMAC rx frames" },
> +       { ENETC_PM1_RPKT,   "PMAC rx packets" },
> +       { ENETC_PM1_RDRP,   "PMAC rx dropped packets" },
> +       { ENETC_PM1_RFRG,   "PMAC rx fragment packets" },
> +       { ENETC_PM1_TFRM,   "PMAC tx frames" },
> +       { ENETC_PM1_TERR,   "PMAC tx error frames" },
> +       { ENETC_PM1_TPKT,   "PMAC tx packets" },
> +       { ENETC_MAC_MERGE_MMFCRXR,   "MAC merge fragment rx counter" },
> +       { ENETC_MAC_MERGE_MMFCTXR,   "MAC merge fragment tx counter"},
> +};
> +
>  static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
>         "Rx ring %2d frames",
>         "Rx ring %2d alloc errors",
> @@ -195,15 +210,24 @@ static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
>  static int enetc_get_sset_count(struct net_device *ndev, int sset)
>  {
>         struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +       int len;
> +
> +       if (sset != ETH_SS_STATS)
> +               return -EOPNOTSUPP;
>
> -       if (sset == ETH_SS_STATS)
> -               return ARRAY_SIZE(enetc_si_counters) +
> -                       ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
> -                       ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings +
> -                       (enetc_si_is_pf(priv->si) ?
> -                       ARRAY_SIZE(enetc_port_counters) : 0);
> +       len = ARRAY_SIZE(enetc_si_counters) +
> +             ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
> +             ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings;
>
> -       return -EOPNOTSUPP;
> +       if (!enetc_si_is_pf(priv->si))
> +               return len;
> +
> +       len += ARRAY_SIZE(enetc_port_counters);
> +
> +       if (priv->active_offloads & ENETC_F_QBU)
> +               len += ARRAY_SIZE(enetc_pmac_counters);
> +
> +       return len;
>  }
>
>  static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
> @@ -241,6 +265,16 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
>                                 ETH_GSTRING_LEN);
>                         p += ETH_GSTRING_LEN;
>                 }
> +
> +               if (!(priv->active_offloads & ENETC_F_QBU))
> +                       break;
> +
> +               for (i = 0; i < ARRAY_SIZE(enetc_pmac_counters); i++) {
> +                       strlcpy(p, enetc_pmac_counters[i].name,
> +                               ETH_GSTRING_LEN);
> +                       p += ETH_GSTRING_LEN;
> +               }
> +
>                 break;
>         }
>  }
> @@ -268,6 +302,12 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
>
>         for (i = 0; i < ARRAY_SIZE(enetc_port_counters); i++)
>                 data[o++] = enetc_port_rd(hw, enetc_port_counters[i].reg);
> +
> +       if (!(priv->active_offloads & ENETC_F_QBU))
> +               return;
> +
> +       for (i = 0; i < ARRAY_SIZE(enetc_pmac_counters); i++)
> +               data[o++] = enetc_port_rd(hw, enetc_pmac_counters[i].reg);
>  }
>
>  #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC | \
> @@ -609,6 +649,90 @@ static int enetc_set_wol(struct net_device *dev,
>         return ret;
>  }
>
> +static u8 enetc_get_tc_num(struct enetc_si *si)
> +{
> +       struct net_device *ndev = si->ndev;
> +       u8 tc_num;
> +
> +       tc_num = (enetc_port_rd(&si->hw, ENETC_PCAPR1)
> +                 & ENETC_NUM_TCS_MASK) >> 4;
> +
> +       return min(netdev_get_num_tc(ndev), tc_num + 1);
> +}
> +
> +int enetc_preemption_set(struct net_device *ndev, u32 ptvector)
> +{
> +       struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +       u8 tc_num;
> +       u32 temp;
> +       int i;
> +
> +       if (ptvector & ~ENETC_QBU_TC_MASK)
> +               return -EINVAL;
> +
> +       temp = enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
> +       if (temp & ENETC_QBV_TGE)
> +               enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
> +                        temp & (~ENETC_QBV_TGPE));
> +
> +       tc_num = enetc_get_tc_num(priv->si);
> +
> +       for (i = 0; i < tc_num; i++) {
> +               temp = enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(i));
> +
> +               if ((ptvector >> i) & 0x1)
> +                       enetc_port_wr(&priv->si->hw,
> +                                     ENETC_PTCFPR(i),
> +                                     temp | ENETC_FPE);
> +               else
> +                       enetc_port_wr(&priv->si->hw,
> +                                     ENETC_PTCFPR(i),
> +                                     temp & ~ENETC_FPE);
> +       }
> +
> +       return 0;
> +}
> +
> +static u32 enetc_preemption_get(struct net_device *ndev)
> +{
> +       struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +       u32 ptvector = 0;
> +       u8 tc_num;
> +       int i;
> +
> +       /* If preemptable MAC is not enable return 0 */
> +       if (!(enetc_port_rd(&priv->si->hw, ENETC_PFPMR) & ENETC_PFPMR_PMACE))
> +               return 0;
> +
> +       tc_num = enetc_get_tc_num(priv->si);
> +
> +       for (i = 0; i < tc_num; i++)
> +               if (enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(i)) & ENETC_FPE)
> +                       ptvector |= 1 << i;
> +
> +       return ptvector;
> +}
> +
> +static int enetc_get_link_ksettings(struct net_device *ndev,
> +                                   struct ethtool_link_ksettings *cmd)
> +{
> +       cmd->base.preemption = enetc_preemption_get(ndev);
> +
> +       return phy_ethtool_get_link_ksettings(ndev, cmd);
> +}
> +
> +static int enetc_set_link_ksettings(struct net_device *ndev,
> +                                   const struct ethtool_link_ksettings *cmd)
> +{
> +       int err;
> +
> +       err = enetc_preemption_set(ndev, cmd->base.preemption);
> +       if (err)
> +               return err;
> +
> +       return phy_ethtool_set_link_ksettings(ndev, cmd);
> +}
> +
>  static const struct ethtool_ops enetc_pf_ethtool_ops = {
>         .get_regs_len = enetc_get_reglen,
>         .get_regs = enetc_get_regs,
> @@ -622,8 +746,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
>         .get_rxfh = enetc_get_rxfh,
>         .set_rxfh = enetc_set_rxfh,
>         .get_ringparam = enetc_get_ringparam,
> -       .get_link_ksettings = phy_ethtool_get_link_ksettings,
> -       .set_link_ksettings = phy_ethtool_set_link_ksettings,
> +       .get_link_ksettings = enetc_get_link_ksettings,
> +       .set_link_ksettings = enetc_set_link_ksettings,
>         .get_link = ethtool_op_get_link,
>         .get_ts_info = enetc_get_ts_info,
>         .get_wol = enetc_get_wol,
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> index 51f543ef37a8..b609ec095710 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -19,6 +19,7 @@
>  #define ENETC_SICTR1   0x1c
>  #define ENETC_SIPCAPR0 0x20
>  #define ENETC_SIPCAPR0_QBV     BIT(4)
> +#define ENETC_SIPCAPR0_QBU     BIT(3)
>  #define ENETC_SIPCAPR0_RSS     BIT(8)
>  #define ENETC_SIPCAPR1 0x24
>  #define ENETC_SITGTGR  0x30
> @@ -176,6 +177,7 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_PCAPR0_RXBDR(val)        ((val) >> 24)
>  #define ENETC_PCAPR0_TXBDR(val)        (((val) >> 16) & 0xff)
>  #define ENETC_PCAPR1           0x0904
> +#define ENETC_NUM_TCS_MASK     GENMASK(6, 4)
>  #define ENETC_PSICFGR0(n)      (0x0940 + (n) * 0xc)  /* n = SI index */
>  #define ENETC_PSICFGR0_SET_TXBDR(val)  ((val) & 0xff)
>  #define ENETC_PSICFGR0_SET_RXBDR(val)  (((val) & 0xff) << 16)
> @@ -223,6 +225,7 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_SET_TX_MTU(val)  ((val) << 16)
>  #define ENETC_SET_MAXFRM(val)  ((val) & 0xffff)
>  #define ENETC_PM0_IF_MODE      0x8300
> +#define ENETC_PM1_IF_MODE       0x9300
>  #define ENETC_PMO_IFM_RG       BIT(2)
>  #define ENETC_PM0_IFM_RLP      (BIT(5) | BIT(11))
>  #define ENETC_PM0_IFM_RGAUTO   (BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
> @@ -276,6 +279,15 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_PM0_TSCOL                0x82E0
>  #define ENETC_PM0_TLCOL                0x82E8
>  #define ENETC_PM0_TECOL                0x82F0
> +#define ENETC_PM1_RFRM         0x9120
> +#define ENETC_PM1_RDRP         0x9158
> +#define ENETC_PM1_RPKT         0x9160
> +#define ENETC_PM1_RFRG         0x91B8
> +#define ENETC_PM1_TFRM         0x9220
> +#define ENETC_PM1_TERR         0x9238
> +#define ENETC_PM1_TPKT         0x9260
> +#define ENETC_MAC_MERGE_MMFCRXR        0x1f14
> +#define ENETC_MAC_MERGE_MMFCTXR        0x1f18
>
>  /* Port counters */
>  #define ENETC_PICDR(n)         (0x0700 + (n) * 8) /* n = [0..3] */
> @@ -615,3 +627,8 @@ struct enetc_cbd {
>  /* Port time gating capability register */
>  #define ENETC_QBV_PTGCAPR_OFFSET       0x11a08
>  #define ENETC_QBV_MAX_GCL_LEN_MASK     GENMASK(15, 0)
> +
> +#define ENETC_QBU_TC_MASK      GENMASK(7, 0)
> +
> +#define ENETC_PTCFPR(n)         (0x1910 + (n) * 4)
> +#define ENETC_FPE               BIT(31)
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index e7482d483b28..f1873c4da77f 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -523,10 +523,15 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
>                       ENETC_PM0_CMD_TXP | ENETC_PM0_PROMISC |
>                       ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
>         /* set auto-speed for RGMII */
> -       if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
> +       if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG) {
>                 enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
> -       if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII)
> +               enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_RGAUTO);
> +       }
> +
> +       if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII) {
>                 enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
> +               enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_XGMII);
> +       }
>  }
>
>  static void enetc_configure_port_pmac(struct enetc_hw *hw)
> @@ -745,6 +750,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
>         if (si->hw_features & ENETC_SI_F_QBV)
>                 priv->active_offloads |= ENETC_F_QBV;
>
> +       if (si->hw_features & ENETC_SI_F_QBU) {
> +               ndev->hw_features |= NETIF_F_PREEMPTION;
> +               ndev->features |= NETIF_F_PREEMPTION;
> +               priv->active_offloads |= ENETC_F_QBU;
> +       }
> +
>         /* pick up primary MAC address from SI */
>         enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
>  }
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 2e99438cb1bf..94dde847d052 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -169,6 +169,10 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
>                                            priv->tx_ring[i]->index,
>                                            taprio->enable ? 0 : i);
>
> +       /* preemption off if TC priority is all 0 */
> +       if ((err && taprio->enable) || !(err || taprio->enable))
> +               enetc_preemption_set(ndev, 0);
> +
>         return err;
>  }
>
> --
> 2.17.1
>

Thanks,
-Vladimir
