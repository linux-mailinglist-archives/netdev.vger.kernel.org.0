Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F036DCB46
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDJTFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJTFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:05:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA691718
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:05:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7lznb424V7a8Mj6PKmIzArLCSE/cZPN/ByEVJ+qGPDAq3PZQjwBeBdgmOhRbz9NKTU3gblFF5DZWMmyr7SM635S5pwkXrh3BZgXhgD7NQfnOO6y71etgoG/f5DcqRVYvhNk4PSYV0rtY89m+QFDpqXUoO+mwpl6jOi9PyDR6fjZwv9MIw4OWezV4MJTGBpAtzbWtD9MzcXG4zfm+DiPFrBcrs6nYdM8JqZDU5f174HT75mvaJUnkqSkz19f7L/gXZVGEnueEY4dYEVhwVIMDJwapeifRYvoGxy9WDMsjU9qQUO4BLucqG8VSVh/c7S6ZW6ak/WgpFim0CFHpiwQGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7caglit/Nkss9J6UTbVMKOFYxR4vsZiy1cutnWtMUM=;
 b=j9dBrlS9bu2oypCqRlc1vK/vt8lLZT7yRay1tHHxU3XJeCa1ovoGJyJ0b4SBQZYnECh/DyXGA5Pa53uLd4Cy/qT3XrXnT0ThBPR37XdWbvghufHkk91+vt091KiLiofFUf6JFq5MIk6quJi6OZK3dBc+9BVT2T6dBUknoObP/u6StNdmzDwMc8zhvdEB4uDz8xWa2nPlbkw8XpIHP2372eh86HWsuWvMN1CzJiRTzRv0ZhahLr5md9O3J5KF9vusGfmgcM20pugTPbod6n9uSJ+q7SLJY3ArpnuiX8sDxtjbyPH52AkIwXaLNUZHt0a/7jrhMGcKOIsnFW7JdBoHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7caglit/Nkss9J6UTbVMKOFYxR4vsZiy1cutnWtMUM=;
 b=a40pKJhpGrp9SFB+TyvK+KWdPbOkVqUTx/OZD7HD53hi6sWQEU1wjWmlsW09iSb7wbcCvbPpWBmGFRpOM1nevlU1ZW93Bu0vu2elsbmSD4KbwhZ3p67WhGUbShDlLqIMmVS27s6WwDyVvsR6kv+Bfl24WoWtYCR1FfUHfwjj098=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 19:05:23 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:05:23 +0000
