Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637EA5AF0DC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiIFQly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiIFQky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:54 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60DD627B;
        Tue,  6 Sep 2022 09:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGCG9dbjSHyAfTOWeX150BNuKxo5rVg8UWNDd91EljMtS5gBfQBfVzbzIR2obb6iIdpgMWZi42LHdcaR7j6qoN8LZ+L9c5+CHhFje6OFxPLxUlBqQuVVAHCBAxhObC6Qlvgtw7CW6mHlZNOxbsZgkcJUUvRkjpQCN7V4QEObwkWAHM/99cSz1gxDUNH0krhPokY6CLyLrwdjUDWwjmnFK8h/AQkfxiO+ymhqRsFG1Tdk8Vpej5R2XxUUB18AHBDPORswaOzFKu807shvbC1xMl7sHJ9xbfl+lZe8FFDLT57uXYZnJkUT1HIUPwxUWswrlUxskGP2Vr5/SbFMj51jFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mmLYKPSYvbRrWjRq6VGz2IrxF9ZKCDiZflh00EyAwjE=;
 b=Ub/vbDJrDSE4odhHdzFe1Ljz+KgJFu4ZTa734+Z42/0FbTCvxKkNh5R212P7CrDhzO5h9l+BdrYQAYOqmPUD/jHrqvnXQUwHqiSkE3pLfFn3rquxpkIbZmRVitT9KV84Epx9AtyXCcXtE+3mIs+w3hRXQXfg7vPRBn0F5OQwtA2vFvGuDVfvVPvZiaHBRknPmFQjmGCzS9ybQ9GD9pq+BwBNgr5j4IlK2Cz2u1D+ZP1JETlAHu0rVld7tCK/4Eq/bqhHbSX6YqVirm4nfdrVtL+n2Y73/JQNyxskjwkxQ3Om5345imNUh8T4zR+AKdgiydrRU9HEakdyoxotS6m3YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmLYKPSYvbRrWjRq6VGz2IrxF9ZKCDiZflh00EyAwjE=;
 b=jgM/c7/RrRgXQqndmgvQ/qisf33W0howe9xNBX3s6WsAl0KiA9cZcHumrnyZP2fk8p127Yhh1+9YOagpqSNuAJ4aD1wlDp4+Wrkp9fUijBjXBwS0ID9WGRg6H9G1ZgqC3HxE8Cp57FQLvDii+2QmHFsaKaaslvNd1smu1m7qGVkGvTG0LufYa583l9pIo9qOc82am2RIWhbmstuLKBDxsyLxJeWDtWZv+UcTUBJ0WahZCpn4TtEQL5Odi7eCKdQSxrB9aqwPdGkR87xGheOCSCOGBDWciTxNiiKKnsJK7rJqU+DRoxR4yOc+7wWp9fJMqNo8sM4Yw0Xm+QXp+niTjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB5664.eurprd03.prod.outlook.com (2603:10a6:803:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 16:19:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:15 +0000
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
Subject: [PATCH net-next v5 6/8] net: phylink: Adjust advertisement based on rate adaptation
Date:   Tue,  6 Sep 2022 12:18:50 -0400
Message-Id: <20220906161852.1538270-7-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0892517a-3cab-4b3d-0bd7-08da9023892a
X-MS-TrafficTypeDiagnostic: VE1PR03MB5664:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qr2E1h8GnXhs5YHAbgXpYR3dDezQwEFl+MG13AXUSm+37BPIpSTvVzgN4QGkW+ZdhTh3mkc11c4nH654cft9HpT5NQDBrw7T26nlh7460Uw9l5ZzkzFTDipw1gnYV71MnIbbIceEwaNoiJzmp+gZs4uw2RUGjYL0nzW5xVWBO3LNmr05S/u1hxLkE+MnPttTzMSvWbpCAvzxdKiQsNBYcMiT1YLLPFgNzmfEXBKIu7gk4i6E35shwsOpeyNepXofFlwTXWQIROOCX3erT4K+xBVLNaeXEgC6MRU81tENQ2IeAF2z0tIlSLynObr5KyeuldwIPw85eYZ+bjMUTdARnOPSSHIMUVWHVQSuJygCAvQU8Fxwr/zddwCs/HRfHX620/VulMTvcTaSaCzhRaKVnnu0Ziy0Hb/R0RQw8hoAoRg5EbeWy/A9Ddp8lx7Yu53xuo0sOsfV3xRxZ7W2km1tgiFH9oGM203P+aALF3/QkPrXuOP7P+/qeAKgrVui5qk5e8xT3j+3EPrXEFZVf5QC5ExUUpsygaSYbCnRjK0bSdW0HnKBL1rapvoatSGW7q0nNYKdbfe1/YYVunc/kyt4/MRm2/mQMKsQE1GCDYh45TGrIoO5HRMu/7Nn52Q6hzrL1Tag2SGiznaNM/N6E4s8kT2qJY9RYIQZqNhDUk33I0HGg7cYYv6Rc2e/5lm4NeEbyO2x+Uql/dED8NYXvxtX0HDSQA6NSX3R9e7SgjHxxNk4THHb3RgBfEHXVs6OKdjniajKL5PVAYS0x6IFOLaYTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39850400004)(346002)(366004)(396003)(6666004)(26005)(6512007)(6506007)(41300700001)(107886003)(2906002)(38350700002)(83380400001)(478600001)(38100700002)(6486002)(36756003)(4326008)(7416002)(66556008)(66946007)(110136005)(54906003)(316002)(5660300002)(44832011)(8676002)(66476007)(86362001)(8936002)(186003)(52116002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MchPToAOgcteDt+FpJ4764OV7zOGhelOTStzZXrfZ031Akt7K83YDqEQkrp8?=
 =?us-ascii?Q?91PnRQKalW9SDSXvmdVhBxSEFN00cBvaFjyn02DCemxjgKkZlbtwL0WknYIA?=
 =?us-ascii?Q?TIr9uTr1pya8a9nlBoLVSYn6jigky4n/MVwirc6lx9tPidE4ndQ8q0/1yxoc?=
 =?us-ascii?Q?Snhl/qpiUEeFPhCeKQzaIOUBm3mWFswCKG5DMw6n2g23eTokneAP0hHnlFKq?=
 =?us-ascii?Q?1t6FUFzPWVwEPjCfdmpuHg9c3IzWC7h8w7xCbbUVdM1/oDphoxd3T89eoivB?=
 =?us-ascii?Q?lBalFFP8OgfOBJFRm0cTXOROHVtDDC5DZ94KbO1kLfFJ6aqjGhN6aRnb4UX0?=
 =?us-ascii?Q?2rwf7xpDxYVLKO1AhAdalJWmCHiPAXXHPekWfWMF0c62J7JCcckqw4igklBP?=
 =?us-ascii?Q?O9F6hSe/rrdrPhDjl1c9MzsDTnQ8/hIln0NXZn+jHlWjQnZ62cgFTt859xHb?=
 =?us-ascii?Q?9Y7VdIv4kZbb+9IIPEYFeoI78tiRs15K/8HoYGrNPlPi5LQb5EcAtzDzm2pq?=
 =?us-ascii?Q?l9oareyl9L1pFk9mSO1bwvAxUBNSsFHvpDP3+mcRcLic8hcsQs2hdRidRyFf?=
 =?us-ascii?Q?DeDoHD3SRcANqLONCSiBi12C8KKAd8SgMKEVAEg4u2bN4jdhqTefF5iGTEsk?=
 =?us-ascii?Q?sU46guhjxokBSI9P+m4c07M6MCjLV7s/DBYNeOFSY9NKa2ht8Q27XD9XVX4B?=
 =?us-ascii?Q?Iol0L+HAd06K6dDiIU0BRaJ0j/L0frJVIRQR0XXE5wj0H/PASdgL6CjODb6b?=
 =?us-ascii?Q?N9gjDZZZelpgQaiuSyJQH5myxhb4p0gmnRCxvXS7AlO2w9YA2cAzURAqo37f?=
 =?us-ascii?Q?Gdn5GQOVRkQWJStu0K2zgDw3nXR3KDZZiylmNlwO/OGI6RQfPhcLyfLLgEIY?=
 =?us-ascii?Q?X/2ohOPcgs6vXoVt/h8Rj0SjbWqR+05Oco4deNf6klGS4wng2EB+LxPcO7co?=
 =?us-ascii?Q?4B2rWVCwlmMFueiLUPKVKukBN4R3DwYqXFXnQcG02pKTyi5Ct0VhtrDDomo4?=
 =?us-ascii?Q?GCSj0vmj5J/qacbmzvgpz8yiNayMg6oAloo4vO3nFJHfI86k51OfrZONm/si?=
 =?us-ascii?Q?r7w0PRzCdvEZO5yMRjqprAKu8XrBpj75aOi+LI1Pdbn7mVwTrCHeqdg0Us6Z?=
 =?us-ascii?Q?HD4lrt2cFhMcQvTaoR+WDy2wNWo3R2EJOSe9i1lH8CrXZuRTke9xHdYW9Ks+?=
 =?us-ascii?Q?fdgcsa3TSc0yytJD21KffDYBm52j1Rt/Y7hyX5p3BmGHY6OxLuLdsQRoRyo9?=
 =?us-ascii?Q?7l2EHNsDtprBkXUTqZSvOBim6Wu6JtB4DW/gd5vhaGpI1DGidAHVjxjA3klO?=
 =?us-ascii?Q?1Gothu/Z1UtPBc2jGcfcxp5adso2hM6Mu8FxXDMB31bRruyIwom5eqvzTgXj?=
 =?us-ascii?Q?RQ4607zkfqJdGklmlqnATJXi1u0oBBvtkQhicfIHfZaI9TnLJhtf7i9RLBsy?=
 =?us-ascii?Q?nCSvcaZbLw7SZfq6mGargeIPZLlLLG9nla41u3ien99VFMzarCNDAjTd/KNt?=
 =?us-ascii?Q?+9ueAe99IbdKp23h4sg2b1/kpWHSHYEjZy9KKvA66pyXF8/ceSQ8zY/uKQ0O?=
 =?us-ascii?Q?1g/tsGQzXV5gRZdWVN82Kh81qVpPeCJU0cbYzku7GgblBJe9JODyEMmJTHRz?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0892517a-3cab-4b3d-0bd7-08da9023892a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:12.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEbnYmQTuidYwPywFlSRL9EcIvDtOkVU7JxAN9OOoHCKPPDhmsGOUkvsh7V4exTtz0XJ8IdbDWJ7O7RfzJZfpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB5664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for adjusting the advertisement for pause-based rate
adaptation. This may result in a lossy link, since the final link settings
are not adjusted. Asymmetric pause support is necessary. It would be
possible for a MAC supporting only symmetric pause to use pause-based rate
adaptation, but only if pause reception was enabled as well.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v5:
- Move phylink_cap_from_speed_duplex to this commit

Changes in v3:
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.

Changes in v2:
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.

 drivers/net/phy/phylink.c | 106 ++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |   3 +-
 2 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8ce110c7be5c..4d73a58f4854 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -373,18 +373,70 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 }
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
+static struct {
+	unsigned long mask;
+	int speed;
+	unsigned int duplex;
+} phylink_caps_params[] = {
+	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
+	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
+	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
+	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
+	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
+	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
+	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
+	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
+	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
+	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
+	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
+	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
+	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
+	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
+	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
+	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
+	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
+};
+
+/**
+ * phylink_cap_from_speed_duplex - Get mac capability from speed/duplex
+ * @speed: the speed to search for
+ * @duplex: the duplex to search for
+ *
+ * Find the mac capability for a given speed and duplex.
+ *
+ * Return: A mask with the mac capability patching @speed and @duplex, or 0 if
+ *         there were no matches.
+ */
+static unsigned long phylink_cap_from_speed_duplex(int speed,
+						   unsigned int duplex)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+		if (speed == phylink_caps_params[i].speed &&
+		    duplex == phylink_caps_params[i].duplex)
+			return phylink_caps_params[i].mask;
+	}
+
+	return 0;
+}
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
+ * @rate_adaptation: type of rate adaptation being performed
  *
  * Get the MAC capabilities that are supported by the @interface mode and
  * @mac_capabilities.
  */
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities)
+				       unsigned long mac_capabilities,
+				       int rate_adaptation)
 {
+	int max_speed = phylink_interface_max_speed(interface);
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	unsigned long adapted_caps = 0;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_USXGMII:
@@ -458,7 +510,53 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 		break;
 	}
 
