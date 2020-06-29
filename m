Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2042D20DF9C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbgF2UiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730543AbgF2TOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on0606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6838C08ECBA;
        Sun, 28 Jun 2020 23:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gvw9fevGPMk9UFh+2ZqXyzQaeenmE/MM7R0ASGJjB5rDdYwlSopoAwprGLv08gjknP6QNC789l3FgHtjwb17nJgfrsQlIHXUed6ERrhVXiatyH43PO4KV62CDd97CrfPnc4BMcGKeRPAvfnrk+0Xu1nyKib9jyW8tlI27wr835+KWOjO49/SL7RDq7qxHWdjBnsfwjHcP27gjmUY1wxX6tgyr8UGH+3LcCgdAjyOogo3Nc15xZyhFL2mFCfczmgIX6dDwQ6ymAUWzxICU14awTURI/SyfouCbCiu5lNEslEsgl7txnYZXs0OqV3LhtZsMld52J7P7tyNagnwjo0mGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ll4w5NK/GNKhw/VP15ZbSLWg8ZMkq9pvTnsn4bB+cSs=;
 b=HGEVGZ9UlniRxcAk6F83FTjJX/j8a+zi+J2ytMJD2K8xyJXjIVcXpzdeeZT1VUeojfZLlsrcorwU9gtVhgLzBS3Mj+qlo0ayRV8w3gjAQGdAZUWbXw3m4tZmsjB/lhkYl3IktQfk+7JJlvzEZywfv4E6F2DFNnIzig4EbvIMQsqeJEufEcn660QtnjyyrHPaTWKPZmevluOlHDXQ8GwtSCVi8vDeP0hUwjV8TX1y/Me5gbo1wKb9h24S2z6cLNlmRLm4f7vo/AQtW+iar/DC+UVzV76YWG9IN0snltEC+DQDEAE02GdvpR6ifKNrLZZ6sNc9FlN0RQyehcif828tqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ll4w5NK/GNKhw/VP15ZbSLWg8ZMkq9pvTnsn4bB+cSs=;
 b=OT4GkilKBcs1cCtea9wiWoURlc4f1FKXyIgN0I30BSbfS8T3QUQ+/XyyKWTUYdSP3S6LPbHc3eeS5zl8XqbjHgeCEzrtnuBazBdCRtGapNPEU1V4ER7fnkx6+tIhbEa0ycu4m5sj8UGFNobF/iXjSWWQ26Mb5z7F0sbr85JWbjw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB5087.eurprd04.prod.outlook.com (2603:10a6:803:5d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 06:52:44 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 06:52:44 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        jiri@resnulli.us, vlad@buslov.dev, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com, oss-drivers@netronome.com,
        Po Liu <po.liu@nxp.com>
Subject: [v2,net-next] net:qos: police action offloading parameter 'burst' change to the original value
Date:   Mon, 29 Jun 2020 14:54:16 +0800
Message-Id: <20200629065416.31111-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629020420.30412-2-po.liu@nxp.com>
References: <20200629020420.30412-2-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0171.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::27) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR01CA0171.apcprd01.prod.exchangelabs.com (2603:1096:4:28::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Mon, 29 Jun 2020 06:52:36 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d057cd2-2270-4486-c2fe-08d81bf9066d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5087AD93A3361D99930E1ABE926E0@VI1PR04MB5087.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/ocylAh6PzcGKvxJFvFpImlPHLJ+fSfKj/ngmFTESYUeifOvyWF/fZPGi75GQSWr4bGo6vquu7430fPzv48YtFJwBQSvnVJNHKMtnqK1fqSj5e8+JSEpWo2aGXYW55DwZUvTSZQ8F5FiutDY6Sv5eqob1ogiy8r76S+cSYVDLmqbyT/8frnuKvnDniDLX6jkrVZf0kY2qdJlwRE4YjhWpAvtom5W2Z3pQ7me2RTv46PYCrlJHXKIhTgcwK6o3dVvrlmsKFvji/FGukAH3rzuOd7w8jnFNLJP5r4felSa/ufNiZbk9k89cadX2t5/gTh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(66556008)(66476007)(478600001)(44832011)(8676002)(4326008)(30864003)(8936002)(66946007)(6666004)(2906002)(52116002)(1076003)(86362001)(26005)(7416002)(6506007)(16526019)(186003)(6512007)(316002)(956004)(6486002)(5660300002)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0YVj4dlEuSqZvZtS8fjfmZJ1GjWvIA2v6wpksah/6iLP/NSSSqx3stcov+Iqcf50UAvFrt2YNt/PT/eTVQy0DVI08t9Tz4RItWjrvjonx3JxyKxbVxI+LcUAa5DgZHS5f5J2sfae+fsKc9UQ18Dp08biD5lXF+F+D7UI4kgZHE+GLAG83jLsLwnyogyqQri7NiNonaq4ToppEkZqCfc0bKLQPwzd11oe6uubgq5tm7dzCqRzLJ+NgGgzDAv96l0bveIWyjwCWIGX+9RBOFL2rgnJFvwKm1xnx2YJqd6ktzat8bLQayImqZr1Ui8k9ar+Mz+jT5nZyFLKyeShJxNdXfZTjAh8Af3ELl6lu838VjTqSjou75uU1EdaZJvB+qaqZG3I/MDJJdORsxpxFjxdgKuXaRZnrR302uaw/r9wk7Cgo8G2zESmxjEptRzZw94iIVDTsR4tknMHKYq27+Isv6uI3F9e9PJMPLQOg6XL16s=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d057cd2-2270-4486-c2fe-08d81bf9066d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 06:52:44.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSIWRQpz48nI61X3tKi7LqNRHbPRTE67yIFETpUZ35RZg+ie4hwK+yYPWeFX3N9Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 'tcfp_burst' with TICK factor, driver side always need to recover
it to the original value, this patch moves the generic calculation and
recover to the 'burst' original value before offloading to device driver.

Signed-off-by: Po Liu <po.liu@nxp.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c                |  4 +--
 drivers/net/dsa/sja1105/sja1105_flower.c      | 16 ++++------
 drivers/net/dsa/sja1105/sja1105_main.c        |  4 +--
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  8 +----
 drivers/net/ethernet/mscc/ocelot_flower.c     |  4 +--
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +--
 .../ethernet/netronome/nfp/flower/qos_conf.c  |  6 ++--
 include/net/dsa.h                             |  2 +-
 include/net/flow_offload.h                    |  2 +-
 include/net/tc_act/tc_police.h                | 32 +++++++++++++++++--
 net/sched/cls_api.c                           |  2 +-
 11 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 25046777c993..75020af7f7a4 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -746,9 +746,7 @@ static int felix_port_policer_add(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_policer pol = {
 		.rate = div_u64(policer->rate_bytes_per_sec, 1000) * 8,
-		.burst = div_u64(policer->rate_bytes_per_sec *
-				 PSCHED_NS2TICKS(policer->burst),
-				 PSCHED_TICKS_PER_SEC),
+		.burst = policer->burst,
 	};
 
 	return ocelot_port_policer_add(ocelot, port, &pol);
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 9ee8968610cd..12e76020bea3 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -31,7 +31,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 				       struct netlink_ext_ack *extack,
 				       unsigned long cookie, int port,
 				       u64 rate_bytes_per_sec,
-				       s64 burst)
+				       u32 burst)
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
 	struct sja1105_l2_policing_entry *policing;
