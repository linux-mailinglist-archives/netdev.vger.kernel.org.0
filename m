Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B476DA62A
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbjDFXmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbjDFXma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42BC9ECC
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4H6IS+uvl6QCTmCMsV196Rdsjoh4GfQRkiteKH8vqnM4P+y+9+Yhf9aQYqPK4b/+vW4AkpyckOPMhgDXatFCCegY91L2dP2XknRsELhObBFkPz4aqeuyvPYkej9C+oLcxov053qSwlGE6xSOkRJIXlJ8gUKxb58PCVmowUzecSBF7q11vqWZrdsZMX2Lr6h5Cc1dTDntqP/c4pVZzYn6jTYOh8ipudA3BXJnaZvxFEHYbWx/weU/8Uv8vpoQLFmrF7XWtvCdvQjPPgZhk5rvu1lp8wmgbVALA7u5R+K7fCTKuZSO5G0PY4zugvzVVImoV6B7GqHgMScUUslKA/mLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q74cyxN86Cg+6YWkuxGILyNIPzUgS9QqPeBh1b/qGrs=;
 b=Y/vmE4mvupGQnm41cKdfVZAphw8rYiOR6ywfOb9DpVwQoX0oIH95wuFh+yw2YvPVybyfiWiCOB79Zc1KNQxUtJ+m4l94jQoyg5RZm9Jctd3xQMpwQpxjT5tGtnFBYt8kizJ6GzYbveo/khwooGfT/YJc7LTG0PQY1BUfUT0/xzPKoDi7s6qhLxMqJZHNpbZDV0uuSFF1gnXi/b0cHFe+enewm0TzmOWszxXVzHTPGcZ56HEKowKsLLiwby4t1pN5S/R2sxrYbFzPRHmgNaUfnddJczn1IHV5UPzem0MfranIFZ5QH+1uhW48YPa2Z8c8t9cPwFRuwvfNt/8vjpD6vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q74cyxN86Cg+6YWkuxGILyNIPzUgS9QqPeBh1b/qGrs=;
 b=sWQpgBo5uwOn4qCyScuTLMc+atskycQXM341sb/X2gN344YltKxt8SSTW9pZjHNtbUfC5cFjuIOwelyGowm6sJ8lru6HYGu3tAoSDW7EO5FecCeOszxApn+eH+Ux3rF4zdT96vAtY5J7s8Vx1erVX6h9+aMDo9+0PjZOd+1Dj2g=
Received: from DM6PR08CA0016.namprd08.prod.outlook.com (2603:10b6:5:80::29) by
 MW4PR12MB5643.namprd12.prod.outlook.com (2603:10b6:303:188::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 23:42:20 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::31) by DM6PR08CA0016.outlook.office365.com
 (2603:10b6:5:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.14 via Frontend Transport; Thu, 6 Apr 2023 23:42:19 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:18 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 03/14] pds_core: health timer and workqueue
