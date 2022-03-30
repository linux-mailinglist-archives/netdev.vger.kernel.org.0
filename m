Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354734ECBDF
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350011AbiC3SZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350732AbiC3SXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:23:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4348B427FD;
        Wed, 30 Mar 2022 11:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8itKTQ6u0J3QOLhLr7DljYEqd3evEFdPyLdYcUFr9g=;
 b=isXyoyAOOFowTejZvujY6fF1Stz16sWO+4ekoFB7HnYpGQ9GeaInYiJAL42hvyLTG16tvaCYWpoCDF6DI/ZkHKbLABNCArR+L5E2d3y4zxK9IxAT/7hcAYJziqtxfeprV9rFXeLNHQEpbP6FAI90WsuFUXSzQHB+83PcuF991/k=
Received: from BN0PR07CA0011.namprd07.prod.outlook.com (2603:10b6:408:141::32)
 by SN4PR0201MB3407.namprd02.prod.outlook.com (2603:10b6:803:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:20:53 +0000
Received: from BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::19) by BN0PR07CA0011.outlook.office365.com
 (2603:10b6:408:141::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:20:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by BN1NAM02FT057.mail.protection.outlook.com (10.13.2.165)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:20:53 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 8883F3F03C;
        Wed, 30 Mar 2022 18:20:52 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKo+S5kf4IBaEE/wh7ZlZNeK6jtbloWHjKX/0jw2trvT1Mys3FDQgExRgfGaI5Bu/PugaBuaa9aGsuUo0Wfz091JNyqVeQLJz/FsssmBBg2483DceMjqf4X5cll7465GUFrj24sN2a1CWNrUadG7YXm5B72ZOALaAyHwoMfho7AqNFZJV6KoHcxgRELHmMjstC3NeRD2VWs/TqSh5LXS52YMgAncHzEa2HeLOKndBUjn6edVPYKdUa9osTUevne4BWBDcfO6kbEmy/g45f3WQv2Qqjxw+jLbjtS2r6aZnXmDMvAfg95fz1AREYQYshPvbrjReOxWfl0EVN4BH1T1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8itKTQ6u0J3QOLhLr7DljYEqd3evEFdPyLdYcUFr9g=;
 b=DHeRMm6ifoayU1Vcuq5yUlvXLhSHtP36V9cw2y/73MsIEWLR1a/Lf1hOIaDa/NHk375z4QpKmGO5wmtZzyfiwrfuxfZbOlWtTo6WcYrLA0gFM2YXNY0VeMWC1lPPmJ4cGpl0n43/i40LXt6Ic5+Wo/lXaQuBlGGx+PGqd/sXVvfZamq6wN9jVf6t4m3Qi8PP0ZGNzIIVGxfPFGpH8I/nGuIv/KdPCk1HW2Xe8UaCR/xVuUCpgGKUpRv6Xd+fy2ZvD3rqFs1jjLV40P+u/m7Y3CpxMEPp2FSLU/moR5On3JFjvMqXVh6y+DUx/qPJ3o7H3lCPBl5AR2y2Lcn5Ea66uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=temperror action=none header.from=xilinx.com; dkim=none (message not
 signed); arc=none
Received: from BN9PR03CA0414.namprd03.prod.outlook.com (2603:10b6:408:111::29)
 by SN4PR0201MB8726.namprd02.prod.outlook.com (2603:10b6:806:1e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 18:20:50 +0000
Received: from BN1NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::a) by BN9PR03CA0414.outlook.office365.com
 (2603:10b6:408:111::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:20:49 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 149.199.62.198) smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT044.mail.protection.outlook.com (10.13.2.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:20:48 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:20:13 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:20:13 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 longpeng2@huawei.com,
 elic@nvidia.com,
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
 si-wei.liu@oracle.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcvU-000CCQ-NM; Wed, 30 Mar 2022 11:20:13 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Longpeng <longpeng2@huawei.com>, Eli Cohen <elic@nvidia.com>,
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
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 19/19] vdpasim: control virtqueue support
Date:   Wed, 30 Mar 2022 23:33:59 +0530
Message-ID: <20220330180436.24644-20-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 4ac9a35f-1ac5-49a3-ccb1-08da127a06bf
X-MS-TrafficTypeDiagnostic: SN4PR0201MB8726:EE_|BN1NAM02FT057:EE_|SN4PR0201MB3407:EE_
X-Microsoft-Antispam-PRVS: <SN4PR0201MB34074D0698BA5B4037659FC2B11F9@SN4PR0201MB3407.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: e+cJUaoCIrL84JDSNKOqK7ptcZdnhEIRz5w+sCVH5WsJH+gw+AwkFdt/eypN64vaGntKuJfdyVJYV1QJ2ng68sxRaI/3E0tJWYDYEWzubPfUFq6cZ5vi/J1ngS8tHi6XBT3AFhEuaqfPCECyeOc/o1/LeJPVJouLSfQqBxuyo0k7E/kL+qIBTu564tfaT2VEHhhsNsffKg2g2xTB7Fc7yXLaYyEBHjAKSdOKnKseZBruQzDty8wyR9Ca7Dnio+7h6OVL8m1K0gwtXvW3jQduSEKvqXgFC6XVMWdF7DnVnHXG8iucgNjMdSUxvOzvz1/q34ibNamC4yB4nUVXr70/DYp9A3Q19qKwJyM3I4nwHfX7niDaSG93Z3cRCK4jNv7Zo+dqSpaJS/GNS+RIkrrAv1A2dVBAGBNSH56mJ6Z3XBML5rnhWmbUQGLMAK/1UQx8nMGbf/8aI9jFVBgK/RO/Dg8Or6rolP6osPB8YQMuAk67x5lhBVSS8zLN7qfQzmqDb2plim9Y/68inIXLVVGNd3rBYkO/dWxO1bCS+ZZD4xMfh9P75TLnVTHFFzkItwaHQWnS3ARHFl/4je9J9pi1h0HT/JXwkSa6gO5wJqsXeJ777AMWQQO2dVu0m5rRZja91+q9jsJkDop4gruDkxAEUTyAcyOZnGkErv3zsES6AZCNBN2gbVMG/gIEi11MVc0BLr98h1muW9gYO+BaZBPe88K7dH0Ze0RqgQ8dkO9JrXc=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(426003)(336012)(83380400001)(63350400001)(110136005)(47076005)(8936002)(7416002)(54906003)(63370400001)(82310400004)(5660300002)(508600001)(36860700001)(7636003)(921005)(356005)(316002)(70206006)(30864003)(6666004)(2616005)(2906002)(40460700003)(44832011)(36756003)(70586007)(186003)(1076003)(4326008)(7696005)(8676002)(9786002)(26005)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB8726
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2aa0ec82-c7a5-446c-948b-08da127a03f6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mGw3B6CVmemVNvzm+2eY8bwF4hwDCLnMBahXSfLTtwWj/hsmeijfhNuZipoOMHV79LJVgWBdb+4L8NaDXFxzhWFo7qnlaxcJEMBJgfD0sVjjaSKwhXrkx8VfiKB8sSSkLqRXygTlrVZ1xGpUEA2eZWfY/mzMw1RpsBUmw7zg/hkvtGFIJwo/ZlDt7Qml9asU6Dw0kohReshErGTqENVxmBZLOmIiHEf6/pYAJjeGhQkP3vZSD/XC9UT8Oo9mU7vuY/j3IECCuBZMV1chFa2+q2r87R25OkjQup+smVXENqlTmTsjB9CyCWdLB6k2Rkb72EQAq2xgsRhk9aRKdqe6cWJColXaZFcNwLpwu+UbAMZ5TnFN96DxjVzEr6i4iDzVpsfvR8QNshbqJiJPk0BtTHs7M9FIODJZg5Xjc/EF27kt0ZooAwSDkctKDbqXjkn1Kf+xO4rkJ7aQijX40+jLwwKiijURWY6szP1wWhYhfviI9t6/ehaI77F46IGff15a3pxManQAFLL4zx+kid9cpEP9C5oSU11aqpzI5D1S2M1PjaWwdRLB7SbgJ0y03QoaJh5M6FmwCMq69IbCmJS4BvEG8o7pHl90Hseewmy47eZwRdg5V2xtvYRqTqBd8JfJBCO20ums3DYA9U1u5La8YlovhmdI5yecIHfQpXINo6W3fpfphOKf2AgkD629tvebGC/9IWBtFoiV8mNuWGFJZld7JOrqDdLQF+qfxV/CHMR+yZWVo+nk5eIbBsHvMUliiKIQBoxCfiNFvCz/usqP2A==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2616005)(47076005)(110136005)(44832011)(36860700001)(426003)(54906003)(82310400004)(7696005)(8936002)(1076003)(186003)(336012)(26005)(508600001)(9786002)(7416002)(5660300002)(30864003)(40460700003)(81166007)(921005)(36756003)(6666004)(83380400001)(8676002)(4326008)(316002)(70206006)(2906002)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:20:53.3171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac9a35f-1ac5-49a3-ccb1-08da127a06bf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB3407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the control virtqueue support for vDPA
simulator. This is a requirement for supporting advanced features like
multiqueue.

