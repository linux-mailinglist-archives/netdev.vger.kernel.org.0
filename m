Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C966450C6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLGBIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiLGBHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:49 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FC311A35;
        Tue,  6 Dec 2022 17:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnzprozO7vDMab3yr7qphYSN/1eVBvAUFs6+NoPf26NxNPS5mh41RFO2YEjjxSAO2monwmYflSSmkamG/w2N41ncKOvsXlxEGns95Qw7OYtJsw1JtxnPytYD9c1IEEMbO5O8tdvC5agGv6Xr0UvoEa+5KidFlzvqcWk8UsC8w+rJYkvif4vWEqoxt4mU4TooOp4m76ilOHHV/cnlUAPSlZxdqYbJseyebak2hf9k1LGvjKd15ocCqAEo1IHDrLSdhLK2n/Idsj+2E86W6JnswuEZ4B6ZHyIerc0QyjDA1sNrCRDQ1Qkiqu4p2y7Cluh8OGobyUCCKCL/oWv9gvAvuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP6uYIfZ93OvAiAOqhXM01aT8PbzLWOa8RwqccXw1Eo=;
 b=U5y1iKMt2b90hLi6KXLyU/g1gT0bwcVkjonxPgiSOMTqdvcbv8AYTjQ2oJHGbgqEvj+CQ1qmy/H0QiPfWlNUGm3MJM4J3exLvnQZM2K4nysPJ5OhCv8MHdK36AsNF1OPr3ZZoOcpPpxYWLT5DeAZnN4Wy/vgRi3YjGR5uau4sFvFl7yWK8iZz/LENHFDUNqqR0MCggF9mqXA34+N4d5rcUjwAEmdNn61na/NRr2+pHhFmVIkEoQ3P8Be3zRoyDl+vEfd5NG+S0cqNy62+xCuM4Yg9SWFDbZoPY+ALCTtZPRylzHrzSbNYhgegZEReN0OrqmGwhkKP3vfcNDwJhmMGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP6uYIfZ93OvAiAOqhXM01aT8PbzLWOa8RwqccXw1Eo=;
 b=h9y/IDRqtpVC5FoJrZBDHy/OlKzLw5VNZo2b95QTBPBr7L1ligSUXf1stV5ITS7dRUHaoA4wsB0wUziipi6TEU0KrpW1Rc3n7aw7FinJtMqE688/eSw28C8GGKAvRfmwYuoJAKlJFNR+u+1eqvIR7AQWAaCwbrRohB0woR5JJkU=
Received: from MW4PR04CA0378.namprd04.prod.outlook.com (2603:10b6:303:81::23)
 by CH2PR12MB4216.namprd12.prod.outlook.com (2603:10b6:610:a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:37 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::8d) by MW4PR04CA0378.outlook.office365.com
 (2603:10b6:303:81::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:36 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:33 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 6/7] vfio/pds: Add support for firmware recovery
Date:   Tue, 6 Dec 2022 17:07:04 -0800
Message-ID: <20221207010705.35128-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|CH2PR12MB4216:EE_
X-MS-Office365-Filtering-Correlation-Id: e49e721a-d147-4f63-9636-08dad7ef6e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SM8I18F15evh1b3bvjMMg+Jln/X2a+/p8bx8KCYA9VLgNOoqVy1P8Cgfq+pe3MonMASQDRoMqOLK6+z5t+EGP4MPRZ+CsZomX7mbM+LJpK3PdgqjKhKV4wc3j2fxWKZCUOcTvTU1hvCQhm3euB9VD8NLGfDJrxAOKdc8FyTA0wfAN0zM+AO0RsRz6KYx4846Ow/lNWAcYruStN4hmi4VJKFM01YYxkubb+HKgB0XqQwTNqZAYZxnyRv15yddB9l+rvHV90y2wOs7jygXPVC2jQykdR6WemZqEM2eKCLU59OwmkFCmejjDeDZKmzut8LatwykRAlmcHra0j5IvpYbu0NWFC+32YBXaZrL7YGiwEugR28Cu5gXnljJ2lPFTKsyBlYfXlfZ7zg/ABKVEUkkVS3off0ytrhfQNagV/zAeAFq9cQDuYTMyaQHgghvFExmtJDvKI6E1oUHWo8UEgU/gRB8DpozWD6bA+4vWR0YNJ0VPBVuknh0uESXer6agdi3wr4ynlQOlguGckHufc4+d6UhQhclJuklZQuRSGG+Gqc4mHv5mOsJ25LlObgTF2vMaN4MPTEw3kwFxTNKgt3Tjx3fWAo3BPb4QcwHpUKsbmalMy326pnSsf9CYx3Dp0hGVMCgBZChqXSHyKuxWO9zQ9I7YBYT7iDC6rxMHo0ESv6ZURC4ooOHACpcrVIz6zcb55vhe+ML5lWkwc9reCxOWSfY3WXWTS+hKRfp7PcX1M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(336012)(186003)(2906002)(110136005)(54906003)(86362001)(16526019)(26005)(2616005)(316002)(41300700001)(40460700003)(82310400005)(1076003)(44832011)(426003)(5660300002)(36756003)(8936002)(47076005)(36860700001)(40480700001)(70206006)(70586007)(478600001)(81166007)(82740400003)(356005)(8676002)(4326008)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:36.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e49e721a-d147-4f63-9636-08dad7ef6e19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that the device firmware crashes and is able to recover
due to some configuration and/or other issue. If a live migration
is in progress while the firmware crashes, it will fail. However,
the VF PCI device should still be functional post crash recovery and
subsequent migrations should go through as expected.

