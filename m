Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6B911E0FE
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfLMJkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:40:53 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:30182 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbfLMJkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:40:52 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD9YVdr004320;
        Fri, 13 Dec 2019 01:40:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=5uRMCp6HQSRwMrNR1xdeqgpN0OtvPwy+xwDBXUPrD4k=;
 b=sDYKJBRrIIEvXvH3fYN1W1b+32/n0fwE4u1PXTc/HBbJpGuUh6/sn9Pp5l1HJ7/e6+Q5
 poEdDsaee9JjLs6u4aIQzQLwXfBidHUSDoDSlSYoXCvQch76YhwtbF4G/Ft90cEJ3V94
 aW1oHxZMHYATvDIAZtVVZvnsG2K8H8akF1TeltdcW4q14pMVS8S+OYxTL0SJQmWnFXhw
 QWGxfbQT3xGov45AEFTEZlQRFXsuipg+RVtx88O7B9hfSo53qCUd8aSs1Kzcwmr3UhnT
 rOvwaRMVtKchto5RtmFPsNX2sxNxCMIJjqrG0bWOqVCAIIjiQHxTWFyJbYzqQWE3/kCD RA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfx4dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 01:40:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhIW7PIXmb1K9jH9gbVlIluWZyC6W3E3h/mQAHs/DVvnYOmxaOGS/AiiwYQmTTDb5h7hno3RpDjTRl4a0fnrrQGwVK/pfOch/apCwFxw+GEF6dDHQu6yt6wAcvyu0R9moEbzQ/vhViGmtLk6xND0lgDANFblUHv7kVYStVmmAeRXVAHq6j3yc8kVn1MWhxznL5AoWXkx/A3hW0BQWF1o70lc207sZA+Wqg3KfqjE7+SZnE5V5LxetIVVf2lJje44xAU1aTqz+DGPfUPOmKBlLvN78Zg8V3GG8ILJ9F9Zj+ZdPNU/RUG4kVnFTo3GEmpfAp/rg7pUIGMpQY2LRIUI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uRMCp6HQSRwMrNR1xdeqgpN0OtvPwy+xwDBXUPrD4k=;
 b=DE2PUXO3cRRv+PhTC6tZR8wJFZQTb/1/Z69RDiyAObUVMjXBeQk+8ZYxLMZW1isjbIsJD8ejL/7BvXQMCBrTzl+vy1Ju4D4Z9K7yLEn/HGWZXMV+lWsBaaS+wAwuXMNMpAZgJ4MY9auY3OepjN5JXPqGEpQxBtZMRYsd0pJm+Df6Xr7w+uqVa5bx95tfF6s+ZwOR/L1uCHRzNG+7sTtIA6ay9lkCkv97pObJRyLG6Tuonk+Aq/6ncoQj0X0CiOo7oXZM19YtAf8hDzhq6tEurjbWbB6tHbwPabhxaGAIq8DKaY0EXsFk9gLzNYEtzgR6wkqGlbMAR04ibmAHKlGe2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uRMCp6HQSRwMrNR1xdeqgpN0OtvPwy+xwDBXUPrD4k=;
 b=i74vM/5l8ub71bcNGPkB8N06u1BfydMBJnjd2kkNfE4CUp12OZhTgNb+6FHWnDE+7Mxxzzngg1BEMV4cGv35IbFN82Y4UPtuppAHPhnM15zwPNX3/yEKp5yLQMnpve+2iwZum80EtGi9JYummA2vPzia6r3ptW+V//XYf1U413A=
