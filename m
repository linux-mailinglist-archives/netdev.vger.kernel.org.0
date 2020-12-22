Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3D2E0B1B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgLVNrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:01 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:47333
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727377AbgLVNq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkZPuukWB64i9PgGTMxL/NFISJa0glsEKO5dsYGEylDWnxztfbtCgBF0uE3Tn7taj2uO3yDovs3bZj0yZAtsORJ7lYJFzDexx0znaunS+7y1sZgQq2YN5JR0u3oiG4QtwNsRMuHIxZ8UP6TJ08Fjq+ubZ/SWX5TmSI2GXU6hAlEN5rwzPyxlciuYJoLMV/gtJHAGHPxHeaesxZD4cGBiia2zAOTbHJ+MlBfm9lK72lC7L3AatneT+W0DAKFpLZAUceOqgwWaENZnz0pWtbnwq2UkFSRFDT0P2pDotPas7xnsBL0z9n5kIANyosRqYAS4ep32VuR4WK3zwaVUFOMuXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3bn4Fw2lAZ+x9BtLWoJ4UugyjLx5WXJNI43zqZcpjg=;
 b=SwA+Ber/EBZWAsPhvHd+PZMwEaF48W/LaKZcqozYo/UhpnM4ecrTm2YQy/gaQX6dxfJMQ+TRiy+nteYzcySHVqayys/J9Weko0B6Xe9m4N+i3ogqxVNMYOTvm3cXfujdM0BMYXvlHASSvXCXi33wSYN50y+ir4IOklGral4dZOxgBsen8eu85FfDBVJ4ioue+J7/AT8Z5atkgQqKtReih0ZBW2GLvx5d/QQ+u9UItXxDJHD/yUQZFapXR3UpCaSr0+wR+3C0Q55gDprIXvunwwLbD5maGbRW0kYpcEXSJ5/cKGwXGVazUjIMBASiD+PZNO1JqzYAfDxMthDdSFo32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3bn4Fw2lAZ+x9BtLWoJ4UugyjLx5WXJNI43zqZcpjg=;
 b=oji9U7NQcOLFd67Soqf/SUsL3Y4g3oTv8tFWj2AXV9s9w+2ZLmZWDTBRwf4mZNfDNxJbDGgP24dShSRK36308vn/ytxluqJJhFGCDxxQUKM1q6ju6WPi92IAtge2FzfAHyFbQl/QixZuQQHsyPhHN2sVOU16oV9B7Hh4VlHyVAs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 11/15] net: mscc: ocelot: export struct ocelot_frame_info
