Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA31E618A4C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiKCVJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiKCVJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:09:03 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0841022BD6;
        Thu,  3 Nov 2022 14:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJFVj9ZvnIPbN/eJA8fYzIc2GYXh4RHz8pJX1VFzyW2a081EUFyS+kvGLSY2goIfFliS0OiTNkXA/dWI6whFLEXOLYl5yjaoZIW+IvTdcTiazOv/lq6H6ppkYfcJYHE6DiJoKm7qdw3fiylX5yexRHs+1agt2GQcI13KLFWu4OngGw+LdZCsSgcS1X39/7nYLSn2BucCBjlbUzALSoOHAF1OZIFFGaWhPXd+CX93ZfRQSP9yz9X476mqs9Uxny7GztMzD5oD7CkkZBNC7P0LwK9/3BpvS5vMpuDP+QMser/dL/zzeZ1p6JbleEF45BwNUrr0y6blm7F+eECt99oj6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3MtNRL413X3k/X7nxqUTT+4HJJ3KpfmqPoEDHL/cGo=;
 b=MN9e8tcAxpwdf+Rb7ZYPz5bwPb2hdL7KsNfmNSc5yFuuJE/5KRBMzVlkV00DvB7w71V00KMbnR4IXHdNeDFhRvnNK20RqKfpCy/ZiRBSdQ/ysbmAVyYRfcFlQ1Xdm3PgUzHBWo2tKcNyEIT/1QqulGs8rMG9hEbL4RHr6Rz0rbU1pTBpqlaTLIPlDQFA88G4ybgvCR56wYuXquW8JqYhrzaws1EiPyTG/KraNLMugBMzhGKPSZj599NQrfU5nYjI7NYx9ZtavgBmlEF+UyRRuG/PKl01sVg4JjZ7tHCzxm/ACe88RNlYb7MB3/z+0KC0eVRu5RnItCL4oCVJGGreAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3MtNRL413X3k/X7nxqUTT+4HJJ3KpfmqPoEDHL/cGo=;
 b=W6NQfrVH5CvjXO59tIKLMPHd9AmVMFibiyIMhX6/7kQlD9pr44FXO4HD0EduZJcCDaNAxO8tK78mrfbKiBeNlBR7TR6tkmw+SAdgyDUmWhU079cK0F8mpb2VPRDYOAD1rjYQnhCvJyWXtWsw1odXHNs92iND+bzub/YtALm0Vvy6IentNozfmlRFdMmW1jqzo2kPOCeE4Qf9o8tM9tNC4VSRf2DoTxyu01+GiNLRQ7U1LX31zGBWX7nacmh0xV+j0wrVMHwQysN6UJEE3FunsAkLXLc3q+JtrpQDnXaK7nsKHZVRaR1i0ib/JI51guY3y7elmk5O1Hn1NSHIpQuwJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:19 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:19 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 10/11] [DO NOT MERGE] net: dpaa2: Convert to use PCS subsystem
