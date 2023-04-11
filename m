Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5746DE1F8
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDKRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjDKRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:11:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F08C449C;
        Tue, 11 Apr 2023 10:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9DYwZvjnrcJ4ZKCzNikazOF57li0338oVgFyBBIzLq6W49/vikJNfmjM4JoWtJ2QD+hRvAQZWV7ISadfyWhVshwb0c2snAadKh4YmM+UqrZUfgu5Ni7npGMtpierFsUdibolT+D/GpgmEoXvNgHZnP6NeKDD57UseNONOqir5TOGHqyJT7z+IAXvPN/7huJaZM6gkTYI941/NhCAju/LEN3/YQRP1IqP3hV6glatYQlU9nKjXdis1WhZ9qdaf/wKU7Cp0E0XNCpwiQZTbJzEzqSa7luGMbPBPWRFbMlzWMv/1Z1C69mdrYfeFr3fwSLWigqcKBeG4sSmf0Ryvky6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnc8MDyzW5HXh1OIhOjOOcS1SBw7i7XxjxuoNLrBWqA=;
 b=lppzTISTYWY5J5VRr9Vsu4VARys7TkreLnq38BwiDxV1CSPIGbOA00U0eUdV+tAU2hE14/2T9reLPh9+u3irNppKVoZwESFAOrnNGuW0ds6RAZeJP6OA5BRN7lKG0xrmXAX5wEYkSn0r05rW49DRvSNNWFeUX8b0yKFemhN6jj9yVX+xgC9QmZYCebN/hNYdfXX976RvRjhB0EK45kh8QqOe3BqNWHtQYMkWiHdonjLPYcHHrF3eWxqI/rDCc2upQdZFNLqb0nn9FmDrOOvHiSZPQcjvWxAw1aFs5q8TnzlhmLA+U7teBj9u0N3Dma//RK27bDqP2J6QwoXVas5kow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnc8MDyzW5HXh1OIhOjOOcS1SBw7i7XxjxuoNLrBWqA=;
 b=RPgLIDDtwkQd6v763nquDCU0pmzhKcw5/rEEVKGOUugh9sre2ZkKCv1bRtcpgkkWX4YbXL6CfYODvs3sQAnBChNN4lXmNWz1C63MLEv+XzQYOVc3ixIUVnvtaDv26ena80XbafrfboCBhYGwHY1F1YdAryFuifFtYblSONa+dfw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 17:11:40 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%6]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 17:11:40 +0000
