Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AA4C37D5
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiBXVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiBXVaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:30:13 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2085.outbound.protection.outlook.com [40.107.95.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2627D1BE4EF;
        Thu, 24 Feb 2022 13:29:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqQ1CJLNGCYwaNNrochh1LbK2KCcSph99+93axdMjXcmgtVUnU7vZzayqW0vMldHdsxsoWl+XbNDiUFPo/Mp8AALc5Xr/Rgg1YP5ImZ8jwE52oiOkzTOCbyPP6ra2lt6alzn1uTSujN70rcPoAWT2lzzlBfjozrs+H6JZCmdOOiBAfjnOANV5+UWWEvX7AdxYRkwebBSGoFgR4B0OhOLz2FxzolDC3NCpV+Rbjz5GzS9o75AFZ5agi4QpsHRGyo40SPHKptjEpVL+F6npGdvxZi5RV19eUFEPDt0fV5XoZuG3sBSZOuPOzon0h09EP1PBjANfAAbGxrjoU7Hiq1kJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WknOEB46P6HUrolnkHi7vdGXd7mgQc+akfqSibPSMt8=;
 b=Mc7jTe2gU3oEbo1mLrRtkbWQaXCnFJRe3AKZW54by0xF/XI4gKJdr+ySKZR8zUU/g/0M0vk7wfcIPEXy2k4vQEaP7MGZ6HtTX0dZykn2e/nD8oAhJRKNakzwx09DnoGzXi3MERnpbiqlUXIl65hp3F1xH+fs1S8o1YyI31Fz8NkesDVYP3y5lycOIJNEQJa4TQN15fwBn8iufiIH2Nv9ASa6agB2gcuKI58MpEWKtvXcknEwuFz2eai2dIS010k1haKi+6QjOi0TCxgqPpg/9y4rRoKvOXuEDCHOUBk452OVOF9lnJ92WWHdFhZkhvBncLswUQDhvDx4+9npxcIFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WknOEB46P6HUrolnkHi7vdGXd7mgQc+akfqSibPSMt8=;
 b=p7UqLyAt3dB9zNdPJVuHJn8luahTjKq0cwcL89GT9U3WuyUzR1ma+Ht5KSFtl0V4KQJOF/7y90i4b5d/VyHF+1E/FBtOb8L5rD4y3o6CMGsB1nI+OupVSgIud2hYB3LgxL+V4gz7czHE5jbPLNXjMUt4SSI/bZctr+/DHDTXz/k=
Received: from DM6PR02CA0164.namprd02.prod.outlook.com (2603:10b6:5:332::31)
 by MWHPR02MB2864.namprd02.prod.outlook.com (2603:10b6:300:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 21:29:18 +0000
Received: from DM3NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::30) by DM6PR02CA0164.outlook.office365.com
 (2603:10b6:5:332::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 21:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT028.mail.protection.outlook.com (10.13.4.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:29:18 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:29:04 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:29:04 -0800
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
        id 1nNLfc-00095B-7l; Thu, 24 Feb 2022 13:29:04 -0800
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
Subject: [RFC PATCH v2 18/19] vdpa_sim: filter destination mac address
Date:   Fri, 25 Feb 2022 02:52:58 +0530
Message-ID: <20220224212314.1326-19-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95ebf148-603b-430c-0b77-08d9f7dcb6f3
X-MS-TrafficTypeDiagnostic: MWHPR02MB2864:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB28649B0B78F7B95C19E814CEB13D9@MWHPR02MB2864.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jkNOtryP3HLO0cDMpDUxuPwk4g6v48ECBbcecC6DCupr9cBo+wF2l4mjQ0CcBNNu4lQZDiOgIPUONPi77T0S0DOTB2o0/c/pfUSDszjdiTnP28cvgsj7OqpUAOCdh2iWngPaJHpH/+XML+Qilz4fzSdjoAL+Cib7AFn8GFq2u+f43ks9gHrEe/aMDU5OuaHPfv6TRdimGkdVU03eX5b/WswUxSD9hH1Z1HJPGatdbr645X3cwlPFrDbZJVCmobHgiu6aVyMbMeBVelHIODk8wWyZ0dJR0UQ2t+wZnoJJA0TtIbaxBNbeo0v7NgDsnbMfSRU9DaX7Q/aTOcKLgGv3mo5rHtAOrAlUhZ40J0uk/y5lJJnRRL3h230KZ6IV8NCsKebMVQXyMM4JjPlvDNlZMzLTGT+qf0jlmVU9oNdeHWPOU073+yNYuVDaK3RNQFNy9Dx8jBOiHgZdqruxFa3m6pCiHhaeAsyFkobTqlB0tF7gxOB6QZVxhg6WKj9wZ8a5l8tQo3pyCR0gu473su+oFeeai1QEQHWYgctZ3q7NxGCX9+riC7i/l0bi6Qzw/X5kqgz7XrsDGYYdDBWxfyxLt0h1sZXWSrTx6owztlkbSaus/daonTjweAo2VK3Mc4cyMRGwqJbhmwVh79DAdUVPmYdPSHbh3XiZaPKJq7y92xWbsqi0kzs9NvjNPfGLcUWcFd1T00CCxaA8rtzbpE+4SfzkdUjWXXNrc2ugtfZzJk=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(6666004)(7636003)(44832011)(7696005)(9786002)(2906002)(186003)(40460700003)(26005)(8936002)(109986005)(54906003)(47076005)(336012)(8676002)(83380400001)(82310400004)(2616005)(508600001)(70586007)(70206006)(4326008)(316002)(1076003)(7416002)(36860700001)(36756003)(5660300002)(426003)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:29:18.3101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ebf148-603b-430c-0b77-08d9f7dcb6f3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT028.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2864
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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
index 05d552cb7f94..ed5ade4ae570 100644
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
+
+	if (len < ETH_ALEN + hdr_len)
+		return false;
+
+	if (!strncmp(vdpasim->buffer + hdr_len,
+		     vdpasim->config.mac, ETH_ALEN))
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
+			vdpasim_complete(txq, 0);
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
2.25.0

