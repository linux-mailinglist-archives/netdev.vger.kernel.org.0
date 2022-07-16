Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A11C5770F1
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiGPSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiGPSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:10 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2981E3F6
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byRg9J0r8bCNbYvl8IFxYDRIMvNPilFm6qehAoqa1WMJO3fzVCSfArZvZLUOwWbOe2YOGEq+tbtxZ9qIaiaZBD6AdX+NJUpnYs8v6I+4WlQZkCYyMHtJyEQvTpaQuKLlxMySydr080jx0ZV9G+awUGl+hu6RnavetzjaTKkmD8Xox/SFK53cRSshC6TUCJFaBSS+S8o6y5ll261z1qRVreKbQSq3AWoALRyGjK1qHnVAUotCPJrYAyV7PggOHY1ytb8rmL9SoiaxPdYmwK+d2OPeOWbMWwHHaX2C+yRxELjNGh69HZEyrqCw82k4ovp44ziDIJTbmm9LU6zMEtOI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4b8KEPziVRgtGsIdrABRHtsu8wpAs6p9Mqn8EYWGQNA=;
 b=gE7s55rRxB1ZRYuGokrLvZvJqbm4tgap6+IRaorRn5UAWd0MNlq6Mmy5I5tU1knJDzYosG1pW+lE/LIpiiFtyw78ZKOcNtdoqUZsEeYm6i4sYO7Qmba3+cbITOLVqCr1DBhEiF7J+axi5L0hbOH114Z6gvpnsnSSzcD7yPsoLyNOhfR2+8FGa/GxIqFIVm1CWCkR/iMYwWKUh8SnbNVrPKnyqYJ3g5MK4NVOW3h0mdhHmAr/NsGDcGn0aHJR+ulZBu2KnrKsRJh6e4pAzo0RI22uOFYdC/tFZhCF4hK6uvJU+PSUrUC2rotvj5K4NAXNJPufxn7d2QT7ccPIOo8pdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4b8KEPziVRgtGsIdrABRHtsu8wpAs6p9Mqn8EYWGQNA=;
 b=fVuHu+6i8BHLww4vUd99TNHtJYm6qprsH/z3DjvlIKWbXA+PUamqevNs5sBTsmFm0gPbrpTHyeYi30KQRaTd5W2FO7KAttUyPmovTdNmml0glGDowyadQlExBYcGGBj+qt1kKoGCyEQeMQl9HWF/TxaPoOk1AuTn4bkencbbfNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 06/15] docs: net: dsa: document the teardown method
