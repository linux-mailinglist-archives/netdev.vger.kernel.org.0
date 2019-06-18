Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305354AA2F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfFRSpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:45:45 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:31180 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730073AbfFRSpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:45:44 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IIiqmR015068;
        Tue, 18 Jun 2019 11:45:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=IRWeLlGnIxyGck2dxp6hdSEolvSTqbmQdM+3Y8pIV3M=;
 b=LF+fg3evQVd8QpYAThFbOYTMdZCyqEiZUZhYf1N4f+OdV0e2YeOTp3V/YEFzngrI8GBd
 N/BLr41Iy6m4YdsdoVxLahnJ+u2r9UQfV+xC+tQVSWbup9BGXMu7AhRFXwtJUcC8KWo8
 68v0RIvF7vZZumh7haQ7zhtJOw8Lkx6QVjT0pkN4/Kg2zlxsEW6gmEas1+7tA50bTlWc
 PO8DD1T6jTTkBgedvpzhUJNBQg2KUbkOadfvp7SbvR4t/q1Pc6hghfqwS7cgWOpuBrtW
 wgTrZKmcXBt0ZneKt6qNFyLYZmRsLicAynEEixC1UTxt0OhjM/z9Mjzkzj9lkbw5H6vW wA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2055.outbound.protection.outlook.com [104.47.34.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wdcfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:45:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRWeLlGnIxyGck2dxp6hdSEolvSTqbmQdM+3Y8pIV3M=;
 b=YM/Qypl8LJkgjfTzk2UraLMAHDyQylEAQ7pORbQnm2jcvuVRv4q8WeG2sESAfMZeglF7N71oIyMncD7aKkcOeaU6dmGnYflCTgl00IL7oG52Lqzf698znJX6Ds1ByHAMK+HY57UGmCgd8mk4ID00Y6Hw9SpJNxeRDybgTQwZB/o=
Received: from DM6PR07CA0033.namprd07.prod.outlook.com (2603:10b6:5:94::46) by
 BYAPR07MB6821.namprd07.prod.outlook.com (2603:10b6:a03:128::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Tue, 18 Jun
 2019 18:45:36 +0000
Received: from CO1NAM05FT027.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::206) by DM6PR07CA0033.outlook.office365.com
 (2603:10b6:5:94::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.17 via Frontend
 Transport; Tue, 18 Jun 2019 18:45:36 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT027.mail.protection.outlook.com (10.152.96.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Tue, 18 Jun 2019 18:45:34 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5IIjTvq032333
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 18 Jun 2019 14:45:31 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 18 Jun 2019 20:45:28 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 18 Jun 2019 20:45:28 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5IIjSOS010641;
        Tue, 18 Jun 2019 19:45:28 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH v2 6/6] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Tue, 18 Jun 2019 19:45:27 +0100
Message-ID: <1560883527-10591-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642579-29803-1-git-send-email-pthombar@cadence.com>
References: <1560642579-29803-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(2980300002)(199004)(36092001)(189003)(2906002)(316002)(81156014)(26005)(16586007)(70586007)(70206006)(76130400001)(5660300002)(53936002)(4744005)(2201001)(26826003)(478600001)(486006)(107886003)(4326008)(356004)(8676002)(476003)(2616005)(11346002)(305945005)(51416003)(7696005)(47776003)(86362001)(50466002)(69596002)(336012)(446003)(8936002)(426003)(7126003)(186003)(54906003)(76176011)(50226002)(126002)(81166006)(36756003)(110136005)(77096007)(53416004)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6821;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5f61d7d-ac38-4e95-ee15-08d6f41d2617
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6821;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6821:
X-Microsoft-Antispam-PRVS: <BYAPR07MB6821DE00C1F91E4D7D145D9DC1EA0@BYAPR07MB6821.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 007271867D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: YaptWfAPIBpgkmfNns294LdNePU0K+RVhP2iZhcYq0ogKJnEnVEx3dIS7eAnxtz45MT4qiUnJpQPk4tgrdQlUu1bQ67rJGBv4qommNb/C0FNgemsC7gRZ7Gdq27RP4DJs5Q5/ezbmRU3EVZaPI6rJjcgE/d9FfgzMJgICCFMP8Cahwutwfaue/m5hAcjFetaHZoH/Ge2wLgFiF6rkkqEvuTQzRAOk5xkUS3Zal0nOCHuLMH52tnN/Bcj0RNQLdNVyYX5iX4LTJxpUbRFJl8YaPHKeDBgP5EXIK/x7f312NSu5XmDlsiircOxdfoJ33RL7w5iIVyNCH1jToniKDeUNEDvYYBLgoz94D4E89FcgxbY2wO/S4YZTPkCzPNtkjfOYf9CLE1TMMZlMAV8ZxFniyNhhhx0r9HSzxi2n2/om3I=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2019 18:45:34.6222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f61d7d-ac38-4e95-ee15-08d6f41d2617
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6821
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New parameters added to Cadence ethernet controller DT binding
for USXGMII interface.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 9c5e94482b5f..b80d58ed1650 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -25,6 +25,9 @@ Required properties:
 	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
+- serdes-rate External serdes rate.Mandatory for USXGMII mode.
+	5 - 5G
+	10 - 10G
 
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
-- 
2.17.1

