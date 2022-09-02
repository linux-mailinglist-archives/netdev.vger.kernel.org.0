Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751645ABA79
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiIBV7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiIBV6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:22 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91456FB2A3;
        Fri,  2 Sep 2022 14:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYOGSMmyT47NGtxDgA18OORPEuXZLOrz7XBFS5dSyn1Sz/hdDCUXeeIU6WMppbnCN0dy3CTzLb9s5EIcZbVq2Dw5V8eiUPWvKG8UfWtubDqtYzWUCBcy9N+8DRrKO+vcWAXqIOgXR0Vml4wRcg5de+IC1lrptT5upXm6KdEWqUmQtIWZPXJ6lBxuTqkClKL9w8BFtHB+lWxLn7UHtSjy8S+14NL65uXq2VF9pCLCkgM5L74ABHZZ0hT0+l8Y0EIfSkmDmtSfFBHfCfLck+tqtAbnUDO2+MeP5h+to6lMqBoWnvVPNXGUCYiMXzjexu6O0XdL3CmgocCMY8bmLgf7mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsN773m6ciD5I+wjfDxSmqyTx5B8yJ3+gC7Ig+LJ/no=;
 b=E1EtcIWKcAuHYWrK9+ZKjkgjCUrpLyUYDKJRCmqhcWKNxxTPVge4cvbfm9kYVJfq1kDdkBl2Oa4DV7vXn9Ao1lEA8OwYpm8GuKdPBH7sj9rjcFtMY6bAec5GgfNRfXr8A2jtiUzjwSDlq9sb9MNWsacMBpYK6FzK1ZxLfTKHvt9loWc1w6GNDTK7er9+UedRtxWnZWDkFa/80EAUsGzbO5SWdfmnIvY3nlbZrSd9DooX1IMsXImkmhRVXbuYiQquZYztxoV9BA6vZUGFExP0kVcbfD0EHIT0cOJMYWdjaq/VLxaBgZaepJ9eZtc1EKCq3m85+xJxP0aNFG77QmlrTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsN773m6ciD5I+wjfDxSmqyTx5B8yJ3+gC7Ig+LJ/no=;
 b=NQvCm38KMfBU6o5OElrLMtmA0xTReTHFcd0SrKie+w93l9MGKaQWT3eW6AorsyEt8h0AxM6PhKsfDTOYiXY0zp+050fkaMHvHr5VGjtpsLRPR5JouGKh6iMAsnvaEZRUBYTQkci95poMTBhbbf47gPAnr6oO/El7z77v36LLE9DEaOJ5l3zDkG2B5kD3xi0CrPCGkncDZe++89HMwkcotf2Ojw/Fe1o1V31XLoj1QwtuMbn+tCQ8idjI6o1snnV+p1CPwKbx8NstXaYcSU8SFeH9uqG8OHIo3IdYNvOqzY0Ru7j3gUVTZH6bDTS3+2OBlzCwCm8EKFMreooM5izsOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:59 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:59 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 05/14] net: fman: Map the base address once
