Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C4C446A79
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhKEVTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:19:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231878AbhKEVTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 17:19:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5LEkLB003213;
        Fri, 5 Nov 2021 14:16:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AZUpa8lDSrKrLf6y5bS67QOa5WMKiuWAbNa3nC82Rq4=;
 b=ZSKhBSjy992Mtd86H6Z+LVK+q27lc+zeDKZeJqucapKyzR4NBNylqVXgpWAGPZvFzukX
 1t3PvW5CXfnp8sGT+vUBYpf/X6mn+O3SFwL3rGAmDtmXZJSRZZAKqu+0rRDGSbQXy4Oh
 eUx77SW5kZrOVgJm4Z+kXruc9JVF9EU6x0c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c559um7kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 05 Nov 2021 14:16:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 5 Nov 2021 14:16:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0oabzf791Yp3o1hxnm+Kxni1aFwpOcGBmHwoVZ90xWq/ir83n/uXAORYqtbd2CcJvZ6QL84eXcCm8NjbjEZV3+1MtCTEAeOhqaHoulbNeXOjog/XyIAiva6vMwXBdWkIJpja2lFpdGgweEWXvkvMJ4VP8C4P/m7NXwFFk5bo1esBCxyhMJGW6+paw5DNU4PGNQWPeInhY4atx01H0FVyQiY9RwfY9GF7zvY3/X3pjmRrD46c4BczoEFCYdWHMxQfJM+PMrtcB1ROxT7tJe1P/zAh4ionUe09qCC6bE/qKMY25MfCsZleFOY4jK1qfVt8cVJQLdUPQZ1rJLWzgIGzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZUpa8lDSrKrLf6y5bS67QOa5WMKiuWAbNa3nC82Rq4=;
 b=lvjA2/n4NXlTSegWlKwRlEMJFtYZmzl7TYv+EFNJyI9e55nv65FqdI0TD65beMlIcaNB1eJZ2MgsrHiKc/o6JtldZainll3tq6Bi/ozjsYaT6p0yeniyQia5q3lhgAhJndOTKXELgLSLiDHApbaJ8Dr9f57mN8I3YueeHE1d62plM2O6lqs+j4Rb3RhvVEMkHYHGXUoVhRNZMdudOFixYwgX1KsdJXfFUk5PzbVZI0tm9ZQ/SgPSTnyEJ0xyBh/ThIY7NyRiCG5ZkZR2Tom9EiOOHi7tWEIOfyiGM47ZQ/lsyF3yQ7xIIDKREkOCFblUc7b5NpPVG8E1gv1XcFsfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4490.namprd15.prod.outlook.com (2603:10b6:303:103::23)
 by MW4PR15MB4443.namprd15.prod.outlook.com (2603:10b6:303:104::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 5 Nov
 2021 21:16:39 +0000
Received: from MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::6d87:d8f3:9863:9ceb]) by MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::6d87:d8f3:9863:9ceb%9]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 21:16:39 +0000
Message-ID: <deed01c3-83aa-9d18-b803-ba0b427c58af@fb.com>
Date:   Fri, 5 Nov 2021 14:16:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        Hengqi Chen <hengqi.chen@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        kernel test robot <lkp@intel.com>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-2-songliubraving@fb.com>
 <6a6dd497-4592-7e28-72e0-ae253badba8b@gmail.com>
 <622ED3C4-7D40-46CF-B33E-32A73B0E0516@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
