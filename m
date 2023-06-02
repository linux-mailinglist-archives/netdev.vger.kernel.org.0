Return-Path: <netdev+bounces-7584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A516720BB4
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2143280C25
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701C1C2C2;
	Fri,  2 Jun 2023 22:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C61FC15F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:55 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BBF1B5;
	Fri,  2 Jun 2023 15:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKkkN9A4Qklk0vZUHBl6eSadDp45HXwJoACrCzWCtNCEO/zDaKWpLTfWa0qAj1cirfbnUw4AfTopKpz5CpeK7tBRec84A25m7liDPAQtl8pqw7VnCvsOriusgaqxZC657Tw3zAaIDOVVa0+mGodVdh8W2+jJWh4rCDRoUQSjhXRPBtgVH9rNtw+8o4oqZh1MhXPH/I5DiixUUlOmA8pka7WfynIWN5/j1VEPBAdnzz72ZwwMvwMyCbdjsv+6xa7PQRyi1U3oWpKUJG456oI2vRiwZPzcCCW3NIEZaKyAvzz5YDC9BW5hfoe605KVN/8lzf8LL+fT61pHDGbPIupIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jXU6SOYTG8SHVYISUqeKRSGzS5mfo45pGP2HDnqj2I=;
 b=LlwLggjJntO3ThRx9NOqpsv81Tu7Q9JAH4NbRGw5yZp1HVFqARKKScwvNitamjtdYwF5slo5FHM2FOCCUUrUqKjyrwj8RfXDsWLBW+rneMo46eBKJpKl8aQpcFSa8vyNcWa0tI+hxClBCdLcroa3+ruYh8ZXDRVXF+/Ik13qW7OW0HtbVe/eEDYTIRQxo328dtfSPKE71bmSmaN1t924hevfQtF587FWiyIdCLvUxd9LfN2XCRjwyTTWkQDFMRAYuLD6EG91VOevhV+G7wq7JATtItetucnmxshsqdcdDYCera5L2DkiC+xEftqWMjBL1GtSuXnI9eMJ35vYRRrUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jXU6SOYTG8SHVYISUqeKRSGzS5mfo45pGP2HDnqj2I=;
 b=EHmx1uS0daBsYMSaQ24UjQ78sHq/KV2T+Gr7Fgb+VeEz6PtwY7LkUYOOVwwGfsuR1Qj8BFYT3sz2ga1TJbBiD4yQKawjVvW3HxMcd80slr2SVv6sE5/Pd6LVCsYUXN+F8g9Ku6UMQut6iQ7Igh6guNjYiiQIaM2zpqHus99d4WE=
Received: from SJ0PR05CA0178.namprd05.prod.outlook.com (2603:10b6:a03:339::33)
 by SA1PR12MB8920.namprd12.prod.outlook.com (2603:10b6:806:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Fri, 2 Jun
 2023 22:03:49 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:339:cafe::12) by SJ0PR05CA0178.outlook.office365.com
 (2603:10b6:a03:339::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.9 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 22:03:48 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:45 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 6/7] vfio/pds: Add support for firmware recovery
Date: Fri, 2 Jun 2023 15:03:17 -0700
Message-ID: <20230602220318.15323-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|SA1PR12MB8920:EE_
X-MS-Office365-Filtering-Correlation-Id: d3620463-5581-4b86-6de0-08db63b53e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5qsP5v+hkza4m2QHDy4NoXEvBCPMUdK8Rblk4p+4OxFzzAV6Q6ragJhK2StZJa9iVPAZ9C2iBm/1L2zid/FdBE4nadv2jenXA76q/DfbctBR/QroUBAjDOQevp5x6HmyeRlBhmqaLYYBScXNGdTGSf0bY2mHunxJLjbH0XX3ppJIfwJoLJfLQHkZtMHi4XgjSilVuV/I7TZfM03iRhaUmqEdMK9hr+GZMJXZJdKPnORQRtcwa5H0N67pDxEv0yAgtVLJ22NPhgkLqeM+Xa6Yf7EgRtlZa3uPn1xnkwcA0YWcCHLmEdnRvlnwKDXIstTGnlGbUP/84/uYSaPEV71L9BLDyuHisM/KGJGlm+KygMX0W/jHLrSOMcMkaenVPlmt5r18Js+zpyAJUlyyo0d1phNUbiCBzRNgchB1DKktpPAcZ4m08LbqYd7XV+dzVbZddyRQSNmCpx/jpeANnnT2HXyH6i3m0T7nqG3CKpFb7tWvvVUU2bVsz7/ZI9dfhqK5wjpNCF3s86ZO1OklzdjwUKjXKv1dbQz6C8ndhccX3+rcmDKjzcH5rtDae2XT3Tcp2EX7a4/ioZA4D4I64PHam5ezoulaEPYrAcHxOyr4f1RZV9kAsZG8tb0np7b7jSEes7a1UMr3cY0BV7MhzFBrvvDRh2iNtgmIxRiRCDP3zpp/BpHua3PKWxQ6QnKEmDgDL40IEAURJsiQkit/tfgv1YWulmgYk4qohQTonzh/OdxJy8lzcaJjXH3AIbsd7hOHq2YjValb9+p8evZBYm54Bw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(5660300002)(70586007)(70206006)(8936002)(8676002)(2906002)(4326008)(44832011)(316002)(41300700001)(54906003)(110136005)(16526019)(186003)(40480700001)(2616005)(336012)(426003)(83380400001)(26005)(1076003)(47076005)(36860700001)(86362001)(40460700003)(356005)(82740400003)(478600001)(6666004)(36756003)(81166007)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:48.6744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3620463-5581-4b86-6de0-08db63b53e3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8920
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
 drivers/vfio/pci/pds/pci_drv.c  | 105 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c |  28 ++++++++-
 drivers/vfio/pci/pds/vfio_dev.h |   4 ++
 3 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ffd47fa8ede3..ca79135c9af2 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -19,6 +19,104 @@
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
 #define PCI_VENDOR_ID_PENSANDO		0x1dd8
 
