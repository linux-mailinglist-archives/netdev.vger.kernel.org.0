Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8399F5B23E5
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiIHQtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiIHQtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C77013B13C;
        Thu,  8 Sep 2022 09:49:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AypFLXTB4UMWrOvWD5nTuONTN2n3mu9kWQyuwFCmb1ObW74LDnOFZ9FK/MXHRPBVFhTE8IA/zOiLisMTbsLkxvklopWbvxnCQbDZJtizeWwqA62eLi0jgVdif0mkd7GjG+ugDsz+SsMPzoUhnCmel3MqAijispREU6BOx3dEcjM7c4Pn0znUgBB+6gGCJiFFmxbri8vnK+0PmeyU0UFJk7ADaqTYV+sTRKzGrjqah+wzVvi8lmAW7CVkf9imGwztjfE7Uaql7gR1NaW4bnNSp7AkEF/736Z+D3QgqadvUFgjjXJU1CZGoSUpmgOQz8sDnXTMDAIL7b802Yma22+1LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2iRSxjYVHk4OCwZ/reTTbpapcos1TCJ7hYFRS8ERBk=;
 b=IoAeHgWToMf0p62fxfS++sAJ6A+ruJWdsmul/3bmJ6fjsM8ejF8cZBiq0ve7OKPy8itCAp2rIrh4brRmYOBGtUGUAt8EEEixGko0bxHgup89g0UmwqDqECRux293f9RaSa1mP4ojI5wvyCXlASDjNIEX7iJakHBK205OeUyK+IdJqhlJvWePb+2dfYBeRDTMkg4mXlW1MDGkM4cXOx03MW0DgLT+kpfGW+RcJMFpeNyx2v2YjnkYZHMM1bJ5XF7xu29wNMA8TdPluqaQkStuvDf939+onVEaxgiNsxXq/7rMzEjKq5NPXqGDxVwqkefJMq/Rbjc1eUxaER4fA2omrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2iRSxjYVHk4OCwZ/reTTbpapcos1TCJ7hYFRS8ERBk=;
 b=Pdn4qHTzTLH4+voFdhkKcQBMH4xQTrEd6jteamt5wMvdg+A54jwqz7j/ONJFskUN5Wdg0O0H3d5sRT7x2oTnzoJ1adQWQKDXQ5AzYycfLVaV71p4r5x4SoBQOsLx4ppZCFCZOGCt4zCUv8sINFl1+AC6rFR7J1z5Fb5HF9rAdsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/14] net: mscc: ocelot: move more PTP code from the lib to ocelot_ptp.c
