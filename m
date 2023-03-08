Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57A26AFE1C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCHFNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCHFNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704FF51C9B
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n09xJr/gM+OxFflVu3Hpz3P+XRODPKsWkQZnYK558FZqEudqfPcXU/53i9H0eRYzFufaLJ5hKaeJtZR+9abpw/k4IUMgooEszS8QqQ0JoSJRJyevxkrpGzz+Pl+O8pMDsSTKQBrK9rwwx3SbLINYkDxJJgawdlHpig9HvhU6PTyynAS/U8TkxXisbcsKzeeQj+UerieeyH7xL1SMKSQo/ALfw67U0Av5PBhLv8saUU8jTncTqUaPiPt0vsXT5mYO2xtocqVWhJxfGAYcqNEnr40q+br38htneZUYA0EiXAwFuuonRQpKdiuvCzonjFfOf11Pl4YKouWhV/PLICZAwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fH24t8dCm33pkvYlCBTzYnHO6G3ip05J887x7yfGmjY=;
 b=aiwr3hzremTc0jbbF3MBfI8CMdmQOi12FBGfRB1G/0BaRnqXTiN6SEp3DmBy7nHMd+M/CFDMUofiS5HkzoUEoKB2OtFWIAoKZotR5h9lMPIo34r/x7GQz6Xaj+PHIUVDkq+yMINRmS5S2NPyHj0xu5dhmMSeSP3oJi0sbgnBwYC/zdfOwCVsV51LjdM3bYI11KzWlTqE6t6Nu/wXAWEoH4YvAfMzDQnhM4/xyNKzUw0g/CCKbfMXd8Kses8QTFpmvpUQFOoL8x0twhTJfzbox1J2w3ykDEf5Mtw3GjOas0RHaHYty4QppnNDla6KRLg/+3bsJz9eKP4ZjfyWwnJDBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fH24t8dCm33pkvYlCBTzYnHO6G3ip05J887x7yfGmjY=;
 b=IEVSeW7wD02leTAgmXm+rNcu9Rgawnz59zS0q7wPOBvJvTPttKJzQo5SyPL78BXdLLWdZFKVgbiurTE6WaGLXi3oY0a9pyeOy6gFglaf9QyBtky9FfMBCgtODlQkjyRqsTQ8NC/W8pdP3KfHzlBlm6FrEbFCmUnXl5ywTJKDxBM=
Received: from BN8PR15CA0005.namprd15.prod.outlook.com (2603:10b6:408:c0::18)
 by DS0PR12MB7802.namprd12.prod.outlook.com (2603:10b6:8:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 05:13:36 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::2e) by BN8PR15CA0005.outlook.office365.com
 (2603:10b6:408:c0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:35 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:34 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 03/13] pds_core: health timer and workqueue
Date:   Tue, 7 Mar 2023 21:13:00 -0800
Message-ID: <20230308051310.12544-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT011:EE_|DS0PR12MB7802:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c303c9-4144-425c-530d-08db1f93deb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajUsuS542CCt2t2sW1tXqqe6HRxPzUQV6+OjrBq4qSiiKaDNTk55V39MCAQ65vez4H2JrkCTfMMi1Up3LSGKD+aZH/2nESjtKHiTSIei0zTvSbn8CQhLzBESrmy1s9IyAZgENre4RBSUkRYXPktCCuRqZURVaqmSiXKZkzcWDMhg5IGv3VHI1ytYgIvALKA4FBb8rrDfG50ohx+lvFjFe15b1vrXOK1Zt52qs3+qtBiG7UgO0mRd5/LK8UKFfsR4ZX+I+UANfbEtKGVk1MSVJ355lqcPxFD1zayVIaFh/YJHFd0vyV1UBJCpbEdiKOEnbqP2YBjYCJiZFpknBL6dACQBz3t6GsxyenkhIyrXuI5tW9Op0HfSEcZYGCNfWmZqgBMGUVnIHVx5uvu3x11LDJCV3cRDm9DedD4CxdhBWNeQFh+oswOamGkedTutwpbqITeNvWg8bwjpnJ9Lz3tzXj8UUMt043OcE7G/LySzGIfHOnTxVxJazvoRuVBKZ1aH4yIWzxfj8NlXu3b7rSh4H6APtOt0bXjNfGAwgSVbFg//BtaZT39t+pGf24BYT3PMnseyA/3RI55L73EtSajl2ixkNiTA1H/CAiK33R4BToX33iy9ZlMA3n/fYRaxstTb86d1C3VYTkwXhFRUe5ToURWn129aUBOaUpuuj/dZdl2RwnpYqg2pwBQYcmptCKrd/FxM71YfCWttIPRp+75QTcutEJiaNQOwutnTdBQp2tw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(8676002)(5660300002)(70586007)(41300700001)(70206006)(54906003)(44832011)(2906002)(8936002)(4326008)(110136005)(316002)(478600001)(36860700001)(47076005)(36756003)(426003)(6666004)(26005)(1076003)(356005)(186003)(2616005)(336012)(81166007)(86362001)(82740400003)(40480700001)(82310400005)(83380400001)(40460700003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:35.9667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c303c9-4144-425c-530d-08db1f93deb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 51 ++++++++++++++++++++
 include/linux/pds/pds_core.h             | 10 ++++
 4 files changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 88a6aa42cc28..87717bf40e80 100644
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
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 7a9db1505c1f..43229c149b2f 100644
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
index 0c63bbe8b417..ac1b30f78e0e 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
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
@@ -135,8 +160,11 @@ static int pdsc_init_vf(struct pdsc *pdsc)
 	return -1;
 }
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	char wq_name[PDSC_WQ_NAME_LEN];
 	int err;
 
 	pcie_print_link_status(pdsc->pdev);
@@ -151,6 +179,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
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
 
@@ -167,11 +202,20 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
+
 	return 0;
 
 err_out_teardown:
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
@@ -262,6 +306,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
+		del_timer_sync(&pdsc->wdtimer);
+		if (pdsc->wq) {
+			flush_workqueue(pdsc->wq);
+			destroy_workqueue(pdsc->wq);
+			pdsc->wq = NULL;
+		}
+
 		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 		mutex_unlock(&pdsc->config_lock);
 		mutex_destroy(&pdsc->config_lock);
diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
index da0663925018..e73af422fae0 100644
--- a/include/linux/pds/pds_core.h
+++ b/include/linux/pds/pds_core.h
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
 struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
@@ -116,5 +125,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
-- 
2.17.1

