Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A11F6D0EA4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjC3TXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjC3TXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:41 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D98E19D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrQe3ZbFb1BuFbG2mhRVMbFYk6AlHDa7vYHxDF1rUIQeikw453HNyFFgB/D5gZobnt9WOkElNVc65eOt7CBkmvdtNZa1gknNjtoQGoEDfOhqye5ja6F52qPQBGsGhAmuEP+1rU6Qbp30uXMbCijPbXDVBWvYhyX1JvTBQjDUPY0FR19wFVbmJWu7SlNQvFm1NX+q5GMvw2oMZyOS2xP+uyIK86bHMOVKDHSXirhnGBD5/W/uUq8f952UXy4U7urNnB4miRqytqFos1iVv2wrS2qP+s+T9Vxs584vQGxdXxZSVaYLzB4NziC3XhUdDG5k43WgqzCCLdkSdCt68Z/YmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjrxzfB5Jzyv5M55n3uPvnJzD2oXWUFajuPHcmq1dAI=;
 b=hlkOk1Ok0B7pw6MEwE6coGMKsnQZftyRt1+VjZpJQM1532oeTL/MdfjJjpeYWss7Xyk2dAqwMJPGFQBMqxMc1vvq9lQEYDoSVMVgryv8pRzvVtwKnrmsZsP3xhGYDyX9tLn9pPvmLaWO9JNRztiNYHXx6XnUr2sQ/ClehaQlfh+lkMKEvdW1bD7SiwO74LqdZxjYwKuKOTWRc723VlTAFVWX//LNrPEZQWD2Zf7J7zpRtVzcVf4UjpWleL25K6ORqsv2IATPY5KO3Rg8w7wWNovCKcd8RlnYpPO3mLH0U+K5nizak6uejjBxnsSiTpLxpwI8Sa1lo0VV98rvEg0CuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjrxzfB5Jzyv5M55n3uPvnJzD2oXWUFajuPHcmq1dAI=;
 b=xPUF5JxGwBwBoaMA1YN5T65R6SlmgVuO4k0/pr2YvPZhk3aUDzUROv5HnyA83hzPCd9Yqx8PgKd7UZ8Kgh0IRh7k/pgFi4nDxMgAnVw5q3KkrR11jkkoN09uNRnDe4BTNCPFKTXFPOXhRXju9hDSnvBSGWLLbUY5FHv0rMU4it0=
Received: from MW4PR03CA0057.namprd03.prod.outlook.com (2603:10b6:303:8e::32)
 by PH7PR12MB5855.namprd12.prod.outlook.com (2603:10b6:510:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 30 Mar
 2023 19:23:35 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::9d) by MW4PR03CA0057.outlook.office365.com
 (2603:10b6:303:8e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:31 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 03/14] pds_core: health timer and workqueue
Date:   Thu, 30 Mar 2023 12:23:01 -0700
Message-ID: <20230330192313.62018-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|PH7PR12MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: 259b7360-641e-49c8-2fc3-08db31544183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvPXoy8qCK83BjCYIvLWEI+glTgYU1igS9AXHFXcJMcSGgq6h+Hwj9SwZ6rZ6f9BbD167drAgz1sjygWM40sxnYoRAMbuOPGp6lYBto2bbm2ISc0wjtpASIOSqnHaS2jms8tQ/oTc6Q5KIoAuxYQXpHrXwYLgby3P72CvitVS/Acp9UOVzOhbsDrOruFQkkw1sP+gKKDTcS5giGEqsNoc9dqFd1UozgagRS+z0De4eZRMAhrXNBiPsejzaj2gJzRU359IfBGWCzj40XCV0trgr9BsoOLQugpnMM8ep0dM/S16y0AnzdDMgkWFl05VMEcV8z0/fpaFcIZue4r0ikD0LOuRfhj2gBCPMxYcJwZtQ08C6eUoP2LlYjO7ie+XRHSXh7cd5kYGWd8IyD+K+N+/EmvsQrEFeIt8qvRSQc80JVi+8W5YUTeoI3OesQ5p/aP1Ers2aV6NIRKZQpqbUtf//Vv8tsfivqqzJzqB5hJCWD2IOx7ry3Tc+6F1tUUOcgFlTvbSlLhS8Wu8Md9RG68S4nuScbULl8WSiaRUAiEB4wWhjNU/ldD5xxIpGI3XRR44071afjPhuRKm/0wJQYEEKZbrVCEOTEwkeBdXmnDdZF0C10g0LsJh1Cm+kaN0mUW/ZA7tRQ+LQ8Ypkbu4MRk3Eb15MXK/K6syaNiZ1BZXiaWcHN3B4Drm6KqaSFlloAnhrJLed6W6g24ueCYgnLniPVuKPdtVSjC6BqlPLpXo6M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(356005)(8936002)(44832011)(2906002)(81166007)(5660300002)(336012)(82740400003)(86362001)(41300700001)(26005)(70586007)(6666004)(36756003)(1076003)(83380400001)(4326008)(70206006)(82310400005)(186003)(16526019)(478600001)(8676002)(2616005)(36860700001)(316002)(54906003)(426003)(40460700003)(47076005)(40480700001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:34.7625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 259b7360-641e-49c8-2fc3-08db31544183
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5855
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the periodic health check and the related workqueue,
as well as the handlers for when a FW reset is seen.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c | 60 ++++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h | 10 ++++
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 51 ++++++++++++++++++++
 4 files changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 80d2ecb045df..39e9a215f638 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -34,3 +34,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
