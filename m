Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1D39D3B6
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhFGD71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:59:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40942 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGD70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:59:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1573skDB009612;
        Sun, 6 Jun 2021 20:56:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QueHHSIpLXbu1VImyJhDrQU6yyDicHdiJKoB+7hXU4o=;
 b=cwrDnck3RGileT4vws2r9dEBn1ZM/tQjLacGWFGVLndCGzKto90Cab0Ad4S7OafrbzPT
 ZzfPjw1Y7Qjh9y2D9C1h30/Tzwts/gdvU57uxWuy/cLzfgZOya4krElqN4/bORadjuCr
 w8P+us4eMqjHStNmjTi7Zb9eF1FeT4TWdcg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 390s14kbvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 20:56:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 20:56:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4rvcDM56T1EuQJ6QAr0hb8p65gVAwINTVhm+OiYfLMniRSZCf2lT8aTlL9MQbD5NkJYMlBeZ6Vy7XkrctVSivXTdpetq7OkoSD0Gbeigxi/t75SbNBQJuuEOilVjld1doYzXT9XNmmSiipEE7Yx7eFiHD76QVQPYcsq3oZ0sa/vK7HUpd7ZYIMWdOsds4OUGUNZDjq2drBB98QNjBqx62rva0/kTy1ER53j149/NXT5Gv+ZAFKo9IxmpYqdzCcp5gytMIOZ2DDW4jrrC2cVTr93so63/zvLYfGXfSQap/GYJxunJt1+n/zo+lF2Mj60sEEgejwEV27sz8bFhSj5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QueHHSIpLXbu1VImyJhDrQU6yyDicHdiJKoB+7hXU4o=;
 b=FmIsWsYIpCkxzrCHOmTReWTWxQygST+ud3VxgokZn4OnV4u1w9EsTq0M8u/SVw7G9/xvUOU7AmPF+L2c8ncuzAQ1RU2vmBmC/NCo9O7g7+7Q5Jo4zGsP575jysGZBIq3K0c6C5lH1EoLkX9fsq3oXRtJ/34m7cu37ByDAYDIxjKNsFGRPdwrj1I8/KbjpjQgohQqRMrXC5ZmkmJtdZgDtbA1pZ6YzvgZsZ+wdgedo7gIZZc3FsZlfUo6wXVLvm5LyJccrDR9ED4u9tKdh/4Pok2IpDqfOPi0Yj/J5rSbSE+MMc/AWziNCFn0pSGJu3cP2YDCecqjWRlRbupCAMq6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4450.namprd15.prod.outlook.com (2603:10b6:806:195::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 03:56:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 03:56:50 +0000
Subject: Re: [PATCH 11/19] bpf: Add support to load multi func tracing program
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
 <20210605111034.1810858-12-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <db5c591c-c5f2-9bcc-28bf-f5890c2cf61c@fb.com>
Date:   Sun, 6 Jun 2021 20:56:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-12-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1571]
X-ClientProxiedBy: MWHPR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:300:93::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:1571) by MWHPR17CA0065.namprd17.prod.outlook.com (2603:10b6:300:93::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Mon, 7 Jun 2021 03:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e428a9-6d7f-426f-7bbb-08d9296847b7
X-MS-TrafficTypeDiagnostic: SA1PR15MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44508B34568A3351D81A6316D3389@SA1PR15MB4450.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+CKGBvYRdor/woj3Rxw0zjZ5ERxbz3REXP+cejpqTOQJkGV1JSvprMMO7w75Ax2Qs0N54QmxwrZWTWTlsVyvV366Xa/jAfcBWVbH5fhrCG/a99RnFf0mTjNFhpiLhYAoFYDn02YWqrH+9zE4NoO7+c/TrU9+KBHzZeYw1Z1O/yQdGrWV28vgGIil8AL40zxFHjujmB4rV0V91xyJoE1xlKiVw25QWOmUim677QJ0GpeBdEhE0e1ffUPbmeb8J9+UAwkLSA5rCt3buU63gMkgE209EJ5E9biFlmi/L4RNLDZc8kib99n+HdUVRg8Pg/kN1IbNKemuZWYUAnaSW3mtLl7rDETr3umAQ84aEGKglowNyZK+PxiQ0jmTgHUMrgzjrWF5MYy+RXDy57gh4voKU3LgMSwfFiGjA7VhxVT4DAJMKEZ2L2oMAHE7cD9gs2JqooNQFrrxoz7iB5LyzIJ5BHM4UUA9nEGRz9ARL+6iWRGNcfUSzcT5KrcBKiSvmE0r525iIL/56aqa8FCuRowb3UNr0+rYAQ7weH1LODhavQzYXdKKgMEp+HghS4rJLRsFbcdD0h/6dtTtbUoI6Sw1vSA8knlnQh14j9WtgMaEU71LbvEGuyKU9OrDQvj1JumCL4+FWnUUxvNutk//AT/c5FatNmmfxpsvVXTRL5/DdERhSrwrZl5CLID2uYpP77K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(31696002)(5660300002)(66556008)(66476007)(38100700002)(53546011)(52116002)(8676002)(2616005)(66946007)(36756003)(8936002)(7416002)(54906003)(16526019)(186003)(86362001)(316002)(6486002)(478600001)(83380400001)(4326008)(110136005)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?7uppgJbxJWGB5le7kB8+2xiDN88KRkxlgd6BtlRb8ey/aCd1M40exidX?=
 =?Windows-1252?Q?RHyRDyG6/o1vkrLLhcoe86KNYI5x4WDtC7fjb7R4XiMyYepvmHYAooKt?=
 =?Windows-1252?Q?E9itIFjTSSljfsS7fZVJVdYlF3aD66Ln6f+zH0foGapdJQyFy5CugNDN?=
 =?Windows-1252?Q?rgXIwqV/8K9wnozhWE0VV2/YZYum7RJhmuUQXxcQ4r4TArmuUROA1oFk?=
 =?Windows-1252?Q?z7ehOT/gdaeB6+ltn8mj/hMVeQ/Pv4Q80ZA93xQYssU5xJi2kcd3fQgo?=
 =?Windows-1252?Q?fap/jf5wFCRc7Ln8x06cAhZmGklOSBdI3PYoOaM+rz3WhjwYadbTH7sc?=
 =?Windows-1252?Q?u8+kkV0e9XeRZ8oeCSL+hJNZSS+hkSJXqkE7MdrQel6WhdMmFPuOYlqe?=
 =?Windows-1252?Q?0ndwO1ou/PRtM7ia4hG7TG9XZmVxPSykinNXk/bPqBJ55+6YdJ4FgP0a?=
 =?Windows-1252?Q?/otJKN6pTgHwuJvTNWBZnWGTr5Mi/v+5J6fgAb6Zn4oK3t8VA25wjswA?=
 =?Windows-1252?Q?O7lPKjdMVh0Jj5N19iAAh+jguRPvVbcsQjoLDXrJ1dLbYTUJyZzYmX5j?=
 =?Windows-1252?Q?3wRdt6b1UfGkxTpaLTMuNXE9VTfjP1ZDGtVWj8V0orVKSD7q+uIZiOFF?=
 =?Windows-1252?Q?iDqJDtkko8V+bj+WaA+7J7EBUGn4Wsmjk2Bw1pcHcjt4u3zFLOsO5IUF?=
 =?Windows-1252?Q?8e299CZ4Ex3v9Oi38ueJKAQ6RKzPwEkEB7fDtzpZsCoEFs6JGXb4a8MR?=
 =?Windows-1252?Q?qTR6Lc62sSSQLLCsW1/Yp0Ycws/xOiUO7ZoIEX6AUPlLRRGbJSBveoWH?=
 =?Windows-1252?Q?ZOosZQYQA1jOINHdMZRGfqKG/sgmCx30gDp/VatWFgAiRii9BawaAeJV?=
 =?Windows-1252?Q?qd4+41SjYyMPOZCqaVOf66HILiZ0DOpHWZh8LPNsCOI+uySBuWH+hi5w?=
 =?Windows-1252?Q?P2G4GDwl1CBpVWkw/linRnaSPzr1irQt7yGUzAfCI0rFZOTx0TyEREYh?=
 =?Windows-1252?Q?lIl8xSSwJe26HwTZmAihnod7tn506ke6vBfA/kdpys2QZl+OMCV+Xl+H?=
 =?Windows-1252?Q?XU9heTeSxZb6lOE0t8OX6ET/8pLYZ0vKAhXCWPOQXtyxldjZX1as+mAf?=
 =?Windows-1252?Q?TlnlRBw/uj/JDxCCkNHki/PFGJVsTapwYE40TmZ9If3M+DnNlkhztB27?=
 =?Windows-1252?Q?08nndi5DjjHeAmTgj0u6KM+Al2tS70krr89RdAEx7kAjd3eZRIoZ7Eh0?=
 =?Windows-1252?Q?s2Zs/I7vOPaYwDNp3haVp3LVOxUdpOf1lqHNR30LiYHmUsKuW3sZ61nk?=
 =?Windows-1252?Q?vZbWS7jlegcpt+EwnXTVPhHl2LLT1+5zU3o9XoyXibzOzRP1M8XD+yRi?=
 =?Windows-1252?Q?QlbePPKMbWN7OEhYi/B3wczPOBM25USUeGoFpgcf/kD9jPb/cyuakN5p?=
 =?Windows-1252?Q?sbkegR/qAWDEdb4X0PdO18SJNrHokJI+y5KX9BTm3Po=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e428a9-6d7f-426f-7bbb-08d9296847b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 03:56:50.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDbm8rhnwGlHHka7T0im4ns8+9VKMwB2pIWG3HYwXP5WdLU0yPEwMd1L8su0JL8o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4450
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: SDW7FhGePqZueuzSFPdMHaagLHKcx6K4
X-Proofpoint-GUID: SDW7FhGePqZueuzSFPdMHaagLHKcx6K4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_03:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106070027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
> that allows the program to be loaded without specific function to be
> attached to.
> 
> The verifier assumes the program is using all (6) available arguments

Is this a verifier failure or it is due to the check in the
beginning of function arch_prepare_bpf_trampoline()?

         /* x86-64 supports up to 6 arguments. 7+ can be added in the 
future */
         if (nr_args > 6)
                 return -ENOTSUPP;

If it is indeed due to arch_prepare_bpf_trampoline() maybe we
can improve it instead of specially processing the first argument
"ip" in quite some places?

> as unsigned long values. We can't add extra ip argument at this time,
> because JIT on x86 would fail to process this function. Instead we
> allow to access extra first 'ip' argument in btf_ctx_access.
> 
> Such program will be allowed to be attached to multiple functions
> in following patches.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       |  7 +++++++
>   kernel/bpf/btf.c               |  5 +++++
>   kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
>   kernel/bpf/verifier.c          |  3 ++-
>   tools/include/uapi/linux/bpf.h |  7 +++++++
>   6 files changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6cbf3c81c650..23221e0e8d3c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -845,6 +845,7 @@ struct bpf_prog_aux {
>   	bool sleepable;
>   	bool tail_call_reachable;
>   	struct hlist_node tramp_hlist;
> +	bool multi_func;

Move this field right after "tail_call_reachable"?

>   	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
>   	const struct btf_type *attach_func_proto;
>   	/* function name for valid attach_btf_id */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2c1ba70abbf1..ad9340fb14d4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1109,6 +1109,13 @@ enum bpf_link_type {
>    */
>   #define BPF_F_SLEEPABLE		(1U << 4)
>   
> +/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
> + * not expect BTF ID for the program, instead it assumes it's function
> + * with 6 u64 arguments. No trampoline is created for the program. Such
> + * program can be attached to multiple functions.
> + */
> +#define BPF_F_MULTI_FUNC	(1U << 5)
> +
>   /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>    * the following extensions:
>    *
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index a6e39c5ea0bf..c233aaa6a709 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4679,6 +4679,11 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>   		args++;
>   		nr_args--;
>   	}
> +	if (prog->aux->multi_func) {
> +		if (arg == 0)
> +			return true;
> +		arg--;

Some comments in the above to mention like "the first 'ip' argument
is omitted" will be good.

> +	}
>   
>   	if (arg > nr_args) {
>   		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
[...]
