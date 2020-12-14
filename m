Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9F2D9391
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 08:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438913AbgLNHOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 02:14:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbgLNHOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 02:14:53 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BE71B6c004899;
        Sun, 13 Dec 2020 23:13:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=imvGekJ8JxR9V0GXhGEy3XfvSAn2qq/4nE7MtUbQ/gg=;
 b=QdYsBNUEH5WmFTO5p6YuQ67Vqg8kHDm1TX9WGMEkSqWIxltdCzodd5f9ny0vN5lSCkmw
 kcvySgtRZyT1jxZz0jut8NU3b5qQw/sEa6WSWsfPAW+R76TIzWogzUIl1W34QmOtUeIl
 bPusQKcKHj3L/QYu6Zu4B+QiejfZpjvqKTM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35desu383q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 13 Dec 2020 23:13:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 13 Dec 2020 23:13:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X020G539a3c6SONFVPq4gut7LZ+pVVVQo6oR+W2fEiKpB0sPlKX6t5Q9B6ByqU5BQQBbiSilE/gndLAHhGj3rhZD1i5DuNMNYWIdumNq5TymlP6NOuHen4uvUSZaD+Djl04bH9WUnUFwc4sZEqUDA0hveXTeyrXJHWw7wcepzfeVHf7BYSfUVnrJqojamHCBZcBHvCAcZ04isgxZoqiNhwg4XftqThG4cSc9y92MWe3tQSo/i7eV8b1QuXnhvyJfRiSv5h2skheGyFjjUystgFOIgbF5Bd03GZXpa3cV+nrIFaRHaHxIsy/8lPPz7SAyxVcE00J6J1zX+J3h7qc1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imvGekJ8JxR9V0GXhGEy3XfvSAn2qq/4nE7MtUbQ/gg=;
 b=JN4acPsspVLzUqpl/QUaN/QvMbMv1Tnet7ZnA0/kc+ancGizI1r73fKGwiaAkFH96ZyLxNOUZKG+KI7N7AaFRF6Aolb0f3zX92qIb1tETJ3ohZNbS6JlQ3enng14XbZuxpURWkqefbeV5FJVC6YsWrr9oUpK8l6pWRvvEQeobmtaz/5iJGfDfuCBP1R81JehfJCs8O7XWoxV/2oDoCDe0niwqU6CoTmD4qb4wUuXjzk2cB+UJCqYOrrJ7kqDhUMO9S4bs6DPxtgbJ3hOz1xQiKmPB0hrUyq7l4sqPt8P69drooCECN02GFIYaf0czlR0Zjg5u1sUlXUPc0jzPiXJZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imvGekJ8JxR9V0GXhGEy3XfvSAn2qq/4nE7MtUbQ/gg=;
 b=In4qxZnlrlNBNIs2Y8cMOleikPIpWICkypfwxZGCZYYBb+29HqDx1Q24IqMbpbRUsqg476026mT5u32+s70+mrllTemy+Nwxql91iRQ0aewT0LmnaEueNLQp4yTxiJUx1mgV+WfZi4uvdys0Z15RwdWaKPSqrgp5hy0SWb0Bfc8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.25; Mon, 14 Dec
 2020 07:13:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 07:13:39 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
 <20201212024810.807616-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ec9dbc75-84e7-45fe-65ab-5b0b6d86507a@fb.com>
