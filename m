Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF506438AEB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhJXRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:00 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231658AbhJXRU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz+Xdsw0SjyCo4dvy8Np8Q2iIWjaf6WMfp7RQiYpZXVCMcBM2qlgOeM3ebYo+eRyZ4xi9GRaP4YTZzMKnA2BkB6N8xVWCJ7Cu9FhjI4tu5rXky1ORM2sBXV/Bncy2U58F0uPqeMnC5QyPu1qAv1jrfyON+U/r4xnzjhdl36VUUNi9Fu77UKLMEVwJSFvXCSGqxVYNlxoDTPRgpw2B0MjmegkamCfJ2iv8r+q7KS9yPBxv27BNrang4C/hbrgjc4pzuwR+DVOLbmFDBLuTp/V0U6w6x8IAOir+I7Lby7+wuZWxKyghwe8J8/aBmxVDMwLnrf/Nt8xMPtv4qGQC6VQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGm6OnOEC21Dt30CP4YeiqV7nWs97IVRQwAsXPHL+zw=;
 b=kbsuXYD1etlG/E6sgoAXqWoNZ4yoNM0q06l4vcK3iwHKLlJapaBA4zPTuaFMuZe27oodsUPZblj4oXDCRngXSY5iNZRS3J6T5+VswSfzLZi/Abu3810OuEm/WFBCrkcspsYrZC32bpLzQuPbUW+5KVqGZ6VzVzebpGyvu0+F8qNKZjTQNWAnzZrbexPZmJNY/cvGgtke7pKwys2N7yZLNcmEjfuNHoeTvCm4QaP96NZgu/6mrQns8soLsJ5W5QgS/y0A5+ZPVkAKpA8LIIVbR1s0oxbMqHg7O99ji6wB9xM9K8ZUKvgWSuaoyxeO38CQpVBCA/jw2qrk9xwUt9XfmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGm6OnOEC21Dt30CP4YeiqV7nWs97IVRQwAsXPHL+zw=;
 b=GlUG4+coy2TVcXARJNZfLyzjpFijSx2jo97wqWksOHxlMYH/6b2rXsePfEfqebPocKA9trQffOu5ZCtpSqF/txbge/BXPyIX4cwaERmORQA4AP9lJImJufniSjn2pPhtIaAF90mo3/cl0MRsEt7byAPF5hv4lK45qPXuqsG/yAw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:32 +0000
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
Subject: [PATCH v5 net-next 04/10] net: mscc: ocelot: serialize access to the MAC table
Date:   Sun, 24 Oct 2021 20:17:51 +0300
Message-Id: <20211024171757.3753288-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23c37e72-e5e9-4adf-fbe3-08d997124e26
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35526824572D683CC2090039E0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksYFNEt9LNl708VmgqL4FyFXfYZAVQUm5uBkIDw/bcE5j6nnfDHQgcv3QZeJHMvSORIfx/V1fewtdvQGeFev8XON88Jay2DUZFcotIO+aIVLzKBrTtac2HyMl9XIkIslg9JxghyTN7pwNH3vrHWItW6pylf6bQCIAmzCZ3HACQrmkAvrxYiBu0kzoyNUNDmxpX09xhZNiVbfrZO+2WZM7urSKcsLx+lfSGSZJEhAjLO84+PVjjPKTSBXVv0i9ecpTI4Klz1lu9pVJX5k4a3KIKmz80b7Pd/NuE8/M6HZ0Oms4muiusZAdtQLOO+B7qmnT9ZTA7/mmnV19YeupET80qNNDiz7ehYxvtN+JEHYQhV3aGGEEUp8HfbKTCg9Oxq5l59vZVNSZ+b51DMgygdfc7sfRiR5AETPmFYUUnbz81QOFKQZfsemEV5E0FhLpuHzTpUgDQUHETza7Gt2PnnMnWEYCbBh4YN3KAu4y+pF49kuGGvT8J2Pyfjp6eeq5Feps035N+QwR/X4i9uUi+gx8jfIM+8lrnzvj0co6v68X/TT5qK171P8qGm6nHHA6iyCXGCwfMSldJQ6BsycAY5YEWBKXYmD7upw+PDJfbsO4Gp1t9dohItPKMp6rYzNkjWQ8OCUQvtDvbdmPHUL3xu9WKi3pdnCzB2qwIjkH5ehFngrVAUdq3dSxAG+2d0FJPE+j+r5XCteUXCahWNISlec3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vEOAIn4kLtC5ROPK3mQ0YSffmFzBywKDvXxKh/tnWtwXGk86r2Y5InOcUz6M?=
 =?us-ascii?Q?hM72ss1F4kH2T/E6Z+omfQoTLkAHklmMxYyVqSoKpExLr1IqWfNztxfs9siV?=
 =?us-ascii?Q?1Hx6v+TMDl/nFhdnSdM7AsC4l8fr18CeXdGP5J2B27ul1L/Hn2yKdUFao5Og?=
 =?us-ascii?Q?EaOCC7uOJfD5DqtZ0K2phb5PvWzKWMUqoK8O5ID4bA9yflNNI6l1yuQ9x466?=
 =?us-ascii?Q?alinR7d/dxf/ixqFZ+d1D0rCc4RMHnGBnPwfhlXQGWTPJTTxHheLYjdNRV0x?=
 =?us-ascii?Q?bkSJQJnJa8rvvRkxVYeTtZswJAlPPdb13dPG0vuMuSkcIKDBqjRgdYiQ6rh2?=
 =?us-ascii?Q?CGBgE/gEkvv3IyIINkmvPPLCAB/uPqTu6ti7l/d7GtNyYwN9ajYzvCgFd742?=
 =?us-ascii?Q?feL+9k1RUq8vyHJt5ZXC5hpXMgEUmWKD64/WfU3Soa6Xebp1RV7UH/N1N6Vu?=
 =?us-ascii?Q?QWZFYetF7vdx9oNJjMHKJiG+dUO0KCkHKr6zPHsxXZWWx2eAYOXrqxmmPVpJ?=
 =?us-ascii?Q?uc0dxxaDhrKdmdatf1jAMfrVx2Lno3AracApLU0nK3QKRpuaF62WxVJsTlyC?=
 =?us-ascii?Q?ZM4H7JPdRkfFPasUI6ZkzTxVJFJuzFBx8baMVI+e5R0kz1EFjJDf5AUNs1EF?=
 =?us-ascii?Q?ZCgCSAUuemkKN0I8h3yiKxFDy4IneHmm5b6DxfqiOG+cKY9FP/JGT5PT317D?=
 =?us-ascii?Q?dHbL0yeH5IjIlgPjew2naTObtFvcYj4mqbjAMVn+gHJ7XfskLs/FPQkgZY3y?=
 =?us-ascii?Q?nN18v/6dDl7tOP3ZDpPxng6Wi8NFSgVdL5MZAfx/02KbKwD7BiZv70n+HLDx?=
 =?us-ascii?Q?y1ENEkydxtG28itB1JBZBI/F+lwVvqJj2RSw20MNAZ0E6GyE+nfXLS57lNkv?=
 =?us-ascii?Q?UU4M460f8LwovHmKrrVnr81xDrODJqv3/KWn/C6B2B6ghhZYZdQguBJmLDD5?=
 =?us-ascii?Q?/tMwsyTDeXK9BWYd+A2YxCzF5Sn7yk6WgSqwec5jS+JV42wxFvyMJ9V+uuKp?=
 =?us-ascii?Q?VJFp1pwkjvx5Ur2bzgoFi0V/CPFb78OaTjB5xBLB2esIimczXcCV2MaOtGPp?=
 =?us-ascii?Q?04C+v1OQg5ByxGqXS0XLlf5lMdvhQMYf509wsdC1hbYUBd6gh+BlLJPIistp?=
 =?us-ascii?Q?Hz+BbNGSS8t0mHc+mToEv2pxhpiX/1DEGU435MCBvcQIK06kuMuk2Iier1rA?=
 =?us-ascii?Q?y7w5S9ijbfuqJDyHkMaUOCV5M5DTZpKiHoVAeeejsmLOypXWOosHhM5WV+iV?=
 =?us-ascii?Q?eW7txEV3M9iPnU4kxedHap1Rc+bJ16BsvjXC2Cd3KJtXMz6N5LVvd1b8GLnH?=
 =?us-ascii?Q?zDKyMZSp1F+4hYyjTM/q7Ez+PygEbyfq8zCN45AqFbEwwUelwV+Ow+blfESa?=
 =?us-ascii?Q?ji+wS1cLSIIHhKZVkrFVyrpYCYwzTjB63iV8+aHIAgLYbQ+aS4m7dX0tECgD?=
 =?us-ascii?Q?jRYkjGcgIdiaIieZqkPjao6lxbFhXdnNX8Zw4BcsT6joGqdN3TG0czM1J8DS?=
 =?us-ascii?Q?cC4UO8KHVngZE+TCcVqnypY7vtJDI0lyglZH1oCHa09yjYaM5YhGnEIRrIcl?=
 =?us-ascii?Q?dJwtCXQAScf0PUa6Iy+D0y9nuFXMoxYS2SCKCiH0LmGR3vA4Ye7I9hRFlSsj?=
 =?us-ascii?Q?MrsZnMjTp408SMnmTcGJA5c=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c37e72-e5e9-4adf-fbe3-08d997124e26
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:32.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBiJfnnIKY6rLLjN+zZYaYTh1iwVppb+wJTX4RJK8Zs3fDCAxtQsOrwy9bEH3HIa/srA2syii1ysznG8YTaRhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
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
v4->v5: revert changes made in v4

 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  3 ++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4e5ae687d2e2..e6c18b598d5c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -20,11 +20,13 @@ struct ocelot_mact_entry {
 	enum macaccess_entry_type type;
 };
 
+/* Caller must hold &ocelot->mact_lock */
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
 }
 
+/* Caller must hold &ocelot->mact_lock */
 static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 {
 	u32 val;
@@ -36,6 +38,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
 }
 
+/* Caller must hold &ocelot->mact_lock */
 static void ocelot_mact_select(struct ocelot *ocelot,
 			       const unsigned char mac[ETH_ALEN],
 			       unsigned int vid)
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
 
@@ -1170,6 +1190,7 @@ int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 }
 EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
 
+/* Caller must hold &ocelot->mact_lock */
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
 {
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

