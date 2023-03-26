Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39FD6C9251
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 06:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjCZEHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 00:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCZEHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 00:07:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A22B759
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 21:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwWlCuqGwzs78WSQKhWyZMxtXJnPlB4rQBhDZQ1S9si3nuJfOABEXfp3Evl6aA6iYcvcbsQDCEIpjt8E7liYQdPTj08xQ+u/ZaonxbyWqfN/vHe2YYaFiG1yKdrZLibu6DcYY+f5L9MfDJiC1TILSSIbvybCbKRBp3Y4ibRkfg8dZKFs+xGwa7aPWch5DRFDqqkNJ+Neow3efIngQaFoD4zO4Xfoj7XEHvTMxWfG1suMPYsVtZ8TCjFz59MsL5kW0bydf/BggedBNyyOhusVwuJm5GN3oSgX2XIdXf/e3kTTsaKU9o6iI3sXrzw0r/8ZoUHqHDrGZ+bHo1dlwMi4DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8e7CDiNZ4wW+FXlaqf2MCVFhGkQHeMASqvt1Pxi6zw=;
 b=AukAmVh44YZFoVZ7Wqed1wkia32W1PH4VJ8L+RJd50c9HSEbfBGeQNEa7w/2nl5AJpr14+uZZ+KyncJGtRMUh7VLtDj8ptpld692W1h+vNYCYUMi/uiLbdgp4Bful6Awo9DTvpD4ff8xhRBrj1EXbzUmhz8qNWk50zvUdz0RspQSsP4lm8TqVYG68wbdB5z9ubrTAfwM779A6CKEH92pRsxWvsIl6pC9unuKrYw/oHaozgLenpdChFXqd2UXrk89r5ikSrYmZIaaDJVMyfdt8tXRCLoWKfZs96QCaSm9tLwNVnn/JrDVcBTd08a9ELLa2RGUpDVJEuQ7fh3T0c7hYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8e7CDiNZ4wW+FXlaqf2MCVFhGkQHeMASqvt1Pxi6zw=;
 b=D7ExxB9QRb8VkvHjdkYHhYGT+mf0EeTqb32IGvR2wX2qE7dW+lURuG4fn7agB93j3ggvOCjEKt/ZyzPLzMECQ1C9gKwyvthOcjKOiiI6HOLZ/1I0ypi2wuV4LGZMLwhYbbsFO8rJtK/TpYGeOj1bgdWl7tYVwsmSh0VQix0N6k0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB5658.namprd12.prod.outlook.com (2603:10b6:806:235::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Sun, 26 Mar 2023 04:07:25 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6178.038; Sun, 26 Mar 2023
 04:07:25 +0000
Message-ID: <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
Date:   Sat, 25 Mar 2023 21:07:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230324190243.27722-1-shannon.nelson@amd.com>
 <20230324190243.27722-2-shannon.nelson@amd.com>
 <20230325163952.0eb18d3b@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230325163952.0eb18d3b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::12) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: 690322ac-882e-492d-963b-08db2daf9b7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDeOfa1nVQAQq3ck/EpCjNwJhKyGRrm9GRtZLzlE6emWtY8FPH7jXkEupY3rLpWR2pAfAgaPGbRjhhnSuI9TPT7KFJduf0VKWJkC2i0OD2MGFoSlgPPC9gWODjaDYs/sLjt7HM9T3OXrYQb9luIFLZpBjAIwAnqLjpZBgUQJizPCz/0nXVS2msguGntQ9VPmBC3H6iBz0l2uBcYviHm+kML4CZ2YdLeBukRklHfLwJ2jCnhaAZ2oYs42dSvO/O+l7Sbhlwmm5p3xs1q/tjuD2YPZgvL87U4OOe1ZpFcsmnSDCgQMohIWYNaCU9dB/bpSP6jdCszT44+PiWm2Z4iTFJpsXWq1dq3oHlhgc8gc1s2Sgh8U5TzLARm/BPEl+N8nE5Xgf3ZvvjAMcPasvcxF7aua07uEL4wCOaWDpskkbeVVZOLigtVlghkDTTo64CLTGfvo+jnhMtcfW9A316cf30Y1hF/vLi9VLT7nOddh2fUjjzfNRdut4HL6gzpCog7C8/PdHLC3PH5hakcP4gW9CXESVANZVfr/dBqyEKFkrPRWfuBqlOe2+OVe/8Vf/6sDioBZcZBrJtFuo4j+V61/AlO/fkMoKSWuMz9kbztVVGXqt2VQjsXRTfuM+rvUv+1gX/AaTksYSTpZ50GBs9WzcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(31696002)(53546011)(6512007)(31686004)(2616005)(44832011)(6486002)(6666004)(26005)(8676002)(6916009)(6506007)(66476007)(5660300002)(8936002)(316002)(86362001)(38100700002)(83380400001)(41300700001)(186003)(2906002)(478600001)(66946007)(4326008)(66556008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHdhaWxYZHNUNVJwREZmNEtBMVpTRmxZRThabE5KeVViU0dITjZDeWZQRXBU?=
 =?utf-8?B?YjhSa2w3bVgzaERDT3RtZXRMVEdRWGt0M3dyRWN2eWRxa3dEYmZ2cEQ1UTNl?=
 =?utf-8?B?QWk4OE80eXVPcmEyQXQ3NlNWd1g1aTNPM3VUL090N0hQL21OYzVNKzVLMUQ5?=
 =?utf-8?B?Z0xURTdyVEhvTkxXVzJUOXExcnBNL3dMWE54V3FvaXFBYjdiZ3Q2aVpFbCtp?=
 =?utf-8?B?TEFoc3AycUF0QzgveGdyS21DZ2NFSjhNUFBrR0N6d0s4U0xheVNNOXl6aDBj?=
 =?utf-8?B?OFVFTDZocjB5OFRtZEU4Y2Ztelc3Ym9UaHhYc3RxeGZKNHFjVDl5Q3JlQ0xt?=
 =?utf-8?B?YVBnSVE3ZEgzN1k1WkttUkZJM2ZqK0g5SUJMVjRnUE11YTlVN0dvRnh1eWM5?=
 =?utf-8?B?UmU1ay93RmJCTUJ0a3ZHczBXM1kwZ0lXMGxiYTR6dlh0UjBrSVlOdWl3WWtC?=
 =?utf-8?B?T2UrSjk5RW95b1FGbkRaaFkzeWY3VXhxSjIrY0RGZkdtaHFscVgrWlpnN0dH?=
 =?utf-8?B?eFlYeW9LTlJ0YUtBNng5amZaaEZxTFRYMFdEVW85NGFTRFdmMktaQmF3ZDM0?=
 =?utf-8?B?emtOTVczaFplS1ZDME1ONDI4STNrQys5TlZjTFN1aVNCUmlIQ3czR3phQStM?=
 =?utf-8?B?R2lCTFZScWZwbTQwTWR6RGpzN2o3ZnRLNEw4a1VXV2ViOGNRZnRwK1M4aG5w?=
 =?utf-8?B?L2MwSzA4SFRsOGFobll4Y3BHdC9zb3BxbUVoV04wZkxHTTR3TTBIaUFFRjNC?=
 =?utf-8?B?K0krTHkzVkVNOS9BaUIvc3lBeG9qazdqZUZnUUFjbjZqS0ZubTdRZUg3TGc3?=
 =?utf-8?B?aTB0bDlsQnNpWS9GbkM4cUhIeDNLRXo4blZlRFNDdWdPamEzZXVrcGpPZTJC?=
 =?utf-8?B?THYzZkdzb3ZYZDhuSzFZYkZoQ29TTDZNeGVjR244S2lIbCtKcElRTklydUZB?=
 =?utf-8?B?QWd1Z1hUQmlJZTBnOWlvbTUyY1cwdDB1UFNmaVgzVkk5ZDR0RGJ5dWlZRjJr?=
 =?utf-8?B?YXMvc1RHUmxENGs0QXN1OTVNbjZyeERrSnNMS0VwS1JMdVI0cWEzWU5Ec3Bj?=
 =?utf-8?B?R3o4MFVjVkxCSTdnZG5COXVHeDdkYXFieEV6NmJqOWtIR2tyaEJpNjVkYTNl?=
 =?utf-8?B?aCtYOFNicUJOZENERWxBTi9HNC9GVHZFUzZTUmd0RHpEM3d6eTFLNUtBV28v?=
 =?utf-8?B?cTZyeTN1RUxHYUhNekFzLzc3Q3QvREFvRlJWS0hGcmM3aUJtbi9QSDFENHNW?=
 =?utf-8?B?NnZZUTZWZFFKUlV4NmdDakYxV3ZhRVBSQWdkS3dESzRFeDJQTTgzbnlpU01Z?=
 =?utf-8?B?bDIxclpoYU1mV3lMV3ZuL2NlSDBvckx2OE14a0hrZ0h6QkVGS1Q4aUw0aDRY?=
 =?utf-8?B?aktsWkZmcDkvMHIwTldoRXpqYVB6cmZEVXQ3Mi9WbFNNUGZRbnZZbVMzdDNM?=
 =?utf-8?B?U0R5cHYxdjFwRklTVGtEN0xkUE5RL0plaGN5b2JDNmVMMjdndVp2am1TWEha?=
 =?utf-8?B?c2pGTFcrS0tVTmp2bnV4eVYweFRKc3V2OUhIN0RnOVNOdTZIOURaMGxxZ1pP?=
 =?utf-8?B?djV1bjVUcEErTUNFWk5tRTJyeTdZeGg0TGNlQjVQYXE2dHIva1V3cWhnSHUr?=
 =?utf-8?B?ZlIwM0g0ZmM5TW5Oa2RvK0FpOGdGY21sdDhyRC9RQWdkKy9iOU9kZWI2Tmky?=
 =?utf-8?B?VWtjL09uSVdwQXJRYmRBbkZROXBOY2hac3lPV2hkQkt2ZHNQVVRlR0NsYlNy?=
 =?utf-8?B?ekpTSms1V2twYUhsdlZiK0o5VHRhMFNaKzgydFM3RkI1QkZ1eHJlQW1iK1Zy?=
 =?utf-8?B?WnBmRHZ1N09QZmgzc3VjTDg2UUJXUGVYbDJxdTJPd2RQVXA5KytGT0d1djR5?=
 =?utf-8?B?aU9XQ01UcnV2aXUrL29WZ3BKOTVBVFovUEdGRDN3MHpjN0tyUDVkK2VDVXB3?=
 =?utf-8?B?NlN2Unk1YmUxTG9rajNCdVZ3V0FzOEtDT29PTHFieFZkcmFqakZYUGFsZERr?=
 =?utf-8?B?UCt6ZVRFbWxFZEdqNk1IeXFiRnk1aEp0aTBBSTcvL3dqU09mWnZoWDNFa2ZR?=
 =?utf-8?B?QVltZ2xQd1JOVTdqZ3B2bkJpQ3RLWFJOcFVxOEdSN1ZJWnd4WUlMb2NKK3Ex?=
 =?utf-8?Q?cyTkV2ZctQewVjPUQ9I8GXrfb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690322ac-882e-492d-963b-08db2daf9b7a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 04:07:25.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Di0kZscsRP8mb/xhWtYG9RBAM/0MArVMe5/9XLUhgD22jql53J7mpZZ9OwteVJTHTN1WzSJ3M4PSQHhGAsi3zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5658
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/23 4:39 PM, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 12:02:30 -0700 Shannon Nelson wrote:
>> This is the initial PCI driver framework for the new pds_core device
>> driver and its family of devices.  This does the very basics of
>> registering for the new PF PCI device 1dd8:100c, setting up debugfs
>> entries, and registering with devlink.
> 
>> +     debugfs_create_file("state", 0400, pdsc->dentry,
>> +                         pdsc, &core_state_fops);
> 
> debugfs_create_ulong() ?

Sure, that seems reasonable.  I'll double check that I don't have others 
that need the same treatment.


> 
>> diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
>> new file mode 100644
>> index 000000000000..a9021bfe680a
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/devlink.c
>> @@ -0,0 +1,51 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +
>> +#include "core.h"
>> +
>> +static const struct devlink_ops pdsc_dl_ops = {
>> +};
>> +
>> +static const struct devlink_ops pdsc_dl_vf_ops = {
>> +};
>> +
>> +struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf)
>> +{
>> +     const struct devlink_ops *ops;
>> +     struct devlink *dl;
>> +
>> +     ops = is_pf ? &pdsc_dl_ops : &pdsc_dl_vf_ops;
>> +     dl = devlink_alloc(ops, sizeof(struct pdsc), dev);
>> +     if (!dl)
>> +             return NULL;
>> +
>> +     return devlink_priv(dl);
>> +}
>> +
>> +void pdsc_dl_free(struct pdsc *pdsc)
>> +{
>> +     struct devlink *dl = priv_to_devlink(pdsc);
>> +
>> +     devlink_free(dl);
>> +}
>> +
>> +int pdsc_dl_register(struct pdsc *pdsc)
>> +{
>> +     struct devlink *dl = priv_to_devlink(pdsc);
>> +
>> +     devlink_register(dl);
>> +
>> +     return 0;
>> +}
>> +
>> +void pdsc_dl_unregister(struct pdsc *pdsc)
>> +{
>> +     struct devlink *dl = priv_to_devlink(pdsc);
>> +
>> +     devlink_unregister(dl);
> 
> Don't put core devlink functionality in a separate file.
> You're not wrapping all pci_* calls in your own wrappers, why are you
> wrapping delvink? And use explicit locking, please. devl_* APIs.

Wrapping the devlink_register gives me the ability to abstract out the 
bit of additional logic that gets added in a later patch, and now the 
locking logic you mention, and is much like how other relatively current 
drivers have done it, such as in ionic, ice, and mlx5.

Sure, I can set up the dev_lock() and use the newer devl_* APIs.

sln

