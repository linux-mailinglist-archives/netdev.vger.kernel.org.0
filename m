Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8794D3621
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbiCIR32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237140AbiCIR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:26 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0B18BF69;
        Wed,  9 Mar 2022 09:28:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eko9n25adjvGxGegNeSxz1kxLZArUD0CWw8zL2r5JKuzTmwPYJ/1H8Eva0eiXICbXEdJ5dVaRflnSqjk1hwKlj7lATl/JIsoaGuTmojYu/V/Vn5zdhIODwj+nt9K6r9rn5e/aC+cGOXXEZoGIlG1XWhmnZ2Jbb88PTyf40C3DH+wanMGhQ/1K6XcV3J0db8X1msfKnWffknLuz9ucpYMLs97iPZX1G/g8y9pA4yseFsqND8juq3RgllW87xXi5T+q19uZhZBFE8+QxipdeUnBPUcAsMqWuzOWuuvxnMAfhFx6Lecj42wikfcngi6a7PK3FaO0Wwgdnd3N5865rddBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjzYIQLdKTdgyHM+oE25auI3Au1YkRyHQ8i+TqxPTRU=;
 b=ViHwxvw6a/LW9oV3qtopshWqrLp3Y2OXudg6gfpF1ATVcy+aTl6BHp3seEd6mxnb6lXENC+kb8gw4e8NRmdWXAi14pe64ig6WHbgJOpE1j1BGEarWHldBTIh0NmESkUTdPxRo4FixzxOfnHnTN2qrhZg/LUKhSXd3X6bXcpPfn/NCBjEWnSb5zte6VpqxaRiMQvMKYKWMQ4sKMXUtdmKicZ9DUqyHXLKEXWfGNCVFzwUPs8Fc2r4OEmeoyKPjcGdQ5HTiMF690rSxni4bLBmXT9vDc23ijdh0Gj64JFhq/2MWSHNDi/5+DmswOOSQmTgbOaLPjK16Kmy4O68xWEZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjzYIQLdKTdgyHM+oE25auI3Au1YkRyHQ8i+TqxPTRU=;
 b=awHXOf7lIHUeQaNsdIY2jC9EsHKD0VP8cTVCHx6oHr2gOugRJTX38TnbI4V6R2DYmR3oUmNnafXcygAaS7MVd9wjw78Jfn+Et2neWQwZnScbvVGuKa6ZFusepg7YHbUMlu3r2dmZaFCj+Eg7Im3o8Nj5Oyz+FIoqwyfmJXHUXiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:13 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:13 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 6/8] dpaa2-mac: move setting up supported_interfaces into a function
