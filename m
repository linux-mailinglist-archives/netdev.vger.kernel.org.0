Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EEA20B4F6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgFZPlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:41:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28810 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgFZPlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:41:14 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QFemej007731;
        Fri, 26 Jun 2020 08:40:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=isarmgW2MOpY/ksuOPlqWRlgjv4SoPwlvSeatlbihuY=;
 b=UXHNICYtkzG4uuGWsrUzvRLAAf/j1NAE2sssoomVsZj0EAThceXB2CQOuQfGQarCxti/
 kv2Ge+6fNSmujdJlJMxLGl0NBmNw51LcVHkAvojQKo1Gqdy2hsSsMO+nEUdsajITUyjB
 FKIeN8hOAmUyjopU2SuL1G/qUxRgSKkJJo0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1ewyac-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 08:40:50 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 08:40:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdMKb0MaicI99IDd4sJ3svkUuBPBYpKh86kFRmjJXmEol35P+t1Y0YCjQYXa0teJiD+FcxtrcQEHOZhtvTfSGFJcgfdqcEkD34KnJNR5wMICdr66dabPNNXOt+cKusvA+Eca25tsW/s2iMJUFdtcJTc5h9jfTuEaPbQWcy0CIJoQjBzx42HLZYA/3y2JsA66T3/LztB/deOPOUPOLdfrmwb1UGrtGoK8Dbtg9ohujxyFP51hVvdE08ooi0ityPd+FJifrOYg85kv44UjbdJqhzjix1JE/E8dOSHXJp90Jfa5TORjav7n89i+pCFQnTy+rOanX48tLVsxeql0fYpU8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isarmgW2MOpY/ksuOPlqWRlgjv4SoPwlvSeatlbihuY=;
 b=Y3Fh8N0X7JJMpPfHH/Uyb8rzxjkZZXH0BwLBaC2qzNFpire+3IpnFbQrcG5Hg2OxW53fmQ9VHBkmnXTa8zCbcx8tA4Hfli0P/RhpsOcvQAMsiOGwO6D3P+r8pCIDjrSctV/LLsZalr9N2eLUY/tZWa7Vrd/VlNyST+1ae3XyOdw2UnIxstD1PDOt9CXeX6t/LI1L7uF8HjTPfbeucHK8CinZD1OUCvSFdKrwybFBwh6kvnpdtU7zkR2QsDsoLd5MQ5fW/jxMAWJdV25F4k7cibJ9Nl2Qv0vJ0XKQjLaQc3ujl1CaupDtPGErffjOv6iFJU164OCg8btpaoxHEuweDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isarmgW2MOpY/ksuOPlqWRlgjv4SoPwlvSeatlbihuY=;
 b=buRh0WZcVUigXD7lG+bG82inxHAxN499GVgwCCdiEYz1qADesxzZ81wz/mqngf7F7Q5w+icjUagUsVVr9JYuKyaQ3ObMjDzLCZAX2HFy6AFYUqPA5UiLcPd23NUFy1rLhPMRDtrqgj+1VG3YIhUlmBnheIktilh0umR9Do3mpYY=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 15:40:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 15:40:37 +0000
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <572bd252-2748-d776-0e7b-eca5302dba76@fb.com>
Date:   Fri, 26 Jun 2020 08:40:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200626001332.1554603-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::18ce] (2620:10d:c090:400::5:ca25) by BYAPR05CA0091.namprd05.prod.outlook.com (2603:10b6:a03:e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Fri, 26 Jun 2020 15:40:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:ca25]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b5fa574-6274-47dc-268f-08d819e74618
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3461253E5AB1DC76CFCD53F7D3930@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqwnE0XX6vvZavdL4yJYKlybWvUQ4KhxumovoDcq7Y6vbrLWM9lNGxL+eHeU6jcofBQ+6ryY9UzIaqa80efLwCNoyHEOSt25GFnjp8dMCXFIipCWznryP48kkaQQO1mWx9hj3QhJs2TlpND4tAp7qpcwWL9ex5Wk+bETquGvybpJUqFETkTV8aJsARr7DQlcVfQm3rGpGADSaQKyyyTiHnuktikttuOzhHiP9xY4ulhcArU2gFNwWTeGbjtpT3hIpCuVR7oZbd7okQemonMtSCNmp7/cLsqPU6XWxIwxNmlVtgKLQEW7eo3YDEp1wJo8riTnMfFUhKsSwHbYOu6/fsJJt1cSIvCJcqinc7o+Dnr4VL5UjLIbFEW8jfDhW37p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(316002)(52116002)(6486002)(186003)(16526019)(53546011)(66946007)(8676002)(8936002)(66556008)(66476007)(6666004)(478600001)(4326008)(86362001)(5660300002)(31696002)(2906002)(31686004)(2616005)(36756003)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xpGvSfsLDzACtHybBcwQV59j5YablHFDyxWkiMujhffK53X0TKJZPDamdhihlZ4x5wszOrIikVpiduzGOnMTCbDxOC3AMiV2Sn9zmYNAAbYsg6Tb/+yZDwqtvSuGTW+utsVjhApQ33kl7WxMUXGxP0ogMuhVeRdP3eCSRLS+FXgBAa7c0jgsuaC4jZnHXkBbxkLEcbHRsWnoMzNgWZtpiHFjhDoD26tq34j0O83zqXBT7/HheoVsqe1YgTNr4AeYsbeTNQt1WNCjoX6ulNBYBzkxd6etwrc3p+JKVcBUEV+jbhPgI16sGCq2ZUrly9nI1MAhDPYbq7Wo67uo3DzdyQBR7xEmDHTscOncgBUsVPCBEg+7t9Th9UsHYy5ECnJisywxJnpRrH+LFaQOqFjQrFeMsheIK3j8v4KvzAANEGkptZjv7zo0bP91tRBjLR+Okif/LzuOXwfxz4DRYmiPEaij2aRe/E13NX4C1fwUTgibLoZoBFeVqfRGKF8yrrW3K1P1bkpCgF62QzjmmPV3Lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5fa574-6274-47dc-268f-08d819e74618
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 15:40:37.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VERqDO47c5SPRgRnCn4axF8M+S1x/43XGUDSPa9aHo1MwtW/FafafuG3OmFvWmWM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_08:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1011 cotscore=-2147483648 spamscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260109
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 5:13 PM, Song Liu wrote:
> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> task. This is different to bpf_get_stack(), which gets stack track of
> current task. One potential use case of bpf_get_task_stack() is to call
> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
> 
> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> get_perf_callchain() for kernel stack. The benefit of this choice is that
> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> stack trace to unsigned long array. For 32-bit systems, we need to
> translate it to u64 array.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       | 35 ++++++++++++++-
>   kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
>   kernel/trace/bpf_trace.c       |  2 +
>   scripts/bpf_helpers_doc.py     |  2 +
>   tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
>   6 files changed, 149 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07052d44bca1c..cee31ee56367b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1607,6 +1607,7 @@ extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
>   extern const struct bpf_func_proto bpf_get_current_comm_proto;
>   extern const struct bpf_func_proto bpf_get_stackid_proto;
>   extern const struct bpf_func_proto bpf_get_stack_proto;
> +extern const struct bpf_func_proto bpf_get_task_stack_proto;
>   extern const struct bpf_func_proto bpf_sock_map_update_proto;
>   extern const struct bpf_func_proto bpf_sock_hash_update_proto;
>   extern const struct bpf_func_proto bpf_get_current_cgroup_id_proto;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 19684813faaed..7638412987354 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3252,6 +3252,38 @@ union bpf_attr {
>    * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>    * 		is returned or the error code -EACCES in case the skb is not
>    * 		subject to CHECKSUM_UNNECESSARY.
> + *
> + * int bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)

