Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6A64EFB4
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiLPQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiLPQtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:49:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F241C905;
        Fri, 16 Dec 2022 08:49:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKs/pzG0dnIhTg0qgdjj5fAgKxJW3tjZs2rgIYHjVvX9Mm2OPtYMSq+oCOT5/50YrTWs+CRryuqxMt4gHa+4rpb42GDtD+iHbVQteJAnQyWny98vh73Dk1O0/4GciGDttQo041IJsyjcEGJ75JVI2HamCaY94g3uJfbAsn+F949eAS3iXtco42Np2W6wrSA01Rjkiso93GygbtWygUkcsGy0ksC8Fkm2tbQsA6wz7xhR23CN460f+UoSAmjxFXJmGI1OF5aAEVU7PQnWbejrejM7s72cAjiVdiyTWysKEmgViBb7D+0UpN+t1AQScPLB92S2abWeK63E78jKypLMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBx2EPpjk5eg3mcjNHLHlcfeB089h5/CB2j8PXvrIjk=;
 b=dnexn5JvscFZRuIlk6J8YEX5bBHqezU1IdzVHe81a+iAVHtZdXqsJKFrHDpqGhBln2p3Xn63MLFpIwSLg6YtRbjjnnVQXefod/xkihqhew7C4c6nSncYdPVWAXjgCQlfguWD14L5QM3Kl/WgO3GLQw1lk3n/bxRLIMtttIuKhg5egawvCGEYKUMZjs85Mvz2Zjx/J+3iYkaPqTy1mQKwANbandfzYvt7dWpIyGX3PDOYaomKvmkHDZLwWp4oj2Ag2lBl3qKWZvQN1T+d5sWgL8Sc0JWw0h70zr81hP2RYHv9lzYx6ow2yqeO6o8NfLJNU8JZQOcVtcH/k508NfIbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBx2EPpjk5eg3mcjNHLHlcfeB089h5/CB2j8PXvrIjk=;
 b=iAKBtAH228UACucqS52M6oxVw5ViGUOhQRW7g1sNoiZNVbQ8kYUGoET7eNcyDajPHb3uoFs4pm7JYQAfjuKzihRnhw9X2GCdwJtM8bpJINREaKfZwtljZ01rv59BMRNyp6bCIMuXcQdppFoTZ7XhqFCAr/R6QpQMAc/G/Y/jG0mx4TO/7XEAL5w1M4aHqkNxxlOJhNo0MQDWLu+L326Ez/8HgH7d4IW6gUWqxLAgBOJYj/i3cQvzPzd7BPJfhl/hgZWDQ8I6k4FYFnIDCBO8Lc4h3d5YR9B+UxG7POtBO/Mb1p/cvvyL5KmGqwItN9H7fr4ew/6f3fhfKmy6JMeusA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB8010.eurprd03.prod.outlook.com (2603:10a6:20b:43d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:49:02 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:49:02 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v4 1/4] net: phy: Move/rename phylink_interface_max_speed
