Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE334ECB85
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349811AbiC3SPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348842AbiC3SPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:15:47 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA57DE8;
        Wed, 30 Mar 2022 11:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aU/tfL5148tmYWuSmlvrXot1O/2T9HMpWMFEV8qP2Y=;
 b=myjk+XTlBp+dO0o5uRnX+BnKjO+IYi1Ayu1vGvNRoHs+l1Y2KNLEd4OIlcPiSm9LtQznsawadHMqEBuPjrSMo9sLT4cd0o67cAfjm8cZldVrRF+Qe1trpk/DozXYwODVPnsbljRBGydcii1MPKUdAyqSWiYc7vlpVm0ySZQZrqc=
Received: from BN9PR03CA0062.namprd03.prod.outlook.com (2603:10b6:408:fc::7)
 by SJ0PR02MB8371.namprd02.prod.outlook.com (2603:10b6:a03:3e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 18:13:59 +0000
Received: from BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::b0) by BN9PR03CA0062.outlook.office365.com
 (2603:10b6:408:fc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:13:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by BN1NAM02FT031.mail.protection.outlook.com (10.13.2.145)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:13:59 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 669DC41D82;
        Wed, 30 Mar 2022 18:13:58 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOS/gehIuwoEJk1PaSLGpyDi1Tfjs6FZNpWTGZesujA4RJpxTkIDFdpNVXXs7f0/uaAHdEi/bmAnXk5eGExJzXyACw7rt5lLl1q9e5iEqQS+Ou/wdh7PxA9344wzw49ZWPosdjpA9hGnC4RQ+ghUBzACVfkOZzjX2hpuTpYjXcO/O1iLj1Apy/5Zi65zfS5qzGqVpWmu7wv5W/BlrrE6oGU2Jq2xEZcghNNx1lR5ZXeXD68nd24Nz34cBz9uxrAnxEMymIDVvS5/T1CqhHE6SKSrT2Dfe1/uqM3ll0bkfioPmjXPJE1+M8Ze7RgzU0ZliZ8r8cVIlIX5o65kHBZFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aU/tfL5148tmYWuSmlvrXot1O/2T9HMpWMFEV8qP2Y=;
 b=MigfNuf7ixYnNsgXXZXwVOWVQkBqgT65cj0YOcorq7XPR7LSMqOG7f6h+AT46OZSZjHU8KpLTM16VYuAE2K8Cfnu0rxXlH/DsTzDU4hzFA63NvY6QqiExdHALY10Ew63hN+zV3AobZmXrjZdmnVRuq1B2YcdBfRM8zOHnocJG+Wlz/jzu21qB0bp4Y4UPhsVS4KBtkp1KpeQjp8hZlcfw2tMj3eVy0gjf+2C/gSsDMFcrz/ETxXvok19XqOZQNUw9d5rJnMnIKS5nWRa8JR84nAWb8afITDypwbDGnQ3DKasMRH7tLTEt8d5KW6btPl9C7TihfgsScDgOFzDXVEF1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN9PR03CA0989.namprd03.prod.outlook.com (2603:10b6:408:109::34)
 by SA0PR02MB7371.namprd02.prod.outlook.com (2603:10b6:806:e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.20; Wed, 30 Mar
 2022 18:13:56 +0000
Received: from BN1NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::94) by BN9PR03CA0989.outlook.office365.com
 (2603:10b6:408:109::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:13:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT063.mail.protection.outlook.com (10.13.2.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:13:55 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:13:30 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:13:30 -0700
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
        id 1nZcp0-000CCQ-45; Wed, 30 Mar 2022 11:13:30 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
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
Subject: [PATCH v2 10/19] vhost-vdpa: introduce asid based IOTLB
Date:   Wed, 30 Mar 2022 23:33:50 +0530
Message-ID: <20220330180436.24644-11-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 7e80a667-bf71-4624-7b4c-08da12790fe0
X-MS-TrafficTypeDiagnostic: SA0PR02MB7371:EE_|BN1NAM02FT031:EE_|SJ0PR02MB8371:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB837141194853C5F154B05AA9B11F9@SJ0PR02MB8371.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: f1AFvSFzoeTxdyiXkjN9GINsAwsqR9EmvDfQJfB0L9vWdURrQnnkN0KbCFNb7/gNSZk+mZ+9o/99HIqlzIPOLhJa9tI4VmHQyn02x988+Z49sLjDTFLIsxY89dNCV1l4MrYGOpJQ964SAzTynIjMUi+/+Bo9TLsrGUb43O/uV9mUohZnmJYcOVa4AJI85wym99kjQWnnQiJp6ioTUU59YuwFNsvef6otoSWtHrTuaQjV2VHZHYpolorohOv3JbIPBhDklx7tNdLYNrb5aJeNpHDNCPt6YURpc4ehA/a2UtoskLgwyWEXw81yJXSdmo52E1ZNteTreX51IokewmaKpkkvEHhU5flHdkrGoOq62Pmk0K57x816fcA9V0eTGk0tv4cjTXLVcLvcnRW0ShWKx9J99kDLUkeMK+In1Nq4+/T7c+LHbXM81atYW4bHHHJF8ruoGkJClSXtT1gRyJkbofGOWrtKMZ1TCf4rzKyapYXJ1jIv/uy4TlXnlrdbz1YuFsgsuIRoPlw6pv58jSE65b2G9heEbt/lJ5SskWyRaS347d/SY6YfjUnd+o70gpGhh1uPMt3jrqPD9T9Opcbb1XPXpbqJ4gZ/JAmNUczU+hQpzYczB5MNXDr8fiFT0/tDFHqiO7RavODIcgeS6XyU1/zL+wDwsIyv7bmSZmBG4f0zx04B/arwZ43/M2t1VspHoEwy+lLuACEgFfaE+EcuYg==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(70586007)(2906002)(47076005)(186003)(426003)(26005)(336012)(1076003)(2616005)(356005)(70206006)(54906003)(36756003)(7636003)(110136005)(316002)(82310400004)(5660300002)(36860700001)(40460700003)(8676002)(4326008)(508600001)(9786002)(7696005)(7416002)(44832011)(6666004)(8936002)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7371
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: a72fa3e3-44f3-42fe-b559-08da12790de0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l1rAP+i6XsJTaMGWe61h0/O5w+l8Mcl539NNxO15NZnGXPpMikrytqFeQkIfCnYim1lsxm4lwvhqik+6p5GVSz9JlMbCHF/jDoRocH9zvNSqhXDvxdlD5Js+owD4VDBuOP2zw624DRDgczNfD8nrBWQmjTGhCeumurbmqhgqxJV7W38rU1MsJnPGQiqhyTVCVkeTZ2H+7rbcscm111qDQQkNAMZJ886C3RpmCdrDl+1YeCmNrVH48Pf1QoKfaZfQjnFYeCpqZXeAEIyEEdGpf0ESXE1gREYRhHP9D8uHvd08xc355nfRe+yJbUgmm425FGaefbpeXCU7gkuR/+C5MpXCiqf7xlV3okNAUfQT10DZ4JCHwHjnseTUe365HeiFI5ZwmAPP3bEzn/OdzAhH7ysqIucYz7fh+GShMTXoS3f5/1tebwV+M3oB56X1U5W4+jojbWY0O2qy+44XGb7/wyHm7eRXzWZvUPBxHPYOIS8MdGVkm5NuN5mwP8tSsYqm4VY0KC13UK/n/xX8pCtWpC1yQZagF0jWNvQWUJTMY3ddVjVza8XijhjYrnnDY1eHbaJrdGArRi5PdTQ4A0iDj9nW/O8rabNDbRI6J3eI7Cx1cHpwWJuA8EOxLp8Mp6lfDSSpIy14StClKnvPzGpiyRo+A8FqM+MUr3LHmWdIqpiM1/yLWx3/oB9fghIJag75p20waOVpoKOD/+FwAgff+hLxFwUh/q9wHhbi+d0kvjsC94l7AmXnn9FUA7TUgbhK
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(1076003)(26005)(186003)(336012)(426003)(81166007)(44832011)(83380400001)(2616005)(4326008)(7416002)(9786002)(2906002)(5660300002)(36756003)(8936002)(47076005)(316002)(82310400004)(54906003)(70206006)(36860700001)(8676002)(7696005)(6666004)(40460700003)(110136005)(508600001)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:13:59.1340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e80a667-bf71-4624-7b4c-08da12790fe0
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8371
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the vhost-vDPA device to support multiple IOTLBs
tagged via ASID via hlist. This will be used for supporting multiple
address spaces in the following patches.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 97 ++++++++++++++++++++++++++++++++------------
 1 file changed, 72 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 174c9e81df4e..cd1bee536c46 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -33,13 +33,21 @@ enum {
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
 
+#define VHOST_VDPA_IOTLB_BUCKETS 16
+
+struct vhost_vdpa_as {
+	struct hlist_node hash_link;
+	struct vhost_iotlb iotlb;
+	u32 id;
+};
+
 struct vhost_vdpa {
 	struct vhost_dev vdev;
 	struct iommu_domain *domain;
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
-	struct vhost_iotlb *iotlb;
+	struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -55,6 +63,51 @@ static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	hlist_for_each_entry(as, head, hash_link)
+		if (as->id == asid)
+			return as;
+
+	return NULL;
+}
+
+static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	if (asid_to_as(v, asid))
+		return NULL;
+
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
+	if (!as)
+		return NULL;
+
+	vhost_iotlb_init(&as->iotlb, 0, 0);
+	as->id = asid;
+	hlist_add_head(&as->hash_link, head);
+
+	return as;
+}
+
+static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	if (!as)
+		return -EINVAL;
+
+	hlist_del(&as->hash_link);
+	vhost_iotlb_reset(&as->iotlb);
+	kfree(as);
+
+	return 0;
+}
+
 static void handle_vq_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -588,15 +641,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
 }
 
-static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
-{
-	struct vhost_iotlb *iotlb = v->iotlb;
-
-	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(v->iotlb);
-	v->iotlb = NULL;
-}
-
 static int perm_to_iommu_flags(u32 perm)
 {
 	int flags = 0;
@@ -876,7 +920,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = v->iotlb;
+	struct vhost_vdpa_as *as = asid_to_as(v, 0);
+	struct vhost_iotlb *iotlb = &as->iotlb;
 	int r = 0;
 
 	if (asid != 0)
@@ -987,6 +1032,13 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
+{
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
+	vhost_vdpa_remove_as(v, 0);
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -1020,15 +1072,12 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	v->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!v->iotlb) {
-		r = -ENOMEM;
-		goto err_init_iotlb;
-	}
+	if (!vhost_vdpa_alloc_as(v, 0))
+		goto err_alloc_as;
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_domain;
+		goto err_alloc_as;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -1036,11 +1085,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_domain:
-	vhost_vdpa_iotlb_free(v);
-err_init_iotlb:
-	vhost_dev_cleanup(&v->vdev);
-	kfree(vqs);
+err_alloc_as:
+	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
 	return r;
@@ -1064,11 +1110,9 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
 
 	atomic_dec(&v->opened);
@@ -1164,7 +1208,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa *v;
 	int minor;
-	int r;
+	int i, r;
 
 	/* Only support 1 address space and 1 groups */
 	if (vdpa->ngroups != 1 || vdpa->nas != 1)
@@ -1212,6 +1256,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
+
 	return 0;
 
 err:
-- 
2.30.1

