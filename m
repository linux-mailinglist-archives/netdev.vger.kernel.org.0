Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BBF3D98EC
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhG1Wbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:31:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7600 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231989AbhG1Wbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:31:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SM79Yk028832;
        Wed, 28 Jul 2021 15:31:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=eM1qLnHZg5hI3V+ygr18ythW9JTZHdSTh6QNWjtwqiE=;
 b=otrSHJQnULlxqkVNvcchi1gCtN/kH65+50oAKKgLbDs2KLaXVMETcQVBjqah4fN5L5ed
 erC2NjAQv3ktWc7XarOj8iQZ2GFdh86S2srM7HRTV41oXO1MEGuQimJ4XzINSHh9FBY6
 Dzxn3Wr72eb9DD9WP+jiF5JIRcZLGZlyOtA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a38tpk4cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 15:31:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 15:31:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/FjProD3lB0dWYdo9tedSCerJuD4QYjmzRkom6X8eu8yDzVGp2GGaKrpTWo6yz6bPIdI7yXb2f89inWKwavLp6M2SkSXJ9a2Ee2fRfGSUlMzUl15Dmh08qrzBb5En0rv00QnVrw9tYxH65mtr1hIXK410NThAuOjszHT76ziendeVmgm0SKQizSzakC8d4wimy7Dpwlmvo2uKdK9ZvFe9g/ifw0B19djNk/Jgas5tc9bDmMY2RpjmwlmLsxHj85B47EkOyV0xpGvU6kkQCjEqFL/Uo9IX7iHw8EJOMm0a6g4CpJf1bFwXpZgrOTEoYXXxbHa/EuJs+T2dvqk1Ty7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM1qLnHZg5hI3V+ygr18ythW9JTZHdSTh6QNWjtwqiE=;
 b=N8wVkPEAj56jcBLyvIy5t1QubHpuhBUZrFZML28Prd22s3V7Vi6fRT5mrechDv4HuZIsrLn74ApySfnBVf7a6MsLY4ViTKK7ZPS+eWY/fmScIt0l7dk54u1TC4FcCDzD+ex6QYvOjlCn56K1CaCFTGIR90Ba3hJ73B08COqHC75oAsR2B3n6V+QyzJjrV+EQjU7YhVmRtdt2aQPw9Rsipa6pIiZDB3S6prduiIBt0vHE2T6Sk7DYSTodS/1Rd4tZwcOTbrQmvBv0KWwddtmnHWtfDwObXrnMmSb/5UofqpVMjpDHVEt8WXOIbYsAjlDSkijOOYNzgn49FFJxDlayKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM6PR15MB2522.namprd15.prod.outlook.com (2603:10b6:5:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Wed, 28 Jul
 2021 22:31:32 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f%7]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 22:31:32 +0000
