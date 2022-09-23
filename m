Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797735E7FE7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiIWQeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiIWQdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:54 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD48313F291;
        Fri, 23 Sep 2022 09:33:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc3vH990tCLjtas/1uh8p2pxpmD/YQLB+mwoWxnuYiU8ICWFLJQPZjHjLS2zO9Bhw3YoDDnPvt/CUol1LTFow3u5EBrOc/z+Y+cqmBeIjauNFqSQzT5A/VTItsfX+//aA/0IxcGaPrHxWxoF8ZIZf0IPS5RgDcmD6DLNjm485P4pe3oVjX1hwEt6OIjBmalhxUxMC/y40ILC3CHcYYQKgvQ+4MXmFmcVWS+M54BeukfcQ2taI30ATxDLsMB1wzWjKJhmeQ8y06OMmLGSWRAe2BaZ54gewyP6/buYyYrbqy83/wxjd0j4xnRLtYUsjfFOLvZg3BEVDpeHnIDDFpKlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iD+qB3/civwY99BrKFFMIwjvQ88kMycvF7XzrouoyFE=;
 b=b2ohA1UcX8F/9PWYifrym9SNdzf23b37XAvRVOAhDNLNjpEU1XqnfQ6ffBhZ1zlHHq2mK5GYVI28brCnhcfegQx1DWkaRFW3QZOs8NWAtH1ZOteaFj26bPm9vJTn94Z14F1qdIi2MKJxsFVFY0ig6C9b5vo7Tqq+ZPkOz6dTnmnFC9oxEd1Vi2dMGAdLL5vuLEavWgml6LxmK2IZNAMQLdY2RbvkZ7AtC7U0w7kvBuVjOkvaG6TEYvd09PaN4584+g1op2PP643TEDJGRBr5aKD3herUF0Mj1hej8dLIfDx3iVBTw0UFzTlwOS4XadM4MvuIO6Ao502Mc6t2T85KNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD+qB3/civwY99BrKFFMIwjvQ88kMycvF7XzrouoyFE=;
 b=EAxwta3ipLONxnBqq0D56BHTnwgV/tcEfMP9Y0PhzCxaOkP5z0tnqVkgU3hMS6ivCDe+Coo+6OH/p4eNk+iya0csh0a273naTFv1lQzu5gUHZBScfwCieKDKXEUvHLgiIni0pg6E01zLz6pZu6/RgE7X4PRglIVytB2ZYoAIRk4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 10/12] net: enetc: cache accesses to &priv->si->hw
