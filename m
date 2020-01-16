Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F2A13D677
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbgAPJNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:13:10 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28912 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgAPJNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:13:08 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G9D4qc025656;
        Thu, 16 Jan 2020 04:13:04 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xfc59my67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 04:13:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQCUgSAaVOkvHSJ+KWHg3V5v02tgvZ/ar/uz2FmuOABvE6eWm8OGyU+gBiOPUtM3RE6FC5Tea5zQYnjkR6tW4wJQMMSyH+nKk3JsluJjj4v0fPb/YOX77SUOICKhki5gs9yZPU2hdj0oC4STyfCxGTTVFpqprJQ1OnvUxMog69uqj6Q7EzlDIg6bUHg8Nl266A2/v3MrNJgArm5cF6p/maH1XnWIos2avdL888pl0omE3wfgbHFUhEgAFp6/ZhGZaS59Iav179K09FFZevzez1FmQI9/XHMTx1CbcpfSlzf6hT7KPBAlCEpufryAM+bQBdvZqLEgD5tTzkSXEHoQng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMxzeGEbuGM/YmErLjwbYXG8v481k0JRWmopiSbo/Zc=;
 b=I3/j1xixMXXpjDVcvZ5jpV+3xTq0vk0WY7lt0u98daY/2+BKjuvwjMWuzlkEP0lGsDfbZLoZrZg0dbT4hVWSgLn7D4I6/t9Bb3Ycrmxw2DBlr8Ij/iWzeeUl7eFOH3ogDIlo8ec0GYBfSTHtERWZDASgFrmdUQt/ccjxAX8ga8mT8ug/nk3pLdzV9Wzwp/9Z8e2SzGvlTPRhD7wQwcw7iCitoO+6s3gW+1PYutA5bjLCwgL8WaugjoTh5mIZo7B2p5lZKXLxhsU6DZO5QGOQt2sFa6rp3CVwOEsj3wKuOkJgLXrhGR5L7kQxkaZGiQfU5CUhMqDOcDNCe/zyUgo9OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMxzeGEbuGM/YmErLjwbYXG8v481k0JRWmopiSbo/Zc=;
 b=PnLFtZKbO7DPTPfCYgqGwo359Iwn/W8fNQWmVVruodgQaWCjPwGDHKp63mO7/IYxIzCDsWhE5Q2p4ljOazWQciv69gSVSl8XjAghMcZOnBIL/fL7+DiXHGtVANTnu4YpgSG436EV1aMb8r1VQl/Z4sbNKEvLzeE++IhS13sTZRk=