Date:   Sun, 13 Dec 2020 23:13:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201212024810.807616-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:c9f6]
X-ClientProxiedBy: BYAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::112b] (2620:10d:c090:400::5:c9f6) by BYAPR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:c0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Mon, 14 Dec 2020 07:13:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1753705-9b2b-4e2e-63e4-08d89fffc83a
X-MS-TrafficTypeDiagnostic: BY5PR15MB3617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3617BD8A12641837DD501911D3C70@BY5PR15MB3617.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2I+8xleBBTIGS7P7o5yljYI877KuiPqbv7Nrkcs2YXPwzKr2l2T5iwXaqJXZpFyWXnRHNBXI6/OK8cDxk6V/jZYnbO3c3pzZ1xLT278KyVrKUbohFBsRlnyfk21hMLloTLT0sLWEQ1bJMouA55TnPEbE8CSH52xfB88j7w1BssiXcjU3ikpWZaE1luZXWhD8DC/VEk+Zc6lYMN/6kUOO9aTQO+kc2zSMeLi+85sDDtEbh9IZ6Wc2ZPOS+xfyz1s64NmwMpYWhB5kiFmTuX2i/09/8DdS7+n4zWknIScNZnfLwLJTbyB5osjrRnf6DaLWs9E/gTtQEd10fqYxPtIGZlNDnJmsqtXFjl8qG5lHH2ZD82d0GCx4OdgTAxhUpfN73JjAgTQDtcW8qUDujl+hY7S17XtTKQ/tw9V4PURi2lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(53546011)(83380400001)(8936002)(2616005)(16526019)(4326008)(31686004)(86362001)(6486002)(36756003)(8676002)(186003)(2906002)(52116002)(66556008)(66476007)(66946007)(5660300002)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWVaVWV4azNBUC9FY3I5NWIvYTZkL3JKeXFDcDFhMnRIWHcwcGJhcmxJSkZ6?=
 =?utf-8?B?RzEybnhxZ2RJM3hneXRRMmwxdGQ2T0FFTEk5cEtJWk5ieG0wdHRENmIvTFVt?=
 =?utf-8?B?T0luQ2I3RVlrbkNBelFnWEdmUlYrZEU1NmV2ZUZaY3MzSWZQY3ZmTHRzVzFs?=
 =?utf-8?B?ZGVXZSs0MHhOcEprcHhpY0NjaUZ3Q0RSSmUyT1JHS3FmSW5oVU9oOGN1TkVT?=
 =?utf-8?B?dGF5bWZmdkV4dXZyS0tlSjEwaXIzdTNrTG5oNDJqd0dLWndjcmVPalZZenpl?=
 =?utf-8?B?VWVWTGUrTDJadFJIUVlBRGZieVVHWFprZ1JDZFBTbU43TmJWMWVsNTVaYU1r?=
 =?utf-8?B?VUNpdmxOb1o4NjdRbkxGa2F4ZjRValBXZStSRHB3REtnTFNPMmhIT0ZFbUNI?=
 =?utf-8?B?ZFRXZmFCdENaLzZhek1udTNJNmpCdkZOWlFQTFR4L05WNkwxWTgvd01rRzA1?=
 =?utf-8?B?Y0thVEhBRjdHZU5CckpFVllvUWw4ejNHZUo2bDNUQzcwNGpjK0ROZUdXMDZF?=
 =?utf-8?B?TFlxR01EOG1rb2tPczh6dmI3SGJ1NHE2SDE4b08vak84OTBmcjRzMG5uVzE2?=
 =?utf-8?B?ODExY1hSY2NkWGgvYVZROTBBY08xRXIrYmFBVjByamRtKys3UVhDQ2xsSEZJ?=
 =?utf-8?B?ellldjAzeUtDZmJVTmtkTW5ZUzR6OU5LMzd2Zm0yaFVPbzJMNmc4TnNyNzJO?=
 =?utf-8?B?SXFWcXM3S09odS94Tlg2aHlwZmhwdTVvMVFrQ1dZb1pLU3RTUkpIL0VWeHFR?=
 =?utf-8?B?Mncwa2dwMjJtOEJIWUFaRHg0WWdHd0U5dE84M1d4d25yVy9wSzNvdFFCRkk0?=
 =?utf-8?B?ZWZINkJ1SUhad2tCUkkzK3o0Rm1LMDlUTmxYSUJWbE8wTkxVbVpwSjN3S09C?=
 =?utf-8?B?UW9aTElydjVGL3hoWWRJVHhsZjR6VVpRREk2NDRneVBMQlFTY2FJUXRQR24v?=
 =?utf-8?B?YUttYWEzcmtJR0ZaRWdTM0FnSTNjZiswSzJTV0JpRERxT2ZHeTA5R2lXYjkr?=
 =?utf-8?B?T2htOE52aFNZRW0yNFE3M29tNm5UL1dBK0MzL3hucEdxcS8rMTE2YzI3dWVP?=
 =?utf-8?B?WUZHQVBOcytGc0I3UU95eTlUQUc1VmdKVmtDQTN5U0hkYVZNWGpCbUpQeWZK?=
 =?utf-8?B?Vk0yc3kzMXRSdy9oWlF4VUczaTFDUEpqOXFqaHkyMWlFaGlOaWdSQTI5SURn?=
 =?utf-8?B?ZEEvMlFXdHgwOVRGeWVwSnNEa0s0ajMxNTU3MEFQem9SeHRLSGdNaEpCajJw?=
 =?utf-8?B?bVV3OW9GVE1BeVNoZkh5ZHJsRm1LQ2hqRGVuNG9kUTdoaFNXQ1pJbXNTQkZ2?=
 =?utf-8?B?Z0MvQytSVUhwbzh3bGM4Z3QrOGpMeXAvRWpad0FVam54YTF3MWhiZnM0WlpU?=
 =?utf-8?B?RFVERFVkTFdETlE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 07:13:39.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: b1753705-9b2b-4e2e-63e4-08d89fffc83a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syU6/ub7JvDyvJY5W3HgOo24B/SkIFCnXCtXP3TwO543XrHzon2wAR9C5rND+QVF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_03:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140053
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 6:48 PM, Song Liu wrote:
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
> 
> task_vma iterator releases mmap_lock before calling the BPF program.
> Therefore, we cannot pass vm_area_struct directly to the BPF program. A
> new __vm_area_struct is introduced to keep key information of a vma. On
> each iteration, task_vma gathers information in __vm_area_struct and
> passes it to the BPF program.
> 
> If the vma maps to a file, task_vma also holds a reference to the file
> while calling the BPF program.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h      |   2 +-
>   include/uapi/linux/bpf.h |   7 ++
>   kernel/bpf/task_iter.c   | 193 ++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 200 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07cb5d15e7439..49dd1e29c8118 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
>   	BPF_ITER_RESCHED	= BIT(0),
>   };
>   
> -#define BPF_ITER_CTX_ARG_MAX 2
> +#define BPF_ITER_CTX_ARG_MAX 3
>   struct bpf_iter_reg {
>   	const char *target;
>   	bpf_iter_attach_target_t attach_target;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 30b477a264827..c2db8a1d0cbd2 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5151,4 +5151,11 @@ enum {
>   	BTF_F_ZERO	=	(1ULL << 3),
>   };
>   
> +struct __vm_area_struct {
> +	__u64 start;
> +	__u64 end;
> +	__u64 flags;
> +	__u64 pgoff;
> +};

Probably we should not expose the above structure as uapi.
All other bpf_iter ctx argument layouts are btf based
and consider unstable. btf_iter itself is considered
as an unstable interface to dump kernel internal
data structures.

> +
>   #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10a..30e5475d0831e 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -304,9 +304,171 @@ static const struct seq_operations task_file_seq_ops = {
>   	.show	= task_file_seq_show,
>   };
>   
> +struct bpf_iter_seq_task_vma_info {
> +	/* The first field must be struct bpf_iter_seq_task_common.
> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
> +	 */
> +	struct bpf_iter_seq_task_common common;
> +	struct task_struct *task;
> +	struct __vm_area_struct vma;
> +	struct file *file;
> +	u32 tid;
> +};
> +
[...]
