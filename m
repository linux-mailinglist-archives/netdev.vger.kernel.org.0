Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99820617B96
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiKCLec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiKCLe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:34:26 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C7712606;
        Thu,  3 Nov 2022 04:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk8FKi+zpJS9eVRKdwiXWtEIDT+wiU4q0/vP8zTh98sFRNyGj2zyx+CcGxLqhUIkTsAtTAsqp1hCEx52Qbj/OXQLb5uKAN+SYUjv6jn/ETHhkjttYrwLfZLleI5Piz+gsVj5Vi1pwPEqNl3/EO91EKuRoiKbwVAOvOqLWT2/9JfZZnNP6czkpjaTlGWVGizxmKWzPaoTVY7T8KwHRYtZxHUJCXatSUfk7lTaWHY1g2bhIguThCNmzemc/j8eMZp0cudCuqLbbPwgSjAjFAS2rMRaAHgE/j3ImOoY/4OyUqZ7vcMlPUTQTXhV9XzRz9MEVnE9681um2bsmYYQaBC9lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80sUDZgLqWj9NTbV3MXrxl0hZfKhyGxhpo19Q7lGvJE=;
 b=TwR7gZwY/1dA12woejwOsokg4yR6f3gDyCpvX2xFRGNLgjIEiSuy3VcFWdTaBBiVdUBmpZKCp/Knl8W7DWO7+VHjWg1ZmAw/XPshDVmeKK5nMLjfdjuF8mCxlU7/JXAhVpe9WwSOujDk/TuiLQigprIbhr1cnb9kgofO60Cj8wnstgSBsNOmZYaFdohDrQaUodUFWQD9l89S8feehTNw0awrf3RvCLVSkQ/QCP5hH+Se+izFtJOIrBCmdrJLi+Vw3+SSMDPueaYCUxtL0H0+Z+jwvsbbVkJZdYHuq49bNRAna67xVKAm33ekmFq/J5SPAm8L1mn6sO+TV0ifGN3v9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80sUDZgLqWj9NTbV3MXrxl0hZfKhyGxhpo19Q7lGvJE=;
 b=LyvVGjOfsT0ilfYAK3wGvr/nHbeh66N4QsfV++UxvLdj/qsFSmhvb+oaIaHV2hMBamdO66Sqm5uf+FZyBOOkcAk/iLoP10SmEZeDVPeTVVgVwcq4sx4oQv8emudu3hvPJROVV3krTrBSZqlDD0aG5yBoXfHLdgjuoBZiUOO3znE=
Received: from MW4PR03CA0216.namprd03.prod.outlook.com (2603:10b6:303:b9::11)
 by CY5PR12MB6454.namprd12.prod.outlook.com (2603:10b6:930:36::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 11:34:24 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::81) by MW4PR03CA0216.outlook.office365.com
 (2603:10b6:303:b9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.21 via Frontend
 Transport; Thu, 3 Nov 2022 11:34:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 11:34:23 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 06:34:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 06:33:58 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 06:33:55 -0500
From:   Pranavi Somisetty <pranavi.somisetty@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <git@amd.com>, <pranavi.somisetty@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>,
        <michal.simek@amd.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH net-next 2/2] include: uapi: Add Frame preemption parameters
Date:   Thu, 3 Nov 2022 05:33:48 -0600
Message-ID: <20221103113348.17378-3-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221103113348.17378-1-pranavi.somisetty@amd.com>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|CY5PR12MB6454:EE_
X-MS-Office365-Filtering-Correlation-Id: f52c76f4-2fbd-45ee-dc2a-08dabd8f5b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7EY6xlcnJxW5/65UXoFk4348FnQDpAb7kvGFlW2krM9hXoaDkSzyHzgyAHHUuQWfN81dT3tLDN2qgdP5rLHHDUssrCiPB+TKkStF0l3rYf0cDrS5/5BMJ3LZB1+dV+28mXe64ymyX6BZAb0wRylsfiK6+wA0NmfUl/wluyioxgEhvd0+t6+2qs15Nox/hsgW23cgjk5r1M9OJyG5mMWoXz4e1CqIltN0aLAxbPmMnlWsHD94KddMJgrydPamfMOwWn1G10z7PuJKsqkN7V3HZZO93u+cbx30sZVhxfI83S5RiQxxPJSx21+l60AWeDyo9mT6ZSMaJ7lmvtJr+/6lDtxFmOPEaZ4os1mugVHx6Eq1+VY//3bL19+pHyIb/59ds2lgS8ZFgTHT8arvnDLDJBgjl5Al4v5DstHs+HukpNsEZnHusntrsE2y7p4Xy44AIcYeZdV6PvmIybsvG0NCQS72XOrPExY1gFrFblx21pzUNP1a64ukYYL23VhgRMXb+uzIwD0qi0eQNoZqyuTDvSBJ3AnglhOP8U1yeoXyWBwny2DM/nKZFET9KoQPjtLPxRAlT6/45gRwN9ARBg27yImJy1HmJqDuNRh88DqQ/fK+pueyuWQFUmBRN4Nj2bMtV8MUAuW37RyFOm6DgwT5e1XDFxiLOWzSwS6DEvPR+rUUeZol2WLvvIVoTunQu5s3yJQrlO2pkeQOXY6+gjB95dfwzUhKx6ALahh7WjEhVsbKslJKJSH6AT6tWrZs0TkIT30WAQjPdc/bXG38n7gHv+mswzmqpcv/aMrUpB04TI4vy5LuQtVRXnGNOd6VxeZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(47076005)(316002)(54906003)(426003)(186003)(26005)(83380400001)(81166007)(36860700001)(4326008)(8676002)(6666004)(110136005)(336012)(478600001)(70586007)(5660300002)(70206006)(41300700001)(44832011)(2906002)(1076003)(82740400003)(356005)(40480700001)(8936002)(40460700003)(86362001)(2616005)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:34:23.6643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f52c76f4-2fbd-45ee-dc2a-08dabd8f5b6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a header file for Frame preemption parameters.

Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
 include/uapi/linux/preemption_8023br.h | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 include/uapi/linux/preemption_8023br.h

diff --git a/include/uapi/linux/preemption_8023br.h b/include/uapi/linux/preemption_8023br.h
new file mode 100644
index 000000000000..762fe4dd1906
--- /dev/null
+++ b/include/uapi/linux/preemption_8023br.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef PREEMPTION_H
+#define PREEMPTION_H
+/*
+ * IEEE 802.3br - Frame Preemption header
+ */
+
+/**
+ *  struct preempt_ctrl_sts:	Preemption configuration and status.
+ *  @version:			version for backward compatibility
+ *  @preemp_sup:		Preemption capable
+ *  @preemp_enabled:		Preemption enabled
+ *  @tx_preemp_sts:		TX Preemption Status
+ *  @mac_tx_verify_sts:		MAC Merge TX Verify Status
+ *  @verify_timer_value:	Verify Timer Value
+ *  @additional_frag_size:	Additional Fragment Size
+ *  @disable_preemp_verify:	Disable Preemption Verification
+ */
+struct preempt_ctrl_sts {
+	unsigned int version;
+	unsigned int preemp_sup;
+	unsigned int preemp_en;
+	unsigned int tx_preemp_sts;
+	unsigned int mac_tx_verify_sts;
+	unsigned int verify_timer_value;
+	unsigned int additional_frag_size;
+	unsigned int disable_preemp_verify;
+};
+#endif
+
-- 
2.36.1

