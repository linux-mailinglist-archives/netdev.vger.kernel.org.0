Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B00E55F104
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiF1WPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiF1WO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9442396B9;
        Tue, 28 Jun 2022 15:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiJcS9/j5h/ABHL6rqvQxg7UsZ5+PrDvI9cmz78PrNGKr/y9m3ccjhUIb9u0zgmXcxcXRF2b/72fFgLPINp+CRj3zHklyX7X9lV3XN9v8XPZ2DNd9KigN+5Sq/L7Wu2hPezo2Dzs82u98atd1rQrj7mvODXGI0Jmm8Lot1oopL23KUKw2pJ+tOoXjoLv8WfcfeWMuVx1Vutge6RZS1dj8neG4zF/n268Uo0O1FKdj8HRrFvZxbXyfLn/dUPCRoOFTeOOgNZLSjQw3i7Dl1OYGJ5BrqtK7kdYr0V7kGlKOoKmwDBc+S0EPKjBC+OfNlFZOOYChC5YdYi5k9DmVW3LAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/eCJbGAHSHU8+ge017Q4V8y5RRgZqs6L3IicsKbrO0=;
 b=BYPJXXIoX5R3BxAnemCo8s4ryYbC8L1HbIS492GyoVtKE+MQu+8j62cwPy8N8DZSoJKbbWybu/qInI6J0QhArxFnN3cjqOHhCmQLk2h7+MmqszYpFmEh8/QBdnX7pzho7YGBn9YJP/9tvvM0HHnhlcbn5UNyWgctZtT2neNOWTcC3+a/K+LFtAm+FnEu+9KYXaLbc/wSOhZ9P9UppuACTqMci6OkoPlg2/+CDQbccZMmEQyxDcY322BrMgNSFuSzZmBbYuRuYqQXk/prXxz5JG54BQCODZPIKq8tMgcNEIYRd7+xm2N4X9EoQd1wCttiIwLqXFC2XjzWMkVy/tpr2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/eCJbGAHSHU8+ge017Q4V8y5RRgZqs6L3IicsKbrO0=;
 b=lanzjjIbeHPeyY+bHGdmx5wQwtZOrznxLaBubUHcce+/4j74zTvIXRDYjzLlKfjeIyjJjC+3T7NktXYt/5BWHI7yQWYa5bZujb+CaTuZg7N8OrgXLym0NUnd4KMLezmlcbAGpQ+gxDFUv3R7GG6tZYMsyHa6ij4dChauRPEgRg+YUZgaU4gSPYHMV41YHse8ax5wCBMh1eoddHAQzS1HQ0wn8IU4TwL5DIUw5eQKanltS1M+R+vsoiM/R4ZjbXRVweVj6VGjLH8Ah/NMkwa9yOloA5gISJOwydhq5PlpJN7B9L163mt9yWV7XHjiffpQTncXJg4i5+yIwAN4gQgZIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 14/35] net: fman: memac: Use params instead of priv for max_speed
