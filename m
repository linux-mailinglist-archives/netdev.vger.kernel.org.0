Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDC7618A49
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiKCVJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiKCVIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:08:41 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E8521E26;
        Thu,  3 Nov 2022 14:07:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jikYOXH0vHXpayigu3PkKbmPxIJBU0T1b2lA64Il7acca8KtX0huheXEFjtYJY6sCi1BPYcaBkrJME+Bt0roID7hvI/0NAQIB2QbLAkz7HnYRZxnJCiPvtNU4q1TxzGFb2uuuEUkd33mSWf6zXrPAkSerq81k/BHOEy3hj52Rrc09gC2lYdJT4ThIVAoVkz2+rd+ABOUp4o0ZJpDm5xEG+6D75sQ3XZeNpJCbijHsmfqVmM/TEKopbOvbtttvytK//U2kKh+jDxd0I3qbPJyL2PpA/hhaPTCCHuv442Ouo9GkAZI1CCntdRV+vDhKR7djVpBOpv/wIQSejRKSwYHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9P97/4EQiRknWb1rlkyfzH0nFWRbN8q/Zzg6R8X7mQc=;
 b=fOSJdEcD/v0IfrrtL/KZt74N+crYXJDKI6tiQQWyfbSrZ6AUTAFw+hnPPVr3eoTw3J1Zly3PbcWY9/siWjquzb5SxANGwCxwGYDj5GBvbaxuMfWIbJGJLNT/CuvCsa3cOVEZUBVQ+BITuxRKu+WU7kmpQHUvHoHdO6cWdNRvRp6Pwk+DQKwOfrJ9hUiPuDxUUYJhgAq/0ubTZB1tyhw3aeiEoa8lLH2Us7WqDqxQ3Q3aRSZ3ikHvecYsU1cQatEkw0KmtEEfxvAnZURJSP4ZdEg/BoPv46dhFG6UGcDktL/fzt3FiiTyUw2ltXe0XFs1JCRMoUxM4vET3Z3Kg43mRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9P97/4EQiRknWb1rlkyfzH0nFWRbN8q/Zzg6R8X7mQc=;
 b=s4HfYFPNiW4dsP24NRd8sh5omXGmqbCttIMNLeIMOIS57cIpBUGXgyKzh/RseqA2+Qrehq/EBaX4iFdnp3G4CDQGOUHlX9YOeJTXqcdZOsL0mSFDF9tkbGCz4sQiELo8+oE6T4p5DUfD37WVuhQZ4A6GzfXecH3SasgZZVovS4IGUnZO08UnKsy6BxyFndTS2pfMEX46hmRAqQkU3UgxlXaXhI+bfG3V6z0cPLVTur03Kvst14V23hBiolu6/7HBwsDLpPMJ67AJKbfZGjs0ttAZ2iR0j6BhaSte8sxhNQrfuLhNzoJfLYf4PRuBdNE1vO1hjIBgXejNI+XpQShtqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:18 +0000
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
Subject: [PATCH net-next v2 09/11] [DO NOT MERGE] net: dpaa: Convert to use PCS subsystem
Date:   Thu,  3 Nov 2022 17:06:48 -0400
Message-Id: <20221103210650.2325784-10-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 478137ce-7086-4cd6-241f-08dabddf6413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDgP5K5Z41luvkVYudipssbPpTdg+iC7YfpRZB+mAUpuigq2mpJwOd/vruM9kvoLuPQNfqJ+tVx2hl/HBYBP+PWAsQTMgDO4mnqM0THSDVEm75CbKKBqHh70E9r55qVArGpkr51RBeGpQRHEGa3M7ApMkcPj711bTst3f+0f021zaiHqH/zAf0CsZyQTOgQ4KSIXKkVT9ULh33U7ocE99nYcSC/f/Ir3r/lDMqVninj+4tnTlblxpzJRsghn26w3Lo+i7X/PLID4n6Gwzqa3oh6XxeP9YCzjUD9a8e4wEG3IDPGjnfjnC53KQt3E0WKAtUI/90f8yZPum52vbh4Vu2W+QiNStfy1yL7FS8DZBZZfCxIdQOROuB60+iU8K1wclqxSe/u7yP3INDBwtQFKMMku8Z4VV+w3kArc06wSzW8+2JNd3MaGS+BwqpfBjZPEMByX38WWQommh5vhbew7tQYVc792Yg60pRm44UkR4cJo1zhQfAQGTdL28raTGDo037DOR/3eNcW8mD0/3rDmEEWtQ6ZwwvemZGcXk36EJn1Hu2yjIxPfjyDkb5sImVwyQIsWIhecCq011rWcKEiDQ6VCdp0WOE/DuuvIQj23y3ZEliQkZJ9dEja1tGdvg4rcKAJQkeraFH0n9vRvfeE9VcSusgCOj7Oth/HjNbt615Mjbkd2Nsr/TLaozOV7qugEHvl01SpokpLzpO7Z/ni6xOvsSo2AkEieu19pJ8MiS2ENHxvkCt5yUCdWZmEQgqZ/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v9MsnWXReTj8O5dNS2dYLJhMhZBsyBGCdfp3tMMgGWHY30Og4w3eCyn8TRAI?=
 =?us-ascii?Q?3LOOokFovyPknMB5RRYRrqL9T/6V7Kr03R5Woa8dnazmSYR9Reho+Mgg9KA4?=
 =?us-ascii?Q?8t5tiTPsdt1Bwd3fnNYmY9qlzpDvsomXDbtYU1H90FJ7f/Zfsp97CC0kGULT?=
 =?us-ascii?Q?6IxGFtw9YsccmaASffcnKj5reIwJZW2+8X3/Phvwdf1kl/zq2yn+jNxZqmnl?=
 =?us-ascii?Q?rv/9aQVrMF/QQj59fAj2P5H03+MGnSVwcoB6J+NDJDVLaUpJ1268uBwmPaA1?=
 =?us-ascii?Q?W2lt+nlcH1uazklq+a8p0jMXYfKe0JEiyLaSr5YaMuCcpaLnbD2mwe324x87?=
 =?us-ascii?Q?PMlJ+GdxzAEzjc7T6Lqy9o3+yRe1wTRGu8/WDdJ/6Ai9qlzcWhJKR1QvyDSD?=
 =?us-ascii?Q?SdgqFLibmOpFS/pYR0F7UcGcsCmUPFefRw7yAlSvj7dGqY5hNWFLAiJRhA9K?=
 =?us-ascii?Q?6uJ21sdTEgfHabF07nzkXoLA1n6w3Lb8yh40WJxVMzk8lHAR3A0lp3DhD+bD?=
 =?us-ascii?Q?t245zQ2rmWMG7hkQsNMk2ifU3Dcy+4zBFhiaDg9yTlU46Ig81rr0FVRaW5ws?=
 =?us-ascii?Q?2iTQqw19QiRDPtKeEEzbpZkgh46rR5vT3K1jAMuonmfQEin7JSh7zUhKRZjc?=
 =?us-ascii?Q?ALVIC5aOoLLr9pm9KYlLl6LcoMQP8jk8dX7lpHk1GRE33DaZAgMcxZsXu7d7?=
 =?us-ascii?Q?nSxvzAm2qVzEw4pvrMZcrRQ5eYFCiCU8Ts4C3S1K3QuVBsLZmlD6/Ia6oNmc?=
 =?us-ascii?Q?BCLaMVUVlDw9Ed6KOnJTepsRzjKF983TPGw2wzncRSQF2aMEkzGcdzhYOgNH?=
 =?us-ascii?Q?CRI+AvfmANuPse10w93EfaGladkmDoe4Sg2gRk6dHHumL7orW13UltLwt4GH?=
 =?us-ascii?Q?0DD5lUbGO2H/zkpGJ0o1+2bc+WTg8PEMJ41eU7bc+bd5RwtQ6Zx1a66YmAkF?=
 =?us-ascii?Q?tCSDiMpQzHgp4wRjTy5pEyieQk0PGAXk0N2sdVDQe4P6dx3Pc+2BFlEDvula?=
 =?us-ascii?Q?/qfyZ4LRHqic+3+Zi7Jp6k5UANN20HKeS7pnBDBv5PZbHxAP/ifYHNBrgGrE?=
 =?us-ascii?Q?6xW5t2zxhYOPMr4UzoXs7aUl1LszvS1u2RkL6eqh/2McmM/+ODSjUDK9X+Oh?=
 =?us-ascii?Q?f2Q09zvlJ7Wqwm3AO1gfqLFiyT47HlwxAb3U1Ntjv/xlGe21R5djRXz7odtc?=
 =?us-ascii?Q?zTOIi5XpEUuHdvorq0eM2Y7hD2/4hjyx+vzxQItDqSMU+/XPkJdZPq2Jj5XT?=
 =?us-ascii?Q?UClkI3sU6bkT1whd4euBECNljOLhecq1aXliiWSIpIa8lyjn9y46F3ak4zVu?=
 =?us-ascii?Q?WCWCU908JA1E3SwUT75hGpMIvHhWCLpuyoaI1wt93kjBf0p+zRNltlJylnCG?=
 =?us-ascii?Q?UsbKFl+1QAu4j2pjZo/m/WnwQm0JeJZomE5jNKOBIzkgrlWTocVqH1JCvcgR?=
 =?us-ascii?Q?sQUYYayKDVxMqbxaD8b170SjyvfuHPTbVqVnoF/N4brUuiK6CRLeV7yy6afr?=
 =?us-ascii?Q?UZTinWKdh+aBq7h1xZb79/GPbhlcDY3ujMXCUttYMp2qO7pE4V1erjq5h28+?=
 =?us-ascii?Q?xgXwgy7sblWpbnc81H6edDI9zaFaMuoNOGj/b5aeNmebVd+8ija3RoyqM5TU?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478137ce-7086-4cd6-241f-08dabddf6413
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:18.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o97kLHUxCjOc058wkOCyMuJywwrPnrVAlxvTmCes0bbQ9bPK8uMsG+qpveJvEFZ4H/HXkeBpcH5Rb99HnD6SMQ==
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

