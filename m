Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E854F3F1B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355290AbiDEUDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457614AbiDEQSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:18:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB0F19C0F;
        Tue,  5 Apr 2022 09:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsCTqs7ykz0watoQ3SY22XztsNHxuJ8AmJOYsb1ScVzYof3wk1kGPcmJpvcDioeQcl5jplyrnR5m7uhLJ+9UG78i0XSdB88sDnvY3XlUyWF+5db7FvFUm4QsSPSyyVFhUXiDfzhXj7mJBDYMFQSJrMW6CiNiLyK4kjxOWVe8yQRW2/J/qwbBgO5NJo+EkMlViMC7vkxfF7vK6WslzSe8neicsaDKme5VbL5LWjQwzgDStl6pw4v3sOkCZ+22CQ3n+kODZWuAp2tdkf4H3l7bl9OciJsVvdUDuiKck3N2QkZW5Z6ICq8P1cSkeCq2cuOXSP/7fG/wXYQUg6KlWEhPmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAumyHDaWD4y90uzXhrxzalObVscbCsbSjk2yt67+Uc=;
 b=DxdsSyy2tFUJx0YmoDJEWnMAXAcaim2LoSkpTzn+KiRjcMSJTebvA4Aw9U8NeADNinr4jDhl59HrmDJZB945rL/Vp1vC/4/r8iu67vaB8PnFpOobtYeHP4wYQ7ywA8K1FLZKjiXB54Z4JI3MMf7L0Ztm7xv9Cj982KQsknQCT9TmrbloK3RwDNx94k6aIK9szUTGYcXHbZyStEfNV5I8Rkq7O6GGMde+uZQX152t0/g9yETgQqFxFIf2TWWdu4fm9qf/EncMBcpLvGAdKmIpe2eY/8IgQoFzhGmRs30LKMv+1jvsxWtU4spmDCVLAKug8+S3QcZ+tIk+hQgOvPQLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAumyHDaWD4y90uzXhrxzalObVscbCsbSjk2yt67+Uc=;
 b=HfgB5RLnwwiW0QXbDBsndDpagJyftXQNL3r2/x6vQVawMkOIrVk28kI7HA/kjboeykmh5enFXhuFVlNdLVlr9hoy3X3ZzhGyTHTzo8ftz9YiBv+BQgnroK82JDh77Z6uguGKdFqA7rWma1LLE8EIL2sXZLXZ1TTNLP37D2+mrFpdc+jXWwlDP4y9MXixWsXm3sjTSI1IVcmvkMJdBsd581tAopWx+997dubiBI0oMZVIrM91UzPxL87piT1rDTB+mfgtsgf/LIXafZh6R178YaQhftVtwN0RhyjsK3N6x6EsghBH37M4G9GqEhw07I8Z/mCd9AxUHOzV0HD3dqsJbQ==
