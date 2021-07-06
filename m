Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBF3BDD24
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGFS3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 14:29:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1178 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhGFS3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 14:29:01 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166IDexl022801;
        Tue, 6 Jul 2021 11:26:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qGr5ZGnRNSFPIMVtyZpqlQIFbV2C+jEwMhIqEAuPhes=;
 b=kJ5T2FNMHPGwsMmr7zqRADfRTqN1gepeyWOH3uzoCVaBhzuU8CmSQX5KVNruH6MKXdir
 BOKuNBHIQ1Z99/sGPR5Tu1d5eUF/BF/WCPj7vcCJW7dWAUbbLwppangPk9hkasNuKDbk
 gbAoKe5pplgHrTD9wAPJ2iU7LN5wzHicSOs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39mhtyuqs7-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Jul 2021 11:26:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 11:26:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu0GNBwjOOS//CcLYCGdYYHh1vooOVzElLRJyiz6zB7EmC3kt308wuHQ8BQYNZYgM6tddWC+7XPBDFTh/v84ucKvdOx0WgzdZZqzlb4r5qkJo2ROzzIesRPhJWXxnzDDe55Qq1kF2RBeB9BpF0weY61WEI0IWny/xAH1yzFQFtsA3DjI3fHJgStWOq4bu6Yimqk5nYtZ3CG9iXSrrz9DtTrgfAegaINlm3WdKC2UlKeNsDS593MXToOf5JGRIi97q8G3Pb4U8KNajQ5oL9nt/trVSrvd2tbD3NSX+TdHO1YYXGW/5sFyDLvWs+lQvohrAk4DCUF/CFknSpyMf6Wvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGr5ZGnRNSFPIMVtyZpqlQIFbV2C+jEwMhIqEAuPhes=;
 b=Uz/PsQJpCUm5Kz1lP3xharnmdXEfckcVQXgqVYG8Wkki6b4gc8n5lMRziaMINpy0ay3LUP7RMS/PpNZht/tr6Pc/Wzn7KtWX6nICkm2P2tpeXEqqqym7Uqc/b61xRlwM4FXrm/VqlJuoE0CzC8rHEjUoY6w+iVRWezJY03j8/iL5wnjJ9RQK6osZ3bwXbdKVPYyIMdidiwzZpTqI2X+gfGEA3hXfLGoLZO2/rX+Gc799oAKPNnbXIvLcsU4akrXBi2GIx9RH4POfMLkZvRwADWswFJk/151Aj3IGGcVhDdsRAM8tdD98WMzwrQpUsP/SIvgD7Yg73SybguxCusfkLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Tue, 6 Jul
 2021 18:26:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 18:26:06 +0000
