Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7934437CB8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhJVSqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:47 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:2528
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232133AbhJVSqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsXr9yvv3Ispsl5r20DG2RMDyUfEJiEbeytIXJ4xzXauJDEnWmp+9Q/tIKYictJE9Bx5soachzUM1IwqSt4fvoPwhFfZYSmV3ZQq91XWllrsZeGhNOfs1qsOnEmw2x2GXxCBHg+ePoHWZ4if0Uo3WNqidEpsTB3+gmJfMDCAJLit5RILCFpnnWDbuCTL7soOj2QzTH0HQojQxv/OILF6KLacDtKGmpoi8FuRN47p6YzuKKPx+TBhInlxK0D2tl316FL6msVGXen89ZKWn0hJ0s8cCDvI8QCHRgamSl/LfaYGggvGRUxR7RnAs+UJ7g0GW3d9Yrh7BtoWEJpxQvZUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FOhTYDLhwzqGcd5/rfVe6rFg1r8Tc0i5xbyB/Z3lbOs=;
 b=OKPhfXTEzEUiIiWBB6oH1CHxWTJhVmXA0/FRgt8U6rpfSGYW5CYDrp9ZgBAhPdFp18ujp5MsaMBBJTf8t07IHlRwJ0a2HIogb7b8klRWjOmJ3WLFvX2yJQNoo+1SLxosasYKq94rOYWrCaCYa0GedHHUXfw/thUnsnLk87v9SA5wFJPryQlQTeAndkKnQ7wdTO30RzJtlaj37O0eB4jnvr64EKgnvrAD4xGa7WAM7GyXT2iUclbiRxgkfgD8fwGe+p1NYCH3EDbwjbUamO2t6kAaAnnxPCEe7GN8l5291sUa2+FtF2uzC+fNyk7J5NfOv/DMidX/b6XUheOvfYi3Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOhTYDLhwzqGcd5/rfVe6rFg1r8Tc0i5xbyB/Z3lbOs=;
 b=HpX5MpnMO9s9sw76nV2bZFHci6A2kqWhZLH0O7Wvw4ECPGuVjwrFRVNmkaUCu0WNPJqyjl3rtpCNxe2FhlN6bhVuoWWYTlDdDMXpm5Ymtuzbwo1gSvaLJfJ6fJxEnD3o1jDcS/dNI4TmiVSEXSN1B1BhL8znHRyIfqZMCFpOW0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 3/9] net: mscc: ocelot: serialize access to the MAC table