When the pds_core device notices that firmware crashes it sends an
event to all its client drivers over auxiliary bus. When the pds_vfio
driver receives this event while migration is in progress it will
request a deferred reset on the next migration state transition. This
state transition will report failure as well as any subsequent state
transition requests from the VMM/VFIO. Based on uapi/vfio.h the only
way out of VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET.
Once this reset is done, the migration state will be reset to
VFIO_DEVICE_STATE_RUNNING and migration can be performed.

If the event is received while no migration is in progress (i.e.
the VM is in normal operating mode), then no actions are taken
and the migration state remains VFIO_DEVICE_STATE_RUNNING.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/aux_drv.c  | 61 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/aux_drv.h  |  1 +
 drivers/vfio/pci/pds/vfio_dev.c | 34 ++++++++++++++++--
 drivers/vfio/pci/pds/vfio_dev.h |  4 +++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/aux_drv.c b/drivers/vfio/pci/pds/aux_drv.c
index b4da741d7956..e20d8448a978 100644
--- a/drivers/vfio/pci/pds/aux_drv.c
+++ b/drivers/vfio/pci/pds/aux_drv.c
@@ -21,6 +21,46 @@ struct auxiliary_device_id pds_vfio_aux_id_table[] = {
 	{},
 };
 
+static void
+pds_vfio_recovery_work(struct work_struct *work)
+{
+	struct pds_vfio_aux *vfio_aux =
+		container_of(work, struct pds_vfio_aux, work);
+	struct pds_vfio_pci_device *pds_vfio = vfio_aux->pds_vfio;
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
 static void
 pds_vfio_aux_notify_handler(struct pds_auxiliary_dev *padev,
 			    union pds_core_notifyq_comp *event)
@@ -29,6 +69,23 @@ pds_vfio_aux_notify_handler(struct pds_auxiliary_dev *padev,
 	u16 ecode = le16_to_cpu(event->ecode);
 
 	dev_dbg(dev, "%s: event code %d\n", __func__, ecode);
+
+	/* We don't need to do anything for RESET state==0 as there is no notify
+	 * or feedback mechanism available, and it is possible that we won't
+	 * even see a state==0 event.
+	 *
+	 * Any requests from VFIO while state==0 will fail, which will return
+	 * error and may cause migration to fail.
+	 */
+	if (ecode == PDS_EVENT_RESET) {
+		dev_info(dev, "%s: PDS_EVENT_RESET event received, state==%d\n",
+			 __func__, event->reset.state);
+		if (event->reset.state == 1) {
+			struct pds_vfio_aux *vfio_aux = auxiliary_get_drvdata(&padev->aux_dev);
+
+			schedule_work(&vfio_aux->work);
+		}
+	}
 }
 
 static int
@@ -87,6 +144,8 @@ pds_vfio_aux_probe(struct auxiliary_device *aux_dev,
 		goto err_register_client;
 	}
 
+	INIT_WORK(&vfio_aux->work, pds_vfio_recovery_work);
+
 	return 0;
 
 err_register_client:
@@ -104,6 +163,8 @@ pds_vfio_aux_remove(struct auxiliary_device *aux_dev)
 	struct pds_vfio_aux *vfio_aux = auxiliary_get_drvdata(aux_dev);
 	struct pds_vfio_pci_device *pds_vfio = vfio_aux->pds_vfio;
 
+	cancel_work_sync(&vfio_aux->work);
+
 	if (pds_vfio) {
 		pds_vfio_unregister_client_cmd(pds_vfio);
 		vfio_aux->pds_vfio->vfio_aux = NULL;
diff --git a/drivers/vfio/pci/pds/aux_drv.h b/drivers/vfio/pci/pds/aux_drv.h
index 0f05a968bb00..422a42b3ce14 100644
--- a/drivers/vfio/pci/pds/aux_drv.h
+++ b/drivers/vfio/pci/pds/aux_drv.h
@@ -17,6 +17,7 @@ struct pds_vfio_aux {
 	struct pds_auxiliary_dev *padev;
 	struct pds_auxiliary_drv padrv;
 	struct pds_vfio_pci_device *pds_vfio;
+	struct work_struct work;
 };
 
 struct auxiliary_driver *
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 1f09e3be408c..117757be9113 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -26,10 +26,17 @@ pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
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
@@ -42,6 +49,7 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	spin_lock(&pds_vfio->reset_lock);
 	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		spin_unlock(&pds_vfio->reset_lock);
 		return;
@@ -50,6 +58,18 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
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
@@ -63,7 +83,13 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		return ERR_PTR(-ENODEV);
 
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
@@ -85,6 +111,9 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	pds_vfio_state_mutex_unlock(pds_vfio);
+	/* still waiting on a deferred_reset */
+	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
+		res = ERR_PTR(-EIO);
 
 	return res;
 }
@@ -168,6 +197,7 @@ pds_vfio_open_device(struct vfio_device *vdev)
 	dev_dbg(&pds_vfio->pdev->dev, "%s: %s => VFIO_DEVICE_STATE_RUNNING\n",
 		__func__, pds_vfio_lm_state(pds_vfio->state));
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 42bfea448c10..212bb687cf9b 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -23,6 +23,7 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
 	u8 deferred_reset;
+	enum vfio_device_mig_state deferred_reset_state;
 
 	int vf_id;
 	int pci_id;
@@ -34,5 +35,8 @@ struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void
 pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			enum vfio_device_mig_state reset_state);
 
 #endif /* _VFIO_DEV_H_ */
-- 
2.17.1