Date:   Fri, 16 Dec 2022 11:48:48 -0500
Message-Id: <20221216164851.2932043-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221216164851.2932043-1-sean.anderson@seco.com>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f727c6-1d34-43d4-cb8b-08dadf856fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1aTPwgkKSBGy9ivc88Fq0bcPe6oiCZDbD8s77hHMiY5KWxokTJE11TZrSBbffroWBhT0Y4BLyvQsPl59mS4jMRdTWvYR/xw90LIZ9Cuu/FqAXp6pC7jS1f8TOM/KpMiV5UVJiKw9Jh1o1UHq+bkWnkI1tXSUrfM+K4nhvpSrf9+CcNJ7mjr88exhX3AvXx7DRULPo8H2NQJFEEMB/wHLvvf3NtxiJB/6QhMCPHqbzizC/hO5ovO+rU3oCQroxaYaq4fxKKbx7BgC8vC4UJX+9sUxf4VEqXS/z7ogX9NvwZSy0xNINIeo4OIKYC0Mcv0IzqZvXquVFLqLH62YSh0T10159M55Y6nxCoircdfnsqKSmXxMBkounpBZyG8Z6aGPl/RVusHG92tmWLmjFdZ7NOn137zKEZeSdF9sV5YRp0Gdnz//XTuePmFzASohkrsDrTZZVZ4HieqUCuuEvnDDmCnOjBfbir/kuNdWJsnP8BpeN9/egqYkEaIrnzLkoVfUcnSkoC+I5R0qp64m0SVSss+lsR9j5iU/JT0M/aOPAl1EBKuMWXxq9kqp4jn0SKfRJUHQVGGIgcZGiP1LqWmI5HnDsq3LFWdMfow6CVilg5XLrAwLlo/V+zol6PjSPSwkBYWIOOHRYBWJ0Q4LvKtyow+YPf8BTtPHgZDcjE0FEejyLx1duOWcaUeKP1upyl621YGRM0t1ZFNdKlIQfyTNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39850400004)(451199015)(2616005)(1076003)(86362001)(83380400001)(36756003)(38350700002)(44832011)(38100700002)(316002)(41300700001)(2906002)(8936002)(66476007)(66556008)(66946007)(4326008)(5660300002)(8676002)(7416002)(186003)(52116002)(478600001)(26005)(6486002)(6512007)(54906003)(6506007)(6666004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJ9keQh20sbxGEHSZOHBEGLzjK86Eux1NtK9Gg0EJAFuElExktjf4DxtCd5v?=
 =?us-ascii?Q?OtncZSZBoyWQ8zzRJD1Ube9lTEHIrMpMU9vnyhbgBoq9v2WBTi7cwfooRQc3?=
 =?us-ascii?Q?bqD5p+gNlHCy5pTIC/GT40ly9aR3mZFX/MHace+DXrbsOYPblfQBy/sBO0m9?=
 =?us-ascii?Q?32Os8c5f3cCDbr1QTUca4J7II7FYe7CD+13wiY3H0N3qXVWj7rHeuC3CdKZo?=
 =?us-ascii?Q?LyD3WyMLs42bxxLmvU+ENYc8Zd6Z7ixnhsX46upacy2TBp/OWgKNuHFMgyEg?=
 =?us-ascii?Q?WEV39TTsL+r5lXGJWLZEBDjZdEcExgT19jdNY70vml5XNXMFrmllOcaxdpgF?=
 =?us-ascii?Q?T4TZzR79oIFR+PuxlIQ2JV59YSgt4ML7i+TWMRnw2OWZcWM6k4HJQtKQPlGS?=
 =?us-ascii?Q?MhYWosdGsszM9qU7xXTrq81JwJAXx3mEP5VVemOMh3oQddZ1MGHrNflIuJ+P?=
 =?us-ascii?Q?BxLo+AIKxHqytYlVaDMmJEkWtpjctyvCcSKCLbJnl9kmGQqCKck2C3i9h1Ku?=
 =?us-ascii?Q?Kh3n97KwKcGl2VWFePA4wxV5HXNZHDGGTLnxehxEP3m1nWxgqRLSPQ4uUroK?=
 =?us-ascii?Q?bbfB+awE5OT0OuFwNfVJtCXGVBnlSuV9nxKAy2eSpUy1aZ4g/ouzErleBMRC?=
 =?us-ascii?Q?Rt2R/OvkpDBunpnW5/Pk3mFEqP+ZTZJ4DpVDTuXPZ2P6WuikM6+jsnEIxy7P?=
 =?us-ascii?Q?as7pO/XjEm1yGdtHxLL8nXFwxtrudBpZCECYxlRy7x6glbmVMNZN/hKM3U9a?=
 =?us-ascii?Q?7+7FNiwIGAev3hFExZyUFDcaLYdbCc8j+YopvOIbuQti2L+DDYjphyjJqCul?=
 =?us-ascii?Q?dvhj6HyqCs/ZCECh05heJNomY/VNAIRUMmCTMMmQ8as01zj6cUpSzxilfFto?=
 =?us-ascii?Q?T7y43yMdTceUd2SFEY2r7Yt1INxviYQ83Kwa/0qN6qMLcsrvTPEfg9gv8Z7p?=
 =?us-ascii?Q?nYvY+oarnJU0tAZauZpzsBKKXdiuckphHv3+5fo9ElwT8rLU4MHQo1VqEeiR?=
 =?us-ascii?Q?XarmSLUxQJdQgBKXnV0Ru4fJsfYcoRMuUrIbJ6oaSg9dlVKw/bkUSoBKfI7M?=
 =?us-ascii?Q?A8geIkn4l1lAHHca1Mb9ZYMLQs7tHVkchoB3T31wkf3sGFT4/jOsmYC/qcrh?=
 =?us-ascii?Q?kMemhJcxz5ni5SZoT+HTUeQxj7pMiXPruwAWnPKxGK5ZqGNZvqjZ+wbDmm9O?=
 =?us-ascii?Q?GipKe+xTmzChMZ3KNmf0vyqtr4irg/ZOvsFOhxeE+GVjmeRE77gR05LU8DB/?=
 =?us-ascii?Q?8yYDlqWbHPrUH288ziaHeBre8/b97YvVE3IFWaMuGC757AfoafbeAQb/ejf2?=
 =?us-ascii?Q?KpGTnjqAkcF2jTcB56erCNdL+r+6VThj9Ab2U7LFEtb3arur/URG8yiDPAHs?=
 =?us-ascii?Q?dKjHB9GfRMTffOdqOqV6VU+cFfddzhkVMU4a1cUgd3Xm0ftKKV6XsGSkLX0y?=
 =?us-ascii?Q?tAcSbJj0Z0kdzoZL9OqPVD79axMgRWq8yThGvax0apkMpkzF6AJIjga5grOS?=
 =?us-ascii?Q?J6X09AHKm5l4waEtO4YQU/v5OEwolbzBGsigvodSyguK1OTJ8RqeH2EtcAA1?=
 =?us-ascii?Q?DljUkOy30tNlnVjq4sZZik0HYmmCPJWAgM9Dy6cukVor243GpTYv/20KX0xf?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f727c6-1d34-43d4-cb8b-08dadf856fe1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:49:02.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xqJjQ3u75HHtJkf6R7w4Dg7OJPQm8sEPcInSFYhe7fQpOovXv1nC/N3Q5npUL0BqUh+Lk42xsBYLJvjkw8yddw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is really a core phy function like phy_interface_num_ports. Move it
