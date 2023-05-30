Return-Path: <netdev+bounces-6356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A30715E48
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 541E61C20B75
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F5F182DA;
	Tue, 30 May 2023 12:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8217FF5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:01:19 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F78B90;
	Tue, 30 May 2023 05:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685448077; x=1716984077;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SV0f890kYGMVyZmg8vt7TTw244ER+FU0s1Oc2QFPtZw=;
  b=hRAzNJ+H5wpxjB60PdPUX6sdJFrAGw88Yl8G8Y6t0tdJzesS4q+x3aKh
   IYnTf854fOQ+b1L8nw70irec+JIgZScNRwdJL6G2umrPxWgva9/2+G88S
   wfcqOLDK5wQb6rsK8WmzeJ+NRjuz0ThVVZH9J/WGQb1uoya+bEMU0DQHN
   5INLop2fjrggiMANeXW6/DwZXNL2G0T5AJZlT10rNt+xyr3BV6PW8hwLZ
   FJxfe7fq6Poi9SQGCeLJDmCLuYWtkC6MXoqEFf4AxeH8eGEw7YLO6CJ6c
   RcmHA+BpAi5PyGSpQOw9nJBuEnTAqIUwQOcCPaIvuxJajm4ypNl/8Xb5+
   w==;
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="216017968"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 05:01:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 05:01:15 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 05:01:15 -0700
Date: Tue, 30 May 2023 14:01:14 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
	<xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "Vinicius Costa
 Gomes" <vinicius.gomes@intel.com>, Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>, Amritha Nambiar
	<amritha.nambiar@intel.com>, Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>, Harini Katakam
	<harini.katakam@amd.com>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Michael Sit Wei Hong
	<michael.wei.hong.sit@intel.com>, Mohammad Athari Bin Ismail
	<mohammad.athari.ismail@intel.com>, Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>, "Jesse
 Brandeburg" <jesse.brandeburg@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>, Jose Abreu <joabreu@synopsys.com>, "Maxime
 Coquelin" <mcoquelin.stm32@gmail.com>, <intel-wired-lan@lists.osuosl.org>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next 2/5] net/sched: taprio: replace
 tc_taprio_qopt_offload :: enable with a "cmd" enum
Message-ID: <20230530120114.zxh5xncibdtqkf3l@soft-dev3-1>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-3-vladimir.oltean@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230530091948.1408477-3-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/30/2023 12:19, Vladimir Oltean wrote:
> 
> Inspired from struct flow_cls_offload :: cmd, in order for taprio to be
> able to report statistics (which is future work), it seems that we need
> to drill one step further with the ndo_setup_tc(TC_SETUP_QDISC_TAPRIO)
> multiplexing, and pass the command as part of the common portion of the
> muxed structure.
> 
> Since we already have an "enable" variable in tc_taprio_qopt_offload,
> refactor all drivers to check for "cmd" instead of "enable", and reject
> every other command except "replace" and "destroy" - to be future proof.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com> # for lan966x

