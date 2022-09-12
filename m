Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466855B610E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiILSfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiILSdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:50 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937C4D24F
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxeyLowDSC4i/E6lykoAosmsNjHQwdGDlolK6DQrYFIQBpIM3wpHS5CCzCoSrhjNuFHmdxyfMW+qYuFU6PGlinLxnfU5rZHf1jFRF9V2gbM9+817ouPCdEzRjoeBFMR2qFE39HGvaQIOAtAhD4K+FoyfxdBOpX1vjkc/vUxcbaXZxRrPIY82bpIgFccoehKuMYKkbDJ+nQ8Ba7YwhEkgz3Vx/bwMb7IV82gK/5hkuXV6WOgTpnj2HLvr+NDhThddLyVzKx9OFFuKL0Vk6z6rYrA+pvFv1jvYmBsx9rcsDr+nVBBz/d6B38B85KnflYGhcF9d8JjUyRSJK/S2mVscRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Sfe13go0OWROSAkFhsnY+WFfK5jURM5EDUrUntG4hc=;
 b=FdqelIDG0CO6l5xDEVWoqwBdwisCKh6oINz84VMH60Vj9WIxETh8MjMuvRlAKk6x//1P0c/tyIYr8Gq7y7jxL5zxahfK2DIaoWt6uvga6Z2zb4ZB4XyLZyAH+gOjiDXdvVuP86CS64UrmOC3XgjUqQb//Gi9BmPUDlcYSYQUcaSVHLgAMMHrcH5eyCkKDADgI5F1gAS2Ak/E/5KS8gbi+3TzqhYANi+q6x5kN86+Nw5oqXxH4ovzo9NcRtYb44DAjcd7oTtNhjPlRk4s4UgLZ1R5emvN26PdyueZNKefimrJn2bZJ1KgyvZwu2nuTOPsFR1Y8Tw91b5HZ9UiWx5YxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Sfe13go0OWROSAkFhsnY+WFfK5jURM5EDUrUntG4hc=;
 b=Zj/NfUmI4yBL8Yc/pv92SZI2xmh7/sH3fhf8J2kJofwSLB81vkTEF23/dnrcHYGr8tOJpL6LhnPchBWiMv9LlqYzFLqeAC3oWzWB5zuJJHtR7keJSkFpPxMEm0RoKfDdzVdt8ReRjioOTTWnkbUZmMhD/BqxrP8WcW4Jjh/ClAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:29:01 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 06/12] net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN pools
