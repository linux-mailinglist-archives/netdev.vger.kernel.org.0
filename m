Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF54ECB4D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349658AbiC3SHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345055AbiC3SHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:07:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D6D3334F;
        Wed, 30 Mar 2022 11:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYYEZsMoX1IF0WdGyK05wlg2fCihGbgVkXhhOVHIci8=;
 b=HisHrKBY8x74ggf+BY+iM8WeyCDp/TXPExlWc5zmMW3u3hY1yywDDZ6n5LEWSYsvIQRKbZPR6tEwS+OMZDkEPn+wuNs82NA/qp4VzQ8z/hKWl9AD0akLPw2QzZQysnt08T7YBaYoE0CijSihLz4ikWTHVDAs2ftO+3GLFiTYNuQ=
Received: from DM5PR19CA0057.namprd19.prod.outlook.com (2603:10b6:3:116::19)
 by SN6PR02MB5344.namprd02.prod.outlook.com (2603:10b6:805:73::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.18; Wed, 30 Mar
 2022 18:05:56 +0000
Received: from DM3NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::37) by DM5PR19CA0057.outlook.office365.com
 (2603:10b6:3:116::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT051.mail.protection.outlook.com (10.13.4.91) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:55 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 4438C41CD7;
        Wed, 30 Mar 2022 18:05:55 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6NCzSwSMzo54w98+j6oesNe9zGy2NfpqJ1uj4OVOXcqJgXcwyJc4eV5b3l2wElYne/VOq+HvrSjgai1zs81HjpMI9AFvdJaNht179JS90XHsIVMRMR3r5SdQZB/+Q9DPvBC3OnzU6D8oNiLowUTiSF7CJSk827PGV2HNOyNva5lu2QxqSQ6/Y4griWK6+NAmVM24O6ZJRYQ7s8bO9q1f7JnYNNp7+wgTr4OzosHMX5E8juK6ZBq3IWDxagDHXDQ3oIbCs7289sVm603DKLEMnm2WF5Rem+BTFbjZDrktLKAPzeTKL7+0GUpmtYi2ktk1VgSTzkMUgWnXtdYjqdSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYYEZsMoX1IF0WdGyK05wlg2fCihGbgVkXhhOVHIci8=;
 b=cNLNn03+CREqX2jyHv5yVE84ae3e1r87ZyN/q7iXTMK2fdjxWO2vaszQqAY3hWvY4Co3LQfzaAONxrLlrN1EGxN6L7CT4b08beiPxm6q41hi76fVaAO4PE8cx4PDoc47/53gzvrwxcXv58mfrGfQ9k4TOWGtb7lf9duH8SFgFLzQJVNpCUl4Ov87evBgX5NohpKkvYmcbqTCRSAA9xg4eT0pNNpj/3rd+QTUxphvzGsh7hwNm+HG3FY1tH5lwtefMjNlUQHqj1JYdyzJRDU0J5f1xuGVb6DylChKbC5glcuLdHgU+C6LzMHQWseyvKdEmlcagpuOuAyiD0haQhbZ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN9P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::33)
 by MW4PR02MB7105.namprd02.prod.outlook.com (2603:10b6:303:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 18:05:52 +0000
Received: from BN1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::8a) by BN9P220CA0028.outlook.office365.com
 (2603:10b6:408:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT060.mail.protection.outlook.com (10.13.3.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:05:52 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:05:51 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:05:51 -0700
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
        id 1nZchb-000CCQ-3X; Wed, 30 Mar 2022 11:05:51 -0700
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
Subject: [PATCH v2 01/19] vhost: move the backend feature bits to vhost_types.h
Date:   Wed, 30 Mar 2022 23:33:41 +0530
Message-ID: <20220330180436.24644-2-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: a0f9c0ae-7ade-4a23-372c-08da1277efc4
X-MS-TrafficTypeDiagnostic: MW4PR02MB7105:EE_|DM3NAM02FT051:EE_|SN6PR02MB5344:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB534441B8E2650F473AF27B1CB11F9@SN6PR02MB5344.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rbGt3nHq13snBDeyPEx/blKIbUcvSoRLwf8GTsCHkaweos7WRJDPdNkArrrIQ/Fo/J00WxlS01rhPitO+oJG0sWJ0FSvAuOe0Wjz/WvtMX8HGCGWoQMWPeONX9XHJo+wI3dlBQngtrjUf6jr1viR72eDPjUe77HUR8Ty/1LuJfqwWXIbLpTn/BBEHA7q2wWgOO0ezKdJsRL6FcNXfTLZowEgsIJcTC1vkw8r3QCLDLXp3sM9eei0MNjFljfbnWviF907MW5raHGgGogJovZ6aCAiQVm1tHnikSl2NZwTBzIy7s9mgbKFaWeHIbOiA3HCXtMcIqJd5StfrP5RQ+hFIw/1bRSSyNLQW/gq9SfKv9i0KwjSQkkUdMt4XVQfiSzv2m6dQIeh1g3STBH45ozag4M7jNOlRD0UmTsPfL3G0oK8VXBqyY579svOLwfOLsRH7Gsy7Mon90EBlh/8Pei+Gs2oMV+KQ8x6zK9GS1E4kLaj8fIf6xlnUJu/zEPC1DpQQLXf7UQuPRr5NTulAcAiqlELFlUXUwqmsTrQuXzhHIpFZVyprMHUUENyVf2DiyP572VLUaxEu/nqiwZzETJrsNLo5eoa6p30yaDUlpoS2O+mCzLEyT28lz3l8pMFD8Cx/8EeN3CB2RnbgwujNadreUaYxb7/pjvg4Kn8ILT/yWcdaoYbBVXQWsp6wAXlIYqn+cTgaETB1mdYI6PB+slEQw==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(7636003)(6666004)(7416002)(54906003)(47076005)(5660300002)(36860700001)(186003)(356005)(1076003)(110136005)(316002)(2616005)(82310400004)(9786002)(26005)(4326008)(8676002)(70586007)(70206006)(83380400001)(508600001)(7696005)(8936002)(426003)(44832011)(2906002)(40460700003)(336012)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7105
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT051.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: be92ef49-9b0d-4960-2f09-08da1277edbe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLmZRP0+ZSwaEBjPTTnnLjfT4R9IYtVD3lzF4d7BVlfF1PpRSrAVhPCuwJdUYAe8eCGMapSPeyTwf+qAhzKX/BnPek2eXc07YsYk2Ef3LouKkC01IU0D9wHz2vxF2eugmPoawAv6ejhVvrm4MbFzQi84yCkMVmNu94kr4Iu2lJVhOUnE24Fh10w6/fCbNFhaCz3HWmGRfGNKJeTJWIzdVoEMPbvoG523S53azuV7fzi2iQcViUAbhl0s5Yg0TFl44eMczGveRFJMkNnOHp2sCuI8y5XRkhx14mJd11cG2Yhve0Ej+MHwu7FhAp5d2Xw50asKx+p/1rwNyMOPSVjft/Ivq5Ubgv4ZznNrqJJX512UAxfj8k+HUtxp51rsv4CraXDThsfT0ljrMDc4AVLT+aRFxvLoBKqmiApdu4SWxO8ZZeXlMJ9sb9skmCGYZv0aN6DBvw9XyQYT8uy8J5MuWqd/gYWotn1pzzmbrZRcZD1xSO/ooYTUsR2kExKUYvxe4dtxqVtBYhxii4dF8VzObn6xV3F8FUvU+pzbeDnnGqM3JCoxaFOoio4B3YijsdXfJr1K3UFH6KDBaiP4A54JN0I39dwQN8lu22eHsR4L5c/OaQc2RWD9L9SXBh+Tqy8DfV/E2mMlAABXGN/mQvJMNdH7u9JDVe1rodJsmtoHJgB4pbE4vqK4h9XUxiCCmMylYhSwSDHSBdz4QYxXBBmDK2/hN9Mh9dqyYzEm8jwwKLed8aKw2oYrpftktVaz4QKw
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7416002)(36860700001)(44832011)(36756003)(8676002)(70206006)(426003)(9786002)(2906002)(83380400001)(81166007)(47076005)(4326008)(8936002)(5660300002)(1076003)(316002)(82310400004)(2616005)(336012)(7696005)(6666004)(508600001)(54906003)(26005)(186003)(110136005)(40460700003)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:05:55.8118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f9c0ae-7ade-4a23-372c-08da1277efc4
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT051.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5344
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should store feature bits in vhost_types.h as what has been done
for e.g VHOST_F_LOG_ALL.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 include/uapi/linux/vhost.h       | 5 -----
 include/uapi/linux/vhost_types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 5d99e7c242a2..8f7b4a95d6f9 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -89,11 +89,6 @@
 
 /* Set or get vhost backend capability */
 
-/* Use message type V2 */
-#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
-/* IOTLB can accept batching hints */
-#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
-
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index f7f6a3a28977..76ee7016c501 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -153,4 +153,9 @@ struct vhost_vdpa_iova_range {
 /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
 #define VHOST_NET_F_VIRTIO_NET_HDR 27
 
+/* Use message type V2 */
+#define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
+/* IOTLB can accept batching hints */
+#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+
 #endif
-- 
2.30.1

