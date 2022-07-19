Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330B957AAAA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbiGSXwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240261AbiGSXvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C77D65550;
        Tue, 19 Jul 2022 16:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqvlVUgrEQnvlvUWwiksGIbr/NIHafRAk/MoxrNspL8xlBv6KZ6LBX0qni7nT+1fsTst7uJCdygh5NSIcPi88Ft5wzaGEo258gQLoteUNut+JaiKhrL3dXRjNZFdTqqcUiq8J2OO3UIbAOoyk1YWQBxiUMW3R1O46MFKmAZG8SuujWgPxMzUsZs4oZF51+FDSwiYOcjupg8BVVj4hYN352FdzZwEHpeqjwD8By+HZn+dYHsO8rU58G8xcL1OVuNpSCkNgPyagE5lGP1fepfZBmNIAX0wEDyKT6gCVYQP04PH7y7UJXk1z/50zEkroBRvR54RLBwzLEhEPQ857I3Nvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiSNoFcIGt6ZJWGY3wZhQzMrtAHg9IgdPPelA5lUqd4=;
 b=KYaEv/MGFZc7Iw5E3Popz5/RGOKCyn50ce4GVj3yTWnbvGHHYow5QlHWijscfwJ63ISmXWAa3jFCwBFdpxXcW6+ypLGV2VQwD7w/zigC5Z/Gxy09KjWt4nDcM2J6q/H+717KvZMinQePOyv2/A8xVfcldvFj3MemQeiXG3H2/ymhVsKfPbVKDuW1hx8F1dFSHqG92Py9wFGoHA0y6bkJrgCY8vw7WEuxQDWtT3zwTN5lHCzSpImsVcefjrJAxWDMLIAFGhl3K2Ghr0s0sQ9v4SdSjaGIpSz2qjK0ygxATY+od3pUkEs32uAtH/6Ml/ysL/Os1FbLzPesEX+QqcKERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiSNoFcIGt6ZJWGY3wZhQzMrtAHg9IgdPPelA5lUqd4=;
 b=HElgw8dhBk7//CB3hjyGar0wg4IdsG16mX7zEePTOKfMNzdRJhZmYDm3z1LmjpDd9ycFgB2SSX6rIjNZIuV3O9JNKRKzu0e/7r0XSSg7lbuGFSC2tZ8qxVCXtln2vHLGVX6bb4q2iRO+8NpG4wD/u8xjQvuhcSQzuZWZi9lJ6ZJmUcJs9gQczxkexCcSzBabwKlBoN8DTbDVLYSjBDV08YLfKMFOvTMkliFPxZORtp9Tikn0mpTRbDkhYZw3rBlhmTvpkaIX/fcZwv5Uf8ISn7AcpKLre+aVmTuKLrzRYKpUGwF2R+kqpRzfLLgIOZEzzY0V4ctuQ4Z67oIX944VOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:35 +0000
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
Subject: [PATCH v2 08/11] net: phylink: Adjust advertisement based on rate adaptation
Date:   Tue, 19 Jul 2022 19:49:58 -0400
Message-Id: <20220719235002.1944800-9-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2d4c710b-20c3-49c2-8aa3-08da69e1798b
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/s1iLHveR/5xJB0Io65DYcFCrhti9ncuJaUg1hTWCuAwaQRYknr5WWG7Qdtdpil7Wmzxv2Ag4Ll6KqYr77prOzy5cguNexY1hpb+aTZgizeqBULIF2h8aGEsvN9P1wsLVT1dz8+vo0j5DM2gpsqT/PFzMITrpXsuWWHK3w0aR9Zz/3/SG5nsqCvRMRidbf8Pq6R3eFwbxWflEVILxYcCj2g9PX9DaYetXcZoPetLJVIykaPEk8p0sK/SefzInFAh92r84xUf2Ae6ZBEIwb7QgF1LVX22JIpuW5n8sEiJ08Dc+8zbeqUIpc/hdgfLmDOC5Z/gq9JYNGZMgfDTaF58kySBfGI9xD3EpkV/jgi8JPyEPEVK8wf7+lDHvlezjjxVk5QMr4DsOE71O8fOtPwoA+7sBvkA/L69cjGYiccGqe9r8L17eEtSZdbxdZll1QWDox2n4K4HxqVmzTV4Y7ZgHt0XdZLtyHGCOjm+Idh+07x8K3PFtKo2BfM2HAtWY2sW5+xb5YXt9dKAnUUesciYUrSGwVL7pcgRnl2zU2k/tkzeStSlhVJmoqAjRryr82hmctPPHBDlnetlHgczqniKPgAZ/mX1IhvozzZO+nAR9aArBpIHxAI//dN7Aiu5hhf8zfCSfBgXC7Um6nV7eR4F7R/XpJHk3n0JPRs3ZOHxACqlYouZzsDYwzJgTsc1Eu8cfGbSL3A4h/B1nKxhdS15an5+su5dQx14B37h4c15jYHt/fAFC15sti29yPL4Ykx4h68StSwIX/I0qcgNK6yOlREYZQHhV9fbMvMlRqdMr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Rex5lVY9kaHMTQ35E1KN8c8OSzKUZZOmu5xsQqAet8qLeHkpGCHk0K2Qw3Z?=
 =?us-ascii?Q?9VXAN/4e2n2ofxoJbqQRvNLDi0ROWXBj9ULrWb5peI/fws972Qfoyj6/UxrF?=
 =?us-ascii?Q?Axuay6c0xclcvCJKNXfLgk7WPoFdqAY6hSZPDnLPfwx2KyRGLatUpmRI6TV2?=
 =?us-ascii?Q?HYoz4gi02/Swj1gOSD8MXvCKiOBFpL5g4MdyvYbd9kMz9GV4HSpIis9IwsKw?=
 =?us-ascii?Q?poE8byDfvS85IDPOYHbOR0WlaaefNM+bMnQL+BmBlIvLhFMn7gpA2qzxnYs/?=
 =?us-ascii?Q?SqZbEXDS6/fM7SrtI0nZpPDvgtAJXKAn2M7YmvMauPKt3IySfWp7JSvYep+1?=
 =?us-ascii?Q?s41ZPKNFEDfBrVhaKhEussv0p8OFTX2AG1Rn7aIK2NEI44HnikIsLkY7XgHm?=
 =?us-ascii?Q?6bwbg74RUjCc5pVSWyUplUFmudEmL9DKCAqKaG4liYbZHwqNj4r6S+sJ4Ddo?=
 =?us-ascii?Q?yUzjjE8zryIoXvLI6J2pwfFMQ3dkqARzUVIDa68JQMP4sLEM9fKPfjn2UAa/?=
 =?us-ascii?Q?8bXCyYavONZl+e7Us++rlzQo6FhjgqKTHW2gHIji8M71lQReisUH2BayEjuu?=
 =?us-ascii?Q?NIfAQA6BQ8yfzebA+lsSgEadSUOj8FcJyBHe4y7gltz8n85eGEybpDbx8HpW?=
 =?us-ascii?Q?48SY3CI7ZcFLR6QgEkN2AyDIgfKTcNCW8nOdAegAtLhcyc4o1aaDHYp32XBi?=
 =?us-ascii?Q?AvNBa/xL2O/3PamTHPYhJTG8ajHfJ84Rd6x48kw+HvrXpvn5g9p+gBM/X5IV?=
 =?us-ascii?Q?ODcKXrdcve91FRmT9RQXvH2Tn+1lGm5qY1Rp82FEpvEn8XKWUriMCDfCBnsO?=
 =?us-ascii?Q?ObUJANYiGlgDhJWLqHgxeb3HhJ8x/OpcaXsj+FjYf/HYIKL0euY5xpGA2Rc9?=
 =?us-ascii?Q?kN0JhAAyyVsk/D9ERZHAsBiEnv/t0klzth4X0xUZpHAElrS6v1BgVmby0f4B?=
 =?us-ascii?Q?SdmYhFcZOPjo1lkdSLHVbFK6X9BmPqnKB2loA2wYEcNShtTrqOVaV/1NTDOi?=
 =?us-ascii?Q?K7MRWg6it+GoUKeZztN6YmDVHFUBsCgvNKXzdDiCJPEZfHR737d1zk1AfPX2?=
 =?us-ascii?Q?AqRgwGDe6PJea9pkpgVySpV+3oBxIRilZ5US22Ozx/CtCILCPYBJBEee2RPB?=
 =?us-ascii?Q?SjyE3qh0ttoKT0TJHV4hgxTkq70SARYRGJRy24iIyPv3QtDEiK1DgYtI/Rek?=
 =?us-ascii?Q?tqo7nisiaoiRGxLzgt/RSgBV6LfLD8Y7FGQapzh000bpX83yIjhdyWv+x0Ag?=
 =?us-ascii?Q?ZC4ye+3Sb8CJTLY1pFS/m4Vpdb2DZTQsJ6WC/X/LvuRuyG8Larfamcoe+13L?=
 =?us-ascii?Q?jBNCvhOOCd7T0y17DaCxlnut0/Jn/17vMwG0lxzIKvcmDCf2Y1QZZPUf62he?=
 =?us-ascii?Q?I23fX3p/dPHZN4QgWYpzuGPXcFofNYwHrE/bl2hyvBlEMiUjJTKprthxPnu+?=
 =?us-ascii?Q?Z9FfkPzCI/HoEaywu2d5sJgJoLiEEd8mpwDfNTTqci2/Gne3aXSumwecWSRL?=
 =?us-ascii?Q?6bmpoFAoLIRxbhSQO1zn32n1z9OspNa8dzxu0Dnssis55WSUC6zuq842r2h1?=
 =?us-ascii?Q?LJr58MDZHcivDfScRgJv8pq2aqnRj6b+BfosCHzG00n2BiBMcxCfPGABRrxz?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4c710b-20c3-49c2-8aa3-08da69e1798b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:35.5811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAJrOJaz4HGF7OpARQQ01SlTYdi5+iKB2brqu1uIcJq8JUXu+reRSNVMy6V4PEZK81iuYR8Vp67BZZoUbS3wDQ==
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

