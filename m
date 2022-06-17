Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B554FEBF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376486AbiFQUf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355421AbiFQUfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:35:04 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C72E5DBE7;
        Fri, 17 Jun 2022 13:34:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcyEVJQA6DRyDV/1KXCMiXPY34+GyXOIj3cKZ/YWGJ27MP8QzNqpTsa4+5aZ7hn1tziqD0DBJOgTSB53Anai5J/Y+lFJm+nMlk8eW9UEF8gn95E+1ZTROw14jqG7Fh7ST0+97Nu+YbpUM3D9zPX/SC/2BYZJo3A939ZPF3u/S4DbOzkewf87ZqqBkN2NJ9SGKzdz7sOMRZV73AbTtx9A7qhmb8SlhdW/XnJhyM6C3l6MQp2NCuk4jrNM1ntoTkUUzgI5Cx3kT+YYs/hSdol2PeikQr1KxI02M6Te+amWv0FedmMgM8GOEIQKlZ6Sg61LTvpW3lK1sTodAGBB2Rp2JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeAub3ZB+ZtRPDlOvQWsj4lyilhVkwXmayOKHMjCVbo=;
 b=grnJPGm/B41tnAVR3GwWHnFzPjewRtTP4ZhxBMVuM6XJhSDwwbfD4e7RT9Z2l3UtSQMWwbtYAIe2nYhfmxrAcQ3y0Lw1d0TTi58H+RidstITXZ7u8C0GsAlbJ90coQAIOWLHZPUAQTucn1arzh8kFjCpbtBbSQ1KtO8zJrij9tjQFVKUoua4VvJJmmUdRf4OJqt3uwS0/pq0K8bLiFMubWMBI2mtxMcbes8oLz3GxTSvucR+62uaQc1xc7EECrZsTtYXR7D4ScLS9wMyralKvGr7KjeaCFvbhy8luFetFkEgzfNMz+okMtGxD2kH6F0xgOwGA+Dm5RP1pIUYeByxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeAub3ZB+ZtRPDlOvQWsj4lyilhVkwXmayOKHMjCVbo=;
 b=2XxuRje8rXBCifaAuI7H6NOGQAfgzdb71KK5xx5gV8I9pEx/g4tBlOtBNaY+vyjTosGTFNifbpC0mA+7b6IhInrHkoxj1NSTM71rYkM2eBeMgQ37U/V67Nk1Lv4TNMV8OC7xS48UO4kiCsK5P9iRzStzydLdD/3jjg8pcMje9VpJzW9jhAR6MN7Mezbuk+FlTFZf+jLXTLJylhg/bVBJfN2WJ6AlH8wBcOKENT2LP+HgFCfKpYXGK26Sd2OVCgdrsawNvbM/rNpnUeGV+4wvqmPzfBwLQbhgcPvvqxyFJ5noEZHyeGnHbigj74RW7uenVf7pIZda3E0EHsc98PGrzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:13 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 18/28] net: fman: Map the base address once
