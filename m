Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD269C078
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBSNyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBSNxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:49 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0044310ABF;
        Sun, 19 Feb 2023 05:53:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fg5z8ku9Nwqbf2bais5WEkN4x/SWAb/T0Khnc3VKTARU4RUjWFLcB4BmFBZxUoCFuVlUJizlwvZZdJiN7NeB9qHYHAwamMyl9tjUdjJXxPjL/kLX9RcDYDlaU/mQgHUPvMDlYj/f+su6a5r5JUU609YBV48+7z6YZLz9HnY+5Z/f1TGGT99xxA6B+QAndite5rkB+0JGbkP+Lluw7fA27I9NxtTaoqFjkoadGrO9LbvCmfJexFNApSxv01szEb6AoH4SFnRFkZC06I/ndqrr4gV4wp7RjVsGr4y3MDin116R0ZlVqs+ciqtWH5V2BoAD07FWHd4plT8h1FZp8xW19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prtL8wN1DAe1pCU6JlXiJfEihnur3t9YaBWwfb5Tv5s=;
 b=DH453lu6I0ifadvLPIQEOd25CMfmRwG3J5QxHolTxBUNpyQL0bV3Fi1Te68tEhn81aZOVrijTssab5UBtusu4rBLpER9XammaPp4yDEPxtRqZJiFa9I9tqLvOU263vFngnPXC6bS/vhs9FRUvuG7Vj5/4vnywP5pWIEqq01/17nkHfJRBLCrZDtU2jleIu89vzdwLF/AoR+bivo1AodguTcMIRm7b3bCitDeFhm2bce4okFrHGGAqftMnRkK+TSSeu+Fr5ishk6xzQD9NKw4C6JF6urZzBdJm/c/a9dfi8jrI10aUVFNgJiP8LNsY/ahj1qY5DAagiBLwVgnK3F7Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prtL8wN1DAe1pCU6JlXiJfEihnur3t9YaBWwfb5Tv5s=;
 b=LzhRnaC7BR4L8GeJ1eX4jx9nzT2p9JBmXUwY8eyHG9FkTVGTEStX4DAgLDG8SFzuuMKbIUaFBf15Pgl46VX2VUpov6G4rB3eZsNUWIK5g7c1p264B6S+eOwz+rxn+QcHjiWIgW8IrpbWwF4gXVdfUi8TO6bz7fApjj9NWq70f6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 05/12] net: ethtool: create and export ethtool_dev_mm_supported()
