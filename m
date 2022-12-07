Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8827645D0C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiLGO5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiLGO46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:58 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC076153F;
        Wed,  7 Dec 2022 06:56:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4EDoWBVLRGCvvyA4Hv9+NBNmBhqJlkdRzJN0Z6jwmt9oW+H+dVUp2F1PbXWZ8uuEFm2NJciyVxeXhfH04/VQiBmQin446artftbSpN4gVOQRq5e/O2YxXSUtPokzYi2d3o7h3oE0O/qINpUaTQ0WXnwY5YoaZNYndWZrwxzyCIqr7j20ig5l0l+XPzav7wYg20hT4jnI7iVNfRTsbmcQGK0jdbEV7bpvhNPv4H8gcneLONw9KP098zFJtoKiNKZ/X7o21OgH3ZGxP89Wr6PfBj4RudApZTW4CYzo7XhW5UFUgVcc1KMGZ4YzFukJgq51egRb/MMrlaGd5IcErfGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ic5TNo6q1jZhFnO4jJDarwcedb1PQLi+h0Vo9bCxJDI=;
 b=dMAIUSVL9W/ccn+AjDAAxTAzBL1kc1z25rmSBSDR/Gfz+5ypTlUHnTbtx8APpOctcxUbOpTYnC4L3WDTBy+RdVROGwyTbG9cK3lIMi/ZbMkZYgc/FffqQj0lei6qakjDB+QIEAjENa4AoisXRF0yJno7jK6laxA2TvUSnlwPCelNBqMCArzyxtbXvtxDF7FkXLDehJeajSmatSnfw1Tn2M0xh8GgAo/E7h5Yd9iDNSX34SDdGX3J6bWcLV2h1pz0I5yittDdSPY0i3qecb31XmM+EL+Zrpswj45861mtlQL9XOnfUw+A1rqX+yexRzgbhXWrexDn2XtQfI5uNh31bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic5TNo6q1jZhFnO4jJDarwcedb1PQLi+h0Vo9bCxJDI=;
 b=NrX9rOuhLJRIjIjdmWhVsQFpmicS9Sn/HH9QwePH6tnC8KGTDECd03AoULy+g61Xees/TudUBlv5jixlqvWRwSBrfn11fixEcy7jgd/m4aoPDDkmaImlR7Q3NHvqyHSLqgCRObJTtN6v1qu8jcRgkZmeHXS5ttHH0dMA1kdR9cQ=
