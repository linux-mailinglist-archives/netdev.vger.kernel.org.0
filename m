Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16F1AF5BD
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgDRWxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDRWxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:53:10 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F150C061A0C;
        Sat, 18 Apr 2020 15:53:10 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gr25so4634830ejb.10;
        Sat, 18 Apr 2020 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tE8bI/fs2o9FcfSbIk3mSGM3pfDqP5WTGd9o0dNedZY=;
        b=po+EuhEWl19Nz/FQvCGf+YPB0E59xj+kbjnFhF7LU0IDw0Usvu+AspcwJM3crexC7D
         z0QR6jkpUTTyK0KoUXt0Yg67C7pAubpgPNuJYIUcQofLHaeXVL1n0H525mB3pOxXlMQ3
         LbXJRyi7ArCFn40JO0JJqqeDp4c2pbkHZNIsCDEOZnzv+rrjSQSlkNomWSROH3TOhrqm
         ez3WZS85NiiJvO/qZNQiVoEKEJvGt2Whh+vC6oCl7JtXd/ar2gpTMuLqEtY7E/aYlrZ/
         faXEWeR9VSAqruShrrRhWotfBlcoptgxU5ANrp5Rps4MlV+g1mhtFxQ76oaBS1RuxiCc
         sfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tE8bI/fs2o9FcfSbIk3mSGM3pfDqP5WTGd9o0dNedZY=;
        b=UYjgaEfgt9ljNBJbXo33nVdJVqe21t3mFBKUAUsEE3jMgJpkp4OiBDoOwYFLU6u59h
         tHhHgscgPjv3DfxszWEzkbV0BUt5BqTd4hl6v3i4fBqu8qT+tk7A9wAJgm0wW3mfn9zY
         GMpkTS11mk3J5sen+eSfguwrsmLILNxPjcn9EIFB8znkzv2J31wswBAJRXfwAfOD+Kjh
         yhAGRaOhGZUNyGlNAwt8TtDmHwr1879acN8uPGdE07asu5jMWp4uC/UFarNElj3gfWCz
         czWwicE3El/MlfKy7D7nEw7vsr6QPPRnQtEQRFaFyZmtUZCDy4BQ7h/LZCQ50vqewlCc
         JWNg==
X-Gm-Message-State: AGi0PuaU+uDVVitlE3WCu7eDe+GzLCAKQ2E3Nw/iwJRo09eGxNgau5DM
        BVs+VwmivCWH2aAnkVxl5602fmNlwoVrEfKn8q0=
X-Google-Smtp-Source: APiQypJ5vi4ujug8Jn1fFu11Q41OZxpvzYDb54pjEsjA4+VAOFZ6tAcWUMVj9cgaCNedRGOQByG0X3cJ70NlyhPFoUg=
X-Received: by 2002:a17:906:2bd1:: with SMTP id n17mr9277806ejg.176.1587250388571;
 Sat, 18 Apr 2020 15:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200324034745.30979-8-Po.Liu@nxp.com> <20200418011211.31725-1-Po.Liu@nxp.com>
 <20200418011211.31725-5-Po.Liu@nxp.com>
In-Reply-To: <20200418011211.31725-5-Po.Liu@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 19 Apr 2020 01:52:57 +0300
Message-ID: <CA+h21hqwtg5zYfiZmFb0Bmq5_oUwJO9wZDr+N5D_8=nrHhjjNg@mail.gmail.com>
Subject: Re: [ v2,net-next 4/4] net: enetc: add tc flower psfp offload driver
To:     Po Liu <Po.Liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

On Sat, 18 Apr 2020 at 04:35, Po Liu <Po.Liu@nxp.com> wrote:
>
> This patch is to add tc flower offload for the enetc IEEE 802.1Qci(PSFP)
> function. There are four main feature parts to implement the flow
> policing and filtering for ingress flow with IEEE 802.1Qci features.
> They are stream identify(this is defined in the P802.1cb exactly but
> needed for 802.1Qci), stream filtering, stream gate and flow metering.
> Each function block includes many entries by index to assign parameters.
> So for one frame would be filtered by stream identify first, then
> flow into stream filter block by the same handle between stream identify
> and stream filtering. Then flow into stream gate control which assigned
> by the stream filtering entry. And then policing by the gate and limited
> by the max sdu in the filter block(optional). At last, policing by the
> flow metering block, index choosing at the fitering block.
> So you can see that each entry of block may link to many upper entries
> since they can be assigned same index means more streams want to share
> the same feature in the stream filtering or stream gate or flow
> metering.
> To implement such features, each stream filtered by source/destination
> mac address, some stream maybe also plus the vlan id value would be
> treated as one flow chain. This would be identified by the chain_index
> which already in the tc filter concept. Driver would maintain this chain
> and also with gate modules. The stream filter entry create by the gate
> index and flow meter(optional) entry id and also one priority value.
> Offloading only transfer the gate action and flow filtering parameters.
> Driver would create (or search same gate id and flow meter id and
>  priority) one stream filter entry to set to the hardware. So stream
> filtering do not need transfer by the action offloading.
> This architecture is same with tc filter and actions relationship. tc
> filter maintain the list for each flow feature by keys. And actions
> maintain by the action list.
>
> Below showing a example commands by tc:
> > tc qdisc add dev eth0 ingress
> > ip link set eth0 address 10:00:80:00:00:00
> > tc filter add dev eth0 parent ffff: protocol ip chain 11 \
>         flower skip_sw dst_mac 10:00:80:00:00:00 \
>         action gate index 10 \
>         sched-entry OPEN 200000000 1 8000000 \
>         sched-entry CLOSE 100000000 -1 -1
>
> Command means to set the dst_mac 10:00:80:00:00:00 to index 11 of stream
> identify module. And the set the gate index 10 of stream gate module.
> The gate list is keeping OPEN state 200ms, and through the frames to the
> ingress queue 1, and max octets are the 8Mbytes.
>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c  |   25 +-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   46 +-
>  .../net/ethernet/freescale/enetc/enetc_hw.h   |  142 +++
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |    4 +-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  | 1070 +++++++++++++++++
>  5 files changed, 1272 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/e=
thernet/freescale/enetc/enetc.c
> index 04aac7cbb506..298c55786fd9 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1521,6 +1521,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc=
_setup_type type,
>                 return enetc_setup_tc_cbs(ndev, type_data);
>         case TC_SETUP_QDISC_ETF:
>                 return enetc_setup_tc_txtime(ndev, type_data);
> +       case TC_SETUP_BLOCK:
> +               return enetc_setup_tc_psfp(ndev, type_data);
>         default:
>                 return -EOPNOTSUPP;
>         }
> @@ -1573,17 +1575,23 @@ static int enetc_set_rss(struct net_device *ndev,=
 int en)
