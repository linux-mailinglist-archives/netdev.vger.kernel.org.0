Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63345BEFEB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiITWNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiITWM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:12:56 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F597823C;
        Tue, 20 Sep 2022 15:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO0/TyLt01fZALMNLiv+NLyvG+bneENZzqTAo9BzEWdxFsVNcZR4f7E3aIRGD27QfG/s3FqQSSrSwsTr5K2EK0/MI482pqamT5dhcNV34sCRbzc4HtKZOhsQOK80fVtIgtNiwH7zPul+y2hkdw8ft6wTj7o1E2Pdoa8Cb61n8tj761PPUkGrcw9Ueu+n/KNwrG2YD2a/hzsotGl4dHLEY1euD9/q1iKWiMSlXZA6b20tQwqYUmgDrf6CiDCUXmC90lA3zAXJxs5/+1DgkJ1vvbttO/bvOndW8AH5SbitZ3QCTvrD9o8q3If7URGUbvgqlkSGbuSdHSaYyo9h68QbuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaYsVKs9r9KfgfIMpIRhZvi8pdLuJebHaGka+7RepRI=;
 b=DCfVAHveQ/jYPZ7v3XAPkK2eIzxbaXe31gq5ZUYS+RxyQJ40oEUsJ1ncNwZWZsugOTDpTHjp2K5ngpikqBDVnA7AsUfJITQG1caCUCKx5c5c6vLP7XhfzWYVVzWF/Ms8XWnj7qq7gqjq3Z74xjN839g85F1G2iNmvvMfE47+mzcXjE50fxOGeNyrqppug7esOJJBiYfgEO6HQA9dnj3PbL+8isPkz48ZcwlxIsYCD7ew8tt1R/ZtOAZWD58cwo2HNyfODV7M64eBMUBmh/UpInt57oJTwHRWztGjO1KiHQqaY74xT6blpQxPZgsR1WwOiL/cYguHKe99TNbdLSYuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaYsVKs9r9KfgfIMpIRhZvi8pdLuJebHaGka+7RepRI=;
 b=gcSvBPnoaE4pgb0gkCm9FBlzhaQLR5LX7vE1SRLo2tclAbm34bcSfRw45cM0A5yV2kc/79Nhu8WA599dMRFfbo+MY0nJii48gAuWg5TMwdc7WpKEepfioMCY/CGxBz0mS8LD7BSF5Hu+yTm1hgMdUiyUadDN+GjBs9wFPJ6459v/gXfio9umOmWAUFzh7D9/9bfTu5CQWaikZuF+VggQx65F61mcxRyH7loPC/1seECVymtSJ+MTosrrSM3Tra0iJA3ksQZRaAYHqrJvfeAqLfd3VTMvDjYPUKp3XgT8NbmEtEJDX5DRGXrRMuHS2Ow0WyiwBHmZ5zbpImEe2lj4Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v6 2/8] net: phylink: Export phylink_caps_to_linkmodes
