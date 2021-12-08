Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16C46DCAA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbhLHUJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:41 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:55236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239976AbhLHUJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmNoUeoLeL6t2Dt1XKtz4dbonqd1jmNGzSSIqEJAddIwPqKn9ikGJSdPw+ah3LoEnAboSbDlgWlx3FgQwKzDPh+U66bbqxSBf80cQhf8l3nDb+1qHbvUW1baeCHFB5Xp5SSkJIVhKJn3udcroJz5BpD6jPh8cOR9l0kQbFX8ogC8STM0ddJhHl0KRg+2Or3S+55IvyVSEAigA8CBpBft4iP1swM05WXhpKor8Sl4k8b/NTr+smhDO1gBetWuxauCG5ib4au8KYz8a5+4lKLZWaN1h7aVIbPlwacp2zwlrc7kCLk3JRM2YicMTfFyDZLjFv8iqBe1hUpeeoT1VtpMbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8Vidc2Rhy2FF/PeScg5a8OOKBd9IKP3cdoV3qrgG1s=;
 b=AtSYnQKeXW+AKJmi2Ks+W+9mIJhbnOdHbQr8qKDyXV+GFMnHmDnrnnxvAF4yAlFOwqDmgRE2AtWC+SaXjG0fbSfMtjm7JKlZPXGdnEjTjKE4i4u33U9McyXFoO1j1evWdVL2efbF1yEFcKcMj4deug69baNCne+lkOnLzeRVSymHEQbT5NUMTTGvSN+6MkCFjY+WVDt+looc9m2nhgP2kwwZH/v2P0mxtHiWfJ3P+5DW2Ld6w2Kgsy2WwUqH6OCp2jhe02MSKsVw8FZ01xDF7fmNeBJ0U2gZtoS29UVJMIC7P9+TmVS7qT3PYSsquvxh0VRJ4kbYUeLQfqkP1M07tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8Vidc2Rhy2FF/PeScg5a8OOKBd9IKP3cdoV3qrgG1s=;
 b=llLKQ97m6TdKPqRIUZfLnqhVhr7kxHpXdOVFbMegNh+5aAaTP1pHaNBqxFYf7J7n6bkLV5TDQjTRaLsKHMNmr+F+u912itjI0MnU4ihsKXCVSYNUwMaj3EmohxIckXGoTkclNw1sFahzc9Nnv7yJLgyqG2yO6vbvttmkfMoL+jA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 20:05:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 08/11] net: dsa: tag_sja1105: convert to tagger-owned data