+static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
+{
+	bool deferred_reset_needed = false;
+
+	/*
+	 * Documentation states that the kernel migration driver must not
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
+	/*
+	 * On the next user initiated state transition, the device will
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
+static int pds_vfio_pci_notify_handler(struct notifier_block *nb,
+				       unsigned long ecode, void *data)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(nb, struct pds_vfio_pci_device, nb);
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_notifyq_comp *event = data;
+
+	dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
+
+	/*
+	 * We don't need to do anything for RESET state==0 as there is no notify
+	 * or feedback mechanism available, and it is possible that we won't
+	 * even see a state==0 event.
+	 *
+	 * Any requests from VFIO while state==0 will fail, which will return
+	 * error and may cause migration to fail.
+	 */
+	if (ecode == PDS_EVENT_RESET) {
+		dev_info(dev, "%s: PDS_EVENT_RESET event received, state==%d\n",
+			 __func__, event->reset.state);
+		if (event->reset.state == 1)
+			pds_vfio_recovery(pds_vfio);
+	}
+
+	return 0;
+}
+
+static int
+pds_vfio_pci_register_event_handler(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	struct notifier_block *nb = &pds_vfio->nb;
+	int err;
+
+	if (!nb->notifier_call) {
+		nb->notifier_call = pds_vfio_pci_notify_handler;
+		err = pdsc_register_notify(nb);
+		if (err) {
+			nb->notifier_call = NULL;
+			dev_err(dev,
+				"failed to register pds event handler: %pe\n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+		dev_dbg(dev, "pds event handler registered\n");
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
 static int pds_vfio_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
@@ -48,8 +146,14 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
 		goto out_unregister_coredev;
 	}
 
+	err = pds_vfio_pci_register_event_handler(pds_vfio);
+	if (err)
+		goto out_unregister_client;
+
 	return 0;
 
+out_unregister_client:
+	pds_vfio_unregister_client_cmd(pds_vfio);
 out_unregister_coredev:
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 out_put_vdev:
@@ -61,6 +165,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
+	pds_vfio_pci_unregister_event_handler(pds_vfio);
 	pds_vfio_unregister_client_cmd(pds_vfio);
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index c58b0c1fc811..b380571f2146 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -33,10 +33,13 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+			pds_vfio->state = pds_vfio->deferred_reset_state;
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
+		} else if (pds_vfio->deferred_reset_state == VFIO_DEVICE_STATE_ERROR) {
+			pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
 		}
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 		spin_unlock(&pds_vfio->reset_lock);
 		goto again;
 	}
@@ -48,6 +51,7 @@ void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	spin_lock(&pds_vfio->reset_lock);
 	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		spin_unlock(&pds_vfio->reset_lock);
 		return;
@@ -56,6 +60,15 @@ void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 	pds_vfio_state_mutex_unlock(pds_vfio);
 }
 
+void pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			     enum vfio_device_mig_state reset_state)
+{
+	spin_lock(&pds_vfio->reset_lock);
+	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = reset_state;
+	spin_unlock(&pds_vfio->reset_lock);
+}
+
 static struct file *
 pds_vfio_set_device_state(struct vfio_device *vdev,
 			  enum vfio_device_mig_state new_state)
@@ -66,7 +79,14 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 	struct file *res = NULL;
 
 	mutex_lock(&pds_vfio->state_mutex);
-	while (new_state != pds_vfio->state) {
+	/*
+	 * only way to transition out of VFIO_DEVICE_STATE_ERROR is via
+	 * VFIO_DEVICE_RESET, so prevent the state machine from running since
+	 * vfio_mig_get_next_state() will throw a WARN_ON() when transitioning
+	 * from VFIO_DEVICE_STATE_ERROR to any other state
+	 */
+	while (pds_vfio->state != VFIO_DEVICE_STATE_ERROR &&
+	       new_state != pds_vfio->state) {
 		enum vfio_device_mig_state next_state;
 
 		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
@@ -88,6 +108,9 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	pds_vfio_state_mutex_unlock(pds_vfio);
+	/* still waiting on a deferred_reset */
+	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
+		res = ERR_PTR(-EIO);
 
 	return res;
 }
@@ -165,6 +188,7 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 
 	mutex_init(&pds_vfio->state_mutex);
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 1e28c072ce08..197ad8e2c223 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -23,6 +23,8 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
 	u8 deferred_reset;
+	enum vfio_device_mig_state deferred_reset_state;
+	struct notifier_block nb;
 
 	int vf_id;
 	int pci_id;
@@ -34,6 +36,8 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio);
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			     enum vfio_device_mig_state reset_state);
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
 struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio);
-- 
2.17.1


