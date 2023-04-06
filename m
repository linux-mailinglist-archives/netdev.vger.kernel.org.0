Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94F96DA643
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbjDFXnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbjDFXmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F781A5E7
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDlH0UEwgOjhFFd8QGOJE1O37C9EvsSdnYVOfTezdpI1BcbtP4cP9jCQsKVFit4kwFwqqtcsH1cOCzUvnzKoH572E/N1o5BU1ypjFAzb+hadheyl9cktlYguTfKXZ5XyrgAbA8Pgwu5BhwHBEBr1G8fzUj3xx10fcDrcFmrd6CQdQUlFNlCX2nNpKFMhfgNHJM2XfBgn6UQV/+Qrsp2hthmdty3um9vR54su+kj9xFbibm18PhXIBnhZTOYZJWGmG50bhol6m/WnyJd4YlHQlbTpXtSAUVqc7utg5Ti+JgWEBKWOfRzSnKTiO7B2b6MSnoy/vq8ONPIGIjjK9NoIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbJyPdorxOu6OOb5JLLCnS9B4yrOdjVCEBaATdKOQyQ=;
 b=ZyMX1qPmMhWnZKWQQ3CGngnGYg3XXmlVQP6lcb2TsYVzrY7icn9vv2xcontRicgwBjkibu233RtJpcR6q/uC7EveYiWXed4cbfZUD2MY9iGXG0cKo8lgNSO38/iCDe21Q7rmHMfDShwKlqdf8EED3BFrIJDoikwzAEhVSIbHqH35dD7WHCctyU1TAVO7+mW0I66AOfr4Kb8Ytd8CCG6Zf4WNci7c8X4dHiEoVROXEh1TLzlphfyLxGnzrWiPfauC1txaPhMXSP6A8iSKQNcbBMT8RiPhP3wp9dzayltEbRws2nTmtapvGKhuQPWCdpJFJY+pqIpoX3aa/zFsG6j6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbJyPdorxOu6OOb5JLLCnS9B4yrOdjVCEBaATdKOQyQ=;
 b=TPc2xNo4qOfmjlY7upk/jA0qeqqDZWMp+i/evdmkgFZuPUb/rHmZAHCp9Y3VsdT61kBXhOwvbrF5Q8BLTY+aXNbxv1RnP7S5C8UpTjFPDZkp3HVKVnQZESfxherdUwpkfoGkD54mP/0CVhWywlTNNDUr3M7DZSlsWMDcq2ZU8Bo=
Received: from DM5PR07CA0099.namprd07.prod.outlook.com (2603:10b6:4:ae::28) by
 IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Thu, 6 Apr
 2023 23:42:28 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::a5) by DM5PR07CA0099.outlook.office365.com
 (2603:10b6:4:ae::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Thu, 6 Apr 2023 23:42:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:27 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Date:   Thu, 6 Apr 2023 16:41:42 -0700
Message-ID: <20230406234143.11318-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT067:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f5486f-49c1-4d06-032e-08db36f89551
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TnuVB6zqGL87qOs0R/hY+c40JhT/Ni0jMyDBGm1+8hKZydyA0VtEP0YPQFQcKYG/bfoZvin8od6iGTnFFVhJfjZJfld9b+jrzO3Bb/I1sLuR8uBojKpTaQoW7I8gluZzYheNNVBb1wEDLcPHfe4cyNP4UgXhmaCkS9lxxSDQWhQpZ11rSefKuk6w3G9w5AqgL2+eFU5IdwaP0Wy7iZtza1PYufmjHYiG130xwPwtD8leJIIrIQ2gB6o3xcGOxwkOWp6XUzWsUljMLOxuZa4noO8X25Vsk7ZDJW7I1dnJoY5/0mFHbi1gx/iR+iYLYXWf94PiXm0ylkadZkqOR3ZQ0PpRhaUksf5YCL3BsIK974zQcD+ZFKWpoYSGQ9UJgo7wg/yhx/NAzzPnvG4LxO+wuwEqVWZsOtK9iF3KXdobH03kiDK95AhTVNhedrOaOiwW/JZh81ZalMcxD9tunvnVV3gCeuk+feBYuDxgupsnPGAQ8UH8+7g6pVQ9NMwYHkq3HXzk718oBR6u9a0xxfCdZPxAOYpWYsh6WCgXDBAIGFi2Iw3SRqHGh/rYLI8zXii6Zgol04cfkAlbWMpdY/yuzThfLYNMsYpWOLVigwuZX+naW9SsLog/rXRdsvlGhJYLQ10d+BC0dzQXU7cu6wG4dgTBkuqi3kglQzFqR2quDckL7eQr6pe1Srbfwc1v/WoklA9pGFuSKJHeBHWLBJtwOvh+ivXWoBVRmNbNjo6ojhg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(40480700001)(40460700003)(82740400003)(316002)(110136005)(1076003)(36860700001)(81166007)(356005)(8676002)(70586007)(70206006)(26005)(16526019)(4326008)(186003)(6666004)(2616005)(47076005)(426003)(478600001)(336012)(83380400001)(8936002)(41300700001)(54906003)(5660300002)(44832011)(2906002)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:28.7179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f5486f-49c1-4d06-032e-08db36f89551
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

The entry points pdsc_register_notify() and pdsc_unregister_notify()
are EXPORTed for other drivers that want to listen for these events.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 25c7dd0d37e5..bb18ac1aabab 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_RESET, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index ec088d490d34..b2790be0fc46 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -6,6 +6,25 @@
 
 #include "core.h"
 
+static BLOCKING_NOTIFIER_HEAD(pds_notify_chain);
+
+int pdsc_register_notify(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_register_notify);
+
+void pdsc_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_unregister_notify);
+
+void pdsc_notify(unsigned long event, void *data)
+{
+	blocking_notifier_call_chain(&pds_notify_chain, event, data);
+}
+
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
@@ -513,12 +532,19 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
 		dev_err(pdsc->dev, "%s: already happening\n", __func__);
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -526,6 +552,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -541,9 +571,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index aab4986007b9..2215e4915e6a 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -310,6 +310,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
+void pdsc_notify(unsigned long event, void *data);
 int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
 int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
 
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 898f3c7b14b7..17708a142349 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -91,5 +91,7 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

