Return-Path: <netdev+bounces-11237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FC97321B6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26DDA1C20E8C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E4E1641E;
	Thu, 15 Jun 2023 21:30:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE072E0FC
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:30:49 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFB6E69;
	Thu, 15 Jun 2023 14:30:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqlaKtYca68WrmDmQbr5zOi8/NlCW3t4h3HibyMIiMjqm9t4NxuUkUNxuPgGNBg5sdv2e39Rl9vdypiieoG2jeKIDejDm30c8R5ZSha2FvMdYUPKuRGqft7qR+tLiksuFrre7M1I+4gV9ZEeFF64wH7bNI3O54tiR1Ni4gQE6bddKf3iBebhJsw5BRiqAuWjQFh2qc5ztcw4O3fKUfq2g/Yxo5/Fk//I6PKYsHAu9etfRC+06mYrrl1uqPP9c5/rVNHUZfVwY4InbIQkd1zy50fnWGThlPQ04jgs+Xxr+TLkhINjE5ZTmcbViGQhsc/6kzMwVAblMmnWjDlFPWTNLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6adDS+x5JiFi6VqG/l0hm8JhSbVevNbTGMYUf7stK8=;
 b=HM2mpsMHqUCEmOqYrWbsaNlhEGbEQOpm6XsMkR0+8CYwODNIbsINkbpJIe3A0Rx+E7QWnvlVCADP09V3P9ZeckSMB9DdBmRq9Z5HLB0T6sBefeQkdMtdajQk163dgEulRjnlicM0Q5XAUzhq+E5aXJ7MnJ9T59/dWKe+oLpXDXS5UOLNmEzqRVszb2w6A1uhZNLkcrWwALQkaakUxA9NSEsHiBiPHHoCCLEDdVn0EgZ7h5uSlCgHt2KPS8Y6cvIBhd9LIcE+N8j7jveWX0khdcbYm+OmujtcFjCjJ7A8gQwSFE0rjrYHf65/VMwFjml6X5A9lzndxaZ8ajcwhHqPuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6adDS+x5JiFi6VqG/l0hm8JhSbVevNbTGMYUf7stK8=;
 b=iMEY/KBnPiRmlSfCGyKgxKtxYKqkakTRXPbTqdBufJhipy6lXDjOtlL2+gJvi1TD+i10AMbDO2ViR6vLqvkvD30+2RDJ9uuFrjEGkLzsGa1PPWanlWuV/NtD7mG8Hi3rTXeCygA+UZDI7TyLq9Tcb0ecXAzlwzmgd/2SjUBjm2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 15 Jun
 2023 21:30:44 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 21:30:44 +0000
