Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184E7580206
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiGYPi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiGYPiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:38:19 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9847DF19;
        Mon, 25 Jul 2022 08:37:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkmKrUGJbZ5CQCyNiGPr0zkkzkQZ6od+t/oYp2yzCMOV82GEk7RU4cNoVuMcxrtGk5uerlRhkb1Sn5Dl6vpPtdeNAUbEYvLceVfysMTBCi3a0+qP4zShuX9RIWgTA1gUmbqtuz2Dkh8DR+emB9htSVpEnyI0nhxcBtTgSM0XjIxF8VAJZAr9ovrzqJg6aO6slGZhhm5FvoCE3tCdHj2x3SJEdTYiVAKRtrlLp+pXAAcPR2IMNP9aodQRROZ7pyOKL9mQ45Pb62iTj1X4AL9JHhrgGW8ev8mXwypcmwffO+YZqJRopFboeZLviHF3kgt07yP+M+4hN9+YXSJZTpQAUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJJthOtyxIDSRQwHcJqYcFt6y2UWA3fLQwokTwJIp/k=;
 b=G6btngqhuMvDvu24lfGU7qZ2u8U/RoF/h6qL0sh+4r8nVYxJXu47pWrpGKJi4uT2oiWUKmNY6uGaCQ1CI9WFxDVn2pwR2RDxk+uLhirqDhXCHrDOFgn+4QWBlhLOMKqnZtVJ1URLo2CsUY9rRXmoMbU5TcWN8q4PPPkBKr5RtHWEsPLxevVKVW3Ed7Vt+g96l6HA9AeexG0AWqP2aF0bxFZ2TeKLNGEdAnkPQS5GqbOXYoIEuVnuFLkBrxLtboxgJONDrg84WJnw3Fr9Nj7hFGdaRD7/lRBjthLlK/B1TUqINrPJFkzvgAGD8/OwrmKjdyi5R/xQKimwrzmdcPfCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJJthOtyxIDSRQwHcJqYcFt6y2UWA3fLQwokTwJIp/k=;
 b=dVZjyrAmbT0QImJvyItgjZrDKRgfsgKB2ktTkugqA4mS2GAY3HrSE9VQ8UDkDgYhLJ5FzdsAJITJ9d5NS7/k6s4SYPY1qSVHM4fDGDhL+30daONpY5MggtRPAqI3nSs38wpFisOpsn3DMsIawFRb9JKpQ50hgpuwIbWFwY4vt9zNYDtl3ozL7VzNYQiEY6WXIwD6PuBsNPQc8SurjTFkydS55HbeNoG13yc/cSnqgSOS1WfERh0wC3Sbb5B5ptT3KQQZJxLyK52Nj+KkOpxBQS6dWDGEdQ7leSNpNhMAdYoYuxr14sKIDoZ6JTfZ8tl0oJ3vaUYyktPNpIBNkkp+lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:37:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 06/11] net: phylink: Add some helpers for working with mac caps
