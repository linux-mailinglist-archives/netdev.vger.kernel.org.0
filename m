Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56435B8BF5
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiINPeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiINPdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:45 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4225448CAB;
        Wed, 14 Sep 2022 08:33:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaV0SkpkWoifrYEY/hjX/mRytophlS+MAQzMjP9Ql3U7Av1KAZh93zE3CIa1LHQa4cR4ezjSZCNukASPZx9czJpzE8BGDl9Vgp9zEXHNDsx/d13f7slaIwL/z3V6kNRH83sK1zA8W0K6VklqljLR2NOBt0+qmFKRB3LXoZr88JFaI4fnUubW/XL8Pynqt49ve8jJqCL4evbWZ8zpqBDosyBxgFhGdXn2Z5BvlKVmYsTxDRhSGyN98cdq7hX2HO0ehhlYMrPZV8NAGUg0hAH2oojCeN+mnhjjMC74dDgULmcfJ6sYo8wlvz355bH+TmYEVzHlxPU15XDImRnP0ae4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibKIHBzuhX/omZGa2Ae8nq4GpL5lNpLQGO+1LOZ8IaA=;
 b=mn0hfsufMmZao+TEwz2t2onN5+DKbW5QLBQv2BaU+ZFR/Uo8M6XTbxASdXQXF5L5SCtj9eOgnaNCcyp1OiF4iz+7VNuq7AChoXvEVLQ5BYPXzD6n3ROUsMM2ZbfBIjDUu/ONfVEWpRU3ytfvcMRR9jnptQ1oV2og+CIrhqr4zPTWUB9ZSHmAJ6wlScEyUgypWjS483mykfHEyaWvqgNAZnORMxAL17+lRX0QB2KiSiZ7Divo5DEqoeKQNd6iPoRtzKZ45JF9yt6LKlMlJXIsIPpMw/j9c8pcxsD7M4REc7bd7YNEsbxCRZ9IkOXZg4cxr76iwizG3dPxZEDPVX04wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibKIHBzuhX/omZGa2Ae8nq4GpL5lNpLQGO+1LOZ8IaA=;
 b=Iu6K4VybN6BwKEGmQA9BhFjnWYdXmC95E3jGiw4H4D0rrGi7OM5uUMNk0jB5yrCpC4Wip9emlgLSAvTl7ltiUJgB17ErbRF+al/A7F8LJa2Xi2dzaImYbwZGZ6doonIL2sAj+z5bpKmf6sW1hJJY/MZH8AUtb3a5IS8pKsz7qjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:40 +0000
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
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/13] net: enetc: cache accesses to &priv->si->hw
Date:   Wed, 14 Sep 2022 18:32:56 +0300
Message-Id: <20220914153303.1792444-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: b85ffed5-814a-4067-fb62-08da96667fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4E9lk7LWVyIueOoxjQN0q1iAT0Ysz5qXdfDZ/ZdSY+7BOnxI5MUJIIk+Y3lEaw74oO6OxqSPyd9IBYE2K5lfDzU5COFBxv842RS1Z1WmyaSUOgt6KG1rTUliLy9p+NARniAMntgv213L0/PyqOlLVw0tabyRNTLqAFuecw4aCc5p2Ey/jhOwjvHARGOqCO/9eHgispaVzgLs3pxioWP0F790ByKYu3yyIVdjhP86mr9KZaLNu6guVCVPbTfumQsWQkQjXbtLCQoRiFy1PCfNrfZ5TB1g3hGlUEvD/QdLhX4DH722yQTSeXfK+bOCPgXKQHvWcUtkWFzJExwaiYqVo7xjTa8ZJVyglqtOWg2wN7b1Q3ytQ+c2Za4YcobQzqVZbN8C3hD2x10Tch33/sbeQyL+hh36bIpOuU9nQFobWAjIARcnK0nOyqc4siNa49sBHX3MSZ6ntKDRwu+CQCO0LumZD0RWVmd6EnCrM78vcZh2oE2gUsx2i1M1ukMSOb8njj0meBrlcvw9FXSCW9cnfHFT7VGpk32ChI6SNypKbVyEkD8RwZf6sbZbTlRKu47Nlek+Rl8Xc2p2TLatsvHh2jG7n/XN8gJZ35uPz+IlXc2WjA1J3GPhQmuIwUOzrbwevIgGlpY1uErkvFw1OJ7MBDoVhNTzIfBFmoarOc1L65cNBrGOMm2D1mRgEjcXst0xBdYRdwksFx/+5gD8gL4+mlBBs6hIan7FJ4PsCk7YZCRguCo9j9WcFzpNnMyWM51+KQbZObf9S7p0lfJm/1Jjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(30864003)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L7pqMALQP5LpC6wwfHGC2nnjszHI00KZekQqHdRNGXxIsDT7IOz8Z5sQi+rA?=
 =?us-ascii?Q?um+kqgXc/ncAimYLytf6olRDoc+zn1oicrlr/JhPGe4kvO0EndXWJx92a5iD?=
 =?us-ascii?Q?caMOHfHGZfrbUVRaw48Nx6j4kaaBOHVA/QXuU1i5XzyO4VRv1ItXkf606NAz?=
 =?us-ascii?Q?qykMT41CZDu03ZdO+YUcgmCwBhapIBOJYK+GFHNVEyCUyD8j8ffZcpu38iq8?=
 =?us-ascii?Q?V2TpEOhuzBouVyEi2kDKwN3gM1Wokt7h6hOuRhKr/0kJU1Fa6yU4Y5kOlzHP?=
 =?us-ascii?Q?qjCeLYceHShKJSMCupeFXhRz26GN2zycwYJfMQpx8AKr8CMtLiQBR5e26Mpz?=
 =?us-ascii?Q?85ne84DqF83BUc4ZSteCe3vicjL3SA60uJqnyTViLJcN8X94jaQiJ5EcHsiy?=
 =?us-ascii?Q?f8FX8UJwZv56wK5UayPGpZaSax4QsaywdBdcaaO74qL3EiQB+iRXSVDzzEaB?=
 =?us-ascii?Q?K7bPJ2sSKHmVt2XTL0/dgOf5KZR0Y4x8F2KwmlsL/peyV6zM2YNCtkELZXCk?=
 =?us-ascii?Q?oBt6GstM+ipl8kRw/5GD9AGt2ZK6MZ3dY4rI0uoubK345W1+N0lD7RI5i5Hh?=
 =?us-ascii?Q?zG5tb8yI1VCwFr4DXgVojh9M9kJ6MgdvpJEiSqLv+0qcn/FaYEYBuwDn5+Zx?=
 =?us-ascii?Q?k/LbB3avUj4Oz+g4pX72/0HJvtEIe6h1t2Bp6jsDx3u5sEnvVP/2OzJle4H8?=
 =?us-ascii?Q?Uv0T1bnDLTKzNZ1AnVMtPIdOjc8vOYbGQaQtfRsKO6wurldYOmX8grItmFJy?=
 =?us-ascii?Q?9YA3SmMWnGXHQ61NtqGaY/ZnNl3LUpANlWtKNPPkz2YTZa5jJSeYmoKOnbqE?=
 =?us-ascii?Q?o9tC1r7hHBdKLYDv6BJyxLWzJb7PJXT5BMGy3Dl706CPmmJlo3p1Md1pkUiX?=
 =?us-ascii?Q?gnbzCKumsqo1A55whe51l7jhMM0VY33KT1i/z7Noyy1P4cJ4tPvvMP9q0stP?=
 =?us-ascii?Q?XwBY+XccAu7r+jhW03nMyFGP8wYnxH9KDgsXBtgLYgeOp6fbOKKfngrhuzdK?=
 =?us-ascii?Q?JkR0fpdvPx5mu1D+KBWvgu2SVuRJQ/QzQXaoVQRvt2Z1Q5Q3MmTcM6J/uK5c?=
 =?us-ascii?Q?XC+dAOE3puTpwjY56UooMhDZLkg/PjO+XTCCB7Jf1nwdmEkuoxJXjYXbAjY0?=
 =?us-ascii?Q?HAFPKTktXPJ6F6m5WIio5AZZBBZn+32DBZjWa5FNfqSGyCuk1fPrq5/BnRzb?=
 =?us-ascii?Q?1mqh4F/+vh2VEhUfPrZRhuuC1rKjTowJaQecTulbromExyadVRNiyJxOsIHi?=
 =?us-ascii?Q?KvXWgFJsncrVP2cIixRT0MdirTUxKEPhyOiJ+XlTt4BIvIcmg9oGgtk9IOgW?=
 =?us-ascii?Q?/gyOZvO8It1BCgQBnBoaR5uz708+1Ttp1TKRVUziHnYRoEuHE+ayezQMPuRE?=
 =?us-ascii?Q?za6uewHp1vN75WgCT6bm6Qn/2mPF1+KeVSlmEkCzpR/mChKotC6MSCCpvHs0?=
 =?us-ascii?Q?JgrrSqTwGSiMyGL7oiUYWiIanG+VBDrBI6+9H/MvFjV+Hrh+WWI69o9V5wlX?=
 =?us-ascii?Q?SqfrSlLi4ThqfGwkylwsNaVB3+aZ09Du9DM2tu0OWyv6bF6jIOvJ1yUFOBfA?=
 =?us-ascii?Q?+Kl6Un8A4Ohc63KdRn4VNb/qZud/jsdFkKog2IvtNdedfKrYIfX3L/oyHg18?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85ffed5-814a-4067-fb62-08da96667fbc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:40.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JiHAmA019Z6E7cwS0+W4R6IRc1pq8ti7mvc95Ss9g8cHaNcE2iIgWonXJ5A0eiEwTdXfRhmHoXxUg35g0smhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/freescale/enetc/enetc.c  | 28 +++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 +--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 60 +++++++++----------
 3 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4470a4a3e4c3..850312f00684 100644
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
@@ -2436,6 +2439,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
 	u8 num_tc;
@@ -2452,7 +2456,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+			enetc_set_bdr_prio(hw, tx_ring->index, 0);
 		}
 
 		return 0;
@@ -2471,7 +2475,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+		enetc_set_bdr_prio(hw, tx_ring->index, i);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
@@ -2626,19 +2630,21 @@ static int enetc_set_psfp(struct net_device *ndev, int en)
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
 
 int enetc_set_features(struct net_device *ndev,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 29922c20531f..f4cf12c743fe 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -468,19 +468,20 @@ int enetc_psfp_clean(struct enetc_ndev_priv *priv);
 
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
index 582a663ed0ba..29be8a1ecee1 100644
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

