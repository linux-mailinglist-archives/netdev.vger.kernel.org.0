Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68582DDD36
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 04:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgLRDRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 22:17:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbgLRDQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 22:16:59 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BI3DT7D017266;
        Thu, 17 Dec 2020 19:16:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5SVTVLhAlksCuLUDW6Tepgbt/fN37FiBhV5Fxzusui0=;
 b=dkYl5ZybyCqHsDbB7urBu/5Fwc0Tlg15dlpknBM7Ul6iUUCyJGaJ9g6WD/xwzsbFlLIC
 QLpG6jp38J7Y/X12cOAU8OneXKtpvLIPgxJrQaNNI/qWde8m0smbppGHY2tJBiVsCI2I
 Z/gwAkuUe+z//7gIYDCzO55BcMyCkOUtYJA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gbrjtkv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Dec 2020 19:16:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 19:16:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CejSDre5TXL0MI9s7BKL234cXMdyQjfNz2jJ6q06kSuMvQFL8Rz+wHSdgoP70LnPc0pYZhn5S+dlmYyS2MyTilEhCHKgQSOdRjc9wDJyULuoG/Q1ifvkuVnidypk+2fnJSc++d/OUZKugWVEeb6MljLHn37uENCcl+Vahemne+h0ajreFGnPu4uNIbahbx+jPIakOBNnupP6IMc0Bdv7J/AQw6xupcE3CsD2Ga3ExTl03PeLOhMIRTPynoUNdFDEH2bcAoV+pTpN2/9kyOQiB4vg5QsuJToc3RVBQxWOGrW4Ki0v4X62MxUOeDMvLdksNbozxr8TKHrZPnnD2FPgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SVTVLhAlksCuLUDW6Tepgbt/fN37FiBhV5Fxzusui0=;
 b=VEXRj6t3sDels49E0ki5CCeU1y/jD+puxRleyO6xLZnPjY5k8Fimh7yB56RCwNDeq0HN7MZD4DXADTFwwRvQGB8NPiBvi4WTiwcEmAInb3xh6EvbH+9PI8oF5DzYOhL9Rb8J15ZL+zXgvp/aRnIqlPihe2kIBobldV5pBWkKSSoeK39f3MWEIj9by1OLlNNUUgrNxipioytApqVa3Ha6/bQjorjCUOORbjvlVAoUjjCMEH+OSyszcmw+L0JIE2aDadFaxX1heW9fUYJmeNscpp5sNG185o6iQm8dDGkcVV1q9NN38M0enJFRmgmQ+/AxSPuIUw9inzUJx4tErLtl0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SVTVLhAlksCuLUDW6Tepgbt/fN37FiBhV5Fxzusui0=;
 b=fSK2n/h+3N2MvHQtvrc813cI/YO4c1Ta9GEsgE7bozFap5uO6nLlMUhVDgbEBkLQh30nmt12PV3eVY+ziKacgSU+nFFaezpYNXF+iek+1dFV6QmjKbootEUAmJbsOMmGkKciyulbEzj5qdIJgiNuvHyv+W5Kn/RHpuPwfgOaZ+c=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Fri, 18 Dec
 2020 03:15:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 03:15:57 +0000
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <74326643-e457-f497-4cbd-c99d9b2c6405@fb.com>
Date:   Thu, 17 Dec 2020 19:15:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:370a]
X-ClientProxiedBy: MW4PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:303:b4::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:370a) by MW4PR03CA0265.namprd03.prod.outlook.com (2603:10b6:303:b4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17 via Frontend Transport; Fri, 18 Dec 2020 03:15:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1731904-f9e7-434a-5612-08d8a3033d1e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB309479200CFFEA0BDDF6BBA9D3C30@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t1k0sR3qANa6wuqqEbjbWZW4VCRYlwmXiGst+ju5eQXMrY5V4BcAy7hwQGrRU/5AftgI7sX/bntbNI59VGMjQZ8Kc6PMPHFvZ3Jhc1oQm/uSZeiMZUw3HssmUe937fWEFIZD3motj+q1oHA/7HXluCYRfmaERgU1Qszfp+BCDeenjWiu/BucjPyuJznEW15KX+kapbtvuTQTqJ3A31gni9clIxsAYRZVT76QSioo5UkgtRpwnWT8mEQ3J5+6Dt5IKppIU9EKYEUy2tZyWtZPxi4XQQW5rZafq9fOuzQs/lFS8Ub/rIfIZqyD/vER9geAy0xBpCJTZMcrFSIl+MjkCx9ouUhjKaLRU0qTUijHvDPBtnxq9ia29IAL1zCobArV6NQzu3nzLSHmnMNC9LYd3NrIR9Xwt34wq0jaDBhHnyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(31696002)(66476007)(16526019)(54906003)(86362001)(2906002)(2616005)(8676002)(478600001)(36756003)(83380400001)(6636002)(4326008)(66556008)(8936002)(316002)(52116002)(31686004)(53546011)(5660300002)(186003)(110136005)(66946007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUtoaUpXdHVobUlkblFRbFhiWklCaWxMdm5DdVZHN0Z5ZmovMTB1QmNCSUFP?=
 =?utf-8?B?ZWJUQlhWUVE4K1pOYmlBZ2xsV3BQc0JHbWFzdUZXb2tjdU5mU0pNalM5VFM4?=
 =?utf-8?B?RE15UkVPTjFNZGFWVThUZDBsdENobGU4eXYvRWZQZ20wVzVBUVkrczdScG1H?=
 =?utf-8?B?Rmt4cGZnTFViYkMzZFM0S2sxcldub1RKVVV1SDJpZ05CeG9HZ2lESG1wbGtI?=
 =?utf-8?B?aG16c0MzOEh4aW1vVlYzbUcxSWljTE5mMGNSVitkaHJiSUN5TzRqVnV5UThS?=
 =?utf-8?B?SWxSK2J4dGhkdTJucUFIbFZLSnhPSDZxMGhhek5ycC9pNkpVUjRoOTRnQUVT?=
 =?utf-8?B?OG9DS25jay95bXNzR1dkdVhGNUthTklhdWt4Ums2ZUFycTlKaUhzNk4xTWxv?=
 =?utf-8?B?WlBQbTE2T3lYUExTMTZRQkk0K2Nnc1FLNXlYbVlVRlVUaDd3RElzd29LNHN1?=
 =?utf-8?B?VEZERzEzQi81TGpwaWowQzZkaXFIdVJDM0t3S2IzeWtVVWFZb1E3Z1d4SG4z?=
 =?utf-8?B?ZzlvUExNOFV3U2syU3ZMZzBpUlVyVStQK2NZbVVIZnJhek9qSHBWVUdsdWxB?=
 =?utf-8?B?TkVzdUVoNklxNTgyR1VuZFFWVUdyenRuNDdVcTJrR21nNUk5endvWFdDM3gz?=
 =?utf-8?B?eXhQdkVLcUpSVnY4V3k0UjVPQzFIRk9ZOU9DT3lKOSt0dDlPODZRWFg5Z2xR?=
 =?utf-8?B?NG5RVDEraFBiZFAzOER0SmZRTFg5Wm9TTHFuU3pjZXNjZDh4YjRoOGFzZTN3?=
 =?utf-8?B?YVFYYUk2NnJ5QlFDRExhai84QkRMVHArRFVRb05tU0F4ZDJTdnM3RktaTlk2?=
 =?utf-8?B?dlBRU0NrdndXMkNPSmFCVi9kZnJVSTE5Wlkvc1BtR2d0ZVcyMk1Ja1lCdWFH?=
 =?utf-8?B?dEFJTGhEZ2EzR3YrSURQQkxSRnU3bkorVlBzUnIzM3pWcjlxbmZ4bGdFRHNz?=
 =?utf-8?B?MW56aUxPbFVyZ0dXNUtQdzdRSjA1d3NZT0NMeHk5MUw0eFlMcy9qRVZKZ2do?=
 =?utf-8?B?Z0pWRTIzaUFlTHVKYkw0R05rN0Y1NXVCckFxNHk1c2k4UjEvbm5HNWgxTzFp?=
 =?utf-8?B?dkRIYkJoRWJ5ZlJwRVZrQlg2aDdjNkd2L1V2WTRzZVRrV1Y3UmJBL0tCQ3hZ?=
 =?utf-8?B?SElzajJDVzQwVGxyenoxU29HRCthMjJxWHk4S2c5Z0ZxSWhtVnpubndqdXU5?=
 =?utf-8?B?RWd0elZFR1ZQeDBPdmE4ZmhtOVJnZW5raDdvbWl2cUFhWGdJV3FseWZkTmdW?=
 =?utf-8?B?QXo1cm1hdEhTaGIweWxwOXFyU1JLZFZaV1NpZ2I0eVR4QVBNOFpMWVJoQTBI?=
 =?utf-8?B?UzZZM1kwcTg5b1A3Wkw4WUxYRUhOVkROV2dnUzRsWDMrWUFvN3ZERU9odUQ4?=
 =?utf-8?B?akJsN1k2OStPekE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 03:15:57.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a1731904-f9e7-434a-5612-08d8a3033d1e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQpKkGadt1yl5aLmi8Zt8fhCJCo5k4LnqdgBAlu1MtUv+VgkMYi/aI2r6Ht4fBHD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_17:2020-12-17,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/20 6:34 PM, Alexei Starovoitov wrote:
> On Thu, Dec 17, 2020 at 10:08:31PM +0000, Song Liu wrote:
>>
>>
>>> On Dec 17, 2020, at 11:03 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>>
>>> On Tue, Dec 15, 2020 at 03:36:59PM -0800, Song Liu wrote:
>>>> +/*
>>>> + * Key information from vm_area_struct. We need this because we cannot
>>>> + * assume the vm_area_struct is still valid after each iteration.
>>>> + */
>>>> +struct __vm_area_struct {
>>>> +	__u64 start;
>>>> +	__u64 end;
>>>> +	__u64 flags;
>>>> +	__u64 pgoff;
>>>> +};
>>>
>>> Where it's inside .c or exposed in uapi/bpf.h it will become uapi
>>> if it's used this way. Let's switch to arbitrary BTF-based access instead.
>>>
>>>> +static struct __vm_area_struct *
>>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>>> +{
>>>> +	struct pid_namespace *ns = info->common.ns;
>>>> +	struct task_struct *curr_task;
>>>> +	struct vm_area_struct *vma;
>>>> +	u32 curr_tid = info->tid;
>>>> +	bool new_task = false;
>>>> +
>>>> +	/* If this function returns a non-NULL __vm_area_struct, it held
>>>> +	 * a reference to the task_struct. If info->file is non-NULL, it
>>>> +	 * also holds a reference to the file. If this function returns
>>>> +	 * NULL, it does not hold any reference.
>>>> +	 */
>>>> +again:
>>>> +	if (info->task) {
>>>> +		curr_task = info->task;
>>>> +	} else {
>>>> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
>>>> +		if (!curr_task) {
>>>> +			info->task = NULL;
>>>> +			info->tid++;
>>>> +			return NULL;
>>>> +		}
>>>> +
>>>> +		if (curr_tid != info->tid) {
>>>> +			info->tid = curr_tid;
>>>> +			new_task = true;
>>>> +		}
>>>> +
>>>> +		if (!curr_task->mm)
>>>> +			goto next_task;
>>>> +		info->task = curr_task;
>>>> +	}
>>>> +
>>>> +	mmap_read_lock(curr_task->mm);
>>>
>>> That will hurt. /proc readers do that and it causes all sorts
>>> of production issues. We cannot take this lock.
>>> There is no need to take it.
>>> Switch the whole thing to probe_read style walking.
>>> And reimplement find_vma with probe_read while omitting vmacache.
>>> It will be short rbtree walk.
>>> bpf prog doesn't need to see a stable struct. It will read it through ptr_to_btf_id
>>> which will use probe_read equivalent underneath.
>>
>> rw_semaphore is designed to avoid write starvation, so read_lock should not cause
>> problem unless the lock was taken for extended period. [1] was a recent fix that
>> avoids /proc issue by releasing mmap_lock between iterations. We are using similar
>> mechanism here. BTW: I changed this to mmap_read_lock_killable() in the next version.
>>
>> On the other hand, we need a valid vm_file pointer for bpf_d_path. So walking the
> 
> ahh. I missed that. Makes sense.
> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
> 
>> rbtree without taking any lock would not work. We can avoid taking the lock when
>> some SPF like mechanism merged (hopefully soonish).
>>
>> Did I miss anything?
>>
>> We can improve bpf_iter with some mechanism to specify which task to iterate, so
>> that we don't have to iterate through all tasks when the user only want to inspect
>> vmas in one task.
> 
> yes. let's figure out how to make it parametrizable.
> map_iter runs only for given map_fd.
> Maybe vma_iter should run only for given pidfd?
> I think all_task_all_vmas iter is nice to have, but we don't really need it?

We could make pidfd optional? If pidfd == 0, all vmas of all tasks will 
be traversed. Otherwise, pidfd > 0, only vmas of that pidfd will be 
traversed.

> 
>> Thanks,
>> Song
>>
>> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on mmap_lock")
> 
> Thanks for this link. With "if (mmap_lock_is_contended())" check it should work indeed.
> 
