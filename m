Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6220CBBE
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 04:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgF2CXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 22:23:35 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:20238
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726154AbgF2CXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 22:23:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRlF2SIvegQNy7lCg8rll4/FUuLdTLrJ2SJv+9H6v+OdxDriXuGNWqWEx+s5JyweLcvNIsCN0SIdLH3mqJtwjbSRle8CFWHsoLBUcffwgaGy8oukbyoDmNAvX7ZRhe/Z3yxAZ09H1dECcHXoXX6a7scMC5Qx/AjHIDrdSAy+DgX9Pjur2dLhTRwKZNe7VIv9ik5iSoCbRAW949QTWOVJ2IEalO0EndCBDhJKlAbwb6+q05tUYwgUr28LW+pW7jobFquyb90Ud58duISxvNVyKMfmy0Sygvpmb0dl7AiwtSutz8z1FrN1S+VymRy2czloSI94/UC4m9FAwN/Zce04sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcy7UL+bnv/Hr53sSBsAJTZKHEXvSXf6kcZVaiG1FYs=;
 b=SoiG1vRzmSqZiyRCgN8nsR+dgWS8sZuEa0SSgtgb03jpCWyGIA0KqrTfbnH6MLlztQ4xypvoMs0iSVEavQfWnvcRMZAfRrEl5t1LfAvy+H62y2Q6FB2oSS+OAl4+vCarlGr91Z1aDySEKfuBkzgnjpnMYXU5CrnjW/dyaAH3gJQZIHn9lGS0TebegIcdt882SJUY0GMS/ncU4hUQctmQuxp762XWPSmZOikmWSAAOBq9LGhU8REmputqypViJGPyCrqAqmeePPbN6FPDyahb6gST+sI4/0dLQqbJSuRvQ2THN4heZpqNf4cZDHwxr1oWnzd/2DAXcHJCcdyl8F0RrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcy7UL+bnv/Hr53sSBsAJTZKHEXvSXf6kcZVaiG1FYs=;
 b=N3cDWn5dHmZl7yaV2WOS8lsYozZgDEC3d/2QJgSACJTi/shc1Jm0dP5gEyzhokKo3IebBYVWSrRJj76set4L7efXx7TuORtLgos6oYnDkrzRAIDbhAbe91lUz6lLRAuBp5PI16SBKCncP964SYjwtz4qQQl7eRrLJwTHGVplyGg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 02:23:28 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 02:23:28 +0000
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
Subject: [v1,net-next] net:qos: police action offloading parameter 'burst' change to the original value
Date:   Mon, 29 Jun 2020 10:25:00 +0800
Message-Id: <20200629022500.30527-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0102.apcprd03.prod.outlook.com
 (2603:1096:4:7c::30) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR03CA0102.apcprd03.prod.outlook.com (2603:1096:4:7c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.12 via Frontend Transport; Mon, 29 Jun 2020 02:23:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3ca1aba-fd5b-494d-5d70-08d81bd368ca
X-MS-TrafficTypeDiagnostic: VE1PR04MB6608:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6608605D5CCED50CAEF3E9FF926E0@VE1PR04MB6608.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xdqt8ZINsq7KCzyAncj/tcBV1ZHJhBRlyF7W/haa/zjWfGOhHwz3PKpop7n74KOgDRzYqOeGBbC1W4UqJcMPSxffp5eZwaxxmxPXNJ8CDGwF6ZHCE9DdIvsDSDQDoI2pEwPLeV33PGYRPAz5TYWutgLw8w/IcC/jU0O0M2SmggCc6sk0CuvN6dMqAAum5ZFgsZm+r8CaY4a0cyW+Mf1SsClt7lnaGWFPHlF6JWCUz8C+wnmGEpaGr38UUGCgmv/zpbtCb1I09ZqfGNfzwcDO42/U2ewrWvrLykbWv1wRWSKkFsM657GdaTPNeH4J9a7D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(478600001)(186003)(956004)(2616005)(86362001)(83380400001)(44832011)(16526019)(2906002)(52116002)(4326008)(6512007)(36756003)(7416002)(6666004)(8676002)(6506007)(316002)(26005)(1076003)(30864003)(8936002)(5660300002)(6486002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q91QVPZSe4mnnrtF+24BJe84cQA721hPZ6y0E+xkTOLqWl/Q7tdCV5+lAEY8x3V/baffoSRFLaHJRc0Xi1efiInJPfMIyz1K8Ryy3AoejnoC5ckXQ2/LWsDDZKWyYhpND7BL1MZZ8VNvzp43e8FgMC3+tG9IL669DwRZ4wW2zGlAsG2uK76ULu6F0TAC/jaboaBrh+XasmhLSvkpa8+ryjJ7NSZxNLLAY9TwhMmtBuZVIdAI9gFO1dwu+9anW99tJcBhd7n94l8JquCBcK2Ws8Nq94JrT1AVX7ydUYIPiiAmZWgkwR55XlzbfUpXveXsWD5b/VG/5p6VNB/LvHCMXdnrnKHGqcd/RyO7DMMjkxk/pQp/kGM0lkshfYikTIwEOH1hyFLfVuQ+JS0eMiCnojdsb0xqB5dEa0H7MYiWDTVDnO9F16kacQY8XHyDQ6TeKLtp/KMcs67Z7PhJV0pq4S8Asu4TryDQnvhgvt1hx0A=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ca1aba-fd5b-494d-5d70-08d81bd368ca
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 02:23:28.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7X/wEHq0C+/xqPgeWI/Hex+91x+WkBhKu4Brx2pvYD/GkS3tH9vK/EOBFJDh664
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 'tcfp_burst' with TICK factor, driver side always need to recover
it to the original value, this patch moves the generic calculation and
recover to the 'burst' original value before offloading to device driver.

Signed-off-by: Po Liu <po.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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

