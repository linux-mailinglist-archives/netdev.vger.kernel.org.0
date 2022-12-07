Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF464508B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiLGApN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLGApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756013121F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkN38YmDyvUxaT014BEYDhWCjprWxk4xTUJy5qi+d3vVcfknIPiokl6D40T3stWAI8j+dSoa8AhJiojeX2d/vdRPmswkpIUEpR8ct4z1HrCw0yv97n0aHTaIjp+bY5bA33vtxst0BJdGDQtx7QOVs7loriaRLoKAfyxCrC2LHGKDU6SbbDz6q5zJtaYCEOQkRysAS+M5zWBrNu8o3syWSHYJ4Cve1/1xU4TZAUERjGK83hkliIxpEyGqtHIwr+vpCcCKsqbZ9EEXyvl/eTrd71+z3D/wx3Ex/+mKqG0VRP6BN+Bx3C+w8KftQ/4OaozIi4UBPWHKUkr/UwjswS554g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dftM4Y00xPfFgSg6fF26978p5ywCI5zmwxdH7xDeQ0o=;
 b=HtgHHbydH9yE6FMWqNC711LKbVnNe30DA53/Qr8A9ocpv9/X5jk3hvDVtrG1sbX7JtercrH3HGhcJFSc/YQSapp9C986Hc4XQ3SfbYVI8oyk/Yjz0ueSI8U1NVAja/af7tDLQDMnluxiykNyWkfV2QjX2exuNhatFWmDFt0qV17OzMwC/kxbXmK657pVdkSkrpwWIRpwZREkL9nPNCz/PhuFC8r//5IXsqg+8WkeVE/zZ1JqwrWDgt6NphhtLdPrbjC3c4oxpQ2eesr1fSJa4PJY05R1bwBMCiV2SsE3DSo7sp4j6CPhqmPQ2D1L9UO0eFu7bIfMAjfwpJcPzK0+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dftM4Y00xPfFgSg6fF26978p5ywCI5zmwxdH7xDeQ0o=;
 b=Vtg57dRAgqrYo5MF34WTDs/diIfHqWmYBAhCMoqAoAxR82xIEgTx2yzZWW75/KQWc3W4PpdY25ZWbiPiME+sZD0mw/zaTIG73gK5DUpCVk4em2poEbEcS4MGz1+z+WCnd/O1lnK0ZbjYwz/BSOZcr/+Q0iNF2+3kUQlQ0IiPzwo=
Received: from BN9PR03CA0903.namprd03.prod.outlook.com (2603:10b6:408:107::8)
 by SN7PR12MB7275.namprd12.prod.outlook.com (2603:10b6:806:2ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:06 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::e1) by BN9PR03CA0903.outlook.office365.com
 (2603:10b6:408:107::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:06 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:05 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 02/16] devlink: add enable_migration parameter
Date:   Tue, 6 Dec 2022 16:44:29 -0800
Message-ID: <20221207004443.33779-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT010:EE_|SN7PR12MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 635b38a1-29ed-49d1-503b-08dad7ec4943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liJxnPbt3htfJDmqsFnuh2AFFUy3Hi89UjomNUK5o1xxdhljFoaYO9JxoHEAbG8RvsKsLjplsj1i1ZrnBv+Pkvy7LclAzrEjHg+YFLvqDGs6cVuTHCqROdVi0fZq3aTpmjHeq0vdl41auqKaC8Chss9jfYO1Oxyrj6Z9Cj43GGDfmWIdhR7DC2h4BjGnjCNRTTFUzc4+96++tytbWdGEUD031kUqSIAHqY4PXH+xUv3cMXKCwl56b+o0pIeFmaSB/ra+FNw0HFkT5dfC5fmi/mFZXf5sr714T5OmKwdtZVooMc6gfuB/9jDo9L9C5KSuoUGteEqySFnNdA0P1UbjHNjvQYT098VaGXC9LeEh8AmI5rjxb76Subf2iKxCGYHnBGCyw0EBOwQOxjZkZUeiu+k7TGe455wM+P1saoMU7/c3wXVfph6dO2gsiZ0PfvQ6ALm4g6MnA4zl4l+BP7fZAgLu9pL/8sVVbqmAEFn5Dd1q2o/wTu5nE/AnBX50UQJtE6lG37eII8x5YmElqgH2WXAy/o7UYXoNV97l6wFh5h5o4p/fptqJp2XUQyxavx5crjoB159BO/jMqnj/OpjDPkeoS8jQgqfzg0LSe0CCsIvW3dkyDser4N9jc0XNqxYJT40uLITuBpM5BMSkUrnvrTC8e1RnkmgprNGaYzOtA1kqYS3Gm8V+dpnE7OeBclXHEe1KR4JnIXwDhQqwpfyfRoaErNfaeHQwBAbVcR+Wjqc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(8676002)(6666004)(4326008)(70206006)(70586007)(36756003)(40480700001)(83380400001)(41300700001)(478600001)(36860700001)(44832011)(86362001)(8936002)(5660300002)(40460700003)(82740400003)(2906002)(81166007)(82310400005)(356005)(336012)(16526019)(54906003)(2616005)(316002)(110136005)(1076003)(26005)(186003)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:06.7435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 635b38a1-29ed-49d1-503b-08dad7ec4943
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new device generic parameter to enable/disable support
for live migration in the devlink device.  This is intended
primarily for a core device that supports other ports/VFs/SFs.
Those dependent ports may need their own migratable parameter
for individual enable/disable control.

Examples:
  $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
  $ devlink dev param show pci/0000:07:00.0 name enable_migration
  pci/0000:07:00.0:
    name enable_migration type generic
      values:
        cmode runtime value true

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 7cf1cd68ff08..602c8d487afd 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -141,3 +141,6 @@ own name.
      - u8
      - Select the bank of firmware to be used on future boot and/or resets in
        devices that have multiple firmware memory banks.
+   * - ``enable_migration``
+     - Boolean
+     - Enable/disable support for live migration in the devlink device.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3fa26a26fa44..79842b174915 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -511,6 +511,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -572,6 +573,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
 #define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 25a075f0aadd..b51c1d0da29f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5226,6 +5226,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
 		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.17.1

