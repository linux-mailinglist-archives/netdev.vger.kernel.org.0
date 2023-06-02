Return-Path: <netdev+bounces-7586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D3F720BB8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7620280C25
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBB8C15F;
	Fri,  2 Jun 2023 22:03:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BF1C2E8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:57 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9995E4E;
	Fri,  2 Jun 2023 15:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAeB4J7eEizfihUqfPVgSaYwSmM/N9kb6KZxWGzVDbAZHzHUom4zJ7xI88ol4aQBBtoV29M62eOcX9hqb6z9SSqea3jjiaztWk/RLz3RtN1pdw+EbNOYPJaLnfFo6S1fwXlnKWcJ6HnaEyT1ee8stjNAyT1lTkKx4BhUcJHAqARCqb17LkP1fMg6pmKOQCZc983HJBqCW2u+T6B+QFXvmywylIJg0XrOvIdgukt0pIhoJRXsyDNol66iNotbJhiPpcMsYo4w//q4LNTYxc2XZmxqsb5YiUD3oJXj4iCUnl305QVO6jK12emnZPVEf6CaOvD7duy5doob53wkQJ6lSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IEcc7LvK/jO2lhC400H1kxIcXUJo6NBRXwlTEYj1M0=;
 b=GRtkQPxY4Zu0xq8Wau2PmlqSw3taQqByxrKJbaNvCx0gr3u05roVmQXKjHMZmk4RoyQrWOfb7KwwQM6YPKUcyT/1lrQLULggrw/Vd07zIIHXD+knRyJdqiApFjTV6BeXMgms4i9WDQeP34xXIKwk/J8M3uXXumzjZaU4k4oBkc7VB/tcIsjeRi4582EX4x+VbU94+b3DkVc+qdMSS71af3ZK+kxWZGUk9T+4TNnspvXnC2DQc6LXOJFFGHJADNsHX2luKnIIC0poZ/Eim1b7z2M+dc5l+h5NGwO7AepwtDvkxvo501qgs7cijSTvt0uBvdVH2yNw0iiTT+7z/BHgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IEcc7LvK/jO2lhC400H1kxIcXUJo6NBRXwlTEYj1M0=;
 b=zgUxPUXhKhg+VIAKvazzgnLye6ipReEzDnVRtTyDoorY6hweO3NpZ9ovyyDKCDr3hipA9qIZAXPe1H7RqtxVBzk/+sIU7E/7X3zp0OGxSetXJBzrRWeL0P7dALK44e1uZXmtlNqGsEDemZ+GFA97Y72WKXc1i0iJdI7dFz7ekBA=
Received: from SJ0PR05CA0177.namprd05.prod.outlook.com (2603:10b6:a03:339::32)
 by CH3PR12MB7499.namprd12.prod.outlook.com (2603:10b6:610:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Fri, 2 Jun
 2023 22:03:47 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:339:cafe::f) by SJ0PR05CA0177.outlook.office365.com
 (2603:10b6:a03:339::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.12 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 22:03:47 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:43 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 5/7] vfio/pds: Add support for dirty page tracking
Date: Fri, 2 Jun 2023 15:03:16 -0700
Message-ID: <20230602220318.15323-6-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|CH3PR12MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 1054bfc5-7838-423c-7e12-08db63b53d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ukzcit2TlnjjWcOz1DEYluCiFM00qBU/6NQOt3dIhCxwcGY9v6KRhJvYJBM8NYIORgr5nrVKkObPBOA9+o+EvOi51syCzBnoE6ayod9eDKoyb775hC0sFwpvj0qdmhVw0HtMEYLprIi8Peoe5Zd0GtsFv4CfTBys5T3/Ga1xN88FBageW8gNIyogLWTQP0jjz3zECMoM6kLXkQxk2OwnlBJXtvMa+5enAihYQCAOE9gieF80H2a0FMjJUXcCqUhessI9sA1bGzBdh6yaK2U0Ha7T5JuDZ1jKBuDcO0ZKKy/QVCMpdkj5TF8XI/lfGbpnwYeT02jOeZ5QUpVtx8OHd0qK3Wbl5ka+bzE3Wnr92N8HsHZ0ZgJhcSFPAJOyWXANaslMlO/KBFFDAHlodcz+YbmwQADkkeYvR0XLSVaCk2jYhrmeBxkBULm2913j0cKlJnunO3EZv7dsIpOIzS4ddDpkZA11P9JtiiZq/K816mp2bnKjY090ZKFXzLHCw8A0S8Rhw3ukmJ5yS2HK9jTuvNafAp7FonEQVrxa0ahqSdvczQWji0WVkAPjITO5r6NQ74xC3XMghPXOKxopFFYZAMTqNcfq2lh+n8kgox1yImHR+wvySEMZ78gQTLiq72HM2fiFv5szFGOaGZnl5b/qTbRePd8KkHMVLThUwr0/ntHunriG3iu6/+HNuPN8txKPX7z3saQZkqH+JDWr58eRxZYsRxVSpI7L0BLQxHvbyMuoxg/Apn1yWRxorkoF795KYYYCTvk3kAMMvkU+1k10Ej2YqDgzOb7NAZbhllUWxpo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(8676002)(8936002)(110136005)(478600001)(54906003)(41300700001)(316002)(5660300002)(6666004)(186003)(16526019)(26005)(1076003)(44832011)(4326008)(70586007)(70206006)(2616005)(83380400001)(47076005)(40460700003)(2906002)(30864003)(336012)(426003)(81166007)(356005)(82740400003)(40480700001)(36860700001)(82310400005)(86362001)(36756003)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:47.0339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1054bfc5-7838-423c-7e12-08db63b53d43
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7499
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to support dirty page tracking, the driver has to implement
the VFIO subsystem's vfio_log_ops. This includes log_start, log_stop,
and log_read_and_clear.

