Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3082047260A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbhLMJst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:48:49 -0500
Received: from mail-eopbgr1300115.outbound.protection.outlook.com ([40.107.130.115]:11520
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234200AbhLMJp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 04:45:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKOtLdTr82ldlwa2SRvFL3ZnQYvtthMODawEB5V2hERavKc13WvPYZSDmnhErcUcu4nGPTRrxaYgE0QOabXCrb/LxHXfwip36XT8Tdh3QRdbm58gx9C7JfsPRCvFogXTpuFtH3BbaODMxmVHShaG1a7XvuiD2hifxAQ9o8cmiaDnru311norCcDjWkeTnqOUhG77lZGp9KWavZmd//MQsIULK/9zb7YZQBzBpo5EQW6uZrtJcuiYdl/Z1N6eypSVZz6G3UQjNdz+w+3bFvUW2RTDaQMeFqzAmgP/KaS3PBt/4isnq2nCV5R2o1pt5ef52vVEIOGmaVEJviTAs8CLLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDFbsUk0ukImBkI6oPQhEodsCA+057qS/GQ/T8ityKU=;
 b=HE5i1zGP523QAia4FbBQzD+8eYd4zxQN0j7SL45Rs1oL1PEQCYsS8NEPaZQrNOYAjNs0+fn8MUn/bMnXxPUwnnEcegdDqvqwJKpMYyNAKOCPYhLibwlLgZZW4RHw+qCN38FIvpge5/8p7+wMIyWj+UfuJ0H3C4szg2PdmflvHdkzdnopucCGRF3hwbZQ+2Uaza5V3CwZ13etGBcbJT2rr1BiGSqOhuy5rhKWmkRqKA0aYwE4O4PznJGsvY5KPcULbEktrIra2rgY7aTRj1/JmPPjvSRGTZ9b4yBh1ITUC3vgGRX/MTCxY3eqFT+Imwmvxyt3vJq7GppJoaxcqLatjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDFbsUk0ukImBkI6oPQhEodsCA+057qS/GQ/T8ityKU=;
 b=OcQZ2T3s5+APSzlHeF8PHnpIvvtuCz6FUlKOfY9OF7H052LGCAAIty/0E7GgNek8xyZwzKp3K6PJuzmmSyjI+X6khyhKhmeQL1KT4Ef5l4p5AbMg+rNedF4USh7WuF10p3dEWsRyT8Jh258IsMwGoCJNgChSN+iUw1+yQ5l728M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3050.apcprd06.prod.outlook.com (2603:1096:100:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 09:44:43 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396%4]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 09:44:43 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: ti: add missing of_node_put before return
Date:   Mon, 13 Dec 2021 01:44:36 -0800
Message-Id: <1639388676-63990-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0070.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::34) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3749ebd-66c5-474f-764b-08d9be1d30af
X-MS-TrafficTypeDiagnostic: SL2PR06MB3050:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB305025550169E3B9C9ACD41EBD749@SL2PR06MB3050.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmWZ+ESHGw1UZ/n23RUp8fv5cdyZkDl97Rr6egy3zvbDOXADN+y2wOUdid8lmAxcSXWgBFBfXdYAiLigGEe6tdRmbEja/Lj+yJelmP4RlKWX0mBioPs+sr728xuDH9OiAPfIrfBQxWChEONhNBhdVUEnO7Rm0gvSteYKOgywMrylyfCZWV7SqOAd+di4GTnVwXwdLU7jA71EA6fQMYpFcSHbjVWQf7S3ZYyi8FB3UVn+VmO10eBp0W1VxNn19dshtZ9kLxlHPAkLpeBNBN1nNKQaNGOx80FYzLexRBtnBsCg8K4hpZcMZF+En7Nqd9/JJy3B1GNy/w/MPo1yORf6bNMJb23qEgSU7IoW1io6YxoAjgXSP0Hao5kE4HOatRWVFX07jN7Qn2xFoFe3FZUFeAi08Ny/fawJvSIG4yYPqq5k5DSJ65wm2FkQ6uJbyAwl+ByGr8b/8RV555h9OJqlgMboeBakS1xf+WhXptwGXylRanNZq/eD7IpliQtDIg9dcyfIpAXh16oZ6qIntYNCU60hOfz8zYrZoqayNEFR67k+gg9Y/uo8eamJSE6PP4N+6/dMYFN0hJ7knSolx3YWaYUD3bSamTIna7ps+/YUtQPBYJ/zrihSTGtOfMmgogH9aEVCYh7kMbuo6J86trtcq0k9c3f+BIp48c3gtF0WePQP722Vwy90vrr/jA7sZnnl6+MYXRA5MrjEF3Drs9JMgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(83380400001)(52116002)(6506007)(110136005)(2906002)(316002)(508600001)(26005)(186003)(66946007)(36756003)(107886003)(66476007)(2616005)(66556008)(8936002)(6512007)(8676002)(4326008)(5660300002)(6486002)(38100700002)(38350700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBJMLbuI/2t7x/nhBUtJJOdysZcKQzT+68uPc38eyN+54Slk5EF4a1FYmcXC?=
 =?us-ascii?Q?197oTd/yLOrjlRQ+XVEalOQGvM9oUf/0JhHkASNVpm+z88YkBn20NQXBVCLe?=
 =?us-ascii?Q?K8DSbfe7lAJsTQfgykGJ9/kJlcvgo1g+dI+YS7mCGOpNR/BGbiuaVNNDZwCX?=
 =?us-ascii?Q?HM6OJV7gr1mDjENzEN+AohcVv7tgAp13Cj453wm2Xu6i9ZMIqXu6fX2A++tW?=
 =?us-ascii?Q?cMPEd3n+wSR0mnEeJWy4fu0ucQDnM04vlNjulqBUazOm1ks+78xuQnCoRDC1?=
 =?us-ascii?Q?Jy43HhtGgpBDkLYq8rgqLDAFYlYjCipAu5if00BppTRoIFaYWXqGthFOk9fG?=
 =?us-ascii?Q?UQlpVMNJ0yIrmIjP029DSqfslXSKehnKvjWPxJuanAD78chefDhLpDDqwCzL?=
 =?us-ascii?Q?VWR25VZoF3ED95jAIFYBX7Gg3LMLBqadV9f8aFIaXDm2wTQK3MqqobJ/dYl9?=
 =?us-ascii?Q?Jwcf8fsXovRFxxsv46018p9k40yj1Lokg8jaAbX87N8ZlW1M8MY8+k39Ra/7?=
 =?us-ascii?Q?RH4I0YdD0ouVup8c5f0jEdMpamGuuW9secFHXL1GD2g+p6RMp/SO/PtKGPwA?=
 =?us-ascii?Q?NcUiaa67sF4VlHDyAoKQ0cR9DM7SoWd8jItBxrG/K43b20/XS6F8Iwmg5uaU?=
 =?us-ascii?Q?lpV7/5F1nkRnew1aVXNGXd/W/EeSlzIlCem2ttf8KAgChus1/3NNCLNuqHkJ?=
 =?us-ascii?Q?NCUIk+Hf0sDjh32MW5QMWENJY1Xz2DcM9mHYa0Fr/Si0sIM3eC2lfar0QKED?=
 =?us-ascii?Q?rBK7oQAlHhtxDbkLI0U96oqv/5JYTSbsGEwOZzB/fSk3kKW7w3WrYBIEDmlm?=
 =?us-ascii?Q?NBF3H2+b5FWD0sIAQn2Vajn5U48to74wr4iM5O9UQ+lbXmlnp/wMK+hpA2H1?=
 =?us-ascii?Q?jDnr5XuFMu3dZe4O0cpu3uET4W2DpEJwv3acJhKHZQXJXkDDjPcjI8h6dxHN?=
 =?us-ascii?Q?kbWJgzaghkSwQFxsEbwYVXQaVGKVNIzvIYBwmGtjE+P3ayqrMoOrcuT5IICH?=
 =?us-ascii?Q?8Lr2IYVyyICkqa7gReSLtDkCkAl233n8ef1z/uJl15iQvSLyXaV5UfVRsDjN?=
 =?us-ascii?Q?lupM6rGRiQe7oBJmaegmB0HjZq7hwvg6ugtWAvcqATIC2DOnjMVfMYI3AhCB?=
 =?us-ascii?Q?hA4Dx5o5uivae4iialckWWBnjUhgOikhVH1imZoqZciCeCgZTgne4w9Zo3Cb?=
 =?us-ascii?Q?t057SeW9F368Vzap70BSfIdvDf5qEiW9zcTuzaKpGb9gytG8hG+1B/B9op79?=
 =?us-ascii?Q?TiDq/zyc+Ntvt8gc6CACVuiK/tvJig1QA3OzGvaCD3TERCOIC/rvWJ+b3MHf?=
 =?us-ascii?Q?AjyEXgVQhpQ3HXD0WNU2uwnB74Cz+bLN7w2PnkZA83KBHt+GHvsUDeyjgbwp?=
 =?us-ascii?Q?6R35hlgKWG57zyT/drBYw3iGCpSaLFbe8AchnT/xapxKvENRz27VrHeS7feD?=
 =?us-ascii?Q?2t74xgH80pHb8YpePUqtLWaEri7PiJ8CY40LcO8DWz6NZSXZ9ixwWi01Wd76?=
 =?us-ascii?Q?sAqoDbRhoAkX5eSDo03k6Sb1YDwsKHE+IcoO+mFrwnZbeZhmarxN6NXkvzRu?=
 =?us-ascii?Q?Vu7kety6PS/ABLm3/t7ODLHvhCkjd1Dv9mZFvpYkf1s5tckU89ozA32x+pJK?=
 =?us-ascii?Q?vYzKXM5NGPZDwDa64+KV4XM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3749ebd-66c5-474f-764b-08d9be1d30af
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 09:44:43.3538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeNvuQ8Wfy0tLv/uXziOh/k73D9MjRNX+KgDQO8dLf+h0w7t/jGKJgJbxpSQDRhMS64jdwqkI72VAPdfL7MnXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Fix following coccicheck warning:
WARNING: Function "for_each_child_of_node" 
should have of_node_put() before return.

Early exits from for_each_child_of_node should decrement the
node reference counter.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 750cea2..8251d7e
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1844,13 +1844,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret < 0) {
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		if (!port_id || port_id > common->port_num) {
 			dev_err(dev, "%pOF has invalid port_id %u %s\n",
 				port_np, port_id, port_np->name);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto of_node_put;
 		}
 
 		port = am65_common_get_port(common, port_id);
@@ -1866,8 +1867,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
+		if (IS_ERR(port->slave.mac_sl)) {
+			ret = PTR_ERR(port->slave.mac_sl);
+			goto of_node_put;
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled) {
@@ -1880,7 +1883,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		port->slave.mac_only =
@@ -1889,10 +1892,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret)
-				return dev_err_probe(dev, ret,
+			if (ret) {
+				ret = dev_err_probe(dev, ret,
 						     "failed to register fixed-link phy %pOF\n",
 						     port_np);
+				goto of_node_put;
+			}
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -1902,14 +1907,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (!port->slave.phy_node) {
 			dev_err(dev,
 				"slave[%d] no phy found\n", port_id);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto of_node_put;
 		}
 
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
@@ -1932,6 +1938,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	}
 
 	return 0;
+
+of_node_put:
+	of_node_put(port_np);
+	of_node_put(node);
+	return ret;
 }
 
 static void am65_cpsw_pcpu_stats_free(void *data)
-- 
2.7.4

