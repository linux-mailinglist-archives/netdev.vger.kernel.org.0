Return-Path: <netdev+bounces-6306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEB37159ED
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB341C20B90
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C03C13AE3;
	Tue, 30 May 2023 09:21:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD914AAE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:21:35 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2059.outbound.protection.outlook.com [40.107.6.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E21A5;
	Tue, 30 May 2023 02:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXer0ZCosmU4PSf+Wbmtww02qRhVkO8XyxvYcXiqHgGqdR5gYGm1NzyWz/jiN3g+fwuF4ggQ9lyjJIXmyxGE3aa2fOC9FDG5Ot2JKzXAXetXTEkcQIIoozDQN1eUw1QRSH0TtVMFwZZDvFkM0bTfC9SPKL41oEzRudcyhsUnX1/RZ4dFfSg8jDqiyVmqBjw94x8ALnx4meyX+x5uScIkXiL5ZGrIB6/056FqGpTVljuUq7HHCsazIrCXBczOknDi897IL2LY/xQCKGffU0RB8kxMxMtnvhx67nJ+7Z/XtJ69iYTnbqfwMpLFsUFWeQdvEbxmygYa9F2PqtkTsHWojA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AE0bfkRAlzb6TGZS6z1c/EA1t0PmP6mUJUN9ivt0eMY=;
 b=YpXsXE60C6ndOWjmvps0a7GtnPDviVVTXkL46kpOGdSslSmXVtz9yIlz8lPXK3Ed6gauU5q9IB+NmvU+fixM/6QRY1Lb691f5M5KpzCnoWrQRF0p6l0RRBJnOA7bYUyVrz+/FOoMjfN8/f3q7qdR4JlCAm8U+3IvkX6ZQAB2vy78gDDyGfemkkPdpuvd/HsLJB/DlnHZmMWFWAMcmDow9H7wn6V8r5GhOdDpA9drmejcf/FCGKDNH4lH4hNJgU4VhirDoMmPTmN2CRRDXSg9DpewP+VcVdb9hT0HtA6JM4aVXxVIZpTvHG6UynCevhqFispzcLKiwWXSpWXMvWhGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AE0bfkRAlzb6TGZS6z1c/EA1t0PmP6mUJUN9ivt0eMY=;
 b=aQCWkk0+BLyBxpW7ltJxj80AXx+R31T/18iqv0/tizU14Su2ypAfSZ6jIEQM6H8DLctQ/Nw1VV4BLpbGVk2I8SmCpYWYn/9i2iiiYRybt2DRXkp4G+N17dJp5vvWmxATnCs1/4163LhSfXh7GDIYmsGSKfYHV0+5Kcqtdl4hrJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7167.eurprd04.prod.outlook.com (2603:10a6:800:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:20:17 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 09:20:17 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net-next 5/5] net: enetc: report statistics counters for taprio
Date: Tue, 30 May 2023 12:19:48 +0300
Message-Id: <20230530091948.1408477-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 5948d08c-d2eb-4a85-33b1-08db60ef1505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wyqQhSJJUt3g7hYwFyjgcMbh+U/qztAbS0B7n4bQC2XSGpdfCa8QhC0Q31/rtJlApCtXQ1PpUnBThbrh16n6/zpnH3DLQEDfQWRgQQ8UkOOsuN1dD31D2bFQqv5pffS03W+PkrTZdcNie3R2zpAu+GUY8Xe3INSyZ4HOUdkBVYa6rsWsOwFNEiftw41GQMSJRLsnHO9FcQBlWLeqXvhpXVN7VAj9Weio9qi0/ng5QApQUKWxUCL6M3dUr4/rHOvCkh3GPJIEN/W3//O6z/zyhQr+LjwfOsllMv+5WzsHZQ5Hx2tDPN/Vbc+Yv2KDhpb+H5OyqyOyBSAIoMNRzi1u34xAH0am4tf/ZAj8RMJ/puhTT1SJCiwFHPVt8HmMNiJFoOrysPjtXy5M10R8ccwEA+aKHYp7V+TdgT2yzvYe5VZCa4tk9IV9SE1Vgt0J4xke9+eBhVw5rBzurlMJw7KxHi52NFffGPFdacnzrt/f85W11UgMK6bFkGiD2jBdYvL3AQjmBxbdj9TUh9Q/eoQHsS/cqnTDDocwh357808Rtn2qUTuTlvuxxLehiOWTgPcvWLKlqOM2XW+6H5z5irIW2ARmbigLYsdVZYPhb8dkM3UgRwe3aitpBOzJwtGCZ9cg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(54906003)(478600001)(38100700002)(38350700002)(66946007)(66556008)(66476007)(6486002)(41300700001)(52116002)(7416002)(7406005)(8676002)(8936002)(5660300002)(86362001)(44832011)(26005)(2906002)(186003)(1076003)(6506007)(6512007)(6916009)(4326008)(316002)(6666004)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QoXt3TZ/TciUeHfupOCAcdSPA7eg4atG4kjupoQjidwd6QaZgR+RhFK9xDYl?=
 =?us-ascii?Q?VRW3v/R4M2vX0KtfXi+/D25wKR9DTTvqaHXrzfGp5IoIFK1UFhnGDy5KbTYa?=
 =?us-ascii?Q?vYSVHVH+nVl1xdJTCGbxgKS12vmbmfhPTLL3qhGpayD6ZfjKKde/xjqMKlCs?=
 =?us-ascii?Q?lVRDWYtVU/u+uFTD1Z3xKf5gwy8uNNXn05LceJm4X9i0gztp8U1vJrNAkrHf?=
 =?us-ascii?Q?PFEMi0aV8/wgcdH93cqAYnwDg0+/4Iad/KVqmda6YW/Xwk2Ll5TZOegYOIK7?=
 =?us-ascii?Q?MApDsFIBMYEQHCQtAyC3L2yDGhGZx03gVM+2amN5yXCYzpGDYfMpiB8U91Zb?=
 =?us-ascii?Q?CEIDIkBIQysw35OOntPk45q8zAwoc6LShUELF5hCTL/lmmqBJD3hW1ofbGwV?=
 =?us-ascii?Q?0l8HBFsySHLUwu9RM6kWaUnKqZZVYB9k3joGpPfjs0CPg464eINSjyvwIiQF?=
 =?us-ascii?Q?1e8K9unWkY3UuY+3R2OWMirLcVR31V5VDAfNVlV0nO9PZSqqGvy2140C08T0?=
 =?us-ascii?Q?hYLfjup2iOocGYfbOXk5saTDJvxnfbI4kEro0iWrLZhrp6sfVd1KmoefylqL?=
 =?us-ascii?Q?GmxBLO9XGB8e/R1fEqe5M85QKu575Lw652IV/cdwILuEj5iT39IdYoJl2b63?=
 =?us-ascii?Q?LJCYjWHCc5Ctq0tkgW9rJKFDGb+p2oI//c+XWPZ5hWxTR1PFRW2/p18ry84Z?=
 =?us-ascii?Q?pyMvEZaQ1gk8snK7nIUFhsoKY03QP3ugLBdfpG1HmhY4OYeyGpiA6pgAx8LN?=
 =?us-ascii?Q?J/OGYQR78vKoR9JRkPWlQljD27hgM3nRxEwl0syMC04ENwsoAt1gPSwGMN5J?=
 =?us-ascii?Q?R6c9HrDkq9caLZ4LatHi9DlKQNdC+WGG5cLE44OTyfnYF3lsHBqNqsujNtLn?=
 =?us-ascii?Q?qf+mu9YNNQCvyt52d1qa0cjIPDtDUXfNddZAqZpedpMbXVNVQOUUP0BQ3Zyf?=
 =?us-ascii?Q?yUxV/fa2ohS97s9dtfmC1gNmI1YPK9fCqyaTsCpvOf8tnfKfpb5CDzujw0pq?=
 =?us-ascii?Q?TdS/9x50Y2Kph3fku1TCpRC08mNBQ+bWbJJHNcQsCou8sOo5WaKPSYvKqrPD?=
 =?us-ascii?Q?s3v7J3I45umncxstNGymUdlCanBa/K9Cuao0hq7/WCK20wtlu/jWuhRmzely?=
 =?us-ascii?Q?XTEPZgq2vBp8d9oWi0cRF0tJb8rVPwgDKY+wpUA9S5AQy8nEw3f41dvOiqmp?=
 =?us-ascii?Q?RFfnjQkR1AwJ9HyVO4SsoIPdzZKFATIs3Z41zoX7oGW8PmkxaHZDtnQRyvNm?=
 =?us-ascii?Q?P+jDXaIJR2eZAN8Boe0V41d8wq06wEyJwO7otR4zWHzc/WRw7TXstNatByBg?=
 =?us-ascii?Q?N1h2NevicxwkuBxNmtObKFvjc/uqUhOIvC55j98HEbK1z6J4UGhwQKu9KlEX?=
 =?us-ascii?Q?riWZwD+jx3P2j003283l5GaNqIDAYO+GpMAnMsA7CCA/JE3Y6dcjigj5iyXB?=
 =?us-ascii?Q?Q8rwRc40XpBzSNFbT4kSwqEa7Way2I7yoicgkmt64ySqDXWJKwTSxvH7mQX6?=
 =?us-ascii?Q?fj9M7BJMGlu+hS8UR9JB0+540VkQSSUO602KR2GbwAuHAU2k1Et3p7LScmXS?=
 =?us-ascii?Q?dTqFZJBQNv6TInNaN4SeXOOgOAWLdBUG3fMZcfoAbpSKgyUIJNTkLPh1IoST?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5948d08c-d2eb-4a85-33b1-08db60ef1505
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:20:17.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxqamcUZLGV35CxSsaBDA3/wx2vygfXtkg/jsqibWHoN+oJdaDWxzPScTMo6/mzd9Dtkt7ZojmUkmga5kuLLAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7167
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Report the "win_drop" counter from the unstructured ethtool -S as
TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS to the Qdisc layer. It is
available both as a global counter as well as a per-TC one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2b8fdfffd02d..71157eba1fbe 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -147,6 +147,35 @@ static void enetc_taprio_destroy(struct net_device *ndev)
 	enetc_reset_tc_mqprio(ndev);
 }
 