Received: from BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1153.namprd12.prod.outlook.com (2603:10b6:404:19::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 16:16:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 16:16:06 +0000
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
Subject: [PATCH 2/5] vfio: Require that devices support DMA cache coherence
Date:   Tue,  5 Apr 2022 13:16:01 -0300
Message-Id: <2-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0132.namprd03.prod.outlook.com
 (2603:10b6:208:32e::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d9c9f2-6da3-4d58-f19b-08da171f961a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1153:EE_|DM6PR12MB4299:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1153DBA716BDBE3BDC2BDBE6C2E49@BN6PR12MB1153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FjwQmjlOmfHCsEM4bLx9JOuZ58gvnWJE4vQiqz1hVqOLAd/inUXi1+L/o97OkajDdSuxwuFHKSucD7F83TamEsuBj0ZeCIJ52VmRRUC/8iNd3s16jLTgBSYPudq6u7+ysm2p92Ta1UrN+DkT004wWHJ7+yYxYocMYWxI201JtdL0NUmQ1B9lwOshvLYhXgkdmbU4Gj3UX2nUojgVeeBzUeU8vPNoR/x5REbzb11Kcu5TdTHn1X2ehKt9esVWZuOEUx5o4woKGTfK0dO9LZQx/YjimD+3N3J8RBAU+1qO578V/5/qULx5xgIlqWEo3ZS+UPRrG6xM7hEJCIo2xceXf0GIDgpTojwG2JP6cuDJlkHgP46ynyB5xbQnefQukIa8inTNyV7IO+vxnLje6Tw6I5bnJSKmizMgTKzVEHn1Xk1FB23Q5yjcl8XTI1UnVy5Rif1XBTMhEh2PfYso86NJNXIsCDeaEXZ3+OOrSOSKUR5TuJKyEiUPe+A0Opc5InphWLt7D5M7VbQJnnzTog2sx7TEDRX1lBvlLB+OvQLaZSe28Fj2pIqz3So+hxLzow/GK1JSoopMCWa0No7Gz72IuJaT7i8CqE1KK7/B3KPzEfXLV768xlMjxDcfDHB0duqb8Z3BqL+d3DNkF43EantczHSVVQ4jojarr6Q15jr1DoHs4km6MwQwH/r6BXiNEpsrr70ckOUoi16F8PaliNHKDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1153.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(83380400001)(316002)(4326008)(6506007)(8676002)(6486002)(38100700002)(66946007)(186003)(54906003)(508600001)(6666004)(110136005)(66556008)(66476007)(26005)(2906002)(921005)(5660300002)(2616005)(6512007)(36756003)(8936002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?08VJmu319hGyDiqOLsMxzAiQdwQyUlrB9i/dRXjY4upczr2I8wMpI7mM2TcT?=
 =?us-ascii?Q?bcGCvxoSjIIgrKN9odU1h4UZbuQY2e7NZguhmDzMk/fkFGoUQ91HOHbFEgh+?=
 =?us-ascii?Q?CtXzckjF5TwreUE4ugz+euXCJzBySAsCaHfdNQjVhuarY2xNmuL9pwvX0mVt?=
 =?us-ascii?Q?O/psTSsmLwfHEPba1ZI03ol6YMe+NwX8SHC7Nxzo8TGpnI2q4H3+LvZjK7ls?=
 =?us-ascii?Q?QOE06+7zCfGULzTFwRVXdLGe8tr9R4I6cjf3npSV91pqiKehXW3scNSl5NO+?=
 =?us-ascii?Q?eiZbUanESBpfQfZHM9cY6Mb0GIIiddt59bJRtuk6ufM8sn468g9AgdzJORmi?=
 =?us-ascii?Q?GL25AkM2fQqTlefoy2mU0FFBS4xygx0r2UTQGiTcufuMCcZ2RQDroHtqaOiD?=
 =?us-ascii?Q?o5gD8bmCznImq+kR3quNedVS1LW3XqheAG0GBY+wLHGZDHA4JTunXks7HfmW?=
 =?us-ascii?Q?CB6exDfcYKC9SOxkfl5jZVcr4OEhR1TKbImoH/so+xAxRkU0dSMBIJKyfOuZ?=
 =?us-ascii?Q?KDTPcCU6vpdYw0e9EmLakIYX6IhZAwEE5nzyWsSTnWFJt2eWTknIqvxj3Ur5?=
 =?us-ascii?Q?Z/KtvHac3UVzrlWId7UE+EM+Vt/UkLVZZJgQRAsyW730lRNLvd50vhvjhLDz?=
 =?us-ascii?Q?ltIBkHrX99hZBDA78KakgoqPlD9Mo6yv3kJNFIo4G6DcAfUPgLCj4oeDEu30?=
 =?us-ascii?Q?Ouzf6CyojFO7xrFUs1glcn5VOc7cHQpX7t4n59PEZHwLIE2hCMSFrKJHqc67?=
 =?us-ascii?Q?vsd+FOpbZS4ua5Z0agagcG60ERjmaFTQUw3dpHyzcMlPownnwineBpMZ9hbB?=
 =?us-ascii?Q?a5vfuGou6aTkvsUH+UgCpustNawATUYGQ/qobYCCMt5XTrMtxlQixbZjmRzI?=
 =?us-ascii?Q?2dZCCgryC2mNenZJEDF2yUlGazv9nxm7YCAJF690WQKJzPgufVikMWNibQ8V?=
 =?us-ascii?Q?KnLp+thIGKYwNl4u+4h/RmiySn6qvpMHxtg5ZaScKcWc/vxLTISYwwdHxoT7?=
 =?us-ascii?Q?M+RJQc/R4FZAytM5nzbrIBAbmIsTEUD5D7HFw+apg9zzQLHfphfLAoPjzQOz?=
 =?us-ascii?Q?kjpq4bbC6usZxqI9C1xFBlNmLgaHaChNDuoQqCvJDzzX6SOZqr0IV1Nn4ssb?=
 =?us-ascii?Q?2CbEWA5AqWlxBtyBEh3YDY4D3tGs9uaFGE3utZ8mVdnjBXYfSm5ze2xP0S4h?=
 =?us-ascii?Q?xzkOeljIaM8EF0jYKsd91noGht7aWzphgLxCGftV+aM6IWbTAyptJ5jEIOnJ?=
 =?us-ascii?Q?SVWviTHgj2JGLJmt2lAj3InVdZhlnOoZTfU0NrAMRlXBlG725bdKCLquaybT?=
 =?us-ascii?Q?hSkqHSrAB7YLPnGM0e/gtqZ4cUt5KxIqzz5gGMA2sQWeixN6xo3i/b1Rxsy2?=
 =?us-ascii?Q?TKj6W+DVbMVrqvTkVtHKZMc7C7EnDeidXdmvchLeOzO6U9weNa2Bgv/Xn1Ge?=
 =?us-ascii?Q?lpdu+K7qUGGx52938zx4uxpq1xtRMlDkiWPUC0HB4z09PGvdyUMKoYSadfaD?=
 =?us-ascii?Q?aWiXTXdOoXFIXHymYcGW3IIeKYClavvPPBkb6RIs2i9IE9eX1EhlnP7SnVso?=
 =?us-ascii?Q?5NbgeFmhNgMLWI7qJ1gm03pcB8OiowWA64Eku/TQ5zD1M2MSfqQpPoCMN/jh?=
 =?us-ascii?Q?uHErBIQftsKtHFTM+wtXBnH3tdLXj0f6BeTQN0XKL2LuCKjr7wbJyijRLW1q?=
 =?us-ascii?Q?3lfP9W8FB2QKrEMzQ3osPLGeBtBiae2hq23ouZGxFlH9kz7XRJHwFFbs0VIu?=
 =?us-ascii?Q?vAzADF1cuA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d9c9f2-6da3-4d58-f19b-08da171f961a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 16:16:06.0037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rddkv4Z2JH8AOMnvNH5drmyDeecvvoIMqRchnNMRWub/IZvyy0eso1eUnxmEhhBm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_is_dma_coherent() is the control to determine if IOMMU_CACHE can be
supported.

IOMMU_CACHE means that normal DMAs do not require any additional coherency
mechanism and is the basic uAPI that VFIO exposes to userspace. For
instance VFIO applications like DPDK will not work if additional coherency
operations are required.

Therefore check dev_is_dma_coherent() before allowing a device to join a
domain. This will block device/platform/iommu combinations from using VFIO
that do not support cache coherent DMA.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e72..2a3aa3e742d943 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -32,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/dma-map-ops.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1348,6 +1349,11 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	if (group->type == VFIO_IOMMU && !dev_is_dma_coherent(device->dev)) {
+		ret = -ENODEV;
+		goto err_device_put;
+	}
+
 	if (!try_module_get(device->dev->driver->owner)) {
 		ret = -ENODEV;
 		goto err_device_put;
-- 
2.35.1

