Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20773F5D40
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbhHXLmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:24 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:17383
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236775AbhHXLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsPZEFVbvqTdANN8um3Yp5xM4pojF3zrFUfCKwiXN5UncKaLUQyT92MEXTEtm4lFWJWr6RUK2yDfz71Sbw/Db8whIsQBE9sB8OAUSL1WYdqMp+xiJXv1vs2jIkRf6QflvS6r2+Jgxyl9EFPr9xrIEmjtk6/SeMyfNKIxE1uanAirmqq0aRQUDIM2C+iUBemQNY53lNG91M7wDRP5fM1lLyNpbYwtYDMGzsF+8I/k22UHN8PGpPlWoRx8Oq/KBFTIR3lSQoZ4hkZPGEH3yqcNAgTP4vCuxoWQLvdT+YuDD1m7IZYci6thWztELaeym4LuE73DBSD49/ny/RaVCCJvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/DfRfgxiFR2oP4mZD9EDUYD6S5gJ05WI2BI60CtH/U=;
 b=JaisdOUznEaciNmud5y5zyE6jiXK5SCyJh2ucf+ktHyvsgfynRYEXGdDOU6JQzfRxlqp4GVXMA6DFBoEmDakJ9wV2wz36AJHChWyUAopOFTH/Q/fYUIoEpnaGpklO9jKQ6fBxqcvGneAt9DS4P2till87RmDVbNeEFzuxSV60gkQYs7fN/KXQn4z2OH8r3mJM/fEXFsFj96+xUGZMqVx2GvbPGPbXWPUGIlF6gQy+8quzPFnb6Iaw1DAqSXbCBrWxD2T4bi7vqs3VN79tCFur3Dfaz5FMdO5SItlyu/Hjy5BIXaNxyMyk6XPIJHWeRstjlP9Sq8OiUO2Dv1r49cYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/DfRfgxiFR2oP4mZD9EDUYD6S5gJ05WI2BI60CtH/U=;
 b=S/uaawWe4CBZpSTU7sXdkyNKEQm3HnhBAQFlC9WDNQXQKgNyJ8nb16RFpJsTPzO92qStwdIvpt4oiE3T0xuAoz07ykfPKdI3xeE88WRk296zUiSUAWstPIuGxm97SabXxFgOqalbjLguflhwGFTdA2pnVeNt8b6gSVO8Deymxjk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:18 +0000
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
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 3/8] net: mscc: ocelot: serialize access to the MAC table
Date:   Tue, 24 Aug 2021 14:40:44 +0300
Message-Id: <20210824114049.3814660-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75808a37-5b73-46c7-ee4f-08d966f4168c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56964004D7EFD95981D52364E0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOthDhAIatxXZHf9Plcki0nbDLkpQDWdT0ueNZfgLrnAhGyW6Xs1dq+2OKwFejJ/ubKx2gRmunm3Q55lONC5kLlBGIP9KLsrVKWzYqA7RXb9agKhHMt709t9iQqbHtDNTKwk3MvkBOavsUZGpAzNdZu49LP3hm8B8h9eI65NxhkyzaSjj7MicAolejo7g54MlZQreRXlsNlF/3Q7+ls1jgC6gJBYqAVRRSo7F6iaSCofPFGwpjQ/cYtRhjiqK1iXo+uhwm+QnZnA8Sjl0gThs5T75zuE/yiOJopA9TM27iSyXxYO3oikjdV6RzU//aiac3yZeJvIyk3NNExZ7d3kNGjMhR5DGEjYSDl2BfeS3mF3tESVCC6wPAw0OC17mu8zqiQkOfJd7qCaG+69tg2FEKND0XAyqaVsHuPDekJ0FMR6/GN+G+vXhZl11e61ke1guhW+p/sZOUpngHdsiMEvruQ89hB5tQ5ejIvgC1yAu08Vjh1ajIZXL2IHBG7QOjgNtHCBO5yZQvDWlNmMKH0z/HQ10nKAh13jDytUT/Vxp3bqhORqla4TW/0v6C0A9NEF0GfWu8uKAIujm6hyllbZ271Gez7ckIMeerMWKFIz/Rxr+BtRJGKRRHpAan9UcKPtkSt3c7UWL50VMqKqYjwYqpklSGgnHyYFGVLQQ0i0ikt2rSFsixmB8jThlBfqNwlTFaLz1hfLLfTzHQFFkctMUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ef4GXr9CCj6exwSOHXUZJjBnqgEg46w+ZkK/PG7MTfQPT59drsc3SzjILMic?=
 =?us-ascii?Q?FwlNApz88Ho8vmaPeycKnl3FV/6zDrrnXV4lLolGgzca+x3hzwqg729X5EZ1?=
 =?us-ascii?Q?TNMO9B8sxm/rMlOf6OHIra1+3O7NprSx6pMDXMiX2ipIe8ixtKu1qWD44QnW?=
 =?us-ascii?Q?jnwr0qaOLhE1/x2/Wo6llpqvTMLgQo6PINNcoPRUD6jOoI0Fg5JuUbz0gmDf?=
 =?us-ascii?Q?TuIyz2m6kPY3LndzivPdKmMmgrzqGy3M1gS0kGqzgb1PHisH7dVthnTupACK?=
 =?us-ascii?Q?7soIxhEcE62FR38gSoVjAOXW8z+1Jlo1AsvJlZFo3HSm2qOz1OaYJX+oSQLD?=
 =?us-ascii?Q?JCu3QB8ZNYr0ClqifwAFvhLp6sAZq+87ta42Bg8tfqFuZhRzyFAu23u4hAUg?=
 =?us-ascii?Q?bzLX7l9Uer10vzPwJ1ixyqTNZVJpkyazKak8QmL7/xsUAT4RK/UdSIAUJy4n?=
 =?us-ascii?Q?PuBUF3TH7rajxoWpmk7ab93vjN8nZC6DJsgdy2Yu+rOLuXoTLTOymeCIJGqE?=
 =?us-ascii?Q?Y6qszN30/j6MmT8A0Q4gaVCoR8rRpbCQyti1JzsrZOLhyR0HRiTWLtGU/Zz4?=
 =?us-ascii?Q?pGfIq/3foUzQecQHn3R54uExwqBSQTY4SObU4L2K/xdYVERnyrolTrNO2+3b?=
 =?us-ascii?Q?qy1eQ5MFr3RI1xVBSQ5hAIgPH3/W+mlAVcNkwnd7FOZdmHrLI06htRzhVO52?=
 =?us-ascii?Q?zEhjI6lNxQz1mKG1xcJoCy3XWFJcV0wx6Se+0W1pNRQOhGmz6hUt/e4rgSEx?=
 =?us-ascii?Q?l6On9S+epGYTZpkkpoIksQtNwdxUE7gPTxR4Xip9J54Q5xUQsLpiH2iu/bm6?=
 =?us-ascii?Q?1ZhawaIMzDRsTTIA9lX6USXsMDJAdvUrAC37kewaabnJx+G4d5+qR+8jz0Cj?=
 =?us-ascii?Q?YEXzJSnuO+fqFLtxSpJAXsWR+4FMPaZvVVAhdpKcR3foJtGerH2yYtcYfsa+?=
 =?us-ascii?Q?4MVpco4NCUei0kzAHEA41e0SZpFFCVthnxF8kB60rXRjQuGrUderrBFeJcW4?=
 =?us-ascii?Q?gEkIEIH27kGOMtvJxnpyxgFFb+fj72/RjPLE5IYGL52Ii3oMXi17IC+9awhP?=
 =?us-ascii?Q?L692DHLCUIaXmyNjscUrhGm1WjMNH4BFIIbCoWh5t4ehKf8W0F50UkrMu23j?=
 =?us-ascii?Q?5M7uZ23hmus/pY7xTtC6qpMu+xmuO6TkYFhXIs5JP/oSgxX569W6LJr+t8aC?=
 =?us-ascii?Q?ol60lL5KQC60Gu5X8f4sWSBiRxByxSyO1C70OBwR8T1UXuwKjSfDhGL2I1bZ?=
 =?us-ascii?Q?Kwai9jmsoVrU5ni32h8izcdrZ44JC3awoHvc6MgP/zp/3oC0C9Ai4Y2HtYpT?=
 =?us-ascii?Q?issEa2ltEpE+rOFy0M5+BJRE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75808a37-5b73-46c7-ee4f-08d966f4168c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:18.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOe54dQeEsOvsOb86Esh4LBR0+XDs7T/HcEQgRtvD1Sf3DlPo5ea3O1IBGCO/foaXoElUywNY4ZT1iAFIoTCLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
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
index c581b955efb3..9f481cf19931 100644
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
 
@@ -1028,6 +1048,7 @@ int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 }
 EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
 
+/* Must be called with &ocelot->mact_lock held */
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
 {
@@ -1078,33 +1099,40 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
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
 
@@ -2085,6 +2113,7 @@ int ocelot_init(struct ocelot *ocelot)
 
 	mutex_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
+	mutex_init(&ocelot->mact_lock);
 	spin_lock_init(&ocelot->ptp_clock_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(ocelot->dev));
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 06706a9fd5b1..682cd058096c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -674,6 +674,9 @@ struct ocelot {
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
 
+	/* Lock for serializing access to the MAC table */
+	struct mutex			mact_lock;
+
 	struct workqueue_struct		*owq;
 
 	u8				ptp:1;
-- 
2.25.1

