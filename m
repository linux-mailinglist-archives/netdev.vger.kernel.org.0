Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCDC579634
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbiGSJVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiGSJUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:20:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22247419AB;
        Tue, 19 Jul 2022 02:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en8UMQi9csyKw9wMFf9ZkXqDXQYRU82gQk7oDFS070USsvQtvQbEhBR6ij9mdHeDFZ80xk6iUxSASXgC7wDRexhhVOvwjvJtIB9HJU/BqlP24sqtUCbEyolzbykvdEKd6sIHIledBkdBE9BAj+qn5++C7ExB+aW0eIZo+WmA23W3xLHMzfFi9xAXLgHVYhyiw2FTzr27SQNPJf1i9byO5Q31dm2HscCAc+KtAbpQsDFIsslgnLCpsq3ZH/nuwohei+na6x0m3tgTb8h2/Eg9lugom9EMztzPdXhabS4lzIJhdUNENUtapOodMtQv6CiGf9cPYNdepoh5hnT2deOKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9JVVNrYt/fKsfQJuDr+RvYpZ//RSxOXgSPS/KpzHRw=;
 b=j5WhHdgJ1cfc5ltoGF9ToKzllTk2itA+jPHSsica9RNLL/eWBTFuI07Ll6dEnGSfml2MKDUONrRjnuzjim2j5SlbgNpGtbpABkECQrWCC45Z0saBHTs1H0XaIsYe1CqHpQoCVPRV9Y/WhykeodKAXNIAiRAfdKxemHgC0L7zKaH7Yfeh0k0lHMjBLfWvI7gja3rAE6AkxgX2WTgBvf13Pj+PIbfGJAD4mmpGghuiZeI/2XLA10RdiZ74O0uIrLspZs1OwLl5hXvpzHkCxSsc7WoY9KiLJ4TMtBU6o/8CewnwYpfIgwPLCmADdbTnyo1Ug0UgieV6mqa7yISjTySgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9JVVNrYt/fKsfQJuDr+RvYpZ//RSxOXgSPS/KpzHRw=;
 b=TSRlyfCMwWRc4svJrQkBA6fuq/xXRhp0GzkjeR44uHVSnaedtttdtquHSpguaE1xazNNli9Cbkzx/PYe1EcEc/0x+PbV6WJXukFMPmOAq+sDdtM65yqdvqzi6q8KtbUXdJr+cYTRWjJxLFMhYHAqsePy0P0X6PXijns5nh+UYX59+vwUpLS+4DBIVvMal/QWvszVFvbM7be6XWjjLB5FEmJCHcnEhfzM4g/5b6Ls0ElHIyd6SR8KhG3EjdR9x1Q3KBIcGG5tkTNs1EhKVkCuECK18oQRDj50b1m9gtDoGcykBUYgkNjoQ9GEZ6Kdz1hEzwPih0HSbo+MQY/QbvBiOg==
