Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0189289C9B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfHLLYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:36 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:37060 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbfHLLYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:34 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNNZi007542;
        Mon, 12 Aug 2019 07:24:27 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2050.outbound.protection.outlook.com [104.47.41.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9qpawfjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0gqjgCXgsjMeDge46QayS57JK1KtSqbk7dIKu3dgHObdI6wC410Xocpu0nMEmbadXUHkBI1vzEVCIysqbFVVnyUgTI/itzx9kHPoUbSzsaiRG8m6VPnLQUw9rmm6vZ3+4UDMoXywzY4wx9QidsiY7ELRewqNcZSpI6z3ZUBX56tRH8mKtPQRiIFvAVd/2oQrsUQOt/Hj62yqcShZ46tTVV/IKYgCdhLAeieimhXm/nhhN+lYLMj1TADW99urAceVOEu+WfcF0rrkQdEXyMI9VPrf5R3VawaB5Kg60HlKEY32uc9pLDjiyWDRf8GhN3srdCe7X3UyKJMZbgNEt5HyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpxz53QW0BqFdEDmfraPY70UZ81PF8uuq174FIgxsIk=;
 b=IvBN44XrN85oQJIPt7dTR1BB0KgGoLX5bsmL0PwZylB5l6oymVPrZldLtlPo6R1KPfmBAIzscQf+4hxOSc7ZYHj7JJ3AQro8hSPI9bssnNHJckAfU2T1NizNU8fUGOPq6hcHqB9trgPHh5eVjUZAmH71o4Cx30YkycS5JTLKolPf3qJNRwHcbZQKKfl7qjiHJP1RCX+d+el7eAwihvkcbNA8KowNYARckei6A+uFrI0KSb2XVTOED3zwuntYDa8BI0+RDynJzRTyaZwq5Am2Sg/0jxUxQqn1Bz5IASDIdTWQGoIZF7GwyhxhH2wRoPtYnaF063BZlPEzZY/k78ATjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpxz53QW0BqFdEDmfraPY70UZ81PF8uuq174FIgxsIk=;
 b=Y05H30m1PK/45PiNlN+/95ZaBiWGThVsJPwz9D7NJWZ6/D5JzJEn4Q5QVJDorB6eQpCFK4Bzo/oUBqN77EQt8bhPm4KAcvk6YmoyeZe8ZpJXZv3ZGwu06BdL4O0Zll2Csk+gTVWsIn+jRcfGaYXlvHBidJpLMmQX3iP4IojbMn0=
Received: from BY5PR03CA0018.namprd03.prod.outlook.com (2603:10b6:a03:1e0::28)
 by BN8PR03MB4689.namprd03.prod.outlook.com (2603:10b6:408:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 11:24:26 +0000
Received: from BL2NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BY5PR03CA0018.outlook.office365.com
 (2603:10b6:a03:1e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:25 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT011.mail.protection.outlook.com (10.152.77.5) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:25 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOP7f004274
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:25 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:24 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 14/14] dt-bindings: net: add bindings for ADIN PHY driver
Date:   Mon, 12 Aug 2019 14:23:50 +0300
Message-ID: <20190812112350.15242-15-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(199004)(189003)(8676002)(106002)(26005)(966005)(70206006)(70586007)(50226002)(48376002)(50466002)(110136005)(4326008)(54906003)(7696005)(76176011)(51416003)(478600001)(8936002)(53376002)(316002)(107886003)(6306002)(86362001)(7636002)(426003)(47776003)(2201001)(1076003)(36756003)(2616005)(126002)(44832011)(6666004)(2870700001)(186003)(356004)(246002)(2906002)(486006)(476003)(5660300002)(305945005)(14444005)(11346002)(446003)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR03MB4689;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e4617ee-c332-46e9-34f7-08d71f17a1c6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN8PR03MB4689;
X-MS-TrafficTypeDiagnostic: BN8PR03MB4689:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BN8PR03MB46897B7E7D4F36423B49526CF9D30@BN8PR03MB4689.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: rA5sNg7vaOMfWHvH8hoQbDe+rkoC9Qd96obAvxGs8pNU7j5/DDrI3ryM0jrcl53tV+abGt8mKefFzjCvn5rs+ZanYsceCAmo90ZZMKO+eH3sL609AQhO8qBfgvESBdu7qw5suxPH0h/srnNviaTvllVehJa1J3AHChz+02oKbgNFIwBy/FsYD4b8dRHTchfm6I638hdvboLJ5WaPKQQPHbIoTECt50WF7O/QIfGcndQ/8vvZy29ZfXC7btDK8D1mTqbZf+0YA9K4b5nNCKeoEdcDV33FXqx1DOeoyB5ZJ5qP44pVumvMbengxhX4Zng47urZAhptJ4Svgsh5yRvmdII6j1EZq9zvhu2WnGhA2Om5dKbzy/Sn+oRV0FeIuugfY2MXP/oFJcQhYM4W0QB2a6trO+c1nF4qE6AL9HqqAf0=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:25.4003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4617ee-c332-46e9-34f7-08d71f17a1c6
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4689
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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