Date:   Wed,  8 Dec 2021 22:05:01 +0200
Message-Id: <20211208200504.3136642-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62475fbb-918c-4100-500d-08d9ba862474
X-MS-TrafficTypeDiagnostic: VI1PR04MB4223:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB4223E433FD83430300FAFAECE06F9@VI1PR04MB4223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBMrm87bnHlVgbUD2yQu9uCyUWNmb1FDqIKnlcUxSKxR29pu/P+PuJ9zUCk/Lfp14JS/aDcZvlnSChWDT0VGxDHn/vAfSxqp2M7XJu2b2aBdJBgyNrVLP1E6s21S4cAJdJ/pbkPr1elqdAUJgXJTgLSVWZOtEPE/1es+YREhDufNF8whXfH4oU4Ex7pJegnV0LYWCKD/s0Gi+THMBLWiaFe7vCCFGh4a77dRipZ4rYEdXWiNODtcINIOB337k8frO4MmRRq7St31S3wFd6Czw8LkaVLsKm44gATXWbR3BbWa4+6hqWD2vZ5f2Cl4kXOBjZedK0OCtVWzDEzrNmMT7mDqnX5ryZ9sLX8iDGrCSkPkc8IYIVSRUrv+IG9IlqSlTw+zajPch1X9PComvdKDbJ/0mrqJwV9lRTDEPFTTVpRXU3mLOnuahp1XDr43RXwX5vvQrFwE6M7qk/eMXITHQANVgMc6uNf1ZTn1UXb3NJO5VxLRkKVzGMKo9Y+I8zXPbhTVscU18cwJV/YGRX13SzeYZisXz+dXAixNWZoGf2sDu5n9eLPQVkTAlAMlB65J9A0ovC5bD1EveKwTxa0lA14aJhdq9wWBQoLobWwcN9zE2nBY4hghOZOmx+MED5scwFI8Arlot1K8lJrYoCNFRhZZkDthN5C5ynv5smPOwy0wgjzyaCrsYrA6ibh+o3QY0PvCh73mNrF9nnahRwRxMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(6506007)(66946007)(86362001)(52116002)(66476007)(66556008)(26005)(186003)(6512007)(8676002)(4326008)(2616005)(44832011)(956004)(508600001)(8936002)(6916009)(316002)(54906003)(1076003)(5660300002)(30864003)(6666004)(83380400001)(7416002)(38350700002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7fkzCCTxP7mguZ3KmR2mk1KuaOJnoov2m0uXzkkcIWmoYdccACZDitAw9JbO?=
 =?us-ascii?Q?57SoLgv1AbRRKEaKjNLHilpuFWrShpym8o5AQX7GxrZFLRKpDco3RI7HbHy6?=
 =?us-ascii?Q?m1QGCKWABi61QopD9JP7YqS0hi0NyR2HpqqJXHFVN+kV50EACmWv1ezeg0LO?=
 =?us-ascii?Q?jYo3/+XUn+edUkS9HAVWSRJrOQtx8X2gPXzMXtMJU/5eAVmp0nrwXuJ5zMyn?=
 =?us-ascii?Q?DtnXDUeXgf7IbJ84djvUEWRc9lyBbARtuzjJkOCy7WOm1YVUXoqN/93scwpF?=
 =?us-ascii?Q?lYWF3Sw9Q6yuM0OU/ZRZoaeDAgNPRkEsorhhQJFfUPGBp3ksLkPK5N2AD5t9?=
 =?us-ascii?Q?oGB3zQFBBt6yBm4R+ukcNLqhsOkw0+WplKXIYNa66ahEXSpM+rUvPj0EIcbg?=
 =?us-ascii?Q?SZoBcoxbq0U/3ZaNJVzmDBJbFtEl4KsHiPW077pWRaoOwYGu+6aUnJdvpcxz?=
 =?us-ascii?Q?9pcJn2saYXji71gMy2EmnTpD4jCMJbNHbh0xy0UYGYektks39AWPq8SB2VgG?=
 =?us-ascii?Q?L3InUKPUg5pge4H1d+7co1xx8xeNtFnbdnmJnbmB4DKpCZt2pg5L0/8Y5M+B?=
 =?us-ascii?Q?0Tv4kWFWGjWB7ncIwwlSaXhaUgBGCBlMzf3fWk6busmnbzDBLy3jcEFa2OOs?=
 =?us-ascii?Q?Cy6wqtU6K4fTl/W1GPQ0jqkPgZO0LLH4BzV/4R67YVANpHJk3ea6jHkBgB1L?=
 =?us-ascii?Q?D81JxVN7UIG5TD5DOS56CxTMk1WqPjyt8c3vfV4iknSoNLo3L+HZjSLzE+Kf?=
 =?us-ascii?Q?iKyN4jXd337CtIFfe0oqdf9NQIU/c10We9EF6JcU/xNSXwHu5O2AbsotGZEd?=
 =?us-ascii?Q?jmghvT1b1EPWG2q8m3vVCjqqL5vRMglgV0lx0W3KvzME9xLccl/iGR2WzgOj?=
 =?us-ascii?Q?M3StckQSQ6Ox1oZi5M/QJKlfVk7TpSWf66DPAd9QxRTnZTEKa5kDGrM7/1pS?=
 =?us-ascii?Q?pdeSWDye3b9YQiqWbJdvMvWGCwhfoArmFdOjH4DcdBTb6GackLvgavvlPGgh?=
 =?us-ascii?Q?hwu61pYN3K39VEAxs7lfpn45pwnchh3LqgTYPmwCBMnnK7L9R6g0QAqWZgLz?=
 =?us-ascii?Q?xVamUf6Mk65khJpv7R74A8bx9jT4Th2jWZJeQB8eB+ZP7YtPMQbQiLOObyeB?=
 =?us-ascii?Q?8hHUAdj0BrHaOB9ZuPSPJ+I1IPYxUhx5o2uQo92TrMAsxfzBMMR+3ha36BEh?=
 =?us-ascii?Q?oJYAiJhZ0x2C+aP3cic6wm6+ziAxAHDbXVvGFINS5qdda0gwM0xengxn+TIm?=
 =?us-ascii?Q?o017oG7LDcrET7zu3ubdg1fcETzThqAl5U3llDaPQHXYReR9E0G9OcR5X4HW?=
 =?us-ascii?Q?9WSvhO5Mijjg7KXRBoREFw1GvKz2gw35lCEFzrNC25icSf/tApYRqjfHRpoX?=
 =?us-ascii?Q?kjrAqytPuc4TDT4irji6J9SwtZWCS4kD7mBTZ8dBS2p2iRrwtirRfxIJ6/u5?=
 =?us-ascii?Q?YfJtD2bm3TW+sc6ACO/lZGWfngpwkSnfzqGpBM6nF45t/h6OErEhvwWSuEVw?=
 =?us-ascii?Q?HAAiBRkpPJg4/vvorIHcuWbhZU0QMyj0xu7gbrBJjVgn95Y37SgOo5M89Ymd?=
 =?us-ascii?Q?tC84Rm0LLr9JaulI8O90r/C5OtZVYgONKvA9ZmNdmXzgIERNPEfFKsmBX6AM?=
 =?us-ascii?Q?rfNhWm38zZuBy/xSfF5EJ/Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62475fbb-918c-4100-500d-08d9ba862474
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:55.1340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+hg6/lEqx8MWKPaFtIJ6JgPD8RIGe3Xr7Tu8K5g5YAIAsC8W824r3LNvV3Z0xgulDQTBlQoXCvvaNJDzk8OWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, struct sja1105_tagger_data is a part of struct
sja1105_private, and is used by the sja1105 driver to populate dp->priv.

With the movement towards tagger-owned storage, the sja1105 driver
should not be the owner of this memory.

This change implements the connection between the sja1105 switch driver
and its tagging protocol, which means that sja1105_tagger_data no longer
stays in dp->priv but in ds->tagger_data, and that the sja1105 driver
now only populates the sja1105_port_deferred_xmit callback pointer.
The kthread worker is now the responsibility of the tagger.

The sja1105 driver also alters the tagger's state some more, especially
with regard to the PTP RX timestamping state. This will be fixed up a
bit in further changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 55 +++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 35 +++++-----
 include/linux/dsa/sja1105.h            |  7 +-
 net/dsa/tag_sja1105.c                  | 90 +++++++++++++++++++++-----
 5 files changed, 110 insertions(+), 78 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 850a7d3e69bb..9ba2ec2b966d 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -272,7 +272,6 @@ struct sja1105_private {
 	struct mii_bus *mdio_base_tx;
 	struct mii_bus *mdio_pcs;
 	struct dw_xpcs *xpcs[SJA1105_MAX_NUM_PORTS];
-	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
 };
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6468a8e963e8..4f5ea5d6a623 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2705,6 +2705,21 @@ static void sja1105_port_deferred_xmit(struct kthread_work *work)
 	kfree(xmit_work);
 }
 
