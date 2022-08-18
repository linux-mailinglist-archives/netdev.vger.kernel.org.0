Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32134598940
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345029AbiHRQqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbiHRQqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF1CBFA9F;
        Thu, 18 Aug 2022 09:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IntrSFmcWSuwsIQ2b9D3nUo7ku5wgzScj2C2XoQBk/SlUtsoTVkCf4MOOQGK87D2DV7MCesZ1SMx1orDYclhtbVE1BpbwBgeRUeNXyxm3FonOJyWpNaGrVCBZ+aE5ed1QCA5Pvu0iXooROuXdkHrD/YEHhhKr+6l5a6TOONnLMAunfzeeLE/foEkztKXPbEEgAKCJOZlBPqAPBvOtsIs8b/rkBJOnT9hc4Y2NnKTxkVagsFlYWxfUB2/J9tBdfpPAjfPjIGO4V+rw0cm6p0x0CxEaYsxxdCsEMequ3oAUJzj6kCJMagpmsl7JjCwlPwjF3zUAkSBYbzzcykrsZ3Zog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jJ1221tKVunCESv1du32WcB+bJC4tZ6d5/Onqpe3VQ=;
 b=c0a44C1NEUq5mAem7IGwZ9+xvA2JYA72SOQJm/bxnU8eLafUzPtSYBGXD/A1aOVSEFeEIOkhZyVFgtDXyNNOIz2KM0DTRQ8VEI9luqK7ED5o7Jd0i/KED46REyNkxuJggvcy5c1c2jphYzctq0O2E8Z6hq570nWVHuAEn0Sj+TvkXvk6pxaL/sPeDN1YpKOrpDnTMJUvaqFpt4K2QcbW5lGoBM2hEJHcZb8f0w20wa0cexwDnfnwS+FzEDTLk+3M0U81bbMyhKJJi2ir2KPvwAXZ8gkB4z0RvigFntubW2yxPnZePyHkuacm0lmEtU7HfBnb8VQts8F2Or49LDZ4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jJ1221tKVunCESv1du32WcB+bJC4tZ6d5/Onqpe3VQ=;
 b=sMIMarbrgd9Cl/Ef1Jh2C8wyTcUiN2l3J3SlluKnSIyq8AbViNT8PYI2sKNoYwk51BCS0mUb12toIrukTtZFEhS4NLSnbzncw+KOkhsLu6Ny1RppvU6uIU5+IGQLQXD5j96aEO4HZPgy4WahwHDzDnAWQirQflUANQaToqmm43+qrFwaZmFMeqHI1z4gEMi5envXjUF/+ZpFh5AeePry23AD1PmdplnRcBBGgfvMR6ooEI+oiZrGvURB7px1unLadLzowgfFIEYsJnc1JJ0D5NrrsLkdbxbL6yGNS8cSMMs47ad2aQ3xtyeezUy/5fsWEYTj6Uz3lnvNjM7X9TqNqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 03/10] net: phylink: Export phylink_caps_to_linkmodes