Date:   Fri, 17 Jun 2022 16:33:02 -0400
Message-Id: <20220617203312.3799646-19-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca665a0b-18c2-447f-9ec3-08da50a0bbbf
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB68384EB2562BF01A36949CD096AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2laKi1AwFhP1F5HJHefZ8tdntWM2KIBB5zCknopDAVq9M8Xf/y8kUz6K5/SSh9ArJ9rbhUXU6JJlgC6ZPlD0Qc7ZbW9w5OE4Rhkhci0xZokMaQKOIi4BPR8BY3R02XmdgY4p7BuD70SZKKZVko9SAz8rmmblLc5eNuc6iM/QOEktAz6+Oq46tHsxeDVWEXQk3Gd6FaoKmJs//FjRxKNF2xmr95zlwtdbXhKd3V5uhHdKDxLHZ7dCsoNrJXheOdkY+CBXpWOD10qAzKfU72MYE1ByN5fWcD7LVxmu7Q7BajcHwheVZ5Zu1Q5P/3k/kAivb67KKShCnrymUacMtYD/IEtXeF5gn6OKaSAz0R57fcBFPGu777+vB9SG79Ag4yYMEGWgSu8W/MFVSYuKALOohKyPxJAT6VPkMLqlILFVYfX6XHLJXffIskrVfl7J56FP6XEh7HtUJtwvJTzp36T986dAfZOeTA5epDB3ZB+8HMMJKSgxbYeJhiTp7g0DGU8afzNb/2VWCUYPMG+OR/Ch52LCVkRnDhv0iufUJtp4BTQ4g37lnK+/fz/vx6dsBLiCVKiVAlzElFA6Pev7uHcE6vh/i1xHsOMtwJicHCnNe6MnH5pG+Gew09uMZHmz30enhadul+/1Uvi/Ln87tvMO0NJ8MpcZ/tZrn3FsjWhumKxN9frjCRw8SG1K5XBWGzMvwNC/NZDd0lMt1AteC3x72g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9H6V0bxDL5HhKmoX1kgOVgrckJd9bR6XMRQTFidc6hniytMHDTeeHqjFOrwn?=
 =?us-ascii?Q?rmcokgkpBrQya8O1PJZTuGt6Hx1bEpBgSQODMNLSDrRERTljuw8ufZH+FBRT?=
 =?us-ascii?Q?mNr6hqhTi9IVRKWQLz4PulwQ4jCDNLNphDs41KaEH2v9YYc6u0GXHLHxbl0S?=
 =?us-ascii?Q?50XYLYR+TJYCw5p91p0Ss7WsGpne6vP/uCyqPVpsavAFlBcDQVN05mvsRUhX?=
 =?us-ascii?Q?8lPF1Cn6axaDbqRJPdEDxmS7GJ5AsWwHRMvU/l4Pjfrj7qETZ40POM1BsN0k?=
 =?us-ascii?Q?8D+dildx6+mI+ViPrmB+XrySn3wV1BIgtV5ECy8XBWc4YGlHlIP3UyiGbFp1?=
 =?us-ascii?Q?3WZGPAGev0YtnDeAwEbyYtAzDAtYuQBY0fNvgL4GJbOo3iyw43/2hbFHAfb1?=
 =?us-ascii?Q?7NP+8GgZgNA0jqSWfaSQ+kOd8nVclHuoL9pVh3xXBpXbvz8bvUKNvyxY7OUG?=
 =?us-ascii?Q?hwU1tXCEu5BYQqgeJFUgUtLLbY6VxEZkmQnpOnFrjLfWyASa3I84EPXIP7lr?=
 =?us-ascii?Q?pvbs9WPjXDkVqegwRLzKpeHi3Gkq71+tAbjUB2vu5pNTr8ZtH1dQ6zPrRLkJ?=
 =?us-ascii?Q?mbIVJ6NWNr30o1MQXs0r+e0bcwmAa/49hhz/r0QGZQlxfHiRwPPHsuph531f?=
 =?us-ascii?Q?yL9hI5q1W04KtiAdytZP7fqYBHMQ4IuwncBhmNdwGHVmGjCmSv/ZQ3da3D7U?=
 =?us-ascii?Q?2kDYT/iGj/gpPfCjIrMb97jA84YoO8CKZKKTiSdNJv9JXDHjDevV/ReUCx29?=
 =?us-ascii?Q?imXhbwzwYfXwfCSodRNwDXeznyEtHECVBNRKLpYtb5+FCKUimkpXJsovHSIF?=
 =?us-ascii?Q?fzRK4r2XbwZr7evMh5k60wtv/2XEIN6nxRnEHl/o+ZJ6RJSQJWDHNcisdVpD?=
 =?us-ascii?Q?b7Q2FMurYSMw/A6bqgfuBvFFJUkebAz5oU/DN/G7zy5fU3ko5/x6iTLCRVjm?=
 =?us-ascii?Q?hfAoevwdUh+HLFDWp89bHqeTNrEy5pRT94mivbd1RTVErqr40fFd0i0/AMAa?=
 =?us-ascii?Q?34h747VJjIqyq4WCK2nyS7LcOCNh2OFU4LQIPr12rMbj4cdtvGlemNHiQdqB?=
 =?us-ascii?Q?bgsuELeGjp6j3ko7Mi4V75HV0AfPdNGgNaTi3MdAf729HUDHlHpQUhptBhDv?=
 =?us-ascii?Q?wKGDIXR3ONj8aPFwdScMfh2C9rkwEcWI4MKd5QBgtZs2FUlulN9jC7yHROEZ?=
 =?us-ascii?Q?6Oa1iFI6Ky8dvw+vo9lJOkaK2D2iXz14uvb0Y3usaMRIuiOqtBh2UJH8uGw5?=
 =?us-ascii?Q?hZ3yJmGOqFMJcHGOw80Ia5Vr7L6kkQLBMRpuRSpDOltCw35IGDf0ixXIWAk+?=
 =?us-ascii?Q?FlruoCYSge2C1mkDT48skyLUa1zlZgSUInmKauA9qlnBYC6kM7Qn06f0sKsv?=
 =?us-ascii?Q?zfEHR/hpeMQt+ycFpiKGZrxvBgvL+Yk2qmbn01AfMrmKDZjIqYXKetc8JvCE?=
 =?us-ascii?Q?fITPrHks6CtLzrIsPP2/SBjzHZv5fb3JL4Oyn1TGDLcHE0/xXWqYxb5Wi8MK?=
 =?us-ascii?Q?3a4eTd/bitU11dCENQ4HMGKLVSX6MatLiBUmtujzVW1pO4aoleHzl8ujjjKW?=
 =?us-ascii?Q?6wspaxsn87fiii24ziKzT/B/KEUEgl274ghMKPXxLZxcAStNLW2V74CZva3F?=
 =?us-ascii?Q?i00Z7GujOiivcHOm6ZfavcRSTR4EqGFlXU9+9s5O8IOyptaRsHnd+CaARuCl?=
 =?us-ascii?Q?jLuyx29yAyR6ZS3UjlagdB6v9dYW49BR25CY88tk3u0mOfaQ/rp3CK2SNbTY?=
 =?us-ascii?Q?bFQi4EENMnhHZUDZ//C7+Ydlwm1qJBo=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca665a0b-18c2-447f-9ec3-08da50a0bbbf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:10.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neTcmMYD9AFLTDVJBSJwa5+7c9x3iRUKh14tz+h7JFwbnddUCs2ZD1HiPse0BV/eEv0iJ0dVISct9ffFzzbhcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to remap the base address from the resource twice (once in
