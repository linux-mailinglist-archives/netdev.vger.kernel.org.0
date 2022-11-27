Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAA8639DBE
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiK0Wsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiK0WsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:48:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2116.outbound.protection.outlook.com [40.107.94.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B4FD3B;
        Sun, 27 Nov 2022 14:47:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqbUU30DB4vO2QlRgDBf/6Z6JIaBe2xVjcuVMLkKNVtONhgp+c/LSzIzxEZSFiMdZKSGtbAwcSVejBsgdwCZ+eIYqqU6rkQM7UtBJIPn5RO4hwG+94Ts9Y4CWfZIeMg+/uZ7hOWRjlLpAUqSZ1KjeLmhAJD02pnSiyHT1iF6GVOilOlvTuUD0a9RhKYm7SXZRgPnEM1U33LvG3+YL0or2alvsgnMOT4HcdIOPUt/zu981f595dacvnUcCWvO7WqCxbZ4KQLXAJxfCAG0cNcVs1Lazsw9yaYf7/Tddh7kxJTUw8hNfpsRc8qsQrj4vkONyUQxGxPPvW4iPq/aRA96MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7WUnJBhHoE6sC2lDgXYIPV/qanNPi1WsJNitRZSSXs=;
 b=f/WAWjGf5YOI1V8LCrMNHEcgfHCblMmu/hW0rnjaVnEZtzooU1yuvm+FjbeXLi1iJFj8XdTIm+Qd6072TcorVPeCnmEJvhFO9P1/pDrq5o4k1cd4q8cdNsVagxJZ3NHku7xxtX3AK5eqqch2k21EtrpC5p6p4y3/XoXmomX/gZ0vxpw96f7n9/J1qdcbCWjuzdNxndPTQ82tLPb10ykfvxb78qW2+4pDY/sGDH9R6B1EyhVRlAX2JwCwXUgRumNBoPLAN0ndypV8g3QNnWlfZ2WImUIFViicif6mPWbOmAEJggetuJPWAh7QHyGT+zaQDYVnAngyhsI+4XYGsiU+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7WUnJBhHoE6sC2lDgXYIPV/qanNPi1WsJNitRZSSXs=;
 b=xu+keqpty9auSJXUbSq2K/fqyS2iopU7wvZEUsoSHvR3SdzOEOx1As9doto0TrDijEz2gsdRxnOtOI+sNlx/cndBORw4+PtL38LK/UOQZnRsMqy1Mdpcoaiwg89GhbJoqnjYDAJvf5Bcrb9sSqRrpjuBqQOHooixSta4AoWyskk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:58 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v3 net-next 06/10] dt-bindings: net: dsa: mediatek,mt7530: fix port description location
