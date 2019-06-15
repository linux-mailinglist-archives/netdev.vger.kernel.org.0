Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC84729D
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfFOXuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:50:01 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:47254 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfFOXuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:50:00 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNnPZl024308;
        Sat, 15 Jun 2019 16:49:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=btibZ4CwVccBYDGblYXVjuLjX+4kKoSQLrCMgw/R1lg=;
 b=BRDPx3feYYD0iyBsosRmzHvucev6jVcGUY9GjC8aNxrUSQGatgs7m3t8xesbTNn3zMvm
 W9XmZwo/TSVtLeYPGaezHBYnc5oKUFLn7JYqdgHGLa5+77pZEh1uAGDmxEiKCa2VihxN
 m9WXFCO3Fua9OZz7Cxa0mGleFyHfTB5iXodIT1nhQRRxyF6XiK1QAylNJSKI/c41gPP0
 or87MW+khFIBOFy/z/RLC+MRz72A5sKMDISgONYM3HqzFgkFgAWqZOFAP8lfHwcXBl+v
 2uKc/ajWvtbXfTbJ5aQbKN6gN/ttE2EcwvSNakLXXePhetDD7RGRTR37R26uPT+QjKPd gg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2050.outbound.protection.outlook.com [104.47.49.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w216m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:49:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btibZ4CwVccBYDGblYXVjuLjX+4kKoSQLrCMgw/R1lg=;
 b=AcKFHaJhfOsbn9iBgc4CnABUCUKq8xelMdDA3Q4vs5y2F6aF47mirLn2RPQKfhOXdzhW03gNRF8DicumEnbf/xtMU1X1Wem+KLepeJ/rqUhTB79z+d2HV4jHin5ID9mMCf+2+2uuXDfrJB4KF8AifGRW3eE++LgrObg3aYqLKiI=
Received: from CY1PR07CA0024.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::34) by MN2PR07MB6832.namprd07.prod.outlook.com
 (2603:10b6:208:11e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Sat, 15 Jun
 2019 23:49:52 +0000
Received: from BY2NAM05FT035.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::208) by CY1PR07CA0024.outlook.office365.com
 (2a01:111:e400:c60a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.13 via Frontend
 Transport; Sat, 15 Jun 2019 23:49:52 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BY2NAM05FT035.mail.protection.outlook.com (10.152.100.172) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:49:51 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNnnvK014480
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 16:49:50 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:49:48 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:49:47 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNnlwK029946;
        Sun, 16 Jun 2019 00:49:48 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 6/6] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Sun, 16 Jun 2019 00:49:39 +0100
Message-ID: <1560642579-29803-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642512-28765-1-git-send-email-pthombar@cadence.com>
References: <1560642512-28765-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(136003)(2980300002)(36092001)(189003)(199004)(305945005)(11346002)(7636002)(50466002)(26005)(6666004)(356004)(48376002)(77096007)(50226002)(246002)(8676002)(53416004)(16586007)(316002)(76130400001)(8936002)(4744005)(5660300002)(2201001)(107886003)(126002)(476003)(86362001)(2906002)(47776003)(70206006)(51416003)(7696005)(76176011)(70586007)(446003)(426003)(26826003)(4326008)(478600001)(186003)(36756003)(336012)(110136005)(7126003)(2616005)(54906003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6832;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9398075-9c8f-4a8c-91a8-08d6f1ec28cb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MN2PR07MB6832;
X-MS-TrafficTypeDiagnostic: MN2PR07MB6832:
X-Microsoft-Antispam-PRVS: <MN2PR07MB683292F54D6053D32E046AB1C1E90@MN2PR07MB6832.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: lIaG9jACxiG/1uGABr6qO+vG3+frIb4ibuEHNqYTlTl289gKOC+MglMI2koxr4AQYMlAS+2YrGiPVXiCbx+7LWopOcLSzlBPv6CvcdjyGbNJyF3sJpK+JNd4YDhQdIcPZTEGW/mq6C87r0zKwdqpalcQd/+ZqX5X05J4oXbq7JE5wjK0/22lwrsMe9EnDjjsSfp28RUTN8WuiQwF1Sl149UFdd0j6tLXkSj9FT8O3hY2Xf0EiGxTq8QE6cPRaROH2kraoG4FSDqtXT64rL790rVQGHgIfdiSW70uM+3Fl7uvcpXJ524flmv9ga0CJt/xkwNd8YpEuER5kHRE/9YgqvqvUTuK04PFimjGZpAqeBJwk8+ho5CbKgJB7+0Eekes32FFeDZ+iSzTjWLqZCtJKVNjpTGK5TXq6PrA3HgFvig=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:49:51.7919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9398075-9c8f-4a8c-91a8-08d6f1ec28cb
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6832
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150227
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New parameters added to Cadence ethernet controller DT binding
for USXGMII interface.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 9c5e94482b5f..cd79ec9dddfb 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -25,6 +25,10 @@ Required properties:
 	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
+- serdes-rate External serdes rate.Mandatory for USXGMII mode.
+	0 - 5G
+	1 - 10G
+- fixed-speed Speed for fixed mode UXSGMII interface based link
 
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
-- 
2.17.1

