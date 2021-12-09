Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF1B46F780
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhLIXiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:50 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234447AbhLIXit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRyA5SACiJaoHfsP3nu7n7kAslIVpg3WHeH0gZNqz7ZPke8r5wj9rGz05UaUlqeNk08uNRn/yJLH3ZAreeFoqKtO0lT1eoRtnGkfxCnKwsL+PeJfKGKG+bXqEiKE6H54xJ3pii9n45sxbPsBiFRKS0QNvQtpkl2W150HoTOI/ZHaxUp7UbA9f0Am2/RmrEsH72kiGA/NvfP8i5pQVZPBJtIB0X7PF6Qo0jua3mhJgC9nmSKgBw65YQMhVJId4w1LMIN/JqwrJOzjJMfStJ+SKSlQs6xAV0NqC73b6R/KEI8YwAG3l4DbN/CB7VJ5GZYLtd/17+KNHJtlqQBU/Qtmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCz5JyOxmCecCN60IwnE61jahFR59Ny3KLoyLeTQGcc=;
 b=iXUzU53CRU5klgLVvsYr6Scz646tDqFhF+XJEScSSjOillFVeNiZZRTPw7Rnx2O5GJ63oanQUe5fc+4UmQUIWbIWFzWaNRcJTn1FY7dwXP46dLTDuC/THeeFtiF+20G4FIpV6y/+4C/MMYg74WG+6SzDPh8QIL8NQ2MJik0Wnd/iHu2SjPcYJu48nu0HMIjMaFSuqme0Ujl5RAbxWmVosGy122FMfRe4E5+LK4xZ35UNalcxQeUPR5z9BXsnwDWVL9ggBzbOZrFu54oIe10WCvzhqGSSY/xUHOcygnUj7P62b11kB5oazxKhJQeWHdqq8eMYPokG4bMpfMqr+DnMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCz5JyOxmCecCN60IwnE61jahFR59Ny3KLoyLeTQGcc=;
 b=XY4Cl2gb7pNP8wd8jK2pmYU1eMCfkmpro9dY7fQgNjAX79Mm9guvtzFo3r/82ptbej9AIc2zQjNU9r0RQzosZSXZ3pSmMN50oX7dcAX4EcWFos4XSliT/YbY3dNN1i2iqV6ERsz7ahNODXRMHWzOxEI51R9EvhvwXwA/bZz95nQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:10 +0000
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
Subject: [PATCH v2 net-next 02/11] net: dsa: tag_ocelot: convert to tagger-owned data
Date:   Fri, 10 Dec 2021 01:34:38 +0200
Message-Id: <20211209233447.336331-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbca124c-3005-46b7-1560-08d9bb6c8a60
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408616EF32B29E67E429784E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwAFjVmu/dOqs8/pXM5fOt7BjSElKL/5VmEERxg5usTdQRYNr4JQ7iptJYD6U6rfgQm07kNjvaZxJUJG/xiW1vUPF0TayrKxxsHtmjBZcbCojKVGnqmREksXf4WO6pZa+ziHa2ZUNhMZ2VHHlzEcZbNjxMMO28xwRyYAExDOQzN4fP3xTPzio+WbKJwI7Ep4ydfOc3QYYhDIwUMMtczQ7f+eoZbzfvGWbdIRpPoV5kXkNDrz3PQ5ywYE3XEhEL24RiT0yB/N8W3V+X1Aoc3YJsv0YU73I917G/X0av03Sc3Odc4jeSuHNiMrPKgCIzTMwEsIKJfZuZYQxfzUSA4u5bm9C1EnRHEFP71RPo9bQBfeFgi1gRgfSsgQd4GFLklWPyh9wqmJ81gy+Nk2ZbCsQ+ts+H7lNcrk/eKHMbLHCtWMqOoPjwdgCbwmnqSHcbdBIH7uI0lsYGaaWnnzkkdb5El7ZVoilSbHQlxjzJC4FGxYULN0rPJAlKnydfxza/uFktwUfRzhnV2xrpYEFQgXnaSlUFDrdkKOiwGkLfqnFuOlSda223NKbhdkvVpX/8tokPfRSYH7QZZe9uqEYjIEYmXu6wppKe6m+oo5b3oNaRxThGBcvp/YvQ5vGOw3qhEQBNGVOuCmJTZ06CK9GrEchw7D2oUMW1qsjN63lbd+XT2YE8SKhRulguR58Bu8fPBQ/b1QC0Fm58VB88qg7mXUtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OlabfJ/oMiYHQnVa0XkgW86aVdot7pGUgIei0Hytns+FYmmrMqRgaKveSLQ1?=
 =?us-ascii?Q?5jv3jtMhovjmtuniGBs3zNUWjjNiXBjxggiXXHvHOHikqleU8TW9s671HoYl?=
 =?us-ascii?Q?uez5wa2wWPTcagj5YlCFZuar5P/YKNuOicLLIj5voro/ft4/j6keC8IftokT?=
 =?us-ascii?Q?tKsaXbwvycIGr1rLULlcjiycSMnk/6fmuJVhxc7rFNuKWftvVBb8YRYSvf8e?=
 =?us-ascii?Q?VBJD7oecyOUwPQ4xflaFkA8XlBKy5XvwDDx4zEN54mGpNb8PVqNPGbF1+c4q?=
 =?us-ascii?Q?EnZ1xA1QUb4iev5bA0agAJW3CnHlNq09cAyR6UZbg63T0p/+ydibj/Oa9l4+?=
 =?us-ascii?Q?kSVj1b3pxVN8aP98VpIoVucCdMbKJ+5GxTqxMnDlXi3dRMB2zE/uz0ayYvJZ?=
 =?us-ascii?Q?X1mbbYquMh2HCHdHlIuujAmpSRWyjRG1oheuXbvvyr7jMcqu9IekDLqbukVq?=
 =?us-ascii?Q?avokEKqeAdquWsQDXzJ+aKIttOLU2v+3wP86Gi+zvd3NYtA96vA4gtMIPDWT?=
 =?us-ascii?Q?q38NP15ym6xGLJhq17Ma9qjRFE8mxS3+v2zv8TXRagP4ZXd1AB7QSSOAvi2X?=
 =?us-ascii?Q?oTA6iPdlHh6vVeUywh+tndHbQH0mJKTHbg0RntvPpHrxYyop0/Z3htJsr1js?=
 =?us-ascii?Q?u9+w6dOzS/rW+BpEFcAaC2EM2p1Gvyi8EOrA++IMPXciMwJq3MnNUv3wviaV?=
 =?us-ascii?Q?5k/cjoNBQqtkeHdIlRPwVSiZyB03CFL4utk7Ch8K8OvaDDEsZxgPDvVQcDH+?=
 =?us-ascii?Q?aGf0R/v/w5WX1Q6GhIlawqpLPIdxjMMXGybjtH1BY9vgx/er2Z0TDY/QDtkM?=
 =?us-ascii?Q?w5NidEIYLegLw5u5NH7onzz/3tRdhABa/uF8IMAlx80gNG+oKbr6YMqsba1P?=
 =?us-ascii?Q?WHHszFe/6T9pzb/OQj6BTokh1JvvhVh2MlNrjUO3xECQSsXKXuC+XUfXHa9k?=
 =?us-ascii?Q?G3gejQDTnRlnyyFZPJAqdXx1mFfc/z1InuCDZINs1ZHzcMJ4a8JQRhVUMTvc?=
 =?us-ascii?Q?t9geL5xEKCwzx6UZ8kGb2+63WjIH5gnLVJTP1oxXqQjg+oOuTpEoCgAzjoLg?=
 =?us-ascii?Q?oNJjMJfqUjyx+bxyXC1djnc7Y6VHUI9G53vaEqz4NhBiuj/h9WKFQO87MC3z?=
 =?us-ascii?Q?RSSs2gT0kcfvYkl1T/DoOUvS9ZVzj9xajV1EiqInTDYbRt+FL2Z0g2ksCn2p?=
 =?us-ascii?Q?KQ4FomftBAnxjpYCtIThhpeauM7dwCEgT+OfUM34C08ecA/sO724HnXxo+jo?=
 =?us-ascii?Q?a5ceLOkeAh4SoX0n1vWP9c9BCzt0KiVPMKWm8ZkS1ZVRYfsXIOKlw0UxDlmP?=
 =?us-ascii?Q?8wG0S8XeiJaqXjFc8gRyawJOmcoLcnkqGvvdj2RZxnEws6HvzVZ1HvjnQIhw?=
 =?us-ascii?Q?Auc0IdEwKSA9+/6Zm/HQ+hVdoWa8zW4Td/dhYcBEU3IpJUXvX/aaZWMyXd7Y?=
 =?us-ascii?Q?CKKugVdrqoWR1ruokKdBCEWZEHtnu4s6SHsuhqDUMu96xgz2i6MChp5ofblY?=
 =?us-ascii?Q?EvtwKck+diD8acw3w8FxRFuvUZsFxcVdlRhkoceS+LR7awmyY/6NqjpvqEyI?=
 =?us-ascii?Q?WjiAtNAXInDaEB+2TPYI4eGWxcvv0MV2sj60VBZI0p5vTcxl/0695KS4QKd4?=
 =?us-ascii?Q?3ACKqx0Xe4R9/Afps778aYc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbca124c-3005-46b7-1560-08d9bb6c8a60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:10.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6sDiExdr2M9ADWH/GjiBEUvEH+AuFusx2Rsy7u/+g8wID8AueQgcE7lwAJA3qgKyz7FcVCXcWfCE8Pi9Htf40A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix driver makes very light use of dp->priv, and the tagger is
