Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DC0601369
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJQQ2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJQQ2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:28:22 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836B6E2EA;
        Mon, 17 Oct 2022 09:28:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzY8nm5mC5tsroVr8fxjxejUL5nebKJXDiuLBOxOAM1zfRxiWoSrvwesIkWI02DOWwNK8Sa4FiXObNJoA1sel+44OwZKmya/dwflhgan27oEgi9o7dO+lSYYjMJcionYYkTI4nU64gr80ErvXehegMrAZjsBze0ZiWoHvwLIo9kJZIUuSzQCSENOfZVySKnpCPpRTuIeb6IVYBEF5NAwNGG0iAjIGzvWnTJDLznNRSlqpXDaTgYQ7Y6jhYD01RK2NePmBKjFB9ug+FE42puWH06bJDn7Tvz3Re7/kUpBfQKFar2NWrONVZ348x3qDvLHWq5tdJr8UR0da1+N37L57Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l02Z7s41/WNVOU8sDakWTlz4mTX9WdW7/RM/RrMiBrg=;
 b=c1UV35LHU/qRwfBW4ldy4lXcMGUChDpoDGJMolqwvgTVX07fNcfPZK8PmrfWKQ3JIiZS1OjFIuB6AnEvA2GZ4BHS4ho05PcqsdeGRcKIU5m+qe4IHI/M82Xj1st3cnjGDgz605YEWsR9XveLGf6u+GjUzuVr+kozEZmmCKK/mASgCl+f35R9ajSf1jW05n7KiSDe/r5iaEracUK5zNLdLtYBEtdpoNWqVaqQ1VGYFm5Gohs+xFEbUU6FNJgBJomPdGBj2xLV8frRMcZdt9MsdUbQtGgCnWrAmVuKJCvyc9Vlk1ZwBInoDTm9l/XrynIvRnELZKfpuT8XB6LrP/Dv0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l02Z7s41/WNVOU8sDakWTlz4mTX9WdW7/RM/RrMiBrg=;
 b=YPH5ghlqlBYVBiuXnDcbscHMQ1DgA7JZT+IsKY/0J5xBKOrIbaHjxcQw1k8ezG8d31BgeWyJOMKe6HWeGff+cHI0G3IhDfJ/IembAHi+26noVyfjKHcP/DZnlIhfoxD755IfUYv/lIake1FZjqDZTaQacTnWIuLiqQqdmRIKrAGJY1MZfno2/aVxV+F89yL5y1dNT+ltsqXHllGz93E8TKMUIG1A+FLTGWtkuhDFH1sN1nzKzJIrRDGGIdcGNTJl7C2sZsQI8EaNQM/Se8VNwz3zTGDc8kBxpjAhCMdPINSsd5GyIN76ohNmaj9H8KZNP/SMbVNE7YdCAaPE9u2gTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB9PR03MB9686.eurprd03.prod.outlook.com (2603:10a6:10:45b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 16:28:17 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 16:28:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net] net: fman: Use physical address for userspace interfaces