-	return caps & mac_capabilities;
+	switch (rate_adaptation) {
+	case RATE_ADAPT_OPEN_LOOP:
+		/* TODO */
+		fallthrough;
+	case RATE_ADAPT_NONE:
+		adapted_caps = 0;
+		break;
+	case RATE_ADAPT_PAUSE: {
+		/* The MAC must support asymmetric pause towards the local
+		 * device for this. We could allow just symmetric pause, but
+		 * then we might have to renegotiate if the link partner
+		 * doesn't support pause. This is because there's no way to
+		 * accept pause frames without transmitting them if we only
+		 * support symmetric pause.
+		 */
+		if (!(mac_capabilities & MAC_SYM_PAUSE) ||
+		    !(mac_capabilities & MAC_ASYM_PAUSE))
+			break;
+
+		/* We can't adapt if the MAC doesn't support the interface's
+		 * max speed at full duplex.
+		 */
+		if (mac_capabilities &
+		    phylink_cap_from_speed_duplex(max_speed, DUPLEX_FULL)) {
+			/* Although a duplex-adapting phy might exist, we
+			 * conservatively remove these modes because the MAC
+			 * will not be aware of the half-duplex nature of the
+			 * link.
+			 */
+			adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
+		}
+		break;
+	}
+	case RATE_ADAPT_CRS:
+		/* The MAC must support half duplex at the interface's max
+		 * speed.
+		 */
+		if (mac_capabilities &
+		    phylink_cap_from_speed_duplex(max_speed, DUPLEX_HALF)) {
+			adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+			adapted_caps &= mac_capabilities;
+		}
+		break;
+	}
+
+	return (caps & mac_capabilities) | adapted_caps;
 }
 EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
@@ -482,7 +580,8 @@ void phylink_generic_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities);
+					config->mac_capabilities,
+					state->rate_adaptation);
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
@@ -1514,6 +1613,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_adaptation = phy_get_rate_adaptation(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 1524846e01b4..c67a67620c8e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -541,7 +541,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities);
+				       unsigned long mac_capabilities,
+				       int rate_adaptation);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

