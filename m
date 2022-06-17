Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9F54FF11
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383410AbiFQUhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382807AbiFQUfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:35:47 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B9A5F25B;
        Fri, 17 Jun 2022 13:34:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1wGcaXNGKWZxByN3dQZ3tlnbVt4mCWYnlOgiG96zEZo38dXRAuEtAwHHV6ndVZsLeKMRBT0CJZsjQc/t4fe+gPmldg+EXDqxa7nxLFUrWKbKELGWOx4F/vBof/CtfzZn9/D8D+V3OmUpvqZ6Gj6p9D/jPwU58Vr55Hw9UacgBl47uKvbaTMJeGFQ/5zya7wXvH0YSBqlm/lnwzol+RyZY3HdCywB2u3ONKg6W320odpThodLrALTuPnaJndaSyjcbvaaTCCvJ1V7W0K74OPRw5D7R5W0BicLrPkKnhUlIvG32doFNUaSaL4gnkFtl6VvjbHvd9kEU1q7cUSlfWm5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CADaDmRzmKOMdy31UT6TFsHjJE6WK1kWCCSE8NrVWmo=;
 b=lUY/937sbn4kiPn//Gt0JvMTQ7hjR6N2Et7Ma3uEQeciLS4uXcF2trFHG2DPmd6AAJqwvpM4oBrRVP1djpUo0eUmmpz1Ac29akINqQbb/wJVvAWG535vBxwmDQKeJAfdGMiTb1bPqLo7rJV0X8s1bTIKNjmio2Epep4xmgnzQ77krYsVfJMCCoBWv+wKvAnaV+OjLw4cuMcEFhSzJWbRpClk/1ceL+hIU1+5LxVMpUVC+UHQJFyzULg7LlPBcXKYXZtANw8KknS49//89dQ2CyfOwvB+ypcVI7PBWKy6WoRQ6bLY30VoplEsSwzamzHsn0ZVo2xfY0KV01XfpwLVhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CADaDmRzmKOMdy31UT6TFsHjJE6WK1kWCCSE8NrVWmo=;
 b=dqqayYS+DAuUUIzfL0WSVc7nDzVZt6bwmYPS6/6iYF817GIp4X+mxEFI/wn2bdk6ZPn8WTdKWw0V3n4TWQnDsq/Y5efidZXIeRjDSfje138w+pZwjWIXvxGx2l937/dtJQDjXy2eQINfnF+8DlgD6broxKdyAbCq4qe8yPyRP1xdSfjrudtXvUvj5qt/BDUFI9CkHgn/2Bk4wCvOjwsdwh9TxKWRVzxJhit2IRLyMNfj0nlNN06aHiYe9fg9GgbfdIADeA517/APOe0wJyhuGHfv1Kel5Ky+cRGUshKmB5xePJglIJyU+N7pBuusqzwNNlVGKfBW5eq1iWxRCvk6lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:17 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 22/28] net: fman: memac: Add serdes support
Date:   Fri, 17 Jun 2022 16:33:06 -0400
Message-Id: <20220617203312.3799646-23-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: f2d721bb-1c6c-458b-8289-08da50a0c041
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB68385B72334BBECC87658FB896AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFPUA0rzSgBchrganU6/BQWrFy9A9cxfDsvLrC6HqTpg7F2z3c0UoETlm7G5psEZxVGqx/NPtGdgu0i814W0WzTTtzlHkNiSgvfH4HXKSztUCie4zLUj3pEqORn7qZR0tgMHHLBk/hFKaHq8yUMucGk+2iIiI/XUOGB8uU7belhJjYJCgWVVZ0cqOkIoBQLVtezZlCcH0+vLVpYY1PbWC6/OT6o1jww8uwLEpb9p8Q+kxymRge2a21zFawIjFpJJEwI3efhvEOBswfAOZx8NfcuJt/9JhXo/eUz7s2Q17IWxfsgVcqTAGdAk8XVC1ZksP7umk5ORuf8coe9r3k0C00q+91m+5bthJQP0Cm7hiYcvN+cgMijX0Liyj7YoIL+6h6kIDVxO9Y68ZlZ5MRjoiD3YUwCrjGh3N1tARS2qcXgqyMflLQaGzdi8ZeiVBFM9CRpVMpfyZN1jd6Wtg5dWJcIrAaHnj8Xi4If5fcJXZyRY6vCQFh0rBtzZpbrDqXo6/AzmUuclKGtpdT+0qnHTGDplXr5iLus2LBcWlj27pQGrm0oiFlpOhuHDlK3Yubp9TQZD4F6ijr63FurPhBkQ1qo3md/5ItbftnDHPVSHwrOzFr1gOUbvEN/UtQhiOvrwJLm7zlKsga2jmingD8LxcskFS9tKo5GIyjxMha4lSdZokBypK7hFu0YfjhcFWCRcsbrvV+v5hk8EUAJUcdV4ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GiBal5al4nVzIYDG5jNIDZ/9vD0cprRqeDBRxklh3vwt+XIAIGaVchUTKDm3?=
 =?us-ascii?Q?zx8LyJ5nkNSJp3XmOhvH7tCM5d2d/LjrZYmisg3NdOBURLhdH8oJO6qih1fb?=
 =?us-ascii?Q?0jgaxbPttqgvTdsVjqTqHcYanZDlTDwIrD/2vY3wLz8mFDGLafdqbxWCCsra?=
 =?us-ascii?Q?ujSuvlEUhkvU9FPU7ggy22qhfO6YvvKWKPl9UkhvsxBARhaPFsXzDdhEjTeh?=
 =?us-ascii?Q?DUD/Ax8B6MzVZ6CF6tE2gUhRUC87NaaFkUbzYh44VevNvv96twYZbtulBZpg?=
 =?us-ascii?Q?U9C/W5QSiFUKnVV2j2IDc0hhNEWPEmp4oM2+94wmLK0QPJyJHV4PA3bvOQyT?=
 =?us-ascii?Q?tAIY1Uy7LS03yjiNXeZ1OBGBML9vkchEl596SpEtTZbt9WtACRVXn61SPj3C?=
 =?us-ascii?Q?fV5M/4v8IblEqijg4QQEWwNqqyHEIA3gurkWUmitlWeqhq4ED06Tp6ErJjvN?=
 =?us-ascii?Q?hcXC/yR2rKv/0kRaZIpPuKQgnMYBYkQlNSzL1jeiHktEh/yF2CISjdvOulMJ?=
 =?us-ascii?Q?2nuRvVQiFOS2hfk4rgJZDLD1t7y075NdG8hyHRVOxp/tr8OZ1jeYqgagL+7p?=
 =?us-ascii?Q?czyCjZzoQBLWfTu0P7NcsDAGV4MKaDjKKwY2tDNMaqcHzkIYlgjZ4S/GrJG2?=
 =?us-ascii?Q?qcvSuVMiITXN2CVaswj5lblviSBPdd2Y85apLWFqfZKYRD6FiCzq2dBhg2q4?=
 =?us-ascii?Q?FeOAJelAHEj0ZsuID355Dx7CxbXLre9AlSo9ntcr1+Xfvl0Pg6/biYoFM1hX?=
 =?us-ascii?Q?JOOFA2GHo7IGtFvNZhVH0sAtjvmX6+JENPQ81x40fDWjf8vZm1+SPZ34yLb8?=
 =?us-ascii?Q?ciJ/NQzTV6vVzYF1a6O0UzkNI9FSS7ZmLl52/DYrDgtlOsawIRXWcKWMedn3?=
 =?us-ascii?Q?0mvsRnjgiTKSdxAs+1BTJoP/eA+d9hefbUgscYo7iukU3cbYoTcC5oskP9CC?=
 =?us-ascii?Q?DRNzAa95DgBs6TlONPl0H7CgPUhpnsIg33qRGnB1T84sHMcyUpG1P2bZHXl3?=
 =?us-ascii?Q?Fyp+D9uGRiTIuPOiC4KsgtKPMqEvVpfn08M9jc3Bc4+diNm4dvP4MBnhFnoW?=
 =?us-ascii?Q?HCGpTFTTgaeszu83JkMNAjcMgxnQfmYdgVSq5dkF3b9Vxdure3MCP2TRCwwA?=
 =?us-ascii?Q?1tcAA7EI/E5fpanQY09pzAvDcSycpnryLB2qhYQColty9AzmsaHJq7K8iclp?=
 =?us-ascii?Q?ESvBZ3+pyVWV/H2OxECo6ww7G1w4h6zKEX3qUPNyATQac2a0QTEYZmUSoXm/?=
 =?us-ascii?Q?hD5KqfR4Hq/88BILTC8geRKxrE9eAiSpxjwEKUDL4YYhEfb3IklLbn/DHYsG?=
 =?us-ascii?Q?/XzPRGkFZU88y/LWWOOY81Vghwy7zhAnJfkrs2Y3ME4nQh+5cB/dTyDuS7Qg?=
 =?us-ascii?Q?dhKqNJHr6ZAiNi1BvH3A6M+Xr9qq8qDt7nvyrzluLHwpPeQyj0CatcEZQPsZ?=
 =?us-ascii?Q?zT1sf8OVXkwqNHAys7qIa53cQp4st6PzC10AA0LIG3yXARngiY79Y9e5N7/G?=
 =?us-ascii?Q?AUIob3n7N/OTtnwTQURyrDa9VszZJsB+9PbXJUoyaZQVybVt+WpU0RfQvFL3?=
 =?us-ascii?Q?cmLWjwj7uwYFU8rJM1VfqwkUXTaO6KNdij8oHJwGDx9ISr5sjvawo8AmKdTF?=
 =?us-ascii?Q?CKIsYvpkLfmUuSX4WlhvvutKOYA06ntOl2gHagHcvLzug4Y3/lrE3AC0z6Ow?=
 =?us-ascii?Q?f6bJi5QYTDUx3BiueDC+YOApuHOA2q29YbdKvORplvt8fkKp63qVMVefEreS?=
 =?us-ascii?Q?0D7xfCu+7Y+9ERIJN/O/snScmQNuUQM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d721bb-1c6c-458b-8289-08da50a0c041
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:17.8104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kadab4utTRs3nEB9e44iA2upMTMWKAgmT6xn/oQT2eYnnNC/UVA6S0PEy/wxQWmRLZ4hUlTxvQfwVBnQCXiiwg==
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

This adds support for using a serdes which has to be configured. This is
primarly in preparation for the next commit, which will then change the
serdes mode dynamically.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_memac.c  | 48 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 4d4c235d5dbc..5598a74ec559 100644
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
@@ -1206,17 +1208,55 @@ int memac_initialization(struct mac_device *mac_dev,
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
@@ -1245,6 +1285,10 @@ int memac_initialization(struct mac_device *mac_dev,
 
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