+
+static void pdsc_fw_down(struct pdsc *pdsc)
+{
+	mutex_lock(&pdsc->config_lock);
+
+	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: already happening\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+
+	mutex_unlock(&pdsc->config_lock);
+}
+
+static void pdsc_fw_up(struct pdsc *pdsc)
+{
+	int err;
+
+	mutex_lock(&pdsc->config_lock);
+
+	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: fw not dead\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
+	if (err)
+		goto err_out;
+
+	mutex_unlock(&pdsc->config_lock);
+
+	return;
+
+err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+	mutex_unlock(&pdsc->config_lock);
+}
+
+void pdsc_health_thread(struct work_struct *work)
+{
+	struct pdsc *pdsc = container_of(work, struct pdsc, health_work);
+	bool healthy;
+
+	healthy = pdsc_is_fw_good(pdsc);
+	dev_dbg(pdsc->dev, "%s: health %d fw_status %#02x fw_heartbeat %d\n",
+		__func__, healthy, pdsc->fw_status, pdsc->last_hb);
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		if (healthy)
+			pdsc_fw_up(pdsc);
+	} else {
+		if (!healthy)
+			pdsc_fw_down(pdsc);
+	}
+
+	pdsc->fw_generation = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index a796d1ae7baa..8ff65f2aa7f0 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -12,6 +12,8 @@
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
+
+#define PDSC_WATCHDOG_SECS	5
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
 #define PDSC_SETUP_RECOVERY	false
@@ -63,12 +65,17 @@ struct pdsc {
 	u8 fw_generation;
 	unsigned long last_fw_time;
 	u32 last_hb;
+	struct timer_list wdtimer;
+	unsigned int wdtimer_period;
+	struct work_struct health_work;
 
 	struct pdsc_devinfo dev_info;
 	struct pds_core_dev_identity dev_ident;
 	unsigned int nintrs;
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
+	struct workqueue_struct *wq;
+
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
 	struct mutex config_lock;	/* lock for configuration operations */
@@ -81,6 +88,8 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void pdsc_queue_health_check(struct pdsc *pdsc);
+
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
@@ -111,5 +120,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 52385a72246d..292deaffe8d6 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -177,6 +177,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		pdsc_queue_health_check(pdsc);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 590b21ddba71..c73862898fb9 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -27,6 +27,31 @@ static const struct pci_device_id pdsc_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
 
+void pdsc_queue_health_check(struct pdsc *pdsc)
+{
+	unsigned long mask;
+
+	/* Don't do a check when in a transition state */
+	mask = BIT_ULL(PDSC_S_INITING_DRIVER) |
+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
+	if (pdsc->state & mask)
+		return;
+
+	/* Queue a new health check if one isn't already queued */
+	queue_work(pdsc->wq, &pdsc->health_work);
+}
+
+static void pdsc_wdtimer_cb(struct timer_list *t)
+{
+	struct pdsc *pdsc = from_timer(pdsc, t, wdtimer);
+
+	dev_dbg(pdsc->dev, "%s: jiffies %ld\n", __func__, jiffies);
+	mod_timer(&pdsc->wdtimer,
+		  round_jiffies(jiffies + pdsc->wdtimer_period));
+
+	pdsc_queue_health_check(pdsc);
+}
+
 static void pdsc_unmap_bars(struct pdsc *pdsc)
 {
 	struct pdsc_dev_bar *bars = pdsc->bars;
@@ -137,8 +162,11 @@ static int pdsc_init_vf(struct pdsc *vf)
 	return -1;
 }
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct devlink *dl;
 	int err;
 
@@ -155,6 +183,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	if (err)
 		goto err_out_release_regions;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
 
@@ -172,10 +207,19 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	devl_register(dl);
 	devl_unlock(dl);
 
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
+
 	return 0;
 
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
 	pci_free_irq_vectors(pdsc->pdev);
@@ -277,6 +321,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
+		del_timer_sync(&pdsc->wdtimer);
+		if (pdsc->wq) {
+			flush_workqueue(pdsc->wq);
+			destroy_workqueue(pdsc->wq);
+			pdsc->wq = NULL;
+		}
+
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
-- 
2.17.1