A requirement for control virtqueue is to isolate its memory access
from the rx/tx virtqueues. This is because when using vDPA device
for VM, the control virqueue is not directly assigned to VM. Userspace
(Qemu) will present a shadow control virtqueue to control for
recording the device states.

The isolation is done via the virtqueue groups and ASID support in
vDPA through vhost-vdpa. The simulator is extended to have:

1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
   contains CVQ
3) two address spaces and the simulator simply implements the address
   spaces by mapping it 1:1 to IOTLB.

For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
to group 1. So we have:

1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
   RX and TX can be assigned to guest directly.
2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
   is the buffers that allocated and managed by VMM only. So CVQ of
   vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
   of vhost-vdpa.

For the other use cases, since AS 0 is associated to all virtqueue
groups by default. All virtqueues share the same mapping by default.

To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
implemented in the simulator for the driver to set mac address.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 91 ++++++++++++++++++++++------
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 88 ++++++++++++++++++++++++++-
 3 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 659e2e2e4b0c..51bd0bafce06 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -96,11 +96,17 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 {
 	int i;
 
-	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
+	spin_lock(&vdpasim->iommu_lock);
+
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vdpasim_vq_reset(vdpasim, &vdpasim->vqs[i]);
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
+				 &vdpasim->iommu_lock);
+	}
+
+	for (i = 0; i < vdpasim->dev_attr.nas; i++)
+		vhost_iotlb_reset(&vdpasim->iommu[i]);
 