mac_probe() and again in set_fman_mac_params()). We still need the
resource to get the end address, but we can use a single function call
to get both at once.

While we're at it, use platform_get_mem_or_io and devm_request_resource
to map the resource. I think this is the more "correct" way to do things
here, since we use the pdev resource, instead of creating a new one.
It's still a bit tricy, since we need to ensure that the resource is a
child of the fman region when it gets requested.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 +--
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 35 +++++++------------
 drivers/net/ethernet/freescale/fman/mac.h     |  3 +-
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index a548598b2e2d..d443d53c4504 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -218,8 +218,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->netdev_ops = dpaa_ops;
 	mac_addr = priv->mac_dev->addr;
 
-	net_dev->mem_start = priv->mac_dev->res->start;
-	net_dev->mem_end = priv->mac_dev->res->end;
+	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index 4fee74c024bd..258eb6c8f4c0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
 
 	if (mac_dev)
 		return sprintf(buf, "%llx",
-				(unsigned long long)mac_dev->res->start);
+				(unsigned long long)mac_dev->vaddr);
 	else
 		return sprintf(buf, "none");
 }
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index e33d8b87f70f..e8ef307bd1ca 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL FMan MAC API based driver");
 
 struct mac_priv_s {
-	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
 	/* List of multicast addresses */
@@ -67,12 +66,7 @@ int set_fman_mac_params(struct mac_device *mac_dev,
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
-	params->base_addr = (typeof(params->base_addr))
-		devm_ioremap(mac_dev->dev, mac_dev->res->start,
-			     resource_size(mac_dev->res));
-	if (!params->base_addr)
-		return -ENOMEM;
-
+	params->base_addr = mac_dev->vaddr;
 	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
 	params->max_speed	= priv->max_speed;
 	params->phy_if		= mac_dev->phy_if;
@@ -309,7 +303,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
-	struct resource		 res;
+	struct resource		*res;
 	struct mac_priv_s	*priv;
 	u32			 val;
 	u8			fman_id;
@@ -372,30 +366,25 @@ static int mac_probe(struct platform_device *_of_dev)
 	of_node_put(dev_node);
 
 	/* Get the address of the memory mapped registers */
-	err = of_address_to_resource(mac_node, 0, &res);
-	if (err < 0) {
-		dev_err(dev, "of_address_to_resource(%pOF) = %d\n",
-			mac_node, err);
-		goto _return_of_node_put;
+	res = platform_get_mem_or_io(_of_dev, 0);
+	if (!res) {
+		dev_err(dev, "could not get registers\n");
+		return -EINVAL;
 	}
 
-	mac_dev->res = __devm_request_region(dev,
-					     fman_get_mem_region(priv->fman),
-					     res.start, resource_size(&res),
-					     "mac");
-	if (!mac_dev->res) {
-		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
-		err = -EBUSY;
+	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
+	if (err) {
+		dev_err_probe(dev, err, "could not request resource\n");
 		goto _return_of_node_put;
 	}
 
-	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
-				   resource_size(mac_dev->res));
-	if (!priv->vaddr) {
+	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
+	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err = -EIO;
 		goto _return_of_node_put;
 	}
+	mac_dev->vaddr_end = (void *)res->end;
 
 	if (!of_device_is_available(mac_node)) {
 		err = -ENODEV;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index da410a7d00c9..7aa71b05bd3e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -19,8 +19,9 @@ struct fman_mac;
 struct mac_priv_s;
 
 struct mac_device {
+	void __iomem		*vaddr;
+	void __iomem		*vaddr_end;
 	struct device		*dev;
-	struct resource		*res;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
 	u32			 if_support;
-- 
2.35.1.1320.gc452695387.dirty

