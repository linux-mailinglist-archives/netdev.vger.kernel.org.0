Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F174F3FC1
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351831AbiDEUCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573650AbiDETbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:31:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE6C245BD;
        Tue,  5 Apr 2022 12:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfaIhWcwnPq/4JTJPsSub5k4g8JRdBV2vLxi7wwHyEmVrPhAdKj10enU4mc8HKvArAVUNT9u4Q5fxKyXtpbIN6MRKmQRTJVYMbNT0e5uWij3n+gB/YszLufMSiPUn93EJds7JNfvBaK5WYvMNTn2ATF7mBRGPSm1dyphA1y6aTAUl7wU3oIj2xnqd7Kb6e+3Hx0GKu1s4EiGx5s8KSjK6mLHdknwQ77VxLneXSYZHJAZ7LK9ch7mAF1OHy7Fs1gZ8wSkzxnNYFM023psfzQ2Yqc/jZVlFn5rhx/bWiIrhGtiVWBKDHjuRfKByUGSEou+i6zjiNI4CYMLVsDoSmtuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg6cJbFDDHBVDK6LJ29Lrd9XaBMpMXJJByseVnaz2fA=;
 b=XBAjDL2Avy+ctecu+GZfotGwApk/2OZrp6e0MddoBYQQ3tsnHpDbBgK5iZC7QKYJGbY/Ww++lfImrNTdIqdjMBaDD+/2R3L6pRZgvbIPsGyWuo5VCgyvqXNQcr/8iLQ1AWvBc8k11Ajrc6kcD9Tz9jqdzTJ26qxKqQKC52DK/rLNy9X+f2LcumQUp/iSR2aWbOs7rag6SLxppqZo9FgLvfcCauWuU6/9H/L66LlR4gtkJfUzyX12aHflCcI5kzRFtzCH2z1cTWpioYRUgp2XkUzLIeWsmKltr6RERJLnDW7T7taFR6uro24iS1wid2+WYlUd1R19zc2Hhs++gdCdVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg6cJbFDDHBVDK6LJ29Lrd9XaBMpMXJJByseVnaz2fA=;
 b=eDv0gLdYTQoJUb4lP+EnKya2cRgdxHCYiZj537g/9wWkRmaGGfVGzOW/l1h5N40/wP3VVE9wI3KRR6u37j4AD1M1Gcg/pEhsmrqhrvgEgHq3iu8wTwlskl53CwgtMlrdpcLXvcqDzMIftB2PYZBZhPXkaFFozwbedOCOvP0JGDsoGBSZI+cio66caUOzCagKYTPq8MO0nJuom85uv2Qy1Sif9BmK8nW2s2WkzOkdPjmCB5mPR6Bga0sSPXrrz0SJBqPuQaxlIzk3IoQC9gW9f8iowYY0S3UJblylrY3szJlT7gruFw6nZ7mBYXysWIgtKf/0YI4ndeVbbQHmam8uPg==