Date:   Fri, 23 Sep 2022 19:33:08 +0300
Message-Id: <20220923163310.3192733-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 750cce55-08d4-4ad1-33ad-08da9d816588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ym50ysa+u8Ligz3zZfuuwwtqACWPBN+ZCwlM0Oq2VON8dJT9lE38wqGEnKq8qv/ZsxvD3lb+RQ/0ItkuXuWjDhEf3NIvLfezN8IXPymf+gTk4jaXJnpzOmY78SwpPZiYFjf52Ee7Ah2PwRzQ8VVTXXaajDGn4VNZVUpTjV55Ly+V4nbHE+lHzMotndbwMTVRX3gV6ibHVFy1k//yt6PL3Jsk9VJ0/q0dJdDCGlUsk6y5NMu5bhRy50RVib1qmWo/cfEbGrHJcm5vSdhImeQrBUlOuqDqBW6zvYcb/rcGIoWHXBK2xcUd4jDDSzUa9mIeanohEwN2zkra3le/E+tykpdN2n3s1uvPU0ly4X8tDM/YKtjoc7Ywv/NMfQPnq9PeAmMiBlpswsfBnxPFWJ579a26b9FN6SIGTe1EN7zAlfCPJmu5bNb+60IsPc2+C21mEWU9/u+RCla74l9gnoGVvLgkIJu4hqrezDSX779CJ5ye3a2a/vYW4UNdg3Et7pQ+KeAbpCx/dC9UYalt44AmbK5avOqjGnUI0mXAp7FjsCN5s6vZCuYIdhrhFWEucioFzeqVFwbTWhepPhkFTAUvD81SeRFc9m0Vogui6O4PLG18jplmX6OebV9d/iXT1dKguJNE8Il46tNYKPPGJVvcI0WFizt1yMmfWc/uTfrZhQv59TqPReNj6zRAvHu9VyJSUGsfT1ZBbY7mBSwKRtOdlV6j46S7n+F/kdCQhj0eLf3ZPHdrN+qdOw+Q+H352dB9EllPIK/Y9z7h2Ijj9+QZ+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(30864003)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?upcmZq8yXNpVqKL2UHilmAhSaF58ZnEMbyTSeu6p7Z2De+wMqoN0zS572WtQ?=
 =?us-ascii?Q?kWEcyedBqjoNhETmTgaPm/2lDYQ6LF6U88n6AYGiAI15XuMQ0rG4gFhoVUKa?=
 =?us-ascii?Q?wvu8c5M8kwoopB9PGtr7EG5ZpIWOR14YLvoIk18FHYLMWt2R/0W4nVMu/OcE?=
 =?us-ascii?Q?ITRt+rbHBzSI+tX6Xt41bcyJhY4IY1kSS3NjXcOdRVk4uHnj0DC6CRI30UN6?=
 =?us-ascii?Q?/gOYvM92Wjm4wIyNda7nMNJWDQ59kIhPCFd/ZqSSThM3c/JhMAH8LItZdaD4?=
 =?us-ascii?Q?edfvBYAAmGDJoQ57tZiATpel6X5AG9FHiTcO3IkH2+7ConqQjGvaGm5lBpKd?=
 =?us-ascii?Q?rODIMzLNYf8SDvbBoS/UXonw+QPPms4dldxZe4ovNKYLyI+pczxA1MuZkV8d?=
 =?us-ascii?Q?Lwaqz6axAotW2TnFPqdUcwxaXCTB23+I6NQiwz/tO+e3q2PVSG7E5uVHEP0J?=
 =?us-ascii?Q?j6F62cz1slPjev2dubIUH6I50oAt8DcpOV0omNBwCZT74tk/Mh2lIENTW4Id?=
 =?us-ascii?Q?n0SCeSQAhO6UkS5xyfpLmjiyGDghX8Ms1K67NhoNKi/NgTciGeBiWxzQPyN9?=
 =?us-ascii?Q?OoSO/EQY6kc5oCc7f75yopYgn611ymD9ZPY+2n1g5bpEKRsveDRrtFFqRbxi?=
 =?us-ascii?Q?pxnGIu4m2MR3qrtMZoAnAIGYeNrGCk43s1HnJym6f7FIZUj3IK0qaqe3KJDc?=
 =?us-ascii?Q?QSFpS7w9ElCXZ5YOn+gwT1J6TUQ+QqBFEJSI+xy14mgGziep2vfipim+QVsH?=
 =?us-ascii?Q?kKZUhjkvDp+MtE+JQ/IR01J7hEWTmDx+zHQHqwoRDOlE8VpPXZii2wrmcXsl?=
 =?us-ascii?Q?cPWl6j78FrLJLX35KH/R8YrwrphCwNEgojsJ/Foa3HTblVMVdb48t4+qXUjK?=
 =?us-ascii?Q?37C9p6RBijcum3j7x/Serwx5mYPDGIvoakieWVL2i6/xVOtBchVVhsvL+T9A?=
 =?us-ascii?Q?FfLRvSUQnLyKu+yfG8VNM9G5PNt8mOhRGctWi2iAOIAjh9dt0GOIe6atRvfG?=
 =?us-ascii?Q?MKH0DCU2C6QyNQiJrlbJd5jsZ1pWNXjGeW3jJ32dfzzxX1DGULRIEh1ao0LW?=
 =?us-ascii?Q?KVPP6CB9qybcyft8Vpb7jGju706ihbtgQrbLgxXjHCBeejO9UC5dTO/F1o6n?=
 =?us-ascii?Q?Jwc35TJ5RUV9SafVl6GqC5v/YhJvZ7/GH+3Ab3WHmUvTw09yh/J9ulizHSTP?=
 =?us-ascii?Q?L9RuqekLvqZAN5Ys4Uxf4t4YHEf6ptTfneU+wIKfbM3N5HkdzLOPRsvyTIyk?=
 =?us-ascii?Q?PWHaCea4tLJaxMQk73io/M9GnPysq9RuOlLeP0RdDsoK9ofDW9h9sSak4yV/?=
 =?us-ascii?Q?+5izPTC/0OV7YBMbw/jSEgz4ACgybtzLb/SrjGoOUdeKHG+oWylg8+qQrPOr?=
 =?us-ascii?Q?Mp6wmGrTyFpc4OFTibJ2JgHgzWEdTJiAzILw/xHepE0mjguY+rS+FPZh5Ke2?=
 =?us-ascii?Q?eObFg0X75jHs2IsEJ/IeacPyaROBNusNOpRi6TcJ0sCySYvYYM61DJnDLkEu?=
 =?us-ascii?Q?4rTvnqz3D9D+piXx4uKzmMclhxPyo3nQ7IsFpmeLr0PzRJoRpIRBS4qJE4gy?=
 =?us-ascii?Q?FyZTG58WGNWF9dERz02RqDQjr4GOknxdD68eqzT8G/nnAciLCWNUxBhsGjqj?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750cce55-08d4-4ad1-33ad-08da9d816588
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:50.8457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN0Al1cLxJ5AJM+w9fgqTEiGoqpUCK7/ZG3sr0JA+isaRe0VfoLp2cOXbv1TU8xxxtzHhMkE2ttJ2rLqi5WCUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The &priv->si->hw construct dereferences 2 pointers and makes lines
longer than they need to be, in turn making the code harder to read.

