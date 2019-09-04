Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3BDA846B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbfIDNX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:23:56 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:4658 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727900AbfIDNX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:23:56 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84DNHlI018404;
        Wed, 4 Sep 2019 09:23:47 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2058.outbound.protection.outlook.com [104.47.32.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqjna7w99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 09:23:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUQtmZNENC48mp0+6aEdA/KnLHr0xBFGXWAS1+LsQx5FLbnTRe29gcRpgxMaMkaLZun/Ad6id8mr5zyia5QqyD+Bh32kD7OlzymV70PXBnSQONoCalRQnMAg7VF+cBsYISZT0v930GxXgqUe4xhdzQh39osy+rH8eCkSpcNF/pB1ssqXyq9Oi7EdKcBbjW8kGIj+DG0ach3e1p4yr50tjdhoGdozkbyhecIApsE5VvutJ3pdF4ul7B5KvihqRlHANHc1qQiyvscu7e+6dUxAy9TJhI5/uUlBQmjfLFZjRewYSSk+LG++DGWDv+5ycXTjQnCObBq0mdp4ullnhLBNFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ec/uExRD7S/CRGCRzUGYG245wPOFoD3FYFLFf4+oQ1k=;
 b=Mg79Roo1NxpTyMhvkYmIFjDgH2q/WP+sMnjRtqUf0P7lfHooZ7Z3k6yN3rkdRVYDJ2uVmem413VtAtEtrNpKa0CMrVoTEGfH6Ya6rooP6/bF3KKA/R/IdpPp6I+MemE43r0/TFUOt8MxrkUS8A/fqGDoW53mr9YVI544UVUnA4kHUJH5SZQiGjYdBe1wpdMedgut/rMqrmF/9xbEZKpD08bO7wntfmpY/GGcmTEL/XqfiPEeZDYpFBdgIgOMqOsYsXcmtgaoI1JeuwId+kXg5hFo0EiADSt6+npQk91537T9ELwbVByztBZoamueX5KBYxia8ocAEZx5vYu9UCqoUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ec/uExRD7S/CRGCRzUGYG245wPOFoD3FYFLFf4+oQ1k=;
 b=sc2g+WXdP6RE6RZJL3oiYdOgUqkV0QdcSMBfWXuel9Y1whAVEELg9AZagZ0PBKJxTyb2g1FApvfy0xFwi0elnB9ODJzifJC0d7kcVkuuhxoLKDjWk+c+FPW7T4JlNYsiHjKps0go849jUjO8LJUS2KroWvND4TfOwWoFsI3MdB8=
Received: from BN3PR03CA0111.namprd03.prod.outlook.com (2603:10b6:400:4::29)
 by DM6PR03MB4236.namprd03.prod.outlook.com (2603:10b6:5:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 13:23:43 +0000
Received: from CY1NAM02FT040.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by BN3PR03CA0111.outlook.office365.com
 (2603:10b6:400:4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Wed, 4 Sep 2019 13:23:43 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT040.mail.protection.outlook.com (10.152.75.135) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Wed, 4 Sep 2019 13:23:41 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x84DNed2019812
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 4 Sep 2019 06:23:40 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Wed, 4 Sep 2019 09:23:39 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 0/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Wed, 4 Sep 2019 19:23:20 +0300
Message-ID: <20190904162322.17542-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(376002)(39860400002)(2980300002)(54534003)(189003)(199004)(50226002)(8676002)(106002)(478600001)(107886003)(8936002)(110136005)(246002)(4326008)(47776003)(70586007)(70206006)(54906003)(2870700001)(44832011)(486006)(426003)(26005)(336012)(186003)(356004)(6666004)(2906002)(316002)(36756003)(86362001)(48376002)(51416003)(14444005)(50466002)(1076003)(2616005)(7696005)(476003)(126002)(5660300002)(305945005)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4236;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7acf0da2-1832-42b8-7dac-08d7313b1aaf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB4236;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4236:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4236DDB4B6AC8887A9488006F9B80@DM6PR03MB4236.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0150F3F97D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ndOu/8xworqyjDMUxIvA8lzbvW7nzkVNyMQQMFs+oOahhSx0l+g+Am7FzNRzodGBNO0SuYqaHnv3rxdaE3fJjSTzwaMs7F9S4cGJhftbnxSB8DPnO/WHGyjnJ1z2jIws6BDgZeevL4rbZgRiNOnEVuHGE440t2lwK8STCDRVPpRSiga0tNNfFJQyJHacx06zqDDAJgdVBwA1uCCJu4cnc73z7+VVXWZs38M6HvOw5fNNmmqv6IVYT1KnjU8r5x9+cy81nf8YKH1rwx2N8/pFjzIfCq25yLs5628dc7m7Vtv696ifcd45Gj1dOukvvhNRBeWX6Ip0iGpLPTMCniszASnAqKoCufKwPDe0U0XHLCcwEHZ/9BlrikLVCdTB1j4YRMaz99No8L7n2Q9MBmME0xBYhRA10q+jRntLv0KVeIM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2019 13:23:41.1770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acf0da2-1832-42b8-7dac-08d7313b1aaf
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4236
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_04:2019-09-03,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=654 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909040135
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

 drivers/net/phy/adin.c       | 50 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ethtool.h |  5 ++++
 net/core/ethtool.c           |  6 +++++
 3 files changed, 61 insertions(+)

Changelog v1 -> v2:
* initial series was made up of 2 sub-series: 1 for kernel & 1 for ethtool
  in userspace; v2 contains only the kernel series

-- 
2.20.1

