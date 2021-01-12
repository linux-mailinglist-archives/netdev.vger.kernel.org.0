Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7D2F3D83
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437978AbhALVhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436898AbhALUVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:21:20 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CKJiY2000737;
        Tue, 12 Jan 2021 12:19:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5ELiHnupXJ+JmYCzZx70ukRL6PdPBP5mwIQmaz1cAHE=;
 b=bV/yGiIouxMJT4cblvk+NHFhI8z6M2hChca1fGug0kgxgNnIojJ7+jVSmDsACFu89qdo
 lSQ3zwrTJs2Yf5GzrOzwVlwHHgddvJ5JFME6dN46asWMYZSZKIEDXcufE4ztpQ+Rl19d
 gZSAqvLia+6ZnvWS/amctZhvfYGnVos7cDA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpb99bj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 12:19:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 12:19:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfYF4LjOvxFeqkpQS6HhdXGkfHAjJlm+QDHWY71bGu+OrpyxqQDx/FnaiGzq8TnvPRpAxar9wjnx5A9g3q/5k5MrSDp9V5tGUBO9gDsyBlm4r5vJu35DjIpV1EsxV0HaEoRJYiZdFHlXJWAG0Jaex9nTrRaGRwL0RiEHI7I5qVkuP1e1dn7gogHpE41mcFc+SJzUs7JFrXTdIUiQ8v0xEy6nMqnR8PsCI3M4TuT7xq971nIPAAFgLqwiJUtuJQWUa/mBvaAs2RVXtsLBv+J4758yIpXSm3NOHMokDOSiOO/QnPtTKGkKKEJI2QqeVfEgmCkc3WaVP3sugXhvYqFXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ELiHnupXJ+JmYCzZx70ukRL6PdPBP5mwIQmaz1cAHE=;
 b=ZRcKQdErWYSHB9szAOduMYzxgbwFLjHfILx59O/I/QZSD4u5kAvSmRPaj63/0egGXI9CXLJY4pfPprzoUa66hiaTHhyIeoL0bCAD78aVBguuB5IU7Z+1qJeSzanDJB2ZDM1wvC2olEL5TFnz0gzSL/LvhODG+1sOiELBPQHTvYyjMEfQZ0OX8MlVNcPMhSZNkz1ep8ngdGzxJ6uPYv6q0gewb83A8jMsluKKIQEV4CKV2TL+aU7sQ1YcTlWwN2ve6AahAFiQny8Y31vDGSZ3adYcvpYjY4LllS3Gc0OB7oF4NT+ZeTxta9MHHp1WN4yGliet9f6YP2LiCrHBkWYktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ELiHnupXJ+JmYCzZx70ukRL6PdPBP5mwIQmaz1cAHE=;
 b=atCKiOmWbgw3X71y9tkWM4k0t60ipTWT7I5+NkHdOz7SxCnMj5QiylYrMGfGmBMpP4nkeV1IVGhxvABapyrT/GoaxFftXEUCoiVdXH7Tj3nkT466AVslYmv1a+Royp5DL7AsEXhJzjM/y6f5NqSjYUFDe/ZXX1PHPNJ8yWApn0g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Tue, 12 Jan
 2021 20:19:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 20:19:52 +0000
Subject: Re: [PATCH bpf-next 1/2] trace: bpf: Allow bpf to attach to bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
 <20210111182027.1448538-2-qais.yousef@arm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8ef6c8e8-c462-a780-b1ab-b7f2e4fa9836@fb.com>
