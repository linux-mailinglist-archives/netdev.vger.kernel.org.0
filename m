Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D651383B1C
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbhEQRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:02 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1237 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEQRVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgELBEgmpKD2m5N+7e/1DDJO78oFrwmgDbwxsyvWLiGNX9utlXaL5gsuAE/3dTWIdTtfaqnctYBPDqsOJLM7zg8qsH/P029siAYjpnKmJVddJUElZphOeAxasYDKFVqMiYRgDBS8g+5O89QINB6VjQPACEDNgLUKq5U89q9EEi777K5pFmNsXPQUspeaGx63eHwcJpv2CoiZPSrf721Cj/R0uAtTNgBg/gwKRfqtSimr7320UJlzW3b4ErnY4eOv8QbiKbBsjy57O6TItjSowVNFjmutdmDgVstig2KpKuN1OgS04hhfgNoCjznkcWUdBrT4OiSUHRHigo1eyCY3sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DV5Z23eiSUiZ7DrvpHwEa9UTUWhqDnMqkNqBnwvTOc0=;
 b=DXVo+BM3CI4WFPa7JTHoB5qnhOWId6l2fFBYVGG5jc+qPFDvZ/z7L3/S6tMwTu9vHfbob//WT+Z0ZqWMJAT3Ci2/YYOR7TtXsDsmZWP3E6DGufcJvYhYB6H3HmC1vsrICks4Q/NjMrAM4nho5LRXJwsVJVGjA0xMmr7zAnDSqOnOSwDSIZNqaTZgocxq+FAnD//ub/2m8VP6QiKF6TXlTe2iEl5Q160fG8BXIbFVAqynzt/UMM74wzPtz1G7gPXJUEX/vjmkoJ01Kxt5rKjASj7AZimAQVzsd8Mko+3byWrsFkGpcUpuv78IKlIg5/W6TxVQXA3E8DclUGzG7vfC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DV5Z23eiSUiZ7DrvpHwEa9UTUWhqDnMqkNqBnwvTOc0=;
 b=VfC+kG0EuprpnLVL1685Nn1wCggmYjcFrkjnpK65SRBvTvb9ojFh2tKYmu084sO8qCuT7dTXFblnb0gHS7hHg6GpwMP4y/VJNifCCpJyHi0ghZXvAGNCOO9QY+iDQvec5iF15AjKNpvhHe6hh0VWdki9wAh8zqwYFkb3rBUnEhNCUX6LqK5mkCPiKAYaPfo9Ec3LP9OgqMNHdjz7+nkqLKc4dd3sJq9Luf0CEUW1mSzaPfietYAd+HeRGf71GarPTO3hWCob6B/M2YUl30Lg3XL3en9v6cU6mtoIiWvbZLv0Bvy6Eo2qRh1Ljs+3dUFJQfYZvXr9tanfoQsfIJHj3w==
Received: from DM5PR18CA0053.namprd18.prod.outlook.com (2603:10b6:3:22::15) by
 SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 17:04:43 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::c7) by DM5PR18CA0053.outlook.office365.com
 (2603:10b6:3:22::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 17:04:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:43 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:37 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 02/11] selftests: mlxsw: Make sampling test more robust