Message-ID: <f34ee622-d47e-d753-48cb-ac8879968ff4@amd.com>
Date: Thu, 15 Jun 2023 14:30:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
 <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-4-brett.creeley@amd.com>
 <67192b9598d041568ece62ea282367d0@huawei.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <67192b9598d041568ece62ea282367d0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:74::33) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: 8377976a-6914-4a0b-cc7f-08db6de7c6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ru/mEGw7vISY3Q3pv1ryJsTCNGzMi8Aug2kA9rEqeJILn4qHAGh1ewB7FqDlh7dSQxAjLJ1OhlgC7OU5d0tIAgf8j1nR+Sx9zsz4w4cn5Yi+wDCChmzT8FvfjgIBb1eOzz9YcgYcbafvRBzeMDvmalkErh2ZNIVBUvkha6NLBsFAuKYGkFa322T0mWqLipLYneAjN/CkM/fNV74IxDsp+z40OgvlQSQH0D9KzMxWQlUSz0EYHurYyvRYHhbWJ4S/lRMNHXjdZIbdetINKFQVNFV0gb52frBjRiUYzPNLk8ImVEv8S/Il/yh7nMvJF8BhSaxg/z2Z9bzDbmGMGwA5EBWHcKmVktFAWhxPR50S4BLVBnTvAQMaK1oK4HdhL/d4+poe30PHP8Q4dQEM3sWpylO3QU8L0Iq8rXEHGJEZdWhj6WIB+b5OiPhKbORUrmdIQsNOSU8JnEEA8JvhBBtSyaUG2fDc7q4T1n6m4ShcxvvTpjqmFVakqilTvYtzmYa1LNNEMxxAV79hriB2aAAxEdc0PlgVWiwQJyzsHfmuk6Oyi+/h6dP2crSs5NZ2R+4dOr/rPdZwRdq4BmL7e3Kicc1iZhwti6P58OC71GhzoIzyRZ+ITmpNEQM8I13/EmVkMV+MFQUYTAMmMSvIKXueGw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199021)(478600001)(4326008)(66476007)(66946007)(66556008)(36756003)(110136005)(5660300002)(8936002)(31696002)(8676002)(2906002)(316002)(41300700001)(83380400001)(38100700002)(2616005)(6486002)(26005)(6506007)(53546011)(31686004)(186003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWNqK0R1WVgwZWpndEcxZFZHV2lFbFFaNmJpTXNPNFVUV1M3Y3lEMk5XNHov?=
 =?utf-8?B?dm4vV0gwL0F3REthUmIrTjZ0MDV2ZWRuelBrcnVndCtKMWdqSjQvRnZ2dWlW?=
 =?utf-8?B?ZkZGMlZrczkxc01zdEVtSTRZRERZWTVsTkY5N2c2QkFiMnVXM3UzQzc2SUls?=
 =?utf-8?B?YjhqT1FScXV6N2JGNVgxckJ3a3F3Z3RhT2NKMEIwYWs5Q0FCREJIZG5tUWpa?=
 =?utf-8?B?SzN4ZmJtalY5MkpWSWpnTVRBL1ZnWi9XV2FCaEU0Wkt6ZSt1OXRFYWMxUVhR?=
 =?utf-8?B?bS9CY1N6QzltSmtJRXk0Y2xOWXMxMGJUbWVxTXNxTkxhVkpqVWY4MUlDa1Jj?=
 =?utf-8?B?Q2lQZ2xmckJVYS9SekFhTE9oaHA1OFpqRVFTcXVPbk8yZnluVEFCOWR5U1Zi?=
 =?utf-8?B?c1N4eTJjbmN1NXZ6M3lRekllczhXSEV4am4zWjFPUUJHU2J3Z1FobTFTM01a?=
 =?utf-8?B?UUlsdGNtMjBSdFFiT0FzV1NhTEVxL2Jlc2lWemVXZG1aRCtkRGFVM2xNT2lu?=
 =?utf-8?B?UGUvUXRKRk91WG0yeDVFNzQxczQ3aHFkeExqUlNJK3E2Qk5Da25STGIwSDBk?=
 =?utf-8?B?OWJ3SWhwTkpQTE9VK1BabEpRLzJ3cjI4c0wxRXZjUVRjQUs1QnB2aWVXd0pE?=
 =?utf-8?B?L0gzc3JTMHBzNDlGenVIVmZscHlwcFloN3RhN2RiM3NzY0k2Y0dId3NyOC9C?=
 =?utf-8?B?NDg2YWVkTHhiNU1ZK0hWMzFGNUd2Q1hNNzI2bWJUQ2toUXV5M2FYbG1IODl2?=
 =?utf-8?B?bW1NdVdRTjJpQW5oRGlFN3ZQQlFOUHA5S1plbUlrWEdyTE82UmVPT2M2dzAy?=
 =?utf-8?B?UU5RMVY3MG00d1BBTGtxUmVIcWhoZDZrQUtGVERZL3FFL1ZCcmQvU2x4TFM1?=
 =?utf-8?B?TTFKbjlnamI5Q0xlazVmMk10Y3ZVZXhjYVZRc0loOXNCem4vQThIWDByQmxG?=
 =?utf-8?B?RDZoNUxvR3RGL09wNG94S0xPOU4yNFhrUFZPM2pFcUhDdnNhNUZac2V6dXlG?=
 =?utf-8?B?Qi84aUVHTTkwY1RRdXhWOGM2QkdlYmtBWHNicjErMFZXVWFDa3N3WHpGNVFQ?=
 =?utf-8?B?d3U1dlFLMVhxbERrYjFKY3N2UWcxWEFrK2xSSU05by9OeCtuYUFKaGNLYWRZ?=
 =?utf-8?B?aXZyWWlQTXljMFB0amtWQlZpVjlQNFRQRld2V2hSaUhXR0Q5YjFFSjlBRG0z?=
 =?utf-8?B?N2F5OHVGM3NsMkd2VUZETVA2eTdkMUNXQ3h2ZE1BaEdaOGlyK0JnL0doVEQ5?=
 =?utf-8?B?WXBkWERzZXdNZUJBUE9URHM4SDNyNnRleGorNElnSGJmQ3FVOWV2dC8wbzN2?=
 =?utf-8?B?MDI1TnMxVW1pRS8zKzhDTGdCZ0VxdUUwejlNblRmcDFMR2Y2ejNVQ0Y0eEdH?=
 =?utf-8?B?eGZNQTAyRWFNSGpoYmlmR1BVaEFiRnh6OWQwRjFwTnJvVFZvaHRjZ2Y4SUVn?=
 =?utf-8?B?NWExa0JlbHpMNjFnMG5PUUQ0ZWlDUWRSZ1ZUM291TmVTcVk1TGdFS1VlblZE?=
 =?utf-8?B?S2owOFlZdTNHaW9rdUFoQTJXMjZpN2Q5RmcvSnBOeDNWMVFYanBKY2Z2OUtp?=
 =?utf-8?B?L1VJWnNFRHhLQmM5Uy9uRHA3RjVyVXpsTnpDR1oyKzZVM0Q3K1k5YTVEWC9Q?=
 =?utf-8?B?STd3MFFWOWNSdE80OUR3TE5vM00rY2FZV1p4YXJET3RLTkx0MVhDblBNK1RX?=
 =?utf-8?B?c1BHamNaQytVazRzUS9BbmhiMkJZSmVhZE9NSkZ4QzBxSzJPVGtPS0o4azlK?=
 =?utf-8?B?RkY1K0w2OHdYM0VnN1Fqd0VXVHlZc2t0Mi9IOFF1MlEwa0ZFTEJuRW5KNkNt?=
 =?utf-8?B?SDd2eUJCSjl6QjBKWXJwTjA3RE9FSS9Jc1o1b01XdmxjUXZLdTRON2I0d21v?=
 =?utf-8?B?OVdZMmVRWmxCcTgvdTBzY2hmS3k3eEpBVjVWc1VHZWZKaEFXRTAwOU9nZnhP?=
 =?utf-8?B?TEZpZnpGTGVzZFRpNGZpcmdvakJXejNNc3NWemI3LzZIYnRQM2t1RUVZUEQv?=
 =?utf-8?B?TXpJMzhaSHBldkJCdjhTbXdjVnNjTElVSjN6RmptY3BkMFVUQTNWV2h6eGlF?=
 =?utf-8?B?SW1mSHg5VXdkUmFZRDRyZTg0cDhxdHhVc215NkJJV09xY0xtTkFvVktjaW9l?=
 =?utf-8?Q?KgGnjsUo3nAlSqeeecHRb8J9i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8377976a-6914-4a0b-cc7f-08db6de7c6a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 21:30:44.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLoIvV2tIlY5g2OShnvsEJAv58gRLxJI0c0eydGwfmF+xr3TM46UL418K9n9U9VjdI+s17093R0leoTgDhACrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 2:05 PM, Shameerali Kolothum Thodi wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> -----Original Message-----
>> From: Brett Creeley [mailto:brett.creeley@amd.com]
>> Sent: 02 June 2023 23:03
>> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
>> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> kevin.tian@intel.com
>> Cc: brett.creeley@amd.com; shannon.nelson@amd.com
>> Subject: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
>>
>> The pds_core driver will supply adminq services, so find the PF
>> and register with the DSC services.
>>
>> Use the following commands to enable a VF:
>> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vfio/pci/pds/Makefile   |  1 +
>>   drivers/vfio/pci/pds/cmds.c     | 43
>> +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
>>   drivers/vfio/pci/pds/pci_drv.c  | 19 +++++++++++++++
>>   drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
>>   drivers/vfio/pci/pds/vfio_dev.c | 11 +++++++++
>>   drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
>>   include/linux/pds/pds_common.h  |  2 ++
>>   8 files changed, 101 insertions(+)
>>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>
>> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
>> index e1a55ae0f079..87581111fa17 100644
>> --- a/drivers/vfio/pci/pds/Makefile
>> +++ b/drivers/vfio/pci/pds/Makefile
>> @@ -4,5 +4,6 @@
>>   obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
>>
>>   pds_vfio-y := \
>> +     cmds.o          \
>>        pci_drv.o       \
>>        vfio_dev.o
>> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
>> new file mode 100644
>> index 000000000000..ae01f5df2f5c
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.c
>> @@ -0,0 +1,43 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/io.h>
>> +#include <linux/types.h>
>> +
>> +#include <linux/pds/pds_common.h>
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +
>> +#include "vfio_dev.h"
>> +#include "cmds.h"
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     char devname[PDS_DEVNAME_LEN];
>> +     int ci;
>> +
>> +     snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_LM_DEV_NAME,
>> +              pci_domain_nr(pdev->bus), pds_vfio->pci_id);
>> +
>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>> +     if (ci <= 0)
>> +             return ci;
> 
> So 0 is not a valid id I guess but we return 0 here. But below where
> pds_vfio_register_client_cmd() is called, 0 return is treated as success.
> 
> Note: Also in drivers..../auxbus.c the comment says the function returns 0
> on success!.
> 
> Please check.
> 
> Thanks,
> Shameer

