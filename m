Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2E65BA38
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbjACFOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbjACFOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:23 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982B0BC81;
        Mon,  2 Jan 2023 21:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7wcofpZZads6L3/2+XrUJtM3DnBtJbI8RnV73mftWJ83cEsyaBSvKdF0ZjEXVoVtVs9b77fGLC+DTnaV55Z/osJArEhmKT5GoUOtVm9ZtzT2jLUOO0cpgeiWy0X7Au/FZCK0YydMHiZn8EeD6zzT+mC/7UbeqEfVdeai3LjCCFG40QSVaiISD0fBHX/wTkgH6rwqz0qKOEtvtsoIBqt+Yin3pE86VD1kfHsOSC4NMUUpNcR7wNnY6NYDNYkLNQqGKFRnEYX7K0qDGtVEZO4+2XsG+z0brBrmXsu1GKuJi/qVOZSSqUHYBbyZ1dRfiNBZA7kITIjqs8OAzuXf8WjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6TxISdy0ZBiWuyQaNqOXiRTe5eJIJA3T89HTJe3DC0=;
 b=Rny53f/0vGH62qwlnTDMG6xsk3KZfPQxi5O6bY6TUpdnghvmccR862LHHRo1l/5OSw2hZRDQO+Kk0PLr2WkBIq1KbUI9UxGJIAhXoWCvom/uzDetDYZHBUtFKor4HK0Zwj6PYiggBwIDyMLnCaB3dHiVOjb8iBoKpCAKiW/nnEBQX+EyuZx4SXJUjb+Jv0fsEzONO2gJXZ+xkwEzW07HLSJqAWIXF6lMTZwvS1O0MtqW/I0C1NmQO/bZFzD/aRBBI/YfGwav2nOhv7NmEXHaUWx0XlcaNWs3KKSyoYJK8VGie+J0Gaf0iC0SUYjOJ0gWYrsDSlcsgnpqfZ4SgHmSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6TxISdy0ZBiWuyQaNqOXiRTe5eJIJA3T89HTJe3DC0=;
 b=bkw06cjsaR1PtGMNR3BAo2P7/mIY8nxvxG46t4wBU/O7kVTfvgxF61d7a2kBxgzqvRniMitKla7nWUFDclT/CQlI0Bq4II3zp5VN/fnL5L8BB+0e3OJCAEsETBFUGe+9DnjEy0R54AA0HBPR2ZTThMkk644U0/V5UGoYmu3vWJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:18 +0000
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
Subject: [PATCH v6 net-next 02/10] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
Date:   Mon,  2 Jan 2023 21:13:53 -0800
Message-Id: <20230103051401.2265961-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: c926db88-b9ea-4b7c-9e4b-08daed495d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7drSaq7W04n/WvypzGHPnNnoNMkF5+r6M/lqCymh4tEw/5cr8771/qfe3Apc9CdxHqlLnShCzs6ODBdtE3KEZHQoedNIybn4JUMPgrQs8ArHXMQJoKfmydOfsPbAmjQ4EoqL/HT7ty0vbGHFUFXI5G7UkyPhlH8rrEjm1jep9+pwDRPFBsTSxv9I1Ai22ZVXZbvCSYqSTVI+yK4t4M6aaOlC2XmJmvcjjTcJGspFTnDIAkWG6g4k1mZUv7hP57Dp71qEOyH8RjjKSxzjlUu5GVKsu9jwThG0T0buAuS9l5xj/9xMRIWnvuuJ5cl1QS8G+n0G8BnBYO3oImSvqpNB5bGe6c5p2JkvLcw0IftVs85Vln0OPi9TLoof1gZSkvAPd6oB0ZP6g32Db4HDnQa4QLDRYqvlPIpA2oaKQWjmdH1O3CnJnpF9e2mMOnV1er7UyO/MTzU80eakcNONAj9RgLQcaGXkyzwzvRl6Fmc0uJGZe5aQYJIPTcPfY7Dj6gRlRAbgu/0Yk8hZiRHqda6pG5Vkh5RPiwgz8lMaWSMtSi7gxKCLqEaJ8fB0rNi5X/Hz2z5FHud+sh593tTp3v2f/i+ziR8fEfZw+i7oDvBJImukAiHnOyzSnu0zztf7sDy3a/q6xb9qwsuYBWkPczz0da0TNoQwQRYOEY3u0vN5iwU8fnoUE5wN2u65dAoAweZ/dx9tZMDUM6+xaLTozzVig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JYIJ4QdfziifASH4u2TwJp6M4k4k5BVBMltqNkdaDp6vIXjJ+QKNigE39NYu?=
 =?us-ascii?Q?BxmRuIG9zzUeyTjktWSCMFLS3GLFvAqQVN4iAswrPU3hbixA4XxEASmtiYg9?=
 =?us-ascii?Q?5Nm2fYW52OUVTW2x80wcJ+ZgEpJPEBUjVmZd4PBjy6Cekslk4F/rN0tcZ0P8?=
 =?us-ascii?Q?RNKM6EBSQ6h2blLWMSPFAshfr6hyotkCyaoUf8IbeM9aELyOabwjCCAGtXsF?=
 =?us-ascii?Q?oiwu9Ac2YoVVQmtewmBKJYGylvu2uJu7pbIAtkUEQsJb/4o697on+oX/pm2i?=
 =?us-ascii?Q?Gu1zZ3EBRDMoYHeGZAoxj9Q/rcQquX7nQXqnYJp87oevlg0VIKn1q4qkRryd?=
 =?us-ascii?Q?vRXSRFm/CdqRT/cBrKceMeK6UArxlV4Dwg5pE1RHzJcN02GgWee4FYyHvTEQ?=
 =?us-ascii?Q?qNOolWRF5fxd/0o4R5FvlpMK355BT1bb0kH67Z/U8VqPqRbmKjhi840oFihq?=
 =?us-ascii?Q?JIKY1ob1P9M5Q+219SpdCnWWsvIVplzpqMoopATIhPbm/lCYKxP1n45gnUQd?=
 =?us-ascii?Q?BLEeq1GdhY/uCOm0Ry6Y15Vcx5OiALp/AeVhF4siVEkr4+uETNuH4B7qdeFT?=
 =?us-ascii?Q?QjNtdrgMQPvxuwjS7usn3/ds1UduujEvOlT236wziF413gTs7h8qtYcMB5OD?=
 =?us-ascii?Q?gf+lTEjdbmsJhUMMJ/Xj/htxAGoYTHatnvv5UwuGWb429T5VlA5Dfb2eANnT?=
 =?us-ascii?Q?KaiyWH5mpCzL+lmFfeSOTJ3EiE4oWzbLvpRXcrw5L1S6OviLuY29POw8gGnk?=
 =?us-ascii?Q?l92uLJIoi1FjM5ihCP/3y0JUBFdykR3tvx+x7s/84b8VmLVhyaiDOXK5KoOF?=
 =?us-ascii?Q?ZpHzWB9QEi00b4e9o05yQIyClDuu8rj1oggdsrjRcZzcCTI5H1/Q1m7TINs2?=
 =?us-ascii?Q?5aukIsFeJVdm+r/vNVSBCEMtQ19JCpAqxsAv5+vhwOxhkPgcdHz3aoX6QCMj?=
 =?us-ascii?Q?OnKE4QtpjI+4f8MVxBY6PSktzGWGE/hwvMrQqXVIO7ZLU+I20/40eJtml1ok?=
 =?us-ascii?Q?mkho1ibv+Yyg2r+UbWZKWXYQNOL+psVzzj8TFDygcsy+wgIk4QwEn1t+mZ7V?=
 =?us-ascii?Q?cRgeh4sAychy/7GIHfYIFwWzgpRNkJiAZ8xtgJsr+obUEtQ6rSEcADkco4Ij?=
 =?us-ascii?Q?TLYlTVNYKz9EazdRlSVc3ZBBR8kkXBfDc5RWT/gCIZjPcYaHlYfakHhTWydK?=
 =?us-ascii?Q?JizyvCIXf2eAozSrwC3ctjqBzHZYMIQ6sdmR2YlNKaPi7BvIwoahPmY+I2rU?=
 =?us-ascii?Q?h9HGfD826TdfRd7ja0uGYxsX/v+TyFqwnUEEq1ub1T9PHEbh1zVRlSt394hc?=
 =?us-ascii?Q?CQ8gO9tfIudEX5tI1W92/S3pwm9iXk21Hn5HU2XFpS3T/mJnGIITI1/kmucP?=
 =?us-ascii?Q?TgQpIvx/sowk90ZePKYQGmjtjF1XgrewKn+0mdgXiiHn6Da2C/8uvBqNCqTX?=
 =?us-ascii?Q?0jDkU9CfT0PGWKXMwfp5CoYrsWfMggUfwDDbikqwrSu4fmwQe2q5P8h1smEL?=
 =?us-ascii?Q?U0MZT17u/206DcuGhb6OU1/LLpIDi+ekcC7DwlaOT4nYw8DWu9moFQSUrLuq?=
 =?us-ascii?Q?v6hIQC/7NMhD3U5tFQkF+A3A7ENH/A0HpCkLAJQSVHIbX1Hbu2wEhZGDZqkC?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c926db88-b9ea-4b7c-9e4b-08daed495d89
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:18.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnx1bPxNTr1unyplnz45pntBK2WFN626dPFJdlQ4sCbruIepsMjV0Qqu4O8pTu6dNZkQSvs2V6C7WUpuCzvdsEORBYswDORL9f7vCUW/np8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property use-bcm-hdr was documented as an entry under the ports node
for the bcm_sf2 DSA switch. This property is actually evaluated for each
port. Correct the documentation to match the actual behavior and properly
reference dsa-port.yaml for additional properties of the node.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v4 -> v6
  * No change

v3 -> v4
  * Add Acked and Reviewed tags

v3
  * New patch

---
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml     | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index d159ac78cec1..eed16e216fb6 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -85,11 +85,16 @@ properties:
   ports:
     type: object
 
-    properties:
-      brcm,use-bcm-hdr:
-        description: if present, indicates that the switch port has Broadcom
-          tags enabled (per-packet metadata)
-        type: boolean
+    patternProperties:
+      '^port@[0-9a-f]$':
+        $ref: dsa-port.yaml#
+        unevaluatedProperties: false
+
+        properties:
+          brcm,use-bcm-hdr:
+            description: if present, indicates that the switch port has Broadcom
+              tags enabled (per-packet metadata)
+            type: boolean
 
 required:
   - reg
-- 
2.25.1

