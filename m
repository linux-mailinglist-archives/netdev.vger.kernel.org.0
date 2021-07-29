Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA46E3D99E3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 02:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhG2AKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 20:10:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56808 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232471AbhG2AKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 20:10:04 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T09n4F031083;
        Wed, 28 Jul 2021 17:09:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/I7i4XG4FbW6c0qm038IV8DPiqrNikluUuBVfHjvsqA=;
 b=gmY0REMGWA2MO8qqUbQFWTqZO7XSvSZv7auhmL1AZrIA5c5IscIEwPPVZlmBKiJ/hkev
 kCqHIhp8i61TPffn1FtSrebTZFbsaZxVEaEAGpx8c5se8eoC8Y0jcVDjjHNjOp8uHvSA
 u63mTHswev/CmsSNnZwwC2rtwRSnOBUL374= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a39fvk50d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 17:09:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 17:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3wRiQXwJ3Ne0c5FBhM+yZyQubhq7lj8ZMAdkr7V1wg/W9SkN7z2D0jdj0DG0c/UnnGY6fCkCLz4M/I6Z+cNXKkzdgl02043JfREATdaXUrOP+0JJSWoMM5IujciesxU8oA1ebQPyJIf55TxUmIS5N8l+yO80Z23sOvtZkQZfWzRkTrWCaFiGwlT0ZokRQfXf2ypxpJvl8DEv+7sEwb9lHL4IFiPIOTX14OY5NvJDwHblLGOMIBIuBtqT5yRHObkMHMnFdZmLpcgYgHQ/zvhgGTpoPRhVWiUrWAAfN3AinDxOP6Yc6FOh4W3sMD3ALni1toIJRNemQJcG85R28NncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/I7i4XG4FbW6c0qm038IV8DPiqrNikluUuBVfHjvsqA=;
 b=VGEfOkrRmK3s8VifJOfJugagU/EV+CMMzMkXPRLSUyjZxHZAnsGz3LnXAHpoA8uzhZIcYayObkGEipn09zx3LQfdXL6mdeoMFLGJ06ZQeMQMIJoy1+sYuXkHlNdBHUvO/XT/MJI+dWvEy/lxAcmS8OCfgPZ3bPw5bD20MC1EpmSfIolG1xVv6EaLp7XZWUjQkcFS6C8qQCVKKr6l/Eo8MMWWLTshHsLZEpYv5u6TluSQlllT19e3A+cCAflsNULqqfW5wmwh32iLkHy6sFC0ciO8MYET2k1LdUy/qk1YF8zfWR9jbzjwpoylJKi4OkRPtHbjI7rB+SHUPhnFu1w+Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2031.namprd15.prod.outlook.com (2603:10b6:805:8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Thu, 29 Jul
 2021 00:09:48 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 00:09:48 +0000
Subject: Re: [PATCH 11/14] bpf/tests: Add test for 32-bit context pointer
 argument passing
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-12-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <deee75a2-a4ce-303c-981a-cd5b6e8cecdf@fb.com>
Date:   Wed, 28 Jul 2021 17:09:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-12-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::48) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by BYAPR02CA0035.namprd02.prod.outlook.com (2603:10b6:a02:ee::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 00:09:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05ba057c-93f8-4d57-bbb2-08d952252d88
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2031D002E716AE0C5D985085D3EB9@SN6PR1501MB2031.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40HQPIsCUIhQ8RAkbh93Z2YxTduXpKneZ4d5OnufiBxQR6KzRwT846Bzu9Zy82N0uitG0VyTDh92dhaMPuNmHkcN9F0wYfaieyldsG5WnmVWYqmjw4O4xpYCQD8FujL1fR23lkCTm2AwNRMIlrQOZAMZrYUSnt0kNjgnzCZLvKccoQqPpDOmCcCcuSsb3euOuy+x7A12J8m/AKeCPx3ef6Yr16wdprF8HmJ36LK6etGdgO5O77GH2bkxdR68J+Y/scm2A2UR6qZ2rB7o5LhL78Tf5cKt3IjnGi00s5YkgEU25/Riom43G1YTpUHZY50L0JrVfaGq2xWph+lqhnySeAJ0AsBiCu8bdei/Kb7om4xmsDCVdkEINwLS33skP+z5wrJAhTnTzEvSnsbJFC8zuN0pZ43zf2+5D5LR/48TNr+2sEuu+6zG7NUHOLPK28GDxSKqIKi1/NVCmhFyNQZ+BTIXMtc1nYmKMUoMvUgh/FZVqLrbjOOXZr+cER8YFQOghTQHWJYYTTuz1z8R6miuFNUvwY4mDo4dni2s5IbuRYOzgXqUSqEfcJtqQhwa2lge/A+wdR7AO3Ik0wCdB8BWvycX7qIgibcv+7t79Dw8xMuVFy7z0zYKfebovcAgncUHUNFSndI5qTmJjy3b+8um2jIQlxOZzFNYI3ccfrQ/j1SLKEleS6G+Zdt4tZ3cIbPs4ZhMn70oaKRSSePYfRYBNpuSsOXi7iNHmWo61Xj8lcwQWB+KhfW1CyLkH6OES44o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(31686004)(186003)(316002)(53546011)(31696002)(66556008)(66946007)(2616005)(478600001)(6486002)(83380400001)(38100700002)(52116002)(66476007)(2906002)(8676002)(86362001)(36756003)(5660300002)(4326008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTlPbHBlRks0bkc1TFBDVUFWWmRkT3Z0MnFkenFmSjVVZUYxVW1tYjgvZDRM?=
 =?utf-8?B?Rkk4ZG50Rlk0WCtrNTN4dFNaOTkxRTFOWEhxY3g2RmRaKzFaS0JLRGVOMUht?=
 =?utf-8?B?b3ZETTlTUWNPb3BML0p2dEk4dVdaTllselR1aFNERHRoYWRXa3NTM0R2cFll?=
 =?utf-8?B?RGc5d0tWWTFmMjU4V3E0WGlKNERIZEVIeFRhZzVoanozUHJuWEFYVTFhQXRJ?=
 =?utf-8?B?UjFtMjRWditVY0hKWHBkNzNlejdLaXhRUUM2Mjk4aG8zM3FVVklHSWtudlUw?=
 =?utf-8?B?WlhaYlRqUEZVOFc1R09Pak9ZVHBvb1FOTUMrTWZ0S2dwdDE1cG1jMFVoQnV1?=
 =?utf-8?B?d0hyNVVmY0NwWndUYzdGOEN3NkwyWDF3N1diM0xJSHVVTStITnBRalpxRU5a?=
 =?utf-8?B?ejc1aFFyOFc3U0ZvQytLMzFKY05JSG9vMGNURWpiekJra1FIUnFpVTdaY21L?=
 =?utf-8?B?blN6dGRRSEY5L05teE1TNHZrM05hUWxNUDhoUlhtekpVZmhSUUtpbjVUQTRE?=
 =?utf-8?B?NmtYUFlVeXhTVmtnV2swN0pzWFhrT3RFNmhMQTgzWUh5Y0o5TlJXZmNmdjNL?=
 =?utf-8?B?OWhzRXpHdlFvc1RpUjJaZ3ZteHBqSi9hUVdBNU5VZ1JBRHNTZHFPUFFpZURs?=
 =?utf-8?B?QUZ1SFdpbnBublk4a1JIUkhGUjR5NWlSYStPQmltYU96ZnhHQ2E3dlNDVUVy?=
 =?utf-8?B?aEtWNFdXQkpyU2wxNTZWQjNMc0dsL1VhTHI3T094Z3dHaS9oK3ExdmcxbTlW?=
 =?utf-8?B?RHJJeXVwcUlzR1JvVmQ2VExBbXZXTXJvYTFuaDNZQXB6K29lUktWRm5XbDFP?=
 =?utf-8?B?YTZ3V0R6K1ZXV2oyTzUzL2tNN0p4b3BtcUNuaFhJSCtpZFhiN0x5Mld1NnJ6?=
 =?utf-8?B?MzhEMmVXUkxWSEJDNnBWZzh1VjVMOUdrRlVZY0tIeWJrbG9oRGtqK2ZpWUlD?=
 =?utf-8?B?UjduV05wZWdxNFlSYlc0QUJDa0dORDJLR1lNWHoyME03WkdESnYzaWdlL0sr?=
 =?utf-8?B?TWx2cW5qemZlaHZUMVpUc3NNOGkveDlKdXFGUTBMU3RQQWRLTnZrVG56ZnU5?=
 =?utf-8?B?M2s1Qk5hWkhwU3dqNjFPb3R1b3FJZFdpVW00S3I1NzZyMzlIODE2clcrbE9E?=
 =?utf-8?B?eUFab0hQQXJEa3AyeGQramQraEpUSk9vRTQwNElRdFpWNE9KUW84UmtvZE9u?=
 =?utf-8?B?ZG5mdGh6aHVqL1lTckw0bWUrajIvTFlONmVZVmU4NjdCRitYcThrRWtNMFhi?=
 =?utf-8?B?Nm1xbEVmQjhQbmpVRTl1Z2pEUDdIV2k1dWhRNGhCWFg2OXR1Sk1WVWZiZ2Zq?=
 =?utf-8?B?WXpicWJJdEZxbllNUkNXUWg4aE9tUkdmNDlSVlZ0djd5R2x3MGIzeXBTV1lk?=
 =?utf-8?B?bllVam45RkhLQmZmbkRJV21JbWVnSTUrQXZqajh6N01jelVXSndyWTkwcXdy?=
 =?utf-8?B?RkZTaHQyTDFjNVBuZjJBbDJxZ0pnbnFQUklRQy9GY0gzZGpJVnJKcXJ3ZXFJ?=
 =?utf-8?B?Z0VmNzBybVM5TkxMSlM0dHNmcUQ1K2REWnpHMmNCRTBQUlR6Q1ExTHBYeW41?=
 =?utf-8?B?YUV0OUlxWjJ4L3RqTHlkcElXRldYK1VxZG5waWdyZHFsSDhuc3Fjd21jVW91?=
 =?utf-8?B?NVJnVEQweWltUlJWMVNuQ0RqYlNTaGVOQm5lQ0UzTHlRb0ExNE5yNXE3UHFp?=
 =?utf-8?B?WXo1L0tjRk51eUtnODNYSHBVclQwcEtCRWNTb2VtdnNyczNWajQzUkYrbUpu?=
 =?utf-8?B?VWphd1VxcktBaitzRmpGeHp4eUhoQStWSWc2cTBtUjhLSXpCM1IzbjNzVmFy?=
 =?utf-8?Q?s8MUK4pUJSLMFp0K8w80oZ2cV92wpfqqrXP5c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ba057c-93f8-4d57-bbb2-08d952252d88
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 00:09:48.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjW9X6gtZDeD0d3+CDAdShpKUvii2lMFfhQ00oo3dA3syifb0k7PSPNOFNVurWZ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2031
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: gi13Ejjey1I9gDC1BOL280vIypKthzEK
X-Proofpoint-ORIG-GUID: gi13Ejjey1I9gDC1BOL280vIypKthzEK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> On a 32-bit architecture, the context pointer should occupy the low
> half of R0, and the other half should be zero.

I think this is probably true. The word choice "should" indicates
this doesn't need to be the case if people choose a different
implementation, right?

> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>   lib/test_bpf.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> index 55914b6236aa..314af6eaeb92 100644
> --- a/lib/test_bpf.c
> +++ b/lib/test_bpf.c
> @@ -2084,6 +2084,22 @@ static struct bpf_test tests[] = {
>   #undef NUMER
>   #undef DENOM
>   	},
> +#ifdef CONFIG_32BIT
> +	{
> +		"INT: 32-bit context pointer word order and zero-extension",
> +		.u.insns_int = {
> +			BPF_ALU32_IMM(BPF_MOV, R0, 0),
> +			BPF_JMP32_IMM(BPF_JEQ, R1, 0, 3),
> +			BPF_ALU64_IMM(BPF_RSH, R1, 32),
> +			BPF_JMP32_IMM(BPF_JNE, R1, 0, 1),
> +			BPF_ALU32_IMM(BPF_MOV, R0, 1),
> +			BPF_EXIT_INSN(),
> +		},
> +		INTERNAL,
> +		{ },
> +		{ { 0, 1 } }
> +	},
> +#endif
>   	{
>   		"check: missing ret",
>   		.u.insns = {
> 
