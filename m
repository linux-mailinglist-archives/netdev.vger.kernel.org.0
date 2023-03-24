Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60C6C8879
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjCXWhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjCXWhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:37:08 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4A1ACC1;
        Fri, 24 Mar 2023 15:37:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTv3LEwS7aJ1oD1wFi3vWQjeodiEBYIXttan8GNSlWIT5YJZeUlAZIn+RkO1A57f2ZzQMLSVT6Wxavz+lRvgpAdf91KE6YalfR0U0Srxz/gFsoHqrdPV1/fMFArpYfqFpO3Qrh7uGqnTNtEJYmpU+6FtBFHIf4n2VXvTe9FgHFHuECn/NZmkXviG0qEk4vhnE+LTWOaci/T5Mhn7UQQzHNbioGyvPBnwgFOc80ZqxHMX1rrNmWRJeafknQIE2LUPhPem3EnroCd1RzyhlkdoQHjtuQuaXoZfpoCsWKUhpV0Ev2GvluWtHpS70D1S8OCo3BgTPbpvpC41T77/qPIjhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTUYJ2FHUSN3wS959PDonvrwohUS2OKzkSo11WFRQO4=;
 b=KK785aMth4Ez5QrpKGRIZO1u5pVirM15NqDE2bGQNbuTApBwxUwoyfXcXYX+0HVdwv3VPfFK74IePgytIAu2U7AfacFahszPivFongHGUUtI9DihtAH1EksGCR11USrqUShY3dVGKJxEy7HKrj8/ffuR6O4vMNJn933e5mKDftBmAI+Z1ZfcKKZRWHaLDSiaoRwcwFLaEDtvNS1Vww9/VFpFcZStYBVYouyKLPJCidO2R7qmL4MltH1lq1RTfYarys2Z+mt6JvTCChSp9+YmNVyk9n8UqhhLi/bClIzBNJsnTRshc9K+BQj0YqPLYTaqq4YBeDaJScwPxNoGhxdUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTUYJ2FHUSN3wS959PDonvrwohUS2OKzkSo11WFRQO4=;
 b=ttM/ZAfSKM68JBj587hf8mlSGBMw5lwnv0diMbNrbVR/mdfFzx1SBIZUBW3aKKM3bovpXYovZ05kpOpyZYYvDf63DMAmR5mNyecPqMWoclQ+7J/dQoIYn9E7UzEGrE4ghMIIpNN0dUr9bpOw5vUsizMuLHdLT9pYMMheSDM5MBw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH3PR12MB8710.namprd12.prod.outlook.com (2603:10b6:610:173::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 24 Mar
 2023 22:37:00 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31%6]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 22:37:00 +0000
