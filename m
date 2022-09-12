Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07755B610D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiILSfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiILSeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008644D4DF
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:31:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0cWuDm6dR5UzyUAXl9GKh9AEGn0lEzoWo31SwrqVvpurpETFeWByQvItyI9ok600FymEk2GYROWfRnGDuKmKFkoa6lzzl6RizoIdcbJzPyizdtrlxSmfhzco3Fc00FRa04Tg7P6elgbHHsXSXb+XsuSd7pt09zXVy0CNZbODpSw7oRlUwnd2uvL/ewuXuNrH9ykPbweOKoIB1dJcmTxUPmxYjRVdr+tO2OOyiwQchdFl6vDHjdHRFS69R7LHdh+RLCRztDvLrYX2FlXkBq9c0aenvvP6pHk5GoAsnnMo2SR+evE5vI0rRXVaZo1OPrbrFkLaHPfCHPDO0pbWE2s3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCOf6C5AIzbhqLA0F9Y8gD3S7PgFtR5pEPWzTLWpubo=;
 b=TzjyvBsJuVoydCwE1HKAozBValETZ+Hpmu8tAdc+De9Wj0L+lWxvRdCtEMaYzw0404XaB8+ao2goYVSitvUTHKAuYLzFty4ZX3Xbn/zW9nuL5/E294pmZLI+A0p1f8xwjnopazPEQ/0mr2o6w97XTou+lQFwnZytnx7GyuIYY6TAcyzoPE+GJysfvyvbd/pSlm5SvQsOgjXeMKX/Ozm2A8pwyeTwX2vinq7tG4SHuciFPq4hgoqNI2Sj3o/zkogGk+5YV6mwNoSUxdZ9NDiTE+api9WT6AE9xSQdKomeEgQ+obQiTX702ienZidtjTQkzQrBv11Oueg/FrrZXQfj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCOf6C5AIzbhqLA0F9Y8gD3S7PgFtR5pEPWzTLWpubo=;
 b=J1hUifXDiJLwwOCJ/md9DSQ78FBjplTQiA536glLJlWJdlRlbDm4EotfxfEpTrFjm2X2z/sguStkWospCDx5s1neiHT98QaIDl+Gqs+WyUC+Zn2DBXgU8zKxqwTEvVZQcGH8lFPlOrIY1RR8J4bm3Uc09eJ93e9ZPFCB4jH8rKM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DU0PR04MB9494.eurprd04.prod.outlook.com (2603:10a6:10:32e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 12 Sep
 2022 18:29:11 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:11 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 12/12] net: dpaa2-eth: add trace points on XSK events