Date:   Tue, 22 Dec 2020 15:44:35 +0200
Message-Id: <20201222134439.2478449-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a88bddb7-534a-4bc6-bc52-08d8a67fc8d6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74089CE8C77A9C60849102EEE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6YLy7FB+vWDe9hbU6xtGtKkunu7hs7rmjm2WJ4eyKB5AdOQCphO0HvefBstGm2uHhoQ5iUCMPAtr+CiwIYXJWxgS9uNqP6935+g5h6InaxqrVEH3qUqEunIPWOKdEhPbAtNwxNFUZ9JgJNvpF3r2y82FMq3qNULgOKr3kWGMe0ynQ5pH6pgdvn0C2No7w4ja3McXbakiCMtNAL7M+JtUGz822Bu3nFjar8fdsfUy+2s7GULQ5mWvDzHezDi7AOt1h/gdhSOFhX8r6z7QBLScz9xeXHt7McVZx5z1k7gGqbASNyx6TQpA1a1KfoONlJLnEkPb/vbCTbiIOddQuBpUHSIInOkwI+DW1RE96WA/vwq7IhLtjtBJkZ+RB8I0uknKctmHPSUmh/W5PrJx/9Lw4i9GtgHtDGNwXqvhEd6Q97Ur0OCezS5ato1ZCrJkDEJXf87JReH2KvQUe6Ur4doMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p2iD17oBb6IKmCyQejCwAHAczNZdzXVx2hHTw8Fe8mjIWjxUgWvBxJIOaiiA?=
 =?us-ascii?Q?N3r0vP0PgOC3/o8p6t3T33MK3gv0OmGLcu7q06h4r2ytPag//0+5KDgIrQvu?=
 =?us-ascii?Q?9+ksfZSxvT3BoDQRKpO+aIyPX6Cmfs4VlUwWWlKaAkahaNCmXYG6uvRHIKJP?=
 =?us-ascii?Q?xDkXbuGOrs03uif6lya2VJZq5awxlDFsUCLs+gmVm7tEMJTreZnX0jNVRubk?=
 =?us-ascii?Q?eYc8QpqEF8cbtlshSH5Zvp+/v+4r/vKtfhC448mp22qt1UBJMVXEq4z1vsjH?=
 =?us-ascii?Q?hiaRo0Jv9Crnl+FHb5kTb8DAOxV2jLxd4DDndBi04jQXjUSFZKXIlbrcLqZH?=
 =?us-ascii?Q?0KA4lkQbKMuIhfaQFCG1mNYVYb1amvVRZtEuh0GVsjE1rM3HXM5TgtUV6fWn?=
 =?us-ascii?Q?yaXCUB/QALCZcrFfwORJ4wEECJCqXHnOgbZQ9fSwmEf2LiGrKZTHfm0mW0xC?=
 =?us-ascii?Q?/K/X9Kwj8GLfhucqhVYAeqdXkAyjlgeNZw/Lau1kjV2fHFPdPD9Sbnc4nhSj?=
 =?us-ascii?Q?JMUn5PAsISq9t67Cqjas/e4N02S1d/oel9iKSE674d/3fTng2Gcvv6DgHPWc?=
 =?us-ascii?Q?cnbU1cw1hVih7uCnZJQqbIXKhcOmq1Wg7ErLTyHkMrJLN8ajEA7Q6vOrjHNI?=
 =?us-ascii?Q?J4WfS0uRw7WMdvGRLefcpP+ECKD9j6/L9RNlaYbQ8Pr6o+GredpRWNYwZ7qC?=
 =?us-ascii?Q?2TqqtVFexLSpQ4eGPdGkZ82b1tRRxyADjbmLnkk/YOGMzPdeiMXfTjh9MCd8?=
 =?us-ascii?Q?5T1x0Ba745HnzewT93QWboTFFkw9MJt+MR8QSQIraC/nzfT1Rq3GPy35LEvA?=
 =?us-ascii?Q?VPmmeFqMtQpAm5NtSAIpNWTp1HlxqGFeLwdRQnfmD6t5PCRbLZYO/wD3MrMZ?=
 =?us-ascii?Q?4dPauaqJfweeoiFh8IpyRgXRg0Jm5ZGnTsdWGkSdBK6fZ5KYVfTtCDIc0u1t?=
 =?us-ascii?Q?32GPC3YOJR+CeaeD9R/1Xk0eaYovPG1CTef8UqUFGddv/t6JkJwXwXc9hD5x?=
 =?us-ascii?Q?FBpd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:03.1979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: a88bddb7-534a-4bc6-bc52-08d8a67fc8d6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKtobasSvH8iHj7tG27DtoRDirlBUouCXTPAyR/g+V1jQIuMkkW+criPW5o5y1na554zQmGkB94R4x0PgPK2Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because felix DSA must now be able to extract a frame in 2 stages over
MMIO (first the XFH then the frame data), it needs access to this
internal ocelot structure that holds the unpacked information from the
Extraction Frame Header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c         | 4 ++--
 drivers/net/ethernet/mscc/ocelot.h         | 9 ---------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 4 ++--
 include/soc/mscc/ocelot.h                  | 9 +++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 52f6c986aef0..7d73c3251dfb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -576,7 +576,7 @@ EXPORT_SYMBOL(ocelot_get_txtstamp);
  * bit 16: tag type 0: C-tag, 1: S-tag
  * bit 0-11: VID
  */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+static int ocelot_gen_ifh(u32 *ifh, struct ocelot_frame_info *info)
 {
 	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
 	ifh[1] = (0xf00 & info->port) >> 8;
@@ -601,7 +601,7 @@ bool ocelot_can_inject(struct ocelot *ocelot, int grp)
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	struct frame_info info = {};
+	struct ocelot_frame_info info = {};
 	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e7685a58b7e2..7dac0edd7767 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -32,15 +32,6 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
-struct frame_info {
-	u32 len;
-	u16 port;
-	u16 vid;
-	u8 tag_type;
-	u16 rew_op;
-	u32 timestamp;	/* rew_val */
-};
-
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ea66b372d63b..504881d531e5 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -533,7 +533,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct frame_info *info)
+static int ocelot_parse_ifh(u32 *_ifh, struct ocelot_frame_info *info)
 {
 	u8 llen, wlen;
 	u64 ifh[2];
@@ -607,10 +607,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
+		struct ocelot_frame_info info = {};
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 		u64 tod_in_ns, full_ts_in_ns;
-		struct frame_info info = {};
 		struct net_device *dev;
 		u32 ifh[4], val, *buf;
 		struct timespec64 ts;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4cbb7655ef0c..25a93bcc6afe 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -669,6 +669,15 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+struct ocelot_frame_info {
+	u32 len;
+	u16 port;
+	u16 vid;
+	u8 tag_type;
+	u16 rew_op;
+	u32 timestamp;	/* rew_val */
+};
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-- 
2.25.1