Andrii's recent patch changed the return type to 'long' to align with
kernel u64 return type for better llvm code generation.

Please rebase and you will see the new convention.

> + *	Description
> + *		Return a user or a kernel stack in bpf program provided buffer.
> + *		To achieve this, the helper needs *task*, which is a valid
> + *		pointer to struct task_struct. To store the stacktrace, the
> + *		bpf program provides *buf* with	a nonnegative *size*.
> + *
> + *		The last argument, *flags*, holds the number of stack frames to
> + *		skip (from 0 to 255), masked with
> + *		**BPF_F_SKIP_FIELD_MASK**. The next bits can be used to set
> + *		the following flags:
> + *
> + *		**BPF_F_USER_STACK**
> + *			Collect a user space stack instead of a kernel stack.
> + *		**BPF_F_USER_BUILD_ID**
> + *			Collect buildid+offset instead of ips for user stack,
> + *			only valid if **BPF_F_USER_STACK** is also specified.
> + *
> + *		**bpf_get_task_stack**\ () can collect up to
> + *		**PERF_MAX_STACK_DEPTH** both kernel and user frames, subject
> + *		to sufficient large buffer size. Note that
> + *		this limit can be controlled with the **sysctl** program, and
> + *		that it should be manually increased in order to profile long
> + *		user stacks (such as stacks for Java programs). To do so, use:
> + *
> + *		::
> + *
> + *			# sysctl kernel.perf_event_max_stack=<new value>
> + *	Return
> + *		A non-negative value equal to or less than *size* on success,
> + *		or a negative error in case of failure.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3389,7 +3421,8 @@ union bpf_attr {
>   	FN(ringbuf_submit),		\
>   	FN(ringbuf_discard),		\
>   	FN(ringbuf_query),		\
> -	FN(csum_level),
> +	FN(csum_level),			\
> +	FN(get_task_stack),
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>    * function eBPF program intends to call
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 599488f25e404..64b7843057a23 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -348,6 +348,44 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
>   	}
>   }
>   
> +static struct perf_callchain_entry *
> +get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
> +{
> +	struct perf_callchain_entry *entry;
> +	int rctx;
> +
> +	entry = get_callchain_entry(&rctx);
> +
> +	if (rctx == -1)
> +		return NULL;

Is this needed? Should be below !entry enough?

> +
> +	if (!entry)
> +		goto exit_put;
> +
> +	entry->nr = init_nr +
> +		stack_trace_save_tsk(task, (unsigned long *)(entry->ip + init_nr),
> +				     sysctl_perf_event_max_stack - init_nr, 0);
> +
> +	/* stack_trace_save_tsk() works on unsigned long array, while
> +	 * perf_callchain_entry uses u64 array. For 32-bit systems, it is
> +	 * necessary to fix this mismatch.
> +	 */
> +	if (__BITS_PER_LONG != 64) {
> +		unsigned long *from = (unsigned long *) entry->ip;
> +		u64 *to = entry->ip;
> +		int i;
> +
> +		/* copy data from the end to avoid using extra buffer */
> +		for (i = entry->nr - 1; i >= (int)init_nr; i--)
> +			to[i] = (u64)(from[i]);
> +	}
> +
> +exit_put:
> +	put_callchain_entry(rctx);
> +
> +	return entry;
> +}
> +
>   BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
>   	   u64, flags)
>   {
> @@ -448,8 +486,8 @@ const struct bpf_func_proto bpf_get_stackid_proto = {
>   	.arg3_type	= ARG_ANYTHING,
>   };
>   
> -BPF_CALL_4(bpf_get_stack, struct pt_regs *, regs, void *, buf, u32, size,
> -	   u64, flags)
[...]
