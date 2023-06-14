Return-Path: <netdev+bounces-10880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F557309E8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F22A281596
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C06134B8;
	Wed, 14 Jun 2023 21:41:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9512EC3A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:41:27 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2277C180;
	Wed, 14 Jun 2023 14:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HK6F0U1Z0ROTAngy4vSLo73dBq5I/iH34oGfMu2V1r9Rm6uvyvkLDPxqpmwr+3qdvL++EmfD4MNfTVd0WpGkgCSkFhjM9I1OkdffU9+aF/h8HicxZFEm3zWUPzkNbIF6OSsn3x51JBehrp8JATKrtieh5q230rTMgWfj7Cyw2A2WFaRow41NYqcvOSNLKt0/odf2tIs5La0j863RsRkJiQEA4RnzQMh/5xoBV4qEXhb5iR5kPvn8Y8CYVCZXbJDjDdajyp/pWwVUzaoUs6FzbvvUqn21k/2Fx9Z6YRuu0ywHia83u+I17OtXiDmrgeBUmhZtB0rcmEMB3v7mtybhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npOlwoyPsoeW9sq6Mc3keinHz8BeBbsDagoZN4xxXlc=;
 b=DaZzeurxsr2M1mtK/t4l8eEAs9pgjM47G9u3bPO4kZuSC8XdeH0w44F5ko5ZlK3IA1SCTZSU5MRO92vzqRFoFG1fc1hP1ahTe2U2wI1lOxlsuDUr9S4Y4qQ8XtBQTcAu+bjcxbafw5cgfl8QfXiccbCorc6N5MP+13LkPnA0XE8D3jXjKfXQCO+ops3k+pqAvLDSL4ZojmxInl5dWEWgi6CiDPxZblA6KCagQNz5x9RUoUIjOFNpQ4vF3G24lcyLYiS0oqe5UKfTS6zBLn0JI8LKU+ofYJEwmxD5gkkt8TcsK9wL4BjBuY2Y18Wq0aul3lnY/qSh4kAVaDPElCRSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npOlwoyPsoeW9sq6Mc3keinHz8BeBbsDagoZN4xxXlc=;
 b=okdLIyRoGltqKgujxzy2NZVXVtGfo/AeNBb69okfutj6BQEAJ7hzPhFeZ98aeALRXcVqxosG1EjiAKxmFnps1Sg5NPQ8HJ+5EiselObYyQWpdTEMkLTkWrojERW9RFkcR8Id50CziAEAdIUS1yqzwqDq2pmZGkFGYAhA+RCiNQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 21:41:23 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 21:41:23 +0000
