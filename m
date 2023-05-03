Return-Path: <netdev+bounces-198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1126F5DB1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7392F281703
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8FDBE48;
	Wed,  3 May 2023 18:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9109BE46
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:06 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EA6E57
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+sN7aRConupdYHUVqlFPvYNXKJQK+WFMLS5rq7hYihISGTLcDLnQmCmeqPhy+itLiUTyOOBgOkWununkqcVuass9CrwGly7IF9n63ZwMtznIBWoUtRnVqHjw0WP3B3Uuy/TzeFu6DAUSANEZRCkxCB3k4DSIMlJMGVIjMHs+7A5DxxwjB1jYvqJfL4KZWp9RseIMQ/2WgQdWRMj/NTnkWw+aMDf9yR3TCYJCxg1B9ofwyHt63yPv+cdZIQXxUFLh/442nKfRMyJY6BzM7EMWKDNQKAJfXJIA0+urCUVNuxIIncsybqZwmSl/QlVJ4Hr39iUzCJ/U0RY+4iWN+4a8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzOeibijAYMHBctMJZOAW07kd4c9TXIUK6PWuZ69Q7c=;
 b=lGY+k/FbScqeZqUIS/u9DfdNdvJr2TaGGyjog/ETvWFyYQa4LqEpXLtmWtikFoVrS2H2h/kRBvrJTR5ZO04GJukxmil5Z/ikrCSTGP5jn6qcbtBPZ1kp0z+AXFa8zZm0cYWqwnvSFbVsUmQrlC3926c8ZfVdlLvStuZopC1QOWaQmkON6t0muvMDDgUTaHItcTxBiSPONWFSfU7JCR4aebktLciu83Ldkm4hnCtX+iSc3HbtWiw+ycq58btqhLwYo/jvZRoP9hybkdUqdSJZHYVCSfGbFtlvqHj2SUInhh7+WVMBQuJeR3m74uPL3ovdMfGP2AqqbYs/V9l7iU/OMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzOeibijAYMHBctMJZOAW07kd4c9TXIUK6PWuZ69Q7c=;
 b=xVyxEFqZNmTZZrN3jE33FJ68blGIxQBUPKs+QqYVOzsXCeHLVF/I6/bfrdcu+N7qLs2V6mDoJK5iHa0srW2do67mfDkbog+8C58EXApS2XfalI8nsqbf5MvZqsuqfUEx8j3cCWdooqJn5dcl5tmU2EZl1Do3gRxqV1VY09pFeDg=
Received: from DM6PR03CA0056.namprd03.prod.outlook.com (2603:10b6:5:100::33)
 by DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 18:13:02 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::86) by DM6PR03CA0056.outlook.office365.com
 (2603:10b6:5:100::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:13:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:13:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:13:00 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 04/11] pds_vdpa: move enum from common to adminq header
Date: Wed, 3 May 2023 11:12:33 -0700
Message-ID: <20230503181240.14009-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230503181240.14009-1-shannon.nelson@amd.com>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: a1646ad7-c044-42a6-2564-08db4c0208c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sAtYFw5M0VfQqU7S8i/BMGBMtQ6jIULCKIpLEtWZ8FS5SbETz5kBhvkBtfhBuF0rhKJnzgI6YPn2PBVPqQ51gW/ZcCcXcCn9Lx6rBDow3ybEwg4tg7dGGHj4DqpG725+Y5N/DXWAs+WmTqF23qQixso+jgfs3lxz6tctsHBEbFHRJKT4SiX1gM1Nplx5gVr/zXtdBImJug8LY9SCbXLTsgwbDnY5bmYd/uz5VKqObluFCflE7+2UNUSgwu666UIFt+13fVCxwJetU73dLhEInnLQbctGGHuYxNFXEnQt6F06Rfgbj9N4DDi4/uitaZOufxwg3fMwPKoUuaIzRweJOEXoft2EzKxRJJNzP9OZnf9zq34Pnh1hJlBXAvEbV29rc8dffwZSPmRmAd5lbkmaPURH2aT7bkmlCRBoR3uyAJsvctl139654Iv6UK1rzb4VCgyAyZeufqmbezOnXM1FAIZ0SSP92UfuDPNxrMKTssD1sGrdme5WhJoQo3gaJNZzuFYokXq6MGOXopffz8+REF0fPcCJv4RR9iCgEyVta132tL+43YhV59Jhac+Xq4ENLoQyLC3iYErJ2y7uRdlKjlzrjlySuZ4SBpOcPWWyxttZDJz7uor1rfiLP+LJV8mq2G2N7EwR1gZqcv04KcalcL7iJvWr4eZagQHUmHv6hNzKg/8Yb5ZyFjGCLv+4pD1PKlQx7ktfqP+ehVO+3GrgMGgqMYkprDyoutZP7ADVrRA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(83380400001)(2616005)(47076005)(36860700001)(5660300002)(81166007)(36756003)(41300700001)(70206006)(70586007)(40460700003)(82740400003)(316002)(1076003)(16526019)(26005)(186003)(478600001)(426003)(356005)(44832011)(336012)(8676002)(4326008)(86362001)(8936002)(110136005)(40480700001)(2906002)(54906003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:13:02.2797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1646ad7-c044-42a6-2564-08db4c0208c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The pds_core_logical_qtype enum and IFNAMSIZ are not needed
in the common PDS header, only needed when working with the
adminq, so move them to the adminq header.

Note: This patch might conflict with pds_vfio patches that are
      in review, depending on which patchset gets pulled first.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
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