Date:   Fri, 22 Oct 2021 21:43:06 +0300
Message-Id: <20211022184312.2454746-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f733b791-f7b7-4f78-a6aa-08d9958bf8e8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862ED1E75C294CFF4CEDA73E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dC9KyyyNwBVKnD26Ra6ndBiruKVoZTmDX18+yYY+6sy8LurjaJsoVmDfGC7Sih9Tg+vwpMmmz9M771bFbgT+aoMx8cfiE8mtz+mZYiqF3hDTV/TkqRFq5WjIV3KMR4MluJWzIg0QXWfAhD2fBE0smPqBbdDS1F5VgMpnJDNH5ME730BEuzUmOfSSxrikTC7T4wi9Oksm0hJy5PHD7UDXmzDFvHxHzI6BkMDn3FQ2XnGYd6lX5RZ40H1lKY3Bw4z0eEIsk0CtNwttpWzUUOi0+Izx0vM6QiqY1p62xMrJEZAhMn3LtIjNQoRBWZhjvpMWCdEOUyzaN/t9f6jIIWsmtcyVeXDbKS08bQrGPp0Ur/ccYzQtLJS/w8vc1N18SPNT9D0z6LOq6iHXNHYGEyz4Lsb5tKYAGUYZaDi2GBAWcpLuY5uzNb4JkMBXg6sTPecU23Ccxd3MWqBOwddRgrAhA/Qmd78n/QPbPXWpeSdYe33Zf0LBSz3UwvkleDmFLbTX3pYQTby6+xh7q8J6bfsRO+mZcU2SMQbJ86YPsXlw/lY5iy/FACzvOf33C6ITnRVnwrN5JV8Ozw+qdr8AGz8PXA1KY36TanfqWsGjQ5P/mBK3ku+VIeW/84jnGtGIZ4aii+T5lGwPMMS39Vu9rrn56lR3lSUxeuSaqg5vvjkNLEpOyc/jXH2pn/Ynas2nq/uE5DEM9/jxsdVZSV4EMSQzPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L707bz8D0sYqtbsM0dgPh+/MT/rsjQlUS07AOe89Xnkyhgpiz+ZkCdtLcy25?=
 =?us-ascii?Q?YTmos7yCJxfdYWAOiL6JINUnZ1yJQJSrUjSBpsbPFaXdrKEaoo41ohPx5VjK?=
 =?us-ascii?Q?RxDOHJK55wGiXYWmwgW9xT5JpClRKfoQv/grJ/MAO7DT1itBm/MuYCGtj9QT?=
 =?us-ascii?Q?lKojz8lqjVuMv7163CZEBQEoLT2w5Ywj1kTgF6NMBuqZ5ojyNosSy4A7lIjy?=
 =?us-ascii?Q?SlFIHg50hwWtxGg5oVkEvCvzCl9HXy6mmeoitI6Zi23LFF/VWVI7TiztPus4?=
 =?us-ascii?Q?kSFlvwDqHonUmX/H9QQWEHk9Gyz/a0ELEaKs/y9l4JsXL6/LkChPHZuU1JB4?=
 =?us-ascii?Q?XF5M6bH1ck/BY6qLaoXCGMF0xbM8zQc2pchKocSxknACwaBk7gnTKnfnpcWw?=
 =?us-ascii?Q?weHUY+L+6Znu5fGdxivVtDED1c2yx7Tm9F3yd8ZhcUpAdXH8eqO71pytsoE/?=
 =?us-ascii?Q?+ux1Z8ntbhJ6fkfd9wjRwbuAi5vJOf8WLHlcS//GtLxKllLzcEBgWnkahlIz?=
 =?us-ascii?Q?SYqkxpZfiCv/pxKpPUc38v/kM4KslhHn4BIp+8Syd0DIP9EHEF7mdo/RFNp1?=
 =?us-ascii?Q?5amhdOi9KnJtdgNS00s1ou+AdFWi56oWxXS5RpEWE6FOEc8RZ4ha4R3Wn+iK?=
 =?us-ascii?Q?dj/cXi5166ANgU9JrTdD+rj92ANKpTrvRypmT8Qw4h2BwMg6UATtM8XosTCZ?=
 =?us-ascii?Q?R1KLSmu3ZQ43OiQnN1BFp4rxNC7DePyT7KqLZXTejgRVqTotlPQx7KMn720/?=
 =?us-ascii?Q?CL6Kj/ojONZBenC/I1nbS6qs9OcvRKiVT80DBzQ8XKJEP4MxSTNeZdeWGWcz?=
 =?us-ascii?Q?VGCdzvgbSzCT9T30erI4RQcPG+X9lh5N4yzrroBTgWM8ZtyeDAD1bmv528K7?=
 =?us-ascii?Q?IDq8taR6J5+Pe+ihAPqjh1SrkACT+OdZZtB3bBNCti7hSiWA4ZQ6HzZb04VR?=
 =?us-ascii?Q?ysz4GbbvDInX0eL/8sVf+bicQ7UtK+6ahgZaRXrGWIfc803LG99S+kZkgrb5?=
 =?us-ascii?Q?iR6KIqeMLhql1dPH26ClrcMw2TviZVKUweoNtyGiZcfv32rSayiX/TNdZVOo?=
 =?us-ascii?Q?bzRCXrrAaLFQk3XxIPlROxQiD6LeuDKWsZgy+LusX3m8GTW12CcBEx1cMBAF?=
 =?us-ascii?Q?iLPDaPtlTXNGogi98J36tYuiCuoKU9GhS/xf8gDciJuIOZZDvtD04TFlt8tE?=
 =?us-ascii?Q?qkE1Apj66n9lqqDlSXcpXHarVogyUl+1kqllSPqUxE/sn6s07HL4ZtNE7Lh5?=
 =?us-ascii?Q?WJU68A1YNrw8uBr2YUWuVQzl5URBGGW3VaagL+fbwt6FevYDWWvCNNwuxgIk?=
 =?us-ascii?Q?wMS84MNRPSiW5zaPpK5xV52pmCpfzI5VpMaxI4NHOkMCwr1jYmZsa0FKztAa?=
 =?us-ascii?Q?vYVguI7cZCOPRlsrUB0ympxFJ4GG3SLR7zUGfWEn9gy4SVHpsw8JDbFx/Cwl?=
 =?us-ascii?Q?piBfrc22lvZ+lzvzEG/a0urixAVXLoR4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f733b791-f7b7-4f78-a6aa-08d9958bf8e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:26.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA would like to remove the rtnl_lock from its
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
the same MAC table functions as ocelot.

