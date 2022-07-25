Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A43580166
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiGYPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbiGYPOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:14:09 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BD71CFE9;
        Mon, 25 Jul 2022 08:12:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgY6lATKK6QuLZI5h0V1N5X99h2M0akkY+TXn3ZH1qk1PzuPG4BPP+1JYRcHoiL3T4RfUzzNcHJxRq9sS+SwqqalfF7Mo5K5hRwmpRBD4IWfntPD4Tid3OowPY8U/tMvkR7Bw6IQGDanwFcAh16PzLJykoC2a9q7klux5ApcSGyjBFRa6ATdNsu4MNQlWZ5wywYdA8YLtPIek8cB38cbQUNGK4ONc+1PWQjp+59VoQwEmY0x+oqtJTEXYVJUwPPvdFo0eDMn7z3vWt5iRRRbaqfqigEw/h0/AUQmUyZgAXS20DAuGJ0qDIaugA4aGVEoYc//LIixp0ymta42dmUUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xAMr2dOIXZXZY3f2SCd8tPIKgnvauVh4jSJsISHwSo=;
 b=WC0DNC0PI48lW8DaAHcmbnPq1YBmZlPCHMSq0vHrAMjXnpHyHUoOit87EeAZ+M56CZFzGqwNACVuHdJxhOyqTsa3E9k4qll29/F1hLh4SCZ9g4l5ml/XMAGfoSpMuH2OpxZKyr2N+in1bsra6AleQ8fStOvZpbBLrkthKjMhmu8jWHdd2tRiTdXVVqxOVVpMLUXvdTsOnMTBkjDxSQ04+PKEi/4IPYVM03h1uI3Bv0sk7SemCAp2PUg9PhL8Et+tMujGZvc7XevbVdl95m8AOnKjW+EzvW/Dmk0kpAOLT/ja6IqRKE50kq/CFuD6WIZ3D8wHRLvNPbCppn9lf4mn9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xAMr2dOIXZXZY3f2SCd8tPIKgnvauVh4jSJsISHwSo=;
 b=CY7CrGyF0MfvqmvT6vsB93e8WWam6Nj0ehu+Nzsx8CIgIdeT/SQZMW/X9/7EVROO52QfsOq0XaDi1sm+QgjZZX2LJEHaY9o11S5HOFt9yO+hGyW2iGkDAncd/zF+xwZ6E+4f9KSEtPjs4N/fWSikBoPpTkV9JDR2d4Q6x0y1gtg4efO3HvR5df+ryV3u1UsY82PzV2Sb0Homl2YWRDKtXuHCl3PwHydc0UWcyrK7ZoI3N+tsUVLNMj6F0e7Gw71mm/BG6ypfIezw7UXgt2g4LAhzGlgHTZK4zzacG7Htnuxrc0Ouqod0ox/foJxOyZFNg2aWkZqJuFVw07Y9DOyz/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 22/25] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Mon, 25 Jul 2022 11:10:36 -0400
