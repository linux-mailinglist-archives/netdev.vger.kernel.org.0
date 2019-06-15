Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0692D47295
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFOXpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:45:52 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46220 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbfFOXpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:45:51 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNicgL020579;
        Sat, 15 Jun 2019 16:45:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=G6aRL6pFKYJdeU6p5IWJ7kiH8eEV0fSNVZfQloEkiU4=;
 b=JzTo0rbcWM3YU0LHPk4CZDxJU9Gw1oaRoscAZHTSxez9p8HaJzJPQE0gtfbePKmselYD
 6AXFn1f6YfHLRv5NCz4s4b8MBfY7x3k7Db0xLxdLp8nhR8UrxyL9mPvoqpA98pFejfR4
 IO6HRC8e+9R5eEI9D3x5fg+dH0o4uSbQ56ODhUwjh+5kJeT0KQaaMkHmqWb9XXlPCO2t
 CZ7FEIfHVb4e1FHNCjDHhvzCCWFzT/gQ9z5o2GXDifLRaEWlGpkYBqDUMLLKXtpAfUcl
 u4t1tHSNnYp9yvpDHfKTBeVs9BBlACK7Ii8RQfxuX6tJTL/7wWbKdC/IRN95B5s78pMd qg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w20yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:45:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6aRL6pFKYJdeU6p5IWJ7kiH8eEV0fSNVZfQloEkiU4=;
 b=alEH/dU6obBKeN3sCw889ZAR8VwCbRvFHgs4eR1wkd6W0OGsp1YqvK5Jow9Ifsez/5nKOt6Rzw9TmgFvVuRJsxwEt2JSVeNfJUo4g2jV9tnM1o3EzhSFDH0bl43nhTA2y0z0Nu1GhVcqJ2mTS/NRPsMRfFpDbWuWsqjV894lzDg=
Received: from CO2PR07CA0068.namprd07.prod.outlook.com (2603:10b6:100::36) by
 CO2PR07MB2488.namprd07.prod.outlook.com (2603:10b6:102:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Sat, 15 Jun 2019 23:45:38 +0000
Received: from DM3NAM05FT028.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::201) by CO2PR07CA0068.outlook.office365.com
 (2603:10b6:100::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.12 via Frontend
 Transport; Sat, 15 Jun 2019 23:45:38 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT028.mail.protection.outlook.com (10.152.98.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:45:37 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNjZiX014149
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 16:45:36 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:45:34 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:45:34 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNjTXi025910;
        Sun, 16 Jun 2019 00:45:32 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 0/6] net: macb patch set cover letter
Date:   Sun, 16 Jun 2019 00:45:11 +0100
Message-ID: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(39850400004)(2980300002)(189003)(199004)(36092001)(476003)(16586007)(110136005)(246002)(5660300002)(76130400001)(316002)(77096007)(305945005)(186003)(107886003)(4326008)(70586007)(486006)(26005)(50226002)(8676002)(8936002)(54906003)(70206006)(26826003)(478600001)(356004)(6666004)(2906002)(126002)(2616005)(86362001)(2201001)(14444005)(51416003)(36756003)(336012)(47776003)(53416004)(7636002)(7696005)(7126003)(50466002)(426003)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2488;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296f8e12-ec98-41ce-bf64-08d6f1eb91ae
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:CO2PR07MB2488;
X-MS-TrafficTypeDiagnostic: CO2PR07MB2488:
X-Microsoft-Antispam-PRVS: <CO2PR07MB248870DC3E034DA0869D2D40C1E90@CO2PR07MB2488.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zA/j00yp5XGFG59nOBVfHwgMHPlL+4DkHDRDLAibvJ5upjNWZ4YJzz5Ux8A6jJkKP019rm9EneNfyN3LTP+VlfWPRj7ZwBaw6NGWz25TaqRxUBa3joBfeqfAyRGMJGa/NWoZbSqpjTJCX2U5DRIdkzx5B/K8W/ZisZJ7vhR9H9+iwbIbtOjmhr7svwBTMtODrbbZauDQNGMG2QzHawLzkCcG0WdN7DgDqxj0rkXoPzVdrtkQ3iBTAGYYErL3QdYIq7Gfh6xafC3gWVMT9SskfCZ5J1V3V+e3SwbYSw6JfV9gUqjvFGRWqKhbLX9hRLtyqJDNldCBmB0LJ8x+e4lHslPitlOBSxw0LvLua6AwztnDjmhng8txlVrbVqNROeXcedGUaCAmZczKHtBnshpd8LN0im46PYe61qR69TjfBDo=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:45:37.8379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 296f8e12-ec98-41ce-bf64-08d6f1eb91ae
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2488
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello !,

This is second version of patch set containing following patches
for Cadence ethernet controller driver.

1. 0001-net-macb-add-phylink-support.patch
   Replace phylib API's with phylink API's.
2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
   This patch add support for SGMII mode.
3. 003-net-macb-add-PHY-configuration-in-MACB-PCI-wrapper.patch
   This patch is to configure TI PHY DP83867 in SGMII mode from
   our MAC PCI wrapper driver. 
   With this change there is no need of PHY driver and dp83867
   module must be disabled. Users wanting to setup DP83867 PHY	
   in SGMII mode can disable dp83867.ko driver, else dp83867.ko
   overwrite this configuration and PHY is setup as per dp83867.ko.
4. 0004-net-macb-add-support-for-c45-PHY.patch
   This patch is to support C45 PHY.
5. 0005-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G USXGMII PCS in fixed mode.
   Since emulated PHY used in fixed mode doesn't seems to
   support anything above 1G, additional parameter is used outside
   "fixed-link" node for selecting speed and "fixed-link"
   node speed is still set at 1G.
6. 0006-net-macb-parameter-added-to-cadence-ethernet-controller-DT-binding
   New parameters added to Cadence ethernet controller DT binding
   for USXGMII interface.

Regards,
Parshuram Thombare

Parshuram Thombare (6):
  net: macb: add phylink support
  net: macb: add support for sgmii MAC-PHY interface
  net: macb: add PHY configuration in MACB PCI wrapper
  net: macb: add support for c45 PHY
  net: macb: add support for high speed interface
  net: macb: parameter added to cadence ethernet controller DT binding

 .../devicetree/bindings/net/macb.txt          |   4 +
 drivers/net/ethernet/cadence/Kconfig          |   2 +-
 drivers/net/ethernet/cadence/macb.h           | 136 +++-
 drivers/net/ethernet/cadence/macb_main.c      | 659 ++++++++++++++----
 drivers/net/ethernet/cadence/macb_pci.c       | 225 ++++++
 5 files changed, 860 insertions(+), 166 deletions(-)

-- 
2.17.1

