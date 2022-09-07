Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B95AFE50
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiIGIAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiIGIAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:00:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF0561D6D;
        Wed,  7 Sep 2022 01:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0YSQy7P5VDyPXap+xwmp4WaAmN1PYBxeKdyd9PUr2BLAVZqjoOzxvjAB6kf4K13EPOqgOWWKNdrWDQWLVhDVZ+qNPli3lZUbWr0Px1VFouXyZvNDVORF9ub7J4Z14f9HgNabuQTvsGPaJ7W63nxOi3AbAxdssHZq5HQ5nmUo45LIosv4R4qP0sH8VN+mDDx5p+CnDWNAZ7MxKDycUZA313KHs7OtvrAXR+UpRz9+gQM+dpNzp2MFlA02F4WjWsdi5BQ+B4IFT+/yM5IuVkyHopeFg9TnpUY9oz/oR+dw6K3wPfys53au3badnfroBV/yBhyKS9Et1fYCUBj4I4r/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH4ClpXLoh0Yfvp0GxMtnOS/ifat+xwjj8RzbBez1U4=;
 b=Y9MhuNOM8ymITCZ1/2Ut0upDspNes0ssqiuV/Cv9RMy/Mi7GXR+P2xhOdO5i1FyeJVPlJvZvocn6/vtqmZbyLLgnwTqskN+6eKkP32xOo7aLi8SG62MwD0aVgz8EhH/0Ut9sIGBu09sE4RH1AEt7X+Rr7QebCJAfOdkn+RXQjT9nhYG5x0hrNAC4kV65G7bqMsUsDR8DtWxF3KulIj3pxcKAlM91CMHeELUaWMwmixuSgciAf1Xqs7ydFqdUnnVQpxQ5y66K5QwFBfrXc6tkZaS3XIINfruD1wur0uznzQwmBGPEIVCPJgisD/BbkcOVw7Ht3CWf3lx+GRzl158MMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XH4ClpXLoh0Yfvp0GxMtnOS/ifat+xwjj8RzbBez1U4=;
 b=kNmdatgJ+1XCf1UamkTb6HWvfh9vyVISgjS+jT/rqY8jeCvzHW8+LZ4GI4WmvqDihYO2s/kSpBRtcGD7gbEvwl8cg6OPd4C7PWY4T8ADBnMrppLX/1e7m5zYSy9DhnmPu3880gR6O10WiQKWVIdQeYSvOlJKIyRxvqTGgWz54tWeYKk1jdMEieiqbNKHriiR6/ctDLqI+Izpn5wcTW1Ij+tlDi8GjkgVtGkMw8VvJNi6xL6UMlwn5lEFIav5T5EYYLcclkT+7qPSsKplvQI08XPhNrp2V+kThyWcdyKYk7OyvNB/cvtEpRryBnTFEJEb/nYaDC/yEcYGR3fD++HxCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:00:35 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:00:35 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v3 1/4] net: bonding: Share lacpdu_mcast_addr definition
