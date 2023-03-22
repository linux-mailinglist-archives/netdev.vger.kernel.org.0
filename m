Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90AC6C5461
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCVS7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjCVS6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBE86A9CB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzbnBRR+FqS7TYxC3HPYjPJLEFt87efXCj3CTsiZ0YnHbrZU3p+lOwCYkehEmp4llbtU61lEioHiwHbbsGh5YE7o+pGpR+Ynv2AOxhZb0daeYfTlkBipWl47ktE7g93Bgphv3Xo0DLNc3P7sVZ5xtE35pinWi6z0oYcJqul8ICCfjtuWtivAh9gQEd6BcjBZqS/QlTaU1/R2LeYtgb5ol/RdwPo/LlLK9BJtIQINWpdG5R3zs5iKzzpRR5ZJ6cAs+X0KnsXBRMeWl4L6Bvls1XPc51AGcfTZv9u6jqIlUrCYzeWNW90kn77L4CBWTDNbGAuHPAWsm9/znHNTMDPUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJmU2JIf0YUeOiDZxyfsDuFzmYo1QOk/KGAgLKuQ7IQ=;
 b=oduALRdgfA7jGwObq0wHPfaSQgC8OcGYc4hRgTikDB2zsFEkrHNXzGjxAP4OLUOE8Y/mTF1OiaFAmkv9xUYM6z6BLc4Uila0R65/PHw3Bu4gjMJWpmvvQFP1K4UIln3MiweMArsWceZg/K1sXNDStX8B2d9fYDHKkjn7FjJ2wt444V9o8lopzYmt1AFj1N38LugF5H11mLcEenvbwfsWu7L19e8mv6W8UG8OA8cC++gpzhC5x7Ywr0pIWF8RuvenCA7rS97cSlHDK+OTzBINmgxkJo63+cZ+rWg3qnS4kJJuhZ/PMWf0/XM6tIUENcn5GYLlLQ9MPYSY5YQ2RVv+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJmU2JIf0YUeOiDZxyfsDuFzmYo1QOk/KGAgLKuQ7IQ=;
 b=ZXypN7bkv9bJGsswKwB/f/1PHYYZqhIlKBPZJV0FjAWsSICtg/QtF2tyYsZL1HkVKxpwwpWSmOvY90YG1HITUqiN26PHgo2D47F/jsO/PmA98BQIM4l2p+lLtAwfEtpHAVpheGf1jY9v0iCsLQenovZ024sbFuDBvqh5rpBiBqE=
Received: from BN9PR03CA0411.namprd03.prod.outlook.com (2603:10b6:408:111::26)
 by DS0PR12MB6558.namprd12.prod.outlook.com (2603:10b6:8:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:48 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::47) by BN9PR03CA0411.outlook.office365.com
 (2603:10b6:408:111::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:48 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:47 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 04/14] pds_core: add devlink health facilities
Date:   Wed, 22 Mar 2023 11:56:16 -0700
Message-ID: <20230322185626.38758-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322185626.38758-1-shannon.nelson@amd.com>
References: <20230322185626.38758-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|DS0PR12MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 42451b63-cec0-48b4-d6d5-08db2b0730a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXHqJ70+8DQANUZbfaYPoKMajWeY1vOPPvFwdgtqtoAaypL0wx+2i/+P2LeDM0AEv1HpnQQ7qtCxVwQzwN8gymjsd3gPYiPkokt6y8ercM3iYMiDo42o5lbMwC4O4+hoaYd8GCPH3dxzP+Vxq0Fi8kebbGcGLlFjnWeQRw7MOqyIgkb6BFYB3GWkeNtd4RWkGkB/v5/3tZaxFjMtRp5atjMyPbJMVu/SW3Ve9QasniIDdegrmg127cL0KraricGBniqahZWQiS5zYhP56tWcU9qS2QCj5laJRo90P+EnAuaKcDUQRG5pjkxq3Xu+ojAXBHHNw+f5xpBsUCkcS4N/3f/uhnvme9fVvRC4+BXFF1p7Mb/USpKFZRbBdDx8O9y/wEpPiGXjojPjqzwLR4Ebjam/vvGa7I91C8+9EuUaV40q9l9JEVS2eFmaMe3V7EaTfcrKegJAlm8aX34kZawrujd+GR5mMitspM6l//X1QADHLEZf0/qV+xltuD3MU7GiUY/6f2LxgO7edLy0L76ItaNNhopB5Bast8S8TlcKrjENe1x7pFDmvE78LFaRQwUi/6mn9fFHirRGOB6ROanDbC+j+WTrp7FBZGLvDRMXEL9mruwqFRUD3Vehx8hIgi3fFd3fu40MI5O36BSheWqCGcrntdPZKq0oMl7h7tkA7jIKCv4F2YtJUBxljkEqS6fx5QwEWFOtQKDG+e1CQ/oZduXzxV/0AokY3c1bqquvHPM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(426003)(2906002)(82310400005)(36756003)(83380400001)(8936002)(40460700003)(86362001)(1076003)(44832011)(5660300002)(40480700001)(26005)(186003)(41300700001)(2616005)(356005)(16526019)(82740400003)(36860700001)(47076005)(6666004)(478600001)(316002)(54906003)(336012)(110136005)(8676002)(70586007)(81166007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:48.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42451b63-cec0-48b4-d6d5-08db2b0730a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6558
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink health reporting on top of our fw watchdog.

