Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288DF59888D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbiHRQSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344572AbiHRQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:32 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8682BD0A8;
        Thu, 18 Aug 2022 09:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn+nqhoq23ZbSwgUlFB64U5xjA1pDuiXQdMzGzAkiDvKMb1Y2GhEtM2h3vK8wY+zzTphPk1wrquT3kJLlO2cckzeRS96/z6kjJCFLjAZc/clS/nw2Rgmd6rGg1tMEE6Bk/ilS6OghUfcjE6tSCd+pgssrtg4VMYr7Y6nW9rONO1U/W0j05MLcsdKQVGu+A8nBpAoEKeuL1IAZGelsf8kFSpARjF/tjSZx3nUEoz9McTfWLe3GQn6e+igOWJLNsxmSf5Owt6grj4LmR4553HZ4KEEElrN5UMpKfentQfDdq93PARDzFoHaZl114k3C2eXUW9yLS3bPWeDQ00ovYcvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjElZB4KBj9O7wepfR5xVozXWKsZLczj6QtJJ2HiuT8=;
 b=ZHhEfEDlT8YSHZ+t93PPNoLrDHwBGKQLDXbwmoFeKH7Lo6WL8FonDGC7MoXR86BTxTGeqPv5JQV3hR3WWWukQOVPmSanoBvjjhCCuWiTcGnujvUPJvwtE9+SEjkIxPTetnSrrZor1I21Oiq95cnXRU7ZU7zCUf+8SNIcYj++QhsiYNIKdcxlHzODRtOntP9B/ZF/MxSg0m7BVxdGwQIXFVHsWq+OEnWv04jFdU55tMuN8Vqw8wFDAraSwi26WepqhtgzhwMTJteycQWkq714OOvgynvwiXE78V6H3CIKoaG8pPiLp3nPq1J8JsvW3TN8AHR9IFE0U1bGrNpslJ+VqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjElZB4KBj9O7wepfR5xVozXWKsZLczj6QtJJ2HiuT8=;
 b=l2peOThBT3qGL700O9NaCEmQsz3huuxm5z3gsi9hZigZEoN/tLlrsqKJDzPh5S9SoAzZcEV2W3s/IXJ9Px4/9IVgFvCRjo5mXHQmtwg2Uj7fW06u/TDZcaWPj+BVKKKXQk6iOtqvVRr2ceEUpObhstdOXT93ha+Pwknl1tMBtWCrwTzILDbMPzXMKfH8DIZ+Mul7PpR7t5xeKxLeGTnT5i+UPEeKM0FLyhrvcg6lugQbBc0GjHbqkP5k2q3sUF3iTDiHIpo+X1z8J/TNd+jIYYyZx7BdGIkTEOUIsuuJpizyH98ZqfDCjv9GL4lmELhfM6ASBpkY0rFy1nocC8Lkyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:23 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:23 +0000
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
Subject: [RESEND PATCH net-next v4 11/25] net: fman: memac: Use params instead of priv for max_speed
Date:   Thu, 18 Aug 2022 12:16:35 -0400
Message-Id: <20220818161649.2058728-12-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7800247a-401e-4553-01df-08da8135221c
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaK6ZRrZgRVeegtnkig8MxP8amFR2a1nVXhwoRW33pelWPMSVQQgzrnOe5BbwzAtjGglMowxj7zk512hYBeSJsXrJZeyd207JdpaD61mas/8JGmOdo8V9584hCkE+uIbO31PWsaCFBHfD8H+s14dz5kxklnAMJIv5Npa4JsWeXvlNjGXj65QWBDHc4d+lLvK1wgsr3Q764887VYxpv9drQXw/TDo8mVYQg3Ex9lPPQoS9VvAH0wejbfi+yqW8trD0jInyz/tp4gkoMrDp19pqwqgj8M0tv6z1e6yvlipKDU6Nv/Xjdw11eFo1kQoXKC8ATZAUdX8SlhUDeOW41Ff2ElC161Q16/Apq6CcKSw266HmqHseEI2azzJShyc9qbo312C1gCgE4iHv4dCEXb9qiC0cmzHfb+7JbMjVKE0YU52dRJuE9Ah9lMk9zCwL+714fY5fx0ScaF53rSf6g/mES7bN/3agMW812JTSNk2kLSgZLL9MiG/dMm5aRMvmTSmFh7AXIDuK2YWuCKly4U6Lrha3Y1VG9r44EVB7NuGl/GtLP06rTGpPcO4xcRcNodoI+MNH5NvvXK2hNrbd62d6qIGFyhr/13i7+BVj02xEsYsaRePcbl/JoIaepP1XC7QrWLcRZNzEnLTDEQ5XiFRgbGFE74GKuh1swN468k8UAKsBNJ5xroXjea7ns0eTSoAAtqPXD9zw2sYqQJd/atCgXeqauqSraDufz6BGar6pgECgB7kXMr7oFc3mKq5Af8dQoJar/nh8ESvuhVNBQusDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erGXD0xTFy/ZtMxSo4xvjbjXzcddqEJ2IlkLnMm5+P2aHs43OG68G1p0g7Ag?=
 =?us-ascii?Q?TelGzbBurJrvX/hZjim/xA2aFgPcQ0lZ0bm+/o18SJYIBC6WUAs7wKjaHtD2?=
 =?us-ascii?Q?Hk6c9fs/QP+UNQ/2vwFJMqMcOH3F3/dveCAfoo5C37qtsX1Y5gCWHHD8k0s4?=
 =?us-ascii?Q?8J0sAscybC2QvBAttVDXtaPzD5eQ8ox8uI+e5TMoUHyLMqqeNwLXPP88HZb0?=
 =?us-ascii?Q?3MSlQTLgSvCWSbXNLUGyJNm/yYzJCBGjR8eBw7WrSQ2ggvxN4L1n9v2iNiXk?=
 =?us-ascii?Q?TVzp7LEXbEwzQPbQc6m/vG0n/4Xsk2AfZskwy7g+cVoJWGwsNvckMNFHV0DH?=
 =?us-ascii?Q?ACl4GqAXhfeoU4PNyA7z1iHhNTavBcyTFyseiknMfPaA8R4QkKy48yGAuZ9C?=
 =?us-ascii?Q?lXD0P9oM71IbP6JMEModAE06fuMZ8+XTCi3sC5HxAZ/jqPsv/rg2J6ktq5k2?=
 =?us-ascii?Q?GV1pn0p6Z3YQsKGPaEMxO9UEIpV1Z8z/RlhdI9ss/EwdOULIiFTKSxXyAe2G?=
 =?us-ascii?Q?ZMT3LjFulNH5233GWOisJZMYf8uABBEHv3tkPm50tNkr9zzCE7gWILBB03dv?=
 =?us-ascii?Q?IXxmwJ3ww4oOYzsVTZIYAL5lOgxxQCDHGXx5pGroa0l5qHajrq1qsas7HygL?=
 =?us-ascii?Q?Y2/wT0Xv40DlTWaaS1TIbcUXKYZMsHxfX42KYeoAvp3mzblLFu3bfpJ4+M+E?=
 =?us-ascii?Q?V7TCV11sc88HWyB8rd+mO0MZiXelHOLh5Bv3lb+3+bxJxqlLCrHfNRbcNCqB?=
 =?us-ascii?Q?qIlJF0ERI3po2RvlDt3+4INj7evWLtebyat3vR4yTwpA3/chQ30D/2Rtzz7U?=
 =?us-ascii?Q?cIELkKNchWLJi6rKsmeOUBqz0HywjeSvTsoAM3yIq7zdp4KbkSSk+IYEiTqW?=
 =?us-ascii?Q?3lsls5ZCUo6UICRFmZORVD/9264OGIsjPsOLP+UrS7zYvV14xj+JjGdS1q2W?=
 =?us-ascii?Q?sKsv4KX6Hso7RO98arJmvuQ9lTerPJBAycFrAPL7+DeJyCOyDK4w8z+FNIGV?=
 =?us-ascii?Q?uUoBu2i0/Qt4qaUtznh+5EkslhwJAwWHidHwMTxtzA6ukhSjvDV30a7lzRQ9?=
 =?us-ascii?Q?8ufPVh7C6JvAEd22EKu0BdsImd3LW6He2b3d0WWW3YKIRnzEDyJsmNOEoE+R?=
 =?us-ascii?Q?MAgVFngQvNJoZD1Ggnp+0lkIu9CisARAE2JBXMwUnJey634fv6N6boUj8Fpj?=
 =?us-ascii?Q?3Ky7m5v7dTurV9TEuk2f8jGW6IGN+dZkgEX2NlnYjWd4Jsi+VxTF993fctEh?=
 =?us-ascii?Q?vsUCKvqAa4r5F+q6flGMSQDZvC2HI7GYhzmMvpgo29kzh8WQNXreE0FwCqkB?=
 =?us-ascii?Q?MQ9kVMuByXtFw8jyBLvQHAsaSuzMnzh16Mone+N4d8vkOovfjgGESJCLxhde?=
 =?us-ascii?Q?r+Wt2jrf47zWhtRZAJY0bcpz5wR/ecbEKYcvPAr2fSrW366H1Aw2sOq75Yct?=
 =?us-ascii?Q?4qDr8EZF2qoRHaUDINERonrNmglTUkZxH+RRBEdEYNwkzxLdf1KtKSw5GjL5?=
 =?us-ascii?Q?GnSplPgxT/42XU2027+nUruI9KYmd1CSd1Ly6MQe1Lpk7L4kGLWeulJ87qld?=
 =?us-ascii?Q?pLh4iBLfsdltaSm6c8AdQJ8cKaLVbF00phnWgevmgaDwzzB96S/C+9YCWleu?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7800247a-401e-4553-01df-08da8135221c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:23.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hL3I2lp3yxXyijirdO7nhZ5Gk1VFBgFYK8yAjgW8ihlpS/DNG1cUHYvVOp9Q0NtE1ph6TEJyDztbrjwkWYBXfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is present in params, so use it instead of the fman private
version.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
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

