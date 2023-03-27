Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC69B6CAA6A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjC0QUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjC0QTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:19:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB235FEC;
        Mon, 27 Mar 2023 09:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmggAep1f3wQ1NyNbwYsqGoBcOEhenLkylWYLSa9VMjjdPGIc2N4bQsTIAdEa6bmhF2dRio23cZbAjinVsgYDUJzLqy4zdLPRocdWLTokrJC0p4a3qekGJIsfFKMzyIcyCYdCBQ5KNIi9ROXypVcWxn3AjgvnQrCY5zGamnpQa9q0mWOToR2c0AIwR+Auq+VCc7dy5m/CicBF9/9tR8j0eNSp/GYyKjG22/h+YlDkkN5qih/loVnjvGpaICPwR74hlQesB8ReodeBuvC3VD3sCkPVCNSdL9AWXH6PmayJ4pZ/W9o+cIadJsdI/FEY5JjbnC/CCFq1IjFt5mvHycJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xq4WTVrTLDl0SBwK14v67O7eUHnQcsdJKlfkDYvWJ4k=;
 b=ZrztClPRlcENw1twPSPfR+i86IsDZDJ7KQORqTNB+XL/ub+d8Cz6jAWU+fSlPNQK0RgOOLPF2tJzN5c0x5x/u2776UBhRcIKJCKwFXpMg+5xBlFQ9CUuiPD7UTS9jTIDHYoP7gnlaLnYga6MOu4OL82J+MjDuOToxdq4kuVAiCBZyxH7Zt9hRn5sXc35ZmUCzoOa1uTC5w/kHcgMOWHQkG8hdLUSK1cWt0vit9pceM7+/GdKIvOiMTMy6eS4FKFXI61Pvz/Dlp6rbbzBPm26xN6916NdnNc93oXOWFPvFLlF0I/7WUXlSXV09/Q4uOd4L7FQ6jIooL5jlfdUZTRsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq4WTVrTLDl0SBwK14v67O7eUHnQcsdJKlfkDYvWJ4k=;
 b=t9AKpeXbsLAUz27OgbSMySWs0ROpKDxAaZ+mV2fBJHr4kfWiyUdlBBzWUiXb4LfCKU6xZ5jzDhT5dHwVI+tni3PHITE/+0qF36VbS071epEZGyOrDKjCtItCNmSOsLN0UCh8p9Fu1Q2w6FBppNMzwEfe+lLdsHlCb/R0fnArPWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB8350.namprd12.prod.outlook.com (2603:10b6:208:40d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 16:19:03 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31%5]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 16:19:03 +0000
