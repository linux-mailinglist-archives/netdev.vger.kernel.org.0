Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5024C37AC
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiBXV0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiBXV0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:26:33 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26FE29DD06;
        Thu, 24 Feb 2022 13:26:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jozj4Vvpli5nWu1I7/vstWyge75psVZZvWmLflwXSBEKuoHhV6LpvOkZSk6AkxJ2IFtDpLRXI1QyFlrohtECf0BdfCjQbOSJJYN87lVEYZt7hVFNFPthmaPKMCS5iwXYmI8bn7ODCFtC38euUfxe5Yc+SGymkdug1POag4BjoQD/XXjIx/0ywcuVQuLgqJNUuCByBQtnm+vkozzbnZMMP265fxsg5ihvfh77jliu13PLJKkBZXVI+MUy0Tz9ALfHUmq1DodqVJ/QWzyZhWQZkR8SP8oDYiLZR5+MaGjVmGCUXxD1r+8QZjNvWi2LC78FUEcZR9Q75N3Jo1EbeXyVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i/LMAOsTt6791zzKm07df7sjVoBknaIcJCDvAx5Qxw=;
 b=P53LuGxMbjvMzlPCEOpuwVvaS9c0XpUTIYdK2I74/w/S4VyOb3ObW2j1e04adI2TWkx0cvVQFD+Ma/XwinzZMyrmoK0OE9nCkgXZYaTjaBuC+nM/3qmONNhr6fhCARmXbwIIvWSDtbAxS093IVVIMQW6okztjK1fn3rvsvMscFky6KUCT033qahOLsjdxexhu+AQvdciN5hWhSlw5U830WOlcXNOdd5BRU8zPiIo5bjO+GvdBe2JJZoq6JnTXcGRw+xM2DHekVFEtZHNOmH0pd6gsHNbmzHbibSykO8vGNG9o+lDKpRxv+tn3NLChtXUUTlgnQIcN6oxjeewhzhvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i/LMAOsTt6791zzKm07df7sjVoBknaIcJCDvAx5Qxw=;
 b=bSJTBceVOHxcOdCmMNpZ/vsM7KpYxyi5/o8+76f/mdB9VjqrnlRmvsW5jZgma1Bj0pz4G4xgYH74FlaG3FyYZC/zRdfJicIE29yVNsKoIJdPcPPf45abgLkwNixojS8wcW+T9xxf1Y2P6NoHmNadJik0Z3m4G7gZdARquDU2dT0=
