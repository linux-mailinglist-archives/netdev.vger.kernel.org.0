Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCC81E49
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfHENzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:22 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:64284 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbfHENzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:22 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dr6eD015931;
        Mon, 5 Aug 2019 09:55:09 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb20e0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjrci0honDbNrQD7jPwIvjbwmn4hgMYhr9BucviLiWXrcgiquKjDje/wy5x7N+auSdiyf7OdRn7KOBtISVQiQYfJ5tqB+ikfyNeTDpRQ48bQS41R8LYdGuh2Y5F3CgXWINBL3+/p43XUZYoBjgMMiBdEvm/DmY2fyHlrde1teXhaloif879jbKFbWFMc0VtL2ODVkAnU8lJOz8OOv5TSJjRK90E8L4MyPmpLBfyFd8Uqm+KUAXramE1owNh2jz8kWq3/9wpc7Rw1mfrcpMatbAULmUP1jk562kqG6rTaAVftT6Su0uV8w61izCj8S6Gk/hTtn9PyNqZXp5wyuotT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWdVer8vo1i/Y8Hv7ibVXAXrVcDEJWoP7Ccfsz8bDLw=;
 b=f7aNp4haiCiEqZJID3jwYpaazN3mROUPKT7+beYNn96CWsrAdXKrG94ggspBra3W44dTOB0jkJNt5Npz7gsTbS4sY0shxTebVu42VhpMZjotdj+DD23foqp4i5iis3ZpztWW0XHBKpdTwYY1Mr1q1PJxt0x1PrbImOCB7RXXc+Ien7bB/lkA5aD9J4tZNNdO+iOxX4gVxMLiSZ4rH6P1+4y0v9W/GuE6Kt1WVgHo/oGo6NqbfA81GBp9fGwmOFRRJzN4GVgyNiGhquPCOEO/DTWJEMjRTD2ipqt+31BUhZDIpoFJ01NAzbPye0w+1OUcE00OWajM95fh5uEwEY5w0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWdVer8vo1i/Y8Hv7ibVXAXrVcDEJWoP7Ccfsz8bDLw=;
 b=N7JcyzFVEEKE1JniTLGe4lmkngBBrAlMW1jPmCJ67iciV8RPGAnH4XCAxP10UjeZjmCXegcVzoEWD8o/Dcci+zbx+T8nzd/K62m7xqbGpO61nGT0OTlP0C+ZEUlTfPe0EKlRcuOjSvHYYSopgUttnX/BY0CctyKYVAQJxlX/8Yk=
Received: from BN6PR03CA0060.namprd03.prod.outlook.com (2603:10b6:404:4c::22)
 by BYAPR03MB4710.namprd03.prod.outlook.com (2603:10b6:a03:131::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.15; Mon, 5 Aug
 2019 13:55:07 +0000
Received: from SN1NAM02FT018.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by BN6PR03CA0060.outlook.office365.com
 (2603:10b6:404:4c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.15 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:06 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT018.mail.protection.outlook.com (10.152.72.122) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:05 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75Dt16J016167
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:02 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:04 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 00/16] net: phy: adin: add support for Analog Devices PHYs
Date:   Mon, 5 Aug 2019 19:54:37 +0300
Message-ID: <20190805165453.3989-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(39860400002)(346002)(2980300002)(199004)(189003)(50466002)(336012)(6306002)(426003)(48376002)(186003)(106002)(107886003)(126002)(4326008)(486006)(2616005)(476003)(54906003)(110136005)(44832011)(316002)(7696005)(356004)(5660300002)(47776003)(14444005)(51416003)(1076003)(2201001)(26005)(6666004)(478600001)(966005)(2906002)(50226002)(70586007)(86362001)(70206006)(36756003)(246002)(8936002)(7636002)(8676002)(2870700001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4710;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6300a750-9464-464f-e29d-08d719ac85bb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4710;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4710:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <BYAPR03MB471016FBC5B6DDF4D2762A2BF9DA0@BYAPR03MB4710.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UWpgBd+oct7XBqOHwYsjsoDuMtIFwqRktxYz0z4aeo92kkfwBlaxwydg+N3tggSJV78b3Pg6/Qd5ptr8YnAxvO2XqiQBXYL1HZf8eDHcIUpCqEuO4gJc22Qe6GMyGBy3k5lZ6wx0JGTtyW47t0T3nEFkpLo7TZWAwcWa/YlXtdIcm3K/WRRXIxrQ9Rd/9NPJl4HPjCoz+kjsrNJ0Y5in+bi4fTnNTSZVeCIvPaJXi0bOU6u2UF+mQ89me8JrAjOnrJWLTyv71DYn/TChB+Py18zrufaLRwJNVJymx4vAHc6niguHCKHG4rcxVi3L8Din+CKaLOEjse+KvfSskfktIklewwKlwMRloCJnns+KX6op1ieiMrc+/JTcFeloCHtdERwVgUB975KGnTEhDXz+yUFi/egLnYnOSDpzrdon+94=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:05.7831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6300a750-9464-464f-e29d-08d719ac85bb
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4710
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=952 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changeset adds support for Analog Devices Industrial Ethernet PHYs.
Particularly the PHYs this driver adds support for:
 * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
 * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
   Ethernet PHY

The 2 chips are pin & register compatible with one another. The main
difference being that ADIN1200 doesn't operate in gigabit mode.

The chips can be operated by the Generic PHY driver as well via the
standard IEEE PHY registers (0x0000 - 0x000F) which are supported by the
kernel as well. This assumes that configuration of the PHY has been done
completely in HW, according to spec, i.e. no extra SW configuration
required.

This changeset also implements the ability to configure the chips via SW
registers.

Datasheets:
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1300.pdf
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1200.pdf

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Alexandru Ardelean (16):
  net: phy: adin: add support for Analog Devices PHYs
  net: phy: adin: hook genphy_{suspend,resume} into the driver
  net: phy: adin: add support for interrupts
  net: phy: adin: add {write,read}_mmd hooks
  net: phy: adin: configure RGMII/RMII/MII modes on config
  net: phy: adin: support PHY mode converters
  net: phy: adin: make RGMII internal delays configurable
  net: phy: adin: make RMII fifo depth configurable
  net: phy: adin: add support MDI/MDIX/Auto-MDI selection
  net: phy: adin: add EEE translation layer for Clause 22
  net: phy: adin: PHY reset mechanisms
  net: phy: adin: read EEE setting from device-tree
  net: phy: adin: implement Energy Detect Powerdown mode
  net: phy: adin: make sure down-speed auto-neg is enabled
  net: phy: adin: add ethtool get_stats support
  dt-bindings: net: add bindings for ADIN PHY driver

 .../devicetree/bindings/net/adi,adin.yaml     |  93 +++
 MAINTAINERS                                   |   9 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin.c                        | 752 ++++++++++++++++++
 include/dt-bindings/net/adin.h                |  26 +
 6 files changed, 890 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 drivers/net/phy/adin.c
 create mode 100644 include/dt-bindings/net/adin.h

-- 
2.20.1