Message-ID: <51ebf045-2361-1f00-d043-6d9520e433b4@amd.com>
Date: Wed, 14 Jun 2023 14:41:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>,
 Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-3-brett.creeley@amd.com>
 <20230614153102.54e82fe2.alex.williamson@redhat.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230614153102.54e82fe2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:a03:255::21) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d71b58-f9b2-453e-c253-08db6d20192d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p6z3+6DCzZnUMo3+OEiOhOMMfrPCftlzaK+DxcAZTg1Y7UM5/CO/Eo5rvIcCiHuAPFFfOzgAsLFKZzJmEcq6qGFoQ2+rY22xzxP8WpzO5hzFmN2AXCcuMhfKVuZfYKTM88GDeUdMCDpWpHbjEC6HoBeJb/TUSpV2nkwqWu8voCLOEL+GzGjPf4RLvfj4Q2mPdzq6fVXEtaXMaqs0mDNwz4kPFRKcLbRQ82cLRTXXcd+TwvUqK9+pDVse5mCKefWmtvldWPiYNd9jH1qAxmAvGKivj4sRG9pIa5snDFlKsRfh0RduZb7mPG8UEf0Bql0EzjOmeisBV9eESA33ZeNaYjjBddcEBAsIYAchJfjWng2m9f6czE7uq1YUqqhZmzsNWeHHxzVdM9JkX+TwokQfV1jD1aCARvtOVp93PAIOVvHo5eSCVH16RqEJ+qcX2TQGyTkRnH/8EPvFQf9vYAo9KXA786lKubowJF7Y/4yWr3iLSpxalj974GcbtOxpPqLeL/rlSzbW1dUqKAto9iKLYEVqwN83dvfXbdRujRpsTNJYFzXhgQklHmZ+Ib63ID6PR9LdDGxbZh/3K69uVQ+tzhYihHV7k8eAC2eYVNDxsGacBnP4qncGb9rq5LFRr1sB1F0ml2DfgofhDRpzh1zi0w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199021)(41300700001)(5660300002)(8676002)(8936002)(2906002)(36756003)(478600001)(31696002)(53546011)(6512007)(26005)(6506007)(2616005)(83380400001)(6486002)(966005)(38100700002)(6636002)(4326008)(66946007)(66556008)(66476007)(316002)(186003)(31686004)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1M3N1RCRGNnVXNrSEhQN1c0RjM3T1Z3YThBVVF1ck5ySTB0RkZHSGVCT3lP?=
 =?utf-8?B?eGx3ODVKeE9xSWRwMlVIejl0alUvK013UHRlRUVFTm9DZklvWXFOUm14TjA1?=
 =?utf-8?B?dGNpUGxIT0E5NzNIOS9TZktzaU9qWE5QM3ZNTVRKbU0zOWhiTHBQMFVoZU5L?=
 =?utf-8?B?dVhxQW5tWmtCZ0JORGgwbXhHOG1iZElDazVvZFBtZzVVdldBN0p2ZEI0MWFx?=
 =?utf-8?B?WGZsVitWTGhxODcxektQLzdFQjFJQmJHSjhEckt4UCtUTGI4Y1BONDA5NER0?=
 =?utf-8?B?Rk1FYWQ4MUNDUkR5aGVNZmsyc0Q4Mms1UUZCQmlzaU94aTBZTzVWc2ZVK1Vy?=
 =?utf-8?B?YVR0bjBTUVVJck5oWjJkTlgrLzl4VkpWN2IxOEpvV1N4R2FUamxDd1lWK20x?=
 =?utf-8?B?UHplbHpoMjQ2Umg5NzF0T0l4YXFTcitoL2d5eFFlVlBVcnRmRHdaTW5WcFZV?=
 =?utf-8?B?alB5OUFlS1ZkUVlnMWtkQkl5UUpoVXl4d0IwN1hDRHVIbHRhRlJhSkNvVkVH?=
 =?utf-8?B?T1VFaHVPN0lCZHNlSnhIZk9LOEY3UDhhdlAvYXl0K0lCY3RMSWZqVW1wQzZ0?=
 =?utf-8?B?NHlFRENvVkhyY3hEcjJSOEc4M1hNMWxITTg3c1hrWEdQclByTXAyaUxtZmZq?=
 =?utf-8?B?NzV2MFhXNE5aMGpKODBUZzdJQ2lTQnE1MVlaekRkTzFJOFhhelc3VlFyUGtq?=
 =?utf-8?B?cSsrSkV0ZUNZTHI3cGZYd2RQMTlibDJQS2N4elowZDd3MDVUMitxbllydlB0?=
 =?utf-8?B?b1l2UFhLWU9TNVRzRjhyaEp2Tlp0Q001cTJndkRtMlljMUtWVURFVS82eWJL?=
 =?utf-8?B?ZTNHT1o5aDZtZ0lIUHRjb052SDFFeXQxdFY3VnRrNjl4SDdlekRxNmVjVWVk?=
 =?utf-8?B?UEFJZ3VIS1JPQUkvK2hGbGFtU3B2b2FkTXFmUTVialc5WWJVbkdSMFNoaXBX?=
 =?utf-8?B?Q0JJWUpienBmS043Z01VYnlaTUZja0hObEdYbWROa3Yxa2w5MW1meUEwamQr?=
 =?utf-8?B?Qy9MTDE0STZ3dlBwTmdxTjFyaWZqclZRTTlieVljL0VUaXd3NTI3R2pHM05S?=
 =?utf-8?B?NDl5cEpyQnR6MEIyMUlxTi9zM3o1d2RpWUI4azFZeEZZbnduNjJUUjc2RkZz?=
 =?utf-8?B?S1ZKQTlzT3pZQWJqb2o0M1FhWkk2UnJTeVphVExEYVppSVNsUmhZb0NUOXlJ?=
 =?utf-8?B?YVpwODIzMjVtM0JUYjROVFBJTUExeFQzTE9MZ1gwdzJnNkprZW95dGJXS01M?=
 =?utf-8?B?eklLZHJ5ZGdzVlNDTFBKcnR2WHBZL0xMdk9FNGZWcTRja2QxbWFGQXpuQmJx?=
 =?utf-8?B?dzZrYjBsenlSTG5kWDBhYzZobTNWWlZmbURQR1JlUmFUc2RlbkpZbWg0RjRw?=
 =?utf-8?B?a0psaTJOMmZzWVowcExmYWZmQVBTR0hDOFFwZThxbVRkZUk4T2w5eGZVbjNh?=
 =?utf-8?B?NkFtWVdBS2lLYlpuY2ZaeDZlSWswWVlMZ0RhNDcxdTJ4YXNRTmVCeVdTOUlt?=
 =?utf-8?B?U0g0QVRYSmI2dmFFb0d6Qlg4VEo3WlNvRHBLQ21lRUlpOHp1RVh6N1J3S2pn?=
 =?utf-8?B?WHI3STFJdWhiUGVVWEwwK042MzZPc1dtcG5LYytadk9aa3VLMEJHOTB2NWMw?=
 =?utf-8?B?STltN1AvSnl1YmpudkYwRWUvNzJJemJ6emNxazdrM0tsTW8wTUdCOTFPdGor?=
 =?utf-8?B?bCtmUURrSTMyd0tsQjdiRG1DWEhJZ1FYYTBxT01VRzdSQXFWN1FSRXR5cFA1?=
 =?utf-8?B?WkNsS1Y1ZEtQZGxuaURVdVA5ZmQzYWJvSVBQaWZtZGVMM2o3TFUwaVNxSlRp?=
 =?utf-8?B?bWNRSG9YUmZFdndPVmZDdVgwQUloZWxGYXA2Y2lhd1J1b3AxYU9UY21GSmxv?=
 =?utf-8?B?WVJHYWgwejRWMEgwYnQxSE9PMVlxUDR3TnVjdlErbm5nUXBmTVNOcWQxOVVO?=
 =?utf-8?B?MzhWeUtxWVA5dWtPSW1yR0h1T3ZIbGZtb3IybjZMZlh6YWJoSTcxOTdMK0g3?=
 =?utf-8?B?Z0UrZkt2MjB6YlRHVkY5WUhPT0NiR2YwQnhCNk1IMnNUUmcyd2JDWHZpV3VT?=
 =?utf-8?B?M09UYlpqdzRabzVYVDBkY1FEUzN3K29IcFZia3NVdHRMaDVpaGZMd1h1ZHRL?=
 =?utf-8?Q?qA8mc0QQF1mdCBtTcYQtdHM5q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d71b58-f9b2-453e-c253-08db6d20192d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 21:41:23.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sFyA7tSlbyrpJa5mR7yAarsol2ZnCCDOuWZ3sMn4YJehz+h1DM2RrhWuFQGau2N7+2JPA+2v60elzDOicTg9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/14/2023 2:31 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, 2 Jun 2023 15:03:13 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
