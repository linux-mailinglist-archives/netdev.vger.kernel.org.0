Return-Path: <netdev+bounces-18-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759BC6F4B7C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAED4280C97
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFDB947B;
	Tue,  2 May 2023 20:40:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA4947F
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:40:53 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9E919A2
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:40:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCQAYwcTpt+KKdvwCZ1emNvm4y5BwRjNxvDHq0ClMRIs6teLMCzJzeDGawyyqGRQZEoyJlEv6l6XV0WK7rhG4ujyB4Viz4qj8eYfOt9klYmHlinkaijWIGRhUB2vgklsXvR/NCzWQYHCOz++auyEnkJ7WFtg2DB15U7gzrl+0tdgeZf+BL9fGkntQWlArxSNUexQjTTBbi0fRb66zG5gWVoattebyjwTHSowmxD9fPterwg5OL+e+8jU6TkxUOlVuegM0eMHqK4zgLSUTjzXx4bNMnFWXOkWUwuhEFbKYYnUjY9YaI74fLmZrIuAJTPDUy4ln8zcDQbrk4py/pFYRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOgZ7lghcqy7MEoiKb4gjxtvVOTmjdG3rCdcsEACDow=;
 b=OrF2UeQ4FWrlkLohw3YQ0c2FwXG+SV+asXHG16RTrMNrzNxS4sMh6m5JcqNsO/ThyYux+d6LyT9dHxCgVAGWDKquPeH4+dAauHIwxhPK7RI27o+KvteubvdBmTTEHP79eOAwq4vQY4x3OPojkwCLnCtR3Z1hq3IcWKMof0NtsrOGKn7hmh7QgA7s3u9yIE/TqO9//8AjMORbb4wcez1e2dMvUldC6PcKOFgrrVBoDqLEGClULzY8V5B0l9WrGEa1/Xqtfr/5DVyB+37704fcYcpuZVnG1adODAPhUyp5+wuejBLVpYsWTKATsHAwcoD/IhmGXug77XyQEaui1n64ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOgZ7lghcqy7MEoiKb4gjxtvVOTmjdG3rCdcsEACDow=;
 b=q2vWs1VKqlMiX3TSurAk3cnlyCuC/vUMJz5Rhtd7hLT6o1lZgOuXB35v80RNxouCgUNxqQuEd/pbsFAcBD74dBFrnQfo2lZ+9eavtRM1aJ6X3occJE3NRq+0fZTtd1RSDnBvA1zDBe2Yxj35qbvz8Ppb0sPeQk9ieQWiKADrMEw=
Received: from DM6PR02CA0091.namprd02.prod.outlook.com (2603:10b6:5:1f4::32)
 by MW4PR12MB7261.namprd12.prod.outlook.com (2603:10b6:303:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Tue, 2 May
 2023 20:40:47 +0000
Received: from CY4PEPF0000B8EA.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::e2) by DM6PR02CA0091.outlook.office365.com
 (2603:10b6:5:1f4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31 via Frontend
 Transport; Tue, 2 May 2023 20:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EA.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.7 via Frontend Transport; Tue, 2 May 2023 20:40:46 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 2 May
 2023 15:40:44 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <kuba@kernel.org>, <davem@davemloft.net>, <simon.horman@corigine.com>,
	<netdev@vger.kernel.org>
CC: <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net] pds_core: add AUXILIARY_BUS and NET_DEVLINK to Kconfig
Date: Tue, 2 May 2023 13:40:32 -0700
Message-ID: <20230502204032.13721-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EA:EE_|MW4PR12MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e53289-5fed-42c9-3e79-08db4b4d81ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X+NJnM++PzcPB69TLquy/Y5OPHliu6e7WSRDPAEeP9mdiBzot+dXC++bx0DGCVF44u5AByGGIvHS16yY6FRnACfV20AF+SwhBCYL1olFW+8towoqlmDg21uuFnPxWCphC3KJisZsV2kmtXXJl5NnWBUbRNhau8abeI5tdk56hpuISHe79wTwMol4twbkv9BUAcmfp2t0maMDEmm1pRDF0wrfHEX60TjQtPfn+WX+uoay1Q0vY/T059bBeYqTSLrMANQv50FHEwRELj2hGv76i2LZe0eQ4/PCba+g3raCQvKYUZ9W657xfdbUicF7Yk449C6lR1wAgQLdpmiQwyBJvqEP4crhv+OeUcS78ZafA3qFaWxOUj1edtkxVIKobf59E5vgzUq7vMe6vGpkgdYWF39VHBxXxS4ttLSlu8hyqFY4B7lKJUi3uMrc0CIgHUWgm8kG7thMNosvaCPaX0buuK32npHglPbCSKQo5BLW3juETaztpA4ndQ0oqP5jnmCQl6hRBjmJi9hoXNWVWtKmpFc0xyw1cZWP5n80mNtcW7tEORxzTlVO3kKCHJBHMH7r2dYir683lCDfzjV8MfIsl4FWgLmjGBiS2iKoVKuEYeoRn3EqXYF5Il2Rok+xr6AgqvcY/pjag33Jd6+5uwBe/nqt1we+PZOIjlFGLcS+A/eqnWofNfHjnFyoXqzJLu7T2NbQe1fVOpLLR1KgWewPxg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(110136005)(356005)(5660300002)(82740400003)(8676002)(40460700003)(8936002)(44832011)(41300700001)(316002)(81166007)(36756003)(82310400005)(86362001)(2906002)(4744005)(40480700001)(36860700001)(16526019)(186003)(478600001)(2616005)(966005)(426003)(336012)(47076005)(6666004)(1076003)(26005)(70586007)(54906003)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:40:46.4577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e53289-5fed-42c9-3e79-08db4b4d81ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000B8EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7261
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add selecting of AUXILIARY_BUS and NET_DEVLINK to the pds_core
Kconfig.

Link: https://lore.kernel.org/netdev/ZE%2FduNH3lBLreNkJ@corigine.com/
Fixes: ddbcb22055d1 ("pds_core: Kconfig and pds_core.rst")
Suggested-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 235fcacef5c5..f8cc8925161c 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -189,6 +189,8 @@ config AMD_XGBE_HAVE_ECC
 config PDS_CORE
 	tristate "AMD/Pensando Data Systems Core Device Support"
 	depends on 64BIT && PCI
+	select AUXILIARY_BUS
+	select NET_DEVLINK
 	help
 	  This enables the support for the AMD/Pensando Core device family of
 	  adapters.  More specific information on this driver can be
-- 
2.17.1


