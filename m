Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B725AF0C3
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiIFQlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiIFQkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011D886725;
        Tue,  6 Sep 2022 09:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifBlvtGXzBe3+9nR4kTQMrko4N9gH+G0UOFCmk3HWvUpBpv/D6q+AF8r7lz78qDaHTsaAA6WI2nDGBVp3BSewLpYwc2CZMWpbSR58efM/nA6vvhMoPt2k7+9A03okPmQsUvC1dzxo5Q+MHeukfFDB/A9WDJVQKpRzCljFSWplrmqSveoEsb5o9BjJAF/ReBe3PEdlly+RCbbaQNxrtPyXre+CHP7r1ZUp+WoW1dUDBIlUoeBm1V3+gAo/I5fxuR9HH5baX3KlEnWwrMyX1NMp5cvFofp2yLX40tkDg2YZoxZJd5tENuQROhv9Vv7rNazw0mZygaNb5YU1LyGeBN0yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTzUpk9Ba8o0OnVKPUc1NcZf0NditoVZqMddjpYNG78=;
 b=iw9rCNL18EqpqcNflHcqBqw0+6D1M1X8Hf5r4gaZwP7+eMyk11WLDsPtPlkUOObODiJvtHvcRBU4J/QpXOtk1jCBeKjj0uu6Q48vb6BglQfVNhbcHeuwSsIcxuTG8QlNWpNhjvWsxaPLBIND3YCfGWwYkUlu7Ed0k+NYFJ+/4sJS1J9LzU7XwRWf0sgGM3m0TziHK3DY2Gwh2fWcrzUs4yENhWRcgFaBmRqw/jR7K7bda4102k8uIRmY0OFGTYZeRqmd75zzhpbeKDwOjvAO1VQ8uZ2Y8U9MO/6/OIrzThNk/a848FFWRUdDvBpMJj0mAkgsHDKoVlwZVHyWCdOOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTzUpk9Ba8o0OnVKPUc1NcZf0NditoVZqMddjpYNG78=;
 b=nmJxzELFlMqzMumvkAewJuPc/gnqVuIuCtK6MaEjdwoqCkpXKXrKUGyjk+wx4DNDnEJE+TpMahEQhmC8MjrxEsY/Xcdj8fxVcnIzFyUvYH/lGW5CUZOsJMaMCcVUWyTPRCElGlyXfdxjvp2txDvSBAyxl0SvBlrlmb+r9RfD4ZTN87E9xQ3BEMkb59MQv2W6SNN64RBoYqFtKvU1QApZGi2vtZBNywc4R9nXTiaosJ03pB5SkZECNwhuAqGLQPV6CXMBEHA+SQ0y1hagXYILR4lxj7RFc/JIz/1VxsIcCt4wFKnVL7Emp01oKCf/UTXXa5ay8cG5Kcg6dsVAHNCNJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2254.eurprd03.prod.outlook.com (2603:10a6:800:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:19:11 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:11 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 2/8] net: phylink: Export phylink_caps_to_linkmodes
