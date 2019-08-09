Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D7087B6E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfHINgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:10 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:54088 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbfHINgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:10 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNAeY026401;
        Fri, 9 Aug 2019 09:35:59 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2051.outbound.protection.outlook.com [104.47.32.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqjwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmlFhsyxvB+gxvKQTF4DnpEJHjdrA0IhwUVvDg4PHiVoQEDRFaObfTJBsGG1WK8124HISnw6NATwoyIgOTyo7dltCuKUlmbSYaIFqgaGD2LkOonCSLVqLB7ipPb5/82D4uHSme2ZhDqAjiXsTkYInBsul3e4N1poPc4Ta8J+84/nVzZ7JzhnEVCygp/e1zJaeaaSRDM1vXlqJNBzo9M9hcjwTH0lML7wGRQqaKKBRZn6yg9KNBJW+ljU9s8jRSGf6jG55ooqUrq5NGrJsp/vvSk2E3T0WDj/Z8aKNaV7TzpGp7nVJEi389KAixMpbA/MHl1cdAB/UKqwOwIKASmm8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qceRXJbF+TsdbZS4C7aStkglOkfUT1s7qbUCu/+W2Jo=;
 b=QXaJnwvHhLBwOHG5b9xFfCUp9xoDWno/Zl/Vng9sNCa4bEMIbDieJ/prU+nWs+ipFPjnkdMnyU2lCQRd+fnxqSi/y+QnXsKzP0tJ99W7gGI/49IysruLGrq4JOwYa7CLtsaC5A7JByQlEyFbbrFOq5Yurm9YKvQsLCKtnHFQLdriENvyx+0mek3flq19Bf1zBpH1jVNlp7S5tb9ijpcUXusj+kT5fH9UaAsfnEPnz5MBk3w/mmcXKx70sstuvS81eFxtfkAmhhMouSiR5wuzdc6rgXtl75Zj6PbJAZBvR8dHky2WzESZ6QEFe1utiZnbcI78YeHhGleFyHN/l9eiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qceRXJbF+TsdbZS4C7aStkglOkfUT1s7qbUCu/+W2Jo=;
 b=urzX6C6Im6H4f/jG7AbuVdzFycCSVsmZgqbX2Cuu4CK1RZCIXlNrv8RkI1uWO9HjlN6Ec3ExsUh9ZFtzsUAmz+3KMeo1eI6M6frqvxftEoE9tOhjK18PFirLuOeuH3YCN8Tk6QEea3twbAk+MHpaMiIzEmIpq0pyb4ourW2lcb4=
Received: from BN3PR03CA0090.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::50) by DM6PR03MB3770.namprd03.prod.outlook.com
 (2603:10b6:5:50::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Fri, 9 Aug
 2019 13:35:58 +0000
Received: from CY1NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN3PR03CA0090.outlook.office365.com
 (2a01:111:e400:7a4d::50) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 13:35:58 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT009.mail.protection.outlook.com (10.152.75.12) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:35:57 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DZuda025624
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:35:56 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:35:56 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 00/14] net: phy: adin: add support for Analog Devices PHYs
Date:   Fri, 9 Aug 2019 16:35:38 +0300
Message-ID: <20190809133552.21597-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(54534003)(189003)(199004)(47776003)(36756003)(8676002)(316002)(110136005)(44832011)(26005)(7696005)(51416003)(186003)(14444005)(6306002)(2870700001)(126002)(6666004)(486006)(2906002)(54906003)(476003)(2616005)(356004)(336012)(107886003)(426003)(2201001)(48376002)(50226002)(8936002)(5660300002)(305945005)(50466002)(4326008)(86362001)(106002)(966005)(1076003)(246002)(70586007)(70206006)(7636002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3770;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d35e68e3-548b-4185-5f44-08d71cce82bb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB3770;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3770:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <DM6PR03MB3770EC123FC116D94AC8067CF9D60@DM6PR03MB3770.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZSBBmFxWBZWWcNf8ehsiTHNycKJeox4ZVbeWF/sv10H7udaMOvV1Osj2TU2N/oPnzgF0VxE9M2rnQVR94VtOh8/keJnFPg7naBe0qu8Jq+tv/7GOZErsnp/rfN7DOjpfw/aJ7LUDsmutIN6xU4bgPi7BAG0K0kllNo+NXkHFv/h9PKQONL2xPmRsVfT7a2lP+s0E7uhdtGHXwfLXXTYp7a7YxabVPVbK8AoBCKJSFXRiXfzeV+Fy9eTiwMFcXrz24QxA9I8++Eo4YnZuSbT3jWveiUxsmD0tpX05/U1FkURljxzljQrfusu8Se5TW+r3s6d5Ov9OGlDAm0zAMvtEI2ElqCJsxJ/X5pQ/T8YqiMp/waP0VCUuUeR/ZkfoKaUZ7ypeR7sim14cbJc2mW7RzXQcdAfLf2/STnSH2Z3K5+c=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:35:57.2928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d35e68e3-548b-4185-5f44-08d71cce82bb
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3770
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=981 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
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
 drivers/net/phy/adin.c                        | 777 ++++++++++++++++++
 5 files changed, 868 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 drivers/net/phy/adin.c

--

Changelog v2 -> v3:
[ patches numbered from v2 ]

* general: added Andrew Lunn's `Reviewed-by` tag to patches [where the case]
* dropped [PATCH v2 02/15] net: phy: adin: hook genphy_read_abilities() to get_features
* [PATCH v2 05/15] net: phy: adin: add {write,read}_mmd hooks
  - reworded patch to mention C22 MMD access is defined by 802.3 standard
* [PATCH v2 13/15] net: phy: adin: configure downshift on config_init
  - reworked patch based on Aquantia PHY driver; using phy-tunable ETHTOOL_PHY_DOWNSHIFT
* [PATCH v2 15/15] dt-bindings: net: add bindings for ADIN PHY driver
  - removed $ref where not needed [based on feedback]

2.20.1

