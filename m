Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72DF57AA9E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiGSXuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiGSXub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:50:31 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A48532057;
        Tue, 19 Jul 2022 16:50:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ditGNTEa0vIlSRicM19M8c6teaSI+tw6OJAhv13OD+jpa9xoT4K8aNH1nlXe4tzwVP0ROLEcAhHm0mU7vY7tG594MxzsjuHHkVbMkF7p04VhTDsUWhysn7TPn1lJoVhItoxOpVCjoGVqo19FrtmBb2QxWb3PVoMQxsBOemOCoJagQKU9OfqYDxEctaFjrQCh6CI+lCMTqNdlBFsJHzEBy9/vP38X+aQs94dzjYw/crjgGMzdfI3uDe5Z39KO8M9iCUWv1wlEtlkfA5NpC0KcGoGolSyqlyNcAyGscNM2i6g7drOkhIFOusgtgVA292/79onjT7sDCFaicHkM2KZijw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=Zks381DFdugW4NmhMBSSpeeHTMpVVEy3LOZapfGH7J7jYx24bjZtE1XoQEJx/E9pzi7E0UFVymmdSTkjbEWuVTIdbm4eNb9qoyQMJYr690oFBiwDey64Bc957Oxy3F+UOWlRfBo/RA5X4Y3sutyiXalNQzmzacy3xVZ8mQKxQIR4KmgRJSUkLMWHn24u1jCGzZaRWkg/N9QpZ4fpt9y4+EntEYHhH867rXvQ0WNdVJN5rQbn8XOmG+Ut4A9/HINXD5YTtemrX28gsjN2Lq3GQ0GofHILmQ2U7syZO8iTwRpb7vQ0af0fDovPaBr5fJpijRO6nnUaSxMEzY54qZ/KDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVN3RE4YPj3naLmLY7q0GTywVhKdcECxcsV/A7K37bA=;
 b=iWGIXvmHZypiwKrRXjX/dwhhf9cGhs/ueGr0uXzS4KRwmJKQ2geW7xm2LbLUDJL25uEabgl+YKgbW9vPnyYFqR+SlA0Qpoif9rMLUP6ziYtTmX7HLE2OlSZSxMT4kawHEvHy6poGJCfzxBlR6xqytjzLBWPCnzKv8czgvsgf86uNtuNdhuyuOsGN8z3BoznYbnvehen0ddHQBWVUDRy0JO1l+VIbr0Cl3I0JeVTcLWy5M750p5l4Y4Eml6aI+dnRQHhKu8Dw34ElLKjhAVVmNTPl9iFCc+JFolOVef3que/55dmfBfHPBhIlke2zlAJSMEnVn+uxmf8RuoKFvpnhPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:27 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 02/11] net: phy: Add 1000BASE-KX interface mode
