Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A42039D364
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhFGDYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:24:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50640 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhFGDYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:24:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1573J012027939;
        Sun, 6 Jun 2021 20:21:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VXt1wOSSBzZC6gm3nJ6l4iRXDYPq6lQA9Vsmx8ASN/k=;
 b=Uq5WgmaVZam1exRxstCwnxPXfCzf44RKtpadOKphMnTIRhgOlOIisUnneUFlXkl5iOq/
 160do2bybbYasIZ03PL4EIGxgwAd0X5U1nQ4CADdKfkfXJ61jpiNZPpFXUhcP9DLFJ19
 jvWRI41+T331JH5sIDWLbaNz1SmGvbpyWMY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 390ryrk86w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 06 Jun 2021 20:21:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 6 Jun 2021 20:21:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcZCKtcr9EcAMqJ1Kt1Q29pRU7zAp2jSmQ3shQLloe/ofvnQupP99nVF9GwtMnYfKudLXDrT4VaE4NdchF5wh6Z4EK39ZYaxY7bbmSLtepi008ZehVzstqxw1RoD20M4aM8ny615ljokUFtFMI5cgdnHA/1+swu/60UBzlztr9vU9eEB5DEHUHYo7T+2xVkTswrvHlF6bxNiBrNCM24WWT9lyP3T9qacw78wNglac13VgAWjEcajfhRGIOHHSLk7dk2hTsQ19TzwzQe9HY06tpmBmsskbCOPhOtWrUCPJ4pwnAAuaL+gxsvVm95RnrNPtsszWD147zCO1DCO8b/Mbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXt1wOSSBzZC6gm3nJ6l4iRXDYPq6lQA9Vsmx8ASN/k=;
 b=jxvWMOvvK8m0nZ4QpKcjmTCtA5tRwcsvpOwA/u6maurdDQ3dgKs5OtW9MnzxYHDi629saE2XSgaF7Y98ri4IKk0fl4J+Ch092IIXbQtRbQmgXdN2l1z+fM/XuTrIPl+nixKtRkZKkobg1wTGZGuYUyxlnCZv90Qxmaz2VhXsyVi3Rd/6nA6FsBgqtGlOjO+NV07R2LSGun5B/W1ZfOH7nL6FlVyxIMFXNgWDuNWQWDFBPvFE5hB1qCc4gx93eDjBZbXrTJPsbO6JJmUkfV5DoOrNpe12hy9uVEC2+1zpwQEEqAIh1aQ5YxcfMwfZ8Vv5EzhRTQdGfXFK58KjpXxepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2415.namprd15.prod.outlook.com (2603:10b6:805:1c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 03:21:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 03:21:55 +0000
Subject: Re: [PATCH 10/19] bpf: Allow to store caller's ip as argument
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
 <20210605111034.1810858-11-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <03777e58-a2b0-83b5-959f-3ae4afadb191@fb.com>
Date:   Sun, 6 Jun 2021 20:21:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210605111034.1810858-11-jolsa@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1571]
X-ClientProxiedBy: MW4PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:303:b5::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:1571) by MW4PR03CA0285.namprd03.prod.outlook.com (2603:10b6:303:b5::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 03:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00b21a5d-2637-4b32-558d-08d9296366bb
X-MS-TrafficTypeDiagnostic: SN6PR15MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24152C7275CC98484B9B03FCD3389@SN6PR15MB2415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unN1lbriVOnFPMeV4398gnDl1VUHZBXM+u0dZQwHPIW5+rY40txp5WxagbXJbtF3yUDv38kOAsEJ2PCrVITJyfgFX1C8W1lU+LyxcmCvyyGDxp71HRM7BeJn3OkZ1keoO004vnA8uWvuEr/7h7fYh41W2NlYe9xKmApBU14KCWVtcUV2MaU0GMUWPsFITMdAshBUphgnipl+xhSJl5Ivq9bH6Ii7GRVi9X7JsztXwk8EdBEVlqT5pcFaWhgvu7CUjVw/ND7+3hNVjhJZ8Fxlw+8YIOlGya58xLUTCtR/zPiyjIUYQN3QesJPTcxC1O2M8rYpBwEMGNBOq8JeUqGObfwFTDFoTtXxLlg0g2rBdn3NWk2MZ4U3CdMdp6CwV5DzH8U49oF0Fje2m3hVOSx1iCMF9xuIcnHuushV601JN1zvicK/yGOJxOHHyrC4BZ+IpHbuYeqFhGpDQxgVNSF7ZBj3DxcZzIty/XWeGDAPTKjUfUKHAkMK8/uh2Ta6mDv22FJaf2y+jsTc+vc1IZtfQZRZ/O3a7+4Lj0LY4Zc6pGN+wYJwcKf0Q5LJfvR0mCNyrfXHMkxByATik0tt4k15/jxbJLptyPBsnxs6cD7gBj3IZWwAVLAUJXkWWiOdbNS/3TWa61mMJlQTMG7dXWlI1MYVxKgpELKdDImrGt47iC8kkTzg9cajIKoJr311sOUj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(2616005)(316002)(4326008)(110136005)(2906002)(6486002)(5660300002)(66556008)(53546011)(66476007)(186003)(16526019)(66946007)(54906003)(52116002)(478600001)(83380400001)(31686004)(36756003)(8676002)(86362001)(8936002)(38100700002)(31696002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?OUGivkjzeSx/Yl3bl8Zw5Oo958Hwkf+9h6yHYtOwF1hQj46JiIS88xYw?=
 =?Windows-1252?Q?y14uN68EnP6TpxrlYp2PRwB3sBVlfrrDEzsdD5qzxWsd2+/CQ2rxWvJE?=
 =?Windows-1252?Q?dmV0oe6GuyQq5fUqq4F/6V2ING0A3cZ1qfhEntsIm/j5P/7NSaVMQn1G?=
 =?Windows-1252?Q?UNtIcrFl0ua/Hyq10l5GEAQCKC8NHrJNydlL3VAMPjiK9MOYccmTS6Z/?=
 =?Windows-1252?Q?0C4dnfjCrMZLvAg/kdqcbijE9iVGdOrMSypQBvKEPYnxf/7UyiWECqwe?=
 =?Windows-1252?Q?tgyB1hFL9a0J5FD3GB7+wHp1zAPbXEuZ+9IS6vPImmqJxsnmMDUbZNAX?=
 =?Windows-1252?Q?IoUkLVEavQ/Hfelh4ytpvjlGpmg0x6WqOiSzgK73g+9Cd/yoF+XjU0jy?=
 =?Windows-1252?Q?g0QkQlcZyaQehswUcql4E6Eq6fsXsF0pIMaExb68t9LSD2Pc2KyWGWDq?=
 =?Windows-1252?Q?pKYehJ3vqphIoS9UmV3YjEnJCBuA7oC39ZliPaHOmhWQWkcHrtOzFC6m?=
 =?Windows-1252?Q?hO9WqNipfNHCWqGH6h012LbGroSkehKF2oTZK5qfAIZDSnO6qMiQG4Oe?=
 =?Windows-1252?Q?gBaCjOcYO86jfGfL0R6C12ifIcgDfSHdja249b+G7dbPJw+zfhXZz0Dx?=
 =?Windows-1252?Q?gSPTXeRdm/ErD0C5CT4Tt3QKegM4BypdGiVIjAfXeQ79I1gphFtSWHaU?=
 =?Windows-1252?Q?X2y4F8rAZ5SolUpEmlHsiVTZ1mUdS6K4FTGmBso44PBRNg3u43IwquCA?=
 =?Windows-1252?Q?Xw6wN9KmWxK3upoh1x9AORF25X+1hXayvqyPK/yJJ3SJ4AaJFFyuJjzq?=
 =?Windows-1252?Q?upJj2mW+2nnQ36orRb9351MED77K6bJQlKX+Spr7FiJsbExEpwDVxlI+?=
 =?Windows-1252?Q?lMGVK2ZpxuL48JmSWBlI6Q8Hv2Zx6UXPWyYliYFW+rVe9zjgiFJqP3y1?=
 =?Windows-1252?Q?0QiJrZ1e9IQFRRHTUwGlPVrLolCsIN5kE3MuzTewdEm/FS6U/04O4naA?=
 =?Windows-1252?Q?7ZRFEwUHrJaxhlwXIKSo/jBosDcuBNemxLg1pC10DkpgyJIbybqLskZs?=
 =?Windows-1252?Q?6FJuz1jXMxM7neCFHdzVHxGvtGkKyvBUW4VRe/o1ZWe9xq3CH2MGCZau?=
 =?Windows-1252?Q?Ij6+aQS/un8LHHGVaN8JySU07TAbErYnF+bD/tmACtZOSV5YvWz5Ko8o?=
 =?Windows-1252?Q?nQFTulaiHnE2uiE2LtjXXiXuiqHro2UckFpxZAWl6W+37+yd2DUQKMoI?=
 =?Windows-1252?Q?wSFOqMLXvA28Rw+Smxc4h2gNCDPtDYKV9hLPfNsSe9AWE+fcdWNKu3Pf?=
 =?Windows-1252?Q?w9NtETSczMc32IE6VzULQHoTQGlhJcmhiAGQLsaWrxrzy5HNBs51MrSe?=
 =?Windows-1252?Q?m40+e+rspBE9TPyzCEuZZoNlma4+29p3QL4/JwlcPK06ny43woy1DBxC?=
 =?Windows-1252?Q?hpIG84kh35WKiIEY+q58ISxPZfryvZCkmgchC2zH8hM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b21a5d-2637-4b32-558d-08d9296366bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 03:21:55.2979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeqFz39fjvRVOwKKz/p+FRbPo4ZNDvvOzLSAF7EdBAlWw+f1lNndkE9GnFLtVzCl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2415
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: qrzw8Hez3jk4HKgm-eXpR4A6aGXMLkhs
X-Proofpoint-GUID: qrzw8Hez3jk4HKgm-eXpR4A6aGXMLkhs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_03:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 clxscore=1015 malwarescore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 4:10 AM, Jiri Olsa wrote:
> When we will have multiple functions attached to trampoline
> we need to propagate the function's address to the bpf program.
> 
> Adding new BPF_TRAMP_F_IP_ARG flag to arch_prepare_bpf_trampoline
> function that will store origin caller's address before function's
> arguments.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   arch/x86/net/bpf_jit_comp.c | 18 ++++++++++++++----
>   include/linux/bpf.h         |  5 +++++
>   2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b77e6bd78354..d2425c18272a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1951,7 +1951,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   				void *orig_call)
>   {
>   	int ret, i, cnt = 0, nr_args = m->nr_args;
> -	int stack_size = nr_args * 8;
> +	int stack_size = nr_args * 8, ip_arg = 0;
>   	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
>   	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
>   	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> @@ -1975,6 +1975,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   		 */
>   		orig_call += X86_PATCH_SIZE;
>   
> +	if (flags & BPF_TRAMP_F_IP_ARG)
> +		stack_size += 8;
> +
>   	prog = image;
>   
>   	EMIT1(0x55);		 /* push rbp */
> @@ -1982,7 +1985,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
>   	EMIT1(0x53);		 /* push rbx */
>   
> -	save_regs(m, &prog, nr_args, stack_size);
> +	if (flags & BPF_TRAMP_F_IP_ARG) {
> +		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> +		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE); /* sub $X86_PATCH_SIZE,%rax*/

Could you explain what the above EMIT4 is for? I am not quite familiar 
with this piece of code and hence the question. Some comments here
should help too.

> +		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> +		ip_arg = 8;
> +	}
> +
> +	save_regs(m, &prog, nr_args, stack_size - ip_arg);
>   
>   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
>   		/* arg1: mov rdi, im */
> @@ -2011,7 +2021,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   	}
>   
>   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> -		restore_regs(m, &prog, nr_args, stack_size);
> +		restore_regs(m, &prog, nr_args, stack_size - ip_arg);
>   
>   		if (flags & BPF_TRAMP_F_ORIG_STACK) {
>   			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> @@ -2052,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>   		}
>   
>   	if (flags & BPF_TRAMP_F_RESTORE_REGS)
> -		restore_regs(m, &prog, nr_args, stack_size);
> +		restore_regs(m, &prog, nr_args, stack_size - ip_arg);
>   
>   	/* This needs to be done regardless. If there were fmod_ret programs,
>   	 * the return value is only updated on the stack and still needs to be
[...]
