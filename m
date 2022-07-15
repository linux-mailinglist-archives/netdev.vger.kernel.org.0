Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC40576969
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiGOWCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiGOWBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADD48BAB5;
        Fri, 15 Jul 2022 15:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyIddqJ5i+7583/fATQabBlrg05q5GqltoZABYXN+NJKUoHxf1tBCmwKrgzkRaYtsDZaTye/uHWT6s7qEd9xScL7jaZ0zc2iLZHKninhE3TnDYw4W/WkH1cRL1hNB2nuEWhvCGTJBjQLV8K79XZTewN6Gp+O1/rqGWC4uiLluymJU4ku5PDI2QwDebGbHApRuiRN0zKVvY0fEqrhmCmtX0HY35+lRoOwEIbETnouPh01Aq1ytZntq4uoJYUeEv2s4UNEQuEayi+aa5a/OpHpDUhrgz/ltmFaBUJu3sTpoV+z0X29WKRYiIJPO4ePc5tyCldF32mFLnZaMQ8QflsL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rj1f/6Q3rCM+U+fKBQWiPEzPTplB//hSzLGZK1FkSg8=;
 b=PIkdmpKNzHmDLPS6oXlDz6GwSZMvw39S/4AUbWiu3KeuYpgqFmhKPBmGAgc4/D1Zf8lVM2Wie+mckcdsvZ3pgRYrqxir8qg7U+zpEhZBZPq5PfxmFNRhoWpO7hch6jGvSxbzrn5DbUXbAWXh3esK/b4UnoE5dxLspT+LAte7TuKjao8GouCQNQ+4hkov0QFqJXvwuQGiVHiRj1WKUFl9wiIfUCHfdZ815KhxHG2aJOLFNDfHmhayu17mfsNBrs5dzVun7wFpFj+5BxMHRADOb+Q5NgnS3MzRSnaV8CNYS8/urnOTi37gX8WTi5Ty9ROtwRfJzO3lbnNljM5rxF/r/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rj1f/6Q3rCM+U+fKBQWiPEzPTplB//hSzLGZK1FkSg8=;
 b=pRYpGMrn/in0zr0b88AAdRwbbjf176axf+mc6UMjbst2jG4iMgd4ePkQqPqwii6PoB8bqJBNQsIs7EzcfXfDs3qKemxv63r4nE7YJZd/YCsRabrT2Db5D3qLmeC5hFE4i9etAO52EbmvIwoQ3zjGNZesd5FBURXytxFKnLO4/YtAfJP4hH20x5A/2vK+X9mA0OLtMwpDO5Zd+wCsLggvaqGJ42BBaM6CcIj4NPWTnBnrTtidbqm3AKzTsVjkGyj9cJoCiS6vS1BqDmxnt3h6Qr+7Og22itTW09kPqrxOda6yV2PxQnqU6HlF52gncVvoDo2JckDZKhqyyZ/RMv/qUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:38 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 11/47] [RFC] net: phylink: Add support for CRS-based rate adaptation
