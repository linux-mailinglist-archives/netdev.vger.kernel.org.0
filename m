Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387AE861B8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403798AbfHHMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:19 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:40366 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389951AbfHHMbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:12 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CSGhX002639;
        Thu, 8 Aug 2019 08:31:06 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2053.outbound.protection.outlook.com [104.47.37.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:31:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWmiOvfD65nIHOGL8QK53Pi9aXlQGKn9/+dJE1gPfBHrUqe/X199MzPLhZKMcn+pweZNKN4Tq2oiYfrBbNwLrmiiYzzshi/Iog457W0oA4OTn5u+ztiG8dBcDJRbI4oxoVwpJboRPNsdMX8XpVEG2ho+RqpBxfR+8J4Q95SHC8JIIyUSulAKJEmqhLzQhBzGPzMYSIKRGdq4SuHhJRByc4pXi02E9cywVGn4HDkLDHpPUyDLn5T03V+MWRCjC+zMVUTfZB0oXB+gyNId/kOlY1m4BkDfd6MGfIl/NYPXPprk/25g2rbeGrxZQHqot/t/yf38B8CcOZqUjBTCc8S8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cyzasWJU2lbaumPe8bDNVinZB/VicHNBvMUkNPRNEM=;
 b=gthAVtKt4Z2es19jGFl64vRtdPS6mtaeUIVxT405UCLyhB+EIgfbAFADrcEC0ycjrDo77vhIzi8DUwU2+lbuBW/Sk5t3OGY1hyofQlSli/Z7A+M1wssaSwVrVSTRuOFm7wL8lx9S7Ffv02ELWTlfmKJZYRuzJulYZoDOvdkzuWGfNVevrEKWKhAdDsaDn/ybz9M2b9JOnkS1Q98yLpNrgj50O2/kmz/QMwgVyE76BoNel0Iwb1/bg/FTeu7J88nQq3J9BkwVLZkmkdG8C9RHDoOITjLETCPJUxn/Kb4gDgbRLkBr2ovwQBFi/qxQvVbmHTyP/flWMYNNJtigDjiavA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cyzasWJU2lbaumPe8bDNVinZB/VicHNBvMUkNPRNEM=;
 b=AM/0mTSHE1YNko6zPZfbEVnFYsLlh6rCm3DkEO7b9IkC1sd18NPTnaRgih2KNj7PnzBrXn8bR29+CugiSg1xUH8cYXTiJmtY6eqNdx3P16FuRpzCLltVPeOCxbQZL2dOckTp3HX8hG+abwH+xSIMdDINrd3FqqQx2tJ6nl2vpBk=
Received: from BN3PR03CA0102.namprd03.prod.outlook.com (2603:10b6:400:4::20)
 by MN2PR03MB5053.namprd03.prod.outlook.com (2603:10b6:208:1ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.17; Thu, 8 Aug
 2019 12:31:03 +0000
Received: from SN1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BN3PR03CA0102.outlook.office365.com
 (2603:10b6:400:4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:31:03 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT016.mail.protection.outlook.com (10.152.72.113) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:31:02 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CV223021308
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:31:02 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:31:02 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 15/15] dt-bindings: net: add bindings for ADIN PHY driver
Date:   Thu, 8 Aug 2019 15:30:26 +0300
Message-ID: <20190808123026.17382-16-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39860400002)(136003)(2980300002)(189003)(199004)(26005)(50466002)(2870700001)(2906002)(36756003)(48376002)(47776003)(186003)(478600001)(110136005)(107886003)(4326008)(54906003)(53376002)(6306002)(106002)(14444005)(5660300002)(966005)(336012)(426003)(2616005)(11346002)(70206006)(44832011)(316002)(476003)(126002)(486006)(70586007)(246002)(51416003)(50226002)(1076003)(8676002)(2201001)(7636002)(305945005)(8936002)(6666004)(86362001)(446003)(7696005)(356004)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB5053;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29d07bd0-abf8-4a6b-7a15-08d71bfc470a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MN2PR03MB5053;
X-MS-TrafficTypeDiagnostic: MN2PR03MB5053:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <MN2PR03MB5053B257A6FDF715D0E5500FF9D70@MN2PR03MB5053.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: y9nF9kY5BavlaFCD2aKU2P8ij/3KPMf68bGajBS2k0NW4jerNcgLAtlaAizZXMqYvU4SFWgS/01VTsx8vZribF7aFRkF6QwpgEGXYBNYbzIsn108zJoRXJ6JFUdYuPSrQ2y/Xa3rsKfUJB0Sbn/OH66BhiQqpvf96NQQnQd1+claKI87o1QIOhGS+WKzXCRh5wn7vZZbYTTTxZe+sHHRaf9jJUF3Wdz1JFqkjngdbzdKcJ0jnGCq6UpjTNhWovVBsT/Y4B09Fk28RYs+oG24tsF4H1phyO3QqV9L0w/tU5VN9uo7Fp1wB/f48EINPdN3U2kdBOlauxci9kBR4VQz/vXkQM4Qat33GH3CLOXTyz7HEsqf7XHxiXtN+tVATnYRTfbFo4j+5LR6heOR5+VnZPab1Vr/nRcfnJAPHgz5VXc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:31:02.9268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d07bd0-abf8-4a6b-7a15-08d71bfc470a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5053
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds bindings for the Analog Devices ADIN PHY driver, detailing
all the properties implemented by the driver.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 .../devicetree/bindings/net/adi,adin.yaml     | 76 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
new file mode 100644
index 000000000000..86177c8fe23a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -0,0 +1,76 @@
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
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  adi,rx-internal-delay-ps:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
+    enum: [ 1600, 1800, 2000, 2200, 2400 ]
+    default: 2000
+
+  adi,tx-internal-delay-ps:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
+    enum: [ 1600, 1800, 2000, 2200, 2400 ]
+    default: 2000
+
+  adi,fifo-depth-bits:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      When operating in RMII mode, this option configures the FIFO depth.
+    enum: [ 4, 8, 12, 16, 20, 24 ]
+    default: 8
+
+  adi,disable-energy-detect:
+    description: |
+      Disables Energy Detect Powerdown Mode (default disabled, i.e energy detect
+      is enabled if this property is unspecified)
+    type: boolean
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        phy-mode = "rgmii-id";
+
+        ethernet-phy@0 {
+            reg = <0>;
+
+            adi,rx-internal-delay-ps = <1800>;
+            adi,tx-internal-delay-ps = <2200>;
+        };
+    };
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        phy-mode = "rmii";
+
+        ethernet-phy@1 {
+            reg = <1>;
+
+            adi,fifo-depth-bits = <16>;
+            adi,disable-energy-detect;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index e8aa8a667864..fd9ab61c2670 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -944,6 +944,7 @@ L:	netdev@vger.kernel.org
 W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/net/phy/adin.c
+F:	Documentation/devicetree/bindings/net/adi,adin.yaml
 
 ANALOG DEVICES INC ADIS DRIVER LIBRARY
 M:	Alexandru Ardelean <alexandru.ardelean@analog.com>
-- 
2.20.1

