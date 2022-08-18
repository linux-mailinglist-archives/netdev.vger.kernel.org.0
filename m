Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB395988A6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbiHRQTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344608AbiHRQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:52 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654EBD0B8;
        Thu, 18 Aug 2022 09:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYe1/KqdY4vwUQPdWGdDaRcC/mcmeZi6ZttGHiM+58ix48GcRelT8JQ1iikrQEBiSN8s6q9FzjwFpnni5F7t9R+mdIkPxfyopE/2RoTa1JC19VTxWPQCCE2CdN+Mp/Gj7aKB4msl2LpYgo+xGLKMv/idBK1cnquXYZ4UIbs7pVlF1N6DNJppn/AZ4VQOL+oBSMLNzHD7Gh7c63Q8sSDsUh1uMHOFXjQUW/0jl1lHCqWo5dyuLTI3pVubwfOc240DZbOdFL6YL7pS+cGeyqqXahzbEnJrdvNZJSXi8ErFGi5PLSC9TxDCIgN73cS1tdKsJD5Ak/3S5ylAos/hZtJuJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGWQbBEdK1su/g5tIpfT1wDYLHV0nYKXcAAYaa2UHiA=;
 b=VZQpnueuHT0x6qFyCABXXBZqU5fCFBi1vvSlrgZhyuJf/aqdyQKeWj9FQeasst6KkO2j56n0/rvulH380CLABgDyYOT/gGmvfzc/VO3RZHxyGDX0DkuNNUuI28uoFjVVpTbGpkSDUlNxNYgDHej8/me0y4cstpTc7IBV+NEU1xAJzAXzLAD0PK1XUiYtEiRbVBQGqdzQ7sJD+7tT1DSBW1TJP5RFWfX2/bGQz42FCklFtVB3jAEVAn3j14xWjml8M6nfe/rpwM1qao0Jx64u2g0OC4nMTZu0ZKocoumQT0kffTs8bNr6Qn6PourZKbE9MSal6+gijVGEdEh7PiBQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGWQbBEdK1su/g5tIpfT1wDYLHV0nYKXcAAYaa2UHiA=;
 b=I6OlaceOB4bT5C9Ft1Djnb/nfwnm1n+N1LNvUN/VaYoLFemIAKcJjg7z65Nvt52oYhojW/G0MBqq0sZBtg506TE5a6QdPHyGDHkyHAX1s4yEitc+tV92ognFc3Nzb/TKvfmr4JfAbhm/1TeahiuI+ZxEZYfDB5zQ/kHKDE8bGpYZF/QxO3mb7Bc0qrt6hl27r6z/RcZ6bMg6WIilG7S3D7SJhRwW56mQ8p+6eEaKNcB1A8JrPIPRQQNjENrAviqGAO80/k9BN/wTaxZpEFwjc2/pYN0ncUPiNLn+TThFmiaB01+ji/R47QM5Mjxpkq9aNj6nfnftpvlSmEX1NYWw9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 16/25] net: fman: Map the base address once
