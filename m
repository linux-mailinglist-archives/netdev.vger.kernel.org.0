Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094912AB547
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgKIKqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:46:53 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:20449
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbgKIKqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 05:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkeRJdY4Kd39QGogOmArs5p5azmCuBxbgzKV8QzkVzWZJXb9Dyq+5LY40c/AEMf7psLjQqG6fd9o7NKcIaRKCUO3sj4o3ev5SgpnRp3JfZJo3wQz3pD403CkCJ72MBLu2FaZ76cNAaSwS6TEXfTBOzN+gY+iQk0E035tkUBOx+sdEkWiVtv9v3GXx0LBpP8VhjNLhzfNUYX7BxPSmq9wWmiDzsxDDqy17Ik34zQAHXtLo2gpVM7sGVDgs1EuIPXboVZoJV/20NwA2ezBUFrWYaEjDNFx77glpwDgzMdzeMRJt34q8M5AtTqPFnr5UVt0wRwtUmHil9tJ1g8o9vWPMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab2uzMqXz4V9krXxZpAa7O0DBMlmavKaa4JUqz7br5I=;
 b=NfPEfoseEwQLGtsrXuQPQdD2q6A9VuP3krUIz5PdkEM4sQwbts5muraltVCz/EfpZAHHniWys3GadXX+ckmsz8q1vVUpT90EudKjavX+lZu8t8tqzkaoX59bpV8FYJdtTe2g6M7vdLVB6gzTwwyl3jQN6ORKxqE/Ip7K+kwsE2a+Wo4t0BDWAhrLCO/EFA/LmZ3ChKuEgms4fZOYaQnhcw8KauK0yT/kZJzbPpEpj5cp2t64mTWmpdQcKk6Y2h3O5j0VH3uNigsfosViuRkIenrrAq8CrLVW9MLQU/mYgTiMaJCaDcizWFC83afbyQYuk/J891RJ3n3h80sq9JZ/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab2uzMqXz4V9krXxZpAa7O0DBMlmavKaa4JUqz7br5I=;
 b=LQhUgUzxfzsJ93oiFX1cCGsQc7cYvrkgnpiu6UZois3V5M0KFRmIqaHnC2yFrn7weQE0+Mof3j0PBLJCCmepDyjniBN5DkOrkEw02W47N0n/pBng7K6qcs/VJ7Zt/Zpiv6amNDcWbNv48Qet4xWL289x985NNzvwElqxRQSO2Ms=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB3982.eurprd04.prod.outlook.com (2603:10a6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 9 Nov
 2020 10:46:48 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3%2]) with mapi id 15.20.3541.021; Mon, 9 Nov 2020
 10:46:48 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     robh+dt@kernel.org, leoyang.li@nxp.com, corbet@lwn.net,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v2 1/2] dt-bindings: misc: convert fsl,dpaa2-console from txt to YAML