>> This is the initial framework for the new pds_vfio device driver. This
>> does the very basics of registering the PDS PCI device and configuring
>> it as a VFIO PCI device.
>>
>> With this change, the VF device can be bound to the pds_vfio driver on
>> the host and presented to the VM as the VF's device type.
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vfio/pci/Makefile       |  2 +
>>   drivers/vfio/pci/pds/Makefile   |  8 ++++
>>   drivers/vfio/pci/pds/pci_drv.c  | 69 +++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.c | 72 +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.h | 20 +++++++++
>>   5 files changed, 171 insertions(+)
>>   create mode 100644 drivers/vfio/pci/pds/Makefile
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
>>
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index 24c524224da5..45167be462d8 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>>   obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>>
>>   obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>> +
>> +obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
>> new file mode 100644
>> index 000000000000..e1a55ae0f079
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/Makefile
>> @@ -0,0 +1,8 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2023 Advanced Micro Devices, Inc.
>> +
>> +obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
> 
> Given the existing drivers:
> 
> obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
> obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o
> 
> Does it make sense to name this one pds-vfio-pci?

Yeah I think it does make more sense to align. Thanks.

> 
>> +
>> +pds_vfio-y := \
>> +     pci_drv.o       \
>> +     vfio_dev.o
>> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
>> new file mode 100644
>> index 000000000000..0e84249069d4
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/pci_drv.c
>> @@ -0,0 +1,69 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/types.h>
>> +#include <linux/vfio.h>
>> +
>> +#include <linux/pds/pds_core_if.h>
>> +
>> +#include "vfio_dev.h"
>> +
>> +#define PDS_VFIO_DRV_DESCRIPTION     "AMD/Pensando VFIO Device Driver"
>> +#define PCI_VENDOR_ID_PENSANDO               0x1dd8
> 
> Isn't this a duplicate from the above include:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/pds/pds_core_if.h#n7
> 
> I also find it defined in ionic.h, which means that it now satisfies
> pci_ids.h requirement that the identifier is shared between multiple
> drivers.  A trivial follow-up after this series might combine them
> there.

Good suggestion. Once this series is merged we will submit the follow up 
patch. Thanks.

