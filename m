Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11924ECB9C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349875AbiC3SSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349829AbiC3SSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:18:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD5F2018A;
        Wed, 30 Mar 2022 11:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxXkC4kjw0lLUqHoJHRLT3ulv/WeAZoKimJhPTcmMaU=;
 b=C57pLAQsPigqoR3YrVUZSjC3lQ2nNNhByz7f+6Gt9Xv/ttAjDLzsMMo6vUx28Lga051cLXV0m5RXK2PmL9XU0FUgvD/EEEngDE/pG5wFbKPusggxmiopX5oNiBZJkon28aHz2sXoS2EK3xYx6q6b5dF2mdu5Eqs3KFxh+765SIU=
Received: from DM3PR12CA0094.namprd12.prod.outlook.com (2603:10b6:0:55::14) by
 DM6PR02MB5339.namprd02.prod.outlook.com (2603:10b6:5:51::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.22; Wed, 30 Mar 2022 18:16:41 +0000
Received: from DM3NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::b4) by DM3PR12CA0094.outlook.office365.com
 (2603:10b6:0:55::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT049.mail.protection.outlook.com (10.13.5.68) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:41 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id EB18E3F03B;
        Wed, 30 Mar 2022 18:16:40 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjNtiwn/VTVCSJN27k90QULY02xcXJr6PK0VB1sFiUIkFWFCJTeTguDw7mUjHqvto+IFTEjOoa//AiGg4m7EWixmpyXd0dTCX3nvQ6uLWSQHoFxZTU2wLD9vxFwhO7lzBnizETOVI8Xkxzw/SEcjg88ZpKk1Y6zzTSX+tZwG8Rj6UTD15qaQ7Kv4Z/UrJtoc1UQ/Z9aYjGp8KER7DBWgJDkne57bR2250ibcdK79x4d07mSO08MuyezcvXV/8UJcS9y00BrFl1QvpyvYGruOU40fZ5yannM8ztrYhRB4X2MBdDFzBeblLhxI1+cuO3Qmz0ax9mtlof1s0H8j/+x7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxXkC4kjw0lLUqHoJHRLT3ulv/WeAZoKimJhPTcmMaU=;
 b=N2/4a0/0ooZUIdlERPMqzRJSo3xwQQwhaJKoHnb0KNwipkemFKZgONqtgGhi7XqXeVtPGsbXTmtsQ3WmyTegvW/9pcj7R3GGRDj3m9gyE7+3FOBMiskgG2yFDJKfxHnaSVvFM04idlObjOHKdAPjUUsIjBpaS9ri4ykilr+glKhow1NjvPo/LyMBZsLY/lUD3vcwMx8iCi3kQRn++R8oHmCVnnpW+Nqt0jgsfbE/W08sduXeUenUHuMSlhJnjsvAUdA6bIGxP/DJU+cvm3R707ee2u0XhkhXONVMZTzmn/BKsGnYFrA66x6dzyI7aPG1sToivz9eWKcCF5BI2H4yow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN8PR15CA0052.namprd15.prod.outlook.com (2603:10b6:408:80::29)
 by DM6PR02MB6395.namprd02.prod.outlook.com (2603:10b6:5:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 18:16:39 +0000
Received: from BN1NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::18) by BN8PR15CA0052.outlook.office365.com
 (2603:10b6:408:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT003.mail.protection.outlook.com (10.13.2.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:16:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:16:22 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:16:22 -0700
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
        id 1nZcrm-000CCQ-BY; Wed, 30 Mar 2022 11:16:22 -0700
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
Subject: [PATCH v2 14/19] vhost-vdpa: introduce uAPI to set group ASID
Date:   Wed, 30 Mar 2022 23:33:54 +0530
Message-ID: <20220330180436.24644-15-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 8168ee60-2600-4614-6ed5-08da12797098
X-MS-TrafficTypeDiagnostic: DM6PR02MB6395:EE_|DM3NAM02FT049:EE_|DM6PR02MB5339:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB53391FA0EECED147FBB7E99BB11F9@DM6PR02MB5339.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: SwPQuvXORl0jYuzuxeF4swueniFiKM1sHdLH2boMy98X+FTKaai6F5LYhzLQALBcbz1EATrtrz0OfyZDK2Xq+YNn1Y0eozVQYF61f6r1zj3jkI3lm4XZpOTwGaiX9n1urjrl2BrpzjsgJa9waGjwg/mvtzGgrs6nsuuaS3G/Ic+nr0PL2D3ywQQkE5eW9PDbvsBQOy/UsPX3G1IOqMTy3qK8H3ohpSMl5WYTuNlPdyRyknSuLsMfeIKjihEg4qL6iafHh0RceE/nKt4m3DDOjxKipFClOmI7foxpF3P2oSqNiDliNI/gNAgzMZOiz7WJKjkWvdVQOl06WRGkyT9hKgC1fuQWoD43ubehN+B/9u3WsWl1eYuNROgUM8wGRXMqSPlf7Gi5pA9aX6t5BORjnsuJG0YXBGowTPCQxELTUhF6tuebpjYy7tWrXRGbJ1+b+HfRh8LESEgF2BZyQKeDpkAjD+DIp/XznW99MGqpZRsZ7Eq+n4Cxt75h2JG6BgLzIGIZZBgtgBtbI2IYuK9zFRebz/pVq3hLQa4L8kDzxQXoEsk2bVPP/SbKRmGD+9Ps/e2Q9iNJ0+/A/Kx2Pq8nQHaKt+njXzbbOkHix8VIYxZ/zzCWf0klKzn3tvWtUxT9NokGPkI8Lrq1hY+yxm2ZMhuC/JNbvTaqcbEX0rGM5Q7Rd5iZKHRsFxRcfRzxx34jXdkGjrL2aaPK7nBcDJo/wQ==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(8936002)(36756003)(7636003)(26005)(36860700001)(356005)(9786002)(1076003)(5660300002)(186003)(44832011)(2616005)(47076005)(7416002)(426003)(2906002)(70586007)(4326008)(110136005)(6666004)(8676002)(508600001)(70206006)(7696005)(82310400004)(54906003)(316002)(83380400001)(40460700003)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6395
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT049.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 75007473-c973-4a45-5541-08da12796f0a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpJD2OrJEgpPReIPhLJkVLhFl9qGxcKqzCgJi6S36UIbfm9Bl0njxaVLKONcAoVhi6jdFvtWO5Qj/Cnq0wyeEpez/7GvyAFARU7qtYlRLNH2Qmam7E4jLZZcpL6RA5q6dbiK+kY6b99Jc7f7BzpprHwsTDqGdl+a5IxHSnmhANsUifMvrigmcV1Ay5gCX1al12QIIVAm1WdRdPdRjG2de25Yx/BwMji1Gdc+NOivR3piHRqd/u5o9oDUGB0RunOfGGDiFxo2Ws7uKg3V/Ulv8JKv446Peze5HiKHH41nFNLHucEY2ca0iQpSy7OZc514ANUjqR6+ILSctE3OJMb+cXkDTvWbEnKCRBYhYkIYMzPQED70FCVxS0PxuWzWcIRDbbk7lHUkvR+Q7zogw+I6ADUzngsE2fPPWILop2pUYbgOXz2OTimkozLOr7tZaYBi/EvsQM1ThBe/EcSCX0n0S8XvoDZv5pF9CaqiTW62fKqn68ue2u1YYkLNJ4eqwMWJ0zGlJotzm9CUkfUbme/AGY7HfCTX0COfIV/Zmoo5SdgbbyBpoCwUvbF7e42hYBfak/RzI/6Th6gZ512FCVOyktfBWiBR1Obh3ExQWgNQ5G6JuxORq8LPcXKcd6rPBxHOjI65GuT1Dzb53Inr6SZA5aPNtT4n4pQ+588aP/5hEslQJrznXrh9t9YZmBiqUVNLTD3xwm9H9TywmbtmW7yJIHcMamON7cvK7b0RzIyqOhP36tsRGrsD3z0EpUCndlbL
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(81166007)(82310400004)(9786002)(1076003)(4326008)(44832011)(6666004)(47076005)(36860700001)(110136005)(26005)(8936002)(2906002)(36756003)(7696005)(186003)(8676002)(83380400001)(426003)(2616005)(5660300002)(7416002)(336012)(508600001)(54906003)(70206006)(316002)(40460700003)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:16:41.4477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8168ee60-2600-4614-6ed5-08da12797098
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT049.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5339
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for associating ASID to a specific virtqueue
group. This patch adds a uAPI to support setting them from userspace.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index aa5cacdc5263..6c7ee0f18892 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -473,6 +473,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		else if (copy_to_user(argp, &s, sizeof(s)))
 			return -EFAULT;
 		return 0;
+	case VHOST_VDPA_SET_GROUP_ASID:
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		if (s.num >= vdpa->nas)
+			return -EINVAL;
+		if (!ops->set_group_asid)
+			return -EOPNOTSUPP;
+		return ops->set_group_asid(vdpa, idx, s.num);
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 668914c87f74..cab645d4a645 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -164,4 +164,11 @@
  */
 #define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x7B,	\
 					      struct vhost_vring_state)
+/* Set the ASID for a virtqueue group. The group index is stored in
+ * the index field of vhost_vring_state, the ASID associated with this
+ * group is stored at num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
+					     struct vhost_vring_state)
+
 #endif
-- 
2.30.1

