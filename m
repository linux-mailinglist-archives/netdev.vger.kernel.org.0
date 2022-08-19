Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681DC59A351
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350156AbiHSSDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350132AbiHSSCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C23C86C3C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6Y0BC2CeAFdfAgYP+ARAmGjm22xcZKe8ZDQK/CTBf/R9a/HQUb93CZqPtd9tM08/wuxnCYj8m0alBZNUfQYTHlZkcevc4vDgpRjC4SOofgnMgaPI0s8xbCMBt4PmkAYYDXzR4c+jFuENpPFo4yky2huZQIQACv+1s7IwZbx9f7MIBSC9iQkkE/cl2cKNYOYTFFpUjY4noAw7eidlj/Ui4KK1U5LqGYlLDph4B4IFEeXYY6ub/DL3XAp9fD01mECenz9+sjGA9hnNFcJ1JimNxyErQ2mFjr9Eci1zPJu1TNXXD5I1UePOVc5AceCCORtZM13QtdN3IQdt+nxdubJ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdQR//DUOxlX2QBpnshR9I6snM/J1/oxylG9ai0vAgU=;
 b=YH84yCVlphEJB1lcRGL0JgSmO8a7NljgT2R2DJ7gf5loZsSf50opgdvAeX3iFQqKaCK2DzFrbWHLg5Z+Mn0MyxUeV6uCaX0Bw7TbaCSvaldSkzduHjsZ7bb/6eF2JKhVYnWMLhOjlgGj9wCKleq+tYcDGYSX6dK5Nrt041Fls3Y4tjiZQApoEn20FEQKNqyrYbEbw52Js9SnATKh2O4FoevbLxc+XCAjhR/YIumXXWXeUGxdKPYgmCceHBda7EgJrPmP7Q+n1N1VbZvBsZC9jyG8uCqTsia9bDajVcQLhnBaeCOzPHBAwi60h8XNT2mAleUZjsxIswUjL3UGJwPvbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdQR//DUOxlX2QBpnshR9I6snM/J1/oxylG9ai0vAgU=;
 b=LHRb98lh4Ps0BGKvjtmHFXbtaZITNkvO/QL13Gzz/Gi0pfPmwK7gvloZZVWdzZzQXBG7OEsIourQN/5iFLzzLOZiHuRWvKDwDnpxTgPijowCCUWEfIDALkqk1umYs0Rqw6W2JNX1jsWcteogfUx+9t0qDFdDKCDBold9Ubjhiko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 7/9] net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
