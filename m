Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B312E64508F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLGApZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLGApM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEC22FFF9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGJX7jyi8Ie7Hh4LTqsXA9g+aARLV3/eO0DzLN5CQx8e1z46+QoJcRbufZ0/0U0bjNHvjgeM/zgSez8C7uRE6q1eURScRn9b5vBqk34iW58x9S3i2GXAJ7KjSd0VasyyP0KHMGDuK/cycDc6cilqwE8AxU2KDMaFHCaB+z0CccILDOTDaHFqfrF5h8cTfRBJBeo7ew5uLv/LMoi26/eLjG6PbZKuqkkomhOL1Ucsv6ijRUIAjHjggut0WB6lpHOxzMBRu1dQZt2uVwM96hn9mhTTcDij0FH6vSMFs1/4VadWUXrDii6zkyklXvBYqJqd2XTI7ZblU9pWsbo5o2SBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yqtZcnHBZBxfBfsGDJIYSsLt13lHqZVixgPtQG2nEw=;
 b=A889ChKx/cZUniMKFvQlN0qkCh49tEncnIF/Lh99Kq4DGBYjVIYtmqwRikpLHKAB8RefLZL0miUPuHw5Gu4pVpIcckntGa0mop6un3Q+2kgKPU+yNjS5QFJ7hrGHXUiF+tSKSjtmSR+x/PKNfnQkE3O8oBMy8E2YgipxiGsPL94z3heHcIlj5Pu/m9cO7hTOhKMwbXO1mlHIeBLVTeI05PFRNb8OD8IARn7KMD4sKTP9TjbXS1AsMoszOFJjDnSRIdOM+ntuOb97KtcsCnujquXEReAjA+kBcvl0qJEoMZa+LDI5YominBdwnfUIGJoStAB3aQy6BIBIzz1PMwzZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yqtZcnHBZBxfBfsGDJIYSsLt13lHqZVixgPtQG2nEw=;
 b=dZD63r8x9EcWcHih6IzEGe/tHSPj4ZnWNSOTe3wO1l6Q9Dg7dsOrzyKgYy3I8+5XHqyxvO0+c/vZ57E/eajdthmmshdcep66ls/xljMrw5otppzLFpEQnzardYumRoxoBQSqVPsKsNoRovihSXY0hztMWTeDtohioIdlregtNPU=
Received: from BN0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:e6::9)
 by IA0PR12MB7580.namprd12.prod.outlook.com (2603:10b6:208:43b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:08 +0000
Received: from BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::44) by BN0PR03CA0004.outlook.office365.com
 (2603:10b6:408:e6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT105.mail.protection.outlook.com (10.13.176.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:07 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 05/16] pds_core: health timer and workqueue
Date:   Tue, 6 Dec 2022 16:44:32 -0800
Message-ID: <20221207004443.33779-6-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT105:EE_|IA0PR12MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: c70042a3-7f9c-4e1a-3c05-08dad7ec4a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjSdnGJM4BhHnj/4mgw+Rv7wfvWUeRl2aRZJCna2ZIBlnn9whJr/aH35zutailG3CtyYIPriJEfTGkQxadvGaeoG7Fb/8pAFHztbbXIUD2uFkhLvH9oYEtAl4+sETe1+3bYIRhjCwAhwUbp34cb5DjdBL5N3SdbPTOkZXNi+LVQVIt7dHJVmmaL7D0jG0YP02AuLS4fTGIC4Ffof1Hp7Po5Ff8RHp1/Ip81/4x3/IaDNbDacSXz/xD/LP1HWezvn7RznTazMA0Y+/Xb/QqSaruupmTwN6lmwoiqWeXpeV1aJMcBLwUSDIPSXsRADT8fLMJHqRJmrICF7Hi60csuzAzgz5ItcGpEBLWTcJOrgxlnQg7Ti9uG4qRoWC1ZddPnxXyx6u7v9KwmJyVFXoBqWEkcsm7b84fh6M4thdQEfNE9TKcDsR8MHmTHRe0/tolDEHZ5fse6S2MaxpObPMUVk3fOaNdL2skUlXe/JbVVFjFz6n/+NaF4r9WyeZg2Gx9I1QG/qYc8b4j/sGX6wTGqOCuoBn1MgqGnMr1DiWt9SETyh4ILKCh9PpkppDtk5UHRYMCGxE4wSJG7sCcK6iK3Yn++xEu3uTb/AgYoQza/o4u2whT+BIqnDcYpjCeacL0Pz2IFzGz6bcgytNjP2C1s2kj5pA9BKWEOtBPPeXCQ7JNAHEP1gBWm6GxPPpjVvrg80irJx3AZrpoGw14lwXI591ZoK5TGvz+CqkE/ZHP8+6KY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(81166007)(36756003)(356005)(82740400003)(86362001)(40460700003)(316002)(110136005)(6666004)(54906003)(478600001)(44832011)(2906002)(5660300002)(8936002)(70586007)(41300700001)(36860700001)(4326008)(8676002)(70206006)(83380400001)(47076005)(2616005)(426003)(82310400005)(26005)(1076003)(336012)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:08.6935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c70042a3-7f9c-4e1a-3c05-08dad7ec4a6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7580
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
 drivers/net/ethernet/pensando/pds_core/core.c | 60 +++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h |  9 +++
 drivers/net/ethernet/pensando/pds_core/dev.c  |  3 +
 drivers/net/ethernet/pensando/pds_core/main.c | 50 ++++++++++++++++
 4 files changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index d846e8b93575..49cab9e58da6 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -41,3 +41,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
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
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index d0d2c395ba25..f09b6ad503ef 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -12,6 +12,8 @@
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"Pensando Core PF Driver"
+
+#define PDSC_WATCHDOG_SECS	5
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
 #define PDSC_SETUP_RECOVERY	false
@@ -64,12 +66,17 @@ struct pdsc {
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
@@ -82,6 +89,7 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void pdsc_queue_health_check(struct pdsc *pdsc);
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
 struct pdsc *pdsc_dl_alloc(struct device *dev);
@@ -119,5 +127,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/dev.c b/drivers/net/ethernet/pensando/pds_core/dev.c
index 1f1193706407..93433201cfa2 100644
--- a/drivers/net/ethernet/pensando/pds_core/dev.c
+++ b/drivers/net/ethernet/pensando/pds_core/dev.c
@@ -181,6 +181,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		pdsc_queue_health_check(pdsc);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 770b3f895bbb..23f209d3375c 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -25,6 +25,31 @@ static const struct pci_device_id pdsc_id_table[] = {
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
@@ -135,9 +160,12 @@ static int pdsc_map_bars(struct pdsc *pdsc)
 
 static DEFINE_IDA(pdsc_pf_ida);
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct pdsc *pdsc;
 	int err;
 
@@ -189,6 +217,13 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_out_pci_disable_device;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	/* PDS device setup */
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
@@ -209,6 +244,8 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
 			      ioread8(&pdsc->info_regs->fw_status);
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
 
 	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
 	return 0;
@@ -216,6 +253,12 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
 	mutex_unlock(&pdsc->config_lock);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
@@ -248,6 +291,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
+
 	/* Device teardown */
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 	pdsc_debugfs_del_dev(pdsc);
-- 
2.17.1