Date:   Tue,  6 Sep 2022 12:18:46 -0400
Message-Id: <20220906161852.1538270-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ce101ab-ed05-4125-cdbc-08da902385b0
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2254:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DIdmau9VjNqWEIy8YG3/KW3jeNTHXMnNEXJ/cxJqKiIkvm75cbVMGYXcowLNE34J35iEpeKCu4724wiIJSnBszQkksMf84fYF+iq6/h0RaaqmfL+TwUPmeglEyN9+dfqgcIKBFIOJeQW/Zxvahz8gyYNG39qTckbkgNrphCR3S2lRTAnLzGyI9E8KAvVsPUAz/DCyZsnkKssWLHRpdpqwUAFb8VRyEs3nopoTK0AlLyNtq8qUFCWt1Ki9yJAMbGKfmtOksRLyZ0OPd0IZjMxcp3SERCgbFKTi6yShXOnQvHfzsWJMc+lVcH55A3C07hJfVpsybyxsNACi95ezmeo58wMKa8BjTFbZIYUDdvMw7JGhOLEju0yVTEVmCXVGU0RejwXAR7CCnyhLjpo/yJ6fnalBAMxqIwafPsHN4vAp9bht6jcjQqLBVqjD0bkrGlEEXFQg/0p5nlnMW3EVfPkCeZu3VMWyZ1jH2ecFhF8H1wz8VYIGAp0s1JgyypxVI08j2f3y7z8roMYmJ6iNJk/BKPg6oNIE5Ml420Ha6cGNDNCOH26VZELU1OEk+q+nUDwrXsRWN8m84HBJJgUYeReJJsOIE6z9QmkVaK4kFyWAJ63Z1rn/9m40UEXwTKWFcxX93V9EiS3kk+py4W8oFRHIolO2Z/9gbCqApYW+eNpvGB4lEq/9cfodFd6rs+BFNGEsU3O+hqxXTOktpmiESLBBqShQPPTxUh97obkOftgHhfJUAJO0UQM6IyvkBNFJaDRMzBxvm+qJLR7AadhI9AtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(136003)(39850400004)(38100700002)(54906003)(38350700002)(110136005)(83380400001)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(44832011)(7416002)(8936002)(6506007)(5660300002)(2616005)(1076003)(52116002)(186003)(478600001)(41300700001)(6666004)(86362001)(6512007)(26005)(6486002)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F9q89wX7l/g693oy5vKZSqyTAxFlpcfwmTM1t55VvmGlbjBgfWWA4u/R7/sm?=
 =?us-ascii?Q?O7L+uBpWaZThihXeSo9Mdu8HBY5dzHlb81/JwFJXw+1ZZLTi+CIDqoLV+8u1?=
 =?us-ascii?Q?wqeRUslnui00g6Iz2DMNMPobotrSHUHWcyrk32R8Vpq/kwrwiuI2yWQKH0G0?=
 =?us-ascii?Q?Dk/Z9xAt6DcgibYfHB+dH+yzVizbHfyHNHJ0ybrSwhzgxTIA501sTRwQ3WmJ?=
 =?us-ascii?Q?sv0HrjPG3sk6/YN0xDNlpC8AWmWMDojCSHlN1Sj6q3FYTMoYHf+CpmCwr64D?=
 =?us-ascii?Q?asa4NetKYsEWTYnRIijYu95ILjPoYYjH+2WYfEvys9Izk4uPLQEQZ8JRAkeu?=
 =?us-ascii?Q?TgU3tHqfxcz4NKgamEgHwHfCwLlfapvBHcWFHnTmr49naAZeL5+V1OV/aZx0?=
 =?us-ascii?Q?grL56PRsCePgv+Q8l6AQGYyV1ZRPGffjQdYES3PtE/B39nDwaucdG9S6UuFV?=
 =?us-ascii?Q?GSc2u9ULJY8FMolwXo5AwOsO2sKqGXg0O3MPlo8cQH0G+1JugnGfkneNO87A?=
 =?us-ascii?Q?8edCfebrZpiptjs+z24heFeThFhLPVggsJpUziJyVNPAqPsm3ZV3OCRDLBtF?=
 =?us-ascii?Q?REZghSR4DkNi6F+eN6zlfooxN9kM4Bm+ao7OAnoOGaPamKb33BnbTJ6oWAvi?=
 =?us-ascii?Q?JrzlBhP1UFaFQJF99pcBK5mCfAtScwmcmtKvTZFHtn/4Bs6wEzrs8KsHEzpa?=
 =?us-ascii?Q?n3PosAILiBQdPynJR+OiKeqKwmo20ZWTAjjVCsqZp02bnLX3bxonSDPGvLIA?=
 =?us-ascii?Q?+383ewyk5qfbbR+rSOvr6r7d5HlnDdf12tO6OsSdGZXnYZ3meamAPI+YC2NA?=
 =?us-ascii?Q?PpfvlrKCnq8Z1bgH1ycPQjVTyNo8mzYPk/QV0Llzwyo94lfqu3M3SaHbCPak?=
 =?us-ascii?Q?5g/3hZKlIxHERa8FJ9QppOS2Dugi80T1u6veJNq+oxXXf+gy5eV2c+cNsbf7?=
 =?us-ascii?Q?GOPxn/7uXWYP+ZKoHSsS0Kpoh170YgLCkzl9cJehovVvNKUrMIkFSIPtiG7r?=
 =?us-ascii?Q?lgohai0YFY9r5J3tLGpCs4m9FBUGkCdPbCkk7blPXC+Z9morOhxX1m6cZ9JU?=
 =?us-ascii?Q?T7GMas/msahhGLbIisfW4dINQVlAUaCw3AiZDp9BCMZ5pvlQRQPUMw0vXYr6?=
 =?us-ascii?Q?51HE8TS2cDsGpihYwNUvbdhDd/2sQ/1FoLxLiyZrO8mWPWSq9rmPGjaDNIdA?=
 =?us-ascii?Q?KUQClJd5K1Xg8FQ7mzVbsAM30ZY375Uz/DE6nFKnwXIay4FvdaGPqUN5fH98?=
 =?us-ascii?Q?aSR9TkIQWARDfPXbVQTMveQcOwkDGi+RFN8heRo8lmP32wAyrCvoUdcMutQp?=
 =?us-ascii?Q?EU3QoVZMvuTOtq/xWlQRII74pfVg1syFOV/hvNAXuQCZFTok+hlx137fDcLt?=
 =?us-ascii?Q?ea7KduSlt0ZoioAxfDdYE+VNouWwWaQARgukH9KdUpO9pGXWeQZVNps8tLDC?=
 =?us-ascii?Q?9QnbvlbV1YjHvnr66XnyJy3x7okg4eTBL3ggXkArSdgL3MlKxkMNOddkw9So?=
 =?us-ascii?Q?mo8SCwb6rdPpFP/cD4UL5LdKBwOg/vvkT4csy0D0MSqJCcLinJ9R3biDrt+/?=
 =?us-ascii?Q?JhLZZqOeheAmYlH/5mjdajA1RduAnLsaPtd4p0AGFJ+epeHpjTNLCUuOyw/2?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce101ab-ed05-4125-cdbc-08da902385b0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:06.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWLYJk+2iSipuuUUPMO65Z1RerfNQ2d1F6CuSscEqIBuZnh4chlWnhNW/s5mBKmvMFPIDh3IeOMXaLKR7MPU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is convenient for MAC drivers. They can use it to add or
remove particular link modes based on capabilities (such as if half
duplex is not supported for a particular interface mode).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 12 ++++++++++--
 include/linux/phylink.h   |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9d62f9598f9..c5c3f0b62d7f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -155,8 +155,15 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
-static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
-				      unsigned long caps)
+/**
+ * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
+ * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * @caps: bitmask of MAC capabilities
+ *
+ * Set all possible pause, speed and duplex linkmodes in @linkmodes that are
+ * supported by the @caps. @linkmodes must have been initialised previously.
+ */
+void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 {
 	if (caps & MAC_SYM_PAUSE)
 		__set_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes);
@@ -295,6 +302,7 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 		__set_bit(ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT, linkmodes);
 	}
 }
+EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
 /**
  * phylink_get_linkmodes() - get acceptable link modes
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index a431a0b0d217..9bb088e0ef3e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -534,6 +534,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 			   unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.35.1.1320.gc452695387.dirty