Date:   Wed,  7 Sep 2022 16:56:39 +0900
Message-Id: <20220907075642.475236-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907075642.475236-1-bpoirier@nvidia.com>
References: <20220907075642.475236-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0021.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::8) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 082b7987-f0f7-4c54-46d5-08da90a70b8e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fdkMMRRuxpy7V38jiNaFoICAxBxQb6RIqE5aSOGWKKzbg3uNZA+n8SB+PA6YTpoqysp3yfDsgFy5g3xxt80A+o8YNJEr8G8a1ViqKP91O0mcksqICX9oD9mrpGOAr6KwPjCs1oaCERmMR8EV+TX3OLhdqGFpaaEQgqxjugKn7XuQvUQmsLuO2eIO8Mh4F3ppQIKD9NpJ9lmS3kSS9OdDU9pC+6EsP6m/si2IBPtjAF0iORv3IUFZRx9zCaXwdWxwYtK2jOeW2GGQBiAwfSn9HX0cgWCIFWIJ9OFtcI/PzWsXhXd1DaMAz0kvPDYnfdSKXcBYjCkK2at9mRayFQnT+iGSMmISw4rBQ2UrvsmX+duuCQj5JFVnQh4ogLTN3hlx25C+e0p/G9OjkmMGS5XX2fVNcOI4eDhVc9kJ1XxoZAhpimPB/autBjq+jfqQDlqgEoZHPAxI8swGTEgVLwNollJUtAin65Ta405+C/jyvQefz8+CPslXCqxiBjObRxzHqPSqyMvsd3lKIsDlzijRX+HrUNG4n0qEtkwDRjKQT5FabQCG+mY9EsPXSDt6pHwt790sf1vVPV/VUlTB9hiUlLkWPe9u2U5WA0/W/MJSGjEv6/kFE7LgN7ywuDdwHDw9zVhi9y53iffe6yRK+cCBTgIDAnppGgKCu9zqgHG/ETXAP7SnUf5hFdMilwmf+xWCQ0V3puFYdat9i8+EFV8ayA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(2906002)(5660300002)(7416002)(38100700002)(6486002)(8936002)(478600001)(6506007)(41300700001)(316002)(6916009)(54906003)(4326008)(66556008)(83380400001)(66946007)(66476007)(8676002)(1076003)(26005)(6512007)(186003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QzIAPtCqMw6gmrBcsLaBU+aWWMfICUWmh6CED9sfHZdmzs8laSVj7COzawzO?=
 =?us-ascii?Q?okq8dhcVaAbp/RweX58WkZbxKzrB7oxJhbnS0UqWSrUlMEM/ol7Ny/OwH5+r?=
 =?us-ascii?Q?FvtYXup1vqwLxQsqFY5naBR7f/VKjW76vJeIp1ur4RJMwmCP0u70H41tv8J5?=
 =?us-ascii?Q?eb52s0sp9/QV+oBxWvVVyFWibeXB/BThdQBmVoET/zsf0QwTd7YySz8hVhZb?=
 =?us-ascii?Q?O22zI4Sq55P9sysHIfqpmIL36XCnBrtiuKGndZqz7TSqSaUcDe33oJBPxqUd?=
 =?us-ascii?Q?NaJL+W8U6DYaWbBkmpRva5D2ZfpeT9Tv8GXwqWtRnPMOi4YT2rcO0WaoWHlK?=
 =?us-ascii?Q?nwMGyMHgkTQyWbj8XrF62Zivdn3aMvO9Ynwx8aswAlVM+q3/w6ZhsZq96y6Z?=
 =?us-ascii?Q?2tLm9tFuYjn/2EvVoGPe9kOHwkV+U+2pgfW1JQ1B0rFAa5x9WnVk6PEj4RmT?=
 =?us-ascii?Q?WcGQ9XZECaeE6VslLvfjrrXqzWJo/3NutfplYVRUQYf2Ie6BmxwDAoA4qaWg?=
 =?us-ascii?Q?uK5EOXx1DjNHMDpB8Zv7NGWGtc5btrPwgTOPyrq3z7s8N3NqxSb5/c5Pj+IY?=
 =?us-ascii?Q?W3iiQsue5w869kmRkIJA83w4Hpf1whzNuRZkAUBOjg6DJqXU1c7IR3zI0l5N?=
 =?us-ascii?Q?G08ugpuTDRDZ7pYTkoDbz7svXZ4uTF6WZzC9Y5/gCzLAzpxFs4+tNwX3R32l?=
 =?us-ascii?Q?/91OuN+Q7JX50KJ/6iiaUoI6sq+AF4l5ZqQv9skxY9HseD4FVYe+RlObGQBQ?=
 =?us-ascii?Q?XLn9J9id5kPSZCqXfqQNDvpDA6EW2IUmd4lAUlywY+83f/tZ4p6sPgpIdO9X?=
 =?us-ascii?Q?PwsX0KjQTR+1s0NGiggCE6D1E66SHSppTsivekAAw1Y3xCfPl7fybh9mZ0Zo?=
 =?us-ascii?Q?l9HejMOd28Dy3SYDnGcBsoNkNq7PTgGgXbyQpZGne6Za6hSKnUyA9g5znHMp?=
 =?us-ascii?Q?oUr6iS1izDoS4rUqYG7EcFspsnxGvIZtTx69V7hATJ5M2JhF6vmzpESopDCA?=
 =?us-ascii?Q?yRxss7dmeqcgyNdJWEN1PzsJBY1KzWmEbAIrShS2zjSqeArfLfxqe2RaTWza?=
 =?us-ascii?Q?qbQH2ls0HGq9GBxitEVj+CWW6fsz57FGwqZAALiiEtGbqo7IwZQSuHKS8E4L?=
 =?us-ascii?Q?2FslgHfCVytYKgIlbrtRzwCblmAk7kVz6sjv7LTf/tkGK3lYfxdyiLOG6eY6?=
 =?us-ascii?Q?HBVW4AOf+x1iWbwtEtxu7f6YNaZERsA14hCRpTOFpoE6UUBEXALSWygzN7FV?=
 =?us-ascii?Q?62COK8AqxOfDSm5Ozh2VB3dewRqe3X9TX00wMwymn6W0b6joh8/QT5MO8Zbf?=
 =?us-ascii?Q?b7iLrc/rwAFLzChuO4vk/+9NAqAJ81x16HWCt1HyiDbXcZOizM7J1hrh5u1I?=
 =?us-ascii?Q?Ch0kxbmSmIsdECMmhHZfHBTUsIaHGn+ufxkZjicaz3RhXq3KUC5rACVu37Yg?=
 =?us-ascii?Q?QrRycGHPWL6SpPts+Taj+1p705emr9z3dsaTu3Meob+FcvNBDabpIqywtvo6?=
 =?us-ascii?Q?YOxdOn4Y4qg8IJV76PeNAz9kwV6RydH64Yy0cERZ/ceiEPYk8hG61dCIgte4?=
 =?us-ascii?Q?uuxpFb9DGN0cwdmytEnRXGjf9fJuoqJiFj5S4OSR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 082b7987-f0f7-4c54-46d5-08da90a70b8e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:00:35.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3v4CuSjI0xZn1iOEQy1us9aVysaUkophwMoc3++f3cVJNIYam1XrU+8+DkB1AHzYRZvQCusSFy28fJU66zjyMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are already a few definitions of arrays containing
MULTICAST_LACPDU_ADDR and the next patch will add one more use. These all
contain the same constant data so define one common instance for all
bonding code.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 drivers/net/bonding/bond_3ad.c  |  5 +++--
 drivers/net/bonding/bond_main.c | 16 ++++------------
 include/net/bond_3ad.h          |  2 --
 include/net/bonding.h           |  3 +++
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 184608bd8999..e58a1e0cadd2 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -88,8 +88,9 @@ static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
 static const u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
-static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
-	MULTICAST_LACPDU_ADDR;
+const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned = {
+	0x01, 0x80, 0xC2, 0x00, 0x00, 0x02
+};
 
 /* ================= main 802.3ad protocol functions ================== */
 static int ad_lacpdu_send(struct port *port);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5c2febe94428..faced8ae4edd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -865,12 +865,8 @@ static void bond_hw_addr_flush(struct net_device *bond_dev,
 	dev_uc_unsync(slave_dev, bond_dev);
 	dev_mc_unsync(slave_dev, bond_dev);
 
-	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-		/* del lacpdu mc addr from mc list */
-		u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
-		dev_mc_del(slave_dev, lacpdu_multicast);
-	}
+	if (BOND_MODE(bond) == BOND_MODE_8023AD)
+		dev_mc_del(slave_dev, lacpdu_mcast_addr);
 }
 
 /*--------------------------- Active slave change ---------------------------*/
