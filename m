Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2C6AFE55
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCHFZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjCHFZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:25:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A29B9AC;
        Tue,  7 Mar 2023 21:25:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtfNopwiUSWz1PlkPBQWcAN0Un4XoQK8j4nYQycRb1zOi4GKj2sTvqvGMDhIXjULsVt9tokSDTtHOn6jLJa1E3oUZtC4TW/I4DXAqSiYnGsWEjITvDhxEfmM5D8ycYNzTsJMDA7WziOXayAI4DzG9F7gzOV+xHy6FNU7EixiqnoyxCXJFVPyCor2TFSreMfQ/euIVg53uDo5EjsXkkXUS1zooNZGSRk9ART0UUdnXG4Tt5klYm6W7vLlaetoFJF7pmkWx1eJSZEwKldV277oM5vJn4B96ifuV+hvvhF5AdxXKvbRY9wPayrmdBDyURTL8fg8bxgSje/bQ11aVptOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnG0DauqXcJwwa9zWdvC3hWdc8kG8urzpSftxM2/62I=;
 b=gtMbwnuPwvhtlmLT0b6SPzOmbXtWcN20UKQCuC++r8Fv5/nXVc7UNCphNlnPIiImr3LNL4BwH4JVbw1dsbym7TvpCsOWbkDTeOU6RRbsLNxUKUSVUnE7YHkqgTdTzCc738DS0GLRDbINgY6fAZPcm+TP9fj37ccnHs8E2nE+z5Iky9lZMDYEh1lMVjqcCFRpW9OVE0YGEPxl3UjyROfUOzT540+S23LGTitk2zcEkDVPjHv48Bi1CY7m6hQgptlku2AjSCRJjIGE2vXQKe2luOCmSfs1swFTRPG59BjffVCoQrOYYqA27jpmEskNF0EQofjlThAU8VaLW30MKXJxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnG0DauqXcJwwa9zWdvC3hWdc8kG8urzpSftxM2/62I=;
 b=oO37xL1dSS9SGN1je2sqS3daDdnQKMupW5Nz43bTxGU20v6p2JoVU4cuYfAibLieIkINdy49999EPJ6LlRJNbliYGqpfYYxcd3Nnd7tix5geIkeDVCuK3g4F4zUl7IxuMK9EgH+2lLNMPmbllsTBualSThNBhv2SYzJkVTulaBE=