> ---
>  drivers/net/dsa/hirschmann/hellcreek.c             | 14 +++++++++-----
>  drivers/net/dsa/ocelot/felix_vsc9959.c             |  4 +++-
>  drivers/net/dsa/sja1105/sja1105_tas.c              |  7 +++++--
>  drivers/net/ethernet/engleder/tsnep_selftests.c    | 12 ++++++------
>  drivers/net/ethernet/engleder/tsnep_tc.c           |  4 +++-
>  drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  6 +++++-
>  drivers/net/ethernet/intel/igc/igc_main.c          | 13 +++++++++++--
>  .../net/ethernet/microchip/lan966x/lan966x_tc.c    | 10 ++++++++--
>  drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  7 +++++--
>  drivers/net/ethernet/ti/am65-cpsw-qos.c            | 11 ++++++++---
>  include/net/pkt_sched.h                            |  7 ++++++-
>  net/sched/sch_taprio.c                             |  4 ++--
>  12 files changed, 71 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index 595a548bb0a8..af50001ccdd4 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -1885,13 +1885,17 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
>         case TC_SETUP_QDISC_TAPRIO: {
>                 struct tc_taprio_qopt_offload *taprio = type_data;
> 
> -               if (!hellcreek_validate_schedule(hellcreek, taprio))
> -                       return -EOPNOTSUPP;
> +               switch (taprio->cmd) {
> +               case TAPRIO_CMD_REPLACE:
> +                       if (!hellcreek_validate_schedule(hellcreek, taprio))
> +                               return -EOPNOTSUPP;
> 
> -               if (taprio->enable)
>                         return hellcreek_port_set_schedule(ds, port, taprio);
> -
> -               return hellcreek_port_del_schedule(ds, port);
> +               case TAPRIO_CMD_DESTROY:
> +                       return hellcreek_port_del_schedule(ds, port);
> +               default:
> +                       return -EOPNOTSUPP;
> +               }
>         }
>         default:
>                 return -EOPNOTSUPP;
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 030738fef60e..5de6a27052fc 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1411,7 +1411,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
> 
>         mutex_lock(&ocelot->tas_lock);
> 
> -       if (!taprio->enable) {
> +       if (taprio->cmd == TAPRIO_CMD_DESTROY) {
>                 ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
>                 ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
>                                QSYS_TAG_CONFIG, port);
> @@ -1423,6 +1423,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
> 
>                 mutex_unlock(&ocelot->tas_lock);
>                 return 0;
> +       } else if (taprio->cmd != TAPRIO_CMD_REPLACE) {
> +               return -EOPNOTSUPP;
>         }
> 
>         ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
> diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
> index e6153848a950..d7818710bc02 100644
> --- a/drivers/net/dsa/sja1105/sja1105_tas.c
> +++ b/drivers/net/dsa/sja1105/sja1105_tas.c
> @@ -516,10 +516,11 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
>         /* Can't change an already configured port (must delete qdisc first).
>          * Can't delete the qdisc from an unconfigured port.
>          */
> -       if (!!tas_data->offload[port] == admin->enable)
> +       if ((!!tas_data->offload[port] && admin->cmd == TAPRIO_CMD_REPLACE) ||
> +           (!tas_data->offload[port] && admin->cmd == TAPRIO_CMD_DESTROY))
>                 return -EINVAL;
> 
> -       if (!admin->enable) {
> +       if (admin->cmd == TAPRIO_CMD_DESTROY) {
>                 taprio_offload_free(tas_data->offload[port]);
>                 tas_data->offload[port] = NULL;
> 
> @@ -528,6 +529,8 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
>                         return rc;
> 
>                 return sja1105_static_config_reload(priv, SJA1105_SCHEDULING);
> +       } else if (admin->cmd != TAPRIO_CMD_REPLACE) {
> +               return -EOPNOTSUPP;
>         }
> 
>         /* The cycle time extension is the amount of time the last cycle from
> diff --git a/drivers/net/ethernet/engleder/tsnep_selftests.c b/drivers/net/ethernet/engleder/tsnep_selftests.c
> index 1581d6b22232..8a9145f93147 100644
> --- a/drivers/net/ethernet/engleder/tsnep_selftests.c
> +++ b/drivers/net/ethernet/engleder/tsnep_selftests.c
> @@ -329,7 +329,7 @@ static bool disable_taprio(struct tsnep_adapter *adapter)
>         int retval;
> 
>         memset(&qopt, 0, sizeof(qopt));
> -       qopt.enable = 0;
> +       qopt.cmd = TAPRIO_CMD_DESTROY;
>         retval = tsnep_tc_setup(adapter->netdev, TC_SETUP_QDISC_TAPRIO, &qopt);
>         if (retval)
>                 return false;
> @@ -360,7 +360,7 @@ static bool tsnep_test_taprio(struct tsnep_adapter *adapter)
>         for (i = 0; i < 255; i++)
>                 qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> 
> -       qopt->enable = 1;
> +       qopt->cmd = TAPRIO_CMD_REPLACE;
>         qopt->base_time = ktime_set(0, 0);
>         qopt->cycle_time = 1500000;
>         qopt->cycle_time_extension = 0;
> @@ -382,7 +382,7 @@ static bool tsnep_test_taprio(struct tsnep_adapter *adapter)
>         if (!run_taprio(adapter, qopt, 100))
>                 goto failed;
> 
> -       qopt->enable = 1;
> +       qopt->cmd = TAPRIO_CMD_REPLACE;
>         qopt->base_time = ktime_set(0, 0);
>         qopt->cycle_time = 411854;
>         qopt->cycle_time_extension = 0;
> @@ -406,7 +406,7 @@ static bool tsnep_test_taprio(struct tsnep_adapter *adapter)
>         if (!run_taprio(adapter, qopt, 100))
>                 goto failed;
> 
> -       qopt->enable = 1;
> +       qopt->cmd = TAPRIO_CMD_REPLACE;
>         qopt->base_time = ktime_set(0, 0);
>         delay_base_time(adapter, qopt, 12);
>         qopt->cycle_time = 125000;
> @@ -457,7 +457,7 @@ static bool tsnep_test_taprio_change(struct tsnep_adapter *adapter)
>         for (i = 0; i < 255; i++)
>                 qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> 
> -       qopt->enable = 1;
> +       qopt->cmd = TAPRIO_CMD_REPLACE;
>         qopt->base_time = ktime_set(0, 0);
>         qopt->cycle_time = 100000;
>         qopt->cycle_time_extension = 0;
> @@ -610,7 +610,7 @@ static bool tsnep_test_taprio_extension(struct tsnep_adapter *adapter)
>         for (i = 0; i < 255; i++)
>                 qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
> 
> -       qopt->enable = 1;
> +       qopt->cmd = TAPRIO_CMD_REPLACE;
>         qopt->base_time = ktime_set(0, 0);
>         qopt->cycle_time = 100000;
>         qopt->cycle_time_extension = 50000;
> diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
> index d083e6684f12..745b191a5540 100644
> --- a/drivers/net/ethernet/engleder/tsnep_tc.c
> +++ b/drivers/net/ethernet/engleder/tsnep_tc.c
> @@ -325,7 +325,7 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
>         if (!adapter->gate_control)
>                 return -EOPNOTSUPP;
> 
> -       if (!qopt->enable) {
> +       if (qopt->cmd == TAPRIO_CMD_DESTROY) {
>                 /* disable gate control if active */
>                 mutex_lock(&adapter->gate_control_lock);
> 
> @@ -337,6 +337,8 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
>                 mutex_unlock(&adapter->gate_control_lock);
> 
>                 return 0;
> +       } else if (qopt->cmd != TAPRIO_CMD_REPLACE) {
> +               return -EOPNOTSUPP;
>         }
> 
>         retval = tsnep_validate_gcl(qopt);
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 83c27bbbc6ed..7aad824f4da7 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -65,7 +65,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
>         gcl_len = admin_conf->num_entries;
> 
>         tge = enetc_rd(hw, ENETC_PTGCR);
> -       if (!admin_conf->enable) {
> +       if (admin_conf->cmd == TAPRIO_CMD_DESTROY) {
>                 enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
>                 enetc_reset_ptcmsdur(hw);
> 
> @@ -138,6 +138,10 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
>         struct enetc_ndev_priv *priv = netdev_priv(ndev);
>         int err, i;
> 
> +       if (taprio->cmd != TAPRIO_CMD_REPLACE &&
> +           taprio->cmd != TAPRIO_CMD_DESTROY)
> +               return -EOPNOTSUPP;
> +
>         /* TSD and Qbv are mutually exclusive in hardware */
>         for (i = 0; i < priv->num_tx_rings; i++)
>                 if (priv->tx_ring[i]->tsd_enable)
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index c5ef1edcf548..88145c30c919 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6113,9 +6113,18 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
>         size_t n;
>         int i;
> 
> -       adapter->qbv_enable = qopt->enable;
> +       switch (qopt->cmd) {
> +       case TAPRIO_CMD_REPLACE:
> +               adapter->qbv_enable = true;
> +               break;
> +       case TAPRIO_CMD_DESTROY:
> +               adapter->qbv_enable = false;
> +               break;
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> 
> -       if (!qopt->enable)
> +       if (!adapter->qbv_enable)
>                 return igc_tsn_clear_schedule(adapter);
> 
>         if (qopt->base_time < 0)
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
> index cf0cc7562d04..ee652f2d2359 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
> @@ -21,8 +21,14 @@ static int lan966x_tc_setup_qdisc_mqprio(struct lan966x_port *port,
>  static int lan966x_tc_setup_qdisc_taprio(struct lan966x_port *port,
>                                          struct tc_taprio_qopt_offload *taprio)
>  {
> -       return taprio->enable ? lan966x_taprio_add(port, taprio) :
> -                               lan966x_taprio_del(port);
> +       switch (taprio->cmd) {
> +       case TAPRIO_CMD_REPLACE:
> +               return lan966x_taprio_add(port, taprio);
> +       case TAPRIO_CMD_DESTROY:
> +               return lan966x_taprio_del(port);
> +       default:
> +               return -EOPNOTSUPP;
> +       }
>  }
> 
>  static int lan966x_tc_setup_qdisc_tbf(struct lan966x_port *port,
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> index 9d55226479b4..ac41ef4cbd2f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
> @@ -966,8 +966,11 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
>                 return -EOPNOTSUPP;
>         }
> 
> -       if (!qopt->enable)
> +       if (qopt->cmd == TAPRIO_CMD_DESTROY)
>                 goto disable;
> +       else if (qopt->cmd != TAPRIO_CMD_REPLACE)
> +               return -EOPNOTSUPP;
> +
>         if (qopt->num_entries >= dep)
>                 return -EINVAL;
>         if (!qopt->cycle_time)
> @@ -988,7 +991,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
> 
>         mutex_lock(&priv->plat->est->lock);
>         priv->plat->est->gcl_size = size;
> -       priv->plat->est->enable = qopt->enable;
> +       priv->plat->est->enable = qopt->cmd == TAPRIO_CMD_REPLACE;
>         mutex_unlock(&priv->plat->est->lock);
> 
>         for (i = 0; i < size; i++) {
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
> index 3a908db6e5b2..eced87fa261c 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
> @@ -450,7 +450,7 @@ static int am65_cpsw_configure_taprio(struct net_device *ndev,
> 
>         am65_cpsw_est_update_state(ndev);
> 
> -       if (!est_new->taprio.enable) {
> +       if (est_new->taprio.cmd == TAPRIO_CMD_DESTROY) {
>                 am65_cpsw_stop_est(ndev);
>                 return ret;
>         }
> @@ -476,7 +476,7 @@ static int am65_cpsw_configure_taprio(struct net_device *ndev,
>         am65_cpsw_est_set_sched_list(ndev, est_new);
>         am65_cpsw_port_est_assign_buf_num(ndev, est_new->buf);
> 
> -       am65_cpsw_est_set(ndev, est_new->taprio.enable);
> +       am65_cpsw_est_set(ndev, est_new->taprio.cmd == TAPRIO_CMD_REPLACE);
> 
>         if (tact == TACT_PROG) {
>                 ret = am65_cpsw_timer_set(ndev, est_new);
> @@ -520,7 +520,7 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
>         am65_cpsw_cp_taprio(taprio, &est_new->taprio);
>         ret = am65_cpsw_configure_taprio(ndev, est_new);
>         if (!ret) {
> -               if (taprio->enable) {
> +               if (taprio->cmd == TAPRIO_CMD_REPLACE) {
>                         devm_kfree(&ndev->dev, port->qos.est_admin);
> 
>                         port->qos.est_admin = est_new;
> @@ -564,8 +564,13 @@ static void am65_cpsw_est_link_up(struct net_device *ndev, int link_speed)
>  static int am65_cpsw_setup_taprio(struct net_device *ndev, void *type_data)
>  {
>         struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> +       struct tc_taprio_qopt_offload *taprio = type_data;
>         struct am65_cpsw_common *common = port->common;
> 
> +       if (taprio->cmd != TAPRIO_CMD_REPLACE &&
> +           taprio->cmd != TAPRIO_CMD_DESTROY)
> +               return -EOPNOTSUPP;
> +
>         if (!IS_ENABLED(CONFIG_TI_AM65_CPSW_TAS))
>                 return -ENODEV;
> 
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index f436688b6efc..f5fb11da357b 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -185,6 +185,11 @@ struct tc_taprio_caps {
>         bool broken_mqprio:1;
>  };
> 
> +enum tc_taprio_qopt_cmd {
> +       TAPRIO_CMD_REPLACE,
> +       TAPRIO_CMD_DESTROY,
> +};
> +
>  struct tc_taprio_sched_entry {
>         u8 command; /* TC_TAPRIO_CMD_* */
> 
> @@ -196,7 +201,7 @@ struct tc_taprio_sched_entry {
>  struct tc_taprio_qopt_offload {
>         struct tc_mqprio_qopt_offload mqprio;
>         struct netlink_ext_ack *extack;
> -       u8 enable;
> +       enum tc_taprio_qopt_cmd cmd;
>         ktime_t base_time;
>         u64 cycle_time;
>         u64 cycle_time_extension;
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index d29e6785854d..06bf4c6355a5 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1524,7 +1524,7 @@ static int taprio_enable_offload(struct net_device *dev,
>                                "Not enough memory for enabling offload mode");
>                 return -ENOMEM;
>         }
> -       offload->enable = 1;
> +       offload->cmd = TAPRIO_CMD_REPLACE;
>         offload->extack = extack;
>         mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
>         offload->mqprio.extack = extack;
> @@ -1572,7 +1572,7 @@ static int taprio_disable_offload(struct net_device *dev,
>                                "Not enough memory to disable offload mode");
>                 return -ENOMEM;
>         }
> -       offload->enable = 0;
> +       offload->cmd = TAPRIO_CMD_DESTROY;
> 
>         err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>         if (err < 0) {
> --
> 2.34.1
> 
> 

-- 
/Horatiu

