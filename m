Return-Path: <netdev+bounces-4020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 859FF70A23D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F1AF281BFF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A520E182AD;
	Fri, 19 May 2023 21:56:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348B182A1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:56:58 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7A610F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:56:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkK4Dv2Ws5+vt8AFCQyaY+fQAAfGkroVDmb0XHHMYp4LO+Vt3oJl/Ga+0AKbLwIskiM5modXMRbMdnaRepv7vsnc4gPYtUeQT/Xe1N3PBg++FMmrv3UaXMEZWl5EBDb+ooJQvXIXem9lIv1A5ZAk7UVwTNYwxMVJowC2YCqfv00zAObABIfCNpcbQafrCsfu/h/1IaGMjThwwLmlqmbgaNpHMtE8F30Y8+pIzFof3Csevwjsm8o7zlDP7a2gBw+Mqk3FgR9Vn9f780Qae2+ozCGclIInNSRsKVwiTr+opH7gFORTygAy2nhHQETvdC7Wb2FEBLEs33pjckSLmJnEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjLTOwD8kyi9Vm6e95kDwSNjpbT8accAL9JbwovDCuo=;
 b=ce1mIZPpexjdyrY13dWcdm/4e2fhHszQajwb2cojptP4VVMVLK2N0cld0lididOeV/wyCCPG0SALvvyduAByjxvCmFbS7d1l2K0TkuLSfPyHtoYQMJG1id6AQrUM9mB90VFbjW8qmsLSyKIsO60CeGchNOzKIRqQlaPFe02THNq7LiRLGH3+5+ZQxtv7kzxgAQII5beafbPZRtOgi0FBIDZoU5r6jtCrNF9DD8Q9BYjaLNe0DAt/VFrkexLIbR8uxHTybb4J+hJ05POobDXUa9tpnB5eVScMLWZp17jicp8vURdQIOj3r4ZwKYEKA+Ibt5r1tArP964SpxsZgtRkqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjLTOwD8kyi9Vm6e95kDwSNjpbT8accAL9JbwovDCuo=;
 b=IqAQbzRHe7Ur2H+Tb7h3WtGuwzPpAErbCw44Sb7fKX+pvqEI4HTS94h4na2Um0lTWYj0fZ7VJ6XAZ0Fkldm71mRnwZZcRft9O2D1jWgMxkvX0UZkHp0kOvDEn9iO/W4i+zETt62atAi+V+MyXl1rYbAGHKytUCa0D5Ne0q/4hUE=
Received: from BN7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:408:20::39)
 by SN7PR12MB8148.namprd12.prod.outlook.com (2603:10b6:806:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 21:56:54 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::c2) by BN7PR02CA0026.outlook.office365.com
 (2603:10b6:408:20::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 21:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:56:53 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:52 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 04/11] pds_vdpa: move enum from common to adminq header
