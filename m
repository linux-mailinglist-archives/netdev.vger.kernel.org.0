Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B826485C7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLIPpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIPpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:45:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2090.outbound.protection.outlook.com [40.107.6.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D503326CB
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:45:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSixYkxKrbk1K0BVM6PbDII8mwxj7Q8s8oIwPmDwNcBdRgjuuQ75im2NwPkJcdtFLcW9i/RaRiPwkHs0jOdrEsWGen4ByIJko4w/Ztluhmzc6APRuG0LTMDQsGOgfjUFTw+tSsTzK17sUZ5yUj6MNYqvRxGYfFwK6Y5m9DE+C+vEh3gsV0JLMG731Hi4VgMeaCWE8Gm4/MkdhZTr7h3hlCEynobE2RXDC2HLrFr/0OVoLQEfaSlz8pb8WdtVcKbR6/X2Bn4NRChNuVPPzZbaPGmySPNwfaQrn/XY49cmqgxMZvFAON3Yf65dg66XXEuWa+w0sDHYid7eeHhPVJc+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dLOkC996BOFbo6cPVv4Up8z4LqDFXg4w/XpyWSFWLc=;
 b=am0lUqdKOxZ25oByFQpeK00an4hzmZj//59uQR/Zv493PAKD0vQb6tiSo/yjlnB8J/q/lNFV1P0841JcgBdQLg7l0vhs8I2KIC74jA9fLVsnnBs9mYDLqqvUdHg+q7asJW3VG7/LruRSQxJpCoMrHmUBO/lQRbti/JcI75NyFiqIrjsrrShC4LeISYeWLWbbrS0d6R9FgzWzXrci7zbS3+QaC5KORIvzeTlETEdF2ggkfBEW+KlO/EwswtgjNayzS9lYGnI95HLIceCHCPQET2ZBNbYkHuwU6e3vxowItBycLYle+hUsc5YEO5bJZeefFlyKO9atiDZ7M0PtDM5wHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dLOkC996BOFbo6cPVv4Up8z4LqDFXg4w/XpyWSFWLc=;
 b=kH9oixcbWLp5igNB8TK9IIOn2DYVnk7zkIsWGBoI5lDwoThIh6b9wyUTGX5virQSLIP6sBXOpHlaiESJ4Hmqq8BLB2e07f+WTzEhOxMpTA+LZEAKxdZ0IQy+44yFzrF0B+PwOlAVF7rQuWiAL3gxllSBedZ4KFdxGsO8sn3NMw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::26)
 by AS4P190MB1829.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:4b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 15:45:47 +0000
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a]) by VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::5912:e2b4:985e:265a%3]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 15:45:47 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Elad Nachman <enachman@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Serhii Boiko <serhii.boiko@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next] MAINTAINERS: Update email address for Marvell Prestera Ethernet Switch driver
Date:   Fri,  9 Dec 2022 17:45:21 +0200
Message-Id: <20221209154521.1246881-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:38::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P190MB0317:EE_|AS4P190MB1829:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d59723-9820-4c0d-ac46-08dad9fc7074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwIGnv6pztSK7/xodWkUJgIAvC/yU+oeOulndA0OUW36MzCmaUS2NSM0QMskhwV0d/R8eaNf/+bkfHGs3bJPu8/1CDknQGYrhiNFXX3rb5M0MQj+uKp4LDsXEzn13xHac7H7haHLwpBZkZ8L0DDI8Vb0c1er+6ihMgFBIA1lJ2pYygu92ByQMyRoOs0XVHeUtBZBt9R6YXw04qYQX21NJMNtTj6qtLcWQa+ciCrrO4XQlbdFLOPEOYokISA20K4aNtg3JDGAAJPOpGPUF0MLP9dKZT80/mq3x4Xcn5C1snhAbSjK7ysDnMNNsgTCB4wezJyxJGV+YUQmen4D9yICZh9CJdCk92dFJdSlYxvEAi9jnpr3aq9Vt0CHETca0cRNsRECYs3Gqw4Mj5U0/NPlUGeU+tY6C4Ehqp65VlaJqdfEvRcufsidamnCMSYSqXfcTqAKsFJAxjDK+Q9lpYXPQOhGanMX9Q5hhXphM57wpcnao2T+ANh1aC2zAepjFBQZS2Gds4UlZqj0mUGvNO4FxUF0U/80pyoT9/dfT/2XThUKauYOWad0OS9P3VpXkWvQKX+PGj/fWOP0MNFvqp8at5ql9ipXKSmUEAUWaMFVUmT5R2dzQYBnYzgJdIxKvzka9g8LhOYMjscUG4eAMVgYCUqv+DlUhcLjXyKZTBWAsA11ksKjdWocZ4zyyeD8rY9JzsyGuu+WJQcnq2GI5vle6PO0un4kKJuO1Pd61JDl9ds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0317.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(39830400003)(376002)(136003)(451199015)(36756003)(66476007)(8936002)(4326008)(66946007)(2906002)(66556008)(8676002)(15650500001)(4744005)(44832011)(41300700001)(38100700002)(83380400001)(86362001)(38350700002)(107886003)(54906003)(2616005)(316002)(1076003)(110136005)(966005)(478600001)(6486002)(26005)(52116002)(6666004)(5660300002)(6512007)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DeqWmT1jwpbc8W/35+kp/0kX5LiI2hNxGrfH6edT7NIEHwFVS1zMAsdQMQR9?=
 =?us-ascii?Q?NCjRaEtMEMFewihN2gp/R7pK2v4PfLBCFFjnC9/xNtkt1gqZJDJsflx0ABkk?=
 =?us-ascii?Q?rNGNVOSkYPiGxFN72BjH7bCXGOST+D64rh/U36oMgXOzB/V+Y9w+I+yfejXn?=
 =?us-ascii?Q?We17L8PcHJIZWEoODMJcvV4n1Ab84HXg42RseETXPovMQ3bu82Yhk6HTcs4V?=
 =?us-ascii?Q?VxxvuqdBxr3nA10NYDmKt9WcAds3zV14Quxo0hWkYMhIMUZZBXZcMxIiZ2wI?=
 =?us-ascii?Q?XwKB21pyJC5b+H5ftpUD5q7bMy0ak0GvPGUt5Ibdk0WbIkb1kGneOoZcdg94?=
 =?us-ascii?Q?dGteuzIt3QvmHUK4U/n9E4C964hvRxIQaqFnMfOkhlKxCv3VklKLKB4yKhHg?=
 =?us-ascii?Q?U6z+Yjxt19odSDdKDKg7BRrUi/NTfhgD+dUEcA7lnW4Mpk+laaTSdmATPa/l?=
 =?us-ascii?Q?OSqbbycTA9UpkSxeeAAlfP6yuHDVGAnymG42TynPnNNPjRSacqin/cQ4EEpa?=
 =?us-ascii?Q?F/xldB6aRA6+5BCFrrA/pJrgPB72LrlsDQypPVauNxw3Mp1qrsVn4X9rMhK4?=
 =?us-ascii?Q?TBEv64yXdWZi5J2ai9DcodaYtnFNODXg+mDzGIOSK7zQHKSDF9N+S6KijYFv?=
 =?us-ascii?Q?XgkEnkSzMn1bK017LdROVCfK5OKPIacIbso4UJXQGO14eNsjjEzae1s+Yd1q?=
 =?us-ascii?Q?GKGLVthf0Dv93M9kRDmfwRo9fYDNeWehJ2YNMdDyLIWgJcp0ku74Xnk6H3Fh?=
 =?us-ascii?Q?tAzoPDpU+nKS/vLkNN+xCT0CK7NN8bU1GNl+HC2+gtXwabLNVYpxOWYbJXxU?=
 =?us-ascii?Q?ryf6ZQOTbHwZ1Rwz6IGoay1fAvGEk7DK8auetw1J2oTJQhGQc4lQlHZx/zEW?=
 =?us-ascii?Q?B5ALcoQq9y0R9g9t3E4anbCPw3E3TmwoabWwnM9jTKcNmt7wct0beGMGgjPh?=
 =?us-ascii?Q?C2VuI790IaI+di3iD1V9/KoidG+2maKC2Yh7XLyUGn5Gkwnn8HfI+xLf+9Gi?=
 =?us-ascii?Q?VTvU345CD3nBUL9ZAa00/V0PN26uU2kvYJ3ujSE0nlkHf+BVeDKU3LrN5WW+?=
 =?us-ascii?Q?Pg0q+JN87nG+y3lZYPFBag80l1LQQDRbb8yPuCILJvUpXVLHqv/5yr58G30w?=
 =?us-ascii?Q?T++mfUj/MZSMMIvuSl0eKfI3UivD9mpsbEXxTr2KtyanKrMBvhcNi20c1xJb?=
 =?us-ascii?Q?0oPmoCvOzEx9ND17eaUdS4i6qQ8+Erwq7BP2MQiLlMvwxXl4J2fXf6mtKAIW?=
 =?us-ascii?Q?uD7Anam22+HYHg8UGIg3LRCQbjRX5mm5kyD/lkNwScoik+JXCIiy8cytPlOJ?=
 =?us-ascii?Q?wHgSYf1mwO1xAEIgFUSvOCfvgM6kaV8UX/pi3zEK0NSRijhbbC2VTBGFZUj6?=
 =?us-ascii?Q?RyGkaUP64/AfwjO0I5m18xbr2XyU/XQQXMIDlsSumD5BbTrfXwqj2BEfZynx?=
 =?us-ascii?Q?nvYhM44sw02IpAKjynWYHbSNVNc1uWtLlAA8Em3S6ref7LpoXtxfgi3VBdII?=
 =?us-ascii?Q?lkSAe3ob8FITPFGH77PwrXB44gyZELMSKr9AjzZNkUNP9WwM4zE5tAkvC6PQ?=
 =?us-ascii?Q?dTFdAGRB4rL069dU8kXk6RPjPQJlBFwiljx1m6S2PFI/sSc3H9H7zwzMgT9C?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d59723-9820-4c0d-ac46-08dad9fc7074
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 15:45:47.0370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hs5R2oL3sQ/gwEe1C/hBt6Wa5u7mtqANFpaRWKRj8C1t8f+18NjHLzVWMHc6PL6GOJM4BtiiS5rvIzvtOKorJQoxC4CldX+r6euDINJYSqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <taras.chornyi@plvision.eu>

Taras's Marvell email account will be shut down soon so change it to Plvision.

Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 955c1be1efb2..88ffba1716a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12365,7 +12365,7 @@ F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
 MARVELL PRESTERA ETHERNET SWITCH DRIVER
-M:	Taras Chornyi <tchornyi@marvell.com>
+M:	Taras Chornyi <taras.chornyi@plvision.eu>
 S:	Supported
 W:	https://github.com/Marvell-switching/switchdev-prestera
 F:	drivers/net/ethernet/marvell/prestera/
-- 
2.25.1