+static int sja1105_connect_tag_protocol(struct dsa_switch *ds,
+					enum dsa_tag_protocol proto)
+{
+	struct sja1105_tagger_data *tagger_data;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_SJA1105:
+		tagger_data = sja1105_tagger_data(ds);
+		tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
+		return 0;
+	default:
+		return -EPROTONOSUPPORT;
+	}
+}
+
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
  * which cannot be reconfigured at runtime. So a switch reset is required.
  */
@@ -3005,39 +3020,6 @@ static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void sja1105_teardown_ports(struct sja1105_private *priv)
-{
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
-
-	kthread_destroy_worker(tagger_data->xmit_worker);
-}
-
-static int sja1105_setup_ports(struct sja1105_private *priv)
-{
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
-	struct dsa_switch *ds = priv->ds;
-	struct kthread_worker *worker;
-	struct dsa_port *dp;
-	int rc;
-
-	worker = kthread_create_worker(0, "dsa%d:%d_xmit", ds->dst->index,
-				       ds->index);
-	if (IS_ERR(worker)) {
-		dev_err(ds->dev,
-			"failed to create deferred xmit thread: %d\n",
-			rc);
-		return PTR_ERR(worker);
-	}
-
-	tagger_data->xmit_worker = worker;
-	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
-
-	dsa_switch_for_each_user_port(dp, ds)
-		dp->priv = tagger_data;
-
-	return 0;
-}
-
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -3083,10 +3065,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 		}
 	}
 
-	rc = sja1105_setup_ports(priv);
-	if (rc)
-		goto out_static_config_free;
-
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
 
@@ -3143,7 +3121,6 @@ static int sja1105_setup(struct dsa_switch *ds)
 out_flower_teardown:
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
-	sja1105_teardown_ports(priv);
 out_static_config_free:
 	sja1105_static_config_free(&priv->static_config);
 