@@ -79,9 +79,8 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 
 	policing[rule->bcast_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
 							  512, 1000000);
-	policing[rule->bcast_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
-							  PSCHED_NS2TICKS(burst),
-							  PSCHED_TICKS_PER_SEC);
+	policing[rule->bcast_pol.sharindx].smax = burst;
+
 	/* TODO: support per-flow MTU */
 	policing[rule->bcast_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
 						    ETH_FCS_LEN;
@@ -103,7 +102,7 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 				    struct netlink_ext_ack *extack,
 				    unsigned long cookie, int port, int tc,
 				    u64 rate_bytes_per_sec,
-				    s64 burst)
+				    u32 burst)
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
 	struct sja1105_l2_policing_entry *policing;
@@ -152,9 +151,8 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 
 	policing[rule->tc_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
 						       512, 1000000);
-	policing[rule->tc_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
-						       PSCHED_NS2TICKS(burst),
-						       PSCHED_TICKS_PER_SEC);
+	policing[rule->tc_pol.sharindx].smax = burst;
+
 	/* TODO: support per-flow MTU */
 	policing[rule->tc_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
 						 ETH_FCS_LEN;
@@ -177,7 +175,7 @@ static int sja1105_flower_policer(struct sja1105_private *priv, int port,
 				  unsigned long cookie,
 				  struct sja1105_key *key,
 				  u64 rate_bytes_per_sec,
-				  s64 burst)
+				  u32 burst)
 {
 	switch (key->type) {
 	case SJA1105_KEY_BCAST:
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 789b288cc78b..5079e4aeef80 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3324,9 +3324,7 @@ static int sja1105_port_policer_add(struct dsa_switch *ds, int port,
 	 */
 	policing[port].rate = div_u64(512 * policer->rate_bytes_per_sec,
 				      1000000);
-	policing[port].smax = div_u64(policer->rate_bytes_per_sec *
-				      PSCHED_NS2TICKS(policer->burst),
-				      PSCHED_TICKS_PER_SEC);
+	policing[port].smax = policer->burst;
 
 	return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 4f670cbdf186..b8b336179d82 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1241,8 +1241,6 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	/* Flow meter and max frame size */
 	if (entryp) {
 		if (entryp->police.burst) {
-			u64 temp;
-
 			fmi = kzalloc(sizeof(*fmi), GFP_KERNEL);
 			if (!fmi) {
 				err = -ENOMEM;
@@ -1250,11 +1248,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			}
 			refcount_set(&fmi->refcount, 1);
 			fmi->cir = entryp->police.rate_bytes_ps;
-			/* Convert to original burst value */
-			temp = entryp->police.burst * fmi->cir;
-			temp = div_u64(temp, 1000000000ULL);
-
-			fmi->cbs = temp;
+			fmi->cbs = entryp->police.burst;
 			fmi->index = entryp->police.index;
 			filter->flags |= ENETC_PSFP_FLAGS_FMI;
 			filter->fmi_index = fmi->index;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index f2a85b06a6e7..ec1b6e2572ba 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -12,7 +12,6 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_vcap_filter *filter)
 {
 	const struct flow_action_entry *a;
-	s64 burst;
 	u64 rate;
 	int i;
 
@@ -35,8 +34,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 			filter->action = OCELOT_VCAP_ACTION_POLICE;
 			rate = a->police.rate_bytes_ps;
 			filter->pol.rate = div_u64(rate, 1000) * 8;
-			burst = rate * PSCHED_NS2TICKS(a->police.burst);
-			filter->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
+			filter->pol.burst = a->police.burst;
 			break;
 		default:
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 702b42543fb7..b69187c51fa6 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -74,9 +74,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 		}
 
 		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
-		pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
-					 PSCHED_NS2TICKS(action->police.burst),
-					 PSCHED_TICKS_PER_SEC);
+		pol.burst = action->police.burst;
 
 		err = ocelot_port_policer_add(ocelot, port, &pol);
 		if (err) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index bb327d48d1ab..d4ce8f9ef3cc 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -69,7 +69,8 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_repr *repr;
 	struct sk_buff *skb;
 	u32 netdev_port_id;
-	u64 burst, rate;
+	u32 burst;
+	u64 rate;
 
 	if (!nfp_netdev_is_nfp_repr(netdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
@@ -104,8 +105,7 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	}
 
 	rate = action->police.rate_bytes_ps;
-	burst = div_u64(rate * PSCHED_NS2TICKS(action->police.burst),
-			PSCHED_TICKS_PER_SEC);
+	burst = action->police.burst;
 	netdev_port_id = nfp_repr_get_port_id(netdev);
 
 	skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 50389772c597..4046ccd1945d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -144,7 +144,7 @@ struct dsa_mall_mirror_tc_entry {
 
 /* TC port policer entry */
 struct dsa_mall_policer_tc_entry {
-	s64 burst;
+	u32 burst;
 	u64 rate_bytes_per_sec;
 };
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3bafb5124ac0..2dc25082eabf 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -233,7 +233,7 @@ struct flow_action_entry {
 		} sample;
 		struct {				/* FLOW_ACTION_POLICE */
 			u32			index;
-			s64			burst;
+			u32			burst;
 			u64			rate_bytes_ps;
 			u32			mtu;
 		} police;
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index cd973b10ae8c..6d1e26b709b5 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -59,14 +59,42 @@ static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
 	return params->rate.rate_bytes_ps;
 }
 
-static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
+static inline u32 tcf_police_burst(const struct tc_action *act)
 {
 	struct tcf_police *police = to_police(act);
 	struct tcf_police_params *params;
+	u32 burst;
 
 	params = rcu_dereference_protected(police->params,
 					   lockdep_is_held(&police->tcf_lock));
-	return params->tcfp_burst;
+
+	/*
+	 *  "rate" bytes   "burst" nanoseconds
+	 *  ------------ * -------------------
+	 *    1 second          2^6 ticks
+	 *
+	 * ------------------------------------
+	 *        NSEC_PER_SEC nanoseconds
+	 *        ------------------------
+	 *              2^6 ticks
+	 *
+	 *    "rate" bytes   "burst" nanoseconds            2^6 ticks
+	 *  = ------------ * ------------------- * ------------------------
+	 *      1 second          2^6 ticks        NSEC_PER_SEC nanoseconds
+	 *
+	 *   "rate" * "burst"
+	 * = ---------------- bytes/nanosecond
+	 *    NSEC_PER_SEC^2
+	 *
+	 *
+	 *   "rate" * "burst"
+	 * = ---------------- bytes/second
+	 *     NSEC_PER_SEC
+	 */
+	burst = div_u64(params->tcfp_burst * params->rate.rate_bytes_ps,
+			NSEC_PER_SEC);
+
+	return burst;
 }
 
 static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5bfa6b985bb8..cf324807fc42 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3660,7 +3660,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			tcf_sample_get_group(entry, act);
 		} else if (is_tcf_police(act)) {
 			entry->id = FLOW_ACTION_POLICE;
-			entry->police.burst = tcf_police_tcfp_burst(act);
+			entry->police.burst = tcf_police_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
 			entry->police.mtu = tcf_police_tcfp_mtu(act);
-- 
2.17.1

