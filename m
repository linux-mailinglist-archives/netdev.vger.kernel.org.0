Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058026AA659
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCDAcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCDAct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:32:49 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CDB6A1F2;
        Fri,  3 Mar 2023 16:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIsbOLzUoZsxmf2xaifUS3vEhJnyCFdPPacd9L3Z63Q=;
 b=cM/EGq5n2CLMAea/rOUgxsI82FMvN1SzBe+8cBNLGjdQAmknaIiFVXQ4jShrVqAgr0VcwncAEr2+/IyOZd9wLZ7QqWUKy7gQd9RF0MLABSa9kq637+E1asbOyXwSZUYV+IilkH90JwFjk47Xbym3ADVwhn+Eik//fiSDynGFcCYPXTf52REN+MHfqba8J4XKvArwpMM49UUjRiJTjZNVzHbgUUnXZjqO1NyCkRLUaK+LyqFcfuvthDaYxym6WDUjqormMGUys9ClSKzmlS+LETNuctPohWN/SC0uTdSn8nGWLuJiYxS4Q28SCZ8RZ2S3kl4kH7RXEP9pXIGnlYsPGw==
Received: from AM7PR02CA0027.eurprd02.prod.outlook.com (2603:10a6:20b:100::37)
 by PR3PR03MB6393.eurprd03.prod.outlook.com (2603:10a6:102:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 00:32:41 +0000
Received: from AM6EUR05FT047.eop-eur05.prod.protection.outlook.com
 (2603:10a6:20b:100:cafe::97) by AM7PR02CA0027.outlook.office365.com
 (2603:10a6:20b:100::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23 via Frontend
 Transport; Sat, 4 Mar 2023 00:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.87)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.87 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.87; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.87) by
 AM6EUR05FT047.mail.protection.outlook.com (10.233.241.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.23 via Frontend Transport; Sat, 4 Mar 2023 00:32:41 +0000
Received: from outmta (unknown [192.168.82.140])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 0CE9E2008088D;
        Sat,  4 Mar 2023 00:32:41 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (unknown [104.47.11.113])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 491152008006F;
        Sat,  4 Mar 2023 00:31:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E27UauLCAmtX4WAwY1qI2CdRx43hSngXPwpq/ERnNNmqVs6lb+CsslF0ZJ85VW+OxWE9/BLn+GjwdixwbDQBFBPuB3Js5xZsrmoPCOkUCFU7i4RLv/WgMhDt+bYehAModDWppJWpkNTDGtXYNU9QrQ2OWaUstEAIptsxzG2oubhB9H0Kdyf+J4Mbx5+k8xKEERWu27BbYZza5QgHlsceHxS8MCJa/Fmba2QvXT/8Ugq/7WU8k77a/SQ7cgul/72XHl1TBig0atSewXso8o3nCx+3BD76h04lB2H2gw2haPn5JpMIORio0fhbdY3yUFaxX2WbYuyxKw4oQ8q9t6UhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIsbOLzUoZsxmf2xaifUS3vEhJnyCFdPPacd9L3Z63Q=;
 b=SXLHvVM9YCyxOCWRQMSKXf9YK3GxviwQP5PhGYYTWdbjOQQIyUgdY6hz6GbVz2YAwm6OaxPD0smGHPFqO5zE/OH52+widQrFXQEjh2kxYZF6+SeShXRUi+ugGVOpuGbeLXXij+qClZd+IV++Pn6BUbhjT1GNR2pLoia2mx/yUaOqoTTHdIyrhiCXE33PZc3PuaWKRB3EZJEoGWsP4ClTXYI2CyFkcNRI4nIo1sXSkvgrPnDSwEUWgk3Zzqd+10FEevdCOnIY9eAXnY73Zwyp4Z00h24IYIrKNpva2h/lskcSoBICJxNeeQeVLkWMfSJVsU5sBoo6rIyAmJbzAfYqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIsbOLzUoZsxmf2xaifUS3vEhJnyCFdPPacd9L3Z63Q=;
 b=cM/EGq5n2CLMAea/rOUgxsI82FMvN1SzBe+8cBNLGjdQAmknaIiFVXQ4jShrVqAgr0VcwncAEr2+/IyOZd9wLZ7QqWUKy7gQd9RF0MLABSa9kq637+E1asbOyXwSZUYV+IilkH90JwFjk47Xbym3ADVwhn+Eik//fiSDynGFcCYPXTf52REN+MHfqba8J4XKvArwpMM49UUjRiJTjZNVzHbgUUnXZjqO1NyCkRLUaK+LyqFcfuvthDaYxym6WDUjqormMGUys9ClSKzmlS+LETNuctPohWN/SC0uTdSn8nGWLuJiYxS4Q28SCZ8RZ2S3kl4kH7RXEP9pXIGnlYsPGw==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB7407.eurprd03.prod.outlook.com (2603:10a6:102:101::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 00:32:26 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6156.023; Sat, 4 Mar 2023
 00:32:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane links
Date:   Fri,  3 Mar 2023 19:31:59 -0500
Message-Id: <20230304003159.1389573-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:a03:167::24) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB7407:EE_|AM6EUR05FT047:EE_|PR3PR03MB6393:EE_
X-MS-Office365-Filtering-Correlation-Id: 350bfb48-04c2-4e8a-f48a-08db1c47f6ee
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ls79Pa20i783Xc8CkQlLb04XZ47pS37jhps/EUUPI3ljQixMJkWtZQg7nim/PBbuTsEHaIUZIbKmxWlmj+4DL3ojvpeDb8eNHFiG+pmhu4IoiBiH1OzSGAs2+5I8aDrTt0HbNQ40PIhCWnrc02QSXHwgniGpThrYjrpWt9EU7sXlAt7230pVfU1/KQVoWdPw93HJhwy7bWOmJXxeYkHD7e2/66dsVXMoSe15dFzypxGUzcrGswYJ04VSZvcnFTF+f0Y2L0Y9PbWWp76OmG7jVDz2an7ieifi5N5mC4byBXXh0+S3qZrUuFN3riNZV3+tl2p1bmKR3Bj9iJRrYmI+hC22bM6LRBFDS14ZbbSlgr2C2vQj4aZwJ8uNaUlTjROBZczPPaM+IRKgpBrrD9pwrnxsmM+upb3Ce3R5BGgFQTcQfkdyAssLo0yGf06PSuHM5R4OcNsIyKoqSOxvxhFA32QP4P4qyV0QnZRSLdOEkOz3m1/wrSEe0gF2rFReX1JGI+fLdZOuGlgNk3Xlw70RV5ymMT9FK5ISMXLFJxv5ihta1mePxfX3vzpHKTFWzVMVaWJ8dr0vI6qjR1hrAfzg580exxLLGpk7u4fiPofd7N9EOXt2Ar+SKBfsDJ7FP9GgZgNKOfs4e1K+/B+AJMTWI9azshkWvzshGxv1iC7twqE4SUGPZcguB5Os5dUQkrf9
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39850400004)(376002)(366004)(396003)(451199018)(110136005)(83380400001)(54906003)(5660300002)(478600001)(41300700001)(38350700002)(38100700002)(4326008)(316002)(66946007)(8676002)(66556008)(66476007)(8936002)(2616005)(36756003)(6666004)(107886003)(6512007)(1076003)(6506007)(2906002)(6486002)(966005)(44832011)(86362001)(186003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7407
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT047.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: be129664-650f-4005-6943-08db1c47ed5c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eD77DyRgJzA5UAlCbl8rZlDMEK+LqZY6o5rZdRs+d0MUgmcdg9tiXi/pcQEAdnoy1Nw+Rs847go0JG5wkcdYLTneCuYNNVDr1/cvBvmek3yPtMNetaZ9XMjcNE4mJhHe9iF5mRJwp1qsAiRazgRvtygwr/ghGjjgxnShNQisayDWFVppJSbupbreCH5y0v/pk6Rvb1d1WaFrNabGPX2O75D5wvp9sZSth5TpsD4NqA4vAqtaxo4HLwT+vZER5gsTHsPiG2DoLnaP0viCuz8PhCJfvExsYGW4eVZ78hu6Rf7f/U80yxVkYxM83irD0ChmjlN+wLqYZ16EUsA7+iLT+6adKp/UPb8lfkpGMrkxmYFL+4JFzJs9ad3IUgYfRg8ZsMIQQ1BdB5zOWtms1e4OFVQDIao++/DnJLHnqADpcsL/zQFBK+s62S1uqxNTsIHTDCZPm2pA89O+lKrhspnuXJifSuwQKqThBdy35JSWjsDFmt3ZeV3p3Yx4S/1P0oXukyaFivubzMVdtXIViZ2dl7Ka1DFn8JkZGoTxtqj3G0IgUWryw7SxNPen11Cs0VLzn4ylxKbrfrDkPzXrt1OJOcPMMe+2SnK4Vv21eP02uyXtXnHyQtPKo2UKiAHD5zMMmb+JP2DoCjQIUnmGcAuQL+2iqGhP5j8/RfZvnsx8OtdNknwLdfoASqGYiKzmbFeE
X-Forefront-Antispam-Report: CIP:20.160.56.87;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(39850400004)(451199018)(36840700001)(46966006)(83380400001)(107886003)(336012)(6486002)(966005)(1076003)(6506007)(6512007)(478600001)(2616005)(110136005)(186003)(26005)(70586007)(70206006)(316002)(54906003)(6666004)(47076005)(8676002)(4326008)(8936002)(34070700002)(36860700001)(5660300002)(44832011)(41300700001)(7596003)(7636003)(82740400003)(2906002)(356005)(82310400005)(36756003)(86362001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2023 00:32:41.3699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 350bfb48-04c2-4e8a-f48a-08db1c47f6ee
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.87];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT047.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
add backplane link mode support"), Ioana Ciornei said [1]:

> ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> by Linux (since the firmware is not touching these). That being said,
> DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
> also have their PCS managed by Linux (no interraction from the
> firmware's part with the PCS, just the SerDes).

This implies that Linux only manages the SerDes when the link type is
backplane. Modify the condition in dpaa2_mac_connect to reflect this,
moving the existing conditions to more appropriate places.

[1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/

Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
For v2 I tested a variety of setups to try and determine what the
behavior is. I evaluated the following branches on a variety of commits
on an LS1088ARDB:

- net/master
- this commit alone
- my lynx10g series [1] alone
- both of the above together

I also switched between MC firmware 10.30 (no protocol change support)
and 10.34 (with protocol change support), and I tried MAC link types of
of FIXED, PHY, and BACKPLANE. After loading the MC firmware, DPC,
kernel, and dtb, I booted up and ran

$ ls-addni dpmac.1

I had a 10G fiber SFP module plugged in and connected on the other end
to my computer.

My results are as follows:

- When the link type is FIXED, all configurations work.
- PHY and BACKPLANE do not work on net/master.
- I occasionally saw an ENOTSUPP error from dpmac_set_protocol with MC
  version 10.30. I am not sure what the cause of this is, as I was
  unable to reproduce it reliably.
- Occasionally, the link did not come up with my lynx10g series without
  this commit. Like the above issue, this would persist across reboots,
  but switching to another configuration and back would often fix this
  issue.

Unfortunately, I was unable to pinpoint any "smoking gun" due to
difficulty in reproducing errors.  However, I still think this commit is
correct, and should be applied. If Linux and the MC are out of sync,
most of the time things will work correctly but occasionally they won't.

[1] https://lore.kernel.org/linux-arm-kernel/20221230000139.2846763-1-sean.anderson@seco.com/
    But with some additional changes for v10.

Changes in v2:
- Fix incorrect condition in dpaa2_mac_set_supported_interfaces

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c886f33f8c6f..9b40c862d807 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -179,9 +179,13 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 	if (err)
 		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
 
-	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
-	if (err)
-		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
+	if (!phy_interface_mode_is_rgmii(mode)) {
+		err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET,
+				       state->interface);
+		if (err)
+			netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n",
+				   err);
+	}
 }
 
 static void dpaa2_mac_link_up(struct phylink_config *config,
@@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 		}
 	}
 
-	if (!mac->serdes_phy)
+	if (!(mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
+	    !mac->serdes_phy)
 		return;
 
 	/* In case we have access to the SerDes phy/lane, then ask the SerDes
@@ -377,8 +382,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		return -EINVAL;
 	mac->if_mode = err;
 
-	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
-	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
+	if (mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE &&
 	    is_of_node(dpmac_node)) {
 		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
 
-- 
2.35.1.1320.gc452695387.dirty

