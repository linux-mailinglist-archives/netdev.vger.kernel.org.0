Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0455F161
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiF1WRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiF1WPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:42 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00086.outbound.protection.outlook.com [40.107.0.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D6C38DB5;
        Tue, 28 Jun 2022 15:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGqNEFIDJ2IQn8kh1UqQm/s5+wCw26Ntpv/UWbGYf3C+l+3CXgbvaVRCCTvPHSAk3ukAxO7FCBXZUQxauhCcOiTTLiWhBK6QZMstJizXDEsqXuc6/hWheL/gvLSmU2IwnNiVfUp0m1JNlZIbouxqizAEXnJBD1IuCfuh50r2RPMFdAJMlT2jShhADxPxLB+xGe623OPgKoUlbFufQrMbxlfySlZ/jYXgm9wc7ikz+0TShxJnAuZ5oySoaHFHN2JbbbDdOD3gYnKkMd/DKiKmXEZOIu2Qeol9FRpWaM1P8tj/wBKBvUTKcIR9JC/a1Wd/dPQcNeESF2qD5G1TatQTqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtA0DbriMocicsVV5jy7nkwHAoHPdx06OSTuOuqk180=;
 b=R8xS9lu5IsGvSWN7cMq4zNbXYzYjPlPMdidFGq4MZBnpaT3IdUrQQsVZQHDEiUxHIstJNb4QUlgoiuIQ/w5FmMcRGfN1gbZfo3/5pW/kYnfQ+LHg1dwLeyrIzmiKiJfK66ZJph4Pw1ZeAAj4poNlHWWyYT5mNQ2p2yt+PI0tQVaXHmQqqNUbkH9wwVOFpFUe+fTfTXQVMfplZMHKiOiKkentKC8nYJ535MqS9RNBGq7YN4Eg++3CngYxw2cR9G+IvhmQYESbrGYEPZgANqEDyD9hKAzB2B5yQHZlOF5JoVjuUGHR621yaxt7j9z0SkG6ofL6q2wNCSXR7QqFVYNwOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtA0DbriMocicsVV5jy7nkwHAoHPdx06OSTuOuqk180=;
 b=pNTEkEGR1Z11uMhmp3rfTiJMTs3oB0ADPbjVyX/+1oudZJaRC7t/1KOsbjqlZHycbpvuhiH1Io5g1i7EMRvtzRx2DugXRKBvtvv+aubKH+0JeZnoRuYzrdKxyOZyHsa+FG/y7mqnq135wHDb4+hmH9QowpHwQEroO6psqFx3mnvHlDk139/xDhKQCDB8nbQF53RCXuXnmNUxlD4f27S6RMYl3xD3LB+I3z6/dnH2hxArvVSVhePP08glZTveLYpJXKwaahDbWWYPp9XoGTXYf+tdVOOE1I3Nv25DwpWdaQG2+oDFhtbLXaRzCDNROM7zRh4VbUJXfvOQJ6wvV9htHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:58 +0000
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
Subject: [PATCH net-next v2 25/35] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Tue, 28 Jun 2022 18:13:54 -0400
Message-Id: <20220628221404.1444200-26-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4399cc67-b4d8-4530-dccb-08da5953a30a
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+1r788yuo80u7BIj3RFwtGuwZLeGqmkIlrzxft9iWHgC8s+QqOjec4BKo4JcYTGGLZ9ofHhT7tpv2prNoZHxkQ1Y1EJbpELxyPLqB36nAtMpVKZMY2MxzFgDUlvC+gQAsgbTbCA+WtEiYkNbk3liDKtbZgBQCQzimAVR1Wxw9bRzZXwgaNaG7sBLVtpJ9lPrwRq9nByRFwzSJ4012u/xjaYzJjgIpD1zoPQww+OQ62c9+oK5uI/EmRscU1dXA4yQLJJ6K5eNztbARQoUOZMNXJLObJsPlQXI+Rcptj6Hr04oATwaJd79yBvfkrrOXfVCj0vpIbSDmkWYSGLsAhmKnw/wpt4lZapTKFQ+yVTI2ArURq8mjMg9JeknPdUWww3JLyHuCIaTHuCrqi7wI1Pma66hgxjKxJ+J9aNv00lS2iM+QBEYWo4vOtUbvLDX3if/3DGh/8a1GmJPowDR0oIFs4IoH85rBUMPUPmoAGKYEqZLRyQXeBYNxjzk+GIJANRThQgQmRqsTUwOSHhX5eNFMc3aSRGGVfwuj3myLq1TsKPL56ZTD1sVeFv1dwOQJGnXALIpcr5uRym1Jkw5SrOptsNVn9VratXyJWNfp/5sJaVnLiQCZssXCX13VEEeaP8sPU5ZPcTuOjlduPpldPLniKb9XX9FRO5srcQwjiqUhMFtJRkkILVR4uVTxcCNJO+epIBYWHPRdPUY78ky96EqmWMUh+AwNRSzQjb21WWWZv6/4x4XtJ3GYEzO2jKyBmx+Kt6EXMXfWQ6TMJ/hq5GCy5I3Dl5dcYCygqQvse+EvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyWE6RToxTGTAnBua3iswsCbQuHVXek8DszU4/BVTuQ51xQX2+waiAZKrEz9?=
 =?us-ascii?Q?gHnurzQGkCs28ixiA+0SEtZ/y1FsQDoq+6k+m7eUYAjmMaDl18cjmQPjhO4X?=
 =?us-ascii?Q?MgIlPQM3wGUzTZbHsTV1IfvrbjtEmq5s5hBz0pctJB9b9r27Bwm9/KQoxkHs?=
 =?us-ascii?Q?XPEkT3C1NCH3NyPqOB+0ykAR3+9UIOHjf3Wv4qfhWp9wd9+rAGIWCdIQZsuQ?=
 =?us-ascii?Q?fV3HKh735wl84w6HByH91TQRnD3up0f9eL3RX8WPl3tZcszbrJY31vFBJ+My?=
 =?us-ascii?Q?06b4hwQ14qvsGdQoMY9JU3fxzmCtY+0RfMiHLqM74o3OZsG5LeXhWfj+RHLH?=
 =?us-ascii?Q?Cs33+PE3x4o2mfUH/A8/2gfYo9jlv7AYuK+PLw6N6fsBFnGXQPeaUdpnTEVL?=
 =?us-ascii?Q?hTW2mCD98AVaPB9zWKtVsNkcO8J4fQ8yAEOsRuCMmqkvv/ISA4xGuz7T1vLk?=
 =?us-ascii?Q?RxJr2y1OamEMt/sRXMfMS5AYs393RyPu6C78CdQC/hJ74KCaXx7cqNFVA9i7?=
 =?us-ascii?Q?JvpMNP8tDNHKUBf/OsUUUtN42kbApTyeGLOBm1F2dx8fblk3WLhNDw+pOAxl?=
 =?us-ascii?Q?E9x0KEkUjBKGvSjfzqAe5AT9PnWMS/E6SJNlRaFkoBcVlCMaep/CHyOuXsFQ?=
 =?us-ascii?Q?EM2x2kNTpaIWP38AOhYxkdfxhidYlsI+fF6E7Q5zvBdqBoIvWzoFnOUE99ny?=
 =?us-ascii?Q?UZDUUZFZbLTLWaldEEA8fD4RGrRhe3a+bsfKoEjGtkCQAmaaZ7E4QJRmCikU?=
 =?us-ascii?Q?Vli8Us0eh0aPfhrVVHys8ZuxNG8hL37M0NVXMgPEWS4bPInoZfqucPUJurt6?=
 =?us-ascii?Q?D3fLl6zXhfGwxcJg6KnOiWIn7pD9EgvYKtixNWVTG8OIvcph1P66RzMpR7GP?=
 =?us-ascii?Q?GYLrhrMnfjHu0QzAEOUpp1+hJyErJEKr4v+wcfcPnR4EJ6sqsJe4HD5VxGKO?=
 =?us-ascii?Q?CEFLrGabdbITcOqylHPm9LFVECkZGd/pa/iTCjmQDVgtlWTdN/nS3/9Wkjqs?=
 =?us-ascii?Q?NeMClx5b3c+c0THqSXHGznFLXB8XrNMZlHzLWzyA/jgw/qpaJJm6uW8hUpRY?=
 =?us-ascii?Q?X9fBjXAbs1Rb2PyosgQ3I25h/5lgQWmPeVEeGteMS8VDAznVALAtMvVcr6Fj?=
 =?us-ascii?Q?tdWrXoY2JyVNlosXmOW4C72WTmvk0JrNtmDYhmLjmbU9vEEdg8wwwzSARFKW?=
 =?us-ascii?Q?BRFiqH1xe1FLhqCwQiRKGE13AeK/Tcyi5E8ijDqIdxTHpC9+Xv95fcvwuk0A?=
 =?us-ascii?Q?dDjqBZCGDfwjKxqaxfo+f/ykQATEcPkkV6yGQFh2JSRJyenEvAhvruldAxxS?=
 =?us-ascii?Q?2bpFyfwEtAz+m02asOul7L1TA0Qf7Gn72z6Jaj6bl0MdOOSPro4z10KEtSlB?=
 =?us-ascii?Q?7Biq/rOB2ozUs0F5ZLrY4jhbvIeSi1KzLRhRj4r6eu0Q/05vyl2Oxiw/eC/n?=
 =?us-ascii?Q?bJRQP027nbVpkIz8+aBghgH3piQMSvzCdJxo1DpcanGoCy2/U7GKtKHi/foz?=
 =?us-ascii?Q?mESMqdqRZp2uNCuzLwlVWh/4L4cP4yLV1mE9Lm9/6bvUOzlBON3RghCygd1K?=
 =?us-ascii?Q?b2psMYWecx2e/lP+81ntHwYybBhwWhoYHwu9VXkanQfiQ8IM+Xc4UcTuvMxO?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4399cc67-b4d8-4530-dccb-08da5953a30a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:58.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C1x6grwg7Q6JoZOtnz6ExxXL0KVV8D/p3JT9+XqB7xKtt0lGmSKVxeFu92YTlEPMMNKau7TVHqQn54x9MQQPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 0ea29f83d0e4..2b1fce99c004 100644
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
+		err = priv->mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