Received: from DM6PR08CA0014.namprd08.prod.outlook.com (2603:10b6:5:80::27) by
 BY5PR12MB4853.namprd12.prod.outlook.com (2603:10b6:a03:1da::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:56:48 +0000
Received: from DS1PEPF0000E651.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::fa) by DM6PR08CA0014.outlook.office365.com
 (2603:10b6:5:80::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E651.mail.protection.outlook.com (10.167.18.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:48 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:47 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:47 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:43 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 07/11] sfc: implement filters for receiving traffic
Date:   Wed, 7 Dec 2022 20:24:23 +0530
Message-ID: <20221207145428.31544-8-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E651:EE_|BY5PR12MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf61f91-8f78-483c-53ff-08dad8634422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkUh9lhzBmPsgec61BYz93v4vQUygzk5NVGVOVEfMLi4Psu7JTydHd0RyQf/glDlw0WKwNJOfITSFyiPtGY1V7cOhMexsY8br6QEmPgjFLG8GZrPcCiubskN8WnUnwi8SsVeeDN/hR31riFp0nsHTLT5PX1djmRUtzMs+XoNI9e1I7X3LkttqUXHKrkdOPF7B+xvqtdD1C+v0Rt+IwKI/+6MsBOqXKtXCbNK8gFx+Wyhp99kPk4osarKcpZyfff6iA1rpEtNGI/o9966obwdAJzMmb/uZC8JtCd//m3NNFUdIE49nfzSsy/7K7c53zwzTGPoPTSCbJpUJBw5GqzRnJol0nMKozfqCrdOLN5ZQBFPBd7Qs7DjUuWIBv9gNNzfpj0FBDgDTIxaUA2cL2HUAjuKIfAFIR4J30bL/y7O/VtDNOZ69wUYKA7f+Zn2YqsdBZf3lpFssDVgbvOAq3dUYdgnTx4NbqhraMLyHNKec2qONsEzRyN8LBi0KjXxpfwYxGi82DYDiAfVmSnfdIF3gUcXakpmaeJ0X2QyD0rIRRPVbf4RiPNA7dHJTjpGHSAjHdEuF0JpvVsACZfVFkrm0JP1kzdU0LgBl8t3y8IT5arkkZjf9gBP5R8eSwk4s3baPIJ3VEn9/HEdWUUloN/F64v7CjmOODZrF4znwCuIoL5UobvJTSGCNmePIg3518nGqxQHvXpWrdI8OfpZGWgQOvFb26WFH/tx8TYpV5W7vL8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(81166007)(8676002)(4326008)(70586007)(41300700001)(54906003)(70206006)(8936002)(426003)(6666004)(47076005)(40460700003)(478600001)(316002)(26005)(36756003)(186003)(82740400003)(356005)(2616005)(1076003)(336012)(110136005)(40480700001)(86362001)(36860700001)(83380400001)(5660300002)(82310400005)(7416002)(44832011)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:48.2183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf61f91-8f78-483c-53ff-08dad8634422
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E651.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4853
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement unicast, broadcast and unknown multicast
filters for receiving different types of traffic.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 159 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  35 +++++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  27 +++-
 3 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 41eb7aef6798..04d64bfe3c93 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -17,12 +17,168 @@
 #include "mcdi_filters.h"
 #include "mcdi_functions.h"
 #include "ef100_netdev.h"
+#include "filter.h"
+#include "efx.h"
 
+#define EFX_INVALID_FILTER_ID -1
+
+/* vDPA queues starts from 2nd VI or qid 1 */
+#define EF100_VDPA_BASE_RX_QID 1
+
+static const char * const filter_names[] = { "bcast", "ucast", "mcast" };
 static struct virtio_device_id ef100_vdpa_id_table[] = {
 	{ .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
 	{ 0 },
 };
 
+static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
+				     struct efx_filter_spec *spec,
+				     u32 qid,
+				     u8 *mac_addr)
+{
+	int rc;
+
+	efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
+
+	if (mac_addr) {
+		rc = efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSPEC,
+					      mac_addr);
+		if (rc)
+			pci_err(efx->pci_dev,
+				"Filter set eth local failed, err: %d\n", rc);
+	} else {
+		efx_filter_set_mc_def(spec);
+	}
+
+	rc = efx_filter_insert_filter(efx, spec, true);
+	if (rc < 0)
+		pci_err(efx->pci_dev,
+			"Filter insert failed, err: %d\n", rc);
+
+	return rc;
+}
+
+static int ef100_vdpa_delete_filter(struct ef100_vdpa_nic *vdpa_nic,
+				    enum ef100_vdpa_mac_filter_type type)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	int rc;
+
+	if (vdpa_nic->filters[type].filter_id == EFX_INVALID_FILTER_ID)
+		return rc;
+
+	rc = efx_filter_remove_id_safe(vdpa_nic->efx,
+				       EFX_FILTER_PRI_AUTO,
+				       vdpa_nic->filters[type].filter_id);
+	if (rc) {
+		dev_err(&vdev->dev, "%s filter id: %d remove failed, err: %d\n",
+			filter_names[type], vdpa_nic->filters[type].filter_id,
+			rc);
+	} else {
+		vdpa_nic->filters[type].filter_id = EFX_INVALID_FILTER_ID;
+		vdpa_nic->filter_cnt--;
+	}
+	return rc;
+}
+
+int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
+			  enum ef100_vdpa_mac_filter_type type)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	struct efx_nic *efx = vdpa_nic->efx;
+	/* Configure filter on base Rx queue only */
+	u32 qid = EF100_VDPA_BASE_RX_QID;
+	struct efx_filter_spec *spec;
+	u8 baddr[ETH_ALEN];
+	int rc;
+
+	/* remove existing filter */
+	rc = ef100_vdpa_delete_filter(vdpa_nic, type);
+	if (rc < 0) {
+		dev_err(&vdev->dev, "%s MAC filter deletion failed, err: %d",
+			filter_names[type], rc);
+		return rc;
+	}
+
+	/* Configure MAC Filter */
+	spec = &vdpa_nic->filters[type].spec;
+	if (type == EF100_VDPA_BCAST_MAC_FILTER) {
+		eth_broadcast_addr(baddr);
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
+	} else if (type == EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
+	} else {
+		/* Ensure we have everything required to insert the filter */
+		if (!vdpa_nic->mac_configured ||
+		    !vdpa_nic->vring[0].vring_created ||
+		    !is_valid_ether_addr(vdpa_nic->mac_address))
+			return -EINVAL;
+
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid,
+					       vdpa_nic->mac_address);
+	}
+
+	if (rc >= 0) {
+		vdpa_nic->filters[type].filter_id = rc;
+		vdpa_nic->filter_cnt++;
+
+		return 0;
+	}
+
+	dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
+		filter_names[type], rc);
+
+	if (type != EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
+		ef100_vdpa_filter_remove(vdpa_nic);
+		return rc;
+	}
+
+	return 0;
+}
+
+int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic)
+{
+	enum ef100_vdpa_mac_filter_type filter;
+	int err = 0;
+	int rc;
+
+	for (filter = EF100_VDPA_BCAST_MAC_FILTER;
+	     filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
+		rc = ef100_vdpa_delete_filter(vdpa_nic, filter);
+		if (rc < 0)
+			/* store status of last failed filter remove */
+			err = rc;
+	}
+	return err;
+}
+
+int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	enum ef100_vdpa_mac_filter_type filter;
+	int rc;
+
+	/* remove existing filters, if any */
+	rc = ef100_vdpa_filter_remove(vdpa_nic);
+	if (rc < 0) {
+		dev_err(&vdev->dev,
+			"MAC filter deletion failed, err: %d", rc);
+		goto fail;
+	}
+
+	for (filter = EF100_VDPA_BCAST_MAC_FILTER;
+	     filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
+		if (filter == EF100_VDPA_UCAST_MAC_FILTER &&
+		    !vdpa_nic->mac_configured)
+			continue;
+		rc = ef100_vdpa_add_filter(vdpa_nic, filter);
+		if (rc < 0)
+			goto fail;
+	}
+fail:
+	return rc;
+}
+
 int ef100_vdpa_init(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
@@ -168,6 +324,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	ether_addr_copy(vdpa_nic->mac_address, mac);
 	vdpa_nic->mac_configured = true;
 
+	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
+		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
+
 	for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++)
 		vdpa_nic->vring[i].irq = -EINVAL;
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 3cc33daa0431..a33edd6dda12 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -72,6 +72,22 @@ enum ef100_vdpa_vq_type {
 	EF100_VDPA_VQ_NTYPES
 };
 