Date:   Thu,  8 Sep 2022 19:48:10 +0300
Message-Id: <20220908164816.3576795-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73745b91-c278-4dea-a859-08da91b9f9bb
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akDK7vc4c9DnwzUrLev91UL0J1mp5QOk1n4O4fFrIxrygwM4l5XY6F5Ui2PmJFA87W3VNE6Piabbp5pb0zoyW5dDhqyLN7IHI/yHgAU0eZe5bGbH2BkyY6JY6VpAwnhLT/20at72iue7KypgxDllE8xnK9qhuLbJzVWVOvOxYMfhXs+wUpmrF9QcvvTY70LbvbfvvLMi9RKfsC4H2v5wmF48yuSvnh2B7kV/3WmJfwNzbkb5V+gnpR3HuAbjvv+FrZLT1u7Q6/8k52bJ+aiObIgA+558ss81jfU1VYzoIT6YsRT9lrtKsPtk9X3I9kdf3w2Tjx1qkPn/Qixds2t7OoOQbVKwg2VKFPzbdd/XNP5tCrrPrvbeEb4oUgBWHIDR5yy+rw+SZqtgS16ocaWJsAPDY8fjZSflursgXIjZusB3bO4sLmYAjgEqILN8Ptntvipn82BQA2JJwxKlV42ycFb9klhLyTZsYnJH2SB/0QIkpf9U0Br681w6V3qUXsRVOsxNf6tVzEGLLi+r3Kr9lmy4n8E3b7kVEfT8Pxou86O7eldou+Ca+F5bSy+4W7wrWnBaoDEcH9/xJDShEGgLYtNcFCdpfyJVmLYj0dnd1fVD2iTR9/dcp46AlJ45aWzLwXj8nQwpZ1ByidZDzrWuuca0+CzB+51UUIhPkoVGjhVU+oqppIJG5Wr6mf8ouOWqq3RoeiNJQOSkHxJ51HGl5P/3sZWbWq16DGsS6eVIqpuOaAnnznU+dCXgpVjx99SJAPOFg/u16Hd+XuFgfPyoTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(30864003)(7416002)(52116002)(41300700001)(6666004)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ucyH9Z7ZJIBxoYxrkrjCQ0+61PBc0UMc7MRaJO+32rAQr2qOIX3DKIeBip7j?=
 =?us-ascii?Q?dfS5avWbPdSs4z0DCeRwZBfgUZciStJ+v4fdUSCQ/PlPhMHYQmvFlLUEJ/Ui?=
 =?us-ascii?Q?rV15YhmbbHm9blc9/E/AGfuQVKWPdD/w5kVU432Pdu8iiqByzTb87l/TN/nF?=
 =?us-ascii?Q?a4i7CUX9rhDk86DXts7ptnoNIkv2A8UNT4KbHBovk3+4bXS6fBdIcCdqeOvi?=
 =?us-ascii?Q?xKaSad6KTj3oKPaVSSsq7pA0RCikQpgtdTrWGjQXLK/ZO252BK19Hn4UnjLw?=
 =?us-ascii?Q?H52l51LE4zAocfvV/yusjCdSwGmROCjWv2xEUVAWsACh+4iWKeG/0PlNobEa?=
 =?us-ascii?Q?MzGk889XDd0ChHc33m1DwxWefUqy97kJ538Jrs3CzNqD6/NR2+YW8yVWIF2S?=
 =?us-ascii?Q?HlBwGS4yPt967juIzIZMcAc2P0QdS+d2svtZbyIxcy7r3dDlsv/70lndhcRB?=
 =?us-ascii?Q?W/L+UdNoiwGgMNM19aLPCHsMeFz2Ma5ovQ6iOvEi1oXYRPtZFufc9wt3vnu8?=
 =?us-ascii?Q?Dx4noZwGrAp3mLs++r6qLGzBaa/XyIlk657R563CMQnanbbx2x/MN2DO7vj0?=
 =?us-ascii?Q?gqLtJfTUDnj1wm581YuHqQIYzmPKUm4LWCKnsDD6Ij294df4xTyXCpMids+q?=
 =?us-ascii?Q?v2EFBu+SytM5mROaKtoLX5QsyX5TfeYrABv4FO2ZB6LG/VgnH2NGw5sSix0X?=
 =?us-ascii?Q?Ur26/TIeuccHylw1XriJJv0Oi26v6pBzfd5z0QC3uB1vQCpY1wy6PXUATEcU?=
 =?us-ascii?Q?aH6xSrnpD3fvbCjMk9BDuWFDH5RkwJ4WTZe5fdD8ES0Q+CBE+thI0GQjkHLj?=
 =?us-ascii?Q?zmpunB4wwwDE8tE58VrK8xoANCtOzgJSaWgT+MMRg+Qgk7EBnTQwSx+Rym6S?=
 =?us-ascii?Q?61L0zLJoyzP/ydgJb3dxY/8sK/KunfskJL480hcXxK+J5YDm/T6lDijOpoEf?=
 =?us-ascii?Q?4yKTt5QBpd8Owo3QfFtk/6gBkb8OtL7JHibIrha2+Lb4x8U3Od01S0f0WHJi?=
 =?us-ascii?Q?QATky3mWVYAVP7+719OQ9t3RfwE15YeoglafPd1kzzbZKXN5eaeeDteYPKy3?=
 =?us-ascii?Q?2e3iPN3zo8EZ5f3LzhrJ0Z3JRyvhqnJo3msNckX5pnqcxqwJ2eCTcFFyWCrv?=
 =?us-ascii?Q?uqrZY3At7JFmSXKIwehFOq+MjycXri/Qv0U/FOqJASRmcdRLv2qPbu6bGoSB?=
 =?us-ascii?Q?ngC2F5zr3GfNZWmSRv1Spz9gZJZCUX3c3BDjDwZ2CkzBIeGS1TSGVsB1nXRn?=
 =?us-ascii?Q?Wi+O98mhsG6o4yKBPCWn11D33EFjYX6RsF5G9YMkjsN/OT2rnt/tvZlhL6nl?=
 =?us-ascii?Q?6QTJxebV306qBiqDsdaog/KNbYrOAyjvBvG8hMdmxncF9KFDeQj5T3zbMRCd?=
 =?us-ascii?Q?05+SKUARVyA2aG2CrVq+nGZVdNFBhNVAIT6wkehjlz7JEvc7m3uEAv2TvjFv?=
 =?us-ascii?Q?6mqOzOkSZJiE4T15FaHlXU/zhnqGOzRrLQwwdRblHNMewNOt5e6lUICYXSzZ?=
 =?us-ascii?Q?xmYj+Pzuw0d/rIstQUrdYmnHva5eGjR79hckT4Q9ycUok3yOfRlFmslIX+XI?=
 =?us-ascii?Q?cvgQNSTL3Nh7BsDIThWMb+KGhGPd2uvCV5Yv1lVpnYr7Pawezj3RgkwT2HcV?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73745b91-c278-4dea-a859-08da91b9f9bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:37.3023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2sJnjbgH+cosrAz00FiCEsdQBG4cFUFU8yTrqEYuZc3mVdBKNNvnMMe1R5MUbTkWIACnRcf3+rzHMTiBChpUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decongest ocelot.c a bit more by moving all PTP related logic (including
timestamp processing and PTP packet traps) to ocelot_ptp.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 478 ------------------------
 drivers/net/ethernet/mscc/ocelot_ptp.c | 481 +++++++++++++++++++++++++
 2 files changed, 481 insertions(+), 478 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d1bbc48cc246..874fb2a5874e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,7 +6,6 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
