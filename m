Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509B441DA4C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351147AbhI3Mz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:55:26 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:41377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351127AbhI3Mz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewI1dlRYBeNNeDKS1ihdet43NloJXwrPJ2FC7aW02rU3FOlGPKHnLeqAsbPdQP3XDIG5izmxaq0y5WTFZ2yCPF1gCLEbIVJcK/PAdajiDIDI2SaulT0Z8KA+Xjcp3L+1fjX/Gvw7zjp4u9BkTdFeyOUQ5Aemz/RfyAbu33JdoHWOo2/8ZAp8sDLsw0IjmdSiqk6YzHPK2IVePvxhJxEHBUF2KAoyk7Q898lN9OP0pTlgd8fod4IztCSsYTTTRDmRikrP3tZVLylqktOzt7hUtaSyty2yFTIIFu7KIALhL+AGENSd/oJCoA46l/ZOrfufH0c4QFlHXvDpxNc0PqBfaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fNMhB6b+l2OaPIWY3wmURBUi5HiS3bCDW6j1n9utfSs=;
 b=YOkZmY39uFTFAtAt6RjYmm6nL3ufkb42USbCiiv86FDclA8y6Rf3pY5xLOc4LhSioQsbQrI6FYe9PurS2+dNPaaFGVJ4c2k0ZiN0oue8CW7/S/1hjHlmqgEw1RoYLAUcd3b9M7TK5dvUV2vofIZjj2HM2/cQNV6p3LpyarurnFaNUg+sC7pxNYD3us6H4c1m1wCVj1LtUO/IcctsnKStOEAEuE7R37SluLRRcLGnntvVJAcoM8YPmfd8K82lm0Jog2u5PDJZw6FRRkKkbo7eSdFdxOBnMmIuGOp3A+ZQFs8DV3tAFd+yqS6zQGicha2nwSLr5beyvZRqFvr3Brms3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNMhB6b+l2OaPIWY3wmURBUi5HiS3bCDW6j1n9utfSs=;
 b=VNxZMkSNAEHbMAYLKhfS5COLf8XmivN+oM2DB9H54VkPPfyIQyN82qvVRbzeOEodWcBqXn7o1RVH8yBLVCGxhTEMeLarsRBeNa3C8UiuoO2jIvv6wiXo1wephRn93mRRdeGXoNEZI6GKL9iyG0Oy+QzJlUIWJi+U5L5/SJxYaxA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 12:53:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 12:53:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net] net: mscc: ocelot: fix VCAP filters remaining active after being deleted
