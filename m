Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC100B5ED9
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfIRIPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:15:04 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:30400 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729889AbfIRIPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 04:15:04 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8I88LsG028312;
        Wed, 18 Sep 2019 04:14:57 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v37jgh39h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 04:14:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zmol7K8+6exMDLocvPVvXYapa/o0RRVZtdtXW2Sj8Ze2npGmFbAF7d4hRShzBh+eSAdoPzduOZO/QnXCh2TVoF4qkyGKvoOJW+h9VwF45QXaZADAOvlVjyewwHKuQhaAzOZN1IFlB5ulPuUTLwuyWzW+RKafVly5dVg6zs8LuEhRqgYiEjPO9SCoIZDnnEBs0tCaPKaW60LF69Zv6qfyF9P4FlpodXw4QGsYUBKss08qt5ZczxRWStoa+ss6kV61kJ6U4lm/+dOrBH04eET3QewH66NxFY9bSllLgzn+/hJK9vrdov4j1UG5PdifagKnZNLDtLoN3fuvvH0DPfbupQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l16CVakqKBk3JG429+sVUBmeHB4mIe0ewsGgDwHG2X4=;
 b=QsIst4tQsFMk3x3qOiTWjmXg2Ox370lfhlfYDb+ddKNYR0HqqFVMW6ycWRN8wKmuROsC9tkgq/N+ZlLdNAxhuyMbdy4SbSzRUK+20PqP2jWdPOYqKkQ/72cOnkgnh+fc18/WJDbjAV1PbGP16ywGUvJ5yo6dizGsxsyNuDaiLMhd7Jfgq46cWWnwV53OAdNL/quH9z9cIf3MAoioQPB/gLrh51j7y8OERVyeEofujCRfIJWJ4uNYKd5hM6TAXwmgCcm8SBnWVIYR7XYnnHnON/1p3KWYuBz7Y1EJ4UqGQopFmj2i6K8zQEKzb1wmPO1I/5DJFJkQML3tq7RkX0eRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l16CVakqKBk3JG429+sVUBmeHB4mIe0ewsGgDwHG2X4=;
 b=HoepIBlqPpYBVadFJdGyvLy/MVKbPot3ZQ3chimYTyR4NHGVFuxVzlI2y4HUGvwjs6GO7NU7DucYE1FJGJBi7z9qouhV8YkqT9fe3mE0AlenhsLljdb3lcZWq3IQ0PYZ+1Ov2UIG3/zS3p0H74j3uzw9yPiPH7P1kF5JFYY0U3s=
Received: from BN8PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:94::48)
 by BYAPR03MB4823.namprd03.prod.outlook.com (2603:10b6:a03:137::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.18; Wed, 18 Sep
 2019 08:14:55 +0000
Received: from BL2NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BN8PR03CA0035.outlook.office365.com
 (2603:10b6:408:94::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2199.21 via Frontend
 Transport; Wed, 18 Sep 2019 08:14:55 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT003.mail.protection.outlook.com (10.152.76.204) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Wed, 18 Sep 2019 08:14:54 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x8I8Esc3010853
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 18 Sep 2019 01:14:54 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Wed, 18 Sep 2019 04:14:54 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] dt-bindings: net: remove un-implemented property
Date:   Wed, 18 Sep 2019 14:14:47 +0300
Message-ID: <20190918111447.3084-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(189003)(199004)(126002)(5660300002)(50466002)(44832011)(70206006)(4326008)(14444005)(246002)(2616005)(316002)(476003)(1076003)(26005)(2201001)(486006)(107886003)(36756003)(54906003)(6666004)(7636002)(336012)(356004)(106002)(70586007)(2870700001)(86362001)(478600001)(110136005)(186003)(50226002)(8676002)(48376002)(8936002)(426003)(2906002)(47776003)(7696005)(51416003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4823;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 962ff4cb-4045-4393-d207-08d73c1049a4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BYAPR03MB4823;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4823:
X-Microsoft-Antispam-PRVS: <BYAPR03MB48236597DE6E4E59784604A1F98E0@BYAPR03MB4823.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01644DCF4A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: IuyfLdV0qE2GtHZvewq4wYtEQQtc3Lnq1ST1yHGYMVw5bXskT5K+anSePLTrDCy69QlV+YvZBuySfGbv5by1T0cMC3dnVqWEw5YsnPVm0ZXklvi4hPo/L957NKicNrjqj5RPvUd5/asSQ9rtG0SZysnNWz2Rx/1Sh6A58IR2p3H3bwKtsmWhJnA2QICmAaY4Bvl4opoCuy6F83bByQ/hqPOuieJwW8VJSGzkoYj3WmHmQRVg79P5WQUXQwFHe/q2/IgljjoJgXgRUiKjSSw+5aSWwBDAoRprLSnIc1ZY+Nw+UZELDbwWGeVpp6FQnYnh7dsRXV++CTwEyJhkjXVqq21ySlCDiMCeopxxmU7hvR/S/U6Kd63NrpiPgeJyt0Q2rFnlDuorVWVNoGK8ySryt5HXVfHScuXzxC/pL7ZayJQ=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2019 08:14:54.8445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 962ff4cb-4045-4393-d207-08d73c1049a4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4823
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-18_06:2019-09-17,2019-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 mlxlogscore=888 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909180085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `adi,disable-energy-detect` property was implemented in an initial
version of the `adin` driver series, but after a review it was discarded in
favor of implementing the ETHTOOL_PHY_EDPD phy-tunable option.

With the ETHTOOL_PHY_EDPD control, it's possible to disable/enable
Energy-Detect-Power-Down for the `adin` PHY, so this device-tree is not
needed.

Fixes: 767078132ff9 ("dt-bindings: net: add bindings for ADIN PHY driver")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 69375cb28e92..d95cc691a65f 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -36,12 +36,6 @@ properties:
     enum: [ 4, 8, 12, 16, 20, 24 ]
     default: 8
 
-  adi,disable-energy-detect:
-    description: |
-      Disables Energy Detect Powerdown Mode (default disabled, i.e energy detect
-      is enabled if this property is unspecified)
-    type: boolean
-
 examples:
   - |
     ethernet {
@@ -68,6 +62,5 @@ examples:
             reg = <1>;
 
             adi,fifo-depth-bits = <16>;
-            adi,disable-energy-detect;
         };
     };
-- 
2.20.1