Date:   Thu, 6 Apr 2023 16:41:32 -0700
Message-ID: <20230406234143.11318-4-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|MW4PR12MB5643:EE_
X-MS-Office365-Filtering-Correlation-Id: 542fd78b-79a7-4800-6e5d-08db36f88fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 468Xqhp8qmoYsfZTMd4+Y1t8r7xMcQSOxmUAwJ8VlLd74OgEEBqeeju+JgSeM8cXwvJJSTqxFmutteyrlE1kQb+8aDJmSuyLy93Lw8J+lVXFabZrZ/lDvEa9+5XUHnyqXZ2H6Yo6r5VuzS5js31y4e5aiHuSVLGBBsBpq1PwOeYutL2RxYLJJEuR6m2bmO6YxlJ6QtYxQWh0HuZkEAoWD/F6p6uT+yOWjbgqI1D5q9g3VnVoUlezeysAK2zFILkDcoLFbiDnW20FfX+PFI0smYgCyOb6unlqSdtS9724Nm4qR7DEYudovd1jjSjhuUs0eYwuAEjlQ477RegkRyLTH7/W1MPBSi0y0gksQZxTaJ4f+qGlaTy/rhmHa8OLk69UpDsFR8D8cKX2s6uHuy9Pw+N8Ci/nRuXpyaHGciqiVuF0ue1yhf+YXltzxETRL9om7awDtvnKkoTkVCkrV/IqTd7tp5+GMo8ezzXD0x19kWDDONjy6ZSe9HbscBH9YRIVufd97P0KuiFG5jsni4MaG6/eo+RLOwikd66OdTvptE70yf4/JQ1wcQ9pvryjeA+fDod28YRQ9bLgKk9v5c+8s2KndwR3zAMa6UO7ckbtWl/WnhrdPLy7j4cn5IigJh7zcvPs77RJ2U/+g1Ny+Jhcf+CPp8KbR/VZTnOBhMvNCffKmhYnl495FvUMgC7eaIQgtkwLGxuuzk91/673JIqwB4lvrYyNjG1Q7uvdvZzFuAs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(46966006)(36840700001)(40470700004)(2906002)(44832011)(336012)(426003)(5660300002)(8936002)(8676002)(36756003)(4326008)(40460700003)(70586007)(70206006)(316002)(41300700001)(6666004)(54906003)(478600001)(110136005)(40480700001)(16526019)(81166007)(2616005)(356005)(82740400003)(1076003)(26005)(86362001)(82310400005)(83380400001)(47076005)(36860700001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:19.5587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 542fd78b-79a7-4800-6e5d-08db36f88fdb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5643
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the periodic health check and the related workqueue,
as well as the handlers for when a FW reset is seen.

The firmware is polled every 5 seconds to be sure that it is
still alive and that the FW generation didn't change.

The alive check looks to see that the PCI bus is still readable
and the fw_status still has the RUNNING bit on.  If not alive,
the driver stops activity and tears things down.  When the FW
recovers and the alive check again succeeds, the driver sets
back up for activity.

The generation check looks at the fw_generation to see if it
has changed, which can happen if the FW crashed and recovered
or was updated in between health checks.  If changed, the
driver counts that as though the alive test failed and forces
the fw_down/fw_up cycle.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c | 61 ++++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h |  8 ++++
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 37 ++++++++++++++
 4 files changed, 109 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 80d2ecb045df..701d27471858 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -34,3 +34,64 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
+
+static void pdsc_fw_down(struct pdsc *pdsc)
+{
+	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: already happening\n", __func__);
+		return;
+	}
+
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+}
+
+static void pdsc_fw_up(struct pdsc *pdsc)
+{
+	int err;
+
+	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: fw not dead\n", __func__);
+		return;
+	}
+
+	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
+	if (err)
+		goto err_out;
+
+	return;
+
+err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+}
+
+void pdsc_health_thread(struct work_struct *work)
+{
+	struct pdsc *pdsc = container_of(work, struct pdsc, health_work);
+	unsigned long mask;
+	bool healthy;
+
+	mutex_lock(&pdsc->config_lock);
+
+	/* Don't do a check when in a transition state */
+	mask = BIT_ULL(PDSC_S_INITING_DRIVER) |
+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
+	if (pdsc->state & mask)
+		goto out_unlock;
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
+
+out_unlock:
+	mutex_unlock(&pdsc->config_lock);
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index fdf171281c87..ffc9e01dec31 100644
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
@@ -111,5 +118,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 52385a72246d..9fdec8adab2b 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -177,6 +177,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		queue_work(pdsc->wq, &pdsc->health_work);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index a762e9a27850..5032fc199603 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -20,6 +20,17 @@ static const struct pci_device_id pdsc_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
 
+static void pdsc_wdtimer_cb(struct timer_list *t)
+{
+	struct pdsc *pdsc = from_timer(pdsc, t, wdtimer);
+
+	dev_dbg(pdsc->dev, "%s: jiffies %ld\n", __func__, jiffies);
+	mod_timer(&pdsc->wdtimer,
+		  round_jiffies(jiffies + pdsc->wdtimer_period));
+
+	queue_work(pdsc->wq, &pdsc->health_work);
+}
+
 static void pdsc_unmap_bars(struct pdsc *pdsc)
 {
 	struct pdsc_dev_bar *bars = pdsc->bars;
@@ -130,8 +141,11 @@ static int pdsc_init_vf(struct pdsc *vf)
 	return -1;
 }
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct devlink *dl;
 	int err;
 
@@ -148,6 +162,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	if (err)
 		goto err_out_release_regions;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->uid);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
 
@@ -165,10 +186,19 @@ static int pdsc_init_pf(struct pdsc *pdsc)
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
@@ -270,6 +300,13 @@ static void pdsc_remove(struct pci_dev *pdev)
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