Date:   Thu, 18 Aug 2022 12:46:09 -0400
Message-Id: <20220818164616.2064242-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71392dc4-a816-4cbc-eeda-08da81393422
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhNh/lWdUPuqqJ/AKNqmv01V+9PGLhGfLBSyjaSVQaG1NxlhGO2VTZq+1yNpWHtuMc73pt/ijwNx/TRqSjdn4GAjTzbmNuZN0N7Gh/qyqyBNH9o2R8LlfyWgZaPf2KxOufZcg9y9yE4Yf0E2dPc/w3+hJN2QJ5sq+10NEkhfTYTTD/eMdYmN9eju714SKpTDqph2sB5LnaXFIs4K/ciO3yZ/os3uLsrZyXsJ1SP6QhB6t1mC8ZzpZ2oHqpDdJJd8LfA1mhOMf/DTSEtM77dqqhWt7gvmdBurVXOpbstvxpATg2BJNGfxTT3mxIDJXf+P1/l0FnTPw/HjDoVRusXe4UFMabohl645nkg7r62vsbC4YzVqrQsQmd/l9oj+hQ/El3y8y59OzYvb9oSxUiDZclF1luBkOcSOsWIJ7bcXof1nGAFY8xBmQP+EcDwawh8HJlxFjPnZlUswlvtTciXsZH2PlIxYA/DSiLshCHbfvzB6h53rfxQ1nU8aIwTWWx0acuQXEd286XraQlTUAFiw5fO4LGn3NMR3yzWZlj0h9jOsicYSGiTCuPP0HTuVLJKXQDDqRGbHv5Nziww3JuXRjtN2K5zVHm24AsY9y10jTPRErGlLGfDBz8FktrzEcZkokiLva7EX+7LByNP+hGzO27Dilzv6G6Vb0SouCEhbh30si4Dqsys+gYd5Qm+ZTurvLfnurnnH7Q/k7lnPXaLdmQ1c2GEtn87SJzuIHJ7jEycj1G4fIogEo2TH19r0jf/EHqVntiHViZgiwZP2cOVqig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?og3wc0X4fDq/BmX3waPefDBTgJwLJyStT2dKkuUz4YFj2JpSRtjEbxVop76r?=
 =?us-ascii?Q?4dnqx8qpSS1un4KNia56Ny4MZK7DOCwkGIMQl6Tj6N+t/R6W6XBNEWm4WILK?=
 =?us-ascii?Q?DcPDl+k3odKHfpYH1b9g18PBwFhmRGZciQbIhO138jC/k7FHmf8nQsI/d5cI?=
 =?us-ascii?Q?439yZQkuA9ptU0vL+25+n/NcilaDYJtzqZlbldIsGvnzNYhxu841S4A0NDBD?=
 =?us-ascii?Q?Kfm4i9yomWPZCyzPv4GwNhWZ7j42W/p3FRKSqecPwtzErg0ZC8k8UeQPfeKw?=
 =?us-ascii?Q?6BlUq6BhUArhTodWS/eTCn7UY9+l7CLrrwBGrhyBJNZHjObyJcgUB2VvNcre?=
 =?us-ascii?Q?p6Q/xl2Uzk4iPg2hkzxkdR6Cr/fnB+brjrtAD4Io7y/x8Cu427gH5eFJeb9S?=
 =?us-ascii?Q?/kr3U12jJZMdOLLbzeXwWYoeX7xgJLqGkQAcOwQdze4P29L9coM9/fgaHfor?=
 =?us-ascii?Q?FAeIxRpGUEs3TyS4s8anu03Axb+0WJlJvPoLSIWeb4Qk+AsgFfQo40gr5IXt?=
 =?us-ascii?Q?pJ9PSGfM1FlDBA2ZAHwzDC5yhTifkdGag2s9nggemfysSOfC3cMJIH/i05X7?=
 =?us-ascii?Q?dJJz8xzlA2wYlHeQ0SIabimE2/4bQeSrpAu9gIcVmOjPfda7Wm7sPAQ/EA3C?=
 =?us-ascii?Q?vEc6aN4QXQ575uQUyuCst7lDIJkkY0slMVoe6slFNU8t5fDOFZy4PGsSH3zn?=
 =?us-ascii?Q?rCVB244Xjkc13Gh+ytR/XzDAj/jFhrqhBY5iEhYWSFO/lqrtMOmZjCikqufO?=
 =?us-ascii?Q?Qd+GaQYx2JcqNilpMPRPhukyzWC3JXL54JDfJHLCs4BGZWeHQcWivVfMHjeP?=
 =?us-ascii?Q?tA4nqgXY4eWyEKGa29B0zHWdRtbcqlI92ETw+AOTTvq3hN2B0gJejIYgwwev?=
 =?us-ascii?Q?C4irhWz5sC/GKhTjrm14/w+kdknrFVByajhxlEgSz9fstW0GARJm1SfJra8E?=
 =?us-ascii?Q?LIcSxj3Lavv/eHQ3OEBQ7fDbG4xL/iwfnPs7JUqg85wirAZjGDojM88zV8el?=
 =?us-ascii?Q?yejAYp9Mn+sPtnev3BarjW/vSlKDifNwICwqliFIRyxUzkPnLeYfE9RHsjKL?=
 =?us-ascii?Q?JrWgHH5ghEDNtIUCpRnfHLqE0+SAPi8pmSrtL/REo/zJ1kpw7JtPMhLv8eeW?=
 =?us-ascii?Q?CICtJQVP/F/2yqEf2DdQNFNcx6Nyf3xhGOd6oALXxR6PwHHze9vMV+nPNqQg?=
 =?us-ascii?Q?slbT3hStUwYWBGA9OI+93RINjQCv2LOY8xzZ0v7TOs/NlA94hL26/G8CMTHy?=
 =?us-ascii?Q?5E9SASZg7P9eJ2B+ncaJQXsV9ynqqOj48e02PPXPI3hVJSG78QpufJ5U2miS?=
 =?us-ascii?Q?dghX/Q0EZXObrpXynq3/a/S9pY5Udlms5cilxgg+zAcgjwmn1SwJvXgiO1Kq?=
 =?us-ascii?Q?MyWRMh6hVRd0/VAVsnKIEYl9QZD1Dl5O1PIhomGx1XnLJIA+RfVr1GMy1uuW?=
 =?us-ascii?Q?8itKRqkm+N7YRl3SsQe5vuln/2bOeu/29prvNfxxUgpA8t8We4osb1HC1FFj?=
 =?us-ascii?Q?qa4907oOato83IeRKe3e3pYywAVNn7M7Q2lcND3+72qFnYnMGEZk/Bua6IrY?=
 =?us-ascii?Q?WBFw1Bnsj+B82fi2v1Nvjf3jzdZ5Gx8uvsEO22FNe8RMeYyj1/WqMQSmqcNS?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71392dc4-a816-4cbc-eeda-08da81393422
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:31.6513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/w9MdXoFa+1k3d+DX6S+e77U+aZavQYkH5ITrISfpQyLWQR7zCH9pbK84qnbZGu2URKPq1d/9d/qCgWXz8rPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

