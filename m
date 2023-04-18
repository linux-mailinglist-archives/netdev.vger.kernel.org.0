Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF496E55DF
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDRAdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDRAc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:32:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A758448B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:32:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/3fqdqg51w/Q711h2un/09RS/G0kQkk3fTSD5Cp9KFfnTQeHNEbGtTRboRZidFcFTRxI6fdbZIKOq7RAYPxtOKexoTKx0Yz7BqxAn9KXOvXxI50fHa0ss0zk+XW+JvvgQbAZBAGh7Cuz3IaTaV0cIN9oM0kvuvI5NL1K2fRu78emO8FgLnlsgKfXXdJEFMsqSNuR2yZyg5Rh73muekJkh70SkHCAXyzN9waZOevoLdDA1NljXYWw7Z4965L02c9WdAbZvUVemeVvnh2FXzPxmoa3TnJ/1LT4LU5u+PDRW9RRf6Bi0JGmNekhM3odBhdKhVwfOATiG2cCOINMQuO9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sovCeb6UyLVl0NznqwjCJ74e3CuHaQs3Uk8Et7U7qCU=;
 b=Z1sl6MPy0IUbpglqFaBerhuNacse9DvQ+3k2yOC2+DEsQ81uPwfhVgIGKDpX0IDbIG+SCP8kPjzveTTr8Wr6y+eEEFNCNhPI6nYAWMHGZBaw50du1/4HbDG1QTExMCZJlbXXRW8jk++EPBJUTyNFJi85jq6PopKUOR08JwoIh1PkV1RxVT9DmcTBLQnP5dEmaqDO+fqwUQf7ku/ry5Ch4Xzq5odc/FF7OZzWEZ8yrUZ5oUMLNDuKGypz4nV6QObtDouD2/9VdA0HagN20niUYQb6h797CMFhXRVLX3Lu3Xg73sFviCN7W4K4tIiSmQWdLNAGZQFEas4T9y8ri/s4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sovCeb6UyLVl0NznqwjCJ74e3CuHaQs3Uk8Et7U7qCU=;
 b=g0Jv9XyYuIyr6bMBT2b9zAHgH1yS+ZGkGoHzt93r/5lWnMaK8B/pypfkJNyz4zSmcbYmlVrQfjKHfzl0vcVF/Vb0cm3PXbK36uX2rcCiOavsaxKIGJVSousY41KoThyFkavT7J1hc4hI2BMomQ2o6iV+TEJI0+IEzYShDGVwI/8=
Received: from BN0PR08CA0028.namprd08.prod.outlook.com (2603:10b6:408:142::27)
 by IA0PR12MB7774.namprd12.prod.outlook.com (2603:10b6:208:430::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 00:32:56 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::f5) by BN0PR08CA0028.outlook.office365.com
 (2603:10b6:408:142::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 00:32:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:32:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:32:54 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 03/14] pds_core: health timer and workqueue
Date:   Mon, 17 Apr 2023 17:32:17 -0700
Message-ID: <20230418003228.28234-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|IA0PR12MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3e724a-e0ba-4d46-207f-08db3fa473e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XrREzMyAWxVuHkUNMZ4cu8FSycY2FL8vv7sSuIRa0r/4yhfaIgbWoJDIksKQ36V9CY4ySS/DbTlE40VitsTl9putjzGlyCeR8O/iAFMKA3ooi1anGj3ChgD/CBTz7nqIyeERd41dGeENU2WEYn+xD9ww5NVB7m5GjRLAXRa5qTh/Un+xd0nKVb5ua0kO238DUlzR6RGaYuz8DkKhAoJQIGNkRTqsW1cWMMKZ+0u9u090o1btWfigFcVZoSwrE/dFgSzAUwIBickrKyzv/seTx5FRhMf4fdR+VayBfDatodU8jp0qdkYZCVEbtcQoPS09Mpo217G9lv7nPF8tavVh6QhBKZ8EXcqlpbbN8QyABxKbqSeSTleLbRn7mcOSKSVKrHIIk6o93VoGJrcLPCEBwefcDOQeR4smdiyi/P1buXHSPPJiPf2G4dAMeI2o+kbi++ja5IHkaOF8FfxJj3iHJz+RR88YNCiBnKCKAy1kUZQX8F/mU3L8Kwo17UYG9ykWI6kbJf4nBtySlfX+4gcHw9JFvPVc1IojmdwakZdb0hi0/3jCT6pn9hA6OOjrr0J5evUbR3bgqmFEsEZH86wshchcIdBc3NaWHux9r2m258FjksWyCioQYfvbxplITReNgPUPo0SHKRFb1Lrp28vSlH2fNkzP2EByr+g8Aq9xFAboyUYlJv8wDhVdPEGx5EgDs3tgd29LrEnKL55kHM+pvyt00/ejOifa+PKca6uiZ1g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(26005)(82740400003)(81166007)(16526019)(40460700003)(356005)(186003)(8936002)(44832011)(1076003)(40480700001)(426003)(336012)(36860700001)(2616005)(5660300002)(8676002)(36756003)(110136005)(478600001)(316002)(86362001)(54906003)(4326008)(70206006)(70586007)(41300700001)(6666004)(47076005)(2906002)(82310400005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:32:55.4589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3e724a-e0ba-4d46-207f-08db3fa473e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 61 ++++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h |  8 ++++
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 31 ++++++++++++
 4 files changed, 103 insertions(+)

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
index fcf6c6545c49..83c528a2a131 100644
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
@@ -102,5 +109,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index f082d69c5128..f7c597ea5daf 100644
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
index 09afb069dcb3..c9fbf1d374a7 100644
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
@@ -119,8 +130,11 @@ static int pdsc_init_vf(struct pdsc *vf)
 	return -1;
 }
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct devlink *dl;
 	int err;
 
@@ -137,6 +151,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
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
 
@@ -154,10 +175,16 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	devl_register(dl);
 	devl_unlock(dl);
 
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
+
 	return 0;
 
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq)
+		destroy_workqueue(pdsc->wq);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
 	pci_free_irq_vectors(pdsc->pdev);
@@ -259,6 +286,10 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
+		del_timer_sync(&pdsc->wdtimer);
+		if (pdsc->wq)
+			destroy_workqueue(pdsc->wq);
+
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
-- 
2.17.1

