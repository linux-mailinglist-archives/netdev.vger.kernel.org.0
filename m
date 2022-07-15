Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3449A576960
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiGOWCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiGOWBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:17 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50063.outbound.protection.outlook.com [40.107.5.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077D88BABF;
        Fri, 15 Jul 2022 15:00:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4Odz1u1mtSFDLuB5xAqFaR8ZlElzV8RWgZ43BB62NvKCKAHzxQ1klaQALG4CL3S1/h9NNISU4AuA1KUMtQD0xdcxbN1GWaHKTLAAIxhjEc/WwYUICrKLa8JV7kaBMjYH4g8Y1OgRrr0a6EVvovLM7wcItUaAX/W+9f2PK2gaJLT0BWIHqViJn9/roXsko95wbaHDdc895Ov7GETufn3rs0YxYzF99XVVzMBYFSNpBC61Aape8/GTQhOzKd4acqge0eXh9Ns9416u9esANlImUeJudR0oo45Yo55vnYwRwBAPQBvXkJXx3tNWqlEQQKu/yUnzcVpm9cKV/aJvY5JSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JC/rvL3KQAs0sjx38prnzjx+8Ar6/vqdJeLXGu9zEMo=;
 b=k7ux8tWNT6Upx6piIw3VqiHwZuxnHgDzswFyGZVhChpuY+gZWes1hPSCkmemf6+MQDCTmM/9ckuxXNWYSIEKHGG2wtTxakd4/nJhLMwPglsVb0ScZXKnP6HVqM5nHeDD7fTkQDV7N5oxbi1Sc95eIQr33/ZRLQm+/H08DKq/iS7TCKqof6ySQwYA/TeI4Lz8ht796ycMshZRd8voPvQtt2IrrllecZBkx9gX3tkyKzFDVKOWHAH9JsSTbVfhXkiXQLBwwmm5quVr0usQkx0TqE1DuMXgQaY37cxdD8dlpVxECwCll7waklGqvYAIZ0Ns/gOLpcebdWqgD7MJQ34Pxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JC/rvL3KQAs0sjx38prnzjx+8Ar6/vqdJeLXGu9zEMo=;
 b=xf9fIbLIwz5urWgx/0jnZVqTDrjboDWdxrE9JkN1zCPdbaunlN9qfK7nDL2ZAzl8i/yevYiCYaameG/47kgM0ewRvnmcLDy1LsGzKwbcp/MXzMnuvPyURjah12KGau2nfneEnPsFC5ywxFlAZ7NxDPiMbvBgt1575Cg7apuMv3kC84B58pBjIgUFJHnu6MPdTePk4g+Mvr7GyGO0++Qal2b0ZmLjN6Q1lRRa0mpWCKHwnETzr3hQkL+v1OrFjBbIPI3gxJDejcbcmvopcQE9OwWJbYdzHUcp3mD4n9zN16Twr0ZtmFBHMje9DcaCZtgmHXGlAQkFYuOGds0uEP6dMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:44 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:43 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 13/47] net: phy: aquantia: Add some additional phy interfaces
