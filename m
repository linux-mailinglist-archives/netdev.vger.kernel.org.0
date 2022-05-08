Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D5751EF5B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiEHTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiEHS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D198A1B1;
        Sun,  8 May 2022 11:54:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPqoa3BMP0M3SLz6+9dWcaF4UnxxkgAFRPvB81UH52yQktf8HzJhyXhZLZ2f3sMGHX+uE6+9xJfTRtPyyz8WMdBIlbJ+nS8DRxn31RKMFLqD/+DsPQTST6bON51wN/HJ1rmnnBqdO3G9YKDHHmSNwFFUmRYT78gMrH5N0CQUKEPH9cxMXXDXmuy7B0CcMxGqKZayogql1RjMvIIros9hx7Ui021D30HeaZCx9Bcke2Q0NrsnilmqKQJ1Rl6ibP/h65ThMlAPH+9JReXpPzn5U7kr8mbrvATLL94UXfH4sTkaseSWcSK12muZPz4Nmz5Ug9Rcqn/aaETtD+Tit5pakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR6KyRqP3UGkGySX6vQxXEvYmEmEmfBf9oJhx5+YSio=;
 b=K46ywgbVLax84IzxdeavBPcNV0ZBrPlwXgFissd5hWwrshnBaP8rYhZ4yC/lnX2fQ2iWTzQ5NLbLpO0Hwc+EH0rcxJf8+iLC/QLqujKMwgJ223ff691PUeg61d2BhRUNnWol+oU1Cc1Kuvb0vMz+VujxceTCmZKC5an0fxkQJ4JLobwqwj8fqG4LjA+xJi2TKx1QiTUiJa3A/K8jtRVGjYZJ4nIxLJjoiL9n9dcPq1Que9MAyppvNTDUog+SRikmM9rLCX5PtxW0VpQCyvpVohXzJMG9pyWV8Y1RemldTxuG8/MiUvgPIXJcprEhwYfrupIK7qj8CRqTcUygcSAzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR6KyRqP3UGkGySX6vQxXEvYmEmEmfBf9oJhx5+YSio=;
 b=BrjDEO2iKmOndQ0ORDkWFlfXQxdWYNkCTH4+/Ain0iHWbogbTf0rAIZQYCJhzSVQJyV59Fqb/wa3ccd6EnU6hQYjhh3vIBMT4l5NQQ6t6XbVvt8Dkop6OGMUBCfcxwEUx3w/qfXD0m/TXcwpHBTrNVteYo7k55Et+dqHEPrzgfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:53:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:58 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 13/16] net: mscc: ocelot: expose vcap_props structure