-	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
@@ -145,7 +151,7 @@ static dma_addr_t vdpasim_map_range(struct vdpasim *vdpasim, phys_addr_t paddr,
 	dma_addr = iova_dma_addr(&vdpasim->iova, iova);
 
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, (u64)dma_addr,
+	ret = vhost_iotlb_add_range(&vdpasim->iommu[0], (u64)dma_addr,
 				    (u64)dma_addr + size - 1, (u64)paddr, perm);
 	spin_unlock(&vdpasim->iommu_lock);
 
@@ -161,7 +167,7 @@ static void vdpasim_unmap_range(struct vdpasim *vdpasim, dma_addr_t dma_addr,
 				size_t size)
 {
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_del_range(vdpasim->iommu, (u64)dma_addr,
+	vhost_iotlb_del_range(&vdpasim->iommu[0], (u64)dma_addr,
 			      (u64)dma_addr + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
@@ -250,8 +256,9 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	else
 		ops = &vdpasim_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
-				    1, dev_attr->name, false);
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+				    dev_attr->ngroups, dev_attr->nas,
+				    dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
@@ -278,16 +285,20 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	if (!vdpasim->vqs)
 		goto err_iommu;
 
-	vdpasim->iommu = vhost_iotlb_alloc(max_iotlb_entries, 0);
+	vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
+				       sizeof(*vdpasim->iommu), GFP_KERNEL);
 	if (!vdpasim->iommu)
 		goto err_iommu;
 
+	for (i = 0; i < vdpasim->dev_attr.nas; i++)
+		vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
+
 	vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
 	if (!vdpasim->buffer)
 		goto err_iommu;
 
 	for (i = 0; i < dev_attr->nvqs; i++)
-		vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
 				 &vdpasim->iommu_lock);
 
 	ret = iova_cache_get();
@@ -401,7 +412,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
 
 static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
 {
-	return 0;
+	/* RX and TX belongs to group 0, CVQ belongs to group 1 */
+	if (idx == 2)
+		return 1;
+	else
+		return 0;
 }
 
 static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
@@ -539,20 +554,53 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
 	return range;
 }
 
+static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
+				  unsigned int asid)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	struct vhost_iotlb *iommu;
+	int i;
+
+	if (group > vdpasim->dev_attr.ngroups)
+		return -EINVAL;
+
+	if (asid > vdpasim->dev_attr.nas)
+		return -EINVAL;
+
+	iommu = &vdpasim->iommu[asid];
+
+	spin_lock(&vdpasim->lock);
+
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
+		if (vdpasim_get_vq_group(vdpa, i) == group)
+			vringh_set_iotlb(&vdpasim->vqs[i].vring, iommu,
+					 &vdpasim->iommu_lock);
+
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
 static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			   struct vhost_iotlb *iotlb)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vhost_iotlb_map *map;
+	struct vhost_iotlb *iommu;
 	u64 start = 0ULL, last = 0ULL - 1;
 	int ret;
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
+
+	iommu = &vdpasim->iommu[asid];
+	vhost_iotlb_reset(iommu);
 
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
 	     map = vhost_iotlb_itree_next(map, start, last)) {
-		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
+		ret = vhost_iotlb_add_range(iommu, map->start,
 					    map->last, map->addr, map->perm);
 		if (ret)
 			goto err;
@@ -561,7 +609,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	return 0;
 
 err:
-	vhost_iotlb_reset(vdpasim->iommu);
+	vhost_iotlb_reset(iommu);
 	spin_unlock(&vdpasim->iommu_lock);
 	return ret;
 }
