Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141E84ECB82
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349813AbiC3SOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349844AbiC3SOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:14:44 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E013EF19;
        Wed, 30 Mar 2022 11:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PF5b2AqIQnrYVIjekGVkPHjmQSR1sDeaupLb000SYc=;
 b=NokGaa4u3sP5zApwGVv+8AnstcYSRUK++Px71TlWL0M3s0cRJgIwfgbj2NkCGIZQI4ydGCW+mWd5p3LLessXf8tiqNueXXRgXwWdS/SFWW/CUWzexEUBomaROFHr0lcC5zGxvwNY8BQ0wQYDhV3ELgdB3+nxLmc0465q9/xktMA=
Received: from DM6PR06CA0078.namprd06.prod.outlook.com (2603:10b6:5:336::11)
 by BYAPR02MB5448.namprd02.prod.outlook.com (2603:10b6:a03:9b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.17; Wed, 30 Mar
 2022 18:12:50 +0000
Received: from DM3NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::f9) by DM6PR06CA0078.outlook.office365.com
 (2603:10b6:5:336::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT036.mail.protection.outlook.com (10.13.5.20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:50 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 08C0C41CDE;
        Wed, 30 Mar 2022 18:12:50 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flGkCyV9EthBaJNKKjl54L66IrTNnHeR44m1T+hBb84dgJaagmoCobyCCH0VWSzqKWxKy+RJDdoifNe9fh8gGrhztNIQ/q1U/xW/kyEKbFOlMNEpEJX0+jvEgkEe82mcrWKrqOLo4pLZmDpR3c2a/PgiiVg6hip9/zfVnh7TTH4IutWkR+rOgjLEqHHVhfKMKoN3FF6GGa+P5DnVFjkLbzzdr3x/m5/On9eMVQzy6qovgb+4hmU9lY3W4r8wg2uuUwqDuUYSFLno5rQkPqAZ7P/c8n/gspksalQQab1JB+6q1ioqIlKNoveJk8E2rC63/1dV3Kqc4bhJ+Gt9sGkntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PF5b2AqIQnrYVIjekGVkPHjmQSR1sDeaupLb000SYc=;
 b=FWEqiT8CcF+pxW02hkKsAbEtLqq33ZPFxEc4aM2JA5ln9Kcyirk/AFRyzu6J2YcMowRfzipUTEPyaQiqEh28jQOJ44UvFk5VSWhzXctVP3z8Vwcxk7CmPIp1sVTrfmZw+6Y5LIfhEC9VorzfZugLH1t6QZNhN8gXZT7lH+CGsnKDLc6oq/l9ZeDBx9W84ulqLNhw9fCt9LRYZMDFRHYXr0d9av0hAxvEyLIKUkCSy1s8Z7rrUUp6HbGa5fZy7QBf8ES4ejwgaLvPxwzSLJ9BEMkLVQ0pX7DmeN2j9cjgpSlCSuwd7xvwr8fEVkJBfBky/F6q85riaPmUG+C23qzUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from DM6PR14CA0045.namprd14.prod.outlook.com (2603:10b6:5:18f::22)
 by MN2PR02MB6941.namprd02.prod.outlook.com (2603:10b6:208:20a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 18:12:48 +0000
Received: from DM3NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::ac) by DM6PR14CA0045.outlook.office365.com
 (2603:10b6:5:18f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT017.mail.protection.outlook.com (10.13.5.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:12:48 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:12:46 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:12:46 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 elic@nvidia.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcoG-000CCQ-3L; Wed, 30 Mar 2022 11:12:46 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 09/19] vhost: support ASID in IOTLB API
Date:   Wed, 30 Mar 2022 23:33:49 +0530
Message-ID: <20220330180436.24644-10-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: b00e87d0-6966-4e5f-5dca-08da1278e6f6
X-MS-TrafficTypeDiagnostic: MN2PR02MB6941:EE_|DM3NAM02FT036:EE_|BYAPR02MB5448:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB5448855A0BE55FD86F285EDAB11F9@BYAPR02MB5448.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: sDgSOgCfnA7H98YV9GI6Tr7KPI25ciwb4zDT7/snQdtd/67b9s9CSN72vT//1yfHaVM6OXfdIxOw2TqFYBGgr53Lxzyxnfw9ld4gq/5d0zrdY9BmzrN89HEFW2z6HHWUFFt46TI+m3KY7pE6Xf9ii3RViBltxsPeeFsBJs2zonwSZ7RYv4oq/ZymsAvetZ1E1LPeJZ0GBGbdvMPbCT/Wj0F0zZgEqnYN15a3qA8iH0YaVXeEsF1CEeLzr7Gzm34HIWmVMaEyUQyNchmiGSfoGBE1Ujq1haWIvaLnAw4oh+sy0EWCt94Gw93wc+7Vg1bdgcKSl6DozmY2Oz0yLg4hiCSxsh8tJFte4T49Klf2BSVbC2o0J7g4hYapiRDmvqTmOLbVo2aAJ8XY+aA2wwHfrDUNvf+wVXj2+mvKu7JxHgi4M5+XNLwUVFZqZZf1Jv4W79E1G4aaAu7vSK3Df1a1tIzjVFxup9lqlBEhNxJmIkqU2zMFCKqM7yObyrY54xFJIw1Inr/lgvjxTREPn/KfvppZJSojtpIkql2gCGiArGk/U1LbPFPO7o5w4NBKu7PJpEUhAsn4ahKbf4MxtgDUGBgogC1euUgK/lxgMje22lbs26+rwc0qAflg4SrofDFt4cqP2jH2wimWUtrU5KaQ/15ymlH8b/B6+A86eeYt0DC1R9tKynizTcitoH2mrEfFAv5vlhsRsvO6ovUWfEOg1w==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(70586007)(2906002)(47076005)(426003)(26005)(186003)(336012)(1076003)(2616005)(356005)(36756003)(70206006)(54906003)(7636003)(110136005)(316002)(82310400004)(8936002)(5660300002)(36860700001)(8676002)(40460700003)(508600001)(4326008)(9786002)(7696005)(7416002)(44832011)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6941
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT036.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 19ec9c5a-77db-44ce-6b5c-08da1278e579
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dxj9I0evKPETooi1U2EcNRl7mQky934xq1UjIWDCuDo9dR4Pt/CZSj2EJ4buJm/gJcFErLsKDt12ClqmTDF/HoH4SOdbTzbCgBw/tA3JzLpkz7QlXXiflchymrkDpf77iYMAzWwLu6dodp5oPKYmDR1ehQUS9SUApiYtCO17A6WDD7jf66cjjnf1vtwRG9tPy/julDgTyG38+Wriz1GSHfuS6x8LAMSqFJEUntGNL/Bz8B0pzB+Rf2ohnlorXYDhRjotcVMPOf2hNVzg9ABhyMzxEFfuxnzGGSc1rS6xNuqkvjnhiblf2y/ZhdrqFMvxzmXys+7etyciHeTPzyVEjRUtfcW/7ab43+5VGxD9IfmyS2OH3KIlC1phRuefor8gdhQddeYzdBJNjqqevEyT59LDVE1KCYbbDwVZiKVTYRfsmtRFxYganUwRokZd3rED9Rob9q0KJqunbOsfpBdne81LHlNdX/OZxx/K0LLIBx+aUXOApRU6qaHgRgC31VUMx3CRvoNIoPoSjZ/JKcB9afdOWh2SFR7l54z/zlHBYD9tv2iX+9S1/VQq0H3qHqFgUkmd6cJGD0ylhLI/tLcSyDG9PauISEoypXuxUOnVlxEXW8vMacOrZGAF7BgSkRu+15ChU872AVHGPJewt9jk0jN9F/6IB7Zoo1YYNYxtsfILhdvJTrngb0no2DOBaCHiS62NupnguLgEZY8VMQ0ndqhKC2hbwzZHGx11YOfHYtuP5fne2WQMrb0B4RhI5plx
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(316002)(1076003)(8676002)(83380400001)(4326008)(82310400004)(110136005)(2906002)(54906003)(47076005)(70206006)(2616005)(26005)(7416002)(36860700001)(9786002)(8936002)(336012)(81166007)(44832011)(40460700003)(5660300002)(508600001)(36756003)(426003)(7696005)(186003)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:12:50.5377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b00e87d0-6966-4e5f-5dca-08da1278e6f6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT036.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches allows userspace to send ASID based IOTLB message to
vhost. This idea is to use the reserved u32 field in the existing V2
IOTLB message. Vhost device should advertise this capability via
VHOST_BACKEND_F_IOTLB_ASID backend feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c             |  5 ++++-
 drivers/vhost/vhost.c            | 23 ++++++++++++++++++-----
 drivers/vhost/vhost.h            |  4 ++--
 include/uapi/linux/vhost_types.h |  6 +++++-
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 9202ff97ddb5..174c9e81df4e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -870,7 +870,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				 msg->perm);
 }
 
-static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 					struct vhost_iotlb_msg *msg)
 {
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
@@ -879,6 +879,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_iotlb *iotlb = v->iotlb;
 	int r = 0;
 
+	if (asid != 0)
+		return -EINVAL;
+
 	mutex_lock(&dev->mutex);
 
 	r = vhost_dev_check_owner(dev);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d02173fb290c..d1e58f976f6e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -468,7 +468,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
 		    int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
@@ -1090,11 +1090,14 @@ static bool umem_access_ok(u64 uaddr, u64 size, int access)
 	return true;
 }
 
