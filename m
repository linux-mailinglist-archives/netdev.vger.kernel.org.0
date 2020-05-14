Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01921D28A9
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgENHWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:22:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgENHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 03:22:35 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E7LUho027019;
        Thu, 14 May 2020 00:22:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=w4yzOQ3QVerG1iNnUBlIG0Qm1mvGqNwwKw1AeeKEtQU=;
 b=QQCdgksUkyL4dezzia5ZA2r0p11V1Jv8LjGfCa9+FvxxuL6V+0w8mXg6D/+0evCEr+a5
 /N+pobJh9I2TfvhBq5LaF1wRWJ5TPb96nqFXzJG604Dah9nS/J5KHmxwxt/RQcD6VQcl
 SIs1vqq5Ah13OXKvzJBcw93+Iog8DcW0qZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3110kjr7e8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 00:22:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 00:21:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nglpdl+slfG5QG73Y3EH6oI3uVby8K2beFCLrw84FUyh238qqbkkAqkUAhMWikTkuZNExRdLyvw57GGY3WabkZ53YoapgIiCSaYG2bPRqEZ6Ag7DH0ktGnDS2j/hHe8rB50qOGuZWOVd1yARgP8Ph8sbwpPnvS8uzoXnXEVafFKqwOWT+ImfE18+scbc1+ClL7BlRiN85XGW7qy8KK0ElAdXLaojWI0QVppQStUXcfe6cmoBwTGsLtKO+sbs8MSOWQ+3sFH7texACPUp2YLWM/1aQhc6Ie8IO49oYWW27YaytZvKG57vQjw23sxZZa7XxEduQaKT7RNjiJIY5P1q/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4yzOQ3QVerG1iNnUBlIG0Qm1mvGqNwwKw1AeeKEtQU=;
 b=LskF0pLhpW5ylDnDbmajyY/JiyZLPMExWsMJ5djyPUkapT7CK+oJObZmd5O5g1TLiHHRgJ9sljR3vRF3wIli711vZ0cFygWNhv5iBaU536rDl/PTf3k5Cx1PVfnbytMILn+hm6qhJH6UA+HvTh6WPW8fwUMeoufzHHvfUZRuizMqzFw02dmVUFrasD78tYrglmFSFzkTiYNIDQ1R/N7t8FG6lCTtACg7ovHNL+Ov6sfKXwXu2wZh5o4Fr0JhyV9Rav8LK5o97ie/2imFCSt6ZVJ8H2JBMW1pwmrNnaWpP9P/+q+AWVtNseA+d78Gqv5fGgx50is1AG/OtUq12p5K0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4yzOQ3QVerG1iNnUBlIG0Qm1mvGqNwwKw1AeeKEtQU=;
 b=KhQlroRzgLw0Nby3tUA3nHGxBw6NOE04JHeEjbYasE0YWpshQrPt6kz2GP63nVr8qTzLwSA0nJFhnv5BuqW8g0VaTYu23Q45CmZ7zgw96AvFGhpgPcrQ2nhJKfLAIRLZ4+/39wahE9/IvrewKH2qsM6Kfz4FP//QNIwSb+po+Nc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2360.namprd15.prod.outlook.com (2603:10b6:a02:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 07:21:42 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 07:21:42 +0000
Subject: Re: [bpf-next PATCH 2/3] bpf: sk_msg helpers for probe_* and
 *current_task*
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
 <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <35846427-3770-f6ab-b1a6-c974a835f746@fb.com>
