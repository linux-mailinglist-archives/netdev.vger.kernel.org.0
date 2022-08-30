Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1A5A6F51
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 23:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiH3VnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 17:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiH3VnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 17:43:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192F58B2EB;
        Tue, 30 Aug 2022 14:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNFF5th502yDqKIrDnyMiwCp/gW5GgdGstDlxi1dtVQNZtm16iqFy0iMljANxXShFnnVp9tHaz0zmVLK8JAcLnwvukqVt9vxo4pi9Enrux9Y/bZlwOG56if79IbFeqLq2xyxi3K8Ziu67FIlZdbWOdoI/UMtXtpwJ8ltT2sSGoM4OQ7kiHegeyts3+6QQrXYlGpLFGOX2Igd0JxIzJTV7rNFYzZS8HwbmgTwP5YEgwN97SjBWRN+r6SNiqsH0XcCQ+wH7mfuHH3YgqbtH2HBLFhg/BdQp+2fPtLe6k1BR5x30HDqdDlk4EEMvJQxlRQrc3ynFbB5Jbds6gbDYRgUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3N0emumBwA2KpXr5l4T2NhMqGVZhZOEUo169dTn3X4Y=;
 b=ZarxRS0AB+PWQ8XvcNqnkqaNZ37hVRr1ZArEerXyIdzlfG5rymspucixw45BKsYAzHarbg3D6KjpgxxcxKlTEnUN6yzzCqqbMSpquo+taUrRvhzETeJI908lqAhMVAMF+9qxYtO/OqcwgyCjPcvzpsjiVqE6SVz8+WlwXDMKnmLJRQGsaLlFYtTDMP2YFWcq8j4PJwXsB+N+XRrB4X+nVxgOCJ4ADNYV7sGKt6dKxerQ4dZYXhEMvoxMyzwyDVCZaN42sPICUSEoTXJfBoccCBKiGCPCpXnthRol9A1Icgo9101JMti9MCZms7/Q+nQXg0rXx6GM3ivhMQ5k4XarQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N0emumBwA2KpXr5l4T2NhMqGVZhZOEUo169dTn3X4Y=;
 b=lE3xJkop7Ki33h1KvolfQpQD6R3IG1lTL2fX7hVWjHMjZVbmWoiF+xrA/cZJpfzLMobE+pv8u0j1pdiZNP99i9/KPImAWxwQPvPazeRf/xEU82C+OGdNxAqAjn70MGUOTLTV8U6keITpnD2QM4ubBT7FGMmfXrQYEWKqXUJPhh+ewClNrahlxY8gyFneSTQ9Q8Gm4NVA8tg1H6fGrVqYxxRf/UMKpml+hsGls01CrCN/AeoCx788+iaq/NK/fZzV1p9GIv4mRqj2RW8l6l3X6DmrsM74t+JDvGPr88CvYuU7k3IRywHvlBbhPlFrOuitozIVg1jBzu3/fIY8Oy9SvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7987.eurprd03.prod.outlook.com (2603:10a6:20b:42a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 21:42:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Tue, 30 Aug 2022
 21:42:51 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-phy@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v2] net: phy: Add 1000BASE-KX interface mode
