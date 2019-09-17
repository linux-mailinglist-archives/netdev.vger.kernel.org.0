Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC44B484E
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392592AbfIQHbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:31:09 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:58098 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727509AbfIQHbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:31:09 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8H7RfG7010430;
        Tue, 17 Sep 2019 03:31:01 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2059.outbound.protection.outlook.com [104.47.32.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v0sy95mrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 03:31:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Omek4pjJkN2Xh4rrmiAn52SRGRS18Y+lHYq9iv4Dc9XHcPS+J+Ea3skYjnPgbWVRvhg6W0UO3kY+6Ym7eFQW+XGtlf7TA+KgGm77tY/AD2TWSoEHa9ILtSMTiLT9LQ5Mptwi6LT6cEAJDrXb1IkYI4Q6BHCWGne2AaerV9PvWqufTLqvp33DJICrMapCNK5upiYHbvLqIZ2MMrwhNT/Zaxm0XySkO77A65gisUl7ihCGsR7RHJcnnXqR2nH6SYZfXnj1apwDTgxSo1KJjYI3XFQyIkWk5EwGBmR8wnbZzVSCbwfeaYFXJa97stipExCrrC34Xw40U76C0kOx8eFhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGPDIOtBYykbMvDDHcKlWWl00GgfWM3oJ9aVBbaSZR8=;
 b=A+BiK4Hsls12tKM5FwnEVjMlRYlUsoZVVOcqThKPJVp5JCCea8OvWXQFfl6ZNR6NlPVDNSnArFNwZao/CbksVBuvDZxnbXx12bcepEesM5baJbZA6xKvcfMoZo7HRVdrd1oVyZbgV5a1WFsSvCV46u2LPkG+M8tQg7TtPLHy8RKsBIie/RZqUwY1isL57UjXu4RMFMBLE8IQ/7znsiZA1Of1dmGa8/xFUBwT3wJMh3O+PgCkTOVO1YKQUH2d2xh4v0jZusExE3l08h3T8ccQyHNeX/rmiqHLj/wiXZkXekB7xd8sG1eJrAn+cpGDgBGD2lXzJH4BJgUsaAPYTr13eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGPDIOtBYykbMvDDHcKlWWl00GgfWM3oJ9aVBbaSZR8=;
 b=YVIc29a0s+kB78z5Ce8efVEcVrZuZp1nRdU2plpmylsCFWzXqD/MYngPYrGapRN48F51OQVnHTOVQmzdMrIZ7Dk25zfOgWPX7JCNepvVOcXuog2qTsdh+yVmrkvlDxO7nJ606Z0WgqTqI1uAxaFPTgYIYNPInEmJNdnkT0a6GRw=
Received: from DM5PR03CA0051.namprd03.prod.outlook.com (2603:10b6:4:3b::40) by
 DM6PR03MB3420.namprd03.prod.outlook.com (2603:10b6:5:ac::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Tue, 17 Sep 2019 07:30:59 +0000
Received: from SN1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by DM5PR03CA0051.outlook.office365.com
 (2603:10b6:4:3b::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Tue, 17 Sep 2019 07:30:59 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT061.mail.protection.outlook.com (10.152.72.196) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Tue, 17 Sep 2019 07:30:59 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8H7UqI7031654
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 17 Sep 2019 00:30:52 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 17 Sep 2019 03:30:56 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Date:   Tue, 17 Sep 2019 13:30:52 +0300
Message-ID: <20190917103052.13456-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(396003)(136003)(189003)(199004)(4326008)(5660300002)(44832011)(50226002)(2616005)(2906002)(486006)(476003)(1076003)(51416003)(70586007)(70206006)(8676002)(356004)(2201001)(336012)(7696005)(50466002)(48376002)(478600001)(86362001)(246002)(6666004)(426003)(2870700001)(8936002)(36756003)(107886003)(126002)(14444005)(54906003)(110136005)(47776003)(316002)(26005)(7636002)(186003)(305945005)(106002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3420;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59592852-2cc6-42f3-7f50-08d73b40fc36
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB3420;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3420:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3420EC27CA4FB1EF6FA1B461F98F0@DM6PR03MB3420.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01630974C0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: h495/GfwrWaucOzXqDc2sGpaIFnDp7wTet0GJvZtWFfHHtB0qSnhWulRRv7yTio7VZw1Ywk+etbAi1ZF9xYnp0/Y5gfWQvwfHNu8uq+7EJmKSEtMpSJUPpZY5CcVzNMust2DmN0m3e4J99W25MFYDQv3xrcZTPFsZ6vtBPvxN6OoXhSWcyCR40csl8O/WhAFsYxNlgXc+UA4b3GqnehVFbA7obKZBmsxdjcsQrAccAyhlEE+bP3iYWTRYeqCQbFA/V28Wg1XV7Lylmf8Bf+y7ANwtabW9kHjSuccZPTD0AjQ1IEuaMEPvksXRWCC2gaLKz4iBmfhAQPIPHquy7iXQr57ijxWaBpGCBpAt9bv4suvSxLd6RcvIf5AcpNtwB1ZS8lhH87GN8VaxzuZ+gh/43Wag2rkCIz4kwwFC3Vlzhw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2019 07:30:59.0399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59592852-2cc6-42f3-7f50-08d73b40fc36
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3420
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_04:2019-09-11,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=930 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909170082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-type',
which are enums of mode strings.

The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
enum (except for 1 or 2). But in general, there may be a case where
'mac-mode' becomes more generic and is moved as part of phylib or netdev.

In any case, the 'mac-mode' field should be made an enum, and it also makes
sense to just reference the 'phy-connection-type' from
'ethernet-controller.yaml'. That will also make it more future-proof for new
modes.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index ebe4537a7cce..4845e29411e4 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -113,7 +113,7 @@ properties:
     const: stmmaceth
 
   mac-mode:
-    maxItems: 1
+    $ref: ethernet-controller.yaml#/properties/phy-connection-type
     description:
       The property is identical to 'phy-mode', and assumes that there is mode
       converter in-between the MAC & PHY (e.g. GMII-to-RGMII). This converter
-- 
2.20.1

