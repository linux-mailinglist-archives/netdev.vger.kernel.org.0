Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA52AB8D2
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405095AbfIFNDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:03:23 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:32914 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403816AbfIFNDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:03:22 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86D38NC028747;
        Fri, 6 Sep 2019 09:03:16 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqjramf6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Sep 2019 09:03:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1RGACCMcnBfpqucGV8aah95EjmIsJxORiE17OniI+yOjrq4UGjzCwm04eBzVtzR2rZ9mtXnaPmllm1ZqNZfVFfnxumQk5jcgv2HE533G66U24BIqeaDmFKwDGoKAPtAKNCZw+zdL/vFchZFg2HEClsADNDQSO6J8XCRd9zMRRQEY2GZ7npn/uHV+B+VQSOukRifi6fPzACHdW0mERPQBc/rgeyQsDSXq6r5BHDzzaBsNuEu0NCCLB2teO6fm3ugFPWX/O71roG2P1u0yVX2jM7qaozTKkfeRDMM0SaVTPR3SnZPpxjkqZ8D2E+VQkfiQ6CbHEyec/LNJoWcpVB1wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPcZeGTesb+C7gl2jqPV14Mdixv2Q+Z+0xdY+nzguhM=;
 b=N3rFHCP6IHzCwWNk4HG3PHNFk0/toJxi9cMIcfHLcqY3oZEbIzWpBWjiGuofv5ke/D3rbuRA1fpMzrjXPpdkPhnfvVHv/f7Fd2QHlomO3EQZaztafZMbuAHi3oEZr6QhxfipXubTfzGpFPihhRwGDMorJdAHE1xwnqXm+bpmK3woLJsjLCKNDrE7zv3OLcP2j4sXPufIapMDRCp+ljrTWXebCtRqgrDuJLHA0DV1CywjD3wnl4a9Ve30KKpcZlT48A/EGok9kogXicMVfZlXVPBCKN76S9zO4Zz7MxWWlj5aOBOYTiZsM3pxFeq4NSzT/WjaSIZDBaUc8ygEpUmjaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPcZeGTesb+C7gl2jqPV14Mdixv2Q+Z+0xdY+nzguhM=;
 b=ObFLZ9aqThV7EXYoxbMd5RncKuhnf4aDNad8CWAL5gwv0o7SjHbXB8j869GyJ23MlOblHuchLrGl/SWf1K9Kj8B2/abvu1aT9EiG9Dug4GD5EYkL9/nfVCyffzJgkCfrHRlxJduLn+QzbKgwoP3KBQStYE9+zl1+P/a6eqY3Ghw=
Received: from CH2PR03CA0023.namprd03.prod.outlook.com (2603:10b6:610:59::33)
 by BN6PR03MB2609.namprd03.prod.outlook.com (2603:10b6:404:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19; Fri, 6 Sep
 2019 13:03:10 +0000
Received: from BL2NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::206) by CH2PR03CA0023.outlook.office365.com
 (2603:10b6:610:59::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Fri, 6 Sep 2019 13:03:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT038.mail.protection.outlook.com (10.152.77.25) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Fri, 6 Sep 2019 13:03:09 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x86D35rR030663
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 6 Sep 2019 06:03:05 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 6 Sep 2019 09:03:05 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <--cc=andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode' property
Date:   Fri, 6 Sep 2019 16:02:56 +0300
Message-ID: <20190906130256.10321-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190906130256.10321-1-alexandru.ardelean@analog.com>
References: <20190906130256.10321-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(39860400002)(346002)(2980300002)(199004)(189003)(6666004)(48376002)(356004)(4326008)(486006)(446003)(70586007)(70206006)(186003)(316002)(478600001)(1076003)(36756003)(26005)(44832011)(106002)(50466002)(2906002)(14444005)(476003)(2616005)(5660300002)(305945005)(86362001)(126002)(7696005)(2201001)(2870700001)(50226002)(51416003)(336012)(76176011)(54906003)(107886003)(47776003)(7636002)(246002)(426003)(8676002)(11346002)(8936002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2609;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24d9bbfd-7173-438a-dac4-08d732ca90dc
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN6PR03MB2609;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2609:
X-Microsoft-Antispam-PRVS: <BN6PR03MB26098E5417DC1EA2576734BCF9BA0@BN6PR03MB2609.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0152EBA40F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vxbwUQwxYuBDcYDbFiyAYw67JpYAEMHZg4g6Iuzqd2zHQw2iZL34T72GmkHt3hCZLzoj6q6YOXgBNmHQt3q23ZgTB20GPdusShlhU45gPElsRE9BJcC6ZM7tQ/iP2uwj87QBc7OL8VQIyhth07W/HtcVmcoLUm8YNyEbVF3yn8VobRXRUkf5qt5KjIlWLQ7MJv6v8SnMt5Oceq4dpTu7Exls73aVtNYiZ30xjU/L1lXx7tsHSm+jC1XiVKZ6QTU/qMV/u80VyXN8puuMEcMO87Fqck5JkgGIL/jFpwmiBZlSA2Al5BVib6p65kfdDdC9qKQwdraRktN76P9wMu5HuD/0OSjshRPYIhS/iKcK86o1EB+7JejRvP8exLCrd/UbB2fEWx9kpYGgaa47WjmDEax3SR9rKa+xPkirUGCjJ0k=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2019 13:03:09.0439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d9bbfd-7173-438a-dac4-08d732ca90dc
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2609
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_06:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=903 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change documents the 'mac-mode' property that was introduced in the
'stmmac' driver to support passive mode converters that can sit in-between
the MAC & PHY.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index c78be15704b9..ebe4537a7cce 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -112,6 +112,14 @@ properties:
   reset-names:
     const: stmmaceth
 
+  mac-mode:
+    maxItems: 1
+    description:
+      The property is identical to 'phy-mode', and assumes that there is mode
+      converter in-between the MAC & PHY (e.g. GMII-to-RGMII). This converter
+      can be passive (no SW requirement), and requires that the MAC operate
+      in a different mode than the PHY in order to function.
+
   snps,axi-config:
     $ref: /schemas/types.yaml#definitions/phandle
     description:
-- 
2.20.1