Date:   Fri, 19 Aug 2022 20:48:18 +0300
Message-Id: <20220819174820.3585002-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d9bd0af-8d06-4388-d767-08da820b0ce1
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0mY0VsMVGM5x+3wNzFArVIHyiajbl2R3TV5LcxXB+lfLH5fM3aCZUvVpJ5F2x2CObPErxNBWBFp+7VwTNFcCSwL3oCTjP5bOSlhaXKFC7Aqdr1V5J7a4ThYtkZVRLwqiQIBDfRjnOYX3+/YsyAKeLpnaNwa9tzgA3MI3/LhTmE4Clba1mZvY/x7eieUqF8DDFf7i2YgnL/lb96kfwS7H0YqIvd07RT00rrhzoWzckPj6dQS8E3TVdEnHseHrv66w76XuDP0JgOhvgxfTV52eIOBCsyTDFwljIwqDHoYfZow0WEevEXEtEO59FQyXeiRo9FSNm5HHjDboDUdmoznh/pMT4z3hsc0O6w988UoBsmBPNYCiEix5cqxVWP7kow/juk8inPM00NhJx86vCIkrbh5ASvnbnu+8PYuFlETnaugevNaczFoS0x50+w7otA2ILiUMcTBBDWGIeZaFtWX573urVjabrKYUHzCLthFu6sviMyRYzMjYW91epV/0v+zuouYpdC4dE+OhoulWK79+Xbx3QP85ZBzZn2Zrt/cdvb+gl8LpipIg1MHW7qoPC7LcPbHn7NSpvqY0lmQO0RSaiTgg0k1HMlq15hSKieHOKfd3ZAt+xk/SS4W6UdGH9Yg4/uHcfPU8IZgmayQYkhR0zF1n8B/QelBGMj2IGMKq40jW+nuzg7e8EVxEDXpMS9GAunjxOAq7zYR+kTAheddJuKuZbD5ScFwGCCD5jfngqpZSZCmOlaCbz+gc6rr/DZ2Fm0hjQQPO9gcEHb/r6AGfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Me8cjPuM8Ov2TIvrM5ursMXTm2jApRY7KKjQSvvK0P230W/Eij4t1LYM0r5E?=
 =?us-ascii?Q?osTSEY74+tEZuDpOk5rt3d5i9Kl2fFZYtZI/kYomrQDPDB94yMwc/yUGm0Dl?=
 =?us-ascii?Q?GKrvQln8mT/Sq9Xi9B6eh0qPI9Wc/92kYl0F36Lm2P2DA7MO/2hSQsPVrdol?=
 =?us-ascii?Q?ibIwHhaYqvDVo62V1iJb/ljIdI90drGij3Su0KHFetQr5Q2qnLQL8oQX2teK?=
 =?us-ascii?Q?b7sS2RZVP9r5Dl6lnsacGaLyoTh1DS9JU6Sh+W7s/dfAUC6kOugQ5P8vmJWJ?=
 =?us-ascii?Q?reePtIrs2TZzEgiXUULFysq3uOnSD1JNlUmRXi7gB+kDWAM2q+wROOgBeVom?=
 =?us-ascii?Q?FvyOSP4pnI+c3+IlESsNDHw4Q013ZRtxYcb5fS8LRQw9Jaipen94F60okmT/?=
 =?us-ascii?Q?y8JCP5ZwG9Z3Fxn89eQu3CvjdWY4DufW2GEnV5r5ogRvhi4Clt6VYjAyMrS5?=
 =?us-ascii?Q?SuVS6a+gItiiOmmRWtRPmqjUEj06bSGMyoeHoxLpJEfNCDpWQv+bO7KQSdc/?=
 =?us-ascii?Q?XBYEemBCo5/LhCmDDTAUprg1f6nAoagd8ZaUerD+hoZgxW16Y7E/zbBxD1RY?=
 =?us-ascii?Q?lWHd4sEYfbrr57xaCdUGYM4ZTXSL0EI597gFsv2ZBZXfHBRmxUrXVdvoErOf?=
 =?us-ascii?Q?0Vu+jWJ+64kRMn59KARjwEmf17OsoK5x1PI1/jKaGrOzigXFUD3p+PHEzoVx?=
 =?us-ascii?Q?clxz4UOhvQWEkCzxEoUjPRLAGGQKcE+UHNlMJIDbrFIDYgU/CuvHzPGH1znk?=
 =?us-ascii?Q?ubu5Ceskk71DKalcl8SByEiwUk+03X4EzDstkfV0vZSioEuJQUaGfJZbr6av?=
 =?us-ascii?Q?EQ4nfngxyzS29voXlE/CQTlzDwbOGiUDieO3O1FeDvK58NYLsEQd3WD70/NR?=
 =?us-ascii?Q?VRXoAPhTbKnzb+x02NbD1/PQ6AcDVEuCW9EoiurOIG2EhmuDAJukegvk4rFS?=
 =?us-ascii?Q?0eT9fBs4zgfPjaJu2dU9u/PdCPhC4NpnyBbUFqJqizKBmKEpKvd8ajQTtGKp?=
 =?us-ascii?Q?6yM7Ixw6GWw1FjxYYA7W2aBUb9K4JjIvxWpWgMXMSgQyi6DfGoHnkGUyVISA?=
 =?us-ascii?Q?yQZg98/TJzBOlJlqwwM5O0M9CD86JQzI26CzEqJ+QJ7Qga+gj6VZI/f87hbO?=
 =?us-ascii?Q?GyaKCUqKLPQqMJl03H1FVjscl0EFUTvDRP2nDrCzSBc1xYsuUWVA9X5ha7Eb?=
 =?us-ascii?Q?mPAyuLWBWa4XCfMwY7HZ6uJ4z84BqYSBz7F6U174+wvYjTNpmLqp3HBkTJpO?=
 =?us-ascii?Q?WvfgrE6msEgW01sQUL9i394AhdzXOMpg3D24wAxhpUYC22h5NMxkM3ZIA8Tr?=
 =?us-ascii?Q?kY0F0Ytk4nJzqqfOmNrtO2yDyyPYbI07luvHqxfDjcpb23z8ji++BeCFgNuZ?=
 =?us-ascii?Q?IvieYeyMuNPRXipqz16JgvAMFYImbmTUY1fFkHHFGlJQP3/iQO8bRPo//dGP?=
 =?us-ascii?Q?YaDW2hbweEOjruilmfG7QzyIZXAjJmn4quOBWh61SxTFoz6DFjJxu83OcsvT?=
 =?us-ascii?Q?wxZ3SSj0qwgyZ77GKolVMVzjLdx+SPXFoRzC79gC4k92PxLTu7/aeFJR064P?=
 =?us-ascii?Q?7GRsBxzH9r3lQOqQOda5nyg1+TG5SS3YBpYkhO96drlcil05mRP/imy0I55J?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9bd0af-8d06-4388-d767-08da820b0ce1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:40.0131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOkGTzcqkk58sXw8jr3HvNCXGouDKtp/uqCYopQTxaw+2pWc+xxwhNkf54Z37Dx5zp5xGpsfWWphNNTCqZ05Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More logic will be added to dsa_tree_setup_master() and