Subject: Re: [PATCH] tools/runqslower: use __state instead of state
To:     SanjayKumar J <vjsanjay@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20210706174409.15001-1-vjsanjay@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b87ad042-eaf0-d1ac-6760-b3c92439655d@fb.com>
Date:   Tue, 6 Jul 2021 11:26:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210706174409.15001-1-vjsanjay@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:a03:331::9) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::19fa] (2620:10d:c090:400::5:e2df) by SJ0PR03CA0064.namprd03.prod.outlook.com (2603:10b6:a03:331::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 6 Jul 2021 18:26:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39b7f299-5fcd-4c98-aaf2-08d940ab8495
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB486938BDE992D8857AE1C9D7D31B9@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNKFiHbIsN6BlzhVrieNGazFSINiAekDCXIDNzw+Hg/nltyf+vmQ1af15O4KC+tzlMGwUbWMgu8gl7TTVRC2M4FV5teAaEIfn6GlV5rYNekP0phGPLT2wstpKFC1dRp5gSfgQPtKKUmLUAr7F9PcajZngIT1wkdo0Apw/Xwm9z6Hi1sHn8U8x2DSMsdmMGm/Cvpm1MPL9EiN8nFBCjJdXkdbFRC6xCOH1PjhrKGCoRfJG1kmESy2ooicV3A/97dNOUy41l5neS1DLyM2o61ePIHDqVDZFJKISJP5LwIj/pxiy3g5ZYUi6nNvA6eH4vLyCK6frWLafYXtTDnrlbmyY6IiMqIt3i8PWHwqvvrkfFZ1SPZdsjhwtMR2S6dLr7zHG6DFKFJIlBPu0xTAUaICMAEHX1ctPF0I5YqLQEVmC/055nCdECxu2CEQyxwLZxOTon72GV3W0vAJ0aSqoD7+ikFsganZAC9G6Ud4FQtOIUz59TF4niUaljAYqtdNq3NO76RgPwn9776EXR0MJ8r8xNk9ywVx6KHM7Zl9M5rxiHjvTS50ssuJXKj323zIVlV4Lt1vGhvwFctSXf0+6x/gxTApSPurv7xWao2we9gkcFMI/eY4YwBjQC7v8DUACBpWge6lsXz1rHNJHwtOzI7XRVRnwC/zgjrFgA5Lk6ji8BdpfM3oniGmMS/2XJNFrAkDNhYg4frqwzq5gI8FtP4g9LkP9wlaRiZITl6q1VXsuFvjocKoTMLeXJiZWhHj+PZi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(66476007)(316002)(6486002)(2906002)(2616005)(4326008)(478600001)(31696002)(53546011)(186003)(83380400001)(66946007)(66556008)(86362001)(31686004)(8676002)(36756003)(5660300002)(52116002)(38100700002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUZKY211cVFQNDloa2RlMndyam1mVXNFNEU3VStGWlN6c0E4OUVuREhtdFpO?=
 =?utf-8?B?MEZZbE12d3R1bnR0eWVzQTBxdXJmMFZpWlpKV0d3SllTQmZIbzFLbEtBWFdw?=
 =?utf-8?B?UGpSeThNVkwvMld4Q2JnRldObTNyUGd0NkkzdXdnR2JLS0M5bndtaEdXSXhl?=
 =?utf-8?B?NEttemRZcWpPdGN6dFFwVTdYNVllWXBuYVdid0FxSEhCRkU0WXhoMHNrNWth?=
 =?utf-8?B?QnZobDd5a1FNZkd3cU9naTYzUUc0RGlER3RFcGVsWlB0VmM0bzRHaFF3ZGMw?=
 =?utf-8?B?dFRCV1J3VDYvVFlrdlRsb3FSSjZWNEc2MS8xRElmVlJFRWtRbzdnR1c0cGtK?=
 =?utf-8?B?MHU3eDVqZUs1VkkyRlFlMGFDeE9xeHRxcEx6NEFJaFFaWG9KUHpCMjNXVjdO?=
 =?utf-8?B?U1JLOHV1bkpPU0RWVTErWXM2ZHlrL3BkVkpxS0FTUStrMGxTeTdCdXdPVnJ5?=
 =?utf-8?B?N0JpUzhjRHF1MUZxZi9EZTczMzJpODdWaDQza2UvSHRzaUltWmZvUDUxczBW?=
 =?utf-8?B?Qlo5bDVHdmpaSG1pS1ZObjJZc3JHZS9qYmQvOE1waXoveVRJOWZCOXQxVkJR?=
 =?utf-8?B?NzVoTUprOVhWSmdVeUR3L0tpOVVkdnRITlczZWRhZW5OTDBNbGZxN2F4dHE2?=
 =?utf-8?B?MDliditicEI5eStNa3ptSDRoc3BWM2ZONzZpZWZlcHYwMEhzTVpTU0J6ak41?=
 =?utf-8?B?clV2Ky9XSVo4TjVSVE5WNTVqdFVMblowUEVvcWhYZDZtYVgxK2phWnYvejNy?=
 =?utf-8?B?RU0rN2lFOXhPbkRsZXBqNFZrbmY1UTRwZUdjSW5UZG5oZnZZN0c3cHVwcFpS?=
 =?utf-8?B?TVNtOWd0bXd3ZzZYZkp6UXgxSEJ5ZjhaVzJ3b2hEcnZwZjVZVzZPb2c4eEV6?=
 =?utf-8?B?TGFsdU5JcERZZHEvL0ZjVE5nNHYyOEhaWXRwSjR6TVFlOEJRUUxRUlJjaDV5?=
 =?utf-8?B?M1h1dVdtOE9mb0VMOVRudlg1VE81cW1GYlRmQVpqYjMvTU01YkFHdC9VMXlI?=
 =?utf-8?B?dDRCZ1BhLy81NEVhdVZvSnV5a0lCY1ZDYWtNRS9aTGJFOFZPL1NwYXhYOGZs?=
 =?utf-8?B?NDA2U1dCTy8rQmt1RkhDSG1kUy9qZWdYUlp3cWJJVnZ4OVl4Uk9FWno4YldT?=
 =?utf-8?B?ZnEyeGJVdytaTUhaRTZCdnd6Zk1FMXllbW1neVh3dHRGVFg4UmtqNUVMUU5O?=
 =?utf-8?B?cTRkbExXNm1zUlAwMWNmQitSVDdDVENqYml4bUthK3VHZlFYVWQrdmJOVm5w?=
 =?utf-8?B?QmErQlA1eUt2VHhvVmErWnk3b3F3dmF4OEVST0xZWnQyTjdzM0ZvRXlFNVNN?=
 =?utf-8?B?QUtCM3l3YU44aEdhbFJockhYamFiZjY2UXp1Qzc0Q2tUbkE1bEMvaHBNWDBL?=
 =?utf-8?B?RFlCNkdqZjhQMkQ0bEp3Tk9MdHRkRE1QZTQ3YkxBUUJSdjd4Mnc0MEswK0NS?=
 =?utf-8?B?dnRJTGtqeEprVWtEUFJ0QnZQVEZSd0lTUXJPbjFzM1g2QVpYc3hWOEkyNTVG?=
 =?utf-8?B?aFYrckhrbGhma0VHWnoxZ1FhV1ZHV05uWWVJdjRFdE1URTc4OStWOEhxbDVj?=
 =?utf-8?B?SFAxMWNxc0pZRFZWZVF3VnJqVWtrZVIvTU5xeE5wUXV5cy9kM2hqOXcrZnFZ?=
 =?utf-8?B?WHQreXZHUHNhYTJGRkRQcXhnRFIvRUR3YW9hU05CbFVDbFlrRDBaNVNkVkdv?=
 =?utf-8?B?azZHTHkrYlIrbE8rdzhJN1pTNUlqTnYyV1VnUWFkYTUxY09QcktLb2ZtS3lO?=
 =?utf-8?B?SDBwZnVUTnVNVk9kbEZVeE8yekFIeWFkeHJJM05uNjZ1SzlGYVFkRFk2Q3lm?=
 =?utf-8?Q?Pxu0khIB7JXNxKAk7My8gSFMmyahS4I4kvzxA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b7f299-5fcd-4c98-aaf2-08d940ab8495
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 18:26:05.9071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+HskE6H3BChEzADTXtskH3NgJ1hFKTRyxY0V2DDFn9VurzWNSmpY9CMRAr2PK8d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: _VzK30_dEHpw7x_bnVKhthVICr9Dv4pd
X-Proofpoint-GUID: _VzK30_dEHpw7x_bnVKhthVICr9Dv4pd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_09:2021-07-06,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107060086
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/21 10:44 AM, SanjayKumar J wrote:
> 	task->state is renamed to task->__state in task_struct

Could you add a reference to
   2f064a59a11f ("sched: Change task_struct::state")
which added this change?

I think this should go to bpf tree as the change is in linus tree now.
Could you annotate the tag as "[PATCH bpf]" ("[PATCH bpf v2]")?

Please align comments to the left without margins.

> 
> 	Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>

This Singed-off-by is not needed.

You can add my Ack in the next revision:
Acked-by: Yonghong Song <yhs@fb.com>

> 
> Signed-off-by: SanjayKumar J <vjsanjay@gmail.com>
> ---
>   tools/bpf/runqslower/runqslower.bpf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> index 645530ca7e98..ab9353f2fd46 100644
> --- a/tools/bpf/runqslower/runqslower.bpf.c
> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> @@ -74,7 +74,7 @@ int handle__sched_switch(u64 *ctx)
>   	u32 pid;
>   
>   	/* ivcsw: treat like an enqueue event and store timestamp */
> -	if (prev->state == TASK_RUNNING)
> +	if (prev->__state == TASK_RUNNING)

Currently, runqslower.bpf.c uses vmlinux.h.
I am thinking to use bpf_core_field_exists(), but we need to
single out task_struct structure from vmlinux.h
with both state and __state fields, we could make it work
by *changes* like

#define task_struct task_struct_orig
#include "vmlinux.h"
#undef task_struct

struct task_struct {
    ... state;
    ... __state;
...
};

Considering tools/bpf/runqslower is tied with a particular
kernel source, and vmlinux.h mostly derived from that
kernel source, I feel the above change is not necessary.

>   		trace_enqueue(prev);
>   
>   	pid = next->pid;
> 