Example:
  # devlink health show pci/0000:2b:00.0 reporter fw
  pci/0000:2b:00.0:
    reporter fw
      state healthy error 0 recover 0


Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c    |  6 ++
 drivers/net/ethernet/amd/pds_core/core.h    |  2 +
 drivers/net/ethernet/amd/pds_core/devlink.c | 61 +++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 39e9a215f638..a9918c34018f 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -45,6 +45,8 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 
 	mutex_unlock(&pdsc->config_lock);
@@ -68,6 +70,10 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	pdsc->fw_recoveries++;
+	devlink_health_reporter_state_update(pdsc->fw_reporter,
+					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index e73af422fae0..0cf7810ba9de 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -68,6 +68,8 @@ struct pdsc {
 	struct timer_list wdtimer;
 	unsigned int wdtimer_period;
 	struct work_struct health_work;
+	struct devlink_health_reporter *fw_reporter;
+	u32 fw_recoveries;
 
 	struct pdsc_devinfo dev_info;
 	struct pds_core_dev_identity dev_ident;
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index a9021bfe680a..a5a243bed5bc 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -14,6 +14,63 @@ static const struct devlink_ops pdsc_dl_ops = {
 static const struct devlink_ops pdsc_dl_vf_ops = {
 };
 
+static int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
+				     struct devlink_fmsg *fmsg,
+				     struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_health_reporter_priv(reporter);
+	int err = 0;
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "dead");
+	else if (!pdsc_is_fw_good(pdsc))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "unhealthy");
+	else
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "State",
+					pdsc->fw_status & ~PDS_CORE_FW_STS_F_GENERATION);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Generation", pdsc->fw_generation >> 4);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Recoveries", pdsc->fw_recoveries);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
+		.name = "fw",
+		.diagnose = pdsc_fw_reporter_diagnose,
+};
+
+static void pdsc_dl_reporters_create(struct pdsc *pdsc)
+{
+	struct devlink *dl = priv_to_devlink(pdsc);
+	struct devlink_health_reporter *hr;
+
+	hr = devlink_health_reporter_create(dl, &pdsc_fw_reporter_ops, 0, pdsc);
+	if (IS_ERR(pdsc->fw_reporter)) {
+		dev_warn(pdsc->dev, "Failed to create fw reporter, err = %pe\n", hr);
+		return;
+	}
+
+	pdsc->fw_reporter = hr;
+}
+
+static void pdsc_dl_reporters_destroy(struct pdsc *pdsc)
+{
+	if (pdsc->fw_reporter) {
+		devlink_health_reporter_destroy(pdsc->fw_reporter);
+		pdsc->fw_reporter = NULL;
+	}
+}
+
 struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf)
 {
 	const struct devlink_ops *ops;
@@ -38,6 +95,9 @@ int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
 
+	if (!pdsc->pdev->is_virtfn)
+		pdsc_dl_reporters_create(pdsc);
+
 	devlink_register(dl);
 
 	return 0;
@@ -48,4 +108,5 @@ void pdsc_dl_unregister(struct pdsc *pdsc)
 	struct devlink *dl = priv_to_devlink(pdsc);
 
 	devlink_unregister(dl);
+	pdsc_dl_reporters_destroy(pdsc);
 }
-- 
2.17.1

