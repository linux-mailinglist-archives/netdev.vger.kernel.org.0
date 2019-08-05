Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE2281E25
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfHENzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:53 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:26942 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729811AbfHENzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:51 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqrI8019294;
        Mon, 5 Aug 2019 09:55:43 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2055.outbound.protection.outlook.com [104.47.42.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJWu5OSh8s/MXIw+hyEdGgOSke02qE2/ekOjt17QQoavFE5y+tMW8lYD7VJYlMqaT2Admels+poKy/h+alhAUnPhwBxy05lFq8wUICMDw6xJL1K1CUFItpQ6kFBUH1YNQrZixq9jMHOIPglbI3g66UyPzv5VZMO7Nz06HaZizjKgRw/6piZQd8QkvO2uL675yYRLP0fBi+m/Ibh1ab7ClxnpiWtDPanIeCXkc1MsFmZGmBTOQm1iKkYszTnimpcZqsM/pn7O+28sOpf3SZ05ja4tEUuThJZAsAo68qvkc+7goQQls2QU0vib0T9frL+nN9toGVbk1zebuK0CyplRhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RgZ1io5NXf3iCajAt61CX3RdChj8GoaGYCjaieIJDE=;
 b=m7eqsDiFRnDP9FilP10ErLaDGgzcZnVvjSGqpaQLJdoWKwPAC58/4LRJr3hoLGum2Z+VxOW/8HAaf0PJUf6nRfvL31UU345EAUUUnPb4zrMQpi73u2S/ajczcOtxcLsjVHTFUGwESs3xWGy8yvXvxkgk3ClHd3v+U8O2aEb3dQC2lNSGid1e9E4I1z02nBKXlr0M0iY4NEKmmcoBqJkCmXpR6TgHhAd+b4V58yeNABpe1qGzIiew88r1p70qiBCQ+VtefbjloMg1fmvNded3T2/9LW5Ce2Z4LQRuxlbr/RlwS7vkLxoIbJxOHnE+evL234slPUVRqMJYkHzrgAVyhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RgZ1io5NXf3iCajAt61CX3RdChj8GoaGYCjaieIJDE=;
 b=pJdjeBeMKYiacIr+oMUJKucbyhIDzas1oZRHu3OHl3tZj3s591k4/0pJ3Fc7j/MOp+CrrpvO+HAfAFtvXiQMJK3uN+tUQzN6HbCjaZ6TREJ02dMccmD2dyitvI0kaN0f3SIUaZOKDXA089DgSHjKHmwDxgY1TQoDkYdPGwGKMjg=
Received: from BN8PR03CA0033.namprd03.prod.outlook.com (2603:10b6:408:94::46)
 by CO2PR03MB2230.namprd03.prod.outlook.com (2603:10b6:102:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14; Mon, 5 Aug
 2019 13:55:40 +0000
Received: from CY1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by BN8PR03CA0033.outlook.office365.com
 (2603:10b6:408:94::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.17 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:40 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT016.mail.protection.outlook.com (10.152.75.164) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:39 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtaNc016266
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:36 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:38 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
Date:   Mon, 5 Aug 2019 19:54:53 +0300
Message-ID: <20190805165453.3989-17-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(2980300002)(199004)(189003)(1076003)(246002)(48376002)(316002)(8936002)(2870700001)(305945005)(26005)(5660300002)(186003)(50466002)(486006)(70586007)(7636002)(36756003)(8676002)(47776003)(51416003)(86362001)(7696005)(50226002)(70206006)(14444005)(44832011)(2201001)(356004)(6666004)(110136005)(2616005)(476003)(126002)(76176011)(11346002)(6306002)(446003)(54906003)(106002)(426003)(336012)(478600001)(966005)(107886003)(53376002)(2906002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB2230;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9e29299-4d2a-4a17-abc4-08d719ac99e7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CO2PR03MB2230;
X-MS-TrafficTypeDiagnostic: CO2PR03MB2230:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <CO2PR03MB22309A03480502C4AF1CB4A7F9DA0@CO2PR03MB2230.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: aAnFMBv+gP+1e1Uov9Z0GG7HY0NwJmn6HlqgTDnllcZpEXYzcRLOSPilMMpjlEXeN2ql2pI//cPaS1Q1Kbr7AriJhq1uirgPvrW6XVugCH/sEcQ5HbWJwmsSI3Wr8b2RxZ3GuuCvHQV4G0Q8P7LsbcnSMDdlrX9ODGMfy2gAMg7LeUivMm5UxNYQ4vIM82WGDHFmMQexyhnxm6OuLAHXqAk+1r3e//rTIG2P1GcXTvS9Wtnh1E+efMp36v+CcVWL30/gfH3dM/f/qOu3ROSnnzi1/BEhgQg4amPNAJWx0rMbRHZm36ZfdggiFUK1icGE0nJU47YP6ZanRevrqdfrwX04p4xTR1yP2oVVlpMInUi+QVzBq0o5CAsHqvun7ewRRj3jxxerXW3iKLUWeVjiDBI2Zr0pu2HkYJc94gbdnGc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:39.6785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e29299-4d2a-4a17-abc4-08d719ac99e7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR03MB2230
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds bindings for the Analog Devices ADIN PHY driver, detailing
all the properties implemented by the driver.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 .../devicetree/bindings/net/adi,adin.yaml     | 93 +++++++++++++++++++
 MAINTAINERS                                   |  2 +
 include/dt-bindings/net/adin.h                | 26 ++++++
 3 files changed, 121 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 include/dt-bindings/net/adin.h

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
new file mode 100644
index 000000000000..fcf884bb86f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -0,0 +1,93 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/adi,adin.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Analog Devices ADIN1200/ADIN1300 PHY
+
+maintainers:
+  - Alexandru Ardelean <alexandru.ardelean@analog.com>
+
+description: |
+  Bindings for Analog Devices Industrial Ethernet PHYs
+
+properties:
+  compatible:
+    description: |
+      Compatible list, may contain "ethernet-phy-ieee802.3-c45" in which case
+      Clause 45 will be used to access device management registers. If
+      unspecified, Clause 22 will be used. Use this only when MDIO supports
+      Clause 45 access, but there is no other way to determine this.
+    enum:
+      - ethernet-phy-ieee802.3-c45
+
+  adi,phy-mode-internal:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: |
+      The internal mode of the PHY. This assumes that there is a PHY converter
+      in-between the MAC & PHY.
+    enum: [ "rgmii", "rgmii-id", "rgmii-txid", "rgmii-rxid", "rmii", "mii" ]
+
+  adi,rx-internal-delay:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII RX Clock Delay used only when PHY operates in RGMII mode (phy-mode
+      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
+      default value is 0 (which represents 2 ns)
+    enum: [ 0, 1, 2, 6, 7 ]
+
+  adi,tx-internal-delay:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII TX Clock Delay used only when PHY operates in RGMII mode (phy-mode
+      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
+      default value is 0 (which represents 2 ns)
+    enum: [ 0, 1, 2, 6, 7 ]
+
+  adi,fifo-depth:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      When operating in RMII mode, this option configures the FIFO depth.
+      See `dt-bindings/net/adin.h`.
+    enum: [ 0, 1, 2, 3, 4, 5 ]
+
+  adi,eee-enabled:
+    description: |
+      Advertise EEE capabilities on power-up/init (default disabled)
+    type: boolean
+
+  adi,disable-energy-detect:
+    description: |
+      Disables Energy Detect Powerdown Mode (default disabled, i.e energy detect
+      is enabled if this property is unspecified)
+    type: boolean
+
+  reset-gpios:
+    description: |
+      GPIO to reset the PHY
+      see Documentation/devicetree/bindings/gpio/gpio.txt.
+
+examples:
+  - |
+    ethernet-phy@0 {
+        compatible = "ethernet-phy-ieee802.3-c45";
+        reg = <0>;
+    };
+  - |
+    #include <dt-bindings/net/adin.h>
+    ethernet-phy@1 {
+        reg = <1>;
+        adi,phy-mode-internal = "rgmii-id";
+
+        adi,rx-internal-delay = <ADIN1300_RGMII_1_80_NS>;
+        adi,tx-internal-delay = <ADIN1300_RGMII_2_20_NS>;
+    };
+  - |
+    #include <dt-bindings/net/adin.h>
+    ethernet-phy@2 {
+        reg = <2>;
+        phy-mode = "rmii";
+
+        adi,fifo-depth = <ADIN1300_RMII_16_BITS>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index faf5723610c8..6ffbb266dee4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -944,6 +944,8 @@ L:	netdev@vger.kernel.org
 W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/net/phy/adin.c
+F:	include/dt-bindings/net/adin.h
+F:	Documentation/devicetree/bindings/net/adi,adin.yaml
 
 ANALOG DEVICES INC ADIS DRIVER LIBRARY
 M:	Alexandru Ardelean <alexandru.ardelean@analog.com>
diff --git a/include/dt-bindings/net/adin.h b/include/dt-bindings/net/adin.h
new file mode 100644
index 000000000000..4c3afa550c59
--- /dev/null
+++ b/include/dt-bindings/net/adin.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/**
+ * Device Tree constants for Analog Devices Industrial Ethernet PHYs
+ *
+ * Copyright 2019 Analog Devices Inc.
+ */
+
+#ifndef _DT_BINDINGS_ADIN_H
+#define _DT_BINDINGS_ADIN_H
+
+/* RGMII internal delay settings for rx and tx for ADIN1300 */
+#define ADIN1300_RGMII_1_60_NS		0x1
+#define ADIN1300_RGMII_1_80_NS		0x2
+#define	ADIN1300_RGMII_2_00_NS		0x0
+#define	ADIN1300_RGMII_2_20_NS		0x6
+#define	ADIN1300_RGMII_2_40_NS		0x7
+
+/* RMII fifo depth values */
+#define ADIN1300_RMII_4_BITS		0x0
+#define ADIN1300_RMII_8_BITS		0x1
+#define ADIN1300_RMII_12_BITS		0x2
+#define ADIN1300_RMII_16_BITS		0x3
+#define ADIN1300_RMII_20_BITS		0x4
+#define ADIN1300_RMII_24_BITS		0x5
+
+#endif
-- 
2.20.1