> 
>> +
>> +static int pds_vfio_pci_probe(struct pci_dev *pdev,
>> +                           const struct pci_device_id *id)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio;
>> +     int err;
>> +
>> +     pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
>> +                                  &pdev->dev, pds_vfio_ops_info());
>> +     if (IS_ERR(pds_vfio))
>> +             return PTR_ERR(pds_vfio);
>> +
>> +     dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>> +
>> +     err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>> +     if (err)
>> +             goto out_put_vdev;
>> +
>> +     return 0;
>> +
>> +out_put_vdev:
>> +     vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>> +     return err;
>> +}
>> +
>> +static void pds_vfio_pci_remove(struct pci_dev *pdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>> +
>> +     vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>> +     vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>> +}
>> +
>> +static const struct pci_device_id
>> +pds_vfio_pci_table[] = {
>> +     { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO, 0x1003) }, /* Ethernet VF */
>> +     { 0, }
>> +};
>> +MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
>> +
>> +static struct pci_driver pds_vfio_pci_driver = {
>> +     .name = KBUILD_MODNAME,
>> +     .id_table = pds_vfio_pci_table,
>> +     .probe = pds_vfio_pci_probe,
>> +     .remove = pds_vfio_pci_remove,
>> +     .driver_managed_dma = true,
>> +};
>> +
>> +module_pci_driver(pds_vfio_pci_driver);
>> +
>> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
>> +MODULE_AUTHOR("Advanced Micro Devices, Inc.");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> new file mode 100644
>> index 000000000000..4038dac90a97
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -0,0 +1,72 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#include "vfio_dev.h"
>> +
>> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>> +{
>> +     struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
>> +
>> +     return container_of(core_device, struct pds_vfio_pci_device,
>> +                         vfio_coredev);
>> +}
>> +
>> +static int pds_vfio_init_device(struct vfio_device *vdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(vdev, struct pds_vfio_pci_device,
>> +                          vfio_coredev.vdev);
>> +     struct pci_dev *pdev = to_pci_dev(vdev->dev);
>> +     int err;
>> +
>> +     err = vfio_pci_core_init_dev(vdev);
>> +     if (err)
>> +             return err;
>> +
>> +     pds_vfio->vf_id = pci_iov_vf_id(pdev);
>> +     pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
> 
> We only ever end up using pci_id for a debug print here that could use
> a local variable and a slow path client registration that has access to
> pdev to do a lookup on demand.  Why do we bother caching it on the
> pds_vfio_pci_device?  Thanks,
> 
> Alex

No good reason, so another good suggestion. I will fix this as well. 
Thanks again for the feedback.

> 
>> +
>> +     return 0;
>> +}
>> +
>> +static int pds_vfio_open_device(struct vfio_device *vdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(vdev, struct pds_vfio_pci_device,
>> +                          vfio_coredev.vdev);
>> +     int err;
>> +
>> +     err = vfio_pci_core_enable(&pds_vfio->vfio_coredev);
>> +     if (err)
>> +             return err;
>> +
>> +     vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct vfio_device_ops pds_vfio_ops = {
>> +     .name = "pds-vfio",
>> +     .init = pds_vfio_init_device,
>> +     .release = vfio_pci_core_release_dev,
>> +     .open_device = pds_vfio_open_device,
>> +     .close_device = vfio_pci_core_close_device,
>> +     .ioctl = vfio_pci_core_ioctl,
>> +     .device_feature = vfio_pci_core_ioctl_feature,
>> +     .read = vfio_pci_core_read,
>> +     .write = vfio_pci_core_write,
>> +     .mmap = vfio_pci_core_mmap,
>> +     .request = vfio_pci_core_request,
>> +     .match = vfio_pci_core_match,
>> +     .bind_iommufd = vfio_iommufd_physical_bind,
>> +     .unbind_iommufd = vfio_iommufd_physical_unbind,
>> +     .attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +const struct vfio_device_ops *pds_vfio_ops_info(void)
>> +{
>> +     return &pds_vfio_ops;
>> +}
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> new file mode 100644
>> index 000000000000..66cfcab5b5bf
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _VFIO_DEV_H_
>> +#define _VFIO_DEV_H_
>> +
>> +#include <linux/pci.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +struct pds_vfio_pci_device {
>> +     struct vfio_pci_core_device vfio_coredev;
>> +
>> +     int vf_id;
>> +     int pci_id;
>> +};
>> +
>> +const struct vfio_device_ops *pds_vfio_ops_info(void);
>> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>> +
>> +#endif /* _VFIO_DEV_H_ */
> 

