Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67712437BE8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhJVRcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:33 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231453AbhJVRcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMiXS7a/C3OI9NBr4sTMATfW0WZl91QELGGX5InuH8JmOFAnZeIOyaxaTLk4A66YM4sITZyo5Ru13N9GOX97vziTftuJ3kyo8SaYgjb4FRSR5eQaAsePJiV1TyFKUbebvUe7VJaP8QkvF2SjQYnnVNln9rI2fDsym/eZu5p3KKDORF4zWnoQChtjhoEz5y3Ef+YCyTFAp9R7Qqc990JWtQ2F7HKGmEsL/Wa831VhxCJSPoa4oNmkj/nsa3ua3XDt10bEHQFFLHWtq7AOZ5mu4mE7u9qt/SHiKQgiiEE8YAbGmEzc0fTYe863z9a6Ts3xAJ+DpDexN8PYZMdIEL9oUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITOiY2f0G4/Q5EwGadBA2Pphs/9an4p9N8Qvna5SQdM=;
 b=hXHNToi6lIRGIPF1sS5OLVh/s3KF80AWn7xn+AGWhilhnbeGf6Y1fuVwuzRqoS1wcpDH2bQ6Rg2x/RHAsIPc1l5L1UHY1d65tZxla1PULGZ4i8TrBedtg5gdUdeDu374f1wZBu1IMnCxkGo2fMqym+NtwRwjSw8zNJFhxFbgGKe2+BIaXDaIJHitf6kK/Rv5g8xidoboLXCsM8bQqfcipPbColOogsorpo+P3x670NzUOAulDZ/ps3Kt7+HQan0miBJ9L8J25mkd9953Flsdwwge5knkbDzixdW4U3oGHvgJEwD+Ld/Pd/XjqMmDlqFrCLZb6dt28VhqJChVh4lKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITOiY2f0G4/Q5EwGadBA2Pphs/9an4p9N8Qvna5SQdM=;
 b=lIXfGoVb49UWiMblcxVowG3oCF7FHbyid6Mf4A1Sj8CL7Dl4cbAuTyl06PsO7YRevyHIFAxxSJTFpRM9bRfc7EfjQsSFVlFDJd3yBae4E0Ha2KJ++Yb+37IEsFr+HeAOEQ2hC5EbpbTNv12uyDfCNqkGdkmLGGf/sUHNhZYzqaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v3 net-next 3/9] net: mscc: ocelot: serialize access to the MAC table