@@ -573,9 +621,12 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
-					pa, perm, opaque);
+	ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
+					iova + size - 1, pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
@@ -586,8 +637,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
+	if (asid >= vdpasim->dev_attr.nas)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
+	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return 0;
@@ -611,8 +665,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	}
 
 	kvfree(vdpasim->buffer);
-	if (vdpasim->iommu)
-		vhost_iotlb_free(vdpasim->iommu);
+	vhost_iotlb_free(vdpasim->iommu);
 	kfree(vdpasim->vqs);
 	kfree(vdpasim->config);
 }
@@ -643,6 +696,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
 	.get_iova_range         = vdpasim_get_iova_range,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
 	.free                   = vdpasim_free,
@@ -674,6 +728,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
 	.get_iova_range         = vdpasim_get_iova_range,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
 	.free                   = vdpasim_free,
 };
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 0be7c1e7ef80..622782e92239 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -41,6 +41,8 @@ struct vdpasim_dev_attr {
 	size_t buffer_size;
 	int nvqs;
 	u32 id;
+	u32 ngroups;
+	u32 nas;
 
 	work_func_t work_fn;
 	void (*get_config)(struct vdpasim *vdpasim, void *config);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 5fa59d4fddc8..5125976a4df8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -27,9 +27,14 @@
 
 #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
 				 (1ULL << VIRTIO_NET_F_MAC) | \
-				 (1ULL << VIRTIO_NET_F_MTU))
+				 (1ULL << VIRTIO_NET_F_MTU) | \
+				 (1ULL << VIRTIO_NET_F_CTRL_VQ) | \
+				 (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR))
 
-#define VDPASIM_NET_VQ_NUM	2
+/* 3 virtqueues, 2 address spaces, 2 virtqueue groups */
+#define VDPASIM_NET_VQ_NUM	3
+#define VDPASIM_NET_AS_NUM	2
+#define VDPASIM_NET_GROUP_NUM	2
 
 static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
 {
@@ -63,6 +68,81 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
 	return false;
 }
 
+static virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
+						   u8 cmd)
+{
+	struct virtio_net_config *vio_config = vdpasim->config;
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	size_t read;
+
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov,
+					     vio_config->mac, ETH_ALEN);
+		if (read == ETH_ALEN)
+			status = VIRTIO_NET_OK;
+		break;
+	default:
+		break;
+	}
+
+	return status;
+}
+
+static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct virtio_net_ctrl_hdr ctrl;
+	size_t read, write;
+	int err;
+
+	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
+		return;
+
+	if (!cvq->ready)
+		return;
+
+	while (true) {
+		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->in_iov,
+					   &cvq->out_iov,
+					   &cvq->head, GFP_ATOMIC);
+		if (err <= 0)
+			break;
+
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
+					     sizeof(ctrl));
+		if (read != sizeof(ctrl))
+			break;
+
+		switch (ctrl.class) {
+		case VIRTIO_NET_CTRL_MAC:
+			status = vdpasim_handle_ctrl_mac(vdpasim, ctrl.cmd);
+			break;
+		default:
+			break;
+		}
+
+		/* Make sure data is wrote before advancing index */
+		smp_wmb();
+
+		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
+					      &status, sizeof(status));
+		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
+		vringh_kiov_cleanup(&cvq->in_iov);
+		vringh_kiov_cleanup(&cvq->out_iov);
+
+		/* Make sure used is visible before rasing the interrupt. */
+		smp_wmb();
+
+		local_bh_disable();
+		if (cvq->cb)
+			cvq->cb(cvq->private);
+		local_bh_enable();
+	}
+}
+
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
@@ -77,6 +157,8 @@ static void vdpasim_net_work(struct work_struct *work)
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
 
+	vdpasim_handle_cvq(vdpasim);
+
 	if (!txq->ready || !rxq->ready)
 		goto out;
 
@@ -162,6 +244,8 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	dev_attr.id = VIRTIO_ID_NET;
 	dev_attr.supported_features = VDPASIM_NET_FEATURES;
 	dev_attr.nvqs = VDPASIM_NET_VQ_NUM;
+	dev_attr.ngroups = VDPASIM_NET_GROUP_NUM;
+	dev_attr.nas = VDPASIM_NET_AS_NUM;
 	dev_attr.config_size = sizeof(struct virtio_net_config);
 	dev_attr.get_config = vdpasim_net_get_config;
 	dev_attr.work_fn = vdpasim_net_work;
-- 
2.30.1