Date:   Tue, 20 Sep 2022 18:12:29 -0400
Message-Id: <20220920221235.1487501-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 76eb4337-0bec-48dd-a22b-08da9b554113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Wn8kISpcd8NYC6xdAZ3plzg2JOgJ+2GCUB50ZIDpE+udI6rhwnJoJBRHvpYk/SkA/VLC8Ls4hHrmniITKlEWKk4913xleYHSx5wG6pWh2bt7/ypTHLNVRWssNBVZoukye1rFOy8nbF8C9dWycLzovV1fMJzOamcp5qYaH1Sr7zSEmaWgCZgGuf0+7JGyHulwsRDbsFrSEqHfm+13uzu/gV027mgE8cK9PrbTciXEhoX86c7JlsdYMNTKXPkhibs6jaZRF76k8P7o2q8MPPQocA1taR3VBOv8jHuNkGcDrFLQU58gtvcug49cT7UdohaU31d7AVKujkNOpLwsShaGCh1iOxYfkST5Y09rTJOzNwLpNcJnBuoguC/yxRU9zzfRBHPNYnyxLTAuAJDZv+urj5mXPBjxgtp7GajvNxDy5SSE3n0XohC02EnjbAYyWSLRCFbz0hjAPTbPp41tJ35jjtxfJ6S1V6CzjJyW8UdhET3gAI5HlRICk7AMdC8XoKNCyKFx/UcvPX/TLMJDTCFZWcQQi5nMGj8ATI+Qcls8B9HOb2+dmiAQ1/lxhVrGXD0oa05af1KgPq7K1rX8sF+7xL168JOcLRjFoL53d56FJ/YsyA/u5Gk+JgXYGnS+ciX/F5tGk7x4HJvYC/OuP4lVfCNAwAdeLybTeVKZ9uBhf2SGi7Z272j/uwya6+m6PKjI4cnjehFjdwF8G7ASry1J9RVzV4uUiM2IW77kinjvnuhUvz1IKFKme7ofB38Us00XQGiyKgo2A8G1ynNvtevZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(107886003)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/hHb413YzabwH1nMf6CD3BmQ04YqFMdPxMdsCNeEY73IQShcAoGCupcpK5YO?=
 =?us-ascii?Q?ldj5y0ORfPM09+14WYh4u6akwrEGfpMnK16BqdNbI297m6RP6TJTTwMjIK0Y?=
 =?us-ascii?Q?q6j/vNE14jFBDRskCLj4RKstqLwLrwY4FXd+UfzuuSCi3YE+EXPm0kox/EtD?=
 =?us-ascii?Q?3RiWabps+Jlrsy57fM2HIhbWrRjf+LvxqODrQT41ZmrxdgeYn2HVu2jy1yM7?=
 =?us-ascii?Q?njSuVYFKFEm2JIa75TBnTlMM6J1uOv2knMA+hEVWLDByAUJE7p9zuAmPI6f9?=
 =?us-ascii?Q?yFM2I8cy8SfgcD5Ml0qxhSVuxMD07KtJP8EDX/zZi+JHCXs66eutErqCGneM?=
 =?us-ascii?Q?ca9BXGu/9Bmz+LjeNSA5A+4gmje9uV9DM42cQFWICJZv4qg5AS4NY5kSkgYT?=
 =?us-ascii?Q?63+b4ypeZaPb0ZHsZy/xU16gKvZ2NDeav2Psh3l2yervxRpHvg0fJj8FQxi+?=
 =?us-ascii?Q?UA9M9z8/dHEe7rZGHyQtxcQcGK6zlLrNz3hLnnv4WAgOjxcd5WVVzjmQj/of?=
 =?us-ascii?Q?n04zFYBTvlEhqLGpkGFXzikyycf+x+bJ6AljikQYJVAaacsVLtHdDssCu+gq?=
 =?us-ascii?Q?aOPNWxgO/j2dJP0bR36NaVWprLUH5QgPMS5CBtH0boUDeNuv6uzJCbipzCLb?=
 =?us-ascii?Q?YSZRFOAMeh786OgXpli628O39I1pEIjj+RNTxDzsVDtXc9mXuSIdoHCqUJuw?=
 =?us-ascii?Q?CNhTnzlf88O8z4ifSOUzdAv2kKt4avzCuN+8gueOQVXAGEfbe270Kr+8s8ok?=
 =?us-ascii?Q?vDMEbCmkMCPc4vms+0wTS5X8LEyMnNCmJd1OxtnbbZVW8v58LcZBc5bYiZap?=
 =?us-ascii?Q?SUsER+tWdly+uu3Zehkoe7FVYbSstYsTpoCfPwK4G3GBbfInxs3D7XMBAaFI?=
 =?us-ascii?Q?IYtHJGU9vh1MfjPP3LHslw96jpDU10OFRHmuf4oLjDLIL9xfOx0OgKC3zrzm?=
 =?us-ascii?Q?+o+P2mLNCHy9gBI2eijk9yNivonzB1EPTllG70RfS1Kk2rNXIv5rGAm4zMGn?=
 =?us-ascii?Q?4Xx8vr+AnZ8nMZxL0vYqMU4dR4djOc8Rm8gxrv59m0Mk7PkO+Z9pVgh3HGZ4?=
 =?us-ascii?Q?oMiOxfFK24q6xCxRYiWuDlO4gaBHKUUW0KCRK2cY+0wA9htH8BOvJBwbBJYs?=
 =?us-ascii?Q?Y6ZVxEoG24ui3QwclFhhFdRanp76IxM3+3QISulLWOYMcygFOgl85TsdtlRO?=
 =?us-ascii?Q?dysrVVGkM4/cQKm2OcHgt+8vAa6Ukv7JtMOeXEK64PUMCG+O61qR3uZBtLqc?=
 =?us-ascii?Q?xPSJ8D7Uwpfly48DeGodP5qwFRygqKWe5N2Iv1HQxq0+sZXTgWsYy+feB2/G?=
 =?us-ascii?Q?9+gufIws4wCkT8uyZiSfqwJUBVuLAmP8nphZDGokuSp3T/LlX4C/P9BND0SN?=
 =?us-ascii?Q?GnQrgXmucc48nieV86voAB2WovqzsxnfGMFOBcJKex8ZYV3YxgSjoQSxxJ+a?=
 =?us-ascii?Q?Tbh0h1JYuk0UDz8cjWWWit38i9KKrjkd508WFgos9d0AnGyW5AM2wSOjk9V4?=
 =?us-ascii?Q?oU7P+r/BNXabH+Ny4FlMOSRUOIplAZiYHUuiYkZRHcpEmR0XqISl0H0zt3dZ?=
 =?us-ascii?Q?AL0WphU2is9hocqw11u7YmaVn/W8Z4RdCUM6xHG/yJjtQYN+LuYFP9Vrim0R?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76eb4337-0bec-48dd-a22b-08da9b554113
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:49.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2TV8D8P+zVlf5h5JMTdznSDLseEOqu21aY7BrDtkoKNhNyzy2lcd5QPvzYWtj5LyYkATCgA7M2rtaOSpn0xJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
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
index 1f997e14bf80..7cf26d7a522d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -547,6 +547,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 			   unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.35.1.1320.gc452695387.dirty