This adds support for adjusting the advertisement for pause-based rate
adaptation. This may result in a lossy link, since the final link settings
are not adjusted. Asymmetric pause support is necessary. It would be
possible for a MAC supporting only symmetric pause to use pause-based rate
adaptation, but only if pause reception was enabled as well.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.

 drivers/net/phy/phylink.c | 87 +++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  5 ++-
 2 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 619ef553476f..f61040c93f3c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -398,18 +398,65 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 }
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
+static int phylink_caps_to_speed(unsigned long caps)
+{
+	unsigned int max_cap = __fls(caps);
+
+	if (max_cap == __fls(MAC_10HD) || max_cap == __fls(MAC_10FD))
+		return SPEED_10;
+	if (max_cap == __fls(MAC_100HD) || max_cap == __fls(MAC_100FD))
+		return SPEED_100;
+	if (max_cap == __fls(MAC_1000HD) || max_cap == __fls(MAC_1000FD))
+		return SPEED_1000;
+	if (max_cap == __fls(MAC_2500FD))
+		return SPEED_2500;
+	if (max_cap == __fls(MAC_5000FD))
+		return SPEED_5000;
+	if (max_cap == __fls(MAC_10000FD))
+		return SPEED_10000;
+	if (max_cap == __fls(MAC_20000FD))
+		return SPEED_20000;
+	if (max_cap == __fls(MAC_25000FD))
+		return SPEED_25000;
+	if (max_cap == __fls(MAC_40000FD))
+		return SPEED_40000;
+	if (max_cap == __fls(MAC_50000FD))
+		return SPEED_50000;
+	if (max_cap == __fls(MAC_56000FD))
+		return SPEED_56000;
+	if (max_cap == __fls(MAC_100000FD))
+		return SPEED_100000;
+	if (max_cap == __fls(MAC_200000FD))
+		return SPEED_200000;
+	if (max_cap == __fls(MAC_400000FD))
+		return SPEED_400000;
+	return SPEED_UNKNOWN;
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
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	unsigned long adapted_caps = 0;
+	struct phylink_link_state state = {
+		.interface = interface,
+		.rate_adaptation = rate_adaptation,
+		.link_speed = SPEED_UNKNOWN,
+		.link_duplex = DUPLEX_UNKNOWN,
+	};
+
+	/* Look up the interface speed */
+	phylink_state_fill_speed_duplex(&state);
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_USXGMII:
@@ -482,7 +529,39 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 		break;
 	}
 