Date:   Sun,  8 May 2022 11:53:10 -0700
Message-Id: <20220508185313.2222956-14-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d8095d0-13df-4621-c320-08da31241bd8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672BA8332187A3FBDEB301DA4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCb4LD+HUyGunOFYiQC9vzi0cM5RIIPdSvFmXWGfjDbvMnEk4jXdzREMfG35QYAzDGbcUmqukeC4qFAHWnxt9WJlV2wC3XCAsvkbswmvCS3Ddspid8hFgQAXuCIEEcMcfXVMoGKWEgMUYndaGL+X+KnuuOmbCr8AC28Yi/Ddlbu+gO3fG36dwTFTrCZlL14H7maot3xGnr0Rp3sFbWvg8dz7ZOqVqOUT10DCe/r9y5ITFYcu/LJUmhKwSqP7dyVhzWBidJ0V4vUM9MJf4wq46CdmlJAr5FqrShAnI3IlwLp48Y4ZTwNXTOr3u/BrxN6EG0WFD8+nLNi4a8ko8YzjWnLIt+/+PcbIEEQOKX8qGblfSa43h7DHEVYwG67zWlkgViNLN7Wt2doTami9XgZJR1iuKusehz2BCBlY2Lh+u4FBe4pLbTe2kiLRgxF5nHB/OUM0cBj7xmmNUbz2NrwS5NvPy8XXL23rGvoSAInqYrZOCSQ0vLpByYsYo7nIbBK+OuPiT1CkIBWMVvDgYQOHTHyzqMlJogXOJQX58X0E0UW9JZTfJMQf/4obXLEt1E6lrOjSknU994G45e0GTBAwb9xslRXeOfBTbhwzqNZ8iF6YqpzEfWXkXpX5zTY7Yg7GfPaa4hA8521vi+WVcmwP/Ci8DSSWh7kfxQiKI7W3gGmTkYfsw4C0kTK6TFMl5hjKi58iJpu+UEm7ootQso+psQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9IXnJVxctbh6lFNGUX3Jwb8uB6nsBGXA5Vh+y/r/d7QGuBrt+SdciGthyCpQ?=
 =?us-ascii?Q?EJysiIhhm+EwG3ktl+1TPfhMvYU3l/ykx5e4ygHcrKod8sJDpp7De9pJ9yul?=
 =?us-ascii?Q?wncNBgkT5M3fJulGQwVjUqqqJr1l5Kkf4tzDZZ/HJK6PFMRYISImvWtm8Dxi?=
 =?us-ascii?Q?cj1MvpdsSCcxs0I+PlCQdatoX7fj0ZcTpEZsFofbFbZy8WBhCsU5SuaTO+F7?=
 =?us-ascii?Q?O8ybWj7MBpOskmbIAcNHcHX6cqvw9HYTADTLKuFEq9BMoh+zsGQJWqUaSI77?=
 =?us-ascii?Q?dvbKv74rkvFM59CfVHdI7GjKcTeWt2zkAQoFyNtu28TTjP6thBitHwvsUMtt?=
 =?us-ascii?Q?Y5N0c1hTWBB25kJhupVAyItvjU3V+4EKVeMF+T36atoXJEE/brHjIhbSmxCO?=
 =?us-ascii?Q?QrPNzZhZQqKWC/2dJrHpKnfC38aoN7H8i8C8nxYznSYMfc8gf8RCoKNlMm4D?=
 =?us-ascii?Q?Ki37wnx9/TtH3SIw5NeEVWqXrguto1+dSFn2EteRDDjFfnZU98r66Z3f7R01?=
 =?us-ascii?Q?gf088t1om02Gz2znCldiwXWlLOOwWtO3365hsTnXgMLbnwxvskXVV44L1cE8?=
 =?us-ascii?Q?5QF0BN440POSkU1SWj5m46zBC6i9Ver/HaofPMbl4DFMLyZqqrIdibhs92jI?=
 =?us-ascii?Q?w2lBRuRUQwJon5XRa4nIGVVOUZrSz5yk8wzLd9SmZyt1hYLa/ieBq9tNVaKf?=
 =?us-ascii?Q?M/x8axtVex4LkcFOtithjowuh3jDDjbn8VGGOGyPZv0O8cNuyt2QRpv8L2Vh?=
 =?us-ascii?Q?qdjcvEPs3DXqAgCugmja3JMCc/H0vasr2VYL1b1791F4gWyjeSwCMsYhqjyE?=
 =?us-ascii?Q?s0jT438gfV5LRnUPyU7l+vHxp19AtPfC45yFx1eSx2dQLXjXtQHBShbBlCv8?=
 =?us-ascii?Q?hIUTgIGz9vi8QZz0li5CgHsTfTFju4kUuzecEVbVZf2X/5syIwnjU2YVKSPW?=
 =?us-ascii?Q?Ogbjcac6lwGnMPRNHOaHf7w3AvUvSveRVtDtXjWhQIiv+9t312uN7Lw1hQAZ?=
 =?us-ascii?Q?nGjca/t75mU+sOV2ReXiN1zT6OrkqhN+UvxW95nYwz4tWOOX/siSIR8mVWui?=
 =?us-ascii?Q?Su1s6EQ6awbpVmPrJEfaGL2d8/Ir0URML8J5OGIlwz4+DW27Hd0ou6msgmih?=
 =?us-ascii?Q?TPXE6C+RhS97aG2b/vCrq3RoTb1nvCGsusEhCX8giYmyNHy71BwCUUmsfcYW?=
 =?us-ascii?Q?kB3ECeXd+p2pTjajeD22kQUng+/PVYjwaO3is1wnmMGRxxpqDseBWVF/i+Dp?=
 =?us-ascii?Q?9rMsnwsWsNVrSou4Qbb+EOjrb/siVZ+VsIcg626i2rvihLeAvUIvLrspEAHF?=
 =?us-ascii?Q?ZOp5WHFat4e2ljmflEUNAndCUaEFvIVM4bq+L6aDXGeoaFuVS//7rEh0a461?=
 =?us-ascii?Q?6O8N5iLH8awn3rrugTEHM3e3WAlbnSao+eI7nPi0Nucbe9MC51HlB+o1q6Sz?=
 =?us-ascii?Q?EeECqTmwhF8xLUGuOa/K++GAZrzZgK09CPAk/Dbd4t4HC7XlM8++LHC/ibgR?=
 =?us-ascii?Q?i9y8tALaeUuy33CIA8CcsddcW6qWm8qbFuFMgQcLt8LpmTSTpDbHzqE5Ti/5?=
 =?us-ascii?Q?FB4w6g38tb28278DUqFG4pw9TGQZ/9+lEf3oMrSWRsgsAnCLALKkYB9PRU/T?=
 =?us-ascii?Q?tBud0kom267s2shBVgIWrBktyxE7MMSrSc7WgwvYstMIXRF3YnlRtSftwQCW?=
 =?us-ascii?Q?jeWDz14WZQLGwj6VgWmLvGXzlp1F5icZzeyU1nukCVTqKQFpsg/Uz1zuZwJC?=
 =?us-ascii?Q?ia6/y1FR0uchnoDd2ZXF1R9Ej1CWWRdpAgiMycDlarAnxRLp6bOA?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8095d0-13df-4621-c320-08da31241bd8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:58.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDmOmLV09ee6BpGc0XbcGCDekx0Zq/jmbuIxneAMU6MnzIl2PRQHbLXh8DGjbU/KqHmDGNaLBAlUveiR9mPq3R/qCgmVi2FsQLLWjNWpGcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vcap_props structure is common to other devices, specifically the
