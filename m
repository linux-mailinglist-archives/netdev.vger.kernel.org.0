Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176C85988BC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344464AbiHRQUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344713AbiHRQTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:19:32 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3952FC0B47;
        Thu, 18 Aug 2022 09:17:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/DS+VEstEQoxPp4N3KF6by9nijLpf10IlZBwxnJ1EJ5UMICBrHat1BZMts0m/sz9fqmeNipL9XanqFt2iF2xTXKIT8BN8H//besFiLJduoojhUKwVqi2tp3VNAoi5NPHgrWxLw/lPXZvyNfT2i1Qp4L419Pm4/aax8Jj0gDh+mzeEG/UrHxJmnPTba22UXt62irVnZQm0U3XGEiVWwQYtdqygx1AkC/mDrHmVCQJoNYq4QoTQoHNm0229izQLTyRWnbpuyodpXiT+Oxq7Eti25ZQ92LR4E0OXEw3jb+wYfGFJ9tpaQx0Htem/GeNRnC2OqiDq00z2g+10gCK3TzuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo9Km00Er52i6dULb9Rb7HzPOzetPkenFipzAOcXWgc=;
 b=AgNRTlLPxP/5hTgqb1lDXULBOvQyrjEIKlu4IEix+L/FXfekT2XxtbJa3Y3n8Zsx79tTw5FgEYlIngntyCm22aHojdoF+RCT0VmPFOxeyXyCmYul4lvER+aai1hQNxf5oxph+QLOCecwYPboJwSDx/5cjJ2s/iRJkdWz5QrBZZhnhcFXLPX9Gqh65CiRZJyQ/2Y2Hy4EmyQ96PdB6fxR0O1wAdJ0Q86pFXABW3SR6xeyYpRre1Rwj2izTLOdryzMlAtMEGkwuPC14Ck4RVOFSb7xCckFFQpskSb/4xdWZ0j83WpXNxBdAF4g5OHZ5hmfG1quGXhRrI+lmwoMEjm80w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo9Km00Er52i6dULb9Rb7HzPOzetPkenFipzAOcXWgc=;
 b=Aq1OXHbLRgyLkimv5LNY6D+LNazbzWH1jpyZvTP78DEQElFqyXrCuDdH5UrWbOirh5ICBmtgexs0RrstgrPVKZgol2qLXZprsezTVjfcMoMto4H7+m0eAoS3y8L9DtgkGvXXo804p+Si+vsqS8bvK5zug6yIRLf8enbgiIvhWPFPPCHURNQmwOUmXfuQbnywRLRDNVWlWpAJX/veq8DUzchY4tq5HItC8RT/KXf4y4Yyiohxu6vxuUbijov3zYk4vpTw2XpKy5QMCFghEW4QPnA/GJgShGQicg8g5J+vDNUiwvUR00yAdMDBtf8RlgVGtVj6ik360V/jl9cDFA2qbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:35 +0000
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
Subject: [RESEND PATCH net-next v4 19/25] net: fman: Specify type of mac_dev for exception_cb
Date:   Thu, 18 Aug 2022 12:16:43 -0400
Message-Id: <20220818161649.2058728-20-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 570372af-d5fb-48f2-1329-08da81352988
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43IlgqG3mR1JHIJI9JOfLG7tcrd3UdDGFNKDcJ9Cm9NrWa3m18HT/g+YJ+Vmg0H+ye63q787G8f5eljZpd3pqw/VRSSBBKa7ZnRe5Fw8u5sFJLg4xlPXZQiv+GrsUBLRL6lQWK2XedP7XCHqjbJrYj0SFOWy3uE7O0LRwAXXBtwebFbyyvCW7Z8VRRSTAeIB75bEBT+mu2HM8sRQNRs4NgeZEIcgT28D+LNXyoe02HT9gl3iinLlq2640YX6Hfokaj+lBO88rdzNZu2kPjc9VHt8G+4DhcoPQdyk+RIyy5DY9XICf+rg5FGaxZXvo4wbu7g/YfeVWZ1bCchpzEWrfD4Jq7KoqhkM+BASSNTLwEiUFhVgs6C8P4PltN15sE/d238/uVK3pVypl4XYwbTxJ4WcbVLasLsWEirtGPOPtKu8vHkEPvHwA7gEJL3npAE02sWktUZNr58DB76vusyTpos9YHJF24C6zQ+iZJXT/VQzjyvgjOvHDkfdnvqwGj4R9OJ1qxlV8+Wdf/rFkGkahAlOVW1a8Ul/TWV2swCn8bko3/B2hUnaZ3TwkJ9SqxahXoTOt9+R3UxRlMldVFg0SyC2ezo9KtN2vMl599DqC8xAA7JkGgWdeLJlVzS/o7NgXKzHR8vNAnk17ajHlKgam0s1LqoGoNWukMJjGrUJApKlNrq2uWZEw1uMsuJz/5crZntzvjwUIMXWfqUrwqiTeMn68Gr2RgD6TXTyVsBKH5gqsbzvIeobScOFMrxWFn131v8bt0EGQksPHiroLpXDVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TbaU7CXUwA/a+UWHBW/YsWiJWZ1VOa7a108GYiYyspiOG9i13v0u4DJ1ijBp?=
 =?us-ascii?Q?GGun9rOpSGaf7aZFJX7NPiQSa21Jb+HWiww7MHsMBjIjj9lN6fgbZcZSqLMy?=
 =?us-ascii?Q?NDO/WPJVc1WWd2g61MWD7Muz/2xhiPIbrB513aeKrzYF4/KX5QRBfTg7El89?=
 =?us-ascii?Q?/dwXrDi0w7lJMqNrYm+tj2kw6joopNdIGg8CNNECvMCodZJMIw5wXBFdN3+m?=
 =?us-ascii?Q?sErGXB4mncoapzpG593gkkegXfsuAiHF38HFXTQ9a1vDYGy8m+qZP0Vs7bkP?=
 =?us-ascii?Q?uvlVNW5rH09QnEhp+48/JfMIPwH5drpVjzPqx+h6qNUE/BQFwr23IWFqdkCA?=
 =?us-ascii?Q?st9nO1IWa/kwHmmYjieXan6Lj8UTS4PA6Q6HqyzLJ7AQxCYVl5MMeTyT+KWq?=
 =?us-ascii?Q?INNIpUXbUyYjkUurkxHCggEmMTCslfOr3VhOlpN1eBD79pvHUBGxOP/zWyh0?=
 =?us-ascii?Q?r9h6TEjCl9TOyyutxk7TXjpsFYUjHlKzW/xeJotvZEoscJCkKxAcGKD2cp1x?=
 =?us-ascii?Q?uuyi4C1TZb7LMcTZ/E9QrsBuQ101nEikq5Llm6dK3zUw1Qs5Itqv6Ndp49QZ?=
 =?us-ascii?Q?NFG3QgXZzFPMxKBdTT5QXzD/T+We68+YReL9aZnX6uDwpgiNusDXMHP7k7YK?=
 =?us-ascii?Q?fOOcUVO/ryMN9TTHqlYSb9Ji3iOcmSsqihNKfxjq8odgK3OBuHWUephM3pvi?=
 =?us-ascii?Q?QUHjUKOVbHy+yu1VJY1T3Bt3BYzyPkyZdyagJdVzV8HZb4QXpHHH0h502FDe?=
 =?us-ascii?Q?WHTid8uI9waTu5w6/bdTl7IHj15Sw8u5T5ptmQYg5YgRYtwcYHd3SSsn6Gaa?=
 =?us-ascii?Q?Lqz2ko1ElLHB+Loh28ib0W4USi/X9v9QY7Z01E8mBs8xVYI/P+6xk5YQ2Iio?=
 =?us-ascii?Q?JB86VmTiKLfDSSraKNJ53jqTKe/V2TLsEgMlGut0jT8jbklghJYk8D7SBmCl?=
 =?us-ascii?Q?tFUFy8dIgeQyEcCNnQ2hd94BF8Jtly7pLZiaj2W8VcFiM3lXNSXnf1UzNja8?=
 =?us-ascii?Q?mP1PRhg9toclrxMHP+vOVDuErg7NEzoP04Un+MFuodj2mKx3vvEqpHcIGtPj?=
 =?us-ascii?Q?jLxbnjE/TsQyQ9vxGv54FHRk49t20g1nOlRJgBLzIexkdqgRa4RRIEKg2sfr?=
 =?us-ascii?Q?O+uy3ANgL0lr34KNJT76ZVBYnlj/QEvApZhAPa1gMwfd6dgceLByEGVF506g?=
 =?us-ascii?Q?+Z+hAtZEw3NDY3bZAiF1u9shkVyX90EHg78+/euWQAH5Wfs+m8HVr7l/3oNk?=
 =?us-ascii?Q?N9InORl5OboJTDyfGnf8b6YnfqcB5PXEWQbUFz6Qlx2YOYh1jT3t5L+GRVzz?=
 =?us-ascii?Q?j16+ALEZZlGt0lwyp94tWsQkZGDcHa8QXyg9SI22+g11UYbcl8JyquDwIWNS?=
 =?us-ascii?Q?h/xNVN/st6J1mw+nH0THrxFcGtjJ26iW1Ts52Wnd1o+yr9FC5RtFNyJdTDmq?=
 =?us-ascii?Q?JyD2SG5yl+gCNlOlG9jVLHdJqcDrU96q23YmZD/7mYu8C8aqPTCl5+AkhnQ8?=
 =?us-ascii?Q?UF0F2Hfn8Jvs+fYY3WlJRBLPUi7NYwzLmC1qYjY1egrdZznwKbLpf4Bd5IIm?=
 =?us-ascii?Q?wx0xsZus9/9OYEoNHRc2EpaRZYych4kfaLSColujC5zu2IfyoVY7gW16Ezx0?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570372af-d5fb-48f2-1329-08da81352988
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:35.8098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocFdgsPacvau76NhcMBGHir4emMqx7N0DJqGuhKVNGNZdSFMvf01VzNt92Pgut8j/XKxD8Y9iCDMIPSdEOurrQ==
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