Date:   Tue, 30 Aug 2022 17:42:41 -0400
Message-Id: <20220830214241.596985-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:208:32a::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f475a5c-0a91-4918-2ed5-08da8ad096f7
X-MS-TrafficTypeDiagnostic: AS8PR03MB7987:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zk80G4UR/XrJ1r1UKewzY6Ah65/tBvPtoZnRr4N139+IwUm87cNZ53X5RJEcydnKJ+JDPU1hGJtdLKRlDZ2LGQKAso4aAjG/HTfQmw8jLOhP6qkJBuJmOwiRV92b8Lzgy12Ivf+ZQ+LdVn2o1tEgBCk2vSNqSEF8Oww67Ij+TT+LgUjpvpKbJiqDElhArC7nl7hW70TFdRYWzj8iYpoKyl9SEbvoUZvQDv5GQ3qNfoRicSTzWEUBbnttSsg6dWg6Kol0lvndAV4sDBsXIbk1SR7JxalZCORXRCWKKGA6aL0zG64RITrxonCXSz+6R6qj8Jx9mtZOXA9PC8Y/bbY453jgpg28iApuRfs8GiEGd2l+rkJplixxMRPZGPBrISpLBH3HQfxx+W/yFC1pPp7QD5jtwzvriOoYtEppAVFtA3cLRHivD2EsCu9xYrPgWrj3J7IwmdbRzA0fKewcg1IfwmTFx6RYp+vRWzVVwNLlGxhKN1ySaFkyWKH8PYcL8qev84NVQ25zicUBCk8a59waYFBs9jjDMtHiNt1sntuxGIddOJRcVjVbcPle5AeCJy0migGWhMxjxZKH4syltvkVfA1SgeOaTz06k8q+nJAF1TESd/KM40ISe8W3qVBMctYNohTZw10qgitCwjA+RvdIZoXZK7p2u4q1xH9pYya8AwAgIwtbVVqRcdJxZ+yrme8JKhCInPJaAKQooUAtwrRAFZVN2mD2YnqmcMCbvUXZGap5fOy0mbVbsPWFVb0U980ePn5LOeBSnbwctRAh6U7vJoBbB5DuhRmipmu2hb5p2bQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(136003)(346002)(39850400004)(66946007)(66476007)(478600001)(6666004)(107886003)(6506007)(66556008)(52116002)(2906002)(8676002)(8936002)(6486002)(7416002)(966005)(41300700001)(4326008)(186003)(5660300002)(2616005)(44832011)(83380400001)(86362001)(1076003)(26005)(6512007)(38100700002)(54906003)(38350700002)(316002)(36756003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4vReC0+poS0mSf10UytHcwAKsopsdgUIcZ75u44S/CDKgUOEAvKXHsH98nk?=
 =?us-ascii?Q?WNQNdSJ2UZ8cIWuPWDtk8PrP488+xjdMSytWbMbpf4AGVF3RpRW9vANHpPGe?=
 =?us-ascii?Q?rxY5BojhLGk22Gd5tFZ4n5yfaRGzgtDTpmSyzukUB0F44RLmMUE5AV4wumMp?=
 =?us-ascii?Q?6VAGltgC+lMw88/pV/yYUOVtiYrX0WVoVVd9DmBzOts7AAlTWPlkjJBX3zSH?=
 =?us-ascii?Q?dLftBQ4WYqU4q9uQ1KuYAcXIRDMGlks17tCdduGVkLdwJGY5iFiLtzGw+Uy5?=
 =?us-ascii?Q?y7PnZ5gxwvpxFHty5LbTR1b3eGn4PuMJ+j0NYobH3DLPc6v1HIe48yFanvsa?=
 =?us-ascii?Q?uPcjFFTZI0ubxkyhZNCKu+y1g/pUS49pOvr7StU/a1c1jv0Ii8DUBR2Ux1se?=
 =?us-ascii?Q?dBcHj4+NJeHU8Hw5HSn/MTVMvbx4UVR5OtiwDuOkwSjd9lM83yX+gQ69YKBd?=
 =?us-ascii?Q?xHTMb9rgPvHcsmBdUjF7p47BLKn22Cstyk6/71oKEHGseu96BHVyToIIo0ZK?=
 =?us-ascii?Q?ZIoWpwcssdhV45oueKfJfd8rID0LlTGoZE5tc1JECSlPjT/BDuYmHdOhtXvo?=
 =?us-ascii?Q?tJEsCyNva8mmiCQqs0x/jg8GMfkfjmQuMIa2uqwup0yjcwvL/JPAhbEjvBdP?=
 =?us-ascii?Q?MtT6UWbConW8gffZ/LD9/JQ1Av3bwZnTzxc2k2ASN37fIFjfrgttOdBmpEdd?=
 =?us-ascii?Q?yYrbLbh4eb1GjnJsqnoVm4ZH8QZIJoZfoFdAJelUC/Ng8PMBjpgSeCVXxR1A?=
 =?us-ascii?Q?Bqwicsj6B0IDkPwQgJqsCwoSPpW2D/e6DHpbpn4yt1z4jR0LC7nb/RFxxDXi?=
 =?us-ascii?Q?EwGc8YnQujwKKzDdWnFW23DFrwZKG/yCaJAUMrztiLmIMRuYs9bPEzfRnV53?=
 =?us-ascii?Q?t3fSmdLk+KlGK+1bgGhUmYr4i6QkCrHbcUyyEGRIgJLMhg1z/EqNo7UYplk6?=
 =?us-ascii?Q?NurYN65RGgptH9YTL3MwP8BMwfl6mSIHkDBOGKLjJYLd6yuMFYT7h2Vj99lw?=
 =?us-ascii?Q?Gd+0ecOmes17aoea3/MMqds2x4bVrp06lXrHrfLtg3JJlXMZxOhIUz0KTaw5?=
 =?us-ascii?Q?JybIzzdbwvnwCl83qQ59rHyAnDttdU/2PDrm+1ShYDkeFdKkPsgKBCp/mr7G?=
 =?us-ascii?Q?NIevf2B/qXKwRRlwXVZVdk0F6hVLYkFCJNyQO4/dTD5D7R1eFRHeMR8Fq7y8?=
 =?us-ascii?Q?MxeCDwdzWU5EmdgiYP2N9TPCuNv23H82pURwhFn9edh0Jvnzjr2BvmF1MegK?=
 =?us-ascii?Q?LF5pO9Y8OWUVLlymOB1pV0h0u5My6jOyhUG4Wo5U7PFefXGhb6f2um68g3N7?=
 =?us-ascii?Q?LBuFbVltWG4EPmff3riHIs3SmGoMLayv+8AxcxOFBbB8jcxZko9wrJSc2k9O?=
 =?us-ascii?Q?4LxznsIaJcs/wg0L/KDyr47MwYJW8aNQv8Q4kauBDHmgZrVhXku4qYTkNJvO?=
 =?us-ascii?Q?Y/IHHbzTxdT9xpXIDgb4AmznTeHp9ESYNmMoD2eMeRyytZpNB5VzBx+lbDxz?=
 =?us-ascii?Q?45hCbCs+JcdSDiIJ643If1QEcvLtYPGIJMgSTTLCjJNBsqOLNcniVoUIUV71?=
 =?us-ascii?Q?4LeJB7v5BNsC5SSUKwdA5VPMfCFm/w8VbtsMv3qEueweRpRFmx65tUB9iV3J?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f475a5c-0a91-4918-2ed5-08da8ad096f7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 21:42:51.8208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1hLRpBo2hfEwxaVHKSNfd3t6ZdYB6twrBySR2+csHTFPYNsgsCFdHCIu/OgfLI4bfMDLPYZe7rNvp4r2tDQZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7987
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
operation is supported.

Although at the PMA level this interface mode is identical to
1000BASE-X, it uses a different form of in-band autonegation. This
justifies a separate interface mode, since the interface mode (along
with the MLO_AN_* autonegotiation mode) set the type of autonegotiation
which will be used on a link. This results in more than just electrical
differences between the link modes.

With regard to 1000BASE-X, 1000BASE-KX holds a similar position to
SGMII: same signalling, but different autonegotiation. PCS drivers
(which typically handle in-band autonegotiation) may only support
1000BASE-X, and not 1000BASE-KX. Similarly, the phy mode is used to
configure serdes phys with phy_set_mode_ext. Due to the different
electrical standards (SFI or XFI vs Clause 70), they will likely want to
use different configuration. Adding a phy interface mode for
1000BASE-KX helps simplify configuration in these areas.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This was previously submitted as [1], but has been broken off per
request. As it was not modified before this, I have started at v2.

[1] https://lore.kernel.org/netdev/20220725153730.2604096-3-sean.anderson@seco.com/

Changes in v2:
- Document interface mode in phy.rst

 Documentation/networking/phy.rst | 6 ++++++
 drivers/net/phy/phylink.c        | 1 +
 include/linux/phy.h              | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 712e44caebd0..06f4fcdb58b6 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -317,6 +317,12 @@ Some of the interface modes are described below:
     PTP-enabled PHYs. This mode isn't compatible with QSGMII, but offers the
     same capabilities in terms of link speed and negociation.
 
+``PHY_INTERFACE_MODE_1000BASEKX``
+    This is 1000BASE-X as defined by IEEE 802.3 Clause 36 with Clause 73
+    autonegotiation. Generally, it will be used with a Clause 70 PMD. To
+    contrast with the 1000BASE-X phy mode used for Clause 38 and 39 PMDs, this
+    interface mode has different autonegotiation and only supports full duplex.
+
 Pause frames / flow control
 ===========================
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e487bdea9b47..e9d62f9598f9 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -345,6 +345,7 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		caps |= MAC_1000HD;
 		fallthrough;
+	case PHY_INTERFACE_MODE_1000BASEKX:
 	case PHY_INTERFACE_MODE_TRGMII:
 		caps |= MAC_1000FD;
 		break;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7c49ab95441b..337230c135f7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -116,6 +116,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
  * @PHY_INTERFACE_MODE_QUSGMII: Quad Universal SGMII
+ * @PHY_INTERFACE_MODE_1000BASEKX: 1000Base-KX - with Clause 73 AN
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -154,6 +155,7 @@ typedef enum {
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
 	PHY_INTERFACE_MODE_QUSGMII,
+	PHY_INTERFACE_MODE_1000BASEKX,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -251,6 +253,8 @@ static inline const char *phy_modes(phy_interface_t interface)
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