All of the tracker resources are allocated and dirty tracking on the
device is started during log_start. The resources are cleaned up and
dirty tracking on the device is stopped during log_stop. The dirty
pages are determined and reported during log_read_and_clear.

In order to support these callbacks admin queue commands are used.
All of the adminq queue command structures and implementations
are included as part of this patch.

PDS_LM_CMD_DIRTY_STATUS is added to query the current status of
dirty tracking on the device. This includes if it's enabled (i.e.
number of regions being tracked from the device's perspective) and
the maximum number of regions supported from the device's perspective.

PDS_LM_CMD_DIRTY_ENABLE is added to enable dirty tracking on the
specified number of regions and their iova ranges.

PDS_LM_CMD_DIRTY_DISABLE is added to disable dirty tracking for all
regions on the device.

PDS_LM_CMD_READ_SEQ and PDS_LM_CMD_DIRTY_WRITE_ACK are added to
support reading and acknowledging the currently dirtied pages.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   1 +
 drivers/vfio/pci/pds/cmds.c     | 125 +++++++
 drivers/vfio/pci/pds/cmds.h     |   9 +
 drivers/vfio/pci/pds/dirty.c    | 577 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h    |  38 +++
 drivers/vfio/pci/pds/lm.c       |   2 +-
 drivers/vfio/pci/pds/vfio_dev.c |  11 +-
 drivers/vfio/pci/pds/vfio_dev.h |   4 +
 include/linux/pds/pds_adminq.h  | 178 ++++++++++
 9 files changed, 943 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index dbaf613d3794..805176f7be9f 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
 	cmds.o		\
+	dirty.o		\
 	lm.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
index 256f458feb58..a2cc6d5011f6 100644
--- a/drivers/vfio/pci/pds/cmds.c
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -360,3 +360,128 @@ void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
 		dev_warn(dev, "failed to send host VF migration status: %pe\n",
 			 ERR_PTR(err));
 }