Hey Shameer,

Thanks for catching these issues. It looks like there are a couple 
things that need to be fixed.

[1] pds_vfio_register_client_cmd() needs to always return negative on 
error, which includes ci == 0. I don't think we would ever hit this case 
because drivers..../auxbus.c returns -EIO when ci == 0, but best to fix 
it in case that ever changes.

[2] Documentation for pds_client_register in drivers..../auxbus.c needs 
to be updated to say something like the following:

Return: Client ID on succes, or negative for error

I will fix [1] in the next rev of this series. For [2] we will submit a 
separate follow on patch to clean up the wording.

Thanks for the review,

Brett
>> +
>> +     pds_vfio->client_id = ci;
>> +
>> +     return 0;
>> +}
>> +
>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     int err;
>> +
>> +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
>> +     if (err)
>> +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
>> +                     ERR_PTR(err));
>> +
>> +     pds_vfio->client_id = 0;
>> +}
>> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
>> new file mode 100644
>> index 000000000000..4c592afccf89
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.h
>> @@ -0,0 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _CMDS_H_
>> +#define _CMDS_H_
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
>> +
>> +#endif /* _CMDS_H_ */
>> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
>> index 0e84249069d4..a49420aa9736 100644
>> --- a/drivers/vfio/pci/pds/pci_drv.c
>> +++ b/drivers/vfio/pci/pds/pci_drv.c
>> @@ -8,9 +8,13 @@
>>   #include <linux/types.h>
>>   #include <linux/vfio.h>
>>
>> +#include <linux/pds/pds_common.h>
>>   #include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>>
>>   #include "vfio_dev.h"
>> +#include "pci_drv.h"
>> +#include "cmds.h"
>>
>>   #define PDS_VFIO_DRV_DESCRIPTION     "AMD/Pensando VFIO Device
>> Driver"
>>   #define PCI_VENDOR_ID_PENSANDO               0x1dd8
>> @@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
>>                return PTR_ERR(pds_vfio);
>>
>>        dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>> +     pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
>> +     if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
>> +             err = PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
>> +             goto out_put_vdev;
>> +     }
>>
>>        err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>>        if (err)
>>                goto out_put_vdev;
>>
>> +     err = pds_vfio_register_client_cmd(pds_vfio);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "failed to register as client: %pe\n",
>> +                     ERR_PTR(err));
>> +             goto out_unregister_coredev;
>> +     }
>> +
>>        return 0;
>>
>> +out_unregister_coredev:
>> +     vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>>   out_put_vdev:
>>        vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>>        return err;
>> @@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
>>   {
>>        struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>>
>> +     pds_vfio_unregister_client_cmd(pds_vfio);
>>        vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>>        vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>>   }
>> diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
>> new file mode 100644
>> index 000000000000..e79bed12ed14
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/pci_drv.h
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _PCI_DRV_H
>> +#define _PCI_DRV_H
>> +
>> +#include <linux/pci.h>
>> +
>> +#endif /* _PCI_DRV_H */
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> index 4038dac90a97..39771265b78f 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.c
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -6,6 +6,11 @@
>>
>>   #include "vfio_dev.h"
>>
>> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     return pds_vfio->vfio_coredev.pdev;
>> +}
>> +
>>   struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>>   {
>>        struct vfio_pci_core_device *core_device =
>> dev_get_drvdata(&pdev->dev);
>> @@ -29,6 +34,12 @@ static int pds_vfio_init_device(struct vfio_device
>> *vdev)
>>        pds_vfio->vf_id = pci_iov_vf_id(pdev);
>>        pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>>
>> +     dev_dbg(&pdev->dev,
>> +             "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d
>> pds_vfio %p\n",
>> +             __func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
>> +             pds_vfio->pci_id, pds_vfio->vf_id, pci_domain_nr(pdev->bus),
>> +             pds_vfio);
>> +
>>        return 0;
>>   }
>>
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> index 66cfcab5b5bf..92e8ff241ca8 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.h
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -7,14 +7,20 @@
>>   #include <linux/pci.h>
>>   #include <linux/vfio_pci_core.h>
>>
>> +struct pdsc;
>> +
>>   struct pds_vfio_pci_device {
>>        struct vfio_pci_core_device vfio_coredev;
>> +     struct pdsc *pdsc;
>>
>>        int vf_id;
>>        int pci_id;
>> +     u16 client_id;
>>   };
>>
>>   const struct vfio_device_ops *pds_vfio_ops_info(void);
>>   struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>>
>> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
>> +
>>   #endif /* _VFIO_DEV_H_ */
>> diff --git a/include/linux/pds/pds_common.h
>> b/include/linux/pds/pds_common.h
>> index 060331486d50..721453bdf975 100644
>> --- a/include/linux/pds/pds_common.h
>> +++ b/include/linux/pds/pds_common.h
>> @@ -39,6 +39,8 @@ enum pds_core_vif_types {
>>   #define PDS_DEV_TYPE_RDMA_STR        "RDMA"
>>   #define PDS_DEV_TYPE_LM_STR  "LM"
>>
>> +#define PDS_LM_DEV_NAME              PDS_CORE_DRV_NAME "."
>> PDS_DEV_TYPE_LM_STR
>> +
>>   #define PDS_CORE_IFNAMSIZ            16
>>
>>   /**
>> --
>> 2.17.1
> 

