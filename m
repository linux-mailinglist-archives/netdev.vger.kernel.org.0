Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984C0618F92
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiKDEwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKDEwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C4A2793B;
        Thu,  3 Nov 2022 21:52:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLfbmzLasC9TgrZGd6xvVFGbCVZRTRLoEoy0k6Fp2hJNB3uBu07jK0tuXsQ9dAehDIxuZnxcmb2ICOogjeBWUDbxuJzh2Ysxj+GwasG3Y6bS8zlOMXb/MoaenpmTJfyu/HOpshHQVtrIhdQSxr7U/78sxHTr2xqop3/D6jtVHQRskbhtyZxRuz8+08q5aBP7SMGdjyCa9UahTLk59ZMFnUGjTUjiI5nRTgcwXCDB3yw4Ka7HPE1LWVf2tRP7ccq5PXpxVPeQ14GgPcYCYsrHGk8YpOortDu7Bg2PwlfMR+qSYpUaQ6zqWm9taeJmzwOrXesecfAEzyKhDCQijhAMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My0hRrEOLaxcZdt44RMuKm0cz6Lj17UAckUIoCKo+uY=;
 b=AYTvov6xUAw15lQO2PFxxGMIGCV3EMQ2eJIhThHLsHyHMpMbi0L0ey8JLL21IEP0kLxEj60LFQGRfB9zsd0kdiEI+M3XkAbt3QfOo+a8urcW6At8gx9/FjNYGjJvB5VJdTkMwIF9gS3mtOmLGAiqz76uPk0lGFt/B+IVsqBoy+IOSBlBp4zi9wP1xRd3bitR67o54XTV9Ktp8Ue6QJzaGci/AwE5CWXysx/8k27mTU3K+sOBmaBa3a2rwnQ7m7r43/nyO9OHspu5HqaTTzoM7CPOp7z53V9RnVfzBzuzCfEyf1w4d8UTnVum0TF1lb8RbWfUv7BmqBWo+uAol9SDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My0hRrEOLaxcZdt44RMuKm0cz6Lj17UAckUIoCKo+uY=;
 b=PmQ4mSUA+Fkcnp5o0FihsJaTZXin+O6T1StdCYPNX0QVRDB7+JeQcmw9Aw3goslQGcpA32dXGHPkFWHpddUA/QQZgl7GBPoqOfkDj5hyqtBzf1wdWUGWky5CnxGbjtiVKQNtZNP45vGzjH7uoYj1+IKstZ/fW7bW5ERoyzOUdIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:17 +0000
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
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 net-next 1/6] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Thu,  3 Nov 2022 21:51:59 -0700
Message-Id: <20221104045204.746124-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104045204.746124-1-colin.foster@in-advantage.com>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: d2009c73-b526-4daa-ac66-08dabe205929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QroEQJWTC2vTbz1AzX5vzPauoz/kugV1rwQc0Jm5LahiRV7fopQ9Ni0TkNvPeHBDSpETptKPl1atHu2WF54uxDqbB7Yw+C1SHtKZcd3k/kPM6U0wJU4vLzQAYWujYtEEXKn5vj4eQev0dSQ2gzPWEYNFNuyvimor6FZeem/pQSXYIkjKxbJ6HY8v0Uixn2/YoPEkmgNsM72RoGA9Z8eNJt9JnL+0th5Euxu2L9RzgcFLvB0HEiFbRyA/1fhdRLuoBYdRMEIFnxNZLcnAAhiPwtf137HogovtUmo5PqMBmxj0Bd8biScAPWYGPSAxNWcps11aON/EyrldapqSe7xl9mdiBxZVggaDClshrvQW+pN5uYQa2JQnjt2xZyb/kyiGqFdPnXIGhKGCg5wqodxEdrWrlryzDGW+OZKcTZ/zT8eRU2f0Abtecf7b9FkhExKdcGBivyZk9mMDoYe3Uq9K0HJ264BD+HVEOpdCSIHmjeM8STVhay+0TPy6Kb7OTUlyU1HcgQbuq2UHDA77K1ZlfuJUrhJnkpLTgwsi0ie4ljaPJTHRE6T2y76UzuqX16sBp3dQ/YuPsZMXRf6lYG+cua7/DfzYThlVotqpWAbq1rof8eXLLyM3ykS50+J91NwFP5AdKUEbaoFt3xM2YoyymbPs3CQbFvGYmBSyVBdPuWRl7HWophJMjFm0/AJExvYg6VfB7zj+duDS1IIF0yaDri2RFj8oTpPmpF42JtOlzRU4A1dyfxjABiE9CIxpEepEdDjlfKXSEsbZEMpZo/DLhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(54906003)(52116002)(66476007)(44832011)(6486002)(4744005)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dHRIA6Y7TbqxjPnY2U+w5QuWK+p8YLJREPHFDCzAKTxhyUpcc5PJHSXlKRQr?=
 =?us-ascii?Q?BX2R41FXRRF7/R09aAp9NOOwuGkTOJyjNx1ykXzJtSyUbdp7f/VFx5p87Wo5?=
 =?us-ascii?Q?6d8vsWWzbeE/VvGlo3uQz2lpdCu6s20KAC22pE3iuX3xRcud4zJBzzb++NkK?=
 =?us-ascii?Q?NQnDPMYJNHzGe49riIKUsut5S52APzVs0JWc/6ivdoqhwxVsijXU+uDV7vK4?=
 =?us-ascii?Q?J03EV6mXZpC3JdD1pSS/XVDQ0v0BVC0TT3gfT+zM7Bww0KC6W87IkbKmmOOR?=
 =?us-ascii?Q?jlN0NaP/GrDH4Vb+cs0LXmrgcfx9iWtll4syoQOE2k5D5uKacjyCYgdBXjXA?=
 =?us-ascii?Q?nA981I9yxwXxZ6KQH/P5K8vnFtrD5g7Fkb3R0q+cWJS6ETYJK+BHjn4lSYpk?=
 =?us-ascii?Q?TumQkU5lDvx4zE2R8tRZau6v5vseysNvLvpJ8N0m+XnYXzK1ShvT6xc1ZKcU?=
 =?us-ascii?Q?VlpWzk0PDNa+SU3eaKMAiItnDxuOL8spfc2ZSZojCY2FiaArNeNgyT96CZiu?=
 =?us-ascii?Q?ingFS7FbQYQea50ARP1cx/EqULSQcwSM8XLwF3wz8MIUT3yaV+rgCjFASRBi?=
 =?us-ascii?Q?4lclrI36k5Bto3izUt1Qb+C/2yFCa/3kUTNiBNzdrtQnbq3fV13UM3oOSoLj?=
 =?us-ascii?Q?5mJZUS8qFt9/vPLn7GyYSgo82xkZkMIx2wbH8nu5Up/ZDCgNVqdCVEvN40Q2?=
 =?us-ascii?Q?QFw6KJpfW48fkvR6UV2LEpN9Sl47Jrgu8QGFGKBb7dpsVNJpxDZbdQZlzuiP?=
 =?us-ascii?Q?VlGHfXwInXGGdUvfOg1Ty4/yGcrYp1TmM61IUVAi4X/VvZBxdEaKwGfd6JEK?=
 =?us-ascii?Q?tkR7AbPySX6UVrbC41ZuGHaVWBn9bp5Biz796XDAFSRr2R08g8kX4AmtWBJs?=
 =?us-ascii?Q?KVDfn31BUxowilPSOkb5WE/63GPHauJTM4hCMlf5zheV2RCapiAGyyNJ5NrZ?=
 =?us-ascii?Q?Yv7ggHoKxjrgbO8LfOb+33THC+P5Uxp40yN+JsBYG5uKgHwlt0wb6Cg3CzdO?=
 =?us-ascii?Q?bluBciSb2GS5UAqDfiJH1f2wjfo+prnx6YqkodtslS/u9OibMAb5vxJLDXNt?=
 =?us-ascii?Q?3J5uc25GdfCN0PSWxhJS3l0Md6M53+Xw1Oq0Y40oZn9znK3+KF6hHO7sXjgQ?=
 =?us-ascii?Q?hLPuBjCUink4V8QRN43R7MFj6vC2/wkvdmqHTmHcuE+3BZB26EFzIXDUGZi2?=
 =?us-ascii?Q?9vRsRSeXsNW5n3BciBLqdOrDjlq6Z/3BUXjYcVY7xLp9MuREr9FVK8SV3c6U?=
 =?us-ascii?Q?HEgmDAoWr8ZQBXMYD/00lUiL2cfVB77SHz1tVbnfyn3bJnQiSR1DiGypbQaz?=
 =?us-ascii?Q?1cAU7O0b434SFXLXOPYPbzJWXJ0nJEHxoMeOrpyPejf4ohSlsJvjHhJ0Z6y0?=
 =?us-ascii?Q?EpzVpvGEPon9Eq6j4o1Bq4G//ezO6yywuH1q+AOjTMJZDGAsMNl+Cp6tg6XB?=
 =?us-ascii?Q?BN4HIgLQqdP/tS5uqx3iGscq00HB3iU6W+aOMOsaBOgW97Syqh/HmBQIj0Z7?=
 =?us-ascii?Q?slZat6fL6pcyQsmSwrA7MIlNSpi4ik4QgVGNV9kqvGG0g7RbWFf7BpncwVZn?=
 =?us-ascii?Q?TXezOmZFcfizVxaNbeFYgUUMRxDtOsprjytkwJvaGaw+ozDE/tHPxYDpt8cP?=
 =?us-ascii?Q?esW3jgHMShjapPNmbKVqXU8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2009c73-b526-4daa-ac66-08dabe205929
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:17.3761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6g0OVKdAOfn4LjBYNQWj64LAnwVzNbnQkpRV1O1UFYn9LgMC+yCw92/J6M1RmpTZnxQcdPY8GrSNNSCRmuHhL3gosmVDjCHKMHQ6EJB3fwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly allow additional properties for both the ethernet-port and
ethernet-ports properties. This specifically will allow the qca8k.yaml
binding to use shared properties.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..af9010c4f069 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -41,6 +41,8 @@ patternProperties:
       '#size-cells':
         const: 0
 
+    additionalProperties: true
+
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
@@ -48,7 +50,7 @@ patternProperties:
 
         $ref: dsa-port.yaml#
 
-        unevaluatedProperties: false
+        unevaluatedProperties: true
 
 oneOf:
   - required:
-- 
2.25.1

