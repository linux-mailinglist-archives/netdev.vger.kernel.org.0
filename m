Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B15A6957
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfICNGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:06:48 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:53378 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729088AbfICNGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:46 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83D30mb029509;
        Tue, 3 Sep 2019 09:06:40 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2059.outbound.protection.outlook.com [104.47.33.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqjna5ers-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 09:06:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPH+JfdRkGC9BK5nPbZYsm5hLGbZgfCVi+thPpoj75+hYPp3abFstlsANdVHxuMnz0g49xpxE6T8G3Xes6Kq65jga28tJcJlxqaUK2zzS5dJRWEG79pCvo0XHDlzbBlAs0WLT6/+dTN5OZqloGxIPDe6MbPhCiHX/7DuIhvgxuNLP1XawqyCwRRqZewHM8WzQSgwUVZte5/XC+cv4xovPh+Tr2N2gJyk6PYvOp94J0TQ6727ecBnqGD1l1jPlfBFKr4K9GB9nL2FsHBYwk+5W2A+A8U4VDEio9gGQGBBRMxZU4WfCNZoRwwBpRYMhITuJGTdunninu6IiB0lmZwtBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfdSTQ1LDLOV+tjmGURSF+Spl73A/+SDbal0olORwew=;
 b=CUOCOamwN2sSN+4MRpfbYCsh0PR2rQTakP0kP79LKGNl+ToepOf62P8JZjySPyaSnjLiDTXSVl6anNXssOa8axBtj3qlNu0i+ZU2v6og2Jay/m+AtLRDm4DQOeLcRnhTfx55XKuu2QVPSNwD6aKrQRpWt998Sbf02/VripzLlS0zTiBFl9fJjwl8CxXbDQr+nc8in5hxwLJxf/aOzr316+6UcWWNqHieJ8kJkfbvpxeioynXM49V99vETFv2nXp1bhTCgvk56hwUscb+HS5tvJFGPu4IrEhDnn+L2YWg7VrPQr+6IPB66QDkWZBiY2CtRc5+5rEsa/88IekOwUa4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfdSTQ1LDLOV+tjmGURSF+Spl73A/+SDbal0olORwew=;
 b=I3PGvwo50uver486G5KUFWG363TdweccR1ZIT2MGofzSTrVW6VsEGA978nEAvJnE20/aRNJHvfOS9/k9I/0H4HGq2rEwc5KS5mtv5HMfHm8BfC+uTYDZRt0vhnyCnTJo7xjufSbgoJDmf5Go74EsHv5bEKO75HeVliwlAMRFoo8=
Received: from BN6PR03CA0092.namprd03.prod.outlook.com (2603:10b6:405:6f::30)
 by DM6PR03MB4842.namprd03.prod.outlook.com (2603:10b6:5:188::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.22; Tue, 3 Sep
 2019 13:06:37 +0000
Received: from BL2NAM02FT023.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by BN6PR03CA0092.outlook.office365.com
 (2603:10b6:405:6f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.13 via Frontend
 Transport; Tue, 3 Sep 2019 13:06:37 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT023.mail.protection.outlook.com (10.152.77.72) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Tue, 3 Sep 2019 13:06:36 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x83D6V9v024799
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Sep 2019 06:06:31 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 3 Sep 2019 09:06:34 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 0/4] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Tue, 3 Sep 2019 19:06:22 +0300
Message-ID: <20190903160626.7518-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(2980300002)(189003)(199004)(186003)(50466002)(36756003)(6666004)(356004)(478600001)(26005)(305945005)(14444005)(476003)(336012)(7636002)(4326008)(107886003)(426003)(126002)(51416003)(70206006)(44832011)(316002)(486006)(2616005)(1076003)(2870700001)(47776003)(54906003)(110136005)(106002)(5660300002)(2906002)(70586007)(8676002)(86362001)(8936002)(50226002)(246002)(7696005)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4842;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 617909e1-87df-4abe-761c-08d7306f8d6e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB4842;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4842:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4842B26D50EADB4DDEC51923F9B90@DM6PR03MB4842.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01494FA7F7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: tLkwCm+B3AGd4bH1FtAy2gCve5Y0jBkjVelYtFJC8lNwHmZ7Qw3YZscs06j13kTxv7U399MmPumGRnVyrNLYJ7PDGkwphudQcTMhWIikuVZHEgcsRavVu4trRqd0wio8mG9PZhOwQbdcd83JwcAknlIxushBx6HfvMckNGy80ymfJwE+q9brrcjkCYCIoy52dJqnb0/mKnNpQ9j0eh7UAEiYQwSh9ynBtGtqmV4hnnrMSwNVYFM8MzDN269Tm33cN/LZ6oPTBtIyAuhiNz1lNbQ+ilQzAyoSKKgwpnDvDqz5O9E/jTLDDe8QGjWmprSjzaXe/8RDJ/wFzd1M/8+zylJMw0GxpZRNbAixPHdK6Gt0IJVdOmG4ACXlF//M2dX2WqlQ+44YkcuWgE+YLFGRaWreFunOAmN+yrgzXYpNlYI=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2019 13:06:36.7553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 617909e1-87df-4abe-761c-08d7306f8d6e
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4842
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 clxscore=1015 mlxlogscore=585 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909030137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is actually 2 series in 1.

First 2 patches implement the kernel support for controlling Energy Detect
Powerdown support via phy-tunable, and the next 2 patches implement the
ethtool user-space control.
Hopefully, this combination of 2 series is an acceptable approach; if not,
I am fine to re-update it based on feedback.

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

-- 
2.20.1

