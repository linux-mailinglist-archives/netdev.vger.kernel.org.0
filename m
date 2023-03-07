Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECC26ADDB3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjCGLlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCGLk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:40:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715C7C963;
        Tue,  7 Mar 2023 03:38:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PofH/peI6fVr1//mFzVG1GxrhbEJmh5lq1XHv35f+PnCf/NpuxRsFJTu0xJZINO8VNGjUy8NnQiYTb570CKb6OLYpby4KCWu+f1LDfKL7W29bgy9MtIx50xi/7TFDujXmkWJwt4CLVVjo7elyvtTjA+MLzjYNL9J2CRsbNHfjpwyvZnYddldyWs8FQV78cedPmgXLgEadW/vfEQPwvRVjKNhsL0tniEYfh8azQzrT/7OFA1p5c6ksWFJJgdLi4Kdhc4XfEmcJkzy3vrtTxV/gn/k9IJpthaDCH+rdJwJFN9PicbPm9bf4JzJPo3nN4AAGUZKjTMpm9x2GzCjzix62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FDigy9/xpaaPZ0ddGnHRq2Cn1yzaIPJBwBICtHMetw=;
 b=L40MWrHHx9v4GQHjlVHUq0vguxb495dQoe+1Ktzx7dNQHOhOb83o+7AOd46rGis2lJ77/GtNa9CAXqnPCCVe7CLMoo2n2HKsQfHO2WhyzrZdMvNc7pRK50UYHEUHmHi8qXTlBZ1MEIboDE8T57iFpwlESu+WvqKHWUsJPMKj6eodj7AjzqJEC3W0c39JZNcrCwacgPabved5qUz3IXP2d+Eg5BwCNXFu+bey3uFXGO1pdSJ1pFX24DRR27ZtCVhpQwKS48ndHvtEoUt6tjh8lA7k9H6rbIet+tgg4Fw4HQYtmEO6MU8O/XY0Dz5TGDNcldjYz7WsziemXIxtr7gtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FDigy9/xpaaPZ0ddGnHRq2Cn1yzaIPJBwBICtHMetw=;
 b=awpUf/pHdx1wJ63DfdC0TllmwrL/Gf0AUOoQnss2pnK8rybl/u/QHy8OAogRkXnTQ+CT4AkILGcFrkosFcFkQo3vA1N5IhMzWL2Ag+MSvbJFl/DN280rDmTmdUKqU3PC00OeO44suKoRU3c27XWmDz8kOVkys/m0AuPkogROImc=
Received: from DS7P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::16) by
 CYYPR12MB8923.namprd12.prod.outlook.com (2603:10b6:930:bc::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.29; Tue, 7 Mar 2023 11:38:03 +0000
Received: from DS1PEPF0000E645.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::97) by DS7P222CA0020.outlook.office365.com
 (2603:10b6:8:2e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Tue, 7 Mar 2023 11:38:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E645.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Tue, 7 Mar 2023 11:38:02 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:38:02 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 03:38:01 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:37:57 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v2 10/14] sfc: implement filters for receiving traffic