Date:   Mon, 12 Sep 2022 21:28:29 +0300
Message-Id: <20220912182829.160715-13-ioana.ciornei@nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DU0PR04MB9494:EE_
X-MS-Office365-Filtering-Correlation-Id: 769970d7-49bc-4295-88dd-08da94ecb032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: echSsLTfjjguCBmyT5xxcA2hb7t8fbVFl44YhC1M5TNIKWBkVmAxVERBo2ySa5b7lU0bV2Zgpj+HWHgk5zYlcT4pCOd95n0aSp3iAxY5Wn3pZBt+zg3TXsttzFvr6nZZp7tv/gpFAvSoF5cdbt/TFYapHZUyoWxN1+r5062UmQiQHGDPrguY0CdjyzSgxsI5jlfpFi47rhW8Z5x+gN1hIJtfh20C0JGGplSJqXbPml33cdLCAtYTBKh2K8ux6gjXIfColZVFnoW1th+nXENWFUeWofiW3aKbDqYXRvMzDAyjaMXM4nyPif+TsihJGm1VtVWjtw+93majjMF/n8W2UwwS6gA0Ae47/MH+XSGTVui9a2pR1ZMQfusmGE+M5THax/3Fq2ljphocy+WnnZx5+CEgR0QjviCFZ8sTUClJovDJPGplyqeaoG+v20gj07AMe70mo+txsAeJtt17rE2uBSuMGWnHpJ4DCFaiU6XiyLN7bpBO7Gx8TKxKUaBBO801/UgM78Ve8z2eMHd9ptj1bVa7toV7+WBonBlkZrULmdxlpPyaZvgN1QXUxlJiObvfswSucFfegopyM+WwU9LEGvjFZwYnyGFGKFQIlOiVYteWLmOX2zcV9OM1nZa6iU1QlrzqKxqTumX7Eq8Z1Lo8PPoYHWfD2yP8rXAXzQfiK5ZZsxB3z521W18+tvY8R1VUKyuz/oTkcYdJU2s0UiGHvRnXoKQOjU/EcXXEcblbYhLjCxIiePvc3Yh8cO+WtlbgD1ajOxE+hI429WokWK1Fsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(8676002)(6666004)(8936002)(38100700002)(2906002)(2616005)(186003)(66476007)(4326008)(66556008)(44832011)(26005)(36756003)(41300700001)(86362001)(6486002)(83380400001)(6512007)(66946007)(1076003)(52116002)(478600001)(5660300002)(38350700002)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e/S9q4NfPgzc0RMRaTKL60oZTO7aKVEZIdEKiBpDaLNo0vOpyOc++MSuSJzA?=
 =?us-ascii?Q?XqCQhtdyIcKqFRk5Kz5vp2lThPCdLQfW0zx5NHmtfrzkLgNeZSW9VXAzy6eW?=
 =?us-ascii?Q?0P13zO3twXvP50Qd0PWnYWLie7IT1mi56eBkpNZwKWdikUeXg6xg9J+RcoAq?=
 =?us-ascii?Q?P9TYz2JMqo0U8Xr7w69jrJlaeW0a05Sbs02j53qF8kcSd2AIdkqC+7mQSfcD?=
 =?us-ascii?Q?pleNbQLUZQnfcgMKQT/xIS4SVvUM6mbFvsunehD/g69QexHQJ1Mjs9dIWz0P?=
 =?us-ascii?Q?x/qiwtf+zwl5Hj550MjARyHDJmbecnGGOmS7QZnfypx6G38cwo6EI1dcc9ON?=
 =?us-ascii?Q?m4DIpLwoueXeHX95o7ikfHuwRj8QVBRd6kL06S9D/M3851WWJiamtqiNtyPi?=
 =?us-ascii?Q?oW6L4try1n+2ua0T7aTzVumBRthHT2ayaHtZPjTfO6XOqFKbIPmgPiUHqb6r?=
 =?us-ascii?Q?wvttYGd5X2JyYL8GXwx1+4lJgrkIcC8ZeRqqeUBuO10psJSNBVY20xqkIVRu?=
 =?us-ascii?Q?S/fzibu6JOxcSjlLm1W+9jGVFJdq4QBJUl22fLcUce1883EHmiHgQ+wHWcHS?=
 =?us-ascii?Q?7V6J9FVP5NZxtLunWtQL4aNBVLpJrSI/R5aMMWDKr0p7Udv8DhxrrLVPLaQC?=
 =?us-ascii?Q?f9S0JXlzu3ZnTcCCq/CmAJYAE8WG7Y/3xlsqjqAZrYO8PSDuEAJUZrY9HAuw?=
 =?us-ascii?Q?s3fv1BAdcF8GzZk/wGs2bh0OSV/dXrsghHgRY0xZ38tyBBiUxmDKQ3vYWLXl?=
 =?us-ascii?Q?KAXCsSwFwmu1VdZqhK3wmWgZ/RrGamEtz6HKi9Gc4ENEDVrUugdRT0r8Nnhs?=
 =?us-ascii?Q?0mVFLp22DHtQdabp+swoMCVhfR779nvtYuz8cjvhxpYUdDVvtlsC13Jm7oeJ?=
 =?us-ascii?Q?UiCAVfl/70VTtwqTMJdx+zTkwbOj9gOvHN0ce8iV+W2ZzyhrL3UrPhqrFAbd?=
 =?us-ascii?Q?yLNToaBb6va1Q6HvaDSZnVyI4kWOSZFGaxshZ1vUf70PLF6qYGsG21XrKYHy?=
 =?us-ascii?Q?0X3VOKm+p7hq3PVfBW3cgcmD56V0037atIKk+FmWCCulMCeNCcZFvbpjm6hk?=
 =?us-ascii?Q?cz/urBdu496Zx3KH0dqw8pCHIUamWXe21FqXFa5UWyujdtrU/vJMjFX1VCIy?=
 =?us-ascii?Q?3nW85DU0THYTp90jPA0cd7ngQSBO5r8DfMYIP5MlyyMvAC/578pOQv1/u8RL?=
 =?us-ascii?Q?Hs/VSNW96aAPgP21rJ2D690aL7/rnmB/aH7SesmIRT6e+BbHVu18fP0kkJOW?=
 =?us-ascii?Q?IlPysj4khJGBVEDkSYYXygY51/rMDtTi19csXd8EKrNk004GXbFHULIFIfGa?=
 =?us-ascii?Q?WC53v7f4GvgGhSd3jVcH7yjbdQaGAmgPNPpzcSlvjia/OX5YZhHW/iNrogx3?=
 =?us-ascii?Q?vCZRC/Toog9ivaHm2ceRYJ1oj0CiOh4Gzg7I6ABkw14vQRwPx/DK5vInlpur?=
 =?us-ascii?Q?T9JawKQMrgQFgl552c0b3tCF6/GjuUdkdqVpxlj8jxExGWnJ6PlrPyH9dauB?=
 =?us-ascii?Q?46ftWnpcrwe1oSt4Tc4dcL+UWSn5zzL3+df+fWhxbCcm7ANrZDKR5i2aSr2h?=
 =?us-ascii?Q?LlyZFiZcq7W8Z79cKzkAE0rsYS1VVB+aFl0X9X/N++uWDweLBJ0qaxB3fci6?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769970d7-49bc-4295-88dd-08da94ecb032
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:11.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKTj3MXXAh6Shid831FoS0/ni9E+t+VbfNY7tx2JTjaWS/VFXYJKeLvQ46FCUwfruIZ0zszORdmxvIShUxrWgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