Date:   Mon, 17 Oct 2022 12:28:06 -0400
Message-Id: <20221017162807.1692691-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:208:329::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB9PR03MB9686:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e52444-25b7-4610-bfe1-08dab05c986f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nym4jq2lZSl8VVN6YJ5p38bnuQ1Teq+XV8wPcZ+XqjG1IbT321AQ1saz9UAFTS42SdM7uH7rAz3rmVTS+7YdCftTGvO29+ZPcVAVv7/cLfbbPJvi1u4M1Eo5dUmPFxWU0zXxanotjmfPxsfCxeyEe0crSIYL5eRuYEkRjSCzxL9mr/ROH4oXYTRJUfQiyWPrix69HuGLt1/KNSl8LfJRspR/807bgx5ioLgZr09U9uN6ALF5eznKHf+S5Gpg8rcFoYyJrgq4tjhDpTA1Rjs5yVavfYCDB2rJ0N5fCK4SrotDKWtgUt0KQSq0nQqBtlsd+v2oAz8xQ8KYFm9c3Yk7gMRy7yskWYnhqkrvK98MEKU4zcfJQG3IiegMrcVZuBQRU8lOHnYzTSEVCvo28Se79Qj+/2g24u/wApX93JmBiTlP8zVmxBxEFNox0CCluOy6eDF0/Dg/MtR1ok0SxRaAxbIDbMWTOEAiLBIbpVAqSq6QHTCjjTMAB+JmNDsXcXnWRJtJwbkeNllbMXrJiHnm7YdzgbWeEMFrnz4PsJnQ6T3jZ04+7mQPsy2i93GyEHBoPWNL8OzSmxJ788WCz6Mf1qf5PNwDvD1V+9Z0lY7CKhoHTM/eJKkaVWvlnK6g9ghMNbcRDwVpriyUPxMWnqdFbfZq0iWZJXQoAUalrZmvwjLr6l+D0OOQkLgtJ4D//XXM44tJLAv3tjlRUR/ZmAR/DT1vk6Ni5TzaOAt3aaSBxilZLujOqIeYMQ8j5DPKq+GcoiS9Un+n+1ovL4NP6uJ2nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39850400004)(346002)(366004)(396003)(136003)(451199015)(6486002)(478600001)(38100700002)(38350700002)(316002)(5660300002)(8936002)(54906003)(4326008)(66946007)(66556008)(83380400001)(8676002)(107886003)(6666004)(41300700001)(6506007)(52116002)(66476007)(86362001)(2616005)(186003)(26005)(1076003)(6512007)(2906002)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/FGjbmDJBY24ChW/QPr3H4oktKCf4X9NBYaFvxwFfgAFeUcPOpygFpJe79k?=
 =?us-ascii?Q?lUTyA+rbPDNVlg6frJsKNhkkhcEr2p7rb6WhvA5PQejYNT9z7xK2m1fjP+fZ?=
 =?us-ascii?Q?yjkS9hK0jupw48sUY+0QIWVEyPAS4wrSQ9V3bRmo0IkVXAL5mlRAQwb0sHrA?=
 =?us-ascii?Q?1pdndxva4YnGN24GqBnfj73q6rDQ0eqfEbDMAJ/fl+2tBHMlrpUzQQeVUR8f?=
 =?us-ascii?Q?h6uIsgdlY1NDTLI2AiaNqyd2shWCqdyLUaTlFO8EkJyagKzN51rkYgzU0sXu?=
 =?us-ascii?Q?0R8homnE3BrqQYsZNazMRQtvRuG8aUt1b4skNRxPHDvKxb41a/mWBSSGjoai?=
 =?us-ascii?Q?uMNVG++hcCD6h+WdbKv4AnHGYuo4t9oaHoChi01dqoql0F8xosORZ8OFDYhq?=
 =?us-ascii?Q?BBYzgewZCZWy2prt6RxNZmcmRTklqYcx+UkgO79kLPPX/svLeCRdtHCZ7y4r?=
 =?us-ascii?Q?kWDuH/pvqU3mQISmoh9aSAzgcUe/6ErAlMIDDiuz9/CoGQ0li6IWFF2sLiP6?=
 =?us-ascii?Q?ZvNJdiV+JAkVfLnFc73J1feRXqIg72IO30VBDFf57f3kaCu9qaQ9BGLVTqTZ?=
 =?us-ascii?Q?IJHB9h2JKWqWtfs/+R5XBUIOKkAzqPdcwW+/9fLNfo88KMXJ0ZoT44cZyu47?=
 =?us-ascii?Q?2aT2EZJVGcaoSsa9VcDLa5uanOIN16JL4ha3b1FoXdx6OK6Z9Ynun0SCGfuy?=
 =?us-ascii?Q?QKX71ggGUTzHtvUHDdQ+76Gr6zHFpdug/tjBPSXW5aBiRZRIh6BQd0gqKjyA?=
 =?us-ascii?Q?Vevb/s5Cr93yF3hncfAI67bKX1qB8ke6JPKPHJOdkofXj811Pqbl1t2ePBvy?=
 =?us-ascii?Q?jZvrbyvDChV8U1+OCdrD1VUKY/BJJs5pob5z2pXVz/3PiP95DoBUfgaHFhlc?=
 =?us-ascii?Q?bib+IMWHBbR7QuqSy1dGbZSzzI7Fqc0AJG4Ec4pDYkK8ktLJEza+I0xBPU8g?=
 =?us-ascii?Q?pCQ2UITIymYANtN84meVbM7Df9cB1an/xqNcPsLp+LWSh5cocKwM1n2XB/8M?=
 =?us-ascii?Q?PX6YU/o5heQY6ehzr1LQtG3YWJKMREB0DH2wCLVFDk6ulcJ2PT7OKSciTpBJ?=
 =?us-ascii?Q?u4RKkcTOEfVpHBH61twm4s/m8Xo1lv/YG+H1aOPl0VOSKkHY+AF59zdm47QV?=
 =?us-ascii?Q?SIBKh274USjTfoaQtawwbQ9+oL1hzt+nY82MSYYBeSv6+BAxlD9JDUIWyCCy?=
 =?us-ascii?Q?Oss7TenIkjnt9nR3Io6eH98Ts+fjzlDk0futNXaDCI0rzywbCNlwIrGPAHCB?=
 =?us-ascii?Q?siU/54L60W44njt9rqlNxQxOui3+eGb7x8++h8F/qQ2G5CqjODZkxhxwTJvf?=
 =?us-ascii?Q?dLg+IUM7ZEYZN789p2IjV9MTJZx07NzuONQeeMIRvnrwocmpBg3dsu/IypEd?=
 =?us-ascii?Q?SZjfcb64LbQS86iUllwEDg2jxt4O3ymSZeOPMAy5oouNOddot1Bjg2XC4GM4?=
 =?us-ascii?Q?khxXbFv14RbeFk50k6FS2c4BhH8zlSxNO2sM1bl5p0Gnde1lVpK0lEm8hrxM?=
 =?us-ascii?Q?OgmDDVdYR6++WYh/ttRkZ2WcISRyEK8XZkKDENga3Bc3GgKzJulxig93Aal/?=
 =?us-ascii?Q?ArrMTM79ydHl5Kswf9jRssOX6RM5asCpE75n7ydQRTBOeErakdpDkOWL5xIf?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e52444-25b7-4610-bfe1-08dab05c986f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 16:28:16.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5drUY5vkzssriGudQUSAERf9gaIcZl2xs0I2dutr92fA8Pn7io9ROhb2/iMD0YwPEg3C99MJw7vvkfMgzG4dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB9686
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For whatever reason, the address of the MAC is exposed to userspace in
several places. We need to use the physical address for this purpose to
avoid leaking information about the kernel's memory layout, and to keep
backwards compatibility.

