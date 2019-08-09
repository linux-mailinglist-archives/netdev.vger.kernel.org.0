Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD00C87B60
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436508AbfHINgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:37 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13020 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406779AbfHINgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:36 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DN1Cr026384;
        Fri, 9 Aug 2019 09:36:29 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqk07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqewSLuXlaPHay4jVyWbTRtLXFz9miE4eLGlqRuRrIShnakyawonwuldAiCEqTQMdwURSHUp3WH2QzORvNY9zV8HAyDGZvNWJWNnRJdRxC8v06C2lxn2HQBI4e2OVt/rKFUupR0mKLlnw7bxJMdK05dRNGeaO4o/L0eof06h3ogPIwiCv+pnxSYp1pDziB3dy9rQzNtddsm1NOy2h7hNcEOsdd1NWnfSFrn9SDabV0qS4mRHzrJBnOPjsg9DFuHIdRaHTf9Vk7PAW1yDu1xsfrnsYHLBncPL8O3v9iR4ubncJVgjSKGaj41P3cJ9t8HQDSKD5MG5Dh183QnO7DEBIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpxz53QW0BqFdEDmfraPY70UZ81PF8uuq174FIgxsIk=;
 b=S7hhej2JpsMFIsQvA7aYa//21GgD+qhwPyRlqroImV61FPIVQqYHlRGiTSep8FbeFoQvinuKoonslBUJuwHu8IgvwdSJPAP4bNH6UyLs2f2ABcUvghJvN3InlJDKTtNWy8+gJFTJ01QK7JFLKWCLZ7wO7i//0Y7G4y/uHaId26RQKU12R5wFLG/EcW3W2O7CVHaXoANJbijzdYGwAV8zbdB2MfLKvZsMKsqsmUOlFsZs/GuezOZWB4a4kNZOh/0b5DDeMH8Ze5yNRY4vAeQg7l8jRyzMEDPf0KfpXoW+tutYZ0ONmuTOCxaA7gMQjxNqdmZ+nGOCOG5HgHfiUQukTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpxz53QW0BqFdEDmfraPY70UZ81PF8uuq174FIgxsIk=;
 b=hV0WkIxynjRMTASebqOVP+h7CaGrsnIsQxVsGYa2oc8HO+raS5nWkKt0fF99B4irZXOuMJFK92RLJLgZSA1C9Q9TZhac6A7mD5CL956pFcF9ZqlP4uD+alYYkFrVmcqgBroI/liMi1owrS8x+jGnTeBuaaZu+3e59tWxQSZwgY4=
Received: from BN6PR03CA0024.namprd03.prod.outlook.com (2603:10b6:404:23::34)
 by BYAPR03MB4840.namprd03.prod.outlook.com (2603:10b6:a03:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Fri, 9 Aug
 2019 13:36:26 +0000
Received: from CY1NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BN6PR03CA0024.outlook.office365.com
 (2603:10b6:404:23::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:26 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT015.mail.protection.outlook.com (10.152.75.146) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:25 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaPuP025781
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:25 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:24 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 14/14] dt-bindings: net: add bindings for ADIN PHY driver
Date:   Fri, 9 Aug 2019 16:35:52 +0300
Message-ID: <20190809133552.21597-15-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(39860400002)(376002)(2980300002)(199004)(189003)(106002)(44832011)(7696005)(336012)(110136005)(47776003)(5660300002)(26005)(54906003)(486006)(2616005)(476003)(126002)(316002)(4326008)(70586007)(70206006)(11346002)(1076003)(446003)(356004)(6666004)(76176011)(51416003)(6306002)(53376002)(305945005)(2906002)(36756003)(50226002)(2201001)(86362001)(50466002)(8936002)(7636002)(186003)(14444005)(48376002)(246002)(8676002)(107886003)(478600001)(966005)(2870700001)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4840;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62996f1b-3624-48c6-10e4-08d71cce93c2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4840;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4840:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BYAPR03MB48409915AA3BFA83B859C31CF9D60@BYAPR03MB4840.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: TbfFGwNxEXfcsIlxAnsXK0fcl1SybqL83AZJi6am7sciOsbv7yycQle7NVkl6b9dxU57iDy9jtUF5UnMoyuqj1LoDIVPvgOZALXQ91RMP3ggkMyHN42LhQeOb/vA4mDA/m9YIfmcoxMcB5goTWx/yMWoM8tJP0VLJ2ochcx0C8v6JjbDbt3FIPVwrGHCPE3YDRoA8M4kCUDtTcB1wNxeZ3rS8lpJfVrBGzgP+nu8xtsX9t83V3qojrIkMhnT3xD1wlWJv7YtL7zuzlpm1cdF79L+0WEEIzWTttJSMh35xQ3tzd5oAwo4aMpzlEtoO4SvyvGweuSv+GtmXsva9Uu+fhabyy8PDhClpLNysmC7iuIuIejhJnW87aegd+mv0vrsPNZDzY5tGCTwpTt6n8v66Epq7iYuVwQZBqwDzCWOkkQ=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:25.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62996f1b-3624-48c6-10e4-08d71cce93c2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4840
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds bindings for the Analog Devices ADIN PHY driver, detailing
all the properties implemented by the driver.

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

