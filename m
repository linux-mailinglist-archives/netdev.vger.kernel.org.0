Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AAE623688
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiKIWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiKIWZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:25:41 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60123.outbound.protection.outlook.com [40.107.6.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA328140C1;
        Wed,  9 Nov 2022 14:25:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0z8lw99JGknZjY59jJyS258PTWRhlciRZY54Nt0LZV77v6Dh4PGZOjalzyX+1xs5OIYte7SXIHqo9eiI/yK775jmOQdhN+vPIGNsnX9V4sBQ9igQD3UZ16Xdf/fh4BBESARTaas7iLXOmIi+eZk3mPsr0TVOfKMMlGI5Hwdl/zmm4aSiMCVm9sQ5q+P9etnzMtGe7utFCBNr8Bli9kZS1gFdjyUg4Dtr21pN8lZ1O9L9rUoU90vWiD9O4CoJHYV4H085NR2bh1KazC39uIrqb+4Y4K15jwJufLKGd1JL3gbNlylWTVXEP8BB8zuYckKh8mhpfuVcmhiyZ3/458THw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+HJf3/LuU/oCvq4SnwqBlyyjJa8NDdhxZb060XJ4Nw=;
 b=Qnrz5r+APTlTn2MXvc0hVFgan+7JAfQrVyI4WfymkAJj3kzjBvQ/Rrr//HCyeiOR07qDq/RV04WN4XnhSWgVqImsEgYL4+DXDuYOOgO9V8bMpgaDt0U0Bzb1/JuUeiUIoMgfRVmVcfZI0K5Ady2FL7No7Ekewsp3w1XW6oq/9B4vXbHzSnVlCNhzGpgHN+wSkhO4ZtYBMGkV4KpMWeosDkfwYc9jXjLQRc6//c3WD+jtpxQXACX52hmPDH0JEnNW60ZA4D/oYSmx/c00lRDDX7L+gmUYHN7Jb6Uc/CJjAwXiHx8f2kAkDLYJO21kmOZgk/GvUpP65CDytA9aQhpgEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+HJf3/LuU/oCvq4SnwqBlyyjJa8NDdhxZb060XJ4Nw=;
 b=qBsZui5DIpLPRBNwhE9DLWVV3bqdwrEwclx3EuA5MOJ4poXrj4HGdhxts+1VtllD5jNhqVILQOMZM6rlwYFhYf2Y25sPOULXtcI2Z8dAUxk8mweiPIXN+lHBIvu2KuZxqoSacYpzEI9F8Hv029yzSMkQHHoctDIqyvgLDduBU+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DBAP190MB0840.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 22:25:38 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87%4]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 22:25:38 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maksym.glubokiy@plvision.eu, vadym.kochan@plvision.eu,
        tchornyi@marvell.com, mickeyr@marvell.com,
        oleksandr.mazur@plvision.eu