-	return caps & mac_capabilities;
+	switch (rate_adaptation) {
+	case RATE_ADAPT_NONE:
+		break;
+	case RATE_ADAPT_PAUSE: {
+		/* The MAC must support asymmetric pause towards the local
+		 * device for this. We could allow just symmetric pause, but
+		 * then we might have to renegotiate if the link partner
+		 * doesn't support pause.
+		 */
+		if (!(mac_capabilities & MAC_SYM_PAUSE) ||
+		    !(mac_capabilities & MAC_ASYM_PAUSE))
+			break;
+
+		/* Can't adapt if the MAC doesn't support the interface's max
+		 * speed
+		 */
+		if (state.speed != phylink_caps_to_speed(mac_capabilities))
+			break;
+
+		adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
+		/* We can't use pause frames in half-duplex mode */
+		adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
+		break;
+	}
+	case RATE_ADAPT_CRS:
+		/* TODO */
+		break;
+	case RATE_ADAPT_OPEN_LOOP:
+		/* TODO */
+		break;
+	}
+
+	return (caps & mac_capabilities) | adapted_caps;
 }
 EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
@@ -506,7 +585,8 @@ void phylink_generic_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities);
+					config->mac_capabilities,
+					state->rate_adaptation);
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
@@ -1529,6 +1609,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_adaptation = phy_get_rate_adaptation(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index f32b97f27ddc..73e1aa73e30f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -70,6 +70,8 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @link: true if the link is up.
  * @an_enabled: true if autonegotiation is enabled/desired.
  * @an_complete: true if autonegotiation has completed.
+ * @rate_adaptation: method of throttling @interface_speed to @speed, one of
+ *   RATE_ADAPT_* constants.
  */
 struct phylink_link_state {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
@@ -531,7 +533,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 
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

