Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A97B0FEA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbfILN2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:28:37 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:6436 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732072AbfILN2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:28:37 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CDRJol016736;
        Thu, 12 Sep 2019 09:28:24 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2052.outbound.protection.outlook.com [104.47.33.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uv6d9gc2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 09:28:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoDjlAFnpM4BSIcHTPRlt1ll7Q1VkvWFcPlLtwve0VkqDB1BnD3ME7HrvYvFiG0zfAAervzIpxKcmSyGW1iuZ8Kunsb56+yjZcxD+0r8TPPCE4o4qKFnjnHrXXw3BaHELEPTz2S+3VapiWyBXuiZZZOHWswS71SlwGWIPPZmjz/eqL/CSoJfURzhDsBL78shy1JFdwfiWf21Ra1yuHlZJ/R1znO/M1KpNCN4Nc+IiAqAQhIiKb0VvgYg3xGlsDqTcVH7yUy34XIR84tFXRxB8b8+Pby7xcJ85Ke7gnlV3MJm31jwcXaaEkMNLO2Wff+Lp/mIL16WV8nYaUgRcJigFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGkaQX0y/LsTYsyqVhVnejP9/6JiSa8yCi1B6VreAbE=;
 b=TLcxUcMDCFHujrpRCJN8lHr99V7x6kaA3IgLpeAm5BRFntxIBFdaMMWQsxEew5oxOou9rmrBl1ev31I7k6D/BZcsQ4VeFflHu/JFUDDqYPdtaBWvJtJrHYrn+uRbxDTqGa63dQUnXwzyi2cbADVHfWaW/p0otOUcAuWqjlvUi6oVBL5c7JoSrAPnUNKyoc3jY+zc5y/pjKjTJwOSvqi4f4foeh5N5xLfZ+zqkvtXpTzitYbQtzldirzkN4Nxsg2cc/+Q3Oj05AHc/7yeUCsjR9d7ZxPG4Gg+XbJnhs8HcPTfv4GMYvX3sanrnnPaLQZq8sKCAAmqcCm3Oz0BSlFdtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGkaQX0y/LsTYsyqVhVnejP9/6JiSa8yCi1B6VreAbE=;
 b=2ptd4aT2L/Hv0KLolWEItle7IQXeQBevXFi0cAWHaahlI614rJjmlzqSU0OmIAlg52JcB/Vaw4shoAAI3zOte8GNq5gK9CSX6XaGh1/EfLL54bxCc3TkKwltadQogGgtwNb+vZkio4Ytu0N7p6zVfdB0/F1kD8esfnztb40JeRI=
Received: from DM5PR03CA0047.namprd03.prod.outlook.com (2603:10b6:4:3b::36) by
 MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Thu, 12 Sep 2019 13:28:21 +0000
Received: from CY1NAM02FT004.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by DM5PR03CA0047.outlook.office365.com
 (2603:10b6:4:3b::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.14 via Frontend
 Transport; Thu, 12 Sep 2019 13:28:21 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT004.mail.protection.outlook.com (10.152.74.112) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Thu, 12 Sep 2019 13:28:20 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8CDSExc027881
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 12 Sep 2019 06:28:14 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 12 Sep 2019 09:28:18 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 0/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Thu, 12 Sep 2019 19:28:10 +0300
Message-ID: <20190912162812.402-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(39860400002)(54534003)(189003)(199004)(70206006)(186003)(107886003)(7696005)(478600001)(51416003)(47776003)(26005)(110136005)(106002)(7636002)(48376002)(54906003)(7416002)(305945005)(2870700001)(70586007)(316002)(2906002)(5660300002)(50466002)(14444005)(86362001)(2201001)(36756003)(1076003)(426003)(4326008)(476003)(126002)(486006)(356004)(44832011)(2616005)(8936002)(6666004)(336012)(8676002)(246002)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB4752;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac0d167a-96ab-41d0-6d01-08d737851482
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:MN2PR03MB4752;
X-MS-TrafficTypeDiagnostic: MN2PR03MB4752:
X-Microsoft-Antispam-PRVS: <MN2PR03MB47525A2E48C4A2DDC4BE59D5F9B00@MN2PR03MB4752.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01583E185C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: muitpMcmpK+aTAwmGiWJwy4afv5YvX2OrZUOEmrvrkKYb9Jn8tkqlFe6Re2ToVKypkagYDcha1lBlIqpBGuiYTS7o6Xa9MZJUmBUBZhtqq0oepKkH5zFDS19GPN3mIv1/bOKF7li4jfudAzlD35aIQEfcncc6YFPEAgSec9V+cIWgy6WZ3qw3VQje/j43w8qyWT0wBv7bQrOq4kxGgGLR/XQHsj5hJ50uw4xD+J3VxKqrJw/qXJPxP8cNU98zmXH73N0QhfEXDu8FcobJvCaE0ZQLrU0MyHdtcs4ssShie2YfAMFd/5hgNkqSJar+Fd1dl4wJ3AGXg4oghIs2VUYjuykiFa+WUcHm/xWiICz+1n6LiNKC52OywEccvc2brjEHmf0O4FYpB9o2JLdh11jbcCE9GpFHheqR9RCEeRTZ9M=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2019 13:28:20.9213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0d167a-96ab-41d0-6d01-08d737851482
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4752
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_06:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=843 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909120142
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
 include/uapi/linux/ethtool.h | 22 +++++++++++++
 net/core/ethtool.c           |  6 ++++
 3 files changed, 89 insertions(+)

-- 

Changelog v3 -> v4:
* impose the TX interval unit for EDPD to be milliseconds; the point was
  raised by Michal; this should allow for intervals:
   - as small as 1 millisecond, which does not sound like a power-saver
   - as large as 65 seconds, which sounds like a lot to wait for a link to
     come up

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