Replace &priv->si->hw accesses with a "hw" variable when there are 2 or
more accesses within a function that dereference this. This includes
loops, since &priv->si->hw is a loop invariant.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/freescale/enetc/enetc.c  | 28 +++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 +--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 60 +++++++++----------
 3 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9f5b921039bd..151fb3fa4806 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2116,13 +2116,14 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 static void enetc_setup_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_setup_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_setup_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_setup_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_setup_rxbdr(hw, priv->rx_ring[i]);
 }
 
 static void enetc_clear_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
@@ -2155,13 +2156,14 @@ static void enetc_clear_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 
 static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_clear_txbdr(&priv->si->hw, priv->tx_ring[i]);
+		enetc_clear_txbdr(hw, priv->tx_ring[i]);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_clear_rxbdr(&priv->si->hw, priv->rx_ring[i]);
+		enetc_clear_rxbdr(hw, priv->rx_ring[i]);
 
 	udelay(1);
 }
@@ -2169,13 +2171,13 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	struct enetc_hw *hw = &priv->si->hw;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
 		int irq = pci_irq_vector(pdev, ENETC_BDR_INT_BASE_IDX + i);
 		struct enetc_int_vector *v = priv->int_vector[i];
 		int entry = ENETC_BDR_INT_BASE_IDX + i;
-		struct enetc_hw *hw = &priv->si->hw;
 
 		snprintf(v->name, sizeof(v->name), "%s-rxtx%d",
 			 priv->ndev->name, i);
@@ -2263,13 +2265,14 @@ static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 
 static void enetc_clear_interrupts(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_txbdr_wr(&priv->si->hw, i, ENETC_TBIER, 0);
+		enetc_txbdr_wr(hw, i, ENETC_TBIER, 0);
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_rxbdr_wr(&priv->si->hw, i, ENETC_RBIER, 0);
+		enetc_rxbdr_wr(hw, i, ENETC_RBIER, 0);
 }
 
 static int enetc_phylink_connect(struct net_device *ndev)
@@ -2436,6 +2439,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
 	u8 num_tc;
@@ -2452,7 +2456,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+			enetc_set_bdr_prio(hw, tx_ring->index, 0);
 		}
 
 		return 0;
@@ -2471,7 +2475,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+		enetc_set_bdr_prio(hw, tx_ring->index, i);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
@@ -2584,19 +2588,21 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_rx_rings; i++)
-		enetc_bdr_enable_rxvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_rxvlan(hw, i, en);
 }
 
 static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int i;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
+		enetc_bdr_enable_txvlan(hw, i, en);
 }
 
 void enetc_set_features(struct net_device *ndev, netdev_features_t features)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 2cfe6944ebd3..748677b2ce1f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -467,19 +467,20 @@ int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 reg;
 
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSIDCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSIDCAPR);
 	priv->psfp_cap.max_streamid = reg & ENETC_PSIDCAPR_MSK;
 	/* Port stream filter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSFCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSFCAPR);
 	priv->psfp_cap.max_psfp_filter = reg & ENETC_PSFCAPR_MSK;
 	/* Port stream gate capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PSGCAPR);
+	reg = enetc_port_rd(hw, ENETC_PSGCAPR);
 	priv->psfp_cap.max_psfp_gate = (reg & ENETC_PSGCAPR_SGIT_MSK);
 	priv->psfp_cap.max_psfp_gatelist = (reg & ENETC_PSGCAPR_GCL_MSK) >> 16;
 	/* Port flow meter capability */
-	reg = enetc_port_rd(&priv->si->hw, ENETC_PFMCAPR);
+	reg = enetc_port_rd(hw, ENETC_PFMCAPR);
 	priv->psfp_cap.max_psfp_meter = reg & ENETC_PFMCAPR_MSK;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index f8a2f02ce22d..2e783ef73690 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -17,8 +17,9 @@ static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 {
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 old_speed = priv->speed;
-	u32 pspeed;
+	u32 pspeed, tmp;
 
 	if (speed == old_speed)
 		return;
@@ -39,16 +40,15 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 	}
 
 	priv->speed = speed;
