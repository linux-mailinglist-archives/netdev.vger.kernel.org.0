Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499145597A1
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 12:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiFXKSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 06:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiFXKSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 06:18:36 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30065.outbound.protection.outlook.com [40.107.3.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E901FCF2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY/BbPEjOI/pToC2OQ0WDx7JefjXrHlfI5Azik2dPVz8+FWjA8TGhVi9xDJQlxrZ/gENratEBsNsQEFqQAUZu8c8E25poNi5a0iBccCsiLDFwBSkCYyoZTow/n2QkXqfXnoIr3OPPmapsb+mLTNQCG/9mmqJo3oK9K+Zg6tfgvm04hPlzq4q9AMxzPiauVGw9S+AfGAXhUqujwMglc5TQx5Ha3F6AvWfFrhWLB6fC5vfG+fd0HrsBmI3W7Uc0uRYR8ojVxtbe5e674+cB4Eaikh9E9ogF+9LInUdul/fbXzMY3RhX88GW0vaB2TpbR6FMgbVnpmL1Dx1FpOvwbNeGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRcbAzP5F7jNSmmu3MSky+IqJVuOAPmSyNB651BvPcQ=;
 b=Cfz6mLNF2UlxItL92huAYewu/ioJcZYpIpwk87DjbFWWFmf6Q4bAH1z6f0YMyS5o0X9Rl5mkJ+dfaKTmebkKHxNcLit8Wz6+57wQPWCr0XTiZcZ+HELw8wXAXuajpgih8Dohps69L3nYY5aQtjDdEG9tFKvouVBJMw0LaQ994B27E2abuj8Ninl48rDkC89QE92BuN3avJEShhuSm2OZkhZYGE8oUGgP4goadBzqoUUqH4bNM5YVStfbXLr4hUdcPZmEa2asQStn9+xQeamzC+dsQWFVjQrnLseSdEx1NN4CupZ0T4ho6Je0mtscVS5oD6Z8ZC8jIyBHzGQy+rwajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRcbAzP5F7jNSmmu3MSky+IqJVuOAPmSyNB651BvPcQ=;
 b=s21ErOQRL/h3TLgR5sX3qYmuaNWtQifvPchNkpMtt74qMDsvVGiE1ocnoZsia/kx5dtOlflc7ncLRJqPORjTu/dcO8YfI5PeeN31GKanzXLGUTBWbXMrhamqIH8i9Zx6K/XvbCGwVF+LQpc6URfxBFnRnrzfTzurMFlzUEnoMOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4753.eurprd04.prod.outlook.com (2603:10a6:208:c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 10:18:28 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%4]) with mapi id 15.20.5353.022; Fri, 24 Jun 2022
 10:18:27 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     rmk+kernel@armlinux.org.uk, boon.leong.ong@intel.com,
        andrew@lunn.ch, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next] net: pcs: pcs-xpcs: hide xpcs Kconfig option from the user