Date:   Fri, 15 Jul 2022 17:59:20 -0400
Message-Id: <20220715215954.1449214-14-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 94ab4026-626c-40ce-9d7c-08da66ad76fa
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jasf0o+v50RGla61eSrMHmRi+3VQ4pGGoV3dUz4/DTXzH6YO1pO4nRGTT38cOAQtZ4NHEb6HtDEf+qb/lKNx7ez1Gkrri4mGYZ7AXzOuFzGXcRPZhy3gTJikc8w5Pc0NnCyCF1S/FwWjCrNeL5WGWLx9pI4FXKglull6WcD37WPTPCncQ23FWmN6TPGNoS+JVsLI+xdwapsb57TK+Z2kI7ZED5RmQfBffyMDtcTHDGrgYbd+xyPVq5J/SGjKfTT2hIE5g3fwHw1LDxw/thDZzOGJNTadV+JyDW2DU9tK9iTulGhiU1ibRMOgNPKokzncmbarlo6PZrsNEBJBv5/yVainxarpdcaQAQAK+yu6Rph6rkSP/zAxy/T20bDwLe8AxzGauhc76LqnMHgDLrExbOmAqHttSJrLTjqaA1akfVsHKlQgymRntT2CgSSxSUL7c5gmbYoKhLUZPW+zZiGSsrzey6N2suP98wzIqR1C8vbLtG/R25/9QHisfuyRU6vXtlB+A4HkAwK7wvMOF28Fj1+ZhYNMAremB3gripATfcBJEtUzBqHuA2Qc/+J+z4lj7b02uOO4rGrZuEEMLmu+zY04FqTSUZ15jO8mB0Cadjq0kYH9FJliiOcI2L4hfsGjkyHVk8QcCtGcszPb2mZqGxZ1ObpA5otBkhQPiNQwJeJKgA6sA2XBBD3dEfowLknl7QOkNz1U5lGKN5cdbZCxHp9w1rFsEqwP21PCbS4zmxNzWd0p6NFXJyEFmXt6s0pqtwtrEouHxYdNnnYHD+sK/uPddB2hwewayh81w2mb+TmFCHVOr36LJsbWo6eKr1ii
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XBTtIbYbVAtpoegWlwYyWg1ciKAQDZRMIeMLMKHDZ7ozAzJT4gQp7hleRcnt?=
 =?us-ascii?Q?53xjp3D8VITyCczmFE8mZGoikM0c68IV8kNxnvFs5uFp2OeUAXG4Ak883Mgj?=
 =?us-ascii?Q?5knzv52PyU8dDTUYVnJYWxxhmZkbGD4OpgGvBkHroFlRY+lIpvaoV75WUh7w?=
 =?us-ascii?Q?z0mIZ3qudcqEvcaefgzuneYm3XkRIKwZFlAszEQ2qzPics5Fb/JKJBJIAWV2?=
 =?us-ascii?Q?xpymy57OVmvBzYd6OIMTftFjzam0yIuH5cZqhJGTfSBYYX8mCJTwmHXKpmbr?=
 =?us-ascii?Q?WKGYkcLTqFyd2U2Ptd/pVlyFAGyyeuUVlx59VVvbVtox37gvG/zQRwGJ0akr?=
 =?us-ascii?Q?aWG0U8MoJb1+yw5vmBot7vb86N6rwQIWBgVC895v1LUI5YYnVffnlUiXhEsC?=
 =?us-ascii?Q?9R08QZV4oEBB32DcIMr3+TqGrVlGIonkuzyN9pfrAQlrUyyaiEj/kBbncUpU?=
 =?us-ascii?Q?I0skYMsDdqandpqBscjyHlqByVKkbfodtMG+PHHn6Q1pQi8b0WsexrfOWsJA?=
 =?us-ascii?Q?MhWxmZLosz+x2PLXnhuCi2t3e+SKC0SqgRZEmmRW/2rktwJcRUd6+oLSSlZU?=
 =?us-ascii?Q?SvsA6at0WY1wajDVQGLLww8yBjyYq5lZR2kkxnTiSpL3ns5qjWEFU+detBKm?=
 =?us-ascii?Q?WdTP/wLYzNApVEWKK0fFszCG1hUONTbcvx8+DMgUWRUKpAIM3Qmokx9lTdZ1?=
 =?us-ascii?Q?tatIrn3xZ+pFiPhSqgI6/rjvvbBn0LErdTpgQI2k90eZQmqkeLIAZaxh8N7U?=
 =?us-ascii?Q?onpxmDwwDWkozhHRTRY/Mw+Xvs2ZOwxlthPp79DTpMKbmNHw6sjLo4c8559N?=
 =?us-ascii?Q?MPUiZS7MwfpnzrE3Btk1J1DzLhj9rg34w2fOkI8Wm0EA9vsNBoQPYJL2KVkg?=
 =?us-ascii?Q?FiSsEdqDbCNANdsVxLlPEUu3FXErSx8JDFAP7lUA0dLzedkNaxFLk+He4bP6?=
 =?us-ascii?Q?Z1vmThzQf30yH5wrQXI5LXzPRR5Kx8FVKLzV8ES7Nv5P0hwtocsBmWgn/J7x?=
 =?us-ascii?Q?06ZUUT+bGoZvPV3SVDzk+rm6RsRog4fO5xnu818z41i2uP++rPjRuMG3YsGB?=
 =?us-ascii?Q?UbP5IKgdHKnzGrbbziClrTZtTHdosySZUMSnc1YAs02+xDsoyPSegxaffBdz?=
 =?us-ascii?Q?A9xLhOR/r46/4YmKXpWhl1+00dg22njTGldU9LOD5c9ro6x/YCfHJoAdX7PS?=
 =?us-ascii?Q?XaqtKiuAGZvLMiJaAA8SMtIFiPcH27Z0FIBj+vQNozWmFpq0QeCHXoHNB3eF?=
 =?us-ascii?Q?et5OpfkSjDZ3Rxud3moCDZ7fqsT6fOs9LEOKMY28mgUon8l9vrP14cIX42BE?=
 =?us-ascii?Q?i2eYxbNoxV6cESs+w2TSeFuDz/gg8KZoofBRIOmEjwzsQ6oJfLiGr7Kk34kw?=
 =?us-ascii?Q?d/Lx8K3U521RP6V5q5FkofHD7trlfTBGTOjpMxLgIhRJ5bZHlS5ouPTtpsjx?=
 =?us-ascii?Q?5Rc81dkRmp9D3T5wfQ2DJUBHPsANWcjivbmTn65/A+m5FHEq4QGHWgEV6S+D?=
 =?us-ascii?Q?ntyxrujN0oV86W9/6WuXrgPCH7nMIfuDk1UIEmvRQviTe3z4qDjtry/bd9FU?=
 =?us-ascii?Q?yB5Z0OUXEzMddeYa/sSEXbeDX99ytR93gV2CBtXz0H1d+u1DEVU0zrWYqDEt?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ab4026-626c-40ce-9d7c-08da66ad76fa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:43.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBN9O5nA7JlBwRcCkBIYFrPSgFJTDhfz4nq0ovGnRvxHMjVhjdeIaGaHB22S1BC+0XSQSiD9dsSboLmo6RjtRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are documented in the AQR115 register reference. I haven't tested
them, but perhaps they'll be useful to someone.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/aquantia_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index f9e2d20d0ec5..0a2f8c4aa845 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -28,9 +28,12 @@
 #define MDIO_PHYXS_VEND_IF_STATUS		0xe812
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX	1
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI	4
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI	7
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
 #define MDIO_AN_VEND_PROV			0xc400
@@ -393,15 +396,24 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_KX:
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEKX;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
 		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XAUI:
+		phydev->interface = PHY_INTERFACE_MODE_XAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_RXAUI:
+		phydev->interface = PHY_INTERFACE_MODE_RXAUI;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII:
 		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
 		break;
@@ -514,11 +526,14 @@ static int aqr107_config_init(struct phy_device *phydev)
 
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEKX &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR &&
-	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
+	    phydev->interface != PHY_INTERFACE_MODE_10GBASER &&
+	    phydev->interface != PHY_INTERFACE_MODE_XAUI &&
+	    phydev->interface != PHY_INTERFACE_MODE_RXAUI)
 		return -ENODEV;
 
 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
-- 
2.35.1.1320.gc452695387.dirty