+
+int pds_vfio_dirty_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 *max_regions, u8 *num_regions)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_status = {
+			.opcode = PDS_LM_CMD_DIRTY_STATUS,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Dirty status\n", pds_vfio->vf_id);
+
+	cmd.lm_dirty_status.regions_dma = cpu_to_le64(regions_dma);
+	cmd.lm_dirty_status.max_regions = *max_regions;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp, 0);
+	if (err) {
+		dev_err(dev, "failed to get dirty status: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	/* only support seq_ack approach for now */
+	if (!(le32_to_cpu(comp.lm_dirty_status.bmp_type_mask) &
+	      BIT(PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK))) {
+		dev_err(dev, "Dirty bitmap tracking SEQ_ACK not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	*num_regions = comp.lm_dirty_status.num_regions;
+	*max_regions = comp.lm_dirty_status.max_regions;
+
+	dev_dbg(dev,
+		"Page Tracking Status command successful, max_regions: %d, num_regions: %d, bmp_type: %s\n",
+		*max_regions, *num_regions, "PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK");
+
+	return 0;
+}
+
+int pds_vfio_dirty_enable_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 num_regions)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_enable = {
+			.opcode = PDS_LM_CMD_DIRTY_ENABLE,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.regions_dma = cpu_to_le64(regions_dma),
+			.bmp_type = PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK,
+			.num_regions = num_regions,
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp, 0);
+	if (err) {
+		dev_err(dev, "failed dirty tracking enable: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+int pds_vfio_dirty_disable_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_disable = {
+			.opcode = PDS_LM_CMD_DIRTY_DISABLE,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp, 0);
+	if (err || comp.lm_dirty_status.num_regions != 0) {
+		/* in case num_regions is still non-zero after disable */
+		err = err ? err : -EIO;
+		dev_err(dev,
+			"failed dirty tracking disable: %pe, num_regions %d\n",
+			ERR_PTR(err), comp.lm_dirty_status.num_regions);
+		return err;
+	}
+
+	return 0;
+}
+
+int pds_vfio_dirty_seq_ack_cmd(struct pds_vfio_pci_device *pds_vfio,
+			       u64 sgl_dma, u16 num_sge, u32 offset,
+			       u32 total_len, bool read_seq)
+{
+	const char *cmd_type_str = read_seq ? "read_seq" : "write_ack";
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_seq_ack = {
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.len_bytes = cpu_to_le32(total_len),
+			.off_bytes = cpu_to_le32(offset),
+			.sgl_addr = cpu_to_le64(sgl_dma),
+			.num_sge = cpu_to_le16(num_sge),
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	if (read_seq)
+		cmd.lm_dirty_seq_ack.opcode = PDS_LM_CMD_DIRTY_READ_SEQ;
+	else
+		cmd.lm_dirty_seq_ack.opcode = PDS_LM_CMD_DIRTY_WRITE_ACK;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd), &comp, 0);
+	if (err) {
+		dev_err(dev, "failed cmd Page Tracking %s: %pe\n", cmd_type_str,
+			ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
index 3d8a5508c733..fc1f4ae611eb 100644
--- a/drivers/vfio/pci/pds/cmds.h
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -13,4 +13,13 @@ int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
 int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
 void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
 					 enum pds_lm_host_vf_status vf_status);
+int pds_vfio_dirty_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 *max_regions,
+			      u8 *num_regions);
+int pds_vfio_dirty_enable_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 num_regions);
+int pds_vfio_dirty_disable_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_dirty_seq_ack_cmd(struct pds_vfio_pci_device *pds_vfio,
+			       u64 sgl_dma, u16 num_sge, u32 offset,
+			       u32 total_len, bool read_seq);
 #endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
new file mode 100644
index 000000000000..321d06d378ca
--- /dev/null
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -0,0 +1,577 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/interval_tree.h>
+#include <linux/vfio.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+#include "dirty.h"
+
+#define READ_SEQ true
+#define WRITE_ACK false
+
+bool pds_vfio_dirty_is_enabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	return pds_vfio->dirty.is_enabled;
+}
+
+void pds_vfio_dirty_set_enabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	pds_vfio->dirty.is_enabled = true;
+}
+
+void pds_vfio_dirty_set_disabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	pds_vfio->dirty.is_enabled = false;
+}
+
+static void
+pds_vfio_print_guest_region_info(struct pds_vfio_pci_device *pds_vfio,
+				 u8 max_regions)
+{
+	int len = max_regions * sizeof(struct pds_lm_dirty_region_info);
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_lm_dirty_region_info *region_info;
+	dma_addr_t regions_dma;
+	u8 num_regions;
+	int err;
+
+	region_info = kcalloc(max_regions,
+			      sizeof(struct pds_lm_dirty_region_info),
+			      GFP_KERNEL);
+	if (!region_info)
+		return;
+
+	regions_dma =
+		dma_map_single(pdsc_dev, region_info, len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(pdsc_dev, regions_dma))
+		goto out_free_region_info;
+
+	err = pds_vfio_dirty_status_cmd(pds_vfio, regions_dma, &max_regions,
+					&num_regions);
+	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_FROM_DEVICE);
+	if (err)
+		goto out_free_region_info;
+
+	for (unsigned int i = 0; i < num_regions; i++)
+		dev_dbg(&pdev->dev,
+			"region_info[%d]: dma_base 0x%llx page_count %u page_size_log2 %u\n",
+			i, le64_to_cpu(region_info[i].dma_base),
+			le32_to_cpu(region_info[i].page_count),
+			region_info[i].page_size_log2);
+
+out_free_region_info:
+	kfree(region_info);
+}
+
+static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
+					unsigned long bytes)
+{
+	unsigned long *host_seq_bmp, *host_ack_bmp;
+
+	host_seq_bmp = vzalloc(bytes);
+	if (!host_seq_bmp)
+		return -ENOMEM;
+
+	host_ack_bmp = vzalloc(bytes);
+	if (!host_ack_bmp) {
+		bitmap_free(host_seq_bmp);
+		return -ENOMEM;
+	}
+
+	dirty->host_seq.bmp = host_seq_bmp;
+	dirty->host_ack.bmp = host_ack_bmp;
+
+	return 0;
+}
+
+static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
+{
+	if (dirty->host_seq.bmp)
+		vfree(dirty->host_seq.bmp);
+	if (dirty->host_ack.bmp)
+		vfree(dirty->host_ack.bmp);
+
+	dirty->host_seq.bmp = NULL;
+	dirty->host_ack.bmp = NULL;
+}
+
+static void __pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
+				      struct pds_vfio_bmp_info *bmp_info)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+
+	dma_unmap_single(pdsc_dev, bmp_info->sgl_addr,
+			 bmp_info->num_sge * sizeof(struct pds_lm_sg_elem),
+			 DMA_BIDIRECTIONAL);
+	kfree(bmp_info->sgl);
+
+	bmp_info->num_sge = 0;
+	bmp_info->sgl = NULL;
+	bmp_info->sgl_addr = 0;
+}
+
+static void pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (pds_vfio->dirty.host_seq.sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio, &pds_vfio->dirty.host_seq);
+	if (pds_vfio->dirty.host_ack.sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio, &pds_vfio->dirty.host_ack);
+}
+
+static int __pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+				      struct pds_vfio_bmp_info *bmp_info,
+				      u32 page_count)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_lm_sg_elem *sgl;
+	dma_addr_t sgl_addr;
+	size_t sgl_size;
+	u32 max_sge;
+
+	max_sge = DIV_ROUND_UP(page_count, PAGE_SIZE * 8);
+	sgl_size = max_sge * sizeof(struct pds_lm_sg_elem);
+
+	sgl = kzalloc(sgl_size, GFP_KERNEL);
+	if (!sgl)
+		return -ENOMEM;
+
+	sgl_addr = dma_map_single(pdsc_dev, sgl, sgl_size, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(pdsc_dev, sgl_addr)) {
+		kfree(sgl);
+		return -EIO;
+	}
+
+	bmp_info->sgl = sgl;
+	bmp_info->num_sge = max_sge;
+	bmp_info->sgl_addr = sgl_addr;
+
+	return 0;
+}
+
+static int pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+				    u32 page_count)
+{
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	int err;
+
+	err = __pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->host_seq,
+					 page_count);
+	if (err)
+		return err;
+
+	err = __pds_vfio_dirty_alloc_sgl(pds_vfio, &dirty->host_ack,
+					 page_count);
+	if (err) {
+		__pds_vfio_dirty_free_sgl(pds_vfio, &dirty->host_seq);
+		return err;
+	}
+
+	return 0;
+}
+
+static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
+				 struct rb_root_cached *ranges, u32 nnodes,
+				 u64 *page_size)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u64 region_start, region_size, region_page_size;
+	struct pds_lm_dirty_region_info *region_info;
+	struct interval_tree_node *node = NULL;
+	u8 max_regions = 0, num_regions;
+	dma_addr_t regions_dma = 0;
+	u32 num_ranges = nnodes;
+	u32 page_count;
+	u16 len;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
+		pds_vfio->vf_id);
+
+	if (pds_vfio_dirty_is_enabled(pds_vfio))
+		return -EINVAL;
+
+	pds_vfio_dirty_set_enabled(pds_vfio);
+
+	/* find if dirty tracking is disabled, i.e. num_regions == 0 */
+	err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions,
+					&num_regions);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
+			ERR_PTR(err));
+		goto out_set_disabled;
+	} else if (num_regions) {
+		dev_err(&pdev->dev,
+			"Dirty tracking already enabled for %d regions\n",
+			num_regions);
+		err = -EEXIST;
+		goto out_set_disabled;
+	} else if (!max_regions) {
+		dev_err(&pdev->dev,
+			"Device doesn't support dirty tracking, max_regions %d\n",
+			max_regions);
+		err = -EOPNOTSUPP;
+		goto out_set_disabled;
+	}
+
+	/*
+	 * Only support 1 region for now. If there are any large gaps in the
+	 * VM's address regions, then this would be a waste of memory as we are
+	 * generating 2 bitmaps (ack/seq) from the min address to the max
+	 * address of the VM's address regions. In the future, if we support
+	 * more than one region in the device/driver we can split the bitmaps
+	 * on the largest address region gaps. We can do this split up to the
+	 * max_regions times returned from the dirty_status command.
+	 */
+	max_regions = 1;
+	if (num_ranges > max_regions) {
+		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
+		num_ranges = max_regions;
+	}
+
+	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
+	if (!node) {
+		err = -EINVAL;
+		goto out_set_disabled;
+	}
+
+	region_size = node->last - node->start + 1;
+	region_start = node->start;
+	region_page_size = *page_size;
+
+	len = sizeof(*region_info);
+	region_info = kzalloc(len, GFP_KERNEL);
+	if (!region_info) {
+		err = -ENOMEM;
+		goto out_set_disabled;
+	}
+
+	page_count = DIV_ROUND_UP(region_size, region_page_size);
+
+	region_info->dma_base = cpu_to_le64(region_start);
+	region_info->page_count = cpu_to_le32(page_count);
+	region_info->page_size_log2 = ilog2(region_page_size);
+
+	regions_dma = dma_map_single(pdsc_dev, (void *)region_info, len,
+				     DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(pdsc_dev, regions_dma)) {
+		err = -ENOMEM;
+		goto out_free_region_info;
+	}
+
+	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
+	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_BIDIRECTIONAL);
+	if (err)
+		goto out_free_region_info;
+
+	/*
+	 * page_count might be adjusted by the device,
+	 * update it before freeing region_info DMA
+	 */
+	page_count = le32_to_cpu(region_info->page_count);
+
+	dev_dbg(&pdev->dev,
+		"region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u page_size_log2 %u\n",
+		regions_dma, region_start, page_count,
+		(u8)ilog2(region_page_size));
+
+	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count / BITS_PER_BYTE);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
+			ERR_PTR(err));
+		goto out_free_region_info;
+	}
+
+	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
+			ERR_PTR(err));
+		goto out_free_bitmaps;
+	}
+
+	dirty->region_start = region_start;
+	dirty->region_size = region_size;
+	dirty->region_page_size = region_page_size;
+
+	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
+
+	kfree(region_info);
+
+	return 0;
+
+out_free_bitmaps:
+	pds_vfio_dirty_free_bitmaps(dirty);
+out_free_region_info:
+	kfree(region_info);
+out_set_disabled:
+	pds_vfio_dirty_set_disabled(pds_vfio);
+	return err;
+}
+
+int pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio)
+{
+	int err = 0;
+
+	if (pds_vfio_dirty_is_enabled(pds_vfio)) {
+		pds_vfio_dirty_set_disabled(pds_vfio);
+		err = pds_vfio_dirty_disable_cmd(pds_vfio);
+		pds_vfio_dirty_free_sgl(pds_vfio);
+		pds_vfio_dirty_free_bitmaps(&pds_vfio->dirty);
+	}
+
+	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_NONE);
+	return err;
+}
+
+static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
+				  struct pds_vfio_bmp_info *bmp_info,
+				  u32 offset, u32 bmp_bytes, bool read_seq)
+{
+	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
+	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	unsigned long long npages;
+	struct sg_table sg_table;
+	struct scatterlist *sg;
+	struct page **pages;
+	u32 page_offset;
+	const void *bmp;
+	size_t size;
+	u16 num_sge;
+	int err;
+	int i;
+
+	bmp = (void *)((u64)bmp_info->bmp + offset);
+	page_offset = offset_in_page(bmp);
+	bmp -= page_offset;
+
+	/*
+	 * Start and end of bitmap section to seq/ack might not be page
+	 * aligned, so use the page_offset to account for that so there
+	 * will be enough pages to represent the bmp_bytes
+	 */
+	npages = DIV_ROUND_UP_ULL(bmp_bytes + page_offset, PAGE_SIZE);
+	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	for (unsigned long long i = 0; i < npages; i++) {
+		struct page *page = vmalloc_to_page(bmp);
+		if (!page) {
+			err = -EFAULT;
+			goto out_free_pages;
+		}
+
+		pages[i] = page;
+		bmp += PAGE_SIZE;
+	}
+
+	err = sg_alloc_table_from_pages(&sg_table, pages, npages, page_offset,
+					bmp_bytes, GFP_KERNEL);
+	if (err)
+		goto out_free_pages;
+
+	err = dma_map_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
+	if (err)
+		goto out_free_sg_table;
+
+	for_each_sgtable_dma_sg(&sg_table, sg, i) {
+		struct pds_lm_sg_elem *sg_elem = &bmp_info->sgl[i];
+
+		sg_elem->addr = cpu_to_le64(sg_dma_address(sg));
+		sg_elem->len = cpu_to_le32(sg_dma_len(sg));
+	}
+
+	num_sge = sg_table.nents;
+	size = num_sge * sizeof(struct pds_lm_sg_elem);
+	dma_sync_single_for_device(pdsc_dev, bmp_info->sgl_addr, size, dma_dir);
+	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, bmp_info->sgl_addr, num_sge,
+					 offset, bmp_bytes, read_seq);
+	if (err)
+		dev_err(&pdev->dev,
+			"Dirty bitmap %s failed offset %u bmp_bytes %u num_sge %u DMA 0x%llx: %pe\n",
+			bmp_type_str, offset, bmp_bytes,
+			num_sge, bmp_info->sgl_addr, ERR_PTR(err));
+	dma_sync_single_for_cpu(pdsc_dev, bmp_info->sgl_addr, size, dma_dir);
+
+	dma_unmap_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
+out_free_sg_table:
+	sg_free_table(&sg_table);
+out_free_pages:
+	kfree(pages);
+
+	return err;
+}
+
+static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
+				    u32 offset, u32 len)
+{
+	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_ack,
+				      offset, len, WRITE_ACK);
+}
+
+static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
+				   u32 offset, u32 len)
+{
+	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_seq,
+				      offset, len, READ_SEQ);
+}
+
+static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
+					  struct iova_bitmap *dirty_bitmap,
+					  u32 bmp_offset, u32 len_bytes)
+{
+	u64 page_size = pds_vfio->dirty.region_page_size;
+	u64 region_start = pds_vfio->dirty.region_start;
+	u32 bmp_offset_bit;
+	__le64 *seq, *ack;
+	int dword_count;
+
+	dword_count = len_bytes / sizeof(u64);
+	seq = (__le64 *)((u64)pds_vfio->dirty.host_seq.bmp + bmp_offset);
+	ack = (__le64 *)((u64)pds_vfio->dirty.host_ack.bmp + bmp_offset);
+	bmp_offset_bit = bmp_offset * 8;
+
+	for (int i = 0; i < dword_count; i++) {
+		u64 xor = le64_to_cpu(seq[i]) ^ le64_to_cpu(ack[i]);
+
+		/* prepare for next write_ack call */
+		ack[i] = seq[i];
+
+		for (u8 bit_i = 0; bit_i < BITS_PER_TYPE(u64); ++bit_i) {
+			if (xor & BIT(bit_i)) {
+				u64 abs_bit_i = bmp_offset_bit +
+						i * BITS_PER_TYPE(u64) + bit_i;
+				u64 addr = abs_bit_i * page_size + region_start;
+
+				iova_bitmap_set(dirty_bitmap, addr, page_size);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
+			       struct iova_bitmap *dirty_bitmap,
+			       unsigned long iova, unsigned long length)
+{
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u64 bmp_offset, bmp_bytes;
+	u64 bitmap_size, pages;
+	int err;
+
+	dev_dbg(dev, "vf%u: Get dirty page bitmap\n", pds_vfio->vf_id);
+
+	if (!pds_vfio_dirty_is_enabled(pds_vfio)) {
+		dev_err(dev, "vf%u: Sync failed, dirty tracking is disabled\n",
+			pds_vfio->vf_id);
+		return -EINVAL;
+	}
+
+	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region_page_size);
+	bitmap_size =
+		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
+
+	dev_dbg(dev,
+		"vf%u: iova 0x%lx length %lu page_size %llu pages %llu bitmap_size %llu\n",
+		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
+		pages, bitmap_size);
+
+	if (!length || ((dirty->region_start + iova + length) >
+			(dirty->region_start + dirty->region_size))) {
+		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
+			iova, length);
+		return -EINVAL;
+	}
+
+	/* bitmap is modified in 64 bit chunks */
+	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region_page_size,
+				       sizeof(u64)),
+			  sizeof(u64));
+	if (bmp_bytes != bitmap_size) {
+		dev_err(dev,
+			"Calculated bitmap bytes %llu not equal to bitmap size %llu\n",
+			bmp_bytes, bitmap_size);
+		return -EINVAL;
+	}
+
+	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+
+	dev_dbg(dev,
+		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
+		iova, length, bmp_offset, bmp_bytes);
+
+	err = pds_vfio_dirty_read_seq(pds_vfio, bmp_offset, bmp_bytes);
+	if (err)
+		return err;
+
+	err = pds_vfio_dirty_process_bitmaps(pds_vfio, dirty_bitmap, bmp_offset,
+					     bmp_bytes);
+	if (err)
+		return err;
+
+	err = pds_vfio_dirty_write_ack(pds_vfio, bmp_offset, bmp_bytes);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long iova,
+				unsigned long length, struct iova_bitmap *dirty)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	err = pds_vfio_dirty_sync(pds_vfio, dirty, iova, length);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
+
+int pds_vfio_dma_logging_start(struct vfio_device *vdev,
+			       struct rb_root_cached *ranges, u32 nnodes,
+			       u64 *page_size)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
+	err = pds_vfio_dirty_enable(pds_vfio, ranges, nnodes, page_size);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
+
+int pds_vfio_dma_logging_stop(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	err = pds_vfio_dirty_disable(pds_vfio);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
new file mode 100644
index 000000000000..d9fdce08e113
--- /dev/null
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _DIRTY_H_
+#define _DIRTY_H_
+
+struct pds_vfio_bmp_info {
+	unsigned long *bmp;
+	u32 bmp_bytes;
+	struct pds_lm_sg_elem *sgl;
+	dma_addr_t sgl_addr;
+	u16 num_sge;
+};
+
+struct pds_vfio_dirty {
+	struct pds_vfio_bmp_info host_seq;
+	struct pds_vfio_bmp_info host_ack;
+	u64 region_size;
+	u64 region_start;
+	u64 region_page_size;
+	bool is_enabled;
+};
+
+struct pds_vfio_pci_device;
+
+bool pds_vfio_dirty_is_enabled(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_dirty_set_enabled(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_dirty_set_disabled(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio);
+
+int pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long iova,
+				unsigned long length,
+				struct iova_bitmap *dirty);
+int pds_vfio_dma_logging_start(struct vfio_device *vdev,
+			       struct rb_root_cached *ranges, u32 nnodes,
+			       u64 *page_size);
+int pds_vfio_dma_logging_stop(struct vfio_device *vdev);
+#endif /* _DIRTY_H_ */
diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index c507f39a2339..9116527408da 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -371,7 +371,7 @@ pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
 
 	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
 		pds_vfio_put_save_file(pds_vfio);
-		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_NONE);
+		pds_vfio_dirty_disable(pds_vfio);
 		return NULL;
 	}
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 2435d8255366..c58b0c1fc811 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -5,6 +5,7 @@
 #include <linux/vfio_pci_core.h>
 
 #include "lm.h"
