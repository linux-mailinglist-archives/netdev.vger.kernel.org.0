Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B7B39D466
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 07:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhFGFjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 01:39:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62804 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhFGFjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 01:39:43 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1575SCLI010355;
        Sun, 6 Jun 2021 22:37:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZCvZiuBOaMYtfgz4FIXVUK5XT4jYQT1sQEQOAnOqFMw=;
 b=Lx8z8Lw2kBqBGKPrLaSrEPTytYHpIg9AiQ7WYg6njSfgH81FeTpts7ugeYi40q+vHejQ
 38RFJKmuspE8P0QZZ+aBgIB6SWNPdkMyXKhnn7VugwbkCmZlPa2YEdmSvkn1dlIbj93n
 /4wi65iNFrK57Dc3ExgTEVcTWvOx1HPtGFY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3908k7ehu2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 22:37:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 22:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6lg+sALXsQwli0X6wHF6BIqC+8ZliQzmTTwHvDmKIaFiQ2jTZRPpkEtUmcVCkbK69bgpb9l5VTOc59jeItjONGNF8au4MSYoSaV03mRiWbYhh30pDB9684TWb7ohs7kBRmXMENaskGVLnru8QIxPzjYKTmiXeACVOCtV8OrN3JuzU22gxzWEKpF8bf7qOsmtTTfIEq+51E8NlvaPd9SthFbU7/yDkdY07Q4G4CfW4lp8Xooq2SFeDJLxepVSsOLuobCWByFnT3tXbYrB0brEGAzAMz3BCxZ8GaV4WI1MPXM5i6yUvkZ+AaRNqqje20LZ+T24fcMZ7928OSJ0OjY4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCvZiuBOaMYtfgz4FIXVUK5XT4jYQT1sQEQOAnOqFMw=;
 b=hoPg8zmZ+WWEFjr3oVMFuyZ5ZqSX6I2iH1Mv4EuyLzYQRg2/mRsDt/pWyksG4/TGlQjGluHSuFK1JBmyuXGfzVlsPb/KErNE4weDq8LL2fvfw3VebbPoVCWGFZvCpVYDg6mEUH/6RJUN2lvbnDu5jDZDVYzAK97u9SIzTHy7GldRx/t7r69Sxi7JhmDvGhenLqSF1Aog/qlGRPFlIXSDg9krfENZ+l3WZo6x9atet2/hEraYFIE21XDFSL9AnbACC1CgwJghpR0qEzjMxQuE9oLygcB9VEErZ08gMzaUvscjpUAbzIIuVoi6FK0ssHslhm0ITTNNkfUJhRtwyHhAIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4705.namprd15.prod.outlook.com (2603:10b6:806:19c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 05:37:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:37:01 +0000
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <de10c18b-5861-911e-ace8-eb599b72b0a8@fb.com>
Date:   Sun, 6 Jun 2021 22:36:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-14-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:9a26]
X-ClientProxiedBy: BY5PR17CA0011.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:9a26) by BY5PR17CA0011.namprd17.prod.outlook.com (2603:10b6:a03:1b8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 05:36:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba7da48d-6dc0-4ef2-86fc-08d929764674
X-MS-TrafficTypeDiagnostic: SA1PR15MB4705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4705D7E1B8C9FE1033EDCB24D3389@SA1PR15MB4705.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tnYILYFDoT0tV3/rd9cTisGgNYz8dpF2bCcx/MQZkY+bOJijV4wMk/eyLx0YzDjc0sku7FjCOhKFc2D9Th4HuZNnK3phjuDyhaPid9k2kpIhbb2WLWUlZ60pG5fCReQo/5ecQqcuOkK+vC1PwrrIKhCuei0DfTYld8qZNTWZVxtxFv2lT8nCfTmaxLgthDxRqPTcn0OuHQ3U7IhVbrGO2wg1hDzrLMBMivGLcKz+YtmTOibc0AVyE2yHtq+PifSIzRzbpxrOxtsg96ZsPB/axf4v483jny5v0FYx2nweRRFt7kYrTHFsoOXfcwevKkgBCxEoAJmen8ZnwnyL8cSMngoy5Yzrf5TxG/ls64hvteL5sFTdg7CV+0LQLnpzSDw1WRIgBPXvQG1cxAFY8puQ3ldqPWmlxG/mCsHBDeQBxhLN/3xY58rqWPVLeSHvps+1f+/RrR3jCY94Q0HHqEteP6E9tPc60DEWEmMLCXvjCDkr+y9AmG2le23s8DVkGmCPlsHSxm3ih+k8K2bV9upqX8c4UjgTVpvxJf9S7eg7jBC1C7WbTeZU9QQiFx3FxcRuvZQsOQCdDR8lm5WwkUY4EloDSWx6Q/2Un+xsWXoybacMVk45sXw7hBj+aKYYe2FTV97aY41+myF5qESJFtZqjM65styyybUpAMAESl1KyCprMRWydKogNC0UhMRYds0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(86362001)(316002)(16526019)(54906003)(186003)(110136005)(2906002)(31686004)(6486002)(478600001)(83380400001)(4326008)(38100700002)(31696002)(66476007)(66556008)(5660300002)(8936002)(36756003)(66946007)(7416002)(2616005)(8676002)(52116002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?QVSlZe03joOa+SJmo5HRf/lHqy/ZT3bJXaMo7eJfD5dKNxjfl1+OVu8R?=
 =?Windows-1252?Q?1d8Jtpz18zn9CElqSUsU9aKy/vWLRe1hHJu/+9ZcWPjq0kuLZU6tnXXw?=
 =?Windows-1252?Q?qaeJsZL7ynL+Ba6pXTjphRSiwZHOQ1/yQzyR5fuaxBAn9+NWgj+UXYBo?=
 =?Windows-1252?Q?o0SzvetsZNrhEUlm8f5lMlFIE/B/e9pBD5OKczmiCLadj0KNG9/XKirJ?=
 =?Windows-1252?Q?jMBxmucAqUuKvKeAW74Zbt119Sita8/OAwrRQIlK4Vwtxoaet1qyzxYe?=
 =?Windows-1252?Q?tJdKiRDJ83Cf4V7G3+U/b/7tanYtKTqUk38ox2VRDGDlNtRktyqDq102?=
 =?Windows-1252?Q?vqboKUFqUbkpOPTckddFs9/DxIIh05HtTzQ9gdSA7kK2WXxyl3PB9lga?=
 =?Windows-1252?Q?k5AD6sC6fpFnzfaAYlKiGTkljBvFf6DoCmPG/3JjfA2MClJRH82eRYfI?=
 =?Windows-1252?Q?t6U36MZ7mHmvjrihXnHuackuck+Nt10N+GZdZ8TpDoGi08a2G43s8kDh?=
 =?Windows-1252?Q?NH++MeuJp0aX8JZC4vPZu3Pa65huq6/r7wBJrG2r1Xq+A2TIA8EpwXYU?=
 =?Windows-1252?Q?5xBrWeLboipqE9UyKL/SIo2opuw8QzN1PCcPjwxKXgsNwaq9f/KlBupV?=
 =?Windows-1252?Q?Ad+Sjw3Q7zWM5OCm8KITq6Z64zPRH9abgCvd7mYtKNQAA2b09QUwQ+n4?=
 =?Windows-1252?Q?yasVDQzZYGewhaHhVo4kWCWtQD0eZrYpZbVksEnbxY1yboC/bwpz5xb5?=
 =?Windows-1252?Q?NP7hrHs8fxue027F3q+zB9GMpfbDoB0cxz6ZQgjda5mPv7mC6CK1nrX1?=
 =?Windows-1252?Q?OAHlvxwfPt1Z3slap4VFJtJbPryHXeSG3ITiMtopqY/QRAwzkCx6YI98?=
 =?Windows-1252?Q?418rHqgcuTJ7cRZMR+t1M13JCzy2cnSFb55LvFYnnqXA04eyjyIgfDKW?=
 =?Windows-1252?Q?zst7uX1eY4vNBtsSQk4UwuIPjO68nsqmtpLdFxvDQhr1jnbADQ9ogSYA?=
 =?Windows-1252?Q?I0osCmQ6+opPPMv75yjNjTw5PYw0E1CC52I7CNkw8KnA5UppiuL18hy6?=
 =?Windows-1252?Q?ZlxoHCfkjisvDtX7xkryOkwJ9K1rwrjENG6Ixw9PswkYbmosN/Sli2r0?=
 =?Windows-1252?Q?GOJBoPT61lguRjIZLmQbjbyufb9gT4yyjj49j1Yy1nWW3CbZVZkHTouB?=
 =?Windows-1252?Q?jgiao+8Xxk2+gaShwV2v1Bq6oq7hfpSdc8RdRWORmi9rNuUr7uhkkhaa?=
 =?Windows-1252?Q?M/8bK2tRjWZ02cFrWu+0Xur/HMV1o3sJ1VfdDMmAtunnFQRUZYHXsNlo?=
 =?Windows-1252?Q?GAYGvY2DhUBmXJrH4pCYMeVCDUVn5xL/KRGXYyZTnd8fFZXsrsKuQnSs?=
 =?Windows-1252?Q?GO8TlV1lSZQaTmwc4NI7jqrEy9TAjBkhUWKhriqoK7B7qkNkKfm8NxNk?=
 =?Windows-1252?Q?ImpUZQy/cPo04n/zbQso0pazv4avP29t0HinL602/eE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7da48d-6dc0-4ef2-86fc-08d929764674
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:37:01.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6VEysnJHkuLrf96eapirTBnYC6MDKwycslsKTmtPGuzi1yAzPiaQo33xknCK4Zc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4705
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6620qrahAWszCasvyRhYnyFOE78uYuyB
X-Proofpoint-ORIG-GUID: 6620qrahAWszCasvyRhYnyFOE78uYuyB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_03:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> Adding support to attach multiple functions to tracing program
> by using the link_create/link_update interface.
> 
> Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> API, that define array of functions btf ids that will be attached
> to prog_fd.
> 
> The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> 
> The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> link type, which creates separate bpf_trampoline and registers it
> as direct function for all specified btf ids.
> 
> The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> standard trampolines, so all registered functions need to be free
> of direct functions, otherwise the link fails.

I am not sure how severe such a limitation could be in practice.
It is possible in production some non-multi fentry/fexit program
may run continuously. Does kprobe program impact this as well?

> 
> The new bpf_trampoline will store and pass to bpf program the highest
> number of arguments from all given functions.
> 
> New programs (fentry or fexit) can be added to the existing trampoline
> through the link_update interface via new_prog_fd descriptor.

Looks we do not support replacing old programs. Do we support
removing old programs?

> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/linux/bpf.h            |   3 +
>   include/uapi/linux/bpf.h       |   5 +
>   kernel/bpf/syscall.c           | 185 ++++++++++++++++++++++++++++++++-
>   kernel/bpf/trampoline.c        |  53 +++++++---
>   tools/include/uapi/linux/bpf.h |   5 +
>   5 files changed, 237 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 23221e0e8d3c..99a81c6c22e6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -661,6 +661,7 @@ struct bpf_trampoline {
>   	struct bpf_tramp_image *cur_image;
>   	u64 selector;
>   	struct module *mod;
> +	bool multi;
>   };
>   
>   struct bpf_attach_target_info {
> @@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
>   void bpf_ksym_del(struct bpf_ksym *ksym);
>   int bpf_jit_charge_modmem(u32 pages);
>   void bpf_jit_uncharge_modmem(u32 pages);
> +struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
> +void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
>   #else
>   static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
>   					   struct bpf_trampoline *tr)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ad9340fb14d4..5fd6ff64e8dc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1007,6 +1007,7 @@ enum bpf_link_type {
>   	BPF_LINK_TYPE_ITER = 4,
>   	BPF_LINK_TYPE_NETNS = 5,
>   	BPF_LINK_TYPE_XDP = 6,
> +	BPF_LINK_TYPE_TRACING_MULTI = 7,
>   
>   	MAX_BPF_LINK_TYPE,
>   };
> @@ -1454,6 +1455,10 @@ union bpf_attr {
>   				__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
>   				__u32		iter_info_len;	/* iter_info length */
>   			};
> +			struct {
> +				__aligned_u64	multi_btf_ids;		/* addresses to attach */
> +				__u32		multi_btf_ids_cnt;	/* addresses count */
> +			};
>   		};
>   	} link_create;
>   
[...]
> +static int bpf_tracing_multi_link_fill_link_info(const struct bpf_link *link,
> +						 struct bpf_link_info *info)
> +{
> +	struct bpf_tracing_multi_link *tr_link =
> +		container_of(link, struct bpf_tracing_multi_link, link);
> +
> +	info->tracing.attach_type = tr_link->attach_type;
> +	return 0;
> +}
> +
> +static int check_multi_prog_type(struct bpf_prog *prog)
> +{
> +	if (!prog->aux->multi_func &&
> +	    prog->type != BPF_PROG_TYPE_TRACING)

I think prog->type != BPF_PROG_TYPE_TRACING is not needed, it should 
have been checked during program load time?

> +		return -EINVAL;
> +	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
> +	    prog->expected_attach_type != BPF_TRACE_FEXIT)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int bpf_tracing_multi_link_update(struct bpf_link *link,
> +					 struct bpf_prog *new_prog,
> +					 struct bpf_prog *old_prog __maybe_unused)
> +{
> +	struct bpf_tracing_multi_link *tr_link =
> +		container_of(link, struct bpf_tracing_multi_link, link);
> +	int err;
> +
> +	if (check_multi_prog_type(new_prog))
> +		return -EINVAL;
> +
> +	err = bpf_trampoline_link_prog(new_prog, tr_link->tr);
> +	if (err)
> +		return err;
> +
> +	err = modify_ftrace_direct_multi(&tr_link->ops,
> +					 (unsigned long) tr_link->tr->cur_image->image);
> +	return WARN_ON(err);

Why WARN_ON here? Some comments will be good.

> +}
> +
> +static const struct bpf_link_ops bpf_tracing_multi_link_lops = {
> +	.release = bpf_tracing_multi_link_release,
> +	.dealloc = bpf_tracing_multi_link_dealloc,
> +	.show_fdinfo = bpf_tracing_multi_link_show_fdinfo,
> +	.fill_link_info = bpf_tracing_multi_link_fill_link_info,
> +	.update_prog = bpf_tracing_multi_link_update,
> +};
> +
[...]
> +
>   struct bpf_raw_tp_link {
>   	struct bpf_link link;
>   	struct bpf_raw_event_map *btp;
> @@ -3043,6 +3222,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>   	case BPF_CGROUP_SETSOCKOPT:
>   		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
>   	case BPF_TRACE_ITER:
> +	case BPF_TRACE_FENTRY:
> +	case BPF_TRACE_FEXIT:
>   		return BPF_PROG_TYPE_TRACING;
>   	case BPF_SK_LOOKUP:
>   		return BPF_PROG_TYPE_SK_LOOKUP;
> @@ -4099,6 +4280,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
>   
>   	if (prog->expected_attach_type == BPF_TRACE_ITER)
>   		return bpf_iter_link_attach(attr, uattr, prog);
> +	else if (prog->aux->multi_func)
> +		return bpf_tracing_multi_attach(prog, attr);
>   	else if (prog->type == BPF_PROG_TYPE_EXT)
>   		return bpf_tracing_prog_attach(prog,
>   					       attr->link_create.target_fd,
> @@ -4106,7 +4289,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
>   	return -EINVAL;
>   }
>   
> -#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
> +#define BPF_LINK_CREATE_LAST_FIELD link_create.multi_btf_ids_cnt

It is okay that we don't change this. link_create.iter_info_len
has the same effect since it is a union.

>   static int link_create(union bpf_attr *attr, bpfptr_t uattr)
>   {
>   	enum bpf_prog_type ptype;
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 2755fdcf9fbf..660b8197c27f 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -58,7 +58,7 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
>   			   PAGE_SIZE, true, ksym->name);
>   }
>   
> -static struct bpf_trampoline *bpf_trampoline_alloc(void)
> +static struct bpf_trampoline *bpf_trampoline_alloc(bool multi)
>   {
>   	struct bpf_trampoline *tr;
>   	int i;
> @@ -72,6 +72,7 @@ static struct bpf_trampoline *bpf_trampoline_alloc(void)
>   	mutex_init(&tr->mutex);
>   	for (i = 0; i < BPF_TRAMP_MAX; i++)
>   		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> +	tr->multi = multi;
>   	return tr;
>   }
>   
> @@ -88,7 +89,7 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>   			goto out;
>   		}
>   	}
> -	tr = bpf_trampoline_alloc();
> +	tr = bpf_trampoline_alloc(false);
>   	if (tr) {
>   		tr->key = key;
>   		hlist_add_head(&tr->hlist, head);
> @@ -343,14 +344,16 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>   	struct bpf_tramp_image *im;
>   	struct bpf_tramp_progs *tprogs;
>   	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
> -	int err, total;
> +	bool update = !tr->multi;
> +	int err = 0, total;
>   
>   	tprogs = bpf_trampoline_get_progs(tr, &total);
>   	if (IS_ERR(tprogs))
>   		return PTR_ERR(tprogs);
>   
>   	if (total == 0) {
> -		err = unregister_fentry(tr, tr->cur_image->image);
> +		if (update)
> +			err = unregister_fentry(tr, tr->cur_image->image);
>   		bpf_tramp_image_put(tr->cur_image);
>   		tr->cur_image = NULL;
>   		tr->selector = 0;
> @@ -363,9 +366,15 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>   		goto out;
>   	}
>   
> +	if (tr->multi)
> +		flags |= BPF_TRAMP_F_IP_ARG;
> +
>   	if (tprogs[BPF_TRAMP_FEXIT].nr_progs ||
> -	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
> +	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs) {
>   		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> +		if (tr->multi)
> +			flags |= BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_IP_ARG;

BPF_TRAMP_F_IP_ARG is not needed. It has been added before.

> +	}
>   
>   	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
>   					  &tr->func.model, flags, tprogs,
> @@ -373,16 +382,19 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>   	if (err < 0)
>   		goto out;
>   
> +	err = 0;
>   	WARN_ON(tr->cur_image && tr->selector == 0);
>   	WARN_ON(!tr->cur_image && tr->selector);
> -	if (tr->cur_image)
> -		/* progs already running at this address */
> -		err = modify_fentry(tr, tr->cur_image->image, im->image);
> -	else
> -		/* first time registering */
> -		err = register_fentry(tr, im->image);
> -	if (err)
> -		goto out;
> +	if (update) {
> +		if (tr->cur_image)
> +			/* progs already running at this address */
> +			err = modify_fentry(tr, tr->cur_image->image, im->image);
> +		else
> +			/* first time registering */
> +			err = register_fentry(tr, im->image);
> +		if (err)
> +			goto out;
> +	}
>   	if (tr->cur_image)
>   		bpf_tramp_image_put(tr->cur_image);
>   	tr->cur_image = im;
> @@ -436,6 +448,10 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
>   			err = -EBUSY;
>   			goto out;
>   		}
> +		if (tr->multi) {
> +			err = -EINVAL;
> +			goto out;
> +		}
>   		tr->extension_prog = prog;
>   		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
>   					 prog->bpf_func);
[...]