@@ -2171,12 +2167,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		dev_uc_sync_multiple(slave_dev, bond_dev);
 		netif_addr_unlock_bh(bond_dev);
 
-		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-			/* add lacpdu mc addr to mc list */
-			u8 lacpdu_multicast[ETH_ALEN] = MULTICAST_LACPDU_ADDR;
-
-			dev_mc_add(slave_dev, lacpdu_multicast);
-		}
+		if (BOND_MODE(bond) == BOND_MODE_8023AD)
+			dev_mc_add(slave_dev, lacpdu_mcast_addr);
 	}
 
 	bond->slave_cnt++;
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index be2992e6de5d..a016f275cb01 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -15,8 +15,6 @@
 #define PKT_TYPE_LACPDU         cpu_to_be16(ETH_P_SLOW)
 #define AD_TIMER_INTERVAL       100 /*msec*/
 
-#define MULTICAST_LACPDU_ADDR    {0x01, 0x80, 0xC2, 0x00, 0x00, 0x02}
-
 #define AD_LACP_SLOW 0
 #define AD_LACP_FAST 1
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index afd606df149a..e999f851738b 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -786,6 +786,9 @@ extern struct rtnl_link_ops bond_link_ops;
 /* exported from bond_sysfs_slave.c */
 extern const struct sysfs_ops slave_sysfs_ops;
 
+/* exported from bond_3ad.c */
+extern const u8 lacpdu_mcast_addr[];
+
 static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	dev_core_stats_tx_dropped_inc(dev);
-- 
2.37.2

