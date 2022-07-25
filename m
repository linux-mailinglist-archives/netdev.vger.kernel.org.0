Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA00D5801FF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiGYPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiGYPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:37:50 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57CDEF7;
        Mon, 25 Jul 2022 08:37:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGsXuTBcEmtc8sTrBVrj3sWGNI3PjbyyRB+dv4Jk2CiZwcG+b1AJ3u0TRHQdjLcLsObuV+l75AekiKQT46E0OAZs6v7n0lK7i13DL0POt7igGFww6EDZwtnFR22kWRXt+XO37Bwbx/BW5t6//Wcntsa2hWO/f90C0opyaY5Csoe6ZPdHGjioRAd5I/DxlX4RFXLZgl2F59OXeN8l0KMmPFJKHedT3/8wlEclbnmR4PrbFVozmJTP2pnYuC4far5EtUGlwMbNT6dyKPlZ7PmN/9yCJRh9WQFa623B8qehVhwIunBkyncajumUs/z8v4db69A+8+I+iEuwe2n4KsgZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=BrWSMp2Na05yQOP1GKY8SBzS5AIL9whL90yuyiFcCaksEbAPqZJK3SA0aMs7ZiDt+L9BL6D+BUpOD+oKHiknZru6RvDK6ZVHmaXj11Z19a4TuhbEJrHEhOmXodVkLaIwnxECfSaN5KJMBt/jGwyKqzDiuBGwP34QwQaMe8kgVZOenj6p7Mjn1VStH3jZ35mt9UK59UXI37Co6vcudagKZVKfsyLBaoyhgOx6dbVcqIYWZMqS6POiVkU19QcoHVnB0QfZ7qSvFbcNCJP3IHStkBZQzrNSrzY0qoaA2lL5zAllPheSmbu8L/OY1rH8Y+ZQCUbuNCw8ctRDh2IgMbefUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=SWZSpNZKNK2EZGLIg8oB4oa2c6a7slwwzEXsdQ9eOk5mQ6tk96GKqM6qrHrTchcjifBTUnnegahWfBL+o6qqExzNLSCBidqA6ipiuP4Dn6pyKDhBDMbipEeDrQ1s6EaP//BRWKk4KfYo2BuyjoccVMxuHkNJOZA5cPlMJ2ey9lcGU2Y5tM5LgJN372tTMESiqJdPtAlTwOZsd6v7eg8F2lRFgg6N+MDuyMTtLgYS+ZW4vBSzcYk/zb1e4iJbALoNZP19tqpk4e7ha0aQmBK8ThbiOSmJWsVPG7XwRGMTCZnhwv7Vdi/RrAMNLu9L59zNIVRAM97IMKRwkVBd515WXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:37:46 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:46 +0000
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
Subject: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
Date:   Mon, 25 Jul 2022 11:37:20 -0400
Message-Id: <20220725153730.2604096-3-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3c9c816e-e990-4967-673b-08da6e539f85
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvaKVNZaa6fj4t0i0vcrio8Sdb6jcRj2thNfZtQsJquxne0HHASIfjueLP5J1XYULPFQstngxkXoWIWcypUAedG8lz4XYRkFg1zJMMIIm0gmGg5B70BYIP74mLwG8aEqMIKtVJRgrTrxW7+UkL9u2v08B2GkZYqWB2hDgz3xeGdjeim/GwcHz2/ci+vp0wR9sCFto6xMR63atAwF47oMc7kr0pzCJkdG69sAhinba5sjfTTsovhA+4F95ynETerd2IN/gz+dD4bYUNsyam1pMxIHfbH4aLr8XeWzUy5LPb+ZIDV56zQSo8598XJPmryr15x4NeXh1PNS0wq3zD9EMPPDnC1ZZ5l4RmGXvJamghmV1+CTPEZHIO2SOOeLSYHt7xMrLdFUWn9L0QF+mCW7GAzPwt8rUyC3UUIK45esThDHngCCEgZqVgfC747rKL9dQWyg/8X+iVecztPWT3u8ZBRofMi+FZSj/xZsAq4s6IT/pEJNH+nrh2H506JwW+bXgNrT7EbwCoDVgcifW5zbCj3Qz/aCxXAly/MrpHwPr2EtpEK7YCpulS0J04X3DWWmR6XeBoJVhGJvUAk9Hmiq2pXiFbbByh80+3iU+oL/FQocyXTG9Nei9pAV76hhcx6zmnV7ELqb06nQlxosQjo5G9bRxYO5U2PWnHlx4l5BYVSj4aeppTjDk0RM+k74cXPlAnkkmElSMNpkfMBJHTaouhjW+srtwNYq0vrMdKarjSRFg2KHivdZvrRA5k+CP25Icp0UFBHKsmyFgcf9DYOpfH7qnDIfXnw3BBk6xJVaS1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(110136005)(6486002)(4326008)(6506007)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(38350700002)(26005)(2616005)(38100700002)(6512007)(66946007)(1076003)(66476007)(8936002)(44832011)(5660300002)(107886003)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?niCdWgx5Jhx/ZFUVR1/4AwQDURHUVsD6SNvdd8ZU49iozm7PYXBa50iUYPa0?=
 =?us-ascii?Q?faQh5c6AANMiJbpLDpZzVQgZHVP/gJtOCzvMjtRaY9i6ba2qgQ7GmKKM+s91?=
 =?us-ascii?Q?F8stEIg9/EyKjNY4LjR/sL7xPSVZzChsajSQDKRsqUUPNgOpm6PqLuJisdfB?=
 =?us-ascii?Q?6qL+AP3iSWjxG9Ou6VlqCiotePAAUM3wTfSRjYzfKj8DEROJFfkQkSr4rpor?=
 =?us-ascii?Q?UddB4raRzbdjfYGI1JMoDpCibJeJKiSGg/lMMvPwRM+eI8ZAr/7W4PxJnG1M?=
 =?us-ascii?Q?lAF3hJRYmZzHUZSxoi87z0UjR1s9hEX4CvKFU6N79YgyRu+e3xgzxrAO9yuu?=
 =?us-ascii?Q?ffBKP3vbziC/PVZVArtjsD9EcWpv4OyIX5movqziqsSEyrzWwi+zdgffdSdO?=
 =?us-ascii?Q?R+HUUcfoMzwqDcxjgr/cTqVtjz5iqemi5Wfbd+4ZD3r5F7YGrjwQA5eh6HOh?=
 =?us-ascii?Q?ZItDKrSVReoL61Nj71TtQBkEnZ1oG25fiJ0IHNc4rZI7d+wMHagw39KOLiUP?=
 =?us-ascii?Q?XrZXlmSqInOue4SlQUnpelDF9YmMd8kLoWo4qzsbNkk2k9NoQSUi79oehC5L?=
 =?us-ascii?Q?1b48PmeJJ+htTu7KMCO18TXEtFmF+hZ+D6RDMiFPoPZznIutsDhaRQsbxUio?=
 =?us-ascii?Q?UIZQKuQcfQAD8bYKDXIz82KftKJPf9xXgm0K50GoDDkXK8h4wSAkWeHNer+T?=
 =?us-ascii?Q?Xfq0HpIr01b0Ze9HO9hGJpjVT1As7y5AWC+h3egoudcacxJecQMBqo7U2XUk?=
 =?us-ascii?Q?yvTOuGz+qTaeNapWOPicluxQEBOK7lg3LQtpyZvkBoKkBsuVNVzKIAP+TGPr?=
 =?us-ascii?Q?wYHcRTX0Kx0HJgdDcHL7pkjsBNA+WcmvZ405HQyUkUaItn7wI7+PrDzWOkcW?=
 =?us-ascii?Q?ltxs8vjfjUaeP0+dNRSZENCRi78d+qEe05BSMUqhyKxnx/A6qB5pFy01idJi?=
 =?us-ascii?Q?jPq+ISZyQCmM2ZFgX92KHxyKXeETryok03x9sCVxVEDpZPqqKDSnqQqc1uST?=
 =?us-ascii?Q?tLlpmLAj505/G9Jrx8OpWTKyjQq87SOT5ehGMh/+1jE29Z+4n8YxKIoFeQ+6?=
 =?us-ascii?Q?d3IMw1J7c+zoq3x47uaUblXk8e9NGVKfhGm4UdUBxvp0yoWyAzN5VUhKofFI?=
 =?us-ascii?Q?Y1TIFvG+zJZJPGOPPM9V38yOf/xL+JN8vEGo8eylzpeNSEew+b+FnVt3EcR8?=
 =?us-ascii?Q?w1HE/9qcXpzDHEq4FlPSSgC+aWJi2AXmmZ8uN/ok3cVH3PqOfJUCFfA4ZTbr?=
 =?us-ascii?Q?XK4qOXsqOWvKDDmtaWBhvlQ0D9pTUfICEWfJa33w0vKx8+2IFk1wLxBVV40e?=
 =?us-ascii?Q?r3F7elDGu0t01h+2yibyk7oo1zDu5imcFI9fUcDv4v5x54GyqTfqkNP204PB?=
 =?us-ascii?Q?9UKN1PXZB7EcfDY/+T1/3uQVePOVhESux29wPo8uqvwPtFeye+Ur2EpSBs0Q?=
 =?us-ascii?Q?Frd6zQo5m2N2sGiZj5J4tfs1WdDBrDPr/rfwzOI7+Q9xh9aOHTtEZ6CpAUik?=
 =?us-ascii?Q?0weOszKrTynzmQWt+A0yfDAeMedDtNeMDQMNpKBNlFObjp1FNiPrSKNH7Bpm?=
 =?us-ascii?Q?LJe01pa9rbY7y9T4w0B/4Q4/skG3KBwo0yLBdjrbcOskg/uu8i3x3xdZutTb?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c9c816e-e990-4967-673b-08da6e539f85
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:46.5882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRWdp1C8zPqOwPeHO5ApiBZfwLOHAwf/Nb+gnwlR1A3uvMLxxtXWb+vTAck4na6x/ekzW4aVoEOQK0M8ge4p8Q==
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

Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
operation is supported.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 1 +
 include/linux/phy.h       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..b08716fe22c1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -344,6 +344,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		caps |= MAC_1000HD;
 		fallthrough;
+	case PHY_INTERFACE_MODE_1000BASEKX:
 	case PHY_INTERFACE_MODE_TRGMII:
 		caps |= MAC_1000FD;
 		break;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 87638c55d844..81ce76c3e799 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -115,6 +115,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_25GBASER: 25G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_1000BASEKX: 1000Base-KX - with Clause 73 AN
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -152,6 +153,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_1000BASEKX,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -249,6 +251,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "trgmii";
 	case PHY_INTERFACE_MODE_1000BASEX:
 		return "1000base-x";
+	case PHY_INTERFACE_MODE_1000BASEKX:
+		return "1000base-kx";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
 	case PHY_INTERFACE_MODE_5GBASER:
-- 
2.35.1.1320.gc452695387.dirty