Date:   Tue, 28 Jun 2022 18:13:43 -0400
Message-Id: <20220628221404.1444200-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f08c42db-1497-434e-6783-08da59539948
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BVYuZ1HuMVYh1xJp8dMuyJD5LL5HNu/xFNztihJqXXmpeVRgGWO444RjU0JfThwaKPZmVOFrQpUBt6TdEZNCIU6/iHYW1TzxesGSEeCbU52uubb9jHTpBgHc/JPSTy9yKPnZUzV6qDQHVaFAPgoMQrrT2vnZ+CUVCdMtwS60DxNiSQGZdZ1zZzjuHrTKU7sxi8eClZc+Lf+Sr9rKrSSOkAZbWhVpnyf9XttUHwqIOmOYePKoM3Ytha19Kssmtuxcr36kFpJRGjlF96dr0QittTC1hbLibADWx1+KdaHgFT9x7tYmR1XNCmIlGASpYDUZxqX8XAX0HvBeaYwZ+QMCbaZniCoVa+Xl3hzLo6iPm1v2jfMNanSewtL8ufEqY49z3r3G1AxwTs702wIw11cqJDqqlAKyB8oyPYLRgvsNeAHx49LDtYc2XaaxMo9giAFWA7TM16FS4tFCboVwza7Rk+lEIhG3SoG5zPIEa9kEhSTD1qlEL4ewTVSYq/pRp03DlgQDjvlWFQW8hUeSYxz0ieF0HqlIkUefFB8bPrqId0EpN1wit6bWQboVYHjYVNCh0wQH/T6KEEzht3u80L8IKfT3G5U+pz/nO+0YKBLu1JRm0CL+Jdx5dmIRwxfA8qEO1Lkm2SdF5sksYuULsey7v6C5+VLvO93Kv0jeXVA4EMlGL41y0FnStOZoqBQCvQ4jHsFctomL5oqkmeKq3fPp5VcxwBCSesPSe23o4YvounKDM9CEC9WsEv4m9D+1Ie+dSzcfYpBDoGUcVxdMVwej3Am3mkOyaK7+smBhIK4OF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wr3JTbbGTpUQUrJQNbLByUdkWM3AxwVWj/eSPxCX/a9+6cD9bK1tbbuoimRT?=
 =?us-ascii?Q?GcXCNFk2J1vVXkKc0WLYe+taAgVlbuxPWVZFrqX95q8fEZfYB27xleGXrCcT?=
 =?us-ascii?Q?xxakZdr+gqqMQyI2mxNFlRHNrzAxUJ9x57tNX0hnUyklNIuGtJckuepEllyG?=
 =?us-ascii?Q?O1OdvtntvV7+qOSAfNqASt7/hF13gPxD1R7cxxOd2z7lPH0MJ903SWoBgTTX?=
 =?us-ascii?Q?30cydqpehkxmDL/fmR5Y2jNUP9eG5JMoWIokDpLcJZsTGqPL7xAQ24tGzy+Z?=
 =?us-ascii?Q?hf+zjMSieqGQsD6IXGxB5bNroE8N3RRj9fPDVpHK1t6YloSvLgAhzvYWLI6d?=
 =?us-ascii?Q?xF3MSMb90pvF1YZuiUcNdMdqb/QuZzBNffNonENTa7dM8oWCqeTCt2t/xNuC?=
 =?us-ascii?Q?abqzIdvrCvqM9y9vVZVCVKolnQ2KkqseOq6memJ6MYKGINSEdEPUvTrwgXFQ?=
 =?us-ascii?Q?KNu9Y4i2sHk7Z7HDb7oeE5CbcnBROHKYwicdk3Z0UJeOLunmiij6u6M/p8cQ?=
 =?us-ascii?Q?nO1FDWZPlzMqyjvpTMEoepeqD87Dr9kACd+GZvByoMaGGUgFtuScaf5BZHCc?=
 =?us-ascii?Q?sbvY8TjymHGGS940sQ9L6qlW2TLE2x0mBwxE54mK8Np7oJvvL2XOmuafvdVQ?=
 =?us-ascii?Q?c6gHr1fQoFTA3RyNfnNqhlalZ9iecddsl/YT5ctK5PWT8488bN7++843qCVT?=
 =?us-ascii?Q?NEDH/HC/7pfYHZYhAfOoNUg8/LI4mZWP+yPq7CZy/7wVmiotB2zdT+82p4El?=
 =?us-ascii?Q?B8kx7jfkayOrUYjrrP0kBJuFyvChA3SZpWNciQTSWhfJHLIX17VXmgrPDji9?=
 =?us-ascii?Q?hB/ISpK350RwJrjvP0Gi8wEpMunJ6AjZwpMIh9qMTau9JmbpZSR4sEofbV3x?=
 =?us-ascii?Q?PJ4J6A/myriGspNxKstYy0qYGQLQdngGcUguPhrUuwYJ/GdKUHKxkbL7E97d?=
 =?us-ascii?Q?GbqUbvSuXiWZoUcnTNSU+ufv4vLOT0+UfVXlu4YnEnFdIh8oM6fdzilu49pM?=
 =?us-ascii?Q?8FytQN8ZTSC/p6wjRQGq8UNTYD8W62lTRft3NXufH6QYXkjkdBv3g80EcxUE?=
 =?us-ascii?Q?PDbp0uw1v2sKayOKJjgQAV3laqe6N7z86caMvrNcoLdQkO/JGKkCO5O6Fyu1?=
 =?us-ascii?Q?3mRrQlIqxTDnzlkkWSUeLvbTJZxykR9CpgxIzXmeyzb0jr5EfuTeFtXE3NvE?=
 =?us-ascii?Q?ZhttGI+PhWGKSQOmUlsdO7/g22q407uZtZKflEPqUawBFMo64jbwzvptWCYs?=
 =?us-ascii?Q?+Wgt20TSQuOUht0WhPfaSKZ7Jf0pjCgpx+J5z9UTvui1AAbc5joAuY0otpGb?=
 =?us-ascii?Q?psF9yrX9pPGrfJc0y8H4bTHM+ZbIlVkc9XPR+7rKcewvQWcTxr0KkikkDnHN?=
 =?us-ascii?Q?C8gmtpMZMKY0AJ4oviLr1qPmqtJDA/nndVOHsghVpVaGMy71LuH4ksSJTcWa?=
 =?us-ascii?Q?MIX46dP1LM/x50N8q4Sy2Q5UG7iKIQ8IRWPh35vaWwlhMD8kqfSaHiGSpx83?=
 =?us-ascii?Q?eL+AghQXeZcFJEU6dK7Hq/Jl21jkWsusitGHsHAftj4gY1BrmW3O2GoF6R+i?=
 =?us-ascii?Q?erVuw6whhU48juPfEitFrF5A4BiJLaEGAt6i9eDP0VxTTb1NUU/ek3D6f0a7?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08c42db-1497-434e-6783-08da59539948
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:41.7350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFAutiXMoMCuqA/XnmAPNYYmrE3ziTvFtFgz23+R/o4kzXI83OGS/HfzsR9WKMc5kaZwo/UjzhVoPbdJYbGKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is present in params, so use it instead of the fman private
version.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0ac8df87308a..c376b9bf657d 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -388,11 +388,9 @@ static int memac_initialization(struct mac_device *mac_dev,
 				struct device_node *mac_node)
 {
 	int			 err;
-	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 
-	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
@@ -412,7 +410,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
-	if (priv->max_speed == SPEED_10000)
+	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
 
 	mac_dev->fman_mac = memac_config(&params);
-- 
2.35.1.1320.gc452695387.dirty