Message-ID: <c508502a-6f60-120a-c9f9-53911549bc77@amd.com>
Date:   Tue, 11 Apr 2023 10:09:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-4-brett.creeley@amd.com>
 <20230410144149.6a602c6e.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230410144149.6a602c6e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::20) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW6PR12MB8959:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3c19f4-ba3e-4b15-9faf-08db3aafd09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQaSX/GmPR3NDO9Bo1/ATeeh1yAvu8c20yzLeOAeol2gtNfbtKq4XjvKyG3RBGMSauvEMeuAylacKEq8wTdVg7wLC72j3hQMYlIGryXqHT+4B5uV5WC+aKGH0FnuoGW+mZVU/fwICc35eLRR7zvbeGdxrjGdn5/7B6EUl2a2c1prSRRjMgpB8q+FBhCBI9eg1Y+R3PJQ4xDZfvxU0b0OsLbfW9Zc+8b908saDsCb68n7bo7alafNegVViNumTtrjL7X57RuiQ1fjCbcmUiGKdR6SIPq7oMHPQxRF1m4O7bzvLEK66gZT5Mg+xlsDPqAuwjQFIX8CD22ny1uwVq5ld0DwwEcbgDpvgzbRlRYvBWzlmyF4XeXR1iOwLDcCxO7qHFClW2xXF79uqCYhgvqE8CUdMHq7ZYNpLUilb4/5ohpa5zMWVF0fH0ujGhHZGMBHijpRfPiHuMp/JXFmcJcd43ZINg28LLvuhXDkmEoaivUjH5noR2unEeHYGV29+k/Vw1kX6uAHapwMgTunArnu26kAM+qVsrT81kpmTLqEoiGrvD/yfg0zJDxqn7hyy0S94Blu2gOJPBXTLzltPSWTBOIClvvrpIPFXy64IRk5ZN3vNOwv1yZ/DFsoAKdhJixK00VoasxkP2s6zwbpBAhwpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199021)(31686004)(478600001)(36756003)(83380400001)(38100700002)(2616005)(6486002)(316002)(6512007)(2906002)(6636002)(110136005)(6506007)(53546011)(26005)(186003)(8936002)(66556008)(8676002)(66476007)(5660300002)(41300700001)(66946007)(31696002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkpoVmFRYkFaQUNMVnI5NGZCWXp2b1N4dUVzTm9ORU11d1JSeDJ5bkpjeVdz?=
 =?utf-8?B?dzh4VnplYit2bDNGeUkrV0N0MjVuZjJpUjFyUFkrb2xOQ2IweVdMWllRM2JQ?=
 =?utf-8?B?V2doNnh3K3g3d01YSUYrc3NtVWhSdVVzUkkrL2hDZEpFR0tZczJCL0RzeFdw?=
 =?utf-8?B?Q1crTHhrWjlYdGdQcjJtVng1ejBvaDlHRnpWM2NNQmIzOVdYZUQybTVKSWp6?=
 =?utf-8?B?TmNISjBOYVZHaHNsR05PUkxJSGJ3YW9aV014WnVIOVIzbS9sUmNub1lPR1dB?=
 =?utf-8?B?UTVJWXBRMCt4ckxld2padVNqbEVjMTNaRzdSekhDbHZTakxoT1h4c0dEbXZT?=
 =?utf-8?B?U2RUeTFxbGZ4SmNIYmQ3ZFNORkQyNkovaUZSODBuc0hXTWlkK2lrY3NUNzlu?=
 =?utf-8?B?VGZmTGlVTzRRVks5NFVxUjFDemllZU5IclJDR2lxdkQ4Y0FHWUpqMXpDLzBT?=
 =?utf-8?B?cUNYZ0tpMldNSXVEQUVQSHFQV1Jxd0MxNU12WTNia0N2MDdNVmg4OG9iZE5U?=
 =?utf-8?B?dXJUVWhwQXowanBKQjZHemNIemxJQ2I2b2FTLzF2KzduREdOVUI5cVlZUGIw?=
 =?utf-8?B?MDlaK3QzNG43UXIzMkV4Y3NlVHJYdEtlTjVDTWpPdXZEOGZBcEFlNkZBOUFm?=
 =?utf-8?B?RWpwM0dHZVUrQmhZSy9NMDYybnV3VmtlQVVHVVdqOHlKMlVyTlZpV3Z4MVhL?=
 =?utf-8?B?MVo3WjVURDAxai8vOFY4U1JCSTQ4aXlHb3M4eGtuMDJvdFgyNmNra2F6MVVM?=
 =?utf-8?B?VmV2TnJqVUdwandwdFJDcy9oRURjNk5ISG5lYXg3ZlBMbS9qcEl6SDE3bFJh?=
 =?utf-8?B?TjIvM0lEUWhDcWNKUFNEVTljZHBTR3UwWDFDSjAwYzdGYmowSHE1dFJKdEhX?=
 =?utf-8?B?d1kvdFh0WWVXajBKODZLbDFxbzNYNm5SZTR1NjlkTDV4b2prUFdTU2NYOW82?=
 =?utf-8?B?eExOOVU4cDVFVFIrTVExT1ZGQ3BITkNlbHRuSFJxNDBDUmdMUGNsMTd3NE5S?=
 =?utf-8?B?b2k5NTlJVG5CK3NUYXFCelYwcGFoL0hZSjN3S05lL2dpNVdnZDJHYkRFbVoz?=
 =?utf-8?B?R1FhR2g5cUR1T0dKM2t5NEZKd1U1Rk5xcGluUC84RVk1dEJiVWdrb3hkanJG?=
 =?utf-8?B?WitNOGcxa2htOFErTWk1N1Vwa2VhVnFYU0ZtK0M2cmtPQStReHBLN1dqMjlk?=
 =?utf-8?B?aEs0ZFJvWkROcktFKzVUb1ZXZlJydHJISzkwS2JTQjU2SDRaMmZ1K2trU2R6?=
 =?utf-8?B?ZVNqK25NMmZ4Yjc5NWl0ZndhN2pmKzk0RFczZDVhTjNnOGphbVh0VHNSZDBv?=
 =?utf-8?B?bnlOeFRqdklTZkwvVHZTMTRFZW1wOFp2cE1kTUlOeEZHZkd0dGdLeXNwVmwz?=
 =?utf-8?B?MC9wMnNUUVZHV2YwSXZzM040eklWZC9mRGRGTzk2VkVpYzgvSy80UDJFcnJz?=
 =?utf-8?B?YnpONitXbjh2b2lLTlgzaHpmRDQ5dVFONE9MTURtOENDeFlXampYOFN2QWFT?=
 =?utf-8?B?TlFIaEN5WGtXQ0VSOGt0Rm9qbVdlWXRyQlJOa2FKMGQzNDBzZ2hpMW9JcXBn?=
 =?utf-8?B?SlRUb0pHRTJVMEorVDAxYmFZQUZPSUtXQWRvMTY4WGhYTXZGL3FSaVZzZ1Rr?=
 =?utf-8?B?WHlOZGxZZjZIZkhWeUU4UW83MUNJZFk1RjFzRm13S2FsOEw4dXBBQTI0KzV0?=
 =?utf-8?B?TUd2UzdFOElPd0VIczY1WlgreUs0S3l1bHUvOTA1eXluL2lidEEyZ201WUZM?=
 =?utf-8?B?RHMwNncxMERjajdjNytab1VYU2lKaVFGNFJMU212TkMrVTFZdHRFREJWbDh0?=
 =?utf-8?B?a0lRd1BQeTZlWnJPMEV5Y0pVempnT0t1aVJYM2hzRFdabUZsMUVubVBDOTcy?=
 =?utf-8?B?S0RWQzRxQjlEbS9oVkhKSUZtcWpwc203S3BEM2VNblYrRWpZelBGeTdJanRX?=
 =?utf-8?B?VEl6V0toT1d6WVBRVE9hdDJoZ1FKMHNzbjNJR1hnSCtRcmVpUGNVcWJHRFBC?=
 =?utf-8?B?bTkwaWtocWsrRjVUS2xtMTFJSnNadWMwT0lhWUVwZzhqRklVbnVIV0Q3NjR1?=
 =?utf-8?B?OGRiQ2dNaEkrbVRjQ3VIc0I0M2c1RDAxbER5SWNaWlE5ZHgwZitTd1ErbzdM?=
 =?utf-8?Q?9kHGcgvJm8OcOxQuS4bjSHtOF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3c19f4-ba3e-4b15-9faf-08db3aafd09c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:11:39.8342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FtKZbjrRnIiBJixBoJ7/ZlI1jxJ9NfxN6owfap52bcA6tzzewUFuCfUrKTtZ3cFscIkvFqwsiypjQ10//QeEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/10/2023 1:41 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, 4 Apr 2023 12:01:37 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
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
>>   drivers/vfio/pci/pds/cmds.c     | 69 +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/cmds.h     | 10 +++++
>>   drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
>>   drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
>>   drivers/vfio/pci/pds/vfio_dev.c |  5 +++
>>   drivers/vfio/pci/pds/vfio_dev.h |  2 +
>>   include/linux/pds/pds_lm.h      | 12 ++++++
>>   8 files changed, 123 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>   create mode 100644 include/linux/pds/pds_lm.h
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
>> index 000000000000..7807dbb2c72c
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.c
>> @@ -0,0 +1,69 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/io.h>
>> +#include <linux/types.h>
>> +
>> +#include <linux/pds/pds_common.h>
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +#include <linux/pds/pds_lm.h>
>> +
>> +#include "vfio_dev.h"
>> +#include "cmds.h"
>> +
>> +int
>> +pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_comp comp = { 0 };
>> +     union pds_core_adminq_cmd cmd = { 0 };
>> +     struct device *dev;
>> +     int err;
>> +     u32 id;
>> +     u16 ci;
>> +
>> +     id = PCI_DEVID(pds_vfio->pdev->bus->number,
>> +                    pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
> 
> Does this actually work?
> 
> pds_vfio_pci_probe() is presumably called with a VF pdev because it
> calls pdsc_get_pf_struct() -> pci_iov_get_pf_drvdata(), which returns
> an error if !dev->is_virtfn.  pds_vfio_init_device() also stores the
> vf_id from pci_iov_vf_id(), which requires that it's called on a VF,
> not PF.  This same pdev gets stored at pds_vfio->pdev.
> 
> OTOH, pci_iov_virtfn_devfn() used here errors if !dev->is_physfn.  So I
> expect we're calling PCI_DEVID with the second arg as -EINVAL.  The
> first arg would also be suspicious if pds_vfio->pdev were the PF since
> then we'd be making a PCI_DEVID combining the PF bus number and the VF
> devfn.
> 
> We've also already stored the VF PCI_DEVID at pds_vfio->pci_id, so
> creating it again seems entirely unnecessary.
> 
> Also, since we never check the return of pdsc_get_pf_struct() I'd guess
> we take a segfault referencing off of pds_vfio->pdsc should the driver
> bind to something other than expected.  Validating the PF drvdata
> before anything else seems like a good first stop in
> pds_vfio_pci_probe().
> 
> It's also a little curious why we're storing the pdev at all  in the
> pds_vfio_pci_device when it's readily available from the embedded
> vfio_pci_core_device.  Thanks,
> 
> Alex
>

Yeah, these are all good catches and I'm not sure how I didn't notice 
them before. I will rework these bits based on your feedback.

Thanks,

Brett

>> +
>> +     dev = &pds_vfio->pdev->dev;
>> +     cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
>> +     snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
>> +              "%s.%d-%u", PDS_LM_DEV_NAME,
>> +              pci_domain_nr(pds_vfio->pdev->bus), id);
>> +
>> +     err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
>> +     if (err) {
>> +             dev_info(dev, "register with DSC failed, status %d: %pe\n",
>> +                      comp.status, ERR_PTR(err));
>> +             return err;
>> +     }
>> +
>> +     ci = le16_to_cpu(comp.client_reg.client_id);
>> +     if (!ci) {
>> +             dev_err(dev, "%s: device returned null client_id\n", __func__);
>> +             return -EIO;
>> +     }
>> +     pds_vfio->client_id = ci;
>> +
>> +     return 0;
>> +}
>> +
>> +void
>> +pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_comp comp = { 0 };
>> +     union pds_core_adminq_cmd cmd = { 0 };
>> +     struct device *dev;
>> +     int err;
>> +
>> +     dev = &pds_vfio->pdev->dev;
>> +     cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
>> +     cmd.client_unreg.client_id = cpu_to_le16(pds_vfio->client_id);
>> +
>> +     err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
>> +     if (err)
>> +             dev_info(dev, "unregister from DSC failed, status %d: %pe\n",
>> +                      comp.status, ERR_PTR(err));
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
>> index 5e554420792e..46537afdee2d 100644
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
>>   #define PDS_VFIO_DRV_NAME            "pds_vfio"
>>   #define PDS_VFIO_DRV_DESCRIPTION     "AMD/Pensando VFIO Device Driver"
>> @@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
>>
>>        dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>>        pds_vfio->pdev = pdev;
>> +     pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
>> +
>> +     err = pds_vfio_register_client_cmd(pds_vfio);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "failed to register as client: %pe\n",
>> +                     ERR_PTR(err));
>> +             goto out_put_vdev;
>> +     }
>>
>>        err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>>        if (err)
>> -             goto out_put_vdev;
>> +             goto out_unreg_client;
>>
>>        return 0;
>>
>> +out_unreg_client:
>> +     pds_vfio_unregister_client_cmd(pds_vfio);
>>   out_put_vdev:
>>        vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>>        return err;
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
>> index 0f70efec01e1..056715dea512 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.c
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -31,6 +31,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
>>        pds_vfio->vf_id = pci_iov_vf_id(pdev);
>>        pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>>
>> +     dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
>> +             __func__, pci_dev_id(pdev->physfn),
>> +             pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
>> +             pci_domain_nr(pdev->bus), pds_vfio);
>> +
>>        return 0;
>>   }
>>
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> index a66f8069b88c..10557e8dc829 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.h
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -10,9 +10,11 @@
>>   struct pds_vfio_pci_device {
>>        struct vfio_pci_core_device vfio_coredev;
>>        struct pci_dev *pdev;
>> +     void *pdsc;
>>
>>        int vf_id;
>>        int pci_id;
>> +     u16 client_id;
>>   };
>>
>>   const struct vfio_device_ops *pds_vfio_ops_info(void);
>> diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
>> new file mode 100644
>> index 000000000000..2bc2bf79426e
>> --- /dev/null
>> +++ b/include/linux/pds/pds_lm.h
>> @@ -0,0 +1,12 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2022 Pensando Systems, Inc */
>> +
>> +#ifndef _PDS_LM_H_
>> +#define _PDS_LM_H_
>> +
>> +#include "pds_common.h"
>> +
>> +#define PDS_DEV_TYPE_LM_STR  "LM"
>> +#define PDS_LM_DEV_NAME              PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
>> +
>> +#endif /* _PDS_LM_H_ */
> 