Date:   Tue, 7 Mar 2023 17:06:12 +0530
Message-ID: <20230307113621.64153-11-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E645:EE_|CYYPR12MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ce3486-ae8a-44bd-4a66-08db1f006949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LU+sG+RSD+VAtLp4ug7Em77tNp3xzP63BkwWR1pi+/gOxWzN6d5oW4orjzviy0Rp1ZDiJLr+hMDbP0dI7TrB3VUpGzIzePtPPd0HJcvkhE9rsj2YWF4jPbm4TcpW+nu27Ts7hhpZYyfSZIixkzIDiTAxdx2BEagsHEya3R4TrN2rNMqmQT/VFSvYnJnxIqTanxYF07rBGJ+MqbAhmb7tqtqnJzUggbVzMoF4mzDny+YFjzwkevZkGSzaf6363p1QVPIAIIGHB2ctElyy42QF7t+eCyfszzZWRrDT8XL6X2/Tafx/zvK2PkowypoV+IiXEETT9A6/EN3PPhU4r9B8rOnoqiG39wjScsOXc0qQVxE/4+SCcWyJ1NenS5yofEJ+sYef50cb97kV5ROrNYHOOEuf/1hm2Z4A9+f1NIIhWx15EhCUk3tao6D8/p3VVc5mTcCgzZOVXVcmYO3aM/ydy57SgCMi+YyE36YEqVpmi083Qvbzy57L4nbtyHMBck25Q6DxHWgBBeJZ9ecJ+u1JQq7QX/DFFZLVZ8qlEJH8TlD/sSnGCHVMmseSvrwQ2LEnwTpHuZYrIoIIKs3NZohdk2SWLNUPp7T0zJFzy0XPWgcBoEqWqcBty5AmdXmhtcxbbQqG8UYgk7uViBkL3kbXcwfDYbJnS04Xe71iTuCDbJLce6hy6V9VMX+X5g1XbfaDrOOShk2n2vLkQ/ZPtH1QgM3MWbZh9sqbZb4lIEk+XQIw/tsgZswFwszm5m+YkDL3
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(36860700001)(86362001)(82740400003)(81166007)(921005)(356005)(36756003)(1076003)(2906002)(44832011)(7416002)(30864003)(5660300002)(40480700001)(70586007)(70206006)(8676002)(4326008)(41300700001)(8936002)(82310400005)(40460700003)(2616005)(336012)(186003)(83380400001)(47076005)(426003)(26005)(110136005)(54906003)(478600001)(316002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:38:02.9148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ce3486-ae8a-44bd-4a66-08db1f006949
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E645.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8923
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement unicast, broadcast and unknown multicast
filters for receiving different types of traffic.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 157 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  36 ++++-
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  17 ++-
 3 files changed, 207 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 4ba57827a6cd..5c9f29f881a6 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -16,12 +16,166 @@
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
+				     u32 qid, u8 *mac_addr)
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
+		/* Ensure we have a valid mac address */
+		if (!vdpa_nic->mac_configured ||
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
@@ -185,6 +339,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		goto err_put_device;
 	}
 
+	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
+		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 58791402e454..49fb6be04eb3 100644
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
@@ -107,6 +123,17 @@ struct ef100_vdpa_vring_info {
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
@@ -116,6 +143,7 @@ struct ef100_vdpa_vring_info {
  * @lock: Managing access to vdpa config operations
  * @pf_index: PF index of the vDPA VF
  * @vf_index: VF index of the vDPA VF
+ * @filter_cnt: total number of filters created on this vdpa device
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
@@ -123,6 +151,7 @@ struct ef100_vdpa_vring_info {
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
+ * @filters: details of all filters created on this vdpa device
  * @cfg_cb: callback for config change
  */
 struct ef100_vdpa_nic {
@@ -133,6 +162,7 @@ struct ef100_vdpa_nic {
 	struct mutex lock;
 	u32 pf_index;
 	u32 vf_index;
+	u32 filter_cnt;
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
@@ -140,6 +170,7 @@ struct ef100_vdpa_nic {
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
 	bool mac_configured;
+	struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
 	struct vdpa_callback cfg_cb;
 };
 
@@ -147,7 +178,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
-void ef100_vdpa_irq_vectors_free(void *data);
+int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
+			  enum ef100_vdpa_mac_filter_type type);
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 95a2177f85a2..db86c2693950 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -261,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
 	vdpa_nic->status = 0;
 	vdpa_nic->features = 0;
+	ef100_vdpa_filter_remove(vdpa_nic);
 	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
 		reset_vring(vdpa_nic, i);
 	ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
@@ -295,7 +296,7 @@ static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 	rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
 					  vdpa_nic->max_queue_pairs * 2);
 	if (rc < 0) {
-		pci_err(efx->pci_dev,
+		dev_err(&vdpa_nic->vdpa_dev.dev,
 			"vDPA IRQ alloc failed for vf: %u err:%d\n",
 			nic_data->vf_index, rc);
 		return rc;
@@ -309,9 +310,19 @@ static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 		}
 	}
 
+	rc = ef100_vdpa_filter_configure(vdpa_nic);
+	if (rc < 0) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: vdpa configure filter failed, err: %d\n",
+			__func__, rc);
+		goto err_filter_configure;
+	}
+
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
 	return 0;
 
+err_filter_configure:
+	ef100_vdpa_filter_remove(vdpa_nic);
 clear_vring:
 	for (j = 0; j < i; j++)
 		delete_vring(vdpa_nic, j);
@@ -680,8 +691,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 	}
 
 	memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
-	if (is_valid_ether_addr(vdpa_nic->mac_address))
+	if (is_valid_ether_addr(vdpa_nic->mac_address)) {
 		vdpa_nic->mac_configured = true;
+		ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
+	}
 }
 
 static int ef100_vdpa_suspend(struct vdpa_device *vdev)
-- 
2.30.1

