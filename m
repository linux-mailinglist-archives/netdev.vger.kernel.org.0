Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031A355F15D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiF1WRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiF1WPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:00 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F402639BAC;
        Tue, 28 Jun 2022 15:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOJIoBm4Zom09eQSw1n5v6pQO3a3lEGG+HxGh/2rUlPSsPgTMNc+AYUlJlRpGuqUrTsTMRsLpRMMeJIB9we5Q5RnlK15A1nmSuGu8cePybOF7t/CtEt49/y+pYINTlWCinzbrEFwkyVuHhPV5jyxLCJylVg9otyqvBFxlroudKaRBecf++kL3Ektt7hdlkUjpqbZ/HzBSJC0n3JHXLCiqUhtPO3ccdlnUy5nFzXDrRPt7BT/3JslF9O6jWbzolBfcD2l+tnCjcdEqaWwo5WqpVM3XSrRaXr+1/066WP3GDgkaKo1qhaDM+IAkcpOWtm4QcqDDkYfIif+ecmEme/l4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+09KfYPSQv7rwZdqNsTjMc+4MLvPaJ/CCu8AuMbiMPQ=;
 b=b4Z12KgY8Lpou1pRd2CcPcJxhrBstNeTUmYAKR3zqPoKV3VhHVcfEwwQKHQy+r1IUChGoCw+B6f4y442ACXDDKC/TRQp4Pp9auz2G51uhn5GVMBDhGwmYAqNjhiMbuOy0YVtjp3X2CtqbJYATDxBex1TqsvSvYjoSJ8T+Lzr6S1iMtXcg0CtI/Mx6vi7nfQX6/igC0uTMpcVZCTU16GeuiWAfAEPfxXvTAqC5DyWwBDBrzkbHWmmf/bnSCzzF7gPJxnQtpJQ0wRXJp+zrVXAnnbrkpZF6eq24Cg1LWqlz1x1IkeXvYsPTjqbSbuWWonlqoJkVgDNxCNuz+CjpLuMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+09KfYPSQv7rwZdqNsTjMc+4MLvPaJ/CCu8AuMbiMPQ=;
 b=0ac6WiN1+33dRnWPi61J2NDhPw9OV0wrpXCVlBUIuNy39W0+LG3+b4BCA9hDv9Ln24Ok3te/NvnTQJ9ni81v5zo1r7XxSWCLaTWEWAsVerpNtHffq3HUG6CFmC/7hPM2XmP9N/sJGRaD1BkSLoI3givbFhU8BWyoA8zcc14X5GqH5DIVDz8u6RepmP6wA/YdYzSfGW5XCTjuxZz+1x3f4SqpIYbJ05TKD4qkwRhc7cN0vZxY07JcOcWf/lcecs3oqVbQzwf6kgvi2Vqwz/cwYRTHjneShh/3J/r9sRheeQp8n13SqkvLsmLw835F64XyR49CmOlqiQjWvVNQ8wJXPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:49 +0000
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
Subject: [PATCH net-next v2 19/35] net: fman: Map the base address once
Date:   Tue, 28 Jun 2022 18:13:48 -0400
Message-Id: <20220628221404.1444200-20-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5046625a-d38a-4928-cef4-08da59539dd3
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvAcDz45EhBOLsaTDVMKHT/SiV5vTu/0yY1SSPRM2NOS9crNxirzcH/Msbt09Lwl+0CpSxAUrNavUIztnP5TXp6sX8Ev1QwTTItBoQARRd8qkcFOnVjDyptx8exmv66rhmPm+HfmhSKyJmDvuCI6VIW7Vm8az+4pXw13XNBUBYcJIZzKJ2Rf8XauFEh/rxnCbXNMyGdSb2nofBqoKwByjK3f9h5koMOtUlIxeZQp24gq6A4GgbIFQV/vAQU5XdnZ2kTM2luo+BrGcf7G9BsDR3VbIcKBA5rR2TGWdvrHsJrzyM1JS3pd9dPQU+a5cj/EhuaY+p8ewONKwPc5G3YsDlzJwCYuBD/JARI0vz2TCaP5f2T7o/11AEFTQs4H94+rXdmQQ7AKRx81MHkWkST5OmYL6tjCPTvUbM8cYXNBJtwTkSQTAmJhN18bApnBxalgdUqp7DVd7qBkS+EKdief3uVORZms+ncBHBd3rLDS6d+alzjKzzrSAYg4WPpkLpUiTbupro7O4V+ri5FlESZpFz24is5EB1MMW7CvjHFo+uZmGXpWGTZGt/3fpU7KwmMNiX21QHK8Gu9XJwW9Aq2npSEOblALg2vmbxDNw9xwlPo2Nr0gX8f4aPPRdsSJvTtXsONo0ciSvM6xi/HM8aApifEIc79ffX/lBulwqj0xAnCdK4tXFMo6Ic+3ecA3/xuGYmiJimneGN19uaitGXx7fVY9iKZua36kSzK2tdF040sSeU+4MEQd2oUviUsAliyzeYni8jfRJCqyLPKuIYpR/hmbJ4hFjCCF3WRApv+rJPc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9lvBpMoGgUEw93N4rYwtB7DJyLkl6/DPXJEe8m0EUNdMEXjAegvCx00mY70S?=
 =?us-ascii?Q?NobSAjWRXp0h7Nxq1uRg7L7YFz957OmexjDRbySRF3OnNfrmUoVmrWmjVAXl?=
 =?us-ascii?Q?9zPhVEtEZ+tLrOsOQo6pHdE8dkyA61YWlUbvQjtBkiOKejJ1p4GT8leh0zmN?=
 =?us-ascii?Q?OP39a0BNqL6RQVPsOF+g8FZ390cj3aXNi5HWHMPtu/pbXBxGYSGsmmBTGtig?=
 =?us-ascii?Q?1VVgVSVqNzow98ZqACiQ5FbBUTLVyAAh4M8iqiUxCsBR92TkMMiCy9Bid9zT?=
 =?us-ascii?Q?SA7/tW8mfAuH4UhZTW1Y/EVSVq68cROvJlJ9OITMzKn9YorNdL8Ezu72xzgz?=
 =?us-ascii?Q?Gf89l4L/9lQhbP5QyUgpJBie2CdzCWV/xXcauDD6+f+clT6LTCibfBJbBczs?=
 =?us-ascii?Q?0evxgS5zUCcRGvG3aOIDrTi9Uy3D5Myw4iG3zY1dOXV8Ur1fTUvmOfOzXi5u?=
 =?us-ascii?Q?gAH4J5h41ZdQqsdz5I1fRKmw3Liz3Nzo15pdbV0HWwHVi1F8MjukMt8rvy7n?=
 =?us-ascii?Q?ZGK4czavS8NG6c2jR2Lvy9ECJ7C3jxVrhS6Sy25b89sYcSu/Iy7Axp/W0DUb?=
 =?us-ascii?Q?mrg/GaC+elpN/O5ALsxNwZnypmHmGHlc3RZihrjdh6P9/xgcdUr2gIkrk8jz?=
 =?us-ascii?Q?F6pnpaXZxWMYEt70Qv+q32EToH/sHAYvB1SKrb9Ccf7jnaXdjfkXAWGMqTAv?=
 =?us-ascii?Q?jqk7t0VrM1N+HQ6Ge4qS3aVjCQoqN4bXHB5MYMTUK0mK/q55VzzK5jMpS1DB?=
 =?us-ascii?Q?4nXIcFZh26vMUwoXxm1nY89X+hStEeNUbsHMl3cyghDvdTjtBktLfcJY8ANI?=
 =?us-ascii?Q?y12urwd1a1Yc2Rhg203Hyk2uWa2cuhp2/o4pmcxcoI+gTSwu4BFYJyTY5QL7?=
 =?us-ascii?Q?lPCeQFDtMVs4k4NRngm0x5OfMJ++TA8rqYVpCp/LDk72OF+41VpOLMOf4pt/?=
 =?us-ascii?Q?yo0z7NrU+xgX4Xj4MCagkO8DWKRZm3NkEld7Mvcj3cjP0NFils5gTkzwT/lv?=
 =?us-ascii?Q?/eV/ogmDkIS+NE52HrGt/rYtFaZYFgigk+U6PMAG8JGNafUDme1fkr1lBiYQ?=
 =?us-ascii?Q?bK38VfgwKOtmXstxTN2kq7Hg2ZVQIFmbVbxcAh9Fj7chwowvHPi3mEpGICCF?=
 =?us-ascii?Q?SxfEaLWunCgfFAZqJdnVVo99ZQZ1ZO71WlEsoNFfQLUOVq072jimuUO4Zp2x?=
 =?us-ascii?Q?iFOmFNkSE1P2wfD7fOmEnnmXH6Wa+MeSQb6xwyhK5RhAMN7BUrDqel9US4oT?=
 =?us-ascii?Q?ApPGbbr5NrC2bFUNUNAj/u8dPg032ZWN1z4IFi1VhfMzcXROtqsHJ7Ml03ux?=
 =?us-ascii?Q?waqnVQujOjVhhVcd61TTL/n8KeeiBVhsPTW5r4eSC09Te6OcCrSrDgKLVhRw?=
 =?us-ascii?Q?rIYf1B+fB6hHAE7TAJ2GsLKS51/UvrUfRy+/6RcE75kuZDDo8zgobVf5eEMY?=
 =?us-ascii?Q?NvwgKmlAtfv+LlTPLNKcHhB+d46Wa0rbwVQ+knXzhpjMMEKZiTu/VVMUQiOp?=
 =?us-ascii?Q?9850Y+augcbRIXI/aOhjkKgbVToCUIU1uNfm+gU3QNfyvyoifHcrRxJonhYI?=
 =?us-ascii?Q?MolC8fzVlWNTBmIcpY7SUCM26M6in5N/ftxHTP4sh2557YxPHZr2P3sfQExC?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5046625a-d38a-4928-cef4-08da59539dd3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:49.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZXBb6XhUfybrsOrBnf/wexnJy7PACSCqjbYck4pK3/qoQ606q6BPjCOAMgk+wiXY8jv/1VF20dAmuS7DzV4qA==
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