Date:   Sat, 16 Jul 2022 21:53:35 +0300
Message-Id: <20220716185344.1212091-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d520ed50-654a-4c3b-30a2-08da675c8d5d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azRsnzhU9q3Uel4TMCfpt/Kp+HdVPV4//ea6f7k3B8vTFHlWKyxggc9KY7jNF4Igr/Qpb0/lfJxfWEBrGMysIguiqyGJhDXFQkuuOkds+3t8Hxx4qcLXhWlxrlCbyegHyMEhExvGh0bOMBcFWB4PMow+hugMKql3eBA6CcXpgMQGSZMeOKgjLwKcniQ+sdu9bHEpriuiPLGMAPrRCNfXpTG2ukhgSulVGJhaFO0PsCf/NzkNIQ7K8+GnSRXQIamuTpnEmlsEbX/jahFnSFYdM8JQKf5GiV/KY68dB5qGFP0DLbHnvc0gLBKhdL3H7j08pMcJw9Rtr9rlVDFSmNEucyLTMqiGteX5Humu8zt1NxnIlRG0PNiumnMElU/hcRSlLLqvBbMkc09cve7tVZ74k8l67Rh9peLUfvkk/KejirF5VWTok+UnRSU0lDWSCyijneF8HR9K1bRjHREtESFeik4rmoX+fYCmmV3dJ+C7AUKL9O2Gc11qAd9eCsX/2b0D2MyNPQw23jq7PZC4j9xGZlUPCKIV3/YgTV4PP0z/dY9QVVYJynQXIsZwetkdQIFv/1bc+X6vcXQ3OzMyaVg4bVrMXdX/3qBtOvZRRGGazXSgzM4Xr6oaLcnlhebnlFpfvIKTVWOJX2D9NoJgkmw72wZNOtvXwrxdINbFIIbeW+eYAKoXpObeHJIx6z0NIc8qSR0drO8BIvr7KxNqfw8o26RxCPOEAiGOeHDwuSqqcN1KxHo2WjPboFeia+ZCbN7V2RHwRKknIiU+hchntZyFAsmX48NZWmIHGRzAzGHtAi1/+h8o7/xuGwE7lBnWbfwp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VmLtPo0v0urQ33JxF8qsMUzZTr0Wqv019AL7UsmEgLurLbyLTWC6NToGCYl+?=
 =?us-ascii?Q?ggOU90cg/Bt6Kkv7Vwg6rcgm19XME5h5KH1re6dnx9fxaD9Nuc1QYK/DGaSM?=
 =?us-ascii?Q?oOzM7VcfGPCkUPmwmgSRnLnW81D7Wbpr3Eg+YUXnTf8QCojhRg4Ju9GBwjIn?=
 =?us-ascii?Q?OnmFmteLsRmKGumBrmNdcm/y/oToXhIdPsyULseZi6tNxknOejRGnr7NgoX4?=
 =?us-ascii?Q?Tuspk68KxqpQJCse5es25/GZmhAZ7LqRkzN6pkXvlfv7+cEq/jN6GaVu6ThK?=
 =?us-ascii?Q?mXQpD1NtepiTJ6X/GSsE4V6hBbFZhRJxly23crJ0M3tQ5RRvAmAUGX7cvXoV?=
 =?us-ascii?Q?Oet2PlyGGtZOT3EziG7gT+0AlJrvXM61bZCwlO28jfrUDJBM2nO8zgLa6UXV?=
 =?us-ascii?Q?aVfgWq1ZOv5jgLKISBbWd+LxhgliYvjRWNGjDB+yfWAKGZ68eCx00sTS9gAK?=
 =?us-ascii?Q?wHpQCwn0RHVR8p7yvL6R/786bad27V10qyeoVF/rAzx7bg7ppC9eElcDQh28?=
 =?us-ascii?Q?KbMkgbkAeM4JsXU8Ppuil663Ti4YnzLVSh3i9P0KBsQwhEb1GKqXxyTlm0pw?=
 =?us-ascii?Q?XZUNWgF8xTJEB9pGl08BbJ1P2HAfBZsVlf1qCo4s/qPwLeeg28tRWB3s79nq?=
 =?us-ascii?Q?+lCvYDMVpeNMtkkVYTbDBUGI73cfsCxJCw40BnW1n1pWdhnJPW61h1enJWeY?=
 =?us-ascii?Q?a1+Tg0bj6npxY46z0W82aG4V8mAA6R4YB/pmpd8tcLNd5lVeRk8xWnYmpPtI?=
 =?us-ascii?Q?RHr853SskoxMew1mDpFMjh3bNHOivNvnD1Oa5sZx7EmtmLY2yX1kC4AyGTTK?=
 =?us-ascii?Q?9A9lCgma0jZE1F9MNd7evm55yjQPbIpOSoMG7T4Sc6PNOwUVQrrW3+SQjAlF?=
 =?us-ascii?Q?j8GdlOjFbWQ1vznNKHoroHeBhR9VXc7q0wshPFf42obTY51QGfqvAGyvFjvD?=
 =?us-ascii?Q?7Y2QPaGHtpLp3T/HDSVFYg8Yr3uKBc/JW9PKB2iU3NOB1+3PHFC4bCb77jWC?=
 =?us-ascii?Q?tHzVOyG6S3msh9/CydkoTIRE6VUG2WmSXLHpQGsjlT8qf4LbmTJe2hMvngjp?=
 =?us-ascii?Q?9IS7yrcmu+JKKjKPOGBugKINqchqYA0qG45kAFg/+3GfTbQ4ATi8a21ZGgjD?=
 =?us-ascii?Q?sL4Aa8/AH2cg1yML/IH4RqzjEfCuahnp+Ws5aq8bF+JUICu6kx9Tkr3HKM80?=
 =?us-ascii?Q?71w4mVkOMFnQmo9fiSF7uQxZZr5h3YEfmewx2vr73EEMkXShtqarY5ta1DQB?=
 =?us-ascii?Q?cjtI5opk1Jd2baGaGR/NlIw0wBTjAn5qjYeeU0RkGBMm4JAtEcvNJMsFH+qr?=
 =?us-ascii?Q?egV2tbehjN2zwadI2NZFwCr//IBrjiJQMs91A+PERFHQUp1911mpem8/Wef/?=
 =?us-ascii?Q?Fh6qtCNSXT9eZbPmXgHS9AXyaL3bG6lKs6nUtYl44DL9MB45zSQscHs+BJpK?=
 =?us-ascii?Q?KEapEvDnAUF7MGFp/5wHKLLg59/l7t/KOc88VC99r1FecX3mE2wB7SmMyoJK?=
 =?us-ascii?Q?g4r0/zsvY+ECidRQQrqMFsS1T35BOu2z771X7yO862FF12WNuhmh0seM59dw?=
 =?us-ascii?Q?cfoWFBM9MosHDZ1XXqCXmy/djWViMwU6Tila/3v07mMWEorOEVPHFhXiXgox?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d520ed50-654a-4c3b-30a2-08da675c8d5d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:03.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0wFTwLlQAstc87nPivpfpOkY44EmgiwsrBCH22C1JpTBJVVVow5nNn71+7HIZSFbSSSiDxLpT88ThXyFw8SWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A teardown method was added to dsa_switch_ops without being documented.
Do so now.

Fixes: 5e3f847a02aa ("net: dsa: Add teardown callback for drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 83c1a02376c8..e16eb2e5e787 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -617,7 +617,8 @@ Switch configuration
   fully configured and ready to serve any kind of request. It is recommended
   to issue a software reset of the switch during this setup function in order to
   avoid relying on what a previous software agent such as a bootloader/firmware
-  may have previously configured.
+  may have previously configured. The method responsible for undoing any
+  applicable allocations or operations done here is ``teardown``.
 
 PHY devices and link management
 -------------------------------
-- 
2.34.1

