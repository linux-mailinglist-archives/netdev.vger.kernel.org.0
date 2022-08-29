Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0DD5A5847
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiH3AHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH3AHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:07:54 -0400
X-Greylist: delayed 1665 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 17:07:52 PDT
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1446B5B076
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:07:51 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TGuHqe009481;
        Mon, 29 Aug 2022 19:39:29 -0400
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2236.outbound.protection.outlook.com [104.47.75.236])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3j7ecx1tw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 19:39:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gr+t7cCGEpxbwV1tyw1TgpxGQm4O+DTPIxaVM+TLZvpe7inp90ZhkPShoxbFjmoWeIGo6D7ju5Fwrs3nhinbXIG0oK/ET/O/ZaTDU/jIKoL02JdSThcDIPFDICQ/rYZj9X56QE75rXWEICpqVxhlbZ3p+qJGalH6WqeNExe6hV84/AazpMFdwkyQjkqStU45KdDsZpZqG+zXpJkB+OZP2k8vtramVlr0IjbAS2RgMo4KLot4fA/Mz81bkbi42rT88gLEcjrPAT5P0wHB5TUPtHtuaBmpvDuff72AmjgtK/QtvJV+AY6hDK+alwE7f+OfZYbn9U3iv2i0HuHIbmcKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXGzUhcLeKTztUBcOyp69GrBkUfbqfZjgxBrCs+o+88=;
 b=d16KA8y/LxGshzHjW9fmyv1HbEDtTSxDHczjBwvJFKH3jiHU4NPi/l7n6kV38F0vRmf6uppyCpbcvuziq8EG7fkbviPkFlLwYCyjeJhN6nV8Z2p+0eRjHEl1Mjv+ZnCXQ0K4+FQhWQEb0pVojZdU0dQcVPpdhvGHVeB55AzrY8OxDlBga9VtV6yjf1yFFJwvswiwIgcHa9xVGSy07sn2BlaWxjwMSVdOd9PV+pNbe98A2MDusqg/EQW3D6WbkdwMcuWZPY9AzppbimnXFp4WbzS6DPH7DpHF6YVm9FHYkDpXVlclr7qldw316VhUZASXHAnNs4lQGqoJMXzVSx88Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXGzUhcLeKTztUBcOyp69GrBkUfbqfZjgxBrCs+o+88=;
 b=xof0Yd7wYzLykkIoeB4gHorWQDQOe/uOwzCbSMHyhFKtfSRkAJ8v1cpaQdkmWncY5m0KnGWfJItoaG7IkbZuNs+EYdYxyRbqHddKA3vC59g60UhufOFH5Meuf+eaMDttT58ZaQlsc0lOQGqRRJsD8Nj7hxYI2DR65O2+bv2wsXk=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT3PR01MB6338.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:5d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 23:39:27 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::1df1:78d3:3f17:d4c5]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::1df1:78d3:3f17:d4c5%6]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 23:39:27 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: axienet: Switch to 64-bit RX/TX statistics
