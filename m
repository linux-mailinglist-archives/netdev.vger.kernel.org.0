Return-Path: <netdev+bounces-4021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 050A170A241
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6F6B1C211BF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E05182BE;
	Fri, 19 May 2023 21:56:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950E617FE9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:56:59 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F940BA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1E2G+6haOSaNSGd+WINED+FRq3UqrJIZ9IWwEQDoSbpsxbcm0zEsFLTIRdrFM0vJu+arrqkAQenhJjiLN3vf4dRgMuI2iGGum8WN5ILCF8czPfeHywzpO/jHXVKuubc1qNXtEagDLWTC0CF9SqC+9c0vj9Wg6lpAmTilVRCnHQviZfJ7X1WBh56X8idkN83zaQbQtm/+7hUE09Ttly89Nvu+snc2mM4gl8h4JJ0UHuzjxeRr4TxxEMlwtkEIRPHQK30Mn5HM4emk9Kf/qO0WxjzYaoTLu2zcCUq254pqmC9xFsWp150fIDh6FRV/mr+RoPMevbZXKAQ95ZKdjOT6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar/EvQMDsaGpEXWXWaFwk/dUjNqlFEk6w69bf6/a6uY=;
 b=hHrxab4xrVVMPXhvIw3RbRA1HU1TOhjdV1GYLj3P0ghJF6/fT48KIojwewRQ5NLlSh8+MgvbIhAmO9GKZ/hYhlQuHdwIRW5YWbGNpVrr6gnDjCU8jSYxZmbUZicqzoNDUx6vs2EDKq7tl5LBvjc2zbjw5VYzEUV0jh8X2WUeVuOxddek+TC4xWWqlVJ+vuiIE9U3s03lY2Tq/6jrkhw/J/GmMnPTC455l050Kns8DrtkEhIFoGuB16TSb1kQIuUnLkmSTWvt1WvAUoV1DO3KvDeLATLIrSUWZktBahCd5tv3yiL1zt5P8H8PCxXlgzw5UD5Oj38xfuL7CNKILBGQsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar/EvQMDsaGpEXWXWaFwk/dUjNqlFEk6w69bf6/a6uY=;
 b=DLqpDMvkWiikWoDjpbL0MHyXGCgmmjVvf3205gThLAsPqogJtrUCNxQDH6CNQDJ+gUh7rfqAYZR5sG6mPetaCv3J7+Fzb4k9jmWIRIGLjW0Csa9UEZubfYw/1h14N4YroOTuUa/iiPvFAN32hiwBeSIdGBsR4wY1WWX6S7dtF2U=
Received: from BN7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:408:20::39)
 by IA1PR12MB7519.namprd12.prod.outlook.com (2603:10b6:208:418::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 21:56:55 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::c2) by BN7PR02CA0026.outlook.office365.com
 (2603:10b6:408:20::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 21:56:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:56:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:53 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 05/11] pds_vdpa: new adminq entries
Date: Fri, 19 May 2023 14:56:26 -0700
Message-ID: <20230519215632.12343-6-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230519215632.12343-1-shannon.nelson@amd.com>
References: <20230519215632.12343-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|IA1PR12MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: 959ef4b9-7e8b-4d75-0741-08db58b3f62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AnaXw5yqfMivFgMsmXeMcNAlqAXUR8S/2ecDjHxpXETW0NKpfT/znWbbjJNfhzlwGglZ9zPkgIeaMiqh1QoMj6YxVq+JOB1qj0aHCwnHOH3deVF4RlUyD0gxiwwxJwTswpFoINOulWweNZ7dNmAjxVxFsEsgxP+SP/dZCsKhzBUBajNk4Z/RJ4WrRnvt2zIv20TloNYxh4vxKDZuWo8sWdKXJHOW8/srIE0sqYcNjeNfqktAQNBmhHQi+yGIGEsoCI/xuvsIEDRJqUapnT0R3Zibj6z1w5F9bFqWCCtBOg4dEayG4KilUqqPGeUL8P53N/RyYY8n6Jnvk+o4NMuS+X2s9wWae/XFCvH9XEjuZ6NygxXT2im99yPdINHscRKScvCeiw6OgVTH01DP3GuQaEkOEtzXBkyIDs+jnW1s0J66RS7t5dRiG5sh3Vhq9hG1iumprSQ2a8NUTjZkpIG6pKbQXaEAITVZGF3z0choLdSHMxrm2UpaU6cx+JxD2qyO3xZ8b67sHxMolBakKwy3GOmDQzjvMhGN8Lfie2Dw+/MqvgLvzas0wVPBcRbTC/px2NlmfCv3y4/OzD/vTVqdSNGHnZ2RJzOIzAvWaUmajyVSnCqVMXEQxPohDlW3jNCN+pmPn5k0zJt+rrZrN55Xl1xkCdeUOA8pneiBlFBjzEZ9jW5msii8ZE5L3KKWsX8ltjSpkTRCaKcMjKr/608Ufj1Z4s1aaswmGs+32tJTlzCEdoABBUUotwKo/FgnsyfSdT+8uwHXuNsc41wBbEmzFw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(70586007)(70206006)(4326008)(478600001)(110136005)(54906003)(316002)(36756003)(86362001)(83380400001)(47076005)(26005)(36860700001)(186003)(426003)(1076003)(16526019)(2616005)(336012)(5660300002)(41300700001)(44832011)(8676002)(8936002)(2906002)(6666004)(40480700001)(82310400005)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:56:55.5059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 959ef4b9-7e8b-4d75-0741-08db58b3f62c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7519
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


