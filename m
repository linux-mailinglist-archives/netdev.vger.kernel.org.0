Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8FB6D1399
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjC3Xru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjC3XrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:22 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CBA11E9E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7G4Ot7VlqAsROvPnJ5wVuaC/x2Vc1IV4+fivMXeEfcdgjXznmelu5iiGF/yTXcp/Slily/sB1vjpidYhUq4vpfFZqjcjVNkDKOyUBU/4qCDYM+dPvmP9hOnnLOLDv2Jk/t6+zwWw3Y/l24hqxF7XTwWKiFvgJZgHC6j8mVgTaC/W+57OO38AY6bZvqOsaD+mGZkcs9ZksBkQLQ3Tp/01owrSnLbBnh5QyrHaiWJOgzOWDkTRzMXdM/R+EPybP76BMAnXRxvz/Fnpv85F58QLf9Oa5rAfldDBgRq6/deSfQz4cUL+FbZ7zjrzKTAfWkOT9iPOrLCbxZ0/iUfAV53Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REoQui8jAiVfW3x+WElBgOV6Tn9MhQ9lHewO+5VqLyc=;
 b=favp1so+lUO/i7siVIIqjcx6Y0ZRYKsUWpuqAJU7LJ3+3NtRKXcG/9z3jVcCDs5+jf9MVlwCjRBUncIULBswAcapXjIgYI1SHQ5cgWBxaD0rfON5MZOr+Em4l1ZL7xGsexzuzBSZJ2O/vK+mJRQtujsSv9AKVztoo1yybaIdiNfbnP4NVPrwVQGYzX2+TGLc3hj1Aq5MECxiD2MwwERZ0WuHdZbMhac46u8Fxcsv84rq5FuqC/QM5W52y8Vo0gq8WW9LsGrMhJEHMLFPgn4y/XIhYvfaokY2JQVq4fow08DICc2vxqwb4OFhinu/D95VN4mYGT/exfNyGHqYJEqTEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REoQui8jAiVfW3x+WElBgOV6Tn9MhQ9lHewO+5VqLyc=;
 b=G+ftRPV3rvobrNaAVR2pE+9OdbIkJXW5P4fOQp6GjTBwrumbmjeXT0KDBiHjkXRSW54kWRZf/3V0Gw7YecF2k0SONd7cOpNpX+XhEcFuXJnasgB3xp8ds9FTUZjO+XiOGM2leCOP10sZtmbB8DC1w7prNCb0SZYSPprKNjlYemE=
Received: from MN2PR15CA0014.namprd15.prod.outlook.com (2603:10b6:208:1b4::27)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:46:57 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::ae) by MN2PR15CA0014.outlook.office365.com
 (2603:10b6:208:1b4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:55 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 13/14] pds_core: publish events to the clients
Date:   Thu, 30 Mar 2023 16:46:27 -0700
Message-ID: <20230330234628.14627-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|MN2PR12MB4502:EE_
X-MS-Office365-Filtering-Correlation-Id: a0daaa15-0f50-4841-7655-08db31790c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAyEYF1eNTgSu8mkDV10FFrqHn0Jhruhg9ypdiHUe2l/BGFTl4+Z0zRIhspAC2Dg+mu4T8dcHbG59Aq3aoE3+z4R72C/TNfSLWgX6PRPvZ68A1QEt+uKOrrm6WEEMvgnpK8I+X6K+VUi2CYddwdehysStF5lQLKvDYdHcPF6eTBJ3et12aAFx7AgRpfTH34MNidfSCYkZDLb0vxfAlP1/rvj4PforKUNJoq1cyofhtaXkUVC445NN5HH7OhCNklNwmOrLXx3cF6pXlQwzOQ3YMNHhtFagekgHmWYeSTmJA2ox5GQrAjEjxA4N9jdSzV4BrY1ujx+CLN9eJiSrk/hjZEUTJx0uKsy6qIsnU8KusWh+P9CueGgr5OehcuQ/a4VlkcaGlD39bkgr2SrZB9J7LHq0zwwLlMKYQbR+FSmu3sEUH3mkrdm6BvKyAUlX+3WcLSX1MCjUBI+rzcqtQ+HZLGovmnN/1uV/FxpcDZC+2kgcplyNz78fNyCXN+Z+nDq/+2/oTJziZcn+34fCoIwmWRkNaNeRTpdUfHEclR/Fk5bqNGk3L5cTIX/nXCzHFKAuqiEcMHlR1ECG8LpjDj9p9yIBEmxjiwpOaduuXJAvX3JRZ6oqTjtgYdf5g90/aMivE+3ev7A/JNBkqoWsYpXKd12pM1WswBxfdRSZndz/2M4t/xKf644mBdacSPPdjt3w9l0P1ENoM6tD+lRyGJlWo5NtjTwl/6DDD/eiQ5UTeY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(40480700001)(40460700003)(2616005)(2906002)(5660300002)(44832011)(6666004)(86362001)(1076003)(26005)(110136005)(316002)(54906003)(478600001)(36860700001)(356005)(8936002)(8676002)(4326008)(41300700001)(70206006)(81166007)(70586007)(82740400003)(16526019)(36756003)(82310400005)(186003)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:57.5128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0daaa15-0f50-4841-7655-08db31790c9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index f9fb04308eff..4f86d1a917c1 100644
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
index 6ec9a081fcd6..c63ab76aa857 100644
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
@@ -507,6 +526,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -515,7 +539,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -525,6 +551,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -545,9 +575,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index c5e3ca7e4b08..adeda830c305 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -311,6 +311,9 @@ int pdsc_start(struct pdsc *pdsc);
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