-	enetc_port_wr(&priv->si->hw, ENETC_PMR,
-		      (enetc_port_rd(&priv->si->hw, ENETC_PMR)
-		      & (~ENETC_PMR_PSPEED_MASK))
-		      | pspeed);
+	tmp = enetc_port_rd(hw, ENETC_PMR);
+	enetc_port_wr(hw, ENETC_PMR, (tmp & ~ENETC_PMR_PSPEED_MASK) | pspeed);
 }
 
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
@@ -61,15 +61,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	int err;
 	int i;
 
-	if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
+	if (admin_conf->num_entries > enetc_get_max_gcl_len(hw))
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
 	if (!admin_conf->enable) {
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -117,14 +115,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
-		 tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(&priv->si->hw,
-			 ENETC_QBV_PTGCR_OFFSET,
-			 tge & (~ENETC_QBV_TGE));
+		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -138,6 +133,7 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int err;
 	int i;
 
@@ -147,16 +143,14 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 			return -EBUSY;
 
 	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_set_bdr_prio(&priv->si->hw,
-				   priv->tx_ring[i]->index,
+		enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
 				   taprio->enable ? i : 0);
 
 	err = enetc_setup_taprio(ndev, taprio);
 
 	if (err)
 		for (i = 0; i < priv->num_tx_rings; i++)
-			enetc_set_bdr_prio(&priv->si->hw,
-					   priv->tx_ring[i]->index,
+			enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
 					   taprio->enable ? 0 : i);
 
 	return err;
@@ -178,7 +172,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	struct tc_cbs_qopt_offload *cbs = type_data;
 	u32 port_transmit_rate = priv->speed;
 	u8 tc_nums = netdev_get_num_tc(ndev);
-	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &priv->si->hw;
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
@@ -199,15 +193,15 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		 * lower than this TC have been disabled.
 		 */
 		if (tc == prio_top &&
-		    enetc_get_cbs_enable(&si->hw, prio_next)) {
+		    enetc_get_cbs_enable(hw, prio_next)) {
 			dev_err(&ndev->dev,
 				"Disable TC%d before disable TC%d\n",
 				prio_next, tc);
 			return -EINVAL;
 		}
 
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), 0);
-		enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR1(tc), 0);
+		enetc_port_wr(hw, ENETC_PTCCBSR0(tc), 0);
 
 		return 0;
 	}
@@ -224,13 +218,13 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	 * higher than this TC have been enabled.
 	 */
 	if (tc == prio_next) {
-		if (!enetc_get_cbs_enable(&si->hw, prio_top)) {
+		if (!enetc_get_cbs_enable(hw, prio_top)) {
 			dev_err(&ndev->dev,
 				"Enable TC%d first before enable TC%d\n",
 				prio_top, prio_next);
 			return -EINVAL;
 		}
-		bw_sum += enetc_get_cbs_bw(&si->hw, prio_top);
+		bw_sum += enetc_get_cbs_bw(hw, prio_top);
 	}
 
 	if (bw_sum + bw >= 100) {
@@ -239,7 +233,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
@@ -259,8 +253,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		u32 m0, ma, r0, ra;
 
 		m0 = port_frame_max_size * 8;
-		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
-		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
+		ma = enetc_port_rd(hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra = enetc_get_cbs_bw(hw, prio_top) *
 			port_transmit_rate * 10000ULL;
 		r0 = port_transmit_rate * 1000000ULL;
 		max_interference_size = m0 + ma +
@@ -280,10 +274,10 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	hi_credit_reg = (u32)div_u64((ENETC_CLK * 100ULL) * hi_credit_bit,
 				     port_transmit_rate * 1000000ULL);
 
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+	enetc_port_wr(hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
 
 	/* Set bw register and enable this traffic class */
-	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+	enetc_port_wr(hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
 
 	return 0;
 }
@@ -293,6 +287,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_etf_qopt_offload *qopt = type_data;
 	u8 tc_nums = netdev_get_num_tc(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	int tc;
 
 	if (!tc_nums)
@@ -304,12 +299,11 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-	enetc_port_wr(&priv->si->hw, ENETC_PTCTSDR(tc),
-		      qopt->enable ? ENETC_TSDE : 0);
+	enetc_port_wr(hw, ENETC_PTCTSDR(tc), qopt->enable ? ENETC_TSDE : 0);
 
 	return 0;
 }
-- 
2.34.1

