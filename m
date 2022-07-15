Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAE1576997
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiGOWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiGOWEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:04:05 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698FF8E4F2;
        Fri, 15 Jul 2022 15:01:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC3TitUQ8zht/eKMa5kSjD2Wk9APjK4eOcMiXYbFX+5v7qsXxp5I3wL0NgOVUXzI17MnhspTWwjcIIIDMzNjBseVbli3tkUxrIineKlujL7Iz7u3VBf5utvFaqxT7uiqNkoyQtSLh929ISUKKUiy4zCoSH6GRzpbt2cZCEX7kleoO3cFL0lNQAMpWag819yJfkIVvz8AQcdpPQg3gY7NBN/XxUHeMyfjB86QuhRBUU65vFdKgYM8rcXebutzZE6tW4KNeDnY1ogWjprt+DafFb7kTESi50tNn8Pn2Hfs9RQ83QgX1nUL2zxedr4EOgWaPh1JrQhXS1UdPczfydPgMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBsoKb0IynL/exrsZCB8tm9m5z0+NmXhH9JcWpEJldM=;
 b=OtYGkWTGQUZ52g0+QLr4Oor5PQ06jA1qb2iSAznHeirZN32H41Y+wwC+WKPhTiZf/J0qydy5EfBt03+hmrrxthw5zlNzgpEKxL5ByovH6abF2ULzkWZsDbCS+8oG+PDVdgThgz3dJCR0PEa/dNawneola/1Vp8osZEPrCOvZy6Qb1Hm6NG1vzXKccsZEv24HgZnF4p+/ehn/OYJ8onLgT+UJuGjvZNGfJxfST+uq5rGP0FFYgdqNtuHG3UFhqXX/VvFXeLF+o4rYByAbi+RGJ56Bv8uwwVPvXbEIHI58niRPU9pZc2RZM7IaSup01E8y40tD/K/UEdV0pH2CWDRSNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBsoKb0IynL/exrsZCB8tm9m5z0+NmXhH9JcWpEJldM=;
 b=OL+CkyPcZJGrtt6trFcJHDe7Ujmkom//z6RPu4J/9ZuTZJJEfLRK3HZttdVlD+WYURrGLGw5BGgJRClTrj0SPEOAHuQnYuAG/aeDrIZ0HYziOykq/6usrR5FhBNIghammpjlRbaUG/RjFf23fn7K622yAxwC+L9g5TyWRw9ULcs7P5rhWkk2vnvmBn8mLNhAECXWHR9l7Std5nf+r+W6DJQgJ3/WL5x9yaJRIl6s/XIprZdMhDp4daFd6176+Pb6aaaq4vZJsvhLnYc460kaGJGb8bJw6m9EBlsaI0rZSbNKRgTsPuldWLpgm8DBOBq7XKBOXN+jF1dWX65T3K1QRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:41 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:41 +0000
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
Subject: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
Date:   Fri, 15 Jul 2022 17:59:46 -0400
Message-Id: <20220715215954.1449214-40-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4b9caab0-92a8-4540-bf88-08da66ad9912
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaZRFEVIEbr71eoJC0l/a8unx+azHlFCoOasWhBugxQMFcDtWzLpaafJ+EvY3a1W/y/ZI/uDuL4f8D4W25klhnEet4eU4fAUICkJw1doQhTel2mf4BaqrN3IJh5qyv1ccxZMeKYsnMi+KFcF53wTc3DvlA4YLnW1R7L4fujzyZkLbj61UW/w9KpqiQsKKyFZdVQuaTHl91krJdIhq1oeSxLuRj4WCk+7YjssnrTokxD0YjbF5sgb9unNOqvaxKc0Oa9V9Gk4Shat1BY72BLKNXIcynMPkrsOjYGDdAgMAQzKvx2Evb5/gU8wcLqq/F0HSKbAbx5UzOcR3eHh40rG7treqT3lLhjbttYoMKwKWo/cm/YqlvJ0KJX4eQf+T4Vrxdhqgbqv58UngXALBxI3w1St+a9zB39NJej2oH24Svm6xk0QWQOPOiEmaIQCgN08gDSVqSDHNCFGk+BB+u4ptge40wXCTA6TdIMRn6jw01snZpKTPknzgLNW7OgtWiiN89LcPV4wfJrmvlluVztc+ZBg7mBhZHA/2VOPiqeVKC2IuIGrt4wn2ZgdeHR7VfuR0s5la10N+pQdFgtyIS9VuCvzt7gay1YIp04M0oC1p9SCpVpc+1N14nmfMUmpihcVhsIXs7cMs2f5e9iy2KMgGDFBkxUWpWN13iEyKulBfGgGZubcrFLL2tIi+BUtlDvF+N8rMQBfCtPvlM80LTbY50NL5Pp26mqEM3B7PbdO29eRJsggh1Q3sDzoZI/yTqpuwwAdwlyEyvip2/azsO6C3fL0+VdPXsOHSsOJsd9nDHpkXQPlfYvExt9xw7syhtBb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(2906002)(6506007)(38350700002)(26005)(1076003)(107886003)(86362001)(110136005)(5660300002)(6512007)(66476007)(4326008)(8676002)(44832011)(66556008)(52116002)(83380400001)(8936002)(66946007)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vJd+Cifz5TWsOKggSQ1F+CWEPtT6xxwprsLitYH2BAd8U4CzHh1fF5VWPDt?=
 =?us-ascii?Q?v50eFuziV7sAbnYCqo7+GMFRFgzZwOgwATCgw+GG8bZHz639RjFqoqPbrd9J?=
 =?us-ascii?Q?iiTdZGCAgOOQ6KmM1GQnsvwKeedSQy2XqLglLfTn6x2RnopaBsgv7/jj0vKs?=
 =?us-ascii?Q?BJX2f2Ny9n7FRJ5WK4OpJJX/Is9XkxKwOWuiZ19oF0k0cL8nwn7m31ktxscx?=
 =?us-ascii?Q?G9R3QpQdyonlAugU/uOk8oq2bpNNqWs2fkqm30t5vy8UHh8xjdg5ElfqDWnU?=
 =?us-ascii?Q?gx2jrJh6uXQvM+cE9u6JWKYOmdcS3BC1imiCUbj4E4AX4v6q11Q7xkd3Spto?=
 =?us-ascii?Q?zsQf1FmTJIydzlX3HM96OvXdo/1kdpT2a6bs2S4JABNx87cQW2tWyA7Ce1mi?=
 =?us-ascii?Q?BGOP5Jfg+c2gW5MPcpXuoDuYqtBJPNDPXvLNG9i01eNEQ47eNQFCwPCILBng?=
 =?us-ascii?Q?pi9KpzPfJucC1wfYC9Qwf8iwxC6+/lev1lGKKXTD5VQbyI5At7SE0Dmv0LJF?=
 =?us-ascii?Q?5Qds4oKEGNqjPnfINAWOAftk46Uh0roKBk6vr2fRegw5BfNgFTVutUxlguC2?=
 =?us-ascii?Q?Oh9DhGV1dUbThVLzIJNMqZNR6boRcNOLQ+LDRMPo3iH2Pay+pEEFZ02J2jFR?=
 =?us-ascii?Q?0jc86v0o+bNG7GR/Oz6U66LcyABQkdvzCUG5r4weeX6qvbotJTX/iLInr7Ke?=
 =?us-ascii?Q?stSY7Z1WTNU4qUnHXDb2HHDNRRse36JbUIQFhOqck3oTPTyPBOWVbJ4g+V7i?=
 =?us-ascii?Q?77kXD4Gahbbu2oymySSOz2dbbJN8cFaZ0I4z0Yxkvzm/50tgQmOVT8cEx72V?=
 =?us-ascii?Q?E2FPzbrs6CCsKKttb0gzLhW+RTGND1d2m4jeOB/z6vtEUNBlB8a8XUIJZ63U?=
 =?us-ascii?Q?/BmPrd0VDouJpMiwEN/bDmdHp/yMCf7IIUSuzHpmt/fwIKy3EAxHXi9dq1y0?=
 =?us-ascii?Q?PhnDGucH04afmNeXG8B/av7NSC0JrX0mYRL29zsRZk4O4eIBiEtgxv2aic6X?=
 =?us-ascii?Q?hyWRKWNZ2xMgdNBYb6E/fQN6mxV1VTxuO3FeXWdjFBeOJdJV0dwDHJ4/5Wb+?=
 =?us-ascii?Q?UvDQCFxQJRzIJOyhT5u4hp9TJphrGwmZtExdrd8q2YKWxEScXjOpChWItwxQ?=
 =?us-ascii?Q?ZR/sv3ec1JhvaeufHQo6yrFmVWlC+pwK4SkIz7Asvz3WKwEpdGpl3Xdn9vaO?=
 =?us-ascii?Q?p2WQ/10LAjdtJG2J65l/3/VIRmkv3gllJ7KRN6InV9p+4sUjT0d87SCjtESN?=
 =?us-ascii?Q?Ff7peSLp/3d94uoFU6IX/GM54S4S8AznTruS+Xj3K4wjBWTXktR5kfBCEXKi?=
 =?us-ascii?Q?TIkx31v0KijMEE6iAQaleFoQciizZMq6HX6Y17mE4u19V78rALlfwCXkmZMU?=
 =?us-ascii?Q?bV+GRphy8sgpODMtl4oDZM+RBHhbxKCurn5AzT9lyl+E4wryCRcaT7avcmgq?=
 =?us-ascii?Q?TqjQlVTBZkATaZDJ3Gc4TBv5/574kThH7T7nen9HS79A95x+Ldive1heiZsV?=
 =?us-ascii?Q?o7if7hH6f8jggZ8+uCt0lYrkmPi2AsX/aCD/628A3kCTGkZPq8Tk9YY9vR7P?=
 =?us-ascii?Q?fQDflQ2BhIUFcuKUzz1rZ4Bn9SARh6VPvy1CWnToIIBvwLSgL+eBI/VPG2o1?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9caab0-92a8-4540-bf88-08da66ad9912
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:41.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: la6Km+ZNriU/8ch3qWVKrSdycvl36Nd25KBtB+WI/7vCMq03EWzjK7O9Mi18nV1i1G0xmWfOZGvbl5GIUH0GFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for using a serdes which has to be configured. This is
primarly in preparation for the next commit, which will then change the
serdes mode dynamically.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_memac.c  | 48 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 02b3a0a2d5d1..a62fe860b1d0 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
+#include <linux/phy/phy.h>
 #include <linux/of_mdio.h>
 
 /* PCS registers */
