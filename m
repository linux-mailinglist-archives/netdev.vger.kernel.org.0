Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB24C3787
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiBXVX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiBXVX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:23:57 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B12158DB6;
        Thu, 24 Feb 2022 13:23:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUWpJRcEAj+mZPxdQAu7jPfMbur7odARG3ygkqfQeO9RBK8xcSRxL1KiJ6y4MXBir2MbyO0FSR+zQdMpvV0uXfDANBr/cUh8tLrVB4ze2AZUhzHvaYfSS2BzLZPZDWt1cqKtVLbSqAOe3uaPemPXuUF8d5YEaCdsMzHB7OZfMFb0copt5/zYNy9XiPwEXSmnAHj8aiX3FEW/kmqNHz98EKh8+scRszSCFfkUv+NkS2ceQ4pRpsdtIcP2OSxMIhQsnGZliiHXuH7wG9qXZHZrGiajlC6tC9txwQJul7bkvsiT/9nkwrJw4gST8QQiJRYtPwcw563U6bjjxPV1MOaX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL2St3CLEm5G9/8a999sggz0g6fdbQcwsjbuzahvB1U=;
 b=fdItSWH8XDrPYHzCmyjjjj5SuF8wY5sW80OrVTOLNxWgrKsCuJrm6MUAB73CDYoP9jhFfpv0lEuckiq98xhVc//EqTfSaphpaRHDEpRAqVpftwYcG1tCe6BHY879lRkviJHe9BAGWioiSU14QZW/sRpSHYNZI8PMg5mn0NMaiTckO1W/pt1s8cP1jIK4/1UafB1aT2YYRC4X/JdIqsuZXoh45YT5WoKhREd9ddkbPUy54xVY6laO9MliefsajOn0fQcA9StjXrjwBM8ePjDgPTBN6hcG1HG5/SC0EUnpKncPizXw+YMPFlw6sOmGZ7fscPrAPaH2IuUBzNVWoOAOkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL2St3CLEm5G9/8a999sggz0g6fdbQcwsjbuzahvB1U=;
 b=FUg4QJ7C+c7mQxCtUqU6atwBb9plSrt027EPq+vlPuieGBr03C3bGgOwu4iPvCYpgKeSnnrD/AJvGyLACiNBZPlce8A6NXq5UfHTNoAZOVqnUT7pARwy/9iLWO53hZ4pIy09QSXjq2ogvc7ipSfIL1D1UKxKTB5j+GxdWA7USLY=