Date:   Thu, 14 May 2020 00:21:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:7dec) by BY5PR04CA0006.namprd04.prod.outlook.com (2603:10b6:a03:1d0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Thu, 14 May 2020 07:21:41 +0000
X-Originating-IP: [2620:10d:c090:400::5:7dec]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bb94616-5cd4-444b-fcde-08d7f7d77362
X-MS-TrafficTypeDiagnostic: BYAPR15MB2360:
X-Microsoft-Antispam-PRVS: <BYAPR15MB23608210EEB850DE812AB6BDD3BC0@BYAPR15MB2360.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkNKo/LdZSlLUFJ0nJUtUAFgU3q+Yins1OoxDO/0WYcTvz0qAdiOPYzsbR1tLzA1T/0Q1urnyUewpG9jPfdKoG/ZJ37eFRNplAxFE4H+7nmK2n1D95Hrs1W+mLrlgzTTcSr1RfjzXUo6kxZJhf8MMEFMej83XVGcDn2PPUNjarYFCROvC9d61qh4osm00tjPXWmxk2bCrZjz6xVf4b7Yal8qQ+4rdaY+EguLNskYtg879oe2tjrVKQA7CRSBKtyDxi1C7WdP/zk/Modwv49DgmhxT8sdjLHwrydSaLSo3IVOmioAMKcVERdIG/Iz/7jNW+9wBgdOxR6FfojQ6yvTLZYkBAfLKfX3Ym/gAI74ZoNcghQWjl8V5KT2eGGLRUAeJY1mhil3tNoHUU35+yz6z4Jp+nX5PJoRQ6PcNeF+MoYmiTDS/sruvr0lUEjysO4sUPLUhjQ220WAbrLW0lQCZ3Ry0PUtfYwqp0YkMQofRD6DHDhk7Iwk8TqKbS42tCyf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(376002)(366004)(396003)(8676002)(4326008)(16526019)(6506007)(52116002)(186003)(6486002)(5660300002)(316002)(53546011)(2616005)(2906002)(66476007)(6512007)(478600001)(86362001)(66946007)(66556008)(36756003)(31686004)(31696002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XGbg6Oz6Gcv+aWX1qvIqzYVswOIRs7rdV6D4UsGj1cAsQutDyMagsND0oHQh1iPZCZy+tY8fKgCNMnSB6X2qUHfnSXYxHmLq5nKU/fv/NYZTX4if92UTIP+Xwn8kFbJr+MB8mWidAjx4SBO/Mzz1/SILGXc7o4asYPBXr+SFUcLfzGq/pN+5xFZwiizy84/snaDaiT3WlOTFCz9qyDd7/cix4h+bgVuJAV6wyQujjShF9EXEEQu9rOnMBd11160qgNLlo7fIAZYLwTClRfg7apijQRfFp1K8/M4dhNir9z3YIstpxo9U7dFft8yCiInWQOOCmtihC8dSkXNe54fXxET20lTBW9q/ZbENAZGMs1UkZx83ir+7QL92zPOrYmEQlllgkS/YreMZZrvtEvB7zV0W5zjwh939UO7lEMSMO6BWpJw9cVK3V+bI6+eFpDmb0V8DzS3Jce5IBBH2/3SwsooY9zbXzEOaEQn7xb54jDOfUJfhKLM7nfuIB7QMluckqPE7VAIpXJJu5zgaRKwWZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb94616-5cd4-444b-fcde-08d7f7d77362
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 07:21:42.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJ3UwsV19SZ4+P4iYqUXoKOkQJh9v0ZfNzIi7Zs6CTXsHIQDLoG9oXz5/keyg89V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_01:2020-05-13,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 spamscore=0 mlxscore=0 clxscore=1015 phishscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 cotscore=-2147483648
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140065
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 12:24 PM, John Fastabend wrote:
> Often it is useful when applying policy to know something about the
> task. If the administrator has CAP_SYS_ADMIN rights then they can
> use kprobe + sk_msg and link the two programs together to accomplish
> this. However, this is a bit clunky and also means we have to call
> sk_msg program and kprobe program when we could just use a single
> program and avoid passing metadata through sk_msg/skb, socket, etc.
> 
> To accomplish this add probe_* helpers to sk_msg programs guarded
> by a CAP_SYS_ADMIN check. New supported helpers are the following,
> 
>   BPF_FUNC_get_current_task
>   BPF_FUNC_current_task_under_cgroup
>   BPF_FUNC_probe_read_user
>   BPF_FUNC_probe_read_kernel
>   BPF_FUNC_probe_read
>   BPF_FUNC_probe_read_user_str
>   BPF_FUNC_probe_read_kernel_str
>   BPF_FUNC_probe_read_str

I think this is a good idea. But this will require bpf program
to be GPLed, probably it will be okay. Currently, for capabilities,
it is CAP_SYS_ADMIN now, in the future, it may be CAP_PERFMON.

Also, do we want to remove BPF_FUNC_probe_read and
BPF_FUNC_probe_read_str from the list? Since we
introduce helpers to new program types, we can deprecate
these two helpers right away.

The new helpers will be subject to new security lockdown
rules which may have impact on networking bpf programs
on particular setup.

> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   kernel/trace/bpf_trace.c |   16 ++++++++--------
>   net/core/filter.c        |   34 ++++++++++++++++++++++++++++++++++
>   2 files changed, 42 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d961428..abe6721 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -147,7 +147,7 @@ BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
>   	return ret;
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_user_proto = {
> +const struct bpf_func_proto bpf_probe_read_user_proto = {
>   	.func		= bpf_probe_read_user,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -167,7 +167,7 @@ BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
>   	return ret;
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_user_str_proto = {
>   	.func		= bpf_probe_read_user_str,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -198,7 +198,7 @@ BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
> +const struct bpf_func_proto bpf_probe_read_kernel_proto = {
>   	.func		= bpf_probe_read_kernel,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -213,7 +213,7 @@ BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_compat_proto = {
> +const struct bpf_func_proto bpf_probe_read_compat_proto = {
>   	.func		= bpf_probe_read_compat,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -253,7 +253,7 @@ BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
>   	.func		= bpf_probe_read_kernel_str,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -268,7 +268,7 @@ BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
>   	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
>   }
>   
> -static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
> +const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
>   	.func		= bpf_probe_read_compat_str,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -874,7 +874,7 @@ BPF_CALL_0(bpf_get_current_task)
>   	return (long) current;
>   }
>   
> -static const struct bpf_func_proto bpf_get_current_task_proto = {
> +const struct bpf_func_proto bpf_get_current_task_proto = {
>   	.func		= bpf_get_current_task,
>   	.gpl_only	= true,
>   	.ret_type	= RET_INTEGER,
> @@ -895,7 +895,7 @@ BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
>   	return task_under_cgroup_hierarchy(current, cgrp);
>   }
>   
> -static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
> +const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
>   	.func           = bpf_current_task_under_cgroup,
>   	.gpl_only       = false,
>   	.ret_type       = RET_INTEGER,
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 45b4a16..d1c4739 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6362,6 +6362,15 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   const struct bpf_func_proto bpf_msg_redirect_map_proto __weak;
>   const struct bpf_func_proto bpf_msg_redirect_hash_proto __weak;
>   
> +const struct bpf_func_proto bpf_current_task_under_cgroup_proto __weak;
> +const struct bpf_func_proto bpf_get_current_task_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_compat_proto __weak;
> +const struct bpf_func_proto bpf_probe_read_compat_str_proto __weak;
> +
>   static const struct bpf_func_proto *
>   sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   {
> @@ -6397,6 +6406,31 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_get_cgroup_classid_curr_proto;
>   #endif
>   	default:
> +		break;
> +	}
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return bpf_base_func_proto(func_id);
> +
> +	/* All helpers below are for CAP_SYS_ADMIN only */
> +	switch (func_id) {
> +	case BPF_FUNC_get_current_task:
> +		return &bpf_get_current_task_proto;
> +	case BPF_FUNC_current_task_under_cgroup:
> +		return &bpf_current_task_under_cgroup_proto;
> +	case BPF_FUNC_probe_read_user:
> +		return &bpf_probe_read_user_proto;
> +	case BPF_FUNC_probe_read_kernel:
> +		return &bpf_probe_read_kernel_proto;
> +	case BPF_FUNC_probe_read:
> +		return &bpf_probe_read_compat_proto;
> +	case BPF_FUNC_probe_read_user_str:
> +		return &bpf_probe_read_user_str_proto;
> +	case BPF_FUNC_probe_read_kernel_str:
> +		return &bpf_probe_read_kernel_str_proto;
> +	case BPF_FUNC_probe_read_str:
> +		return &bpf_probe_read_compat_str_proto;
> +	default:
>   		return bpf_base_func_proto(func_id);

If we can get a consensus here, I think we can even folding all
these bpf helpers (get_current_task, ..., probe_read_kernel_str)
to bpf_base_func_proto, so any bpf program types including
other networking types can use them.
Any concerns?

>   	}
>   }
> 