Date:   Thu,  3 Nov 2022 17:06:49 -0400
Message-Id: <20221103210650.2325784-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0949d7-8751-466a-3d49-08dabddf64f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvstXsSKBG78h/k2mxolxow1Fk35OKzeyZ6KcYSmjCa5VEoMYf+3bXwyg40xEOv4T5jHbXQvO8jzviEYNgkgl+ryYjrNBjM+nOsS1MHWyFmaFF+7UuMghFWEl418h3lvbJ2pkQc6pjTJ0N1+nFsP2trKi6h9CU6onJ4pREsCtEm21NhExGVCaBdIwkBpqBuPN8pN9XfDbh2MRVi9oI0EenfpwnxFLPfB9qdMjywRoh0vHPQZ1cg5MKIsPpKlg4Q8uJZeSbAmRxldLwMATi1sTv/ga6UHGocn5RODyiJAozGVnxx/QUa2MhOPuYlTl8sPWG5gSCPkZvkjbXMjM5pDswQwYl1/uSyDVCY8p4yx9tXck2FUtG6OeuR0YP/yzZMU/6kLJ/zkfyV9ehBJm8mk8aXaO8/sOS2VAzUoODbQOS1UXf1vxulcECPCaayI+OiW9VF8XZf82SZTKb9Jy8dMOPASw8nrha1hLr8VTfz2SpJbH/ajQKw2vrv/gkcNdu9ojS89khraeVffE+h+2Ms/BbvhYv8fY7IQXKcY4TLfkyUKtQ9E4qdCCfOmoQ+kfvQtyfJ3qyY/cWur7f5L5ii7tJQ+RzTygXtuBcfhCKOw3sZ6t125Xl+H8g8+bFz5GVeExBkqJO5Ftaq1QFSzZmtyVvgHR/nHoO1rxVYAbBHPTG7yocpRHFDC8bCFg3gjGVbIzk78rwWhjDmM+5Dnv1nE9GJErRtH9xdo/NcvkMwZtvwiLOgzoMldjUh9czoc8tcn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kM4TUtl7DHANAom/zlxZSZTfjU2hA56MpxLiI8GXHUrTAUOpRZ+K27Xm/8ez?=
 =?us-ascii?Q?YtS061E5+oq8hUwuDZkq+4xMpidjnpmS8+QBoVbWbfzrt7vRjdRmjVs380YU?=
 =?us-ascii?Q?vgDJuBlF4FvnyyptfvOvSfkwirb6uJd8JK5q6PHYG0bBwnxiVIzpl82BdS2C?=
 =?us-ascii?Q?7hbhkPh2HuukHKSMyjvW8Hs2wlc+NQ9lYenWzkePZpjzuKGnobFZ47thA241?=
 =?us-ascii?Q?sVm2vHAeyyTUFqqzNQReaLlg0DP86kXLe14QDFwB35ycnLExp7dRbVMuruec?=
 =?us-ascii?Q?KtVUoeOpfkig3JMhT5IM/LwRzLjGxIiJcPUwEXUl74ToB9mvkJy31v9uz1fI?=
 =?us-ascii?Q?pCq+NoE+Q1kXtS4u650eSFSEntRNOBT1vfxfpRrfEkVDAI0H+xqwdjQq7+nF?=
 =?us-ascii?Q?XiNqoPUfZIjavz0Tvd3YuIgDHbSzaV+cPXg1VBTqe1XlPXxmbqxOXFQoM/oR?=
 =?us-ascii?Q?P4+rC/vdcfkNtY8OxjqCsf7IndR2KfDSBL4TR4/1HviTVAXTVGpA1zPgwPLr?=
 =?us-ascii?Q?uahENXdbCGzTm8TtcZ2NaXFabx3N9w8FYMyDx8aqZeP/3H301b3LUCmoPyaT?=
 =?us-ascii?Q?3eAFnU0wxs8sQJKuYP72DHrwVceJRdOFqEgfGjwZUza162n4rDh4k1Er16Fg?=
 =?us-ascii?Q?9KEjayPydAQnY5WP3og+dlFzjX+bHqXfJKybY++ipDo0+kUjqN/rwrc58FFj?=
 =?us-ascii?Q?zy802PajXCoKN2Nkrl9dpJZsdbVSBJhsk3MA2f9s24vtdLh2SaVUCHeXhPCq?=
 =?us-ascii?Q?MaE8nUJhk4gY6OlDmMpkXsbblddOSPcDGwiny5HRxshrOgG8l5sk22TUR+56?=
 =?us-ascii?Q?6fdtluNa6hSvODnRhfR1nwkAvSGcQWWtnmWUrmJ0/4Kn5l4Wr8JxTsTOV1Ln?=
 =?us-ascii?Q?Be0WEkTha7EkKTKnWiDe7hfx70mKyB7qSgmM17G/iWHcNKFA/h+Vv30erMhq?=
 =?us-ascii?Q?FDhFmLuyunhU3SxmEI7C07uN1DfcG/G0ek3J2CxyPdnlFEpWCMR9d+ERcTmM?=
 =?us-ascii?Q?qGCZ6i4xWHAacLor4433YxoLsnsi/bFqYrggkIosHmG8VHF8jzZ/5th2cZ+5?=
 =?us-ascii?Q?1jGlVq99RpXaKkARSb9Uda2m7gLUzfG1+TG59W0tGmmNzhGVIEkg4wjJ/VXC?=
 =?us-ascii?Q?ghr4qFewNUMBLGi6Z4YMKVE553W13gnDoYdc3kb1bwYRogItmos2CANIGbEM?=
 =?us-ascii?Q?5wauhqFad2N8qydnk94Rm9PVRNWrsn8wf0DDATHKL9VXTH4cPDHif4LzoY8z?=
 =?us-ascii?Q?XAXnSPV749MJcCJJjGrTvzQTuHL6q+eC+9ZBpWYIprH3gRD3wM85zy5+w6vw?=
 =?us-ascii?Q?TSgxWET7tZDuIOiH+qCmEDTWNTdI3CtxwcbGKH/HmymxyVolKdvvHle+hpg6?=
 =?us-ascii?Q?PBMg8SBRsWeDm5DIKCKOXe/kwp8Bf/K9wi4ZhPEBUyiniTahZM6pvj1dxSAJ?=
 =?us-ascii?Q?R8EAQbjdNuf5PT49taESwzd625DUCl9vXLp2Qa8JtOVhbQyzSqdKrLSyXutA?=
 =?us-ascii?Q?MgCBDMzZFjiiSlQu85Gqn3vNICFBmfgAX1FiFqtOUTnktT8P4Xfyk5jj59PX?=
 =?us-ascii?Q?6V1q50ZjfU1JLfG+oNbI0HIsiMUnSmErpR8hXaDNzUPJl9T0UyDFC6Eee3Zg?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0949d7-8751-466a-3d49-08dabddf64f3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:19.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAAxq4b9khpzurBgAAgMHQvcv+utKDs5aw7zi/AU36Tc05r86fam2dpv6nQxG5OaUQYhZElUbHrcO81tlsjjEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the DPAA2 driver to use the PCS subsystem, instead of