to drivers/net/phy/phy-core.c and rename it accordingly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/phy/phy-core.c | 70 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 75 ++------------------------------------
 include/linux/phy.h        |  1 +
 3 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 5d08c627a516..5a515434a228 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -150,6 +150,76 @@ int phy_interface_num_ports(phy_interface_t interface)
 }
 EXPORT_SYMBOL_GPL(phy_interface_num_ports);
 
+/**
+ * phy_interface_max_speed() - get the maximum speed of a phy interface
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ *
+ * Determine the maximum speed of a phy interface. This is intended to help
+ * determine the correct speed to pass to the MAC when the phy is performing
+ * rate matching.
+ *
+ * Return: The maximum speed of @interface
+ */
+int phy_interface_max_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		return SPEED_100;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+		return SPEED_1000;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return SPEED_2500;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		return SPEED_5000;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		/* No idea! Garbage in, unknown out */
+		return SPEED_UNKNOWN;
+	}
+
+	/* If we get here, someone forgot to add an interface mode above */
+	WARN_ON_ONCE(1);
+	return SPEED_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(phy_interface_max_speed);
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..f8cba09f9d87 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -156,75 +156,6 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
-/**
- * phylink_interface_max_speed() - get the maximum speed of a phy interface
- * @interface: phy interface mode defined by &typedef phy_interface_t
- *
- * Determine the maximum speed of a phy interface. This is intended to help
- * determine the correct speed to pass to the MAC when the phy is performing
- * rate matching.
- *
- * Return: The maximum speed of @interface
- */
-static int phylink_interface_max_speed(phy_interface_t interface)
-{
-	switch (interface) {
-	case PHY_INTERFACE_MODE_100BASEX:
-	case PHY_INTERFACE_MODE_REVRMII:
-	case PHY_INTERFACE_MODE_RMII:
-	case PHY_INTERFACE_MODE_SMII:
-	case PHY_INTERFACE_MODE_REVMII:
-	case PHY_INTERFACE_MODE_MII:
-		return SPEED_100;
-
-	case PHY_INTERFACE_MODE_TBI:
-	case PHY_INTERFACE_MODE_MOCA:
-	case PHY_INTERFACE_MODE_RTBI:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_1000BASEKX:
-	case PHY_INTERFACE_MODE_TRGMII:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_GMII:
-		return SPEED_1000;
-
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return SPEED_2500;
-
-	case PHY_INTERFACE_MODE_5GBASER:
-		return SPEED_5000;
-
-	case PHY_INTERFACE_MODE_XGMII:
-	case PHY_INTERFACE_MODE_RXAUI:
-	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_10GKR:
-	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
-		return SPEED_10000;
-
-	case PHY_INTERFACE_MODE_25GBASER:
-		return SPEED_25000;
-
-	case PHY_INTERFACE_MODE_XLGMII:
-		return SPEED_40000;
-
-	case PHY_INTERFACE_MODE_INTERNAL:
-	case PHY_INTERFACE_MODE_NA:
-	case PHY_INTERFACE_MODE_MAX:
-		/* No idea! Garbage in, unknown out */
-		return SPEED_UNKNOWN;
-	}
-
-	/* If we get here, someone forgot to add an interface mode above */
-	WARN_ON_ONCE(1);
-	return SPEED_UNKNOWN;
-}
-
 /**
  * phylink_caps_to_linkmodes() - Convert capabilities to ethtool link modes
  * @linkmodes: ethtool linkmode mask (must be already initialised)
@@ -435,7 +366,7 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities,
 				       int rate_matching)
 {
-	int max_speed = phylink_interface_max_speed(interface);
+	int max_speed = phy_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 	unsigned long matched_caps = 0;
 
@@ -1221,7 +1152,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will send
 		 * pause frames to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_FULL;
 		rx_pause = true;
 		break;
@@ -1231,7 +1162,7 @@ static void phylink_link_up(struct phylink *pl,
 		 * the link_state) to the interface speed, and will cause
 		 * collisions to the MAC to limit its transmission speed.
 		 */
-		speed = phylink_interface_max_speed(link_state.interface);
+		speed = phy_interface_max_speed(link_state.interface);
 		duplex = DUPLEX_HALF;
 		break;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..65d21a79bab3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1004,6 +1004,7 @@ const char *phy_duplex_to_str(unsigned int duplex);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
+int phy_interface_max_speed(phy_interface_t interface);
 
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
-- 
2.35.1.1320.gc452695387.dirty