+static void enetc_taprio_stats(struct net_device *ndev,
+			       struct tc_taprio_qopt_stats *stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u64 window_drops = 0;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		window_drops += priv->tx_ring[i]->stats.win_drop;
+
+	stats->window_drops = window_drops;
+}
+
+static void enetc_taprio_tc_stats(struct net_device *ndev,
+				  struct tc_taprio_qopt_tc_stats *tc_stats)
+{
+	struct tc_taprio_qopt_stats *stats = &tc_stats->stats;
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int tc = tc_stats->tc;
+	u64 window_drops = 0;
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		if (priv->tx_ring[i]->prio == tc)
+			window_drops += priv->tx_ring[i]->stats.win_drop;
+
+	stats->window_drops = window_drops;
+}
+
 static int enetc_taprio_replace(struct net_device *ndev,
 				struct tc_taprio_qopt_offload *offload)
 {
@@ -176,6 +205,12 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 	case TAPRIO_CMD_DESTROY:
 		enetc_taprio_destroy(ndev);
 		break;
+	case TAPRIO_CMD_STATS:
+		enetc_taprio_stats(ndev, &offload->stats);
+		break;
+	case TAPRIO_CMD_TC_STATS:
+		enetc_taprio_tc_stats(ndev, &offload->tc_stats);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
-- 
2.34.1