Subject: [PATCH 3/3] net: marvell: prestera: pci: bump supported FW min version
Date:   Thu, 10 Nov 2022 00:25:22 +0200
Message-Id: <20221109222522.14554-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
References: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|DBAP190MB0840:EE_
X-MS-Office365-Filtering-Correlation-Id: e71828c2-70d1-4e6c-d00e-08dac2a153f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnD28FpAZdSWphBFrDfmMwKAmPG/4iAhI2Ph/2vKkSycmyavAF6qLrH19CvF7Vm2AYRpLiByxB3HY7MQSNFLMdONIPXOnVAvQAo//BZIPaz2urH34N/oR8XP1tCz31EeU8LLori7P21Z0J7o5nivHkEjgcbN1Ei1bKyIwiraep8Wk7i8OG2DdCJqADoUjR0pkQHiQSfROHCgAtt0iPnpbzikCo96I9xFDD0/+St2I4XnoxSMqlao2/WwLscGqQwnwTaEinbuburCiZvz06iH9+8qhqrCSftZ0+bWbIzF01SEsyNPisTBx4z9dLO6PuIzKDsFOQ3cHA0ofAg7dtf5Ucgb45mUhRtov4DJjJaDKvqY1FBPm1cTUwGTOGe7HOrExv6H1EA5YCW2vwXFRMB7zJcDeMgE1ZiEpoDPNl9+iA4Be4eJOeFryDAI7hH67zv2sNqNfxSbk6qDjjf3LdqiW19NAucX9piBT9aVe3GKMS837mYcIa7udNjWxHvfHaJHmrg3d6TclXOqvX/e9wPMQekCjovuq55SKWaGWVF89b/YpPncazNUyOfmxvPFXneNMtw7ZOsB9rHzk/XtMjpEy6qw6YW8HaYWQtEyMaAneXmqw5Jz2TWLVkCF+kfeS3sohOKhl7bH9Jx2bBLpZInviuKg2UHqKQBX6F5YL5eJt0DlwFUXjr+ebXunUK3oKw7GGgQJd+aKhwZXUDjX7Vsbk0wNsvDHMTAFG7BTYJ82NYC9NHEtAbOwt44qMeIGhzIE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(346002)(34036004)(39830400003)(451199015)(66476007)(26005)(6512007)(66946007)(66556008)(4326008)(8676002)(52116002)(316002)(6506007)(36756003)(2616005)(8936002)(5660300002)(41300700001)(6916009)(83380400001)(2906002)(41320700001)(38100700002)(86362001)(38350700002)(44832011)(4744005)(186003)(1076003)(6486002)(107886003)(6666004)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6ZRZkMBjIiq41i9qoOrQ+F1mZLLOY1BULbh+tHMEUNtTpuDpG3w6yWen3by?=
 =?us-ascii?Q?7URmb/3hnON5WDlY9ofqtOAPEWDxfozzXAQW38ttl4/HTkc8848L0huz2Huk?=
 =?us-ascii?Q?Itnl/ZFwhEQ1RFuC3XCO96vp18OJ1drEhVK/tpq0FgX/0mW4z3nFIX2uCd+G?=
 =?us-ascii?Q?3XA6Eibuorw1OBuANlu/skyf6b8ZAnEqnuUKAv3iCssfostkBMFzXKKjA2Rx?=
 =?us-ascii?Q?kpeZRoEOUti+3xycFIiAqx0x0gDv0t8riyXY54wQWyYZq4NPMWJol538B2mW?=
 =?us-ascii?Q?S8Qih/szUIcuKM5lZm25jisdVKowpciFFvGJRTm8+IJjhlgbE6A06KJjXxC1?=
 =?us-ascii?Q?aASAfqCiqXt0uEaOikQ3VxNZ6vH82wLmAIuEZwVjpV625cH3p4LesHvNRLm6?=
 =?us-ascii?Q?lBUQDKv8VPBH2/K/VdjlVcnI3BuaKEJtjY63rNsFvIBo+chTy950oE6Zrp5m?=
 =?us-ascii?Q?/x8uWHEYi0gCulQ9+DoQ9YTEyYh8S7POGrfGCOTdT5BaOzAU4T/zRn6wzDIj?=
 =?us-ascii?Q?EEqOxV428vnUN7ceXbmvaamz3+GTOfUbyq+FLYZ/guZTt7a/rgEBpthQLOR/?=
 =?us-ascii?Q?mF7695MLIWTdK25SGR7f60Od/luyB8+Z84dd/7vKAJwysAmgb6pD6sGz/u5Q?=
 =?us-ascii?Q?4QLJkMDQSBrVqWl3q8QR/whqFp0Jdlq4z8tDzvv5QKo/QAjzqXR8AIlUw+Um?=
 =?us-ascii?Q?QRuLNqeJSj0196pf+PRbvHyZxDCqkTo2SflDzWaoncAml6YygL19iQwzDdn4?=
 =?us-ascii?Q?enFoPz1UOZjj9gQxgs9iCnbEZAeuZVBmT8BEyW8r0b+238GdO5PxxOHkQIEY?=
 =?us-ascii?Q?n6w2j5kN41Ea/cY5BBRgwXakGZ6PT/J7mtO7RFvjJkzWBzd/YCPH021RSuGw?=
 =?us-ascii?Q?XTvse35pYDNR0V4GjZpAE2jv3cGiOJuaNESmE7TskreGZQPka43bChP5p2RJ?=
 =?us-ascii?Q?EikC7/f2wMF+mJaJsvNLoNpdyiZx5LjrM1N7zHS/oipU+nSyobBD9eLHV5y0?=
 =?us-ascii?Q?s/QAIOBW5ohM2B2SGZDXxsbLy6FynYnN64CNB4KrckXB1AMLRrCUvZYJ3HZp?=
 =?us-ascii?Q?lu2VLsUutGJDcf9TKmmdEcpoh4MXfddrVviq6UWXKJL/wt0sDLJHD0w+k280?=
 =?us-ascii?Q?xAnFJRoxjKn1OlQXiJUsqNco2SG0mS02J+HdjRK/YUFKUr1pgzZlRT4G2ybe?=
 =?us-ascii?Q?uxu2Khe0GkxPQO+LdAaYlz/eAYlLojUUHybKBTzOz/GGuhqh5TGa1SDPsGgO?=
 =?us-ascii?Q?fldjxY9oLFt51EoEiFQoRbpAcsA0/VHxasHK7KGcBSD1OiRqzzzfG82TSBz2?=
 =?us-ascii?Q?4QqyhetF2O9/Fd9FtplCGBZc7gNJ3OKYh6eVDcLWuvrA5oi9lDRYC5ZrVBKA?=
 =?us-ascii?Q?V8maEcRLcdfPtgFMaSuunSGdTr9EPi+nOxD3VN9IytMiTEm05z+ly+O24rwJ?=
 =?us-ascii?Q?rfwvIf+iykIZDTwl1ENayVO2c2e2da8YggkQADs12lHAWKQ/X+JSwiD1+JMW?=
 =?us-ascii?Q?tFhHXAas9nZ22u2n1P2owMQMPIdfL3fULtZdfOYknYMXJw18R8emGXf6JBP6?=
 =?us-ascii?Q?VV3ZtGhFBaX1C+zitimbMwxjbZeKIyWPQM6p3syj+tSezF5G+ehmV+D2n2Zb?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e71828c2-70d1-4e6c-d00e-08dac2a153f5
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:25:38.2195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCkGBeg+Pdi3qx4jnGdJzaErmTPpTJ/55bIhvt5EHP8Sr3sUosnXA0aQRLuQn+3nBpHtLBnh9+WApTOsMg5//KA5b3xm6lhCULyxN9wsarM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bump MIN version to reflect support of new platform (AC5X family devices).

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 9475499069e6..f328d957b2db 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -15,7 +15,7 @@
 #define PRESTERA_MSG_MAX_SIZE 1500
 
 #define PRESTERA_SUPP_FW_MAJ_VER	4
-#define PRESTERA_SUPP_FW_MIN_VER	0
+#define PRESTERA_SUPP_FW_MIN_VER	1
 
 #define PRESTERA_PREV_FW_MAJ_VER	4
 #define PRESTERA_PREV_FW_MIN_VER	0
-- 
2.17.1