Date:   Mon, 17 May 2021 20:03:52 +0300
Message-ID: <20210517170401.188563-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af6f6ce3-364d-44cf-a2fc-08d91955ddba
X-MS-TrafficTypeDiagnostic: SA0PR12MB4399:
X-Microsoft-Antispam-PRVS: <SA0PR12MB439926660BEE9BD5C7A9E005B22D9@SA0PR12MB4399.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8o/CYqaZ2MBUirxQN4oTCCIKV9GzbTBUcZ4cU+LOaenvtc4sWaLZand0BzkyrVfAfkXSJIDJiFaqCT1aWnY08dpGOCPsGr4lQ7HmDC1mjbj1rZRD1t6UIVLJfFYNYQ7Clv+JMUu9I94SW8MaffM2T3ZFGiUnqbc+0QRc+Rm9k9Tsn/5Ku8d9dLMeocTTv25+ALMggGIktc7wEhI6G0cQlMKM2TTKoIyESSl50JHK07L/L2xatLeHoWvb8dyrHmRnfBcDNTqLsH8NY9QgSnR2qTN2eE8YKzu29S8Kcu7SFm9g2RILX/CZj990qjx7d2utKDq+4VWMCRMuJgUcQtYbOyNaBihVkmgGZnse2zOZqXBCDgMbLt8g730c+k4TE3YhkTPZunEu8rLzofUmoSyuZ16uOPWaesFiE/wf/oqmyi2Vmj3I4SCLwP5xOuaC1WLd5WdfFvLRRoi32hiyZyvdMB0q6r6lhgozzFG2WFYNCFuq0nvJx01XwFX6e2NJPSC8Z995xlpwyB+2ZT8yhzu1LlMhVvgyZRYYGeQnKnn4BGuGVKO4ZwCDw3BZ7Ze1/gh+TiRqWhFfA0xblM/bmr04bxy9R1lEANjNdnkSxtWuMrq8pYhTqoKeREypkf1jR2B9uZcaMNQMo4G2jMiyA5yPA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(36840700001)(46966006)(426003)(54906003)(316002)(186003)(47076005)(16526019)(36906005)(336012)(5660300002)(6916009)(8676002)(2906002)(86362001)(8936002)(4326008)(2616005)(82310400003)(82740400003)(36860700001)(7636003)(356005)(36756003)(1076003)(83380400001)(107886003)(478600001)(26005)(70586007)(70206006)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:43.0787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af6f6ce3-364d-44cf-a2fc-08d91955ddba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test sometimes fails with an error message such as:

TEST: tc sample (w/ flower) rate (egress)                           [FAIL]
	Expected 100 packets, got 70 packets, which is -30% off. Required accuracy is +-25%

Make the test more robust by generating more packets, therefore
increasing the number of expected samples. Decrease the transmission
delay in order not to needlessly prolong the test.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/drivers/net/mlxsw/tc_sample.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
index 093bed088ad0..373d5f2a846e 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
@@ -234,15 +234,15 @@ __tc_sample_rate_test()
 
 	psample_capture_start
 
-	ip vrf exec v$h1 $MZ $h1 -c 3200 -d 1msec -p 64 -A 192.0.2.1 \
+	ip vrf exec v$h1 $MZ $h1 -c 320000 -d 100usec -p 64 -A 192.0.2.1 \
 		-B $dip -t udp dp=52768,sp=42768 -q
 
 	psample_capture_stop
 
 	pkts=$(grep -e "group 1 " $CAPTURE_FILE | wc -l)
-	pct=$((100 * (pkts - 100) / 100))
+	pct=$((100 * (pkts - 10000) / 10000))
 	(( -25 <= pct && pct <= 25))
-	check_err $? "Expected 100 packets, got $pkts packets, which is $pct% off. Required accuracy is +-25%"
+	check_err $? "Expected 10000 packets, got $pkts packets, which is $pct% off. Required accuracy is +-25%"
 
 	log_test "tc sample rate ($desc)"
 
@@ -587,15 +587,15 @@ __tc_sample_acl_rate_test()
 
 	psample_capture_start
 
-	ip vrf exec v$h1 $MZ $h1 -c 3200 -d 1msec -p 64 -A 192.0.2.1 \
+	ip vrf exec v$h1 $MZ $h1 -c 320000 -d 100usec -p 64 -A 192.0.2.1 \
 		-B 198.51.100.1 -t udp dp=52768,sp=42768 -q
 
 	psample_capture_stop
 
 	pkts=$(grep -e "group 1 " $CAPTURE_FILE | wc -l)
-	pct=$((100 * (pkts - 100) / 100))
+	pct=$((100 * (pkts - 10000) / 10000))
 	(( -25 <= pct && pct <= 25))
-	check_err $? "Expected 100 packets, got $pkts packets, which is $pct% off. Required accuracy is +-25%"
+	check_err $? "Expected 10000 packets, got $pkts packets, which is $pct% off. Required accuracy is +-25%"
 
 	# Setup a filter that should not match any packet and make sure packets
 	# are not sampled.
-- 
2.31.1

