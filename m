Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28DB4B42C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbfFSIka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:40:30 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:27516 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730418AbfFSIka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:40:30 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J8XXmF026446;
        Wed, 19 Jun 2019 01:40:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=18aaMrsMqJhQ0U6Z9t9N3LI8rLFx6DxufpaPU8Y5Ey4=;
 b=cpObaM0kfd6Q5Vuq2G0H4CmjrmUO5JrrRQOUgSanQk3DkW5lLXvPU+jbMmT7QFvNMb0/
 KsuAngevqmf0wMWgs4ZhPBS8MMG1QRMftyIezWYW3r0h5gwrE1qQYtReN2K2L1CAw2zQ
 /IQjHCyfq6ruVXXtEytdgPtnj3H4GY7RaIFeS59Pj+OPj9wgDPQfdA5ynarpWdfhvSqa
 GoHEavLuHebv4d1j9qqpSTCgfJubVcdl97jvOf5BsAm7q6kt35aKuZzuGWxa0s6ESUag
 MgPeeduyD6h5+rNN0VYg/fV/u14TfYVQnVpjCENnCDuLHJl554pXvYd41ctofSHYAJJ3 Iw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t7byx1gu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 01:40:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18aaMrsMqJhQ0U6Z9t9N3LI8rLFx6DxufpaPU8Y5Ey4=;
 b=TZII+lvJoKONuGi1xZlNVKKG0RbMW61KWfWsXBHR0EngXXvNg8GGgqLFKd92XhfOSPCqJOWwnobb1ZCFu3PvtQy0WQ6+jwrBkF9IG4Ned4p4uOPAIQC4eBhTVt/Sp5Bfk+2SIxVydy9YlGdLbilALyLik/xLVgMPPeU7BKfkrV8=
Received: from DM5PR07CA0077.namprd07.prod.outlook.com (2603:10b6:4:ad::42) by
 CO2PR07MB2488.namprd07.prod.outlook.com (2603:10b6:102:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 08:40:13 +0000
Received: from DM3NAM05FT016.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::207) by DM5PR07CA0077.outlook.office365.com
 (2603:10b6:4:ad::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.13 via Frontend
 Transport; Wed, 19 Jun 2019 08:40:13 +0000
Received-SPF: PermError (protection.outlook.com: domain of cadence.com used an
 invalid SPF mechanism)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT016.mail.protection.outlook.com (10.152.98.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Wed, 19 Jun 2019 08:40:12 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8e83o017010
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 19 Jun 2019 01:40:10 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 19 Jun 2019 10:40:07 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 19 Jun 2019 10:40:07 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8e2g2027845;
        Wed, 19 Jun 2019 09:40:04 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v2 0/5] net: macb: cover letter
Date:   Wed, 19 Jun 2019 09:40:00 +0100
Message-ID: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(136003)(2980300002)(448002)(199004)(36092001)(189003)(110136005)(4326008)(486006)(48376002)(7126003)(2616005)(53416004)(476003)(26826003)(336012)(8676002)(508600001)(246002)(426003)(305945005)(7636002)(8936002)(316002)(2906002)(50466002)(50226002)(126002)(70206006)(36756003)(70586007)(86362001)(16586007)(76130400001)(51416003)(186003)(356004)(47776003)(107886003)(7696005)(6666004)(5660300002)(26005)(77096007)(2201001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2488;H:sjmaillnx2.cadence.com;FPR:;SPF:PermError;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0425ba07-ff26-4914-b7e4-08d6f491bef3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:CO2PR07MB2488;
X-MS-TrafficTypeDiagnostic: CO2PR07MB2488:
X-Microsoft-Antispam-PRVS: <CO2PR07MB2488B09482FEAA20FD135447C1E50@CO2PR07MB2488.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0073BFEF03
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: y2YV2GhbNPr6sg5/rpCCWYsZy2oqxytezvYfA2eLpew36B0qhezSYcb/lut35FxjNvXMUqEYck4VTFtpV289tW+1GjzCwceF8bZXjRTlhtD5UqyQFxkJvTrKYdP0Okl3LESREQ7J5TLGVjzI/KZgluPbHsgQGruSUaDQF2IhrFBhK0/kBZweEkqPbkoNPI4q1XqLXUP5M+YE3IeVxRfKkpJgcokRCzXlEUS9DvlfoEuMhpVQchySvz5raHGoGVEstn6BpI5aKpvQv/sWAVmZgP4eUXVwAwQBduB1j2J/DvQ89/z2IXaisBLWYuP1CbhWvfDZfGv4EhDyHh79EZM1/EvlZI67n5wAXyrgZMzjPNswpm6bWoAvuGwhpYcr6G61V6C0OdxWfNIj8HiRmTKshOMIibRp6/ysvPmAaGT4GRs=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2019 08:40:12.5225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0425ba07-ff26-4914-b7e4-08d6f491bef3
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2488
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190072
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
3. 0004-net-macb-add-support-for-c45-PHY.patch
   This patch is to support C45 PHY.
4. 0005-net-macb-add-support-for-high-speed-interface
   This patch add support for 10G USXGMII PCS in fixed mode.
5. 0006-net-macb-parameter-added-to-cadence-ethernet-controller-DT-binding
   New parameter added to Cadence ethernet controller DT binding
   for USXGMII interface.

Changes:
1. Dropped patch configuring TI PHY DP83867 from
   Cadence PCI wrapper driver.
2. Removed code registering emulated PHY for fixed mode. 
3. Code reformatting as per Andrew's and Floren's suggestions.

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
 drivers/net/ethernet/cadence/macb.h           | 135 +++-
 drivers/net/ethernet/cadence/macb_main.c      | 668 +++++++++++++-----
 4 files changed, 628 insertions(+), 180 deletions(-)

-- 
2.17.1