Define the dpaa2_tx_xsk_fd and dpaa2_rx_xsk_fd trace events for the XSK
zero-copy Rx and Tx path.  Also, define the dpaa2_eth_buf as an event
class so that both dpaa2_eth_buf_seed and dpaa2_xsk_buf_seed traces can
derive from the same class.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-eth-trace.h         | 142 +++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   5 +
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  |   4 +
 3 files changed, 100 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
index 5fb5f14e01ec..9b43fadb9b11 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
@@ -73,6 +73,14 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_fd,
 	     TP_ARGS(netdev, fd)
 );
 
+/* Tx (egress) XSK fd */
+DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_xsk_fd,
+	     TP_PROTO(struct net_device *netdev,
+		      const struct dpaa2_fd *fd),
+
+	     TP_ARGS(netdev, fd)
+);
+
 /* Rx fd */
 DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_fd,
 	     TP_PROTO(struct net_device *netdev,
@@ -81,6 +89,14 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_fd,
 	     TP_ARGS(netdev, fd)
 );
 
+/* Rx XSK fd */
+DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_xsk_fd,
+	     TP_PROTO(struct net_device *netdev,
+		      const struct dpaa2_fd *fd),
+
+	     TP_ARGS(netdev, fd)
+);
+
 /* Tx confirmation fd */
 DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_conf_fd,
 	     TP_PROTO(struct net_device *netdev,
@@ -90,57 +106,81 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_conf_fd,
 );
 
 /* Log data about raw buffers. Useful for tracing DPBP content. */