Date:   Sun, 27 Nov 2022 14:47:30 -0800
Message-Id: <20221127224734.885526-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ab64c2-74a8-4418-71fd-08dad0c96e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ORr1CTQFpZ5FV4Fio8TICAg6/GaeX5GoksaUOk6dGUpIGREZK6lhj9yGeUK1k6GIK/ttMuQeGF2rEyzLMvZAjJoZ1tCCYnsnAe56XdUvh+Gqu1YBn9NvBH9jc0tTp5RH4gb7JobTSfwPw8xeTRrZhKDo9DvPrxzKjHGWcb4hkYaqUdn3oD1DOnd20stuUZ/iQDZf7vYThS/wPf0+2o6k3XslrIBiFRN+vujzrzUVCcj4JDab2xd1vYT1JNLOBm4CRYw4mSpp+k7LnCBrPKFXqvL6gm8wzkXrRZtRDgPL89eY6J4DuZQ/qxdIlPjwe69zWhOgJMYnrbHi8g8aufu8VAO5xTo07oP9NbqOqrT2LqAIX96d2fqLmF6HrMI0A4eSbAWd4oW9y9btJLR2UBuEzC7+dzyU9lj4VALXrBPtfHRSpi9EUzlYFtYQ54OOlVrTLxwiKC6QZ8CV7ZR03kXcJWqBfo63X9enUJ6xT3UE2QAd+BWi4biRgzjlc6F7nQ5WqrdkkLmq2wlDRLbjF6tqhmFM/mV60aSlNDfuxFuLGe3503BxS2e0a8sWjbWIU5tWd0UBMXtVi2tMAM30GH4Eey8hrXHUAv9PIfW2+7pItN7MOV4U2588t71/7KOs+zclOZuQUqcpu4ldC+bgrdBy6Pf8W/dc4GMIZTzyJIqQVZehW24VFK4MSDO9LU4/qcV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39840400004)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRlo1UO5Tmz7qQnkUNWbbwm8TN/Plvy0S34YRt96FcoOz2H0Sunz0j/t539F?=
 =?us-ascii?Q?B49S3Tyv4k6mwvRgx2Q7p3vhpz94R12f2tb4zw/ZQM+GKFTOIWgBA0Q6Smgd?=
 =?us-ascii?Q?2wIEQPwGAUZfeY7YszIsQwaFlpXQTJMLtwnxXL8xcmgNopEsZpTRTtlIyoj+?=
 =?us-ascii?Q?VFBspE9rrHJpzxXG9lhMwn2r3ZdFh5a5IInuzeRNHgWss9TTYtrLIjNM6yUS?=
 =?us-ascii?Q?HKiTHAlkMd2d6PsbE6SUGw0sGbCW+cjiGnX4Jrv9EShUZG2gGN/AJBxQTh8c?=
 =?us-ascii?Q?GBXng4KWOr2AiIjsvC/SXFQAL3yDWzkhEVFpTT0v14iPseWpKLzQqy1gWdL9?=
 =?us-ascii?Q?UxOj2+2LsrJWNPTuMMzgCht3Dejt0OMzTK8q58LIwdQqC9MvTdPuHv8iDmBt?=
 =?us-ascii?Q?/QUdAaKamCusxs7G2vuYa5NgeHGQUJZGxwk4Lq6KaVJd/wO8ljNJKgBW521K?=
 =?us-ascii?Q?MY4lp7W1k78MCktKIvFufI77j8lmEUsqT+zFho9+J+IUwgVAVFf8FY4+qxdC?=
 =?us-ascii?Q?oknDnZcF8Ly6vow5rVKhdXS3/J9+eHOcPnOcyjRmYeOe7RXSCee8wHiVzrC7?=
 =?us-ascii?Q?iSOJ1UsFGSy0P6wfFiHObkKHDZNcOhbqMgLjDlhkgZW4sEOG15Y/33A2o8Zs?=
 =?us-ascii?Q?MpOipLGF4YuB2ENoY+QawhGJPXczZ9zYs/9nsgUg4glKUnl1XtA1Ehntuzj/?=
 =?us-ascii?Q?daNMvPSpuHquq0/2GRLKjeWTVxgDC632yb8gIbi9aXbARzskPdX2J2rgsl4e?=
 =?us-ascii?Q?O7tV5PM3bZt1XFtlFRilhchSboeeSWFHNhrwoo64SgDras7A5w316YXbLeBK?=
 =?us-ascii?Q?1p7FGEfu1SWTsYnOVfxkGFM8Vync+LGezpJUfwaqLFkoEdXvkkLX0oQVIDRo?=
 =?us-ascii?Q?3CsFa8Ka3GyrgPPLx5/bqwFCb2LUr3VpbUn46ycwKEVUILHha9ucvIKH3RG8?=
 =?us-ascii?Q?8lwU3WLtUqlM4UVpmWWHxkbFtp74AfHgfHZ3yX+6XWTqASRyfDrWaLIzw+mZ?=
 =?us-ascii?Q?l+okVjPN5PyEn4dg8Ya8gO80D31fr+6kno7qrtxnsRfvDjUS5QinIpNpqAay?=
 =?us-ascii?Q?rOZVdgw4Xx0kAqKCnjHagjVNY4mN6Wqe3HHbeMMb4NJAyLBHh8rihYeTckzH?=
 =?us-ascii?Q?sXVK/C++yYlaXi1rIgYaxHrlw3Sku1ZYzKmk2wRPKERZBXx/S0LhL0WPOA74?=
 =?us-ascii?Q?toAEfV/que+COvp+IpLx4MbcQSPT5qbv3TKHVZiEGGsFeXz2KnZczxKf3hVd?=
 =?us-ascii?Q?VxXvhMC8qvwFfbCXWSUrMLCx+JXagdIalXndUb+bwbvC+QCyw9XmEn9Xvx9O?=
 =?us-ascii?Q?EtIpELZpSOsD0cM2S6PaNgM/Wnfs7COTvQSFT5sddjcKMCHCsaUPT2Ay04o3?=
 =?us-ascii?Q?ikB4OmtqrX9ZAHKxzKZw8XaIm+IeM3cwZhnHyyhpMFNXFKQpwV00QHpyDjHT?=
 =?us-ascii?Q?Fts6xV6FsZ272nJBNsKokqaalh4+HqIW0xOJbQiXIi9mBfn+uqTnXJIhuIlR?=
 =?us-ascii?Q?0MHZu97Lr2+PI/qvwEg2sSCBz9k/5EUHnWLsMAcQByISdP1f5uyQoOe8eQPc?=
 =?us-ascii?Q?pXRpgoIEpNLBmifPQnmVk4GCzdN3PsujgCvuy5/B/LQQ8y7+1nJmJYHBG9WV?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ab64c2-74a8-4418-71fd-08dad0c96e3c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:58.5149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nuw15IdZag1Buj69OJINg9WsGjwBQQOX4XXzoJJZuIl3UNWfpULqQsczHRNKQzF/JLoPEX7Sw5OuB0Oiv8gD9svBZ7r+vqi0Ax7cfToFQqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The description property was located where it applies to every port, not
just ports 5 or 6 (CPU ports). Fix this description.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2 -> v3
  * New patch.

---
 .../bindings/net/dsa/mediatek,mt7530.yaml          | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 7df4ea1901ce..415e6c40787e 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -156,17 +156,6 @@ patternProperties:
 
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0 to 5
-              for user ports.
-
         allOf:
           - $ref: dsa-port.yaml#
           - if:
@@ -174,6 +163,9 @@ patternProperties:
             then:
               properties:
                 reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports
                   enum:
                     - 5
                     - 6
-- 
2.25.1