Date:   Fri,  2 Sep 2022 17:57:27 -0400
Message-Id: <20220902215737.981341-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 061b0159-b19a-4d64-6f64-08da8d2e32fb
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbWkCyK6jgv4MwSubyu73TUxOD83MX4PumDbcPVrEDIUgHn7zgS1nmZHzIbhsPOvoor5kfXazYlEvDUzOp6JaUvA2+8PxqI0mATqghB2YGAR3dQyRTEqXjk69J/ywxdRNcvOa8AGotmOkKTP8oYv/u+nC2+5qeutDrUMT58jGExmg3jhF4bJ0N+f6uT+cSCDI9ZdJ4gYUwq8kOL9AlggmDBwjA+yoHWhM92XorecIbu3gNrWa5IHhtaVQa+gamk8qOQRb7U81F29gFMfTuRm+7a8gQuFiHWLo3SW4EO9GTxdAaC/M0zkSojqpCfntGh+HYgd0xFXejLYieHmzBRpev7Obz4Har9KgjOVxOWjvvhIp9Zuio0OwRevO0PIg6B1Ds0vzJsPXS0HRETIcW0S1VyiFolT4qNmHqcZTT/46YAY720hivPWQLrPcFTQDk7vwnULZzKCtOdEpxnn5M1V0PiW8sPCzJXZg0qgbxVZVvNacTuCQEEAmZWAO2VFG8JPBHJ3k13s4WYMXbvTYeMKsbZg58A0s5JCayjVKlzcB10xezNEBkY++jCRKXlYhxSDhd93ktsKlgOE8Jr7mXGBGNUWkeEui3qcoEIcn1z3dfeMeWT+7VPVhi9lefzdM968DG5SQD7+Kw1w0cKEBRzLUp+qr9tubq82mqAxwln21Ioy65a3ySGKvss2G6QnQEnzonWtkknP1i47SX2e4V7RQFoLsQuzYh7ArtC8C48E9L8GDnv5UqNkxj/Lwm9uV6EJxGbylkLuau8+B+99jAfL7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XzGWQqpUzToBT/kHbiP9vYyb7CRFoX4GFmegrOeM5YVBLon9xqtceIJ1bXnq?=
 =?us-ascii?Q?zIUwrJEXMzsnVUyY/M8QDBnK6TsbZXmIoLnyiYjvq315FsM/ATvbErBTcJsH?=
 =?us-ascii?Q?WWVp0NL1O3NXQ93V78EwGTbbp0VGHzEpOZgxdjJdpIJemHynpbvYrXILz1oU?=
 =?us-ascii?Q?A1vvU+N6+0i/xHhOhzBtHjwAL7h9/WDuFkPHF8+y3MNA4P3rtFA58XTfGO8W?=
 =?us-ascii?Q?DnkDzU7/syZVRqtayk1yPv20lkO9CLEw4D66k+enqKCugH8EdWGA5EIN7YL5?=
 =?us-ascii?Q?vgBxRSNev1/Ze+ig5gJmlCCKkWmeltRs6QNeOWWEcwML9qszrW8ZTpRU6C/R?=
 =?us-ascii?Q?ozczK2CRQIuyIqfTC2JlkF/NSI98uFr/CumAzaNnFYdhLgM2ysUBYnIZW1FA?=
 =?us-ascii?Q?UsBevDDguS7Tt1qWcRqrqSS9T0wRzBUhAx1YvVFX18Tvwrr8uZ61y5JoCOyT?=
 =?us-ascii?Q?wJbQ7KgjcgNEd8B703qovVzRskJxHLDeKpQUoePQuhgu3aE32zvXePMICWld?=
 =?us-ascii?Q?BCSQbLWcVC3ASdga3RdcYRHo6FYpnbp1oaWEZcJl4nQMi2hbr2fjgTZDeGZE?=
 =?us-ascii?Q?9HkxPwjX/EpX4ujFo1/apGOs7ifCUugXHE55YiyoA6+R4NUfh7owQ5e+OsmJ?=
 =?us-ascii?Q?gpXs+SdwEqqyWR8REvOaEKIJNPXwPS6NGC/S0JP+iHdSWVrdGZJqAhjye55o?=
 =?us-ascii?Q?GKkxqDvIKYQg3bkKh5vO2zCnC/B1/JfdcZ7M7Y7vfLWjY/qfqU7sz86K0u+y?=
 =?us-ascii?Q?SHDm3F+jENnBM9auANXtgdJvDPtskvUM/AuciSlQq/RMDrGEw49eLevAeq2w?=
 =?us-ascii?Q?s2JRu1FkWzIOhc+muqGW5j9BWCatSx+igD1bf5CNm/HBSmWVuyjAELB4ue14?=
 =?us-ascii?Q?YQEm8dxXYiykI6meWjJbb25T+KRxmIcM2Jnbbj/Q98CeKmxG8W/0unESCO5Q?=
 =?us-ascii?Q?134xjkRLM8VJknz5HMpU88InIwz/CA3fVwuu9x2JOYZ446wPl/okYqkZ223E?=
 =?us-ascii?Q?QD4o+lZiBMlp9oHRd5nhzDOIby07dZi0BQ/ls21a7AbLBvVCXLJh+hUC0zYK?=
 =?us-ascii?Q?/4UR159PSS/iVAM9sPEkMjm7AnR6c9sIpIAAGY42fyGA9Gr6qCZJWdj1q0WE?=
 =?us-ascii?Q?kC/3jbVdwzlqdYvlcL+EDoC28kzz7emZ5lL88ERc2zG+f7Clk4yvabMOwTX7?=
 =?us-ascii?Q?1Wr+dIrkKbGvb5MBP4+4/0rTVl2grLI5Kdkeng/3d0Su4CPqD04pwhs6HnzQ?=
 =?us-ascii?Q?a6YQoP2HA6DSQpGQqBczpsqLn0aNwI8bFUf7v1tVcFvUENACewIyKypBD7dV?=
 =?us-ascii?Q?7g9q2bsL3qmdUT3Vw9F4L7k4YtUFS7Pvwz2mQkf5LEsgmyhnNqTxXsKwCvC3?=
 =?us-ascii?Q?2T/hewmSqASk4NE/pA7XEMr1k+qynrQ3QSDO1HOlQOamhECHzHBQRL3uIJF0?=
 =?us-ascii?Q?tHyZxmZ3hz7qejK9Be9V9BhzuWo5PKVlm9J8hj00QCt6L0oibAq5R7D1T9vw?=
 =?us-ascii?Q?vUa0uIHgJpQ/y/hEAa+d+G5lOV+nJ7fGIdNd4Qa8GBVC+obQ2pr5gfhzZkTj?=
 =?us-ascii?Q?ia2sHiFRM+VTTmEW+M6z81TIkf//5GJiJ+KfJ4B9CHAz8Jnrqh1WWcbBRTd2?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061b0159-b19a-4d64-6f64-08da8d2e32fb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:59.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oowpywGQa+7oePHX6oNnQr0IiKLBnsviVMbHRJWmLy8lXe0WCXeBfY4wqMtNfqdvCHkWyRtLvIcHNlbON6+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
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
It's still a bit tricky, since we need to ensure that the resource is a
child of the fman region when it gets requested.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v4)

Changes in v4:
- tricy -> tricky

Changes in v2:
- Fix warning if sizeof(void *) != sizeof(resource_size_t)

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 +--
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 35 +++++++------------
 drivers/net/ethernet/freescale/fman/mac.h     |  3 +-
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e974d90f15e3..02b588c46fcf 100644
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
index 7afedd4995c9..62af81c0c942 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL FMan MAC API based driver");
 
 struct mac_priv_s {
-	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
 	/* List of multicast addresses */
@@ -63,12 +62,7 @@ int set_fman_mac_params(struct mac_device *mac_dev,
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
@@ -305,7 +299,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
-	struct resource		 res;
+	struct resource		*res;
 	struct mac_priv_s	*priv;
 	u32			 val;
 	u8			fman_id;
@@ -368,30 +362,25 @@ static int mac_probe(struct platform_device *_of_dev)
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
+	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
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

