Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E84C37CB
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiBXV1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiBXV1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:27:39 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C442D64BCD;
        Thu, 24 Feb 2022 13:26:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TacHgItltT5Y2Ds7EGKu7hDsnkugae5Bhifdp1tIvoa01hgxAOUoECrHskmkqfeHgRqWGHCBA1oJloL8f5UMjJCVHP8zE28HiUDdv56Llxkshxf/CXhcuERA5cE1JyAQ4uKwm0DfaWwC74Jk0v9woD0zHE4nn0kMrc9XHLos/AfLuI96vuI0QNiTQY0ptMpz4p5H0TB4ZLIsARGGoEMy7KBbCU1j+/FV2kv5JYDvCWCyxxwF2rxv5FVTaVM2Bdgt84MLxerZ99gZECsMaVqG6IUXirCVb0/zvDCjVZCzSh2mwXxbEt4/0g2Za30Jlh6NMFYWrAupk77u7hH7HKqF7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OzNqprShJ/sPFnbaEsuGL/x+Wq9ZcKHWv4EQt7MqXc=;
 b=EBd7nEwmdmQnwfC/tJHl2WAYB7zkvuZCntPGEw1b0tLGdEAJb+9iS/Cw8A0A1gzNLbz0yH1RB/1GHExsSyPRi/172ZO+UgMQyZjv1OoEjD8R/4FE6/gK5VQ+757AgRPDnh/WEq7yOb9c+60jlmaj18LQYyZI8O97/8CxB0Fr5sZvPUMdlzMExooSDXNrj4ZBj8+0/KxStMRsh/ZSDKZ7AoDRFfCfWjzh8ixw+UmD1uVvmjZq/CK9lZAiJwWYBCI/xCiYkrmRB3yYWwYYM4447KVAXYeRVa3rGiZOUpBRFQqMHZRMXN4qllw3c++IeyqTJudZyIHqYYTt+t7o0JUD/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OzNqprShJ/sPFnbaEsuGL/x+Wq9ZcKHWv4EQt7MqXc=;
 b=TgoRmiTsSRS2t6XBhMC1w0Edx8GKq2rgoPR9/qRCq4sp09pYN8OIPwVdpM1fHxVvCikFj4v1ywsFr9dJq+ps5OpO+BnA2pqbH0zqw7NDf3s536ikyaSxXZoDnbvjdpqSiUJ4FoOoD02gkKaPBcyiPutl/AvEiIsVzB8TyB3j2Pw=
Received: from DM6PR11CA0009.namprd11.prod.outlook.com (2603:10b6:5:190::22)
 by SN6PR02MB4605.namprd02.prod.outlook.com (2603:10b6:805:b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 21:26:50 +0000
Received: from DM3NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::a2) by DM6PR11CA0009.outlook.office365.com
 (2603:10b6:5:190::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 21:26:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT032.mail.protection.outlook.com (10.13.5.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:26:50 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:26:50 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:26:50 -0800
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
        id 1nNLdR-00095B-ME; Thu, 24 Feb 2022 13:26:50 -0800
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
Subject: [RFC PATCH v2 11/19] vhost-vdpa: introduce uAPI to get the number of virtqueue groups
Date:   Fri, 25 Feb 2022 02:52:51 +0530
Message-ID: <20220224212314.1326-12-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdacefd3-97ee-4d58-8900-08d9f7dc5eff
X-MS-TrafficTypeDiagnostic: SN6PR02MB4605:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB46057A262FCEBBD609CC6FCFB13D9@SN6PR02MB4605.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZLIZj2nWS5K028ciBOw+rbexv+/dCNsKTOz66pxADxkAOk5ygOBOCeLabGTAAd7qcf1T5Jt91yslukSScA1GqQK+NIJkfyIcfUauVxWbwKKlNGGqn2ymNEWhkI93p/xGQ0g9Ja3hWpzVnnBXATvPnwSk/LmC2s2TGSlpuDA6XOqMYfUFTS8YAqsPJve1cj/b1eeuCv5GnhKbv7Z7HpXk6BJem0kq/ngV4IaQ3VHdrTMMSB8addDolKlM22ljLyI0bMcen6eR2oumQWcvWBioEF8UQHTxqiWdcWFvft6ImbvWZUN+IlsuSCCySuXBGMN/BpxvxkCnCLu5+2XWUOFBliltA9wuf2JVPIeCmdqe0zg04JkukA+o3x56xU8YMiTTWlRvdOwg7hhFB8HQ+UJMbocGOUXgomOYZS4wq6frTGA8XJYkDsGsH0Fq+dDjIuAbc4cxGQsEREVz2UL3MBZ3MDHZBanPcYPaO2IcQj769HTL2o/NY4FJX+C/+86jrbQ7SfdCCyzUwHPNEutyAib0X9qAAAXlJhuwnFML8+CHRxz1UFhFbuGWCSybYlRT2h3U9BCqcclzpUPRxK8L+yZZtRuMQaV3/5ITaBjcyjtzVRsBnUcL3U4vt9t2KwqgCCmnRBC4m9Bk7YvNsMFJ30G4XRN2IidU/IAuTQHvGqDXHoP5mZScQNIhetpAxl5VdqCCZegNjhlqf5mjgD/f3Ltkzao2C+Y+LVZseHwMM4KS5Cr/konD4WYOFkGa+L3J0RC
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(4326008)(316002)(54906003)(508600001)(7636003)(356005)(36756003)(70586007)(70206006)(47076005)(8936002)(426003)(7696005)(336012)(5660300002)(9786002)(40460700003)(44832011)(7416002)(1076003)(186003)(2906002)(2616005)(109986005)(82310400004)(26005)(83380400001)(36860700001)(102446001)(266003)(15583001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:26:50.7525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdacefd3-97ee-4d58-8900-08d9f7dc5eff
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT032.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4605
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for multiple address spaces, this patch
introduce uAPI for the userspace to know the number of virtqueue
groups supported by the vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 4 ++++
 include/uapi/linux/vhost.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4e8b7c4809cd..7a8a99cef8a4 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -538,6 +538,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VRING_NUM:
 		r = vhost_vdpa_get_vring_num(v, argp);
 		break;
+	case VHOST_VDPA_GET_GROUP_NUM:
+		r = copy_to_user(argp, &v->vdpa->ngroups,
+				 sizeof(v->vdpa->ngroups));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 59c6c0fbaba1..8a4e6e426bbf 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -145,4 +145,7 @@
 /* Get the valid iova range */
 #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
 					     struct vhost_vdpa_iova_range)
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
+
 #endif
-- 
2.25.0

