Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E444E204
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFUIfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:35:34 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:37864 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbfFUIfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:35:33 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8YARY005046;
        Fri, 21 Jun 2019 01:35:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=JgcR0ufGnevNMWVIUuslxI/4jhscmKopIITnh6rf3DUHiHJWwNE83oGGV6LZyOsYjSut
 ZalKDrfRJuolSqjqkX9OrHE4QkLDtHOFN9qDS8g/zXapC0L1zFht39Tl10i3OGhH1331
 SAP1QBOV3QBnmirFv7VrfMH19Wti4HQd+PgV/r5/cZEe+yiuPyvpyja1WaHukkF+2zxh
 492udt7eFajYARlrbnN4VVC4/nH7MnUzDM/3v9VHCKx1C6bepXaKOFi2j+LY1zkKcd4v
 H4I9ySLH1Rtli2y2Al+YT6/L7v7qCZ990m/0zXGgAJjQxSIJcXd2Phdd7mtSS9h0Dmto 9w== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2053.outbound.protection.outlook.com [104.47.37.53])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t8cht4h9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:35:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=FDdjqAq+N3hMBJx/2r+g9IFsz4TuH01UhDCQB3oZQOagYGgPS/9NTvHnBDQknrKCK0KzOQP6UiKS/7o5sGIe9KMXs5EzUCzybAl/fVXmQT3G8Qh3ftqy+5fDnBQsaU+upJpMaJhH0lqKJQ3jKWQgp/91AKgxfngcYT16EyW4s6Y=
Received: from DM6PR07CA0001.namprd07.prod.outlook.com (2603:10b6:5:94::14) by
 MN2PR07MB6831.namprd07.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Fri, 21 Jun
 2019 08:35:22 +0000
Received: from DM3NAM05FT008.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::208) by DM6PR07CA0001.outlook.office365.com
 (2603:10b6:5:94::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.16 via Frontend
 Transport; Fri, 21 Jun 2019 08:35:22 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 DM3NAM05FT008.mail.protection.outlook.com (10.152.98.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:35:21 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8ZIRQ002547
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 04:35:20 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:35:18 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:35:18 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8ZHCs009522;
        Fri, 21 Jun 2019 09:35:17 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 5/5] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Fri, 21 Jun 2019 09:35:16 +0100
Message-ID: <1561106116-9361-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(136003)(2980300002)(199004)(189003)(36092001)(7696005)(53416004)(51416003)(70586007)(8936002)(48376002)(81156014)(107886003)(76176011)(47776003)(486006)(68736007)(478600001)(81166006)(50466002)(76130400001)(8676002)(69596002)(36756003)(4326008)(305945005)(77096007)(53936002)(356004)(126002)(110136005)(336012)(426003)(186003)(476003)(86362001)(2906002)(50226002)(4744005)(26005)(316002)(70206006)(2616005)(2201001)(446003)(54906003)(11346002)(5660300002)(26826003)(16586007)(7126003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6831;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e195dec-79e1-49c4-77ae-08d6f6236685
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MN2PR07MB6831;
X-MS-TrafficTypeDiagnostic: MN2PR07MB6831:
X-Microsoft-Antispam-PRVS: <MN2PR07MB6831E7A40DC69F445279CDE4C1E70@MN2PR07MB6831.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yUUiw0ffaakQQQpC44hsLuZjmVZuCp5m0+N3zXB+8j/N19yj4d2CJPHPEYBe6V09Q8LYzfo4jeRcbadMZKm+cMe88V/RFeNVQpgzsJn2SqTcMGVDHbCdBWoN3gkO998iGlb7DxNBjEbtYp7QnUR98PA5DsAE6VqWWuPpqCdCxAqlgjQhCJJk/Dl9xpmAnqwJF9YL5UWFurZhVSoQ8zK6yQc7DxsPPIDXPW511SA4j+LoR0/VcFKoO41V0eVukbS6gnPIRMdQKRrS3uJQPsDnyp68ZFST5AjSzYIjNp0X/YfIGXeWZSg4AGda31hueHMIaARs6dTTUWyeaQQu4qdCWircdVIGkTCTHALAuE/Cm4LCh8Tqk1+7cmHk8EJR3dUr3IxxB7SP8HXXuX4n9XMVR+bPChpybh/Wm9crQpL9ggE=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:35:21.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e195dec-79e1-49c4-77ae-08d6f6236685
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6831
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210072
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