Received: from DM3PR14CA0140.namprd14.prod.outlook.com (2603:10b6:0:53::24) by
 BL3PR02MB7955.namprd02.prod.outlook.com (2603:10b6:208:356::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 21:23:23 +0000
Received: from DM3NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::63) by DM3PR14CA0140.outlook.office365.com
 (2603:10b6:0:53::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 21:23:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT058.mail.protection.outlook.com (10.13.5.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:23:22 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:23:21 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:23:21 -0800
Envelope-to: eperezma@redhat.com,
 mst@redhat.com,
 jasowang@redhat.com,
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
        id 1nNLa4-00095B-GJ; Thu, 24 Feb 2022 13:23:21 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Subject: [RFC PATCH v2 00/19] Control VQ support in vDPA
Date:   Fri, 25 Feb 2022 02:52:40 +0530
Message-ID: <20220224212314.1326-1-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9ea84de-a45b-42d3-a4d8-08d9f7dbe31c
X-MS-TrafficTypeDiagnostic: BL3PR02MB7955:EE_
X-Microsoft-Antispam-PRVS: <BL3PR02MB795538E34B2E191119CCB656B13D9@BL3PR02MB7955.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2ahp0hco8qnk4s0ExzoTB8drSmKloa6OUhuFZHHOVCLiQWFckWJs870cmFy0KfnFe47QFHW0jDfpFRSHdv5s6n1wA6ERUtd3BB8p4CxWA39uqivv1XB7Ld1vQQ+Zb9kcpwBTWhQZ1hfc6Mo6oAmM54o/UJLXAxSunGJEZdZ1bYLcQK4hD7WmHGsUnNu8B62duuTDWpPPmc6vZPCndQo594RotfmqB7BzE7NFpVblfZKYcstpoCUlojR07uw7KwQgjhiJQPXbbXJHPt4mvAb3AyAQIlkahW5bIr6sxgVKIR4AKDn/nuHbhGL8uFBAnYS6uIr+5yKjaDuau+qBvN4iGXInS4ncc0Ni6PJMNaYRjLVhuJWzod20FIvAXVWKlVNOvLrC2xmL+i4OAloSFK+SvFKs6VTO6FgeOTE33U+NxVP+89MlD1BJsawlZUoavZC3AEJ8WV+UzaYY3I0bYjuQyOQcLCKRPbTuVQYUuyQxjoSbXsYRtxm8/ZJY2LL60DijvcL+GiomVp7GhJpzhP1dq6joMbwcqK9DaeshnKTDS9EndomKTI2Iau8XWCB9Ta4BE/2VvhdTyyIwYh0oFucm1rLPm16zEmVRiN1djCoTuRJIseACWwROChqmu3vxa3ZeHDBMs4g/Vi1xOJRh4G5Bk0m91fc1ogNmENXfgF2Hpe86suNGp3AVkevjjRQ4cPEII0NHe0IJTO+zcMMEqHxc8tj2MOpBY8ekaP0MOs3jOUe11qCDeB9C1xtxhRKQLL6cjK/orjTTyP+V8e4a2sAUEFigX7E7eYJYmi4qrToGOy5lgUd+a3KAR16jXF+qjG844zKFp3MBCnnZddtfuJNFJd9cY6bgomMKX+oK1tjf90=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(44832011)(36756003)(54906003)(316002)(186003)(26005)(83380400001)(47076005)(356005)(7416002)(7696005)(6666004)(7636003)(1076003)(5660300002)(336012)(426003)(109986005)(40460700003)(2906002)(2616005)(70586007)(70206006)(8676002)(4326008)(508600001)(82310400004)(84970400001)(36860700001)(8936002)(9786002)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:23:22.8902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ea84de-a45b-42d3-a4d8-08d9f7dbe31c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT058.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7955
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

This series tries to add the support for control virtqueue in vDPA.

Control virtqueue is used by networking device for accepting various
commands from the driver. It's a must to support multiqueue and other
configurations.

When used by vhost-vDPA bus driver for VM, the control virtqueue
should be shadowed via userspace VMM (Qemu) instead of being assigned
directly to Guest. This is because Qemu needs to know the device state
in order to start and stop device correctly (e.g for Live Migration).

This requies to isolate the memory mapping for control virtqueue
presented by vhost-vDPA to prevent guest from accessing it directly.

To achieve this, vDPA introduce two new abstractions:

- address space: identified through address space id (ASID) and a set
                 of memory mapping in maintained
- virtqueue group: the minimal set of virtqueues that must share an
                 address space

Device needs to advertise the following attributes to vDPA:

- the number of address spaces supported in the device
- the number of virtqueue groups supported in the device
- the mappings from a specific virtqueue to its virtqueue groups

The mappings from virtqueue to virtqueue groups is fixed and defined
by vDPA device driver. E.g:

- For the device that has hardware ASID support, it can simply
  advertise a per virtqueue virtqueue group.
- For the device that does not have hardware ASID support, it can
  simply advertise a single virtqueue group that contains all
  virtqueues. Or if it wants a software emulated control virtqueue, it
  can advertise two virtqueue groups, one is for cvq, another is for
  the rest virtqueues.

vDPA also allow to change the association between virtqueue group and
address space. So in the case of control virtqueue, userspace
VMM(Qemu) may use a dedicated address space for the control virtqueue
group to isolate the memory mapping.

The vhost/vhost-vDPA is also extend for the userspace to:

- query the number of virtqueue groups and address spaces supported by
  the device
- query the virtqueue group for a specific virtqueue
- assocaite a virtqueue group with an address space
- send ASID based IOTLB commands

This will help userspace VMM(Qemu) to detect whether the control vq
could be supported and isolate memory mappings of control virtqueue
from the others.

To demonstrate the usage, vDPA simulator is extended to support
setting MAC address via a emulated control virtqueue.

Please review.

Changes since v1:

- Rebased the v1 patch series on vhost branch of MST vhost git repo
  git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
- Updates to accommodate vdpa_sim changes from monolithic module in
  kernel used v1 patch series to current modularized class (net, block)
  based approach.
- Added new attributes (ngroups and nas) to "vdpasim_dev_attr" and
  propagated them from vdpa_sim_net to vdpa_sim
- Widened the data-type for "asid" member of vhost_msg_v2 to __u32
  to accommodate PASID
- Fixed the buildbot warnings
- Resolved all checkpatch.pl errors and warnings
- Tested both control and datapath with Xilinx Smartnic SN1000 series
  device using QEMU implementing the Shadow virtqueue and support for
  VQ groups and ASID available at:
  github.com/eugpermar/qemu/releases/tag/vdpa_sw_live_migration.d%2F
  asid_groups-v1.d%2F00

Changes since RFC:

- tweak vhost uAPI documentation
- switch to use device specific IOTLB really in patch 4
- tweak the commit log
- fix that ASID in vhost is claimed to be 32 actually but 16bit
  actually
- fix use after free when using ASID with IOTLB batching requests
- switch to use Stefano's patch for having separated iov
- remove unused "used_as" variable
- fix the iotlb/asid checking in vhost_vdpa_unmap()

Thanks

Gautam Dawar (19):
  vhost: move the backend feature bits to vhost_types.h
  virtio-vdpa: don't set callback if virtio doesn't need it
  vhost-vdpa: passing iotlb to IOMMU mapping helpers
  vhost-vdpa: switch to use vhost-vdpa specific IOTLB
  vdpa: introduce virtqueue groups
  vdpa: multiple address spaces support
  vdpa: introduce config operations for associating ASID to a virtqueue
    group
  vhost_iotlb: split out IOTLB initialization
  vhost: support ASID in IOTLB API
  vhost-vdpa: introduce asid based IOTLB
  vhost-vdpa: introduce uAPI to get the number of virtqueue groups
  vhost-vdpa: introduce uAPI to get the number of address spaces
  vhost-vdpa: uAPI to get virtqueue group id
  vhost-vdpa: introduce uAPI to set group ASID
  vhost-vdpa: support ASID based IOTLB API
  vdpa_sim: advertise VIRTIO_NET_F_MTU
  vdpa_sim: factor out buffer completion logic
  vdpa_sim: filter destination mac address
  vdpasim: control virtqueue support

 drivers/vdpa/ifcvf/ifcvf_main.c      |   8 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |  11 +-
 drivers/vdpa/vdpa.c                  |   5 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 100 ++++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   3 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 169 +++++++++++++----
 drivers/vhost/iotlb.c                |  23 ++-
 drivers/vhost/vdpa.c                 | 272 +++++++++++++++++++++------
 drivers/vhost/vhost.c                |  23 ++-
 drivers/vhost/vhost.h                |   4 +-
 drivers/virtio/virtio_vdpa.c         |   2 +-
 include/linux/vdpa.h                 |  46 ++++-
 include/linux/vhost_iotlb.h          |   2 +
 include/uapi/linux/vhost.h           |  25 ++-
 include/uapi/linux/vhost_types.h     |  11 +-
 15 files changed, 566 insertions(+), 138 deletions(-)

-- 
2.25.0

