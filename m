Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD7D60C305
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJYFEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJYFE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB517109D52;
        Mon, 24 Oct 2022 22:04:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDz0ROyaceWvtr73BAb5qs9htuSXFmwUTYdN1gtpRNlVFYt3VxoaLNpePkZxagkM8qdg/NJ4MAITRc5WHawv5ZbCUltvQZrUnlOwRLtxb95jQD8R6Yl0gp1zQODGChB0hYIiCf8m24erFhJaehPxAv+NxNPCQPqP5SHx4W8VxSc3ti+fMfkCeJ7ajaMACmdJaNoRQD/hcNbaJLldgwZ20Ah+kEYuR3yl0gP7W4zr3rdLP7Rgj+uwKwBC2tRFyuZQ7HWkLaFEHkY6cTw9XJiSAuqdHtYLBy98hWLqnmMMzdS4/2IUoSFwJW7dfSHpJoW3DUj5s4y468sz1nSmnpyZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOuDn3YnfNQYm9LyX1wpq6gf5Mm3KwlBByBdMWYN5Q8=;
 b=l0oHJRFYlq2PP18M0pr5Xz+16anzF9q/WO/XHtb/NFtIN88q4sbO7r1Akd1JqbTgo7gxgufLehydHRns2s/z9yIceuNJmaFcSFDPOZkTAUxghWEEvgbkCa4zdlgiEfKOuvxnkkGQcckkRqEYIv57CsOJac6kG63sQTsrSOmu7G1JwqyjgQ0pgePJ8DgmGP+PumumR33Lqzp98ZCQ1ifRbdpy1DJaRwvCE1wpQnMa2tWDL2wNtRnSUA76HL5nye7uFfhNALHwuXMr+2no0WhaURCOB3KrPD81elvBXyv/088OSH3NvQfgD+kabHh483wfYVOlCh3nWDFN6EZgnJpF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOuDn3YnfNQYm9LyX1wpq6gf5Mm3KwlBByBdMWYN5Q8=;
 b=tWGbw/s7KAt3aQwOVpIN9m9a2VUIlNgpGBfqSk1KUWo24eKdDDhiL8UtxzL391h615m6ikGaL+KzqpXtVRxCm7U4wVe4QmLjsrpRAPayznX59Kbe2qY+aDg9Ts1zMs/JZRcWJ+6sB9ruGdp/QqOuYUalDPIus3py3i1ESh7UIF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v1 net-next 4/7] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Mon, 24 Oct 2022 22:03:52 -0700