Date:   Mon, 29 Aug 2022 17:39:01 -0600
Message-Id: <20220829233901.3429419-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::25) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c65a1c1-be9e-4725-38d3-08da8a17b608
X-MS-TrafficTypeDiagnostic: YT3PR01MB6338:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbPorX1rjFDEtCKikbPjSvUKXcCT6ureRN/aGKtitp+PWApTN0Q66ac5NUToXKlJlycu63sQOQogUcb0ZN4DqlBC4sqt5kmJn7OhXHorKxjOybQJo0/UQlhFJjlcyBjWX4DRCrp0SGCd0rmqx8HBU1jaXLxBccF6Cb/JOiUJ55BQNsIgBEbVAMsTbKbfwGHeC4vrIMP6Is5CzKMYwESV2drrbOxunChsFhYGXw3RR871JajSkenDFlkVL8X3ldvwzfcof0l6SHIg2SwxStLcivbd3cVce8/tHhj6fZLcSTBDTkiCj8aOq27B1ycCsqbU5J7ThDvNcCKqgWraoee9G7wpS5EiZ9y67XgcXTj8pbU2N+PMnox/DI9y4QVjIlv1ClxBW7T1Vua/OmBCvCo7p9RJPT54ofZS7PyIaCkZulVulFrH2heKZHUdocKoAl6U+d1+clRTxidECvfZDzUaXEariuWE/KE8nM3pBwmQyZ4fiF/trF+Sr8vxw/hcyisPonyPq1tyyYeGDkfbe5rc0U5KUTaN9Wy8GdpCo/VFdUQHU2qKnns3Y/2WvOaFLY5WYkM/xUTG3Du2Ng5cgi6X0PSGVi7u6XP72Ic2VSuxW5rBBBjHIrnFBXLIeLuQiWggYslxvn3677RJFwbgc6Ajt9nKn9yhsRpD2aTOKABgYPORyOLJ6J7Won4DY4AUqjgJvEtiE2FK3URGGNizPUEJtXCmXtTOUHUy3YBHzFxJ8i/lqTLh6Rg3DOd7o883J6Ts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(36756003)(316002)(83380400001)(6916009)(38100700002)(38350700002)(478600001)(4326008)(6486002)(8676002)(66556008)(66476007)(41300700001)(5660300002)(8936002)(86362001)(6666004)(6506007)(44832011)(66946007)(6512007)(186003)(107886003)(26005)(52116002)(2906002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UWayalaA3VSPZLu9U1k4QK4rMdyIHXEK+RRdzgIiYRhoA91gGOD8qvLaX5hh?=
 =?us-ascii?Q?G9t9xcsP2IGjPkUkApCBOuji0a604477QHiyJealk1si3zeZX/XtSI9+S7c9?=
 =?us-ascii?Q?AX2nniSqvPPSowX1jSwV+yul4hqxyUliIL3YPMipIWmiPSVXIB0Te0VuWPVe?=
 =?us-ascii?Q?38NLrCYBkc8vfg8otzizkPLaLMUZwUgJmZj26kWVXujYumKITVR8/iNWCHeD?=
 =?us-ascii?Q?GLvoUk49JVcjInY6Cen99oyS4MmHm6xvMxQKTlo/D+V5JIsIqHok6BVnV1V3?=
 =?us-ascii?Q?02SE6+KohSKskivkeLEt3aXAHSm/66Awqf5spksPZ7pTj3fW5j51H/DNB57R?=
 =?us-ascii?Q?KBkEze/W89NcRC2WY1ztMQ3NnP47TnJLkF1ub9ix+/HOwevoOzZvV7w3zAKY?=
 =?us-ascii?Q?BZKpwsktVHQWC/xNEGqdSlMOf8TFbJAgDPwl+mZmY7UI5R5SXSNyYJtETaaH?=
 =?us-ascii?Q?QzbKm93VZhhrkY/UIkv67DHTD748uuut5ca1cTGxtzyzQJbhZx2VWTTcocey?=
 =?us-ascii?Q?ncpkMJsiHeiqgZVCdC+pPFFwdtvKaMJ6JyT7+fph/pA2X0DncxRlcOMUewbP?=
 =?us-ascii?Q?OF6tbIdai4OUaA/P/HSDsIkCj19YqGtPnrnMbor/6pR0HZNi/llBxULntEQs?=
 =?us-ascii?Q?1JKMjRTuyHNQtiYZSxI49pogCaTLtSHG+jEATwNwCduYJ70tmcIbbsAfQsNm?=
 =?us-ascii?Q?4fIoNb3J+RceT1om5hDkYOCDcqdnci+wOwA/7ck2y4pIjfI4jzBx85zxlnBb?=
 =?us-ascii?Q?pJxQjrM9/UEJWRZDQL1Zevp9KVDjr+gNGqOfV6lZLb/J03kiIELCciWqWzSV?=
 =?us-ascii?Q?vYiOMBEqf94oPqoeFZywGZyXYMvIlfQmnCqwrGaMVQWODKFWCCpQ/A54XfGd?=
 =?us-ascii?Q?pFtZTE2LlqIkMYb5pPEZjtgFoisjJQ9qvAoDmpguetqrdLLikbe5FVwcm93k?=
 =?us-ascii?Q?dIT4PyATfnFG7NZYoyxysEad5i/bdEQJn8o7MhLsuB1UpdJj5WbZwJmQ75Kd?=
 =?us-ascii?Q?UEsHdmlOE1C/3v6e+LJBFucyLdbNlhvtfKTgZN2h/8mflnn44QG4dIOBoBsf?=
 =?us-ascii?Q?skY1WLrL5aCqAscBe+Yk2xzYXPw0QQlEoGZy+/WeRCHfl1/WC+3UdD8k/Uj9?=
 =?us-ascii?Q?+3Ogfdzivc4cA5NkYuTS7JZ4LWmXkim5nYD0o7szW3rusZ3Xspw1eqDt2li8?=
 =?us-ascii?Q?1A3xaFTUuUNpIvOulQwLFDFHZrgJ6r/Kl58ilVtMWAMlI7g9vpenof8claNc?=
 =?us-ascii?Q?wWIb4rdk4VOYzop06CZvyygmuqOJ4zXLYqVUL37fE85VQ1p6BCdp1BPtg+wS?=
 =?us-ascii?Q?a9d5wrYjoToj6NYeZNIUVQFRJUqwPRzJ2Wetuz15qzY4tgf+ZBpwWIBE0O84?=
 =?us-ascii?Q?jxDNi+T7ajHNfctO4sALxjmLakXrLzICjUUT2yzKuvbzodBMbaPONmeDCAFv?=
 =?us-ascii?Q?yhxe447/leOt9zrJairgE5Kxa6bSavkhnBvHm4O3yvXOzr4/sbaodYfUG9fu?=
 =?us-ascii?Q?tyShquMTx02PxjM88TidLNEwO6Go8SlzeBilbNVXfUA3hSbYLncUtzP8pxwH?=
 =?us-ascii?Q?zQBUWvjbSfVAeawDnPAQIxJmO6faKCOH9n5tgQprSDRpZmIvUa1NytceDBgn?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c65a1c1-be9e-4725-38d3-08da8a17b608
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 23:39:27.0313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpTCFPmEd7+m8OI4+dR/Bam1KSklSxrYzSWKB/TJZfXW80fOd0C8+JW91GZVkng+2mPK2Jb4GY4pgBGKfwlbZz8aT/joYEP/M8B3F3Kiti8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6338
X-Proofpoint-GUID: njAs-mk-tOVpUZnp_Pd5L0Mldv6foOew
X-Proofpoint-ORIG-GUID: njAs-mk-tOVpUZnp_Pd5L0Mldv6foOew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_12,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 suspectscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX and TX byte/packet statistics in this driver could be overflowed
relatively quickly on a 32-bit platform. Switch these stats to use the
u64_stats infrastructure to avoid this.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 12 ++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f2e2261b4b7d..8ff4333de2ad 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -402,6 +402,9 @@ struct axidma_bd {
  * @rx_bd_num:	Size of RX buffer descriptor ring
  * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
  *		accessed currently.
+ * @rx_packets: RX packet count for statistics
+ * @rx_bytes:	RX byte count for statistics
+ * @rx_stat_sync: Synchronization object for RX stats
  * @napi_tx:	NAPI TX control structure
  * @tx_dma_cr:  Nominal content of TX DMA control register
  * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
@@ -411,6 +414,9 @@ struct axidma_bd {
  *		complete. Only updated at runtime by TX NAPI poll.
  * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
  *              to be populated.
+ * @tx_packets: TX packet count for statistics
+ * @tx_bytes:	TX byte count for statistics
+ * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -458,6 +464,9 @@ struct axienet_local {
 	dma_addr_t rx_bd_p;
 	u32 rx_bd_num;
 	u32 rx_bd_ci;
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	struct u64_stats_sync rx_stat_sync;
 
 	struct napi_struct napi_tx;
 	u32 tx_dma_cr;
@@ -466,6 +475,9 @@ struct axienet_local {
 	u32 tx_bd_num;
 	u32 tx_bd_ci;
 	u32 tx_bd_tail;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1760930ec0c4..9262988d26a3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -752,8 +752,10 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci %= lp->tx_bd_num;
 
-		ndev->stats.tx_packets += packets;
-		ndev->stats.tx_bytes += size;
+		u64_stats_update_begin(&lp->tx_stat_sync);
+		u64_stats_add(&lp->tx_packets, packets);
+		u64_stats_add(&lp->tx_bytes, size);
+		u64_stats_update_end(&lp->tx_stat_sync);
 
 		/* Matches barrier in axienet_start_xmit */
 		smp_mb();
@@ -984,8 +986,10 @@ static int axienet_rx_poll(struct napi_struct *napi, int budget)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	lp->ndev->stats.rx_packets += packets;
-	lp->ndev->stats.rx_bytes += size;
+	u64_stats_update_begin(&lp->rx_stat_sync);
+	u64_stats_add(&lp->rx_packets, packets);
+	u64_stats_add(&lp->rx_bytes, size);
+	u64_stats_update_end(&lp->rx_stat_sync);
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
@@ -1292,10 +1296,32 @@ static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
+static void
+axienet_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+	unsigned int start;
+
+	netdev_stats_to_stats64(stats, &dev->stats);
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
+		stats->rx_packets = u64_stats_read(&lp->rx_packets);
+		stats->rx_bytes = u64_stats_read(&lp->rx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
+		stats->tx_packets = u64_stats_read(&lp->tx_packets);
+		stats->tx_bytes = u64_stats_read(&lp->tx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
+}
+
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
 	.ndo_start_xmit = axienet_start_xmit,
+	.ndo_get_stats64 = axienet_get_stats64,
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
@@ -1850,6 +1876,9 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	u64_stats_init(&lp->rx_stat_sync);
+	u64_stats_init(&lp->tx_stat_sync);
+
 	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
 	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
-- 
2.31.1

