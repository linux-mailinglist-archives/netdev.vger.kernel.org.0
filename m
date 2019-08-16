Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB48F90287
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfHPNLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:11:03 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:32370 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727433AbfHPNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:59 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7kdA030348;
        Fri, 16 Aug 2019 09:10:53 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2055.outbound.protection.outlook.com [104.47.41.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2ud8vhapmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTpsc3vqBAOmN1laHdyaqt3w+sIZcdmOuL2lwIsqCKZ8vEQLpyaqpuh3vZBqYrTsvb3bejZTuaTubikx2t++/inQIzVrhXhBqshnJ+qO5Ld/MgQkth+rnvcyvYgEnCmc2EMJ65ikW0MowadLy0ZGV80xS4r0DqVEMl8cIFObP6AH7/KAQifuk30Y1HZFE7VkjVStEg3RflB8YCyWCbYmQ2d0m4eo3GUEry4VzTmhceL9liQuhJMubCNh3xYIFHIF2D/T5xk7yuwiGsw6pBiTJkK7oZjx9myhiceC6eRLwkpq0liyXgM+PtzIMpc6jRmNVEVqorqmdXd24Xg61/1Tng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ijQbwNPrMEWo7roF+BYvwtPs1w7q9amw7Z/6Ex/jH8=;
 b=Ok2ZZvLG/2rsoo5MqmaHvpF1pukxeCVVEQFK8RSIf6UuXZtS2Q8HLV8dDQQz3UDz+8TogQ0eNCEf0ri43PCDx6aOm1z0HtjEQT/v1CD6Hq66rIFBxZzHrG2kldqVaHvmtpkHtAmTffAN4lnWwY4X3lM+lNigeMINlKtXYnp/hQboqmK9MVMMQQRHnOOB60OuIth1CPeGiupG2TE8awBImXfKGIQfI21w0kT37Za3ivHiD2WFFia66L/CbM3QDSQx0vPYVznW0YHgt67kLKFbqHeC3+5BbfvJ6bvCyElKCQJRdIGGSlNKBZoxQzCSsjcRtC/eYYXzo2ujCZ+E5TRz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ijQbwNPrMEWo7roF+BYvwtPs1w7q9amw7Z/6Ex/jH8=;
 b=l0LHgkk7IM667Ge2ZsQ6O77lIyWvignu1KSCS7LfBYWpmIIEZeRbnb2rfWi2nZMdwnVODg/LS+fdVvR77WMFhnRFqQdTyfCARCugJz4J2u66bKTve9jcons/oN2h4l50PbSMKCdtGDXIIftNv5IXgOj9hivEu0rIYnSwtiBWJ6A=
Received: from MWHPR03CA0060.namprd03.prod.outlook.com (2603:10b6:301:3b::49)
 by MWHPR03MB2607.namprd03.prod.outlook.com (2603:10b6:300:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15; Fri, 16 Aug
 2019 13:10:51 +0000
Received: from CY1NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by MWHPR03CA0060.outlook.office365.com
 (2603:10b6:301:3b::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:51 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT015.mail.protection.outlook.com (10.152.75.146) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:50 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAncb007951
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:49 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:49 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 13/13] dt-bindings: net: add bindings for ADIN PHY driver
Date:   Fri, 16 Aug 2019 16:10:11 +0300
Message-ID: <20190816131011.23264-14-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(2980300002)(199004)(189003)(110136005)(966005)(54906003)(2616005)(106002)(486006)(36756003)(2201001)(8936002)(14444005)(126002)(476003)(316002)(50226002)(5660300002)(47776003)(70586007)(2870700001)(11346002)(44832011)(50466002)(48376002)(478600001)(76176011)(51416003)(246002)(7696005)(7636002)(426003)(446003)(4326008)(356004)(336012)(2906002)(6306002)(6666004)(8676002)(1076003)(186003)(26005)(53376002)(70206006)(86362001)(305945005)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB2607;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68e1720b-36d9-4658-f15e-08d7224b2988
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MWHPR03MB2607;
X-MS-TrafficTypeDiagnostic: MWHPR03MB2607:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <MWHPR03MB2607CF375B0CB23AEC7F3681F9AF0@MWHPR03MB2607.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: nkt6qp4B/pQuTEvnu9jIQKcMC6h8R3TfmTyIVK/8ukCWpFxR6HYwL9wIfSqHleK8AEezW6Nk2GLmpPxHN518O07NG7g3Q8vrtddZ9Qoe2kiZ27S6Bi4YK46v9eBOs4jcTrCCuXiUYLpRFIipjk1lDLteqDo6xZTEaYkWnCDvfvn86oUIx0bk3ZNWr+JIhGypy6b8Xfhnl/admd+5vDxHM4KjX1SJgfltNfmTI7/c/NxjV/dr09wmkdm6Z2DZYR0XQJem1VRFHBqssVCrqgEaHmDsrxy4UvMEhyq5WbyQVNitPNrFNCq3NrYOe2HvvDFInBRhotrRRzRg1y1o7szUXXYd1hFclISqtnvzs5xkhPTFEROsct6B3OZiG8fpcfQilyChzbuCShGji0pwlRpE95wGRpw3NqXJtX2x6skOS3Y=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:50.5061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e1720b-36d9-4658-f15e-08d7224b2988
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB2607
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds bindings for the Analog Devices ADIN PHY driver, detailing
all the properties implemented by the driver.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 .../devicetree/bindings/net/adi,adin.yaml     | 73 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
new file mode 100644
index 000000000000..69375cb28e92
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -0,0 +1,73 @@
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
+    description: |
+      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
+    enum: [ 1600, 1800, 2000, 2200, 2400 ]
+    default: 2000
+
+  adi,tx-internal-delay-ps:
+    description: |
+      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
+      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
+    enum: [ 1600, 1800, 2000, 2200, 2400 ]
+    default: 2000
+
+  adi,fifo-depth-bits:
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

