Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6134AD9C4
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfIINNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:13:31 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:27792 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727766AbfIINNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 09:13:31 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x89D81wj024420;
        Mon, 9 Sep 2019 09:13:20 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv967g00n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 09:13:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkwoUWslSrbLEb1qmbWOIzaRMMwVnkuEFoTWMAEl2pw8ZTlzrsSkdL6lbbZ8S5WrrOHCfLnvkTqZZRMVkOJ+RGlKTZbfhz6vwzc77xZZNb86Y1nvm96DhoMVlr4T2cSxjitfjTOm302FWZolTpu2nlJoumthkd/cfr/5GQQKLXY+7BdiMgOBuSLVQowtuOWKM/tsHDLpeVn+Y9P7kTucUsO25agCZ1tXmTssG0ibeYUQDShl7OcJyPKDKOEKI3Aj8MVY/d0NLS99ceamMc/yZT1ADMPIYfvAwV3y8STjaWKpVOnfvz3B1zWCk87ACA5rQBB8j6Bbxp9mYM9PXTJkFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D3kbPvSQsvs2dJZUpTMdjaXKC5FaiwpvcNjeIGpEAw=;
 b=LKiYiFS4NG6vLl0u8SsxOZHo9SPMq/chCE6/ZefkpIetxL0nfJfLjd7mkDZp7/fI+SR8iFyZvgJ4iXBX0XuE06GujVpG0kj2tf14Mpkl4SHi3N28ClyOADtfbJFfHSKtoMZ7IHIE1uvzjAi7Arp4bYQv9L7+9z3kRzq3P000XXZvb1ELeqK8UVuhndJCAVVRthwpEOfQVBDZoo2QWzEA/7pQYPAlrlDJUltLbWdUs6K38oKKHMOVWxSY7GNHIgmvE+5EZ70eOKKWhSPTwQVtNJCpckoCOYup8uUKhQPs4dJ5bP+p+JUnwhBsYs6xdqTVKpecjyf/+m+qOqlID6BU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D3kbPvSQsvs2dJZUpTMdjaXKC5FaiwpvcNjeIGpEAw=;
 b=CWOdKQrbE96+i1WJ3JNrgYJUt5PWdOblc9epfrMxbqkinM+cP73xbt+cRbZq25COrgFH1q7OdTLk8XiAsWnpVOO7QB5cAh1QP/r2HW1iJ1wxz4NQHSd2XpQO4wpQ/TZ38ebTLpRygrXrw5fLWRwQdY/n8SxJLECFxtnNMQXEeBA=
Received: from MWHPR03CA0005.namprd03.prod.outlook.com (2603:10b6:300:117::15)
 by BN6PR03MB2786.namprd03.prod.outlook.com (2603:10b6:404:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.20; Mon, 9 Sep
 2019 13:13:19 +0000
Received: from CY1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by MWHPR03CA0005.outlook.office365.com
 (2603:10b6:300:117::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15 via Frontend
 Transport; Mon, 9 Sep 2019 13:13:17 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT053.mail.protection.outlook.com (10.152.74.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Mon, 9 Sep 2019 13:13:15 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x89DD95F028620
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 9 Sep 2019 06:13:09 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 9 Sep 2019 09:13:13 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 0/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Mon, 9 Sep 2019 16:12:49 +0300
Message-ID: <20190909131251.3634-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(199004)(189003)(54534003)(106002)(14444005)(5660300002)(2201001)(44832011)(316002)(48376002)(476003)(50466002)(2616005)(1076003)(54906003)(7696005)(51416003)(110136005)(70586007)(70206006)(478600001)(486006)(426003)(8936002)(2906002)(336012)(50226002)(186003)(6666004)(356004)(86362001)(26005)(36756003)(8676002)(47776003)(107886003)(305945005)(2870700001)(126002)(246002)(4326008)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2786;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 740d138e-0335-4c8b-5b8c-08d735277a1f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN6PR03MB2786;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2786:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2786EEA0B9A060D9B0F1E269F9B70@BN6PR03MB2786.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01559F388D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: D0QvAruNqIIrSyJKCjdx5kvx6d1CCEiHG5NmX8VkQCdBVEPXfwWYjL1BTldZq41uwHRhnHSz+ysABG+3lboK5BuLqIf+6MCLEPNltyoCD/NEM3rs+H+1N09hFtOkwIHnRNjauNRTb5SGwxVLbJqwYI/HxKv0chJyUqXZhImejJKsPrA1f4wctbp66xa+fZNwVAzxqIrDRqpXnEIa4svFYZWzmQOBEKV0ceNUDbdCfV2PI2iDhl00xjDXWpLu8tjREPQBFbLpuvbaLUKJmKtGHvQ64dTii/bCkhPDcn+oqpfVErzzlEX/KkNYR3Krsf5xxUqBg+LUaF1SfFYFX8pTM2jPipTPnL2rOxlR6p89etfV71RmUWO7H7gxugNd/fnMZcn6LpvNEEpr/swcSc8Ui4ZZdSsF9dIA2OZMWVJZfIs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2019 13:13:15.9462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 740d138e-0335-4c8b-5b8c-08d735277a1f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2786
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-09_05:2019-09-09,2019-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=643 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909090136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changeset proposes a new control for PHY tunable to control Energy
Detect Power Down.

The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
this feature is common across other PHYs (like EEE), and defining
`ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.
    
The way EDPD works, is that the RX block is put to a lower power mode,
except for link-pulse detection circuits. The TX block is also put to low
power mode, but the PHY wakes-up periodically to send link pulses, to avoid
lock-ups in case the other side is also in EDPD mode.
    
Currently, there are 2 PHY drivers that look like they could use this new
PHY tunable feature: the `adin` && `micrel` PHYs.

This series updates only the `adin` PHY driver to support this new feature,
as this chip has been tested. A change for `micrel` can be proposed after a
discussion of the PHY-tunable API is resolved.

Alexandru Ardelean (2):
  ethtool: implement Energy Detect Powerdown support via phy-tunable
  net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable

 drivers/net/phy/adin.c       | 61 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h | 19 +++++++++++
 net/core/ethtool.c           |  6 ++++
 3 files changed, 86 insertions(+)

--

Changelog v2 -> v3:
* implement Andrew's review comments:
  1. for patch `ethtool: implement Energy Detect Powerdown support via
     phy-tunable`
     - ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL == 0xffff
     - ETHTOOL_PHY_EDPD_NO_TX            == 0xfffe
     - added comment in include/uapi/linux/ethtool.h
  2. for patch `net: phy: adin: implement Energy Detect Powerdown mode via
     phy-tunable`
     - added comments about interval & units for the ADIN PHY
     - in `adin_set_edpd()`: add a switch statement of all the valid values
     - in `adin_get_edpd()`: return `ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL`
       since the PHY only supports a single TX-interval value (1 second)

Changelog v1 -> v2:
* initial series was made up of 2 sub-series: 1 for kernel & 1 for ethtool
  in userspace; v2 contains only the kernel series
 
2.20.1

