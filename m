Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2876182C3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiKCP2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiKCP2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424371AF3E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+3oFoaIOxj0H29YE3C8bzy7gWb+WdxN/HJPb1GiQYnJgN3AU+j6HLdSCbfiEDLyfL17t60vrsFfPjVvLj2TU+2cneLY7pXpAe8hAxNcG5J5BHig7VRlwSuZ94Vh0QtK6/M06C8/h7q2hlOWdM4U6U5NS/RRBIhIb+Xr5y6Uij+gndaSFeC9rxE/FadXdQdAOpnuDf/j5SmyZKsMm3INYigrwaBbLy6Zp1pz/YHhBMPaiw4YcOS0ZmEkQlsSPpE+ddrviuun8wYQ636g8ab3kY837karJYUlSgGHuWqFaFwcAOMp1sZCGo3JNQkUSxdEAlLpiD8Py7k5flc4ypWjcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liE56fG/lrVRwVbBDj6rmp0FSnGZ3UzuvYCSN8slvY4=;
 b=XyMSFIs5IUPCaIXML1C7gWBnnBFUsxsHel+KqPE4yeLSRM78oBnuh4DgdP0Ml7DKAXDDI+Rs3N+d5g0FxkDQPi0Al8igO3fBQp8o+BfMhLITwmUCzBL/EKhctCf2JxYGnmH+O6uOM/X72bpCHUo4piigAUGxigzdYyc6nNcEpXg11iMw+jniXBggh5s0Z/tluAc54sTGLMvDCUnmL8cqjhhk5RvazTp+ZWxf2TFmchHVyUi9gjRY6r8z2htEs1VuF4Ctlvz2o1ufW2BVKYXht7TNoJvUSRUTY9V5EyzfSi6xdzsRZ7P/BCvDsXjYYbRB4pwblwEk/Ouzjo0qsTYMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liE56fG/lrVRwVbBDj6rmp0FSnGZ3UzuvYCSN8slvY4=;
 b=DiAcyGgX1siRB5QiEd7So8OEWHbFX+PlIkrMCkpbI/6himAliq0IkvHmIy4sMk+YGgzWv7gJy8r5NF3YOFH451N1dTa34wv0AlEdXHlnbSqpl+NWdIkzYp4I2lXgx34D3k87AHPWhINPUug/Hn05BM5/AOmH+uU4BRzbC98VMeU=
Received: from DS7PR03CA0064.namprd03.prod.outlook.com (2603:10b6:5:3bb::9) by
 SA1PR12MB7101.namprd12.prod.outlook.com (2603:10b6:806:29d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 15:28:00 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::cf) by DS7PR03CA0064.outlook.office365.com
 (2603:10b6:5:3bb::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:00 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:27:59 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:27:59 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:27:58 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 0/5] sfc: add basic flower matches to offload
Date:   Thu, 3 Nov 2022 15:27:26 +0000
Message-ID: <cover.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT074:EE_|SA1PR12MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd36495-9994-4d5c-bc56-08dabdaffdcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PB4TLo5S2fdqW2E4rh1/FgAyvmtG494mPFxChnt8l23Sc6eP1IUkj/I+9Ih0jGqgHKI4Mx5M6rZ1U6J69Sc5epVYY6AzpEhvpmJFfzVmjMIgdhAdhBap8XxLbZsqn6ZJ7gCHCKUZHD85V7nghmjN1vYCupemnlrP1UJJV/oMhJbgxGy4EF3nqCNhRsTxSnGQBixYrI7hPuFgndLT5mBgCtjO7vkI3Xmo9cR4qo2nHR0a4+vwIHU36/UUXZUY8iCbDjOaV/rYx9E6ZPwm/E3wbma0aY98HEzX5kZhRX1VTZ1/KD924c1dO0ZobyHoVPSQbu432Wj6mVQtrSkyxp9kV38fq9F+EkDZ7ALp6L7QtGcTq7TZFh/1Qfl7JFeeAsL95/JFyfnJDJyYGxtel4KS/bl755JBNqTsIQ/UXmM/hqKPx2tEA0ShXBYkQhWS81U3JsucdVGt5sKPxisF9Ph7Cd0PD4fnNeI/rDdyctbJsEIpQpqG+IOgMOv3+GQlvdi7ErgXG1hpnWK5xnYo4jWpA8VBdSiuH2SH+c3llkN7hAJQGlakGLQXkrsxsIogHtDoYerbFixbMMM+NV151eqr7+66Da+aoTlATSomsRSJtApOTeESGk0izYwzNhzd9XMBM/e48BMiqPcoJDQOfS/E3Z+aQxeCSVacSLPV4DDY6M0egiukhU5A2maaPkSvAX5QxWFoNGHsO6BvVa2Z9QmwZNyLPfCIOVZMC9PNsQ6dYqrBhRyC4mc4ZQJgsbcHsG+nPLOzG7vlOPX8+txI21uFcfx4r0crrKyUn1/ozhZgAn1DiWWccA8GP3vISmEg7Xv2
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(6636002)(2906002)(5660300002)(2876002)(8936002)(110136005)(54906003)(478600001)(6666004)(40460700003)(41300700001)(186003)(336012)(86362001)(83380400001)(426003)(316002)(26005)(47076005)(82310400005)(36860700001)(70586007)(70206006)(36756003)(9686003)(82740400003)(356005)(81166007)(8676002)(55446002)(40480700001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:00.0544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd36495-9994-4d5c-bc56-08dabdaffdcc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Support offloading TC flower rules with matches on L2-L4 fields.

Changed in v2:
 * changed CHECK macro to not hide control flow.  Annoyingly, gcc complains
   if we don't use the result of the OR-expression we're using to get short-
   circuiting behaviour (ensuring we only report the first error), so we
   have to have an if-statement that's semantically redundant.
 * added explanation to patch #1 of why these checks aren't vital for
   correctness (and thus don't need to have a Fixes tag or go to net).

Edward Cree (5):
  sfc: check recirc_id match caps before MAE offload
  sfc: add Layer 2 matches to ef100 TC offload
  sfc: add Layer 3 matches to ef100 TC offload
  sfc: add Layer 3 flag matches to ef100 TC offload
  sfc: add Layer 4 matches to ef100 TC offload

 drivers/net/ethernet/sfc/mae.c  | 131 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  12 +++
 drivers/net/ethernet/sfc/tc.c   | 137 +++++++++++++++++++++++++++++---
 drivers/net/ethernet/sfc/tc.h   |  16 ++++
 4 files changed, 285 insertions(+), 11 deletions(-)

