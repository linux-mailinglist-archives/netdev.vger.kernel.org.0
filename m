Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9334ECBBD
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344942AbiC3SV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiC3SVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:21:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9F942A21;
        Wed, 30 Mar 2022 11:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3G6k8sUWSn6lI6j7WyZONhDugw0wYLK9Gjpmdqufjo=;
 b=QMtGUGmZ0g5d0Xk047t2zxsKxH/tmfQpyHUVLoFgKMnLU8V9vCDayzbLP7qvVMGvxxuLH5OGfJKOU2ehdnq1m9o1FPVBqlHvnMPJB4/NlbqfLfI8cDvklJQJxl6xdQdn4O/b1pjoE3lL8g1m3Qo2eQ3OTCHTYDXnGtNUE/TEwyQ=
Received: from BN6PR22CA0040.namprd22.prod.outlook.com (2603:10b6:404:37::26)
 by SJ0PR02MB8625.namprd02.prod.outlook.com (2603:10b6:a03:3f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 18:19:33 +0000
Received: from BN1NAM02FT018.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::42) by BN6PR22CA0040.outlook.office365.com
 (2603:10b6:404:37::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:19:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by BN1NAM02FT018.mail.protection.outlook.com (10.13.3.159)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:19:32 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id EE82A3F03B;
        Wed, 30 Mar 2022 18:19:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCkfKGDvNepUo6xup2zi1W9vPmGEqvc6ZPWvTfDrOtw5TZoT+DO5UuBD+kOrFWF+wNdB84MLm+TeNIkFsmR3yPWkSyJrf0dXtUHeQlmyHWYfK1hxPoRekxc1hjmnQ7Jr71ktfiXniOQzRS+io+uDQKrAbz491ZWQoFzDepDLJ81e4aOwwh6uRTIAuczJS+OjDo3tRvwezqicd8JjY+ZfN13k8Xdofw3kJ5hsJaZaMNfIFVXY2yTu23vEidZiVn1IlFnR+161YCxfNvogrhXWNSl17go7EjxK9JGQF1Ft9iw2bETzULE5Lgt4pfpv2b5eVtloHZpBHOo5tfFUFQbyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3G6k8sUWSn6lI6j7WyZONhDugw0wYLK9Gjpmdqufjo=;
 b=kLFVm4Znr+k31QTkcjnv55eG1BAOVvxtJkuvNRMWYKCm2y4Tk0tPHs7utOJtm0wmmMa9P8qS56qnfLIxp199kwVny+UtoS9jHIXxdqj4pSElvTFk3258HyTPAMfNPO7naQ7PFFm/Ryj3XOsYeUQkyl1lDXtjzHcHK0uZKXklnk0Fhwq1SDGWlRhtcoMkDBTLAmgfQr6EdqNz7hkIa3ihzQXTS9minswc/HU4LCdhdAxjBeMjIRHC5/y4BIjQ6JXnZyLJgHLEIarHcLS8YczwZtRRj+OjDryvBVQ2uboMjOwkr5VdPv0KUo1zXTEJHfn5tSDERpR7gmi1HSTudvnirA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN6PR14CA0012.namprd14.prod.outlook.com (2603:10b6:404:79::22)
 by DM6PR02MB5513.namprd02.prod.outlook.com (2603:10b6:5:75::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 18:19:28 +0000
Received: from BN1NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::f7) by BN6PR14CA0012.outlook.office365.com
 (2603:10b6:404:79::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT049.mail.protection.outlook.com (10.13.2.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:19:28 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:19:22 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:19:22 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 elic@nvidia.com,
 sgarzare@redhat.com,
 parav@nvidia.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 lingshan.zhu@intel.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcug-000CCQ-4X; Wed, 30 Mar 2022 11:19:22 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <elic@nvidia.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 18/19] vdpa_sim: filter destination mac address
Date:   Wed, 30 Mar 2022 23:33:58 +0530
Message-ID: <20220330180436.24644-19-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: dd2b96ef-58ef-419b-b4a5-08da1279d6ba
X-MS-TrafficTypeDiagnostic: DM6PR02MB5513:EE_|BN1NAM02FT018:EE_|SJ0PR02MB8625:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB86258575D630F88774F5969EB11F9@SJ0PR02MB8625.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: kKBWQEh/y9Eglx/mNQHVs1YuIJvqgdWkLjTn3yuJWVnV4PZIapgixIBgPL7pjtSH8oW5IDmYiTGC5v/ZjgVqClsiY+RVLguviNUMuV/2ZqCJKPbqH4wwoIFyjdowgQQ3xaDg8w0+FwC+RCoj6G5jkvt6m9MedZwn0p7fn/HfgIr2F53NxWkVus4XaO1TLHTnVIDmOzTu+cyiX8StwMqq5+Tas13BAhTGgd3YsXpz/BMAVRbu7LENWPpZLsGuZOfBn1ZaEGMH81Sxu+Hsdgfn5GWS0GZ8ehvS5oC4QxXAYxPwQxgGX7QEsT6k7Ej3LQ54kVGWE8l9R5w2y6vzy2zkH7eH410Rdd81v/zOEk2ilMa22iPcbJH5dyASLp2mLWRwslMCsLLmhLgVcNnS3mG4Vmfr28jbgnqWFU777mdzosv1ruAskHUIuCmRbMJwQxQsh+3rk9GNSFjOkS/h/XZ3dTg5fwQclcK1JZHj8J3FpmNdywJX30MQElQJ35YSULGWIx1bpr3dc6AjkTAgcqSi6/ExdFmB2wHsRFzbbtxyNwwqbGMtpSmh7Cui2C6y2Hbz09bGLlbRJKyYAfZ8cZvLnI876gqDx73DTKgiLGr4r0ggEGJZj1Ay8aU1a9GiccGzvEoh7MM3ln4GirvO9SJEbQfHgMRMLOz790BSgsLCrx/FHPKf/7gbTAmOpa4ty7p8hEqMKgjiTrGwGYJsj+nL02Hn4dMxktt3LFW/e8LiRH8=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(44832011)(7416002)(921005)(9786002)(8936002)(82310400004)(5660300002)(356005)(1076003)(2616005)(186003)(40460700003)(110136005)(316002)(54906003)(336012)(426003)(26005)(7636003)(508600001)(6666004)(36860700001)(4326008)(47076005)(8676002)(83380400001)(70586007)(70206006)(7696005)(36756003)(2906002)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5513
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN1NAM02FT018.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: de3a5c75-1a5f-4121-8313-08da1279d429
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTYtF7bk19GuhW3ymDN69FqvR7UTuFQQE9mxXDZS29Pqdp0YMbCpmycsHm/XNvtnIj20JpyIj3Mc/X1Z05PMnLsIdHn3G5nknULS4MNGeWPW25cWWhFy1M/TFNeubW4XFzQXxmU+cPXfewSggbMVjwIbwVHb40JpXJo3tDGaNxQv6BlhdPytT9ogHOOi6h0AtYV9tahRlSgtTu1CBlkBk+BHLDAKyuL3zlreNJhabvzrzyeyj2JDZkYSIza3cAFSV9ZGmmo2ZriOev4ageebZB5d+pqg+igK8a3mS7IFSCx+Cp5oqwwB0DDsi51dDSz3jah2spTk0AS/I7Thu96lWqxSil33nqFqErWbG3/7rLkHIXFbhpuouMrF7Yw+9Eof4/ggfpKLzUg8a3eaRCfO+W3cYOnIZTNCLH+sbb/5KzSCzXBvFpTlyozWrUqW/2TxBlEO9vACoyH3haIRVCZK4+QEcJNQJXr5STqx8l9mXa7YRWKgDg3gi78+i/kz0P51o3aXqwP/phk6MDZZ9M1fjeWW5phm/KdTPxbK70ADigQbZ+Qjr3C7Q4nc40hk1hzRwmGZNvP85gAG5BL2yPZ/E/7OlpLMSCRLVSS0CVHX8pcTHOTNhAjswTFk6pRc7cIS/Sd+JHNlEZABLCO8BxVwHO6jFR90mP2115L7ozwBsKNb3F8bx4K5B5i/dAy1UMK7jTOdlrzu9paPfkICqfnsCwcU3pAnO+RY5cuSUV7es+m06xmkg5md8QCRLwZCwLIb79qOpY5BA9zC5xeUXTyD2Q==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400004)(6666004)(44832011)(81166007)(508600001)(8936002)(47076005)(70206006)(2906002)(7416002)(316002)(9786002)(83380400001)(7696005)(921005)(5660300002)(8676002)(40460700003)(26005)(36860700001)(4326008)(1076003)(336012)(2616005)(186003)(36756003)(426003)(54906003)(110136005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:19:32.7374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2b96ef-58ef-419b-b4a5-08da1279d6ba
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN1NAM02FT018.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8625
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements a simple unicast filter for vDPA simulator.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 49 ++++++++++++++++++----------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index f4607172b0b8..5fa59d4fddc8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -47,13 +47,28 @@ static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 	local_bh_enable();
 }
 
+static bool receive_filter(struct vdpasim *vdpasim, size_t len)
+{
+	bool modern = vdpasim->features & (1ULL << VIRTIO_F_VERSION_1);
+	size_t hdr_len = modern ? sizeof(struct virtio_net_hdr_v1) :
+				  sizeof(struct virtio_net_hdr);
+	struct virtio_net_config *vio_config = vdpasim->config;
+
+	if (len < ETH_ALEN + hdr_len)
+		return false;
+
+	if (!strncmp(vdpasim->buffer + hdr_len, vio_config->mac, ETH_ALEN))
+		return true;
+
+	return false;
+}
+
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 	struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
 	struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
 	ssize_t read, write;
-	size_t total_write;
 	int pkts = 0;
 	int err;
 
@@ -66,36 +81,34 @@ static void vdpasim_net_work(struct work_struct *work)
 		goto out;
 
 	while (true) {
-		total_write = 0;
 		err = vringh_getdesc_iotlb(&txq->vring, &txq->out_iov, NULL,
 					   &txq->head, GFP_ATOMIC);
 		if (err <= 0)
 			break;
 
+		read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
+					     vdpasim->buffer,
+					     PAGE_SIZE);
+
+		if (!receive_filter(vdpasim, read)) {
+			vdpasim_net_complete(txq, 0);
+			continue;
+		}
+
 		err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->in_iov,
 					   &rxq->head, GFP_ATOMIC);
 		if (err <= 0) {
-			vringh_complete_iotlb(&txq->vring, txq->head, 0);
+			vdpasim_net_complete(txq, 0);
 			break;
 		}
 
-		while (true) {
-			read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
-						     vdpasim->buffer,
-						     PAGE_SIZE);
-			if (read <= 0)
-				break;
-
-			write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
-						      vdpasim->buffer, read);
-			if (write <= 0)
-				break;
-
-			total_write += write;
-		}
+		write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
+					      vdpasim->buffer, read);
+		if (write <= 0)
+			break;
 
 		vdpasim_net_complete(txq, 0);
-		vdpasim_net_complete(rxq, total_write);
+		vdpasim_net_complete(rxq, write);
 
 		if (++pkts > 4) {
 			schedule_work(&vdpasim->work);
-- 
2.30.1

