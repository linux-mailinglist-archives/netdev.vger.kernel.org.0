Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656726817A4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbjA3Rcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237494AbjA3Rcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:32 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8D53BD9C
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwYbwkMtK64JWyHWlgg+tv+VDMEbWoqAH7ZaHT4MszwvUiO0k6YMBKkMYjwDdFGGUJums/eCxqnodxLXrSPjqJxCz3i3u9Umb5/wGRtNEGx9kWLfMkBx63gzKQupVnCO7n0B4O/tkc0J+hil7v1ev4ae2rchvLkNcYKc1RoVdHipGUs9O8YHh5RAw7hUpoWzM7jMw6n6j3i8D5mh4x6fgo7o2JmQ/c80/y27c8kzHp2dZx5xS3Ob4Rc/D5Sr21dvPQrpEYnYtA63WuutpM9qxhjjnel5lnNZKLraxuOaAYJBbWKLpmVwXwDX/l5dA3U+xGk6bVMpTJvGdby77oBRCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZGnuiFstEBfHjUUtIamArn5rwyBGPrhGVSpwy9kCEs=;
 b=STOR0q1KYgowexuJa3Z///PMFivPJu9gW0fbsS0OkX3XIW3wbuFNaSAT8n3ztC54O5upHCqhGNHjPQUZ4xEacg7ZJFuEL5BtlSyRKEZBUdRWUDykJP4pU8rMffuhExNDeFFeUoJtTVqA97ZIFP9ykSGlL9MWxGDlVC7nCwB+KBWePoLxH9+mdRPr0hVgRkRhtqMJw3xsYs0veLcqp/+HTGwsDoVcXWkXp/geomelCD4eFiXNk7BhzsB3uHL4mUVkhj848qLStEN0xoTxv3GFXE+S8kqEk5eL9JxPyuMh0wcTgoTQ3NtloSbVMswuGbOKGCtK7gfuZhnjWI4axc4z0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZGnuiFstEBfHjUUtIamArn5rwyBGPrhGVSpwy9kCEs=;
 b=nla29b76BY3I8X/z4qlDRHeYHu+qXy7knrazN10JFJxWbeOBG/MjjLcCUFQCUxdfIIrSM3cPJ4v8+9CgQI9O4p1y2urrCSwtxR5b+2fjMhisO3GdnUwA/gXhoJ1jTJoyxKG+/lr4DWOpdkv/DcLIYCnFHokNnlMrc+M5pgxISjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:10 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 03/15] net: enetc: recalculate num_real_tx_queues when XDP program attaches
