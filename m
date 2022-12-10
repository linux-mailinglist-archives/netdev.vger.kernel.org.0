Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81547648CCC
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiLJDbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLJDa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:30:57 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773F38B38B;
        Fri,  9 Dec 2022 19:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7axXMZU5agFtM8CT7wiusAYYAcmHfxlAOIdW7BFyIDkCzzTWNfcWp2WzOICOfaJgvJemyGOXD55eOEW5ZogcpflvWvauq6Q7ctK1vzTPhDb2A8VIXL8PHlcQM4dkOkdshjJsvpp07h1sgrq+/EWwlAd0RD9hDTn73M06t1vn8zFnbwS3gI3hi9RIxqIMSjdLPDl/czIGJ7Uqd4a1V+0DIGVUI3cSyuIp1AAEEpOcxs5hnxm1GVNLI3s+rTYWXG/4oIHgcKlMyk4FhfsZ0Ijcx/FNe9CsQ6wLarjdpP30R3jrMNmIpFO7qlM59WGke/8C3ycGLpCSfUPR/wfA7hNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjaMZnGag/P+VQM6ozRTghG4Ww1JDT1CjIpPmJJncEI=;
 b=KHxhGTDOAyNmhhKqQaAWcRxwIglOCnjw3za9q8HZ7f9lt3/aT0aylDSDKJ0dTAw2rwsuaNh4c+xeikarQXRtj+Yknzvl5fGzHNpbpjWOaxABWCsT9BnaBuy3oFpfENHldmHlt4CAOQBpUfqR+qPbSG+8Tp+I6+USCByFQOxOxxJeTPBbXI/8TX2Wy7qZN6w9adGOeX2GS/lze9166e2tX1aLcpx5QGSE9Om44CipC+fz+lPXwX9woXQYUQe3psyV4w87NrWsYSB13B3Wih11tji0hdFER+QDZKJwz6rgsW9hxxlR+PB4yf1JuACYMWYtc6WQIBnnkXy6oTVBCkzVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjaMZnGag/P+VQM6ozRTghG4Ww1JDT1CjIpPmJJncEI=;
 b=gOtHhIGwjc3ZEZ43aHdxJUeWOBj52isFAagDPR6fsqOF2uUvT09ZwkBbpwc5ILFccJNYF+tOiA9mIlvIzRWQE8uyJPzV5GbnFNLfuNKl7ECttfKx18JJigybqu7jByiUP3l4aRIAxY2NDpkLV8DtsgPr7A/VjJcDqy4M5fkRSno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:30:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:30:52 +0000
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
Subject: [PATCH v5 net-next 02/10] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
Date:   Fri,  9 Dec 2022 19:30:25 -0800
Message-Id: <20221210033033.662553-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f107dc-6538-4a34-c716-08dada5ef03b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KiED3mnu45pl8kbP0h0d6ujPmteSGe6/ouAvEPZB6cmUug9WUg6QGgsGRU0+NM53BZP0/HTQsA5CrozaO01FR42jRt6JNDL3hOA3L0IgHDblD2TeEJ1rYTxb5DlUcmsFXpEDGgVul8AHYq2nS8VxkzAO6IIP9gfreDzBTLm5v+T7mYOH50Ocxudjw+8MUlmUwaHwr5nkEniBRCEoAXInCZOzHsMNy9XGKYRLOYeCbxU3yK/1GxOn5ujWb8j7eQnOv951IlVKgGi1sD/uyC256tjhGc0moPTaIyITEaJJ0GOqcJPNzcawBCinYztIFKQ0CxY2gM41AZn3mjStd6VKRjl+pg61wjX1t9/Bhw5E4+ndoDne737XkrHZFFA30QDyE65ZrokOLyDBVUUIOO4DILDt6mqfajrC3dHxZIrqSRZxckfqh5YasOTGTapGaONgnsbBNkrK2yv02zQ8n+GTMxpc3EQ9lRM3N6r618Dm91r5oPin4TBmrFSYHHwBwyprZhqpH6rQoeB03gjmztky3ck5VF5Rnij0GhrJH/DtniU93ZmcQxzCIPRw6nGVpDNEapPcb8z1aEi/MBUGaXscPdUDCBS2Wtoikleq27ydJ5mGVT64ni7iTIQaIYyKOtwd98sR2UvJffFNwSvICBjxQ17tbPZiJK5taA/J30jVZG4qI5zW5YLTGsHont+sVTju
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39830400003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aq2S7LE4Y9oQ0vbnhkTK6rXMf6M16IBccKGNrIVNYt0Lw8nrs8kz8QGjBcm/?=
 =?us-ascii?Q?pVmbYXaGItscHbESnARhfliIMVNJEx+ZuxSs6ZS6MUV+F08HUNxGDSdl9YK5?=
 =?us-ascii?Q?8B3jT9g115RJMjmcRS7Mc9RWTifVIyySzUbHGOHTBpjLCmf91j7b38QKMyAx?=
 =?us-ascii?Q?x41IJlpYBvN7oRvp/MotavGsYyWiTvX9gE7ZoTjRpn/YAxDM5KD/t392G39b?=
 =?us-ascii?Q?rxsWArc+9u0+weanePuEy6WsHnp8uAYYxndKoVC1BxZzAwHYKVwpXqrYuiB7?=
 =?us-ascii?Q?ndUZSK7rdPaiselydvvlR8M3rSE5UlgWV8LKGLTzeoBw1Ljb7/XMQpwzecVt?=
 =?us-ascii?Q?Y/BFYwMtpFm4V5haK4rT0OYLMYDfUcgm/Lgh4PUoswHOR07rMfmUcFblCoEr?=
 =?us-ascii?Q?O7EEF7bQYB0DTO1yEFEdaWFigWONeGzDMUeYS9GpkkKFfNAH1guLnP0l68ea?=
 =?us-ascii?Q?3Gds8IrdGTxfxboukQNsP1qERctkdwaC2goTyaAfNVQXfk8yKO8pPQdBetIl?=
 =?us-ascii?Q?cF1McRfaiT4PK4HUGXxtoISk6IBUYR1p0pjkR9kVBC8SCwlxVmNtxHPYVspX?=
 =?us-ascii?Q?5sTi3ukyRdBP88zq2bzHSR3C9y2qeFepat7Lc7Ca0u3Q2JGSQI2YXXV1W2bk?=
 =?us-ascii?Q?BeBMcZ2CFeBz6QTRFvi83NiHBfwIm+R9v9T1dIlcM79Maw/Tp6SzT9UQEcUn?=
 =?us-ascii?Q?AAuQl71AyGk+sXmzg8x5XjbaiAeZa0GPn/u4wniCPYI6b6c6UqxqTVRV1SaJ?=
 =?us-ascii?Q?m3LCw9x/rz6mrHuxj0Qgj+F3FCYMlpy1SmtMO1zz1uZSIB8q31+ziqGuRZfz?=
 =?us-ascii?Q?rT0nRKFIWBJlsYMVjYY3gqZIunyGFqbaGXRC8h7O+U+5zynQA3UqL3X9pZdZ?=
 =?us-ascii?Q?nQRHFNgH7HuQ+cL/5770RcwL0qBxyNTdIeOvqufLlWnromFfnis+Q73QGmFF?=
 =?us-ascii?Q?qDyb/v55xVsubl5Qb+MMNWyxUl6DgGAZ/JZK9G1u0TSNR+oKc/PVT/luiM1J?=
 =?us-ascii?Q?Vfq1vNU0AAQsoD8uMUk4MI+D4Buo0wgAG7GMj6oRZ24VZRX9xXsJUwhpQWwx?=
 =?us-ascii?Q?JOluCKQswkKvAORtwrLc+y3GsOQ7ug5pLh7aZl7NBEHCP+66PuExqIaRMtTs?=
 =?us-ascii?Q?cQurdXEBjvPeT0xCpVX/o7Zr9hCtrpnefpzrHVm1SirI68zGwwQOnp66ip8l?=
 =?us-ascii?Q?K9uQTFBMKp6940J8hEedn7PYjCbqJob60+IhwZM7KIrRedAP+AYEurj/PeGk?=
 =?us-ascii?Q?hLR63cHKwGy4/FM1hPDWVObVkWcktHGs9VZ6+Ucy2oJWmhgV1bNmVTYKSHFj?=
 =?us-ascii?Q?etj/L1M5vTrk9QrEIh5B8cGE7nnn+8/fpOJLCjwqtDVxM+WjDxD4LLZEUuaZ?=
 =?us-ascii?Q?mzf/FzxT9C6U9B48wiAtG1zFZpXI/yzAJRkikpqHlevJjxGyNqbWrIio7gzE?=
 =?us-ascii?Q?sKFKU2VFGt70Cbxx3/iDfdi6wbKmT+g9o5yLBXH0YAp1lfSVuPCWputGgsLu?=
 =?us-ascii?Q?FnppJ8Xe+lQrNt8KHnQRwjGjoxp24quPggJ/9ZfOFRzGLEp4UOXTnrjyYftp?=
 =?us-ascii?Q?iOAB+8NgrpOnmj8kxAIc1NOwIbMF7A45bP/vt/QY0xUQEH9n2O2FX8h94//q?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f107dc-6538-4a34-c716-08dada5ef03b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:30:52.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9x+dQ0IeQs3DUjz6KqFRnX0Flnwg1bCKCNFh6HqB0GcAAe88/KF6vwdT7hDAjGf8xt4F+XqhRwaDpt0NTfi5TMVYl2bH9Y4PCqdFHoN/wxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
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

v4 -> v5
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