@@ -324,6 +325,7 @@ struct fman_mac {
 	void *fm;
 	struct fman_rev_info fm_rev_info;
 	bool basex_if;
+	struct phy *serdes;
 	struct phy_device *pcsphy;
 	bool allmulti_enabled;
 };
@@ -1203,17 +1205,55 @@ int memac_initialization(struct mac_device *mac_dev,
 		}
 	}
 
+	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
+	if (PTR_ERR(memac->serdes) == -ENODEV) {
+		memac->serdes = NULL;
+	} else if (IS_ERR(memac->serdes)) {
+		err = PTR_ERR(memac->serdes);
+		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
+		goto _return_fm_mac_free;
+	} else {
+		err = phy_init(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not initialize serdes\n");
+			goto _return_fm_mac_free;
+		}
+
+		err = phy_power_on(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not power on serdes\n");
+			goto _return_phy_exit;
+		}
+
+		if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_1000BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_2500BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_QSGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_XGMII) {
+			err = phy_set_mode_ext(memac->serdes, PHY_MODE_ETHERNET,
+					       memac->phy_if);
+			if (err) {
+				dev_err_probe(mac_dev->dev, err,
+					      "could not set serdes mode to %s\n",
+					      phy_modes(memac->phy_if));
+				goto _return_phy_power_off;
+			}
+		}
+	}
+
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
 
 		err = of_phy_register_fixed_link(mac_node);
 		if (err)
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 
 		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
 		if (!fixed_link) {
 			err = -ENOMEM;
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 		}
 
 		mac_dev->phy_node = of_node_get(mac_node);
@@ -1242,6 +1282,10 @@ int memac_initialization(struct mac_device *mac_dev,
 
 	goto _return;
 
+_return_phy_power_off:
+	phy_power_off(memac->serdes);
+_return_phy_exit:
+	phy_exit(memac->serdes);
 _return_fixed_link_free:
 	kfree(fixed_link);
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty

