Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9702C55F121
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiF1WRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiF1WQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:16:00 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F43AA7B;
        Tue, 28 Jun 2022 15:15:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWVCQVUTpQophqPI3M3SZRHVE41HaHdSHqclP6M6yiZDKXzof1/eR+qLCvLtcZaonWewzKin1/qiF/w41WDC4+moIGUshyVDbRxK8IjMjRt3Gcih3xnZ0qgYQPVUGdrmcMmp1+aDyasWrS6o1X2ZSVPVpiI3jkjk8FauPY1NMsjmJ4PKqhvNmqW/CIhguRCGj3o55vkBnA8MNfy23++YTU5OyFFNEGVTA19baS9tVASdqnnMk1ZoyDzyFSLmiHxOuMVJt2SBTpFTsH/4VYBmql+LcROvylUxp1VG8HiChxWZFYhV2eCe4k9UeNCXMH9glxptXhQU2jmcbsZX42zJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBsoKb0IynL/exrsZCB8tm9m5z0+NmXhH9JcWpEJldM=;
 b=fkDyi9NzIL9V7/DainpbjxB2DkWAWZjaKIIWlregRh4dc8EjuTCfMdKbnnRTf6D4xMHbbtU5wOBf5EdFLeRdZ1r/pKijDJQa0hbqnT4dPKV1IvA2og0vz0G7tEU0g4V6n0kwIyOSE7acgFwjA4OSdf/AUUJ00qfiXIG0N/yUaDaQ1G9FMMDWl7ULu/U/Ph6BHGmqaP3KfEXr0iBdBOqCZRlV3JHsEv6xGCAFWT4XVQlvCIFlb8kYw6pB2bMM7o+cCYcPF2SP4PoTtwA6lc7ZHuBU6IaMkpVb5CmYY/oDJUgQ2Gxc/QLHKu5yZaTpH3mbnpqNMN5i+jxsN8puL3q8Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBsoKb0IynL/exrsZCB8tm9m5z0+NmXhH9JcWpEJldM=;
 b=DT+2sS+lDm/1XHjaH0szXIbqy8A34G+m6aXhp0OfCjO58YWiJ3NBvQoC0j6/gFhI+ingYFzMBRjn7w7DfgWyfvuFf/kGbd6zTJvOI4ICMEtfX96GNzB/+CUfk+cbF2BlBMbh1lToMa1Ju7dyiUK3tUf2t+XcsOLtgJ05VHrn4iR43yp3O533v5GdVvjaLhbMABXKKt3Z/nuyu2nw+2twUOXz5Ca03gaKySCWzRABjkDLCLdjXt6Ypx03IJOupxInxbs4NqTIfIPUL87yU1cywSyMwIGGcEWGtQziU0utyZnCLExMQS9phLFmmtUNyPlZNyZ0FIST9KeAvdLUiAHRqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:04 +0000
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
Subject: [PATCH net-next v2 29/35] net: fman: memac: Add serdes support
Date:   Tue, 28 Jun 2022 18:13:58 -0400
Message-Id: <20220628221404.1444200-30-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1d293c41-9e97-48cf-78e8-08da5953a6c4
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPBzgbUnmAgRsxNUulW8M+x4ZiCW/ZmmqdBgx1tF3IqM1ARzTTUJUInedb/3FIKTR1M9uGvVxuGb2ujY4NV+Wueft3mTGvbCMOLGisLPdUQ0HPYCgSlnnWkH/O/0WYLKL0NYR9W0g8MAk4Ovxa5YNQ3R4D3YkzO3fGxoeMAog3yyWLysB2XM6ma0NcB2gtNwTB4OPgfQPpqOBqeJ7HNTQGLGMgfGCxL6j4Lek54MgXs/nH97sFv2gg5ruP8kP93rskcEsqQ8B1/L2gbgqz6JJQ/n5uLPp1e/kI1OcRh0Xgb4F99dc1G+ZXbgyl4pVvAiI/9SOAbFID/2RisnhJBHI2L/egVkEcEyTim1qVeMyOTM8nZmM15k+ClQZWqFvxMLXHi3d70zMF/pn5pMK5gDAb/XfSWxA1RCMXVKOFskHyfJ0u7EY78nV6osRHW9LGQGRfI3kZl3BRUjKQOSX9foTm1Ra1t13TZ5YNGYTfHAs+YeP+jK31gpba/Rf03dGJ7l5nmKaNILM1//++YcBmvlhQZO2hV7yHAiZPX4fk03kkuDxQidWK5HqbvBiewzqIGI99DdPAv9SpV+GMPP0pzKWWpuuwltdJ9dJr9ZondrBN+HfdcaKWshQ5tULkMJ/C/pu+ysIQ0OE87hOQqUcp9tWCAbxLyCepEcxkrhZ+n8Sifai4CNUoAbAT/7bCpxSAbTGZFl2SyJJop5H3KZ7U0P12tl/aiQYwnLjh5mQgAQDzI6sy9I8+4muaAhCI8pWRJS69Jx5/0rCEm6/fs0kqMBENYpux3mF47//mkM1TBtqf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qTvr+DLqDdGvAV+o1aSzj4d1g7hkVVtOIv4zMJU8u63BmWy0kDRoe4YqVAJE?=
 =?us-ascii?Q?wxO9jocb7BZK972gtlr/WlJin1j1b45qMbIoDktUMAIzBAHaO9hxPf7PhWC0?=
 =?us-ascii?Q?JdXUVwU4Q4Si37j1TZKQmN4m9qCGpwWu3jX5J/D6NY0/KFu8P4i0isHXZFwO?=
 =?us-ascii?Q?VbPEud7q2n1RL+u2uVjC0NhPAVWyBpZsJCxteWBgGO/TdiLOylCPTtlwKV9x?=
 =?us-ascii?Q?CSoRrfUWgVeKi1RupB9kJiwl+ccB7jxFThj0ibgtqfstilDTLDQkZIhQ1TnD?=
 =?us-ascii?Q?6sDEK/akjobzeBO+lgkZO1EJ7lBdr5HFAn9NPkEQ52GneSKIjoEUKtgZz8Nr?=
 =?us-ascii?Q?dYD2RIbsMG9Yd1mwK1vbH9XUKHgGozMwVsx53DB/vxMM/SRIkPvEinqnyzao?=
 =?us-ascii?Q?Iu1r5GBDuCZoc9612rl9sfjmYATxnQL+85Vo3IZbxNl0DhYr6JxyMAc/xiAy?=
 =?us-ascii?Q?hh3QxKVmjCHTYdL/pHeqRln9+k9WQPMgKfsV5nksaho1Nw7049ye/EMLEhSf?=
 =?us-ascii?Q?DtZc5A2+bMbjW+hHky5YZJ8NNtX+KOWo/+mFAXYT3o+eHfMD8qfv1/gue83F?=
 =?us-ascii?Q?M5Rye6tazfEg5db7DE2tSVVcjUpPapMaQYLKziBN44FvbTly4a8WDXvWTOCU?=
 =?us-ascii?Q?b22ZCalr3ww5JunwnTGIMlqqKEfbIQYYuR3RNtCYDms1BLBmOKC8hpXwDDxF?=
 =?us-ascii?Q?DnYwH1b6azQDa4R7vaINeQmXdT3sHaM0OA0SesPEZjqGzKVyZMxxVzFUkbSb?=
 =?us-ascii?Q?7rjeGqeHi+jyhLtr6CsXiB1tS3VtGEwodYHkFsS/dv0wJJV+pHIotIGhgKzS?=
 =?us-ascii?Q?zKVUZpAejGiWWD0MkJm9Qlh80Urs/NCVaUAC5vgtMWyhwx/KkFzP7r2BFEr2?=
 =?us-ascii?Q?t2PUQQ6JVPelQ/0jjcIcOAGtO7uhdvCFpDNuKYcyOXAkxE7+0gIqPiPj5oPc?=
 =?us-ascii?Q?/8U6iqCW5y1365pMKSm1jRZFfPR7w/IJ7sjoMFF93kC7lfuz1Vha5sd3Scbe?=
 =?us-ascii?Q?/LPQml91S9cVmtjwJyyklU8r90QiWFtyyZNyRFBoii3PzWkqq/+VFwtyAQNB?=
 =?us-ascii?Q?GGYuf+9f+i+zxmTwfExUkXqvPXdqUExBx2dtiLNoCwF4olF0ATh7evqBJAoY?=
 =?us-ascii?Q?p4UaYtW/e+qwF+RoZfj11djIesAD5uactnPK1+uJSn6461qHZz5ZF6OROUWK?=
 =?us-ascii?Q?qFo9NC+5P3V6zWNwCSgB5l5j0FyXD6641O3jaOizlB+zzdrCYrRE2B6E/gTE?=
 =?us-ascii?Q?UL+GFlSC7TcfTTybadi8pTYNWcr/MvABurpYrKQptJRciByXJ2V069kmp4AP?=
 =?us-ascii?Q?YOODcHbsmiyRW8xHsVUYjG3RXPYSbZPPn56l2B8NnSJsO+h3v8PHoZGPIp0D?=
 =?us-ascii?Q?lsrQcNUPEGzpj+2KOE38aWRlG9Dm8XK0afmZln32nAdqSp3UBGoB/FLGkABR?=
 =?us-ascii?Q?w+w6o1EEUYnwVGE5yYwzl/4XoImlSmnlhdhemyAaC9AytGXKiHCrNXxyObFf?=
 =?us-ascii?Q?UNoPptrknU1Chane3rNSey1M57lHzSYXznSEFzEymGLsORQQ1y0gE6MSUXex?=
 =?us-ascii?Q?T55b4kxX0XS8h2kh6N+7lR4hI+KAkk8jApRiriS1MPrkRSBr5/4dIdmhsuvs?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d293c41-9e97-48cf-78e8-08da5953a6c4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:04.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEg93hbFAdIHkoFzpFtzbAYW8oKkmDCXMaLa+VPc326qWWtYca7BQZI6dYL1StMHg9DFeG22y6Qymv0K2ifcMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
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