Message-ID: <5394cb12-05fd-dcb9-eea1-6b64ff0232d6@amd.com>
Date:   Mon, 10 Apr 2023 12:05:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 02/14] pds_core: add devcmd device interfaces
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-3-shannon.nelson@amd.com>
 <20230409114608.GA182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409114608.GA182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::20) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 586b41d4-9c28-4ac3-ab9c-08db39f68940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZFvOjhlzFiBpkQk0PpejSI6A+PYaIYkQXsZBITAvBbbnzqNN0tn8cH0JVOv9hypVqTceM5Pu3kIRHraQGG3dIyaRXz3D043BNiYHIUqn0OwFotjAJ6r6dou21RVbzXrDeBN0lagWcvolPDo4Rjp9oKE/epjWwCnbYDxrScPrqFC894zhBmOKAVHz6+udcNIaNwAAR2LxejfLiinzu0h/RSIEpwiZtWb2AzM4rr0GVpQ0J0Ra1VMmBHKIqxM9a7r+5i2fy0Ds1ixTEeO83iqGVUgQGIM8m03PAxYUdROLSKn7eA5LT7xvgVvvfw5uhHnuU3/rKi4XAbw2MaAuJ9P5EfIAJRB9bMCmlp6gg6jdw4h8Ys7N8Rc8qLAouKG3J+gnNtq8W093TxtnVycvZaEqIMC+iwfyShJ9p3NMEwoZXCrcFA/F6zIzW2cHs/6v64AH+iTEqt5KlTCPG17eP6h8Gqsx74yRgEijhvO7vt0JDFUYx4FfhOfU8XqjWq6Hj10vCFBO9JuxInSIVEM96hscBlEfDyhPQYfrn/0hXSv196CnhFVZfwtcn6G3zQoXaNLYVHQ6kF1/BCl2VSqF3wxvKcE/oc8EV6Qq+S6JLLxeLHwsHkXDgpesCQdh5PitiOGlQgVJROwt1h+K4Uy6HCn7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(478600001)(316002)(53546011)(6506007)(26005)(6512007)(186003)(6486002)(2906002)(44832011)(66556008)(4326008)(66946007)(8936002)(6916009)(41300700001)(5660300002)(66476007)(8676002)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0Z3UEJSa0J6VW1kK1pIS3VCcmRCRjZYY25KSTQ1bloyQ2JBeDViQkp2WERY?=
 =?utf-8?B?L2I1cjRpbzB5UitvdkhJRzVjVUJyN1hYdEhGWG1MYStZY1JERVVkaFk0OUlz?=
 =?utf-8?B?ZlFjMWtDT1p3TExTUCtXL2pDRkVlQVp2MHZKZ0h1cFBxQWl5VmwvWE90aGpU?=
 =?utf-8?B?N2ovY1R1OEN6MWpKcWY4SjA5MjRBeGNoY2MxLy91UFgzZ0ZJSnZObkxxK3Yy?=
 =?utf-8?B?MnFWTDQ2cXowTG1aRFl0MmZ5VXR5ZmdObndmSUxmT3h1Zm4vRHRsekI2WC9a?=
 =?utf-8?B?bnAvSnUwaGVBL0E3d2lIVFFmYmlLR2E2bU9BTFhhZ2RmTnZ5c3N2dUROazRV?=
 =?utf-8?B?emFxR21YUzFRcFlPdS9aY0F0R0dqTTFzVUhaNE5wWjhJNDVJS2ZodVpHN0gv?=
 =?utf-8?B?OU9kZ2JpYnFoU0o5LzdzcGUwSGlyY1JtaW9acFJJU2hEN1VuYzlyV29qdS82?=
 =?utf-8?B?OWNIYUJhZCtucTk2Qk9YTjlHYS9ZQUhJYmNic1NBV2g2OTVQQkJ5bjJHSitW?=
 =?utf-8?B?ZHJCQThJR2x2OFg0L3M3dFJvaU5heVNrVk9kVThweEVvejQrTmI3c2hMbmhy?=
 =?utf-8?B?Rk9Ubm5TVmI3RGhITWdCb2NUeU9LWityU1JHbVFnSENlUUl3cEhVcUducVUv?=
 =?utf-8?B?WEpGanFKcDNuQnZmSDZRUmZRdzdqc1pIY3lWRW9sOGV0QnNVYStXMzFvZDJa?=
 =?utf-8?B?QS8xVGlMOWkyWjRHTEEyNmpNakJndlpFZHZKc0FDZkJRTkVwMC9CMUdFQ2o0?=
 =?utf-8?B?MFNCRC9WMkppV3ZvZnoxZnFSOFBreVNQMWFxdkF5RzE4aFI1TGMwTHZtaisr?=
 =?utf-8?B?cnZaYnJMSWNtSFE1YUNPVkdmRFMwRDBNUjBvRHYySDBkYkFTZ2pYVzVmUktW?=
 =?utf-8?B?NGlDSndQS3I4QS8yV3ZlZXpjTnJyL1MzR1JYUEkwd3hvTHpEOUZ0ZEpxVGJN?=
 =?utf-8?B?OTg1OWlNbS8zN0NQeWFyb25qcHJMc2ZJUHVPR2xBdWplVmtYNDVVR0E3TUJi?=
 =?utf-8?B?ZFNTeE1qSUQzckRaY2tOMmVJZDNuNGplMkU3OUhXNkJjZENsTVh4UDArdTJW?=
 =?utf-8?B?dHpvOC9hQ2pGZmFsODFaQVJaVEE1Z25KN3hZd0pyQUtrWWlFcU1zdnBtTHEz?=
 =?utf-8?B?ZUk2LzNJd044Z2N0SGRod0dvQXlPc01RNVBZc1M1b1c4TXNNWmd4VnRnUUNI?=
 =?utf-8?B?ckhReldGOFFMalJ3SEY2YU1QdlFRSlF2eFJjbkZYN1B5NHdZWUd1b3hPN0xz?=
 =?utf-8?B?VEV6YVM4ck8zanVsL2JtdjdLZGRRWlF0cHJSWWZvM0tNNk9IQktMZXp6c1dJ?=
 =?utf-8?B?WVpjUG13WmJTMDhILzI0OVFYU2JhTnZBSDZhQTh6OWtBdVhycTNCbUhJTFNx?=
 =?utf-8?B?blg5RzZzaVYrWjZHNGtWMWVzYnhlT3ZlWWVGYmV3bEVER0lYZjRaSlh6WElW?=
 =?utf-8?B?dldBL2xSN0ZjSGJISGpLOFB5d1Y0eVFPWEJlRkROZTltMkFuWDVqSzVtNTN2?=
 =?utf-8?B?bnpwb2VIUVhIT2J3SUM0MnhVM3EvNXFGS20zazdKcG5tc0duUVZJZ2ZqMzFx?=
 =?utf-8?B?RHN3UkhUVDZkc3BPRFhxSEN4SkNtMG9WS3p6VUdtVjVaTytZOHE4dzZFczJa?=
 =?utf-8?B?UkJBSHgrQWk0NWNZQmpHMU4vV0g4Qm9HYk9hTk02Rkg1ZTZybGZTVHgrTmVq?=
 =?utf-8?B?MElUVVg4R1gxUjJVa3hEOW92aldLWlZ6YXIyYmpMWUk5aFRSdkVRK2FCODZh?=
 =?utf-8?B?dyszQlluTi9mSTJCNG1xZUNsTWZtNGFoNDlqMkVEZVMxQStJWUM2Q3prME9G?=
 =?utf-8?B?Nk5kTDB2WTBhYWhkcjRHbVdsYWRwSk1JRm9xZVlCZ2JqWStkcE1JWDVBM25q?=
 =?utf-8?B?V1Nsd2hXV2lLbCtRMlNkV2Y4eTBObElGcVZjNkd2OGY4TzcxMVJwMXNIcDc3?=
 =?utf-8?B?R2ZkUkhLY1BRL3psWFJCTjRPQXFOYWViYzZVb1BpeDdONHM3bE9QeXh5MjNj?=
 =?utf-8?B?cmtFc1lRR002WHlQUFh0Wko1R3N2YXYwbFRZZk94UFpkc3kxUlF2aFNHSHdm?=
 =?utf-8?B?dkVyNEZYaS91UjVTSGpSVWZGMDVMdUxrR1AwZzJCbXU4dXFTREtwNmFjOTBa?=
 =?utf-8?Q?RwbqVgQ5wGZ5VppKF8Zb9HiAY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586b41d4-9c28-4ac3-ab9c-08db39f68940
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:05:23.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WdeFWHK2g60EyD6QmthO7DX9ICNiL8CaQiyI03d3qXgb4HpojVXhRf+wUClz9NOoH92rKoUxdoN96VHGqreJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 4:46 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:31PM -0700, Shannon Nelson wrote:
>> The devcmd interface is the basic connection to the device through the
>> PCI BAR for low level identification and command services.  This does
>> the early device initialization and finds the identity data, and adds
>> devcmd routines to be used by later driver bits.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/Makefile  |   4 +-
>>   drivers/net/ethernet/amd/pds_core/core.c    |  36 ++
>>   drivers/net/ethernet/amd/pds_core/core.h    |  52 +++
>>   drivers/net/ethernet/amd/pds_core/debugfs.c |  68 ++++
>>   drivers/net/ethernet/amd/pds_core/dev.c     | 349 ++++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/main.c    |  33 +-
>>   include/linux/pds/pds_common.h              |  61 ++++
>>   include/linux/pds/pds_intr.h                | 163 +++++++++
>>   8 files changed, 763 insertions(+), 3 deletions(-)
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
>>   create mode 100644 include/linux/pds/pds_intr.h
> 
> <...>
> 
>> +int pdsc_setup(struct pdsc *pdsc, bool init)
>> +{
>> +     int err = 0;
> 
> You don't need to set value as you overwrite it immediately.

will fix

> 
>> +
>> +     if (init)
>> +             err = pdsc_dev_init(pdsc);
>> +     else
>> +             err = pdsc_dev_reinit(pdsc);
>> +     if (err)
>> +             return err;
>> +
>> +     clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
>> +     return 0;
>> +}
> 
> <...>
> 
>> +static int irqs_show(struct seq_file *seq, void *v)
>> +{
>> +     struct pdsc *pdsc = seq->private;
>> +     struct pdsc_intr_info *intr_info;
>> +     int i;
>> +
>> +     seq_printf(seq, "index  vector  name (nintrs %d)\n", pdsc->nintrs);
>> +
>> +     if (!pdsc->intr_info)
>> +             return 0;
>> +
>> +     for (i = 0; i < pdsc->nintrs; i++) {
>> +             intr_info = &pdsc->intr_info[i];
>> +             if (!intr_info->vector)
>> +                     continue;
>> +
>> +             seq_printf(seq, "% 3d    % 3d     %s\n",
>> +                        i, intr_info->vector, intr_info->name);
>> +     }
>> +
>> +     return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(irqs);
> 
> I'm curious why existing IRQ core support is not enough?

Yes, that one is not necessary, will remove.

> 
>> +
>> +void pdsc_debugfs_add_irqs(struct pdsc *pdsc)
>> +{
>> +     debugfs_create_file("irqs", 0400, pdsc->dentry, pdsc, &irqs_fops);
>> +}
>> +
>>   #endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
>> new file mode 100644
>> index 000000000000..52385a72246d
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/dev.c
>> @@ -0,0 +1,349 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +#include <linux/utsname.h>
>> +
>> +#include "core.h"
>> +
>> +int pdsc_err_to_errno(enum pds_core_status_code code)
> 
> All users of this function, call to pdsc_devcmd_status() first. Probably
> they need to be combined.

This is also called from pdsc_adminq_post() which doesn't use 
pdsc_devcmd_status().

> 
>> +{
>> +     switch (code) {
>> +     case PDS_RC_SUCCESS:
>> +             return 0;
>> +     case PDS_RC_EVERSION:
>> +     case PDS_RC_EQTYPE:
>> +     case PDS_RC_EQID:
>> +     case PDS_RC_EINVAL:
>> +     case PDS_RC_ENOSUPP:
>> +             return -EINVAL;
>> +     case PDS_RC_EPERM:
>> +             return -EPERM;
>> +     case PDS_RC_ENOENT:
>> +             return -ENOENT;
>> +     case PDS_RC_EAGAIN:
>> +             return -EAGAIN;
>> +     case PDS_RC_ENOMEM:
>> +             return -ENOMEM;
>> +     case PDS_RC_EFAULT:
>> +             return -EFAULT;
>> +     case PDS_RC_EBUSY:
>> +             return -EBUSY;
>> +     case PDS_RC_EEXIST:
>> +             return -EEXIST;
>> +     case PDS_RC_EVFID:
>> +             return -ENODEV;
>> +     case PDS_RC_ECLIENT:
>> +             return -ECHILD;
>> +     case PDS_RC_ENOSPC:
>> +             return -ENOSPC;
>> +     case PDS_RC_ERANGE:
>> +             return -ERANGE;
>> +     case PDS_RC_BAD_ADDR:
>> +             return -EFAULT;
>> +     case PDS_RC_EOPCODE:
>> +     case PDS_RC_EINTR:
>> +     case PDS_RC_DEV_CMD:
>> +     case PDS_RC_ERROR:
>> +     case PDS_RC_ERDMA:
>> +     case PDS_RC_EIO:
>> +     default:
>> +             return -EIO;
>> +     }
>> +}
> 
> <...>
> 
>> +static u8 pdsc_devcmd_status(struct pdsc *pdsc)
>> +{
>> +     return ioread8(&pdsc->cmd_regs->comp.status);
>> +}
> 
> <...>
> 
>> +int pdsc_devcmd_init(struct pdsc *pdsc)
>> +{
>> +     union pds_core_dev_comp comp = { 0 };
> 
> There is no need to put 0 while using {} initialization.

will fix.

> 
>> +     union pds_core_dev_cmd cmd = {
>> +             .opcode = PDS_CORE_CMD_INIT,
>> +     };
>> +
>> +     return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
>> +}
> 
> <...>
> 
>> +     /* Get intr_info struct array for tracking */
>> +     pdsc->intr_info = kcalloc(nintrs, sizeof(*pdsc->intr_info), GFP_KERNEL);
>> +     if (!pdsc->intr_info) {
>> +             err = -ENOSPC;
> 
> The general convention is to return -ENOMEM for memorly allocation failures.

will fix

> 
>> +             goto err_out;
>> +     }
> 
> <...>
> 
>> +/*
>> + * enum pds_core_status_code - Device command return codes
>> + */
>> +enum pds_core_status_code {
>> +     PDS_RC_SUCCESS  = 0,    /* Success */
>> +     PDS_RC_EVERSION = 1,    /* Incorrect version for request */
>> +     PDS_RC_EOPCODE  = 2,    /* Invalid cmd opcode */
>> +     PDS_RC_EIO      = 3,    /* I/O error */
>> +     PDS_RC_EPERM    = 4,    /* Permission denied */
>> +     PDS_RC_EQID     = 5,    /* Bad qid */
>> +     PDS_RC_EQTYPE   = 6,    /* Bad qtype */
>> +     PDS_RC_ENOENT   = 7,    /* No such element */
>> +     PDS_RC_EINTR    = 8,    /* operation interrupted */
>> +     PDS_RC_EAGAIN   = 9,    /* Try again */
>> +     PDS_RC_ENOMEM   = 10,   /* Out of memory */
>> +     PDS_RC_EFAULT   = 11,   /* Bad address */
>> +     PDS_RC_EBUSY    = 12,   /* Device or resource busy */
>> +     PDS_RC_EEXIST   = 13,   /* object already exists */
>> +     PDS_RC_EINVAL   = 14,   /* Invalid argument */
>> +     PDS_RC_ENOSPC   = 15,   /* No space left or alloc failure */
>> +     PDS_RC_ERANGE   = 16,   /* Parameter out of range */
>> +     PDS_RC_BAD_ADDR = 17,   /* Descriptor contains a bad ptr */
>> +     PDS_RC_DEV_CMD  = 18,   /* Device cmd attempted on AdminQ */
>> +     PDS_RC_ENOSUPP  = 19,   /* Operation not supported */
>> +     PDS_RC_ERROR    = 29,   /* Generic error */
>> +     PDS_RC_ERDMA    = 30,   /* Generic RDMA error */
>> +     PDS_RC_EVFID    = 31,   /* VF ID does not exist */
>> +     PDS_RC_BAD_FW   = 32,   /* FW file is invalid or corrupted */
>> +     PDS_RC_ECLIENT  = 33,   /* No such client id */
>> +};
> 
> We asked from Intel to remove custom error codes and we would like to
> ask it here too. Please use standard in-kernel errors.

These are part of the device interface defined by the device firmware 
and include some that aren't in the errno set.  This is why we use 
pdsc_err_to_errno() in pdsc_devcmd_wait() and pdsc_adminq_post(), so 
that we can change these status codes that we get from the device into 
standard kernel error codes.  We try to report both in error messages, 
but only return the kernel errno.

However, I see in one place in pdsc_devcmd_wait() we're using the status 
codes where we could use the errno, so I'll fix that up.


> 
>> +
>> +enum pds_core_driver_type {
>> +     PDS_DRIVER_LINUX   = 1,
> 
> This is only relevant here, everything else is not applicable.
> 
>> +     PDS_DRIVER_WIN     = 2,
>> +     PDS_DRIVER_DPDK    = 3,
>> +     PDS_DRIVER_FREEBSD = 4,
>> +     PDS_DRIVER_IPXE    = 5,
>> +     PDS_DRIVER_ESXI    = 6,
>> +};

Yes, they are rather pointless for the Linux kernel, but it is part of 
documenting the device interface.

>> +
> 
> Thanks