-#include <linux/ptp_classify.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
@@ -910,211 +909,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
-static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
-					struct sk_buff *clone)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	unsigned long flags;
-
-	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
-
-	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
-	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
-		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
-		return -EBUSY;
-	}
-
-	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
-	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
-	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
-
-	ocelot_port->ts_id++;
-	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
-		ocelot_port->ts_id = 0;
-
-	ocelot_port->ptp_skbs_in_flight++;
-	ocelot->ptp_skbs_in_flight++;
-
-	skb_queue_tail(&ocelot_port->tx_skbs, clone);
-
-	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
-
-	return 0;
-}
-
-static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
-				       unsigned int ptp_class)
-{
-	struct ptp_header *hdr;
-	u8 msgtype, twostep;
-
-	hdr = ptp_parse_header(skb, ptp_class);
-	if (!hdr)
-		return false;
-
-	msgtype = ptp_get_msgtype(hdr, ptp_class);
-	twostep = hdr->flag_field[0] & 0x2;
-
-	if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0)
-		return true;
-
-	return false;
-}
-
-int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
-				 struct sk_buff *skb,
-				 struct sk_buff **clone)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u8 ptp_cmd = ocelot_port->ptp_cmd;
-	unsigned int ptp_class;
-	int err;
-
-	/* Don't do anything if PTP timestamping not enabled */
-	if (!ptp_cmd)
-		return 0;
-
-	ptp_class = ptp_classify_raw(skb);
-	if (ptp_class == PTP_CLASS_NONE)
-		return -EINVAL;
-
-	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
-	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
-			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
-			return 0;
-		}
-
-		/* Fall back to two-step timestamping */
-		ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
-	}
-
-	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
-		*clone = skb_clone_sk(skb);
-		if (!(*clone))
-			return -ENOMEM;
-
-		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
-		if (err)
-			return err;
-
-		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
-		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(ocelot_port_txtstamp_request);
-
-static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
-				   struct timespec64 *ts)
-{
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
-
-	/* Read current PTP time to get seconds */
-	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
-
-	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
-	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
-	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
-	ts->tv_sec = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
-
-	/* Read packet HW timestamp from FIFO */
-	val = ocelot_read(ocelot, SYS_PTP_TXSTAMP);
-	ts->tv_nsec = SYS_PTP_TXSTAMP_PTP_TXSTAMP(val);
-
-	/* Sec has incremented since the ts was registered */
-	if ((ts->tv_sec & 0x1) != !!(val & SYS_PTP_TXSTAMP_PTP_TXSTAMP_SEC))
-		ts->tv_sec--;
-
-	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
-}
-
-static bool ocelot_validate_ptp_skb(struct sk_buff *clone, u16 seqid)
-{
-	struct ptp_header *hdr;
-
-	hdr = ptp_parse_header(clone, OCELOT_SKB_CB(clone)->ptp_class);
-	if (WARN_ON(!hdr))
-		return false;
-
-	return seqid == ntohs(hdr->sequence_id);
-}
-
-void ocelot_get_txtstamp(struct ocelot *ocelot)
-{
-	int budget = OCELOT_PTP_QUEUE_SZ;
-
-	while (budget--) {
-		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
-		struct skb_shared_hwtstamps shhwtstamps;
-		u32 val, id, seqid, txport;
-		struct ocelot_port *port;
-		struct timespec64 ts;
-		unsigned long flags;
-
-		val = ocelot_read(ocelot, SYS_PTP_STATUS);
-
-		/* Check if a timestamp can be retrieved */
-		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
-			break;
-
-		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
-
-		/* Retrieve the ts ID and Tx port */
-		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
-		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
-		seqid = SYS_PTP_STATUS_PTP_MESS_SEQ_ID(val);
-
-		port = ocelot->ports[txport];
-
-		spin_lock(&ocelot->ts_id_lock);
-		port->ptp_skbs_in_flight--;
-		ocelot->ptp_skbs_in_flight--;
-		spin_unlock(&ocelot->ts_id_lock);
-
-		/* Retrieve its associated skb */
-try_again:
-		spin_lock_irqsave(&port->tx_skbs.lock, flags);
-
-		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
-			if (OCELOT_SKB_CB(skb)->ts_id != id)
-				continue;
-			__skb_unlink(skb, &port->tx_skbs);
-			skb_match = skb;
-			break;
-		}
-
-		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
-
-		if (WARN_ON(!skb_match))
-			continue;
-
-		if (!ocelot_validate_ptp_skb(skb_match, seqid)) {
-			dev_err_ratelimited(ocelot->dev,
-					    "port %d received stale TX timestamp for seqid %d, discarding\n",
-					    txport, seqid);
-			dev_kfree_skb_any(skb);
-			goto try_again;
-		}
-
-		/* Get the h/w timestamp */
-		ocelot_get_hwtimestamp(ocelot, &ts);
-
-		/* Set the timestamp into the skb */
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
-
-		/* Next ts */
-		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
-	}
-}
-EXPORT_SYMBOL(ocelot_get_txtstamp);
-
 static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
 				u32 *rval)
 {
@@ -1497,53 +1291,6 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
-static void ocelot_populate_l2_ptp_trap_key(struct ocelot_vcap_filter *trap)
-{
-	trap->key_type = OCELOT_VCAP_KEY_ETYPE;
-	*(__be16 *)trap->key.etype.etype.value = htons(ETH_P_1588);
-	*(__be16 *)trap->key.etype.etype.mask = htons(0xffff);
-}
-
-static void
-ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
-{
-	trap->key_type = OCELOT_VCAP_KEY_IPV4;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
-	trap->key.ipv4.dport.value = PTP_EV_PORT;
-	trap->key.ipv4.dport.mask = 0xffff;
-}
-
-static void
-ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
-{
-	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
-	trap->key.ipv6.dport.value = PTP_EV_PORT;
-	trap->key.ipv6.dport.mask = 0xffff;
-}
-
-static void
-ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
-{
-	trap->key_type = OCELOT_VCAP_KEY_IPV4;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
-	trap->key.ipv4.dport.value = PTP_GEN_PORT;
-	trap->key.ipv4.dport.mask = 0xffff;
-}
-
-static void
-ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
-{
-	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
-	trap->key.ipv6.dport.value = PTP_GEN_PORT;
-	trap->key.ipv6.dport.mask = 0xffff;
-}
-
 int ocelot_trap_add(struct ocelot *ocelot, int port,
 		    unsigned long cookie, bool take_ts,
 		    void (*populate)(struct ocelot_vcap_filter *f))
@@ -1612,231 +1359,6 @@ int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie)
 	return ocelot_vcap_filter_replace(ocelot, trap);
 }
 
