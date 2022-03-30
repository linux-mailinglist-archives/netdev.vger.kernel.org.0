Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAAF4ECB44
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349660AbiC3SGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244286AbiC3SGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:06:54 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39573A707;
        Wed, 30 Mar 2022 11:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZwOtYuGVeQ5KonJMh13xH67gYHnqcQbdlK/Rim6Fdg=;
 b=j1ok0AyKble2hIVWMgRm7w5m4Is3NAwH+vVnz9DA3lECrnhCUI/ilU9JO690y4UsaZgEa1sgfp0aIpzP/zedvvyt3MfN3bf34Z45JCMtRd/b7AG8ZxACbfn4jbo1ATKStWts31lJqaI0MjRNrxWz5Y5vaTV9oZIUoAu7BCXDAZ8=
Received: from BN6PR13CA0047.namprd13.prod.outlook.com (2603:10b6:404:13e::33)
 by SA0PR02MB7243.namprd02.prod.outlook.com (2603:10b6:806:e8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:05:06 +0000
Received: from BN1NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::5e) by BN6PR13CA0047.outlook.office365.com
 (2603:10b6:404:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by BN1NAM02FT032.mail.protection.outlook.com (10.13.3.192)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:05 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id D116742CBD;
        Wed, 30 Mar 2022 18:05:04 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTBLRkmRjzqkRWmCGekuCYNeEJsDBlpMWzu4Q/kIjbg8x9o1AVU7onooM/AwIRpcqr0A5+WZoWHni6hsuR9ftHdlcc+C+d66xodvFYyG80qCHNKaWxM756zoc1KqmmCsh67VaD0vRz9Sp21X4+543jRL7WXx5WqX3FXEHOHuXi8jZXF7C1WzUGkvJswmPdCMy5Drz4f/K5FF2j+641Zml1rGNzj0t/hEFrkxH7rhMT3I2AJwg5Hzun95L/WRN2nndYoQ+KhL9zEdQ/lMOeLosA7a/ajjkHbc/+2k8titHaKq0UqKJl1tyGvHz7zGz2Qk8istzm8Hc/dC1m1seP9E/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZwOtYuGVeQ5KonJMh13xH67gYHnqcQbdlK/Rim6Fdg=;
 b=JB9J0r+yJvcPJq4kZUgaBj4xxYZhnzi8mKFmT1m6sR+TC1omzTizr5JPLY5n3nS1YYfr7ZPeTeEfyAZM6wjZUjpZme4Z+EqPfnmB5YUB2phugdOsg5LLz6ezAfg6O8gmn+q1Tr54QiZkdCncPitST8JZTdIH8a/u3Pv49NA6dxRrgylpcHx837pujNIPzF/4dYoiIB1p1QnZwOetQ/rqFp2plvn7ES12cmmGkX1Tnc+NGc8XaoLunA7t1qaLq87aCa0gK0lg8f0Nc4rkcHXJVyNBkaxe7SYBYINqKfl2+eurxgI9CrLCi1bJ2YcbF6TKGAUyF+7+o+43K/tkErnVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN9PR03CA0040.namprd03.prod.outlook.com (2603:10b6:408:fb::15)
 by BYAPR02MB4485.namprd02.prod.outlook.com (2603:10b6:a03:58::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.17; Wed, 30 Mar
 2022 18:05:02 +0000
Received: from BN1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::86) by BN9PR03CA0040.outlook.office365.com
 (2603:10b6:408:fb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:05:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT016.mail.protection.outlook.com (10.13.2.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:05:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:04:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:04:59 -0700
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
        id 1nZcgk-000CCQ-K0; Wed, 30 Mar 2022 11:04:59 -0700
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
Subject: [PATCH v2 00/19] Control VQ support in vDPA
Date:   Wed, 30 Mar 2022 23:33:40 +0530
Message-ID: <20220330180436.24644-1-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 10b13f95-6668-488c-1450-08da1277d1da
X-MS-TrafficTypeDiagnostic: BYAPR02MB4485:EE_|BN1NAM02FT032:EE_|SA0PR02MB7243:EE_
X-Microsoft-Antispam-PRVS: <SA0PR02MB7243A4FD8D4515D1970156FCB11F9@SA0PR02MB7243.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 6nbOOXnxE5XSGKO+5EcBBaVm+HEpXVvRH1PaJ0PHH45PriMSYOTBkF+RQx/qRrK+g56leHI1t+F+okRqkGcXM8+YFsI6tw08hs3AdIFL4+w4XNmFmosK5mkVh0tJf1czPECsJcJIeF4tR3TdMG2OOc/ievl0uOZY/VbIoVa9Y79L2B0p5aY6hP5axZm6ao4Ej8BPh9Tz70uG8qiDwHXgc3DzUJJK3gzpNdUw9AJvUUU5u6y+wh+wbwtffLvCTIbEWyqEI5qrZYRGUb9M+X75hVlpG0m4W5SUdpVwO1V9b07e6opN4eMS7hUKbjhHsV1EDQCOViHEovZuWRnRLCOeFsIya3EOKSoYuxq9i1AO1Wrfgsj5Aj5i7XEkVCrfccv3el7NOtixhV2j2xtNZc4OsKImqLi16+bGVZkw3+65K/mWh2pafp+9//318mbZ9hWdw+sNO1RYsVOdHr/W+8tROsa7S8+5n5vlOEa2VqQhj2EwVVv2vyhVB44o6DgvFIL3G6IJCU0ZIM5SEnzuLXNVSxukW+aywyeybT5HE4Ro+SIiknrFudqks6tUd+4ZMLD99k/wzepMy83OlrP4qX52zGrRPJNHzw2OZtaLDD3QtA7bFPu7d2H3hCwpwRlQn37kdaRGudc96sSZJnXBvzbSRoZwnWVkVc2MpJUXVkToN+MCeyvHjgzU+fJ/KfKwg6C97VVRu2q33QbKn/srvmMGAEbroAqviC1rAFR9UzCBjG0kvYGXCX52kfiJL3MNI6FN+fYuWrmqrALY084vPGtSniNIMCkIOk79Dk2nVIlP2K9WXs7Z6lIkVgTGJ2lFqXShFJB1KL2dpGqejZla4Xmoow==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(8936002)(9786002)(70206006)(4326008)(8676002)(70586007)(26005)(36756003)(336012)(426003)(2906002)(83380400001)(1076003)(2616005)(36860700001)(7696005)(186003)(7416002)(508600001)(44832011)(6666004)(316002)(356005)(82310400004)(5660300002)(84970400001)(7636003)(47076005)(54906003)(110136005)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4485
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN1NAM02FT032.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 28bb2f67-7144-48d7-5952-08da1277cf67
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/wNtB284SMY+FlO5TFYsJJRihO1FXOlyj5vdR6HukUdZeLQJC3P6saelttA5iV1NtDXDdcOjesenGtq6c2tmfK3OcyPTKFapYn/NB28ASBtUAk7wcBVYJbMW0ckvc0qApqZAYr7jEvjNwgwAMBKRl2kXgIvk6+SDot6kh2NuAlpb8NwufVLsh2lHUSYys2HmPxIVR9k7stM+x6YRwMJpXUCnyjn1OAcrf9Zb3iSyo38btHr3RZ+G20L9QnOZfglz2mMC2UD/W5KBqYFVcDoF2eYE7Qu8Nn1R+0fMFi1zIsy177m+UGZ0wmpO08IbuYWxlmR1W80RJ1SSVP3gehTDIZB8FtadUygGx0swDNKzaq2jAXAZCO++2y+Gg2bKZygqr8oMPzFtUTx9inEbFRiDhjXtYrCg4SLMgVqG7UokVzxTFMx8lfe7zZ3aTrLh8HQAq0BPXzjmPnO83cyLBHWqGss+bqQ+D/e6fIYnkCeCqnLpScstjfmXJ7WtobTVjI2SHPZ/FgZjF+66nmxn/aT9GjJgdwo+droV9dYtTXw+elvbazztt0AqgxAtY4+uXuRwPN8WGWg3KvW3w+7TSPYCNf1uwCfJEkTC6KV+IjwRt3laYeYv4HdIptDCXg7Mcb8xYOq1GQJKYZZGRg6/O6raJUpAOGYnDiCGesx2ezrh9ZgPhUD5pGiF720ZKTs8hNZLOmpHTM7xIIB33wEI399A25FCBvi+SomvQ51NpvWiJxXrdpfuDrRu0RUZXFq+BSXZhTLaGdFY8NnQ8o9ViEVPdc2IshHJ8jsIrAzbB51VqN7m6nLzJQ7r4IUq2ClmFIcY5GxqJFr+dOI0syyrobM+6fdcQQQZFICrXUUPnqQjMI=
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70206006)(26005)(36860700001)(186003)(7416002)(54906003)(36756003)(8676002)(4326008)(5660300002)(47076005)(6666004)(426003)(110136005)(1076003)(44832011)(336012)(40460700003)(9786002)(8936002)(84970400001)(82310400004)(7696005)(81166007)(2906002)(316002)(508600001)(83380400001)(2616005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:05:05.5922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b13f95-6668-488c-1450-08da1277d1da
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN1NAM02FT032.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7243
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
  advertise a per virtqueue group.
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

Changes since RFC v2:

- Fixed memory leak for asid 0 in vhost_vdpa_remove_as()
- Removed unnecessary NULL check for iotlb in vhost_vdpa_unmap() and
  changed its return type to void.
- Removed insignificant used_as member field from struct vhost_vdpa.
- Corrected the iommu parameter in call to vringh_set_iotlb() from
  vdpasim_set_group_asid()
- Fixed build errors with vdpa_sim_net
- Updated alibaba, vdpa_user and virtio_pci vdpa parent drivers to
  call updated vDPA APIs and ensured successful build
- Tested control (MAC address configuration) and data-path using
  single virtqueue pair on Xilinx (now AMD) SN1022 SmartNIC device 
  and vdpa_sim_net software device using QEMU release at [1]
- Removed two extra blank lines after set_group_asid() in
  include/linux/vdpa.h

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
  VQ groups and ASID available at [1]

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

[1] Development QEMU release with support for SVQ, VQ groups and ASID:
  github.com/eugpermar/qemu/releases/tag/vdpa_sw_live_migration.d%2F
  asid_groups-v1.d%2F00

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

 drivers/vdpa/alibaba/eni_vdpa.c      |   2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c      |   8 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |  11 +-
 drivers/vdpa/vdpa.c                  |   5 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 100 ++++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   3 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 169 +++++++++++++----
 drivers/vdpa/vdpa_user/vduse_dev.c   |   3 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c    |   2 +-
 drivers/vhost/iotlb.c                |  23 ++-
 drivers/vhost/vdpa.c                 | 267 +++++++++++++++++++++------
 drivers/vhost/vhost.c                |  23 ++-
 drivers/vhost/vhost.h                |   4 +-
 drivers/virtio/virtio_vdpa.c         |   2 +-
 include/linux/vdpa.h                 |  44 ++++-
 include/linux/vhost_iotlb.h          |   2 +
 include/uapi/linux/vhost.h           |  26 ++-
 include/uapi/linux/vhost_types.h     |  11 +-
 18 files changed, 563 insertions(+), 142 deletions(-)

-- 
2.30.1