-static int vhost_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 				   struct vhost_iotlb_msg *msg)
 {
 	int ret = 0;
 
+	if (asid != 0)
+		return -EINVAL;
+
 	mutex_lock(&dev->mutex);
 	vhost_dev_lock_vqs(dev);
 	switch (msg->type) {
@@ -1141,6 +1144,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	struct vhost_iotlb_msg msg;
 	size_t offset;
 	int type, ret;
+	u32 asid = 0;
 
 	ret = copy_from_iter(&type, sizeof(type), from);
 	if (ret != sizeof(type)) {
@@ -1156,7 +1160,16 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		offset = offsetof(struct vhost_msg, iotlb) - sizeof(int);
 		break;
 	case VHOST_IOTLB_MSG_V2:
-		offset = sizeof(__u32);
+		if (vhost_backend_has_feature(dev->vqs[0],
+					      VHOST_BACKEND_F_IOTLB_ASID)) {
+			ret = copy_from_iter(&asid, sizeof(asid), from);
+			if (ret != sizeof(asid)) {
+				ret = -EINVAL;
+				goto done;
+			}
+			offset = sizeof(__u16);
+		} else
+			offset = sizeof(__u32);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1178,9 +1191,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	}
 
 	if (dev->msg_handler)
-		ret = dev->msg_handler(dev, &msg);
+		ret = dev->msg_handler(dev, asid, &msg);
 	else
-		ret = vhost_process_iotlb_msg(dev, &msg);
+		ret = vhost_process_iotlb_msg(dev, asid, &msg);
 	if (ret) {
 		ret = -EFAULT;
 		goto done;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..9f238d6c7b58 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -161,7 +161,7 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
-	int (*msg_handler)(struct vhost_dev *dev,
+	int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 			   struct vhost_iotlb_msg *msg);
 };
 
@@ -169,7 +169,7 @@ bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 76ee7016c501..634cee485abb 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -87,7 +87,7 @@ struct vhost_msg {
 
 struct vhost_msg_v2 {
 	__u32 type;
-	__u32 reserved;
+	__u32 asid;
 	union {
 		struct vhost_iotlb_msg iotlb;
 		__u8 padding[64];
@@ -157,5 +157,9 @@ struct vhost_vdpa_iova_range {
 #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
 /* IOTLB can accept batching hints */
 #define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+/* IOTLB can accept address space identifier through V2 type of IOTLB
+ * message
+ */
+#define VHOST_BACKEND_F_IOTLB_ASID  0x3
 
 #endif
-- 
2.30.1