-static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
-{
-	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
-
-	return ocelot_trap_add(ocelot, port, l2_cookie, true,
-			       ocelot_populate_l2_ptp_trap_key);
-}
-
-static int ocelot_l2_ptp_trap_del(struct ocelot *ocelot, int port)
-{
-	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
-
-	return ocelot_trap_del(ocelot, port, l2_cookie);
-}
-
-static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
-{
-	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
-	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
-	int err;
-
-	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie, true,
-			      ocelot_populate_ipv4_ptp_event_trap_key);
-	if (err)
-		return err;
-
-	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie, false,
-			      ocelot_populate_ipv4_ptp_general_trap_key);
-	if (err)
-		ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
-
-	return err;
-}
-
-static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
-{
-	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
-	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
-	int err;
-
-	err = ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
-	err |= ocelot_trap_del(ocelot, port, ipv4_gen_cookie);
-	return err;
-}
-
-static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
-{
-	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
-	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
-	int err;
-
-	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie, true,
-			      ocelot_populate_ipv6_ptp_event_trap_key);
-	if (err)
-		return err;
-
-	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie, false,
-			      ocelot_populate_ipv6_ptp_general_trap_key);
-	if (err)
-		ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
-
-	return err;
-}
-
-static int ocelot_ipv6_ptp_trap_del(struct ocelot *ocelot, int port)
-{
-	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
-	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
-	int err;
-
-	err = ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
-	err |= ocelot_trap_del(ocelot, port, ipv6_gen_cookie);
-	return err;
-}
-
-static int ocelot_setup_ptp_traps(struct ocelot *ocelot, int port,
-				  bool l2, bool l4)
-{
-	int err;
-
-	if (l2)
-		err = ocelot_l2_ptp_trap_add(ocelot, port);
-	else
-		err = ocelot_l2_ptp_trap_del(ocelot, port);
-	if (err)
-		return err;
-
-	if (l4) {
-		err = ocelot_ipv4_ptp_trap_add(ocelot, port);
-		if (err)
-			goto err_ipv4;
-
-		err = ocelot_ipv6_ptp_trap_add(ocelot, port);
-		if (err)
-			goto err_ipv6;
-	} else {
-		err = ocelot_ipv4_ptp_trap_del(ocelot, port);
-
-		err |= ocelot_ipv6_ptp_trap_del(ocelot, port);
-	}
-	if (err)
-		return err;
-
-	return 0;
-
-err_ipv6:
-	ocelot_ipv4_ptp_trap_del(ocelot, port);
-err_ipv4:
-	if (l2)
-		ocelot_l2_ptp_trap_del(ocelot, port);
-	return err;
-}
-
-int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
-{
-	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
-			    sizeof(ocelot->hwtstamp_config)) ? -EFAULT : 0;
-}
-EXPORT_SYMBOL(ocelot_hwstamp_get);
-
-int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	bool l2 = false, l4 = false;
-	struct hwtstamp_config cfg;
-	int err;
-
-	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-		return -EFAULT;
-
-	/* Tx type sanity check */
-	switch (cfg.tx_type) {
-	case HWTSTAMP_TX_ON:
-		ocelot_port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
-		break;
-	case HWTSTAMP_TX_ONESTEP_SYNC:
-		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
-		 * need to update the origin time.
-		 */
-		ocelot_port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
-		break;
-	case HWTSTAMP_TX_OFF:
-		ocelot_port->ptp_cmd = 0;
-		break;
-	default:
-		return -ERANGE;
-	}
-
-	mutex_lock(&ocelot->ptp_lock);
-
-	switch (cfg.rx_filter) {
-	case HWTSTAMP_FILTER_NONE:
-		break;
-	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-		l4 = true;
-		break;
-	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
-		l2 = true;
-		break;
-	case HWTSTAMP_FILTER_PTP_V2_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
-		l2 = true;
-		l4 = true;
-		break;
-	default:
-		mutex_unlock(&ocelot->ptp_lock);
-		return -ERANGE;
-	}
-
-	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
-	if (err) {
-		mutex_unlock(&ocelot->ptp_lock);
-		return err;
-	}
-
-	if (l2 && l4)
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-	else if (l2)
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
-	else if (l4)
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
-	else
-		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
-
-	/* Commit back the result & save it */
-	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
-	mutex_unlock(&ocelot->ptp_lock);
-
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
-}
-EXPORT_SYMBOL(ocelot_hwstamp_set);
-
-int ocelot_get_ts_info(struct ocelot *ocelot, int port,
-		       struct ethtool_ts_info *info)
-{
-	info->phc_index = ocelot->ptp_clock ?
-			  ptp_clock_index(ocelot->ptp_clock) : -1;
-	if (info->phc_index == -1) {
-		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
-					 SOF_TIMESTAMPING_RX_SOFTWARE |
-					 SOF_TIMESTAMPING_SOFTWARE;
-		return 0;
-	}
-	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
-				 SOF_TIMESTAMPING_RX_SOFTWARE |
-				 SOF_TIMESTAMPING_SOFTWARE |
-				 SOF_TIMESTAMPING_TX_HARDWARE |
-				 SOF_TIMESTAMPING_RX_HARDWARE |
-				 SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
-			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
-			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
-			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
-			   BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
-
-	return 0;
-}
-EXPORT_SYMBOL(ocelot_get_ts_info);
-
 static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 {
 	u32 mask = 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 09c703efe946..1a82f10c8853 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -6,9 +6,13 @@
  */
 #include <linux/time64.h>
 
+#include <linux/dsa/ocelot.h>
+#include <linux/ptp_classify.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot.h>
+#include "ocelot.h"
 
 int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
@@ -310,6 +314,483 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
 }
 EXPORT_SYMBOL(ocelot_ptp_enable);
 
