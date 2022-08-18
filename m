Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F65559887D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbiHRQRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344564AbiHRQR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940CBD118;
        Thu, 18 Aug 2022 09:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQlROIbJw8+bC9N9+hvg/yZ4NO45UHxjDY9obuBZyWcBc1hJCDnwOxS3DbhBmIS5FrpQ/u03v8Y/xR143gn5wpkFtD8jCi51P/SQI4roKBnKs9upG0ZDK+y8BKBDuQjK7WBrMa3Uo3wqHIHNlRvNRzJFjfa+++CF734JB+iOocFZdwUs2LNGKmz9mED3YpKw0WmBIt4PaSdcCFsU219HliJa06WBAi9+I5sgoeIgLruGYh3J4nnSs6EAM4V+hzRyjWtHiYNLTU7E9woEjQa9m1GHV9TKd08Xhovc8i4t348wXkHU4fG5EViBwf3lrRwXJxuhowroS/ZXD8tfqqr8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikmed1H2u8yYjG0yC0+OW7IBD8A+JO361DVKp96y2Wc=;
 b=PHKUcwwoSAh05HCJaS6CPuShdRXQoRuAOKYoc7/mTJittJXtD/Zc6HmyeUg6rgmARYJoSnAhfQ2p3rOU4VsFqPmnTQytTdC1zXt2p/bazqsqehNNZDQ0mDGhrnP5u1c/sp4rNh/eUcQAY/+Ez+MrVvxQkigMI0dyiq0ADzDqyyysjPuU1wJeQIIKxRI9x7C8QJpl25hc9oJ6wjm4JqPoUFWDthPnrwrEhJftrP+BOORcxZZ0vUl5vtY+YqIBtozLqSXUx6qv2g4Gpgq4gWrwDBD2rM25sSgGYI/qnfwQCcastDh0npBHQZIrAsFwGs9wUf6zztUPdP5PnaFSa5f3UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikmed1H2u8yYjG0yC0+OW7IBD8A+JO361DVKp96y2Wc=;
 b=nKA4GbB4ZHnq30jrtqh8azxBCehKmcluKb9z7msDeZ97XW3petbzRzPrZD0TiAxQu4bbm4+lHACjlc46UeNMs+VLjx6pC06NfgUYONDOeC2xujWsqWadkdb0Yc18FtxS3C3uo4LOjfVI8OnXJ1bCnP7NGWx1Z0qxpYsyAGsPXA2GoEPxrwrALyk5uZKfaEE6r51elLp1vrDEt1l0iyH599Zf4TOZEQCCXZep4ABy/q1pdz2KACgKvh6mEDkL787fhR3wEfilgQafiHUxj0XMM2nL8TQfWtd9k6QSpmmAZErMDAwSpH31sCOqOtuMSadxCvsIAUSbK6DxS0bd6IZ8Nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:16 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:16 +0000
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
Subject: [RESEND PATCH net-next v4 06/25] net: fman: Get PCS node in per-mac init
Date:   Thu, 18 Aug 2022 12:16:30 -0400
Message-Id: <20220818161649.2058728-7-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 73efe216-5f33-43c6-f6de-08da81351def
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cw7ESdEFeHm8YWEEktL02VDtSmuaflQlFUXZBuZZXt16i5pfdB9HhIoO4hG0bMAyWMHhyIuu+KQYZMwBtIbK8CeigjbJJgIq9bTIaNxvI+dIWyHcGGz5nc1XO3GEiHJHVlk//B2lLEgjST+NZ38TYgrNs75UYLik+F+eNTTcQb5wc9A96IrrxEEz0gOFIUgqhJckyV3L33POPR/hIPwE8u+nfNAGdwruTaYJ1h0Iqg2wq1MdJ1E9FdXi1b0v2tuNALC+3OuWf5kpcH4jEq4SYAJbKJ0NA0UksVxsIDAGJKt9dWD7zxvEY2hU1Xo9GAdiOqtF1JVpxKUMJiwHp+ZN3DRKZ+9mOg/OpK8h9n7YLBnOonc1esaFMO7+g08oiJDbtD7L+Xyjq5SLVeDcmTQTyJ+91cWHV8gqwHyTFQXyhUmFa8TU2k+mHW3h4odqFDiIeNMf7IecqqVwPrmb+2WRkyjCwh3+8s+sl8EbsEafpIqXV7hMutOh+OE/qwe1w6nMcmCko72VcZrd+5TJNDHHWH+Cu+xL8oqYg+M7D4ne22ePEfCkACeBl/+KiHObQBC6xDgnOI99GEtzDftUMx0lrcbvEfMSsO2xtaOVy070p1zXtG1kyrHaIlfoArfAocnjWjP9CM/MuCIMwBbV2L/Ha2euurqGdkUT32RGGyTn8RAVDaLhLsMbk7Lm1SfZKSeIB5Dj6tFerfcj+0O17CdSpCxWCXkDHBSW7cjAnl2nOwjsG2EIOwXF7e0cZwY3KqizFvkawiHoDHqz3SUARR6dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m76BgoFrXECyguYF1XdThcTyDgkijk29VNIa4EDMWbxA1qYFtoLfZTCOQ2bG?=
 =?us-ascii?Q?5TTsTkN85gOJ1euYDXU183nnIzLV6AY82BQ82EKL6zOnptuDOLIYNkDXs6sW?=
 =?us-ascii?Q?e32UbkeeRnsd478IcIF7ytC0uQtOA52TxAuasKYqY02xlWy/BU6l1M/DOV4y?=
 =?us-ascii?Q?XT1PyZPjSVGZZtDjUyZKpILpUnX3GoLNax/TDgAY2wlRftwEpg3+6zhu5LSK?=
 =?us-ascii?Q?wTwAIu8vQ4tzpEMe9kmAxueGSZqwbzJVtNwjFStJe9jCIg1jUwdaSBiHC2iB?=
 =?us-ascii?Q?ddTRpYCVtGDRvr+X3Q2ZXJd6iL64cx0FmIjftfbkWM3++4sCvDC25C2Al1tL?=
 =?us-ascii?Q?loxz3JP5NI48GrbgCEpq7xAvNKkmBW3EciHdE0TyszRs7DRLXIdizUyscgSV?=
 =?us-ascii?Q?67RHPGg65nW4AHmWdqRY816rPgjlyf/IV5dncX5Ko+l3mVJKFy5WmvYGmSBo?=
 =?us-ascii?Q?7igECkf6JncPZUzmU1P+Rt/ohkDivWQ5v9HMDcUNspPyx+IglU3khQYxzzwN?=
 =?us-ascii?Q?SNm+k/yzlJEzawrIB+UR95e1CJf6+clg2GqJRoCu69xrqz2U0YVD0OulxCYo?=
 =?us-ascii?Q?tT9gXYaWrYKBr/IW31PM6ldaRz8f4WAdXzT5PQEQc5G2TGK9b5oEAoDrBgwP?=
 =?us-ascii?Q?qJRHHNwZhs88EyXU2hWMGCcqYnAE3QNTIIvnCB3Io6CNko9UCu6CCSTMWuAy?=
 =?us-ascii?Q?X4tXZn7XXZ3tio4EEXCMLxBvTsZV3qAn1dSyBFbsqwjjVHYAvx1xnF//1JJd?=
 =?us-ascii?Q?ikBscjga5EhHv/Ml6r2thsXEtdgAiSdET6ktz+hfEDpe1fpajlLRqrNzjK2j?=
 =?us-ascii?Q?VFqpg11pfkc0tVjKlBsxESNZ3vFv863FulS/Qx1Vb/3J8tWPPFM4gQMKgfNT?=
 =?us-ascii?Q?D6HKpQNWravRABbiEOGtilLTJCHSVXJvQSOJXl6uPeaPJ+PTZibGEApEQEpj?=
 =?us-ascii?Q?3+sI0bU2zkQI6rvjqBcACd/sMNxmri7KHEZ51szh/dHunAAkEwDqloy9K3ax?=
 =?us-ascii?Q?QcU5JI+tMPOoqqb3eqvh6NOaOYxUjATYj4kOL4k3XRekAM/oIHxfkmlNt3aJ?=
 =?us-ascii?Q?c2dSzyV59KTk4JjhmzIcc4IpSvVGIbIxZ/GflwVddDhIDkKYkmiCOagv8U6N?=
 =?us-ascii?Q?uOQ4uNkZC1+xiLxYNr+R/NAxG7Tsj9CXAEJyn6UcYaGdV58qRzJPJEMAee1k?=
 =?us-ascii?Q?tu1+sFsoU7lOx5i06r3lKWUe47j9YQmGS+rkCqWxi/Hk75iGP+7qQ70p0chx?=
 =?us-ascii?Q?7hSqYjvwtOt6tFE5kgHv1BFiAB8TyjcbDThhp4m8ZIStBYHjhiIhGal76WMy?=
 =?us-ascii?Q?fVKkzBZK4UvApJlRxTH3+HhOMOBSxKqXBSpDN2p+49mEq4P0ShiXbmzxPs53?=
 =?us-ascii?Q?6mQgaVJeGcp76E6EyxWcvikMUsVyixF5Ra6sg5uC0d1/Ycl7t0Wf3mnPFRJ2?=
 =?us-ascii?Q?O0Qvuy8bMPYhKTL1/2JdRgct+b2XsQrWSVnd963Fogf4DBNx8FfZMk8dIsqV?=
 =?us-ascii?Q?1i+9X6l8MmTRyKNyjvmKNvReHfcYmuohYwP2IaRpKZsO0545tDRKvgkGyRFI?=
 =?us-ascii?Q?2/FwclbBaSdN4t7ZS8l5a6tW8RAkbOudkL02J1vmpsLhGZOb71W3TQfyYqQ3?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73efe216-5f33-43c6-f6de-08da81351def
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:16.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7IxeFI980U16RaVvEhK5JR1GHlh6lvqBA+ljyuNwWxlqVLDvuFfX51ka7/IwHtO6Feupzg8NNRnMEWW2bh9bw==
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