Received: from DM5PR07CA0107.namprd07.prod.outlook.com (2603:10b6:4:ae::36) by
 MN2PR07MB6510.namprd07.prod.outlook.com (2603:10b6:208:167::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.16; Fri, 13 Dec
 2019 09:40:19 +0000
Received: from MW2NAM12FT021.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::200) by DM5PR07CA0107.outlook.office365.com
 (2603:10b6:4:ae::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.17 via Frontend
 Transport; Fri, 13 Dec 2019 09:40:19 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx1.cadence.com;
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 MW2NAM12FT021.mail.protection.outlook.com (10.13.180.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16 via Frontend Transport; Fri, 13 Dec 2019 09:40:19 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9eEpt023309
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 13 Dec 2019 01:40:16 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 13 Dec 2019 10:40:14 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 13 Dec 2019 10:40:14 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9e8Q8011216;
        Fri, 13 Dec 2019 09:40:09 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <rmk+kernel@armlinux.org.uk>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH v2 0/3] net: macb: fix for fixed link, support for c45 mdio and 10G
Date:   Fri, 13 Dec 2019 09:40:07 +0000
Message-ID: <1576230007-11181-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(36092001)(189003)(199004)(54906003)(4326008)(110136005)(7636002)(2906002)(7126003)(2616005)(478600001)(336012)(26826003)(5660300002)(8936002)(426003)(70586007)(7416002)(8676002)(76130400001)(70206006)(356004)(186003)(7696005)(26005)(246002)(36756003)(107886003)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6510;H:sjmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc5ef34-e049-4f79-d359-08d77fb07787
X-MS-TrafficTypeDiagnostic: MN2PR07MB6510:
X-Microsoft-Antispam-PRVS: <MN2PR07MB65103960F8FE8F9FEDE12F9AD3540@MN2PR07MB6510.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0250B840C1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYFSMr4HLLZdJFmJQJ//HChffx/uRdtFNzZC5yQ9ksmSBv8yBvtDRmXrGHPjWeHR87T1P5Ol+PlMMgjJturGz9L/Sz0NTDW4WDOrI8jsZTYS+89f98u4TPzrrs6bX2p/9QdSdMZmNnU3Gj9HqX4bIMkojKZzzgnxixKpQ3mWSY/KWiQdaNNgxNuASRbF2gfrLwjqopfe4T75WcD/nFJr/oDaAwol0/k0fJ7JRNiacQ9GGwIQ+bHPyiYDtCIxNlHEpHtiO8LdQyLwknuKhnzBp2tsmpNPHTz+EYiUY3IP9MLyu7lpDviJTGFDYJclCRdYAZcuizuJSn9t/vct7UeiWP6edx0flBY8tvQPMVhJvXUBr8B2jfZUcKAsOndgnwWEBthTLc0ORc8hbUIodf7SJjDc8VoJz2Yv9skejyg/AYm76ApcPww/QcyDryxfOOitIWbUQ4caQN4Mj38m2nmN56hXNCU3JXj6KI9h87NX2GJR15J/F1p8ij72Rr0dAGFy
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2019 09:40:19.1935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc5ef34-e049-4f79-d359-08d77fb07787
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6510
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_02:2019-12-12,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=590
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series applies to Cadence Ethernet MAC Controller. 
The first patch in this series is related to the patch that converts the
driver to phylink interface in net-next "net: macb: convert to phylink". 
Next patch is for adding support for C45 interface and the final patch
adds 10G MAC support. 

The patch sequences are detailed as below

1. 0001-net-macb-fix-for-fixed-link-mode
This patch fix the issue with fixed-link mode in macb phylink interface.
In fixed-link we don't need to parse phandle because it's better handled
by phylink_of_phy_connect() 

2. 0002-net-macb-add-support-for-C45-MDIO-read-write
This patch is to support C45 interface to PHY. This upgrade is downward compatible.
All versions of the MAC (old and new) using the GPL driver support both Clause 22 and
Clause 45 operation. Whether the access is in Clause 22 or Clause 45 format depends 
on the data pattern written to the PHY management register.

3. 0003-net-macb-add-support-for-high-speed-interface
This patch add support for 10G fixed mode.

Changes since v1:
1. phy_node reference count handling in patch 0001-net-macb-fix-for-fixed-link-mode
2. Using fixed value for HS_MAC_SPEED_x

Thanks,
Milind Parab


Milind Parab (3):
  net: macb: fix for fixed-link mode
  net: macb: add support for C45 MDIO read/write
  net: macb: add support for high speed interface

 drivers/net/ethernet/cadence/macb.h      |  65 ++++++-
 drivers/net/ethernet/cadence/macb_main.c | 224 +++++++++++++++++++----
 2 files changed, 247 insertions(+), 42 deletions(-)

-- 
2.17.1