Message-ID: <c273282e-6719-6ea8-bf3b-1d470f4751b4@amd.com>
Date:   Mon, 27 Mar 2023 09:19:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v5 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
References: <20230322203442.56169-1-brett.creeley@amd.com>
 <20230322203442.56169-4-brett.creeley@amd.com>
 <20230324160251.4014b4e5.alex.williamson@redhat.com>
 <57f5d678-a3f9-d812-9900-d8435a44eb23@amd.com>
 <20230324164711.6aeb40b2.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230324164711.6aeb40b2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a3d9bb-209b-422d-a0e6-08db2edefac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrY42zRX5RSd1QJqLBZvYab4K4SxqpBeDw5DJQEMDZlX0p6LuTBvk99Jlo/oTJ1Bwy6GP5sobsZyj0cH0Vp4JgipcLvkop0VaMDv8Ft+nJW5u9q9eaGLLca6cZvxKCWyWTYQnqo0IjPSdUgDEL1Qr7RHcUnUamR1RM8eFgDg33J0LBOsfERHYOTv7eLMiIScI3CrHqAf3vyYZge9HmOML2s7Kbwy3la6GUZHrPVnamtbS2ZLr7ev2ZVmFLwUb0herBV+SxMrBUUKhLY09jLu4FKrpDkcUIE7qGHm6P3RaAKfAD0U3QunJd1LHffXl7+7sRJReGAzEt0M+V+J5MXlpgHCiaTrW6kvlCUJUuzLoZUFW3WMAI7ARTV61nLwLkAeXT2lcUHCPxy2e52bPfgyuuYdaP9MvjELudzYumK54iVAU7DipBAAZWQWCs+cW/9mdjJKdy0s/iCHOEUyxW3N7+cHgMYbPHRlZN6t00zo88PY5S0kbdW3bIvz8xXrHBA7hYDACMeph+tNdZOUPktYVzCUFj9JPvG4CTDAs5Zf3xTtALknjRRkJJGsgGUzQz3AkpCM6spd1ySMr3QgA6pdxanYoeVmhBqVvDu/ocE/7suXYJoObi5tSGEE3p1rNcjKy6nSgGCCIdYx7gZw887gEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(31686004)(31696002)(2906002)(26005)(6512007)(6506007)(316002)(83380400001)(478600001)(38100700002)(6486002)(2616005)(186003)(6916009)(8676002)(4326008)(66476007)(36756003)(66556008)(41300700001)(5660300002)(66946007)(53546011)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlJGS3ptRWZ3VDJmeHZKRWpwNUU4U1BpbjBaaEhDZUl4SG8wcEdvYWplNHJq?=
 =?utf-8?B?bTdVWHBKQzVkYy83YVJNeC9HSnYwZ2VSVUliaXhGNDZrdFpKL2NiODFwQkIr?=
 =?utf-8?B?YWlaTmc2UG4wWlNJTENSMUtlWW9pRzErVGoxZ3BiNWtsNjVSNFJ4Y09ZWkdH?=
 =?utf-8?B?NXhpWWQ0UXZyNnpKbmswNmZuc3gzc1BVZHBzd1ZsZ25uTHBrWDh2K2g4WWlE?=
 =?utf-8?B?bko0dXRqWjVZeS9DYnNLRms3b1g3VnJmWUdZS2V3TVdJVVFxWVNzOFFnOUNa?=
 =?utf-8?B?RVMvcGI3VXlZN2llYkFNdTJnZ2ZYcWo4V3hQYVdmTGVLbWhaQ0VnVUR4cytC?=
 =?utf-8?B?YW9ibWhWMkNDcWM3eWVrN0RoSUhFQ2RSTEhEN1BYT2YrRVh5NExqcXRKWm9v?=
 =?utf-8?B?b09pUlN6RHF0Szc1UFJuUnNlSkwwc0YxdzlhTEhJcHJQQTEwcjdrdUNzbno2?=
 =?utf-8?B?K1gzUG9QNk1ib0tkUXh4YWxETUQ3d1MydTNNT0lFeHg4TXRMb2o3VXc4SitF?=
 =?utf-8?B?QmhDM214ZEVyb1k4QStLckprdFIrVkhkUkI0b1ljNW1aUEtpZWhrb2l6ZTY2?=
 =?utf-8?B?VERIZ25DNW5KVGUzT25BTlphZXNGbHR1Vnl0a2VubDJGZWhVMEJqRzIxc1BR?=
 =?utf-8?B?Ni9pdjl4dlpyS3dodXhPcHJNeTZRN3F4NVhIdGVwM2hyNjFvOVpHd2VFZGhX?=
 =?utf-8?B?Uk9XazhqejhhYU1GU2QwNWY5QkZUa3AwQTdEcys1cmlnMTltU1ZkL281K29y?=
 =?utf-8?B?WGd2MENxRTZDYnFCZ3FUaEpOU2plV01ON2ovTE5jbmRKSTZjVFp1bG5VUjZ4?=
 =?utf-8?B?UEViWmJHQjJwa0dmYXQxK0loaWhnTWNqanNUS2FOcFJnS04yMW1jQzAxWDVa?=
 =?utf-8?B?RkdDSHhDQXZ5NlVhdkQ2am50VHBEc3RhMEVEWmdpWUVkNHZlQUQ5bldGQU93?=
 =?utf-8?B?bk16WjR3dTBHZ1QxTWFORUhsQkZkSUFmaGdDRWpOdW1BWktDdFRvRTJkNjlH?=
 =?utf-8?B?WTJQR0JibnlEdERLZ2xuUC92ajB3Q3k0L3dWaDRaWHMxTWUwb3VyUUpmc25p?=
 =?utf-8?B?UmZFemppU3JiMHJGRzR2YmQ5cjJBdXJSekNiazZJSTJ0WTh0eTlKWmlySUZh?=
 =?utf-8?B?STBIbi9DQVZnd3ZhM3huTldhQjY4Vm1FNzZOOHlTaWNUdEEwVXB2djhaUlpk?=
 =?utf-8?B?RWI3a293Q0tQcUhrdFRvR1dUQ1B6MHJDOFZmSk1ZdVl0MjQzRzF4Vy9zU1Yv?=
 =?utf-8?B?dzZCU01xMW93TlFnaml1WDVJbWR5dnNuUDFYcW10bmtNTTZ1UDJuWWY2Smtl?=
 =?utf-8?B?STROY1FOSlRkQVZ2eXhnVDNoS1hwQzFGOHR1eHhhaDB6RHI2eXd0U01yTXdQ?=
 =?utf-8?B?eEViQng1ZHV3MXpMY0dzQldIN055ck96T2tBbmZzRXNWZGVibW1qVFFJR2ow?=
 =?utf-8?B?VnhScHhHYTNic3FXd3hmNWZnaDhYUmhGSk1pK1A0TktDOC9MVENRWFhmYlJU?=
 =?utf-8?B?cEI4eWpWM1dCZTJQWml4ZE5wMkRFSDE5eUg4aFZrQkNGcEJVK2lYeXdVcExq?=
 =?utf-8?B?MFJSRytabysvWHJsdEhybUVlamRPMytHaytSMEpCNis1NWhuSnlsVnRNYlEy?=
 =?utf-8?B?RUtlWitxbnpxa1k3K0J5V2h6L2YyaGpvekV5NzUxQlQyVE5PQU5xNytOVnZv?=
 =?utf-8?B?ZzJhOVZIS2ZpTzZTY3FXd1BnUEtFZ0l1WStJc210d3hoUTFyNjd3dlp3V1p5?=
 =?utf-8?B?Vk5GeEhaN1UzdC80ZTlkM2NOQzVGNmNsWnZOSm5LWVNTdnpVeXp2ZFRPWkZQ?=
 =?utf-8?B?dU1jL1dnNEFOcUVrM1ZTTUwyMTRkSWdVakhvTkdKWm1jMTZnL3AvbFUyaXdF?=
 =?utf-8?B?OVg0dTFEOXhNU0pOV3lPUFN5dlRZV0lWeWIxYVdJUlpuQ3FkdXI1ZzNaZWlO?=
 =?utf-8?B?RGorWktYMVNpNkdyZmNqU0p3VklDWnVJY3VHNVQzNnZsc21ZMjNQY290M0hk?=
 =?utf-8?B?clp5RXFpL085L2MrbEdEV2lRcXNIdGZWNHFmMXdzQzJBV0EyZ3crQzJ6eXpX?=
 =?utf-8?B?TE9sbW5pb2ZuMjIvMjRXTE5xMk9sYXVicVFJR1JndmpSVzJKb1lFRFJFRUhz?=
 =?utf-8?Q?l/KA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a3d9bb-209b-422d-a0e6-08db2edefac9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 16:19:03.0067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YkPV+sgZwFIjWxBx8vwC70I4Zvrhnpat+HzR9GkP2IyUpaHfgtxEaRB0gfS/7SxZhNAoMcMbCh9dp5iMVMZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8350
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/2023 3:47 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, 24 Mar 2023 15:36:57 -0700
> Brett Creeley <bcreeley@amd.com> wrote:
> 
>> On 3/24/2023 3:02 PM, Alex Williamson wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Wed, 22 Mar 2023 13:34:38 -0700
>>> Brett Creeley <brett.creeley@amd.com> wrote:
>>>
>>>> The pds_core driver will supply adminq services, so find the PF
>>>> and register with the DSC services.
>>>>
>>>> Use the following commands to enable a VF:
>>>> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
>>>>
>>>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>> ---
>>>>    drivers/vfio/pci/pds/Makefile   |  1 +
>>>>    drivers/vfio/pci/pds/cmds.c     | 67 +++++++++++++++++++++++++++++++++
>>>>    drivers/vfio/pci/pds/cmds.h     | 12 ++++++
>>>>    drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
>>>>    drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
>>>>    drivers/vfio/pci/pds/vfio_dev.c |  5 +++
>>>>    drivers/vfio/pci/pds/vfio_dev.h |  2 +
>>>>    include/linux/pds/pds_lm.h      | 12 ++++++
>>>>    8 files changed, 123 insertions(+), 1 deletion(-)
>>>>    create mode 100644 drivers/vfio/pci/pds/cmds.c
>>>>    create mode 100644 drivers/vfio/pci/pds/cmds.h
>>>>    create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>>>    create mode 100644 include/linux/pds/pds_lm.h
>>>>
>>>> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
>>>> index e1a55ae0f079..87581111fa17 100644
>>>> --- a/drivers/vfio/pci/pds/Makefile
>>>> +++ b/drivers/vfio/pci/pds/Makefile
>>>> @@ -4,5 +4,6 @@
>>>>    obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
>>>>
>>>>    pds_vfio-y := \
>>>> +     cmds.o          \
>>>>         pci_drv.o       \
>>>>         vfio_dev.o
>>>> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
>>>> new file mode 100644
>>>> index 000000000000..26e383ec4544
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/pds/cmds.c
>>>> @@ -0,0 +1,67 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>>>> +
>>>> +#include <linux/io.h>
>>>> +#include <linux/types.h>
>>>> +
>>>> +#include <linux/pds/pds_common.h>
>>>> +#include <linux/pds/pds_core_if.h>
>>>> +#include <linux/pds/pds_adminq.h>
>>>> +#include <linux/pds/pds_lm.h>
>>>> +
>>>> +#include "vfio_dev.h"
>>>> +#include "cmds.h"
>>>> +
>>>> +int
>>>> +pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>>>> +{
>>>> +     union pds_core_adminq_comp comp = { 0 };
>>>> +     union pds_core_adminq_cmd cmd = { 0 };
>>>> +     struct device *dev;
>>>> +     int err, id;
>>>> +     u16 ci;
>>>> +
>>>> +     id = PCI_DEVID(pds_vfio->pdev->bus->number,
>>>> +                    pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
>>>> +
>>>> +     dev = &pds_vfio->pdev->dev;
>>>> +     cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
>>>> +     snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
>>>> +              "%s.%d", PDS_LM_DEV_NAME, id);
>>>
>>> Does this devname need to be unique, and if so should it factor in
>>> pci_domain_nr()?  The array seems to be wide enough to easily hold the
>>> VF dev_name() but I haven't followed if there are additional
>>> constraints.  Thanks,
>>>
>>> Alex
>>>
>>>> +
>>
>> Hey Alex,
>>
>> We used the PCI_DEVID (id) as the suffix, which should be good enough to
>> provide uniqueness for each devname.
> 
> But PCI_DEVID is not unique unless this device is guaranteed never to
> run on a system with multiple PCI segments, including cases where these
> PFs and VFs might be assigned to multi-segment VMs.  Thanks,
> 
> Alex

Okay, that makes sense. Thanks for the feedback. We will rework the 
devname and repost.

Thanks,

Brett