Fixes: 262f2b782e25 ("net: fman: Map the base address once")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c       |  4 ++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c            | 12 ++++++------
 drivers/net/ethernet/freescale/fman/mac.h            |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 31cfa121333d..fc68a32ce2f7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -221,8 +221,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->netdev_ops = dpaa_ops;
 	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)priv->mac_dev->res->start;
+	net_dev->mem_end = (unsigned long)priv->mac_dev->res->end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index 258eb6c8f4c0..4fee74c024bd 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
 
 	if (mac_dev)
 		return sprintf(buf, "%llx",
-				(unsigned long long)mac_dev->vaddr);
+				(unsigned long long)mac_dev->res->start);
 	else
 		return sprintf(buf, "none");
 }
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 7b7526fd7da3..65df308bad97 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -279,7 +279,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
-	struct resource		*res;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	u32			 val;
@@ -338,24 +337,25 @@ static int mac_probe(struct platform_device *_of_dev)
 	of_node_put(dev_node);
 
 	/* Get the address of the memory mapped registers */
-	res = platform_get_mem_or_io(_of_dev, 0);
-	if (!res) {
+	mac_dev->res = platform_get_mem_or_io(_of_dev, 0);
+	if (!mac_dev->res) {
 		dev_err(dev, "could not get registers\n");
 		return -EINVAL;
 	}
 
-	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
+	err = devm_request_resource(dev, fman_get_mem_region(priv->fman),
+				    mac_dev->res);
 	if (err) {
 		dev_err_probe(dev, err, "could not request resource\n");
 		return err;
 	}
 
-	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
+	mac_dev->vaddr = devm_ioremap(dev, mac_dev->res->start,
+				      resource_size(mac_dev->res));
 	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		return -EIO;
 	}
-	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
 	if (!of_device_is_available(mac_node))
 		return -ENODEV;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index b95d384271bd..13b69ca5f00c 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -20,8 +20,8 @@ struct mac_priv_s;
 
 struct mac_device {
 	void __iomem		*vaddr;
-	void __iomem		*vaddr_end;
 	struct device		*dev;
+	struct resource		*res;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
 	u32			 if_support;
-- 
2.35.1.1320.gc452695387.dirty