Date:   Mon, 12 Sep 2022 21:28:23 +0300
Message-Id: <20220912182829.160715-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 64c43ecd-93b5-45ea-f53c-08da94ecaa28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNQ2k3l+WkikiuGKKbk18iMYF9YyR8xByy+WyKF8mu9jJioLWekHBeujP30Tkls1Mr77VKdZKPcvARC/wnWsYY2cveqOTFnC2sULmp+r35UOnOLM+cmxPUrDiXgoCEnpTZptNXjv2fFDCu6DXwtOZqnou5xmy1FH5UVQd/JoTIv4qXpmbbwIWxNGktSKsVRsa3QLnFrr8T+EqE4yDUkrUF77hWTPA9BZqrS0fvPJcHl8B9pmrbt0ayR9Oc5KzvoVafScQeHDI7YIaWAltHNNTEVH/lG+wzh+8k2EEP/Whl0Q7lT0rjC4VMVCzfQFTBxSEAR7tb/cGP/a2sr74oS2FnHjRTTP6s81ui33KHyGRF0FSTlDKFxUE73887NvSiUu17F+3NdKxFzHiXkDZNPSn2HEI4mtpoW36PnxA72qoiNQrHkuCuvI9BgdluEXBzdNZREePnufHoazC/nIit9oIYxUMuM/MXEYHTTrmXIL/PYY2L4AbZVlhmF0W4+SB8q2H3hO1ff21N9HxWjkvFpCQ/ERHqSfBVCPmk+0CBR6bc6UvV1wTKjH+Fiw0R637WH1fAqUfELTwwHlw6leGTw5+mPD6SmC5y1QK0nJPLKiMyVMnYJA1bsBm5E2/SmZCTCYXygbrnJWSiX4ej7N5PhIFWLiFnxqwzLQK1IeV6amoRBei3N2UaMRQYXhx+Tor2oTOxvT2ofB3XVWTSJYdWXQ2bKdkeU1nYDzbXZ+Hd+hoiJ9YtsbgxOUyR7tzAMwPP8no+6+eh4fL0wvsoYGpxtSeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(15650500001)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ERwfsXVsrA5An/FvZdFZBIFwerO70jn+ax10Wod4VnkIOFb4cx0Q6ErfiULs?=
 =?us-ascii?Q?Pdog8RrZyrvZj4baDBnvn8yhTa7CqSuu/AKUbNKhVgHZLkJeZR3EnLIwWo9A?=
 =?us-ascii?Q?yUdpYz0Rs85rPZL9pNwOUYZqKSOv30FCcz3qxi3BSaxgbYWpDuhZw1/u45A3?=
 =?us-ascii?Q?b6BA8910TTy4qdTthv0BGCf5r5EVGU94p1+lwn2zh2DJVqNn52z9nfIwqBeJ?=
 =?us-ascii?Q?tu6ai7xWyR7c9u7XtBPB4hbrh8dfIG1UozsSyo4bFKQEEVEaq1eKjKVVaPFd?=
 =?us-ascii?Q?c1xrVv4YyMkIjQftJcgzgMkgn6zUf30HPge8mB8ggh9+vEJLqK/LHoGmDNVP?=
 =?us-ascii?Q?XiSSp32mN6fnTtfkCmcUsmiHY7OoVdIwK+OXBCQ/DuNus9iP7o69t128X8c0?=
 =?us-ascii?Q?W28SNrkg5rqhen4pM0L0/8nH3YdGx5P8nD55Z/XEF6slyRWj1dvHpwyHYg6N?=
 =?us-ascii?Q?JCgPnZFilxQL4+XC8d32vJRiOSN1TeNYkBaYUWDGqmktlFpEbIZNKOrsZWm4?=
 =?us-ascii?Q?J8jz3AMAbns6pPU3dEHGOv1Us7BHomZj6I0yz0aL2y5sxe17cEtT5bmm1LRE?=
 =?us-ascii?Q?tN+DvasGkDlU/KGjKwxhQvkCwQJ51qRqhlqoN98K166aYYrps3qis0HxtR1D?=
 =?us-ascii?Q?BmJBISdin6FCV8nXOXg+CkGUWcGkIFx/aK24rmYwzsl+uSl5diLlFCBCkc2B?=
 =?us-ascii?Q?DJ89I51vFt4BWWJ9MnuX2BNqbiCyTKTXi0sJXliPK6xBuAs3Nstekd76fTZR?=
 =?us-ascii?Q?GvT31xNNCK4I92j+eh0Dk4+tUmh+e6xttrx3yMwXLloYslJfUmCK/+Jxe+H8?=
 =?us-ascii?Q?9LuZOXjlpAR6gxCawHmcGKNC/DWwucQQLYqPN7SWaYfq9IjpTGksZ6IDTB03?=
 =?us-ascii?Q?iF6aQZFLi5ct0RFTVAmkA1Yv1dO9DEwuP74TnkUV4hLiqkFpN3+RTlQtLAJ4?=
 =?us-ascii?Q?AjUV6x0sFmfJiASFwv3PIBUH70EyehK9ZY57Abhi/Nm6fLlZis6LARNtRYFj?=
 =?us-ascii?Q?pn2PzKlVgXmSymz7M8HSBpZkqE3H5w4dfAQa/japygpshD3/fmIiuUqipYcB?=
 =?us-ascii?Q?j+tmpbvEK+Ns7notdchQhwYC379O/fQy7JOmyWGSV/eH07rYiran8OhrICv3?=
 =?us-ascii?Q?LpBBOIx3DQasnxM5a0bjBWCOg/FqZiNi3Ms+fk1LK3oO3S2c5qOyQm96cbjy?=
 =?us-ascii?Q?l3kUhsrkoGzmNWH81HjGGuyKhqQrbkb8qqGL5Qw1BdDuqpqKU61NNj9zBFQW?=
 =?us-ascii?Q?9SnHvJ8P7/UBvtGzR4HxucFfXHP5HD7q49DSqB+zopw+GVjzl0fHgYMF/Ha9?=
 =?us-ascii?Q?c7eqOpCtuM7hXZ5zFGOCTcl5iF8wQbvdbAXMNOZn7lBpxtoV5B0FxsJ3y3Me?=
 =?us-ascii?Q?oKCF97P/QWPczw4X7mfMAcI6TiCXR7VamYYjMWis1EfcX0Bh4Ru8nTCm+cZH?=
 =?us-ascii?Q?K6z8cSQ2NrGakQLv5dcRu3omEPTbqJvdW1/6ppPbUl4Jre3lnKnspwW8yRz9?=
 =?us-ascii?Q?exI//DP935lv+A1nt9GvXFOPAY8Ba2WAeVF5MD1n0eTKDjR8HN6VkkdtjCVM?=
 =?us-ascii?Q?iHOX95NHpMMc0U5rlLWmSIVPkZaUCIFccILho4Gj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c43ecd-93b5-45ea-f53c-08da94ecaa28
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:01.5769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bI1w34bUf9hB66LnKjVCYYdLvo484plxiaMOMVzqGrAqv0Sonk8pzGtGTPfsMVqu5Qov6uYowneotu/C+Ot9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

