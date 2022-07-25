Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF83E580156
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiGYPNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbiGYPMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:12:31 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFE31ADAE;
        Mon, 25 Jul 2022 08:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZGwT/C9h9xLcU+TMkmUwdK0mFUExUlyYh5X6CIchoIn3N4XscbJQupgtOyZPjox7oIxsl84dU4iLS/EA7HAvjdpRrJIeMLb9t4Q/xueAIIOgDwSXHpuXNavDyVaLCmbb6w330fE+DbOHYyYu5yL2rw2TpAV1QxLrJwdr4BUZ9Apy4Ces+I4D21iLCAo2hBWyIZ0Hl1VYOxdIVbHbaDbL+Ap6V7qi1MoJEYkggD7m4wl9y1Tqm1w3zee8k0LsBsp9BasPI63BenCy8EJWIu9tX9rth+7cEtyUByQ6IFqWsCs+lk1U0nVqwcJtkX1QHZ7IME8VncChVl0N8uh6BeY4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGWQbBEdK1su/g5tIpfT1wDYLHV0nYKXcAAYaa2UHiA=;
 b=IFUoxCd1/5Qf9OqwfZpWi/6s8mWDQmSJusmMIL/C7yBfzuf3YgEeXqZy+CHdptEQfny/cWmAeEy/SjT1d323EtD7/o9QOJuxXa6jtyBi3AflkdNRz6/Qg/RgZ6lWesSoByqXu33Ps8utXDQB8D/Ea46hY4QAx4pdXUfa7fcD9Dtrspo3tRAogizDlOVlUS1VDxrlld+FSZ1iXjjsdIxQKWniHFMGRKFhT2q60uXG7sNmqshYh/qqXct0bKTGbsuAurFqyQVeE7Rit5kWTk/RE5MCNRwi03vDUytLRJKy2cNDkTacmtr/RQRH3hh40de9EA4D5DrxJ1I2ksVAelWlpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGWQbBEdK1su/g5tIpfT1wDYLHV0nYKXcAAYaa2UHiA=;
 b=ocu6NGEVhhQqnNvIh083J+ddRfbsXh/BfUU4Phy6w212BGA5UKfMD7zcv4umhtDIfqkkhYqZYDKdgU/50XixDhXYYfMkhwsSR/B2LujBCkK/nDj7B+WHiGfqbQWdVRefKv1SrFt8MosO8kTlTgfpVyrI3RyYUhEBOBLQA91ESJ3gCt1F/9a78oCNUSEWrhA+MigjTCFJlzSIqfBkFPNkHHRgP2qpN8SaOr2IExay62VRPn5oNfLnu0jxYZT+mC0XwfeFctaOQb+5c44tJpXVn9C/VVZrDu9IX7iiJO4kXtd2WDUgFsVs0tLwoxPy4A4eRSGfMpjDZ7ZvVySiJoia1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:27 +0000
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
Subject: [PATCH v4 16/25] net: fman: Map the base address once
Date:   Mon, 25 Jul 2022 11:10:30 -0400
Message-Id: <20220725151039.2581576-17-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 473f0ff2-17c3-4e88-2af2-08da6e4ff26f
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuktGEkGVslFRTeFBZ1RqJCxY9q+ybeH3DVlZakX2q5bu9FIVFkohxxA8r6WJlmGjb+VHncF3fKXCn5MFfSQYQskOjmtVkyD6GptPi9Y7YV/OPpnagZ9f14tmofER/eAG5rd/ye77WEYcRpTyz4gLkUgutljqfaIP6ukaFqxMIHrjnUVwG7afJljiMXPNheHpb4WPWUW78L3gakVi38f7QszB0SV4Va0SNMxWB13QANjpK722EXX8r5JzXrjCXbcLD7PPPXhPj8FcuBBMTpt3ynQYdxbSSf2ymsO1xMuMOvtWvqTVqcQyv8TGEoJae6vpISrBEqvd/670zaIp9fg6zeX6F2LfDjo26XF/oI0YosRWuSKEhIDZuZqVK0mpmBb+5Yw63mA5vdOABh4DrD2zJQ2R9D3mxo3Na7GMab5sezAh03HTPTFnPTcO+Ymg3z2Ks5cTIaebdw77YW9AzCvCr50C7pYZhgJFQU9ria/7h7o/M3mQ1j8G5QWrm+bq/FDEpK/ngHD7HV+gXxOMXuCEEr3MTk8mHgKHVqVKixO0lG10Dn/n8Ve9vg8vKq+NandXsB2hBC4Xm2nmxFrzU50aEAiwNGYKC4z4tqTRia207idS4GlgSWqYIUmWInbgUGuCajBHkDueCNrL/vJPSk1Jv3dBwY1rtJql41Ol61ujVDp2ywj2iSrh8B2ZJGnvMmDVWygZkD1tpcwWDsbaoX24xzRUF3D9pZdNIPApgMgR2BDJjVj5fyRQvrEjTohf0UfoeNBR4hW85avP7ZRaqINNqSc6DmfNSQ09Ze6czWTIXA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mCYthsRXUb3gaYH0ta76dwp5JkZC5XJxJ7Ppkd93L8dW646xDSI09qtYJ0jM?=
 =?us-ascii?Q?r2kldpcNNH1Z/sJUflkDBnQKMNo7zT62z2YlYlFcdEFryPvH8ywX+EXEsL3C?=
 =?us-ascii?Q?oOfumbBfionyhZEt73rp15OYPHR/dXQxeZ4rVd6MDtGT3gVkMLy+ho1Rkh5p?=
 =?us-ascii?Q?Ltp13GWUrEn3dH7qm4/z0GdME6RvLkOeD0ahniyT9vvESMmQGatSu1TUu8MS?=
 =?us-ascii?Q?JULNou38TA1zPRCCwIGpe5JEB74JU+ipmS4XIpJ4Fi6N+Bi5z+Sgmt1+h/vx?=
 =?us-ascii?Q?vqSUapPk4e/2zRnQHq8kJ9ZOON7RjS9r5GhN4vVNum85Wf/ok1X2nwa9GUw0?=
 =?us-ascii?Q?vTxSnLuDWYMe8cAVuHDhn6a8H/TKeOGVik3Ae5iWlpgz0Z7awEUHflJ1ffh3?=
 =?us-ascii?Q?uoufH5fIoI0ibzaOW2iEbZJ+ZHWF6HMmMvXztgINUgDQYUqtfUAoUCRlGg8k?=
 =?us-ascii?Q?0F1bcXdO+M0+parGxLTU4HDTLcgAI/mRrDhoCLEdlCvf6WC+HGQi9of3DtC3?=
 =?us-ascii?Q?eUgaQxt3KoB2pKjWJ4dnG/p6MalwBZAbI+fVvXj27RWTBoktZpL+XIhisA/M?=
 =?us-ascii?Q?GH+ELts+jtir9F3Qa2ZV/cPPTN6WCdafNKKLEplwWTZdLIwjszupnYZuqBaR?=
 =?us-ascii?Q?uxaFY3uFDPxhyL9oMD/EdHwUhCnPdxl13zdK4KdCcdtYvKhXrTAGA54DxB+A?=
 =?us-ascii?Q?1xVZxNgnFQExL0JoWM1kYQ+SlxIOdXBEOazHDIIpY9+9GC9P8PwPyIoFv+zU?=
 =?us-ascii?Q?3BuZiOuRq16kk7dGqkmN/wPa/DtZx8iGNR3P46GUohEGOgkcnoTpmq63SxId?=
 =?us-ascii?Q?CKKCA6a/QLPOqGRCwHanbypLOJpzbfSzeLx99VlZ6hpC6n6VOGHu3bCxhPJC?=
 =?us-ascii?Q?W7N8SXLT/ir/eeh5I7rtJJh6IgtIWLFyWhaAVd9grn45hW7S2UzPN1yy5S6y?=
 =?us-ascii?Q?QIGvN1ZcXAggXnscf5SJEb6v8e3OC22ZvsIvrOpiJgaIX1I9Wzj2FZxGdGMQ?=
 =?us-ascii?Q?F4KqhZcS5M5OwLu1y7dN4ZCWdq1xof4EkNW++ZBBi3dPxEuFF1fd8r8qPMhP?=
 =?us-ascii?Q?qC1ZUc/ZrOx+jVpEgtuNyIquW7HqA+ustFho0+xCNHs240Aedq6obNS0otxF?=
 =?us-ascii?Q?rXzFbu0Ope83rLPcsIh94vdY16ceJdK4uKWZVg7HxuuXQG4ISZTiHhpuJlvi?=
 =?us-ascii?Q?xbuXpYrVjMRDuS6fO569l5eg0St4WA08txYElq8vjzw3DehnJXBrnvLV4zFw?=
 =?us-ascii?Q?KEG+8xkTZ5NdDShDnFZHkbuNMsjgqXH2+5rkm0hAZtxNOgSFpseuHxT2pzwP?=
 =?us-ascii?Q?DeON/Lx4AeTb/6l/sL0+KSA/woOwHOE8Oy/yRaN1Oa0JYYa0Dr8vRar1LshV?=
 =?us-ascii?Q?ooUfKhux84bFPRNIbCKNcMYrwBS6x8HddGuDXK+orKlCCllhdj5UN7m7Wagi?=
 =?us-ascii?Q?9HJhG1fwOrxGLsxaFa1PCJWcR/nRp9PlIs5dv931FPypAwPzaB2T78eL4qv1?=
 =?us-ascii?Q?1fGtRyxH3K64dOIvXeSLFdupOUubZJeWkzn4WxKvE2iAC7ju0QZqODzm7CRr?=
 =?us-ascii?Q?RNg9oXwmgRSNYNWoXbhJtpgc7EfPBtfGuE20KOw5IU6unWtaHXJ2CboCIeMK?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473f0ff2-17c3-4e88-2af2-08da6e4ff26f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:27.6908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNl46yS/n7FsI1+2ekvFK9FWhuOL2Ouny0MyFvGk2kKlpZjydw25ghIBfLd2q1EbnCHlGuR3SVKTHigFP5xJ2Q==
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