@@ -3163,12 +3140,12 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
-	sja1105_teardown_ports(priv);
 	sja1105_static_config_free(&priv->static_config);
 }
 
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
+	.connect_tag_protocol	= sja1105_connect_tag_protocol,
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
 	.set_ageing_time	= sja1105_set_ageing_time,
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 0904ab10bd2f..b34e4674e217 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -58,13 +58,13 @@ enum sja1105_ptp_clk_mode {
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-/* Must be called only with priv->tagger_data.state bit
+/* Must be called only with the tagger_data->state bit
  * SJA1105_HWTS_RX_EN cleared
  */
 static int sja1105_change_rxtstamping(struct sja1105_private *priv,
+				      struct sja1105_tagger_data *tagger_data,
 				      bool on)
 {
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_table *table;
@@ -75,9 +75,9 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 	general_params->send_meta0 = on;
 
 	/* Initialize the meta state machine to a known state */
-	if (priv->tagger_data.stampable_skb) {
-		kfree_skb(priv->tagger_data.stampable_skb);
-		priv->tagger_data.stampable_skb = NULL;
+	if (tagger_data->stampable_skb) {
+		kfree_skb(tagger_data->stampable_skb);
+		tagger_data->stampable_skb = NULL;
 	}
 	ptp_cancel_worker_sync(ptp_data->clock);
 	skb_queue_purge(&tagger_data->skb_txtstamp_queue);
@@ -88,6 +88,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 
 int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct hwtstamp_config config;
 	bool rx_on;
@@ -116,17 +117,17 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		break;
 	}
 
-	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state)) {
-		clear_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+	if (rx_on != test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state)) {
+		clear_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
 
-		rc = sja1105_change_rxtstamping(priv, rx_on);
+		rc = sja1105_change_rxtstamping(priv, tagger_data, rx_on);
 		if (rc < 0) {
 			dev_err(ds->dev,
 				"Failed to change RX timestamping: %d\n", rc);
 			return rc;
 		}
 		if (rx_on)
-			set_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state);
+			set_bit(SJA1105_HWTS_RX_EN, &tagger_data->state);
 	}
 
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
@@ -136,6 +137,7 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct hwtstamp_config config;
 