Date:   Thu, 30 Sep 2021 15:53:30 +0300
Message-Id: <20210930125330.2078625-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:207:1::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0086.eurprd05.prod.outlook.com (2603:10a6:207:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 12:53:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9043c0dc-91e2-4a32-367b-08d98411542a
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23018AE4EF0C442DC46876A9E0AA9@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BL7dUNXxy2oc1+0y8MHBj6HTUpcARtHV15/nfnliQ0y1ftu9vw99E3Uv3X3msZ9CBM7QGYX8RqZiQK8U9zJA/4qeWGYYxYVlAcFq7ykbeIlZcmUzDelmeVG0aJxPhlOwDJr68pNjUxywXSOUnQwMhRB8oVwVQF2n0CxcLy8/pMFG1ZMF+U3eKa6DxYOTNfD+dHAJrRfhWLm83qxrBnh0lzZpXjBJmZSwNSYXaHvZ9mqLuPIwGbIhOw1yY/3hM+hBwUcWjNdjuVWkNIrzjKN8YuSKTZmkjvDiQyD5KDEMMsdeDwZi9XGyaVj/bEKMYUNWrab/qijs3A6dsTPHhKMeXNMgo9+g/qFUlohmqWMAVRm3vYRlJtLFgW6h9xlzR6p7182QOdSS+Cl/tqwayV02wkUVmoY1x/79mjoZG4Tn61BcHy/79pFPS6uAMtHGVBy5i7rBJesKK/t7jdXYvq4nI8tW8JGV9cjcci3kv9UCmd/8q+6qZAtGsdSpjFH4QdgWVt4H0tPC1Qbw7aS2e35KngbyVPin6y1ARLfpFfgOHZBJEcU9V0V9DBH8KZ8Ti1qJavrnjW0F8s8oaDqGvEe85lk6iCg/Kw5PCVw9MKvXTPL8xwgt0KBsVv9wOuMSWVsOpX7tIcDhpraFs2SuVxcO92jgCBtp82MbEk8kRa7SUM64Zj+uh+SOcrphmmaDcK1KCeIRBJp9cQxL+B2rsUzV1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(52116002)(6506007)(26005)(4326008)(66946007)(2906002)(8936002)(6666004)(38350700002)(38100700002)(36756003)(54906003)(6512007)(6486002)(1076003)(83380400001)(44832011)(186003)(8676002)(316002)(956004)(2616005)(5660300002)(86362001)(110136005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?890IQZKB3D1rQ/TR5YQ8svOi6BmkS5owk9QzbR3G0AWJ7dP+2F8T2ihVy0U/?=
 =?us-ascii?Q?EgOZFZ1V4SwA3avLj5iJghmGliSCuaiBJ+l1ek1Q/uUnC2PfHDUeU5wvlwbb?=
 =?us-ascii?Q?iCBlYhwUXVGMauberFsrP4IwGc1mo9uHcOGhWEmu01IDPe/UI1yjMGobB1Q1?=
 =?us-ascii?Q?W2EUn8rLjJbrpy4LPnV/i2ndrhXKpZuTWsMYUO6YEyWgPvicvSKpSqwO5Bjz?=
 =?us-ascii?Q?CAfPrzA1/1WektF+IDZEuleuBQixekzGUFqR520IAt3w95/IVZMBS4q/7XUz?=
 =?us-ascii?Q?8dkJW/T/3R8pqS23k4g9IRTqWcusSRgiuTf9KwZ8VUVxJRDQMuBBgxVojjUf?=
 =?us-ascii?Q?4iI79K3zExFm5RtdgmWdaG3uds9UhOl9L15Fgbhpl3G/QnvK1CXcleZRbaA3?=
 =?us-ascii?Q?4gQ4A4AnPMiuIsr9rLObKZLX/SvWiOi1JY54qsKxDu1LvUnjk9CMZWc8oo33?=
 =?us-ascii?Q?QUB3vILiX0WiYXvyz3DLHSD0YB0X9wA1uZc4THIunpBnm49ohEQAduIzJWUT?=
 =?us-ascii?Q?sP2co5WDxV/8ELjejOZY23L4CYIRFr9r878iim7IosykSrIiIp1F7orTxeo4?=
 =?us-ascii?Q?7JW4Q9WFJWXinUBdGYwOzghqtjzT0sQMlfHUIwQyuHbSej9dD86xZnYxDVyx?=
 =?us-ascii?Q?eL/3dB60MCVZIPYlnq1DiuOspNDerlPnRjELJNY9UOHkG/KT4b4OhgZ1IyeV?=
 =?us-ascii?Q?xcQyrpFdOdFvGy7aIxLrH3wg0q48aNu9bv7b6/QbFVkDc3JPngXOPJE21zCX?=
 =?us-ascii?Q?GlK5lqz/Y+2Zwpzdzewo0bhdeWRggxmUFJjUJNltx8qV5Lx2R+uwzNmEkxQO?=
 =?us-ascii?Q?qVRAdIYpDBclFqZv8NXwmQ57drn5kUifoFMrtJcjzNjDg5sNmhYgm7GOWobZ?=
 =?us-ascii?Q?gnq9jmXw2SYdy/UTYHyPtKaLjzafKPKowGt0VW/xplLu5lXTrcCBDRHj89eV?=
 =?us-ascii?Q?9eqgg1ZkQPRKB5kgWZJv5F5cTkZsw1MF0bKF9OVThWWy25S7tp0m+DadJYdL?=
 =?us-ascii?Q?p2rziLSl1A8k+6/qtsEVhVE14TMPmgIJ8lxmTB+TeTG9LrkGwP8le7J1NIpx?=
 =?us-ascii?Q?7J5H6HRFjIWnWE4DWget/L7oP6DuxxbNurNRmUaHUxisppHHy3usss2bmZ0Y?=
 =?us-ascii?Q?BEo72KkY+FjGwa2vOO6g/oWgALcHkJjYBWQC2CI3GUme55TNfgBL/zHwt1aG?=
 =?us-ascii?Q?xOf5FiES31msCqPbPb43DmqBCVPs9x9OzeUyE3PZLF85m4/P+u+xP8ri0d9f?=
 =?us-ascii?Q?FqjUDu6muNZvuw3tr9qoP2fihtjzlpvAroBqHE/JfeLKR0d7FIQtAqmlS88/?=
 =?us-ascii?Q?NHW5b7j4yWYFnyGRyigIlenc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9043c0dc-91e2-4a32-367b-08d98411542a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 12:53:41.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvQoAF7tiK8t/fz7nzaxT5yWkAZSOq6zo5se3Yr+Puaz3PrOjXZ7jzlrmuPhE/bW9z16DNqCkWGHHrLYWopvjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ocelot_flower.c calls ocelot_vcap_filter_add(), the filter has a
given filter->id.cookie. This filter is added to the block->rules list.

However, when ocelot_flower.c calls ocelot_vcap_block_find_filter_by_id()
which passes the cookie as argument, the filter is never found by
filter->id.cookie when searching through the block->rules list.

This is unsurprising, since the filter->id.cookie is an unsigned long,
but the cookie argument provided to ocelot_vcap_block_find_filter_by_id()
is a signed int, and the comparison fails.

Fixes: 50c6cc5b9283 ("net: mscc: ocelot: store a namespaced VCAP filter ID")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++--
 include/soc/mscc/ocelot_vcap.h          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 7945393a0655..99d7376a70a7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -998,8 +998,8 @@ ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
 }
 
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
-				    bool tc_offload)
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
+				    unsigned long cookie, bool tc_offload)
 {
 	struct ocelot_vcap_filter *filter;
 
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 285deaf68307..7ee3dedfcb6c 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -699,7 +699,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
-				    bool tc_offload);
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
+				    unsigned long cookie, bool tc_offload);
 
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