Date:   Wed,  9 Mar 2022 19:27:46 +0200
Message-Id: <20220309172748.3460862-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eea7f833-a1cc-4073-3953-08da01f230a4
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9422D7EE93C6AD0F18AFE701E00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYL7gz/j9N6KsiA/COt1Q+nAWl6YO9kqPxVrfLBmN0pn8rtH+e5LWk/Pm26CF4a5sXbUpXpc8Gn2hsJJFgVqRIELWw6AlsxbHwwXCGGH8ABm45F5rGqF6OGgI06G8w5GLZnJwE55g2UlO0o+jwL3hilg8Z7EFP1i69M78D2ReYqasxcBTnmypdZvH+CWC94P/lH4I5FWnQQ1RFZFG3oCl2OZDV79EhO3gBC+qLAni+tkfCJbRCKuW/iGoM3KN0yO23zD8D57YrQ31BWirSO+cYm/rItnTkt4bbXaDX6ygsf+RmEhCL9z8Jx36bSN9BDK+zIY8cm90VJVeNV/ro7F5HBEZSPWhCGkfK5lHR7hJ7ND1kaiO1Y6s95/wx0tbtJ467ggiyeyCAviQb5cZmIGqiNJzZRW9vye3SYR619vLgG5RbR7z3RknuTqcga93mFkam4JqS1toBaVKTkBvlwkaeW4pXPpBwusXRIWl1iRkAovZRoWsNE0reBPkyicQ4mpzhWtQ4qexVjUk3KVAniQE5UU6ZlEnPcC7sCZpw0yDxDIuoxJw1LK6OGzXan5fGzLogB6eVMia9tX87o2+sMJMY3NsTN37XadhSIBGFjLwJlLIgfxnbDnYkdKCUVbjtCe+l37Z6jUqx2u8wXF/VsCfW+hUAywzFvsIMkLBDInDwnAj3RJUePjieb14IJVJcibTYa2LkLNCAAgIbEe2lY2/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sBN2jM6/1srNL7zhS0OhVO8CKOtQkLZ+S4buU/KiO1XT6rG3Jv6TaJ8MFXgt?=
 =?us-ascii?Q?QTZpQ7I0BA8Fza6qUsC/W2hvUfZk+xXGGkdseIusW9Y1eXvwngL5qSIhmn4T?=
 =?us-ascii?Q?b5zfVYGMwNH3HRfHBRpZlsvIeX8V7KAtAa5tZCPaK0veUuU3M7SnRyHSS5kR?=
 =?us-ascii?Q?RkpDc3GPJhdzn/eiM3uNer+Vj+nCvgnDJjaS4n3/g80RQvFLdANKAzjOVoD6?=
 =?us-ascii?Q?fId+8BTDc4ouhmCGvc0kPB5fa7eCWNhAtBX3Tje28/iDk2iYHFH3bwDBrAuQ?=
 =?us-ascii?Q?EegQaKO3dsd0xcqsmr6DFtbWFwWw6suWQpUaTcpazKPQFKU8HFfkCLuOKCWf?=
 =?us-ascii?Q?19dQ8eNpM661OnyA8fmfpG7+HiXeqjwinx0ikWdRO4MDvJNQ9FYUPGuN5thE?=
 =?us-ascii?Q?BZ4kDHVTCaIkyVjo7Q424UYs5J4e3JDOU/6PB2EUn7SvrMg69f39ID67YWNO?=
 =?us-ascii?Q?CgpbIQXSHPmRyrMoEXg0KUrrOqApwZhK/uwDyoxTIGdnJjcRedoaP5D+ibN0?=
 =?us-ascii?Q?NLYApgkZ2LFNHTLjNDqvLdQYmsOtD3EreVbnwsZPm1MeHdWNClFqOsiTIzGV?=
 =?us-ascii?Q?79TU4xvdkw8qUpPCmAi7eLMY3jUfVjUBIvRhlUHkuZtwU0F4eqT9loj6KSrY?=
 =?us-ascii?Q?6VPSmzwU20pQ88SEpU3TdfArHwgfhFqUv7CiL4ESks223Jf5Km8PsYvs6p52?=
 =?us-ascii?Q?vh4d6wDc1yITW9B7/65q9TwZY26Alm4yG5o3z7FUhiMeYmZCbbUTDqgSRotl?=
 =?us-ascii?Q?6ZFJHTf0+igJxuB2CvqZnawncoy9kRBo0G8KBgXNRCoF13Op7/X3xUfd74jj?=
 =?us-ascii?Q?NxmXpFksAj0UGBHCpkTXk7mDLuC0JTRK0z9z31V0fU03/Eg7D3J0vy2J46Q9?=
 =?us-ascii?Q?qCFPgmAYRoPzXu++Pyha7ZPjAmEor6mpSbgAhjXWJQj2J2hKTUjft2PRNpDg?=
 =?us-ascii?Q?81zhg7k6OxZ9hzMIdqwcNq8oDEH9cGOi+75Oev3KtXHDu2InETsQdYETL4cW?=
 =?us-ascii?Q?Qa/HnMrHwLDOdj9UAX6XzH4EQlounObkvPgw4k6octoDhfzcx23p56POwD9Z?=
 =?us-ascii?Q?2eDZJhUunnMt+CT5T0z7CqyFPtyU026dxjRMhJrqWt5QupItVwrS2fbiH4OD?=
 =?us-ascii?Q?A2yT2yDgkateB3FpUZQZAriSS8Qk1k/PTQL8OkvYKc91gOzijfHU/7k44J1o?=
 =?us-ascii?Q?hMjbGtbk9BcL4CwA5pUi9l+dYRlQTasNCeTtoL0oLgNRdXZX2ylGzs6WvN0s?=
 =?us-ascii?Q?zCtZPWu6LMkdyQB0XevPlQ2mHu1XQRtcLb7b/UF8ZFRbxZy6t4+8rGrWg4ne?=
 =?us-ascii?Q?Fi4j+paHK+DDFBwRao2SomJoxCmlMMaeDlC6Gg3JI86XDVYyp/1q3z/IRPx0?=
 =?us-ascii?Q?0RftLBL4Wc18i0HwREBYpYOx6E6qo+uBOPCZA8JY4sjEZogkKqtyN6dxIfOu?=
 =?us-ascii?Q?FtzFrnXW887fn4SVMx1UCb0N9gj+2ZA2bV9ny+tuvV502XAtzHyldQJu8Olz?=
 =?us-ascii?Q?MMiWADjDj5bsENTQfXNaBk9u0uvfxaIJZUB01Qa/eAW6WUJbrPXm1ph2H8r2?=
 =?us-ascii?Q?XSo2wXgZBSPUJ2WzB4XZZ0i8ODVjzKfqXbA6OhPOtGwxPJv+JG+94sFFwUuz?=
 =?us-ascii?Q?tXOO75RaKV3chEUluA6JYTo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea7f833-a1cc-4073-3953-08da01f230a4
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:13.7391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta01wLUu1fHK1CmHekj9jsxz0+bRIcYV/d9AYLGVmQUYy338uG8xA3txvdG1YCk7taZO5aZnDJMbZjoREQBcEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic to setup the supported interfaces will get annotated based on
what the configuration of the SerDes PLLs supports. Move the current
setup into a separate function just to try to keep it clean.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 +++++++++++--------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c4a49bf10156..e6e758eaafea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -257,6 +257,29 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 	}
 }
 
+static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
+{
+	/* We support the current interface mode, and if we have a PCS
+	 * similar interface modes that do not require the SerDes lane to be
+	 * reconfigured.
+	 */
+	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
+	if (mac->pcs) {
+		switch (mac->if_mode) {
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  mac->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  mac->phylink_config.supported_interfaces);
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
@@ -305,25 +328,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
 		MAC_10000FD;
 
-	/* We support the current interface mode, and if we have a PCS
-	 * similar interface modes that do not require the PLLs to be
-	 * reconfigured.
-	 */
-	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
-	if (mac->pcs) {
-		switch (mac->if_mode) {
-		case PHY_INTERFACE_MODE_1000BASEX:
-		case PHY_INTERFACE_MODE_SGMII:
-			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
-				  mac->phylink_config.supported_interfaces);
-			__set_bit(PHY_INTERFACE_MODE_SGMII,
-				  mac->phylink_config.supported_interfaces);
-			break;
-
-		default:
-			break;
-		}
-	}
+	dpaa2_mac_set_supported_interfaces(mac);
 
 	phylink = phylink_create(&mac->phylink_config,
 				 dpmac_node, mac->if_mode,
-- 
2.33.1