Date:   Mon,  9 Nov 2020 12:46:34 +0200
Message-Id: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::25) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1864-101.ea.freescale.net (83.217.231.2) by AM8P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 10:46:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9e9794e-8563-44b0-c913-08d8849cc203
X-MS-TrafficTypeDiagnostic: VI1PR04MB3982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB398230FB2F6CE0C957C8988FECEA0@VI1PR04MB3982.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFTRmU9p50iy2Z1vmnKa07bvPGalhCVTW6IRZd27Xqkw9HTUtYRke0bj/JuruOWbbQt08MIXyN94ScOXNvWA//d1JpIglU+wlRKL7NWjfNKPLBkvQ0q88z9MA1kdBMzoD9FTfJCk4Z35KpEIBhdMEJmhTaOUhqBdzaeDTeD/ik18ZWxu1t1Vsdosp68ptWcgP1P1eTcwB0pWq7Bpll6xuAVGwWaxHZjLBNl9GnOSWsOPh+a1CNsjxUc+eR+6UEwB6TJE8nT2HCZRbWZ3nmd5QVttUwwooSNebyv5BOTFLsNFVsCjxoYvp4XhxQn+2YdK1iVEiDra7GaoO3b7/GJXrgIBKI8dOQIGYSu7HCQZo562KHyfvLmjC6vpeNAf32MkJmGqag3TfrN4cUPRJ9YbuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(2906002)(52116002)(966005)(7416002)(66556008)(1076003)(6506007)(66946007)(66476007)(8676002)(16526019)(6512007)(6486002)(956004)(44832011)(8936002)(6666004)(26005)(316002)(54906003)(4326008)(5660300002)(186003)(83380400001)(36756003)(478600001)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: flg3+jfCsVZpkUWgsMr5XA5B6pou7gsJg9yVlo3bWil1vHwfLHfFMX7T8A2w7eSrJJ0oz+4Yxk45U6NJJDHbjbfVPhwmvJdt8plyX/fgvYkPPFcDc7FNQWeHtGsfpsWj9vCQGLYPLIkgzpFUW8272Lz8dQtUfFhtLfsxWfX2kWZlxsYHNlI7KFL5uZ+ICHlXtf3dIGHJY32WIGj+EizXhQcIVKnouNoDrSkRl201NHJNuFNvrEMagd/Rg+PezPAS/YQaRhkHgQkG/wDfDA7hGtZykVR1lOBsIArPCdZopBTgzpiuIYunY/9utJU9n2O6A9AFjtt7pZh0L7mppKC60XbfnEpuiR3G18huYD7r6ZJ/z0Sq9SgstL2Hu1SEtxbWQxIQ2r3hQ/3GgLLpu6d2A3nJxAeQiysSf3/lmGO34zUGNzLjqWTpyTl3Zm3Lf4ZW17qTZ499Ng3O4AhexA34bF1C8pbLi9+xvQMwco4kn11fvFbgdipfBpw65pz4uqZh5o86xBg5JVCPk2wrQrlI7W7D1mvJAjv0X8u9aHKvfLrSHAgSTUSDvFuqEDIydipEmAnhLkrtzF0aSbHM3QlYqCE41Ji0ey+fNkWWA4HYu5x8jhnxQGLCxPqX10M6XxreEJFEp4IOKYzQAa7aVtwBRg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e9794e-8563-44b0-c913-08d8849cc203
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 10:46:48.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkYQyflUJRA8pLmkPKlXbW1DO5QkIvT595QuXghGf7aMCFab8rQf6j5oiuWIJoMj5KOneZzUrN2j9fVrkw+XBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3982
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ionut-robert Aron <ionut-robert.aron@nxp.com>

Convert fsl,dpaa2-console to YAML in order to automate the
verification process of dts files.

Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
Changes in v2:
 - add missing additionalProperties

 .../bindings/misc/fsl,dpaa2-console.txt       | 11 --------
 .../bindings/misc/fsl,dpaa2-console.yaml      | 25 +++++++++++++++++++
 2 files changed, 25 insertions(+), 11 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/misc/fsl,dpaa2-console.txt
 create mode 100644 Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml

diff --git a/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.txt b/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.txt
deleted file mode 100644
index 1442ba5d2d98..000000000000
--- a/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.txt
+++ /dev/null
@@ -1,11 +0,0 @@
-DPAA2 console support
-
-Required properties:
-
-    - compatible
-        Value type: <string>
-        Definition: Must be "fsl,dpaa2-console".
-    - reg
-        Value type: <prop-encoded-array>
-        Definition: A standard property.  Specifies the region where the MCFBA
-                    (MC firmware base address) register can be found.
diff --git a/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml b/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
new file mode 100644
index 000000000000..271a3eafc054
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2020 NXP
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/misc/fsl,dpaa2-console.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: DPAA2 console support
+
+maintainers:
+  - Laurentiu Tudor <laurentiu.tudor@nxp.com>
+
+properties:
+  compatible:
+    const: "fsl,dpaa2-console"
+
+  reg:
+    description: A standard property. Specifies the region where the MCFBA
+                (MC firmware base address) register can be found.
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
-- 
2.17.1

