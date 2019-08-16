Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD19902AD
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfHPNKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:41 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:5332 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727241AbfHPNKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:38 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7mgk030041;
        Fri, 16 Aug 2019 09:10:29 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2057.outbound.protection.outlook.com [104.47.41.57])
        by mx0a-00128a01.pphosted.com with ESMTP id 2udk94973r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJydkFR23ZW5H0m3edMwb1HL1YIob4sqBiESQBQocanuwqCKE3UIMlVtc9cIxljl2vHGqH3krS4q67TO5wpgXptPjlPqidtvaPtm5LCoPFkwUQvbHMYBjCHh0XdN9JKF2p+RsdAuUegkhRyXT/11yhQT7CVGHzdVWGm3St6uu14VL18EPxHsCZFAcxeESEQKD5+ONXvYp4KBlxEQJE66MVOGA7u5BIT4rzAWHmnzQFbWPsz+mgbiq+YJOLe4zFOUL7DA74LayrpXJwnbcXm2yWy2OerngVGomocJkIObUa0JtH7XZOfq71uO6psQ4pNmrPOQ558w0EvdsX8lf3+IJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+aJIdBwSL8a0yyHCl6K6LBmYKhqaugruGJfDp/zXhs=;
 b=MZN26dWCna4+gluSEvm13Gr5F742E/xXhL3RPL5aoM8R69wtN2GeYdZSQtrg+NwpND26YffLuUV+chmCCX+CQuv8xB5W74PCmys0U9/rX3YZ3DOMWBIDgBDJjOUq1Wk2BwSbbsPq6tsHFRtqjcfGPz3Y4VoDCQuwZ8setzSPhbyQVRPTAxx1GeMRkeyGchW+nwGPPIGy9nss9UWfYgNNNCWR9zK6PyqnCONPg5ZEJ+R9LJesW2r0XPVPuoYkyQYLu9exa+UwHkNlxE/t3nX1YQ3aUhPWOg78oyrMyn6auPEyZJ+HCE41+dIOn8WDBXEgdp2yQWDBo1ErDtc+yjXesw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+aJIdBwSL8a0yyHCl6K6LBmYKhqaugruGJfDp/zXhs=;
 b=ipyhbz9/cD7d+0DYvCpmNUNMV27VfSiQ/X5LtvGH0prIv7kRSohTDyH9qUJlJb5d4Mw9YPtlS+/XCUE08IgcJqJuVNS8ePz/VDq6LlZaW28siNEMDGn97ot9x8ZeUyT7Cu5HNovYUTA7+nkIXOkGaTFPUPFXVONbvdpIkOaKWCg=
