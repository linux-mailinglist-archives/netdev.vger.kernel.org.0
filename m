Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250706D6891
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbjDDQPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDDQPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:15:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D273C39;
        Tue,  4 Apr 2023 09:15:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfSp/7JzCwXe+62+fx7mSiMAAuBTHL6zQ5pgr+ovBfQO464JFx6YgzPSYHHh+uveCmdCA18jdl8Cc3WTr772wUASOM4gBAFpK1aGmsuMoSiiWhnps5IkLVHYgrhB2atMWtxX4DvvUuHT6AwBNKSSCeijXIlG2u8Nop7+wYLpx0pZM9yKdtbaToD7skK3SHNvmh+ML/AHn8XZQofovXFeeJgnmcOEz14YVlg4GZfrkjCI1mnZTvaOSqIxOTVT+YfA+OdnJEXJLj5k4+6Q7h0tnVCKKSLOweJpl5I612EiKT8t/9goBlVbW85NALu9Nhxi7pKqoeVX79ZhmYvksceGwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hZ4tdTbAC164tFyGRjpYl58qRf96eu5E/xkwE4FR+c=;
 b=BmAMXj5V8WMe2WanZtVGucjPpyz/mO/jkvdCXUli3Vr6dZgnddv+V7VfStc/rUOoRKwIMp2hkWChfvwtvGT0Oh3X3Wi8sT/KNmYzGtlByvY7zW+Mq6DiYJiYspjVf0dCyElbZW/v8XeSWiPkJ/pOdKo+JSgDI6DpAQ84ysNnd4UCZN9v5JIUuDm1usIXinh0fuc8Tbtojg3tzkehQZ+OsNvZs9zLN3UuVeMVYeV8WZfgaXvOssUNtC769Zp3eWCjzhm4k8EZiQIfK3JmmDeLRxcAmbwDd/c674Vz1WqMQQ3/lpquJmouxfhKJhvv9tBO2gpsbKhf9nmUK9Th0M41+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hZ4tdTbAC164tFyGRjpYl58qRf96eu5E/xkwE4FR+c=;
 b=IFsY5272cZ5IF2v7IoemEz0q74tOtcP+fbhQ652MvbtDHhXZif9sLcAyaKRfoZp0oA9pDPzCapkxec8J50eIrzK0pJ2GkyEDrBj/SBrL9r+RsFQPXe+EfUnsRrGYsGh5V548aU4yodUuJgoylyzrR/4vYz0K/OH82VH1efnzzl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH3PR12MB8936.namprd12.prod.outlook.com (2603:10b6:610:179::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 16:15:30 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31%7]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 16:15:30 +0000
Message-ID: <9cd3f43c-0203-9d96-b45b-c303b40c8689@amd.com>
Date:   Tue, 4 Apr 2023 09:15:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Cc:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>
References: <20230331003612.17569-1-brett.creeley@amd.com>
 <20230331003612.17569-3-brett.creeley@amd.com>
 <bfef568736b34c3988bbc463b1be91ce@huawei.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <bfef568736b34c3988bbc463b1be91ce@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0363.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::8) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH3PR12MB8936:EE_