This converts the ENETC driver to use the PCS subsystem, instead of
attaching the Lynx library to an MDIO device. The control flow is now a
bit different, since we don't know whether pcs-handle-names necessarily
exists.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Split off from the lynx PCS patch

 .../net/ethernet/freescale/fman/fman_memac.c  | 118 ++++++------------
 1 file changed, 41 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 9349f841bd06..a88fcfbcb5e6 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -11,7 +11,7 @@
 
 #include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/pcs-lynx.h>
+#include <linux/pcs.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/phy/phy.h>
@@ -974,25 +974,17 @@ static int memac_init(struct fman_mac *memac)
 	return 0;
 }
 
-static void pcs_put(struct phylink_pcs *pcs)
-{
-	struct mdio_device *mdiodev;
-
-	if (IS_ERR_OR_NULL(pcs))
-		return;
-
-	mdiodev = lynx_get_mdio_device(pcs);
-	lynx_pcs_destroy(pcs);
-	mdio_device_free(mdiodev);
-}
-
 static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
-	pcs_put(memac->sgmii_pcs);
-	pcs_put(memac->qsgmii_pcs);
-	pcs_put(memac->xfi_pcs);
+	if (!IS_ERR(memac->xfi_pcs))
+		pcs_put(memac->dev_id->dev, memac->xfi_pcs);
+	if (!IS_ERR(memac->qsgmii_pcs))
+		pcs_put(memac->dev_id->dev, memac->qsgmii_pcs);
+	if (!IS_ERR(memac->sgmii_pcs))
+		pcs_put(memac->dev_id->dev, memac->sgmii_pcs);
+
 	kfree(memac->memac_drv_param);
 	kfree(memac);
 