Received: from CY4PR03CA0099.namprd03.prod.outlook.com (2603:10b6:910:4d::40)
 by DM6PR03MB5324.namprd03.prod.outlook.com (2603:10b6:5:24c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:27 +0000
Received: from SN1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by CY4PR03CA0099.outlook.office365.com
 (2603:10b6:910:4d::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:27 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT033.mail.protection.outlook.com (10.152.72.133) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:26 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDALBU007828
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:21 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:21 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 00/13] net: phy: adin: add support for Analog Devices PHYs
Date:   Fri, 16 Aug 2019 16:09:58 +0300
Message-ID: <20190816131011.23264-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(54534003)(189003)(199004)(1076003)(14444005)(6666004)(356004)(2906002)(107886003)(561944003)(2201001)(4326008)(86362001)(2870700001)(50466002)(36756003)(48376002)(110136005)(70586007)(7696005)(8936002)(106002)(47776003)(50226002)(8676002)(246002)(51416003)(70206006)(44832011)(305945005)(7636002)(5660300002)(486006)(126002)(966005)(476003)(2616005)(478600001)(186003)(26005)(316002)(426003)(54906003)(6306002)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5324;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ef1005-7d38-4db1-6b86-08d7224b1b2d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB5324;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5324:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <DM6PR03MB5324161F685BF98F2DE9FE25F9AF0@DM6PR03MB5324.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: I1XKOC3VVMefMzy09ZZ9eGzHdW+ALxwZhrFwnDhovo8g7FxmrpMc1091h8vTlnRAhE+mFlIyrbjqdg/NudVkqDfuxgV/TXYCvl610A7oYwws63IT2ma5j55YMT8KtUK75ynm7LkzCJOOweyH0esm+yheGicacoMYj9fP/mmQSU6IWeBbJSl3p4q2/az/fhtxj8B8fnfPwYomACVvQLQDM1nkHNhjNJuJNM4VVCGzI3oxEznjuD5h7LEOgEba83+W1hgWZvKwsl3V0KoSpu+GHoGpb6N1JceGkA2zRM8FPBFBOr6jh3QeWlTLA9bk1RoBSOgqKJnvUUx6LSI37pnreNc+zRMBraZZEDgyioon0K3xFe+N8aUYs/uFZsLqVbI9qkVR/Aw/5nJivC43i+Iif4H88NRrEgzxohim7bUZvxM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:26.5544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ef1005-7d38-4db1-6b86-08d7224b1b2d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5324
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=998 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changeset adds support for Analog Devices Industrial Ethernet PHYs.
Particularly the PHYs this driver adds support for:
 * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
 * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
   Ethernet PHY

The 2 chips are register compatible with one another. The main
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

Alexandru Ardelean (13):
  net: phy: adin: add support for Analog Devices PHYs
  net: phy: adin: hook genphy_{suspend,resume} into the driver
  net: phy: adin: add support for interrupts
  net: phy: adin: add {write,read}_mmd hooks
  net: phy: adin: configure RGMII/RMII/MII modes on config
  net: phy: adin: make RGMII internal delays configurable
  net: phy: adin: make RMII fifo depth configurable
  net: phy: adin: add support MDI/MDIX/Auto-MDI selection
  net: phy: adin: add EEE translation layer from Clause 45 to Clause 22
  net: phy: adin: implement PHY subsystem software reset
  net: phy: adin: implement downshift configuration via phy-tunable
  net: phy: adin: add ethtool get_stats support
  dt-bindings: net: add bindings for ADIN PHY driver

 .../devicetree/bindings/net/adi,adin.yaml     |  73 ++
 MAINTAINERS                                   |   8 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin.c                        | 724 ++++++++++++++++++
 5 files changed, 815 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 drivers/net/phy/adin.c

--

Changelog v4 -> v5:

* added Andrew's and Florian's `Reviewed-by` tags where the case

* [PATCH 4 10/14] net: phy: adin: implement PHY subsystem software reset
  - simplified mechanism; doing a static `msleep(10)` after issuing a subsystem soft
    reset; the previous mechanism (with a busy-wait) was working because of fluke;
    the reset bit in GeSftRst is self-clearing; once read, it always reads back 0,
    so there is no way to determine if the PHY has actually reset, except
    to wait a fixed/pessimistic time; after that, if any PHY read/write op
    does not work, it can be assumed that the MDIO bus went into a bad state,
    so the PHY is unusable

* dropped [PATCH 4 11/14] net: phy: adin: implement Energy Detect Powerdown mode
  - will re-spin with a phy-tuna proposal at later point in time;

* [PATCH 4 12/14] net: phy: adin: implement downshift configuration via phy-tunable
  - found some bugs while re-testing
    i) bug1: changed:
+       if (cnt > 8)
+               return -E2BIG;
    to
+       if (cnt > 7)
+               return -E2BIG;
    my 3 bit-logic was not that great for max value
    ii) bug2: changed:
+       *data = enable & cnt ? cnt : DOWNSHIFT_DEV_DISABLE;
        to
+       *data = (enable && cnt) ? cnt : DOWNSHIFT_DEV_DISABLE;
    needed logical OR vs bit-wise


2.20.1

