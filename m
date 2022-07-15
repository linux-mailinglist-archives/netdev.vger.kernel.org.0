Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDE057697A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiGOWES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiGOWDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:21 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D471A8E1D1;
        Fri, 15 Jul 2022 15:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2D95p9Np4/drnD5ug71bWyF8M8Au76MuuVwHQSJw0trYcO8/dxL/Z4RRneU7zBWBLJ3vXMKlBZUhj4jfI1m3jZoW38yPYYMI0b1TNt8RklT2a1YcD7oWbo9Sdh2QN9RR24Xu9wrIyktrdlfaInSATOkWgRpKWHOsU0YBJqoUEn3r+qo8AtXrTDK0PRzXcnGTf2g9wscLNKIDyQnPfW0lSvdRMmIV2EH1CMHUe+HQmic2sZ72k2eqOttEuoSjWilsI9HM8eeot/+NpzqSSMGy0Gj0DFKhyNKENtDLxkE3dzH1Bh5lQX0iXamYi7PN++tiMvNqnsWkFSar8J5igty3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7BrJA5PavkzVyK1KGe8HWlNKAyaHV7WuMzVn0YbMoY=;
 b=GS30rEQ4zjs/2QQJB01NflzfgB/Wvugj+DigPlHjuEgOB0+S+0Gpp8qTikoadXQwHj6vR+uxmsiZwns9hizC3CfEXSNn/56F2jVUiYfNYwqm2GFM9JHVpWKe+PprNyn4d4gerpvVPak+bPJl/QXhabHVAQUkWaiPn2Gv214ATOc3eWD/h8ZRREc4d/YOMqPida2QxuYBhV8dAqKZeelKEdeCp4kE+ZSbyWnAHeeDGEAXMabyaRzgYdXwRKmyfqJE7GVgl5Qld2QivY0lhgXF4Ta6m/iyBWNMKk74jbPqqARfQv5ffypOCKoztxfwJoDn2jTi/6gCjudW0NosrY1COg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7BrJA5PavkzVyK1KGe8HWlNKAyaHV7WuMzVn0YbMoY=;
 b=weiSnguuxaCEFmTa4o6r1WVe1fqcYnWVoAbtGCEzoGIUeYemAMmb9N5dIgFys/BwGKdhAvX3jJgA2A8CfpZFVu70haAl1vYhkd2Wcer6P7n99bXe9ga+sC6CYOpxpO7JCxDsjHEfZmZuAGH6ba50Fe01G1B/9uEWLM3bZ+GBCvVGO1EI+8UJNhCq++xxZjHDgx9C7B6knUXkctgmEI/MWOVnP7jnbrgRCCNcfo5AA2jRPlhsvpg9/pUndtyNPfrmziIkfK7qslg8FzxSJXIc3G1OQ14eiBKR38dj2yPkd9Y5BoswJztnicj79/PNZTl4XScUNS9ZVKyTEKz0NPN1IQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:01:21 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 30/47] net: fman: Pass params directly to mac init