Received: from DM5PR2001CA0023.namprd20.prod.outlook.com (2603:10b6:4:16::33)
 by DM8PR02MB8248.namprd02.prod.outlook.com (2603:10b6:8:6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 21:25:57 +0000
Received: from DM3NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::d1) by DM5PR2001CA0023.outlook.office365.com
 (2603:10b6:4:16::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25 via Frontend
 Transport; Thu, 24 Feb 2022 21:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT063.mail.protection.outlook.com (10.13.5.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:25:55 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:25:53 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:25:53 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 elic@nvidia.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.170.66.102] (port=59620 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLcX-00095B-CP; Thu, 24 Feb 2022 13:25:53 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH v2 08/19] vhost_iotlb: split out IOTLB initialization
Date:   Fri, 25 Feb 2022 02:52:48 +0530
Message-ID: <20220224212314.1326-9-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2b66660-5d5a-4649-f7c0-08d9f7dc3e31
X-MS-TrafficTypeDiagnostic: DM8PR02MB8248:EE_
X-Microsoft-Antispam-PRVS: <DM8PR02MB82480D864958A107CCD6D381B13D9@DM8PR02MB8248.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 37S2bZkcJavRObjS4C5JnKAVtReJqcjBW+CRh6oq+HFPKtHvwDBUbMJ6XUoquJ2mPHZbiciS4LJLT0PEia+PFZpz5O07vOYmZlDNIALLUNJU0uY4mX1MrIPdDZkADu3oJBym58wTEI1z8CR9TbDda4KYv5j3CPQ+JdLKog/mL4rJD8SovkW8AlT8hhT+TsGXQK4QlOsyZoz/+vuEKmNNE3cwv3TMRds1LOQRyVVo4kkVL1ZoLpvnZcSWCgFCMor1Yd5LRpunptmynqUNuMq9/d99PP4iYbw1I7dSsXQPPHQg/OikBVWGTXbxs5RNdsYQlW8aBWisG9bmStYmXDKaJ/c3CEH4W63dVQ7on3KKJ2YsPhg8ROdFOg/7cMUlzYfihmOgEq0Lk2Z0zaJVAJteN0o9ae/ZfQP96wWvNhz6cuMKRqbFyNccF8ScOpcnx0kyQrxC7T4X8nZkz5j/X96j08EZwtFePsoJCAZQEDs68HtyY/ZmmRCgcqj24FpJgVSgQspr7g/Md1beUr2bj8NbejV4f3XAC73zFybkZqG6FpnMwf9PgcvWUj633/2hReo5QTuf3P83PN1E5rENw4aritB6quOEdwBIE1RfYa+EUbX2Xv5ISDmTWFiCmByO2r/xBU59iFuoK4HODuU8jfvEW2uovotopSS+uSoEHAT3phJMXI2AKNmTz9hv4UNW/MRQZCSO7e6QODjpnS/1AezWKUl1s2G9Erdl/isQBmGKQ+xQZFQvwlhEDMPUhNdpu/mt
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(426003)(70206006)(336012)(54906003)(47076005)(70586007)(8676002)(186003)(6666004)(7696005)(82310400004)(316002)(36860700001)(4326008)(2906002)(508600001)(9786002)(5660300002)(36756003)(7416002)(83380400001)(8936002)(7636003)(44832011)(2616005)(1076003)(109986005)(40460700003)(356005)(102446001)(266003)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:25:55.7026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b66660-5d5a-4649-f7c0-08d9f7dc3e31
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT063.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8248
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch splits out IOTLB initialization to make sure it could be
reused by external modules.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/iotlb.c       | 23 ++++++++++++++++++-----
 include/linux/vhost_iotlb.h |  2 ++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..6239d0ad3853 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -110,6 +110,23 @@ void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last)
 }
 EXPORT_SYMBOL_GPL(vhost_iotlb_del_range);
 
+/**
+ * vhost_iotlb_init - initialize a vhost IOTLB
+ * @iotlb: the IOTLB that needs to be initialized
+ * @limit: maximum number of IOTLB entries
+ * @flags: VHOST_IOTLB_FLAG_XXX
+ */
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags)
+{
+	iotlb->root = RB_ROOT_CACHED;
+	iotlb->limit = limit;
+	iotlb->nmaps = 0;
+	iotlb->flags = flags;
+	INIT_LIST_HEAD(&iotlb->list);
+}
+EXPORT_SYMBOL_GPL(vhost_iotlb_init);
+
 /**
  * vhost_iotlb_alloc - add a new vhost IOTLB
  * @limit: maximum number of IOTLB entries
@@ -124,11 +141,7 @@ struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags)
 	if (!iotlb)
 		return NULL;
 
-	iotlb->root = RB_ROOT_CACHED;
-	iotlb->limit = limit;
-	iotlb->nmaps = 0;
-	iotlb->flags = flags;
-	INIT_LIST_HEAD(&iotlb->list);
+	vhost_iotlb_init(iotlb, limit, flags);
 
 	return iotlb;
 }
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 2d0e2f52f938..e79a40838998 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -36,6 +36,8 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
 
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags);
 struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags);
 void vhost_iotlb_free(struct vhost_iotlb *iotlb);
 void vhost_iotlb_reset(struct vhost_iotlb *iotlb);
-- 
2.25.0

