Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89991315DA5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 04:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhBJDBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 22:01:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13442 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229711AbhBJDBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 22:01:47 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A2xHXU030848;
        Tue, 9 Feb 2021 19:00:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gRFcT6lTPqswUXcqwC04HsUIifW12U4Ch6OKE5yr8Ds=;
 b=bTBIK5AneIqkow0xfq/FqTm23dWgQ93wPBd91BBGgq+L1/mwwxovx5Q06cbsauw4z2YM
 X7Zm0kgxPlXdKFOirXcDUrol0Udi5L317q1F0mPFGiNn8BdGX3ZSEE78x/gIvjmluMKe
 JBGPpLfz9+sLWGXFUXn6s7fmNIdbHcYSLLw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36m6xmr272-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Feb 2021 19:00:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 19:00:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUNAOccYtB5QgJ3xJiXlXhFoCH97F22wEnt8beMD0EKOTuQtN2tN4OuOHjUdpb5FO16Uc+N2bTyafnxDXcZDUOvmdGMOBv/zA4dlpx5ZaTCyP3a2JNoZvPaMlZibvfWPVQwCdu1QZki07jVS4Vll5p9LQa2zFhXoM8yAIG6U1j1MiIWHcMpm0tzsveWbp4QMl0Hs1giAbsJvyLuUdBvqKyMUX292fFQtZV/CPIsEchNTd5yGvw5bVDBvjV2A12fL1qkSidgfYrx3W0ZgO9yDtgiwJDbDLGKe54Fz9g5w6MlExMd9y6f5fDH+VqzM+fStkXKWOwa0Eom7ynZeiP7Hag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRFcT6lTPqswUXcqwC04HsUIifW12U4Ch6OKE5yr8Ds=;
 b=MT5d1luYeCzg+i/Dghep+wJGx/YDb8ZbSxmB5dC8x/6w405DOOlWxzLhnBGzn7RV3MNd2CiDsk7Y3rhFoKMxaiir1gyV9DGkPa0UY4EB0c1ONAUAcXjV2TB7y76N+SMIuWt6xvt96EvTGoIlweGehd9QalvUBfhzYVoRABYJHzTdRa1NdVixdzv9dVmydAJjWOSZpGz6vyPHZ1P2Ee8/dtgKkNXSjissJPTHkUTG7lYX3wT3OMkyQfcRU+bn2Lh1l2JODOSwDk+8Ygohb4vDvHROeMNol2Obd5onISLKh04XrDZD78KWZ4lfxxr45I0dRYfm3waQNzajZTgdowcEpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRFcT6lTPqswUXcqwC04HsUIifW12U4Ch6OKE5yr8Ds=;
 b=eVjFKUj2Sf6zNK6P/z4qp4M1aPEwmH5xqryed7WlOsQdpXEX44r19+Ja2seCMupy1gVCLcYMov/T3w+BVwa4BQn8aRgrC9WjXaTKV/psFOQz3jT0RHBo71fJw5BL/LF3deukwJu8Gz2EewXT34Pi9wTRhpHNvebb5qHLmRhM5Rc=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1411.namprd15.prod.outlook.com (2603:10b6:404:c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Wed, 10 Feb
 2021 03:00:44 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::81bf:9924:c4f1:75cd]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::81bf:9924:c4f1:75cd%6]) with mapi id 15.20.3763.019; Wed, 10 Feb 2021
 03:00:43 +0000
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>,
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
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
Date:   Tue, 9 Feb 2021 19:00:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <6846C89A-5E5F-4093-96EF-85E694E0DA4A@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6ac9]
X-ClientProxiedBy: MWHPR17CA0089.namprd17.prod.outlook.com
 (2603:10b6:300:c2::27) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:6ac9) by MWHPR17CA0089.namprd17.prod.outlook.com (2603:10b6:300:c2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 03:00:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d09ccea-f746-41b5-e43d-08d8cd700e7c
X-MS-TrafficTypeDiagnostic: BN6PR15MB1411:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB14117B7A771FF7F3CBADCB0CD78D9@BN6PR15MB1411.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMf6D2j0UC51FBESpm+CPjWnGk/5XxF5xm3uJqBISWRaNzwXZhJrFJTiDcLOt41/FvByxvaDAnMS2gkXolST+1OnV12zqx5omdmXFdW/YSZksmqPcM4sghDwSfaX7+VJKn/dKt72HNLnaERIIuo/sWsrUBwxrdMT47uZwHbsJqKFJ0LCYzrSfvLABRRw+wJtAPwnzk9dAHU4XlvmLwBh2Q7HeyJ2GKkAFl7VQmWZ6yPO3VQjqZahvEvMlvbGaAqZQQVV+/xME9dcFNYR6bunFUCZtnfPXaD2AFWmFMT4fGrNT0kED9nn0DzWpollaZTsaQfgkk/K6ivX0Xv/uGtgluMM1+DOO1gQtyilKZWxTaa9Rv7R0U9jodfG8QDIqmK+sb7X5IZvOQ1XMaWbVMY/MmYOEfPZASPWJp1OdK0K18nXC8jCWJFBPiawn05kXyKxtMBCHKE9czqc+Zh62wx6b0JNZ8PfYx6Ibj7qrI8ecMReJZv3wl2jhUdjWWZxeaqOazhinx7uf/MCBh8N9mLjKwHAmMxHj48vLu3xe2BaaJfcBuXa7T2s/UR92LyXspzEFVF+yr1knV0b2UskPojcgOkwATJygmUSil3PXIPUBds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(396003)(376002)(136003)(5660300002)(316002)(83380400001)(4326008)(53546011)(2906002)(6666004)(110136005)(54906003)(52116002)(2616005)(8936002)(16526019)(66476007)(66556008)(31696002)(31686004)(36756003)(186003)(8676002)(86362001)(66946007)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2dQa3Y2RHJnOVFSWmdodndxZ0wyUjhaRTNJTjhtWlpRaUFWV3dUMGxYNytD?=
 =?utf-8?B?bjkwM01tbWVpYUhqdVFkOWM3ZnkzVTViVDlZKzk3RkJ5cmRlcmowWHpmRWwx?=
 =?utf-8?B?SHF2U0tBNWo2VUxaVXcyWFlMV0gycFRPc2dpR01vOGNxQlNHdHo4cTZiVDNw?=
 =?utf-8?B?ejRJWHlGUityTXZvbjhnalUyN0hRMkE3UHNyY3doWFdXT0NTRjg0cVY0ZXdO?=
 =?utf-8?B?U0NmL1E1WGJIK0R2ZGN2dW1TZVIwM3QwdUZxUDBxb0kzSzFuY0d0REExTU40?=
 =?utf-8?B?SWpiK01nYTY4UzZmZUM4NThJL1VFKzlvUUdVbnZINXE0Ni9GVGx4d2NrWE54?=
 =?utf-8?B?L0NoWTk3S2xzeVlZR2FNYzdhaEdWeHBITE1UUzRXTDRtOXRrSVhtMnhUQlNJ?=
 =?utf-8?B?UWErWGhCaUdrZHU0WmhXNm91eXNhNXNwMXZ1MFJMRWk5ZjVrNlVRTDlTeDZI?=
 =?utf-8?B?c21rYmx4RTdzdXFnVkNDRjZnR2tXZEJqZFY2UmpDSVNVdUdBUW82TXRtbGVk?=
 =?utf-8?B?Z2RTbTVhaVBxNk9LWU9jN3FSYkFDTHI3dlRjVE1GMFB6Y3lQZFpNV1NNZFhT?=
 =?utf-8?B?WnBrZmFXL3Z4N3lXcFNseDE3OFA1NitkLzUvanFQcEptUFVwVlZIaE1WSUU2?=
 =?utf-8?B?RVVWSkRnd1NXNXFpUHFsVm9acGYvWXBxUTFBS0FMRVpCS1hPZjE5eC84L01Q?=
 =?utf-8?B?aUdueHhmSDRkTVpHcHU0MFBDc2EweGhJb3ZZV3E3MWhzckppZERjSHFIYnB3?=
 =?utf-8?B?dXl4QVZKdEZTNzRhakI1M1JNVnB1TmpjOG9kT0VnYTAyakNySENDZlZQSHEy?=
 =?utf-8?B?SThMb1pqK1FabitMRStZWVB0VnlwdnllYjlVWld0V3BRRUViZGVtdTcySGdk?=
 =?utf-8?B?RjcrbnZFMGNWZmdOckRvMVVHTnA0cnZPb1JRUnVpZFRoNFMzdzdKc0VNaGJq?=
 =?utf-8?B?ZEIvdzRpZWhqNk52bGg3cTZaVHpQcGFDcTFNTFI2Ym04ajJPcHUxMytUSzdn?=
 =?utf-8?B?elBkZjRPN0tXTVRQbmNRQm1CcHVDR3N4ZjVjcjFxUTRUaFpjS2w0WXVlMGdx?=
 =?utf-8?B?V0dvTlphTWtCZlI2anN4L21mWVIvTWYxZkJiM0JtZ1dLZUtjTE5NdVJoSGhy?=
 =?utf-8?B?ZHBwdWVpd0g3akhHek9ZMUpuOUNXYlhXV2V4TWZzVktzRk9MbDdkR0xveFZl?=
 =?utf-8?B?bFRKVFRIcDBQblR4MnRiMlJLeU4yTjFpTjJzYnRKaVNqME5iZDZjc2ZabUxN?=
 =?utf-8?B?VjFVUnkwbEdHRUVlVUtPNFNoMTV4RDhDQTViQlJqSjFaVnNzN2doNlN0b1ow?=
 =?utf-8?B?NHAyRnVjYVl0V20vWCtBbldZanZocWpBZUJFZU0ybS9mQ2FteTg4ZllaM09s?=
 =?utf-8?B?VGtnaktwdDNBREVsRnFWUXZMVHFNc210TmRmT1lPNzhka3NyS2ozMUp6emxu?=
 =?utf-8?B?dlBzT00zZk55VEw3UVQ4dVcrYm9pQWJzMU5nOWx5YnFIdW9LWWF2TXNwbEV4?=
 =?utf-8?B?cUtHQjVDRHdKUExMT1UvV3hjL0NkRnNQeVltQlNCamdGdWVRMFdvUER1Umx1?=
 =?utf-8?B?ekxLRHE0ZEVnQmdBWHE2ZWEzVld4aDJ3dkxicXowN1d4NGNNTVNDUGpQbG56?=
 =?utf-8?B?NFpSV0hDbG80ZDJtU2JnajJ0alNLY1FWTk9aR2Vwd0NFWm04TzRPRWh2SmhD?=
 =?utf-8?B?RVkzbWljeU5Ici9DT3JHd1llNFo4Y3diSnNxS2p1MzhzZzVnN0JpR2c2RnlJ?=
 =?utf-8?B?bmFBQ1lIeVR1ejdHQnR0Y2NBY3JqcVNIcEc3MjBONmt6TEFXYUhseUpzb2hn?=
 =?utf-8?B?YWsybTc5cEI1NEJOcU5OZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09ccea-f746-41b5-e43d-08d8cd700e7c
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 03:00:43.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9kS2kVXmJOh/QdHbvPmNnGrivhyZErUVJ06rWCbQ9sT+ztVccU96YWEwJnR0yB0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1411
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_08:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1011 bulkscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100030
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 2:08 PM, Song Liu wrote:
> 
> 
>> On Feb 9, 2021, at 1:30 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>
>> On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
>>> Introduce task_vma bpf_iter to print memory information of a process. It
>>> can be used to print customized information similar to /proc/<pid>/maps.
>>>
>>> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
>>> vma's of a process. However, these information are not flexible enough to
>>> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
>>> pages (x86_64), there is no easy way to tell which address ranges are
>>> backed by 2MB pages. task_vma solves the problem by enabling the user to
>>> generate customize information based on the vma (and vma->vm_mm,
>>> vma->vm_file, etc.).
>>>
>>> To access the vma safely in the BPF program, task_vma iterator holds
>>> target mmap_lock while calling the BPF program. If the mmap_lock is
>>> contended, task_vma unlocks mmap_lock between iterations to unblock the
>>> writer(s). This lock contention avoidance mechanism is similar to the one
>>> used in show_smaps_rollup().
>>>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>> kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++-
>>> 1 file changed, 216 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>> index 175b7b42bfc46..a0d469f0f481c 100644
>>> --- a/kernel/bpf/task_iter.c
>>> +++ b/kernel/bpf/task_iter.c
>>> @@ -286,9 +286,198 @@ static const struct seq_operations task_file_seq_ops = {
>>> 	.show	= task_file_seq_show,
>>> };
>>>
>>> +struct bpf_iter_seq_task_vma_info {
>>> +	/* The first field must be struct bpf_iter_seq_task_common.
>>> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
>>> +	 */
>>> +	struct bpf_iter_seq_task_common common;
>>> +	struct task_struct *task;
>>> +	struct vm_area_struct *vma;
>>> +	u32 tid;
>>> +	unsigned long prev_vm_start;
>>> +	unsigned long prev_vm_end;
>>> +};
>>> +
>>> +enum bpf_task_vma_iter_find_op {
>>> +	task_vma_iter_first_vma,   /* use mm->mmap */
>>> +	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
>>> +	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
>>> +};
>>> +
>>> +static struct vm_area_struct *
>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>> +{
>>> +	struct pid_namespace *ns = info->common.ns;
>>> +	enum bpf_task_vma_iter_find_op op;
>>> +	struct vm_area_struct *curr_vma;
>>> +	struct task_struct *curr_task;
>>> +	u32 curr_tid = info->tid;
>>> +
>>> +	/* If this function returns a non-NULL vma, it holds a reference to
>>> +	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
>>> +	 * If this function returns NULL, it does not hold any reference or
>>> +	 * lock.
>>> +	 */
>>> +	if (info->task) {
>>> +		curr_task = info->task;
>>> +		curr_vma = info->vma;
>>> +		/* In case of lock contention, drop mmap_lock to unblock
>>> +		 * the writer.
>>> +		 */
>>> +		if (mmap_lock_is_contended(curr_task->mm)) {
>>> +			info->prev_vm_start = curr_vma->vm_start;
>>> +			info->prev_vm_end = curr_vma->vm_end;
>>> +			op = task_vma_iter_find_vma;
>>> +			mmap_read_unlock(curr_task->mm);
>>> +			if (mmap_read_lock_killable(curr_task->mm))
>>> +				goto finish;
>>
>> in case of contention the vma will be seen by bpf prog again?
>> It looks like the 4 cases of overlaping vmas (after newly acquired lock)
>> that show_smaps_rollup() is dealing with are not handled here?
> 
> I am not sure I am following here. The logic below should avoid showing
> the same vma again:
>   
> 	curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
> 	if (curr_vma && (curr_vma->vm_start == info->prev_vm_start))
> 		curr_vma = curr_vma->vm_next;
> 
> This logic handles case 1, 2, 3 same as show_smaps_rollup(). For case 4,
> this logic skips the changed vma (from [prev_vm_start, prev_vm_end] to
> [prev_vm_start, prev_vm_end + something]); while show_smaps_rollup() will
> process the new vma.  I think skipping or processing the new vma are both
> correct, as we already processed part of it [prev_vm_start, prev_vm_end]
> once.

Got it. Yeah, if there is a new vma that has extra range after
prem_vm_end while prev_vm_start(s) are the same, arguably,
bpf prog shouldn't process the same range again,
but it will miss the upper part of the range.
In other words there is no equivalent here to 'start'
argument that smap_gather_stats has.
It's fine, but lets document this subtle difference.

>>
>>> +		} else {
>>> +			op = task_vma_iter_next_vma;
>>> +		}
>>> +	} else {
>>> +again:
>>> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
>>> +		if (!curr_task) {
>>> +			info->tid = curr_tid + 1;
>>> +			goto finish;
>>> +		}
>>> +
>>> +		if (curr_tid != info->tid) {
>>> +			info->tid = curr_tid;
>>> +			op = task_vma_iter_first_vma;
>>> +		} else {
>>> +			op = task_vma_iter_find_vma;
>>
>> what will happen if there was no contetion on the lock and no seq_stop
>> when this line was hit and set op = find_vma; ?
>> If I'm reading this correctly prev_vm_start/end could still
>> belong to some previous task.
> 
> In that case, we should be in "curr_tid != info->tid" path, no?
> 
>> My understanding that if read buffer is big the bpf_seq_read()
>> will keep doing while(space in buffer) {seq->op->show(), seq->op->next();}
>> and task_vma_seq_get_next() will iterate over all vmas of one task and
>> will proceed into the next task, but if there was no contention and no stop
>> then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) will be lucky
>> and will go into first vma of the new task) or perf_vm_end is some address
>> of some previous task's vma. In this case find_vma may return wrong vma
>> for the new task.
>> It seems to me prev_vm_end/start should be set by this task_vma_seq_get_next()
>> function instead of relying on stop callback.

Yeah. I misread where the 'op' goes.
But I think the problem still exists. Consider the loop of
show;next;show;next;...
Here it will be: case first_vma; case next_vma; case next_vma;
Now it goes into new task and 'curr_tid != info->tid',
so it does op = first_vma and info->tid = curr_tid.
But we got unlucky and the process got suspended (with ctrl-z)
and mmap_read_lock_killable returned eintr.
The 'if' below will jump to finish.
It will set info->task = NULL
The process suppose to continue sys_read after resume.
It will come back here to 'again:', but now it will do 'case find_vma'
and will search for wrong prev_vm_end.

Maybe I'm missing something again.
It's hard for me to follow the code.
Could you please add diagrams like show_smaps_rollup() does and
document what happens with all the 'op's.

>>> +		}
>>> +
>>> +		if (!curr_task->mm)
>>> +			goto next_task;
>>> +
>>> +		if (mmap_read_lock_killable(curr_task->mm))
>>> +			goto finish;
>>> +	}
>>> +
>>> +	switch (op) {
>>> +	case task_vma_iter_first_vma:
>>> +		curr_vma = curr_task->mm->mmap;
>>> +		break;
>>> +	case task_vma_iter_next_vma:
>>> +		curr_vma = curr_vma->vm_next;
>>> +		break;
>>> +	case task_vma_iter_find_vma:
>>> +		/* We dropped mmap_lock so it is necessary to use find_vma
>>> +		 * to find the next vma. This is similar to the  mechanism
>>> +		 * in show_smaps_rollup().
>>> +		 */
>>> +		curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
>>> +
>>> +		if (curr_vma && (curr_vma->vm_start == info->prev_vm_start))
>>> +			curr_vma = curr_vma->vm_next;
>>> +		break;
>>> +	}
>>> +	if (!curr_vma) {
>>> +		mmap_read_unlock(curr_task->mm);
>>> +		goto next_task;
>>> +	}
>>> +	info->task = curr_task;
>>> +	info->vma = curr_vma;
>>> +	return curr_vma;
>>> +
>>> +next_task:
>>> +	put_task_struct(curr_task);
>>> +	info->task = NULL;
>>> +	curr_tid++;
>>> +	goto again;
>>> +
>>> +finish:
>>> +	if (curr_task)
>>> +		put_task_struct(curr_task);
>>> +	info->task = NULL;
>>> +	info->vma = NULL;
>>> +	return NULL;
>>> +}
> 
> [...]
> 