Received: from BN9PR03CA0745.namprd03.prod.outlook.com (2603:10b6:408:110::30)
 by DM6PR12MB5551.namprd12.prod.outlook.com (2603:10b6:5:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 09:19:34 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::5) by BN9PR03CA0745.outlook.office365.com
 (2603:10b6:408:110::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.22 via Frontend
 Transport; Tue, 19 Jul 2022 09:19:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 09:19:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Jul
 2022 09:19:30 +0000
Received: from [172.27.15.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 19 Jul
 2022 02:19:27 -0700
Message-ID: <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
Date:   Tue, 19 Jul 2022 12:19:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220718163024.143ec05a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32cab19f-0ea3-48b9-c3fb-08da6967cbbd
X-MS-TrafficTypeDiagnostic: DM6PR12MB5551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5qwcYLVBIk+K9BfjfM95046Uqvp+AtBsdA+DonUB6PsIlOD/5tzYsVFP3pac6GTEahhU5Vnu4Ihb29yB8zTEfvevmgxB7tUKXlVPpKmnf/B/zPtTx1eewxCxvdI+eLgvqOzOZFsnWMlv75c0n++i2Ro0ZzP6/jDqFal8Yfp+2iVyin1Qs8qCK1bQ/OMLvF8y7boTj13nKVLEL3ZbSV6FAe9m/AW/fSejMWoHNyJCFRI1O1KsPBoEFQGYJHgebKHYNNgFh6dduYSbSplBDOjTGKFMnsvPEu8qyTC/7v3EDpVRU5Y5uBdDlEhA1dEPNlJLwiEhsmv5aWMtfUwROV47yLTu8+bBh5xi0ztBaPISW2YYd/8kuV7OyTDwNYZvu5xHtjpSN8FX7lZ4zsMkYFamjuMs01j6NRz88ooLtGkk1tbKL+i8qWJwRLUbC6Otl1jO3fJOekF+rMH5kxYwTZj3nxJtAyn1QQSOFo0Ez8LSsItEQZ+8wjQWCWah4FA96KJwHLbYPafgnk8i8QjC5SxMmGQU/6ig0PEcg9zSToXuzFvhBoiqhABgo3YQV2XLjJ4Uw28hdSpT2Nm31cU9FUN4/wOUMjVm0yfuejmXezJQuEEWEWqFqeK8e+IZ3CB1sYRIz1ouVazaoboHrVsBGEJXlGbBJYxcZ8Sy5eHXuxA87DjaSDqs0yxx7bfZFkDEjtIs+EbSVDdonJRiuye0lkstewZEFZ63M1I7T2gGXIeoizwJRCJUTPeqUU4PGz/bM0AANwsAmq9xPz4/TZ7/LkMtnbOS8QPaHew/fGip4mbMhMtugbO7zEMa/D5CR/4nY6ZC13uRKAWIEkyVwHi8/dWmbj34/0lxOC86EHPM/kABB/pWK/8slKfxd/RfkVOdcP+
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(40470700004)(36840700001)(46966006)(82310400005)(26005)(40460700003)(31686004)(6916009)(47076005)(16526019)(426003)(336012)(2616005)(36756003)(41300700001)(54906003)(70206006)(186003)(8676002)(2906002)(478600001)(36860700001)(40480700001)(81166007)(316002)(16576012)(53546011)(83380400001)(86362001)(4326008)(70586007)(31696002)(82740400003)(30864003)(5660300002)(8936002)(356005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 09:19:34.5230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32cab19f-0ea3-48b9-c3fb-08da6967cbbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5551
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 1:30, Alex Williamson wrote:
> On Thu, 14 Jul 2022 11:12:46 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Introduce the DMA logging feature support in the vfio core layer.
>>
>> It includes the processing of the device start/stop/report DMA logging
>> UAPIs and calling the relevant driver 'op' to do the work.
>>
>> Specifically,
>> Upon start, the core translates the given input ranges into an interval
>> tree, checks for unexpected overlapping, non aligned ranges and then
>> pass the translated input to the driver for start tracking the given
>> ranges.
>>
>> Upon report, the core translates the given input user space bitmap and
>> page size into an IOVA kernel bitmap iterator. Then it iterates it and
>> call the driver to set the corresponding bits for the dirtied pages in a
>> specific IOVA range.
>>
>> Upon stop, the driver is called to stop the previous started tracking.
>>
>> The next patches from the series will introduce the mlx5 driver
>> implementation for the logging ops.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/Kconfig             |   1 +
>>   drivers/vfio/pci/vfio_pci_core.c |   5 +
>>   drivers/vfio/vfio_main.c         | 161 +++++++++++++++++++++++++++++++
>>   include/linux/vfio.h             |  21 +++-
>>   4 files changed, 186 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>> index 6130d00252ed..86c381ceb9a1 100644
>> --- a/drivers/vfio/Kconfig
>> +++ b/drivers/vfio/Kconfig
>> @@ -3,6 +3,7 @@ menuconfig VFIO
>>   	tristate "VFIO Non-Privileged userspace driver framework"
>>   	select IOMMU_API
>>   	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
>> +	select INTERVAL_TREE
>>   	help
>>   	  VFIO provides a framework for secure userspace device drivers.
>>   	  See Documentation/driver-api/vfio.rst for more details.
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 2efa06b1fafa..b6dabf398251 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1862,6 +1862,11 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>   			return -EINVAL;
>>   	}
>>   
>> +	if (vdev->vdev.log_ops && !(vdev->vdev.log_ops->log_start &&
>> +	    vdev->vdev.log_ops->log_stop &&
>> +	    vdev->vdev.log_ops->log_read_and_clear))
>> +		return -EINVAL;
>> +
>>   	/*
>>   	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
>>   	 * by the host or other users.  We cannot capture the VFs if they
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index bd84ca7c5e35..2414d827e3c8 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -32,6 +32,8 @@
>>   #include <linux/vfio.h>
>>   #include <linux/wait.h>
>>   #include <linux/sched/signal.h>
>> +#include <linux/interval_tree.h>
>> +#include <linux/iova_bitmap.h>
>>   #include "vfio.h"
>>   
>>   #define DRIVER_VERSION	"0.3"
>> @@ -1603,6 +1605,153 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>   	return 0;
>>   }
>>   
>> +#define LOG_MAX_RANGES 1024
>> +
>> +static int
>> +vfio_ioctl_device_feature_logging_start(struct vfio_device *device,
>> +					u32 flags, void __user *arg,
>> +					size_t argsz)
>> +{
>> +	size_t minsz =
>> +		offsetofend(struct vfio_device_feature_dma_logging_control,
>> +			    ranges);
>> +	struct vfio_device_feature_dma_logging_range __user *ranges;
>> +	struct vfio_device_feature_dma_logging_control control;
>> +	struct vfio_device_feature_dma_logging_range range;
>> +	struct rb_root_cached root = RB_ROOT_CACHED;
>> +	struct interval_tree_node *nodes;
>> +	u32 nnodes;
>> +	int i, ret;
>> +
>> +	if (!device->log_ops)
>> +		return -ENOTTY;
>> +
>> +	ret = vfio_check_feature(flags, argsz,
>> +				 VFIO_DEVICE_FEATURE_SET,
>> +				 sizeof(control));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	if (copy_from_user(&control, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	nnodes = control.num_ranges;
>> +	if (!nnodes || nnodes > LOG_MAX_RANGES)
>> +		return -EINVAL;
> The latter looks more like an -E2BIG errno.

OK

> This is a hard coded
> limit, but what are the heuristics?  Can a user introspect the limit?
> Thanks,
>
> Alex

This hard coded value just comes to prevent user space from exploding 
kernel memory allocation.

We don't really expect user space to hit this limit, the RAM in QEMU is 
divided today to around ~12 ranges as we saw so far in our evaluation.

We may also expect user space to combine contiguous ranges to a single 
range or in the worst case even to combine non contiguous ranges to a 
single range.

We can consider moving this hard-coded value to be part of the UAPI 
header, although, not sure that this is really a must.

What do you think ?

Yishai

>
>> +
>> +	ranges = u64_to_user_ptr(control.ranges);
>> +	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
>> +			      GFP_KERNEL);
>> +	if (!nodes)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < nnodes; i++) {
>> +		if (copy_from_user(&range, &ranges[i], sizeof(range))) {
>> +			ret = -EFAULT;
>> +			goto end;
>> +		}
>> +		if (!IS_ALIGNED(range.iova, control.page_size) ||
>> +		    !IS_ALIGNED(range.length, control.page_size)) {
>> +			ret = -EINVAL;
>> +			goto end;
>> +		}
>> +		nodes[i].start = range.iova;
>> +		nodes[i].last = range.iova + range.length - 1;
>> +		if (interval_tree_iter_first(&root, nodes[i].start,
>> +					     nodes[i].last)) {
>> +			/* Range overlapping */
>> +			ret = -EINVAL;
>> +			goto end;
>> +		}
>> +		interval_tree_insert(nodes + i, &root);
>> +	}
>> +
>> +	ret = device->log_ops->log_start(device, &root, nnodes,
>> +					 &control.page_size);
>> +	if (ret)
>> +		goto end;
>> +
>> +	if (copy_to_user(arg, &control, sizeof(control))) {
>> +		ret = -EFAULT;
>> +		device->log_ops->log_stop(device);
>> +	}
>> +
>> +end:
>> +	kfree(nodes);
>> +	return ret;
>> +}
>> +
>> +static int
>> +vfio_ioctl_device_feature_logging_stop(struct vfio_device *device,
>> +				       u32 flags, void __user *arg,
>> +				       size_t argsz)
>> +{
>> +	int ret;
>> +
>> +	if (!device->log_ops)
>> +		return -ENOTTY;
>> +
>> +	ret = vfio_check_feature(flags, argsz,
>> +				 VFIO_DEVICE_FEATURE_SET, 0);
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	return device->log_ops->log_stop(device);
>> +}
>> +
>> +static int
>> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
>> +					 u32 flags, void __user *arg,
>> +					 size_t argsz)
>> +{
>> +	size_t minsz =
>> +		offsetofend(struct vfio_device_feature_dma_logging_report,
>> +			    bitmap);
>> +	struct vfio_device_feature_dma_logging_report report;
>> +	struct iova_bitmap_iter iter;
>> +	int ret;
>> +
>> +	if (!device->log_ops)
>> +		return -ENOTTY;
>> +
>> +	ret = vfio_check_feature(flags, argsz,
>> +				 VFIO_DEVICE_FEATURE_GET,
>> +				 sizeof(report));
>> +	if (ret != 1)
>> +		return ret;
>> +
>> +	if (copy_from_user(&report, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (report.page_size < PAGE_SIZE)
>> +		return -EINVAL;
>> +
>> +	iova_bitmap_init(&iter.dirty, report.iova, ilog2(report.page_size));
>> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
>> +				    u64_to_user_ptr(report.bitmap));
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (; !iova_bitmap_iter_done(&iter);
>> +	     iova_bitmap_iter_advance(&iter)) {
>> +		ret = iova_bitmap_iter_get(&iter);
>> +		if (ret)
>> +			break;
>> +
>> +		ret = device->log_ops->log_read_and_clear(device,
>> +			iova_bitmap_iova(&iter),
>> +			iova_bitmap_length(&iter), &iter.dirty);
>> +
>> +		iova_bitmap_iter_put(&iter);
>> +
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	iova_bitmap_iter_free(&iter);
>> +	return ret;
>> +}
>> +
>>   static int vfio_ioctl_device_feature(struct vfio_device *device,
>>   				     struct vfio_device_feature __user *arg)
>>   {
>> @@ -1636,6 +1785,18 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>>   		return vfio_ioctl_device_feature_mig_device_state(
>>   			device, feature.flags, arg->data,
>>   			feature.argsz - minsz);
>> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_START:
>> +		return vfio_ioctl_device_feature_logging_start(
>> +			device, feature.flags, arg->data,
>> +			feature.argsz - minsz);
>> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP:
>> +		return vfio_ioctl_device_feature_logging_stop(
>> +			device, feature.flags, arg->data,
>> +			feature.argsz - minsz);
>> +	case VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT:
>> +		return vfio_ioctl_device_feature_logging_report(
>> +			device, feature.flags, arg->data,
>> +			feature.argsz - minsz);
>>   	default:
>>   		if (unlikely(!device->ops->device_feature))
>>   			return -EINVAL;
>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index 4d26e149db81..feed84d686ec 100644
>> --- a/include/linux/vfio.h
>> +++ b/include/linux/vfio.h
>> @@ -14,6 +14,7 @@
>>   #include <linux/workqueue.h>
>>   #include <linux/poll.h>
>>   #include <uapi/linux/vfio.h>
>> +#include <linux/iova_bitmap.h>
>>   
>>   struct kvm;
>>   
>> @@ -33,10 +34,11 @@ struct vfio_device {
>>   	struct device *dev;
>>   	const struct vfio_device_ops *ops;
>>   	/*
>> -	 * mig_ops is a static property of the vfio_device which must be set
>> -	 * prior to registering the vfio_device.
>> +	 * mig_ops/log_ops is a static property of the vfio_device which must
>> +	 * be set prior to registering the vfio_device.
>>   	 */
>>   	const struct vfio_migration_ops *mig_ops;
>> +	const struct vfio_log_ops *log_ops;
>>   	struct vfio_group *group;
>>   	struct vfio_device_set *dev_set;
>>   	struct list_head dev_set_list;
>> @@ -104,6 +106,21 @@ struct vfio_migration_ops {
>>   				   enum vfio_device_mig_state *curr_state);
>>   };
>>   
>> +/**
>> + * @log_start: Optional callback to ask the device start DMA logging.
>> + * @log_stop: Optional callback to ask the device stop DMA logging.
>> + * @log_read_and_clear: Optional callback to ask the device read
>> + *         and clear the dirty DMAs in some given range.
>> + */
>> +struct vfio_log_ops {
>> +	int (*log_start)(struct vfio_device *device,
>> +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
>> +	int (*log_stop)(struct vfio_device *device);
>> +	int (*log_read_and_clear)(struct vfio_device *device,
>> +		unsigned long iova, unsigned long length,
>> +		struct iova_bitmap *dirty);
>> +};
>> +
>>   /**
>>    * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
>>    * @flags: Arg from the device_feature op


