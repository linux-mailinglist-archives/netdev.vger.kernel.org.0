Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D5D598939
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiHRQq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345032AbiHRQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:43 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A18C3F58;
        Thu, 18 Aug 2022 09:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYQoFUnUYijqua8jO06+aWX6NSCqyIEHuZ7/v07b+WyIAmveNxF1wUDMoXxnsCM/5T8KCqGCNP2YeMKLtl/gNr1ADL//h9Gay84TGag6cK9HrIJYYlcgmOhD6nGEGF5DZfkSOyxibP9nbQULgPPOVAiOtGJb9StEzWb0PkjyQGr4rXOgg7/3IjxiE3BGxEc7BlhtKchsxhAogeTqSovphgYILOH26QFvWIL1aFTUX8QrheUh2mBj3DfQyxo9mPV/+qhduYNDCyfkuJb1daoxQK1xjKolCrlCta1G0cu84WCkPjO30dyGn1FyNqKn7cNXpjDjFnuR3aZUM9PNcsO+Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWTwdL8XYjWXUlCwYopbD4tR94omZLzELWNGk3uuUFA=;
 b=Zunudk/WkG5ZOdmESYMJO+P6Thv5uSOXm0p6eO8UxMFNESvu90fFGoY24Txe/yedekZA6+5i6x3OLutZu6KsB+ZpDvVsbIdsevseRG6F7Xt+BcpeQf2ymo0C1ltVajoxzmYcQbNiFytZHXSnCLTGi+ntHCRXJLaHe6fPVUUIm3YkQTx0rCJ0t9ONx8bt8+JpAFQIoQiYHFrmnPhLG5w2mlVw+hyO/MKqbFVrW6PxCwTJ4l9GdH9DOh7dk75NVbNg5qFHLbIdDRm4hXYAiAo1C6Ckw86ZGWRPHLQ70x27YeC89CXYuk5/UuIdqP9QwSyunBwB+nMhX/81UKsvMBiNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWTwdL8XYjWXUlCwYopbD4tR94omZLzELWNGk3uuUFA=;
 b=xhxCmPFuZw0x2Fq/uCsdQ6Y8bNglSN4EU4ukxNminSEUF4RYVYxBsriH9eLO73T/W/iD7t1fpQSAlgvRnyz1GJOwZrBwdH6/0YBhE6nPxlUekJyftE6XcQOEwHyYf1FYV9pJtnjto54bIJbzXIKpvOfy3y4Js+b9OK2cQ6x5iIkexmcbMRTj/NbUyL2HzAzc79o/+7bdvfmvvh9QRXYntQGyd7mKRdf3FDmeuWaemBK7QpcnKYbaKJ4ATLH/2GhNp6fLNms2FvKbkKbqp3FNPUnGQV94eQt8SHcINPbsaAvwox0fJsya/lIHQ37l0YcJYUP9QeOI0a9w15edVj+ohg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:40 +0000
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
Subject: [PATCH net-next v4 08/10] net: phylink: Adjust advertisement based on rate adaptation
Date:   Thu, 18 Aug 2022 12:46:14 -0400
Message-Id: <20220818164616.2064242-9-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8fb08306-f0b5-401c-5dac-08da8139397b
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCjXou0EXB50zUyNhrJEIUvlqL9k3NBY4+no3gZzWCDDaaY5GtW+HVNyH+AW22P74qAv8jbRTH03w7yzurz41uawKiOtLbz0sukrv8zNETyCe2587OTFBBcC3enu8b2AKBWAJErx6yh3cIjYSoV6Pdz+0twdOlE3u0vJqwMt+G8bXI2XZseLshnvvuCgUoqP1Tiw3103feo8yEELEzZPWiYcwlK3IB5GE06jfWky7OEktefFU5DrQ8+3gz8wZgbcxI/6zbd/doLfFGmt7N8bGnP6p+HcYuExpIaLLzkRaL1rM+4tBgkBGOUQtG6oRxIWmW7mnBXlFcrCtZsjwiH33iW56UiIlssLTSKgIpLHzUDTjm5aRmQ4mPa9JvnTMf2uw87Gb3ygsLq/GIjYdc3+JmxdXxFXuDxQpKoEYGDTee7VV7X5bIpzBNc8Jgn72X09NNaRaAebWjMVR2CQ1F0JjUI949VMlQWo6gsV53wVtWgqw3ptHCzSYFcuC02IRYVbdu2RPxiR+z+t2BTPTjp4eN5TOTqP0wjgo0URnGPU3VhRU7g/9dUfOUFSnsWcO8+ziy3oO1iHavnBgwxG+TbAe7M77glNmSj+Jq8o8qDL11L8Q2KVK6S0Bwwvc99piVYBVZIOIgX9d6+QG+fFMSWFbbdITQnhUcdQ6cmquMmQeTmvkZcHVaSUxw+/2KA8AL69jNxkOEpgI8l9t700DukLbXr1mOePLXJnvUc1agU3tlbHWMh1dpUt3hTCMU3uefRA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(107886003)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZIU2MBSNl8ayUPJPCHH9PpiusoGmxAnO8lgXST4bbSjqIk8R2W50wGL0Eg8?=
 =?us-ascii?Q?X+7FY7gqlm0YIaL7p/qz5fvTqUOqF0jTUbZFr2SJ6SHKCOCh+a3elMnVbFhL?=
 =?us-ascii?Q?pT4dHAZFQ1equZDjP6iyj8sSuG9FjmWernnMSApl5xZS6JAIIGuis9yp3kvz?=
 =?us-ascii?Q?XsJWsdLgu2o8oxJwa/WyjhOIlaUq4IkjRHvMbCAJ44NI/s52CNckZdq7N0xl?=
 =?us-ascii?Q?4caBSOpiDh/QFFcEdFv+agHJgQj/lydjZfE7JZSMovzUtlyl9BltprzIQgeg?=
 =?us-ascii?Q?zReFBmqr2TPlS+/kSqJZC1G/LG71UoJ8S++N+baJqEHYJOnw68E1wOAE0eVB?=
 =?us-ascii?Q?2AgATkS2gMOU82a7tqVMOrmxuLhtPXIOWkkhQCXMzbKzRqN0M30cFUu7R2HY?=
 =?us-ascii?Q?AkuIgNFhnBwEi1QN7a/mTD2xsyUN0n/WOUEL3f3/oitVcGGa4gEJl6fQUw7i?=
 =?us-ascii?Q?ueWkIAo9VGHnVHfeFd32Lu5Gq5f1wPCrQFsg+QaVWWFJttwyy2yJgQcOj2Bn?=
 =?us-ascii?Q?CrKXoZ4Aj1a3ZEl4s9yo3CHYXcJxkfwdfTCJKJVtc91ryUr1QLbW3HrFdTJd?=
 =?us-ascii?Q?R49yopr7rsQJ5MzyHmJ9xUGzOUJqhuyucw4aJs6sXi++4s2P4Q3pWD8BzaXb?=
 =?us-ascii?Q?6nfs7lQXpTesHgX+yb/AGsSMfBpIoFKPTkqQa+kG3eg/8jV9CBb67Nka94S2?=
 =?us-ascii?Q?H0RwSnk0xzXzbGQ90/D3iMubAoPQUjErWJCrZc46biG0PVx/MjcQxl8iG+Oj?=
 =?us-ascii?Q?kDhiUL8SjoUtmWs/dUmAmmzROCeiXrHasZn/kVtXOdfwDnYMP9hdCpZzoYCU?=
 =?us-ascii?Q?cjXjyby+tqQx7OyoeWXaokP6D5lJ2myxdKPORDl2qZvc0PFlCKhmkN8iXOkE?=
 =?us-ascii?Q?04mvhPa1HOppV4V1rTzuTUqBXDE2bRLUVCzGknqmuem2Aj4MvX+4QNtnl9Ic?=
 =?us-ascii?Q?9lNWqULQC9FPydrvK/QxEWr/Iyq7/X4JIWbIjdo48Qc6bibi8yDsTkavoGO8?=
 =?us-ascii?Q?ekLJ0nLA3be6T6QkJBl6m29dctBA3tpf1RwMt/4k9HikNUCvRX08N1Hme4rH?=
 =?us-ascii?Q?dmz6iRdWkxPosOwhtLFPy1v6quobRzr2waQ6h9r5UU9znYU1kZWKSDeOJFNL?=
 =?us-ascii?Q?dTCZTRi4MF+qsmF9tkg1AlNGYo2pAvJ6Ypii0tDVbwey0znGmUvZyAeuV61S?=
 =?us-ascii?Q?0hEhwOd2GD/fwizfB9Na340ZekQXVS+i1qqRO2GUHToNDomkadpvCt+PmAYI?=
 =?us-ascii?Q?aG2d8NEb0thntd48z40drkZvmTt/kGwruvhkqxCJe+woGPJUCGc/HmSMK94m?=
 =?us-ascii?Q?9ssyOURKn6WJXfGqAR+53s4HMMlShz6UqruNwaCM2xWq0IHANyuuyo2Xzlb8?=
 =?us-ascii?Q?V+9ZI/boePM6tz1MDIIiPj8SgYsg+LJLnNAohQqBXrTdSwK5VobWQL577IID?=
 =?us-ascii?Q?MiCMhAeaE3kBzW0NOxcVyn6OYNMmwSY/DHgYTd+gncRp5aXaW903vawZ7/rY?=
 =?us-ascii?Q?JZJxOfaP1tCiIMR+Gw+Xfx8GDugzhzUvyfua2Px1QdebdDwtkC0GxHU4N7cM?=
 =?us-ascii?Q?QnUz0vsn7o0PanhEsokyh6dF80/AlgC9aScCE/DaD1QVFUvAekeRwXti6Y3A?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb08306-f0b5-401c-5dac-08da8139397b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:40.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ra9MSjkgOdWzBefDvwVD/wkOb/MU1qCw9wUu9vt2PRuFJ4SyBmynfJ+WzzFQAADNGuCpNd7JLdAdQg5EkXWFpw==
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

This adds support for adjusting the advertisement for pause-based rate
adaptation. This may result in a lossy link, since the final link settings
are not adjusted. Asymmetric pause support is necessary. It would be
possible for a MAC supporting only symmetric pause to use pause-based rate
adaptation, but only if pause reception was enabled as well.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.

Changes in v2:
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.

 drivers/net/phy/phylink.c | 58 +++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  3 +-
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3e4bbeb1fab2..6cc033148ebf 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -433,14 +433,18 @@ EXPORT_SYMBOL_GPL(phylink_caps_find_max_speed);
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
@@ -513,7 +517,53 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
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
 
@@ -537,7 +587,8 @@ void phylink_generic_validate(struct phylink_config *config,
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities);
+					config->mac_capabilities,
+					state->rate_adaptation);
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
@@ -1563,6 +1614,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
+	config.rate_adaptation = phy_get_rate_adaptation(phy, config.interface);
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 192a18a8674a..265a344e1039 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -543,7 +543,8 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 int phylink_caps_find_max_speed(unsigned long caps, int *speed,
 				unsigned int *duplex);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
-				       unsigned long mac_capabilities);
+				       unsigned long mac_capabilities,
+				       int rate_adaptation);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

