Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23E94C37C5
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbiBXV3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiBXV3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:29:00 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CA9190B43;
        Thu, 24 Feb 2022 13:28:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCb5rJthZbIAxErIeI2ptOYuEyRGbBi9iaOQqbO58Fvp5OPqu/WSV4kJU+IdVaHdPfERpreBAHpjCe2AHutmfJp7nVJw6d0581nkbcVA3hhWlkOsLwqa6u2QAtMjwGu+73zzX+0sb16d8V6U1YZ9Lh9ixW3lHSH5/on/HezVrAm5hQjQEurOQeD8rg6Q/WpJollS+S4Rr1qDxkqCPpyVE5pWAAwO1mjgw9CK/6f6fTBotEgDKbSYIgKrIoHALBc/+JrCNrSj18KPD/U8KLH36VuyfiC8uIXcKFmABMMlVmgCPuTYhlKJxfzmpwJrpTqgX+w4L1lGQpM1OIF8xNGzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dggSplGGDZO0vUuyz9yCOEXlnVMwK3uzZ3/hX6LuJoE=;
 b=H2tLPoU5dqlJisc+VwAfzj+kU315LssLq+bZoHHpK+WO+Yj3jFc38bZC/Ho4ZWlVxS2VwTFfdSMaHKdJBY0PxiuG4q9c10q4y5osm02GgbMwvTCc7U8TXDsfUnONvuxVSBQ3QsTSNpKzs1O25Nx5GSl3FJSUG75GMNYy8tQDRg4B+RFrldnJhGvvIukjVQjeYXWClHGETD0o1zcFYeMnHO1M3XMfejaF1LkE/3Jvrz73dWbl4vAXtDeE4AbD8hBf5EbHIqxL2xJ12VkECpSJT6z2b32hdSJYOmSZp0Fon/M45HlhGcLgbuZ4Uo7kQYPK8gdYXB8mAu/YVPy+fI251A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dggSplGGDZO0vUuyz9yCOEXlnVMwK3uzZ3/hX6LuJoE=;
 b=ICWuiIWwIUOyvw4iWsP57aoIpTqcO8Kj0TgqS7SIT02BVYYmvxpsaGvL+kdayA1AFWOGamn54H9/fLxmKzRNh9He+gtogJiq2uR0BUqTDrXUAhI5KRPw8qD5IOWopq8N95zl94bFBXdiBd3V+2sY8aMMmK0OyHi9RMd6d+wpom8=
Received: from DS7PR06CA0054.namprd06.prod.outlook.com (2603:10b6:8:54::34) by
 BL0PR02MB4276.namprd02.prod.outlook.com (2603:10b6:208:46::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 21:28:28 +0000
Received: from DM3NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::15) by DS7PR06CA0054.outlook.office365.com
 (2603:10b6:8:54::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 21:28:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT031.mail.protection.outlook.com (10.13.4.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:28:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:28:27 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:28:27 -0800
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
        id 1nNLf0-00095B-JZ; Thu, 24 Feb 2022 13:28:27 -0800
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
Subject: [RFC PATCH v2 16/19] vdpa_sim: advertise VIRTIO_NET_F_MTU
Date:   Fri, 25 Feb 2022 02:52:56 +0530
Message-ID: <20220224212314.1326-17-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e09f82f1-321c-4f0c-c699-08d9f7dc98d4
X-MS-TrafficTypeDiagnostic: BL0PR02MB4276:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB427662F596D72854210532A0B13D9@BL0PR02MB4276.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+xajR0OTZvyW9qDp3UNIawqoV9HE2fFCg3wvpn5EnsNBs1GFqWKaY3+cuXUATku4DP0Rbm8XT5JN1+GuD6Zd1Z4+tXXCx8P33PVKTC5woLKDgxIPJogDg6b8soNxXo1FPWcnZb56bhxC+KtlpUFIlCal3xrF/I2NsPDU9/F+fpckW98U9O876IKWB6h9+yfS9IeqE0FaunDpSAwZzGlpaD8w83Jjhzvh3MjtMK4VOQH2eUX5XSm0LlpzCm8hBm2CY08eQaueH7m2Vv8Rds7MoxvbML40rM+mGejWhjEcENKrald2lDTlCdtoG5lUzL26Iv1tQE12v7PV0KzDr+valelZUiSB7t+BMVEORR/VjxcUgamJabPsbHsPZd1TN/SpjfJpuSqGoarnC3e03pFkgmlKNxuHNCD9p6HLCmjCm7DM4EIWqqlA26aCFWs0NgozBaNOhitaxBmupOtCGU6I2ifOvvNJxOo1vibd5h46bLLnjwXmJC5M9yWMJtl7RicvjCbewvYDmHhJreT0ylfpLD0M4IQbl3uKKEoO9/rCBkPncMykb/KNGupYr1XI9d4JlBj4LsGvr4DAorsnzchbqXUGjY0s044+TMoe4sdfa2lfCS7k43BqpTDbCTFDQR/ycWTPm0IBghIOpKqdOKf8fs2qv9L3qLVz22m1awKmfkMpTdZXv5lvDcAPSBQ2aTvkAXtWu4L7NgKvBf6HReVKA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(8936002)(7416002)(316002)(4744005)(9786002)(70586007)(2906002)(70206006)(54906003)(8676002)(508600001)(26005)(5660300002)(83380400001)(82310400004)(6666004)(7696005)(36756003)(2616005)(1076003)(7636003)(336012)(186003)(426003)(44832011)(4326008)(356005)(109986005)(36860700001)(47076005)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:28:27.7489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e09f82f1-321c-4f0c-c699-08d9f7dc98d4
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4276
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've already reported maximum mtu via config space, so let's
advertise the feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index d5324f6fd8c7..ff22cc56f40b 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -26,7 +26,8 @@
 #define DRV_LICENSE  "GPL v2"
 
 #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
-				 (1ULL << VIRTIO_NET_F_MAC))
+				 (1ULL << VIRTIO_NET_F_MAC) | \
+				 (1ULL << VIRTIO_NET_F_MTU));
 
 #define VDPASIM_NET_VQ_NUM	2
 
-- 
2.25.0