Received: from BYAPR12MB2597.namprd12.prod.outlook.com (2603:10b6:a03:6e::20)
 by DM6PR12MB2892.namprd12.prod.outlook.com (2603:10b6:5:182::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:29:19 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2597.namprd12.prod.outlook.com (2603:10b6:a03:6e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 19:29:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 19:29:18 +0000
Date:   Tue, 5 Apr 2022 16:29:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 2/5] vfio: Require that devices support DMA cache
 coherence
Message-ID: <20220405192916.GT2120790@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <2-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405131044.23910b77.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405131044.23910b77.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de0d5aed-0eb0-4cc9-893f-08da173a9383
X-MS-TrafficTypeDiagnostic: BYAPR12MB2597:EE_|DM6PR12MB2892:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2597C9C0C76536D375BF2144C2E49@BYAPR12MB2597.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PlsJsXkHgHvdVpKujO/POeGTX1NhUxxRszuSP/9yDSZz68FPTXqvQplKDYaqL24UHIkt97dCIM3dKSVfwZKenhazwz6PvPP7ikjvUqZJo3ry/LzsAgHYQyIlNLFWs/j51YZ0J4dTPr+y02psBSBfkNK+4KvGzmtItc6d0FzwaAG8TK2251i8VfWSIzIG8Th6DCpHljkSquOc6STxt2YXqKhw/4iGWvYPWGz/yGyk1LX4l+yq4Gmebplv8So/cNMyhXZ3iE82DGvBsC+EueyabfRQyaxlfPihcE8wggg2SOuSD8q/IhQQGnKq5Pk0abMadGtgqlKLi8sgU0qRerrpuEf6OWbB2899ejuHMxSGY6E640Dd/B/gcvOe3EM4hysFCWP97Q5xoPGSMDQvM+eNZvMbNrwXdVqoYm9rkNzp61RapbgpOaD4uMS3Ynt6z2A/OallIOZa0He8bjvzMILIySLXiRETYr1Ne9YGboJF5NgAuKeOzOtDa9XlzDY6zrrxLD6Pvayh7h/BF/jpObzNOrtZjEP43TtbWYUzvHjXZmgEXRIZElFhBUQuv16BBMf48bUXFNDU1QTbOS533U2w9VewVn+e6viqv7GMEyZg2dRFLEMvnqDBqO7rg2z91ZiPdSOZVdEe0U2DVZb4mEZlOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2597.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(186003)(5660300002)(83380400001)(26005)(4326008)(8676002)(1076003)(66476007)(66556008)(7416002)(8936002)(66946007)(2906002)(316002)(33656002)(2616005)(86362001)(6916009)(54906003)(6512007)(6486002)(508600001)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RxFrqoJlLcTB/DuvQ1jtN3YwbrnDVaRrrkjn2bjwzQcR+OIQ13Mm5MD3ac4c?=
 =?us-ascii?Q?ol1IuO1O99VmX0aGmBBgimYtgLHDSc99bvA0+acB1GHwctE0Xpu7YpA9Ibjf?=
 =?us-ascii?Q?ivGCmtV7ol3lj//PIZBavtKkqFR209M7ibtD9OaKVfHMYoDci8+6jmd8obou?=
 =?us-ascii?Q?DmupuFPyUNbFB1ZxIWynuLvhbyDoG7zOrS2/WxaEf3W+E5hj369dgN2+E3Ve?=
 =?us-ascii?Q?/O5UMwo0L+9zRnyRA1dMY+e3mZxIXNq5BMRe5gNB0r2NEz70w/kEdb5Pi0EZ?=
 =?us-ascii?Q?awV4AYJDUJPOQlYi9apdMZH24ZuwSC0PY4E4m9zy2UkieC+3fYqQaXhf4UxX?=
 =?us-ascii?Q?c1czOc1KUlsaZvpPdRc4TJ2tD7DcD5iUqDVIb2YdPxrWGrNGnCC9Lpu1Tf5N?=
 =?us-ascii?Q?o3ve2sSq8Y+8tmErJhYUReFPePEcx1+OViWGSYbj9uQGM3Cef3Bsw5u20nwL?=
 =?us-ascii?Q?UwWuJ7nKQSQP3OkRtlY4iljVV7XLy4N8O1pMR2+vi4M8xzkMfzlkR8rw6X18?=
 =?us-ascii?Q?yo+d3ndQy+9IIDWopaAwcOK9FK+4IT/A2NFd1HYe2mgY3ifOy1SxCsjFXS/5?=
 =?us-ascii?Q?G5N4nk7iJ9vR1YIFlDq/vIeE/TQZo7TLNcrkq0RaMFKhg2MQAnk9ZBN7llfm?=
 =?us-ascii?Q?m2crwEQJhIy8qC2IECwdmlryzj0HFz3yLOJbbWF4osGzt85q+/Qp59VsCbwf?=
 =?us-ascii?Q?1Ld8b0GXNMfp8ITKCwQ8m6rwb99+hKftA4a0x0/HRXqLu0NL1aPyR1WpGZjn?=
 =?us-ascii?Q?6LnvByMllMVwjt79OFnAHmc7mZBkLvObuD0Oc4V4zQkc4S7dEDwSk49fQIDJ?=
 =?us-ascii?Q?Q2nTLVUm4x04xSvqviIM8w9hD8PWR4iWI7fdu+Zlsy6nMbKYEm95hrT8dVLC?=
 =?us-ascii?Q?DCROT45Uk9ug+7mya8whtLfeeS39tMNbwxLfmf0DSNbZvkm10+NbJYSNQ8Yt?=
 =?us-ascii?Q?o2npyDL2mVPCy2iLUQIJ2wUEaz1dzBvLfIcuaj0Y8pRTVu44rsKx3rIXsqpO?=
 =?us-ascii?Q?tCV5ilIPrA5DeIJJtQd+Vrfmrxayfr4Z3JtXZjUAM5rTgUOejQMrlrq/bNwC?=
 =?us-ascii?Q?pu2D9ETCVlv7CkiGUCYZq19Tse4jQWBWZvCMIC5DFLCQyAIWWsxcBDlw734+?=
 =?us-ascii?Q?PhvblmZwwBqI1WZVPQ2Ax2deCYZBF6GHnhMOhXXDjfNQpJBydPwNDqvcOnTh?=
 =?us-ascii?Q?taIQACDy4a5BUdNphewOKc2cRTn5F4/EFgHKvbhUAKYi5tVOnMdfMLHpwE4b?=
 =?us-ascii?Q?UlCL7bGYYnB0sOPnrai+1Fwr0LON5LMTlGDnK0Spw5aLIgqkmVTSExcwTPpa?=
 =?us-ascii?Q?1zuNJPB3D6ZRSXrRVOWzrkrRZSOb/RTAOq1J/Sm7zde7fkA3t8uTjNtzyG37?=
 =?us-ascii?Q?Ocg3Saeo7gdCoPcryRKLcHhMZj0g0UpX4oIOWUjSouX0Sgvbx9OAv2PLnJ3k?=
 =?us-ascii?Q?uUfwiRMz3tTrRwbT7ixQy0zNq8OZY9BaxI+s45anWXTBIpDDmiJajsp1UtXz?=
 =?us-ascii?Q?xDYtgDYw5IGpK4F2sHkFcKpQlSod+JfBV1JdEe+faLet3zSOByGd4A2XdlbG?=
 =?us-ascii?Q?72E+rg1b2gq6VmJeXmGR3hc3btZPc6c5L9ozJExmzfaH2DYEtQOW/RnosCsd?=
 =?us-ascii?Q?cSmCtkEXwjk/A1AtMigOVNhelmmPBBS6IPmZT1X8A6u2MlvQn3E1tT5Ncaaz?=
 =?us-ascii?Q?UILf+xAcZ1UBBV3KiBBj1dnCBl+D936JKQh2oUU+tK9ImOXBEiKzWZcaTOAH?=
 =?us-ascii?Q?pXAjM+i5YQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de0d5aed-0eb0-4cc9-893f-08da173a9383
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 19:29:17.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYE63IqYgr6FSrTCutXdc+jcwEo4vL90Ko0ZJFI6MJTaBKi0lq5nNjMnTW/gTtl6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2892
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 01:10:44PM -0600, Alex Williamson wrote:
> On Tue,  5 Apr 2022 13:16:01 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > dev_is_dma_coherent() is the control to determine if IOMMU_CACHE can be
> > supported.
> > 
> > IOMMU_CACHE means that normal DMAs do not require any additional coherency
> > mechanism and is the basic uAPI that VFIO exposes to userspace. For
> > instance VFIO applications like DPDK will not work if additional coherency
> > operations are required.
> > 
> > Therefore check dev_is_dma_coherent() before allowing a device to join a
> > domain. This will block device/platform/iommu combinations from using VFIO
> > that do not support cache coherent DMA.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index a4555014bd1e72..2a3aa3e742d943 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/vfio.h>
> >  #include <linux/wait.h>
> >  #include <linux/sched/signal.h>
> > +#include <linux/dma-map-ops.h>
> >  #include "vfio.h"
> >  
> >  #define DRIVER_VERSION	"0.3"
> > @@ -1348,6 +1349,11 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> >  	if (IS_ERR(device))
> >  		return PTR_ERR(device);
> >  
> > +	if (group->type == VFIO_IOMMU && !dev_is_dma_coherent(device->dev)) {
> > +		ret = -ENODEV;
> > +		goto err_device_put;
> > +	}
> > +
> 
> Failing at the point where the user is trying to gain access to the
> device seems a little late in the process and opaque, wouldn't we
> rather have vfio bus drivers fail to probe such devices?  I'd expect
> this to occur in the vfio_register_group_dev() path.  Thanks,

Yes, that is a good point.

So like this:

 int vfio_register_group_dev(struct vfio_device *device)
 {
+       if (!dev_is_dma_coherent(device->dev))
+               return -EINVAL;
+
        return __vfio_register_dev(device,
                vfio_group_find_or_alloc(device->dev));
 }

I fixed it up.

Thanks,
Jason
