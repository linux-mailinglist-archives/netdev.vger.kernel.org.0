Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7962D55F118
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiF1WRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiF1WPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:03 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F063584E;
        Tue, 28 Jun 2022 15:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbzhtgffuWa57dQpymGFlDvPtwqVJ50Qm68fFMmlliSeUCrOLyp3xZbaarIhAh8DGjNhXzHL6768RZkfvrreKEKq1QJ9TTCrlWCPkQ7ZYESNpVkcD+8a31O+tPl11pjGyzwn1TwwSlLMP7NZPFMeE+MZMnrrhEqb74Ff7C42b895GHlM0z+4aBHkv/wt/1K95Ek3xke4ar0tyHFrHDeClLhhjiq1nZUp9qX4s8O2mT3QIqKOJvJtxsumaYnBcgMahfOT+3gsboZtdd/xyIA9nr+8Yzy3g6c3nHv2a6XBhGDdil7F1abpF0ba6ZdJtKvEIvY67sKYhaUiU6bs0Vwyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7BrJA5PavkzVyK1KGe8HWlNKAyaHV7WuMzVn0YbMoY=;
 b=XOX8PZ4gnwFb7q91XhxhZh4EoavvW5KCn5aWQLTAxKFAO9fdHgbIRWLnhr8YVvNLer4RFQK1Rvi4TgTLPAIVZVIsXM1sVSiYuo+dKyNo2Gk7JoxMusgAOVReZny5atuI0mHQJU5bQQ37+m4ewG+p4w4YyRGJR9vvPemwul2OPfXNR9o0bgQBCWF1cbTAUWy/FPDGTzEFkt87h0FNYbBwEdWDO/s51uvVhkk9gB9BV1vpYEnnTEyM2JmAGBIp2+qkphpqMVqSVjCJsJbmPfVbzPNUOpi5jUPYoOwfXfNPs7Xxpm3cGTkXUnAiYjHstQPK5F6JHQIGk+MY736F+77dEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7BrJA5PavkzVyK1KGe8HWlNKAyaHV7WuMzVn0YbMoY=;
 b=sHfNUg6ZcHj90mfHkR0/0RWxbB+IUf6I5We/hfKFXvtfJI13BwBrVslgJrqDs2ORZpF1uxT/5Dg1Sjj9BFKQ+hIfDlYcdaV26baufMJn9smguqD4y1PmTvVvLTOtiJ22rqDcPZk/eijBSC3NYqsczdZtKVATAWDvtkMoYzPTlcoZsMwOfaojIIbI9VGdB5lO797Cla6nqPDyayaAHBOpB1puLHdX2jks72b2PABdNQVs6FcxKdXFqF/4TSbLwD4qRS2KhJz941fFU63UtjS6Q1SGDLGdjSX8AlhPKjyNa2H6ohPBkTO3OsLXfwOkaQ/8rowYMqMhHmfVLavNZF9CMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:50 +0000
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
Subject: [PATCH net-next v2 20/35] net: fman: Pass params directly to mac init
Date:   Tue, 28 Jun 2022 18:13:49 -0400
Message-Id: <20220628221404.1444200-21-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 429ece03-d872-4ad7-c143-08da59539eac
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgC7V+m3fz85ou+LxHagT3E5+D7pRiwhXeHhTF8dmDyGzwfygXybiapWhEVbDXtVq+BNVNxPnFxJNBd2W571etynS9NJo9WEHYz0XMxn/HHPlppe+LMVH3HUlJsrLMPdNcOPKPPBWUHZoTfHl0AGVZpxUDGZcPTGx1TDdrO5KF8s7QBK6nTvYQPXIb34XeDda5BzTLy/z4mh0++FUU77YIlwLkwTUugDeY6ka0aDG3ZVCKVavZc+wscBh9xRkqxskQyYS+gF8Uq3aJvIDpUsINgxi4NXnlZJ03JxKsmqINrfrylGtVsAuAjH2EtnzJ+LfoHSPnb9XVhG6Ou2Y5LEDQyprIxWlE6fCgJJOFYJDNdG/YyR+0keuB7Jqu4nM98a5QJGkvHjP1i5H0vCCu+QrFfR27VksXiI8QTmuK8TeNWURWJCYVlmzDLf4KX5YQ6s1E/N7OU60j3Dsd3zaj8+bN3VKhDMyp5ylAQXRNzCBbVgKaQrUZfw+Sz3growKWei3gR1G/JtGj8tZDSGSqG0X5iKsGv6FEFMqTNOqyb11nE8NVs+KKyus2CJavc/u5FEiZVG68CTBXGfwXo2BKbDRWAgyui6v4Best/zMCqL95d8m5b5r8GoQNL5KS1Hqd3i9/VROC509xwpncnS859GFJRTj953piQ9cYv9AzL/Xd22TOfEoWjbAJ8fmW1sY07FfAFUiUDl5KbsYcM482tlqApNPkmNeWkrfCISbxb0HVzTiX/8YPyHNIWcHiPg8sbKHyLFxQ3NlPmUbi1V07C6/JGZOPuSw9OEzX8vktQrqZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijuwlZ8CGMa7HdB3WM8vaK2tSd32oOI0Caskfg4sl3kK0qJe5HNrrXhYLRl0?=
 =?us-ascii?Q?4ROSdqoW6ARreIPF/AL6900MA6PB2pef5iQmVU2weFoew46+FQxkFYClcwmi?=
 =?us-ascii?Q?j6pb7PTUlHZRE9NIkX4WlZeW6a34MICWHDYXEQdD+7dM0qbISz/bw1UcD7FW?=
 =?us-ascii?Q?2Yj753oU9pzzWUGyRWju31D9NGRzHtH8jp1a8R0/69EceBVCFdO3DBgdYSwe?=
 =?us-ascii?Q?6Hnd3454UIXSsspYtY0BOjZlmvGyNhnoDOy9/LXrgSCJmm0seszO4+7+BX2p?=
 =?us-ascii?Q?uz2X95MEOt2cQIFiOWmvVIHVA0osFRAwiKCL53u29r+9bYgUt83pxp3k957Z?=
 =?us-ascii?Q?u+fyzlQ/TNekCJquN6/UAjwjCfmCCOhz7ausGZ/Ebw1jn56LDeYFIbWzjWn5?=
 =?us-ascii?Q?/kpCZD3iZEmc0/gylpAkakUs0TH66zeaIY3jKxxHbMU30ngrH/th89sO4if+?=
 =?us-ascii?Q?zVFSOdM+Oip8BsO+WHXvnBHkx/XwyUKODhlttg/aQem9VqWIS8/75WtiTz0m?=
 =?us-ascii?Q?3Cz8fXdnCK5KU2D+EYz+tdrWJRbuqVXanWWV7nxS0cbIRg9txWB5VHVprOcP?=
 =?us-ascii?Q?8hBwT5X4Un/xVWrnMbt0uIDhZXFrGy/OesH9Zkzo6wttPN78XEPE25pNvkNI?=
 =?us-ascii?Q?SPJKR3roK4dfal6uVFNWMXrotxfxz6rZ8ZNwcz1rftkB1szbzzVThY+61Zcr?=
 =?us-ascii?Q?AHZ2v+t/ykqPGctzYrTVOgg0X4K//XTD00XTWRrmBjp6SCBx1kCYSwKhza1u?=
 =?us-ascii?Q?sVmMre2Zfr3FmyOZu1I7xJ/eltjrkEzLGBPncP9oPZXz1nHamWE8H3W7mf+P?=
 =?us-ascii?Q?GpigQfQ0kzewY5Owg+HyEdIBtvLMjaCNLHWtTrYgayANNOvG81oGyDoOn8SL?=
 =?us-ascii?Q?LUe9WeCnMnqq06ESQoZASqjYqoi1/MTrmGLAClraTuScoRcM2pxLuSaH91oy?=
 =?us-ascii?Q?w8bJ5lhF2buZKCASgJxJ4SOAN3yg44Wn0CAxXJoaqMqmLKrY8pnT9Gizy6uG?=
 =?us-ascii?Q?ZC+/C8eNXY4gTHVrXVY7INyLWAA41H9Irgjq9JR3ftknE6gmw3QHqXJ/X/U0?=
 =?us-ascii?Q?0UfNK4U3ieRx/wPpxpNkE9PvoU6MTZjEj07n6x108B6j99Zf3HAxdO7r0nhQ?=
 =?us-ascii?Q?UMachHM98c9epS4QYNg4coFduwTEXuJ003/Q7pTgOyrjGOnrrgVC6f3JGefF?=
 =?us-ascii?Q?+rndPr2+1aJHTLvyrJbfes48mjjihZN1bj1MZ2Dq93DrnrTVUHpmXmw9JMOU?=
 =?us-ascii?Q?76tTdu/eP/d2QT+9aXQwSMmOlzXoLvFdo9ERqALkjFKmJ1nYTzpHEmC14t9i?=
 =?us-ascii?Q?HeEHsgrjGyNjsw7YrYVVWuY4dYjMCn1sBeGlVMMGvbchF3RT9N4ZvpzhGuzc?=
 =?us-ascii?Q?Pfi23RCMe6ILeMJmt6SfktXvFLe+Z156G1mtyBjUPOz5oGmUivQWVDTau4iB?=
 =?us-ascii?Q?4CJN0WuLbs1oJYZBfueWHAte7t1b75kA2XsTZMSopzx9MyTQra76g+E8He/V?=
 =?us-ascii?Q?ciH2g6fy8CnYA2nkYEhSg7x1+5jOY85wOjG4Fvr5qoPJIh6AprfnPXWoi91Q?=
 =?us-ascii?Q?bkarUcRfD438quiguEBKvZtJ3/z6Su2ymK5D50ANcl/V2le4igzPApWhWJIY?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429ece03-d872-4ad7-c143-08da59539eac
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:50.6563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omGX3ZweyR22vWHp+uYXOiCurb8xp7vWTBq8QbmWUDaGL0SELs5vOVYyItrZjRA/CWhwFMTVwbnTQzm+rZ+PuA==
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

