Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0623F6C857D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCXTDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCXTDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75A415153
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7Q8QrYDcdVAt72A/IFJzE/YXZDfSH9u/880nRPVHH/TSquygo88OGVQC9BH8ld8M8h62bXUx5rwaqEzgYdgCLCDBbhf2S74KuaaYPdzr1o4zkZ23gdIGSOir0jaA/AoeSUXO96yM9Y29km/pn9/uz0wNHAs95yrBMI+wlgAHNa+UFtCbkZ/vDPFRHZY9If/+eE5fnLg2wqFKMPyHB3Vi4l3vBvKP0V6+NxEypavVoVFXAsCT+p/tPqzqeKO+qj8hFiErU8qnRdGDFHrctQxoBGe7T3IGn/dwcA7f6VSC9eC34YPHDK/W2sZhZ6tYQx2UgqacLMr48Ueuf+ClC+B9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UiMzdkmUxaTLk1bvZ5N7uKaFROdr8Yn5ef0KYUOEf0=;
 b=faH6xkt/YsufVmOO7nGde+Kccki5ukEo/E+p7fDtvQIOZ9Jwbw9S3lQb+Bm4E7rIaWZZr1gsZXogVDAKH48qcjeh823xo5H8c993+cVF9TnP73Gw8R4uGU66M89zzJYL4SRueMW0onVdxd95Tw8N2OoYGz6hnbOK3B8Qs2t1kd0515V47tjEUinA42DWk4FfPNkCtykORBCAdZR2wjwdmi/trFkKLvoQMk6wMd7R1HZjU7fqHuybQuBDuRujfA/3ojPT+gPoIwR+QBLBUKRxD628CjIRzuutHBKIR7gPLZGOJguajAiX8Odj0/qk0nv2E00oxfwe315p+jNdov5Mww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UiMzdkmUxaTLk1bvZ5N7uKaFROdr8Yn5ef0KYUOEf0=;
 b=i+LSVnnDOD9U6Gb3gafsXCFJ3l0haaewnkf5JrYME/ThfcJma8FCE1zxyPBS0/L+83+j1BJ7hfCIFof+f6ht/OwM6sI+acEPDv1UmNvYV5ewHyTI4e8B9w6HMSRQQDKE0AbxHFH2xw5cW6Z1h7Wjb7oXkQdlJ4FAJVXYusjVRfo=
Received: from DM6PR02CA0153.namprd02.prod.outlook.com (2603:10b6:5:332::20)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:10 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::9a) by DM6PR02CA0153.outlook.office365.com
 (2603:10b6:5:332::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:08 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 04/14] pds_core: add devlink health facilities
Date:   Fri, 24 Mar 2023 12:02:33 -0700
Message-ID: <20230324190243.27722-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 1acf026f-e908-4eec-c145-08db2c9a6953
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqU/ZOWQQlXyG7E+mGyE+uAUoRZm6ngSnOewEWUXmD7x+LKXS50QhBKZlXad1td+jK203xt1FLvB0VlSBpjr2KrjY49wRgkJp2XVULEgI/P+2zv4V1bu9FshKdfBXW95ifh1VtiFwi1sBXc7YJxnKVDlHQ6ic9rgwyHrgtNAB6aeR9QEe9EY32sBlBqa8MNSMgqG4SnGvEm9xXd3hvciHHfltSZqm/jkynId/6BJ+5sl1uOuyal9OUs6fb0cRSVV7eSea9yQfh3+WQgWOtCnEVrrpLmi/v+xx5LmKZ/qNmH/AU4iq5j1RxqLwAbeAbTXYFcNEPMpKLWUtf5SqrY7ul+0R3IrFQBBra1io5d043cEE8S+TcM/dqCaLWoscmvh68VYpOmciP6YyPsYZgxevqh74azvpf9iCkrsEgguosEUNqXsMcJrCwna2aBygPVkrZQ2gu5O3sm4c/YiVwLLFGyreq4w16R8FIEy0dOhqCXRSRcvx1XifI2LJZhERIdIIHni9jKVaLkmXZPp9ZB9dEnVkzITiA9nUv/GL/yoOTy3Y7IU3xki8pOw6btO0wj0bUyRXNZG/7DtDdQh4zZijyBNQQjimdTQFn4UvuoyGg2puOdcb5pEpbdrTz3bTO9zNEfFGR0toawastwsxUBIosn+ey2mpz/QFKx3oYEgDeztowsNIFZlJhFl94l3yyGs1L3w+aulcFrX9tARVpO7ldpYrfyJl/cBgvf6T4nZIFw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199021)(36840700001)(46966006)(40470700004)(70206006)(4326008)(86362001)(41300700001)(8936002)(8676002)(70586007)(110136005)(82310400005)(54906003)(426003)(316002)(2616005)(44832011)(2906002)(36860700001)(1076003)(16526019)(478600001)(26005)(5660300002)(356005)(40460700003)(82740400003)(36756003)(81166007)(336012)(47076005)(40480700001)(186003)(83380400001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:10.5958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acf026f-e908-4eec-c145-08db2c9a6953
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/devlink.c | 65 +++++++++++++++++++++
 3 files changed, 73 insertions(+)

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
index 29cec08bd795..1254f088955f 100644
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
index a9021bfe680a..fabbf274b223 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -14,6 +14,67 @@ static const struct devlink_ops pdsc_dl_ops = {
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
+					pdsc->fw_status &
+						~PDS_CORE_FW_STS_F_GENERATION);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Generation",
+					pdsc->fw_generation >> 4);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Recoveries",
+					pdsc->fw_recoveries);
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
+		dev_warn(pdsc->dev,
+			 "Failed to create fw reporter, err = %pe\n", hr);
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
@@ -38,6 +99,9 @@ int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
 
+	if (!pdsc->pdev->is_virtfn)
+		pdsc_dl_reporters_create(pdsc);
+
 	devlink_register(dl);
 
 	return 0;
@@ -48,4 +112,5 @@ void pdsc_dl_unregister(struct pdsc *pdsc)
 	struct devlink *dl = priv_to_devlink(pdsc);
 
 	devlink_unregister(dl);
+	pdsc_dl_reporters_destroy(pdsc);
 }
-- 
2.17.1

