Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF77D6C5464
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjCVS7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjCVS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D474EE1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2p1M8Yc/6QYAbrDRqwAZ0vSvAp5/2O2CiGkUITjEAtIQupIMRUU4qaUI2ioymrhkgyhOUwjoBz3ovFog6uBwHDOKcnorIhV3IgVHK+i0UIxqSJEgSlPtzFsU/QWx7VH1VRiNBMj+8xTg71k66P6wpPtHjZXU8PFofHlh2aK/cd2ZR0FQ0DmaG/tGJKC4Aovg1b7nZbBxq1DoG5h1XEwOXbCM/N7M0AUJOhi9XwyqqmalA1a6QQK6/3SmXA2qjuEEfP2l8EBlCWlLJs8aYI3Rr4pESjQ5rhdyz8+rsNj4cRUphy5TxmS6qTuHxZxPyAaYv4GsoS4l4kqepdKPd1jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=id6n7HluWsAycnWsX/VV2eIaYkl01p0UAAedczjkxvw=;
 b=LFXI9dd1qGD7L7nD768Jxu6bkTMY3LWhAOcg59uIQWv+Qs4cRWPQ0FwaJtUQQeKkN9LR4F6DkkkIhc0LBrVGR2gVBzBLpqTbVN9AiMlqoMwA0SMPMpd3pAStqdlcvcy0vY7AhGQWk0NewnYCSJU+imB0AW9Yqi33jy6nIklvujvVcjZC8WZNubdSTnCRGrOX8pnVe6tjTmCzizTIqWYlQHXqngOiDgUAOWEqLbhGr85wVgUXu0RzRuYwZc/5YHN5lvw+8fixnheJT8woLDjS+Om7MeLsv6ypmQSu3J63GNLtHnqdXsD3cSKQG2co/Oq0WKpscz4FNu+JnQAY1QvUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=id6n7HluWsAycnWsX/VV2eIaYkl01p0UAAedczjkxvw=;
 b=NsYX74EBLYNISLr+9XV6wXTU9BtzJntEvuBXOir/ZYA/0glG3iAhB6Qx48K0WOir2Lo6JrawALeZS6z4m5OBTuDGj4BjIvuhRlGG33GpnrkHg6HPb8FLy+qhbV52xcnBYFe+Xv8hjpV6+3Fgo9+h9nP1gkW/VgB+tCjNcCnj0lc=
Received: from BN9PR03CA0964.namprd03.prod.outlook.com (2603:10b6:408:109::9)
 by IA1PR12MB8585.namprd12.prod.outlook.com (2603:10b6:208:451::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:57:00 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::a2) by BN9PR03CA0964.outlook.office365.com
 (2603:10b6:408:109::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:57:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:57:00 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:55 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 13/14] pds_core: publish events to the clients
Date:   Wed, 22 Mar 2023 11:56:25 -0700
Message-ID: <20230322185626.38758-14-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|IA1PR12MB8585:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d17887-3915-494d-6005-08db2b0737b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaNaZdcqyDMHXO0JxsjXfHEYqSR9h87wBAuV2V9oP3+Luf8nC1FtIpYStwsxfygaym7D4hnTk4CAGvYFx+Y8UC5yUBO1X+5tMBi3WQZoBBknx9mg7tTF+ieJ/T3/iJvc8irdKO7dvNP2GEeKQI527PxOkVm3uxYmw299jBk7A3odWXaZ0PgJ17q/sOuLEAYDispkknyrrN04gqtw6AONbwfwdJbcenJcDIm255UoPoF6ngF3I3m/ujepGmoOpNQ4+ji5CBMRrkUQxbNXG0DWuAr0XJgbEA2sH9q5xXRgvsYNGvY/Qi9Bqayal6LDels7folCdOKEyrV2HQ6gsonOR3CpE+MpTcKgCL14Y9NvmRGOi5HhygsaU95JxntgGDzLBhfkaA4xcxrafKKUoROJLP1iwsYOuyVAJ7ULJf2GpwbWgg2ZR54ssWFZlTqJ+1iF1Val0tGvay/LHpeAlCAeuB58EURu+Hs8ACcsD+rwDyCoFUUZbVWUSJui4RB1S9SWRa25wSELfoOikvH+SXh5eiL0c+TRl2zPCOTYY2AYbtys4b32HVHIaOLGpZkF2HYb0ioNul7uxWO8R1scvJDGFiHcPiLAftwGcJui94FmHd0R2dxBZ+VY2GvWR9e5psVSmWFbronQjvpn8QvmIFjKDxHJUJ4AJUEpa3OLm0NjKpaisfpwOebbxF3oG0CCwJxVkPQLYTcHULwQ0mGOOhVx1BpHXmrqo5oLlYTTQ3qk0B4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(4326008)(41300700001)(36860700001)(70206006)(70586007)(8936002)(356005)(81166007)(40480700001)(86362001)(36756003)(44832011)(5660300002)(40460700003)(2906002)(82310400005)(82740400003)(47076005)(8676002)(186003)(26005)(1076003)(426003)(336012)(478600001)(6666004)(316002)(110136005)(2616005)(54906003)(16526019)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:57:00.0293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d17887-3915-494d-6005-08db2b0737b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8585
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 3d82835b4a3d..84405194aa16 100644
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
index 0e3be77d77bc..cbad6ad26421 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -5,6 +5,25 @@
 
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
@@ -505,6 +524,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -513,7 +537,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -523,6 +549,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -543,9 +573,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 9d991c0bca05..9b0c90134eaf 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -306,6 +306,9 @@ int pdsc_start(struct pdsc *pdsc);
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