VSC7512 chip that can only be controlled externally. Export this structure
so it doesn't need to be recreated.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  1 +
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 7673ed76358b..6191bca7a9c4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -161,49 +161,6 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct vcap_props vsc7514_vcap_props[] = {
-	[VCAP_ES0] = {
-		.action_type_width = 0,
-		.action_table = {
-			[ES0_ACTION_TYPE_NORMAL] = {
-				.width = 73, /* HIT_STICKY not included */
-				.count = 1,
-			},
-		},
-		.target = S0,
-		.keys = vsc7514_vcap_es0_keys,
-		.actions = vsc7514_vcap_es0_actions,
-	},
-	[VCAP_IS1] = {
-		.action_type_width = 0,
-		.action_table = {
-			[IS1_ACTION_TYPE_NORMAL] = {
-				.width = 78, /* HIT_STICKY not included */
-				.count = 4,
-			},
-		},
-		.target = S1,
-		.keys = vsc7514_vcap_is1_keys,
-		.actions = vsc7514_vcap_is1_actions,
-	},
-	[VCAP_IS2] = {
-		.action_type_width = 1,
-		.action_table = {
-			[IS2_ACTION_TYPE_NORMAL] = {
-				.width = 49,
-				.count = 2
-			},
-			[IS2_ACTION_TYPE_SMAC_SIP] = {
-				.width = 6,
-				.count = 4
-			},
-		},
-		.target = S2,
-		.keys = vsc7514_vcap_is2_keys,
-		.actions = vsc7514_vcap_is2_actions,
-	},
-};
-
 static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ocelot ptp",
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 2b75753da4e2..d538b05306f8 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -677,3 +677,47 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
 };
 EXPORT_SYMBOL(vsc7514_vcap_is2_actions);
+
+struct vcap_props vsc7514_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+EXPORT_SYMBOL(vsc7514_vcap_props);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index d2b5b6b86aff..a939849efd91 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -12,6 +12,7 @@
 #include <soc/mscc/ocelot_vcap.h>
 
 extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+extern struct vcap_props vsc7514_vcap_props[];
 
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
-- 
2.25.1