This means that the MAC table functions will no longer be implicitly
serialized with respect to each other by the rtnl_mutex, we need to add
a dedicated lock in ocelot for the non-atomic operations of selecting a
MAC table row, reading/writing what we want and polling for completion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3->v4: use __must_hold

 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  3 ++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4e5ae687d2e2..33a4a9a17436 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -21,11 +21,13 @@ struct ocelot_mact_entry {
 };
 
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
+	__must_hold(&ocelot->mact_lock)
 {
 	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
 }
 
 static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
+	__must_hold(&ocelot->mact_lock)
 {
 	u32 val;
 
@@ -39,6 +41,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 static void ocelot_mact_select(struct ocelot *ocelot,
 			       const unsigned char mac[ETH_ALEN],
 			       unsigned int vid)
+	__must_hold(&ocelot->mact_lock)
 {
 	u32 macl = 0, mach = 0;
 
@@ -67,6 +70,7 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
 		ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN);
 	unsigned int mc_ports;
+	int err;
 
 	/* Set MAC_CPU_COPY if the CPU port is used by a multicast entry */
 	if (type == ENTRYTYPE_MACv4)
@@ -79,18 +83,28 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 	if (mc_ports & BIT(ocelot->num_phys_ports))
 		cmd |= ANA_TABLES_MACACCESS_MAC_CPU_COPY;
 
+	mutex_lock(&ocelot->mact_lock);
+
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a write command */
 	ocelot_write(ocelot, cmd, ANA_TABLES_MACACCESS);
 
-	return ocelot_mact_wait_for_completion(ocelot);
+	err = ocelot_mact_wait_for_completion(ocelot);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_mact_learn);
 
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid)
 {
+	int err;
+
+	mutex_lock(&ocelot->mact_lock);
+
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a forget command */
@@ -98,7 +112,11 @@ int ocelot_mact_forget(struct ocelot *ocelot,
 		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_FORGET),
 		     ANA_TABLES_MACACCESS);
 
-	return ocelot_mact_wait_for_completion(ocelot);
+	err = ocelot_mact_wait_for_completion(ocelot);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_mact_forget);
 
@@ -114,7 +132,9 @@ static void ocelot_mact_init(struct ocelot *ocelot)
 		   | ANA_AGENCTRL_LEARN_IGNORE_VLAN,
 		   ANA_AGENCTRL);
 
-	/* Clear the MAC table */
+	/* Clear the MAC table. We are not concurrent with anyone, so
+	 * holding &ocelot->mact_lock is pointless.
+	 */
 	ocelot_write(ocelot, MACACCESS_CMD_INIT, ANA_TABLES_MACACCESS);
 }
 
@@ -1172,6 +1192,7 @@ EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
 
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
+	__must_hold(&ocelot->mact_lock)
 {
 	u32 val, dst, macl, mach;
 	char mac[ETH_ALEN];
@@ -1220,33 +1241,40 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data)
 {
+	int err = 0;
 	int i, j;
 
+	/* We could take the lock just around ocelot_mact_read, but doing so
+	 * thousands of times in a row seems rather pointless and inefficient.
+	 */
+	mutex_lock(&ocelot->mact_lock);
+
 	/* Loop through all the mac tables entries. */
 	for (i = 0; i < ocelot->num_mact_rows; i++) {
 		for (j = 0; j < 4; j++) {
 			struct ocelot_mact_entry entry;
 			bool is_static;
-			int ret;
 
-			ret = ocelot_mact_read(ocelot, port, i, j, &entry);
+			err = ocelot_mact_read(ocelot, port, i, j, &entry);
 			/* If the entry is invalid (wrong port, invalid...),
 			 * skip it.
 			 */
-			if (ret == -EINVAL)
+			if (err == -EINVAL)
 				continue;
-			else if (ret)
-				return ret;
+			else if (err)
+				break;
 
 			is_static = (entry.type == ENTRYTYPE_LOCKED);
 
-			ret = cb(entry.mac, entry.vid, is_static, data);
-			if (ret)
-				return ret;
+			err = cb(entry.mac, entry.vid, is_static, data);
+			if (err)
+				break;
 		}
 	}
 
-	return 0;
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
@@ -2231,6 +2259,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
+	mutex_init(&ocelot->mact_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	spin_lock_init(&ocelot->ts_id_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b872da0c246..fef3a36b0210 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -675,6 +675,9 @@ struct ocelot {
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
 
+	/* Lock for serializing access to the MAC table */
+	struct mutex			mact_lock;
+
 	struct workqueue_struct		*owq;
 
 	u8				ptp:1;
-- 
2.25.1

