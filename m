Return-Path: <netdev+bounces-9987-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C8472B966
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 424D5281108
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2375E576;
	Mon, 12 Jun 2023 07:58:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB3DF6F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:58:43 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B3E171F;
	Mon, 12 Jun 2023 00:58:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANZIZuNg/sqJjxy4/wiY0PxuYOz2USpWckGwRqPECOdyvW1IECDr9WKOpx5wohT5pqqGAiqqq1cAi29ecCFsiIgig9JEQX8H0EarXyfODAO+uDKLYpLHIm2D895Z6exhSzwNw5rBU0IkKpU6FkujXpEAZt2j6Tm/UGQNqUXLSfC1VwcSudt/nB3ETEd8kesBqSIugXzxG4wSFuAJ27fFYdTSoKyi0nEeoIicSIrQyHkMt1U3rSv+VXNwRvvE3zfkEh0gWAiHO+abiDtiAnJSP0y+xvS45pJSIkzPzA6lWaZxG+Ximu9mOSXJdrbMjaI6MTAmgXak6gV8pIFRpKTNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nabgudca77iuNWJJYGGzOlbxMQdCLWawTxuTfhnEO5s=;
 b=dhl6NpxpgE9e2sj8hV9JH8S/XwBj++Za/C5KwqQSFp6Uu68Tl20mjbmW/GYG0Nya11ubRbLKWsEshq7u5EcOVT63L6FtfAIBFXUuShBZTqklkMkLPbCBiG/fMJeULgBlDTLVDntLTeRpuTa9TsF+IPpS/HpR9szS2k6SeVFdre1vsZKWJvsFVm4JWmTnLK+qJ/mKMF8RbWk9V+hvlt/tj3Hfbyfjb3tmnO68I3S3hJhhoP5DylIXPj09gTntgM29d0nau/EoVOCWM0VDaMQlIBowIZUwMzh7x2Qy/2SXu5SbDWkvvDKIX98VYl5DadCnVsWZxaxYfCPH/81Z4g1mXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nabgudca77iuNWJJYGGzOlbxMQdCLWawTxuTfhnEO5s=;
 b=b4JaldvKPKqNnwQz/CXXqHIGCGE/P4Jl71mAoeqcowgLWiRcOGcPSKfQzpkZphaq4gcv8I5aFJ2PUIuquyrRgmCr9ZN04bWgcqkwJheej/ckhaoPPar+rTSFL2gVghlatSWMOp1pHiorP7cDnWp9nOFNCgY581LLtqJys3aUUPEUewJa9xI4WwUgptYWoc+kJmWytP78YWlO/G+B8Y67fXZ0u/LZ7ejrJCOxBzyuxso2uWYVxwV1w66NUJAt5bMVMJEN5YmqDjCnY2zih25zqtMbL2bzpfMVbo933Psipcyd26ZszhnKLEplzNSB6GIE1/DyrtWWbR2ccpWS/MyqoA==
Received: from MW4PR03CA0343.namprd03.prod.outlook.com (2603:10b6:303:dc::18)
 by CH2PR12MB4907.namprd12.prod.outlook.com (2603:10b6:610:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 07:57:45 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:303:dc:cafe::63) by MW4PR03CA0343.outlook.office365.com
 (2603:10b6:303:dc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 07:57:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 07:57:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 00:57:30 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 00:57:29 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 12 Jun
 2023 00:57:26 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<marcelo.leitner@gmail.com>, <shaozhengchao@huawei.com>,
	<victor@mojatatu.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 0/4] Fix small bugs and annoyances in tc-testing
Date: Mon, 12 Jun 2023 09:57:08 +0200
Message-ID: <20230612075712.2861848-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|CH2PR12MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: 2baabe31-3209-435f-29cb-08db6b1ab49d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hDkl+vTnJ/TCw+g932dBlz3EkYDLOsC1VLs+0i5UwKT0bxaKuRKHNUT+ydrKXmXWU0iXRLtSY0emt6jUrzbP7V8EysWOc8Jv78yhuVnrp3ip+3M57fr/K73rnEm6QgyM/IFZljBQIXpoZ4DLEM1L/s4mpOQv1zGGylxKbw2c+Z8sm/Uz51MXSK2DBdxKjqtMuVOU0Bl0pWt0A5Jt3e6oNytT05yAjMrQ8dcG+FRXeTfp1K4n2X2jyR6FLkup+j/b0dPDQoYXqvvgbaulu4uP1k4UE0WDYGdM5fUlGo3GGPHzXTeDXgV7yxrKbRHz2NIl/RP41lBXmzL0PgQYBk+C1/EdlxeIgqgWXhbW+xr0u090vPysEV4LJURVCDIomSi9CO2ay9YdEi7UP+56J66yk4wfWfYLTSuq/7dZvUD9PTc5EpDBgPC+8kGGRr4IPqOfoOBh1/hO1+i4jZU+8BUec8wGe/30MMF/MaARPuZv5uDiElrM/zYuHe9QhakaAnREnJstgsWS6TUuziJCUGwSP7e1iGQNBQWZlvtkrStv/zXMODb67iqgiXADDMRkWWM06gEQG67Gy+vbEcqqoy4wKVlT5V8hGIUaS4LZsSlzZcBbmUhlYtypz3q2scLlVYxkLFRuhJBRKNz+H13wWdq9rh/esMN/KGPeYNbnuQarjIFgNjcXlFHrsclXEJfQd7trduUqx7i3L1Qt+2R7bzJIpW8taq50nOh7I7UDGR1nT8fHChStbYrGsbhCFC/4QFxF
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(110136005)(70206006)(70586007)(478600001)(54906003)(7696005)(316002)(41300700001)(4326008)(8936002)(8676002)(5660300002)(6666004)(107886003)(7416002)(26005)(1076003)(186003)(83380400001)(36860700001)(426003)(47076005)(336012)(2616005)(82740400003)(7636003)(356005)(86362001)(82310400005)(36756003)(40460700003)(4744005)(2906002)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:57:44.5015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baabe31-3209-435f-29cb-08db6b1ab49d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4907
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Vlad Buslov (4):
  selftests/tc-testing: Fix Error: Specified qdisc kind is unknown.
  selftests/tc-testing: Fix Error: failed to find target LOG
  selftests/tc-testing: Fix SFB db test
  selftests/tc-testing: Remove configs that no longer exist

 tools/testing/selftests/tc-testing/config                   | 6 +-----
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json | 4 ++--
 tools/testing/selftests/tc-testing/tdc.sh                   | 1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.39.2


