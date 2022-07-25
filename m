Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44158015E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiGYPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiGYPNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:13:24 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686951BE93;
        Mon, 25 Jul 2022 08:11:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkDNgMzjXgXvBCPg9x7c/Fbzzn6AXOJCOUTAlvIe9r8A7HoRicBX2gK7qwFbGdqq5FNwucXemP5BH0ea/sJvnU3g3Ov2swixIjqPXezu0R0E0L4xmyZsmwqu8RdtDiwj3tIk6UnRimLy4HgGYir+hdzLd20hpTl9vzu4MySqfWINC3oOz7ZnnkZpuXDnoIJdS6mmtLyR0TJGbx10w4Apn86pYFv+nTXsDkZsd9gdi7ZItMgX6A4yuC5qkroxzJsC7TvLciCr1NliHIGZ/Uh0hWBhYtYrl3f/ACYdrdlLjK+S+f8YtrAZVoxpRPrO0ByobUkkhmr08xHtLFpaZ+aMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo9Km00Er52i6dULb9Rb7HzPOzetPkenFipzAOcXWgc=;
 b=e+dMKIwrqHzljlB2DY65R5hgevqD9kSY4TTKjL1nrt+Z6W3QqWs6tmlL0e6L1Xr6M6ePXea0+Xgi5k/SskNXHbt3PM67A1LbJvym4GIs8jeA6xTWWLgGrzw7TQXNFlDaDy+PVpgf4jxj28Tn6URVgILCs0VsCtU6pr/UnOA8+hC2rsgHuJYQeCrNQB0zqCve5jI078KlyTHG7UOqmenxDJo2aQhPY64UnAks1xeWEk+owxGjN+zw/1d1rG6+1xtlaEgkodatYouF6W5IyT1tugXvbQT/QsJYA8rKUKyMNp4FOsIdxfu7GKDT/lt7rN075pxNe7MNLvagYn9j/evLvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo9Km00Er52i6dULb9Rb7HzPOzetPkenFipzAOcXWgc=;
 b=S9+2UYRobBIoLbglw4gQls38OmgdYh7akp7t/oRuHkPW7AwDtXC7LnvaJVSvCQmu2abHoIbOKqQSavl/p7wwQlE1AF9QhxDOwGmwoyFIIAqad405e5rKz/PI7I5LLo77mz1nUv1RxnKT8iT2i6FP+kmfzLlSK4G4luEnLaApGF54tkJDZv2J/CmHko2llw2XAixUSN+T4c4ESQY7cu8WMC3IFQLB+gPP07Z38PU9w+JaoB4LWfRhdnis3GbP/0K224j4KvsQahIfHykf05UDbBtCh/DqQELVmUe52Aqu8GnNbe45qDxh2l1zLN9wkbz3Fv24XhJw3ixuu6nYpSrEzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 19/25] net: fman: Specify type of mac_dev for exception_cb