Update the dpni_set_pool() firmware API so that in the next patches we
can configure per Rx queue (per QDBIN) buffer pools.
This is a hard requirement of the AF_XDP, thus we need the newer API
version.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   | 19 +++++++++++++------
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  9 +++++++++
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 828f538097af..759385c882b1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -13,10 +13,12 @@
 #define DPNI_VER_MINOR				0
 #define DPNI_CMD_BASE_VERSION			1
 #define DPNI_CMD_2ND_VERSION			2
+#define DPNI_CMD_3RD_VERSION			3
 #define DPNI_CMD_ID_OFFSET			4
 
 #define DPNI_CMD(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_BASE_VERSION)
 #define DPNI_CMD_V2(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_2ND_VERSION)
+#define DPNI_CMD_V3(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_3RD_VERSION)
 
 #define DPNI_CMDID_OPEN					DPNI_CMD(0x801)
 #define DPNI_CMDID_CLOSE				DPNI_CMD(0x800)
@@ -39,7 +41,7 @@
 #define DPNI_CMDID_GET_IRQ_STATUS			DPNI_CMD(0x016)
 #define DPNI_CMDID_CLEAR_IRQ_STATUS			DPNI_CMD(0x017)
 
-#define DPNI_CMDID_SET_POOLS				DPNI_CMD(0x200)
+#define DPNI_CMDID_SET_POOLS				DPNI_CMD_V3(0x200)
 #define DPNI_CMDID_SET_ERRORS_BEHAVIOR			DPNI_CMD(0x20B)
 
 #define DPNI_CMDID_GET_QDID				DPNI_CMD(0x210)
@@ -115,14 +117,19 @@ struct dpni_cmd_open {
 };
 
 #define DPNI_BACKUP_POOL(val, order)	(((val) & 0x1) << (order))
+
+struct dpni_cmd_pool {
+	u16 dpbp_id;
+	u8 priority_mask;
+	u8 pad;
+};
+
 struct dpni_cmd_set_pools {
-	/* cmd word 0 */
 	u8 num_dpbp;
 	u8 backup_pool_mask;
-	__le16 pad;
-	/* cmd word 0..4 */
-	__le32 dpbp_id[DPNI_MAX_DPBP];
-	/* cmd word 4..6 */
+	u8 pad;
+	u8 pool_options;
+	struct dpni_cmd_pool pool[DPNI_MAX_DPBP];
 	__le16 buffer_size[DPNI_MAX_DPBP];
 };
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 6c3b36f20fb8..02601a283b59 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -173,8 +173,12 @@ int dpni_set_pools(struct fsl_mc_io *mc_io,
 					  token);
 	cmd_params = (struct dpni_cmd_set_pools *)cmd.params;
 	cmd_params->num_dpbp = cfg->num_dpbp;
+	cmd_params->pool_options = cfg->pool_options;
 	for (i = 0; i < DPNI_MAX_DPBP; i++) {
-		cmd_params->dpbp_id[i] = cpu_to_le32(cfg->pools[i].dpbp_id);
+		cmd_params->pool[i].dpbp_id =
+			cpu_to_le16(cfg->pools[i].dpbp_id);
+		cmd_params->pool[i].priority_mask =
+			cfg->pools[i].priority_mask;
 		cmd_params->buffer_size[i] =
 			cpu_to_le16(cfg->pools[i].buffer_size);
 		cmd_params->backup_pool_mask |=
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 6fffd519aa00..5c0a1d5ac934 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -92,19 +92,28 @@ int dpni_close(struct fsl_mc_io	*mc_io,
 	       u32		cmd_flags,
 	       u16		token);
 
+#define DPNI_POOL_ASSOC_QPRI	0
+#define DPNI_POOL_ASSOC_QDBIN	1
+
 /**
  * struct dpni_pools_cfg - Structure representing buffer pools configuration
  * @num_dpbp: Number of DPBPs
+ * @pool_options: Buffer assignment options.
+ *	This field is a combination of DPNI_POOL_ASSOC_flags
  * @pools: Array of buffer pools parameters; The number of valid entries
  *	must match 'num_dpbp' value
  * @pools.dpbp_id: DPBP object ID
+ * @pools.priority: Priority mask that indicates TC's used with this buffer.
+ *	If set to 0x00 MC will assume value 0xff.
  * @pools.buffer_size: Buffer size
  * @pools.backup_pool: Backup pool
  */
 struct dpni_pools_cfg {
 	u8		num_dpbp;
+	u8		pool_options;
 	struct {
 		int	dpbp_id;
+		u8	priority_mask;
 		u16	buffer_size;
 		int	backup_pool;
 	} pools[DPNI_MAX_DPBP];
-- 
2.33.1