Subject: Re: [PATCH 01/14] bpf/tests: Add BPF_JMP32 test cases
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-2-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ede57ee2-a975-b98c-5978-102280a77d8c@fb.com>
Date:   Wed, 28 Jul 2021 15:31:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-2-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:303:2b::22) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by MW3PR05CA0017.namprd05.prod.outlook.com (2603:10b6:303:2b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Wed, 28 Jul 2021 22:31:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f6be388-4eea-430c-42a2-08d952177339
X-MS-TrafficTypeDiagnostic: DM6PR15MB2522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB25223C6202F7EE2A63300750D3EA9@DM6PR15MB2522.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEWJDaEX0symsOrjegJXLZ+VupJ5jIvzLTNDlwUciOaLKfZfmvPfKaBD4gD9eCoGu6Vd2BC0bl1mTwYxo/tvKU3YqddowtS2G3Rr7cx3qmmjuTikAMmL1qBafvqNkcvwWWdfFjs3VnZCS3+DNy4JVCttHXdbIJtukUBKbuoOxBXHbGHbdGliCOZzIZk2BogUP2nFqFy234EruAPTSs+ZBY3u95UKCUquIi4at/eXR8ug+UgDnlFp7Ay0d1vduE2Qwji8ex5UU/52FMc2pOIoHh2/6frCtHpTbk9sO0l6+F3pZoGT/Ry6GX9vzut+PoOH6N2ZA5baGpDtUjI4mNeIkFCHEyHHkIYVzjYGG9E3/Q1Yz9mnwZL8A+SSLZkcNTZrXRQkpUyuFByvecHoCcY9WTm++RkVdjuhh+YEGIM+nzs/Y4GI61SVQYFHjAi64T6Gy07MxcRmZRhDjOkOcuEtdeg6Do97dwUTjrYVV/J+8/6eniyB4PArWesc0aZCwwFdpy393kNwTAy8IidRzEcvLCF1YKxwj2W47YnVgUR5hZHvD7ED2pLwsrm12e//EZ8sLjJZrt21D5BZZMOUvFtXNl/x4CSNy2S9cGGZj51pvec+hO1FXBu5Hx26ubLWeCL8IqpNiHtlKOHShAdE6+H/iDpk3SwoohFr122L/rYURM9HCfwTVRDcSIccI8sABzmNvpHAaKtsOwAOhn5mTkPheQUXqMqYr+5HaOlWmChsrYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(8936002)(2616005)(2906002)(478600001)(66556008)(316002)(8676002)(31686004)(5660300002)(6486002)(186003)(66946007)(66476007)(86362001)(6666004)(52116002)(31696002)(53546011)(38100700002)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZkVHJTbG9SSElYYUZJNVR5UTRNdFFtbHp3N0dXMWFYZTlSRjdMekx1dFJX?=
 =?utf-8?B?TTR4enY0UWd2djZxMjB6UmVXT1VuOFR1dzFIUGpvcC9wb3ZkMjk2Nk53eVMy?=
 =?utf-8?B?d1J2L2Nlei9iVytNRytQaFo4OWtvVFA0MzVURUFVRXZmdFlYMU5aVzQ5UjFn?=
 =?utf-8?B?YkFJU2VMNzVROUNjZkhMblV5ck1NdzJrVmJsUUhSVzBOUEF4N2ZHa01jOFVK?=
 =?utf-8?B?RzBlenRESXBtYm5OVDBsV0w4QzQwYm0za3ByaHNxeDQwZXBPSCsxVm8wQkpx?=
 =?utf-8?B?Y3JYcVVrbFFFN3ZlQXVjbGF2Wkd6WVFHQ0JjdWxGcG1XVmcveTdHclIyWExV?=
 =?utf-8?B?YlVSNWhQN2RYY083VGdxVE1uOXFWdG9XNTBpVFkxeEhLblN6MGI3TGhTNktO?=
 =?utf-8?B?bS96RzErUjU3ZmkwMWM4NGgyQTJoRWZnejh1eTNCemMrKzkwSGVWbmFlY3U0?=
 =?utf-8?B?Ymx5OC94ZEU3QnNiR25LNFRDRDJHQ0tiMkVUNTRxdmtGRUFrdmJYMlZ2V1c2?=
 =?utf-8?B?ZW9hbEcyd3pxQUdGRWFXalVjM1BKVlZNeWFRR0Jld3dlRFFaVExEemhBbytz?=
 =?utf-8?B?VVlZVG9IZHN6QjA4bWIwbXdxUytXalBQaFdXUnJ5WDNPWjU0T3Y1RGFFaGVL?=
 =?utf-8?B?dHlDZWgyMFp2OXowVHBPYS9FYXRkeTRnbUppRzZSQlkrQUZ5UmpGeEY1TFli?=
 =?utf-8?B?VWd6L0xBUGNKbWQ0cnRMRFhMbVBoQkwyMGpnZEtwcm1oR0pXVGNjbjJXdXkv?=
 =?utf-8?B?bEFWSG0rUzliNzBoc0V6UnQ3RWdQcUpjQ2ZqYW1RRUQyUHZTVyt2b0lrSGNM?=
 =?utf-8?B?SmVjK1pJTGVUZDhvdS9aeE9OV1hBdGNOZHRicE53YXVuT1RsaUpraVRDS1ZM?=
 =?utf-8?B?VENSYkRJb2pzZHEvd0VTd0lZaVZ3RytGamNMclNtbWM4TnNibnltNjFuUitM?=
 =?utf-8?B?VDN1TkRVbGNXZmtrY09SUytGV0l3YXIvSWxFOFJxUmNPWkhZVTZXUlVjQUFV?=
 =?utf-8?B?eFp1QjltWTJqcEprRWlnaXdoQTdxNEdhZTdTdTNRcXhOMnZrTGcvb2Q5d1hk?=
 =?utf-8?B?ZkE1UjZEY00xeTVFdFpsYy8xVzRBaFNVR0ZXTnR6YlBoRTFOTUg1RlZ5SS90?=
 =?utf-8?B?NkxnQi9oVzZIU3ZqSSt6VVBETGJlUFdFdlhZazBXclhxNlJPV1FVQ3FFMy94?=
 =?utf-8?B?cDhFcVFKK21wb09FRlNvRFlidGpCdlNkdUtleEQwZ25uSE9EY1NCZ1QvN1Vj?=
 =?utf-8?B?SXBPcDM5ZnFRQ3VLRDhnc1kvNDNlNlNuVmRXUWU4QWUzTWFhL1I5dzZNNWtT?=
 =?utf-8?B?Z0RRT1FOMU5ZK0JDVmY4cDRkaGQ1cXJ6c1Z1aS9neE9lZlQvU1R2aG1pZTBa?=
 =?utf-8?B?SG1jUWFscUFUeHRpWmY3Z0lKOWEyeGNsZ21FY3BxdzZkVnRTZHJVYmpzczBr?=
 =?utf-8?B?d3BFZE9jNmNSSmYvZi9QTkV3SVNKdUlpR25rL1g4ODJxYmhJQmtnR2RvZGxS?=
 =?utf-8?B?QlJLSGw3TVN5cjRjNHVwN2JUZENpejQwbExuODB0NUpwcDRYaXpqaHhaWk1U?=
 =?utf-8?B?VXE1c1ArMXZEeEFVaHdDNHRJc21LcWxsdS9zNTg5aUxveTkrd0pDNndHanBr?=
 =?utf-8?B?ajd4L0YvVE9MbVlGTVRQMjNCSzdlbWVyRUNRLzlPOXNXQkNDWmg5V2Eya1o5?=
 =?utf-8?B?MGRHOTFyVDFWdGUrOGdxQzlxMTYvZ3JKZ0ZwMHR1ckI3SWN2eW0va1gzSjYv?=
 =?utf-8?B?RWVxZGd1Nm02ZzBGYVdvaldPTHlTblAycDRhQllaSkFsVXN3c04wZDlQbmY0?=
 =?utf-8?B?ZHBJL2lJUmFDUnJja2FkQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6be388-4eea-430c-42a2-08d952177339
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 22:31:32.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbY5JIWMsup6R0spxDC+yBC9cc1QtYUMdA2qjmItfJ+Oi8r+14ob2ffP+33EOq27
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2522
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 5BVd_Vx3dgT5vSpCTByV_fowt6Uan9bE
X-Proofpoint-ORIG-GUID: 5BVd_Vx3dgT5vSpCTByV_fowt6Uan9bE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> An eBPF JIT may implement JMP32 operations in a different way than JMP,
> especially on 32-bit architectures. This patch adds a series of tests
> for JMP32 operations, mainly for testing JITs.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

LGTM with a few minor comments below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   lib/test_bpf.c | 511 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 511 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index f6d5d30d01bf..bfac033db590 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -4398,6 +4398,517 @@ static struct bpf_test tests[] = {
>   		{ { 0, 4134 } },
>   		.fill_helper = bpf_fill_stxdw,
>   	},
> +	/* BPF_JMP32 | BPF_JEQ | BPF_K */
> +	{
> +		"JMP32_JEQ_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 123),
> +			BPF_JMP32_IMM(BPF_JEQ, R0, 321, 1),
> +			BPF_JMP32_IMM(BPF_JEQ, R0, 123, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 123 } }
> +	},
[...]
> +	/* BPF_JMP32 | BPF_JGT | BPF_X */
> +	{
> +		"JMP32_JGT_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
> +			BPF_JMP32_REG(BPF_JGT, R0, R1, 1),

Maybe change the offset from 1 to 2? Otherwise, this may jump to
   BPF_JMP32_REG(BPF_JGT, R0, R1, 1)
which will just do the same comparison and jump to BTT_EXIT_INSN()
which will also have R0 = 0xfffffffe at the end.

> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
> +			BPF_JMP32_REG(BPF_JGT, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JGE | BPF_K */
> +	{
> +		"JMP32_JGE_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 123),
> +			BPF_JMP32_IMM(BPF_JGE, R0, 124, 1),
> +			BPF_JMP32_IMM(BPF_JGE, R0, 123, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 123 } }
> +	},
> +	{
> +		"JMP32_JGE_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_JMP32_IMM(BPF_JGE, R0, 0xffffffff, 1),
> +			BPF_JMP32_IMM(BPF_JGE, R0, 0xfffffffe, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JGE | BPF_X */
> +	{
> +		"JMP32_JGE_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
> +			BPF_JMP32_REG(BPF_JGE, R0, R1, 1),

ditto, change offset 1 to 2?

> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffe),
> +			BPF_JMP32_REG(BPF_JGE, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JLT | BPF_K */
> +	{
> +		"JMP32_JLT_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 123),
> +			BPF_JMP32_IMM(BPF_JLT, R0, 123, 1),
> +			BPF_JMP32_IMM(BPF_JLT, R0, 124, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 123 } }
> +	},
> +	{
> +		"JMP32_JLT_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_JMP32_IMM(BPF_JLT, R0, 0xfffffffd, 1),
> +			BPF_JMP32_IMM(BPF_JLT, R0, 0xffffffff, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JLT | BPF_X */
> +	{
> +		"JMP32_JLT_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
> +			BPF_JMP32_REG(BPF_JLT, R0, R1, 1),

ditto.

> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xffffffff),
> +			BPF_JMP32_REG(BPF_JLT, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JLE | BPF_K */
> +	{
> +		"JMP32_JLE_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 123),
> +			BPF_JMP32_IMM(BPF_JLE, R0, 122, 1),
> +			BPF_JMP32_IMM(BPF_JLE, R0, 123, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 123 } }
> +	},
> +	{
> +		"JMP32_JLE_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_JMP32_IMM(BPF_JLE, R0, 0xfffffffd, 1),
> +			BPF_JMP32_IMM(BPF_JLE, R0, 0xfffffffe, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JLE | BPF_X */
> +	{
> +		"JMP32_JLE_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0xfffffffe),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffd),
> +			BPF_JMP32_REG(BPF_JLE, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R1, 0xfffffffe),
> +			BPF_JMP32_REG(BPF_JLE, R0, R1, 1),

ditto

> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 0xfffffffe } }
> +	},
> +	/* BPF_JMP32 | BPF_JSGT | BPF_K */
> +	{
> +		"JMP32_JSGT_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -123),
> +			BPF_JMP32_IMM(BPF_JSGT, R0, -123, 1),
> +			BPF_JMP32_IMM(BPF_JSGT, R0, -124, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -123 } }
> +	},
> +	{
> +		"JMP32_JSGT_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_JMP32_IMM(BPF_JSGT, R0, -12345678, 1),
> +			BPF_JMP32_IMM(BPF_JSGT, R0, -12345679, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSGT | BPF_X */
> +	{
> +		"JMP32_JSGT_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
> +			BPF_JMP32_REG(BPF_JSGT, R0, R1, 1),

ditto

> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345679),
> +			BPF_JMP32_REG(BPF_JSGT, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSGE | BPF_K */
> +	{
> +		"JMP32_JSGE_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -123),
> +			BPF_JMP32_IMM(BPF_JSGE, R0, -122, 1),
> +			BPF_JMP32_IMM(BPF_JSGE, R0, -123, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -123 } }
> +	},
> +	{
> +		"JMP32_JSGE_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_JMP32_IMM(BPF_JSGE, R0, -12345677, 1),
> +			BPF_JMP32_IMM(BPF_JSGE, R0, -12345678, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSGE | BPF_X */
> +	{
> +		"JMP32_JSGE_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345677),
> +			BPF_JMP32_REG(BPF_JSGE, R0, R1, 1),

ditto

> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
> +			BPF_JMP32_REG(BPF_JSGE, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSLT | BPF_K */
> +	{
> +		"JMP32_JSLT_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -123),
> +			BPF_JMP32_IMM(BPF_JSLT, R0, -123, 1),
> +			BPF_JMP32_IMM(BPF_JSLT, R0, -122, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -123 } }
> +	},
> +	{
> +		"JMP32_JSLT_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_JMP32_IMM(BPF_JSLT, R0, -12345678, 1),
> +			BPF_JMP32_IMM(BPF_JSLT, R0, -12345677, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSLT | BPF_X */
> +	{
> +		"JMP32_JSLT_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
> +			BPF_JMP32_REG(BPF_JSLT, R0, R1, 1),

ditto

> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345677),
> +			BPF_JMP32_REG(BPF_JSLT, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSLE | BPF_K */
> +	{
> +		"JMP32_JSLE_K: Small immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -123),
> +			BPF_JMP32_IMM(BPF_JSLE, R0, -124, 1),
> +			BPF_JMP32_IMM(BPF_JSLE, R0, -123, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -123 } }
> +	},
> +	{
> +		"JMP32_JSLE_K: Large immediate",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_JMP32_IMM(BPF_JSLE, R0, -12345679, 1),
> +			BPF_JMP32_IMM(BPF_JSLE, R0, -12345678, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
> +	/* BPF_JMP32 | BPF_JSLE | BPF_K */
> +	{
> +		"JMP32_JSLE_X",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, -12345678),
> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345679),
> +			BPF_JMP32_REG(BPF_JSLE, R0, R1, 1),

ditto

> +			BPF_ALU32_IMM(BPF_MOV, R1, -12345678),
> +			BPF_JMP32_REG(BPF_JSLE, R0, R1, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, -12345678 } }
> +	},
>   	/* BPF_JMP | BPF_EXIT */
>   	{
>   		"JMP_EXIT",
> 
