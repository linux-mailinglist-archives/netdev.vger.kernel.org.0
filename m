Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079EB6EE996
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbjDYV0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbjDYV0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:26:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061D817A23
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJMKNggoPoPlCeXOfznWxJEJeQIPXP2s4M2KJ3RmgDo1yJdq1vwrsuweq5byOGuc+iATouh8PkjP+mmy1ksYmTWNnkqRVJdlfMnZPBm9bvhU32Z0OCgM6wyWzdR0UN5ghX6TKyclxpGhxc1bd8zedZaIRlagydTB1c3RHCfgp/m/oTfx+Zp2YcjVG4CkGhUsYC7V42Xqyr33gufhTWQvFO2167XeuXHYzUqIKagWbzdDSJ219sdQHHh1Cg32f0Lb2/WfJ2r0c3yaLHafuwoht3H6QcCbAaIgL+yfB4ywDAkCWMxLthx9UH0YOuj6HuE82Fb9/J5fSGeVdKGHrECu0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzOeibijAYMHBctMJZOAW07kd4c9TXIUK6PWuZ69Q7c=;
 b=Y9dPA1tE2HMXtAiVvPX0ogCNANGKZkiCksEwvZCebOeGo2Iw2/VQT2jPtIFX/jD27A9LIerHWkRHSr5WnAL68f91WA9R17h8jOQ5ZymnYLTT+ERNYGazojJgwHjPObdVzyfrW3A+PX4S764mnwfd/zkRMNKwZnD5m8e/X6LaofwYIHo0m4mOKuiUxpZV1mP3FTmTTNocu58JiApDzUvYWRE/itGuApJAVYbgNcPTGgFVzIgMbiGZtWlEm+9mVQnb66uQs9wUzbYxd4fCSaMQeVjC468M1rG5uYLn9EjsTZgNSIkBfjR/4MzI96kS7DFtnb8PJxYHyAIYv99aKtQgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzOeibijAYMHBctMJZOAW07kd4c9TXIUK6PWuZ69Q7c=;
 b=C96wYintkMf3QPo7jLlatwqcJZJ2R1nWp+1HhS1sjhtkQXeOxbZ4w0BKjs8lmsqw/+wIY0yUKBsVzsuyGTBN/BT6CU+ApPaVnSClOIRW0gTFC99bJkn+Grc06wd0DnzGR2dVwOxb0p//5+Ful2ClLAQZ2Sy2T6qNVupJjT8qO1g=
Received: from DM6PR06CA0028.namprd06.prod.outlook.com (2603:10b6:5:120::41)
 by CYYPR12MB9013.namprd12.prod.outlook.com (2603:10b6:930:c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 21:26:20 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::c) by DM6PR06CA0028.outlook.office365.com
 (2603:10b6:5:120::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Tue, 25 Apr 2023 21:26:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.20 via Frontend Transport; Tue, 25 Apr 2023 21:26:20 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 25 Apr
 2023 16:26:19 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v4 virtio 03/10] pds_vdpa: move enum from common to adminq header
Date:   Tue, 25 Apr 2023 14:25:55 -0700
Message-ID: <20230425212602.1157-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230425212602.1157-1-shannon.nelson@amd.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT065:EE_|CYYPR12MB9013:EE_
X-MS-Office365-Filtering-Correlation-Id: df72699f-d1cf-4234-092a-08db45d3b68e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wlq0lAcWbyGCtfWRPeOEPsyCxcLzj/QOza7g92wyHbDZyQfcslWhdMvmcZDwTYahJDxGS+oSikJxjjFexVkziu+ELvr8JhL4ufJppjL4hmXjhwLn5uwVEL7J7VQZAgfP3Hk61Tvn033KhxA8ZieoeLiAtjhhSqlv1hmFG8dDBgXC0gsBOeIMBc0iN+FuNpnnnWEYz8OpnuHuNGZPX66cqIfvBooGuf3RADf3oNL7HHmytVfAnoLWqPNBvR9EwYToVtJEH91gOwx4Ndw0yuYvIWQ9OJ9wlZDeMda+6fz1oj2tHeSfjxiqkE2qThZ9IHUbaP6wDIVTVVyrf5oO5CnV3Ue0AUtfeRET51TQyou9NPmdJcuiXCFMGHqqqIfIocXubx2BX7Ygbq6bWEH35+r9zelf0CCUIvk1Tx9hiFYGc/xbXD5LqCWKy9Hgk4fpLUIFySWFymY/7i97F/j9NjuiJYhDucpe6hWhCUIlsMAzifgEzly2oPdpW/EkIrMk8hF49IBSUZ4QLW/jNdvnVkfUUncS0XubNlcEmrORWoRMtjEpWiBAjQNZrs2ZsEbVTLxWdTiz7LMYA8bgR1FAu/9Nxz2nyDMSQFOgAW2URfXJ9VVTtjTnKZk7Y22p7W5WIA5r/9AgFjgvcLa4OJC9MdBi5hsxnKEele03y0rMu84UqjGX50ASn4vF3k7nSOAPB9X1NYeyIFXbLCAAPixJIpn3zUFftGviNcG8bQQdi6wpVXE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(46966006)(40470700004)(16526019)(186003)(70586007)(4326008)(82740400003)(70206006)(2906002)(356005)(316002)(81166007)(41300700001)(5660300002)(40460700003)(8936002)(8676002)(44832011)(36756003)(6666004)(82310400005)(110136005)(86362001)(40480700001)(478600001)(26005)(1076003)(2616005)(36860700001)(336012)(47076005)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 21:26:20.5453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df72699f-d1cf-4234-092a-08db45d3b68e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9013
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

