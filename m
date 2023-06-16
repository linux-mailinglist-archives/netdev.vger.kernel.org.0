Return-Path: <netdev+bounces-11638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA4D733C92
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C057E2818B6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36986FAA;
	Fri, 16 Jun 2023 22:49:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD2398
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 22:49:16 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::60b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674D23584;
	Fri, 16 Jun 2023 15:49:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6dB3oUR0/ejHy50BI4j5Go1bJmYYBDjZdzZ/V/ID71+f6HaowL15kcz1s+4EoHb9bSuFFbbE3MkJBhfDHdfLfbwrjNafqUmBjGBpt/t+Cr+jfkyOFZ3YnH0lUGcuM8gBNuORlLYrsLck1wSJ5TQsLFCT/3Ig0DUYcYpVVNiMfRCbUrxHsnDAqrQqmFVq9napyIDxLcI9qwNcz4Rey6/IaXB1GyMCJd8DPRHc4Aj1Lmi3PhqtPt9E5bE05/j/AR5zdygdLDMyA21TIqK4AwTt2VAMInH1pfr6uLCcFNhVP7lpO+vpu8VMDZ0XD6RzLveO/i8uQTMvS4c2Stgwi/aqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIHeWOxcHoxoiDa1gvGjWVIDiniluGqIYWMEQ5HSR5g=;
 b=B9ym/2jxvVZ3eozWqL+hsMCru+IHnzlDK25Mo8LwHpAuGqhUuKGSC8Nlpijh9b5Ba0ov1fErFkTwL66dChfvzm86EbubJb/ZWZFOA9KPpiQUKfADCpR7U93GEKAP9mW8PxSfJpHEI/Rs8o9PG3bQGRWwtz66BY3i6rFNaFYUOa9Qc7TZShiryZ0l73pIS7pgaF1OOVASs7HdNeH0ye1Lb84NiXdgpp/std+JtyIKUQ5x3fNBefxd3UXsHkFtDcPLtkMtB6f4xU2GnX4lBMy7J03uEs3qw2Stu1awD08lwK+CHvUfD7o5m17npoSUv6KrBMBNfL9WOgxPWE84D1HXlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIHeWOxcHoxoiDa1gvGjWVIDiniluGqIYWMEQ5HSR5g=;
 b=lIuy8tk6bsq8xrxiL6K2PpkhDCmAp28StdmXvO0vDni+RX0CDttClZvuNeW0af9fUgQU9rL4TrRbi8Z9xyF+ZD4+eEu9zf1B+4/IGwS8q8kFtcghiAVUc2JaYD9Jr+XwwnZoyi8Nysmf3+NVCpF6UPlIk9qyuyL4jrXJ2MxYKn0=
Received: from BN9PR03CA0421.namprd03.prod.outlook.com (2603:10b6:408:113::6)
 by MW4PR12MB7144.namprd12.prod.outlook.com (2603:10b6:303:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Fri, 16 Jun
 2023 22:49:10 +0000
Received: from BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::9d) by BN9PR03CA0421.outlook.office365.com
 (2603:10b6:408:113::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27 via Frontend
 Transport; Fri, 16 Jun 2023 22:49:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT104.mail.protection.outlook.com (10.13.177.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.30 via Frontend Transport; Fri, 16 Jun 2023 22:49:10 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 17:49:10 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 15:49:10 -0700
Received: from xcbamaftei43x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Fri, 16 Jun 2023 17:49:09 -0500
From: Alex Maftei <alex.maftei@amd.com>
To: <richardcochran@gmail.com>, <shuah@kernel.org>
CC: Alex Maftei <alex.maftei@amd.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net 0/2] selftests/ptp: Add support for new timestamp IOCTLs
Date: Fri, 16 Jun 2023 23:48:43 +0100
Message-ID: <cover.1686955631.git.alex.maftei@amd.com>
X-Mailer: git-send-email 2.28.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT104:EE_|MW4PR12MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: e6bfb8a2-4665-4b69-dbff-08db6ebbe663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XxA016/bf4+FnN5wHX/2U4WPWOf8Da/shG7ovUwIG5Cga4QCIiVos66h6NmLo57CvADK0RV3PYJ8ua0/QP/RQgmWVZaXt/vJjH8nX8JFZSw0Yh52mzFEMyqQ5I3vbqaCbYWnwgleQJYAgRAg5LKA4q9xGAuVJ0MSx2d1hUbfhqnEVZhatQb3fpycU7VP3OM0Eaedbbo8qIA1Sm8cK6nXUddeIQnbcUhhJbiHqPKe/+Jo9/U9hsKg1TMEBcKCH9ecmk9bBV2WzfHEXOvIFJbL4Rjml1+bJpntytL6PSQTqkcbdGN/7LpiyuQYzaP8QI2NrPHhvKqvhs2TxGE18pwyljLl0zW5MDg+6XxdpGxEoyWCqn2ns6E94Q7ilEryrWnkfgziKwVpcJs34MzqbClAqmMaxQLwUWON4IkCgDep8BFN3ECzf6M1Dy0dvGRpFNgkO5mm7Dzltijr2UYZI4KSt4NtbOFQeayyTHQuGLufgi5GiJPwgvSVHv3FjYt8ZH74nG0r73LXBH13H/1z5sXarmUW9gdYaW5VyoTwXbkAVCLp/1VzZK6cPCR0FsdGo5XdY56RB/vWTP4iSu6WlLJh8J9B4iTewlWF+z5UhAdM94csaTftEs3MDPwNo3wSCDRFcWx5sZ9Clj6C3gVgLrxoK0Oo7up4i9Ak/SWW+TLeD+XdDuXEM2IX32QFGeVVhSwIrXHNQ6XODtIOSHMlc6VG+gcJvkbJSh6AEaArvhg0h4F72uCqDudTOaea0RN6L2+5NUXgySUc1uRzuK7Q/dkm0Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(81166007)(82740400003)(356005)(40460700003)(40480700001)(6666004)(478600001)(110136005)(54906003)(5660300002)(316002)(44832011)(41300700001)(8676002)(8936002)(70586007)(2906002)(70206006)(83380400001)(4326008)(4744005)(47076005)(426003)(82310400005)(26005)(36860700001)(336012)(186003)(2616005)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 22:49:10.5832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bfb8a2-4665-4b69-dbff-08db6ebbe663
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7144
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PTP_SYS_OFFSET_EXTENDED was added in November 2018 in
361800876f80 (" ptp: add PTP_SYS_OFFSET_EXTENDED ioctl")
and PTP_SYS_OFFSET_PRECISE was added in February 2016 in
719f1aa4a671 ("ptp: Add PTP_SYS_OFFSET_PRECISE for driver crosstimestamping")

The PTP selftest code is lacking support for these two IOCTLS.
This short series of patches adds support for them.

Alex Maftei (2):
  selftests/ptp: Add -x option for testing PTP_SYS_OFFSET_EXTENDED
  selftests/ptp: Add -X option for testing PTP_SYS_OFFSET_PRECISE

 tools/testing/selftests/ptp/testptp.c | 71 ++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 2 deletions(-)

-- 
2.28.0


