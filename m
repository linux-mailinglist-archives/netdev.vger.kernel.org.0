Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78D54F413B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354233AbiDEUDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457613AbiDEQSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:18:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D9193D3;
        Tue,  5 Apr 2022 09:16:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5vFLQeWCPDLZaphTX68k7+w2FWGuRcly5nNE3fl459R7ByHQAn2g4xgirJA9V+2IP7Ss8UMSXSdECQ9hS/9xtXDKBxXPsa4Sn2UGIEagzl8ZVtY1i9BOe7cZWnMtp/m74W8KG9vt5w1bR/OL9jcpOoPR0O4RFwyQPNDB7HER4juX1eIL5awq5dRTZGe8dlbx5bt/KGeVT8Yx0elg2na7Q3I7ZOmhYWMY2ok5GUggAAtiVHeIpiCJ97afxgr0Yyzg+wZkf6An+L9WZLuyfNxR8Ly0TfEp14LT9YIOQgy8DduA/shFxawzgRceSorA6J+LruvevTDmCzWZ+XEujY6ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYZhLuKsv21uOIiI2RWBbXWyksWwON+fpEvEMAl+B7E=;
 b=m2a+fCU0q6gUy25CzTu6/Ukh/AYWPi4A8fX+7BRBR29x1T3l9CD0Pg988hMwNODjuC0DvcM0xvw6FYyDgnW4llGaAnrFE9c1N/1Fq60srWxY6M8hpAtObodeLNQNuRqmAX3XYhNJeC0hJy9MHU8Bbb1m9RVcATK076Qpp0hyIFWsZ2IsYZi5l5+GXlsHirlHoWjuJGW5RnL1gBN/soBzAZ7kl/PtX0bDup35V4tNnwfpjPLwHbZXM3GC3w7cBaVd1FwFD+i2V+LBobOqqAh27QTM65q9w83qrfbYz4MT8F7CgYG+/wmqN4Fqo9R/VEpfwnp4f63yEGObU/VkYYeFGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYZhLuKsv21uOIiI2RWBbXWyksWwON+fpEvEMAl+B7E=;
 b=tjACv2ggBZFnFg6xE5GiSeSGFl8p+La9h8kgVLjn85MlW+/yasqQ4tgqG8Y2wj8SvrwvVRYgn+UYXuXBPlHeCTcwSc4VQL3zDa5QYHPRXl3faLh92uGwPuZ/8JsfPXnruNSQ1UTHaq4OvzG44+0iKCA+7xbyh+jPo1mGa/NNg6ZMFvLmdAeR1v90bUh0Nul2P4AUd5Zo407KERuMhjd8Mfnf+fNa4QzuBBBiK4NSDYynLBjsNUO5ZxPPTn6o8BxxsrvNoxryMj3k0jOZ9Dm8Uui/L90n0g9g4MNPB96cptnNaROipx83YaATH+KhU84XHI6Ks40UQ82MkYnjTRgWCA==