dsa_tree_teardown_master() in upcoming changes.

Reduce the indentation by one level in these functions by introducing
and using a dedicated iterator for CPU ports of a tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 include/net/dsa.h |  4 ++++
 net/dsa/dsa2.c    | 46 +++++++++++++++++++++-------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b902b31bebce..f2ce12860546 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -559,6 +559,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_user((_dp)))
 
+#define dsa_tree_for_each_cpu_port(_dp, _dst) \
+	list_for_each_entry((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_cpu((_dp)))
+
 #define dsa_switch_for_each_port(_dp, _ds) \
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
 		if ((_dp)->ds == (_ds))
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b2fe62bfe8dd..6c46c3b414e2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1046,26 +1046,24 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 	int err = 0;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
-			bool admin_up = (master->flags & IFF_UP) &&
-					!qdisc_tx_is_noop(master);
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
+		bool admin_up = (master->flags & IFF_UP) &&
+				!qdisc_tx_is_noop(master);
 
-			err = dsa_master_setup(master, dp);
-			if (err)
-				break;
+		err = dsa_master_setup(master, cpu_dp);
+		if (err)
+			break;
 
-			/* Replay master state event */
-			dsa_tree_master_admin_state_change(dst, master, admin_up);
-			dsa_tree_master_oper_state_change(dst, master,
-							  netif_oper_up(master));
-		}
+		/* Replay master state event */
+		dsa_tree_master_admin_state_change(dst, master, admin_up);
+		dsa_tree_master_oper_state_change(dst, master,
+						  netif_oper_up(master));
 	}
 
 	rtnl_unlock();
@@ -1075,22 +1073,20 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp)) {
-			struct net_device *master = dp->master;
+	dsa_tree_for_each_cpu_port(cpu_dp, dst) {
+		struct net_device *master = cpu_dp->master;
 
-			/* Synthesizing an "admin down" state is sufficient for
-			 * the switches to get a notification if the master is
-			 * currently up and running.
-			 */
-			dsa_tree_master_admin_state_change(dst, master, false);
+		/* Synthesizing an "admin down" state is sufficient for
+		 * the switches to get a notification if the master is
+		 * currently up and running.
+		 */
+		dsa_tree_master_admin_state_change(dst, master, false);
 
-			dsa_master_teardown(master);
-		}
+		dsa_master_teardown(master);
 	}
 
 	rtnl_unlock();
-- 
2.34.1