Date:   Fri, 15 Jul 2022 17:59:37 -0400
Message-Id: <20220715215954.1449214-31-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84564d52-75b3-469b-33b4-08da66ad8d1b
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80PXCHM8PK6oLN5u2jb4nMzdgXtPPb+DDAmKyoVlbT11Oxq6OatWx+0O7ixXhBXuCk+LNZu5pLol/wvti/1XnOoLNlLZFZQ646eWyTlApCpwlUti2eXcm+9fqhBTvgMiaqrZWTUEs+g0R3q4scTpYSypKezw2gYThEONyrdlf4bBOy74SWGQ+FaoDI0ELwBchhqTEflZj1ssgj2pFKJPSmkm0jd2lr2kA87RRjf/6exPz2JEo7kBSAQyZ82Uvuz1qXX4WfJ7fuO95V8J/7VPKD1pBZGwoS12heelSwDtN92UMZRizPBSnqVrQykGTJ1DDeh//HxzG5qnXguKMSKYNsM1V275MLPU4v9PrvqdHRJnnv7RlTjawW93Scz1LZkG1X4WHo0ECHX+Rw2g8TGqwn1xsnBczUjgL7re1bi8p5Gkf4RRcfS15rOuyB6DHExQyI3gQNmImgZ02TBF2on7L9BBmd9PwXSMMyk78Hq3KY5gJkozuZzv13NmLKs6SWsu9xQnGisDDnPMNMbJT8m/xUKJ795zPViS83W9MmOvJIfjvNc2Qf92jB9059S+dOv/GxZUh8zTKOg3WXoLC09kRPoNZelGqGtb7iKtmcaU/TAm/FuHsCuTgbqUzyZuEtNtx/oT6Nj3XtyvRL05J2wEMPIrmrni2rhd80ssW0/Hl2/at7+wo2bCMZgxylNGzKpL496Lr79tnpbHnkaTRtKOMnncS0wSdTf2vSu1rC2uOmixxf6CjZX6drgInmU2TfwxU3Qv9LKLJJyC2MQyuPefYStqYKzsfYtP9Jh7ZRcT9e2t4peOmfEBNNZwRj0kSDVF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(107886003)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cdkLld1vqL57O+R0jHTqFxNnIkmBFmlywxbuQ5YOTsEuEsvYYzSYRBIvW0Or?=
 =?us-ascii?Q?v/6F84QNA0DpntNPyBvz4fux+lg3A/USlJtClUMA9mC4lN9dX/5rut5RlVXt?=
 =?us-ascii?Q?SPrupqIsD66UWLF9f4Fa6z528VL1ccJJXaJQ3pkZ9aHXPvzoq6rr32kxaH6O?=
 =?us-ascii?Q?au08u7hxOVHbFx3QzO16e8SnGUpDtA9sq4vtc/1BrIiyGvxT/fBZla9k5wrh?=
 =?us-ascii?Q?nYl8r3Fd1GHv8NBftKg8fpXU0IMlMAbGd7helUVpsy93WdPZg+MoNTDTjORZ?=
 =?us-ascii?Q?HHHnWxKk/ksG6M3QDLwVQ7qMpZbXsdSbE9Oh9M+tZ9+vYGZuIH1gbCFbbdeS?=
 =?us-ascii?Q?BKpj2uUI81j2XD298BI4mX14W0sXoxr9+8D8Az7xWERvfjpOJReM20Yy5ywK?=
 =?us-ascii?Q?wkyq/y1Otyd8ahCH1qjH2JTEmJWmxAAhh9zXXsKlr7uqUlKqsghL6qWO3Ito?=
 =?us-ascii?Q?FY1r6dqUEE6w9KugoUyqEtuTUC51RpGf1epDENAedQvJFH5tt+JBTYSpuokJ?=
 =?us-ascii?Q?TduwQb070WEPh889G32/ZZkChWfRBG5urX+DUiefofGi+mdNoaj1mecmtXFQ?=
 =?us-ascii?Q?m4zIINHMQusc+eGKfEPGDcujEXtFVtad4ChG1N53gT/5IJ9o7QHk+DbzEWHr?=
 =?us-ascii?Q?z/iN71ooneZkYxa7+Wm8cOAaAzd0fHNq2pRi6Cgaj+D+5MvMVjEMu7r4NSUK?=
 =?us-ascii?Q?yyr2dwZVeQGy5LTJbPcgRga3UKdmcJF0s3ssC58QQP8+0rMNINA6ndJta5zH?=
 =?us-ascii?Q?xZ/V2XHi/Ha+tVf8ReoHHbjM9zUl7HfAi9RYaWu/yfNDCI99HT5pLNomTXl6?=
 =?us-ascii?Q?wIk7sBoTCSL/+W6k4Vns6phoBEFKw87btKU2dSbL8WznmT5nubOAoGxjVElq?=
 =?us-ascii?Q?md9UOewc6Spik5ey7MEVOy9cH7N0TLQNQH6oYUEgp6hlVLE/weYxQ4R1huHH?=
 =?us-ascii?Q?PInEiQBYZELNkgGX+KwWScejxnBJhniltMNdPTxgJePmTz59v3cDcL9a3ORV?=
 =?us-ascii?Q?4p/cge3UzV1UKrGCa/L3MXULp3eWdCBlQvOXGdhkwMayWVMZkgq6wPkNyJwr?=
 =?us-ascii?Q?H4A1/YwNWNLGdLYW2u7+tUFk9pe036hvX1YZUA4ftsvg02ahV7XSSo39Wuv3?=
 =?us-ascii?Q?+UW9JUrkD/rXyR1RV96ZNbfM273fxlKfqztF8oT87deOWW57gux5jM8B5Z11?=
 =?us-ascii?Q?GAOtYKK2cdwYOois5sgKR40E69BOcdyAHSXLznMZJB7fD+Iv2PN3oDilB+06?=
 =?us-ascii?Q?OATHECQyx7p50gpQaCAeNNnOiJJLJz3ND4PCqvgbhVz6vLoexiT5uufRPZ1y?=
 =?us-ascii?Q?tSG5cy350YxEEYWfLOru5Mk+Ag/sS27SNE/X9SMmUwCOzOSow8PA7CuCafa2?=
 =?us-ascii?Q?/zeWfuId981p/yovZMLrtZGLAPf5Pf/3ACXMlf5YT4KduYmpPbRuJeMfCOeG?=
 =?us-ascii?Q?+aZRbGF/rlzlHwELQgOE8vFxvsxTG57pikqjdvA1m887hSJ29Qj3NDhQxEM6?=
 =?us-ascii?Q?UeuZt62gKpDzPMs/Ao6rEf+ZlyT4zFdL3ZR7o/j7sylzDWZHi+GXAhg9Wh3l?=
 =?us-ascii?Q?UEA+kqKTaoHZrijVF1FlLbvEt6I81KQGdcfYuKTBl+vJqUk4Myobk0uVkvnJ?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84564d52-75b3-469b-33b4-08da66ad8d1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:21.2060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GGqvifvcD2g3PlYpGL2UUtY6a5aBYYgqCZS/XD2qCks9Q8Pe1GQdRACYPu+vcx9gGzwowqNKfK+Yr77NsKsqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having the mac init functions call back into the fman core to
get their params, just pass them directly to the init functions.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 10 ++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 14 +++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 10 ++----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  3 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 36 ++++++++-----------
 drivers/net/ethernet/freescale/fman/mac.h     |  2 --
 8 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index c2c4677451a9..9fabb2dfc972 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1474,10 +1474,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 }
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			err;
-	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
 	struct device_node	*phy_node;
 
@@ -1495,11 +1495,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
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
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index cf3e683c089c..8c72d280c51a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 5c0b837ebcbc..7121be0f958b 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1154,11 +1154,11 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 }
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			 err;
 	struct device_node	*phy_node;
-	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1176,14 +1176,10 @@ int memac_initialization(struct mac_device *mac_dev,
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
index 62af81c0c942..fb04c1f9cd3e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -57,25 +57,6 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
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
@@ -294,13 +275,15 @@ MODULE_DEVICE_TABLE(of, mac_match);
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
@@ -474,7 +457,18 @@ static int mac_probe(struct platform_device *_of_dev)
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