Received: from BN9PR03CA0756.namprd03.prod.outlook.com (2603:10b6:408:13a::11)
 by CH0PR12MB5187.namprd12.prod.outlook.com (2603:10b6:610:ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 05:25:16 +0000
Received: from BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::20) by BN9PR03CA0756.outlook.office365.com
 (2603:10b6:408:13a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:25:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT108.mail.protection.outlook.com (10.13.176.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:25:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:25:14 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [RFC PATCH v4 6/7] vfio/pds: Add support for firmware recovery
Date:   Tue, 7 Mar 2023 21:24:49 -0800
Message-ID: <20230308052450.13421-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308052450.13421-1-brett.creeley@amd.com>
References: <20230308052450.13421-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT108:EE_|CH0PR12MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: 2164fe20-140a-4f49-a116-08db1f958011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeqCxivHHoAM7XR+2RMV4tFbQkKokLxiVGD5rIu/0c3fH7am9LiVqY7yPaIVul0VYcQQwbohq/w9qlEJILbZFnmADRU/S7zr9s0jzSNl15DRfSni890hdDQwg2mjI487mbsqWNpNsSrKukHJgga6FCvqQ3WsgS7hb6AJ9OM3nAFAJuvrIm9t7qWhFwwQMOgGwasZ/d3WH006cXhiw7WZGPS2UsS9pwnkC0mZxP7rvEJ6O0Et1h0q2Snn658Rf7YBXdI68WAu5vpMy0gZgts3UtMu+bCs++br43uHSfv+Xq9ceUXLwHita1vfjFq9mIvI9ooqlSyVv43nnJfgVYqbfKUDs2gGZw/SXFsMTia0GOaKZzDV0ohx/Uh3Ets1AfC2ZXgnA7iO9z1X6XdIbFmz9AsmtoUC96OHSeXE6+CbqHb24gz3lfnL+JIk83rSx+AFbMR72lhd8pqPfDhlUVG+AzzFjH8AlxUbV8X3FE/qeG25CEhu39+jA6JvVz7a8Kmh0E8TlScd4WNrpsMcMWBGlkU3xcl0o5WmwAmpnEUamT3r710+0UfsLZI15QjgXyXJdwFAiepHZt6/aTAtDlKGQjcLPqc2DvywVtwlYU4D4edUP6XyH6LPHu5T/F8tOZLiAOuAD/iPo4Ws3U6JoorQqVCbdQGvtxACBxI0HbSp9ZxQd7jzZFSvCr3nR81f7x18WxVqGILE0iJQ4/9Qx3hGZ6rArx5RqNO/ltNLA3NxSNs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(82740400003)(81166007)(356005)(86362001)(5660300002)(70206006)(36756003)(30864003)(70586007)(41300700001)(8676002)(2906002)(40480700001)(8936002)(4326008)(44832011)(82310400005)(83380400001)(40460700003)(2616005)(336012)(186003)(16526019)(426003)(47076005)(478600001)(110136005)(316002)(54906003)(6666004)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:25:16.1815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2164fe20-140a-4f49-a116-08db1f958011
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5187
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that the device firmware crashes and is able to recover
due to some configuration and/or other issue. If a live migration
is in progress while the firmware crashes, the live migration will
fail. However, the VF PCI device should still be functional post
crash recovery and subsequent migrations should go through as
expected.

When the pds_core device notices that firmware crashes it sends an
event to all its client drivers. When the pds_vfio driver receives
this event while migration is in progress it will request a deferred
reset on the next migration state transition. This state transition
will report failure as well as any subsequent state transition
requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
reset is done, the migration state will be reset to
VFIO_DEVICE_STATE_RUNNING and migration can be performed.

If the event is received while no migration is in progress (i.e.
the VM is in normal operating mode), then no actions are taken
and the migration state remains VFIO_DEVICE_STATE_RUNNING.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  | 110 +++++++++++++++++++++++++++++++-
 drivers/vfio/pci/pds/vfio_dev.c |  34 +++++++++-
 drivers/vfio/pci/pds/vfio_dev.h |   6 +-
 3 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ec741613f46b..c4acae68b8b1 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -19,6 +19,104 @@
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
 #define PCI_VENDOR_ID_PENSANDO		0x1dd8
 
+static void
+pds_vfio_recovery_work(struct work_struct *work)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(work, struct pds_vfio_pci_device, work);
+	bool deferred_reset_needed = false;
+
+	/* Documentation states that the kernel migration driver must not
+	 * generate asynchronous device state transitions outside of
+	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
+	 *
+	 * Since recovery is an asynchronous event received from the device,
+	 * initiate a deferred reset. Only issue the deferred reset if a
+	 * migration is in progress, which will cause the next step of the
+	 * migration to fail. Also, if the device is in a state that will
+	 * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e. VM is
+	 * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will clear
+	 * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.
+	 */
+	mutex_lock(&pds_vfio->state_mutex);
+	if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
+	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio_dirty_is_enabled(pds_vfio)))
+		deferred_reset_needed = true;
+	mutex_unlock(&pds_vfio->state_mutex);
+
+	/* On the next user initiated state transition, the device will
+	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the user's
+	 * responsibility to reset the device.
+	 *
+	 * If a VFIO_DEVICE_RESET is requested post recovery and before the next
+	 * state transition, then the deferred reset state will be set to
+	 * VFIO_DEVICE_STATE_RUNNING.
+	 */
+	if (deferred_reset_needed)
+		pds_vfio_deferred_reset(pds_vfio, VFIO_DEVICE_STATE_ERROR);
+}
+
+static int
+pds_vfio_pci_notify_handler(struct notifier_block *nb,
+			    unsigned long ecode,
+			    void *data)
+{
+	struct pds_vfio_pci_device *pds_vfio = container_of(nb,
+							    struct pds_vfio_pci_device,
+							    nb);
+	union pds_core_notifyq_comp *event = data;
+
+	dev_info(pds_vfio->coredev, "%s: event code %lu\n", __func__, ecode);
+
+	/* We don't need to do anything for RESET state==0 as there is no notify
+	 * or feedback mechanism available, and it is possible that we won't
+	 * even see a state==0 event.
+	 *
+	 * Any requests from VFIO while state==0 will fail, which will return
+	 * error and may cause migration to fail.
+	 */
+	if (ecode == PDS_EVENT_RESET) {
+		dev_info(pds_vfio->coredev, "%s: PDS_EVENT_RESET event received, state==%d\n",
+			 __func__, event->reset.state);
+		if (event->reset.state == 1)
+			schedule_work(&pds_vfio->work);
+	}
+
+	return 0;
+}
+
+static int
+pds_vfio_pci_register_event_handler(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct notifier_block *nb = &pds_vfio->nb;
+	int err;
+
+	if (!nb->notifier_call) {
+		nb->notifier_call = pds_vfio_pci_notify_handler;
+		err = pdsc_register_notify(nb);
+		if (err) {
+			nb->notifier_call = NULL;
+			dev_err(pds_vfio->coredev, "failed to register pds event handler: %ps \n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+		dev_dbg(pds_vfio->coredev, "pds event handler registered\n");
+	}
+
+	return 0;
+}
+
+static void
+pds_vfio_pci_unregister_event_handler(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (pds_vfio->nb.notifier_call) {
+		pdsc_unregister_notify(&pds_vfio->nb);
+		pds_vfio->nb.notifier_call = NULL;
+	}
+}
+
 static int
 pds_vfio_pci_probe(struct pci_dev *pdev,
 		   const struct pci_device_id *id)
@@ -43,13 +141,21 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 		goto out_put_vdev;
 	}
 
-	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
+	INIT_WORK(&pds_vfio->work, pds_vfio_recovery_work);
+	err = pds_vfio_pci_register_event_handler(pds_vfio);
 	if (err)
 		goto out_unreg_client;
 
+	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
+	if (err)
+		goto out_unreg_notify;
+
 	return 0;
 
+out_unreg_notify:
+	pds_vfio_pci_unregister_event_handler(pds_vfio);
 out_unreg_client:
+	cancel_work_sync(&pds_vfio->work);
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
@@ -60,6 +166,8 @@ pds_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
+	pds_vfio_pci_unregister_event_handler(pds_vfio);
+	cancel_work_sync(&pds_vfio->work);
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 }
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index d49dea3e8cb0..720be3539a13 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -25,10 +25,17 @@ pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+			dev_dbg(&pds_vfio->pdev->dev, "Transitioning from VFIO_DEVICE_STATE_ERROR to %s\n",
+				pds_vfio_lm_state(pds_vfio->deferred_reset_state));
+			pds_vfio->state = pds_vfio->deferred_reset_state;
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
+		} else if (pds_vfio->deferred_reset_state == VFIO_DEVICE_STATE_ERROR) {
+			dev_dbg(&pds_vfio->pdev->dev, "Transitioning from %s to VFIO_DEVICE_STATE_ERROR based on deferred_reset request\n",
+				pds_vfio_lm_state(pds_vfio->state));
+			pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
 		}
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 		spin_unlock(&pds_vfio->reset_lock);
 		goto again;
 	}