-TRACE_EVENT(dpaa2_eth_buf_seed,
-	    /* Trace function prototype */
-	    TP_PROTO(struct net_device *netdev,
-		     /* virtual address and size */
-		     void *vaddr,
-		     size_t size,
-		     /* dma map address and size */
-		     dma_addr_t dma_addr,
-		     size_t map_size,
-		     /* buffer pool id, if relevant */
-		     u16 bpid),
-
-	    /* Repeat argument list here */
-	    TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid),
-
-	    /* A structure containing the relevant information we want
-	     * to record. Declare name and type for each normal element,
-	     * name, type and size for arrays. Use __string for variable
-	     * length strings.
-	     */
-	    TP_STRUCT__entry(
-			     __field(void *, vaddr)
-			     __field(size_t, size)
-			     __field(dma_addr_t, dma_addr)
-			     __field(size_t, map_size)
-			     __field(u16, bpid)
-			     __string(name, netdev->name)
-	    ),
-
-	    /* The function that assigns values to the above declared
-	     * fields
-	     */
-	    TP_fast_assign(
-			   __entry->vaddr = vaddr;
-			   __entry->size = size;
-			   __entry->dma_addr = dma_addr;
-			   __entry->map_size = map_size;
-			   __entry->bpid = bpid;
-			   __assign_str(name, netdev->name);
-	    ),
-
-	    /* This is what gets printed when the trace event is
-	     * triggered.
-	     */
-	    TP_printk(TR_BUF_FMT,
-		      __get_str(name),
-		      __entry->vaddr,
-		      __entry->size,
-		      &__entry->dma_addr,
-		      __entry->map_size,
-		      __entry->bpid)
+DECLARE_EVENT_CLASS(dpaa2_eth_buf,
+		    /* Trace function prototype */
+		    TP_PROTO(struct net_device *netdev,
+			     /* virtual address and size */
+			    void *vaddr,
+			    size_t size,
+			    /* dma map address and size */
+			    dma_addr_t dma_addr,
+			    size_t map_size,
+			    /* buffer pool id, if relevant */
+			    u16 bpid),
+
+		    /* Repeat argument list here */
+		    TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid),
+
+		    /* A structure containing the relevant information we want
+		     * to record. Declare name and type for each normal element,
+		     * name, type and size for arrays. Use __string for variable
+		     * length strings.
+		     */
+		    TP_STRUCT__entry(
+				      __field(void *, vaddr)
+				      __field(size_t, size)
+				      __field(dma_addr_t, dma_addr)
+				      __field(size_t, map_size)
+				      __field(u16, bpid)
+				      __string(name, netdev->name)
+		    ),
+
+		    /* The function that assigns values to the above declared
+		     * fields
+		     */
+		    TP_fast_assign(
+				   __entry->vaddr = vaddr;
+				   __entry->size = size;
+				   __entry->dma_addr = dma_addr;
+				   __entry->map_size = map_size;
+				   __entry->bpid = bpid;
+				   __assign_str(name, netdev->name);
+		    ),
+
+		    /* This is what gets printed when the trace event is
+		     * triggered.
+		     */
+		    TP_printk(TR_BUF_FMT,
+			      __get_str(name),
+			      __entry->vaddr,
+			      __entry->size,
+			      &__entry->dma_addr,
+			      __entry->map_size,
+			      __entry->bpid)
+);
+
+/* Main memory buff seeding */
+DEFINE_EVENT(dpaa2_eth_buf, dpaa2_eth_buf_seed,
+	     TP_PROTO(struct net_device *netdev,
+		      void *vaddr,
+		      size_t size,
+		      dma_addr_t dma_addr,
+		      size_t map_size,
+		      u16 bpid),
+
+	     TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid)
+);
+
+/* UMEM buff seeding on AF_XDP fast path */
+DEFINE_EVENT(dpaa2_eth_buf, dpaa2_xsk_buf_seed,
+	     TP_PROTO(struct net_device *netdev,
+		      void *vaddr,
+		      size_t size,
+		      dma_addr_t dma_addr,
+		      size_t map_size,
+		      u16 bpid),
+
+	     TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid)
 );
 
 /* If only one event of a certain type needs to be declared, use TRACE_EVENT().
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index ccfec7986ba1..9e29b3ed6edc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1729,6 +1729,11 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 				goto err_map;
 
 			buf_array[i] = addr;
+
+			trace_dpaa2_xsk_buf_seed(priv->net_dev,
+						 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
+						 addr, priv->rx_buf_size,
+						 ch->bp->bpid);
 		}
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
index 0a8cbd3fa837..7599c028fa42 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -113,6 +113,8 @@ static void dpaa2_xsk_rx(struct dpaa2_eth_priv *priv,
 	void *vaddr;
 	u32 xdp_act;
 
+	trace_dpaa2_rx_xsk_fd(priv->net_dev, fd);
+
 	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 
@@ -414,6 +416,8 @@ bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
 			batch = i;
 			break;
 		}
+
+		trace_dpaa2_tx_xsk_fd(priv->net_dev, &fds[i]);
 	}
 
 	/* Enqueue all the created FDs */
-- 
2.33.1

