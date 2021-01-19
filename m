Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB21E2FBB47
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391534AbhASPed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:34:33 -0500
Received: from mail-eopbgr60090.outbound.protection.outlook.com ([40.107.6.90]:16515
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389820AbhASPKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVJrm5t+Gt7JtUGFP8mCArpcEd9aiqtJwwJldbm5aAI7zJZpINRQKenyg2K3dmgRg+J7hWFIA8All8lswHRpfInB3RRVTj5LN8P26q9XShSYNKWnMtcQ2nXNBVTFdhC6tE1xgQSNh7QoatG5Vnh9irrfjB9kSYfKfpMUb7q+/cx6ZBX+tCyriUY7ior7qAFMxOF4SuUJ5WSed1dmF+0imiWpPCf4Itym/SBvqbPzeCHHapzZ4pLCXF73mNB0A6UuVLrdiebJRpMyG7z+qZyDaYAzUwdKzwQ27pihQoexSAYdNu8+LMZ/I7N+USjIT2iUjicN0zlcqMb0xK/zosHZ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItH/HTFNZVEGP/zDWBWtWig0GC2CV3FacBzzAFllqpY=;
 b=a1hfV29i7JEnzMj5JHtCfCP6OKAGoDHga1WV2gIF8eD8uHr5Xfgdh/VkroIcanzaZygboL1Kvo88MoiAh66+4WZA+0S9W2j3Orv8+3piXS+CMLoqKLijNG60Fbj/KarfBeKzaviHqBNtNKvJQvUGZ/Ypb6o9P7MUZMGjrTVK2Qn+gZPDfpUrxytFNUDuTgfGk9PXBBfBEHyRKeDPvcGGLZQrTnHzASN8tpWALRnhS7Nfh46InJ7oNKutPQi6bVgF4mGVKe3SoSjEFvrJpEd7tOB9QmObK5o5A439ZE2SLHLE4O3jj//eU5MY2lZt9lCsA1le5HECi6VfdawXzYNUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItH/HTFNZVEGP/zDWBWtWig0GC2CV3FacBzzAFllqpY=;
 b=lTOlup61EEHfCrFxC/0Wvp79XKS6U89cIeHZ0hwF8Vi7TDz0GkdMANX0CL/oVbv3uzsanXCNcinfIFxn54hu59HDeEmBPyJz2MVkVKTF2V0q7Yh0L2i/KAbJObxSKTRCCeKJpAQdbgZDDICPxrtsRPsbHplFylBAm62JmE/Btgg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:14 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:14 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 09/17] ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name} properties
Date:   Tue, 19 Jan 2021 16:07:54 +0100
Message-Id: <20210119150802.19997-10-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3363d313-f8ae-4898-da4e-08d8bc8c2e30
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB36815A97A4829B1E137213BB93A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fSHZ5nWx90nCxvhHxteBdWMIYfv4QO96SFhGlHAbe+0PfkMxxIz9GjZoH6dOmL/T6a2q0Mi9XtSl1x/KD6rbYImWuoEZfqIX9CYc/VfGGsz2AKz64x76VZ+t8zafSi6Av2kChLwWSn96MycvIfUV0nutIOGf/9FcmhkhDFCXR1B8gvVH+JrIxFlGBSsJLxytDHWu03zA74ZoIpvI9sy9fpTEtLBHGqL1ypRLvf484RsgkkoMqb5VdeBXV2Jy8EXcglI4I9x+y18+t+HrrychDoGgbHnbpk2WVOqlBoNK90yUPEQ2Ko9hUqzX3SIeUkZTT3xd0pl6GBgz4qAUnCbF46h9pix7IhlKLJiOp9FEPdqqfg8WqQ2U2kOvE5e9e/4E0gPfALqJ3YV29/nOQg6ZKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PjVm1KT//902IVNN6bKJ1NlBY9hkqyVOnfK/sMQRDLcxzutUJbZEOOCR2QGa?=
 =?us-ascii?Q?Ja4CiHV/WZrX/AlK0rn5pq/IGYzbp7w0NBc2Qc4jqMWhoYMs81LBYsXLGh1T?=
 =?us-ascii?Q?0SXPJtLkKpgz2Zlp1D6D9ZS2Rg/p70hUzWSB1q5tfYR0AItUZhl9Emn1oSGa?=
 =?us-ascii?Q?tGLgn/yEqdwAfT173VppSYbQJcWA6k861m6aGM/ziseZtoy62OriYzrUGv03?=
 =?us-ascii?Q?Ta8GNx3skwTCuFDGYl1IpykYdvpBJlcPqQTsLh+DayDPjDWzrVES/yECT+JB?=
 =?us-ascii?Q?Ie0ckXyMiwRiGSSowIwD5eM+RuP2e2RvU79zNxmecSKgLl6UX8l62gi39SCL?=
 =?us-ascii?Q?suNJw0v0Q4ldjg5qEqsL4iJsYFOLFdOwI62VZdDPSAVAlbahCjM998S5BMiN?=
 =?us-ascii?Q?7F5HRZmAXNsAFlExAMJjlQbonWap69bRmgWONkx8rtFoFwHWcbyajJzCLsQ+?=
 =?us-ascii?Q?rUDBuErImzK8qokU53c1MB+Ajg1k0MPTVP1I151fqduYPlFODN+MeFG7Omsl?=
 =?us-ascii?Q?HeqVFrFVmQ8aVyGkF4yBgUj8AOzX0JjZ5dQA1Q7vEsTNMBNSK91uTscZs85k?=
 =?us-ascii?Q?dgVdyYO5ZdQ3rDgei3m1X3r0cgd6o+kfWGU/OAS7vqX3rAGN5rPNPSOKIIsF?=
 =?us-ascii?Q?Xl/S4JXkJfDeBoCQZIJSAVmFsysZEqkwg99yhqp0YEhILTIpNU5+rDYvoAE9?=
 =?us-ascii?Q?W1y5IQtM4IGy1f8Gf4OBz2Wzgnoqtlc1fJiXvsXb5JJ2Sj6aepVatS9lmFOe?=
 =?us-ascii?Q?PL4gW2I8kGbHcMfNOWvOVHv4AUV1uEc5dW26/YBs02OFwjixHVQcdJbTpfUb?=
 =?us-ascii?Q?xhX+MUEchg8PlMQpBXWRAV0gpW6/DRcvReFVAfck7gKJrovVEQKRXTJ8Ddkj?=
 =?us-ascii?Q?BHHqLRqnh1WV4JsNq8cE0mXFysdCCvqaVh393AvTbMvQu/t3PIhm3N1LrNdA?=
 =?us-ascii?Q?UmQzQ1sP56t2Z3xmWg4L1PFhlDiGPjE+yxkUyByK3SIudS2W5K8aOP2isvhu?=
 =?us-ascii?Q?eYn0?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 3363d313-f8ae-4898-da4e-08d8bc8c2e30
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:14.3274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 633LjqERNO5ei8V/03R8FhcpuNNL00NcWjDzbk/FByJIhHDLQGp7NKDNX9oL9kQ0HpHbW3bSrSaMJZgaFns2cN46ykV0YsQ6LrQlhJzblNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the code duplication a bit by moving the parsing of
rx-clock-name and the fallback handling to a helper function.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 80 ++++++++++-------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 75466489bf9a..75d1fb049698 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3646,6 +3646,36 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 #endif
 };
 
