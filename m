Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9569F50A7C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfFXMNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:13:11 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:30700 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbfFXMNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:13:11 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OC8lZr004723;
        Mon, 24 Jun 2019 05:13:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=QoceIQ2JNSom9nlWIuhpe2lyQkwtVkTAmcdrLYsxfeTMoqm9Qlul0HxJUlrssS6NPiBx
 0oIeiKaIW9rIUk1wrZevnfZEf9fZZfnocFiVRbQwKpklfJs/WgTydBRceyf6X0wMZ9/j
 J9PkHoQu84qm42oA9wTZfZF5SVzVsEdr55g2oZh0DVVYYGWnTfAbnnjlfgBqiuGzeeMO
 gel3y3a+/OwUYEYQJCxIhQVOInkYBK1HGrkXpsPhAf8FKWJSqcHq+I19uY1V3F6jq55q
 vs01Olxjfp8QDJAo6sE8a/X5mwweSGjXUEk3NmoEZoFhBIwd+NNiixPdFGAEiiaVGrja yw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2058.outbound.protection.outlook.com [104.47.46.58])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtqu9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 05:13:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=XsqN+dwFfWID4zrsWfp0GuCJXGAASTE58sj4kXVpI83KYIYbCbh+wMcRXovEsD2ZSrxd5wz3dXCYK6somuD95JejIsI4LD5ko69W9JzoX3+EJAVS1h3FE2LA8UXe29axz2cW/HTD25RbNKF4uhIxwQQ/uk0s0PaoMLeT28v6qgU=
Received: from BYAPR07CA0015.namprd07.prod.outlook.com (2603:10b6:a02:bc::28)
 by BYAPR07MB6823.namprd07.prod.outlook.com (2603:10b6:a03:128::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Mon, 24 Jun
 2019 12:13:00 +0000
Received: from BY2NAM05FT014.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::204) by BYAPR07CA0015.outlook.office365.com
 (2603:10b6:a02:bc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Mon, 24 Jun 2019 12:13:00 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BY2NAM05FT014.mail.protection.outlook.com (10.152.100.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Mon, 24 Jun 2019 12:13:00 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCCwX0031308
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 24 Jun 2019 05:12:59 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 24 Jun 2019 14:12:57 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:12:57 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCCvrc014795;
        Mon, 24 Jun 2019 13:12:57 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v5 5/5] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Mon, 24 Jun 2019 13:12:55 +0100
Message-ID: <1561378375-14674-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(396003)(136003)(2980300002)(199004)(189003)(36092001)(54906003)(7696005)(51416003)(16586007)(316002)(110136005)(76176011)(478600001)(107886003)(305945005)(2906002)(7636002)(2201001)(246002)(8936002)(4326008)(486006)(446003)(86362001)(8676002)(426003)(11346002)(126002)(476003)(2616005)(7126003)(50466002)(336012)(48376002)(50226002)(76130400001)(70206006)(70586007)(356004)(53416004)(47776003)(186003)(36756003)(26005)(5660300002)(77096007)(4744005)(26826003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6823;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3a09d24-3a46-4f65-8e9c-08d6f89d4d12
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6823;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6823:
X-Microsoft-Antispam-PRVS: <BYAPR07MB68230C589CCFC434B088936BC1E00@BYAPR07MB6823.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 007814487B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: VKkZHbspmV7E32SPuQsSyPrkX1CpLs+SFb/Y/sVimzc1TW/IrnHmlkh14506K3G86cluoHYgrJwmJSPNY0uI+wpgjKTGZJOqS6mS2Z+j8ezvJUwPSKksMP5nhxv+cb4OXotJBKrLBfh9acRkaasObmXvyOwmMp00kXs0SRAIgt+zJ2DwOwqt+22qbXsafYqd/mbQzOEUG+Rhnpn8FCZNBgLhiEKCpuVqxV/DMVhH5lpSoj88FvCbRXI2u2laPAcvXYKYQc0QfB/b38iqUhDIvDQ4KVH02ovQAoppqApRs8JRquqUmIyqbUYxqHjIepVdSId3bcPPqYuoTQxeqBEL7vfYMZKleQJIqmONrWugKbfNw5gxQlz2hqRs49IwGF9o9rAp6WNOn8FSUg3uhdk+TGBjnf4XbdIrKTDyFf/vLL4=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2019 12:13:00.5499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a09d24-3a46-4f65-8e9c-08d6f89d4d12
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6823
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240101
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
index 63c73fafe26d..dabdf9d3b574 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -28,6 +28,9 @@ Required properties:
 	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
+- serdes-rate-gbps External serdes rate.Mandatory for USXGMII mode.
+	5 - 5G
+	10 - 10G
 
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
-- 
2.17.1