+#include "dirty.h"
 #include "vfio_dev.h"
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
@@ -25,7 +26,7 @@ struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 			    vfio_coredev);
 }
 
-static void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
+void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 {
 again:
 	spin_lock(&pds_vfio->reset_lock);
@@ -117,6 +118,12 @@ static const struct vfio_migration_ops pds_vfio_lm_ops = {
 	.migration_get_data_size = pds_vfio_get_device_state_size
 };
 
+static const struct vfio_log_ops pds_vfio_log_ops = {
+	.log_start = pds_vfio_dma_logging_start,
+	.log_stop = pds_vfio_dma_logging_stop,
+	.log_read_and_clear = pds_vfio_dma_logging_report,
+};
+
 static int pds_vfio_init_device(struct vfio_device *vdev)
 {
 	struct pds_vfio_pci_device *pds_vfio =
@@ -134,6 +141,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
+	vdev->log_ops = &pds_vfio_log_ops;
 
 	dev_dbg(&pdev->dev,
 		"%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
@@ -172,6 +180,7 @@ static void pds_vfio_close_device(struct vfio_device *vdev)
 	mutex_lock(&pds_vfio->state_mutex);
 	pds_vfio_put_restore_file(pds_vfio);
 	pds_vfio_put_save_file(pds_vfio);
+	pds_vfio_dirty_disable(pds_vfio);
 	mutex_unlock(&pds_vfio->state_mutex);
 	mutex_destroy(&pds_vfio->state_mutex);
 	vfio_pci_core_close_device(vdev);
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index df6208a7140b..1e28c072ce08 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+#include "dirty.h"
 #include "lm.h"
 
 struct pdsc;
@@ -17,6 +18,7 @@ struct pds_vfio_pci_device {
 
 	struct pds_vfio_lm_file *save_file;
 	struct pds_vfio_lm_file *restore_file;
+	struct pds_vfio_dirty dirty;
 	struct mutex state_mutex; /* protect migration state */
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
@@ -27,6 +29,8 @@ struct pds_vfio_pci_device {
 	u16 client_id;
 };
 
+void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio);
+
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index db6de081f15f..2e51f66b85a0 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -601,6 +601,13 @@ enum pds_lm_cmd_opcode {
 	PDS_LM_CMD_RESUME          = 20,
 	PDS_LM_CMD_SAVE            = 21,
 	PDS_LM_CMD_RESTORE         = 22,
+
+	/* Dirty page tracking commands */
+	PDS_LM_CMD_DIRTY_STATUS    = 32,
+	PDS_LM_CMD_DIRTY_ENABLE    = 33,
+	PDS_LM_CMD_DIRTY_DISABLE   = 34,
+	PDS_LM_CMD_DIRTY_READ_SEQ  = 35,
+	PDS_LM_CMD_DIRTY_WRITE_ACK = 36,
 };
 
 /**
@@ -777,6 +784,172 @@ enum pds_lm_host_vf_status {
 	PDS_LM_STA_MAX,
 };
 
+/**
+ * struct pds_lm_dirty_region_info - Memory region info for STATUS and ENABLE
+ * @dma_base:		Base address of the DMA-contiguous memory region
+ * @page_count:		Number of pages in the memory region
+ * @page_size_log2:	Log2 page size in the memory region
+ * @rsvd:		Word boundary padding
+ */
+struct pds_lm_dirty_region_info {
+	__le64 dma_base;
+	__le32 page_count;
+	u8     page_size_log2;
+	u8     rsvd[3];
+};
+
+/**
+ * struct pds_lm_dirty_status_cmd - DIRTY_STATUS command
+ * @opcode:		Opcode PDS_LM_CMD_DIRTY_STATUS
+ * @rsvd:		Word boundary padding
+ * @vf_id:		VF id
+ * @max_regions:	Capacity of the region info buffer
+ * @rsvd2:		Word boundary padding
+ * @regions_dma:	DMA address of the region info buffer
+ *
+ * The minimum of max_regions (from the command) and num_regions (from the
+ * completion) of struct pds_lm_dirty_region_info will be written to
+ * regions_dma.
+ *
+ * The max_regions may be zero, in which case regions_dma is ignored.  In that
+ * case, the completion will only report the maximum number of regions
+ * supported by the device, and the number of regions currently enabled.
+ */
+struct pds_lm_dirty_status_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     max_regions;
+	u8     rsvd2[3];
+	__le64 regions_dma;
+} __packed;
+
+/**
+ * enum pds_lm_dirty_bmp_type - Type of dirty page bitmap
+ * @PDS_LM_DIRTY_BMP_TYPE_NONE: No bitmap / disabled
+ * @PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK: Seq/Ack bitmap representation
+ */
+enum pds_lm_dirty_bmp_type {
+	PDS_LM_DIRTY_BMP_TYPE_NONE     = 0,
+	PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK  = 1,
+};
+
+/**
+ * struct pds_lm_dirty_status_comp - STATUS command completion
+ * @status:		Status of the command (enum pds_core_status_code)
+ * @rsvd:		Word boundary padding
+ * @comp_index:		Index in the desc ring for which this is the completion
+ * @max_regions:	Maximum number of regions supported by the device
+ * @num_regions:	Number of regions currently enabled
+ * @bmp_type:		Type of dirty bitmap representation
+ * @rsvd2:		Word boundary padding
+ * @bmp_type_mask:	Mask of supported bitmap types, bit index per type
+ * @rsvd3:		Word boundary padding
+ * @color:		Color bit
+ *
+ * This completion descriptor is used for STATUS, ENABLE, and DISABLE.
+ */
+struct pds_lm_dirty_status_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	u8     max_regions;
+	u8     num_regions;
+	u8     bmp_type;
+	u8     rsvd2;
+	__le32 bmp_type_mask;
+	u8     rsvd3[3];
+	u8     color;
+};
+
+/**
+ * struct pds_lm_dirty_enable_cmd - DIRTY_ENABLE command
+ * @opcode:		Opcode PDS_LM_CMD_DIRTY_ENABLE
+ * @rsvd:		Word boundary padding
+ * @vf_id:		VF id
+ * @bmp_type:		Type of dirty bitmap representation
+ * @num_regions:	Number of entries in the region info buffer
+ * @rsvd2:		Word boundary padding
+ * @regions_dma:	DMA address of the region info buffer
+ *
+ * The num_regions must be nonzero, and less than or equal to the maximum
+ * number of regions supported by the device.
+ *
+ * The memory regions should not overlap.
+ *
+ * The information should be initialized by the driver.  The device may modify
+ * the information on successful completion, such as by size-aligning the
+ * number of pages in a region.
+ *
+ * The modified number of pages will be greater than or equal to the page count
+ * given in the enable command, and at least as coarsly aligned as the given
+ * value.  For example, the count might be aligned to a multiple of 64, but
+ * if the value is already a multiple of 128 or higher, it will not change.
+ * If the driver requires its own minimum alignment of the number of pages, the
+ * driver should account for that already in the region info of this command.
+ *
+ * This command uses struct pds_lm_dirty_status_comp for its completion.
+ */
+struct pds_lm_dirty_enable_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     bmp_type;
+	u8     num_regions;
+	u8     rsvd2[2];
+	__le64 regions_dma;
+} __packed;
+
+/**
+ * struct pds_lm_dirty_disable_cmd - DIRTY_DISABLE command
+ * @opcode:	Opcode PDS_LM_CMD_DIRTY_DISABLE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ *
+ * Dirty page tracking will be disabled.  This may be called in any state, as
+ * long as dirty page tracking is supported by the device, to ensure that dirty
+ * page tracking is disabled.
+ *
+ * This command uses struct pds_lm_dirty_status_comp for its completion.  On
+ * success, num_regions will be zero.
+ */
+struct pds_lm_dirty_disable_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_dirty_seq_ack_cmd - DIRTY_READ_SEQ or _WRITE_ACK command
+ * @opcode:	Opcode PDS_LM_CMD_DIRTY_[READ_SEQ|WRITE_ACK]
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @off_bytes:	Byte offset in the bitmap
+ * @len_bytes:	Number of bytes to transfer
+ * @num_sge:	Number of DMA scatter gather elements
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	DMA address of scatter gather list
+ *
+ * Read bytes from the SEQ bitmap, or write bytes into the ACK bitmap.
+ *
+ * This command treats the entire bitmap as a byte buffer.  It does not
+ * distinguish between guest memory regions.  The driver should refer to the
+ * number of pages in each region, according to PDS_LM_CMD_DIRTY_STATUS, to
+ * determine the region boundaries in the bitmap.  Each region will be
+ * represented by exactly the number of bits as the page count for that region,
+ * immediately following the last bit of the previous region.
+ */
+struct pds_lm_dirty_seq_ack_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	__le32 off_bytes;
+	__le32 len_bytes;
+	__le16 num_sge;
+	u8     rsvd2[2];
+	__le64 sgl_addr;
+} __packed;
+
 /**
  * struct pds_lm_host_vf_status_cmd - HOST_VF_STATUS command
  * @opcode:	Opcode PDS_LM_CMD_HOST_VF_STATUS
@@ -815,6 +988,10 @@ union pds_core_adminq_cmd {
 	struct pds_lm_save_cmd			lm_save;
 	struct pds_lm_restore_cmd		lm_restore;
 	struct pds_lm_host_vf_status_cmd	lm_host_vf_status;
+	struct pds_lm_dirty_status_cmd		lm_dirty_status;
+	struct pds_lm_dirty_enable_cmd		lm_dirty_enable;
+	struct pds_lm_dirty_disable_cmd		lm_dirty_disable;
+	struct pds_lm_dirty_seq_ack_cmd		lm_dirty_seq_ack;
 };
 
 union pds_core_adminq_comp {
@@ -838,6 +1015,7 @@ union pds_core_adminq_comp {
 	struct pds_core_q_init_comp       q_init;
 
 	struct pds_lm_status_comp		lm_status;
+	struct pds_lm_dirty_status_comp		lm_dirty_status;
 };
 
 #ifndef __CHECKER__
-- 
2.17.1


