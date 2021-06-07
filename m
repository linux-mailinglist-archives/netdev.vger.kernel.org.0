Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2A39D479
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 07:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFGFwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 01:52:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhFGFwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 01:52:14 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1575nb1e023436;
        Sun, 6 Jun 2021 22:49:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1XkYk0P49ndeuPZjWp1iakhb3EhYvR3tTAGfTlQ/+f0=;
 b=S4sSIdOXhRiithIVEOCoa2G+xmkDCY+KHnnCcGLMMJyxzW7pVh4fW5rV/eJdEV/pWBCr
 Zbv3/33UgicZsOxnY1FHLEc5F3yv4hkCGRWG8C7VVpcIDCbaLPpNTI/3FHj7T82sP1ws
 FqR3gMHdAvNG1PhB2wb6w+76cc7asK250OU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 390sbwbmn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 22:49:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 22:49:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8Z2ro3Zw6lwBVVi9EEKt78NtFjr4cX/rsVL0GglpyuiJ338J4IHX5FioGlI8gDRvJ3KQ9OEeT8ZteMX8/97d+qqfhHPf2LZbVxLK/FVyECkKewz5UEWBxypFytFvDsW8d4oXfuJl1Tu7KhanZZXNb8jwehMwOeTPunNRoex5dlyW9yMi+qaGCih6mj4dQzQUdSD+UiLwf7yrgcEBeF08jnOvZeWUHZq8pJqeEfwJEtNdV9R4djwuD22C+BCnoRXtV5f0vYr3fjoN2188yNrWdULjjflin8Rzloiycr58nUbsNkhd3lYIhOcODN8mTFLrhJmVAQA/heSM86T9qMIVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XkYk0P49ndeuPZjWp1iakhb3EhYvR3tTAGfTlQ/+f0=;
 b=g9iuoTlWRha5isxup4+T4Ru4LhDIEerojTm5hyEsCWk4o3yUx4hN2MRWRxbK1g5a4vaW92K4MrDJqo1cAu4QmiIYYUKIQaRd6jX/zif4x1641BSsaQTbYBwS781ghKkGfEndqiIxb7aB4/NNxe/H8ANocHvUPJyFBpVplBF7hPsppuI0/QqyhenwPBytLvKvFGW1EC7ojEpqNIyLfRj1t4sa/JPG4xBFl31gdD01QcRZegHJFxzuu5iZP6uoctNNQbXJ2iDaN0aZvwE95RSj8RchY6ZM40TWoF3zKG+TpG9L3J0azKRIcSPp4h+K11LvbN+XV0XATUOhs3sjsUeDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5030.namprd15.prod.outlook.com (2603:10b6:806:1d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 05:49:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:49:25 +0000
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing
 program
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
 <20210605111034.1810858-16-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <50f92d1e-1138-656c-4318-8fecf61f2025@fb.com>
Date:   Sun, 6 Jun 2021 22:49:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-16-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:9a26]
X-ClientProxiedBy: BYAPR01CA0044.prod.exchangelabs.com (2603:10b6:a03:94::21)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:9a26) by BYAPR01CA0044.prod.exchangelabs.com (2603:10b6:a03:94::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 05:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f3dea80-be53-4eb2-8252-08d929780192
X-MS-TrafficTypeDiagnostic: SA1PR15MB5030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5030DEF4CC424DBC513E47CDD3389@SA1PR15MB5030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+Pbof3vdrirKw4FvBbBKxPhyJp2CZULCypoNAxnKqX+2OveY+8fbJSZdRrIBfc1hCMSbWIuDsex3fOnUS2NyGfM489HaUDaTM+dFYvHvRaI9FC5zsBWkO5AujmLRzsmlkY6sIHO+HFP//sH1NJG/8NSOIEhi5gpzeLn8EcsRAmq3816D/HC0XaCdYgaV3eC3LHb5+71f4pk20VU5h8D96OVSUnMWJ8cJs5AqAUmlU6q8a7eJRMpr/IUayqY7jHcfZ4uBGQa9TnEsFxwu9LR893FyiOWyymGitVRmSB9HL+3a+ZEcO6CcZ/zy0KmLgnn8yn+V4pdagbakY+wwvDFMqDFjBybkQwcQRO8Zmw3OUGSSIVDasmH743+wjYB0qIinglkyouxiAk3KdAO5hXwF18Y+CB9C/kvewSocN10ikLE+5KVZAxq4hiZArX7ldEj8v6rDaQh4losb2wEtDBvByqTLygWHL19dDaQQ+qXie8IIJMXhgNPDR0hN0rCK8NaeOVQ0G+7Ad7k4nqYxqBfhQ59F3z2tX/wO9xyXIjtU/gXbArz1d5/7D9hJOP8xHheuaAq696BJHD6W+Llj0NiQWpi9tP0B3R0Kd8fTBqZhGp1uipzzXmp1fHRjwxBnJS1LxP03/XfzceQqyx2nvWQ4O+sRPKliBctFBPNrQc8QwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(54906003)(110136005)(86362001)(2616005)(2906002)(52116002)(6486002)(36756003)(186003)(4326008)(478600001)(31696002)(66476007)(83380400001)(53546011)(8936002)(66946007)(8676002)(316002)(5660300002)(38100700002)(7416002)(6666004)(66556008)(31686004)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?7oV4KfjetsXsqugfBXfC6MPiOtum0U62vFMwdnk0YgXDKJ67SB0e0Dye?=
 =?Windows-1252?Q?m0gJqEJBSCqbALBi+Kxkz3eUrE0xrotCtp5XmWCvI3Y/Z5O6icMzP02J?=
 =?Windows-1252?Q?s1jJ7zMK1Qc/iHgOlO1Xa5DZsWsR7oIkJC3SZESrhswGSiTPQLVVgKNN?=
 =?Windows-1252?Q?xJVl0fY8rQPzi0F7OTMdONRoCOrR4So6rdrhL2ibnUpg/nFC4JbfLZ0V?=
 =?Windows-1252?Q?Q519QWWoDojmS1gr2stoJmyHiXOxZSikwETFMKYAhll+QSDGz9J0Pih2?=
 =?Windows-1252?Q?UqMefM8vIwKkbENGSGoc5kNlyFkFBi8N8kF5lAkw5BBCoyj/SUN2T0tQ?=
 =?Windows-1252?Q?G2mWVRC1PPPguRI3XhwlDo5JcFHEIskz+hexOHy7bQqIB0N4b+wna7FR?=
 =?Windows-1252?Q?nhzbBM3HIWZPXLI9ge+CuVEgchNKSjkJV5ICzn3TwHFAGOftHr06v2T6?=
 =?Windows-1252?Q?GXSbSsx9KZIKsIxT5cJMMeN+n0JHT1V1cwGEhNXE7NyvDey8ffvOJj7R?=
 =?Windows-1252?Q?DUCGjEsGP/jdWF58Rfimr87H054DN1IyGYwkU1XoHvUnqL97/3T0Prxx?=
 =?Windows-1252?Q?gvh0FVHcY1VnqGuDngs+RspyhXaqp979dOZnz3atYlE9mAZi8x7MY7dC?=
 =?Windows-1252?Q?70PknGh+4vhLrdzCpKEWg5EeXLEDxjRJmc8uWdJ46+H0pVuull4JihNz?=
 =?Windows-1252?Q?wqk1Z0O/VwqcKKYV1VJh5+fr2uaqk8k4wFVuj24z0WLfpTk1mW4kVH4M?=
 =?Windows-1252?Q?E6WcGsyGlIcIBN+KtzBk0KAfPoFbkuCHTAZd3J/1ymgr18v3DwCFaIx0?=
 =?Windows-1252?Q?i+oJ9rba50iXWOZXxvrNhRS/j6i6x8pq/IU2CKt29gn1wTQXB5E7/omI?=
 =?Windows-1252?Q?N39w31rp4mFsFXi5wqr0yblUU/L9IlLWSqcTdnpYyt26I9VUSrzRY3iz?=
 =?Windows-1252?Q?87n/r5DF5RiKkHGvK/pq1Hz59iQQqcP9suM7dnpdH6E60DTbqnWsFVF2?=
 =?Windows-1252?Q?ICWFKumRuNsGXefNYH4RN9A1qsQNE9175BlPHaAY373znAE7Uy0sR5fF?=
 =?Windows-1252?Q?PJBCnTlI30QG1jehOtKkUHyNX3mQqdMcexVT98Mi1G/LVm+ikm6tqIg/?=
 =?Windows-1252?Q?vB7Fu1T85z2C1Upr9i0wKWSLg0SEC83/Uif9siyv5BfKaatka5wHxUN7?=
 =?Windows-1252?Q?kKUId7gqUVJfZ1G0JHIvzdyUKTcEY/8zy7JEwyuP7aQrs6abMz5kuPr7?=
 =?Windows-1252?Q?JiFHIcMMyVp4vqE0vk943PVa0nxJS+/1PIDaQ1QNy9LzaEIok/+iDET2?=
 =?Windows-1252?Q?Lll+Vv9QmkDp+3IfgmDT9BIeYncSK0y4xyelBeupOfI4atakCn7UpYOO?=
 =?Windows-1252?Q?xowzYCeG7WDo6H22sMGKURbzNLtsxCSBQjxJyUDMCwaok+zHwJfmTJWd?=
 =?Windows-1252?Q?o+GHM511EZJg+dy+En1M40NlBbbSX53n7KZTN1fidYI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3dea80-be53-4eb2-8252-08d929780192
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:49:25.0817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fI1yjS3tMQL8/3kVmC1HNYAmAyCutTsWTmH2bL2JVqh2jnlA78ZGuYWo0t3nMlK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5030
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Jdn7l4Y0Y3lAFTUQ0kfOiuk69eyqNoit
X-Proofpoint-ORIG-GUID: Jdn7l4Y0Y3lAFTUQ0kfOiuk69eyqNoit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_06:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> Adding support to link multi func tracing program
> through link_create interface.
> 
> Adding special types for multi func programs:
> 
>    fentry.multi
>    fexit.multi
> 
> so you can define multi func programs like:
> 
>    SEC("fentry.multi/bpf_fentry_test*")
>    int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> 
> that defines test1 to be attached to bpf_fentry_test* functions,
> and able to attach ip and 6 arguments.
> 
> If functions are not specified the program needs to be attached
> manually.
> 
> Adding new btf id related fields to bpf_link_create_opts and
> bpf_link_create to use them.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/lib/bpf/bpf.c    | 11 ++++++-
>   tools/lib/bpf/bpf.h    |  4 ++-
>   tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 86dcac44f32f..da892737b522 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -674,7 +674,8 @@ int bpf_link_create(int prog_fd, int target_fd,
>   		    enum bpf_attach_type attach_type,
>   		    const struct bpf_link_create_opts *opts)
>   {
> -	__u32 target_btf_id, iter_info_len;
> +	__u32 target_btf_id, iter_info_len, multi_btf_ids_cnt;
> +	__s32 *multi_btf_ids;
>   	union bpf_attr attr;
>   	int fd;
>   
[...]
> @@ -9584,6 +9597,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>   	if (!name)
>   		return -EINVAL;
>   
> +	if (prog->prog_flags & BPF_F_MULTI_FUNC)
> +		return 0;
> +
>   	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
>   		if (!section_defs[i].is_attach_btf)
>   			continue;
> @@ -10537,6 +10553,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
>   	return (struct bpf_link *)link;
>   }
>   
> +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
> +{
> +	char *pattern = prog->sec_name + prog->sec_def->len;
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +	enum bpf_attach_type attach_type;
> +	int prog_fd, link_fd, cnt, err;
> +	struct bpf_link *link = NULL;
> +	__s32 *ids = NULL;
> +
> +	prog_fd = bpf_program__fd(prog);
> +	if (prog_fd < 0) {
> +		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	err = bpf_object__load_vmlinux_btf(prog->obj, true);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
> +					BTF_KIND_FUNC, &ids);
> +	if (cnt <= 0)
> +		return ERR_PTR(-EINVAL);

In kernel, looks like we support cnt = 0, here we error out.
Should we also error out in the kernel if cnt == 0?

> +
> +	link = calloc(1, sizeof(*link));
> +	if (!link) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +	link->detach = &bpf_link__detach_fd;
> +
> +	opts.multi_btf_ids = ids;
> +	opts.multi_btf_ids_cnt = cnt;
> +
> +	attach_type = bpf_program__get_expected_attach_type(prog);
> +	link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
> +	if (link_fd < 0) {
> +		err = -errno;
> +		goto out_err;
> +	}
> +	link->fd = link_fd;
> +	free(ids);
> +	return link;
> +
> +out_err:
> +	free(link);
> +	free(ids);
> +	return ERR_PTR(err);
> +}
> +
[...]