attaching the Lynx library to an MDIO device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Split off from the lynx PCS patch

 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 +++----------------
 2 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index d029b69c3f18..2648e9fb6e13 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -3,6 +3,7 @@ config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
+	select PCS
 	select PCS_LYNX
 	select FSL_XGMAC_MDIO
 	select NET_DEVLINK
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 49ff85633783..18f8f9f8d161 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -2,6 +2,7 @@
 /* Copyright 2019 NXP */
 
 #include <linux/acpi.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <linux/phy/phy.h>
 #include <linux/property.h>
@@ -246,32 +247,10 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 			    struct fwnode_handle *dpmac_node,
 			    int id)
 {
-	struct mdio_device *mdiodev;
-	struct fwnode_handle *node;
-
-	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
-	if (IS_ERR(node)) {
-		/* do not error out on old DTS files */
-		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
-		return 0;
-	}
-
-	if (!fwnode_device_is_available(node)) {
-		netdev_err(mac->net_dev, "pcs-handle node not available\n");
-		fwnode_handle_put(node);
-		return -ENODEV;
-	}
-
-	mdiodev = fwnode_mdio_find_device(node);
-	fwnode_handle_put(node);
-	if (!mdiodev)
-		return -EPROBE_DEFER;
-
-	mac->pcs = lynx_pcs_create(mdiodev);
-	if (!mac->pcs) {
-		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
-		put_device(&mdiodev->dev);
-		return -ENOMEM;
+	mac->pcs = pcs_get_by_fwnode(&mac->mc_dev->dev, dpmac_node, NULL);
+	if (IS_ERR(mac->pcs)) {
+		netdev_err(mac->net_dev, "pcs_get_by_fwnode() failed\n");
+		return PTR_ERR(mac->pcs);
 	}
 
 	return 0;
@@ -279,16 +258,8 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
-	struct phylink_pcs *phylink_pcs = mac->pcs;
-
-	if (phylink_pcs) {
-		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
-		struct device *dev = &mdio->dev;
-
-		lynx_pcs_destroy(phylink_pcs);
-		put_device(dev);
-		mac->pcs = NULL;
-	}
+	pcs_put(&mac->mc_dev->dev, mac->pcs);
+	mac->pcs = NULL;
 }
 
 static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
-- 
2.35.1.1320.gc452695387.dirty

