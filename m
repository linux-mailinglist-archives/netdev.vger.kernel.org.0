Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534C913D67F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbgAPJN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:13:27 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:27570 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729139AbgAPJNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:13:06 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G9CfLB024975;
        Thu, 16 Jan 2020 04:13:03 -0500
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2059.outbound.protection.outlook.com [104.47.36.59])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xfc59my65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 04:13:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0O2zgpx/TTAGIRP+gQyhloWtLN+VrHnlBPPRZg42ubroOyybMytHOXcr0r4VQ7D94nakclOHzhHTgORk/lnupEhxHgF6sw1UKM1yahoHOWUdPoOlLeZh8qGSNv6BhCQi4InDv1z5O451vBHdguDQb8bQ6NcOTdOd2SDAx1ZNjY1aLpDyphBzSUIUHrZJrRJDaUi6PaM0Kukx5SH3vzKNFGFMniqsYvSr7NU+//rtad+sMB5+MnHl6pM56g14YDRAtmCeeFC2YyfDSImdroGPJr/B5GNNyO25EfRd+H8L1dmzzynscT3yUdD0xFSPc6jnmJbj+qjZ6icfzkEr8GVeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6aFuv9/zOIxMP3IBXnBJplTzMYLCE0fPq1lnckqF+c=;
 b=R+0YRT1aqMb0eRV15YYWCvO6TQGDghfK2NKHXS+KXXmOFr1z5+VjMQzfAYmLhS6BR0ncGiUWKXMNj4TXBEyPPI24/fK/b7tr91ojFxoNpZ7JT8uVF7DRlME5wGYO4ABtD4jFS5a+uHABNW7XovZrBVrxv5Mzj8P7s7jID1TZ+F3J0JQyKUBH9rcNPhwxBGYgj3a1XZ3TF2ORHavrbgTSCPCGpB6Ho61cAso9xYBu8ykeg5+VF9fcZYK5vjJPAWaUTbaoTLyfUWV9OUr4U4FirngIypmL3HVW8r6OvXcpHy8LEAwsvJIhPWw2NeU60XmQDgPsYi4KWU6lzkGpl30Zlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6aFuv9/zOIxMP3IBXnBJplTzMYLCE0fPq1lnckqF+c=;
 b=7VhVkJeo2Yfi76t6dZh7lBaUbdhiFnL4sNJXW0ricd54/Rivl84Q3iWH+Yazh2k2pin5fPUglkQFMEf3dYK2ahExWiaLiS5b9ShIgEp2V9bedMo0ctTR34gFjIcV02nPcY7GwgzbGcpEs5G0wQ8vlZ+EoH8t5iMQKVs36i2/Xm0=
Received: from BN6PR03CA0089.namprd03.prod.outlook.com (2603:10b6:405:6f::27)
 by BN8PR03MB5123.namprd03.prod.outlook.com (2603:10b6:408:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19; Thu, 16 Jan
 2020 09:13:01 +0000
Received: from SN1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by BN6PR03CA0089.outlook.office365.com
 (2603:10b6:405:6f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.13 via Frontend
 Transport; Thu, 16 Jan 2020 09:13:01 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT037.mail.protection.outlook.com (10.152.72.89) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2644.19
 via Frontend Transport; Thu, 16 Jan 2020 09:13:00 +0000
Received: from SCSQMBX10.ad.analog.com (scsqmbx10.ad.analog.com [10.77.17.5])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00G9Clgw032333
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 01:12:48 -0800
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Thu, 16 Jan
 2020 01:12:58 -0800
Received: from zeus.spd.analog.com (10.64.82.11) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 04:12:51 -0500
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00G9CkjV020088;
        Thu, 16 Jan 2020 04:12:47 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 0/4] net: phy: adin: implement support for 1588 start-of-packet indication
Date:   Thu, 16 Jan 2020 11:14:50 +0200
Message-ID: <20200116091454.16032-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(54906003)(44832011)(110136005)(426003)(246002)(36756003)(316002)(7636002)(2616005)(8676002)(4326008)(70206006)(5660300002)(70586007)(1076003)(107886003)(2906002)(26005)(7696005)(186003)(336012)(8936002)(356004)(478600001)(6666004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR03MB5123;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cefe399-2581-4f04-e970-08d79a64491a
X-MS-TrafficTypeDiagnostic: BN8PR03MB5123:
X-Microsoft-Antispam-PRVS: <BN8PR03MB51233B6BDF47BC6CD07C2480F9360@BN8PR03MB5123.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAbuWAyoRi7u7+QMR+uBzrcITIsAjomQnNSWFvSM0tHpmLk2zQogxojWZerG8jTgtkiZa4hcRp/6qi+ZIZ8uRq7IcYsBhFITLpnQPAdh2c+Ky1lPlbCW/3+jcvp3wEQMiLPUUkdZQQuiRNKdue68aDyWvX/X7oo4oU1g3yK9dAHhgvecbeeF1m0eGLcOB2bm52cOYvkX5MY5r69rKSkYbqfPSk8jZEIBrxyGcoBhUK/RmI2jxAq/QLhu4PbH5FnPZgbLDh/j9E3Hv/m8WoDwd4KmCXMDMe+f8d3njyOWk5nP0587ewgmpMat2JZuc9S4OM5EbxYHfnBA8CshjdjIT0VjO+FOjCdATjzMWOgldh4cK5OlknPRT+R7N4KdbQqs5TZqPvxn5cabV/X6Hwmzdvs/uKVUM5POy6MppuOOgrDvQoNtoy/SGOV0XY56VJp+
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:13:00.8841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cefe399-2581-4f04-e970-08d79a64491a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB5123
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_02:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=923 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001160078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1300 & ADIN1200 PHYs support detection of IEEE 1588 time stamp
packets. This mechanism can be used to signal the MAC via a pulse-signal
when the PHY detects such a packet.
This reduces the time when the MAC can check these packets and can improve
the accuracy of the PTP algorithm.

The PHYs support configurable delays for when the signaling happens to the
MAC. These delays would typically get adjusted using a userspace phytool to
identify the best value for the setup. That values can then be added in the
system configuration via device-tree or ACPI and read as an array of 3
elements.

For the RX delays, the units are in MII clock cycles, while for TX delays
the units are in 8 nano-second intervals.

The indication of either RX or TX must use one of 4 pins from the device:
LED_0, LINK_ST, GP_CLK and INT_N.

The driver will make sure that TX SOP & RX SOP will not use the same pin.

Alexandru Ardelean (4):
  net: phy: adin: const-ify static data
  net: phy: adin: rename struct adin_hw_stat -> adin_map
  net: phy: adin: implement support for 1588 start-of-packet indication
  dt-bindings: net: adin: document 1588 TX/RX SOP bindings

 .../devicetree/bindings/net/adi,adin.yaml     |  60 +++++
 drivers/net/phy/adin.c                        | 227 +++++++++++++++++-
 2 files changed, 274 insertions(+), 13 deletions(-)

-- 
2.20.1

