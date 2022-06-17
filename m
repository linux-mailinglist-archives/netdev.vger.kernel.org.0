Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727AF54FE9D
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379017AbiFQUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378994AbiFQUfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:35:07 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E3B5DD16;
        Fri, 17 Jun 2022 13:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbTC+KLW0PA/8qE5wQH4JDOTfqScU74mAIiKv1mv5gsy2LWIf9NHJwKjam7pZrp/A1j9/RHiq5BrP3pVzqu8ynH27u3GAS070KJ+NkkVf+9S8H/WREUuK9pkkprolRAwMno3WBmIVejyGRklomeE6c9VWPI5gsE5XPaKp0dbPNfFUaSS7hmBBPG0LK7cEKIb5NfN1Irp1E+uoaJxhXQQYh7DPJUoEOKMSS46OWCh0KVutHmFcFeSGqdWcPxdFfnB3DuchITT6kgmsx8pcMBxC+0i/3DtqGVYlZg1rFMVTS5oJ9ud4Aj8x/Cb+ymMutpzRgBVLg+Z0nlR2rQflbycPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37/Rtds5AIbFCAahtmcRA4sIwlmQ6ktFIbKivVSu7pI=;
 b=A02JQ2dAWpObdf5f2uXpo80+omyy7EuOdKmalUYomaFGqrvYjeoCT4WMCQCb5i3uk4Gloyq0QEeuehvIuYNFK5h4lIm19UEQgLkFSdgP7r+kWAdBgt1EmWGYbuxdEK5bU9mEDQDBvO08Iy4/FU2bUTkuR7htcKk9/vyvrpEOH5OtGRjvGjtMSTI/UrxD7+BxUDaB7b310Bfdh0v/e/Q1UY7MumPYE9Nj+ax5L2sL3MJCj03lxyUpsyPfE5rFg5APUBNo8YVbzfqHx9Rv4lW6PJEq9542jUdG7gCTGRl9+/iqoeCh5tYofN+HtKYnDCm6NAx+KzVT3Qeuo1VU7yaVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37/Rtds5AIbFCAahtmcRA4sIwlmQ6ktFIbKivVSu7pI=;
 b=dt13Xexmfw6vCHgQO6QL99pqR5KvLa2UkN4uWD1LTZTbQ1MU7BjUAtOKHZ3Y+Yoqs/eEMJ62nL10Tu+yZRljZACZh1lnOhsNuMnM1CDIpbT9QnX1EqmjDQMRpwpR/ZOIdzRAS6zTFJvwBL5UtQS+pQwQb8t/pJFyNPRearhMkdYsmAZU/e777fW+mecojl9PSXM1uE+pwFGxoNlFD2rkeydm4G4HASstTEEXCh/vcQJwAnTbItxTHZQeIDCazmhEXIw3L/JzcADqHQ/seWPnE0oQgr8FdZQfm+pLDbQfv9CG7es7sKtJMeqxZgadiZ1Og+tXcW6NG6mUvKzSESd9Ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:14 +0000
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
Subject: [PATCH net-next 19/28] net: fman: Pass params directly to mac init
Date:   Fri, 17 Jun 2022 16:33:03 -0400
Message-Id: <20220617203312.3799646-20-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: f5ddd2a5-4469-413b-c7ff-08da50a0bcf0
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB68386BC26094925AC5D8179696AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ricjXUf6MZLm71rnWLX0oD+QdofJKdCfB+OnWNMMu7olyxS7dg4Sx+IFP9QZICDvKxAo9Wf1Ex+0qVlL+q40QSC9grhvyQLb/AKK0FVM8GMBImJ8FNfeON9PgRyy4WaMtzOzxYRKp98DT3h2/ovdtqUaXTwnsWhDsFrV+2CCqmnktfJdg1xrUck4r+Ri8v07A4cPvNPnTzVi5IiUhO2e+zvtItRsoExOhztI9bZ6H1DgWPEw84n64+pnw1EHsy6r0xovV3zdcGCN+i7hWa/j+fNf4H5ybxjRMpgadY3wjbn07OlQy0HJTR6rB3CnxXAEb3yJoyV/63nxRvhj6vVKlD8DBXRJx06fTfO63lLTOyLoFQdxwsveOhEvrZpAhi5QYU9pHIw0w1vmWL8p8HJfVKsMgkGAY5xDsXOFlwfsFFgqiiK+KGcZoAE2LqOCS0Rnoh1jxGm9JVbStpsQ2a9GvQoK3Wo5g1vUhviFd162aM7PXsoakMR3gHcPp/a/dZrHQL6gBeQqAVhGu2Fhr1aSS74QCf64RGYX3ebsYALrfLaVNH6Ca9rVCrk2D0UGLz+zHv8p3t/SwS0nw+0/ZCxk43sgsStFqBlLKHBSrs9OZE8TvRqYqTDIqP1eAtDy5R6VeJiy9miewU7Lb0ikh1V+cTfdfsjPz0sTb/N1bDZGE5nNUOTjFRE3xCU/N9vTOq2xwhvhFZRHYV0Emj25Wgzauw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mv/9pDe946aer0MkeJ+FM5SWrzCelxNfcZA7xnxaXJHuKJB5Ouqzh52lhazV?=
 =?us-ascii?Q?YMAEQIXd5Lzp7MrVJoALV0ilo9025NSE5aDcP/ObTQYvLult7SLYfZXx9u8o?=
 =?us-ascii?Q?QufcSHup9JKjKhMsJNotquaQQUAGyXSzcIFXcUiGjrFQRdAW+3fvsPp8swO8?=
 =?us-ascii?Q?dEHQCVHzxKoKItvNwgwcejnnxRZGH/tQvObY7glP7UICHa7hk6NQgYAosSc/?=
 =?us-ascii?Q?hk8nNugjAJTDuE+1OCv7+j5+aRq1dFoIi7e27k905I/0AVGK99V8jBDnvKwO?=
 =?us-ascii?Q?nXzt/E9SvriY9GRNia45cLm6K0T3TN5Rbgt4NQqP4qDIvRgeIJTsQcCHqsfG?=
 =?us-ascii?Q?rICpz4CVeTKvV/DVXskl8mzM0a0KKyYCsfQvWB7/b/8QNeXLeOFdL98pIEgJ?=
 =?us-ascii?Q?t5ieEmeNFAYFNmhrt1edgC9JtnY92WNWhu5YA8HyeGJjb6JOldbnfZcTFPo/?=
 =?us-ascii?Q?bJJ5JkI8+sv2Ay+NO5eh2OPCbiImkt4DspKPR/p4zDz0e8sjfLatvMetx/nx?=
 =?us-ascii?Q?t3D6jGhS6rqa3+wUSKMaZ1bqdgn/DjsaUS1i2pfzUoKuCGnLqb3T+u8IWYLv?=
 =?us-ascii?Q?RbLuEmKKQWrXVs67Z9QImImNm516bZKpCy9P8H4AzzLGVUg06R7ehlWxkdLU?=
 =?us-ascii?Q?Cq+8SB/+hZNUoKkNs3QqF5uJ6u2nmRxu120ZfsHgM2UGCNb/NwXGtOdQyODQ?=
 =?us-ascii?Q?lFltDomE4Y/mrOjEAMynQrfz8pH6E5SLKjvYpfz54UdWsBtyKBONErzag5y2?=
 =?us-ascii?Q?bMdqbwpaQdiDDY5p72udUy8cg7op+viN1rODReRxZkdL79VVR18E0rVpUGRB?=
 =?us-ascii?Q?pcJ6KlQqov3yXDxq/YsYxE5yFS0n6+ydLB74v3Vhb90a2fneUAZinEfVpn9a?=
 =?us-ascii?Q?stm8vAH6VVabJa/jrROunxZ1kzu4yuK7XkyD+2xGVfZm3y9IG9S+AaaySYCR?=
 =?us-ascii?Q?NljRzq9D/Mqsg39nt3n0yl/+7oqpxTN8TN18kiAG9QtBUt4jWWq+/Gs+9Ypj?=
 =?us-ascii?Q?C3m6nXTaitOm+ZVIFs3WrlMhe2h5vvZ+fCYzPu5cRUrlbbwYcAWXx4OnZ9dv?=
 =?us-ascii?Q?r0/m9BFgnBLkVhRATFlmHqNtRdTri51/xzQMOc8cXuZhZhthAmJ0GKslEAWB?=
 =?us-ascii?Q?vfXn7U+MWYAhgPYXGKYx0FW1Pxe3mrKBn58cdz9sBUEMLDeS34xxnzpsUl19?=
 =?us-ascii?Q?UiEFSad+oWNGE9nPI5FGyNW0Z3kon83WUoYcEZh3jGiM1+ioB3NPRmOMDazA?=
 =?us-ascii?Q?hoYa9JfDhELVcK5eGgONwpRwYV4DbkQexQ7m3cBAU/6as92Cp6HOhPsP1cpA?=
 =?us-ascii?Q?Yy7oNLnNstZ/niANoDaXClRN7tLpDtDi+/iODQICB3e0jtcs9UrZkQKZgLIp?=
 =?us-ascii?Q?wQf9Mqphx7sxlhnPF9HTrjPCi87ix86E5kqlRqoV4S9pkF55CwVv+bLOBC1S?=
 =?us-ascii?Q?g+oxZN35PajvhdUnVraDFZEJaJp7kNl3TpEqe4NygmWc3q38AP09GpwZMCV3?=
 =?us-ascii?Q?MfOm0q5i76xA50DvHXV+vA7W/POECdIrdLvd5iG+eSOqK+XNUKpqBqmccC6T?=
 =?us-ascii?Q?tQ9/0/kq9WFK1GwGVtLLMGuEtEKXhYUQ0j3MZ2Is2aqSAzioauTFDEtYupiN?=
 =?us-ascii?Q?TgoqSYzeh7yvOQOhJYG+wG3H4sSeahWtTd86Uj2F0P5HlkQVVbUZebMeVBP4?=
 =?us-ascii?Q?q5CKFhXz0jG4QgwVS5vQbqgR5AhgLkaaICUNFzKw5QLO0MTrRYj6dUYTWptv?=
 =?us-ascii?Q?l3fPdI/kskZCeXkpYpYo0AYzJdVc99s=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ddd2a5-4469-413b-c7ff-08da50a0bcf0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:12.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8h2jylw79GSRnGOm4sPgrgAMdI7gre/c/5pX9/mXR2MzZ4dNp3jgv0osHXERfKsPmuMpp7z5Y7jZ1UmPkUNjg==
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

