Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7CC4FAE2
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfFWJRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:17:31 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:56638 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbfFWJRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:17:31 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5N9F6pd009074;
        Sun, 23 Jun 2019 02:17:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=Oj5Scj4zxwarFsSoJIjGVxnnMSphxmQjLKv52ck5xEk=;
 b=a8rSeuWK/fNWAY7Fs0WF94RUO9g21ab0lqNs9tAoheMYlJFpN5Q+4Nn7XxeUE8OtzKdh
 UA3AKlk5HNqndSi+EyLNykGpwaZNmxHcWOqIBBjFp4FODLx1o+1kOZrz7RTfMQOm5zUP
 svNJXH8CcbDQPw+fLZD+8eLEPMilu3Ulm4bOBnu5kjH+yEaQLubr4ltWh8sfsG3+hWo9
 xYt852JTi6XeAFIsfJfDwB5TrC1Riyed/xQdlfC8mWUjPzw8BuGAwHI92/+sJpBiZYpO
 ZkKPkKwFLP4P9wzhD2F7HyLv6AE+hvjDXoabm2eWknQml7XpktkqZPURu6012fnQ8WGA cA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2050.outbound.protection.outlook.com [104.47.41.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtjw05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 02:17:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oj5Scj4zxwarFsSoJIjGVxnnMSphxmQjLKv52ck5xEk=;
 b=OKj5qKM+EOH2/IxSQxXmKWpVLj1i0A2XNG+dNtwpsSQu7D4VgGGkNoFVbF8R7Qha+12cg4WW3Wj8Cq9CAbHe+VVDTWkA/gumb9VY++tBYyRt45Akd52R+lLKy+y0KJcYVh7thETFyy/+wCATlQkvo1INgymcxyNdjZLIadTWlHw=
Received: from CY1PR07CA0025.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::35) by BN8PR07MB6818.namprd07.prod.outlook.com
 (2603:10b6:408:b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Sun, 23 Jun
 2019 09:17:13 +0000
Received: from DM3NAM05FT019.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::204) by CY1PR07CA0025.outlook.office365.com
 (2a01:111:e400:c60a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.15 via Frontend
 Transport; Sun, 23 Jun 2019 09:17:12 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 DM3NAM05FT019.mail.protection.outlook.com (10.152.98.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Sun, 23 Jun 2019 09:17:11 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9H7O9008096
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 23 Jun 2019 02:17:08 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 23 Jun 2019 11:17:06 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 11:17:06 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9H1qS006191;
        Sun, 23 Jun 2019 10:17:03 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v4 0/5] net: macb: cover letter
Date:   Sun, 23 Jun 2019 10:16:59 +0100
Message-ID: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(36092001)(107886003)(2201001)(4326008)(26826003)(356004)(6666004)(426003)(70586007)(50226002)(86362001)(70206006)(478600001)(7126003)(2616005)(476003)(486006)(76130400001)(126002)(5660300002)(336012)(110136005)(51416003)(316002)(54906003)(16586007)(47776003)(53416004)(2906002)(7696005)(305945005)(48376002)(7636002)(50466002)(77096007)(26005)(36756003)(246002)(8936002)(8676002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR07MB6818;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 172e3988-1ec9-4e05-62d3-08d6f7bb937c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BN8PR07MB6818;
X-MS-TrafficTypeDiagnostic: BN8PR07MB6818:
X-Microsoft-Antispam-PRVS: <BN8PR07MB68185E2177651F8F46BAABE9C1E10@BN8PR07MB6818.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 00770C4423
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AXJ5biU5kmiF3LUlFx8B3tBMHpoQSOyXytDjH6buc3o6SjmYpM6ISoIimSpJ4LM09au5lLSQB/Gy+lCd3WkR8gd5QnfNozhY8YRJg5LLBRXr2YjNSmMsSI/MjcoqO8aTyb3CeXwZlljrnGmBKoty8T3FW5mZyz4HmR3w5d5ce+uc0MT19OrTchtfjowTC8m1dZzJBCPXEh45enk5aBXhcrR1NDZHNMNggroArMoEJ3Z2WKtjR4ShMYSc1SrbnjuMD5I+0NftmqWV7oM3xpeG9HBqRKE5JuSr0woZIQsKlU+63rlLSAGvbZxK9xCk6peVIKB+6uj2bJjZS3MMyPK0gzJMkR7wMaUAQxTFbkAIeh0i7kr2ZlgUpwkKSCI1uQprnO9h6iFCL713Lhdm2pDZQMdUCIpRUVzz7ugAsrkSUps=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2019 09:17:11.9427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 172e3988-1ec9-4e05-62d3-08d6f7bb937c
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6818
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-23_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906230082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello !

This is 4th version of patch set containing following patches
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

Changes in v4:
1. Removed PHY_INTERFACE_MODE_2500BASEX, PHY_INTERFACE_MODE_1000BASEX and
   2.5G PHY_INTERFACE_MODE_SGMII phy modes from supported modes

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
 drivers/net/ethernet/cadence/macb_main.c      | 589 +++++++++++++-----
 4 files changed, 524 insertions(+), 183 deletions(-)

-- 
2.17.1