Date: Fri, 19 May 2023 14:56:25 -0700
Message-ID: <20230519215632.12343-5-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|SN7PR12MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 61df9576-68ce-4fce-f2dd-08db58b3f50d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VPZ2VKEKM7QPLnq8MflrZxFt5NUXpCbit+z/Lvs8N0sZVRG2IEcs43v6Wnw8+AM1AAjzjkktZTbzsZF164kmb19MAC39ijMaf1f72ZaPHahuZEoNtjMCkzpvs5bUgk7ASndJXnaTDVaZpegWSnsdPS7ijvoYbjvxAECN0abpwtDzftaG5fBvw6GUMMqGWN+pcU3ZH8uajiDSS0cQgDiFjPomzABIqsziptedTmSLE8bW5P5YvXaqjyFUBsgpCDhU2RYtGJiTWoaCMtqy59G9pHxTPZWtISCvDKtCNpFRoI4sk+84D/DC42cQmA2eKmJy8btTkFCLF4YsDK+z5MYPe+qCCxySxp2vpWIo0sLZLdTe0t42eH0RtMSkS0etS47xGRSxz8tJtmhD4OnC2xj9qy1/aP6aMFvwvBinfJifQFGOxwuqO6JJKcqtv9GjX55gvozlM2l5BK3GZpO4JF1FdkdGUp5WMr5MiA0pCX3GBCM0v3npRkmCrAzFTainf1OF3U3m9MUu1PYwFNGEnzVu3/DNM+hdNQwB9uv2vew7qLLfwzF+IRHphD/M//lUWzWD+4X9jTVQaSxO1W7QC+tGldHEEs9Zr4Gaeibwiv28917aXksdUOoK3DY7b0jTsEg/KgCQ+6SnAb2liAdhTHxCpJ/+A2thrWM/JLorQl3W9gTFEEu/8ixn5WGr7BjAnaqYyAupMCpb6i/tOp9ZsBq4NzyiBqHXbWAkoL7rlOnI6lLWLm1B2IW7u7/kgEO9pN2dbTifSnj5Mu6n8B8PcfBMaA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(6666004)(26005)(1076003)(8676002)(426003)(186003)(336012)(316002)(16526019)(36756003)(44832011)(478600001)(81166007)(356005)(2616005)(86362001)(4326008)(5660300002)(82310400005)(54906003)(70206006)(83380400001)(110136005)(82740400003)(40480700001)(70586007)(41300700001)(36860700001)(47076005)(2906002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:56:53.6310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61df9576-68ce-4fce-f2dd-08db58b3f50d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The pds_core_logical_qtype enum and IFNAMSIZ are not needed
in the common PDS header, only needed when working with the
adminq, so move them to the adminq header.

Note: This patch might conflict with pds_vfio patches that are
      in review, depending on which patchset gets pulled first.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/pds/pds_adminq.h | 21 +++++++++++++++++++++
 include/linux/pds/pds_common.h | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index 98a60ce87b92..61b0a8634e1a 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -222,6 +222,27 @@ enum pds_core_lif_type {
 	PDS_CORE_LIF_TYPE_DEFAULT = 0,
 };
 
+#define PDS_CORE_IFNAMSIZ		16
+
+/**
+ * enum pds_core_logical_qtype - Logical Queue Types
+ * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
+ * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
+ * @PDS_CORE_QTYPE_RXQ:       Receive Queue
+ * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
+ * @PDS_CORE_QTYPE_EQ:        Event Queue
+ * @PDS_CORE_QTYPE_MAX:       Max queue type supported
+ */
+enum pds_core_logical_qtype {
+	PDS_CORE_QTYPE_ADMINQ  = 0,
+	PDS_CORE_QTYPE_NOTIFYQ = 1,
+	PDS_CORE_QTYPE_RXQ     = 2,
+	PDS_CORE_QTYPE_TXQ     = 3,
+	PDS_CORE_QTYPE_EQ      = 4,
+
+	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
+};
+
 /**
  * union pds_core_lif_config - LIF configuration
  * @state:	    LIF state (enum pds_core_lif_state)
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 2a0d1669cfd0..435c8e8161c2 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -41,27 +41,6 @@ enum pds_core_vif_types {
 
 #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
 
-#define PDS_CORE_IFNAMSIZ		16
-
-/**
- * enum pds_core_logical_qtype - Logical Queue Types
- * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
- * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
- * @PDS_CORE_QTYPE_RXQ:       Receive Queue
- * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
- * @PDS_CORE_QTYPE_EQ:        Event Queue
- * @PDS_CORE_QTYPE_MAX:       Max queue type supported
- */
-enum pds_core_logical_qtype {
-	PDS_CORE_QTYPE_ADMINQ  = 0,
-	PDS_CORE_QTYPE_NOTIFYQ = 1,
-	PDS_CORE_QTYPE_RXQ     = 2,
-	PDS_CORE_QTYPE_TXQ     = 3,
-	PDS_CORE_QTYPE_EQ      = 4,
-
-	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
-};
-
 int pdsc_register_notify(struct notifier_block *nb);
 void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
-- 
2.17.1