Message-ID: <57f5d678-a3f9-d812-9900-d8435a44eb23@amd.com>
Date:   Fri, 24 Mar 2023 15:36:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drviers@pensando.io
References: <20230322203442.56169-1-brett.creeley@amd.com>
 <20230322203442.56169-4-brett.creeley@amd.com>
 <20230324160251.4014b4e5.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230324160251.4014b4e5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:a03:167::24) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH3PR12MB8710:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ad56bb-c9a7-4bd2-e2d7-08db2cb84858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0n2gEgVvf8DJRmXC4l96yBPA6hpPtdkqciUTwT3cBpiirpy4tMv+AsSQRUbRk/P+8JZFWKOYSskULln92CHJl4tsb8dCIDS5fWlYrjkZ2NYG35/vuc7Z0Tj70ao6PFZqmeVKVXnSbg1SP4FrH8GPNIHhfNhi5e5onFgHCcKt8B2DSwWBigoItSHl1VWczV93U3yacMjNRlDzNqgbjefHKFO+f1YSVZP+t5KNEpwieVMoLLtmbNVTApn9a6b5S5oPir3E+pdREszclfoh++4HNA69tlFx1rU8PFQfrYGpgYk1pkhspHrizgOH4I2ff/Kzy4maevgWu2duXmThrFNmv8dxK8Etf0RzoLqSUMz5H0ZUJKVDaA7ukea9k2fTciHZwCQ9VO8kQnfExjgZkYENuN7DkXPOZ0xg9pH6D/z766Y03EMt54sBIvaFd4XHMUqBKSsTgazatJVhhskVRK21DA43zH22Kkh2+Flcy+dz9nfv5KJ8ISor5Y8J41FZ7C9vYgq0cTviF2pUML4hUTQGDk3ZPyeFO4/tnsx5yrh8tOVln55BNOfxNUlHUHyQ70BHZjSTcJJlPEkFDHeIsJ7wZiPYlMx64F/QmGUxsFWSGHwwEHV4cVBLANR5F9mwl7soNeJ/lWZvm2l6RHq+mhKoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(36756003)(31696002)(6506007)(83380400001)(66946007)(6666004)(26005)(478600001)(38100700002)(6486002)(8676002)(66476007)(8936002)(66556008)(4326008)(41300700001)(2906002)(31686004)(6512007)(186003)(53546011)(5660300002)(110136005)(2616005)(6636002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TURFUkxqdklISkIyTjEyNkVQZUFzVnhZR1ZvTmRjWHVIZEZrY0lqa2RzQVBn?=
 =?utf-8?B?TkhuT2I2R2VRaVZad0lpUkZXWjhjdTEySWo2SGh5L0wzcGliQjQ1VDVyZEVj?=
 =?utf-8?B?MXdQNHZ6K1NaU2x1WmNONUYzYm1lK0FBQzFUWS9VOUMydUdUVlhlWkZFOEx2?=
 =?utf-8?B?MnQ5NVkwRW5jbDI4UEZlS2VnNEJERGFBWG5Wc0ZaYzBncXNRYVVtQUhDUW1s?=
 =?utf-8?B?YmE4UW51WlpDRWEvK3p0Z1d1bVpOeEJSK1ZERXBSVEF5cHMyeXVONWloRFNW?=
 =?utf-8?B?US9XM1dFSHE0MXRIYUtlODhtdURJbDl1UWl0YUFnWElONHVMRWowK2RwQjhs?=
 =?utf-8?B?YURrVXRvcDI3YTV0NmZTeHkvekhWc1lDSlZRYSs3bGJHUWpGWjFody9sa1ZX?=
 =?utf-8?B?SVNOWTk4REptdWJKWlVBdzZFWVFzdHJBSEdqM05hVFNTMWVSWlhsaVNzY1RD?=
 =?utf-8?B?bUp4RGcyTGxIdnJpbGcwbG80K0VNM0FHT1ErWWpScE1KenBlOHArRkZScWlR?=
 =?utf-8?B?RGlXK1gxV0p1eXh6S0RPRWRVcllTS3hFcWJCZmM2alFHTURXcEVVNUFGMDkz?=
 =?utf-8?B?Zk5XbFpOZXNZNlZtTTFmUlMySzJpcm1tbTVVU1plOFB1Ym1OYXBCMHpkU1hs?=
 =?utf-8?B?UEFtUXQ2R1pQalFnQndnNElwRmJQVVl6cUNwNlVja0JlU2VtNktPSkhzS2Yx?=
 =?utf-8?B?ckJTN0h2ZDBEbndaVlhveVRTYU1HSjFWR3RuMm05YjBBVFZtd0VmcFBCa0RG?=
 =?utf-8?B?VTlDL1YyTnh4ZmtScnRKR2ppVXFuQjZ3cjdYZitvaGJwWVc1bGRkUFYrQ2J3?=
 =?utf-8?B?ZEMwTk03cFN0UEVzc1JHNjB3YW5VWXIyK2NUNlJ0RlNZMEhiT2pRWnFEb2M2?=
 =?utf-8?B?Nlk4b0lteXNGTi8yejRLa1ZHYnZyazlHSjY1WUlVaGQrZURjeHFXSzlYRDFT?=
 =?utf-8?B?WVVBc0dNNGJVYXFYSUQxVG1Oanc2a1haRlNxaytoaGFJT3IyRDhxTWM3a014?=
 =?utf-8?B?ckZRYVdnTGhvdmZ4U2hadHcrcjJ5OEowaWNjdThZcURLWlpPTUw1cDF6c0ZT?=
 =?utf-8?B?Tk94QXRSa2xtTytOeE9OWWh4L2p1OUhQem45MHZJQmJ3YzFYZWMzblhIdkNE?=
 =?utf-8?B?RHM1TmJJdUxWa3p3RnAzMXhxeEwxL3U4Y0JuR3EwbFFvUUJOdGVGVVhrYVhN?=
 =?utf-8?B?YUgzUWpLaS9JZGJ1eTZuMEJlL0xsblhReVovN1dtdU5BRU14OHQ2STVmRzNL?=
 =?utf-8?B?Mm9kUlF5RExLWXFoUzliaDBBN2MyVm56RjBUMkl0NldXT1JnOVpSN1EzNDBm?=
 =?utf-8?B?d2JJelVKWU0vZjU0QUZra0hNaWlQblZNMXYyazFVMkhhMDhDUmkyYTZDSXZ4?=
 =?utf-8?B?NnErR01IYlovTlh6eFdDVC9vWVQycEg3LzdOem90a2l1YklGK1NXMEVaTUNU?=
 =?utf-8?B?cThHcjF1Ylh6YTNJeDErYVRYRE1veEVTMW1zczgvSXE5MGltY2NkOE4xMWEx?=
 =?utf-8?B?QUswaFJiV3U2T0Zac05hTW5BSncremFBdll0WDRNME4vMElmWGUvZ3RTSUFv?=
 =?utf-8?B?RUZpKy95MjhxMGJLeFo4QW5NZHY3eFdreS9ta0grTU9nQUFtY1ZHeW5pMUdq?=
 =?utf-8?B?YnJWMUNVb1lhNXRKaDlJRnN3UjBiTjgrcXNwTC9abjRVcFZTM3lSeDVWL1JY?=
 =?utf-8?B?aUVrY0FtVlNkckJFTjRUTDdGOG1JY1FITTh5U1lZUDJUSkdwRlQyN2IxZU16?=
 =?utf-8?B?dGRQNEVUT0lhR3hweHc4cWhsOC9sQzVYbTJNMkIvUUd4aDdjSHlnMm5tSG9N?=
 =?utf-8?B?SFVBSXd6N242Z0thU041TUxjNDFMUkU5eGdGcGUvRldlT1Q1R05vTjhkZklR?=
 =?utf-8?B?ZEVrOU9aSlh4bkxGSnlPdFM1dnArdkhhVThnbFlhWTdjMjBybHpOSzNLaWk1?=
 =?utf-8?B?YTZqOTBhY1phZFg4QXo1R1NDWTBFcU9ZL1JpNmQwTDlGYlQzdVdXOHUwRW5M?=
 =?utf-8?B?VVZoNnBoZUw0a1RnWlVnck1sdDNyL1NieHpqUk9Hc3NXdUZHSEdOdnN3NitN?=
 =?utf-8?B?UUsrNGpUSm01VmNUaVZueWZDV3A1VTI1NUNWZ3lMdTRjYVpMQXJub1NLYWVY?=
 =?utf-8?Q?RuMsGJ3dBaklY/PlbS+F1/C+/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ad56bb-c9a7-4bd2-e2d7-08db2cb84858
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 22:37:00.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5AAThc2HMxN1oO2i8PQVgAGnIcCSClz0JIITKElHtwuHTPfwpyzr3Wn+7zEwIoe1KtiXYdm/rgOY61kvwOyXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8710
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/2023 3:02 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, 22 Mar 2023 13:34:38 -0700
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
>>   drivers/vfio/pci/pds/cmds.c     | 67 +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/cmds.h     | 12 ++++++
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
>> index 000000000000..26e383ec4544
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.c
>> @@ -0,0 +1,67 @@
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
>> +     int err, id;
>> +     u16 ci;
>> +
>> +     id = PCI_DEVID(pds_vfio->pdev->bus->number,
>> +                    pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
>> +
>> +     dev = &pds_vfio->pdev->dev;
>> +     cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
>> +     snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
>> +              "%s.%d", PDS_LM_DEV_NAME, id);
> 
> Does this devname need to be unique, and if so should it factor in
> pci_domain_nr()?  The array seems to be wide enough to easily hold the
> VF dev_name() but I haven't followed if there are additional
> constraints.  Thanks,
> 
> Alex
> 
>> +

Hey Alex,

We used the PCI_DEVID (id) as the suffix, which should be good enough to 
provide uniqueness for each devname.

Thanks for the review,

Brett

[...]
