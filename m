Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01C55ABA74
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIBV66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiIBV6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:22 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B6FC11B;
        Fri,  2 Sep 2022 14:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny7IejYpH9A/FlJa8KWMFWwFF+a1wko+/zzZ3omGpxvKETvoXTwJ6mN9nA2qDwXATUQ+pqUCQa0a7U7Ik3SU67lQ8ID/sFahWQewRTdc2/J42vorzwHprQFnZgV2POeTdgIjQWDkxRbBwo3sMb3xON9SmpQ+Yns2ahtHvKn6IeyIRi901/NSO/SqRLVNOo13yyP4I/5ArV/BnJ6WdaqtTO5Xvhf5wHlF4kV7a8fO2SZgGaOJylhbLcD9tIqc/gNHBB8PE7Bn/oTkqQct6KacvDAN2/MdEO4vBi1x/meEBegj2YRBQq3p8yVUQu02vmqeH+NigjnvHjvfV1/OhefXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KuhusnLjiLJbej+rFDCuxZxkk1q2MwlbFKv7ZvUD2s=;
 b=kc/j/ysprd4ewzAvSdoP37l+e8o+DUwKEOho8f3fctODIsNJNCnjRbqIPlkA/X2l7yPTcmyIIOmMcAg4X1FFNZDE7LLeLMEwwo9zo9J9qMPsoEQ65n9V70ZBVOUXRiW/Q04XBkjjk7KathPcSY8znr0rJNDl58dBrUGbywhSUqI7Qsma2pjgXZzCVXyDjHWjCBaBRknMhfTUkHzfoxOZ5shAgi4fbuj84xEkpUlVsQxKrohn+77UV141tC6xDhfNi2OMcKppYM883LjUYEK9heQSLF6sCVP48n4QXMvy/74NS0k+4Ufc4j3fm9Xzg430HRiwW0LuOsY2Er25peR1cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KuhusnLjiLJbej+rFDCuxZxkk1q2MwlbFKv7ZvUD2s=;
 b=gLrXOfGJcBuLy6S1uSFsZuP3neYjVwf4IxDwa+1wf3uO0wDn38DxcdvhNCOQr+ovxTFp4lm2Ty/0x9Own52NdxJgRLORjjVdNXHYIpNub/XhrfUbVjpZlrjdaWjclcYiXdVlUAchQbJ9bAYvSwAvf6puI7MrNvwE4nlRvNoAashi3xn+VYsmrf76P1swRAe07VDaBLqokk/UiB34XPg1LihCnUME40kOTgp9JsWmCzrhOi+3eaC6IKtPXIZGVb7m+jwoYwSEkC86tpk3NOTQDJjcIfNml4pP9jcgFT2/ePibmXruA97Flt+LYI3zQp2L0hyd+AvTmMTaWZM8r7CnQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:01 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 06/14] net: fman: Pass params directly to mac init