Instead of having the mac init functions call back into the fman core to
get their params, just pass them directly to the init functions.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 10 ++----
 .../net/ethernet/freescale/fman/fman_memac.c  | 14 +++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 10 ++----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  3 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 36 ++++++++-----------
 drivers/net/ethernet/freescale/fman/mac.h     |  2 --
 7 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index b94fbc38cdd9..7acdaed67d9d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1474,11 +1474,11 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 }
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			err;
 	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
 	struct device_node	*phy_node;
 
@@ -1497,11 +1497,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = dtsec_config(&params);
+	mac_dev->fman_mac = dtsec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index cfa451c98d74..fa84467e10da 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1154,12 +1154,12 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 }
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			 err;
 	struct device_node	*phy_node;
 	struct mac_priv_s	*priv;
-	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1178,14 +1178,10 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
+	if (params->max_speed == SPEED_10000)
+		params->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	if (params.max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
+	mac_dev->fman_mac = memac_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index a58215a3b1d9..5a3a14f9684f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -14,6 +14,7 @@
 struct mac_device;
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __MEMAC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 32ee1674ff2f..f34f89e46a6f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -783,10 +783,10 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 }
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node)
+			struct device_node *mac_node,
+			struct fman_mac_params *params)
 {
 	int err;
-	struct fman_mac_params	params;
 	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
@@ -803,11 +803,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
+	mac_dev->fman_mac = tgec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 2e45b9fea352..768b8d165e05 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node);
+			struct device_node *mac_node,
+			struct fman_mac_params *params);
 
 #endif /* __TGEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index e8ef307bd1ca..5d08c4696c21 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -61,25 +61,6 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	params->base_addr = mac_dev->vaddr;
