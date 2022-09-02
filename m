Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D337F5ABA9A
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiIBWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiIBWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 18:03:46 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A124FFE055;
        Fri,  2 Sep 2022 15:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmZ86MgE9dF63+paFnZFKKUwGrQBjUt3ezVhIlHoJ5Dvz3iCdUv0kL8QVPeq43trACidMsWAALOd3tyI4xFFKv1Ir+nnALkdMbO2mCQmESLiMiI9U17GfeOmnD/lkUZU25aBPCZuPP05cMr8rmpyiMTbk3nxrfEC/BCuOJvMTlm0rHBhd6zWxRISLyA7DfXNTFgxdJQqmNgAl+tVyqzRy0I8kPhtXNxezimHIPz2sS90gOoyd4UpAeZDicG3belesb4MRGqckGFc4fnUoY2RKqtehjkSoPgkgF+2Faw96C+4MehNPOue4tw7cQ5cpa57r2aMBRJrq+pKwImLYqTUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lecyqEEJuZAqMbTypG/HNB9hpnpKr0dh8L/PGCVxwBg=;
 b=kV/mjFjSqQl9RKBbO5rRPsK41P5CIjinHjFu/hEbpR29ydQtZbucJG74797qJmWrW1GBs+/awa+r+Pk7NQL3ATPUeAqFlmDHYZbGtEgvwGxeBKEWWsUvkMZ+2dOBNE2n/cjRojOsuQfngcb7xwnUyzBf/6rgvU25whSbuxz0ihPHmR+kfzGlRKEe2/zQJZMWUYSVWge/7ZXlcstN6LAMH3wc5Gi8Q9SODNtdXC+rd96mFZRC3RsnqymZc9rvh42ngnarnXxPiXBGdv82dTTrTor5r0DTRsDuZ9CMtr3fID8xFtgAVXpevxsVrdHDcMggoeOqYzb//wXfg+PrLoYucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lecyqEEJuZAqMbTypG/HNB9hpnpKr0dh8L/PGCVxwBg=;
 b=i4Xsh1HuS4K6A+25mo7K2t4Mnrf0NyFFZshWSt3KOvMa71HNv2FfEooMWGNR3JfD8Tsr9CRA1NhQ6tO9YLDgIY6dBsbFVku+5/y3lNRkpDctL+VFwrKIBSda6Q4T+Rsp8VKN+QmrKmxhbwMSa356MjAvBZH31ZlK0YdxFpbE92LcmCUrcX8z9yIRenlm77c6p1k9g6iWnmrBwE7EOYgsjtLBoWf0fADDUpmAv5kvYc/TGR36VytJntT0/xs58hxl/NuNmE2Q/ZYaE91O96rrvDEca0JYsOYhoEUwWzfyDJhaCuV9Z6uL5WQf7vwDewNwJJqVxemQ7NeWXm/qlsTciw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 22:02:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 22:02:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-phy@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v3] net: phy: Add 1000BASE-KX interface mode
