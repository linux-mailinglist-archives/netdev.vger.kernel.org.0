Return-Path: <netdev+bounces-2833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF177043BC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDED31C20CA8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAFE5233;
	Tue, 16 May 2023 02:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359685230
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:55:53 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E920E58
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO+fukNMUjos8ZF+cxZZ5fXe9pg9pzJAB9uzoaez9zbwh+dW+7cJleBt5NfjAulZqN7eJWjxwIiy3hzVTyMwgLbuWU0KTpdeRFUYBEt7BTeKW7O8XFBboxht8VmFHUTYpSBfzOhm2vW+OaP8cre0QiTqA8NUYARcmibW7mMQTpHucBY9x4stiEYF4afQoMZvP+oE6FOuD3Rp6dxY55mKsseCW+JkaSRJdKjX8sgK1G5RZoWZfGSWoPVqPSUCShVTnAnfWbhxfx0TLpQV5uhff31pSSJdUaa9SAr3TJ7NTY4BzBMlz5WM1dz9Vsvqz6y5PO/MOKqDeuBWkiWE+f0RjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar/EvQMDsaGpEXWXWaFwk/dUjNqlFEk6w69bf6/a6uY=;
 b=JRZW1GFGQMD3UNjFTi76M4b4/yLxMLXRrNIH9ullr9w5HHABfYbJk7/OSh2v4SRaWksjibNG/OLVQLDdsImaCwjORgQ5P/nKPFjkIwceUA7CwLuXKoTc3Q3yX5a7I/GiJZ9NTtNCwLILXupSAqewu+6j935krSEfoy5LO2liWmJiFPuVuqmaQBL8bIEDeMEyaA+F1+ia3lynz0awLUvitz+spgkUfN9SxQG+k8SZ4teFolshWn5E+tTeqfEj+EG5/GMbVDlDR4xW22nWY+NebSpRlsDiz7D+A58ZPKg5f3xipzozDKSiH17aCyaaHlJLIgqTnK73WIfqgeh6Q4OTfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar/EvQMDsaGpEXWXWaFwk/dUjNqlFEk6w69bf6/a6uY=;
 b=zlTgMoGRU81umqPKdW0HoCJH65OeT3pjPQ30Lo6WR1mVlvzt3YPoagoIZ/KZTUJTiYsJLd/bvnu8wdsQhsUPQiCauCfNpTfUrUyGsn9SPbq0yi4yGFqFSSf/lmq/+UoFcZXKYoJ2R9KJNTrNCLj6QRmxXjOCS37XhYAuqtAC96s=
Received: from SJ0PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:33a::33)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:55:49 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33a:cafe::f3) by SJ0PR03CA0028.outlook.office365.com
 (2603:10b6:a03:33a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 02:55:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:48 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:46 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 05/11] pds_vdpa: new adminq entries
Date: Mon, 15 May 2023 19:55:15 -0700
Message-ID: <20230516025521.43352-6-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230516025521.43352-1-shannon.nelson@amd.com>
References: <20230516025521.43352-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 05a3e6fd-1c5f-4a00-2281-08db55b90d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rTJxFxSPOiKLc3jLrqkXpnsqpTzqDKAH050BUpZVDVhEuAuaoMhoHldHhQd3NpZelWs5U/EqH3xqofbe8ywPq5Gkxj2bcqXrjsiGO8UYonWocyJkHPsZysplkXelHjsnK8FAmyZyYSciI9/2XuduQ0k2wHF//LoyScQCWklqhiEt79+mPl38KI6vBGAdi5Kgu6gjbzzqUJTc6dNN1BtFP265aC7yVD2Q422mh/xG3cyZsKnDC0FNVUfT9AAGY4tH10WNGIQ/enNjJ9lx1eeH7xbc2xpkseVUPaHgKETuCXEeD1JB54vnzDKiof5Gaht8zmiP6jnftL2bdiudJIjeY9Y2a4sQz7eHqr25qdOQy+i86Af7vDAieCdgn+8goQmAbVaycVYkRX2klV7QH3gl1UizdgzgYIla3BWIJUnJLC+4mp7a6xeZ3gU+SpwWV0GYDhWbFMoFgXOa0VADgKBWunH7v67NrhEBKaOdKDCptKrMzvGX9dlojq9vwe8sHyH3VyeBV/Rc4URTvTrGmvhYdfZGIKuqzGevdWO3uPh9MoFMFrEK0E0VRxoPqImYYZXuA/at3p45MeZGmuohv+57JvdEMjSCiYfOFb6Tza8UmKuzULe0uVrdhSx0w6gh2dShpHtwh1tRWQeR/My4wN5159/yG1RmdBQKlxTX2dMfdz0AFXdnH/H7RKEa4tgjsSsZaRJynveI6EoqKpTSxy32P4SHTKoOYWcWziDaGNqKVD/yipKDXzHHEmZeIv12B5fPa9YPh/nVs8wq+W6z4VeZYw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(16526019)(186003)(86362001)(36860700001)(2906002)(26005)(1076003)(6666004)(2616005)(47076005)(83380400001)(82310400005)(426003)(336012)(8676002)(8936002)(478600001)(36756003)(40460700003)(54906003)(110136005)(81166007)(5660300002)(82740400003)(316002)(356005)(4326008)(41300700001)(44832011)(70206006)(70586007)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:48.5825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a3e6fd-1c5f-4a00-2281-08db55b90d7c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add new adminq definitions in support for vDPA operations.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/pds/pds_adminq.h | 226 +++++++++++++++++++++++++++++++++
 1 file changed, 226 insertions(+)

diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index 61b0a8634e1a..bcba7fda3cc9 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -605,6 +605,219 @@ struct pds_core_q_init_comp {
 	u8     color;
 };
 
+/*
+ * enum pds_vdpa_cmd_opcode - vDPA Device commands
+ */
+enum pds_vdpa_cmd_opcode {
+	PDS_VDPA_CMD_INIT		= 48,
+	PDS_VDPA_CMD_IDENT		= 49,
+	PDS_VDPA_CMD_RESET		= 51,
+	PDS_VDPA_CMD_VQ_RESET		= 52,
+	PDS_VDPA_CMD_VQ_INIT		= 53,
+	PDS_VDPA_CMD_STATUS_UPDATE	= 54,
+	PDS_VDPA_CMD_SET_FEATURES	= 55,
+	PDS_VDPA_CMD_SET_ATTR		= 56,
+};
+
+/**
+ * struct pds_vdpa_cmd - generic command
+ * @opcode:	Opcode
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ */
+struct pds_vdpa_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_vdpa_init_cmd - INIT command
+ * @opcode:	Opcode PDS_VDPA_CMD_INIT
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ */
+struct pds_vdpa_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_vdpa_ident - vDPA identification data
+ * @hw_features:	vDPA features supported by device
+ * @max_vqs:		max queues available (2 queues for a single queuepair)
+ * @max_qlen:		log(2) of maximum number of descriptors
+ * @min_qlen:		log(2) of minimum number of descriptors
+ *
+ * This struct is used in a DMA block that is set up for the PDS_VDPA_CMD_IDENT
+ * transaction.  Set up the DMA block and send the address in the IDENT cmd
+ * data, the DSC will write the ident information, then we can remove the DMA
+ * block after reading the answer.  If the completion status is 0, then there
+ * is valid information, else there was an error and the data should be invalid.
+ */
+struct pds_vdpa_ident {
+	__le64 hw_features;
+	__le16 max_vqs;
+	__le16 max_qlen;
+	__le16 min_qlen;
+};
+
+/**
+ * struct pds_vdpa_ident_cmd - IDENT command
+ * @opcode:	Opcode PDS_VDPA_CMD_IDENT
+ * @rsvd:       Word boundary padding
+ * @vf_id:	VF id
+ * @len:	length of ident info DMA space
+ * @ident_pa:	address for DMA of ident info (struct pds_vdpa_ident)
+ *			only used for this transaction, then forgotten by DSC
+ */
+struct pds_vdpa_ident_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	__le32 len;
+	__le64 ident_pa;
+};
+
+/**
+ * struct pds_vdpa_status_cmd - STATUS_UPDATE command
+ * @opcode:	Opcode PDS_VDPA_CMD_STATUS_UPDATE
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @status:	new status bits
+ */
+struct pds_vdpa_status_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     status;
+};
+
+/**
+ * enum pds_vdpa_attr - List of VDPA device attributes
+ * @PDS_VDPA_ATTR_MAC:          MAC address
+ * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
+ */
+enum pds_vdpa_attr {
+	PDS_VDPA_ATTR_MAC          = 1,
+	PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
+};
+
+/**
+ * struct pds_vdpa_setattr_cmd - SET_ATTR command
+ * @opcode:		Opcode PDS_VDPA_CMD_SET_ATTR
+ * @vdpa_index:		Index for vdpa subdevice
+ * @vf_id:		VF id
+ * @attr:		attribute to be changed (enum pds_vdpa_attr)
+ * @pad:		Word boundary padding
+ * @mac:		new mac address to be assigned as vdpa device address
+ * @max_vq_pairs:	new limit of virtqueue pairs
+ */
+struct pds_vdpa_setattr_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     attr;
+	u8     pad[3];
+	union {
+		u8 mac[6];
+		__le16 max_vq_pairs;
+	} __packed;
+};
+
+/**
+ * struct pds_vdpa_vq_init_cmd - queue init command
+ * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)
+ * @len:	log(2) of max descriptor count
+ * @desc_addr:	DMA address of descriptor area
+ * @avail_addr:	DMA address of available descriptors (aka driver area)
+ * @used_addr:	DMA address of used descriptors (aka device area)
+ * @intr_index:	interrupt index
+ * @avail_index:	initial device position in available ring
+ * @used_index:	initial device position in used ring
+ */
+struct pds_vdpa_vq_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+	__le16 len;
+	__le64 desc_addr;
+	__le64 avail_addr;
+	__le64 used_addr;
+	__le16 intr_index;
+	__le16 avail_index;
+	__le16 used_index;
+};
+
+/**
+ * struct pds_vdpa_vq_init_comp - queue init completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @hw_qtype:	HW queue type, used in doorbell selection
+ * @hw_qindex:	HW queue index, used in doorbell selection
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_vq_init_comp {
+	u8     status;
+	u8     hw_qtype;
+	__le16 hw_qindex;
+	u8     rsvd[11];
+	u8     color;
+};
+
+/**
+ * struct pds_vdpa_vq_reset_cmd - queue reset command
+ * @opcode:	Opcode PDS_VDPA_CMD_VQ_RESET
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id
+ */
+struct pds_vdpa_vq_reset_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+};
+
+/**
+ * struct pds_vdpa_vq_reset_comp - queue reset completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd0:	Word boundary padding
+ * @avail_index:	current device position in available ring
+ * @used_index:	current device position in used ring
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_vq_reset_comp {
+	u8     status;
+	u8     rsvd0;
+	__le16 avail_index;
+	__le16 used_index;
+	u8     rsvd[9];
+	u8     color;
+};
+
+/**
+ * struct pds_vdpa_set_features_cmd - set hw features
+ * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @rsvd:       Word boundary padding
+ * @features:	Feature bit mask
+ */
+struct pds_vdpa_set_features_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le32 rsvd;
+	__le64 features;
+};
+
 union pds_core_adminq_cmd {
 	u8     opcode;
 	u8     bytes[64];
@@ -621,6 +834,16 @@ union pds_core_adminq_cmd {
 
 	struct pds_core_q_identify_cmd    q_ident;
 	struct pds_core_q_init_cmd        q_init;
+
+	struct pds_vdpa_cmd		  vdpa;
+	struct pds_vdpa_init_cmd	  vdpa_init;
+	struct pds_vdpa_ident_cmd	  vdpa_ident;
+	struct pds_vdpa_status_cmd	  vdpa_status;
+	struct pds_vdpa_setattr_cmd	  vdpa_setattr;
+	struct pds_vdpa_set_features_cmd  vdpa_set_features;
+	struct pds_vdpa_vq_init_cmd	  vdpa_vq_init;
+	struct pds_vdpa_vq_reset_cmd	  vdpa_vq_reset;
+
 };
 
 union pds_core_adminq_comp {
@@ -642,6 +865,9 @@ union pds_core_adminq_comp {
 
 	struct pds_core_q_identify_comp   q_ident;
 	struct pds_core_q_init_comp       q_init;
+
+	struct pds_vdpa_vq_init_comp	  vdpa_vq_init;
+	struct pds_vdpa_vq_reset_comp	  vdpa_vq_reset;
 };
 
 #ifndef __CHECKER__
-- 
2.17.1