@@ -41,6 +48,7 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	spin_lock(&pds_vfio->reset_lock);
 	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		spin_unlock(&pds_vfio->reset_lock);
 		return;
@@ -49,6 +57,18 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 	pds_vfio_state_mutex_unlock(pds_vfio);
 }
 
+void
+pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			enum vfio_device_mig_state reset_state)
+{
+	dev_info(&pds_vfio->pdev->dev, "Requesting deferred_reset to state %s\n",
+		 pds_vfio_lm_state(reset_state));
+	spin_lock(&pds_vfio->reset_lock);
+	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = reset_state;
+	spin_unlock(&pds_vfio->reset_lock);
+}
+
 static struct file *
 pds_vfio_set_device_state(struct vfio_device *vdev,
 			  enum vfio_device_mig_state new_state)
@@ -59,7 +79,13 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 	struct file *res = NULL;
 
 	mutex_lock(&pds_vfio->state_mutex);
-	while (new_state != pds_vfio->state) {
+	/* only way to transition out of VFIO_DEVICE_STATE_ERROR is via
+	 * VFIO_DEVICE_RESET, so prevent the state machine from running since
+	 * vfio_mig_get_next_state() will throw a WARN_ON() when transitioning
+	 * from VFIO_DEVICE_STATE_ERROR to any other state
+	 */
+	while (pds_vfio->state != VFIO_DEVICE_STATE_ERROR &&
+	       new_state != pds_vfio->state) {
 		enum vfio_device_mig_state next_state;
 
 		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
@@ -81,6 +107,9 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	pds_vfio_state_mutex_unlock(pds_vfio);
+	/* still waiting on a deferred_reset */
+	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
+		res = ERR_PTR(-EIO);
 
 	return res;
 }
@@ -165,6 +194,7 @@ pds_vfio_open_device(struct vfio_device *vdev)
 	dev_dbg(&pds_vfio->pdev->dev, "%s: %s => VFIO_DEVICE_STATE_RUNNING\n",
 		__func__, pds_vfio_lm_state(pds_vfio->state));
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 49b0c61fde45..c2d655c8bda4 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -23,6 +23,9 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
 	u8 deferred_reset;
+	enum vfio_device_mig_state deferred_reset_state;
+	struct work_struct work;
+	struct notifier_block nb;
 
 	int vf_id;
 	int pci_id;
@@ -32,5 +35,6 @@ struct pds_vfio_pci_device {
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
-
+void pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			     enum vfio_device_mig_state reset_state);
 #endif /* _VFIO_DEV_H_ */
-- 
2.17.1