Received: from CH2PR03CA0005.namprd03.prod.outlook.com (2603:10b6:610:59::15)
 by DM5PR03MB2490.namprd03.prod.outlook.com (2603:10b6:3:72::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 16 Jan 2020 09:13:02 +0000
Received: from SN1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by CH2PR03CA0005.outlook.office365.com
 (2603:10b6:610:59::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend
 Transport; Thu, 16 Jan 2020 09:13:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT046.mail.protection.outlook.com (10.152.72.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2644.19
 via Frontend Transport; Thu, 16 Jan 2020 09:13:01 +0000
Received: from SCSQMBX11.ad.analog.com (scsqmbx11.ad.analog.com [10.77.17.10])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00G9CmnM032334
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 01:12:48 -0800
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Thu, 16 Jan
 2020 01:12:59 -0800
Received: from zeus.spd.analog.com (10.64.82.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 01:12:59 -0800
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00G9CkjZ020088;
        Thu, 16 Jan 2020 04:12:55 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 4/4] dt-bindings: net: adin: document 1588 TX/RX SOP bindings
Date:   Thu, 16 Jan 2020 11:14:54 +0200
Message-ID: <20200116091454.16032-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091454.16032-1-alexandru.ardelean@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(199004)(189003)(2906002)(8936002)(7696005)(1076003)(5660300002)(44832011)(4326008)(7636002)(8676002)(426003)(478600001)(186003)(336012)(316002)(356004)(36756003)(107886003)(54906003)(110136005)(70206006)(86362001)(26005)(2616005)(70586007)(246002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB2490;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2eab73c-fad3-4e37-a269-08d79a64496d
X-MS-TrafficTypeDiagnostic: DM5PR03MB2490:
X-Microsoft-Antispam-PRVS: <DM5PR03MB249021484E4FEBE3DE963BF1F9360@DM5PR03MB2490.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyMqucs46SMlfBNqTJskMe7t8WB0XrIr4V4QbHJ4wDXJB9uDTPT8nv1VhP9z1mQ8RnkMbcKAC957cxNto2/mVsR4bu8Vv/X32XSfjQGZhXYCNtlJqQLdiQfqvRX3vkBjOjI3o1ZyQSDf/GIlXP/tXxQUcGmYcKQjML1W+aGsGQFXgLseT7zDqJagdyrcbt9NowYcIzbZ/ttxTGxS7RYwrNS88A2tqVTeWbIVg/HrW43VNEx2kaEuMCpkdCd49Kvi/AKibjkDr5Ly4nTHhG5vkzq8aF1g/uL53TduEQK3DXbcB6uMGtwtBgPrBuQFlZsnvUXNo29D1bybYFd4Ljoi5qmISmvFcoidIsmQ8/HCTpswTh27pvXVbAIdj5yeOEps3VmIjybr3XHi9abByAue7WXGVwx3iALRC5pmIwLKDXq5jN7ta6q//3xQ2nFRVFpw
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:13:01.4352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2eab73c-fad3-4e37-a269-08d79a64496d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB2490
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_02:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=941 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001160078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change documents the device-tree bindings for the TX/RX indication of
IEEE 1588 packets.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 .../devicetree/bindings/net/adi,adin.yaml     | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index d95cc691a65f..eb56f35309e0 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,6 +36,60 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
+  adi,1588-rx-sop-delays-cycles:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint8-array
+      - items:
+          - minItems: 3
+            maxItems: 3
+    description: |
+      Enables Start Packet detection (SOP) for received IEEE 1588 time stamp
+      controls, and configures the number of cycles (of the MII RX_CLK clock)
+      to delay the indication of RX SOP frames for 10/100/1000 BASE-T links.
+      The first element (in the array) configures the delay for 10BASE-T,
+      the second for 100BASE-T, and the third for 1000BASE-T.
+
+  adi,1588-rx-sop-pin-name:
+    description: |
+      This option must be used in together with 'adi,1588-rx-sop-delays-cycles'
+      to specify which physical pin should be used to signal the MAC that
+      the PHY is currently processing an IEEE 1588 timestamp control packet.
+      The driver will report an error if the value of this property is the
+      same as 'adi,1588-tx-sop-pin-name'
+    enum:
+      - gp_clk
+      - link_st
+      - int_n
+      - led_0
+
+  adi,1588-tx-sop-delays-ns:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint8-array
+      - items:
+          - minItems: 3
+            maxItems: 3
+    description: |
+      Enables Start Packet detection (SOP) for IEEE 1588 time stamp controls,
+      and configures the number of nano-seconds to delay the indication of
+      TX frames for 10/100/1000 BASE-T links.
+      The first element (in the array) configures the delay for 10BASE-T,
+      the second for 100BASE-T, and the third for 1000BASE-T.
+      The delays must be multiples of 8 ns (i.e. 8, 16, 24, etc).
+
+  adi,1588-tx-sop-pin-name:
+    description: |
+      This option must be used in together with 'adi,1588-tx-sop-delays-ns'
+      to specify which physical pin should be used to signal the MAC that
+      the PHY is currently processing an IEEE 1588 timestamp control packet
+      on the TX path.
+      The driver will report an error if the value of this property is the
+      same as 'adi,1588-rx-sop-pin-name'
+    enum:
+      - gp_clk
+      - link_st
+      - int_n
+      - led_0
+
 examples:
   - |
     ethernet {
@@ -62,5 +116,11 @@ examples:
             reg = <1>;
 
             adi,fifo-depth-bits = <16>;
+
+            adi,1588-rx-sop-delays-cycles = [ 00 00 00 ];
+            adi,1588-rx-sop-pin-name = "int_n";
+
+            adi,1588-tx-sop-delays-ns = [ 00 08 10 ];
+            adi,1588-tx-sop-pin-name = "led_0";
         };
     };
-- 
2.20.1