effectively stateless. dp->priv is practically only needed to set up a
callback to perform deferred xmit of PTP and STP packets using the
ocelot-8021q tagging protocol (the main ocelot tagging protocol makes no
use of dp->priv, although this driver sets up dp->priv irrespective of
actual tagging protocol in use).

struct felix_port (what used to be pointed to by dp->priv) is removed
and replaced with a two-sided structure. The public side of this
structure, visible to the switch driver, is ocelot_8021q_tagger_data.
The private side is ocelot_8021q_tagger_private, and the latter
structure physically encapsulates the former. The public half of the
tagger data structure can be accessed through a helper of the same name
(ocelot_8021q_tagger_data) which also sanity-checks the protocol
currently in use by the switch. The public/private split was requested
by Andrew Lunn.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 64 +++++++----------------------
 include/linux/dsa/ocelot.h     | 12 +++++-
 net/dsa/tag_ocelot_8021q.c     | 73 ++++++++++++++++++++++++++++++++--
 3 files changed, 94 insertions(+), 55 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a02fec33552d..f4fc403fbc1e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1155,38 +1155,22 @@ static void felix_port_deferred_xmit(struct kthread_work *work)
 	kfree(xmit_work);
 }
 
-static int felix_port_setup_tagger_data(struct dsa_switch *ds, int port)
+static int felix_connect_tag_protocol(struct dsa_switch *ds,
+				      enum dsa_tag_protocol proto)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-	struct felix_port *felix_port;
+	struct ocelot_8021q_tagger_data *tagger_data;
 