This moves the reading of the PCS property out of the generic probe and
into the mac-specific initialization function. This reduces the
mac-specific jobs done in the top-level probe function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 19 +++++++++----------
 drivers/net/ethernet/freescale/fman/mac.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 6a4eaca83700..0af6f6c49284 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -32,7 +32,6 @@ struct mac_priv_s {
 	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
-	struct device_node		*internal_phy_node;
 	/* List of multicast addresses */
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
@@ -85,12 +84,12 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	params->exception_cb	= mac_exception;
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
-	params->internal_phy_node = priv->internal_phy_node;
 
 	return 0;
 }
 
-static int tgec_initialization(struct mac_device *mac_dev)
+static int tgec_initialization(struct mac_device *mac_dev,
+			       struct device_node *mac_node)
 {
 	int err;
 	struct mac_priv_s	*priv;
@@ -138,7 +137,8 @@ static int tgec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int dtsec_initialization(struct mac_device *mac_dev)
+static int dtsec_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			err;
 	struct mac_priv_s	*priv;
@@ -150,6 +150,7 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -190,7 +191,8 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int memac_initialization(struct mac_device *mac_dev)
+static int memac_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			 err;
 	struct mac_priv_s	*priv;
@@ -201,6 +203,7 @@ static int memac_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -583,14 +586,10 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
 		setup_dtsec(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "tbi-handle", 0);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-xgec")) {
 		setup_tgec(mac_dev);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-memac")) {
 		setup_memac(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "pcsphy-handle", 0);
 	} else {
 		dev_err(dev, "MAC node (%pOF) contains unsupported MAC\n",
 			mac_node);
@@ -783,7 +782,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		put_device(&phy->mdio.dev);
 	}
 
-	err = mac_dev->init(mac_dev);
+	err = mac_dev->init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 95f67b4efb61..e4329c7d5001 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -35,7 +35,7 @@ struct mac_device {
 	bool promisc;
 	bool allmulti;
 
-	int (*init)(struct mac_device *mac_dev);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	int (*enable)(struct fman_mac *mac_dev);
 	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
-- 
2.35.1.1320.gc452695387.dirty

