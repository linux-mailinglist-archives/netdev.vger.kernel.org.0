Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8C76F0A27
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbjD0QqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243525AbjD0QqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:46:05 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B057746B6
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:46:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIGoofh4UuKxrAxSwlfIHhXzWOQS0bAKsmJdlAXjfAa18tL5VM2ydOKehpfcG3uvnts6xK4JcJ6BYU+9C0Gl25hJQ+HDwGStJq82gaCFlJYDIkZG9g/fgaXDH4mC8tnaD071A9Fpjy3+HbDqyhWFxyfNbpQirbOZL7UzGh5vfBmooatX8OrWplaw7Gf32xKDZj4NSdBY7uBpxg/9v1Eg2fbxlcD5G1kKvyvITfhAt1oS+NjfJgJajhwjmFD2S2y1uooCYCFjMyX61Z0f7VmzWUPsQ1lLdlioE+HS+q3xZmvSeJmpYC1CaKnIznQw5wGVfavd/0OcPepPBJhHmOzcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxmKGSKrwjmu9O66iUq29th1FZWXPuYVKB0Jm/taa1c=;
 b=O5UrpGj2E9q7sjG4iY9znyMlQn0jy9B5znsKx8uta2E/a45MSeccnkQ3pakSYR1gsD2a0AZXZ/BKweLjHuVCoWJPWTCY5X/n/f8SmTPAfofTXCTHKdxXeRVcO6BOUjxXBtKLu1do+d6eRLPGXEXEhyvnYJrN7J+E0NKQRwUM/JFuxUbcd6+RQaX169TC2a0Amyf5Ween0u01mUeFy6+jdblMFpqSLZ/ygqeeemuTEOtYDDcdHOmoZpdZJsMZtibntggjifZwicPFMAhFUMM8t2PbwHzkYiRVpVa/44KUl8Y5ki4PSKptsRPvktsDXipPYISugPH2b/uKwQtEgBfSeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxmKGSKrwjmu9O66iUq29th1FZWXPuYVKB0Jm/taa1c=;
 b=V1M6/0JB3BLEjoFwMuOoo0JPN3HNZ9MQuBXsdEe1Zu4DltnPxrMd+DopGOFk1iKT0HnFUTP9wNxZCFWlp8Jv6Vn13V2HfG3A4q5QiABEMJVXdxbYAj5XfatVg5Cnh7+wLt5r/Dj+AdP3NMddGniiEB/288UQETr9b7mYCZdfTUE=
Received: from BL0PR02CA0074.namprd02.prod.outlook.com (2603:10b6:208:51::15)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 16:46:01 +0000
Received: from BL02EPF000145BA.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::15) by BL0PR02CA0074.outlook.office365.com
 (2603:10b6:208:51::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22 via Frontend
 Transport; Thu, 27 Apr 2023 16:46:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000145BA.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Thu, 27 Apr 2023 16:46:01 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 27 Apr
 2023 11:46:00 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for vlan offload
Date:   Thu, 27 Apr 2023 09:45:44 -0700
Message-ID: <20230427164546.31296-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BA:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 27645cd3-d074-40ad-68f3-08db473ee27e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQtG+DDEynSKP+Au+2poyb+9P7fyOhXwe/JA2mpGqIQff9IPVgpQtPMW8bPCKySYKZac5d8WwRGREsztYpXN71NWqecPfBZbhea/jURpJKr0wqC5zXK0FruoDbTEsqHoasWzP4y2hJ9eq2vhiX27zRfxjdTMgj/mrKgpxbjkMTigfc5oaN8m+qJDwr7yqZ32VZo5TpSVcGPU0sHYtJy5ebMT4uQukN9NqW/BkXSnrlmjDMSQMVpWvYPel+QfnEaVhG+xOV+CX5LJI+xQcHDOuQiFFCw0hN4XVyv/yxZalqY27M1d6YE5FD01rBb9oGFdGk33ryTqjayIUerpaBSLeY5ieV44mtsQ2CRAgISAgbBEBwbzzsx13pZvGWFK7oFJIYNF1BzS9JI/FsDU8isG7JWmyE7IVKQJjE2c8ZsyFl+6eKOOnG29JlejpaJ2nc+43E3TmfhWe5dPrurEAwy2KFySm5Ih9v5At8o3tErNHZNxv5LKo/kXDrxcnB+sUAZuV1PvByu/rjxyNw0iJmMBP4ppNRBE75UV0GZf4VHEqjoROkI4ksibSxWu7dzdzZGDeCrkdZneqwyEgPyxCGieNNkVfBR/QGhEKHbge4qZu8EX2+TvPb7kszEgWhtQVOaceE7+hbX6ovc8D1XPvjt5s8FG4b3GpO1/H8mHq0Swa1UMlV86rT7QrgYkZLcy9JC2C3UNSgZioDboS9W+iiowdhZaOYyG/zR0zc5WhEU1Evs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(66899021)(316002)(4326008)(40460700003)(70586007)(36756003)(70206006)(110136005)(966005)(82310400005)(6666004)(86362001)(40480700001)(478600001)(186003)(16526019)(1076003)(26005)(36860700001)(5660300002)(41300700001)(81166007)(2616005)(356005)(44832011)(336012)(426003)(2906002)(47076005)(82740400003)(83380400001)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 16:46:01.6224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27645cd3-d074-40ad-68f3-08db473ee27e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC for adding to the pds_core driver some very simple support
for VF representors and a tc command for offloading VF port vlans.

The problem to solve is how to request that a NIC do the push/pop of port
vlans on a VF.  The initial pds_core patchset[0] included this support
through the legacy ip-link methods with a PF netdev that had no datapath,
simply existing to enable commands such as
    ip link set <pf> vf <vfid> vlan <vid>
This was soundly squashed with a request to create proper VF representors.
The pds_core driver has since been reworked and merged without this feature.

This pair of patches is a first attempt at adding support for a simple
VF representor and tc offload which I've been tinkering with off and
on over the last few weeks.  I will acknowledge that we have no proper
filtering offload language in our firmware's adminq interface yet.
This has been mentioned internally and is a "future project" with no
actual schedule yet.  Given that, I have worked here with what I have,
using the existing vf_setattr function.

An alternative that later occured to me is to make this a "devlink port
function" thing, similar to the existing port mac.  This would have the
benefit of using a familiar concept from and similar single command as
the legacy method, would allow early port setup as with setting the mac
and other port features, and would not need to create a lot of mostly
empty netdevs for the VF representors.  I don't know if this would then
lead to adding "trust" and "spoofcheck" as well, but I'm not aware of any
other solutions for them, either.  This also might make more sense for
devices that don't end up as user network interfaces, such as a virtio
block device that runs over ethernet on the back end.  I don't have RFC
code for this idea, but thought I would toss it out for discussion -
I didn't see any previous related discussion in a (rather quick) search.

I welcome your comments and suggestions.

Thanks,
sln

[0]: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Shannon Nelson (2):
  pds_core: netdev representors for each VF
  pds_core: tc command handling for vlan push-pop

 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/core.h   |  12 +
 drivers/net/ethernet/amd/pds_core/main.c   |  28 +-
 drivers/net/ethernet/amd/pds_core/rep.c    | 322 +++++++++++++++++++++
 4 files changed, 361 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/rep.c

-- 
2.17.1