Date:   Mon, 25 Jul 2022 11:37:24 -0400
Message-Id: <20220725153730.2604096-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ad3429f-b6a6-48d1-6a18-08da6e53a303
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEjBwc1vEfSzi+Tqw3SuejjWSStHtlwpDM1ZpiFzud0N2qxAQ86bUCEXFFpBBFhwW3ITXUQnEPbKOYCT8M9AJMqw6EeD4w1foYrVxOIzZhuALqjyDKGG5dmJdQ2/eKucRq7KCZ9nv2lwhEn/taxA+Z3oL9eXAOEceBLnk7HJaihZ4zWZgNV5TyjY7EBTt4oYChIm0casei8zMlLGCTCXxenqMzBI/H5ITdNaVB85vS2dZQ1NmXIzEGH3JtHd3AUpQGedStyuWBNtaO5fZrC34wlJ4c2uYbjoPO2ZvIuMyo1LJupNzEmPJz3UFWaJEOcKKUfjRRypPjPxdMDmyClniIugulE+IB9SilCa/QG5gJIG2/2AC9oD5Cww+KFOI+JvB4WBLvm7ZnIHVpEh19onbNycrfC/3DtfF8IsfKAXn3tOzEFMCw+pikpwSYcnmxI+Jy1hky27oxtVzFjISF63gYij9ugV9mi2ytkd0B8pfZRU0XGkIPSQuKHnEu/45Bw8UIgeCi3F8s5VJKfkt505vKiKSU1Q6+wAqVyHHnmQ0vnYlqDLEphyHjqQSWGWpJ9Doc0wzz48mK0m0jkg4DhwQUVdLvt4jpvIwK2nuuGgXgQTL8/0C5jy05IH42fi16lzLZsGxDz/h4RTQphzjrRrAUwT+pEBR85EkMzhMF1oErDp03LWf4G0Kd94OxdtAJWvpSJ+l3+fenwcmGkL3ou0M0HQECVIv0YQOYMUWJ8UrzinCVCk/hXkWfQLOTPTZw6QizBzVknD7CdL3lm8qon3WhZUhp1JgfDKN3/nmE4kXvxiOdzymXgHw0jzRQvwksyMFiflqgsnHYq5NrKXqQiatA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(966005)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PkGur22vc0Pj4ZjDea2ASdl1MfzOnNJEV9efubt90LQCXo3jiVhka69yPiRJ?=
 =?us-ascii?Q?85E9cm6Fd0arflFZ9ZZng1odKA6jfNCGbOazwPM4lHqGtKS3w61pg04Y7Xgi?=
 =?us-ascii?Q?FXk1fTCY6sruaB+3fs1qbZYqRrtmxA/eiv6SDXE2c9z7xMFtN0BIy2HAUNSG?=
 =?us-ascii?Q?MFI57+6vNvSOSytyWIzo5ADT12a7gJf6V0CD/sBWNMwGZnBIZn2QiDFNINZL?=
 =?us-ascii?Q?lSDh7klyjSruIxSEqmVcEhlKULUsJGFxqavC7OiQz246BLexbD2pVbocPYCs?=
 =?us-ascii?Q?JXKFARjDs2DLdfRCgSD90zxu/JCdNuF7fxk0x/P4l+rXfQ3ulq8tK5MztgCQ?=
 =?us-ascii?Q?A9Eg/1/BBYJjw3WLKJZ92KZ+tsEleggK/XAoFLEsZ+7gksgazcrYu8Fg9U4g?=
 =?us-ascii?Q?joqsaWfRou9cn2dBAwsFW6WoMA+Pf1EUwFZJjsd8JmdDDY8rFYQ9kK4iOccL?=
 =?us-ascii?Q?P7mJ9Fs1DHDJkI3xuLUBR+tqAhWAlTenerBxoW2lcbM83AsaS/hqPfFJWAIr?=
 =?us-ascii?Q?myASzOZ3ZXTu1vvz4W68XQGFr+HfZvZhtC1JiLRx7srsWBJ99WgrXiV45k/8?=
 =?us-ascii?Q?WhSKsdHYg923quzMtp8mzKCuXuHDL/FaklEFLkAiEURK+R/9evv3v4wLk1Rm?=
 =?us-ascii?Q?qQMP2+qIcPwTzMFdfIl1y23NVFI4tP3IVwKkRtqyQIXw5qFOI4UXct0tMF25?=
 =?us-ascii?Q?HCFrISbQVDjgDnknegjlWcmfMZperN07DP/uVo85Ys7gdVXzy2q3b+dfEv1w?=
 =?us-ascii?Q?IkNDCtFFTEXkmgrsWgSQowMrQFNhf8JP3BkPiS/0dYOjkAOs19yyt/ZtyvzV?=
 =?us-ascii?Q?W9HGmU24QiRE0DI+sKGCg3JRxLMCbiEP+0NVCuqbw2kgKu9Y38IGET4PbVw0?=
 =?us-ascii?Q?u8aBps4ExPGnz/ed0wgEodT2WRqz3cI1uQxXi1Ye+aLvOOrLjF8oR9SGhfF+?=
 =?us-ascii?Q?c+cYVO4pyf5BL1k8MsPuKdPGLfwUUhaz6Jzm0aSNwVWZu3+iJmn/VOwD/VMD?=
 =?us-ascii?Q?uNFT2v27AaZvXtQv3GdN6onsKXEF+H96s9699XErW1+2+BlGoaTuclu7rGFg?=
 =?us-ascii?Q?vKBCD7JToN0nZN5SUwf+FI9IGEY6Bck0uGdJueUvgHFzaq7K6L3j3rAurKW2?=
 =?us-ascii?Q?nwY0a/o+6+xZRNDaQBK4I74c8UuPoRP+Zz/v2N1O/ZJyP0voiJs8r6e2P/bd?=
 =?us-ascii?Q?QFgBZKOVJ9obiwxCiqL+qniJo6Mz5lMfh6G2y2Oz6CBMYKYBRDmp1fCIjgZ/?=
 =?us-ascii?Q?pT3WPR9c0EQ0peZhjMQeRLLm7bMCAu1GkAfZZIbUCX2JxcMaEm/9iLb/xtNM?=
 =?us-ascii?Q?vMsB1w6+OIaT56Vl1A7LpdUDDE/wc83HYmrLmFcdCPGlXWioli92ozPEJmaU?=
 =?us-ascii?Q?CqFtLuP42dzVLYmaZggge9zjN8V34q09QZUgOncgOtc1K1Tj7EMGqWZU216s?=
 =?us-ascii?Q?5Ntt7K5Aewyt2dlbQrbSQJ+Hc6Lo/WYJGyGVrBN+G5e2wXyVkjp/ToNkr0Lj?=
 =?us-ascii?Q?SYManC/kZVIAqO6idf6/XZEU2+bkkRSBuxiQam5VQ0/FQ7IN1tYD/nXM9r4K?=
 =?us-ascii?Q?5DZRV7+QbiVzICd3KVN1IbIoiAc/w8PrGoY9RBkxHAM2ICqQ3UntFnGZsYXG?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad3429f-b6a6-48d1-6a18-08da6e53a303
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:52.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7f1KqAcvyqXNJgQM7UJAANe7mu3bzQInfV5r35KDRKFC5a1jHFMSXBoQ3LXZKYtQi9ZztGVIAPO3l+hDhO9v5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a table for converting between speed/duplex and mac
capabilities. It also adds a helper for getting the max speed/duplex
from some caps. It is intended to be used by Russell King's DSA phylink
series. The table will be used directly later in this series.

Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[ adapted to live in phylink.c ]
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This is adapted from [1].