In-Reply-To: <622ED3C4-7D40-46CF-B33E-32A73B0E0516@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:907:1::14) To MW4PR15MB4490.namprd15.prod.outlook.com
 (2603:10b6:303:103::23)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:808) by MW2PR16CA0037.namprd16.prod.outlook.com (2603:10b6:907:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 21:16:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 572a350c-6ec2-488a-73d4-08d9a0a18e88
X-MS-TrafficTypeDiagnostic: MW4PR15MB4443:
X-Microsoft-Antispam-PRVS: <MW4PR15MB4443A39459B84E3525F8F9C9D78E9@MW4PR15MB4443.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6JZq2626uYTimWdkk/HwdO3o988Sf62I2/2YCpEPWjbiBzkYDQu8oJntvTuXYUk6giyVeNKspmJ9RbX21ouG/5Qag1yzuH2Fv/SSFyCfz1u2iYlH/2PW6TKlFQ8GvulaCEl08sE4VseuYE3R8YIkcQHRyPl3X04bZXNHVcBMhWFQaew7TMUTtHeaiFpdqTIT1DJBx/fsll+UgXQNFrpiqpUGaRgkWdowlc/QkPVUUhP695DXiS8/LCM3DcL38xDV5zM2QKfT7VjA9VfmDm9yKP++uY4i8t1SXGggB2fnC+lI8IXyrVeF8Al8ri3xrLgLgVK4ZvX9L4wCw/VciK2JGz3b2kzTbmydCvUoOkZUX7Xu4sc8xwtDvTJtOZ0zjJqsejIJasih0sgxvZbOxeuJl2wtQzo+vphfekdI8O17iEJGDgBTVxxtMwOFu+dHZ81zc52lSUu9dG8KFxxxICJcY6SL/BOKyWFsHQp7VZ3tctjoEgrWEHL/NbyX4gEADrVyYDzCgu+oyFpytvRfq18G7HlMZLGBKY9NgKEYpZJGTvrmskivDqpBvLmhq0rquQ7BAeGee55Scm2EM43yG9LPejhy0vg40hENcCwZqDpmx3WOy02JwD6iNuP1/kqWcAKqw0ChqdiF2nITayGbuo3eofqC1VjZbTBbzZBA8mcXb/Et4K/xLp//8aAilev5OkN3lYr9EcZ50yb1LPgoxMOX/DbsmJ3/zPXnMugQKMGXO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4490.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(66476007)(66946007)(83380400001)(2616005)(316002)(66556008)(31686004)(8936002)(8676002)(6666004)(508600001)(186003)(5660300002)(6486002)(38100700002)(2906002)(52116002)(4326008)(54906003)(36756003)(31696002)(53546011)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWZzc0FrZVh3WmNIVU9talIrM0JsM0pSN2dYdUhrMU1kL0tnY0drNll1Yktk?=
 =?utf-8?B?UXhwRmRoc3FTc2dTVnR4WGloSjUzcXpvNFMzNFVURkZGNGJIZlBZK1AyNytK?=
 =?utf-8?B?Y3M0blpjWEc2TzN6bDk3R2hObUwwRllsVUNXYlpLeUtyRU0rRk5jRVh4Ry93?=
 =?utf-8?B?ald0a0tGazZlVWFFZkUybHRvZ05xcXU2ejFkN3FEMDQ1dkJFcjNLTDgzeXZE?=
 =?utf-8?B?YnY2SnJxRHhITXoxTjltS1ZsZXpBZnJmeHJ4K1ZxbWhsOU50Qk9YLzgzOStk?=
 =?utf-8?B?V0JNNUpVVDgzNlJTaVhnTVRtdHpHUkgwZU5lcGpTTTczWkVLaXczQ21wL3hk?=
 =?utf-8?B?d2MyYlAwbjhzaDA5NWlaYXFUelpEWmVac0lBN1FzbkgrOURhYTFEaU9meHpp?=
 =?utf-8?B?Nm1sQlBXMEhrVnhWNEFmMlp4MWI2VzJHTGJ6N0prbjk3aCtOYWFoQi9xN0JS?=
 =?utf-8?B?dkFTaHR0RlA2S1pKcDZ5dFdMZTVUaWhnUzV0bk9TZkptUnJyYzBvVzFHUjVE?=
 =?utf-8?B?eks0eUtad3lVaTVndE9TVVdXVlVVeVhBQzVtazZyR05MMllRN3ZJcGlIUXhD?=
 =?utf-8?B?NEs3SkVOOUVLdXZ6SlB5aWUvTkpBWVVLbXhEbWtsQnFEcURUaXB1YzVpclRh?=
 =?utf-8?B?dE12OXlBYk8wUjBpTU5JU3dVcXI2Qk5kdFFOK1VuZXJKT3BpaElCUmxIMmlx?=
 =?utf-8?B?bzdwbk45K0VQTXROak82N1kzQWRsUm1CWkUzckNGSE41cDRhS2NlZWlGVW5K?=
 =?utf-8?B?SThNUFlJM1FaYS94WDd5MzlBOEdHYjlkOW1nTThmTWtYSTNjTWdUQ1JZeCtk?=
 =?utf-8?B?aWVScHdGWVZFMVZWdjJzalczbWtySVNBY1dnaHVIaFFHbDlrRFJUblk3MmZj?=
 =?utf-8?B?Y2ZqMERXay91UlduUVh6aHdvdzM3Zk1vellRZXdMei8rK0V1bVcySVhzY283?=
 =?utf-8?B?ZmhlcWZkU0Q2cFJXSWFxMnpmK2xubVhMZVpkb2xPUTAvSTA5NzlLQWFsdk1h?=
 =?utf-8?B?UloyWktXV28wTTRDYW9meHlWV09aeGNRQ0NSMVJEQit4ZDlZZDQwQVh5bldG?=
 =?utf-8?B?MGVsbzdKNUxOZVBhaldlWWJFclBRcHlOODllbHRHUDEyRGNXdXlwQnBNTE9I?=
 =?utf-8?B?eUVUQzk2WlQvcVpCYTZOUEZGT3VlYmFkRmI0aU5tYlNNRld2Z1pxZUlwWFd4?=
 =?utf-8?B?TDJOM2RobkJ3VUxFRlNsNFJWZ0g2Q3VmUmd4aEJMbXEvK3dWb1dPQjJIRFQz?=
 =?utf-8?B?dDRqSkVTNmtPNHU5cjR2NTN4Uy9WcHg4UllTeWZRcGV6MEtvM1BNNEl4YUti?=
 =?utf-8?B?ZDFCaW9CdnUwOGFTK2FaZXFLd21rK3FyWklaTTJab0NQNFg3MHFDV2VIUWxt?=
 =?utf-8?B?SUNOZXovOFdUdVA3bkVDK3gyN2lwU2ZtUUVXbk9WS3hJNXpGaUcwaXJwY2pj?=
 =?utf-8?B?b3k5WVF6VEdhWHRkNkZHY3lIZW5wdEs0NkhRWXgzZU1tK21BQ3JnUGZ0VmJW?=
 =?utf-8?B?V2UzMVU4Y1Q3U0FmTG5qekN3UjZPKzM1VGR1NUFWKzFHUEl4TUozdG0zSHJ1?=
 =?utf-8?B?U051NU52enRxTnZ6UjhUNzR6N0F2UnR4clppZ29BS0VadnBKSVlLUG0zcDhD?=
 =?utf-8?B?c24zYy94VDNRZW1tclNSU0xqUkVmVDl5SGFEMlIvZkYvSDI5UXJqQVdnK2xW?=
 =?utf-8?B?M0lvdjQ4ZVEwZGJFWm8vc1Q0d2hYUGNwTyswTTR1TUtodWY2cnR4N1N4YW9q?=
 =?utf-8?B?b1ZIMWNVY0s4aDEyNFZYODdyb3lEa1JMcHhJd0EzVDdQUCtqaGFIM2VUVUZG?=
 =?utf-8?B?N3dETjVzR2Y1bDZnWXZZNmtQU0hncVpBMkc0L3FQYVQza1VMVGRnNE5CenJm?=
 =?utf-8?B?RU5rbi9VN3FsTjVGNTlWQzY3MlNzRDBacHdGdE95S3AxTGUyMXdDcmI1elhR?=
 =?utf-8?B?aW9OTm5aa0hkUXpWbTFmKzZqcXZaS3hhaWhmUUU0THZibGxOSzJtUU5jbkZz?=
 =?utf-8?B?aSs3MHNsMkYrTVpqL2lLMDlGZklnM0tBUjZPVytBUW1FNWpsdnhQUVNHa1Jx?=
 =?utf-8?B?ZlY1NHdiVHlRcHNvRis5UzNtTFFwTGdPbFhoelJmK0Q1VG1wTER5bXpTL2NN?=
 =?utf-8?Q?FjxueOU/4Z/GcHAYh/A3RVuFo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 572a350c-6ec2-488a-73d4-08d9a0a18e88
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4490.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 21:16:39.4039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGxjnS3jPOP4vDUdE6aahLZpRy3TYUrpSr4eRorCDpEo5oAtd+wNdGZozS9ALgjU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4443
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: crKpQQ7xecKlB6hFnYDih9FrTggQZO1q
X-Proofpoint-ORIG-GUID: crKpQQ7xecKlB6hFnYDih9FrTggQZO1q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 2:11 PM, Song Liu wrote:
> 
> 
>> On Nov 5, 2021, at 8:23 AM, Hengqi Chen <hengqi.chen@gmail.com> wrote:
>>
>> Hi, Song
>>
>> On 2021/11/5 5:31 AM, Song Liu wrote:
>>> In some profiler use cases, it is necessary to map an address to the
>>> backing file, e.g., a shared library. bpf_find_vma helper provides a
>>> flexible way to achieve this. bpf_find_vma maps an address of a task to
>>> the vma (vm_area_struct) for this address, and feed the vma to an callback
>>> BPF function. The callback function is necessary here, as we need to
>>> ensure mmap_sem is unlocked.
>>>
>>> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
>>> safely when irqs are disable, we use the same mechanism as stackmap with
>>> build_id. Specifically, when irqs are disabled, the unlocked is postponed
>>> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
>>> bpf_find_vma and stackmap helpers.
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>
>> [...]
>>
>>>
>>> -BTF_ID_LIST(btf_task_file_ids)
>>> -BTF_ID(struct, file)
>>> -BTF_ID(struct, vm_area_struct)
>>> -
>>> static const struct bpf_iter_seq_info task_seq_info = {
>>> 	.seq_ops		= &task_seq_ops,
>>> 	.init_seq_private	= init_seq_pidns,
>>> @@ -586,9 +583,74 @@ static struct bpf_iter_reg task_vma_reg_info = {
>>> 	.seq_info		= &task_vma_seq_info,
>>> };
>>>
>>> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
>>> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
>>> +{
>>> +	struct mmap_unlock_irq_work *work = NULL;
>>> +	struct vm_area_struct *vma;
>>> +	bool irq_work_busy = false;
>>> +	struct mm_struct *mm;
>>> +	int ret = -ENOENT;
>>> +
>>> +	if (flags)
>>> +		return -EINVAL;
>>> +
>>> +	if (!task)
>>> +		return -ENOENT;
>>> +
>>> +	mm = task->mm;
>>> +	if (!mm)
>>> +		return -ENOENT;
>>> +
>>> +	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
>>> +
>>> +	if (irq_work_busy || !mmap_read_trylock(mm))
>>> +		return -EBUSY;
>>> +
>>> +	vma = find_vma(mm, start);
>>> +
>>
>> I found that when a BPF program attach to security_file_open which is in
>> the bpf_d_path helper's allowlist, the bpf_d_path helper is also allowed
>> to be called inside the callback function. So we can have this in callback
>> function:
>>
>>     bpf_d_path(&vma->vm_file->f_path, path, sizeof(path));
>>
>>
>> I wonder whether there is a guarantee that vma->vm_file will never be null,
>> as you said in the commit message, a backing file.
> 
> I don't think we can guarantee vma->vm_file never be NULL here, so this is
> a real problem. Let me see how to fix it.

It's unrelated. There was a separate thread about this.
