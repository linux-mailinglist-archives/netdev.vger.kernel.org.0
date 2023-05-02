Return-Path: <netdev+bounces-16-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B496F4B5B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A831C2096B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C00C9473;
	Tue,  2 May 2023 20:28:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7B9444
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:28:15 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF9C1997
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:28:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD5qevc5N3n67CDQLto8dbNLIDeanFNi8dISI4xCBtZ3N2OJHKg+5KIMA1bPnqA3aT6c9Ht0lnTfHgMc5P8BDSk2gYA6UGl5v8tt6MzFp5bvUeVlxNKKquopKsZauhuORBhPieDw6N9mVA3l+poaEBh0LiC49vDq2eKxbFX0AtO5tGwKqLZ6M4WmQfsatcU9VpCAgc26wccvH81CXsNAp8gWT+Y3vZB6mSc891NEYtp6qi/sjBRSeP+vYtrkA3g9Znx0bXMaxz53gzodbDJj8us6jUCshOx5S1muFlIkVFk0bbBqBJZiEe1vq1Ico5oU73BZKHBnetQMyefO2kTkFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtdqDptWQDmtmnpd/4SMYFDoxtDFMwuoSucSdJTMwQk=;
 b=gYzwHD4yElsvaeiFr8IWLz4Uc1Nij0GdXeGxN+JIWCZf93AlvdTUEYYqhY3eX6DxrYQ9ZE0VI3q9LDxlG0mjHQB6TWDdvGSWLlDOuvNqZWzpnuFcwuHTXI3ZzOkjKUaOHhsAKsH8+OtwffWYc1QpQgAx6AYggiBdn4mC8ezRbFHdlfHsN2gNJQpRE/Lw4D2EaDoUn0RUV+HYMTVVhtSk0rVlJAGU4n9vAL7ZAtMDS/QbVibjLcZFb3m3JhdU4GwV4FHzfle1DgG0K7M9E6bt9bFeV0tCEr0cMvYx8aymF0H8EKiMvvk+NDShVO9n2QTIER6h77ANlEdS3zw5VWj5ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtdqDptWQDmtmnpd/4SMYFDoxtDFMwuoSucSdJTMwQk=;
 b=j972VJH2r30GJtOktl9UVHM5LSfL8/bNhOuBWrCOybtjzyn9KJdF4zrNKALElSPhF7mSKdzJNOHjYeMIxIUTHEiiOPOfAJrcEsM0UAL7whyLY1k4JEaknorsT9Lz9XQO4mmdQAgkV0tkDuXPuiChxN2yl8USad8DYuOzbo98UzI=
Received: from MW4PR04CA0115.namprd04.prod.outlook.com (2603:10b6:303:83::30)
 by PH7PR12MB6468.namprd12.prod.outlook.com (2603:10b6:510:1f4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 20:28:08 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::38) by MW4PR04CA0115.outlook.office365.com
 (2603:10b6:303:83::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31 via Frontend
 Transport; Tue, 2 May 2023 20:28:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.21 via Frontend Transport; Tue, 2 May 2023 20:28:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 2 May
 2023 15:28:06 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net] pds_core: remove CONFIG_DEBUG_FS from makefile
Date: Tue, 2 May 2023 13:27:52 -0700
Message-ID: <20230502202752.13350-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT018:EE_|PH7PR12MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: e264d476-b42a-4872-6e73-08db4b4bbdee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eXG3Pit1dnPiSd+8U6R5OzjehHwjWRTCHipYf5QzLXGEH5nGIAt4gNYyq+34XCn5C6tSNYOkZOK3OJnKQK3GsjXlb8hbzizD0nIgHicuU0bBxklu9X4YJ0pCrZkjxaTeGMxToaxkZJcbXHtXxAJDc9Nj6fnHGAOZK9L85m9T8rJNIfO2/dAHXTYMKBuBxmk4a4KxE2KA2eq3LUp1Xyvbmfv/H2x8ASuanneDzUUhXIRwW1iiWeyOQW6siYswwszzCWtFC8ZTFk+3z5bpcnfVKBXbwyfo7lYYPYloenanXuwYuexylhjouuSNhX57JxKR++mvXtCuw9/RVm09iQaKxCT+KyKDJNG3SMLxNtD7Ybx9rKH8LRXBV7lRIWHZ6Ow3a9yP2LoIkprKOgcxYiEQiHuUXBDBzUIDcLYxkePSVk40LhEdgJI04QJRbryqm6Bt5qTUom2ul6ZHd3/TZ0bxXDVnZB7s2YcfJ+yada1XlkNmSNluJ1DAK2hBzM8LiGPJUMwIv3zMlk9gcxR+Fu7oEsCYw2QyS/w7PFe7hBW2G7qPS6fBej06J4LwJnZ2iqPAK4ZalXyFZ0mbSz2ebw6PIk2Xn7Q5zl8KDpOUXnxGc2ZuraPeeC5o4+d4qjmtu/nAiKdMOe2lqq2XMNDw+aXr5gt6wKEnjj0P+ku5MpYObB1S+TnAjQPBxcmWnqFT8IRFWow2B2LmIefJ+lmbJIKuhBL1nWZoJ7b8KItJTQp1xwQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(41300700001)(4326008)(8676002)(70586007)(82740400003)(81166007)(356005)(70206006)(316002)(2906002)(4744005)(40480700001)(44832011)(40460700003)(5660300002)(8936002)(1076003)(16526019)(26005)(6666004)(83380400001)(36860700001)(82310400005)(336012)(186003)(426003)(47076005)(2616005)(36756003)(478600001)(54906003)(86362001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:28:08.2644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e264d476-b42a-4872-6e73-08db4b4bbdee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6468
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This cruft from previous drafts should have been removed when
the code was updated to not use the old style dummy helpers.

Fixes: 55435ea7729a ("pds_core: initial framework for pds_core PF driver")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 0abc33ce826c..8239742e681f 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -9,6 +9,5 @@ pds_core-y := main.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
+	      debugfs.o \
 	      fw.o
-
-pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
-- 
2.17.1