+/**
+ * enum ef100_vdpa_mac_filter_type - vdpa filter types
+ *
+ * @EF100_VDPA_BCAST_MAC_FILTER: Broadcast MAC filter
+ * @EF100_VDPA_UCAST_MAC_FILTER: Unicast MAC filter
+ * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to allow
+ *	IPv6 Neighbor Solicitation Message
+ * @EF100_VDPA_MAC_FILTER_NTYPES: Number of vDPA filter types
+ */
+enum ef100_vdpa_mac_filter_type {
+	EF100_VDPA_BCAST_MAC_FILTER,
+	EF100_VDPA_UCAST_MAC_FILTER,
+	EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER,
+	EF100_VDPA_MAC_FILTER_NTYPES,
+};
+
 /**
  * struct ef100_vdpa_vring_info - vDPA vring data structure
  *
@@ -109,6 +125,17 @@ struct ef100_vdpa_vring_info {
 	struct vdpa_callback cb;
 };
 
+/**
+ * struct ef100_vdpa_filter - vDPA filter data structure
+ *
+ * @filter_id: filter id of this filter
+ * @efx_filter_spec: hardware filter specs for this vdpa device
+ */
+struct ef100_vdpa_filter {
+	s32 filter_id;
+	struct efx_filter_spec spec;
+};
+
 /**
  *  struct ef100_vdpa_nic - vDPA NIC data structure
  *
@@ -118,6 +145,7 @@ struct ef100_vdpa_vring_info {
  * @lock: Managing access to vdpa config operations
  * @pf_index: PF index of the vDPA VF
  * @vf_index: VF index of the vDPA VF
+ * @filter_cnt: total number of filters created on this vdpa device
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
@@ -125,6 +153,7 @@ struct ef100_vdpa_vring_info {
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
+ * @filters: details of all filters created on this vdpa device
  * @cfg_cb: callback for config change
  */
 struct ef100_vdpa_nic {
@@ -135,6 +164,7 @@ struct ef100_vdpa_nic {
 	struct mutex lock;
 	u32 pf_index;
 	u32 vf_index;
+	u32 filter_cnt;
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
@@ -142,6 +172,7 @@ struct ef100_vdpa_nic {
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
 	bool mac_configured;
+	struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
 	struct vdpa_callback cfg_cb;
 };
 
@@ -149,6 +180,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
+int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
+			  enum ef100_vdpa_mac_filter_type type);
 int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
 void ef100_vdpa_irq_vectors_free(void *data);
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index b7efd3e0c901..132ddb4a647b 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -135,6 +135,15 @@ static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
 	if (vdpa_nic->vring[idx].vring_ctx)
 		delete_vring_ctx(vdpa_nic, idx);
 
+	if (idx == 0 && vdpa_nic->filter_cnt != 0) {
+		rc = ef100_vdpa_filter_remove(vdpa_nic);
+		if (rc < 0) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: vdpa remove filter failed, err:%d\n",
+				__func__, rc);
+		}
+	}
+
 	return rc;
 }
 
@@ -193,8 +202,22 @@ static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
 		vdpa_nic->vring[idx].doorbell_offset_valid = true;
 	}
 
+	/* Configure filters on rxq 0 */
+	if (idx == 0) {
+		rc = ef100_vdpa_filter_configure(vdpa_nic);
+		if (rc < 0) {
+			dev_err(&vdpa_nic->vdpa_dev.dev,
+				"%s: vdpa configure filter failed, err:%d\n",
+				__func__, rc);
+			goto err_filter_configure;
+		}
+	}
+
 	return 0;
 
+err_filter_configure:
+	ef100_vdpa_filter_remove(vdpa_nic);
+	vdpa_nic->vring[idx].doorbell_offset_valid = false;
 err_get_doorbell_offset:
 	efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
 			       &vring_dyn_cfg);
@@ -578,8 +601,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 	}
 
 	memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
-	if (is_valid_ether_addr(vdpa_nic->mac_address))
+	if (is_valid_ether_addr(vdpa_nic->mac_address)) {
 		vdpa_nic->mac_configured = true;
+		ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
+	}
 }
 
 static void ef100_vdpa_free(struct vdpa_device *vdev)
-- 
2.30.1

