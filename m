Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B351642EB0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiLER1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiLER1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:27:35 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C4C297
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG7kHudbufGvdspDiadUuJ+DXc+b8/octhMCgK3/2cWEguiqj2EwaUSIc5WU188bwGhPAFxWxxh05SQUr+Wkwh8vB47TYRkJ8Agl5M1iuT+HsQFRcN7FKbbghsWccgDhpyoEvNp077ZAqQN6QkoMnUHQDl3COBt8NRJ2AUJY9nMYGEZLX8XzHUTWQ2NsODqrhlMnd9jwRZiPQtHSemqADTfGrp0o9jwqiRf98L1Y5UnmPS1siSNMKiYYiVQ/CDxUX4LxhLMa8l188jeyVVDL+JSpN9ngg8uXvmzaDg4j4KLARUumZgsP7ezYRNSU93N3ef6qcLSj1pfr0sfqM1m46g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXUN8yP6bprTroJWTJd85qPXfxCSxhdtG/sJ0Rs3XNc=;
 b=QrLE7a3XVrbwQ8Wx//FmTc6ub+/TXZazO89UhliHRUuBxZUODpmxye5IGPfjyqH4y2geYVyiHtDRwpto/X6TPlFqn/qIXbTUsSTdL1gDRCrSTDgTpeE0IVXm6Dcie8IMrGfOGXBbSXyWFWDId6xoafng85DCUeTRVJLZGxq/vPiu9vKqOqm8IVTrOZzL51I3rEjQA30gaCSsas83SkYPkv4dmPeCEwOfhkFlmhaT3BKfoFfNRJklR0qcE/twRW1Hv+qCEX5pYf/di70YHwVawgxqHbqlMf0hNoB9Tq8vzIgv491fPB7PyJHNaJ/LrGTkVQdhNSqy4+Zmg76KryqvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXUN8yP6bprTroJWTJd85qPXfxCSxhdtG/sJ0Rs3XNc=;
 b=BYs/MmaxWtxy1+EP0bxvbn1J3vmEkVrd3fAQKjXFgBlHtA5mmzmti2affVsyhM0PHfugPamKQWZmHVYBfVrMJ17gkMNNaRrZiCm5OjLF0j9W3yKgzSsR1RF8KyMNbiKpnl1qgZP/IXZPhZAjJRlK6cuseEhJc/7bbCnNrVax6Q8=
Received: from DS7PR05CA0032.namprd05.prod.outlook.com (2603:10b6:8:2f::31) by
 MN2PR12MB4341.namprd12.prod.outlook.com (2603:10b6:208:262::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 17:27:30 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::32) by DS7PR05CA0032.outlook.office365.com
 (2603:10b6:8:2f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Mon, 5 Dec 2022 17:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 17:27:30 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 11:26:47 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@nvidia.com>
CC:     Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 0/2] devlink: add params FW_BANK and ENABLE_MIGRATION
Date:   Mon, 5 Dec 2022 09:26:25 -0800
Message-ID: <20221205172627.44943-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|MN2PR12MB4341:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da6427a-4249-4823-29f0-08dad6e5fd1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfzKYWt58WRi3UVMoglf0FJywe8+D1dHt7rBKxAiAExxX6Mcv8f+fG2PGba8m92zySciHdcOiAzvg4I+WRE7hqnjS4wFGy4y8yStbErEUaaZ1TXQyFhpmEVtt3mhM6+KkWeY2bWffhfXj5jLWMOIcKH0dToizHykDu16rGgIKknCr99RKd1Mk3YgNdIQRdjw92Ak0OK7Y7UD64WV+gu66MU3I0aTuYLViJxL/qxDzOyiefmdhhjEqLFJJlgqY/2btwPo3Xn5hFO3/cWuqjakk6cX6a/GER1/g0mSKW6huFSzdm1+WZOMoNV9FpbgkXThpZ2YUG99VwJpCXdpxdAy0ss4HxrHQfhkGkxa3q2zbtZdCmd7soJ6qp1kJP57YCarU1tkZOsDHS9FbofBSMvZjwahOaxfj24xXRIdereYB053xPwe6tMVRD5fqDRAmU+Ft2IF640HEz00wqLp/ygNoybRFvyrY7IOOlTw/mJCveW5YnNhKYpp3CSGNTl+4qKdHUWz1NOwCv39pmfBnxPhfZ9q4sJbz0/jWshdUInW5ThHGJ+b6ifXK89Lk8G1lyDQkifEnor9jyZw+cRqqOrynoFUuebqRZuBRGFGl4O9e+cz0IZs6WGWO76ydCtBBX+JxM1RwTzvp6rL5s6FhYivYYs8Y978gOcM7GgQe8gWXxaQMYSkNmsCQDY37mnQRlbJomUU3861Gj/m2o9HNUH0nn7ILqLSEC4U0L7gha4wDdqK+rfqWbcRSUvGje4hE116J+mdAflsFEUD9eWC29y64A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(44832011)(70206006)(8676002)(4744005)(4326008)(70586007)(8936002)(110136005)(40460700003)(2906002)(16526019)(316002)(82310400005)(47076005)(2616005)(336012)(82740400003)(1076003)(426003)(83380400001)(186003)(36860700001)(40480700001)(966005)(86362001)(81166007)(356005)(478600001)(26005)(6666004)(41300700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:27:30.8123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da6427a-4249-4823-29f0-08dad6e5fd1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4341
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some discussions of a recent new driver RFC [1] suggested that these
new parameters would be a good addition to the generic devlink list.
If accepted, they will be used in the next version of the discussed
driver patchset.

[1] https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Shannon Nelson (2):
  devlink: add fw bank select parameter
  devlink: add enable_migration parameter

 Documentation/networking/devlink/devlink-params.rst |  8 ++++++++
 include/net/devlink.h                               |  8 ++++++++
 net/core/devlink.c                                  | 10 ++++++++++
 3 files changed, 26 insertions(+)

-- 
2.17.1