Date:   Tue, 19 Jul 2022 19:49:52 -0400
Message-Id: <20220719235002.1944800-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2856a7ff-af83-490b-17c0-08da69e17471
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkFdIfjPHV1FQV60/825EArw68wyjdS229+UnIBbMkZPZllAJ9t01D8kJd9NkfOhp6Upszh2PhqE2hcBavGnvQmF10FfpyEFaT7nb88QLZI+WVQG009vwVZI5BAmY9cTgtXbZ9IUleRxlDG+dgFqZ0FjiRV9yAP12mpMnbHUAzArFCc8Hb/VGYj7Zu9C2m0F/t6rztj/pfaqvTpFgdtEBSN9+PvAyaWXOZCxAnPR9HUZ58J+d4RAvSn95VvpYYaaz+BoA1GLN6nsQDnp075btZ0yfteTZcooXfqLN2P9zPmG5iPbb8mMkdjUElpvPk1IoJVzz6Ubrozwu0ppaaGhRBRISPL6ey+RoVLutFzmnrWQud0Yhss3fMhNcnSVKn59o0i3tqfL2UUANjUZ8kV31Xe5KxAgDyKdtgZGQcS2VK7vn2j9eJjtLFOPSXtHF81AgivuZ8qieMtfSKdx77wLSfL30iorNBfWLpw9cDVWeaQNN74/T2HPe9aXVLQLyu+JvaC22mIQbJC4uSP1Bq69Tshep/RaP9O+2t75i2PsY8FsnyakMOaO3L3KlYPfc7oiUZeuLHkbPngwEK43Aq+mVYF7O4RJ5xT13T0PMahxaiWLOKux+Y9qEXoet/QcmJButUPaGcvIEfWee4qrN2udOtJJkBzMEMCViZhzgiSXC62BgwPBBd5W7infQXSIdygwYMemwhzajHgflsr1CC3IKFpOm7QebJbNN1kJFDLY6bLnhyFqrLo3oafR9GXmv5U3ju/aDzn8HjYHZ4L4TjykbBNa45+DujAhzs20/pyX+RiVvRvfUUFwu322NOKLasU+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/5446gi4+iJFAQp90tYDkiQ9d2zwhZwWUlHpxJYElQ0x9hSqR1wZdLWdvza?=
 =?us-ascii?Q?g5Hq763rVDpiqMcu9fR4QzV5ErDkdhVIeolz0u3+QpLohVZdyi8aQtQePV9S?=
 =?us-ascii?Q?M9TR6jgM89KzNGT6q9T56pCMI8nPo/qY7f71oQE23phJoBvbac4yVZVfKa8R?=
 =?us-ascii?Q?U5Ge5O8zTZrgRG9TX6sRs5aVHrOewjLz8uXeN5YfVxRRdGak02i+lnGJHL+b?=
 =?us-ascii?Q?6FSYKpotYQAHYvAz1165EHQYeMh26hk0fcumFi0qfrk+8I0btiVBv7meFDQZ?=
 =?us-ascii?Q?Dd6YP6oAa5Khvx6jyDCrLDKx1W+1Cy++4TM3r68HY263C2L9JqQGL/qoTzgF?=
 =?us-ascii?Q?cPOpcMUTuynxY0xNC5ZESmO1ffrJOohNkLrKogD/Fi/Nv8HuwIAmSImGtsNz?=
 =?us-ascii?Q?hPl2CLA5xYBhwokM1GKkdcT1hRB0RwG9DeC648wLNaEQvszvhcT2SB1s5N2b?=
 =?us-ascii?Q?xgBAyi5812FOibgOfcDi7d4rgFdpxFFGtKQuH503HTBHSbHKay7E+mGIaJ7o?=
 =?us-ascii?Q?W4dAuvCxRRhXGPT1/Qkxi6hBer9HF6ZsvzYHuzTcfaLOW/Iz+8PNuLE4iZ+D?=
 =?us-ascii?Q?JaD4Puu+WTvwPQb4w7Ef4e/QDubs0tzgLRRuLMKs0k0M25It6dlAO40o4yLV?=
 =?us-ascii?Q?urdRpqlrWozYBgOy9m4cAbXsbMgVLfiUIhtvubY6/FUfH3jRqkjfUpbbbBY+?=
 =?us-ascii?Q?XdLu68u5+FdQE4iCDNObY/MjTfEvEIolv5NfbkCmETFbqFNvH2ClpgOzgiAg?=
 =?us-ascii?Q?yYv7crFwvJqL+Bp2kVwixrVMwp68xTWJ18eO3SePxcZJmy36WKUk/GGgAFsc?=
 =?us-ascii?Q?C/LHREQPZjRDhXgB9LuxJJON7W8FpJFG/gLWkcmlaQ4VsPXKanulk7xJNXIf?=
 =?us-ascii?Q?fNbGmUISqDCKy2rBtf6/ZJhEwuwWGp8aq08I2E26jWOa/DqLLf3EsYFor+FV?=
 =?us-ascii?Q?zSr5+t74sWtiSfXAIn/588UWcO7v+igW0QixpbHLAVleifXbpXH3WvVDy4Xq?=
 =?us-ascii?Q?SannERxxIqJAeJ+fDMW6Lqd+OqJDaqeajam+pfG1/cj+FhwFfcMrMrUQRqZi?=
 =?us-ascii?Q?XLrMONsV6PAVXsWzkVRUJRnKxMcRdzaQGjw/sT+pnGabEFNmVpFke3plHED4?=
 =?us-ascii?Q?+rfrjgl8yMyGwfO478TYdXtVVFlRsKPEGmviLbEoz44mtc488sWCvGF43YrC?=
 =?us-ascii?Q?Bhp9sbk7r3L+wTSJzRH2R5gIGv6Ui74vzMrXdNqTVQ4TwimEfPIEkXuvZ2sq?=
 =?us-ascii?Q?OlSYxkBpzpKqXR32b5KCP31lzRsDRSeNKMQ6EYBlVXzH4DD0DaEU01YLF/bq?=
 =?us-ascii?Q?LJCYUX+RlW63s5m/1xU1f3EHdMBoKeMH63by2y6NZyRSB5b00qdeIjZm9SlL?=
 =?us-ascii?Q?1f+W7w22CoZJfpYfoM9nh4tLI2P2L8Pvdp/QtwOIBCJrPOcIoiUP3+VTIxBa?=
 =?us-ascii?Q?QmRcyynw5/qhsoRGvDjagUcx2RE9GGsip5gAWCnDg1qP3MnR/qDvbD2gJT5F?=
 =?us-ascii?Q?i//RxpOCn0EGHvXVtCG8XsEtLW3gxZjElTkjsAAmZKfi0MtNtG0jraVW7Vwo?=
 =?us-ascii?Q?nfvifrl9Lpi1ZOCK83Hfcs9GkhnzorPhTHNfH682tBK08XfJiR0iKr3hFmDa?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2856a7ff-af83-490b-17c0-08da69e17471
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:26.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+ZH0aqnDbtSh1bF49IXIUAr1/6gaKCHJaYR4AEVJKSuMbGkyxryaE9pl+MHx5Z00u6d0iMPhyFQQLgUWoTpRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
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