Date:   Mon, 25 Jul 2022 11:10:33 -0400
Message-Id: <20220725151039.2581576-20-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9fa7e21-5c4c-4351-3215-08da6e4ff5af
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95/XWpIES0h2bX8uBqoOsmgrOT8BEXRXf1c0bMlaQk1yxvefwFEmHoJJhCSKkaXkGRYlC+dM28BFGvvHVapEYHoH9yszcbIjqb9VdxSHRM7Ahm69guCsuYMxZx/1IQM7GWvzXCLoQwOxF2MiNpUSjG3d+XFbG/ckNGzubpw7ouuMu0aQUpnMmHAty1IqKH2MbxrDArSjTZlAOHpjsQXNb1fyw9WTUqiEelAYiFDd7DfaQDU94gDJgPvGRzEFhTf2ptXkPpFkGImzcHAzBNQHvDZf8RzWT15Fhak9R1mwvl8h896te08QjPuKj23LNdO+XRPmZXxlen+yAPX2yO3ZGUB68ok8bttt43DQhsfGzzsSpdEWFIUfc+uDc0fFCnnm82bLYPrpEXodRIOSvsiWGaxfdZQaesKDuUE0r5brOLoFVrK3KKEL3+n1tyy2EAKNFctesDWpzS4fPiqBpZ3Kvblimh/we4T0tF0xPE+b4dYfU9nwyXiNMKmjAhctdLq9H2SsVCgEoBFDq4U9k55bwe6jsIaA3gH2jRcgfb+xiYX1963D8Tty0tRFpUlg6B835hJBvxEdMFzubGTh5r5xA3natdKPHjltEDpTCyVgYCpen01WxJwDriTVY4ZZNPAqz1CAirQfq10bq3kcbJ3m/YkDh+ibzWONFP7vo6yOL6lt/Tp6Ymi5ClqS/OiVNTiclMAvjdcg2x8BILjZAyonZDw0gZmVUuJBMXsCKFlNIngTGGwda8iw3DnIn/cfEpua8P+XaJkB/stcc4R4I3LsNd7Oq8nYTqOfcEz0SeFWqXo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9IcOB3IiRsm4kahgWzQKp7yBOYe5x+giJO3gUofN/A0pbH7wYCw0kHamwIQY?=
 =?us-ascii?Q?g6sqJ2LJwWlf0IjxU0438Iz1TZWj0mHsjVbazmC8SsiyjbMD3ymm0dhivVD8?=
 =?us-ascii?Q?zJRh3cZIFZriPkfiexZGSMyCO+oP1uQcwyX/sNvhS8iAIgBEeRTy2nmBuqry?=
 =?us-ascii?Q?eMx1T9Ir2pp6pLs59Qj/1pKQfacvlrMc1u0FEsFEd9LhM6tv2mgP/d08iLx5?=
 =?us-ascii?Q?5I36IXZkkeN9x0D8LENhtDKu9Xo+BLFEjtLdH4EGVeO6bPpaUtQizKcYA5zm?=
 =?us-ascii?Q?efd7ZkT1G5SVpq4r4gr+T9ml2D3vN5934kOMNc8rHHxKThLGsLXZji5Rc3kW?=
 =?us-ascii?Q?k0EneFp6UN66pHIWWQhfvgSVejNy62vgP+dk2Sm3yCjbVulQHmesRWCCh8z+?=
 =?us-ascii?Q?KYMvNvRB32usl/1EnbAp2fgy+pIFoQAng9pE+rt1Va6qSy5Bt3APs1PiEhCY?=
 =?us-ascii?Q?RrkB2oEhXZ8nSeNJUdqKdA5xkfi7cgDzYaUaKO16q1E6FIr/3h4EuFvMXpCx?=
 =?us-ascii?Q?EPHq8xu7jWG77FBJjVk4nDp/o51sXvueYY2BDR+HNNNQg7QyCh+nnbUrBvAx?=
 =?us-ascii?Q?cx8rAwcMETaaaMXbc55YoVNLctO+NFmbLa7cn2hUyKUk52kZD8qXE2/dWwFP?=
 =?us-ascii?Q?WkseIrlmIpABLaEi1VXHoqPCyRf8Xp5fa2xxo2BfEwMg+qIAPQCKX9uJdAJy?=
 =?us-ascii?Q?NRa6uRPcQSnZvC7ikpYLeJdkfMzNb5uCu89c0sEson+ecR8zgIDO8VeUIxJ3?=
 =?us-ascii?Q?ea3oVQ5bKKpBMSPSsKhk7Fa+V1qDfoP1wj76jOhtTiUQSoXF6GY7cg5muRjv?=
 =?us-ascii?Q?MH1iTvpET5XYMxY5gVDdlJy9HX2t9MSqd6c5zyUx4QjcPJIsWlqecJ8Q7uDy?=
 =?us-ascii?Q?7SuJNlfGW6ylPkXTAFo8CUL36qmS7QjHxUpR5e1qFE724jZthLLlTzYROK84?=
 =?us-ascii?Q?keihwoOzHN9cIHpA2MPDRlHZat9YEExcB0nsWhlVfew2dX+OhncBfVk0Volw?=
 =?us-ascii?Q?BbOs4KoGcY4ctXOz5mFJxrWUQDx1NtAbYVxaL7ZJneUdoLh238Gw41lc+tTs?=
 =?us-ascii?Q?VWq4Ltvv5Ew/MGrfjtZ9L/ILfirLrWuneEUnTGQDTGlE8TDS/C8c8b3ukV4k?=
 =?us-ascii?Q?Gu4zp3L7apaJdH5LO4+DzkWyO+vNB5bj9BS+xLyDD0nYePlT1vMJ5lK2dVNO?=
 =?us-ascii?Q?k6dKZjnxvs1M5ZlAFs0I4W74LfqT+RU594OIttEoVsDmyF+puCgMIiFFxFJ9?=
 =?us-ascii?Q?MbFbS2M0GT61svNvrLyMXRt2oIhJIDfPK1zd15w2+iz+o2fBcVNGDeTHIf8I?=
 =?us-ascii?Q?cv670lRXbUD0keN8+RTzd6e5mDGZUkVEA+ag1UD5/tKK0cB6uGpu1NNI1YYv?=
 =?us-ascii?Q?d4vhZuFV31CLvx7gJfY0cyY7OyEdbSF9JHi1FPnYjxz01M6da86S/SPBGxBH?=
 =?us-ascii?Q?cSaG0t1gBf0WnQj3wETFLwfFds3OlBF50vSqLX/CGtFoar1WPDC3qUZfauPw?=
 =?us-ascii?Q?4th1+s9XCjU5h0l6eSah7ympZJURxWXviMaX/yPZaaWIB4G/3vJILLdhu/lX?=
 =?us-ascii?Q?IF8SM7fH27b3jaZneg8Ru34LDkA96kC5Z/732ouJJzvQtQOfsgYIfTdsRjHc?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fa7e21-5c4c-4351-3215-08da6e4ff5af
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:33.1280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6k/RZMLXov+cfD4tI6KrkSZo2ffj7fVRpEtCm5xdF7Z17TZE8ofj+ziYI1IQz9LoAy7bI3vQfdDTEs3QQynDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