-	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params->max_speed	= priv->max_speed;
-	params->phy_if		= mac_dev->phy_if;
-	params->basex_if	= false;
-	params->mac_id		= priv->cell_index;
-	params->fm		= (void *)priv->fman;
-	params->exception_cb	= mac_exception;
-	params->event_cb	= mac_exception;
-	params->dev_id		= mac_dev;
-
-	return 0;
-}
-
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -298,13 +279,15 @@ MODULE_DEVICE_TABLE(of, mac_match);
 static int mac_probe(struct platform_device *_of_dev)
 {
 	int			 err, i, nph;
-	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node,
+		    struct fman_mac_params *params);
 	struct device		*dev;
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
 	struct resource		*res;
 	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -478,7 +461,18 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	err = init(mac_dev, mac_node);
+	params.base_addr = mac_dev->vaddr;
+	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
+	params.max_speed	= priv->max_speed;
+	params.phy_if		= mac_dev->phy_if;
+	params.basex_if		= false;
+	params.mac_id		= priv->cell_index;
+	params.fm		= (void *)priv->fman;
+	params.exception_cb	= mac_exception;
+	params.event_cb		= mac_exception;
+	params.dev_id		= mac_dev;
+
+	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 7aa71b05bd3e..c5fb4d46210f 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -72,8 +72,6 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params);
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