Date:   Sun, 19 Feb 2023 15:53:01 +0200
Message-Id: <20230219135309.594188-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd6d318-746a-4f54-ba83-08db1280b8d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akJ7DMOQ0UOMVBD13CbhdiTDx/8s/JInmF7cpCVVbNpya6ATcfkCA+zmnYG/PFM7V+6ULs3ij2i+I+fV9XMLPpMTX/+bHYS49ivkonKdnHO/GfKPJtm0tEF43C8LVxA6cGh1l/3E1pVuhMQkXaGR+OC3S+BzHIguGTXy13xpfJOYxhESVOIAMbJjmQtyFBj+0/l7afA6bx5aK5kyEnN6OcTB0MXJxJJ9honS41W96EWQ/O3yHdZi+5ftpfq8yz9HME72N/x5PUNg/6obKmogteJIJy0KX2fSTtjd9z1J0v1US4xd/E4kDsRYcZU1z7agk4C0QTgS6TZ+dvL3eq2KJuQn4XrIfNcngH9ZoJHGjjE+e5ZUh0MPTfybY8z4EIJEXlc3GwueDGQFzaVIUwG41JyDXyXAgij7rr+89v5vHNdy9ehVgEs8B+Z57CXQWB/JEP+UPTJVM6oP2lf0Yibgrla6dOQy40+qezqDTYclulnCLY0Iv+1Az6fj350hHYzVEmcltDvXLl7vBZT4GhwPciT+Fwsny4yDcVpAw4PbR51AEovIR4DxKXpED+eKHCVJpVhdt18ol3V4L0VqTWyWIQECsnYEDHq8wRDRpGgxYC/cgP0FQRyYFEwihnAgF0mcs2fQYtxsMsXj8JwmoA3bW31P3Dg1MjpZTNnsdlyZcGhKFvZ7aH0QDi8lmSnsWGEAkMR8Dvw1OIrnCAwFMbFa9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fjTciUMLOQ7h6Eq0XyP5/IougvAJs29Q/R9XQHfsRnQ4s8mHIhhBdaxgtq5u?=
 =?us-ascii?Q?SGKnY0oMbIcLIvoBfjPWn8XZ6hOpAngnxN5eSrezUXS3/ExfASIbJya+OZh2?=
 =?us-ascii?Q?oihC6pJFjLO5JYoX41o5VhI+4zfj1cOWUnohru8acriMn+ET919PqRvI3PuX?=
 =?us-ascii?Q?/a72Y6AEIVM3r2STdZBAyiC4zbfzV1Cv28SjohkCgfL9uobFKqexscSkY9Kw?=
 =?us-ascii?Q?2ss5wMYqJR9vq6EHFB2iWhEdasney8fsF11YgK4MZqFK4C5LkftWSirxey+G?=
 =?us-ascii?Q?Dde8K36darnO8l6PmsmKu+91rPktvFPVJjEyNlX0OvOsX+mWuM5r5t4Avjun?=
 =?us-ascii?Q?YUSfzZHuYSFnuyr9qwP9GZnAaaLjS+540Gy7nA0iMh42533ZKnIr3MsBzM/W?=
 =?us-ascii?Q?UkNJHLqlQWxuLN/C5H6VgaZinEJ5XaG9ZuBmFUS/BDhF5GCsG4Ko73uDD/mQ?=
 =?us-ascii?Q?ACf/jBD+rC9u+AshcXqCQhQ0oQRgK5WoHneUVkalxrytZHAXp3Nyx6VgZs/g?=
 =?us-ascii?Q?6sDmpeV2rLhIDBpHYLMc3vKzcLhL/Q0mTDD1NxZsT7vMmBeh8AvwBjRxmpGo?=
 =?us-ascii?Q?WeNFhHFxNvmR2c5N72qyLSvTDWMZnrLRdI90IZ5RJlw56TWuMDlXxJ7J+eqE?=
 =?us-ascii?Q?Dxeh15w02VsqiRifTTC6K+vgGncgt97Nw4HZ9AprO0m+E6nlx7Zv5ODFJxgl?=
 =?us-ascii?Q?HdfZ7+kqdGSLcbiGcONt3oLV9WJvA0MZW8UWCZRfxRS6TP+PtgLAbB9/tAeC?=
 =?us-ascii?Q?Us2OUWqnXdUYzxag/N5OyXQBHETRS4Q+5TPX6ycLZVrhCA1Qh1uIj1efq9sA?=
 =?us-ascii?Q?cuvdiXyLVXrnLAIsMyyUS1d96rzIk15xOMEY6OogFWXxKN2M9qT20GgOtv0/?=
 =?us-ascii?Q?+sxR2VsZpi/vE1dZ7k5TBif/Wv/lfDY6zb+JB3pkpAkqGAxJ6fWIu09WSwQj?=
 =?us-ascii?Q?z7mmawhukvtLdcILf+vTh3ZqEeQSQYoREcOe710wclA/HG257lR4mV74480G?=
 =?us-ascii?Q?xOsiS/NR/wPSQX8K01KjgRwpZZ+32ISzf3l+ehu8w5SzlJee3OOxa6jcNqRx?=
 =?us-ascii?Q?Uf4asqDtw/Vd5pgPrQcPrzKUun7P3cMNUawBkxO3NMKaqvmw0FCuocga+e1B?=
 =?us-ascii?Q?92vLfeYJWfBMTpdiyQ4O+1Qcz4fwQgueqRG8C0oRqL5T6FspPXMUnYs9dtbp?=
 =?us-ascii?Q?FFP458Pw6v5TtsDQmtbcsAKLG3Q1mogCtwab3GQdjAd3yPt14y/ig4SXKhTz?=
 =?us-ascii?Q?SxNJ7VfyimdlO9p9lyMY+2iQspJ8HLFqloNbog4wLB+lKAQcnmtDlvRi+Ljf?=
 =?us-ascii?Q?PkBmCEKtp4qrZiteyNAh1j0UkGUmEEi693pvRnHjqelvNGFAmsMr35jgUUNu?=
 =?us-ascii?Q?tWX7bA11ZlQt3Kh7BvIv7OxnCAkOYhhk8DY6ZlFgZGR3HIbUX3utxdFsG+cM?=
 =?us-ascii?Q?CFRSB+KolAUh3/hSYC/ncErRcSP+SKl3Gg+l3zqxT01sO+/1bg1yz7h1ho3t?=
 =?us-ascii?Q?xi9bfN2wA1IQlxqLDg8eyDIv4xRzmVLRxgPP7q7rbuicKhJX/8QLyndhTNhT?=
 =?us-ascii?Q?5OKyXvAj3uDw8NL1X9PLL6PfOxMDZ6Q2zOsimgPe4JAIFXKrlEZzFKLVjCvN?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd6d318-746a-4f54-ba83-08db1280b8d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:47.1463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +k7ScDop8URlZzzDkDgH9pYRjcDLXocvKX7XQ3GyYo8xj2ZsLdnwu3kefH9X4qOnabsbtEUmZLnEXVF5LJBxgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a wrapper over __ethtool_dev_mm_supported() which also calls
ethnl_ops_begin() and ethnl_ops_complete(). It can be used by other code
layers, such as tc, to make sure that preemptible TCs are supported
(this is true if an underlying MAC Merge layer exists).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- don't touch net/sched/sch_mqprio.c in this patch
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)

 include/linux/ethtool_netlink.h |  6 ++++++
 net/ethtool/mm.c                | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 17003b385756..fae0dfb9a9c8 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
+bool ethtool_dev_mm_supported(struct net_device *dev);
 
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
@@ -112,5 +113,10 @@ ethtool_aggregate_rmon_stats(struct net_device *dev,
 {
 }
 
+static inline bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index fce3cc2734f9..e00d7d5cea7e 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -249,3 +249,26 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 
 	return !ret;
 }
+
+bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool supported;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (!ops)
+		return false;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return false;
+
+	supported = __ethtool_dev_mm_supported(dev);
+
+	ethnl_ops_complete(dev);
+
+	return supported;
+}
+EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported);
-- 
2.34.1