@@ -1039,25 +1031,6 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	return memac;
 }
 
-static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
-					    int index)
-{
-	struct device_node *node;
-	struct mdio_device *mdiodev = NULL;
-	struct phylink_pcs *pcs;
-
-	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
-	if (node && of_device_is_available(node))
-		mdiodev = of_mdio_find_device(node);
-	of_node_put(node);
-
-	if (!mdiodev)
-		return ERR_PTR(-EPROBE_DEFER);
-
-	pcs = lynx_pcs_create(mdiodev);
-	return pcs;
-}
-
 static bool memac_supports(struct mac_device *mac_dev, phy_interface_t iface)
 {
 	/* If there's no serdes device, assume that it's been configured for
@@ -1076,7 +1049,6 @@ int memac_initialization(struct mac_device *mac_dev,
 {
 	int			 err;
 	struct device_node      *fixed;
-	struct phylink_pcs	*pcs;
 	struct fman_mac		*memac;
 	unsigned long		 capabilities;
 	unsigned long		*supported;
@@ -1101,56 +1073,48 @@ int memac_initialization(struct mac_device *mac_dev,
 	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
 	memac->memac_drv_param->reset_on_init = true;
 
-	err = of_property_match_string(mac_node, "pcs-handle-names", "xfi");
-	if (err >= 0) {
-		memac->xfi_pcs = memac_pcs_create(mac_node, err);
-		if (IS_ERR(memac->xfi_pcs)) {
-			err = PTR_ERR(memac->xfi_pcs);
-			dev_err_probe(mac_dev->dev, err, "missing xfi pcs\n");
-			goto _return_fm_mac_free;
-		}
-	} else if (err != -EINVAL && err != -ENODATA) {
+	memac->xfi_pcs = pcs_get_optional(mac_dev->dev, "xfi");
+	if (IS_ERR(memac->xfi_pcs)) {
+		err = PTR_ERR(memac->xfi_pcs);
+		dev_err_probe(mac_dev->dev, err, "missing xfi pcs\n");
 		goto _return_fm_mac_free;
 	}
 
-	err = of_property_match_string(mac_node, "pcs-handle-names", "qsgmii");
-	if (err >= 0) {
-		memac->qsgmii_pcs = memac_pcs_create(mac_node, err);
-		if (IS_ERR(memac->qsgmii_pcs)) {
-			err = PTR_ERR(memac->qsgmii_pcs);
-			dev_err_probe(mac_dev->dev, err,
-				      "missing qsgmii pcs\n");
-			goto _return_fm_mac_free;
-		}
-	} else if (err != -EINVAL && err != -ENODATA) {
+	memac->qsgmii_pcs = pcs_get_optional(mac_dev->dev, "qsgmii");
+	if (IS_ERR(memac->qsgmii_pcs)) {
+		err = PTR_ERR(memac->qsgmii_pcs);
+		dev_err_probe(mac_dev->dev, err, "missing qsgmii pcs\n");
 		goto _return_fm_mac_free;
 	}
 
-	/* For compatibility, if pcs-handle-names is missing, we assume this
-	 * phy is the first one in pcsphy-handle
-	 */
-	err = of_property_match_string(mac_node, "pcs-handle-names", "sgmii");
-	if (err == -EINVAL || err == -ENODATA)
-		pcs = memac_pcs_create(mac_node, 0);
-	else if (err < 0)
-		goto _return_fm_mac_free;
-	else
-		pcs = memac_pcs_create(mac_node, err);
-
-	if (IS_ERR(pcs)) {
-		err = PTR_ERR(pcs);
-		dev_err_probe(mac_dev->dev, err, "missing pcs\n");
+	memac->sgmii_pcs = pcs_get_optional(mac_dev->dev, "sgmii");
+	if (IS_ERR(memac->sgmii_pcs)) {
+		err = PTR_ERR(memac->sgmii_pcs);
+		dev_err_probe(mac_dev->dev, err, "missing sgmii pcs\n");
 		goto _return_fm_mac_free;
 	}
 
-	/* If err is set here, it means that pcs-handle-names was missing above
-	 * (and therefore that xfi_pcs cannot be set). If we are defaulting to
-	 * XGMII, assume this is for XFI. Otherwise, assume it is for SGMII.
-	 */
-	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
-		memac->xfi_pcs = pcs;
-	else
-		memac->sgmii_pcs = pcs;
+	if (!memac->sgmii_pcs && !memac->qsgmii_pcs && !memac->xfi_pcs) {
+		struct phylink_pcs *pcs;
+
+		/* For compatibility, if pcs-handle-names is missing, we assume
+		 * this phy is the first one in pcsphy-handle
+		 */
+		pcs = pcs_get_optional(mac_dev->dev, NULL);
+		if (IS_ERR(pcs)) {
+			err = PTR_ERR(pcs);
+			dev_err_probe(mac_dev->dev, err, "missing pcs\n");
+			goto _return_fm_mac_free;
+		}
+
+		/* If the interface mode is XGMII, assume this is for XFI.
+		 * Otherwise, assume this PCS is for SGMII.
+		 */
+		if (memac->dev_id->phy_if == PHY_INTERFACE_MODE_XGMII)
+			memac->xfi_pcs = pcs;
+		else
+			memac->sgmii_pcs = pcs;
+	}
 
 	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
 	err = PTR_ERR(memac->serdes);
-- 
2.35.1.1320.gc452695387.dirty

