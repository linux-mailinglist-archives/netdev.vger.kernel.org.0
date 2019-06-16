Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC38947382
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfFPHFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:05:47 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46856 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbfFPHFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 03:05:47 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5G742GH012380;
        Sun, 16 Jun 2019 00:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=btibZ4CwVccBYDGblYXVjuLjX+4kKoSQLrCMgw/R1lg=;
 b=RDTfg5dPcJjFhxllt3fzj2l1Gb3xt9+RG9HyfucCVpWPJ8M/0RoujL+jzSVVj75ArRDr
 NDZ/b1lJywyZFDjKTp1eEpCEmoFvHm1ga3PEX97Cn8r3ebxanEdrjArT1RoMthYHug85
 itGBW1xrfGQbmze82dhqT5ziq6TrnyRWtxX+cWQYbh0SYOYAZzjlKcfRPZYeCqjUhIMS
 jgAOtV5VVUeI1EYvrxnPu0zyG9wCybfKjmnWLY6hH6t4Pz9wkYbErR1f/Qtojp3IW5cC
 B8NY3JPNT/cykulQe09e6ZObjSEpNcYTvyBMUaOApyfMT/ujGKqtsAJOvruKPRTmsuO3 0Q== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2050.outbound.protection.outlook.com [104.47.42.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w2uqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 16 Jun 2019 00:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btibZ4CwVccBYDGblYXVjuLjX+4kKoSQLrCMgw/R1lg=;
 b=ZBPl/wYXcDWiRC+vqbqRiB6f5IWYHc8w3UPhvZmuUXlCJRZQdZLrKFVRuKNKkjUncS2zyPjU+BDjgfkEWb/YHfhZgPSLjgR2REvIXxGNP6fShQd6pou6rzC17qde0JQFVhjCNaRO5b3h5i2DWz0csbzKlgFy6PPzHwJxyu7y5Yw=
Received: from DM5PR07CA0070.namprd07.prod.outlook.com (2603:10b6:4:ad::35) by
 MN2PR07MB6976.namprd07.prod.outlook.com (2603:10b6:208:1a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Sun, 16 Jun
 2019 07:05:38 +0000
Received: from CO1NAM05FT034.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::200) by DM5PR07CA0070.outlook.office365.com
 (2603:10b6:4:ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.13 via Frontend
 Transport; Sun, 16 Jun 2019 07:05:38 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT034.mail.protection.outlook.com (10.152.96.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sun, 16 Jun 2019 07:05:35 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5G75W5m009035
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 16 Jun 2019 03:05:33 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 09:05:31 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 09:05:31 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5G75VPi022894;
        Sun, 16 Jun 2019 08:05:31 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 6/6] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Sun, 16 Jun 2019 08:05:28 +0100
Message-ID: <1560668728-22834-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
References: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39850400004)(396003)(136003)(376002)(2980300002)(36092001)(199004)(189003)(6666004)(336012)(305945005)(76130400001)(426003)(186003)(77096007)(70206006)(446003)(70586007)(26005)(53416004)(11346002)(8936002)(81166006)(81156014)(8676002)(53936002)(50226002)(4326008)(107886003)(50466002)(51416003)(7696005)(48376002)(2906002)(76176011)(54906003)(26826003)(36756003)(478600001)(16586007)(316002)(110136005)(69596002)(486006)(47776003)(2201001)(5660300002)(126002)(356004)(476003)(2616005)(7126003)(86362001)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6976;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9709b7c1-e08a-4ded-a8f2-08d6f2290800
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MN2PR07MB6976;
X-MS-TrafficTypeDiagnostic: MN2PR07MB6976:
X-Microsoft-Antispam-PRVS: <MN2PR07MB6976A479C57B1AB41D813F20C1E80@MN2PR07MB6976.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0070A8666B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: RBOTit8qKPjZy9eeaG9MxG2/yN6xsSD5kF6GvWIJe8ox2Z/K9x+PojLIVI9y/SXLQ/wdxwWnmD6W3ni2SkrtYOdhErtKqfJRuz69NtkI+0qQAph8ISjq535NpvhQ3/qFqJMzSMQ+bjeFJrww8gVOJLqEJ8IgvRL64f7l4tc4UMGKXyUG/Fma5WkDgIjXWuy8gBxRUCab1V5li6+YD5wathqAGR2u32p0vsu3dnV/y6qbFffnHY3+ocbY6UW44k3ja7TR/BrtQ2oqHN19VvsGYtCoVfrVlukPtrr2hP5UXAoy84hNIRHSqr2XmJTkdrQgFN89wSgQLY9SDxc8FxHW/rL4Q5mduVi2B9VsUU/Web0pd0s3+pPmo++V0Og9dyMXGsu095TJjRbXO7w7aw7/sfTyK0LmAgzgtX7yYDSB8ZI=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2019 07:05:35.7662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9709b7c1-e08a-4ded-a8f2-08d6f2290800
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6976
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906160068
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