Message-Id: <20221025050355.3979380-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025050355.3979380-1-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 66fe372d-25d4-4732-e68c-08dab6465cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umR/RqTNFZ7Qt+MjSWU45cKx21romeHgiEVvrQ207g0sm2MDVMTmBik4geVmJ2FPijQYqgSY2DW87t1HHG7LxXMTQVM9s8I4VHV23KZm7Yxu3g120ageBekN5iaWPk+n1Ga810kN3HKioTalp5/05rYacmjFFgupBQI0oShIZyY8JzVvRCfp9O2zgTo3poRiDapeLHgdc2AdYbVDELS4rCxUL4UpLMmlUmagXLipGJAdCDiTm9/rPnQ2vrd+CZXClVEaT9Wi5bikF8fVk/qdd0SL0Vzb8eqw3LmFx3lwnTFiR7CZDztEq/1xu4B8gZxinRfHL30WMnPuM7wFnAvjF/2OzDMjpHFyBqZVS01LksNk0whpxxNRv1MOrlbjhazzjyDFGeANTkunnwEfGJToSoo1iMw+C6VEwUug56LwoV65X3y9DfpgRjuTYAeMiAOSAuFD/rn/Wk3g5CcPiOiou3q3RBskHEAgvGBwNhSHgYqLJDNCbrHvA/mKnsDqjqsTe3PnQyycuAX4NQcMAQtvdkGqs7O/Qrg2tLtYhcRb/x9QzV4tV+WTLgw+Vngwi4lEN+NxQYmNE0H6KKyTTS1SyLx5cJVWtUuscvRLLu9+d1kQIYxP4SHucztO39AdW+wflli90NANjAnv0FiziPtE14Yr00WYTsfmZwWKXF/2o3vGWQ9g5h4qeHLPMFNhPQ4Mv6dnWE1Jbq9oQrVL3084aRfjc2yZQ6mufqap2N6COlo29mdztEmyImwZLcO6Ws48EmkiD2821rLjpjM2ieav9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(4744005)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wIk0Pf6zUF12bmhZvc6bnBHJraE0hZ8M3+kEb5+M8JNYI8vlNtSnF8ce8pKt?=
 =?us-ascii?Q?nki5qI5S25aCIf5g1rfqZLpUKUlH+MuBBlULjUsJ+JLIMhnHF2uDYtSlXSHC?=
 =?us-ascii?Q?izx+t6s6aX9lC6rTuJ06n1mJTzDboofvgkUJu6Ro/DNsnrFMlpxTGUulDS3Z?=
 =?us-ascii?Q?VK5jbgWd/EZ2lecu0z6KzTml/iUZAKkGVj3j3aBUc9gYXbnFYas2wFLdJyOC?=
 =?us-ascii?Q?7DI/dOQQ1+GkqAKgcCNzhpoHhIXPgMJyKY+5LwNWXXSeUrbrx+oXgFAMdKWz?=
 =?us-ascii?Q?ouSWahB2INP5cHAGtXlqE4BmXaeJvF3YJKlUh/D0UnwzVHJzzMePLeYbFIFL?=
 =?us-ascii?Q?Jt5bGyDLT/X8Rz36Z2etKKL0YJDJgCO03x0nalv2OcZ9S+5gW5XP+JAE6RXJ?=
 =?us-ascii?Q?gyYnTdJMj36Z4q2XLDpDNoP1r3UcgdwFdOvvUBgKn3pWUNwD31+odX/2J60h?=
 =?us-ascii?Q?buZsoD3So5w67IiF81Yd1sUtXiQ7NiHObtTFz9Z6fgb2VUazE6/NZ2eZtB4I?=
 =?us-ascii?Q?x+ZS46GyjbE5T3z5Qanr4JQDSsxjVei18EYjpV5X+U/YYK5lPRas073c72+4?=
 =?us-ascii?Q?Ez42j2959Bjp8df6Vrr8UW6vLcobo+nZwwhUDOe8fjn0sHl/MvR90cubmeRa?=
 =?us-ascii?Q?9OwB4W5xdDjav3bVT+K7WSnbLKZ90enmhn1mZ9Q9ZK77do9teAIU8GquqBJK?=
 =?us-ascii?Q?a22UtFSx/rXKxjOyZgQPSO8oLPlA3/oo4Xn3zyERu+AMoK5FziPVmAu8b0sc?=
 =?us-ascii?Q?R/DL9vCSVkJSY6DqDhVAd8nnwaQHT4PzJj30rO07sr/XB+J0PwkvF3BVsf81?=
 =?us-ascii?Q?wXZZloKYVqYq86QyCxwThAvTm7/MQbgXA+ujGSFP7u3bPVem2dD8Q76ihvbR?=
 =?us-ascii?Q?j5Rmf1ZksfI04ZA+IM09c+1i4VfZ6zS2tFel1mrafxJyYagytSb0hCiUW6RN?=
 =?us-ascii?Q?f7t6HSBt5kUkkyZSQP8A3wu6+TSRIg9hBqvllLkfbMP79CXR5y3zLjxyQ6Uk?=
 =?us-ascii?Q?rtvpLPj2jcN6uqpUyFf7SmHaYQIsRUB9yIlmnjvNOMjKohPpMxkQ4QWJ1lnT?=
 =?us-ascii?Q?1zBx0Mcw4IinNV+2qUMLqkaKQ2qV1zZI7jpP+QhuGgAQ+VZblJ0ZErhWpuQw?=
 =?us-ascii?Q?fkrDBskLfLUUGGiyBUk8bu1mXfjOqZuJtIqWdtrUATTYLk7UZ568N/SZiOGZ?=
 =?us-ascii?Q?BSvnEKbXdH6HN60sdBVQDCCT7QXFW7e4MDdaB6Z7xpi/mx6d2COJiT1Ax7jb?=
 =?us-ascii?Q?p8DS0m1GVqCmNtOL7rU03sCMWjB3BlJqqe+FF+n6wJsMjDq4r7fSKO3JcShI?=
 =?us-ascii?Q?UAtSTNhXXrR9IguU0SAgutl25sw5nTL8XpSwqIc3O4e6g5iihjqo+/Usyv4H?=
 =?us-ascii?Q?u7yebQgeHdhXLaHq2GHf4NhomUqMnDGh+nEKVRm1fEX2GN8mzKNFhZx/SQcD?=
 =?us-ascii?Q?af6F2laZCYDQPebQKQMCYkjVvIOnhZn/t066kdQmN4K67+jZFu+JR6JU2Kat?=
 =?us-ascii?Q?udJQsYJi2CiXTdv5Hu19q4PH4dSBFzG2rU6THW1K22+1NnL3za9SWxdHrO0J?=
 =?us-ascii?Q?94RtFngEg09+IxSCvX32oQUtxMQXdR96ZwNt6PZArxTDmhQIO4IBu3apzLwI?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66fe372d-25d4-4732-e68c-08dab6465cd0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:14.9537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4F7XMPIdqKl52bx5rf6MNkCCbeToELmUy21spM1fPT/Q+XUppO3389P3N1Jt57wV5j0zgFwwd+BAs4aeq3akXXDg87oRBPHq9d4oosaq40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
the binding isn't necessary. Remove this unnecessary reference.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..81f291105660 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -159,8 +159,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        unevaluatedProperties: false
-
         properties:
           reg:
             description:
@@ -168,7 +166,6 @@ patternProperties:
               for user ports.
 
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

