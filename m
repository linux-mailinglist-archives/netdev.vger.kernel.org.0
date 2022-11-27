Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54F8639DA9
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiK0Wry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiK0Wrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E2DEAE;
        Sun, 27 Nov 2022 14:47:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTIPFdc9OqdY1VNmLzhWFsWidCebOcunMqvyfdU4G7Ddq/lol/csa4c2ZPFK0CEM/h3zH16iZbD190dfIR3ALHPJaMUAvCaVsCcH4j3f6RritrvW5dRWNzftL7bqCvO2rhXKB6Gn2yHDK7xY60mN2em0xoshiHVwYa/dnrdhTXkq4TvfvLOEbw3HTsPyYg/KJd626Mt9/Vqv2Ia+8jB36CjqMXYiv9L2OeXiDFk4hU/1h2GO60xY0oFV2my3VuwJqRdorEl5eNPgFcgD5Pm+UVuO3rGBJbi8DCeGtc0WJguw7aRmUaw4bCQMZcyfff18a7rbmqFogJ15aUy3pi5WXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcbWsb9oJJB3MTUecATLv2JH2gCX/danEzE9/kV6How=;
 b=CEDfUohfPgiNR7vvYfiJirXzrm1zEX6GDG7DjzXdUbBgmpl/RDgajNkdtjcL0Z9nJqA6c+iknfYg2ls4zIGShZmSrbPQx2YBEHQnZoeVnhkOSwvtA1x5Gs5bue0L8iUOMn4zrdIc+wSOuqaYziwjHhDmrzBzInNGWLtLtz46bOU2+niHQwB+bsQhmy/Lhrcr4Dvuw3oD7dnWiZNz4XChXLWIAHXGPSE1WZPR+f9Qeexj2YU84tvIVREb6vhLlnqAVh+dKbIL9VTKJiWOokacAGXpslVqDGjK/MwqjJI0W7lNqoLXjfEdccmQgaXEp8NklJsAR6EmNPH5Cd/nZDBjOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcbWsb9oJJB3MTUecATLv2JH2gCX/danEzE9/kV6How=;
 b=B4WlSxkPnbUVc8cbKz01Iff8bOZK7dlJ91fmgZTxT1Rq+00lNqEsD8zP1jSxZD+R3LdJl2MgcUYWP17ePc1ayb6LCUsEbXc8JVLj/mczyMAynJE33wztrdkvuZDemHJe+XhE+6N4ytHzmmUhfgvl2KgKYaDUTZguLngUgB02x7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:48 +0000
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
Subject: [PATCH v3 net-next 01/10] dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
Date:   Sun, 27 Nov 2022 14:47:25 -0800
Message-Id: <20221127224734.885526-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 14587bb9-4a40-4e5d-9929-08dad0c96833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUlRkfqYhvmg3BtkgByfwhz93emVcsxx4jkTUCsWuiWXNIe3B3w9aDWSbj4qnFDBu5Z5AI8pz0LdLXBUyW3g2IpNYX6vCksCT6n5D9l/hTGcoXW6pseB8DRVjvmVdcFQD16TPkdMtrwdQw8sU8ofZ8QpcCgyMV+wHpfuisLXfvWqY05vQmr547MgNFlSDy+0EU4AoqZ1tE0ehJRfmlQZiB8avjc8zA94VPGeeb4dw2MHd1ITwZcAQUdFFMqSaWdi8qplAjwj+c//FvsE3v9IgL5DMeGTV3SZtDlieGZ5cxGCGUuitGEzILxkNLm8L0qTYqWYxXiykjHn4vn0jd8Gx8KHMDNuQHaegmjKL2ZwhKlEOHmOd3qJqMqeeaBodI7OSMQM3Mjkt4+Zjv9fo7jltccrUZgKF4hmz//hin0lqSQDb/yC7MPKf/H8q+8ACGDMPn2nYRrOhboZR+jyW0S+KXZbZHXDneJa0XHF0qoE2zNE5erVHOUW5xP+I9RkmBybvaxzXR/xehZcrjbV8vNc+p9vge3g0iFUZjyFCitrtK5aEqv2DeDTlXvQazH9n3MHCy+6SAyA/FSbi4yZW3mO3mFY0R8wCjUXEJO0AbeRmzM+Io0b7wxsjtsb5/u4Bh+qdM7yTLMglcA2fkHK+YDML0pL8EljdGiYC04qkZxqdxonBpN5anszOZ02PxQu3efj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKphD66QngkxR+bX0nSv70AUpQd0CTtpADD5kgZ6JBiqQUzM+LKrI9rFkGv+?=
 =?us-ascii?Q?mgoJ/aXIzy7SE9rlxQ/MJkDBbbpRtM3bfiDB30zYC5KE7Ey29rUgbRMAu0ry?=
 =?us-ascii?Q?R41d9r2pVp74Yy5uZQM2XqoJFZqTgFVumoCWxsDPh9aobzK2VK0maBfGKREw?=
 =?us-ascii?Q?CWmtASm53Emj+HZBQuB59G06tRf2OmZrVrwtyntMHWaDe1lw79cIgbTuaAVL?=
 =?us-ascii?Q?/+1YDIMGOE9KZ8txO8Ee0cgHHG6s2XDcS8hfYKd+AsMLvjkHJJ9O4wvXMIE7?=
 =?us-ascii?Q?Byq9E+/FrbhxHlaXEiGhFylSbm1CBuDWHSYx/FPOObQFfV8kB3jIJF8gcXu1?=
 =?us-ascii?Q?0yTlVBSh7DudEqtJx2EikhwIwRZsulIzwFfDGETJR4eTeKMC0TwKYoV0Ch2s?=
 =?us-ascii?Q?D0S+951P8aucsgLw6/isLoi817hovdzY7VGRIHWU8SGL3k7OFoyCWb6lujOg?=
 =?us-ascii?Q?cmVij+pJkW7KQ6UddWHo7tZjHBYcGC0sNvBaQR8iLVMbe0itCwyOO8vFZF9v?=
 =?us-ascii?Q?bCChlyCYdDuvYjdhROca2BFFqv8wjkumhe0gT5WhkqOtwdxAW0ASuJYaGaHE?=
 =?us-ascii?Q?QyPrnt+gexENXT4GhZmIuF9/F5Xf9jftC0sAfAj4XHmQQ1gFtQsd213pHWlr?=
 =?us-ascii?Q?ijMiVWaRNARayVG/CG1H4K1hq+/UP0rnE34X/wximsOFTh/38+c/XfzkoYhl?=
 =?us-ascii?Q?viH99SEjqNpwI7mxGHF//wNzEv/vlXkvjOjqOKq/Elr/bXbeQKVx3e4xaB8F?=
 =?us-ascii?Q?6M5tM7AzfP0SE1cZOh+MIe3cetAkncan5EMzMa9kLMOGdNuZkfYOz8Q3uqBZ?=
 =?us-ascii?Q?Ca58VVlEwUSYXHMmKyqvqiJzQhSc/5E/FV4SoAHpn1Z3AYCfQcyvKfzlV4X2?=
 =?us-ascii?Q?UV2DZB14Fkb+o4cjYQkbU4mJQBGbtVYxdlonBsyHNB6weisWBslpkV6HPadY?=
 =?us-ascii?Q?9Pyen3gKmloCdLIf6c7EEbS7f+PecMQbnSNz6uffzMfdVl2blwWjkgS7ks7J?=
 =?us-ascii?Q?CVgzmQUbjZRzjz174xmSMiSoj66ecTI7fgnF7C0A+Nb3bUvHYWAcbjIoSEsD?=
 =?us-ascii?Q?rBY0hHNkobZb58kd4vQ2Xz+MCMTxn8ZjP+YodguGVyALaWg8hbDEuh8eeDfj?=
 =?us-ascii?Q?TvlMlSYHzw6CDb90lAuPWLe2ksQvlq9YWXyJIzDymoLDem7Zmw6LPUBpx/gK?=
 =?us-ascii?Q?ri/fITyP2fHf1q7LXwMaIsexr9NVTLq0ouPCyBXddJCZUuUr0NFLDiA5Lstq?=
 =?us-ascii?Q?F6PHkfxOOEF3Cxw51KfCh79L/3+vaaRkosOAIT+oG6MMbIEF10ijlBQTfhEj?=
 =?us-ascii?Q?/mS+Zy+KoTgX/0z7tG7Enhz60liIxnxzBsTXxJ6W2s3VUQH9sENXefmIblk/?=
 =?us-ascii?Q?gFkjE9GVvGxsEiOJougbbE2InyfJpLqSo7zOLaptjCRA2SQXtCaR6VmUWlIn?=
 =?us-ascii?Q?5siFdffLv/MGWw9I7gFIdZZmyAEVcEzmftw82L91GK11syYQP6ccC4fPS/Se?=
 =?us-ascii?Q?HRKzSa4DETOsfR/SejpxlTpGhMnZH2qLZuYhHeW/vmqUwfoGIPSBYfodLJJb?=
 =?us-ascii?Q?TtU+5gt6vauRVyyFWnYZ3lbkP977oaSWppNRnlkxWyXZYRGx6+Fr55nJ2nkd?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14587bb9-4a40-4e5d-9929-08dad0c96833
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:48.4374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WKf3H781wnNx0dQf2WPtnLf3//UCezk0akZtJ3EyYsyd2QwNL9MySXn9vRaPGwD4FogDyS5TNUDJc7qSjOYfVqnOlt1+Eya1/cI8GD13/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
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
---

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

