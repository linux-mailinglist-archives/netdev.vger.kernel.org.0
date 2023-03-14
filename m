Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB76B9D26
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCNRgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCNRge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:36:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BDAB893
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq9rD5Y2tjhb6i3nGXOE4eD8GVXEl6dYSq4r65s0KrKXPKSafRxkJHrOMOk2nWFH5DwgRL97QuOQiLpxN890JOA9IxNiu5mCCkuqLRTgUasKgAyfMToZV5XBA3MRqUro8T6RvL9GVAC9a0yFlfvqTLNPf/6BSAFCjMMwR8u4E4C4mByRdJU+bNIG010p2FJAKgWO03lCWW4A1E55J/SMnObXoa8ys0brx8J9iq2TF5f6MJfBje9Zn80jQOwOZf3WJMsjlCF5W/JTAR3bnoe1RurRDBHjMkYkfDTkKqEp6x/bkSf2WEngWzCdIHmh2vQpw8UCEJmgPeqyd0gbIMjkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFP9MWXC+WVqj3GiUWvvH5R37qiAyb72NNWuKMglQkA=;
 b=BPo7FWonQbeuT+r868gLybvK8mBTw+IA/kzPKobroDwRXZ/kQy5xalJNep3wZeEaXV9mHxqJsDB0JFk1fxLV93KfxwbtDQfnt4j94eSNUdtd7M4F+HXgDIFDfYgNn4Z7moo68BoHFphClNFCC7kDWhgWXUoB0+QkTx5p6fb8N4WNZhYnozjY+WzomwTpoREFAJeSOHIm4sZeDv7/dhfXmWKs2NoDsOWMtPdUsN3u4QKFPu7PIpdSffpieX4urFdQ2XyOz2W+k7Xa8or1InYBhvT6iTvhNpdheP+tnbHI+pGGXV+/TjxFM3ecvWKE5VP3Nzgg7gedJzGJQzdO+ubUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFP9MWXC+WVqj3GiUWvvH5R37qiAyb72NNWuKMglQkA=;
 b=GaowC1GHIQqxw+0p8/wXXqGaR5v3a8oWwHZUbpOq7R5PEhLVL5YUPR44AUfwHenASyQsIjuZw7cVU6zAadY1H1N8VpEJlx31VCmVRidt3V/YrpFHrkOYR99Vzw46I5O3ft/IML5xZpw7Mo6Ta4ynS82o/D7RSrCFKabyyzYAIV8=
Received: from MN2PR06CA0011.namprd06.prod.outlook.com (2603:10b6:208:23d::16)
 by BL3PR12MB6545.namprd12.prod.outlook.com (2603:10b6:208:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 17:36:29 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:23d:cafe::6) by MN2PR06CA0011.outlook.office365.com
 (2603:10b6:208:23d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:36:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Tue, 14 Mar 2023 17:36:29 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:36:28 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 10:36:28 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Mar 2023 12:36:27 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 0/5] sfc: support TC decap rules
Date:   Tue, 14 Mar 2023 17:35:20 +0000
Message-ID: <cover.1678815095.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|BL3PR12MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f54bac7-8768-4034-e6be-08db24b2a4f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0r1Ajt/H/Tq9omqewExZwQOF3iJcx1AtFk3CkwOuoA9sXmQcJmdx/V0j1HHC1T6IwNpI1sN93bxbl4xfmoC35WSHZDJUiD9P0OiGmSM7cwIZmq2VdFgsWIU0XQuwULt0oODjXbqX8GOMc8GDMQbgjfzSJgWb5atmPsJRW6L7MqDQeiE3tV2++lPMxRBXKezzEjNqsIgpeaNaoMPGznUvq521D+XwbAP9w6ecndnkGi6LkHfjw7n8yHBv9diJ5V6yPdcYSkkmPOa+AJsq/OGU/Y1SRdpBv+OsEBtGTzQK31xhBr40kE6lNnvtPu19LyMYMogaE8qFSrEq/3ZJ2ybKqGNrNyhyZasOuxtgFVT7EdKkbKefBdfQRDDqqQkyVfA/ox0LAlp/0LHdDCXZtr7Bg1rYTNo9xVwEOtUvmAfhgIpVX4Ds/JBcOooVm/kR3NG5uNTs0PGisQ1Afhmh9Kmx+8MaV2egFNRKgtNJei6gKFT2hotbeLGKlJQPKw0VVK5TlJnJzoR9pjNaVMTXPZl4LXOTt2QxS86tK0elEM51/cJttG8aVSeMzXzW19gED71AFH1vICXQ8MeNYmXu6zYUntZOOy1JLfYANiOfbZATSc1Cxv8Aef2SFuqJ0m8dAHzfIFl1IbjoEQwiDpw4pZOQQVsmeBRrGug2fjMhgDy2+osngfE14P6AU0887V/c4eCb0A8D0U2IBWIyuSEnX9mMeFAyEA6siEDLCMaSgmrnOA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(36860700001)(336012)(70586007)(81166007)(70206006)(478600001)(9686003)(40460700003)(26005)(426003)(82310400005)(6666004)(36756003)(8936002)(356005)(41300700001)(47076005)(40480700001)(186003)(4326008)(8676002)(110136005)(5660300002)(83380400001)(82740400003)(2876002)(86362001)(55446002)(316002)(54906003)(4744005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:36:29.1564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f54bac7-8768-4034-e6be-08db24b2a4f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6545
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds support for offloading tunnel decapsulation TC rules to
 ef100 NICs, allowing matching encapsulated packets to be decapsulated in
 hardware and redirected to VFs.

Edward Cree (5):
  sfc: add notion of match on enc keys to MAE machinery
  sfc: handle enc keys in efx_tc_flower_parse_match()
  sfc: add functions to insert encap matches into the MAE
  sfc: add code to register and unregister encap matches
  sfc: add offloading of 'foreign' TC (decap) rules

 drivers/net/ethernet/sfc/mae.c | 237 ++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  11 +
 drivers/net/ethernet/sfc/tc.c  | 596 ++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h  |  37 ++
 4 files changed, 864 insertions(+), 17 deletions(-)

