Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704E8B35B9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfIPHf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:35:59 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13566 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729229AbfIPHf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:35:58 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G7XxW2022674;
        Mon, 16 Sep 2019 03:35:39 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2059.outbound.protection.outlook.com [104.47.33.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v0vu6b7a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 03:35:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4lblVOj/puljZdjtwNmWaplWNCmVLvluQc4MjDrftCLfDxbqYrQ4nrfmPyXfy6SdXrC5nd5bgj+sYDsRbZhE1R/6/He9643oYUT3CxzZwiQvnEL9Mh4Czaz/clWrM5QN4xwLS1Hzu3epWVejOitXWl10JMIZf6+fvOl4O0wWC7pvn2CGP4i1WSrVAJFuwoaTqR3cAlFfsMBEdh9MEt+MlNRZFIS4VYFHE8JzbQLB+AKIQyQVvCvmm1aZXOFPNzSOBCnpR9qd+Lfr17+MTSyOQyIlhF1r3onwe/1irb40uBEw3MbjRC7se9jxARs+oRKFphtmpm2byFYLlFvveGpxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TatWPe1/XVHpXpiT64ypI5t1s6a1HGeg2/DcNuzV4NY=;
 b=GwE33nWGyyUdE1CyHnTqG2QdNbLdWpUj8CFM6NONTEFU0227O3cv/HoPGJuasqZ3k1pHTxsapLppbvMsE9IbHY6rOTJuXQl/QmaCsImUUZRGHoa8bHs9Htr8IvYnzSvKEtyqEPgM/lW4bFLGOJYGbVoOoAJ0/EMTjhZWW5OnKuGxf3jCnh39ASsXbDC1393+DNejVG5yhU96/3JyhacKaWxSB+yocjSWshOiJ1xdQTLBCMyb6Zsz54rbqkVxHaAZoO0iNXXCwnFfKSackyLR+laZIWOCryztgbXiJyQE4B5T949OJD5aNJnrVxEosAQJYtO1+hj/bRQgyW+evytCTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TatWPe1/XVHpXpiT64ypI5t1s6a1HGeg2/DcNuzV4NY=;
 b=Zmr5oxs1y3QYoZjE2mF0MXpJw0oHzOwQ0Q9uiV1cFbG4OQF0AryTff1+THDhKy5MJDEZqILZTjQzxvrMAeUtUsN0lLlgMUoCjbpovqoyfRHwaPxW2OMHh2ud1i9MJ+XLpL0UIppYBelOwFXyYjsrHbYpVe+rRKwz1Qt2Jf7IsBA=
Received: from CY4PR03CA0100.namprd03.prod.outlook.com (2603:10b6:910:4d::41)
 by DM6PR03MB5274.namprd03.prod.outlook.com (2603:10b6:5:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.26; Mon, 16 Sep
 2019 07:35:37 +0000
Received: from CY1NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by CY4PR03CA0100.outlook.office365.com
 (2603:10b6:910:4d::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19 via Frontend
 Transport; Mon, 16 Sep 2019 07:35:37 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT038.mail.protection.outlook.com (10.152.74.217) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Mon, 16 Sep 2019 07:35:36 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8G7ZUwa021651
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Sep 2019 00:35:30 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 16 Sep 2019 03:35:34 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 0/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Mon, 16 Sep 2019 10:35:24 +0300
Message-ID: <20190916073526.24711-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(39860400002)(376002)(54534003)(189003)(199004)(246002)(4326008)(305945005)(110136005)(54906003)(107886003)(106002)(478600001)(8676002)(48376002)(2870700001)(7416002)(2906002)(36756003)(70206006)(26005)(336012)(70586007)(8936002)(7696005)(51416003)(2616005)(126002)(476003)(1076003)(486006)(426003)(50466002)(186003)(44832011)(356004)(86362001)(6666004)(316002)(7636002)(50226002)(47776003)(5660300002)(2201001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5274;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 416ad344-1677-4a55-e938-08d73a78775a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB5274;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5274:
X-Microsoft-Antispam-PRVS: <DM6PR03MB5274967C535BEFA5B3B42ADAF98C0@DM6PR03MB5274.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0162ACCC24
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CnZIBwpx16p3ZkzojDdNRoiWT1phMqN5nxz+ZwiymzcqFb+eRhGyzcRZvsccPkXxvYifxgwkUVjUxiedYxKw7cE+M6z0Uo2beQPDHRfDdsLxm932y3tZ814TD843KPBCq/K7zz9GPEB5wg8BdgmLRCG9EybiFX1NgN64T+R67XGNHnoqUYfJG51kxwwVaEudd34nUpt0xw9mR9p2iUsYOxTmsWanN6iixtpOBULCAN3WNt0uAvqBFgXQIBQBY24yj9ug0tWTqJGifEeafNlBcJCNHCDRe9aigqxUyjRZg1Rrp1E5SuQvYmHVh09FCIE+Kx5evHt5xH2mtcyYSRnhNY7Jczx13EfZcxnAqPeAlP6fu3rPsbJt7QrukApC8mQ34OxAEYLZ+qxKczz5EoUu6/kZIXPYeU/gG6w5qzdilYk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2019 07:35:36.7866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 416ad344-1677-4a55-e938-08d73a78775a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5274
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_04:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=757 malwarescore=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160082
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

Changelog v4 -> v5:
* add Andrew's & Florian's Reviewed-by tags for patch 1
* fixed patch 2 goof:
  `rc = adin_set_edpd(phydev, 1);`
    ->
  `rc = adin_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);` 
  this was omitted when re-spin to v4 was done
* for patch 2 added Florian's Reviewed-by tag as this was suggested by him
  and his accord was
  `with that fixed: Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>`

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

