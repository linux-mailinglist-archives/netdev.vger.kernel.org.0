Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4507A89CBC
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfHLLYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:13 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:26260 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728002AbfHLLYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:12 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNN1V003863;
        Mon, 12 Aug 2019 07:24:00 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2058.outbound.protection.outlook.com [104.47.42.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9tj5w5yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7j6mIQy/pirK6YxvJeIrIWGjYqxWyrDHlrRiEXDBiKf8bTeXymYQem/w0hPBLracM2U/8saM4AzkrS4m72Xt5ekA9Se9t5qA4qFkDYpdz30C/+1oQyuRH1pPCvxw5Y9EIISBU6NVMvuO9kB68f7KyAW6ARFi0MJ8diYFb1VtBLnUnTBQoBULXbYs+N06x2rJmSu3VuPiR6yGQwi15O9qz3NWvOCD9/85iH0LD38XOEntxy6OCMQoA/aJ2kiLQA9ZmdbNIOoO0pBVu6UxGL4W2Y6eHVM1GQYvrgXwe/vtNrZdz2JpLByVvT5y55qdzZw6SKbxkEKGSqE8CMb1mYWvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVq3khXPCmQbD5YaUjvVmg0dyGSbBBI56yR29sxBudU=;
 b=U2KpxbrBXhw1S1w/pAIn5MjoLW4Rlenw3DO6OdtgKEyI6f4DeMirIEte1YtlH1xRUtf4hov/jnixzrevwas+oBSZhgZGTHHfkXn/vcHNbs5a5gb77VEi1rM9vlfnJdm/P9AJDvqmQeytRCfeWY50dvKiUSTr1qIc0UPjM+ViV2sMiLjMsnQzfW8JIGhvNjEAqjnE22IQYRnEZ7dHL92gXVHOtKHQibuSOEd6JBpLNnapVuXaQWKLtkAy2OhOTUPXHy8DSKVbT6aU/IKLFBIbBfeHUPFbQnZ8SVQqn7K/H/4asztY49UtEZirJ/fhSNtpVZNYHGgZ9LZPTtaMxZz5xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVq3khXPCmQbD5YaUjvVmg0dyGSbBBI56yR29sxBudU=;
 b=mEE6Oxk/Csj2eAf2rAka8P/HQpkY7nhDvRjm/MCaB5bYjD9Fj9PjVyNYXHvJqKTprlD4eHyoxORe54LnzOEsGBQXKiQdBucDSm5ckCHExzsEzEpsO5M8CH7eONdVWgIC2CF6gkAGKfDBmB/eaqjCcakQ+mq5SKxSLC51w53n6xY=
Received: from DM6PR03CA0016.namprd03.prod.outlook.com (2603:10b6:5:40::29) by
 DM5PR03MB3161.namprd03.prod.outlook.com (2603:10b6:4:3c::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Mon, 12 Aug 2019 11:23:57 +0000
Received: from BL2NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by DM6PR03CA0016.outlook.office365.com
 (2603:10b6:5:40::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13 via Frontend
 Transport; Mon, 12 Aug 2019 11:23:57 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT024.mail.protection.outlook.com (10.152.77.62) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:23:56 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBNtXK004141
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:23:55 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:23:54 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 00/14] net: phy: adin: add support for Analog Devices PHYs
Date:   Mon, 12 Aug 2019 14:23:36 +0300
Message-ID: <20190812112350.15242-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(2980300002)(199004)(189003)(54534003)(8676002)(106002)(246002)(1076003)(48376002)(54906003)(2906002)(110136005)(8936002)(478600001)(966005)(86362001)(44832011)(6306002)(50466002)(2201001)(47776003)(6666004)(356004)(50226002)(126002)(7636002)(26005)(305945005)(51416003)(7696005)(186003)(426003)(107886003)(476003)(336012)(486006)(2616005)(316002)(14444005)(70586007)(70206006)(5660300002)(36756003)(2870700001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3161;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262d0c84-3178-4de6-67e2-08d71f1790c4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM5PR03MB3161;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3161:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <DM5PR03MB3161A2CBA4B0EA42DB4511B2F9D30@DM5PR03MB3161.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: dH3UAJUj25k23XlL4X0cHwUM/bo9jRpyOIXw7Z3zKgQIxNPbSWuQIHyUi5b24l/DVYq+YsckdaniLBFVH9jgmSZJ3s9Avx5JfvslMRKDbRLbin6OAL+O4ghoDLT3HJLmm2gWVMBJc6MY0dx4zK0Ux2GjCkZ/lQztpq0rnbsypCtl7IBK7T5FEqSPf1qzQcfYILC2zDfFeBT23g9GLd5AMozJIct9x+HhTLEcM3FIk1TSYALXgyOSrNUdlvi6ra0FK0zCv6yqPcXKb9kq56RnDYpF0zRKgtIOFIDbSjiMWl7gTWZIIez4rwiQ6LZQPU54zkRryk8zVxhwj0xMRhWSMK6kYgCy5QqO5YeH79f4JQk7eOtUEQk3E2bR2xJpuNwQ02rMlYfyZrWvYRGZenyATAhqwFlynMY+d5hLl0SUOeM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:23:56.8693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 262d0c84-3178-4de6-67e2-08d71f1790c4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3161
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=759 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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

Alexandru Ardelean (14):
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
  net: phy: adin: implement Energy Detect Powerdown mode
  net: phy: adin: implement downshift configuration via phy-tunable
  net: phy: adin: add ethtool get_stats support
  dt-bindings: net: add bindings for ADIN PHY driver

 .../devicetree/bindings/net/adi,adin.yaml     |  73 ++
 MAINTAINERS                                   |   8 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin.c                        | 763 ++++++++++++++++++
 5 files changed, 854 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 drivers/net/phy/adin.c

--

Changelog v3 -> v4:

* [PATCH v3 03/14] net: phy: adin: add support for interrupts
   - using only Link status interrupt
* [PATCH v3 04/14] net: phy: adin: add {write,read}_mmd hooks
   - dropped C45 access code; it is dead-code, since `is_c45` will never be true

2.20.1