Date:   Fri,  2 Sep 2022 18:02:39 -0400
Message-Id: <20220902220240.996257-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca2a82b4-7bff-4422-230e-08da8d2ee037
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jRUkgv7TqvHCOgVxEG7rgZBXqlBn+qW6W+dXBfx9QD/j4GJnr7qnf04TQbWnyr05WElDZk3b6P08WakY9s5XDZq7339orL2peLKfDowQYcN4ev9C0kFtzd76nlDfeY9YKb8dkwMbmuZLRDySLc0Q5RuqH+ceNiYPqI1xmu39KX5MwVXkxTFOZ/ZoaWHtU4Sjie//B766u2evqlGR/PYCfdZ1vBn2JS6/Z6C3tP6JJZm9D4kw3e/G/LH975afdjJdCVrqB9ncUnEN6dro7VVOurU5Dv+SngpoMNRLaVqYhjuj0lgiFrMCNbgU3Z9t8MFmSEW6ssUG5iJPTlxxBxJ+PkR91oQ+YFh5lP3HJrg7rD8bi1WjhRKd8icrLlQjpi0s4FHojSV/QpeZ29Tzt/zyOYw2HU7skMuMg+NNTnYzhJ2dfuUPBozLX9RzIiLPPvXyfOQYVSyD6dFG6ZT1xHpBdtHcJxnOqc02cdlPLU8UOoorWalrr2HSbMI9vgCBRRUjpb+FiV3f5U5kl+SNMRQPLlsEV4dNzbhxuoMPCyr9l6BM6xym3cRwXAOe+9yWXGTtngVNtpr3BnKKqiSeCV4/bLvFYO4+jZMBHqFYF6HAy3BErCc27yH0vLzWHSOV6tmm76VkSAJnSiOe6i4h6dnVeiflZ+yXKkQBE0Pv85Jwy90Le8LRqpqGQ0RJlFgoybmEoG87sZ1aF1CABuHiuMntpQ6DhkuNFI7kFRAfDKsXC6yowhLnQZxtRFlf+ki+ishyIZKIhmnha14ZB9vJnp+RceT21mzTNGorIkvP7ReWZwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(136003)(39850400004)(376002)(2906002)(36756003)(83380400001)(54906003)(38100700002)(66476007)(38350700002)(66556008)(66946007)(8676002)(4326008)(110136005)(316002)(7416002)(52116002)(8936002)(5660300002)(44832011)(26005)(6512007)(6506007)(1076003)(186003)(2616005)(6666004)(966005)(41300700001)(6486002)(107886003)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+7iesahF9wcadaOeWbHtlL/xpU4XA7q4JRglPoukQJPt+Spk0WmL9cytz0EJ?=
 =?us-ascii?Q?IWoXH3DrS34HMwbRG4ulq0NK9rkpnm5JHLcZM14GNu4+k6ZJgfF7BU2PHKCw?=
 =?us-ascii?Q?fCwv9lyn1tSZEyRymKQQ5XwPyiYzZAU4N4mnI/iFa4h+h7PhEeA5L3tk12fK?=
 =?us-ascii?Q?hUfrukA7I7AXJsC6Ib+E4v5dBGPmYoPJP017SWaUcnPX3Nc3woR8CCDRHs/C?=
 =?us-ascii?Q?mgcl4LdnWTaydYNs6YqlnMcCJEQiX09T+UlyS0UxdcLt6acIdQZgFSMb8KZG?=
 =?us-ascii?Q?nZKjl1kxP6o4x4hkpMmxFZPHb3l+y/D7ekidTIORqy7i/OmyY5oe5DNJIf8e?=
 =?us-ascii?Q?WqvVEn4k9zwbCQ/wBYB8w43Hw3snt3RXYhDNAFiorHiEk0cg011L6+3YVmSO?=
 =?us-ascii?Q?bMqnEi7PcJawbc86Si2WclBDW2+GQSSR36vbrpW60oPPVOgUaZCcSSJ6mOQr?=
 =?us-ascii?Q?ygOD8PtoJQop4pEUvSj7UKCfcpiiB6vKmJGQB1dP/ep/euAf1B/c5/2fw9qJ?=
 =?us-ascii?Q?kU3Ol2tD6N5ln6EuWENZ4bDbYqq1ZJLc31FbpXv+obyxTTIVyO55Hta/t9wt?=
 =?us-ascii?Q?Ylq7tMrQKiTRk3OaAmrAtdu49MdjurH+yI9OXlFwTwlr85P+gg34umZWW9Qq?=
 =?us-ascii?Q?NjSQ9ssJrDBTiSWSl4+TKjNzecxnZhKe08C9JcJ+lj3IHYz7ovmyHElSb82j?=
 =?us-ascii?Q?tl7MnqAdiEaFvMDX+3uMwOe+oslWcLYTHBuNwnN77M+Li9bONAJqdZfb63xh?=
 =?us-ascii?Q?KPHMOmnMsU7zYKuCjyZi8HjBaQD6lCC9a5+EfpQD64dzPzSG3G3UjklM7OWh?=
 =?us-ascii?Q?Fg+kq1JetyBq+b/ESsoZ0Y6efCm9Q1dPav0/rbx7XIXDjqbSPoAAd1COPXzQ?=
 =?us-ascii?Q?YwUIRExJ3GnQGdzx9iixUo3c6vUok3Kzn0xHepNkLAAZ+iywYlBQGmRhfOIY?=
 =?us-ascii?Q?lDXGqA1u85JtJH9gkcTAJZYcyvzdUK1nzZdHkBZCiGtDk8DdZ+O+FAyqFxFx?=
 =?us-ascii?Q?Er5o5yDiYWMxIoMaqdj8TXt/QSOpK2OE1RS65AKTeZ5pvjfhh2PltOqQi1M3?=
 =?us-ascii?Q?bcKsBJ8032/MBSqfweUpEcBXcXPnYswD2m9rJ5SE6BEgltuX3E8it4oIHVBY?=
 =?us-ascii?Q?VF0FHC/QkiCJF4fFpZ2fc9Npn8hzPUZsg3u8qhrssKlPmB72Q5GaI8q1t1gL?=
 =?us-ascii?Q?7SaF0nGMLQKlfo6nqv1v82Hn88G4WI8qglfi2H2lpJQUWAiJyjca93bfDoa0?=
 =?us-ascii?Q?D6JDzrKyO7ZpjOm7Phpc24E/P47Z7I5oilZcebmaFAl2U58rszx2BODjJFZ+?=
 =?us-ascii?Q?ex2/oYybd3IWvG95cmP46A6QmFyNgNZbxb1J0hZUd2nkESZySinneDftuxAV?=
 =?us-ascii?Q?2iMiY7pNQWn8G8Gxar9/jo9O5+9Un25TvjweZJ30+2SRFGPZdHlqC8xKaoJ2?=
 =?us-ascii?Q?clGBBhQFv/GVeujtQufV5EwauQWRLk0CQy5lA81qQ25jRJGbl2MoONzb2N2M?=
 =?us-ascii?Q?KfLVWgRLaRmQf3DUnuJeFV4N6HC7gOqBuLDfwH+GVvc3m2j5aM6Ip2wm1/Pt?=
 =?us-ascii?Q?xNJqJcpdzE/TebIhUScIHiWZYdKwlvkStgpwnHX84ziSLRTNmhLerPdqyDPW?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2a82b4-7bff-4422-230e-08da8d2ee037
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 22:02:49.7943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZMcTsRbARgD41+PQt5BwJnylU6WZbVGoe9Cr4WN6WIW4dBOSbYofHghxNOHk7toS4GDliMSIdpo1JsN5iph4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
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
with the MLO_AN_* autonegotiation mode) sets the type of autonegotiation
which will be used on a link. This results in more than just electrical
differences between the link modes.

With regard to 1000BASE-X, 1000BASE-KX holds a similar position to
SGMII: same signaling, but different autonegotiation. PCS drivers
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

Changes in v3:
- Add mode to phy_interface_num_ports

Changes in v2:
- Document interface mode in phy.rst

 Documentation/networking/phy.rst | 6 ++++++
 drivers/net/phy/phy-core.c       | 1 +
 drivers/net/phy/phylink.c        | 1 +
 include/linux/phy.h              | 4 ++++
 4 files changed, 12 insertions(+)

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
 
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index f8ec12d3d6ae..2a2924bc8f76 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -114,6 +114,7 @@ int phy_interface_num_ports(phy_interface_t interface)
 	case PHY_INTERFACE_MODE_100BASEX:
 	case PHY_INTERFACE_MODE_RXAUI:
 	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_1000BASEKX:
 		return 1;
 	case PHY_INTERFACE_MODE_QSGMII:
 	case PHY_INTERFACE_MODE_QUSGMII:
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