X-MS-Office365-Filtering-Correlation-Id: a465ec56-08b2-40ec-569e-08db3527cf0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ehkh5+ZxqdMudWYrfkNrCyLvYJ82qP9+EaTel0yOjpHCuoq6oM0NxHQSZUH6ae5ZUk/UjXWzWYrsb6XNyIg5WKSgI2r7vfSN03CCl/Ksg1sUUeN9NBynG/y0Q/VoJnCBs0QaV7uv/+TFrofEzuLjZZGtjQE6v7lTfvuPVqK4haq5dP55e3mWKpNxZYYJetMT6Ywmix6/Voecvs6FJoO1vMC5gm/FGfWpigfNWCQn9K9+REEaFEegWDFoRkU7BFqRte4skyaf5e38YmgMNEwZOZvMiGMTF0/MIEZ6NFqmbY3UJhHRs0CrYzUI6fsH14dCB5+mRwKKhATOcc3yZCs9TCHnzirA9+ZDDNSNw7L/KZ0Jf1TRDtoTgFm7wMDWqP1bNnP4HPOIu9tCmBkc28UuEBOFrhOlfkys/EKC7ffJRXK247DIDIhQmn7gzBwWpm5IYPLFPkOWIZcvCe4Tt5zLS/UMQzabcpXgH95bHTURODFHAKSVeE1O0ZDbGJ6GIx7gkEVC6w5giSTxetl9ZIpXO9ONuVsxUPRAxLge7W5GNJ/8qkKZZPgok9L/TUs7BRS4fB3saANG50mQugKfTPqk113MN2IPwykYx/3p+lLbZuNk0FDFFj6+h2OpKMmgVyABs0gX1sp3VOoFL76cInE6oA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199021)(31696002)(36756003)(2906002)(31686004)(2616005)(6486002)(186003)(53546011)(83380400001)(6506007)(26005)(6666004)(6512007)(66946007)(66476007)(66556008)(8676002)(4326008)(478600001)(41300700001)(38100700002)(316002)(54906003)(5660300002)(110136005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVdLUVBMYXFhNXQ2SXZ5UjYwVW1NY2Q0MHVKbk5kUXhCUUFUc2UwR2N2NzVC?=
 =?utf-8?B?amhxcWV0ZVhmMDNwV0JaLzQvSUJndmxvdk1keTYvRUlHWnd1Q2FDQlAzak4y?=
 =?utf-8?B?UnNJZHN1VkxmVUR6aFN5SUhCbDhwQ002M3BuRklqcXkrc3pRN3NXb0NhYnBN?=
 =?utf-8?B?bDNYcnFPYU9oTEVYbFF3SWlJQjhGbnNseDFQMjVlWmxSK3BlNlRaNUJONURs?=
 =?utf-8?B?VGdCWWcrRlhyYmg5dGZjRWhKZmRSQ29IcEJBWmdnSUx5RHF3bXhVK3pMUnov?=
 =?utf-8?B?T1daUlVWS2xIY2Z3eENDL0d5MW1QR3YycUVsVS9LR3R6QmwzK253TDh3THZX?=
 =?utf-8?B?Z0wxb0xKQjFycjBkM29kRkhSVnNINmtCZGNzQXcwOWh5ZlhNL1g5UzlyTGl1?=
 =?utf-8?B?L3VpMVlPdVhJNnRkaXluVUYrai9UNTUxeVhGOWJpaDJYWkJubTZpczcyK0FK?=
 =?utf-8?B?NkZncGZGaXZDa0dLWmx2RDU3QUllYldncVBGZ1hWZ2prTzdBQ0RydGRjVUdY?=
 =?utf-8?B?QTdlQjREU2tMQzVuZ1hKY1FIVTNSVzhnNldJeTVzU3ZxVzRlc2dhTVNlb0pZ?=
 =?utf-8?B?Vk1yanFEdjJSWHRjSlBpNG1FSlFiZFRxZ3JGelU1UThEbE96bmhMWVlwc1Vl?=
 =?utf-8?B?U3dDaE8zOFIwbEt1WkdSZzBsOVhSQ25mMXg4NmxZcTBTSm5RVXVyN2liN0cx?=
 =?utf-8?B?eVdzek9HbUkyVGtqYkxFam1wYytUcGNnRmMwczNLQWQzQjNvY0d1eVZCUXNa?=
 =?utf-8?B?alFRL001aXJQSkkyOUo2WW14MW1oVGVyeUIwcmpUMmlzaDl1MkJHL0U3b3cy?=
 =?utf-8?B?dnNla1AvYVYwZ2RDdlpTbEVMVXRVM3dvdEQ2RU1jMmFtSHFpc3h0SFdCNUNS?=
 =?utf-8?B?cTR4SkVHd0VjMk53LzFSeEZaYmJ6Ym5YWG0xRHF1SHZGOU1xVlprZkxzazh6?=
 =?utf-8?B?eXFVa2dHUy9qYnB6eXRBZktaclZxc3RCdGVycmJ1UzRmMmp0T2JRUFZzTjRT?=
 =?utf-8?B?TUhwRHFxbDljbUVJN0lmN05iMG5RT1l4SjhrdW94RmpyQ0JZZXJOMFFQVnVn?=
 =?utf-8?B?R0dneUVxREpGQnhPMzMzRVp1V1FlZ05iY2FVNDRyeVRCaFFiQUl1TWJsL2NJ?=
 =?utf-8?B?dFFkYXBXanpZQjM4Ny9tQlVXR0RPeVpQSkpLdjhmbEh1M1IxUVVwRHBwbkRD?=
 =?utf-8?B?RVlRaTNBaEJTQktvLzhmWXFCSGk1MDJTS1FTVStEdVp4NDVyMHZENU1iN09m?=
 =?utf-8?B?WWQ1dEpvNkNCbXpERnVnNnRxWG9hTlVQUHBneGN5MHRYMG51QitZbmJCOFVi?=
 =?utf-8?B?eFI2WlA2NzBKaUxYUTN5V2FDclZCWTJ6YTNvaVl6cFVFMUNkMnhEbERXdTY2?=
 =?utf-8?B?bHh5dEtwei9GK1FsMkttSUhWMGQ2NmMzU1g4TkplYmRhS2dCRStOeWtXdmt3?=
 =?utf-8?B?ODFlWFpXV1k3cW0yZnVKVzQrbDdMbjR0MStzRVlzNy9TbGFqaXBLQnJOMEN1?=
 =?utf-8?B?YVJhMUFBeVNBZHRFK0thTnQwTnZ3RE1KUFpvRHhENUZFV3hobGcyc0M1a2tI?=
 =?utf-8?B?R2lrMWdvbWZHbGxFTEptWWlvSGM1amY3RWp5ZExpMGtqd2VKTnQ0MlZoZWNK?=
 =?utf-8?B?U1J0RVg0bklwUEs3enB0b1dTVWpTeDBKalVRaXdndENtWjRwMkJWSDhncU84?=
 =?utf-8?B?cm5EU3JZMjRWdklWQU1WQXBNZDRmK2UreXZpS016d2hSanBFV1VIcTRWTHM2?=
 =?utf-8?B?MEdSNCtZZWFTSVVKU0E4T1R6YWkxcVo3NzhFYTJTc0p0cHN6Z0Q1V1RhNGpj?=
 =?utf-8?B?aktRZmVPdThxc2I3UzU1enBrdS9jVmNGeUhCTmN5Tm02QmRtN2MyS2U0Z3RC?=
 =?utf-8?B?V2ZCZEk1YzN2NEZkUlRnalFjUmpBSkh1NmhYeUcwWjlFSlZ5VnZsZy9WVlE2?=
 =?utf-8?B?MGFKc1NwMmhjNkpmaXlNTFlQbGY2aHNMODhUK3NMbG1abmhYWFZPRXlHc2U5?=
 =?utf-8?B?bU9mUktvQ2o5RTFMMUQ5T2IzZTkydmZoNTFkeVdLVGM2UTN4U0FrVlMzVVdx?=
 =?utf-8?B?Q2RmZmJWTmYrd3FUUjVxUmJLMzREd0ZkZ1BjaHB4eE9vWm5nOGk3YkJybXhZ?=
 =?utf-8?Q?mRuFSL2UhT2I8BdnZRpOUrbj9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a465ec56-08b2-40ec-569e-08db3527cf0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 16:15:29.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGZRmIotSL9pFRjNUoMnqvS+5eRL5O/aAMN+FkSsMVRJaTz2Co10mixklac1Tc3Qb/w/wrzL8TOp9nPPF4syrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8936
X-Spam-Status: No, score=-1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/2023 8:36 AM, Shameerali Kolothum Thodi wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> -----Original Message-----
>> From: Brett Creeley [mailto:brett.creeley@amd.com]
>> Sent: 31 March 2023 01:36
>> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
>> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> kevin.tian@intel.com
>> Cc: brett.creeley@amd.com; shannon.nelson@amd.com;
>> drivers@pensando.io; simon.horman@corigine.com
>> Subject: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO driver
>>
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
>>   drivers/vfio/pci/pds/pci_drv.c  | 74
>> +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.c | 74 +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/vfio_dev.h | 21 ++++++++++
>>   5 files changed, 179 insertions(+)
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
>> +
>> +pds_vfio-y := \
>> +     pci_drv.o       \
>> +     vfio_dev.o
>> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
>> new file mode 100644
>> index 000000000000..5e554420792e
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/pci_drv.c
>> @@ -0,0 +1,74 @@
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
>> +#define PDS_VFIO_DRV_NAME            "pds_vfio"
>> +#define PDS_VFIO_DRV_DESCRIPTION     "AMD/Pensando VFIO Device
>> Driver"
>> +#define PCI_VENDOR_ID_PENSANDO               0x1dd8
>> +
>> +static int
>> +pds_vfio_pci_probe(struct pci_dev *pdev,
>> +                const struct pci_device_id *id)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio;
>> +     int err;
>> +
>> +     pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
>> +                                  &pdev->dev,  pds_vfio_ops_info());
>> +     if (IS_ERR(pds_vfio))
>> +             return PTR_ERR(pds_vfio);
>> +
>> +     dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>> +     pds_vfio->pdev = pdev;
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
>> +static void
>> +pds_vfio_pci_remove(struct pci_dev *pdev)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>> +
>> +     vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>> +     vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>> +}
>> +
>> +static const struct pci_device_id
>> +pds_vfio_pci_table[] = {
>> +     { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO,
>> 0x1003) }, /* Ethernet VF */
>> +     { 0, }
>> +};
>> +MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
>> +
>> +static struct pci_driver
>> +pds_vfio_pci_driver = {
>> +     .name = PDS_VFIO_DRV_NAME,
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
>> index 000000000000..f1221f14e4f6
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -0,0 +1,74 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#include "vfio_dev.h"
>> +
>> +struct pds_vfio_pci_device *
>> +pds_vfio_pci_drvdata(struct pci_dev *pdev)
>> +{
>> +     struct vfio_pci_core_device *core_device =
>> dev_get_drvdata(&pdev->dev);
>> +
>> +     return container_of(core_device, struct pds_vfio_pci_device,
>> +                         vfio_coredev);
>> +}
>> +
>> +static int
>> +pds_vfio_init_device(struct vfio_device *vdev)
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
>> +
>> +     return 0;
>> +}
>> +
>> +static int
>> +pds_vfio_open_device(struct vfio_device *vdev)
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
>> +static const struct vfio_device_ops
>> +pds_vfio_ops = {
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
>> +};
> 
> Hi,
> 
> Any reason why this driver is not providing the default iommufd
> callbacks(bind/unbind/attach) ?
> 
> Thanks,
> Shameer

Hey Shameer,

Thanks for pointing this out. It seems that we missed this. We will fix 
add the default callbacks the next version.

Thanks,

Brett
> 
>> +
>> +const struct vfio_device_ops *
>> +pds_vfio_ops_info(void)
>> +{
>> +     return &pds_vfio_ops;
>> +}
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> new file mode 100644
>> index 000000000000..a66f8069b88c
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -0,0 +1,21 @@
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
>> +     struct pci_dev *pdev;
>> +
>> +     int vf_id;
>> +     int pci_id;
>> +};
>> +
>> +const struct vfio_device_ops *pds_vfio_ops_info(void);
>> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>> +
>> +#endif /* _VFIO_DEV_H_ */
>> --
>> 2.17.1
> 