+static void ocelot_populate_l2_ptp_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_ETYPE;
+	*(__be16 *)trap->key.etype.etype.value = htons(ETH_P_1588);
+	*(__be16 *)trap->key.etype.etype.mask = htons(0xffff);
+}
+
+static void
+ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv4.dport.value = PTP_EV_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.dport.value = PTP_EV_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv4.dport.value = PTP_GEN_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.dport.value = PTP_GEN_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
+
+	return ocelot_trap_add(ocelot, port, l2_cookie, true,
+			       ocelot_populate_l2_ptp_trap_key);
+}
+
+static int ocelot_l2_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
+
+	return ocelot_trap_del(ocelot, port, l2_cookie);
+}
+
+static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie, true,
+			      ocelot_populate_ipv4_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie, false,
+			      ocelot_populate_ipv4_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv4_gen_cookie);
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie, true,
+			      ocelot_populate_ipv6_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie, false,
+			      ocelot_populate_ipv6_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot);
+	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv6_gen_cookie);
+	return err;
+}
+
+static int ocelot_setup_ptp_traps(struct ocelot *ocelot, int port,
+				  bool l2, bool l4)
+{
+	int err;
+
+	if (l2)
+		err = ocelot_l2_ptp_trap_add(ocelot, port);
+	else
+		err = ocelot_l2_ptp_trap_del(ocelot, port);
+	if (err)
+		return err;
+
+	if (l4) {
+		err = ocelot_ipv4_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv4;
+
+		err = ocelot_ipv6_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv6;
+	} else {
+		err = ocelot_ipv4_ptp_trap_del(ocelot, port);
+
+		err |= ocelot_ipv6_ptp_trap_del(ocelot, port);
+	}
+	if (err)
+		return err;
+
+	return 0;
+
+err_ipv6:
+	ocelot_ipv4_ptp_trap_del(ocelot, port);
+err_ipv4:
+	if (l2)
+		ocelot_l2_ptp_trap_del(ocelot, port);
+	return err;
+}
+
+int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
+{
+	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
+			    sizeof(ocelot->hwtstamp_config)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL(ocelot_hwstamp_get);
+
+int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool l2 = false, l4 = false;
+	struct hwtstamp_config cfg;
+	int err;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	/* Tx type sanity check */
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_ON:
+		ocelot_port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
+		 * need to update the origin time.
+		 */
+		ocelot_port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
+		break;
+	case HWTSTAMP_TX_OFF:
+		ocelot_port->ptp_cmd = 0;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	mutex_lock(&ocelot->ptp_lock);
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		l4 = true;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		l2 = true;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		l2 = true;
+		l4 = true;
+		break;
+	default:
+		mutex_unlock(&ocelot->ptp_lock);
+		return -ERANGE;
+	}
+
+	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
+	if (err) {
+		mutex_unlock(&ocelot->ptp_lock);
+		return err;
+	}
+
+	if (l2 && l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+	else if (l2)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else if (l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+	else
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	/* Commit back the result & save it */
+	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
+	mutex_unlock(&ocelot->ptp_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+EXPORT_SYMBOL(ocelot_hwstamp_set);
+
+int ocelot_get_ts_info(struct ocelot *ocelot, int port,
+		       struct ethtool_ts_info *info)
+{
+	info->phc_index = ocelot->ptp_clock ?
+			  ptp_clock_index(ocelot->ptp_clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+				 SOF_TIMESTAMPING_RX_SOFTWARE |
+				 SOF_TIMESTAMPING_SOFTWARE |
+				 SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
+			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_get_ts_info);
+
+static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
+					struct sk_buff *clone)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	unsigned long flags;
+
+	spin_lock_irqsave(&ocelot->ts_id_lock, flags);
+
+	if (ocelot_port->ptp_skbs_in_flight == OCELOT_MAX_PTP_ID ||
+	    ocelot->ptp_skbs_in_flight == OCELOT_PTP_FIFO_SIZE) {
+		spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+		return -EBUSY;
+	}
+
+	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
+	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
+	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
+
+	ocelot_port->ts_id++;
+	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
+		ocelot_port->ts_id = 0;
+
+	ocelot_port->ptp_skbs_in_flight++;
+	ocelot->ptp_skbs_in_flight++;
+
+	skb_queue_tail(&ocelot_port->tx_skbs, clone);
+
+	spin_unlock_irqrestore(&ocelot->ts_id_lock, flags);
+
+	return 0;
+}
+
+static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
+				       unsigned int ptp_class)
+{
+	struct ptp_header *hdr;
+	u8 msgtype, twostep;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		return false;
+
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	twostep = hdr->flag_field[0] & 0x2;
+
+	if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0)
+		return true;
+
+	return false;
+}
+
+int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
+				 struct sk_buff *skb,
+				 struct sk_buff **clone)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u8 ptp_cmd = ocelot_port->ptp_cmd;
+	unsigned int ptp_class;
+	int err;
+
+	/* Don't do anything if PTP timestamping not enabled */
+	if (!ptp_cmd)
+		return 0;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
+	/* Store ptp_cmd in OCELOT_SKB_CB(skb)->ptp_cmd */
+	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		if (ocelot_ptp_is_onestep_sync(skb, ptp_class)) {
+			OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+			return 0;
+		}
+
+		/* Fall back to two-step timestamping */
+		ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+	}
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		*clone = skb_clone_sk(skb);
+		if (!(*clone))
+			return -ENOMEM;
+
+		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
+		if (err)
+			return err;
+
+		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
+		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_port_txtstamp_request);
+
+static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
+				   struct timespec64 *ts)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
+
+	/* Read current PTP time to get seconds */
+	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
+
+	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
+	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
+	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
+	ts->tv_sec = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB, TOD_ACC_PIN);
+
+	/* Read packet HW timestamp from FIFO */
+	val = ocelot_read(ocelot, SYS_PTP_TXSTAMP);
+	ts->tv_nsec = SYS_PTP_TXSTAMP_PTP_TXSTAMP(val);
+
+	/* Sec has incremented since the ts was registered */
+	if ((ts->tv_sec & 0x1) != !!(val & SYS_PTP_TXSTAMP_PTP_TXSTAMP_SEC))
+		ts->tv_sec--;
+
+	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
+}
+
+static bool ocelot_validate_ptp_skb(struct sk_buff *clone, u16 seqid)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(clone, OCELOT_SKB_CB(clone)->ptp_class);
+	if (WARN_ON(!hdr))
+		return false;
+
+	return seqid == ntohs(hdr->sequence_id);
+}
+
+void ocelot_get_txtstamp(struct ocelot *ocelot)
+{
+	int budget = OCELOT_PTP_QUEUE_SZ;
+
+	while (budget--) {
+		struct sk_buff *skb, *skb_tmp, *skb_match = NULL;
+		struct skb_shared_hwtstamps shhwtstamps;
+		u32 val, id, seqid, txport;
+		struct ocelot_port *port;
+		struct timespec64 ts;
+		unsigned long flags;
+
+		val = ocelot_read(ocelot, SYS_PTP_STATUS);
+
+		/* Check if a timestamp can be retrieved */
+		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
+			break;
+
+		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
+
+		/* Retrieve the ts ID and Tx port */
+		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
+		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
+		seqid = SYS_PTP_STATUS_PTP_MESS_SEQ_ID(val);
+
+		port = ocelot->ports[txport];
+
+		spin_lock(&ocelot->ts_id_lock);
+		port->ptp_skbs_in_flight--;
+		ocelot->ptp_skbs_in_flight--;
+		spin_unlock(&ocelot->ts_id_lock);
+
+		/* Retrieve its associated skb */
+try_again:
+		spin_lock_irqsave(&port->tx_skbs.lock, flags);
+
+		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+			if (OCELOT_SKB_CB(skb)->ts_id != id)
+				continue;
+			__skb_unlink(skb, &port->tx_skbs);
+			skb_match = skb;
+			break;
+		}
+
+		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
+		if (WARN_ON(!skb_match))
+			continue;
+
+		if (!ocelot_validate_ptp_skb(skb_match, seqid)) {
+			dev_err_ratelimited(ocelot->dev,
+					    "port %d received stale TX timestamp for seqid %d, discarding\n",
+					    txport, seqid);
+			dev_kfree_skb_any(skb);
+			goto try_again;
+		}
+
+		/* Get the h/w timestamp */
+		ocelot_get_hwtimestamp(ocelot, &ts);
+
+		/* Set the timestamp into the skb */
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
+		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
+
+		/* Next ts */
+		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
+	}
+}
+EXPORT_SYMBOL(ocelot_get_txtstamp);
+
 int ocelot_init_timestamp(struct ocelot *ocelot,
 			  const struct ptp_clock_info *info)
 {
-- 
2.34.1