Date:   Fri, 15 Jul 2022 17:59:18 -0400
Message-Id: <20220715215954.1449214-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a6873a7-c932-4ad1-04ab-08da66ad73ef
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QtUfj3aOnZ78oDU2z4JgNwJIC3j4OZcSe73n4ObtobzMpMRmwm5xgzu0RGccuLtdPGDZbAlEm9R/N8nLyliovEymc3IG/D6g4JvgEi5QolUNF+Nb+3ue1v3tctU6T7IG5x5HnT6go8BiwxUmsqe7fbeV+Sxol9lHdzN+9OcoISwkmYINPhD0Xgy8C/eGyZFsgy5rOkKrDg0X+vksKKef7uiFyDsYxPU0HrJQ2wAmG9/CQCqfCInEpP5CdFYIKeY4T9abElPwSACHK8C7DokKXFQlv8WcUyuKVh9AAFvAv9D4jUEyBKpOKadBMgyZb3y+Pnnf+h/hE96Z/jY6myh+18Cjh21QLuxpVvAIL3wZOtVIKtlE74ttQrUqrdWqd1/YakrhcNqe5KwTHrpMOKgXDsAnh2nKklOmviMa89PXQvOfdYmODVL4iRgKkt/j+43x41fMZ6pGlCZ+45yLIaCvRWcsEh8ZuQPeDEjgg3AAiQhA7WwdFL9pUijnLMDRWbPjfGwcmrZaJ25TEa+7b6QaH4+BNYtVXsRi1XgZfYK/+9/irg5scR31pmLpl8fxJIVjCsIWvqWLGGvnGTLLQT90RVq1+XZg260xs7FXRdZQB1KcYlpCYxuSqZwqMun4fSGPRZpJGSBVUgWe1QGW1XXQHmR6Bn0WtasEYbaYb5Ac3FRucK+Ou6jn5YqeD5xLjo2CQkbW0fs4vAVsZsy78TZaZrUd+/H4Zn8CaqpOxTs5cl1dq9ggbUOn7VvFUufOSfLxL0Axsyz9cV9ADYln5+6vNDWEY7mDynAwcW9DHERk4VrbMG4aeUJU+6mpomxu1Ozn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(83380400001)(38350700002)(2616005)(1076003)(186003)(107886003)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vrV6z6jDv6PEokF8H7FKNfz3OfVHJIHjtW8HSQAnmtByPAHeYsjd+PtpqaN?=
 =?us-ascii?Q?2dfIZCW6hYZZ7m9w2MboliV8IeyATjH+/cYH/gWHM4Y/ukA5hp+qakumn2FV?=
 =?us-ascii?Q?XeoYLDFgpGANaAeW0iQ3QIfuzgwNGD0OpFKPuDjKG/W9yCTBIGK2aQ7QXVen?=
 =?us-ascii?Q?vqkjjTqHM/jQZsLuXa1BHS/SDDU/kdVAw+T79sA3pIrEYNkQFgTT1Bii4Vs8?=
 =?us-ascii?Q?EgbWvF8WFbRd/F4VmJNuTp0p+AGLb1qpT08zG6BPPxaUN1G0oHa3ji0uxzBa?=
 =?us-ascii?Q?0X+tVm50AvQ0n+TLtYAxPI7GJYkbtzimvYSSjm7PeG6bysy8wSldT/U/gVNB?=
 =?us-ascii?Q?AEHON64kN4timx8Zfpz3tbL1qaeWQzkYO4NxQpWsFQOKqj65x2vaD9yszM8L?=
 =?us-ascii?Q?YE4BI/70XxMKT70Zc/uVYsW/v1pDwJVpm/naCEnSuDCKqlq4CSR3bJRUeISf?=
 =?us-ascii?Q?OO/yFLlQ2hDywYcWVYT742cSCLvI85KkJo2Gw+XZxQoi9hAIVY2jExWuuvRr?=
 =?us-ascii?Q?Z/2sHnBIcAgV4rsOktJ6TckajjfRHi3/ygNy/CpG9abouxqMXXvD6VFEicjb?=
 =?us-ascii?Q?ZHmCId+cQJDHSX/RVntuw+62nwrGghJdyegI2O4509IgGATvxcTX3EaWJpmB?=
 =?us-ascii?Q?GdAqAzC3VcxzLCkZmCa8p67S0ZEkyP321kfe3pumW3c675WgiY0+50M2gvhq?=
 =?us-ascii?Q?nRLm0Kfbu6PVfDkGy3YMakQMU1hQtzafCD9+d0optAsK7qQfDugvXrY0D0V8?=
 =?us-ascii?Q?SWsANpbj6WMf2f4VkADWbPs1dFRC1mUZxazY+B7rqIXqiODEs0ddjBY2U9La?=
 =?us-ascii?Q?QLzeeJv5vxVjXwnfMPz5x0CswUplUv361bNxldzbkAam6WfTHiSRSZrV9USf?=
 =?us-ascii?Q?r9kWB6mYLXiI+UH4chtoOirKUmyvxuBSSHn8D4aE3Lk2TWTwsvCC5mqWqI8s?=
 =?us-ascii?Q?X7KOSTgAM3tXm/P/VqwJ8tDGYC83XZpHDyR20anMIYPJy+sjNEdhYAJCFDdP?=
 =?us-ascii?Q?TTlRJbWr62DDCK4GoMEWb7+G5D49QKUXbKhYInWs2Y+i33CSly7kcHHz8anZ?=
 =?us-ascii?Q?z3f/fPS5PUrWtzwFzYZjlRMjWRF+rje9YOO5Wr4cfvY+3btkfmnXERgeF5Ae?=
 =?us-ascii?Q?ZriReeSSNUDpZeg1CEp8e42xUMxXUUhqmeoSaeLnlrKFx7HZCO1sKE4xusDL?=
 =?us-ascii?Q?HLqVdj+Rt5oXrl6NXNHSfSk3sN8RjzHAIyXsPJ4jd3f54y07egGXsqeR9aDE?=
 =?us-ascii?Q?H3l9KqDyy8wUZ75JWqUqpoHAwnK6bLlOOtyMePyuHKQnom+stK8aUMzu2f0W?=
 =?us-ascii?Q?41mH+CI7qxsQ14aM4oj4xBx9wv2iaHbHJunyNtFH2PNQTqaYQHbROv0Vtiuq?=
 =?us-ascii?Q?5FFxeNEsReHCgl6+7YBxuiLaD9i2pesIzWreYIAjJJziEZyA90HGUAk1pD5m?=
 =?us-ascii?Q?rrHu1AVv4aDlEw6ZPnF2f42HG8Uubp3p9tkpPGefShXrvFUBcFjEtOBEOhAP?=
 =?us-ascii?Q?jQeBaKDzPe0I3nNFsG3ukwVMLim85NXIyisnc3ync3ruhDDhRvlgYFQIoAkv?=
 =?us-ascii?Q?Vzil9zR/2CyCS95zYPrlDB7NPVrhrwU4/2db9K/I0b8HVRJNO00QFHRBvUfy?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6873a7-c932-4ad1-04ab-08da66ad73ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:38.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: too/o8nF7Vob6VzAKGhd+UahszxSMjuBa3MDJtq0DYlfdcrpwHiITmP6Zf6OMM26xBdgr8xMVbpCv/k0+bS3Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for CRS-based rate adaptation, such as the type used
for 10PASS-TS and 2BASE-TL. As these link modes are not supported by any
in-tree phy, this patch is marked as RFC. It serves chiefly to
illustrate the approach to adding support for another rate adaptation
type.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phylink.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7f65413aa778..d27f6d23861c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -476,7 +476,15 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 	case RATE_ADAPT_CRS:
-		/* TODO */
+		/* We can only adapt if the MAC supports half-duplex at the
+		 * interface speed
+		 */
+		if (caps & MAC_1000) {
+			if (mac_capabilities & MAC_1000HD)
+				caps |= MAC_100 | MAC_10;
+		} else if (caps & MAC_100 && mac_capabilities & MAC_100HD) {
+			caps |= MAC_10;
+		}
 		break;
 	case RATE_ADAPT_OPEN_LOOP:
 open_loop:
@@ -1448,6 +1456,8 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
 		pl->phy_state.duplex = DUPLEX_FULL;
 		rx_pause = true;
+	} else if (phydev->rate_adaptation == RATE_ADAPT_CRS) {
+		pl->phy_state.duplex = DUPLEX_HALF;
 	}
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
-- 
2.35.1.1320.gc452695387.dirty

