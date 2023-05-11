Return-Path: <netdev+bounces-1933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F80F6FFAD4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E6EE1C2108F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F739468;
	Thu, 11 May 2023 19:49:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412DC9463
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:49:16 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4442AD37
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:48:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KL9N4ypVsPl/HJlJRG+cA7YCZMT7bPfBoRK0OJM1bjYugL4eOGjgMvSeegbOvMSaAm1YE6NHYYQ5tUJsO0KavVgsuz+Ex/6xLJC33/faEjSKH7AoOtlUC8X9OM0BM3kq+aLbu5CZeWvPyszETPKPCW+ADC28J/VyRbesN7podOtzmLSiIj3IjNRhqKwkgPH2sDkDjAfUoP86pnfwKTES5cNvDtUwhmFBysvSDCDW0+vAux40wnKXj+OaCYUtIzKsOF1PtgLlpC2bxSyhmPmKVcea6l8ZDlyoPixnpEXKymij25ScFzSv6ejUzdAnP2eBzS3h4eN6KlKmaJqb18I2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmiI7FYFUGubmN1RljPDk2VO4d4DB8O13DSBdpNYUxY=;
 b=GX6vJr4/jWIo8maKD9VdyAFRFYGacK+E0SC8+TCEtcX+y7dhioFgqwA72o+4BZn7fhoNzI+62GTvCStgAWsXukG2yQfnd5fOeUbW6mF3/Skit+7AzXMIeDAqR+5pqjED6V4ILEzZAT2GQ/qA7mOKLUvFFFtBTPnlPY3OzjCObhgzFlQb1Ok/10uT2zp9aHitKPPuLiAqkV65Gjpy4nRVXO6K2eua8IJ8agG6f5adqf2uLs+h8lEcGclIOvDQe2dH4FFhkE6aczn/B9Az1cc8qUwWM1SaMKRzsJhZgg7sHPsqirUmmA5k3JnR0u+WtE/Ov0l7QArBWDUtynQObzvcdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmiI7FYFUGubmN1RljPDk2VO4d4DB8O13DSBdpNYUxY=;
 b=bHPcvLOEaG4runJGP8qACcXUOaFKFYNqd/QIw/Su8xUclj+pndr5RfgPYz7NESdWpC+YU6cwt3h2It6EkDw2EtMgwF9YXqTOvGFSPU6NFWl7dpP2J5KxU+3OeqrfvbwLm9/Wyiqf3zrY3hsbEdebRHFxGMRyBBfhBaNvKc+td1U=
Received: from DM5PR07CA0069.namprd07.prod.outlook.com (2603:10b6:4:ad::34) by
 SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 19:48:12 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::7f) by DM5PR07CA0069.outlook.office365.com
 (2603:10b6:4:ad::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 19:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Thu, 11 May 2023 19:48:10 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 14:48:10 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 14:48:09 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 0/4] sfc: more flexible encap matches on TC decap rules
Date: Thu, 11 May 2023 20:47:27 +0100
Message-ID: <cover.1683834261.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT045:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d4158a-facf-4417-ca79-08db5258a6a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m5dAGg7uB84FTXFiAtf+8YYEcruYgmYLxHiGfRzJJnKY6coyoxWMhpQyXmsCcsl2zmvBgsRixStlaRe3uR5NgchPIWCBVXq343tjex0g6JznO6ABkNLnPxgdJp68EgpGYKaJiVGobunZyLXlgcw6PSejiLyoGgtXdI7HO5tWEgsmlv1JykeX8EVW5oBPZn/QCkrxpJaMssQHRhY9xpji84vLkzyPrAa1/5gJ7IJ+/PFGuhuL2gwX0+9IoPblq0w220yWaoOu0lgkjmZ5gm5JXNA/pedxZQ1WgeL06tJ3lT6sPYnVZIRm/lCvW8qarPPCa4S3+GYsWSYcu+C7dAZvY1dFuHWIyaDpz/deKBuR5KwJCbak3TuNXnIJIXef8d/ry1jhwjn2HIGV4pukVJJeonlktwl4oEDQ/dapuwKfr6srcj6Ha7PBeLfP0v1SU9tcUjtUayHPRBLCw6MrNE1pVsjsusPCLsl241u/6QoZjrgXmRJnWCcpWHP6Qy6IZqufg6WQXUSwVocc628o6QOXZf1nj/7EQmo+iKt6wd8p3H0aJ7HHi1EUKH9l5nuhOokJEbVkfvrqHarE7oqdyxIWL00Gn6A6DIrjy9XUj6Bts20slt98Z9oYV86+wHNeHj0IkZ07OEDTAyr3KPl8fFX09ohjOGm7iqrtOWMmC16kt4oaxtVUMU6RXD7CpaU/8Q1uZyhEWcAIm22q7bI+nmAPpGlfcaTDUaxLcvR+uGL7Hh5UzhetWF1EJ0RbIWJs1sehIBJoy/cDFpamNYMXYaX5Ew==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(40480700001)(8676002)(8936002)(26005)(186003)(82740400003)(9686003)(47076005)(426003)(356005)(336012)(2876002)(2906002)(81166007)(83380400001)(40460700003)(6666004)(70586007)(70206006)(4326008)(82310400005)(110136005)(54906003)(478600001)(55446002)(316002)(36756003)(86362001)(36860700001)(5660300002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 19:48:10.9020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d4158a-facf-4417-ca79-08db5258a6a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

This series extends the TC offload support on EF100 to support optionally
 matching on the IP ToS and UDP source port of the outer header in rules
 performing tunnel decapsulation.  Both of these fields allow masked
 matches if the underlying hardware supports it (current EF100 hardware
 supports masking on ToS, but only exact-match on source port).
Given that the source port is typically populated from a hash of inner
 header entropy, it's not clear whether filtering on it is useful, but
 since we can support it we may as well expose the capability.

Edward Cree (4):
  sfc: release encap match in efx_tc_flow_free()
  sfc: populate enc_ip_tos matches in MAE outer rules
  sfc: support TC decap rules matching on enc_ip_tos
  sfc: support TC decap rules matching on enc_src_port

 drivers/net/ethernet/sfc/mae.c |  28 ++++-
 drivers/net/ethernet/sfc/mae.h |   1 +
 drivers/net/ethernet/sfc/tc.c  | 205 +++++++++++++++++++++++----------
 drivers/net/ethernet/sfc/tc.h  |  27 +++++
 4 files changed, 197 insertions(+), 64 deletions(-)


