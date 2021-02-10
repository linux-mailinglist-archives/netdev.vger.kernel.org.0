Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3123173E1
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBJXDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:03:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233070AbhBJXDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:03:41 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11AMvqcl023548;
        Wed, 10 Feb 2021 15:02:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9ej2oSZZuK0otHqhYOFGMLXZoPA+hfybKWjV0YXsXD0=;
 b=h55hHw49jTYPzOMdJLz4jFOf7I1WrDp0AXW45NzQl0MJPMTxL4+q7E4D7glP13WMyPpp
 13H8I+8kfHAe9OWGR5Q2D9eejwrH9v8/Sco+JlxFMN5nwJ3wk1AnyCwhexX+6oPOhhuy
 HFIa1rnH9ddmJe1+V8Y1Ls3gqYg8Nh4gnv4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 36mcakmb6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 15:02:41 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 15:02:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmH/iBS3GZztwoVnqCgv2v5P8iOiAQc7V/qqa/ABq7qwh3G/qcLJB4n6D0yWpErrzqEYWCHYlJmVsRrtWKbaQeuny4hj3X+qgTJXHbWq4pSSfxCX7P9oGyW4tDeJoEo8KUDyVtYkH7c0ddzerZ5Leb3cmsCiBugPJUykOPJ/n60WNrwq8VjPVPSfGlKmnqURYc3Qp+hOkgrrROCjn6LRXuIFeXRHDDxmiNU44xneN1aWnSMFYW42YYAQj+GGSm2O1QqaFURjJBYSQmQmAZT5w1iT1YXZ6lrolZXRNo9Tz/gg2/ZVSFKpnD06c4G1yGZmiGsR7EK0E1krL87+Fkh4aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ej2oSZZuK0otHqhYOFGMLXZoPA+hfybKWjV0YXsXD0=;
 b=f9vuyYTkCzFbmUJWOhbU2Vwtxl+QUPfA8wm+kqg/XJvGlGDX04mU06vkoV5kJ5XWjSlJshhhvxSF6wGmoI8QxfVatfd8vsVr0eifBEqdXSMZDyxPQR+bi9qw2GXIoXS0qQWmaY+2ABwT67Sili8sPyqWbfWE1cy2I68/J+1LpVNPYCT4HJg5fCSJbLZFPneP8ibYx92/dME7isOVEW7MtwWSzigv5F2GsE0BOg55JIwh9F58wp6CJih9RpalOcSgFkgzLl+TUvZBvPRWpuFXym4WTi+PhYHsyfidjGjO9w3rcs1XkOLP0cUXsIjekW1jvaZBuKuDypTrr2mPZWJjXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 23:02:35 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 23:02:35 +0000
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Alexei Starovoitov <ast@fb.com>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
 <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
 <6846C89A-5E5F-4093-96EF-85E694E0DA4A@fb.com>
 <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fa4801f7-c31b-9518-4092-144391c715a2@fb.com>
