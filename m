Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9614E50A71
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbfFXMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:10:45 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:60470 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726351AbfFXMKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:10:45 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OC7V7Z029689;
        Mon, 24 Jun 2019 05:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=herx55GRVReUd5mD9QBWH//pJbrMu+PEKOmqsXbu19g=;
 b=hjpE8SoOO3s3iwaBDFtYOO8GYR5FluEKLvocZv0a9zYZ9JpZ3+6v6IgLu+7icUAKBsVj
 Ehz1xE9UixNiab6xIiRsqEHSxT/CZlwD0tfv0dtEj0/JINcRNFkUpeeTpx6T0ICnoPf7
 7mIqCNPbZ9OzLu1FkH0Q7Tq3vA87Lsiq6LKd125E05CM1thiKjs4ZwKNADc86d/RXYgh
 RipXkSyjg7TFBvqFZjNs0l1znT/Eg9nnHIbGKd2IzKV6O2FM6z4/txw6JuHruxjZz+RI
 yvi4jznIschd4YwbqsJiu9h9PpeA3mmcyaxYS/WCxk8Rx/WCMmRI/noYTvr8cVasU60V Gg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2055.outbound.protection.outlook.com [104.47.32.55])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs7715-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 05:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=herx55GRVReUd5mD9QBWH//pJbrMu+PEKOmqsXbu19g=;
 b=SHrNKzUeoxELGYsuef7c9iuD0UQgLDcuDfrA9IlzSTgU+/FYbBxh6axO8YrtIuYmEwdSa+7tzvp+znXAlauDKAFEeEfzZ5fIijxp1eWrbksfBmnvQ9TyI4feWIqbAr3wQxjDwRx+6ffFQje+qqd01Q2Cms2D+y7sVRAi0z6NnZI=
Received: from BYAPR07CA0069.namprd07.prod.outlook.com (2603:10b6:a03:60::46)
 by BN8PR07MB6961.namprd07.prod.outlook.com (2603:10b6:408:d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Mon, 24 Jun
 2019 12:10:23 +0000
Received: from DM3NAM05FT007.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::209) by BYAPR07CA0069.outlook.office365.com
 (2603:10b6:a03:60::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Mon, 24 Jun 2019 12:10:22 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT007.mail.protection.outlook.com (10.152.98.113) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Mon, 24 Jun 2019 12:10:21 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCAGd4005179
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 24 Jun 2019 05:10:18 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 24 Jun 2019 14:10:16 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:10:15 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCABYZ011103;
        Mon, 24 Jun 2019 13:10:13 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v5 0/5] net: macb: cover letter
Date:   Mon, 24 Jun 2019 13:10:10 +0100
Message-ID: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(396003)(39860400002)(2980300002)(199004)(189003)(36092001)(54906003)(51416003)(7696005)(16586007)(316002)(110136005)(478600001)(107886003)(305945005)(2201001)(2906002)(7636002)(246002)(8936002)(4326008)(486006)(86362001)(8676002)(426003)(126002)(476003)(2616005)(7126003)(50466002)(336012)(48376002)(50226002)(76130400001)(70206006)(70586007)(356004)(53416004)(47776003)(186003)(36756003)(26005)(77096007)(5660300002)(26826003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR07MB6961;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cde1b0bb-9458-4d22-b7da-08d6f89ceeb4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BN8PR07MB6961;
X-MS-TrafficTypeDiagnostic: BN8PR07MB6961:
X-Microsoft-Antispam-PRVS: <BN8PR07MB6961D12ACC2CD92A80BE4990C1E00@BN8PR07MB6961.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 007814487B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UKMB175G1kbnXq/wazs+2jAvX71UIiEHA1kb8jUoSZy0xjs3GBii6IWv2VEgeRj1DIIiEEDH2NeR6EgUsSASvhKxJOh42Ts9+6nH2Ej8SrkDtw/QDOvivYO+YXaq/64imN+gMSxfU/LLkdIWIntHcjbTfJ1VaZuwG5C5vb2h5K8WDuY6IzsWMUG3SXt7pwu5SErUMzV4iiBhcFiA7i4Tcs6a3q/Ukm7o7aj0hn2fjaZ8eSOJtVpT8+WH6+qU0hIonCn+oib85dNV4aZ+8QYNz7kt/of/CkuRh7IrQYzaHgmyjUiEqISk8sT6sWSn83figYgGIDq9eUbz7dXtMvhbMRrKkJVfv0ivAe2WcPP8xLy7/G8UewPBSib67/4GWaBnF83xsTogV6h206w6vl9bhOHYuVLyQ7hM5KNxHOwF3dU=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2019 12:10:21.7507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cde1b0bb-9458-4d22-b7da-08d6f89ceeb4
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6961
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello !

This is 5th version of patch set containing following patches
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

Changes in v5:
1. Code refactoring

Parshuram Thombare (5):
  net: macb: add phylink support
  net: macb: add support for sgmii MAC-PHY interface
  net: macb: add support for c45 PHY
  net: macb: add support for high speed interface
  net: macb: parameter added to cadence ethernet controller DT binding

 .../devicetree/bindings/net/macb.txt          |   3 +
 drivers/net/ethernet/cadence/Kconfig          |   2 +-
 drivers/net/ethernet/cadence/macb.h           | 113 +++-
 drivers/net/ethernet/cadence/macb_main.c      | 593 +++++++++++++-----
 4 files changed, 528 insertions(+), 183 deletions(-)

-- 
2.17.1