-	if (!dsa_port_is_user(dp))
+	switch (proto) {
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		tagger_data = ocelot_8021q_tagger_data(ds);
+		tagger_data->xmit_work_fn = felix_port_deferred_xmit;
 		return 0;
-
-	felix_port = kzalloc(sizeof(*felix_port), GFP_KERNEL);
-	if (!felix_port)
-		return -ENOMEM;
-
-	felix_port->xmit_worker = felix->xmit_worker;
-	felix_port->xmit_work_fn = felix_port_deferred_xmit;
-
-	dp->priv = felix_port;
-
-	return 0;
-}
-
-static void felix_port_teardown_tagger_data(struct dsa_switch *ds, int port)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct felix_port *felix_port = dp->priv;
-
-	if (!felix_port)
-		return;
-
-	dp->priv = NULL;
-	kfree(felix_port);
+	case DSA_TAG_PROTO_OCELOT:
+	case DSA_TAG_PROTO_SEVILLE:
+		return 0;
+	default:
+		return -EPROTONOSUPPORT;
+	}
 }
 
 /* Hardware initialization done here so that we can allocate structures with
@@ -1217,12 +1201,6 @@ static int felix_setup(struct dsa_switch *ds)
 		}
 	}
 
-	felix->xmit_worker = kthread_create_worker(0, "felix_xmit");
-	if (IS_ERR(felix->xmit_worker)) {
-		err = PTR_ERR(felix->xmit_worker);
-		goto out_deinit_timestamp;
-	}
-
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
 			continue;
@@ -1233,14 +1211,6 @@ static int felix_setup(struct dsa_switch *ds)
 		 * bits of vlan tag.
 		 */
 		felix_port_qos_map_init(ocelot, port);
-
-		err = felix_port_setup_tagger_data(ds, port);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to set up tagger data: %pe\n",
-				port, ERR_PTR(err));
-			goto out_deinit_ports;
-		}
 	}
 
 	err = ocelot_devlink_sb_register(ocelot);
@@ -1268,13 +1238,9 @@ static int felix_setup(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
-	kthread_destroy_worker(felix->xmit_worker);
-
-out_deinit_timestamp:
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
@@ -1303,12 +1269,9 @@ static void felix_teardown(struct dsa_switch *ds)
 		if (dsa_is_unused_port(ds, port))
 			continue;
 
-		felix_port_teardown_tagger_data(ds, port);
 		ocelot_deinit_port(ocelot, port);
 	}
 
