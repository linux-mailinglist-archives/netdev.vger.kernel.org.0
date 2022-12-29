Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F540659178
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 21:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiL2UVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 15:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiL2UVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 15:21:37 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2055.outbound.protection.outlook.com [40.107.247.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12313F88;
        Thu, 29 Dec 2022 12:21:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGU1Bb/A35HLhF9i67jnFr0NJZH/wMltFklZSAA0zlV0/mKUfVPdZMpQzlyhLTNxqEeuQ3HAj9SGceIy8Ikw9YVGTxj5nwTWTA0MGpRtRxn6DNKnZRHAnuyv4alt3aWZwB23odKM2lPIoduRvWBsN4MG9H4+Fhqd+3WKlkN8Wl2W5IEHRnN3B/5I3rlNHtBX1qn4p8Xoa/8gUpAX0d5lXTYsmG9KmtE9GJS55ggRg9N+6Wr5GQeGDzTDNrWPPCUnDoYBXYSBn9RaaXhnmTXMkcmw4gF4ydFW7rSFIRSSxuI/xSyLIx1kNs423xRgpwgXX62vNy6q8FaCLMX+acPORw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMv1/WBEMG2QbGiuyLwOHCvcJLGePxgY3PudgXTLJ1w=;
 b=Hi1rSSM9w0DSVl7OCK/gruDNw9l7e1AZowO9O00kM97dRRyHC26TEXsN2rnW412A+zVKmeA9FFGFoIpT9b1SCnhVQJKmBoON85AizXqCY6X2OnzquwV+h7LZ/ffVxVgXq8iKMKed2zJGKuqSHOc70238jGpoD9lAg3LuOFWGzeVigH/gO5RsUYmYpA24IPpG8FN8x7FmhBZh7qYWSGTuaro/ya3pbY9qsy1nnVXmpn+msFOPcYhvApN8j3F1Vv7ASdZt+gyCXqNtSJO/sXbPzhJKt7tcLKk6yzKPDOTmSMZtPoHtN6Wl1Vwp26o7/P5CL40R1GP/6kyz6hrryamc+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMv1/WBEMG2QbGiuyLwOHCvcJLGePxgY3PudgXTLJ1w=;
 b=meN2WLObp49TaBVdQ7A6kqQkd7DOYlKmTTnBQLKnDmBrHFGU6w9Vrv04Kcs0/z0joL3N2C4JwHF/KTdM7hYQu7AXC9Q7qKxiR+IPSVlNDeV+gyvHkjTW/zrra+Gr9IegSRpknvKAknZnYahBVFassbubctc8+3suqWClN2aM7teChiBfKEh8Gwg1+h12DC5z/tPO8IIuqoEHLfe6QqrQ+h7j+Y2o/sG1kNi8Qtenh4BB0Ivth79j1lP5IcSwMPxcFYo4ZrLtGWzASD2XtT0UvLmSWkbCMRuuTuxSAzuGxToupIR24Jqw/X8Ud2KM7r4YU3NsacF/uYdOCwDl7MS95Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAVPR03MB9679.eurprd03.prod.outlook.com (2603:10a6:102:316::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 20:21:31 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 20:21:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net] net: phy: Update documentation for get_rate_matching
Date:   Thu, 29 Dec 2022 15:21:20 -0500
Message-Id: <20221229202120.2774103-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:208:fc::44) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAVPR03MB9679:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eccd76b-73e2-469a-04de-08dae9da45f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQjlQfF+RlG0l2fBTEoaQqpxJYIXpot0qs464S7byol1V4VYqDcY8sFj1EVPQ8mgYkr/BPB8E6MkF242N5S7Rabqzmszx5+4mSN51r+OBNr/3eN8kLUEBxq6N9XXo+DNje/4xMgP9QJ9efgLE9Q9iVYfoZPOxwebnvmvRGQNKIvEzboKSdQaaDN0XGatgBSI/Bn+4M0QRN3aNRXRyUBVje+bB7204kLFfrhCfcOEH08DH+QswIyAbKlnuQaQEY5UPJ107C3noIhvK4O2Dn1bkl3GJ+fO7HyHIakxHPi2fTQf1Sc983MRQdR3OVz9PNVU4FHcDJ9S9rOXF1s2Uscr8/L7d1a7ekHBOiancm1Yf7VpWZ3kNtW1opjvtPGZ7GwTo/XMHwgvhF6eAkYgySx+T2KRObbzPcNYTU6Z9IWkwJwTEpvJH+wzejKgKWharREL2gQ5p5TPXTgd4ti12meqKsExpNV9XBp9Ex37A96bXvKpkFGO0Gjv7TRDPreKpaM9wFqR2JH3DbdSZF0ekw5LFKYANOQ6gs1osUq6LSW6UhW2SUaSm0Lr94skY8xmW15mWIgUZlYGpv4nj1vJ0wr8Fd8vpk+IOWlbrem783URtbobPNhqr+yCf72FukCxeyBDfhoQ5mh0lIysnllvVbMkFECec8x4lp8x4aYQXO6BpwKtYBgiSvj9NUSRlUPWftzVxkbASzkUhwaGXskLhI95Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(376002)(39850400004)(451199015)(86362001)(83380400001)(5660300002)(38100700002)(8936002)(38350700002)(2906002)(44832011)(41300700001)(478600001)(6506007)(6666004)(2616005)(26005)(107886003)(4326008)(1076003)(6486002)(6512007)(186003)(8676002)(54906003)(52116002)(316002)(66556008)(110136005)(66476007)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DT3nc50bXEmTCU+UiaR4AzLtM9ksqHcx7KzstsEhoq2GmFJTimZvarN2MBbz?=
 =?us-ascii?Q?Otf3XlEVSPeNfM2fn7MSScrXyzuyf9DdflWWMe0f1uyZgw6hetPoeOD7mzpA?=
 =?us-ascii?Q?lIMfGgw8ZOd3UQPNKNcc6VNj/S05NwHNNgWYeO7DvFj4kLbKMvqP9J/oswQU?=
 =?us-ascii?Q?QxFxUJACpFcTNQwh5ToIyKxGLvmjkQcVJu2AIjEiHAVTubyPni1kSL7Y6hzJ?=
 =?us-ascii?Q?5cnOLoI2sQeEAViuT/j5g18GHEWH3ad/mD3okZOER2NGsc5xkRCVBxh/bCnk?=
 =?us-ascii?Q?7hWgHnF3JHamTPYUKVJla5tFC89BKEB/VmOoFhMVw8qUwv4h6ibG90r2pyMs?=
 =?us-ascii?Q?SaD5pJcFMgtAlqFPQ/rqxhJm/S1OpDMwAZsOOHdzknKd426WHualYC6G6GGd?=
 =?us-ascii?Q?jHlUq3XFMcBKOjrL/T9xuvoogNCukI1lBuoJIepSNdptU9mE1AhZOdrNOMl0?=
 =?us-ascii?Q?hH52oRFaOqOtRvhCgNc+x3N5gCq2WrT5vxpYp3rlfjPoVUACMTN6AxI2Diuq?=
 =?us-ascii?Q?w0RI/2U4ldunf21194MJMNcdYSgb003LGIUdIZG6KlEa3dxnp/mtmbcTkr9g?=
 =?us-ascii?Q?F3ve4GEyARiWA7PpcNFmj7b4sHDdSglNxHcCV3vBJuUQQurM8i3b6dpyZrYv?=
 =?us-ascii?Q?Y+3ieqxqb+i+/Rcn1o7rz6U6JjEBJ5TNwF7KwkNwAj3FgolTG5mgWEH2PaAS?=
 =?us-ascii?Q?CeeGlNp0t2Rg2w2cu64Tlu44N/9w3nmdLdWl8a3laZh5ksGSXGe1HP6OEZJy?=
 =?us-ascii?Q?3jLS0mzpxsX00wxJbToQCyMNrWS7Pp1gHeWXp85zPODVXuNlHy3Aqab9yFLq?=
 =?us-ascii?Q?l1DKgHba4HCecOZ4ZFTKvYGP+LqtQSMGEbTP2BbeTzDI0nTghEY7TBFYcEUq?=
 =?us-ascii?Q?+JZK76i/THjwIjjbWz8lC4BeTXoAchdWC+0E0JpzdlDXd+MtTMcW+3NODN+A?=
 =?us-ascii?Q?3mo7imh62OEaXOSq3gZg/sEqcoNBPt8BokOV92I2IY1NapuSX9YaiJcCq00V?=
 =?us-ascii?Q?AzOWgHUV0WApZTzaLdq8WednOWiChSBHXYQiPCJyL1coykcbRGlOvMh8Znza?=
 =?us-ascii?Q?Wz3v8feWbK1LWGLi0G72oxRyVQXg5nz6pmNnUjhEwRYd8XKdeuV3IMjDPob3?=
 =?us-ascii?Q?SOj1x/aeWupAYl4MsfcCZavZ2xcBqNLQ3DfMBnv9/ikyka5mwULULpmLB64m?=
 =?us-ascii?Q?XYkXSbxzNtRo4N8ssuILsDSvDfBAUivZugwYRTRwZBTyl7C8GzCwpdcHTYu3?=
 =?us-ascii?Q?LENTnoIhbY5LWTa19lN0hp3B39rlkKSd38Ao5y3GwAX69i6GrqzB7Fow5FWA?=
 =?us-ascii?Q?mm6qeEKsyAdfDLLTdxPB04bCxwHEXHZogtEUnE25oONNV7qGm95q57p+0SVo?=
 =?us-ascii?Q?TshkBHMDzpkoe7ZIR6nhwN4/TxUaTaOB1tb6ytzpRHciVPCx5KAbAIbrzjq4?=
 =?us-ascii?Q?Q+5MtiHr6RxVd6WxbHVuWNzALeJBvzfhVq0Q7eqDkHysUvlB8PmI+iVWcZzn?=
 =?us-ascii?Q?2RwoYV/oFZwbqaqwZppr5WEkL0B6U4GI3dhj+z32pgUxXQ7xcTi8WzccLjMW?=
 =?us-ascii?Q?oSGLDGKypqwk+59oz9UInAButAS/2Xoypj4rtlUgIu9nO9IP+zVx6Nuz6elW?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eccd76b-73e2-469a-04de-08dae9da45f0
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 20:21:31.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ixpgmuosw2Fb10Ten7SssRG4WvfLJpxLFE9glijK8wyU0/0Iiw/YDrlltvJuLQvXz0mjrlr7RwjwHffetZ2Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9679
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that phylink no longer calls phy_get_rate_matching with
PHY_INTERFACE_MODE_NA, phys no longer need to support it. Remove the
documentation mandating support.

Fixes: 7642cc28fd37 ("net: phylink: fix PHY validation with rate adaption")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 include/linux/phy.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..6378c997ded5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -826,10 +826,7 @@ struct phy_driver {
 	 * whether to advertise lower-speed modes for that interface. It is
 	 * assumed that if a rate matching mode is supported on an interface,
 	 * then that interface's rate can be adapted to all slower link speeds
-	 * supported by the phy. If iface is %PHY_INTERFACE_MODE_NA, and the phy
-	 * supports any kind of rate matching for any interface, then it must
-	 * return that rate matching mode (preferring %RATE_MATCH_PAUSE to
-	 * %RATE_MATCH_CRS). If the interface is not supported, this should
+	 * supported by the phy. If the interface is not supported, this should
 	 * return %RATE_MATCH_NONE.
 	 */
 	int (*get_rate_matching)(struct phy_device *phydev,
-- 
2.35.1.1320.gc452695387.dirty