@@ -144,7 +146,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
-	if (test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
+	if (test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 	else
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -417,10 +419,11 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 
 bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
-	if (!test_bit(SJA1105_HWTS_RX_EN, &priv->tagger_data.state))
+	if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 		return false;
 
 	/* We need to read the full PTP clock to reconstruct the Rx
@@ -459,13 +462,11 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
  */
 void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data;
 	u8 ts_id;
 
-	tagger_data = &priv->tagger_data;
-
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	spin_lock(&priv->ts_id_lock);
@@ -897,7 +898,6 @@ static struct ptp_pin_desc sja1105_ptp_pin = {
 int sja1105_ptp_clock_register(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	ptp_data->caps = (struct ptp_clock_info) {
@@ -919,9 +919,6 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 	/* Only used on SJA1105 */
 	skb_queue_head_init(&ptp_data->skb_rxtstamp_queue);
-	/* Only used on SJA1110 */
-	skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
-	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
 	if (IS_ERR_OR_NULL(ptp_data->clock))
@@ -937,8 +934,8 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_tagger_data *tagger_data = &priv->tagger_data;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
 
 	if (IS_ERR_OR_NULL(ptp_data->clock))
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index d8ee53085c09..9f7d42cbbc08 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -84,9 +84,12 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 	return ticks * SJA1105_TICK_NS;
 }
 
-static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
+static inline struct sja1105_tagger_data *
+sja1105_tagger_data(struct dsa_switch *ds)
 {
-	return true;
+	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_SJA1105);
+
+	return ds->tagger_data;
 }
 
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index fc2af71b965c..f3c1b31645f5 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -125,7 +125,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
-	struct sja1105_tagger_data *tagger_data = dp->priv;
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(dp->ds);
 	void (*xmit_work_fn)(struct kthread_work *work);
 	struct sja1105_deferred_xmit_work *xmit_work;
 	struct kthread_worker *xmit_worker;
@@ -368,10 +368,10 @@ static struct sk_buff
 	 */
 	if (is_link_local) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data = dp->priv;
+		struct sja1105_tagger_data *tagger_data;
+		struct dsa_switch *ds = dp->ds;
 
-		if (unlikely(!dsa_port_is_sja1105(dp)))
-			return skb;
+		tagger_data = sja1105_tagger_data(ds);
 
 		if (!test_bit(SJA1105_HWTS_RX_EN, &tagger_data->state))
 			/* Do normal processing. */
@@ -382,7 +382,7 @@ static struct sk_buff
 		 * that we were expecting?
 		 */
 		if (tagger_data->stampable_skb) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Expected meta frame, is %12llx "
 					    "in the DSA master multicast filter?\n",
 					    SJA1105_META_DMAC);
@@ -406,11 +406,11 @@ static struct sk_buff
 	 */
 	} else if (is_meta) {
 		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
-		struct sja1105_tagger_data *tagger_data = dp->priv;
+		struct sja1105_tagger_data *tagger_data;
+		struct dsa_switch *ds = dp->ds;
 		struct sk_buff *stampable_skb;
 
-		if (unlikely(!dsa_port_is_sja1105(dp)))
-			return skb;
+		tagger_data = sja1105_tagger_data(ds);
 
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
@@ -427,14 +427,14 @@ static struct sk_buff
 		 * that we were expecting?
 		 */
 		if (!stampable_skb) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Unexpected meta frame\n");
 			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
 		}
 
 		if (stampable_skb->dev != skb->dev) {
-			dev_err_ratelimited(dp->ds->dev,
+			dev_err_ratelimited(ds->dev,
 					    "Meta frame on wrong port\n");
 			spin_unlock(&tagger_data->meta_lock);
 			return NULL;
@@ -543,20 +543,14 @@ static void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 					u8 ts_id, enum sja1110_meta_tstamp dir,
 					u64 tstamp)
 {
+	struct sja1105_tagger_data *tagger_data = sja1105_tagger_data(ds);
 	struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct sja1105_tagger_data *tagger_data;
 	struct skb_shared_hwtstamps shwt = {0};
 
-	if (!dsa_port_is_sja1105(dp))
-		return;
-
 	/* We don't care about RX timestamps on the CPU port */
 	if (dir == SJA1110_META_TSTAMP_RX)
 		return;
 
-	tagger_data = dp->priv;
-
 	spin_lock(&tagger_data->skb_txtstamp_queue.lock);
 
 	skb_queue_walk_safe(&tagger_data->skb_txtstamp_queue, skb, skb_tmp) {
@@ -737,11 +731,71 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = ((__be16 *)skb->data)[(VLAN_HLEN / 2) - 1];
 }
 
+static void sja1105_disconnect(struct dsa_switch_tree *dst)
+{
+	struct sja1105_tagger_data *tagger_data;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		tagger_data = dp->ds->tagger_data;
+
+		if (!tagger_data)
+			continue;
+
+		if (tagger_data->xmit_worker)
+			kthread_destroy_worker(tagger_data->xmit_worker);
+
+		kfree(tagger_data);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
+static int sja1105_connect(struct dsa_switch_tree *dst)
+{
+	struct sja1105_tagger_data *tagger_data;
+	struct kthread_worker *xmit_worker;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
+		if (!tagger_data) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		/* Only used on SJA1110 */
+		skb_queue_head_init(&tagger_data->skb_txtstamp_queue);
+		spin_lock_init(&tagger_data->meta_lock);
+
+		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
+						    dst->index, dp->ds->index);
+		if (IS_ERR(xmit_worker)) {
+			err = PTR_ERR(xmit_worker);
+			goto out;
+		}
+
+		tagger_data->xmit_worker = xmit_worker;
+		dp->ds->tagger_data = tagger_data;
+	}
+
+	return 0;
+
+out:
+	sja1105_disconnect(dst);
+	return err;
+}
+
 static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
+	.connect = sja1105_connect,
+	.disconnect = sja1105_disconnect,
 	.needed_headroom = VLAN_HLEN,
 	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
@@ -755,6 +809,8 @@ static const struct dsa_device_ops sja1110_netdev_ops = {
 	.proto = DSA_TAG_PROTO_SJA1110,
 	.xmit = sja1110_xmit,
 	.rcv = sja1110_rcv,
+	.connect = sja1105_connect,
+	.disconnect = sja1105_disconnect,
 	.flow_dissect = sja1110_flow_dissect,
 	.needed_headroom = SJA1110_HEADER_LEN + VLAN_HLEN,
 	.needed_tailroom = SJA1110_RX_TRAILER_LEN + SJA1110_MAX_PADDING_LEN,
-- 
2.25.1