-	kthread_destroy_worker(felix->xmit_worker);
-
 	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -1648,6 +1611,7 @@ felix_mrp_del_ring_role(struct dsa_switch *ds, int port,
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
+	.connect_tag_protocol		= felix_connect_tag_protocol,
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 7ee708ad7df2..dca2969015d8 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -8,6 +8,7 @@
 #include <linux/kthread.h>
 #include <linux/packing.h>
 #include <linux/skbuff.h>
+#include <net/dsa.h>
 
 struct ocelot_skb_cb {
 	struct sk_buff *clone;
@@ -168,11 +169,18 @@ struct felix_deferred_xmit_work {
 	struct kthread_work work;
 };
 
-struct felix_port {
+struct ocelot_8021q_tagger_data {
 	void (*xmit_work_fn)(struct kthread_work *work);
-	struct kthread_worker *xmit_worker;
 };
 
+static inline struct ocelot_8021q_tagger_data *
+ocelot_8021q_tagger_data(struct dsa_switch *ds)
+{
+	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_OCELOT_8021Q);
+
+	return ds->tagger_data;
+}
+
 static inline void ocelot_xfh_get_rew_val(void *extraction, u64 *rew_val)
 {
 	packing(extraction, rew_val, 116, 85, OCELOT_TAG_LEN, UNPACK, 0);
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index a1919ea5e828..fe451f4de7ba 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -12,25 +12,39 @@
 #include <linux/dsa/ocelot.h>
 #include "dsa_priv.h"
 
+struct ocelot_8021q_tagger_private {
+	struct ocelot_8021q_tagger_data data; /* Must be first */
+	struct kthread_worker *xmit_worker;
+};
+
 static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
 					 struct sk_buff *skb)
 {
+	struct ocelot_8021q_tagger_private *priv = dp->ds->tagger_data;
+	struct ocelot_8021q_tagger_data *data = &priv->data;
+	void (*xmit_work_fn)(struct kthread_work *work);
 	struct felix_deferred_xmit_work *xmit_work;
-	struct felix_port *felix_port = dp->priv;
+	struct kthread_worker *xmit_worker;
+
+	xmit_work_fn = data->xmit_work_fn;
+	xmit_worker = priv->xmit_worker;
+
+	if (!xmit_work_fn || !xmit_worker)
+		return NULL;
 
 	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
 	if (!xmit_work)
 		return NULL;
 
 	/* Calls felix_port_deferred_xmit in felix.c */
-	kthread_init_work(&xmit_work->work, felix_port->xmit_work_fn);
+	kthread_init_work(&xmit_work->work, xmit_work_fn);
 	/* Increase refcount so the kfree_skb in dsa_slave_xmit
 	 * won't really free the packet.
 	 */
 	xmit_work->dp = dp;
 	xmit_work->skb = skb_get(skb);
 
-	kthread_queue_work(felix_port->xmit_worker, &xmit_work->work);
+	kthread_queue_work(xmit_worker, &xmit_work->work);
 
 	return NULL;
 }
@@ -67,11 +81,64 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+static void ocelot_disconnect(struct dsa_switch_tree *dst)
+{
+	struct ocelot_8021q_tagger_private *priv;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		priv = dp->ds->tagger_data;
+
+		if (!priv)
+			continue;
+
+		if (priv->xmit_worker)
+			kthread_destroy_worker(priv->xmit_worker);
+
+		kfree(priv);
+		dp->ds->tagger_data = NULL;
+	}
+}
+
+static int ocelot_connect(struct dsa_switch_tree *dst)
+{
+	struct ocelot_8021q_tagger_private *priv;
+	struct dsa_port *dp;
+	int err;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds->tagger_data)
+			continue;
+
+		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+		if (!priv) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		priv->xmit_worker = kthread_create_worker(0, "felix_xmit");
+		if (IS_ERR(priv->xmit_worker)) {
+			err = PTR_ERR(priv->xmit_worker);
+			goto out;
+		}
+
+		dp->ds->tagger_data = priv;
+	}
+
+	return 0;
+
+out:
+	ocelot_disconnect(dst);
+	return err;
+}
+
 static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
 	.name			= "ocelot-8021q",
 	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
+	.connect		= ocelot_connect,
+	.disconnect		= ocelot_disconnect,
 	.needed_headroom	= VLAN_HLEN,
 	.promisc_on_master	= true,
 };
-- 
2.25.1

