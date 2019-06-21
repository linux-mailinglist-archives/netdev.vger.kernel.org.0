Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85C4E1F7
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFUIe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:34:27 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:41412 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbfFUIe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:34:26 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8YAAS005049;
        Fri, 21 Jun 2019 01:34:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=DffwnC30NLNSMWSWDcxBylLsOyHjfJhsoZ9YahvoPxg=;
 b=EqjN/AOHJ3Ya9BHPznMNev0TX3Qin9oqc2y0p/EA4hgb/fMn2sqm7NIGdIB4dK+LKvEz
 HlToTpMN805OfoPOsVBjZ1Qw03tEH/7JZkhcgcgLEYH+f9YgSfBiTkWEbZ/xMKs822o2
 /Jqfte9+L5bnJHrOeP6dYNlJjMZhBeO9yOz1ixgUi9SUw3CMyoWhuJqs5VI10zjSL6LF
 T5PDs1ca5670J80dMvdaLzfI/7yDG2EAdsOKHnaNEQXHryFBZfmo6f8pxI8rx9CW/lBY
 c/G09rIWOP2H17tZWFy6AcM3ikaS+5uKUmfWAwNVENREUhx7kTy5Yn6sS/HhoIL2EA0d uw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2050.outbound.protection.outlook.com [104.47.42.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t8cht4h47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:34:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DffwnC30NLNSMWSWDcxBylLsOyHjfJhsoZ9YahvoPxg=;
 b=mFBCQT9KDYSc5uXUX4xMTxbmxrQaYEnV84JyWPoqbQSlIJEPTfIeR+CImokYiUTgIA67B2lFx9jsFE8RLQUaQc/tStUVhd7yHbN54v1aXt3ylSox2BSI05yBUm+zgGH9i0HN5W0o7Vut3xP8JrCmvlrBZ3pEyoh7AsyviT/9j/M=
Received: from DM5PR07CA0095.namprd07.prod.outlook.com (2603:10b6:4:ae::24) by
 BYAPR07MB6822.namprd07.prod.outlook.com (2603:10b6:a03:128::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.11; Fri, 21 Jun
 2019 08:34:10 +0000
Received: from CO1NAM05FT003.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::204) by DM5PR07CA0095.outlook.office365.com
 (2603:10b6:4:ae::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.15 via Frontend
 Transport; Fri, 21 Jun 2019 08:34:09 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 CO1NAM05FT003.mail.protection.outlook.com (10.152.96.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:34:08 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Y4GS024228
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 01:34:06 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:34:04 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:34:04 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8XxNa007032;
        Fri, 21 Jun 2019 09:34:00 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 0/5] net: macb: cover letter
Date:   Fri, 21 Jun 2019 09:33:57 +0100
Message-ID: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39850400004)(396003)(346002)(136003)(2980300002)(189003)(36092001)(199004)(426003)(47776003)(2906002)(2201001)(70206006)(53416004)(107886003)(16586007)(54906003)(316002)(6666004)(186003)(110136005)(70586007)(7696005)(356004)(26005)(5660300002)(4326008)(77096007)(51416003)(36756003)(26826003)(8936002)(8676002)(76130400001)(86362001)(336012)(48376002)(126002)(246002)(7636002)(50466002)(305945005)(478600001)(486006)(2616005)(7126003)(476003)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6822;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93576e64-e4fb-44e3-0277-08d6f6233ad9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BYAPR07MB6822;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6822:
X-Microsoft-Antispam-PRVS: <BYAPR07MB68221215E3652C0828137EA7C1E70@BYAPR07MB6822.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AJzzcmj4mrBqgMUxbmpl/BJU9ycgS8VDI15UH4f++bIHjhwkb++03TnDfZzfMZAR/o8Yw0u0jqrqEv5DJXuSayEJGeAZuU+t64hIb0uXaY7UMTnXGo7SE57lxfDwPEDp/QCSmjRiLOM+EYKj9dwyFzmpiJ+GcVvdr6Mg9bzk26aIyAqNDjeKGUl0SZj+T/8SYx7pmiZS485SAYVEkuzdhpOXO1pA+JdW9i6xPinCggULeLhrvRbEAwQ/9w6iu53p1hfrvBG+fg7G2umRMLoEzRWLEjQIuX03E17ZgcFo9hMql4Beduom3Lunev3gP90jLvU3OWmOt1vh1o72o137PUdzMH0WRGD4Eyu523t0Sl+rCWESrMrJgwOFb8M/DqU+AnJp3rvYxaGz66SpWvJQZ9mIKtkBaQpDCJ69/lYGLIE=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:34:08.8350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93576e64-e4fb-44e3-0277-08d6f6233ad9
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6822
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

Hello !

This is third version of patch set containing following patches
for Cadence ethernet controller driver.

1. 0001-net-macb-add-phylink-support.patch
   Replace phylib API's with phylink API's.
2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
   This patch add support for SGMII mode.
3. 0004-net-macb-add-support-for-c45-PHY.patch
   This patch is to support C45 PHY.
4. 0005-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G USXGMII PCS in fixed mode.
5. 0006-net-macb-parameter-added-to-cadence-ethernet-controller-DT-binding
   New parameter added to Cadence ethernet controller DT binding
   for USXGMII interface.

Changes in v2:
1. Dropped patch configuring TI PHY DP83867 from
   Cadence PCI wrapper driver.
2. Removed code registering emulated PHY for fixed mode. 
3. Code reformatting as per Andrew's and Florian's suggestions.

Changes in v3:
Based on Russell's suggestions
1. Configure MAC in mac_config only for non in-band modes
2. Handle dynamic phy_mode changes in mac_config
3. Move MAC configurations to mac_config
4. Removed seemingly redundant check for phylink handle
5. Removed code from mac_an_restart and mac_link_state
   now just return -EOPNOTSUPP

Regards,
Parshuram Thombare

Parshuram Thombare (5):
  net: macb: add phylink support
  net: macb: add support for sgmii MAC-PHY interface
  net: macb: add support for c45 PHY
  net: macb: add support for high speed interface
  net: macb: parameter added to cadence ethernet controller DT binding

 .../devicetree/bindings/net/macb.txt          |   3 +
 drivers/net/ethernet/cadence/Kconfig          |   2 +-
 drivers/net/ethernet/cadence/macb.h           | 113 +++-
 drivers/net/ethernet/cadence/macb_main.c      | 619 +++++++++++++-----
 4 files changed, 554 insertions(+), 183 deletions(-)

-- 
2.17.1