Date:   Mon, 30 Jan 2023 19:31:33 +0200
Message-Id: <20230130173145.475943-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d8306bf-603c-4df9-5bbc-08db02e7eaab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W03hCspqwibAWw0mRHe5kyhiFYCbGzIwe7rRTyRdz3mtjVhe0xADhC1/V9lmt4vM5vZefhV3eWN0BorimdU4DWJwiNzlM+pmzDdlYspI0K34MGdlP8b+wL2Z752ht4J9mWZtxoLc6GRreRj9BsYIAyDus9CtfkSaYoYzMod5/NFCfo/F6XgOZb6XNraHtSuFSaRRybzRu5fcItc5Dk9LupgMh4r5YFm5ysqX3BGI8cTMsOzYtdTcKLjkHJVRYyx9GvBICkDIJP3HC60rrgjfA391DNAzPB7CzNfC5+sy9jqtp220Z/XSfEHz7fw5J99mTBnRzKe6h6ixqPJjtOt055IdC3UtHwzKw8AEnwYw0uWLM2tbkoDKsD2tPcdGgmN06gV7SPNt95hLaI/nNlD4eSIgwkAQoSZiY2RyAw5ivQ0hKWkKfBO+HC+oEOvmdk0MI5CZQNeGejhzlCmCz+Qk1NnLDgUv6WeejLRAtyo29Q8eSzrPj/WMId1Z2nSEnGwdCptczhnKtRapXGyUVMqqIEcadZSzx9B5MvOqKPGPK4O61Q1H0qofXTA48MoGky/wOFv+Odttqv/2k/dhIyQnO4aWLZ9P5/XNvtWboey8kTdME4Ik8204nInAaqcnUz/7UD1ieBbooi61ZJ0PU1jJWH0zYCCW/Cmv8zF5xG1kksDsCM4QmXvUzJzMnx/4gl3iQLRapW6p3gjy2opsdrHlFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TI1P7T6i0nuhn2CFtsAJzd+An1Rl01vswZ1quHpMFwcwU4vaZ3ycutO5Cq55?=
 =?us-ascii?Q?nXoXrHfuNnWl+w/+acxgi1zueDIGQYnURBJCPNGUarp/AtqgDT+ugeUFU5sq?=
 =?us-ascii?Q?zB0QC2wyRv2d1yrvkizkRFlMQm+YrqouHzWgDKVdTZVI+CFHZc8ilAgVjve+?=
 =?us-ascii?Q?C54xUQoOAuNlu1PBt662OUTNVXhYtGJrKLvX1CzY9nHHtD7/aqjxX6FaKZR/?=
 =?us-ascii?Q?1HT7fxElFFxxxKSuMe2dvhPDekAdj2SUIjWBvLZ2K7ss8nRwDEeA7u4Dsa93?=
 =?us-ascii?Q?hFWoU632yWRtMz7QO2xgUT/PCJvqb9a7ZkfYdoUEL6qMuRwiT/RrAinNuaX2?=
 =?us-ascii?Q?9dBFfXCWAwvQk1AhL3ijfK7KC7/eMNJ2h1OPUVcwJh6qlDexGTHF67wmNOTB?=
 =?us-ascii?Q?7HxPVVgQ+FKTivOHTuJ2ROYEMwCrqCkSK0i0kyzPv051hpHR7Km1vyTryp5y?=
 =?us-ascii?Q?YP2KSrCTAoOmwokrdU0pz1VD3cx1hV8jBS869azZd98yT4gwyO0fc11hVvc5?=
 =?us-ascii?Q?zmI2OV3tsta8Qw9IPnNrtxgHebjQxfMtfAL2S5p9zNnTEhY+7XG1Y8sdzHue?=
 =?us-ascii?Q?iYqJWgFrGMCRq9hMpdP3EgCxhct6QgbmVu86HEOeilZ+vNBeMEieBn+Tjpj0?=
 =?us-ascii?Q?RnjkjGgSo/0Mj8p1lX8fPrbEwEi6tw3KvUG58yGHOeL+JMG+jblyNNqCjfXI?=
 =?us-ascii?Q?KbTFO7T2NIxMf2crsyJA5npQm4s+XBc5WTD/nXjPGFxY3crPxaBvNJbdbj2+?=
 =?us-ascii?Q?a5/0nb2EFsJ93GgFjQDwP6lmIizizB5juVkbp++tYgglmfNlMPjDi9qlOumB?=
 =?us-ascii?Q?pFslB+yMVewp6Pi+O6nd4Ux6yGs5fG0ZY3dKYx7YEs3RjGnNcHK3YVtdb41t?=
 =?us-ascii?Q?OBYBmZ1JiyMXhpyPgBExMDU5ALyVBK8dfN8Ubc5Hpt2pzIGKD8L7pRWPtFDz?=
 =?us-ascii?Q?MGKyckXKrIgwjlJRrSXli1lbE0O0nnPD7IAGCq9boNnIRisShzRJqdgFeLkg?=
 =?us-ascii?Q?bLjsZSTPStJkzsQaswMqEhB7LDRsHPfRNgQi7U6WUv2Yy+K1SOuSe0jxBiHx?=
 =?us-ascii?Q?4M/aHITjQj1KDjxwiXlhmC4/QBiKbqjS4x2yiZtd9TewML9KtTjKDaGhYser?=
 =?us-ascii?Q?kwW7QODAAelR0I3f7Hw0N7V9upwq18K4v/YagdCl4deZ9FsR7xGoij7rCqR2?=
 =?us-ascii?Q?VAdg7xJGbU2vc81eYO4SxHPFjwNAETPW8EJXQKz4hTFuz7WkZsyfwHnl66Xb?=
 =?us-ascii?Q?6FI5fJetyeGq1oVmRgVMvbnCtBVAqScAooPuSDdAh1tgyUFsbbQn+1675gC+?=
 =?us-ascii?Q?4qubGnBjtHzRKXobhLJOJEGg26J339ENGaJepn9l8FENybmqIA8132mEUCTH?=
 =?us-ascii?Q?9GScRi45vRZyl7A2F9r6I5qJNdZKnzK+a59e3FlszKaYl2KfiYBsdTGiJ66u?=
 =?us-ascii?Q?yusaoGQlzRsSsVP5moO5RPqBe4geBOTeTkxp3cvNTX/Nqjibkgsze5QQqqGK?=
 =?us-ascii?Q?1vHFByGANWYugsprAP9K0ZKtiGp1qFzceYu2ymSXUwuc/un4WtKQkeM/4/b3?=
 =?us-ascii?Q?8rEDMFy5qpHwKYOI++eV0pBSJ2BKptHd60Js7cQJ+jrEQHgC5xejATwao4Q3?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8306bf-603c-4df9-5bbc-08db02e7eaab
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:10.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SffehchClwhuJ1yyxyqgHZAZ51hwotDK5swQ7CQ7GzVDjIAl8ooEuT5mYm96FQ3HDRACCWqLp9eowA7hu/VPXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed net-next commit, enetc_setup_xdp_prog() no longer goes
through enetc_open(), and therefore, the function which was supposed to
detect whether a BPF program exists (in order to crop some TX queues
from network stack usage), enetc_num_stack_tx_queues(), no longer gets
called.