Date:   Fri, 22 Oct 2021 20:27:22 +0300
Message-Id: <20211022172728.2379321-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41725be6-2e63-4cc8-15d3-08d995819a4f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB550496AAEAC0246FDB9E5CB1E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QyoVmDxcTyOOOBeWOy2gMpGoxjeNFRY3fS242eXe9+lTEh7jL6VMqFOyLFNQfUCjXVUCR4eWDDMKFADZyAbwIF50wq+BU3xntHnKgu5urY97UaemirrCMVNyDEudVV9AasCq7GfvW/ax88+iA2j/6z4sZ3u2A8tXJtSROLo24x0KJk0Xne7NOD3M2G2k99a4yYrp4JY0AAeSACEvWPJ6zqy6QZu33dwHCgfIhvySBmnwjRXFDU73yED4cs5TvgdCtyuOU98lTU1bOn4ufgssGmxacecxsaJsp5oqgSS1ISAsjeV8lJpY0Xrj9FWxEJdyDmlb6x2D+PGAbeqSx9UqDL1DFLyicJ2O9szRjzT3Fgy+p8bAuTpGxx03VSo/DrHlAU70asRZx0Enu2oVH25f9luYufr7PNBr3FL0kBXAZqHlpnLziBvpjIejDU2g4jCMUY8XfQjRZWyvvu54vTEwXRA/W/EnSkzZU6yPnjPiCQfChdhSwlbgaP9EgP2zlELQLehUKdndGv9ljR72xKz37UJ+BVv5HduqnYQf4/iqVpV+ssfyx8PkSqCh+9m59lBTqIcFXhhgrEtXoMWPlt6caUnElKsTeUa9tpPBLcRVCU6KN/J20PbLOt78rDv/OZzjicgQ1d70AxfCXqi5b/ixQKruGcB8Foau0AtNpB+HuXFh8xXA2tOIuPBBRKjDi6IcFD7dEc2Bqc0qiA484zV/Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1X9YYPFUH5U+uXzIQjSOMBgJ/UwFlfXV40nnP/96C7uNRMnrD7INa2lupcbi?=
 =?us-ascii?Q?j9r2l/d9vjg0k6r1qS5iCH4P0VFEpb+o3obitUHGiFOR8wJbzwVlJhG++WZp?=
 =?us-ascii?Q?fygGfzNhsMPk0Nz+ADIK/0H1mT3w4MbZ/Pbqk1jlz5WS/QQxvUbbl/FBxG5z?=
 =?us-ascii?Q?z2b0c+zJzq/frIneAh1ZhjkFkn+ZCjEfnt/ENjYn1gooebmqSpEXpy2OIgpv?=
 =?us-ascii?Q?BGl06sNpakT7y+wmMjb559FynJtJZDFdm9u+jWHBGsolMJ0C2Xwt9RsaYnfl?=
 =?us-ascii?Q?17vOMdMcR/EeESCVjHVn/wBVG7OrJUgoQ1CndxkvwVlTEsENI8auP5QbWlja?=
 =?us-ascii?Q?XVj8iRw4YIsESGcww5QpeFA/XrrQQS+UjcR/h+S9puUEsrjhmi+SwFO0QNV1?=
 =?us-ascii?Q?fqDTQbeekqZUqz6DIZw5Z3qUIntAd3Wv8ixHnaz6spEFTFVtAJTvgbpy1rAv?=
 =?us-ascii?Q?y9noq2GHsD5fA3KYRYKezt8WS3IL8NYnkgHaF1SH0m07xSQM6Wy9UddufN3H?=
 =?us-ascii?Q?tXc1lPdY1mEdYajKrPCxoGLLbbhOB1o1OtJSIGfP/wOexz2WXsHkXTmRqmz0?=
 =?us-ascii?Q?DNxK8SdKePbkZXqvqPeAXB4EKGn+Hxh7FgMgTkG1B/2yquCMMrJ1YuG+tImD?=
 =?us-ascii?Q?0+SfxyBLLGPPDRdTN3HP3wGsjp0yJTuz9AKZE8Rq1PK7evbE6H0qcknlwAD8?=
 =?us-ascii?Q?rOCXQzJf1BexqRJW4Mk+I2+/KJQCprnv83zDXLFqrQMSwbpFxl1nWIMnNCEW?=
 =?us-ascii?Q?F290IPnRFirdqLXMhnJQgPX/+N14mQRFF1sON6p1GV2HAtP0CsNizb5DtnJu?=
 =?us-ascii?Q?jU+J5yxZ0GR8ctxyeiNcfdZFcpcKSuHv3H6lYaiJkDIzFNvKMxFCvgNjbObb?=
 =?us-ascii?Q?m8hgDTXE5N//Pz2CtOJCq+WIkK49M9dgilLtwuskY3uHjEhLFzTSOwdNEPkS?=
 =?us-ascii?Q?o1MMOGJUKzWmby0V5mf4zvx5OrlIRE8RkjyLKT5sJ3YnSiko0/4wcCM7aEwT?=
 =?us-ascii?Q?3lh+R+I2zixoIr/7x1/hVOBnOEbYnj40yUgdcPq47++x3kZeNyDbdUL1bzyV?=
 =?us-ascii?Q?74Yrh5MjCJZY2b4OvpgWVXMmfHTTFkBf+wcBbR+xHnkz9Z1Dhz1ssUwqplxV?=
 =?us-ascii?Q?/AwF+tPRHT/RufHSj+n8mK7nsfNXaObDjL6IHKIbb+aStHd9Td+J2OmBYcrP?=
 =?us-ascii?Q?pbXdGHDu9NuwQY+TCGx0TzX+mlQzoND1e3g8FoA2VwHfI9Tk62Havy609oAN?=
 =?us-ascii?Q?MLa7qK+Vfn0bmizQbxFjP5IyGCW0/5qgKLs57M9p12lzjZZNtbADnwVryqsb?=
 =?us-ascii?Q?kXSnGM2iU5ALp88ZXDz/DvVWdLZcP2YG57uc1y/J2qwitHu4EXBq3KeoIiui?=
 =?us-ascii?Q?/eukuN9cvLrPBCThnSx9ADK9rs3rKzaqslKPxWHmskVQmAyeIoV/SMLRujSv?=
 =?us-ascii?Q?aa12OsvM+4Q3umrfEzeixkN0Nu2JLPt6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41725be6-2e63-4cc8-15d3-08d995819a4f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:12.3448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
---
 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  3 ++
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4e5ae687d2e2..72925529b27c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -20,11 +20,13 @@ struct ocelot_mact_entry {
 	enum macaccess_entry_type type;
 };
 
+/* Must be called with &ocelot->mact_lock held */
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
 }
 
+/* Must be called with &ocelot->mact_lock held */
 static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 {
 	u32 val;
@@ -36,6 +38,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
 		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
 }
 
+/* Must be called with &ocelot->mact_lock held */
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
 
+/* Must be called with &ocelot->mact_lock held */
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

