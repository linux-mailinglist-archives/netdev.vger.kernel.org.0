Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65051667DEA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbjALSWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240578AbjALSVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:21 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E32913F26;
        Thu, 12 Jan 2023 09:56:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnEoO6vaKEz0os7Ji8TAU9tq2/yb8OLdF+/WPX7Q4kGbbs8kxeTmMClF37FLvZUU7XjKWDnhdZXp6QZkmtRHsz4kSyDSXJ0rj5CMgVeI76Oxa1kIa6XT8/XrAoqWMXC5ENtaJNtf9EP7iMY+/Vx9VD27OHccWU9MLaF7h+mWr/oXOv5N+4VjFLVxOCQsxZjZZcLLmyhWAqSNZY3VEfECsgyaor5PDWnjKsLOZogBiIn9bh8wSxhYH14I5+L+VKyDsVRXF3T1oY6rjpcWXV+u/Lx9WYljeYCfHP+VDYsLREY6FBd4XZVWAOT82QyqSRJ8YZjZJrbG+Iwrub9EqYl60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qd/kAKEvr3Tcc8Sv/GkNlmr2eKPdfRYoeXyEaMMLtoc=;
 b=jsrqFFOk4XH+BaSD8GEe+xo8Sz71D+jwj2UAb8RZ4988dpLShC5Oca/w4ikHbBFfj4et/bIEBK6AxGO/gZtw/izH9OqvJHP2fc68/0incHDErnebNsI9r1yDcn2DGD1KDp27Win3CCQ9w45LebtGhuRmV5j0CJrMHE3T69+Qk+ECMwCorWWBMpHPD/KGfEjl+eMwK9PiZL+lI3h3rUuEPufyeFIOjwcyAEaJF7GkIe10ZTx+mpLBBmWmQNKkXpTs1MOPZHMKT5W5TQiYAH/QzWZxpd9Y/W3ssb2J04SeT3VVuJnUfP7WOfWksI0fXajM0I4fjbVOvzRtGqj9ynC6pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qd/kAKEvr3Tcc8Sv/GkNlmr2eKPdfRYoeXyEaMMLtoc=;
 b=HytHi4S+DEbQlK8TdTiP5r4gE0J5zAOY+TR0aYzOKZgd3sn70W+O/a+uEsTSsk9Jftisa75pHDixnhBMWxRFMp8MpAJtTYCou/xsGy6G9IItDBhjbq2YKPYYolg8/eSaVjOMY5+yZAvxvG/PbqOLJJ0rAG+XZ9WW5kVvQ9WvNWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:36 +0000
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
Subject: [PATCH v7 net-next 02/10] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
Date:   Thu, 12 Jan 2023 07:56:05 -1000
Message-Id: <20230112175613.18211-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 1afa9640-b95c-40cc-6718-08daf4c658d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URyotYrxwO7BCHjDSLr8nlReMlCrZoYx3R6VIXdKZldUQTu62hI47EciA+suQFGa/vcn8OX/ZRGqv7pggBqWFffvHxNvn8UT7O5V0hCwYbMAvaWw0cSzLWG1vOq4TrEsV2sohT4B3/lF9E9NSReB+b1Q4mfV0dlJjwpOVZWz8LHx1lghtwhB0ZSiK6nHCiLXI15+MmHN7sBnB/dhGKJ+oWNhvqI/pvIlpSWhi684MPHffRH6+oLlbKIf3Xn1aOREeApxZqnBPpaU8sWFyF/YEKeYVRaCAhFtKfMquJXS3WEyrV5ajJhKgxJfhNjphEqnknf+cICYRN+CpfGUFHEi/Xf5cEpbOy1mLfbJnWSttMrOm1yTRxSf3U2VJspcJSMIMSbQEPGJwQNMkpCtZ3Sxuz/KWRwemeveogFORWnmJkK8//obfQ+1jHe+coWHaLg/SZIab4Z7Q7ddoEbHetIEuRav3BA1tc0ipQ0XWmwaC/2ZziCGZccZskCgaQ3rtXYwkVovgcLC5MqsOLIDKm8/+H1AP5s8h69GNnaneu6xkaqOey5L2E5Q5ZOSJSJ8MMxxRLSqJNMwijrpHqYDCHt5dcv1rAeqMPIqnfbjfSoW8rqSA0gqVsLS+gWK1t2s82Tj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39830400003)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(4326008)(8936002)(2906002)(86362001)(38100700002)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PdSBYFt6Dn3IfkT5J8jWvMQZBDpibv1nu7mjNMzcVfZpd571v5TojJZJy0tU?=
 =?us-ascii?Q?Nmk3Zimg94DXeXWbi/+tN1VYVsHbZmgmwIM78qwakQi9KLOIOTwIa8S9KixP?=
 =?us-ascii?Q?TLWQvP/31g/asgLNe5MeSDIc76KIa1LsOYgB+fb5z47JYYINu7aaOmUWmkPN?=
 =?us-ascii?Q?p0m+8gCvD6ZRbHPWUruP63ZFSGOqbNDnIsCkGmNpO+WOwop2Yg7Ew3zWd2tP?=
 =?us-ascii?Q?X8X94B8xRNbsxrQNvJEYA+Di5R2c7zhTEuw7fzVpc1fn09NU7Tu2qed86MuG?=
 =?us-ascii?Q?xpfiEuZ4GPaRc6nNGsU5BwCYUIu52cDbc+6dHRFkAcWzmYnnt+O96gC8Zfit?=
 =?us-ascii?Q?dtQPvvjwyxbJbjLHfbL+jUy6FRO8MBFrP9CjpqWpk/PoQlYpZlwWOddWjBJz?=
 =?us-ascii?Q?R0oVFD5ni8zZdmG8X+429d9rOpmv4V0dPC0dXejPcH2/6fGiBNkJPfmL6ONV?=
 =?us-ascii?Q?jhcPJRDgYhhmuMsQEBU9umKqB+5ppQk8QO6mN2rYu/J72bhNpEDJyKtQ/Wcg?=
 =?us-ascii?Q?4uIcuPzfKh37OlnrnvQW2jarZE4ElLCWjOw/DGqCI/S3cUeUIg/Ca7Y92Iv2?=
 =?us-ascii?Q?WcdFRJpOhhm/pRGWyU+nFFkFFHmvNlry+3dnM4lzFj8Mdp9Tz5LihK0OmRCC?=
 =?us-ascii?Q?86cDsp8UjGDKtM3gXg0oezIh2l7jx1B32G9tzgxLxsCpbDuJ0u7Tg+iUhnJP?=
 =?us-ascii?Q?E/itxDsRq3ZdU3ydnHppTIDEdyOQIaY4LsQPtYmvA6DCIyi8zbTd6s69a97i?=
 =?us-ascii?Q?U7r/ZJ/zdsUY7EUjDZiZRKhBMua7Iq8eCR8P3QGQ2HJdhQKNbCvwidjhuGTo?=
 =?us-ascii?Q?R6PDui6H/M5pt2ckhsnpiiTMiYUmJ0LR7Nv3Kl3FW7WLg5N9pRVPDn+xeLKN?=
 =?us-ascii?Q?WsaPjyFGC97FSwf6J3vzqOQvgHgRuYus/PW+egQmIbl4zRG9UKlGOQesOjxy?=
 =?us-ascii?Q?YVeoGVKNZuds/3IAOfQrH+FtP2Xq8WeRBs9uzvOJrAS3+neFyMbXsQbAqtuh?=
 =?us-ascii?Q?sJftzidSx78v94svs3nJ4oeP4ttHZcA0BvPLWAeS62emSMcLFDlkDIliUmAp?=
 =?us-ascii?Q?KcICRIO1niI3wZ3PGWFdLEPU7t2MXdt1E6PTdthRQmq7KFl0LLg3X4QgG1Tt?=
 =?us-ascii?Q?E8szNRBgYvXoZMhvb9F721jjVaMZNTCDYYnhP+TJo/G88DbCGKBYypnZx68G?=
 =?us-ascii?Q?6zpIWMEl2sdyWzDV+6FMJZVgG+p7h8vJYfOyXqX5h/Atx2TFFq2ZKGvVKcDu?=
 =?us-ascii?Q?QvtDZjrmw+Fxg43RAAg15TmJLWlQhif0QKrqlro+u9vdokSjFkWjxvKlESPL?=
 =?us-ascii?Q?yDKYq5r4DKlCu4dWZkV08jGHOwOIl/Sd6GoHH9cVbEWy+AAxo7OqCiya6YBI?=
 =?us-ascii?Q?ZIWs3kh9QbE0D5nAbTBikMM0wDPiWaP/7hYO6u+4S8PfsGyRleU7QRzn0kWm?=
 =?us-ascii?Q?QmGIM7GZ7FQnp6Q44XqxSy34e6WPFKyWlLR8ougFCgHUU7Lug5qnsir5fTNU?=
 =?us-ascii?Q?0XUQdvlVxdz5G3zP4Qmh/yDUDWN21u/h4jg9rx4e6WIH9B3c0xCBl5FLkg6a?=
 =?us-ascii?Q?JWyDW6pfSn6U4ZvWN/5oXRREoGnDYGG5aSYzjoW5cGsctLDxMflFTDN8pybc?=
 =?us-ascii?Q?yWw2cF7NavEnWaWjDes53Hv3m0h3Z8DeJX5PqnbcawujFUWHnLGA2vqAjivS?=
 =?us-ascii?Q?kG6VHOg/19nhmj+Y33YRt8qGLxY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afa9640-b95c-40cc-6718-08daf4c658d4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:36.0175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9iee6IQ1Wmb9hR9YN7Y0X2GmP3P60sVqvvakRUsgy/csbDJVm8wI73BEW+TbEIs1ddBWy9CcOOsm47nn6+dT0fF/lNvXm6UlW5N9k3+fnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
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

v4 -> v7
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

