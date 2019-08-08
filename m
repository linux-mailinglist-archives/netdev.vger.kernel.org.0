Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A671861E5
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390036AbfHHMc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:32:28 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:15274 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbfHHMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:49 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CSGhQ002639;
        Thu, 8 Aug 2019 08:30:35 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2052.outbound.protection.outlook.com [104.47.40.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJEkQ/CSF9AAtrSxkHe+pI9VOC5nA+BjBHeP5OoJH0voASjkIti9xYgj9b95SP2Hljn5xsSZZ1Wc1DmMRmKpMWv8eNLUqTfhH3W3A/ePbD66bHAf4ShOctZDU1yvli9BLfrFwQsDjbknW2hlD65lOz1c+8ht7Bm3Pbv/Huq6/BhSbWJcNj7gnVGfuJbCMVI+iMRyq9arJm0KHeEnlQZaWSsk0x/SwfMWkMjarkBMALITuybCkV0qJjcS8OnJbeo4aJ4xhNU8i9Opj+ZqKHK8L7QR85u6ExPVrJvngq1A67gEpGK7DzSKgCCO2ptoX/FbB+TDKVav0V97Cn+SqmaM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3TAIIs+UWT2o5W3vXKNm8urMpQCTUalQTyCWSjLX9Y=;
 b=Wv/NlVKAtjm5lkqvoQ/3y9w6qj5YnPK4dldX2590EwkIzXqqGRskjHz6YWPgcbkbAt8oLUrJC+VNGq3iYzZRrwwVD+2ZGCNAqhjMls3eR8X5Y4UWoeYsPxp3+pthCJaQnZeOG386pGbyOvEmP3C1xv3nyqgXXpJC9CUse75P93R9tbFFMzSTkSO6th19+KdJRHV5pDNAbz7YqpaCPqIZSoRHgE9wz7Y2a3eXqK+wxi4ChPl8diffR+5k75HEkn56HGYPFxLMHRk0uSEzni3O/IdaoTJIyOXV1ErhHpK/vNm+LCMgD29cGdxUvmCQ/T3TXCsu49HrLjYP7++sbH83ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3TAIIs+UWT2o5W3vXKNm8urMpQCTUalQTyCWSjLX9Y=;
 b=iZMsVgikjkHWj6AdhRu/LfJTA6Rnu+qZwhB/8sXLSEFXsGQUe5E91ekGEdKINkEnH9FnVr8i3yUuz8ciQ1WtQJPvSZZa42PegfFlU01G8ZoJwEykdqU9uMJqGrmAxgsXl9BnAdBeHSZamLH87jw6a0/MQz6y9R+5rHC6XFD0wUU=
Received: from BN6PR03CA0097.namprd03.prod.outlook.com (2603:10b6:404:10::11)
 by CY4PR03MB2455.namprd03.prod.outlook.com (2603:10b6:903:38::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.20; Thu, 8 Aug
 2019 12:30:33 +0000
Received: from CY1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by BN6PR03CA0097.outlook.office365.com
 (2603:10b6:404:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT020.mail.protection.outlook.com (10.152.75.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:32 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUU3n021062
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:30 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:30 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 00/15] net: phy: adin: add support for Analog Devices PHYs
Date:   Thu, 8 Aug 2019 15:30:11 +0300
Message-ID: <20190808123026.17382-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(199004)(189003)(54534003)(50466002)(6306002)(246002)(8676002)(8936002)(107886003)(305945005)(50226002)(7636002)(2616005)(426003)(486006)(7696005)(54906003)(316002)(44832011)(186003)(51416003)(106002)(476003)(126002)(356004)(6666004)(110136005)(26005)(48376002)(336012)(14444005)(2201001)(4326008)(5660300002)(966005)(86362001)(2906002)(1076003)(478600001)(47776003)(2870700001)(36756003)(70206006)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2455;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da3e60e1-b1ec-46e6-84ac-08d71bfc34fb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY4PR03MB2455;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2455:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <CY4PR03MB2455C348D4866DF642CC583BF9D70@CY4PR03MB2455.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 7/m+2snhbKIYVKHkqJwGKMtKyi0XsaJoPgWF1OD2M92KiK4gSA/N2/ddHKwNdwdJ2b459+r2sv21Qcp/JBu1ebsLjKmEMEl1L+Pyvyo+X/BSV8pPSPFQc839gvdlqJ1xu42r1eFonmBkg4Usuv6X6eRyvAn7a6NcPZVMU8PZCvoSKDLtkQpWAXwXozloHpO7So723ASMvvldSneOzkdBZlSGSt0Uzu9ZBZyPqIOdXPRtlEXqDT2ImPVPvPAcrrlkGwuaE0dtqrcMP4bm1JM57JoKkBWBps4FvCYG6I+mDjDoq1YjDM5bpLtGUc5KdyrgA9ZTre8458U7Zg6BtkL/s3uNxYLO1nro3TK9jGdJG/J7MAP4GePrb40EJXxM2378iBZc3dSr5JXh8Ub3+d1FMxBilMDG8qDmo5gzgruwmj8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:32.5347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da3e60e1-b1ec-46e6-84ac-08d71bfc34fb
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2455
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=974 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
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

Alexandru Ardelean (15):
  net: phy: adin: add support for Analog Devices PHYs
  net: phy: adin: hook genphy_read_abilities() to get_features
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
  net: phy: adin: configure downshift on config_init
  net: phy: adin: add ethtool get_stats support
  dt-bindings: net: add bindings for ADIN PHY driver

 .../devicetree/bindings/net/adi,adin.yaml     |  76 ++
 MAINTAINERS                                   |   8 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/adin.c                        | 732 ++++++++++++++++++
 5 files changed, 826 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml
 create mode 100644 drivers/net/phy/adin.c

-- 


Changelog v1 -> v2:
[ patch numbers are from v1 ]

* patch 01/16: net: phy: adin: add support for Analog Devices PHYs
   - return genphy_config_init() directly
   - remove `features` field; the ADIN1200/ADIN1300 support the standard IEEE regs
     for reading link caps
   - use PHY_ID_MATCH_MODEL() macro in `adin_tbl` and `adin_driver` tables
* added new patch: net: phy: adin: hook genphy_read_abilities() to get_features
   - this hooks the genphy_read_abilities() to `get_features` hook to make sure
     that features are initialized correctly
* patch 03/16: net: phy: adin: add support for interrupts
   - removed deprecated `.flags = PHY_HAS_INTERRUPT,`
   - compress return code in `adin_phy_ack_intr()`
* patch 04/16: net: phy: adin: add {write,read}_mmd hooks
   - changed reg-style to 4 digit format; it was the only place where this was
     inconsistent
* patch 05/16: net: phy: adin: configure RGMII/RMII/MII modes on config
   - removed `goto` statements; used `phy_clear_bits_mmd()` for clean
     disable-n-exit path
   - dev_info -> phydev_dbg
   - fixed `phy_interface_t` type conversion for rc; reverted back to `int` in 
     `genphy_config_init()`
   - added missing space in commit description
     `For RGMII with internal delays (modes RGMII_ID, RGMII_TXID, RGMII_RXID)`
   - overall: things have been simplified since this no longer needs to account
     for `phy-mode-internal` thingi/patch
* dropped: patch 06/16: net: phy: adin: support PHY mode converters
* patch 07/16: net: phy: adin: make RGMII internal delays configurable
   - changed mechanism, to specify delays in pico-seconds and convert them
     to register values; mechanism will be used for RMII fifo depth as well
   - fixed masking bug for internal delays when reworking this mechanism
   - changed DT props `adi,{rx,tx}-internal-delay` -> `adi,{rx,tx}-internal-delay-ps`
* patch 08/16: net: phy: adin: make RMII fifo depth configurable
   - using same mechanism to access access RMII fifo depth bits
   - changed DT prop `adi,fifo-depth` -> `adi,fifo-depth-bits`
* patch 10/16: net: phy: adin: add EEE translation layer for Clause 22
   - use `phydev_err` instead of `pr_err()` in `adin_cl22_to_adin_reg()` helper
   - renamed types from cl22 -> cl45 or clause22 -> clause45; the translation
     is from Clause 45 to Clause 22 indirect access
* patch 11/16: net: phy: adin: PHY reset mechanisms
   - dropped GPIO logic; using phylib's
   - doing SW subsystem reset if there is no reset GPIO defined via phylib
* dropped: patch 12/16: net: phy: adin: read EEE setting from device-tree
* patch 14/16: net: phy: adin: make sure down-speed auto-neg is enabled
   - use `phy_set_bits` to enable/disable down-speed
   - implemented downshift similar to marvell driver; also configuring
     num-speed retries
* patch 15/16:  net: phy: adin: add ethtool get_stats support
   - changed `do_not_inc` -> `do_not_accumulate`
   - in commit comment: `incremented` -> `accumulated`
   - use `strlcpy()` instead of `memcpy()` for get_stats
* patch 16/16: dt-bindings: net: add bindings for ADIN PHY driver
   - updated bindings with all stuff that was left in the driver; some things
     went away (like reset-gpio)
   - implemented Rob's suggestions

2.20.1