Date:   Tue, 12 Jan 2021 12:19:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210111182027.1448538-2-qais.yousef@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:3e3]
X-ClientProxiedBy: MW4PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:303:6b::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:3e3) by MW4PR04CA0087.namprd04.prod.outlook.com (2603:10b6:303:6b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 20:19:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efb067e1-c43f-4e9a-0804-08d8b7376b21
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4085BCD751DBC12105881FDCD3AA0@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbzQpo+cB2+PqPvNigr2A2ha5sRP0RPb24XtP7HLiywM4hD8/rlnl+ILlowLSksZfF30jl2Ttv8G1y/qnkLBQUbsgTY6/hjQROR566UMAYGF2DmFT+VNq48PSbRXzZq4CsRpgc6lLph65w6tpyx4VKP4NBwkNzN90fz2UM9IwhXhIbcgrfXoO9Vqw96c7FGVG1koBep/5Oc5P7NTHqonOzD4a6xslfB9PvZjF80WU43CwaKkz0jYIv2mLczjnGetLNQaGJxyPl/hJSFu/pX74SdPm8fMwPq+sj6T+WPQWLywSXdcUV3BpUj5sssXpH66VWrrtvg/dTOVv7s6GiKEGmgVA9jAd+F51dgGM/ku+aAr2blvXyjxQSjRuakUSJ9f4msaZc++RB2q3aTirGGp6oM6nx9pCeBAEXqrPZ/gJrigbYbxQ13KmkmqgTBG6yU4eWBObYq68w8vrxH2w8A9PxwnxJ+z4+y9KKsM5FyB1j8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(16526019)(4326008)(5660300002)(66946007)(36756003)(8936002)(66476007)(186003)(66556008)(478600001)(31686004)(8676002)(6486002)(86362001)(316002)(53546011)(31696002)(2906002)(52116002)(2616005)(54906003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dkMzSlJXbVhCbzhmQit2MW11b2JxNXVhUjVSM0RHeEp4QzVpTW1lVXY0QzA4?=
 =?utf-8?B?c3hiY3ZrSDlxYk42eTF0ZWhrRG1HVHBEeXZ2QjdJYTY5K0JrU2NrLzIyeVNM?=
 =?utf-8?B?NnVRMjJOd1psNDhPYWtwNjZTUllOMjdKR3ZadWhxUmN4ZlBwMmRiZkhPdTQr?=
 =?utf-8?B?b1ZSTUZGQmJtQzlJM00zaEZYU3RpeTZwNlNBejgzQTNzdUNQdFpNejNmeFdD?=
 =?utf-8?B?bUlKamFsNC9xbmY0L01SdzVBRUdPRUxpSnlETkN6bmFLNlB3WGJ0OHpqejJM?=
 =?utf-8?B?ZkN3TnQ2VXIwOVVKTksyaW5DOUpHWkNkVGNCQ2xhZnVieFJZWEp4ckJlRFlR?=
 =?utf-8?B?L0VPYXdWMjRCSXNXbTlQS25UNFFOcmFOZFAwOU9sSC9RMXU0VVZqblVLdUVl?=
 =?utf-8?B?OHVBTldZV2FsejlxMWRScnhHQnlWYytPR2IwR2dxY1lSQjZIV1pHZVlXWDFZ?=
 =?utf-8?B?bC9URmFEWkdxWnNUOFNKZ1U0VUpzcVBsd2VjckxoNHZlRmM0aWNvVGN3T2J4?=
 =?utf-8?B?NC9BcnQ2dU1Lc0owUXJWQUIvMG9HbytlSWJHNjZXYWFQK2Q5eExCSHJyZXNy?=
 =?utf-8?B?SzZjWXRmaVFuOUQvNjErNUtxU25KejM3T01OeG9KckNhY1Z6VjUvbU9xdExT?=
 =?utf-8?B?UHdOdHB2OHV1Rmk3V3FWQ2Y3bDV3THEvYTg5MUlIbWc4bnp2L1Z6eGVOWXlM?=
 =?utf-8?B?NDZaSnVncWRFR1UycmNsUFFKUlQzQldob0NkRmtjVkdRNkJkRnhPVHk5MlBk?=
 =?utf-8?B?ZG1qelZPMnlJSU0zc0VDOU9qUURNcHNvdTNoSmZyaEpUM3J3cWdsQWJEUXY3?=
 =?utf-8?B?cGg2bDlEeG9vekNIOEpJSFh2c0xNU2o4cnNtM2Z5MUlvNjM4MkRsZC9UNENq?=
 =?utf-8?B?WGRsVFV6NzVFZ2JLQThlcGNLWXNpdWdWcDBkeGdHWmR2Q21aRVFpTnN1UExt?=
 =?utf-8?B?QXJsUkExSDBDeGN2b2c4dlEzNFkzZ1RBRWlOVXc2R0RmVzNFYWUwNHQyVHZH?=
 =?utf-8?B?anpvZHNvNENJMmVNUmlwK1lDU01lQXorNCtiK1lYVnMzcHRZaUNWbldBOXdN?=
 =?utf-8?B?UE9IOS9Vd2doNE5FbWFpb1JCMkpHT1hlYzE4SzRqRVMyMnpidWpFODdSNGlM?=
 =?utf-8?B?dkZHQm5YcjFoZ1BncnpPWi9oWWlPS012R3RIQTFEUnJ3eEw4YzFwOUtub29x?=
 =?utf-8?B?Ny8wYmV6OGRMbkZLeUM2c2ZvbHRjSlIrMlZ2NmdOdmJjUUFqWVpucHZSNUJ1?=
 =?utf-8?B?OUM4anRZVFA3aHQ0UHF3bi9MdGhZNnpsdEFLTmZHSFhoMTZLTHJBTW5qaVcw?=
 =?utf-8?B?bWN3QVExUkxleXpwaEx2QUpYWkFRam02czRBV0x5SU9LRndiU3cwWTMxc0Fn?=
 =?utf-8?B?NUM3TVhEaDZrNWc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 20:19:52.0206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: efb067e1-c43f-4e9a-0804-08d8b7376b21
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5m6lCbhSmtQSGFwWAh3JKEw/3C22uoz4AgQH7l1OgUC1A7Lqat1BDj//0KL9ZOe9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_16:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 10:20 AM, Qais Yousef wrote:
> Some subsystems only have bare tracepoints (a tracepoint with no
> associated trace event) to avoid the problem of trace events being an
> ABI that can't be changed.
> 
>  From bpf presepective, bare tracepoints are what it calls
> RAW_TRACEPOINT().
> 
> Since bpf assumed there's 1:1 mapping, it relied on hooking to
> DEFINE_EVENT() macro to create bpf mapping of the tracepoints. Since
> bare tracepoints use DECLARE_TRACE() to create the tracepoint, bpf had
> no knowledge about their existence.
> 
> By teaching bpf_probe.h to parse DECLARE_TRACE() in a similar fashion to
> DEFINE_EVENT(), bpf can find and attach to the new raw tracepoints.
> 
> Enabling that comes with the contract that changes to raw tracepoints
> don't constitute a regression if they break existing bpf programs.
> We need the ability to continue to morph and modify these raw
> tracepoints without worrying about any ABI.
> 
> Update Documentation/bpf/bpf_design_QA.rst to document this contract.
> 
> Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> ---
>   Documentation/bpf/bpf_design_QA.rst |  6 ++++++
>   include/trace/bpf_probe.h           | 12 ++++++++++--
>   2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> index 2df7b067ab93..0e15f9b05c9d 100644
> --- a/Documentation/bpf/bpf_design_QA.rst
> +++ b/Documentation/bpf/bpf_design_QA.rst
> @@ -208,6 +208,12 @@ data structures and compile with kernel internal headers. Both of these
>   kernel internals are subject to change and can break with newer kernels
>   such that the program needs to be adapted accordingly.
>   
> +Q: Are tracepoints part of the stable ABI?
> +------------------------------------------
> +A: NO. Tracepoints are tied to internal implementation details hence they are
> +subject to change and can break with newer kernels. BPF programs need to change
> +accordingly when this happens.
> +
>   Q: How much stack space a BPF program uses?
>   -------------------------------------------
>   A: Currently all program types are limited to 512 bytes of stack
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> index cd74bffed5c6..cf1496b162b1 100644
> --- a/include/trace/bpf_probe.h
> +++ b/include/trace/bpf_probe.h
> @@ -55,8 +55,7 @@
>   /* tracepoints with more than 12 arguments will hit build error */
>   #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
>   
> -#undef DECLARE_EVENT_CLASS
> -#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> +#define __BPF_DECLARE_TRACE(call, proto, args)				\
>   static notrace void							\
>   __bpf_trace_##call(void *__data, proto)					\
>   {									\
> @@ -64,6 +63,10 @@ __bpf_trace_##call(void *__data, proto)					\
>   	CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(prog, CAST_TO_U64(args));	\
>   }
>   
> +#undef DECLARE_EVENT_CLASS
> +#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> +	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
> +
>   /*
>    * This part is compiled out, it is only here as a build time check
>    * to make sure that if the tracepoint handling changes, the
> @@ -111,6 +114,11 @@ __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>   #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
>   	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
>   
> +#undef DECLARE_TRACE
> +#define DECLARE_TRACE(call, proto, args)				\
> +	(__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))		\
> +	 __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0))

I applied the patch to my local bpf-next repo, and got the following
compilation error:

In file included from 
/data/users/yhs/work/net-next/include/trace/define_trace.h:104, 

                  from 
/data/users/yhs/work/net-next/include/trace/events/sched.h:740, 

                  from 
/data/users/yhs/work/net-next/kernel/sched/core.c:10: 

/data/users/yhs/work/net-next/include/trace/bpf_probe.h:59:1: error: 
expected identifier or ‘(’ before ‘static’
  static notrace void       \ 

  ^~~~~~ 

/data/users/yhs/work/net-next/include/trace/bpf_probe.h:119:3: note: in 
expansion of macro ‘__BPF_DECLARE_TRACE’
   (__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))  \ 

    ^~~~~~~~~~~~~~~~~~~ 

/data/users/yhs/work/net-next/include/trace/events/sched.h:693:1: note: 
in expansion of macro ‘DECLARE_TRACE’
  DECLARE_TRACE(pelt_cfs_tp, 

  ^~~~~~~~~~~~~ 

/data/users/yhs/work/net-next/include/trace/bpf_probe.h:59:1: error: 
expected identifier or ‘(’ before ‘static’
  static notrace void       \ 

  ^~~~~~ 

/data/users/yhs/work/net-next/include/trace/bpf_probe.h:119:3: note: in 
expansion of macro ‘__BPF_DECLARE_TRACE’
   (__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))  \ 

    ^~~~~~~~~~~~~~~~~~~ 

/data/users/yhs/work/net-next/include/trace/events/sched.h:697:1: note: 
in expansion of macro ‘DECLARE_TRACE’
  DECLARE_TRACE(pelt_rt_tp, 

  ^~~~~~~~~~~~~
/data/users/yhs/work/net-next/include/trace/bpf_probe.h:59:1: error: 
expected identifier or ‘(’ before ‘static’
  static notrace void       \

I dumped preprecessor result but after macro expansion, the code
becomes really complex and I have not figured out why it failed.
Do you know what is the possible reason?

> +
>   #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>   
>   #undef DEFINE_EVENT_WRITABLE
> 