[1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/

Changes in v3:
- New

 drivers/net/phy/phylink.c | 56 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 58 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 68a58ab6a8ed..72bf6b607320 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -304,6 +304,62 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 }
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
+static struct {
+	unsigned long mask;
+	int speed;
+	unsigned int duplex;
+} phylink_caps_params[] = {
+	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
+	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
+	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
+	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
+	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
+	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
+	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
+	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
+	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
+	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
+	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
+	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
+	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
+	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
+	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
+	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
+	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
+};
+
+/**
+ * phylink_caps_find_max_speed() - Find the max speed/duplex of mac capabilities
+ * @caps: A mask of mac capabilities
+ * @speed: Variable to store the maximum speed
+ * @duplex: Variable to store the maximum duplex
+ *
+ * Find the maximum speed (and associated duplex) supported by a mask of mac
+ * capabilities. @speed and @duplex are always set, even if no matching mac
+ * capability was found.
+ *
+ * Return: 0 on success, or %-EINVAL if the maximum speed/duplex could not be determined.
+ */
+int phylink_caps_find_max_speed(unsigned long caps, int *speed,
+				unsigned int *duplex)
+{
+	int i;
+
+	*speed = SPEED_UNKNOWN;
+	*duplex = DUPLEX_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (caps & phylink_caps_params[i].mask) {
+			*speed = phylink_caps_params[i].speed;
+			*duplex = phylink_caps_params[i].duplex;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(phylink_caps_find_max_speed);
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 661d1d4fdbec..a5a236cfacb6 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -535,6 +535,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
+int phylink_caps_find_max_speed(unsigned long caps, int *speed,
+				unsigned int *duplex);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.35.1.1320.gc452695387.dirty

