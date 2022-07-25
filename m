Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1BF580205
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbiGYPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235774AbiGYPh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:37:58 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D53DF1E;
        Mon, 25 Jul 2022 08:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IO1NA8+7KQHMvOuUnRiqj9pK6dNM57OCUyjDRapxyn076exeQL9Tt/emAnEPNJ8ZzmvXOpTAJP0zWbtsRvbapFA2HsWBE0DncEM7tS616IFpjV3ZFwTShXy+rIrgEvGwZYIPXv3qIAF5n4caZw6KMHNoZEqWOjOY0JY61yhj/n4jVjsNuF2zGz4pNjTfR+DIEM24VGdTuqFRcZAKaGYVKFOSoXR6rwP8pXyP00oscT8Z5nZoMiBWXQzOs4q8GfdZfAfEyqqcDNyL48bLZf2isW+4lPix+ZGWDg0/T2gf1jSeYqqCirJTG/9/+jlMfROpu9OBBfyfJcG3STAsvCM0OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jJ1221tKVunCESv1du32WcB+bJC4tZ6d5/Onqpe3VQ=;
 b=Y+Wgy8C2Rt1q+u7kJo56R+kvtQiV5YbDJd/BvNj9THGn9KGbFehhLIFvYCKFISNMvzeamoaQsxGIO7/YvzuW73mv+i6cVNmvzXwqP6lUklsGo4zJrPXsA/KvHlMRIXRJ4puz+0kI9N1C4ZpWnSr3i3ijd7smami9fSgQx6pVhzJOr9qrtYi1hOMWhdXijR0tt3zXD2ed97zI+zaUckKecN+ZToKhk9lf0E79rGaxHcSvTq4C13F75B4dBygdpkYYKtVAXwXWp70Hh3OU+VjTp5DOtAgyhpyH1EOTcmwgaN9virizN3+AYFpTNriGHrLMHNhcjctd9khoF3GCjxZGTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jJ1221tKVunCESv1du32WcB+bJC4tZ6d5/Onqpe3VQ=;
 b=aJSoFqe6sqW5El6VszGQO/1DXjmSeh75peXOQPZj/6v1H7iVO7hlawprfOIjreSTMzDxfqpxAo7jVe99tOqRCfiJay7mWddGef2GZDhY7aOl9rthMTLiVblMnvz3PVk2zWggDnalYwOEmHgggRRCts5WaLHr0hk+hj6Q95GX38BwBaPmBU2ZX+F8kuW2VAFGeSTAopvoNH58dIFmhDXk0oUGM6plq5iN+R1iutxBoHMMVGFBwcKCb20pYsF3yDMc8/cSuuS1ssSPv/9M2e6MXohuyTlavsbBB3VJs8HdGNzYvk+ggsQqejDqVn/mqHYZRMjQVNd2mOLHvmyux6zF2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:37:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:49 +0000
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
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 04/11] net: phylink: Export phylink_caps_to_linkmodes
Date:   Mon, 25 Jul 2022 11:37:22 -0400
Message-Id: <20220725153730.2604096-5-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0c4d11dc-529f-4905-ae37-08da6e53a139
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRPnJd4KNaUDlfDY1dw2Roup16Cr2fU5fDp+IatJr44+J0ixKl0qaxbdfRozVztZ/ReFgV7V0P6oVm6hJJjJEfDlgo/5EGBj7ZAuCaUSJOya1bKtuPDwDdI8S1DvAQ+FvK+ZS9tOANJ5+ENf8JJL4jbECWuiF/JHUUMmr9vVAF+9CV9ypvsLEb3ms5Ii8AGensrdLs3LXd4Bf4aPuONh87sHu2RFGMRMKuIiLshFJs22R+P9VakW8Zqs7nZXIYCFDMwyJC51BaNsNAanxCFL1nDlsxYyeoh3CWabUa1xY+DiqOl+xiMzXaUsoMa6JwIpgWhMycf7Rdk1nDEk70UwDDui5pqqdTzaHkUtpVJXvdgqxeYEs/FuUxbyWDWw93LN/Mh8vqukRdLJyHtR/D/wN4sqYU7xCNQ+yYLpaigkM0Ty25KVe5xZ1ibvYI3q7jK8E+PV3JawH212VnXi5xBjL1dZE+WzZkyQ2PHl+xnHvorJRuTBaTVKdqX96LMHBr0solb3i560PMFG7DZsG70CdeIr5FZCrrPD3FE2L7dEkJSz+wxE5aHmPPTKEBkigRl01UVdIVBh78xY2V/WIjMusMBeOKqybcrWoryffYmRTp8FgTOhwjaOcA4kPBYJ3+i9Q0X05QatEHWWntYRv+JIURa7fkDvuwDVopt0wuXtLd6evjUaaygoJhV7mcEqOEntkfcvTcUKaJNUxQ2ZuS2jH74w39SX6N4cZdBVwrRHiA0pmk/o+4+LjVFqZICsWlwEM5atLihnV295EDIBlMQxHRGQr+M7QpKRqLWc+AhJA+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(110136005)(6486002)(4326008)(6506007)(83380400001)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(38350700002)(26005)(2616005)(38100700002)(6512007)(66946007)(1076003)(66476007)(8936002)(44832011)(5660300002)(107886003)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0gvxX1QkthfHylISLmz+Yu9z7nGGpErJVdoX+bUDDN3lLmIm01nc0xBmoW0L?=
 =?us-ascii?Q?sNI6iqfQlJWw9ulTMLdoHG/o0cm8wBbqudMsc70LS1HuJ/EBu5urFueYhyEC?=
 =?us-ascii?Q?tspTZA1hD9zfXzBt4GH8tfuJEHGyNnfddnLaGOHdXJhG2xHzR/fcODQUGggx?=
 =?us-ascii?Q?vgylgqO6t4Y19UfYy8vd218nNRIpdgLrAYmC0th7nhtNY+WtwquALKnA3YuK?=
 =?us-ascii?Q?PDs3pBx4m/zUdY4/QpIt5la+9p9sGAkgZ6gQs5rK7/2JuurqwJFKdUjtbZ6l?=
 =?us-ascii?Q?XIRGAFkb0XCEwPLmu06kmGcBc5zCW8LiylYiLddw0bWqIAkPIy7DlbHE7erI?=
 =?us-ascii?Q?+XAzEpopfIHZUMkhpf1RDPQFWBP3jtTSBzgo90G00RYh0/6ug2mKOgNfIZ0o?=
 =?us-ascii?Q?WfCFb+MmrgqaFlH0nsy4w/Zj/AgvZvAYzOzfsIt3PHcIKPr45+J4hAiBHtvw?=
 =?us-ascii?Q?5mqXIec17tOpGPoJ2B4PyxqUOQBFf8H7TWKP/0cmjXoXYqO72mAZVW7jN21a?=
 =?us-ascii?Q?G9KZZuqQPtql4x9087Bzz2AejzKF8c9DPXSvsRvC1lOZ7nIgSWvtoxyh5bvg?=
 =?us-ascii?Q?G2UUcvC9Jxn1ELcUEZrtIMKXUR8+El31zxlklA//YhfB0lHrqrie34MhVQwx?=
 =?us-ascii?Q?1xVTRArjhws5THWGRnQ3YKHk8EDTP84dgQlCPIbaQ44S+K9gkzwRBP0s0fNe?=
 =?us-ascii?Q?pHVo+Dgp0Nj3Dn/i99tAXY6N6Tk610Yk2S6cxBIA1bIzI9C95iPCF+tNsT7F?=
 =?us-ascii?Q?QjLX6KpRj2GpCC3NQi4DMlTq75hW6y78EyB4qkFMjU1rlVQtT2/g6ln8Y7lj?=
 =?us-ascii?Q?8o5giLP0dAVPl3hg0hGkvKwZP+BX1jjo18FSrfdK1mDBjss49ajOwPJ+xhN6?=
 =?us-ascii?Q?W31UAdJLhD9ncdABRM8yWWGY1E5eObJtJn/8eSaP+nI9tdYjTONJBS/pHUXM?=
 =?us-ascii?Q?SW4wCTNODFKIJ6OXf5mvXaTPxdFCuvkZ0GmRpvIj0t6kNy/3697Wb0AOp9Dm?=
 =?us-ascii?Q?ip3qR/+40JPkkwRrea1ox6DDmPO8XkcyxELkfMioGszBKtp1ZWo5uRM4+z7O?=
 =?us-ascii?Q?83MFUXXU23br61+Z3CR5ceo3iWjl8JmAsJNL4Hxx3mNM3fvc3TjIK499A4CI?=
 =?us-ascii?Q?Y9lp9/gncAqgYWvqEHda5I3GFviVI30++X1xgjYGXk1JNa+qcC0NDi4Pveni?=
 =?us-ascii?Q?PlWtns5pS2XG2drIXbrvlN/q8uifEpYVS3pgNKmXgleNojtCIUF9fqxi7lXw?=
 =?us-ascii?Q?QiLQfixsYLV08jZaywSP2dEdQ/Jy2bhcmP5HlkaCXpBe1MpH5QFEMBFMEaFm?=
 =?us-ascii?Q?6H/xnOIw+nN53gjRiv/UI/hNKIQ21IZmLurbo6mroVcV3lCy/1VMgmyZ0o43?=
 =?us-ascii?Q?BCCedduIprRHEf8J3LcKBM7a5XIN+Rg4geDhhB9n2+yIuUEChizpNxlEp0oP?=
 =?us-ascii?Q?bJcuiDPeyRtVvyU494GvTZ6h4YyIuVsR0htgv2hOCc3b1W0GW5i1vmCCXdar?=
 =?us-ascii?Q?EZD92BdLcC6QAr+2pyN3wov7cwNRKxcidWR0B9tlmAPyNZnXC0yMwgoqei4B?=
 =?us-ascii?Q?2KSZcGhcVAthcMQfGou5hy1N34u+nDqlRnUcwozi4NJebw/hfLCM2TmiNiYv?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4d11dc-529f-4905-ae37-08da6e53a139
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:49.4005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sImK2OrrxEdmqWc8hE3OWRjRv29cF64W6dIL7tZAlwNhoZRrr8j1BVAy+or5Sk14c24fb+rr7ih8yaRrshIfzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index b08716fe22c1..51e66320526f 100644
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
index 9629bcd594b1..2a6d2f7a7ebb 100644
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