Date:   Fri,  2 Sep 2022 17:57:28 -0400
Message-Id: <20220902215737.981341-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c6f6146-c44a-4d52-9948-08da8d2e340d
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtxAULMkJ7CFbifOZQXGACljz9AmK2XORqWj9u7MeI2KIID7OYl2RrW47k7DR/IhlWQZYbNUKJgaP84z/mEBXXOpwzyFYYPMUSsb3/KtjECHRpC8X5GpAKb2DJ5SHzh41oSDAFlV0xiiVXoljGtG6LlcFnyERVdCoi1kOE5iF3qp8CiT97oAtAaR9w3QTfAnKqAQWIZJtR1HjMqinsaPP73Cl0WjrpdnRSfL7nQpxwR06yqZ/cfvUFPdSmPvvv0HjDzwFDxErdpAWjvo8XDkacWiUR6iu/Lic+kyH3e3N5/g/kSGp7dDXwL+l8UQ7t8ZFuwXRPyjYbyczYsvpU6JpC3aEpPESD5t66g/hMgYlSgikFa8DKB9H9YN3ipP56RlWhfAYeeaoeRsZ7qp9UDXZak6BrBGX8nmBV9R8D2gVlVLJ4O0MmbY4DnH+ICh2lCfLihJ/vwJhuHNBwXGe+d8RlEVdVDB41W1YrDArLjjZbDawsrsjw3J6CN0gBq1i3Ta9sviXW6Wz3KaD8MXZCq811V+81XO0fRz8dTRsaROT5lW/cPhcL9PtD0YsIWBFeJFWT2wqDDVnDnnGzRX4FaLfy6S4HzOfNevXKEyZkzoi/Wjyoa8l5ZVbS6m9HO7Y9Q1HaOQCrW4Lv7w0hCgsMAUStYWoLdMqm26wRzbpL7olDB93DKwA8mRrD89QtcuZwUbUa7lhJnhmyg2cL0+liRcP3ulD9t63aO1ZE8YQkuRfjkfxHTxz8voE8KIbTqaUyqRjkGwkktbgQXrCov48PEhfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KMtX7lA8lcL4+RvNJkGipLfVwy4rSODfPwXXTNuCjRjZFo/Qsv01wyjcTAcw?=
 =?us-ascii?Q?17uvrL8wWgs076cWU3ytBkdV9Z0omiJeM+U3DM1OVeDeeNEwMFLVII2aM/Mn?=
 =?us-ascii?Q?B8QNDc4NFt4XHeUMOmTtV3PZDayD+ZQCpnKJgC9S9RFFZSQy3Zpo6ATOA17J?=
 =?us-ascii?Q?N5rrpKThv34roRxAT3Mu/bQjuH2qXUzbHOiD9LB4m8jn8B83gxQW3j3YQewl?=
 =?us-ascii?Q?0gi9iGHXiBEUmgT4bJazVRs2qJWx3FyyZlQbgUNCSBWspZpceJr6H6fJZQWd?=
 =?us-ascii?Q?Vy5JYoCKyE1jx2X6XYl5tDGeFwj1dq/y4+wQySKJyvsWoGQEuoIB86uhsiwd?=
 =?us-ascii?Q?HZFddaV8ZoB05OSbkzTbJlZKmaN3fp0Ktkar864FhdN70XN9oAtU2BQtOqQb?=
 =?us-ascii?Q?Fpo7NGA/YPtR0aIC5GyLvVXSpYtHqnncOH49eu0Tkjz89L4SlTe7JQdgHlPf?=
 =?us-ascii?Q?S0lrowZAleaNp29SruqylRJQOoYl2aLWrL8pbLcQA3bzCPn+VTYSIqQvDCaH?=
 =?us-ascii?Q?Cz50jq2bnlSY82AKZCJcBMJYmAaL9dhV2Sp4X6Xk0ns8VMTBVxlHJ8W+Bgj9?=
 =?us-ascii?Q?CeUnwAv/AM1/GG7gWPH4BZSjD+4Sr0rOWxIh6bUxlnxWM7vqHKi/9YDf7Q7A?=
 =?us-ascii?Q?cLPWEpQKnJikRY8vkxemysI0POWv4togi/NwJCr6N7TdvSUxwn5fNaWxWCIx?=
 =?us-ascii?Q?E0TNqdSAshJ3B9yJOhd+MUwG6EZNCSJjGtDuRMVzFVEbWUHkD46BF48Ddq7h?=
 =?us-ascii?Q?09L9/HLkxw5evDOwvnO+a/aYi4K+Vjjoz5EORP2YgnQxvyH9ZOvxUW50iVVX?=
 =?us-ascii?Q?p2tuA0EhuUx2R0og/swNeS/avRV4MkWiiJRiaVx4mjwK+3tTmyB7Lh7Hq5Fv?=
 =?us-ascii?Q?EGUnGsg05xViaYMwSF86E8evdGUhtM+APhnzKER1MVjUp5LsYGR0a8fwytSS?=
 =?us-ascii?Q?2AMbX4uyCGx0uQXXfBJP1SK7M9amhbctAguu3pS53aEr7JZotA8fHnpR7OAR?=
 =?us-ascii?Q?FpX9j7+7uWb9Iz3u4BAjQpvkCmQ5oSUhdgCbh5UnqvJAB9SpUuJHzpDft1K+?=
 =?us-ascii?Q?kqdJ+i++t5UE/CvABXLiFjR7aQhjae2DhyWUgxn9z9NdxFBifJcx4hbwdFlG?=
 =?us-ascii?Q?n20/YV7RwI2aXrvVtaFiwug0nNigU41jSqXvQLQodsc7w/nh8uQRvj5CNWEd?=
 =?us-ascii?Q?4GEbjkZX+wdx6kJblySQbGHmi0mQ65gZLsh4mrVmNQ6/BO+NAWRwEBmR8b6T?=
 =?us-ascii?Q?th0vYGkIyc5ZveeLZufQmRH3cUDapc9muv7NTdWPigEr40dyNlauynr0t+cI?=
 =?us-ascii?Q?XELD6f+BYWkCpvip2Ia0+KkFNF/eRg9ZNOpS8Dys5oMn81C/kuh5NdS8XV+I?=
 =?us-ascii?Q?fuSYRp5JQtYZi6J103tCNX3MO6ugO+RwJZUeOIR/GO0MZLR3p/bnVyl1FZEJ?=
 =?us-ascii?Q?qm9lW6fogUH2JeSNCWvN7PFyE/0H1fp0wkAVFP/SbIOwrVf5hP19grstIVQA?=
 =?us-ascii?Q?j/Gc1caKezkviOrMK0rR+lP8NkTJRU6gVclheOoyFYLXmBykpJvx1+ZTeG+L?=
 =?us-ascii?Q?T8bNTvl2sdpBEeSjotu/Dee/xDxntiquFrlGA6fHoxTs1M5p57K2uik/K8o7?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6f6146-c44a-4d52-9948-08da8d2e340d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:00.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Csg2msrxrYLD4PBMBOxFHaLZUWY2Ra8TLp3kUmOCCsn2Ml03zZaN0zw6nE4dRs3b3VH9D1EFwCMzEhi77rBcSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
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
Acked-by: Camelia Groza <camelia.groza@nxp.com>
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
index 19c2d657c41a..5daa8c7626f4 100644
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