Date:   Fri, 24 Jun 2022 13:17:58 +0300
Message-Id: <20220624101758.565822-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::11) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bb47dbe-ee9a-4540-4e7f-08da55cae103
X-MS-TrafficTypeDiagnostic: AM0PR04MB4753:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqqQ2aKjJhVGiHjgonYfAT9Sl7Xve020MPiT5dAK8vIOLPX7OXizJqCu6ggGE3YMyBPpLalm9uCxPQSApunkqMlg/V1b+7St4ZDkRMoMGe3koh+q7b3YHG0rdaF9MR4QzEoCtd3VSZ8rQZKvV9LCqBBDTUlPJuTCp5kPe+gDySZZfKHIAsTTMmVjTjKMa5KdxkZTWiBlyz8YU6iPai4Cdnh3AjHSg6OLGQzetqdKL/9J/8oba7Yr+v0VKx/Exqt3FCwg9//N18i7zfu7Cf7k4KHhSMfljBzvOH+Mf+8OXuiSoh843AGFeu/wU6HeEWLT4d1WCKtL1qhsnOXMUEEhXb+MVRVlY2/7dqKcnI7GGibHC+xfVIXPDViv4uhi/auQezZcR4ebC/qha1kcX5tWKWoNe6hY4J9eCcrLd+jKLJSZ365kMwVfNL+IbFd2RWCBERQ/gKl5sYZcKX8lG9JkW+f87VKlvLNJmWpor/8XtfVYbdSg6rCqfagzAB9hThlQRwqHY1sEQBN2StuW1N2foT29el9vN6ouTE8OgoFr1i6fBVhVUgZ3Q3ZlOwW23UgeuhCP3ODjXFm7jwufhSXko+AXLU3MHflZJpbYranVLYf3Bx3U13U0ByGdgG11x2doNFbiZQoQfqCUQ9tfXo80elJm4B1+vuxBSPyk+VxJvuu4Mv+KWMK+GW1jj6P2dNk7/Bfa/VzFcppbIMj+EFNYIxBuCkQLI4EAgG6HpgrqdgK4wfPKo1ddLwGrb6XEVkUMIn7lg1PYfXxsy408oJ7R+nIvNmwkt2jHdlG1sdgCQoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(1076003)(6506007)(478600001)(54906003)(6486002)(8936002)(5660300002)(52116002)(7416002)(2616005)(186003)(6512007)(86362001)(44832011)(26005)(316002)(83380400001)(4326008)(66946007)(2906002)(66556008)(38350700002)(41300700001)(6666004)(36756003)(66476007)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHsoty1fbrOeeQFsBkEVxz855p3rqJ4LGWrgqkYRzbDK4BIpKPbxV4v+Mecy?=
 =?us-ascii?Q?1FF3bvanngYqSdiddKTKxggpGmNGI2a89Wv33FNZNsX4yQzpGQe539M7Ym5U?=
 =?us-ascii?Q?RUJL5LEp2pqvjIdwj9F7v2RL441eok3iynB4djoJpgsiuU0u4+KRObCXV0E+?=
 =?us-ascii?Q?I24UhIW2EQPbT7BYd7GE7fHN9iqT2pqiwOtTIxDJjofRDOy+TDtpabAEw9BW?=
 =?us-ascii?Q?G+1y5zjbiSe3awF/Tp+4WmRpr+xUlOTHe4l7YvcW1iLC0HDp2S9+eqfSvpZ3?=
 =?us-ascii?Q?u1cLLUOnwv/yscNMEqGD1Krb0lQGE9GMnb9BsqLm9dIcIaseWf7ZQYP2UNFO?=
 =?us-ascii?Q?1prnzBUmKdFLx+Co306kNBInAcYsP7qtoxTlDkJdPt2SXTf908MAFbUgV1cT?=
 =?us-ascii?Q?ShyxmoF6jJihrzmsjIj0+FOdhzIhKm1eQcBox39Ph/ScBkuIEz7XXfr1WL3I?=
 =?us-ascii?Q?s365appggZllzbWIUgOaeFADUNgdwxnBR8VGn9jiFB8sVkWnivzmOys/XgdN?=
 =?us-ascii?Q?40UdGILQn4LsZtoGphtklTLOtp8dRTXooYSWv4vwc4cpkRsZ1p/RPkjTyxzD?=
 =?us-ascii?Q?0RitErBDX88LGvyRaDv4y1DBJiW1G7fvLHErxGzb7nz01SzXTEfMGqCAD1lp?=
 =?us-ascii?Q?jFyQVdBy2N1YqzhUIR4WDymL0AAXwIPWaiglwRvoUzuGqpAvERI4fcSGFjdM?=
 =?us-ascii?Q?Z0cCAfw5W6i0TK9ai7b4V73fwG2MW6AZsL83tbw1Y0v4P/4BHk5ogIWodKAL?=
 =?us-ascii?Q?NYPPetbIy4qtoKVTHKu6TO25WceFRcAC98y2ZF50sVjY9IuVUKoIZzyvkd9Y?=
 =?us-ascii?Q?qxzVkrTPZfitOMVu4TwEF2yme5xakr0SmKVB+q3Vlbe9gXFOhL6ZeOW4TA75?=
 =?us-ascii?Q?JIzbhF7Sf73oS8cDhzrtRiCFdstBhlzyxZv0qVuqdIk6zVad4GwsaQds0ok0?=
 =?us-ascii?Q?L40b2QgvqxIm5o+ILw6pkVyqWpBeIPhNm/DrizeJD4joUNzgrLwCdQ/tNcx+?=
 =?us-ascii?Q?erzhB51L8ftR2sjLu3o1Q7I/0NIU+DCg7tHS2o9TI1/a1FdF7css0m66lqII?=
 =?us-ascii?Q?pnwANmfqHzu+oQLi90WxAwmQ6H4JPSRAZglO56o2t28YjpgjnxKIJXLvu4WT?=
 =?us-ascii?Q?0RGhNW+YeIOxSFEd2+WB81+NoOCdteBMTeaPioT9DanAfrVI0+xA3mJiMmwW?=
 =?us-ascii?Q?lvAdA/nInmAN8fX1lbSeYSsHVCca1n4oHL51kkEZN/3uKahVd8qYhUL2aSl4?=
 =?us-ascii?Q?XpfwCXsrwqmOpIc6ujw8/jC93Rhj2tUffV4LsWHZUsiAIj/AAsZ0XO6bbaGA?=
 =?us-ascii?Q?CqlrtmiMIQVddYx9c0RYOmR7mSwGjwIL+NwczpwW9UWuWlJcsRZDyJsMN2LJ?=
 =?us-ascii?Q?v08sdgvCC9UdJT+ijwyNvXNFzIh9qCMBja3f0j6iq45I48raBqv3/zfcqcQ6?=
 =?us-ascii?Q?pG7DoSLD177Ai7ABs3gFkm1lhxyMuu/qPsxjplNMIoeFTKVmNd4H+pN395BA?=
 =?us-ascii?Q?hnaJ8Gptaut4u5j1jLLgHVfNODvZwY8810XrZFk6uWLbnkCWQ/PtIPj+v0l6?=
 =?us-ascii?Q?u+XxBxPgBT69vV7HwMLrZ56rODZuep1juNdDVEXo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb47dbe-ee9a-4540-4e7f-08da55cae103
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 10:18:27.5547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxuAwDfzHQ8nvxM5Qyq8gL8PZdVTKbepEMzcawjZwZF/quQ+guPnw8PsV+AwI6KIOyYP1U2ZqxT84lsgHRq+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hide the xpcs Kconfig option from the user so that we do not end up in
a scenario where the xpcs is enabled as a module but phylink is not
enabled at all.

ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!

All the user drivers (stmmac and sja1105) of the xpcs module already
select both PCS_XPCS and PHYLINK, so the dependency is resolved at that
level.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/pcs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..9eb32220efea 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -6,7 +6,7 @@
 menu "PCS device drivers"
 
 config PCS_XPCS
-	tristate "Synopsys DesignWare XPCS controller"
+	tristate
 	depends on MDIO_DEVICE && MDIO_BUS
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
-- 
2.33.1

