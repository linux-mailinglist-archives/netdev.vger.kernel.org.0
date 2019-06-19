Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85AD4B445
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfFSIl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:41:27 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:14650 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730996AbfFSIl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:41:26 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J8XXbD026447;
        Wed, 19 Jun 2019 01:41:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=njQgYsw+Ia1Ogmnu5hCG//rDm3kIDak84ADXksqnnntHHGdoIkfbSymXOuJg2jAYvfDC
 s0XAzZ8+P2XYl3s88rkdAzC1og+px/bXU8jtE+MqVoMwJfyhbHbLfDhAfpRVBXcM+SAB
 EEktwwdezJEVBLe3fQQCNYC+WwOIKb34iI/w3NMGW+QS7DxBl5alQwxB3IDBdgP0TxMl
 U/3ysg+PYfScGZt/jykH0wDi0HNvpuASwlk36pAwWrLhTljK1vA6B+nD8uWR12W9aoLE
 mujGveL2gPtm2JuvEtfFEavh0bpgoX+wygLNiHLO2ZS4uLLJw0u3q0FDvbktACXgeosK jg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t7byx1gyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 01:41:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=ORr/IjT/AkQClco/bNdm1NFoa6WDdFm+wVLHibHLTjLyiyi9YGY4vSi6EcfSwI1RC2elkmGqZIcBY6fxQOB/Mo/O5CAJ8Kosnk2iRkZUX2OeK5DvOh34UGDGuMx9eyZRayGqJ0mGHLFkQ659EgA21+7AS5vX+v3Nd1Wkz+xw6Q4=
Received: from BN8PR07CA0007.namprd07.prod.outlook.com (2603:10b6:408:ac::20)
 by DM6PR07MB6972.namprd07.prod.outlook.com (2603:10b6:5:1eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.11; Wed, 19 Jun
 2019 08:41:17 +0000
Received: from DM3NAM05FT035.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::200) by BN8PR07CA0007.outlook.office365.com
 (2603:10b6:408:ac::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.12 via Frontend
 Transport; Wed, 19 Jun 2019 08:41:16 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 DM3NAM05FT035.mail.protection.outlook.com (10.152.98.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Wed, 19 Jun 2019 08:41:16 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8fDvl008183
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 19 Jun 2019 01:41:14 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 19 Jun 2019 10:41:11 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 19 Jun 2019 10:41:11 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8fBks030500;
        Wed, 19 Jun 2019 09:41:11 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v2 5/5] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Wed, 19 Jun 2019 09:41:10 +0100
Message-ID: <1560933670-30359-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(396003)(2980300002)(189003)(36092001)(199004)(70206006)(26826003)(7636002)(305945005)(76130400001)(4744005)(77096007)(8936002)(53416004)(426003)(26005)(2906002)(7126003)(356004)(11346002)(5660300002)(110136005)(2616005)(54906003)(446003)(186003)(36756003)(316002)(70586007)(16586007)(48376002)(336012)(4326008)(50466002)(246002)(7696005)(76176011)(476003)(486006)(86362001)(47776003)(51416003)(2201001)(126002)(8676002)(50226002)(508600001)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6972;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53d4692d-5718-4bb6-c3bd-08d6f491e4e4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:DM6PR07MB6972;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6972:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6972D4B4D3C4DF301D8805FBC1E50@DM6PR07MB6972.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0073BFEF03
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Sh2+I6WG+5Vwx1Ev3f5f/K6ZDsdHcsEace3T7lMx+capjOG0PqfSMJZwyKLLe9uY0NcTvteed01BCbkGnRVcX/OouD63KNAh+LhjDWp5Iew6kyM2+Tf4jeeiGNR+PQnJpN0ohrn0gW0ZHQtSq7ASIeRZD/0vF4V6cJqxyXEGLDAuDv7QDOtyLju1zED2aj4oLWL3NM8+UEJ8JcgYjjaQv+nPHrj1Mn8njnbg7gTg5bUU4ijEwa7QiYXfd/fZ9lctkt0ErGwhu0dwo+hgGoNh4qYAojKzGeT/69PUk4Md7HMxACvq2yqf6xSlU03ISboiwJnOlFxPuzOtnmthrfcabB90gqjlK7g/mE/Pr+4NUo7jdN9R2NwYsaWxn9yXD1xgnhux2O/8iGNwTharqVMtK+w1jUPn1fvlAzjuemdedp0=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2019 08:41:16.1792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d4692d-5718-4bb6-c3bd-08d6f491e4e4
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6972
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190072
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