We can move the netif_set_real_num_rx_queues() call to enetc_alloc_msix()
(probe time), since it is a runtime invariant. We can do the same thing
with netif_set_real_num_tx_queues(), and let enetc_reconfigure_xdp_cb()
explicitly recalculate and change the number of stack TX queues.

Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5d7eeb1b5a23..e18a6c834eb4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2454,7 +2454,6 @@ int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr_resource *tx_res, *rx_res;
-	int num_stack_tx_queues;
 	bool extended;
 	int err;
 
@@ -2480,16 +2479,6 @@ int enetc_open(struct net_device *ndev)
 		goto err_alloc_rx;
 	}
 
-	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-
-	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-	if (err)
-		goto err_set_queues;
-
-	err = netif_set_real_num_rx_queues(ndev, priv->num_rx_rings);
-	if (err)
-		goto err_set_queues;
-
 	enetc_tx_onestep_tstamp_init(priv);
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2498,8 +2487,6 @@ int enetc_open(struct net_device *ndev)
 
 	return 0;
 
-err_set_queues:
-	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 err_alloc_rx:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 err_alloc_tx:
@@ -2683,9 +2670,18 @@ EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
 	struct bpf_prog *old_prog, *prog = ctx;
-	int i;
+	int num_stack_tx_queues;
+	int err, i;
 
 	old_prog = xchg(&priv->xdp_prog, prog);
+
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err) {
+		xchg(&priv->xdp_prog, old_prog);
+		return err;
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -2906,6 +2902,7 @@ EXPORT_SYMBOL_GPL(enetc_ioctl);
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	int num_stack_tx_queues;
 	int first_xdp_tx_ring;
 	int i, n, err, nvec;
 	int v_tx_rings;
@@ -2982,6 +2979,16 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		}
 	}
 
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err)
+		goto fail;
+
+	err = netif_set_real_num_rx_queues(priv->ndev, priv->num_rx_rings);
+	if (err)
+		goto fail;
+
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
-- 
2.34.1