Message-Id: <20220725151039.2581576-23-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b34f19f-a48e-43c2-9b84-08da6e4ff8f1
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 715yeHiTd2En1MJr9ysy4s1ppWCmCpPUSIrUVCWbic+nmCVqJeQYpoB1l52rSpRvYfzPXaB2wKUrxPD1LiJ1I1/MhItal/dPM/igZHrcNwC5QnJ6+Rnr0IK99599BWDkol042w/N2pkl2lQUNBVjGWI3CJGHrvWUE4DmKnP3huWVHGqoM8K/JHVoFgoHd3y8aUOfJjIOH/00L5ZHGna6c0/s0YOBOdHxS0wE7JQmDb5CgVqJXXInH9XDUulLV5pzLcyUQukHeb0O7oXAWF4whNA0Mos9m4Ftn2/z5Ljkm3a56C1e+xwPJooUIaB6qLhNhUr6Q3jPdkJ3usHBkt7FSW7z111GywNt5eIRZPDH3KLkSiNrQBLz+/yjYrpHl+jB+17eXK4JKpdoSdfZ2nzGSIVn23l4pmABstoF41DWRsP0wfcD3zSqopvXg8d6HcMr6P9gi7qNJs0WCpm5K7CL9xEHXUpfyWTeiu7gS7ZTfqkfTF0GGjPTpCrLoFrPRXayl9hDv27COGZiXox3ytGedEX9FBhegKmLzH7W1pwWaVDp5o9Il+O5NgsCde22xYDbmr16tLfu+9Wd4psjI18RyK3y6B4lbFlJ89PPKYN5Yldi2B7EDPu7YoYNTUX4YDSGajfBHx+sCXR3REZcGt3z9paSIYSi7DgT6jK+AQvZATNJBZUdXOBLJQ4/QgcHM9q94ZlPeh2/xRNKyTRgkEi3SAyIRIcVgMtPmQnUhcPqLGSeCB8khDWtVh07X0qkhSeL7Q3hKEOtTIaypDIvutzpQM+GCCErajNygak+GVMdeIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EzxypGXWSy0AXAdyHR8kdox5q34MAxuKZ4ra9qi8idbGJ5+h/cTPSZdWGcyz?=
 =?us-ascii?Q?2ij4l9zRm55x44KJJBEu+DGA15jUU0vqfpK5fRQP2bzragA4WJ2ckz0u3YEH?=
 =?us-ascii?Q?UVcX3WTZzjqhJFXaglc8icdI6jqIY2dUEjxiw+mh8NRErCfhs06k3/7bnwa6?=
 =?us-ascii?Q?SjOTqkLanFZkZ1FuxlIp0z1ud37DppmxMjc5PSx0wLMgpu8iu+kvWVj8Wv4A?=
 =?us-ascii?Q?bN+nSTxqD0/hvMIFx3ZT3TWGaDgFnZB4wCyEzX+qJcoFrEJkJyRs9Rmn3Uvy?=
 =?us-ascii?Q?7IOWJtl0ct7oCAGjBJDVGaGZEs/y8sSYqW3GI7d3uERtjl7Eict1zGP8Iidk?=
 =?us-ascii?Q?un6CKFBhGKlE83TnVgzHUBAQUpYIWBQxK+/KK/TYhLR81vLnLfUaIq9FCGr/?=
 =?us-ascii?Q?VfiRvXQPbIIo7Xv/sDx3snBsIdYVHbl/scjTvB4GwZLV9y/F8uuy8LReD1Ar?=
 =?us-ascii?Q?9bR7ZmC4apdNF4z7mn8+vRuDtWvPGqiFJsuQJNXBOeiCRY/Yyonk6uHjLCuG?=
 =?us-ascii?Q?mq8Tmo4TPAAkfBSaZ+l1h47qYS1bi65jaizLQAknXMHBI42WFRm3L2Eswrn8?=
 =?us-ascii?Q?0IZFMVL2AXu4/DLhp7tYsuyr7NCRbRGF86N0sZhk4mVqFLhTYK8ns7nZ3JfZ?=
 =?us-ascii?Q?7xNukucac4Jkx9rtLQzYeB4T2YFduNAHTJVwxvbT6vBabiUdqYPjLtj/SMrc?=
 =?us-ascii?Q?AUhrdZcIL0wUdVVjZqKsH8K8gTb4himBnL4kAiI1mmTzkYriOtmnihQLeoRd?=
 =?us-ascii?Q?m7ZFRnxr6vQmpZWqM2KAm/oJWvCETEqu6Mj4wZVB9r5cLRxMHTGUQa4WjU6Q?=
 =?us-ascii?Q?BiVffbiTlqIYOIlYNAi/9f+Q5nGFvAaMCwKTCU+GwO/B7Kn+81THBuTCJ95n?=
 =?us-ascii?Q?GzmW4ix0wOe4j/9Y4W55RH0MmYCueOnpknq+ImiSYY66tHIYvel5JJ2+NKdl?=
 =?us-ascii?Q?wmuCSa+NHnzCrYO134xIjdLedaaGPMmMOS4YIvRV1q7d9DtIOtbzTHn9Bl1T?=
 =?us-ascii?Q?oPtKUdz0QC0SMTBG5cwTJSv+4caFGmBrQDwNRS2PPLMVCzienbTJFXUxq3hV?=
 =?us-ascii?Q?DP76u/bhlwVJhV2r5t4S5tmVSnXWmHfQI2wHdFRjUEFg5gEAVt/fPiSiYkMw?=
 =?us-ascii?Q?4bbhKtRWS74TayccFxNyL6XIpP6cTwqe72tZPhcM2c/GRrMpnbWx+D8ZuLry?=
 =?us-ascii?Q?J6QRUk7SqAQcgUOT50/z6R4z7Id4YIftLxmTksDznAIlnxgIvIGd0NqRnjDb?=
 =?us-ascii?Q?qqJzzUE7OxdQwFT9Uo0fP2hWnCEVLkc/hiq6wCpjEJK8pt+XWZIKJm0gP1PA?=
 =?us-ascii?Q?qweaMpo4vPa0jI3G9J+EsUfyqqmbSZzvoTOQvjIr03JCAoyVhW7xgpjWQiFF?=
 =?us-ascii?Q?oB2otLXNWQbcoTZL3Hay8I8Iyl23Kd4D4l3AYo/nvpQEmCE1Xxl3bk8wiOri?=
 =?us-ascii?Q?x467n8sLNAHWc4sgl9AFb+JuqN1RIDGT+zQKKZuW3eSYXE1yrwpI+1T/JA0T?=
 =?us-ascii?Q?K4X9x6JcC1mMW8FJer1dUwGdo7N4kSG4fZbyv7OVQqQUonJ3VcajaT9FJREk?=
 =?us-ascii?Q?e1CjUFR/m6Kwr77reAmJ7+TtP+Bli7iDOy/F9UzfwvmxwDF0Ep8OsBC7aoS8?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b34f19f-a48e-43c2-9b84-08da6e4ff8f1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:38.5807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQsFXMx0wZzTaCLZ4uRaCO31dzfw6ZcJ/8TOzzLSPgCR1jvO66jrX40/eI0Cs00Tuxij9G42vtYITS+5bnQ2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- Use mac_dev for calling change_addr

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 0ea29f83d0e4..b0ebf2ff0d00 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
+	struct mac_device *mac_dev = priv->mac_dev;
 	struct dpaa_percpu_priv *percpu_priv;
 	const u8 *mac_addr;
 	int i, err;
@@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	}
 
 	net_dev->netdev_ops = dpaa_ops;
-	mac_addr = priv->mac_dev->addr;
+	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
@@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
-		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+		err = mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