+static int ucc_geth_parse_clock(struct device_node *np, const char *which,
+				enum qe_clock *out)
+{
+	const char *sprop;
+	char buf[24];
+
+	snprintf(buf, sizeof(buf), "%s-clock-name", which);
+	sprop = of_get_property(np, buf, NULL);
+	if (sprop) {
+		*out = qe_clock_source(sprop);
+	} else {
+		u32 val;
+
+		snprintf(buf, sizeof(buf), "%s-clock", which);
+		if (of_property_read_u32(np, buf, &val)) {
+			/* If both *-clock-name and *-clock are missing,
+			 * we want to tell people to use *-clock-name.
+			 */
+			pr_err("missing %s-clock-name property\n", buf);
+			return -EINVAL;
+		}
+		*out = val;
+	}
+	if (*out < QE_CLK_NONE || *out > QE_CLK24) {
+		pr_err("invalid %s property\n", buf);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int ucc_geth_probe(struct platform_device* ofdev)
 {
 	struct device *device = &ofdev->dev;
@@ -3656,7 +3686,6 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	struct resource res;
 	int err, ucc_num, max_speed = 0;
 	const unsigned int *prop;
-	const char *sprop;
 	const void *mac_addr;
 	phy_interface_t phy_interface;
 	static const int enet_to_speed[] = {
@@ -3695,49 +3724,12 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
-	sprop = of_get_property(np, "rx-clock-name", NULL);
-	if (sprop) {
-		ug_info->uf_info.rx_clock = qe_clock_source(sprop);
-		if ((ug_info->uf_info.rx_clock < QE_CLK_NONE) ||
-		    (ug_info->uf_info.rx_clock > QE_CLK24)) {
-			pr_err("invalid rx-clock-name property\n");
-			return -EINVAL;
-		}
-	} else {
-		prop = of_get_property(np, "rx-clock", NULL);
-		if (!prop) {
-			/* If both rx-clock-name and rx-clock are missing,
-			   we want to tell people to use rx-clock-name. */
-			pr_err("missing rx-clock-name property\n");
-			return -EINVAL;
-		}
-		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
-			pr_err("invalid rx-clock property\n");
-			return -EINVAL;
-		}
-		ug_info->uf_info.rx_clock = *prop;
-	}
-
-	sprop = of_get_property(np, "tx-clock-name", NULL);
-	if (sprop) {
-		ug_info->uf_info.tx_clock = qe_clock_source(sprop);
-		if ((ug_info->uf_info.tx_clock < QE_CLK_NONE) ||
-		    (ug_info->uf_info.tx_clock > QE_CLK24)) {
-			pr_err("invalid tx-clock-name property\n");
-			return -EINVAL;
-		}
-	} else {
-		prop = of_get_property(np, "tx-clock", NULL);
-		if (!prop) {
-			pr_err("missing tx-clock-name property\n");
-			return -EINVAL;
-		}
-		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
-			pr_err("invalid tx-clock property\n");
-			return -EINVAL;
-		}
-		ug_info->uf_info.tx_clock = *prop;
-	}
+	err = ucc_geth_parse_clock(np, "rx", &ug_info->uf_info.rx_clock);
+	if (err)
+		return err;
+	err = ucc_geth_parse_clock(np, "tx", &ug_info->uf_info.tx_clock);
+	if (err)
+		return err;
 
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
-- 
2.23.0