>  static int enetc_set_psfp(struct net_device *ndev, int en)
>  {
>         struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> +       int err;
>
>         if (en) {
> +               err =3D enetc_psfp_enable(priv);
> +               if (err)
> +                       return err;
> +
>                 priv->active_offloads |=3D ENETC_F_QCI;
> -               enetc_get_max_cap(priv);
> -               enetc_psfp_enable(&priv->si->hw);
> -       } else {
> -               priv->active_offloads &=3D ~ENETC_F_QCI;
> -               memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
> -               enetc_psfp_disable(&priv->si->hw);
> +               return 0;
>         }
>
> +       err =3D enetc_psfp_disable(priv);
> +       if (err)
> +               return err;
> +
> +       priv->active_offloads &=3D ~ENETC_F_QCI;
> +
>         return 0;
>  }
>
> @@ -1591,14 +1599,15 @@ int enetc_set_features(struct net_device *ndev,
>                        netdev_features_t features)
>  {
>         netdev_features_t changed =3D ndev->features ^ features;
> +       int err =3D 0;
>
>         if (changed & NETIF_F_RXHASH)
>                 enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
>
>         if (changed & NETIF_F_HW_TC)
> -               enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
> +               err =3D enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC)=
);
>
> -       return 0;
> +       return err;
>  }
>
>  #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/e=
thernet/freescale/enetc/enetc.h
> index 2cfe877c3778..b705464f6882 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> @@ -300,6 +300,11 @@ int enetc_setup_tc_taprio(struct net_device *ndev, v=
oid *type_data);
>  void enetc_sched_speed_set(struct net_device *ndev);
>  int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
>  int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
> +int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
> +                           void *cb_priv);
> +int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
> +int enetc_psfp_init(struct enetc_ndev_priv *priv);
> +int enetc_psfp_clean(struct enetc_ndev_priv *priv);
>
>  static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
>  {
> @@ -319,27 +324,60 @@ static inline void enetc_get_max_cap(struct enetc_n=
dev_priv *priv)
>         priv->psfp_cap.max_psfp_meter =3D reg & ENETC_PFMCAPR_MSK;
>  }
>
> -static inline void enetc_psfp_enable(struct enetc_hw *hw)
> +static inline int enetc_psfp_enable(struct enetc_ndev_priv *priv)
>  {
> +       struct enetc_hw *hw =3D &priv->si->hw;
> +       int err;
> +
> +       enetc_get_max_cap(priv);
> +
> +       err =3D enetc_psfp_init(priv);
> +       if (err)
> +               return err;
> +
>         enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) |
>                  ENETC_PPSFPMR_PSFPEN | ENETC_PPSFPMR_VS |
>                  ENETC_PPSFPMR_PVC | ENETC_PPSFPMR_PVZC);
> +
> +       return 0;
>  }
>
> -static inline void enetc_psfp_disable(struct enetc_hw *hw)
> +static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
>  {
> +       struct enetc_hw *hw =3D &priv->si->hw;
> +       int err;
> +
> +       err =3D enetc_psfp_clean(priv);
> +       if (err)
> +               return err;
> +
>         enetc_wr(hw, ENETC_PPSFPMR, enetc_rd(hw, ENETC_PPSFPMR) &
>                  ~ENETC_PPSFPMR_PSFPEN & ~ENETC_PPSFPMR_VS &
>                  ~ENETC_PPSFPMR_PVC & ~ENETC_PPSFPMR_PVZC);
> +
> +       memset(&priv->psfp_cap, 0, sizeof(struct psfp_cap));
> +
> +       return 0;
>  }
> +
>  #else
>  #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
>  #define enetc_sched_speed_set(ndev) (void)0
>  #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
>  #define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
> +#define enetc_setup_tc_psfp(ndev, type_data) -EOPNOTSUPP
> +#define enetc_setup_tc_block_cb NULL
> +
>  #define enetc_get_max_cap(p)           \
>         memset(&((p)->psfp_cap), 0, sizeof(struct psfp_cap))
>
> -#define enetc_psfp_enable(hw) (void)0
> -#define enetc_psfp_disable(hw) (void)0
> +static inline int enetc_psfp_enable(struct enetc_ndev_priv *priv)
> +{
> +       return 0;
> +}
> +
> +static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
> +{
> +       return 0;
> +}
>  #endif
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/ne=
t/ethernet/freescale/enetc/enetc_hw.h
> index 587974862f48..6314051bc6c1 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -567,6 +567,9 @@ enum bdcr_cmd_class {
>         BDCR_CMD_RFS,
>         BDCR_CMD_PORT_GCL,
>         BDCR_CMD_RECV_CLASSIFIER,
> +       BDCR_CMD_STREAM_IDENTIFY,
> +       BDCR_CMD_STREAM_FILTER,
> +       BDCR_CMD_STREAM_GCL,
>         __BDCR_CMD_MAX_LEN,
>         BDCR_CMD_MAX_LEN =3D __BDCR_CMD_MAX_LEN - 1,
>  };
> @@ -598,13 +601,152 @@ struct tgs_gcl_data {
>         struct gce      entry[];
>  };
>
> +/* class 7, command 0, Stream Identity Entry Configuration */
> +struct streamid_conf {
> +       __le32  stream_handle;  /* init gate value */
> +       __le32  iports;
> +               u8      id_type;
> +               u8      oui[3];
> +               u8      res[3];
> +               u8      en;
> +};
> +
> +#define ENETC_CBDR_SID_VID_MASK 0xfff
> +#define ENETC_CBDR_SID_VIDM BIT(12)
> +#define ENETC_CBDR_SID_TG_MASK 0xc000
> +/* streamid_conf address point to this data space */
> +struct streamid_data {
> +       union {
> +               u8 dmac[6];
> +               u8 smac[6];
> +       };
> +       u16     vid_vidm_tg;
> +};
> +
> +#define ENETC_CBDR_SFI_PRI_MASK 0x7
> +#define ENETC_CBDR_SFI_PRIM            BIT(3)
> +#define ENETC_CBDR_SFI_BLOV            BIT(4)
> +#define ENETC_CBDR_SFI_BLEN            BIT(5)
> +#define ENETC_CBDR_SFI_MSDUEN  BIT(6)
> +#define ENETC_CBDR_SFI_FMITEN  BIT(7)
> +#define ENETC_CBDR_SFI_ENABLE  BIT(7)
> +/* class 8, command 0, Stream Filter Instance, Short Format */
> +struct sfi_conf {
> +       __le32  stream_handle;
> +               u8      multi;
> +               u8      res[2];
> +               u8      sthm;
> +       /* Max Service Data Unit or Flow Meter Instance Table index.
> +        * Depending on the value of FLT this represents either Max
> +        * Service Data Unit (max frame size) allowed by the filter
> +        * entry or is an index into the Flow Meter Instance table
> +        * index identifying the policer which will be used to police
> +        * it.
> +        */
> +       __le16  fm_inst_table_index;
> +       __le16  msdu;
> +       __le16  sg_inst_table_index;
> +               u8      res1[2];
> +       __le32  input_ports;
> +               u8      res2[3];
> +               u8      en;
> +};
> +
> +/* class 8, command 2 stream Filter Instance status query short format
> + * command no need structure define
> + * Stream Filter Instance Query Statistics Response data
> + */
> +struct sfi_counter_data {
> +       u32 matchl;
> +       u32 matchh;
> +       u32 msdu_dropl;
> +       u32 msdu_droph;
> +       u32 stream_gate_dropl;
> +       u32 stream_gate_droph;
> +       u32 flow_meter_dropl;
> +       u32 flow_meter_droph;
> +};
> +
> +#define ENETC_CBDR_SGI_OIPV_MASK 0x7
> +#define ENETC_CBDR_SGI_OIPV_EN BIT(3)
> +#define ENETC_CBDR_SGI_CGTST   BIT(6)
> +#define ENETC_CBDR_SGI_OGTST   BIT(7)
> +#define ENETC_CBDR_SGI_CFG_CHG  BIT(1)
> +#define ENETC_CBDR_SGI_CFG_PND  BIT(2)
> +#define ENETC_CBDR_SGI_OEX             BIT(4)
> +#define ENETC_CBDR_SGI_OEXEN   BIT(5)
> +#define ENETC_CBDR_SGI_IRX             BIT(6)
> +#define ENETC_CBDR_SGI_IRXEN   BIT(7)
> +#define ENETC_CBDR_SGI_ACLLEN_MASK 0x3
> +#define ENETC_CBDR_SGI_OCLLEN_MASK 0xc
> +#define        ENETC_CBDR_SGI_EN               BIT(7)
> +/* class 9, command 0, Stream Gate Instance Table, Short Format
> + * class 9, command 2, Stream Gate Instance Table entry query write back
> + * Short Format
> + */
> +struct sgi_table {
> +       u8      res[8];
> +       u8      oipv;
> +       u8      res0[2];
> +       u8      ocgtst;
> +       u8      res1[7];
> +       u8      gset;
> +       u8      oacl_len;
> +       u8      res2[2];
> +       u8      en;
> +};
> +
> +#define ENETC_CBDR_SGI_AIPV_MASK 0x7
> +#define ENETC_CBDR_SGI_AIPV_EN BIT(3)
> +#define ENETC_CBDR_SGI_AGTST   BIT(7)
> +
> +/* class 9, command 1, Stream Gate Control List, Long Format */
> +struct sgcl_conf {
> +       u8      aipv;
> +       u8      res[2];
> +       u8      agtst;
> +       u8      res1[4];
> +       union {
> +               struct {
> +                       u8 res2[4];
> +                       u8 acl_len;
> +                       u8 res3[3];
> +               };
> +               u8 cct[8]; /* Config change time */
> +       };
> +};
> +
> +#define ENETC_CBDR_SGL_IOMEN   BIT(0)
> +#define ENETC_CBDR_SGL_IPVEN   BIT(3)
> +#define ENETC_CBDR_SGL_GTST            BIT(4)
> +#define ENETC_CBDR_SGL_IPV_MASK 0xe
> +/* Stream Gate Control List Entry */
> +struct sgce {
> +       u32     interval;
> +       u8      msdu[3];
> +       u8      multi;
> +};
> +
> +/* stream control list class 9 , cmd 1 data buffer */
> +struct sgcl_data {
> +       u32             btl;
> +       u32             bth;
> +       u32             ct;
> +       u32             cte;
> +       struct sgce     sgcl[0];
> +};
> +
>  struct enetc_cbd {
>         union{
> +               struct sfi_conf sfi_conf;
> +               struct sgi_table sgi_table;
>                 struct {
>                         __le32  addr[2];
>                         union {
>                                 __le32  opt[4];
>                                 struct tgs_gcl_conf     gcl_conf;
> +                               struct streamid_conf    sid_set;
> +                               struct sgcl_conf        sgcl_conf;
>                         };
>                 };      /* Long format */
>                 __le32 data[6];
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/ne=
t/ethernet/freescale/enetc/enetc_pf.c
> index eacd597b55f2..d06fce0dcd8a 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -739,12 +739,10 @@ static void enetc_pf_netdev_setup(struct enetc_si *=
si, struct net_device *ndev,
>         if (si->hw_features & ENETC_SI_F_QBV)
>                 priv->active_offloads |=3D ENETC_F_QBV;
>
> -       if (si->hw_features & ENETC_SI_F_PSFP) {
> +       if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)=
) {
>                 priv->active_offloads |=3D ENETC_F_QCI;
>                 ndev->features |=3D NETIF_F_HW_TC;
>                 ndev->hw_features |=3D NETIF_F_HW_TC;
> -               enetc_get_max_cap(priv);
> -               enetc_psfp_enable(&si->hw);
>         }
>
>         /* pick up primary MAC address from SI */
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/n=
et/ethernet/freescale/enetc/enetc_qos.c
> index 0c6bf3a55a9a..7944c243903c 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -5,6 +5,9 @@
>
>  #include <net/pkt_sched.h>
>  #include <linux/math64.h>
> +#include <linux/refcount.h>
> +#include <net/pkt_cls.h>
> +#include <net/tc_act/tc_gate.h>
>
>  static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
>  {
> @@ -331,3 +334,1070 @@ int enetc_setup_tc_txtime(struct net_device *ndev,=
 void *type_data)
>
>         return 0;
>  }
> +
> +enum streamid_type {
> +       STREAMID_TYPE_RESERVED =3D 0,
> +       STREAMID_TYPE_NULL,
> +       STREAMID_TYPE_SMAC,
> +};
> +
> +enum streamid_vlan_tagged {
> +       STREAMID_VLAN_RESERVED =3D 0,
> +       STREAMID_VLAN_TAGGED,
> +       STREAMID_VLAN_UNTAGGED,
> +       STREAMID_VLAN_ALL,
> +};
> +
> +#define ENETC_PSFP_WILDCARD -1
> +#define HANDLE_OFFSET 100
> +
> +enum forward_type {
> +       FILTER_ACTION_TYPE_PSFP =3D BIT(0),
> +       FILTER_ACTION_TYPE_ACL =3D BIT(1),
> +       FILTER_ACTION_TYPE_BOTH =3D GENMASK(1, 0),
> +};
> +
> +/* This is for limit output type for input actions */
> +struct actions_fwd {
> +       u64 actions;
> +       u64 keys;       /* include the must needed keys */
> +       enum forward_type output;
> +};
> +
> +struct psfp_streamfilter_counters {
> +       u64 matching_frames_count;
> +       u64 passing_frames_count;
> +       u64 not_passing_frames_count;
> +       u64 passing_sdu_count;
> +       u64 not_passing_sdu_count;
> +       u64 red_frames_count;
> +};
> +
> +struct enetc_streamid {
> +       u32 index;
> +       union {
> +               u8 src_mac[6];
> +               u8 dst_mac[6];
> +       };
> +       u8 filtertype;
> +       u16 vid;
> +       u8 tagged;
> +       s32 handle;
> +};
> +
> +struct enetc_psfp_filter {
> +       u32 index;
> +       s32 handle;
> +       s8 prio;
> +       u32 gate_id;
> +       s32 meter_id;
> +       refcount_t refcount;
> +       struct hlist_node node;
> +};
> +
> +struct enetc_psfp_gate {
> +       u32 index;
> +       s8 init_ipv;
> +       u64 basetime;
> +       u64 cycletime;
> +       u64 cycletimext;
> +       u32 num_entries;
> +       refcount_t refcount;
> +       struct hlist_node node;
> +       struct action_gate_entry entries[0];
> +};
> +
> +struct enetc_stream_filter {
> +       struct enetc_streamid sid;
> +       u32 sfi_index;
> +       u32 sgi_index;
> +       struct flow_stats stats;
> +       struct hlist_node node;
> +};
> +
> +struct enetc_psfp {
> +       unsigned long dev_bitmap;
> +       unsigned long *psfp_sfi_bitmap;
> +       struct hlist_head stream_list;
> +       struct hlist_head psfp_filter_list;
> +       struct hlist_head psfp_gate_list;
> +       spinlock_t psfp_lock; /* spinlock for the struct enetc_psfp r/w *=
/
> +};
> +
> +struct actions_fwd enetc_act_fwd[] =3D {
> +       {
> +               BIT(FLOW_ACTION_GATE),
> +               BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS),
> +               FILTER_ACTION_TYPE_PSFP
> +       },
> +       /* example for ACL actions */
> +       {
> +               BIT(FLOW_ACTION_DROP),
> +               0,
> +               FILTER_ACTION_TYPE_ACL
> +       }
> +};
> +
> +static struct enetc_psfp epsfp =3D {
> +       .psfp_sfi_bitmap =3D NULL,
> +};
> +
> +static LIST_HEAD(enetc_block_cb_list);
> +
> +static inline int enetc_get_port(struct enetc_ndev_priv *priv)
> +{
> +       return priv->si->pdev->devfn & 0x7;
> +}
> +
> +/* Stream Identity Entry Set Descriptor */
> +static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
> +                                struct enetc_streamid *sid,
> +                                u8 enable)
> +{
> +       struct enetc_cbd cbd =3D {.cmd =3D 0};
> +       struct streamid_data *si_data;
> +       struct streamid_conf *si_conf;
> +       u16 data_size;
> +       dma_addr_t dma;
> +       int err;
> +
> +       if (sid->index >=3D priv->psfp_cap.max_streamid)
> +               return -EINVAL;
> +
> +       if (sid->filtertype !=3D STREAMID_TYPE_NULL &&
> +           sid->filtertype !=3D STREAMID_TYPE_SMAC)
> +               return -EOPNOTSUPP;
> +
> +       /* Disable operation before enable */
> +       cbd.index =3D cpu_to_le16((u16)sid->index);
> +       cbd.cls =3D BDCR_CMD_STREAM_IDENTIFY;
> +       cbd.status_flags =3D 0;
> +
> +       data_size =3D sizeof(struct streamid_data);
> +       si_data =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
> +       cbd.length =3D cpu_to_le16(data_size);
> +
> +       dma =3D dma_map_single(&priv->si->pdev->dev, si_data,
> +                            data_size, DMA_FROM_DEVICE);
> +       if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
> +               netdev_err(priv->si->ndev, "DMA mapping failed!\n");
> +               kfree(si_data);
> +               return -ENOMEM;
> +       }
> +
> +       cbd.addr[0] =3D lower_32_bits(dma);
> +       cbd.addr[1] =3D upper_32_bits(dma);
> +       memset(si_data->dmac, 0xff, ETH_ALEN);
> +       si_data->vid_vidm_tg =3D
> +               cpu_to_le16(ENETC_CBDR_SID_VID_MASK
> +                           + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
> +
> +       si_conf =3D &cbd.sid_set;
> +       /* Only one port supported for one entry, set itself */
> +       si_conf->iports =3D 1 << enetc_get_port(priv);
> +       si_conf->id_type =3D 1;
> +       si_conf->oui[2] =3D 0x0;
> +       si_conf->oui[1] =3D 0x80;
> +       si_conf->oui[0] =3D 0xC2;
> +
> +       err =3D enetc_send_cmd(priv->si, &cbd);
> +       if (err)
> +               return -EINVAL;
> +
> +       if (!enable) {
> +               kfree(si_data);
> +               return 0;
> +       }
> +
> +       /* Enable the entry overwrite again incase space flushed by hardw=
are */
> +       memset(&cbd, 0, sizeof(cbd));
> +
> +       cbd.index =3D cpu_to_le16((u16)sid->index);
> +       cbd.cmd =3D 0;
> +       cbd.cls =3D BDCR_CMD_STREAM_IDENTIFY;
> +       cbd.status_flags =3D 0;
> +
> +       si_conf->en =3D 0x80;
> +       si_conf->stream_handle =3D cpu_to_le32(sid->handle);
> +       si_conf->iports =3D 1 << enetc_get_port(priv);
> +       si_conf->id_type =3D sid->filtertype;
> +       si_conf->oui[2] =3D 0x0;
> +       si_conf->oui[1] =3D 0x80;
> +       si_conf->oui[0] =3D 0xC2;
> +
> +       memset(si_data, 0, data_size);
> +
> +       cbd.length =3D cpu_to_le16(data_size);
> +
> +       cbd.addr[0] =3D lower_32_bits(dma);
> +       cbd.addr[1] =3D upper_32_bits(dma);
> +
> +       /* VIDM default to be 1.
> +        * VID Match. If set (b1) then the VID must match, otherwise
> +        * any VID is considered a match. VIDM setting is only used
> +        * when TG is set to b01.
> +        */
> +       if (si_conf->id_type =3D=3D STREAMID_TYPE_NULL) {
> +               ether_addr_copy(si_data->dmac, sid->dst_mac);
> +               si_data->vid_vidm_tg =3D
> +               cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
> +                           ((((u16)(sid->tagged) & 0x3) << 14)
> +                            | ENETC_CBDR_SID_VIDM));
> +       } else if (si_conf->id_type =3D=3D STREAMID_TYPE_SMAC) {
> +               ether_addr_copy(si_data->smac, sid->src_mac);
> +               si_data->vid_vidm_tg =3D
> +               cpu_to_le16((sid->vid & ENETC_CBDR_SID_VID_MASK) +
> +                           ((((u16)(sid->tagged) & 0x3) << 14)
> +                            | ENETC_CBDR_SID_VIDM));
> +       }
> +
> +       err =3D enetc_send_cmd(priv->si, &cbd);
> +       kfree(si_data);
> +
> +       return err;
> +}
> +
> +/* Stream Filter Instance Set Descriptor */
> +static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
> +                                    struct enetc_psfp_filter *sfi,
> +                                    u8 enable)
> +{
> +       struct enetc_cbd cbd =3D {.cmd =3D 0};
> +       struct sfi_conf *sfi_config;
> +
> +       cbd.index =3D cpu_to_le16(sfi->index);
> +       cbd.cls =3D BDCR_CMD_STREAM_FILTER;
> +       cbd.status_flags =3D 0x80;
> +       cbd.length =3D cpu_to_le16(1);
> +
> +       sfi_config =3D &cbd.sfi_conf;
> +       if (!enable)
> +               goto exit;
> +
> +       sfi_config->en =3D 0x80;
> +
> +       if (sfi->handle >=3D 0) {
> +               sfi_config->stream_handle =3D
> +                       cpu_to_le32(sfi->handle);
> +               sfi_config->sthm |=3D 0x80;
> +       }
> +
> +       sfi_config->sg_inst_table_index =3D cpu_to_le16(sfi->gate_id);
> +       sfi_config->input_ports =3D 1 << enetc_get_port(priv);
> +
> +       /* The priority value which may be matched against the
> +        * frame=E2=80=99s priority value to determine a match for this e=
ntry.
> +        */
> +       if (sfi->prio >=3D 0)
> +               sfi_config->multi |=3D (sfi->prio & 0x7) | 0x8;
> +
> +       /* Filter Type. Identifies the contents of the MSDU/FM_INST_INDEX
> +        * field as being either an MSDU value or an index into the Flow
> +        * Meter Instance table.
> +        * TODO: no limit max sdu
> +        */
> +
> +       if (sfi->meter_id >=3D 0) {
> +               sfi_config->fm_inst_table_index =3D cpu_to_le16(sfi->mete=
r_id);
> +               sfi_config->multi |=3D 0x80;
> +       }
> +
> +exit:
> +       return enetc_send_cmd(priv->si, &cbd);
> +}
> +
> +static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
> +                                     u32 index,
> +                                     struct psfp_streamfilter_counters *=
cnt)
> +{
> +       struct enetc_cbd cbd =3D { .cmd =3D 2 };
> +       struct sfi_counter_data *data_buf;
> +       dma_addr_t dma;
> +       u16 data_size;
> +       int err;
> +
> +       cbd.index =3D cpu_to_le16((u16)index);
> +       cbd.cmd =3D 2;
> +       cbd.cls =3D BDCR_CMD_STREAM_FILTER;
> +       cbd.status_flags =3D 0;
> +
> +       data_size =3D sizeof(struct sfi_counter_data);
> +       data_buf =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
> +       if (!data_buf)
> +               return -ENOMEM;
> +
> +       dma =3D dma_map_single(&priv->si->pdev->dev, data_buf,
> +                            data_size, DMA_FROM_DEVICE);
> +       if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
> +               netdev_err(priv->si->ndev, "DMA mapping failed!\n");
> +               err =3D -ENOMEM;
> +               goto exit;
> +       }
> +       cbd.addr[0] =3D lower_32_bits(dma);
> +       cbd.addr[1] =3D upper_32_bits(dma);
> +
> +       cbd.length =3D cpu_to_le16(data_size);
> +
> +       err =3D enetc_send_cmd(priv->si, &cbd);
> +       if (err)
> +               goto exit;
> +
> +       cnt->matching_frames_count =3D
> +                       ((u64)le32_to_cpu(data_buf->matchh) << 32)
> +                       + data_buf->matchl;
> +
> +       cnt->not_passing_sdu_count =3D
> +                       ((u64)le32_to_cpu(data_buf->msdu_droph) << 32)
> +                       + data_buf->msdu_dropl;
> +
> +       cnt->passing_sdu_count =3D cnt->matching_frames_count
> +                               - cnt->not_passing_sdu_count;
> +
> +       cnt->not_passing_frames_count =3D
> +               ((u64)le32_to_cpu(data_buf->stream_gate_droph) << 32)
> +               + le32_to_cpu(data_buf->stream_gate_dropl);
> +
> +       cnt->passing_frames_count =3D cnt->matching_frames_count
> +                               - cnt->not_passing_sdu_count
> +                               - cnt->not_passing_frames_count;
> +
> +       cnt->red_frames_count =3D
> +               ((u64)le32_to_cpu(data_buf->flow_meter_droph) << 32)
> +               + le32_to_cpu(data_buf->flow_meter_dropl);
> +
> +exit:
> +       kfree(data_buf);
> +       return err;
> +}
> +
> +static int get_start_ns(struct enetc_ndev_priv *priv, u64 cycle, u64 *st=
art)
> +{
> +       u64 now_lo, now_hi, now, n;
> +
> +       now_lo =3D enetc_rd(&priv->si->hw, ENETC_SICTR0);
> +       now_hi =3D enetc_rd(&priv->si->hw, ENETC_SICTR1);
> +       now =3D now_lo | now_hi << 32;
> +
> +       if (WARN_ON(!cycle))
> +               return -EFAULT;
> +
> +       n =3D div64_u64(now, cycle);
> +
> +       *start =3D (n + 1) * cycle;
> +
> +       return 0;
> +}
> +
> +/* Stream Gate Instance Set Descriptor */
> +static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
> +                                  struct enetc_psfp_gate *sgi,
> +                                  u8 enable)
> +{
> +       struct enetc_cbd cbd =3D { .cmd =3D 0 };
> +       struct sgi_table *sgi_config;
> +       struct sgcl_conf *sgcl_config;
> +       struct sgcl_data *sgcl_data;
> +       struct sgce *sgce;
> +       dma_addr_t dma;
> +       u16 data_size;
> +       int err, i;
> +
> +       cbd.index =3D cpu_to_le16(sgi->index);
> +       cbd.cmd =3D 0;
> +       cbd.cls =3D BDCR_CMD_STREAM_GCL;
> +       cbd.status_flags =3D 0x80;
> +
> +       /* disable */
> +       if (!enable)
> +               return enetc_send_cmd(priv->si, &cbd);
> +
> +       if (!sgi->num_entries)
> +               return 0;
> +
> +       if (sgi->num_entries > priv->psfp_cap.max_psfp_gatelist ||
> +           !sgi->cycletime)
> +               return -EINVAL;
> +
> +       /* enable */
> +       sgi_config =3D &cbd.sgi_table;
> +
> +       /* Keep open before gate list start */
> +       sgi_config->ocgtst =3D 0x80;
> +
> +       sgi_config->oipv =3D (sgi->init_ipv < 0) ?
> +                               0x0 : ((sgi->init_ipv & 0x7) | 0x8);
> +
> +       sgi_config->en =3D 0x80;
> +
> +       /* Basic config */
> +       err =3D enetc_send_cmd(priv->si, &cbd);
> +       if (err)
> +               return -EINVAL;
> +
> +       memset(&cbd, 0, sizeof(cbd));
> +
> +       cbd.index =3D cpu_to_le16(sgi->index);
> +       cbd.cmd =3D 1;
> +       cbd.cls =3D BDCR_CMD_STREAM_GCL;
> +       cbd.status_flags =3D 0;
> +
> +       sgcl_config =3D &cbd.sgcl_conf;
> +
> +       sgcl_config->acl_len =3D (sgi->num_entries - 1) & 0x3;
> +
> +       data_size =3D struct_size(sgcl_data, sgcl, sgi->num_entries);
> +
> +       sgcl_data =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
> +       if (!sgcl_data)
> +               return -ENOMEM;
> +
> +       cbd.length =3D cpu_to_le16(data_size);
> +
> +       dma =3D dma_map_single(&priv->si->pdev->dev,
> +                            sgcl_data, data_size,
> +                            DMA_FROM_DEVICE);
> +       if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
> +               netdev_err(priv->si->ndev, "DMA mapping failed!\n");
> +               kfree(sgcl_data);
> +               return -ENOMEM;
> +       }
> +
> +       cbd.addr[0] =3D lower_32_bits(dma);
> +       cbd.addr[1] =3D upper_32_bits(dma);
> +
> +       sgce =3D &sgcl_data->sgcl[0];
> +
> +       sgcl_config->agtst =3D 0x80;
> +
> +       sgcl_data->ct =3D cpu_to_le32(sgi->cycletime);
> +       sgcl_data->cte =3D cpu_to_le32(sgi->cycletimext);
> +
> +       if (sgi->init_ipv >=3D 0)
> +               sgcl_config->aipv =3D (sgi->init_ipv & 0x7) | 0x8;
> +
> +       for (i =3D 0; i < sgi->num_entries; i++) {
> +               struct action_gate_entry *from =3D &sgi->entries[i];
> +               struct sgce *to =3D &sgce[i];
> +
> +               if (from->gate_state)
> +                       to->multi |=3D 0x10;
> +
> +               if (from->ipv >=3D 0)
> +                       to->multi |=3D ((from->ipv & 0x7) << 5) | 0x08;
> +
> +               if (from->maxoctets)
> +                       to->multi |=3D 0x01;
> +
> +               to->interval =3D cpu_to_le32(from->interval);
> +               to->msdu[0] =3D from->maxoctets & 0xFF;
> +               to->msdu[1] =3D (from->maxoctets >> 8) & 0xFF;
> +               to->msdu[2] =3D (from->maxoctets >> 16) & 0xFF;
> +       }
> +
> +       /* If basetime is 0, calculate start time */
> +       if (!sgi->basetime) {
> +               u64 start;
> +
> +               err =3D get_start_ns(priv, sgi->cycletime, &start);
> +               if (err)
> +                       goto exit;
> +               sgcl_data->btl =3D cpu_to_le32(lower_32_bits(start));
> +               sgcl_data->bth =3D cpu_to_le32(upper_32_bits(start));
> +       } else {
> +               u32 hi, lo;
> +
> +               hi =3D upper_32_bits(sgi->basetime);
> +               lo =3D lower_32_bits(sgi->basetime);
> +               sgcl_data->bth =3D cpu_to_le32(hi);
> +               sgcl_data->btl =3D cpu_to_le32(lo);
> +       }
> +
> +       err =3D enetc_send_cmd(priv->si, &cbd);
> +
> +exit:
> +       kfree(sgcl_data);
> +
> +       return err;
> +}
> +
> +static struct enetc_stream_filter *enetc_get_stream_by_index(u32 index)
> +{
> +       struct enetc_stream_filter *f;
> +
> +       hlist_for_each_entry(f, &epsfp.stream_list, node)
> +               if (f->sid.index =3D=3D index)
> +                       return f;
> +
> +       return NULL;
> +}
> +
> +static struct enetc_psfp_gate *enetc_get_gate_by_index(u32 index)
> +{
> +       struct enetc_psfp_gate *g;
> +
> +       hlist_for_each_entry(g, &epsfp.psfp_gate_list, node)
> +               if (g->index =3D=3D index)
> +                       return g;
> +
> +       return NULL;
> +}
> +
> +static struct enetc_psfp_filter *enetc_get_filter_by_index(u32 index)
> +{
> +       struct enetc_psfp_filter *s;
> +
> +       hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
> +               if (s->index =3D=3D index)
> +                       return s;
> +
> +       return NULL;
> +}
> +
> +static struct enetc_psfp_filter
> +       *enetc_psfp_check_sfi(struct enetc_psfp_filter *sfi)
> +{
> +       struct enetc_psfp_filter *s;
> +
> +       hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
> +               if (s->gate_id =3D=3D sfi->gate_id &&
> +                   s->prio =3D=3D sfi->prio &&
> +                   s->meter_id =3D=3D sfi->meter_id)
> +                       return s;
> +
> +       return NULL;
> +}
> +
> +static int enetc_get_free_index(struct enetc_ndev_priv *priv)
> +{
> +       u32 max_size =3D priv->psfp_cap.max_psfp_filter;
> +       unsigned long index;
> +
> +       index =3D find_first_zero_bit(epsfp.psfp_sfi_bitmap, max_size);
> +       if (index =3D=3D max_size)
> +               return -1;
> +
> +       return index;
> +}
> +
> +static void stream_filter_unref(struct enetc_ndev_priv *priv, u32 index)
> +{
> +       struct enetc_psfp_filter *sfi;
> +       u8 z;
> +
> +       sfi =3D enetc_get_filter_by_index(index);
> +       WARN_ON(!sfi);
> +       z =3D refcount_dec_and_test(&sfi->refcount);
> +
> +       if (z) {
> +               enetc_streamfilter_hw_set(priv, sfi, false);
> +               hlist_del(&sfi->node);
> +               kfree(sfi);
> +               clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);
> +       }
> +}
> +
> +static void stream_gate_unref(struct enetc_ndev_priv *priv, u32 index)
> +{
> +       struct enetc_psfp_gate *sgi;
> +       u8 z;
> +
> +       sgi =3D enetc_get_gate_by_index(index);
> +       WARN_ON(!sgi);
> +       z =3D refcount_dec_and_test(&sgi->refcount);
> +       if (z) {
> +               enetc_streamgate_hw_set(priv, sgi, false);
> +               hlist_del(&sgi->node);
> +               kfree(sgi);
> +       }
> +}
> +
> +static void remove_one_chain(struct enetc_ndev_priv *priv,
> +                            struct enetc_stream_filter *filter)
> +{
> +       stream_gate_unref(priv, filter->sgi_index);
> +       stream_filter_unref(priv, filter->sfi_index);
> +
> +       hlist_del(&filter->node);
> +       kfree(filter);
> +}
> +
> +static int enetc_psfp_hw_set(struct enetc_ndev_priv *priv,
> +                            struct enetc_streamid *sid,
> +                            struct enetc_psfp_filter *sfi,
> +                            struct enetc_psfp_gate *sgi)
> +{
> +       int err;
> +
> +       err =3D enetc_streamid_hw_set(priv, sid, true);
> +       if (err)
> +               return err;
> +
> +       if (sfi) {
> +               err =3D enetc_streamfilter_hw_set(priv, sfi, true);
> +               if (err)
> +                       goto revert_sid;
> +       }
> +
> +       err =3D enetc_streamgate_hw_set(priv, sgi, true);
> +       if (err)
> +               goto revert_sfi;
> +
> +       return 0;
> +
> +revert_sfi:
> +       if (sfi)
> +               enetc_streamfilter_hw_set(priv, sfi, false);
> +revert_sid:
> +       enetc_streamid_hw_set(priv, sid, false);
> +       return err;
> +}
> +
> +struct actions_fwd *enetc_check_flow_actions(u64 acts, unsigned int inpu=
tkeys)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(enetc_act_fwd); i++)
> +               if (acts =3D=3D enetc_act_fwd[i].actions &&
> +                   inputkeys & enetc_act_fwd[i].keys)
> +                       return &enetc_act_fwd[i];
> +
> +       return NULL;
> +}
> +
> +static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
> +                                     struct flow_cls_offload *f)
> +{
> +       struct flow_rule *rule =3D flow_cls_offload_flow_rule(f);
> +       struct netlink_ext_ack *extack =3D f->common.extack;
> +       struct enetc_stream_filter *filter, *old_filter;
> +       struct enetc_psfp_filter *sfi, *old_sfi;
> +       struct enetc_psfp_gate *sgi, *old_sgi;
> +       struct flow_action_entry *entry;
> +       struct action_gate_entry *e;
> +       u8 sfi_overwrite =3D 0;
> +       int entries_size;
> +       int i, err;
> +
> +       if (f->common.chain_index >=3D priv->psfp_cap.max_streamid) {
> +               NL_SET_ERR_MSG_MOD(extack, "No Stream identify resource!"=
);
> +               return -ENOSPC;
> +       }
> +
> +       flow_action_for_each(i, entry, &rule->action)
> +               if (entry->id =3D=3D FLOW_ACTION_GATE)
> +                       break;
> +
> +       if (entry->id !=3D FLOW_ACTION_GATE)
> +               return -EINVAL;
> +
> +       filter =3D kzalloc(sizeof(*filter), GFP_KERNEL);
> +       if (!filter)
> +               return -ENOMEM;
> +
> +       filter->sid.index =3D f->common.chain_index;
> +
> +       if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
> +               struct flow_match_eth_addrs match;
> +
> +               flow_rule_match_eth_addrs(rule, &match);
> +
> +               if (!is_zero_ether_addr(match.mask->dst)) {

Does ENETC support masked matching on MAC address? If not, you should
error out if the mask is not ff:ff:ff:ff:ff:ff.

> +                       ether_addr_copy(filter->sid.dst_mac, match.key->d=
st);
> +                       filter->sid.filtertype =3D STREAMID_TYPE_NULL;
> +               }
> +
> +               if (!is_zero_ether_addr(match.mask->src)) {
> +                       ether_addr_copy(filter->sid.src_mac, match.key->s=
rc);
> +                       filter->sid.filtertype =3D STREAMID_TYPE_SMAC;
> +               }
> +       } else {
> +               NL_SET_ERR_MSG_MOD(extack, "Unsupported, must ETH_ADDRS")=
;
> +               return -EINVAL;
> +       }
> +
> +       if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
> +               struct flow_match_vlan match;
> +
> +               flow_rule_match_vlan(rule, &match);
> +               if (match.mask->vlan_priority) {
> +                       if (match.mask->vlan_priority !=3D
> +                           (VLAN_PRIO_MASK >> VLAN_PRIO_SHIFT)) {
> +                               NL_SET_ERR_MSG_MOD(extack, "Only full mas=
k is supported for VLAN priority");
> +                               err =3D -EINVAL;
> +                               goto free_filter;
> +                       }
> +               }
> +
> +               if (match.mask->vlan_tpid) {
> +                       if (match.mask->vlan_tpid !=3D VLAN_VID_MASK) {

I'm pretty sure that vlan_tpid is the EtherType (0x8100, etc), and
that you actually meant vlan_id.


> +                               NL_SET_ERR_MSG_MOD(extack, "Only full mas=
k is supported for VLAN id");
> +                               err =3D -EINVAL;
> +                               goto free_filter;
> +                       }
> +
> +                       filter->sid.vid =3D match.key->vlan_tpid;
> +                       if (!filter->sid.vid)
> +                               filter->sid.tagged =3D STREAMID_VLAN_UNTA=
GGED;
> +                       else
> +                               filter->sid.tagged =3D STREAMID_VLAN_TAGG=
ED;
> +               }
> +       } else {
> +               filter->sid.tagged =3D STREAMID_VLAN_ALL;
> +       }
> +
> +       /* parsing gate action */
> +       if (entry->gate.index >=3D priv->psfp_cap.max_psfp_gate) {
> +               NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
> +               err =3D -ENOSPC;
> +               goto free_filter;
> +       }
> +
> +       if (entry->gate.num_entries >=3D priv->psfp_cap.max_psfp_gatelist=
) {
> +               NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
> +               err =3D -ENOSPC;
> +               goto free_filter;
> +       }
> +
> +       entries_size =3D struct_size(sgi, entries, entry->gate.num_entrie=
s);
> +       sgi =3D kzalloc(entries_size, GFP_KERNEL);
> +       if (!sgi) {
> +               err =3D -ENOMEM;
> +               goto free_filter;
> +       }
> +
> +       refcount_set(&sgi->refcount, 1);
> +       sgi->index =3D entry->gate.index;
> +       sgi->init_ipv =3D entry->gate.prio;
> +       sgi->basetime =3D entry->gate.basetime;
> +       sgi->cycletime =3D entry->gate.cycletime;
> +       sgi->num_entries =3D entry->gate.num_entries;
> +
> +       e =3D sgi->entries;
> +       for (i =3D 0; i < entry->gate.num_entries; i++) {
> +               e[i].gate_state =3D entry->gate.entries[i].gate_state;
> +               e[i].interval =3D entry->gate.entries[i].interval;
> +               e[i].ipv =3D entry->gate.entries[i].ipv;
> +               e[i].maxoctets =3D entry->gate.entries[i].maxoctets;
> +       }
> +
> +       filter->sgi_index =3D sgi->index;
> +
> +       sfi =3D kzalloc(sizeof(*sfi), GFP_KERNEL);
> +       if (!sfi) {
> +               err =3D -ENOMEM;
> +               goto free_gate;
> +       }
> +
> +       refcount_set(&sfi->refcount, 1);
> +       sfi->gate_id =3D sgi->index;
> +
> +       /* flow meter not support yet */
> +       sfi->meter_id =3D ENETC_PSFP_WILDCARD;
> +
> +       /* prio ref the filter prio */
> +       if (f->common.prio && f->common.prio <=3D BIT(3))
> +               sfi->prio =3D f->common.prio - 1;
> +       else
> +               sfi->prio =3D ENETC_PSFP_WILDCARD;
> +
> +       old_sfi =3D enetc_psfp_check_sfi(sfi);
> +       if (!old_sfi) {
> +               int index;
> +
> +               index =3D enetc_get_free_index(priv);
> +               if (sfi->handle < 0) {
> +                       NL_SET_ERR_MSG_MOD(extack, "No Stream Filter reso=
urce!");
> +                       err =3D -ENOSPC;
> +                       goto free_sfi;
> +               }
> +
> +               sfi->index =3D index;
> +               sfi->handle =3D index + HANDLE_OFFSET;
> +               /* Update the stream filter handle also */
> +               filter->sid.handle =3D sfi->handle;
> +               filter->sfi_index =3D sfi->index;
> +               sfi_overwrite =3D 0;
> +       } else {
> +               filter->sfi_index =3D old_sfi->index;
> +               filter->sid.handle =3D old_sfi->handle;
> +               sfi_overwrite =3D 1;
> +       }
> +
> +       err =3D enetc_psfp_hw_set(priv, &filter->sid,
> +                               sfi_overwrite ? NULL : sfi, sgi);
> +       if (err)
> +               goto free_sfi;
> +
> +       spin_lock(&epsfp.psfp_lock);
> +       /* Remove the old node if exist and update with a new node */
> +       old_sgi =3D enetc_get_gate_by_index(filter->sgi_index);
> +       if (old_sgi) {
> +               refcount_set(&sgi->refcount,
> +                            refcount_read(&old_sgi->refcount) + 1);
> +               hlist_del(&old_sgi->node);
> +               kfree(old_sgi);
> +       }
> +
> +       hlist_add_head(&sgi->node, &epsfp.psfp_gate_list);
> +
> +       if (!old_sfi) {
> +               hlist_add_head(&sfi->node, &epsfp.psfp_filter_list);
> +               set_bit(sfi->index, epsfp.psfp_sfi_bitmap);
> +       } else {
> +               kfree(sfi);
> +               refcount_inc(&old_sfi->refcount);
> +       }
> +
> +       old_filter =3D enetc_get_stream_by_index(filter->sid.index);
> +       if (old_filter)
> +               remove_one_chain(priv, old_filter);
> +
> +       filter->stats.lastused =3D jiffies;
> +       hlist_add_head(&filter->node, &epsfp.stream_list);
> +
> +       spin_unlock(&epsfp.psfp_lock);
> +
> +       return 0;
> +
> +free_sfi:
> +       kfree(sfi);
> +free_gate:
> +       kfree(sgi);
> +free_filter:
> +       kfree(filter);
> +
> +       return err;
> +}
> +
> +static int enetc_config_clsflower(struct enetc_ndev_priv *priv,
> +                                 struct flow_cls_offload *cls_flower)
> +{
> +       struct flow_rule *rule =3D flow_cls_offload_flow_rule(cls_flower)=
;
> +       struct netlink_ext_ack *extack =3D cls_flower->common.extack;
> +       struct flow_dissector *dissector =3D rule->match.dissector;
> +       struct flow_action *action =3D &rule->action;
> +       struct flow_action_entry *entry;
> +       struct actions_fwd *fwd;
> +       u64 actions =3D 0;
> +       int i, err;
> +
> +       if (!flow_action_has_entries(action)) {
> +               NL_SET_ERR_MSG_MOD(extack, "At least one action is needed=
");
> +               return -EINVAL;
> +       }
> +
> +       flow_action_for_each(i, entry, action)
> +               actions |=3D BIT(entry->id);
> +
> +       fwd =3D enetc_check_flow_actions(actions, dissector->used_keys);
> +       if (!fwd) {
> +               NL_SET_ERR_MSG_MOD(extack, "Unsupported filter type!");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (fwd->output & FILTER_ACTION_TYPE_PSFP) {
> +               err =3D enetc_psfp_parse_clsflower(priv, cls_flower);
> +               if (err) {
> +                       NL_SET_ERR_MSG_MOD(extack, "Invalid PSFP inputs")=
;
> +                       return err;
> +               }
> +       } else {
> +               NL_SET_ERR_MSG_MOD(extack, "Unsupported actions");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return 0;
> +}
> +
> +static int enetc_psfp_destroy_clsflower(struct enetc_ndev_priv *priv,
> +                                       struct flow_cls_offload *f)
> +{
> +       struct enetc_stream_filter *filter;
> +       struct netlink_ext_ack *extack =3D f->common.extack;
> +       int err;
> +
> +       if (f->common.chain_index >=3D priv->psfp_cap.max_streamid) {
> +               NL_SET_ERR_MSG_MOD(extack, "No Stream identify resource!"=
);
> +               return -ENOSPC;
> +       }
> +
> +       filter =3D enetc_get_stream_by_index(f->common.chain_index);
> +       if (!filter)
> +               return -EINVAL;
> +
> +       err =3D enetc_streamid_hw_set(priv, &filter->sid, false);
> +       if (err)
> +               return err;
> +
> +       remove_one_chain(priv, filter);
> +
> +       return 0;
> +}
> +
> +static int enetc_destroy_clsflower(struct enetc_ndev_priv *priv,
> +                                  struct flow_cls_offload *f)
> +{
> +       return enetc_psfp_destroy_clsflower(priv, f);
> +}
> +
> +static int enetc_psfp_get_stats(struct enetc_ndev_priv *priv,
> +                               struct flow_cls_offload *f)
> +{
> +       struct psfp_streamfilter_counters counters =3D {};
> +       struct enetc_stream_filter *filter;
> +       struct flow_stats stats =3D {};
> +       int err;
> +
> +       filter =3D enetc_get_stream_by_index(f->common.chain_index);
> +       if (!filter)
> +               return -EINVAL;
> +
> +       err =3D enetc_streamcounter_hw_get(priv, filter->sfi_index, &coun=
ters);
> +       if (err)
> +               return -EINVAL;
> +
> +       spin_lock(&epsfp.psfp_lock);
> +       stats.pkts =3D counters.matching_frames_count - filter->stats.pkt=
s;
> +       stats.lastused =3D filter->stats.lastused;
> +       filter->stats.pkts +=3D stats.pkts;
> +       spin_unlock(&epsfp.psfp_lock);
> +
> +       flow_stats_update(&f->stats, 0x0, stats.pkts, stats.lastused,
> +                         FLOW_ACTION_HW_STATS_DELAYED);
> +
> +       return 0;
> +}
> +
> +static int enetc_setup_tc_cls_flower(struct enetc_ndev_priv *priv,
> +                                    struct flow_cls_offload *cls_flower)
> +{
> +       switch (cls_flower->command) {
> +       case FLOW_CLS_REPLACE:
> +               return enetc_config_clsflower(priv, cls_flower);
> +       case FLOW_CLS_DESTROY:
> +               return enetc_destroy_clsflower(priv, cls_flower);
> +       case FLOW_CLS_STATS:
> +               return enetc_psfp_get_stats(priv, cls_flower);
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +static inline void clean_psfp_sfi_bitmap(void)
> +{
> +       bitmap_free(epsfp.psfp_sfi_bitmap);
> +       epsfp.psfp_sfi_bitmap =3D NULL;
> +}
> +
> +static void clean_stream_list(void)
> +{
> +       struct enetc_stream_filter *s;
> +       struct hlist_node *tmp;
> +
> +       hlist_for_each_entry_safe(s, tmp, &epsfp.stream_list, node) {
> +               hlist_del(&s->node);
> +               kfree(s);
> +       }
> +}
> +
> +static void clean_sfi_list(void)
> +{
> +       struct enetc_psfp_filter *sfi;
> +       struct hlist_node *tmp;
> +
> +       hlist_for_each_entry_safe(sfi, tmp, &epsfp.psfp_filter_list, node=
) {
> +               hlist_del(&sfi->node);
> +               kfree(sfi);
> +       }
> +}
> +
> +static void clean_sgi_list(void)
> +{
> +       struct enetc_psfp_gate *sgi;
> +       struct hlist_node *tmp;
> +
> +       hlist_for_each_entry_safe(sgi, tmp, &epsfp.psfp_gate_list, node) =
{
> +               hlist_del(&sgi->node);
> +               kfree(sgi);
> +       }
> +}
> +
> +static void clean_psfp_all(void)
> +{
> +       /* Disable all list nodes and free all memory */
> +       clean_sfi_list();
> +       clean_sgi_list();
> +       clean_stream_list();
> +       epsfp.dev_bitmap =3D 0;
> +       clean_psfp_sfi_bitmap();
> +}
> +
> +int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
> +                           void *cb_priv)
> +{
> +       struct net_device *ndev =3D cb_priv;
> +
> +       if (!tc_can_offload(ndev))
> +               return -EOPNOTSUPP;
> +
> +       switch (type) {
> +       case TC_SETUP_CLSFLOWER:
> +               return enetc_setup_tc_cls_flower(netdev_priv(ndev), type_=
data);
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +int enetc_psfp_init(struct enetc_ndev_priv *priv)
> +{
> +       if (epsfp.psfp_sfi_bitmap)
> +               return 0;
> +
> +       epsfp.psfp_sfi_bitmap =3D bitmap_zalloc(priv->psfp_cap.max_psfp_f=
ilter,
> +                                             GFP_KERNEL);
> +       if (!epsfp.psfp_sfi_bitmap)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&epsfp.psfp_lock);
> +
> +       if (list_empty(&enetc_block_cb_list))
> +               epsfp.dev_bitmap =3D 0;
> +
> +       return 0;
> +}
> +
> +int enetc_psfp_clean(struct enetc_ndev_priv *priv)
> +{
> +       if (!list_empty(&enetc_block_cb_list))
> +               return -EBUSY;
> +
> +       clean_psfp_all();
> +
> +       return 0;
> +}
> +
> +int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
> +{
> +       struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> +       struct flow_block_offload *f =3D type_data;
> +       int err;
> +
> +       err =3D flow_block_cb_setup_simple(f, &enetc_block_cb_list,
> +                                        enetc_setup_tc_block_cb,
> +                                        ndev, ndev, true);
> +       if (err)
> +               return err;
> +
> +       switch (f->command) {
> +       case FLOW_BLOCK_BIND:
> +               set_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
> +               break;
> +       case FLOW_BLOCK_UNBIND:
> +               clear_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
> +               if (!epsfp.dev_bitmap)
> +                       clean_psfp_all();
> +               break;
> +       }
> +
> +       return 0;
> +}
> --
> 2.17.1
>

Thanks,
-Vladimir