Date:   Wed, 10 Feb 2021 15:02:32 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:8e68]
X-ClientProxiedBy: MWHPR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:320:31::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::12d5] (2620:10d:c090:400::5:8e68) by MWHPR18CA0028.namprd18.prod.outlook.com (2603:10b6:320:31::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 23:02:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c0fdc22-5997-4174-9770-08d8ce17f45e
X-MS-TrafficTypeDiagnostic: BY5PR15MB3571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3571A71F9B0142E735ADDFB7D38D9@BY5PR15MB3571.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 305QSWEaHfyV4boZ7CO/l3zQVOUtQb5M/4LZv+Ifm5UZtP6jca31RFU5M34VYFHoV5/nSTtPH3M8tw2M7ATztOmxsjw0apjfIJQ9Mb91YQh3p6Cm6rPGDNApcLplbuv1TcgvsOltiqDs3xSGEpyYrQVyQ9J/xBCqEb84cCGXQNBRIw3Uy6zvbTiUqX0rFMamxQyfdkAQhfnWlzht3kcVmfWxZfQ4lVGgFnnxA5ndxj17yne5oaE/tPEF6AKXOuRlRFz7MnEIcmS98dFMeSfeCY+3DYyhoODTnE6w7LuFCLp/HKZYoJ1yoKol6MbNf3ozba5fzZ6Cqa4vFLyXmzMv3b47/rz5VBadReg8WrkJqD5h44EUs+dQp5X4AuSItL1f0d4TF6o/af15sBDuEgwocmvHNC4RdKJR8xmkIlYfmd7Qse900qh3H+8ILNK6v/ul55/69iYHXVqLzG2agKwN/55macD+uFD2uWEyYjCXESo7SriT8njWI5hJGwdF3yK0m5tef1uQ57pukAZ8BttBicbHx6N2KLKjtX2WCxdNDCkcSnQ8QK7RLFUUVpK5PrChgI1AXtVgw00AAFuKJ4fJRTL1kSeIqUp48yxmvG2V3zs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(54906003)(66476007)(2616005)(53546011)(478600001)(52116002)(5660300002)(66946007)(316002)(66556008)(186003)(16526019)(8676002)(83380400001)(86362001)(36756003)(8936002)(31696002)(2906002)(31686004)(6486002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UzYvTjJ6a3dJbm9VMnJISGQ1UjNhZzNiLzVzY2FnNTMzMGJ3eWZ5STdmaU5W?=
 =?utf-8?B?elY2SGRpVC9DeGJ2eDhXZEVLS1dROTRNSUU3WjFUVGpyVXhtRkQ3Y0lhbWow?=
 =?utf-8?B?aStxZUV0VVdJdzF6SWltMGgwZXhNRnlkMWdzMTNsUm1TWmxuMURuNHRIRXlk?=
 =?utf-8?B?TjZ1QmRTRFcraDQxaVdUOHVIYkVrWXl5bkZtclROQjZpemkxcE4vY21KQmRR?=
 =?utf-8?B?QVc1Mk1LWnArdEdFRVhNdnJsVHVyQVlyOUQ1S2JHWFZzbVU3cmZ1U1BaYW9W?=
 =?utf-8?B?MHlQaXBpakRSMTFMLzk5NnJPeXdDNzUwNzVabjVrQzNZKytBVldXU3pvc0hC?=
 =?utf-8?B?Qjc1Wmx5Rlo3a1lFNWlHUCtiNk1acmwyYWpaV05xU2Y4STA3UmZSYnpUUHJB?=
 =?utf-8?B?Rm4xVGV0a3k4bWNvT0hCMWpOQ3E0c29MV1owdXZNZ1FuUjZacXoxN0lDWlZJ?=
 =?utf-8?B?ZzN3akFKMTBSVytSTG1nbUo5NUhhc3BkMVdOc3dMS0NJNGd5UUltZDdlSllD?=
 =?utf-8?B?YzNqOGQ2K2NZQ2VKS1lteEJDUU5zaVg4azlQM2piRFNJQzFyWjcrcmhoVjlm?=
 =?utf-8?B?NGZwMDQ5cEgwNi9rTWNGY1FOblozWTN6VmFOVWg4bHNZbEI1NmM1UDA4Ly9k?=
 =?utf-8?B?SlMrd2JTSndHbStOa1Jkd053cXFqb3lqNEpQQ0RDcUlWSldRcVU4MWYwL3M2?=
 =?utf-8?B?RGEwdFBZQ3g5dTJTZm0xYUJxTVE1KzJYMlVXYzNvMkFwK3NocVhJVllOS3hj?=
 =?utf-8?B?VC8rdGRicFR2MEx6MGdTWmdZMHJRdVlZN0tBYXpHODlHaGo5S0QwSlFJTzdY?=
 =?utf-8?B?azJBNEMrTG4rY3dHdlJaN0xKQ3d6VEF2Z0xnYzMweTgyZjZabkV1WXM1blMr?=
 =?utf-8?B?Qjc1TWtmUng2OW1VZUtaRmtyVngrL3VvMHJtVkNtVlFjeEZmUjdTbEJVOUZO?=
 =?utf-8?B?cmdtdTFpT1JVTWc0ZzJpZ0dZeEZjU3VZTFk2YlJkUGdBSkM2Q2xKUEVJRnFV?=
 =?utf-8?B?VG1MN04xNjA1Smp3WUNZSG5sM0w1Y2h1cEhYR2YvemE0THVMTXhQdlZzajVX?=
 =?utf-8?B?U2ExV0UxLzUvQWZpbHBZTTc2UnRPc1BOY2xSRmt4QlE4MjcwakdaakNrWkdV?=
 =?utf-8?B?ck5sVDI2RWljMGU4VkNRdGNhRnF1dmRZck1jQnZhV2RpMHNIb1UrUEZWdk5P?=
 =?utf-8?B?dFcyYW94dDNnUGtsZlZ4SFpXbEx4MnBpWlJDTndWdnprVVhxWTNPVloxcGpi?=
 =?utf-8?B?YlNOZjJJNUg1UVJmRFpTUm83RWQ4N3ltQ2dVZTQwL2sxa0QzR1RxcmhRcU11?=
 =?utf-8?B?Z1NhWGxONWtvMG1lNllZQjhWWk9ycmpIV2EyT014VTRvZHZCVlhjYUdBMDBk?=
 =?utf-8?B?NDZlUHp5Q2dXWUo1dGs3bjhjMXk2alhKMW5LMTltU0lQb0doVjZKaGovOUpO?=
 =?utf-8?B?MEd0elR2aGFBUGhNQ01DZU5ZUEFhLzNCU1hDSUpUWjVMR1RYRFBjWGZxSzBi?=
 =?utf-8?B?ZW01NEFKSUpCUmg0VkJSUzd4RGUrTWg2dnZaYmlxbkdiT3dMa1BXS0JxMDlJ?=
 =?utf-8?B?ZUFEOFdVM2lhRzBLbGNWSjV4V2RPOHphTmlESlJESTdWaVF1bzZ0T1dNeUQr?=
 =?utf-8?B?V0FEaVRnRXhoa2F4TE9WVXBvZFZZN0JLMHBTdkYrb0VwRDM3VjlmOFhzOEZ0?=
 =?utf-8?B?a2g0RSt3Y1F4azdPUVJFRVBGQ3c5cEY1RW9xWjNrejFKK3RmTFZPRTViRnVF?=
 =?utf-8?B?Z2JYOXN3bGhJM2k4aFUwY0pGTk94RGRxRDJDbHlvYlEyY3V0bnFqMkVBZTdS?=
 =?utf-8?B?bzlYcWZYMG0zWDRRdUVwQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0fdc22-5997-4174-9770-08d8ce17f45e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 23:02:35.4293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qq87JqNG+1ayuCzNTIemzmDnE9/xx0AIltN5oBrGPv0Rdqlimd4IBYdJiSR6wcUZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100200
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/21 7:00 PM, Alexei Starovoitov wrote:
> On 2/9/21 2:08 PM, Song Liu wrote:
>>
>>
>>> On Feb 9, 2021, at 1:30 PM, Alexei Starovoitov 
>>> <alexei.starovoitov@gmail.com> wrote:
>>>
>>> On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
>>>> Introduce task_vma bpf_iter to print memory information of a 
>>>> process. It
>>>> can be used to print customized information similar to 
>>>> /proc/<pid>/maps.
>>>>
>>>> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
>>>> vma's of a process. However, these information are not flexible 
>>>> enough to
>>>> cover all use cases. For example, if a vma cover mixed 2MB pages and 
>>>> 4kB
>>>> pages (x86_64), there is no easy way to tell which address ranges are
>>>> backed by 2MB pages. task_vma solves the problem by enabling the 
>>>> user to
>>>> generate customize information based on the vma (and vma->vm_mm,
>>>> vma->vm_file, etc.).
>>>>
>>>> To access the vma safely in the BPF program, task_vma iterator holds
>>>> target mmap_lock while calling the BPF program. If the mmap_lock is
>>>> contended, task_vma unlocks mmap_lock between iterations to unblock the
>>>> writer(s). This lock contention avoidance mechanism is similar to 
>>>> the one
>>>> used in show_smaps_rollup().
>>>>
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++-
>>>> 1 file changed, 216 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>>> index 175b7b42bfc46..a0d469f0f481c 100644
>>>> --- a/kernel/bpf/task_iter.c
>>>> +++ b/kernel/bpf/task_iter.c
>>>> @@ -286,9 +286,198 @@ static const struct seq_operations 
>>>> task_file_seq_ops = {
>>>>     .show    = task_file_seq_show,
>>>> };
>>>>
>>>> +struct bpf_iter_seq_task_vma_info {
>>>> +    /* The first field must be struct bpf_iter_seq_task_common.
>>>> +     * this is assumed by {init, fini}_seq_pidns() callback functions.
>>>> +     */
>>>> +    struct bpf_iter_seq_task_common common;
>>>> +    struct task_struct *task;
>>>> +    struct vm_area_struct *vma;
>>>> +    u32 tid;
>>>> +    unsigned long prev_vm_start;
>>>> +    unsigned long prev_vm_end;
>>>> +};
>>>> +
>>>> +enum bpf_task_vma_iter_find_op {
>>>> +    task_vma_iter_first_vma,   /* use mm->mmap */
>>>> +    task_vma_iter_next_vma,    /* use curr_vma->vm_next */
>>>> +    task_vma_iter_find_vma,    /* use find_vma() to find next vma */
>>>> +};
>>>> +
>>>> +static struct vm_area_struct *
>>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>>> +{
>>>> +    struct pid_namespace *ns = info->common.ns;
>>>> +    enum bpf_task_vma_iter_find_op op;
>>>> +    struct vm_area_struct *curr_vma;
>>>> +    struct task_struct *curr_task;
>>>> +    u32 curr_tid = info->tid;
>>>> +
>>>> +    /* If this function returns a non-NULL vma, it holds a 
>>>> reference to
>>>> +     * the task_struct, and holds read lock on vma->mm->mmap_lock.
>>>> +     * If this function returns NULL, it does not hold any 
>>>> reference or
>>>> +     * lock.
>>>> +     */
>>>> +    if (info->task) {
>>>> +        curr_task = info->task;
>>>> +        curr_vma = info->vma;
>>>> +        /* In case of lock contention, drop mmap_lock to unblock
>>>> +         * the writer.
>>>> +         */
>>>> +        if (mmap_lock_is_contended(curr_task->mm)) {
>>>> +            info->prev_vm_start = curr_vma->vm_start;
>>>> +            info->prev_vm_end = curr_vma->vm_end;
>>>> +            op = task_vma_iter_find_vma;
>>>> +            mmap_read_unlock(curr_task->mm);
>>>> +            if (mmap_read_lock_killable(curr_task->mm))
>>>> +                goto finish;
>>>
>>> in case of contention the vma will be seen by bpf prog again?
>>> It looks like the 4 cases of overlaping vmas (after newly acquired lock)
>>> that show_smaps_rollup() is dealing with are not handled here?
>>
>> I am not sure I am following here. The logic below should avoid showing
>> the same vma again:
>>     curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
>>     if (curr_vma && (curr_vma->vm_start == info->prev_vm_start))
>>         curr_vma = curr_vma->vm_next;
>>
>> This logic handles case 1, 2, 3 same as show_smaps_rollup(). For case 4,
>> this logic skips the changed vma (from [prev_vm_start, prev_vm_end] to
>> [prev_vm_start, prev_vm_end + something]); while show_smaps_rollup() will
>> process the new vma.  I think skipping or processing the new vma are both
>> correct, as we already processed part of it [prev_vm_start, prev_vm_end]
>> once.
> 
> Got it. Yeah, if there is a new vma that has extra range after
> prem_vm_end while prev_vm_start(s) are the same, arguably,
> bpf prog shouldn't process the same range again,
> but it will miss the upper part of the range.
> In other words there is no equivalent here to 'start'
> argument that smap_gather_stats has.
> It's fine, but lets document this subtle difference.
> 
>>>
>>>> +        } else {
>>>> +            op = task_vma_iter_next_vma;
>>>> +        }
>>>> +    } else {
>>>> +again:
>>>> +        curr_task = task_seq_get_next(ns, &curr_tid, true);
>>>> +        if (!curr_task) {
>>>> +            info->tid = curr_tid + 1;
>>>> +            goto finish;
>>>> +        }
>>>> +
>>>> +        if (curr_tid != info->tid) {
>>>> +            info->tid = curr_tid;
>>>> +            op = task_vma_iter_first_vma;
>>>> +        } else {
>>>> +            op = task_vma_iter_find_vma;
>>>
>>> what will happen if there was no contetion on the lock and no seq_stop
>>> when this line was hit and set op = find_vma; ?
>>> If I'm reading this correctly prev_vm_start/end could still
>>> belong to some previous task.
>>
>> In that case, we should be in "curr_tid != info->tid" path, no?
>>
>>> My understanding that if read buffer is big the bpf_seq_read()
>>> will keep doing while(space in buffer) {seq->op->show(), 
>>> seq->op->next();}
>>> and task_vma_seq_get_next() will iterate over all vmas of one task and
>>> will proceed into the next task, but if there was no contention and 
>>> no stop
>>> then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) 
>>> will be lucky
>>> and will go into first vma of the new task) or perf_vm_end is some 
>>> address
>>> of some previous task's vma. In this case find_vma may return wrong vma
>>> for the new task.
>>> It seems to me prev_vm_end/start should be set by this 
>>> task_vma_seq_get_next()
>>> function instead of relying on stop callback.
> 
> Yeah. I misread where the 'op' goes.
> But I think the problem still exists. Consider the loop of
> show;next;show;next;...
> Here it will be: case first_vma; case next_vma; case next_vma;
> Now it goes into new task and 'curr_tid != info->tid',
> so it does op = first_vma and info->tid = curr_tid.
> But we got unlucky and the process got suspended (with ctrl-z)
> and mmap_read_lock_killable returned eintr.
> The 'if' below will jump to finish.
> It will set info->task = NULL
> The process suppose to continue sys_read after resume.
> It will come back here to 'again:', but now it will do 'case find_vma'
> and will search for wrong prev_vm_end.

Thanks for catching this. I have discussed with Song about return value
for mmap_read_lock_killable(). We only considered ctrl-c case but
did not realize ctrl-z case :-(

Song, you can return a ERR_PTR(-EAGAIN) here. This ERR_PTR will be
available to your seq_ops->stop() function as well so you can handle
properly there too.

> 
> Maybe I'm missing something again.
> It's hard for me to follow the code.
> Could you please add diagrams like show_smaps_rollup() does and
> document what happens with all the 'op's.
> 
[...]