Received: from BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17)
 by BN6PR12MB1363.namprd12.prod.outlook.com (2603:10b6:404:1f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:06 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 16:16:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: [PATCH 0/5] Make the iommu driver no-snoop block feature consistent
Date:   Tue,  5 Apr 2022 13:15:59 -0300
Message-Id: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0310.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84cf4138-ea12-44ad-8335-08da171f95c7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1153:EE_|BN6PR12MB1363:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB11539ECDAAD27D4BC8665AE2C2E49@BN6PR12MB1153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: or1dTHaHW64TiENqmTfAtr6nlAxbL5aM0W04pOOpXkN2hNPJIbOoKUPND4N73qjyEqU7KhmQioeOfUuxFbvy7mSRtDvI/QYvO+kZvboPj9OxI95RaphSHDqz/qA/XFvSm4m6kM0wohJRfdO34X1CpuddACekObp1MPC4i4p/NFkDtWEDwHczbKbe1J82v3Zz4iHZ29XKhK7VQZ/GpYBFo/8N2/oBBEK6uuAfos1Ls3KXV8XnTiTNLoR9QOInt3m11pW6ULs2J8WjLwZmqL9n7fiA30au5PMUkJS/rt4M6/uWqsts99wMN52rjoXFmskgvaq2PdCue9ho02GQo9WP8N23NzTHGLC0d150pOAALDnc9eqmPflaj297ls2EINMXB4w99PrrGsW4Ql5T3GniJJ9NEVboZDXDfoYE/oklZngwhu9JyM5azFxlX3aKmrwUc90SziCoCAjl6z8ExKILyjXrdAi9Tl2A5w8+qI1JrQhhGwosxQT9KsrvgB+QjLFWFidGx/pIbR2W31HRnaqvNjUW+ZFyMOVhggNLcmXR3v9BrnBjjEI+44WraD9auLdmeQvhcysHmC8dvBZkqsxzxy54KGYB3oLUeKX6nsjHVLT9YcPg+ZBhbK3/1sh4rGaz1JMprPXN0kCQ3jxKOKDNyx8e+64GsnxAVtJmL3Oq0Itde6SUaDnrLA8kYqByVZyRoSVPl0ATNSc8jL5bAB3zvDsrKVi8bVCrNR0V7/1ldnzosIX4Rq5eIp3pH3vhOR4nYnmevWGDDZoyLqAzwZ/eWTyBH54Lm3qvDDHEnXlbu30=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1153.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(6506007)(2616005)(66946007)(110136005)(316002)(26005)(66556008)(66476007)(966005)(86362001)(186003)(54906003)(8676002)(36756003)(83380400001)(2906002)(6486002)(4326008)(921005)(5660300002)(8936002)(508600001)(38100700002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6IYsW4BXkK32AaEFuBZsxepIiHZ120BX7bxOhTRduvlwTg3u79jCE9t9rOk?=
 =?us-ascii?Q?RChsVIPbzEQJEd9sx8vg2MLsWD0OHQHadDbeqCTnuqdkGBtC/qK3Gp30OmGd?=
 =?us-ascii?Q?7c90SQLjHoaY4DV//flt2XeTk7TtaJF7eKjd+ROeb/hFj2uHsdYkjEhq2tqb?=
 =?us-ascii?Q?9LnMI6VswFZ7v+P2PLAd8gCO5YfIqK3t7eE4Ox2DQenWTlrVu+IfpvKI3NF+?=
 =?us-ascii?Q?C8Ytp+5M7iyBZaeWNTx9wP8SH7o9RLd3m9DewaTZzfrqnramVCHSt49eD+IW?=
 =?us-ascii?Q?qmaDH55RFb2blAiWY/Lwrsb65VTrb0iEftLHTGjTN5KZDaVbYwn+IWogcYc8?=
 =?us-ascii?Q?Bvi3hHnj3/aYPW1pCXGGs+Fe+MXz9aodxnJ0Oh49ZE+1ycEOCOCqLNgd02Hk?=
 =?us-ascii?Q?2pnSZUlVhPPal1EfmUq3fibVkIWWpuAMTWAHFPO0ldygYAvKTDEVTGnw07I+?=
 =?us-ascii?Q?vS7kcN1Y4vxsrKybQbsFcQdFJi/ZHSqYGzFt9MoWb2QTrLDCBi+A/fWk7FXy?=
 =?us-ascii?Q?deO9JSvLLdXHfPjw4TaUCoP/A8gz0lBmGAkT2fgkYbeAz4yJeuFyaYwEW0Df?=
 =?us-ascii?Q?RzFRzxzqV2d+Ri1EG2wC8Pu8PsiakL8CdtYHjt695wEf6Ew0GzbYSjDAbT9o?=
 =?us-ascii?Q?ajs+EpmvVobq+NcCiFl+33iDXSnj4AwHz6UbGtsNE66fIetD+oWV3YVGpMYI?=
 =?us-ascii?Q?FL0efjmI169v5q3K4Cg94i9p+8NupS2B/p3Q14k/I2NTi4SPzkM0+rJwryBM?=
 =?us-ascii?Q?osYQ29GEgcBi+hnn+59pOCIQRrisC3xwjfdX3xCoj/n/v1YdKYH03b1/siC6?=
 =?us-ascii?Q?wuRWtIfBThOXF8rJuhEauTrd/9xFqq9EQGQp0xDbgTIXT7QMSaKqZmrf4wLe?=
 =?us-ascii?Q?frMZRnNjkhDWnaSmDn5UFre7oDWFZGpHUgGK8MCcUDlblEaTPPm+8uiM2TnL?=
 =?us-ascii?Q?Dzi7VWBylvym9j5ZnJUdVLMtZsWBwDDXVmmwTGHCbKP54xIZs97MfiP//+W7?=
 =?us-ascii?Q?6wsrE1afAZ6REsK/ssHzhI7q5lPZxCC8Htc6NEF0vqFV6tU1Qcqlr/vI54gA?=
 =?us-ascii?Q?2znxGHbjUluQFjHD+fkvai0zfT505YalfhD9B8kFqKdYA4YoRy0sVhEDXha/?=
 =?us-ascii?Q?pFEvHJ5xXFFDtZhri6uPtiR1/Uxv0Jc+Y3Q7DqlIBMFZiN84buqC7llcK13x?=
 =?us-ascii?Q?MtfJ0cEKxVjjFgiMNoCYVPb6msltZ0+2E49XG/xw4skjJJjdo+PMuv89DM0r?=
 =?us-ascii?Q?A5hobxS1pQHiDaxC0+k3GfUUCK+7RZm6ZOF/sqZYab6uBGn9vCYzFP2l5OsD?=
 =?us-ascii?Q?UwZrT/OmC35rlyf2BbMP8XE2biB2JdtEGCcsjtph0nlkoSTKr83oJzptDjXP?=
 =?us-ascii?Q?f8WzIKBfWLvRr9YOt3WDmBcq8zl2SCtHf9HxX2uzO5NOxRVtmIFprsruXDu0?=
 =?us-ascii?Q?OIKQ3F8cHW3fxwUXfwBWLzDcUKOeHOcDB6DJaCu3L+zFYf0qK/4jm3nfh71a?=
 =?us-ascii?Q?93MRUG3vVB/YVIahQWs5P4HeAOdPQa5oQXtQkEpKuqWJFTBzkuG6uaY2geYz?=
 =?us-ascii?Q?0/rxZEiLt04VkM4DhzGIHuIGDt05SG4zrLQaRtX8yIaHfh+jd3/eRTR84Udl?=
 =?us-ascii?Q?HAMmAKGdPiixrgw9/NF5mXX2tHADyJun4k8zCIErPnqv8XoQud6XW/SpmDRX?=
 =?us-ascii?Q?+bXWMQmYB9MAAc7mBxicue5rwftAV3V6PHN1gfukp6cqliT3rEVVq/O5ha96?=
 =?us-ascii?Q?ve+z6lBiPw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cf4138-ea12-44ad-8335-08da171f95c7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 16:16:05.7381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SU+AlptkcxEgXuWR0q7VTrZsre3m2Q16m2XXNgeDiVVG+aQV8h0Mnx6SM3ikRLTJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1363
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCIe defines a 'no-snoop' bit in each the TLP which is usually implemented
by a platform as bypassing elements in the DMA coherent CPU cache
hierarchy. A driver can command a device to set this bit on some of its
transactions as a micro-optimization.

However, the driver is now responsible to synchronize the CPU cache with
the DMA that bypassed it. On x86 this is done through the wbinvd
instruction, and the i915 GPU driver is the only Linux DMA driver that
calls it.

The problem comes that KVM on x86 will normally disable the wbinvd
instruction in the guest and render it a NOP. As the driver running in the
guest is not aware the wbinvd doesn't work it may still cause the device
to set the no-snoop bit and the platform will bypass the CPU cache.
Without a working wbinvd there is no way to re-synchronize the CPU cache
and the driver in the VM has data corruption.

Thus, we see a general direction on x86 that the IOMMU HW is able to block
the no-snoop bit in the TLP. This NOP's the optimization and allows KVM to
to NOP the wbinvd without causing any data corruption.

This control for Intel IOMMU was exposed by using IOMMU_CACHE and
IOMMU_CAP_CACHE_COHERENCY, however these two values now have multiple
meanings and usages beyond blocking no-snoop and the whole thing has
become confused.

Change it so that:
 - IOMMU_CACHE is only about the DMA coherence of normal DMAs from a
   device. It is used by the DMA API and set when the DMA API will not be
   doing manual cache coherency operations.

 - dev_is_dma_coherent() indicates if IOMMU_CACHE can be used with the
   device

 - The new optional domain op enforce_cache_coherency() will cause the
   entire domain to block no-snoop requests - ie there is no way for any
   device attached to the domain to opt out of the IOMMU_CACHE behavior.

An iommu driver should implement enforce_cache_coherency() so that by
default domains allow the no-snoop optimization. This leaves it available
to kernel drivers like i915. VFIO will call enforce_cache_coherency()
before establishing any mappings and the domain should then permanently
block no-snoop.

If enforce_cache_coherency() fails VFIO will communicate back through to
KVM into the arch code via kvm_arch_register_noncoherent_dma()
(only implemented by x86) which triggers a working wbinvd to be made
available to the VM.

While other arches are certainly welcome to implement
enforce_cache_coherency(), it is not clear there is any benefit in doing
so.

After this series there are only two calls left to iommu_capable() with a
bus argument which should help Robin's work here.

This is on github: https://github.com/jgunthorpe/linux/commits/intel_no_snoop

Cc: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
    dev_is_dma_coherent()
  vfio: Require that devices support DMA cache coherence
  iommu: Introduce the domain op enforce_cache_coherency()
  vfio: Move the Intel no-snoop control off of IOMMU_CACHE
  iommu: Delete IOMMU_CAP_CACHE_COHERENCY

 drivers/infiniband/hw/usnic/usnic_uiom.c    | 16 +++++------
 drivers/iommu/amd/iommu.c                   |  9 +++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  2 --
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  6 -----
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  6 -----
 drivers/iommu/fsl_pamu_domain.c             |  6 -----
 drivers/iommu/intel/iommu.c                 | 15 ++++++++---
 drivers/iommu/s390-iommu.c                  |  2 --
 drivers/vfio/vfio.c                         |  6 +++++
 drivers/vfio/vfio_iommu_type1.c             | 30 +++++++++++++--------
 drivers/vhost/vdpa.c                        |  3 ++-
 include/linux/intel-iommu.h                 |  1 +
 include/linux/iommu.h                       |  6 +++--
 13 files changed, 58 insertions(+), 50 deletions(-)


base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1