Instead of using a void pointer for mac_dev, specify its type
explicitly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 5 +++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 drivers/net/ethernet/freescale/fman/mac.c        | 5 ++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 09ad1117005a..7acd57424034 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -301,7 +301,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Number of individual addresses in registers for this station */
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 730aae7fed13..65887a3160d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -41,6 +41,7 @@
 #include <linux/if_ether.h>
 
 struct fman_mac;
+struct mac_device;
 
 /* Ethernet Address */
 typedef u8 enet_addr_t[ETH_ALEN];
@@ -158,8 +159,8 @@ struct eth_hash_entry {
 	struct list_head node;
 };
 
-typedef void (fman_mac_exception_cb)(void *dev_id,
-				    enum fman_mac_exceptions exceptions);
+typedef void (fman_mac_exception_cb)(struct mac_device *dev_id,
+				     enum fman_mac_exceptions exceptions);
 
 /* FMan MAC config input */
 struct fman_mac_params {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2f3050df5ab9..19619af99f9c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -311,7 +311,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2642a4c27292..010c0e0b57d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -180,7 +180,7 @@ struct fman_mac {
 	/* MAC address of device; */
 	u64 addr;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0f9e3e9e60c6..66a3742a862b 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -41,10 +41,9 @@ struct mac_address {
 	struct list_head list;
 };
 
-static void mac_exception(void *handle, enum fman_mac_exceptions ex)
+static void mac_exception(struct mac_device *mac_dev,
+			  enum fman_mac_exceptions ex)
 {
-	struct mac_device *mac_dev = handle;
-
 	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
 		/* don't flag RX FIFO after the first */
 		mac_dev->set_exception(mac_dev->fman_mac,
-- 
2.35.1.1320.gc452695387.dirty