Date:   Thu, 18 Aug 2022 12:16:40 -0400
Message-Id: <20220818161649.2058728-17-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60311f5e-8d9d-4368-ee90-08da813526ee
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XjSHCqIolUvZD53fvG0SiWz7FTTinR06sBvI1U2IOfSZXNef2B6PTfIBzqhmFz7ek5s0H/5zTiei7KrxgZQKVCDk4Oz5BsLbMr7HhKK+b8GbNipdzj3ZLa+MkWMBCirVVyR7yCn5LueaZIXGijdAiVXMlA3FBRWMoZlatfjblSDBcdXiGBuAcpFbZNHZ9yaPetvip+nlauFwdIEbEXs4WjvpVmY0XntL6zLagZZpcP2G975Jca3wUQqJZa8Du/xEUKgi4ZVDCrZSTgT3M917GQMg3l+T3fVFO3e6Zm+5E4cdZLDWo0qANGBtL//7JZOm6XpUl1OKrMNWfO3cv8VoDKUkxfrsw12CbSJ8PpsI25l6X5wa0wIdw0fgZ8giHAhzMJ03y/nJhPiZJ0Xpp0sPYMQ35ZxA4+k/87w+udyI2gAn+wUm3tgsDELIB2fTx+017L9Qukiqv4h3Af4MvxH4eyih+zpT2h6QC+ZNBP2bc0bFUygvEb3GeOKX+TOGfl5AaD64uYEbKccN7BmZBithxymO9bqezAL3NADE+cgv+mUDEqZ+dJEqZrzAnsXYD+bzGERBDywitdus5SYKiAw3OBci7XQgCLD/Tehwe8C4jP02VTxGOgE2mTCzYsqqNTk+dKlutxgKETB2FgLpx74I0fNN4TdUCtxVw6NHiQ8CR3RNZm0K1vaV5GPNV1y89uc2kp8j86ITAPPcglfJGG13HFIV7U5vD+EXmcMAra3sM0ZOCSzwdyoUUHEoG9x5Z6x5p/KowNJHDnFqZoJ9e739Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIFIdSDoPpl8ARDf0VC5YRxSwFMQWO9qpW6g4iZoxLh+1DZTsdr0+7F52EI1?=
 =?us-ascii?Q?jhD/Wez2F9CoABZUXrEZ19wY5R/1jk0QtmUKVzbuRzMmoRq/jXGKsShnINbC?=
 =?us-ascii?Q?twrlybI9Y59thiRTSGueb07B62UmML4LssnFLYByHakZ1PoXsU1n+qJ3IlKl?=
 =?us-ascii?Q?ODvhOJyLXD4FvYjlCvIZ9EDZ6JWtbmIb6whLEyaRnQW2Yzr2kO+GAqed8ZKq?=
 =?us-ascii?Q?QlVquPu1dhUFFktVqg1H0Q2cIYXEy0caY/BGy7Xd3gGVls4EU9PKQpFEeSwE?=
 =?us-ascii?Q?MwhbgxrKrVo3U+Lmlq82GB3F78k//vPK5gFe/IE5bJKm17jiB9Xr5JZ/Gtz4?=
 =?us-ascii?Q?LPd93Ve8+LS83o7f/L5yMTBjdoWJv4P0J8cQph8WULC4ik35zGQcIG+eV4MG?=
 =?us-ascii?Q?77n+wEzpNdDY6Zfc1YGXI6Qo9DoYYSGriZjIBiwiROdth0k5V/qnIwIkvytr?=
 =?us-ascii?Q?UXF0DYxiBtrACqtwToZUlLapsoL7PAgmBYkk8gTvqPs7WNsl1TFGUIBP+6kS?=
 =?us-ascii?Q?4TSoLDEUreOpP14dR95PIp1pcga9vIynlS/tE+29mGr8DClnhhL5ndV/TkGn?=
 =?us-ascii?Q?TlFMIE3ghlXbogpuYqanv8yx3d49kAVF526TSRT8SP5HtCv/duGpAWbCmCJM?=
 =?us-ascii?Q?23fdMZANkUSv56wQqeEYJYJx+XB1JpmRroXQDuNZuPqXLh/sDm3ravuD86iU?=
 =?us-ascii?Q?Z68oA8xAIz8I4Rp66rvn408SCnYyEmnT6vn/k60DHGJsEzre8pYK+qSCxwcF?=
 =?us-ascii?Q?5+DTSq1xmEJO/SXr3vesc3plEduonp9lBDDsfREJf1mjkTjtRDAbIwaLCLat?=
 =?us-ascii?Q?3M6I1gdblEW4nVb/gCFe5R5qXc3ftVRRSJFwlk5Clq8ae7kb8+6s+8yktghS?=
 =?us-ascii?Q?Es2uAaKY4eWG9p2SnHrMkW+BBMX2Shv1gLXT9E/mIMEQblmYEShrkY/X7C3z?=
 =?us-ascii?Q?xnFHvLao5M7z/e2nt1tP7Nf1Ohae6dIPubpDhwRu3M75+TgkFD9FQ+kpXfQr?=
 =?us-ascii?Q?mtW55NEto2QUBc5cnb65mKCfRVsbQBmyD391H3xhDC9GkpWffk4si0S9dFZY?=
 =?us-ascii?Q?lkDgmzmBZQrqGb9nr63+2g+Io9g+FravbReUPOxKlJWMJXJjpUuPPH1lnI85?=
 =?us-ascii?Q?rvBy/2kqbeho1bz0RApC9Sd+B7+qvv7vRavGqTMRL39kRCJaMrSGQk8PTF1e?=
 =?us-ascii?Q?P5JyAyzOzW+3JiJa+vr0Hi3YJnqXG3+n26doWhHbEMDoH43O2Z0VA295qWoH?=
 =?us-ascii?Q?uZowNMrQS2DIN6TNpPx3+JWZZOmkeZi5HaSNM4jCtXh0kUahVW/PPzE8bl8w?=
 =?us-ascii?Q?hMdQjrOGnZUpbf2z1zC7YwyZWQ9NXZYMAqLEDsVvqIDAoDtc6u5OrNzyzYM/?=
 =?us-ascii?Q?Ccpo1ml2YfyOyMWo31ZauMftXs/yQD36GajgnXI+WGkn4lTnqTNPMFqSuPv1?=
 =?us-ascii?Q?jfSwOm1RONzz6VtkdzPPy3jTGOHHnzC2Rg2JIbMO/G0YkFu7XLYX/9T52IC7?=
 =?us-ascii?Q?FpZjp3lSsy9UNG357algpndghUmLbD7ZioWZSLXol/X93efb+Szro+im6qGX?=
 =?us-ascii?Q?TVkURg2QcnwsaOYcqaE3W3rFg8DGqq5i8eMGyJvrpp4zyojPTM52+Cyn6drx?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60311f5e-8d9d-4368-ee90-08da813526ee
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:31.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcmDekdhNQHhSEu353MoIfWHgfMnAAVbq9gVouRaMhKec/7pAvLlYfx7XmK8Lz30aMSVj1mOMQBvPfWvFrkyRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

