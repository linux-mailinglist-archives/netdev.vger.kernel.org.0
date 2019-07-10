Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4231464881
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfGJOhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:37:09 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:58980 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbfGJOhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:37:09 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AEWcFf030919;
        Wed, 10 Jul 2019 07:36:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=JSHQ4f+RcZgf1UXAMrPAw9lan7skEb9rxYJP5IiDz1g=;
 b=V5CYjHhY9C5vyTWta4mF1o4ZI8wSDjH10DUzIF1sMIj6Ah7wLlNZOrm2c6oOV6j4OWEW
 KAk/cv28BfzGxXLkwmza78+G9WZBCV95N4QWA8OzWkg6HHE8p+74sXIyFtugHATSn6gs
 4HsuNyd6wIDcysakJmp458SX8g5T6ggP3Pt2jhGcemGE59+lMEcE1Qum61HtfjNXpL+Y
 KD+U2il/23Cw4P4byRrLE1xBrrXrpDqJKgyZ+qtjex1AAYZTTITT2lS1RNzpYebNZ84C
 XM2EI5ONDBmMkIX+ll/XTZkAWpIaSpeQe3FFIdNKmMsAc7sIprReymP7dzSpw5JeDdQ8 pQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2051.outbound.protection.outlook.com [104.47.38.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2tjr6vr3pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 07:36:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSHQ4f+RcZgf1UXAMrPAw9lan7skEb9rxYJP5IiDz1g=;
 b=NKDM7a15AUpWb+Hyd4/Iay7uVihyaHph4x3gelFWh7XQJkQc0kDqO1h+66A4HvetucVCRk0S5kKa1jkZgW0+doVkWj9boyNk2UzDdaWwKhWIRoJPSRgPObwzds0AasvRU7vD7qpGPUn2TMVvSm25KNgOffj2ZtKsYtV30OTSVgA=
Received: from BYAPR07CA0028.namprd07.prod.outlook.com (2603:10b6:a02:bc::41)
 by MWHPR07MB3117.namprd07.prod.outlook.com (2603:10b6:300:ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2052.16; Wed, 10 Jul
 2019 14:36:42 +0000
Received: from BY2NAM05FT034.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::206) by BYAPR07CA0028.outlook.office365.com
 (2603:10b6:a02:bc::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2073.10 via Frontend
 Transport; Wed, 10 Jul 2019 14:36:42 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BY2NAM05FT034.mail.protection.outlook.com (10.152.100.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.8 via Frontend Transport; Wed, 10 Jul 2019 14:36:41 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEabDs004523
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 10 Jul 2019 07:36:39 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 10 Jul 2019 16:36:37 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 10 Jul 2019 16:36:37 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEaWq9031868;
        Wed, 10 Jul 2019 15:36:35 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <piotrs@cadence.com>, <aniljoy@cadence.com>,
        <arthurm@cadence.com>, <stevenh@cadence.com>,
        <pthombar@cadence.com>, <mparab@cadence.com>
Subject: [PATCH v6 0/5] net: macb: cover letter
Date:   Wed, 10 Jul 2019 15:36:31 +0100
Message-ID: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(39850400004)(376002)(346002)(2980300002)(199004)(189003)(36092001)(246002)(186003)(336012)(14444005)(26826003)(7636002)(478600001)(305945005)(26005)(36756003)(316002)(76130400001)(50226002)(2906002)(126002)(7126003)(476003)(486006)(54906003)(53416004)(16586007)(8676002)(48376002)(2616005)(50466002)(107886003)(86362001)(8936002)(70586007)(7696005)(110136005)(6666004)(4326008)(47776003)(426003)(2201001)(5660300002)(356004)(51416003)(70206006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR07MB3117;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d381fc9-fb00-4257-5eaf-08d705440655
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MWHPR07MB3117;
X-MS-TrafficTypeDiagnostic: MWHPR07MB3117:
X-Microsoft-Antispam-PRVS: <MWHPR07MB3117B19FC5818E202ACA6643C1F00@MWHPR07MB3117.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0094E3478A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vpaBZO3PXT2yCsTeLpy3PlLsbZfrmu1G63gchvVj7QYen4FoFdD5KO51mr0svU9IUKpZrIQBvp2XJfmC60c0XJ9lnHydSE1x9gUrFvwFgXwHAgoQPcZT6riY8GRwrxvkwSgHVUEhXQJ3McXCoIABZuFaJcYACRA58IYUE4sJdhOOyh+9TEoiDkxnFny/iQK4WPfazJBD6VAwuuUIm1hnnxa/33lOBn11chBFbspALsdQsIv7caVZXuxqdGTDs1nhJO3qQmbNj9+GhMeTf9goR8dgc8u4VZ6+ZHhtZz0d+VwhoiFreQNdIVTA6UQQ0TwDjH7DzrFGodzXo59dpyjSZPx3A6g1SGOu1qiwXN1xc6PPP7tFH/59cjQtO0a4i7Kjmv0ScWlLimt36FIdO0il7p4jjClFkTJIc0mqkTSHg4w=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2019 14:36:41.7807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d381fc9-fb00-4257-5eaf-08d705440655
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB3117
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello !

This is 6th version of patch set containing following patches
for Cadence ethernet controller driver.

1. 0001-net-macb-add-phylink-support.patch
   Replace phylib API's with phylink API's.
2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
   This patch add support for SGMII mode.
3. 0004-net-macb-add-support-for-c45-PHY.patch
   This patch is to support C45 PHY.
4. 0005-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G USXGMII PCS in fixed mode.

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

Changes in v4:
1. Removed PHY_INTERFACE_MODE_2500BASEX, PHY_INTERFACE_MODE_1000BASEX and
   2.5G PHY_INTERFACE_MODE_SGMII phy modes from supported modes

Changes in v5:
1. Code refactoring

Changes in v6:
1. Allow phylink to validate particular phy_mode support by hardware.
2. Remove device tree parameter and 5G serdes rate for USXGMII

Regards,
Parshuram Thombare

Parshuram Thombare (4):
  net: macb: add phylink support
  net: macb: add support for sgmii MAC-PHY interface
  net: macb: add support for c45 PHY
  net: macb: add support for high speed interface

 drivers/net/ethernet/cadence/Kconfig     |   2 +-
 drivers/net/ethernet/cadence/macb.h      | 115 ++++-
 drivers/net/ethernet/cadence/macb_main.c | 543 ++++++++++++++++-------
 3 files changed, 483 insertions(+), 177 deletions(-)

-- 
2.17.1

