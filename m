Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21633B8BD0
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 03:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbhGABsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 21:48:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237149AbhGABsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 21:48:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1611cdHW000626;
        Wed, 30 Jun 2021 18:45:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6lxW4emFz69VsUHruT4Ss1QOfrUgx4LE+RjjMyI76jM=;
 b=guaFqotAorRP/9gN4tD8YIM8lcrk4tplFqsX6s5F/DRrUQAQkKhMXtyxvp8LANV0TiD7
 krkK/n20BEoIvn1nFkn4cZMIZ9EPiGZ9wH5bwAIDe2y4r/SiSXgX9mUI8Bj86e/Aeo8A
 eIOLiKAwOiII7SMJBj97odOjmlc2scJgBBM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39h1wyrnaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Jun 2021 18:45:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 18:45:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnTHoPhHS75Ad+g9mf4YiZWMbs2qsE9QEHvao9SHy2cOXJzfJcjQjCKEjAS+YLJ7TNMvomiWjhRqJKUWeZRjTZqYCltYVZ4LEFyvGHw/YiEKuoT3s/usMT/6mmCmsAHNFHtKQ2dq+apuQZBZJ4+i2gShnJgOvjvVUIa8M7acKWUk9bCycLVTystQd8SMaX+wV9gliBS/B9qYnjTYBeyTvwsUrBzqqWmuqphg0QsyXkQ18GzKVTIB9M9DwzFv8lsNa5TBTN7O83wohUoTev0qVhyeOhEXpQJHoHzTHXCTdvHlsBCu8Gwl1WWWK3MjrJ0UK32+GMHPQJaLFEfflfhSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lxW4emFz69VsUHruT4Ss1QOfrUgx4LE+RjjMyI76jM=;
 b=NzEodpLoekqfECNBpEFInzHdJBpokcfbVUxKvAjCNVlotdPN+eyNZZ9Mq3j3cpbwj2kCSKGHifo9EsFlCryQNETLxv5R5F7FBT/CwNO6lHmNkX7JH1dul0Yr7hv/zBSupyb05MqE2crGzaPCG0ajBKHhP/9TTM0lhqFS3GCRsBNb9gUK2Fz1etWm9kEteY2d+GJKYlos075F58vzTYBJLvYYrayWhskad3GqVB7Bln4KAufngfULR+Dd2eaxEQ5bWiS359RqHgLc+rWO4RjlrvcfKfWYqu93FzlUjilJORxee65lvuwQEIDXH7S5DJPsGWyvSpqN0pMpsjUGv4q0pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4497.namprd15.prod.outlook.com (2603:10b6:806:198::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Thu, 1 Jul
 2021 01:45:49 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4287.023; Thu, 1 Jul 2021
 01:45:49 +0000
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
To:     Masami Hiramatsu <mhiramat@kernel.org>
CC:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20210629192945.1071862-1-jolsa@kernel.org>
 <20210629192945.1071862-5-jolsa@kernel.org>
 <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
 <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9bf11f44-37cf-3d39-619d-87b9b611716e@fb.com>
Date:   Wed, 30 Jun 2021 18:45:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:2f06]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::19fa] (2620:10d:c090:400::5:2f06) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Thu, 1 Jul 2021 01:45:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 431ab3be-c3b9-491c-54d6-08d93c31f3f2
X-MS-TrafficTypeDiagnostic: SA1PR15MB4497:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4497843BB472CD9F7A89BD75D3009@SA1PR15MB4497.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AM4ljh1H+qsf0fMJe/Fuxws2Q+1udksY9uNE0dpSeaDFwHtOSQXbHUUyZaP0rPA9DGOU/qDrpPUTNgIBhhWKdzko5Y2QIy/sowxj/0Wtz1Cp0xuWnnMHwRCAfqZTBId1li8Jg3AZdIaj7/pC5lv+a8ouj0ikc8Bb7oSpQTZi5qm+eoHX+KI7arT8Mbb+8yGt9eusm+gWjVU9gz7LNH+dXRcudVPVpaC5Szv30b7w9Rbhcy7N3OQ2z6iDjn2SErXVZmp9l2SYJwXdZDasJegdSQIb5k/rwoVaYkClMOEJRAc1cezwHBA5Drm+n52oBMOmsaOtds8ck5vokO54OUYL/8i0r1b1Ls8HNJaeXxxJkwOxjaPnQ7WZOCnAMcsvV70vJlhMsv7PobywpPL90xj8eGcApjxB/2IIs3clVWstDNu3QIhsZwK2ZiujkAgXJU9/Kv58h3eyofF5l97/Ll7nNfWpa14IzUE4EAykQlzwDtTeNU/dGDYR9S93JHZugO1NcTzExMfHoNAY9PeXjJlzJII+FjK6PLD+nWdQ5GBKJJG8cdgu+O4K4oAvHUTzXtyygliRt6f4bnSpPcV8PNYL8sw1kS+Vhy+AE3o8FcxUD8AXQRMhsx2OwD2S9JTE6MMSJrrrbFJvjFf5H2O+xrvceiJsJQ2irrPJNc8JGvMdB5rUkIog+w3ljpEyIEIah5a+z7zTfOoLclqPRoeLdbq+nydiom6/7h1DJulNu41HN4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(8676002)(478600001)(53546011)(186003)(6486002)(86362001)(31686004)(16526019)(31696002)(2906002)(5660300002)(38100700002)(83380400001)(316002)(2616005)(54906003)(66476007)(66946007)(6916009)(8936002)(4326008)(52116002)(36756003)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFJPN0h2L0VqbFFleGIzZU1tNVhiUGlIUXZiTUNXaERHcjdyYlhzUzlXd2tB?=
 =?utf-8?B?VGpvNkFCL0NpeDRvdU1nYmo2Q2lhU2c4MmdsdXVWelJNL0FDVWFDY3U1OG13?=
 =?utf-8?B?ejJMT3JqN1FFNTZUd093MnFWT2RXLzkrVGtZKzdnS1lnenBscG1OVDdLOWVQ?=
 =?utf-8?B?K1hqZko1MEFmWmtHTTBoNWVueXVXdXd6UE96by9ZbnZ4ZWl6WjR3TEp5SXE0?=
 =?utf-8?B?MnNyVWFodms1aUgrNUpTa0ZnNUx2VkJRc1FBSE9lN24xRWY5SDNDM3lFTDRG?=
 =?utf-8?B?dTJyR0NrSmt0MTI4NFdVZ1JMWXBIU21zb0tURzhBZnRjcjJNRlR3WkFUeHJJ?=
 =?utf-8?B?Z0hKU1hRY3QzWTNOUlp3YmJCUFk2VFgvbEJjNnBBakQ0N2FrbGtDalFaK043?=
 =?utf-8?B?azlkdDhxRFEvSkRhb0FVVXhrdVRKVFNBQnpGTDIzdno0WC9jeVNyMzc0NDlC?=
 =?utf-8?B?bTFoT0ExRDlVNGE2RnRXVzFJK1BZSWdFQk52dUxmOUdXU29iZUR0KzVmWFdJ?=
 =?utf-8?B?QzQ1OEVyakhpczhIM3JWZzNWK09pU2JxbXorM0Q2ekVHb2dCYmQrbmF0RUEy?=
 =?utf-8?B?NURvZ3p6TmRvUVkzcHBHbXgxcThJNDFRWXozYnQ5RVUwZzBQc0ZFZi83dHpM?=
 =?utf-8?B?UEVxMmJhcHdPVmlzYkJoWFhNY0JxOWF0eDhjdGh6ZGtqcGtuYlRNUjF5Z1Y3?=
 =?utf-8?B?QlhJTHhWaXp1d3VGKzVndVJmeDlsd1p1L1lyNEpFK2MyWjlpMytIWVpydEUy?=
 =?utf-8?B?ZG5GVGpJQ0dPMVFrbHFYNmNQMW5nOUtQNTQ0cjNGTktZY2oxNjBzVTRWUDI1?=
 =?utf-8?B?R2RzVXBac0N1L0F3aTE1dzJRaTZzRVo1a3VMWWpWNW5UbmRrLzU1c1d6bVQw?=
 =?utf-8?B?TGNaWW5DQnYwcFVBOVQ5ZW5GL2pWYk1DbTcwWDhqUXdFVFEwRkV0SzI0OTA1?=
 =?utf-8?B?QXk0QkVCU21rUnA0U0FrT08yZDlCYU1NbzBpcitRYm5DL1RlVlE4ZUlmNnMy?=
 =?utf-8?B?VDM1TU9aZlV0Z1B1cmVudkxyc1NhRmQwbDdpcnpncXhMRzgzMlBjcjJab1JT?=
 =?utf-8?B?bzgyUFJGS0Q1N1dNMmlSb2xyVWFYL2tCQ2FTb1VWSU9wRmpmNXh0SDhXY05T?=
 =?utf-8?B?QTg0NXNQSk90eFRnN2VFOWZ1bmFVb29XdWk4K1BEajRjL1NEclZUV1cvSSt5?=
 =?utf-8?B?UVhDMkwyZlRBdGpmeWZUU1NLQ3d3ZksvblBEQmphSnRFb3ErYWhnaHZhUUsx?=
 =?utf-8?B?cXdVUnN6cE9hOHc0UTZ3SStaQWVBUFN4QjJwblY5ZXI1cUpQWGgrM3BLRjJt?=
 =?utf-8?B?UG9DT1BOZU9QMGRvSENRNnllUDQxQjJsSElTNWFBQlBzVURJcXhvWEF1T09z?=
 =?utf-8?B?STV0amE0R0RKbnpvMzBLV01qWkV2dlVJc0thaHhuNEE0cEpnakJpbGo2aitx?=
 =?utf-8?B?VU43NHNYQlJsandLMVZrWUtabmkrakd4S1FIN05MSGZBbkl5WHNVUWpiZDFi?=
 =?utf-8?B?dUdIM3hjcmFWQXVyYmpFa2drS2RkSkxiNXduWFZWakd4c3kvYlZBREV6U0Mx?=
 =?utf-8?B?a0ZaWm1WYkVOMGJQaFpDOWdtVy9LendUQTVaWW10MTIxdTRrZjAzNWpaNEs3?=
 =?utf-8?B?S3hkTmU0bVEzdnpiQUFFbWo3ZzlvSGZ5VGIrc1IxRzF2bXg4RENVWld3bjM3?=
 =?utf-8?B?bjlvZDdNSHZwemtuSURuK2VmaHcvbkNoNEo1MUFxWlJweE5JbytqNGgzbGJB?=
 =?utf-8?B?ZGR5WnE4K3dlSnhRMVoyczdHNitLMXV4UDgrTGp2MlZtQldsYkhOUTRWNFBy?=
 =?utf-8?B?UWdCQWY1V2RjcWhiUHQ4QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 431ab3be-c3b9-491c-54d6-08d93c31f3f2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 01:45:49.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILrB+grvZzPDv93lvsyUQqfPBTZjk/0uxQJhF7kwQwRJ2XP5ta4Tk1KYc99Fz6h6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4497
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 0zzWI0EG0BE3ZwUnXKDeh7Pp2rRxWAA6
X-Proofpoint-GUID: 0zzWI0EG0BE3ZwUnXKDeh7Pp2rRxWAA6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_13:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107010010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/21 4:58 PM, Masami Hiramatsu wrote:
> On Wed, 30 Jun 2021 10:47:01 -0700
> Yonghong Song <yhs@fb.com> wrote:
> 
>>
>>
>> On 6/29/21 12:29 PM, Jiri Olsa wrote:
>>> Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
>>> so it's now possible to call bpf_get_func_ip from both kprobe and
>>> kretprobe programs.
>>>
>>> Taking the caller's address from 'struct kprobe::addr', which is
>>> defined for both kprobe and kretprobe.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>    include/uapi/linux/bpf.h       |  2 +-
>>>    kernel/bpf/verifier.c          |  2 ++
>>>    kernel/trace/bpf_trace.c       | 14 ++++++++++++++
>>>    kernel/trace/trace_kprobe.c    | 20 ++++++++++++++++++--
>>>    kernel/trace/trace_probe.h     |  5 +++++
>>>    tools/include/uapi/linux/bpf.h |  2 +-
>>>    6 files changed, 41 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 83e87ffdbb6e..4894f99a1993 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -4783,7 +4783,7 @@ union bpf_attr {
>>>     *
>>>     * u64 bpf_get_func_ip(void *ctx)
>>>     * 	Description
>>> - * 		Get address of the traced function (for tracing programs).
>>> + * 		Get address of the traced function (for tracing and kprobe programs).
>>>     * 	Return
>>>     * 		Address of the traced function.
>>>     */
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 701ff7384fa7..b66e0a7104f8 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -5979,6 +5979,8 @@ static bool has_get_func_ip(struct bpf_verifier_env *env)
>>>    			return -ENOTSUPP;
>>>    		}
>>>    		return 0;
>>> +	} else if (type == BPF_PROG_TYPE_KPROBE) {
>>> +		return 0;
>>>    	}
>>>    
>>>    	verbose(env, "func %s#%d not supported for program type %d\n",
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index 9edd3b1a00ad..1a5bddce9abd 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -961,6 +961,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
>>>    	.arg1_type	= ARG_PTR_TO_CTX,
>>>    };
>>>    
>>> +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
>>> +{
>>> +	return trace_current_kprobe_addr();
>>> +}
>>> +
>>> +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
>>> +	.func		= bpf_get_func_ip_kprobe,
>>> +	.gpl_only	= true,
>>> +	.ret_type	= RET_INTEGER,
>>> +	.arg1_type	= ARG_PTR_TO_CTX,
>>> +};
>>> +
>>>    const struct bpf_func_proto *
>>>    bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>>    {
>>> @@ -1092,6 +1104,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>>    	case BPF_FUNC_override_return:
>>>    		return &bpf_override_return_proto;
>>>    #endif
>>> +	case BPF_FUNC_get_func_ip:
>>> +		return &bpf_get_func_ip_proto_kprobe;
>>>    	default:
>>>    		return bpf_tracing_func_proto(func_id, prog);
>>>    	}
>>> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
>>> index ea6178cb5e33..b07d5888db14 100644
>>> --- a/kernel/trace/trace_kprobe.c
>>> +++ b/kernel/trace/trace_kprobe.c
>>> @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
>>>    }
>>>    
>>>    #ifdef CONFIG_PERF_EVENTS
>>> +/* Used by bpf get_func_ip helper */
>>> +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
>>
>> Didn't check other architectures. But this should work
>> for x86 where if nested kprobe happens, the second
>> kprobe will not call kprobe handlers.
> 
> No problem, other architecture also does not call nested kprobes handlers.
> However, you don't need this because you can use kprobe_running()
> in kprobe context.
> 
> kp = kprobe_running();
> if (kp)
> 	return kp->addr;
> 
> BTW, I'm not sure why don't you use instruction_pointer(regs)?

How about kretprobe? I guess kp->addr should still point to
function address but instruction_pointer(regs) does not?

> 
> Thank you,
> 
>>
>> This essentially is to provide an additional parameter to
>> bpf program. Andrii is developing a mechanism to
>> save arbitrary data in *current task_struct*, which
>> might be used here to save current_kprobe_addr, we can
>> save one per cpu variable.
>>
>>> +
>>> +u64 trace_current_kprobe_addr(void)
>>> +{
>>> +	return *this_cpu_ptr(&current_kprobe_addr);
>>> +}
>>> +
>>> +static void trace_current_kprobe_set(struct trace_kprobe *tk)
>>> +{
>>> +	__this_cpu_write(current_kprobe_addr, (u64) tk->rp.kp.addr);
>>> +}
>>>    
>>>    /* Kprobe profile handler */
>>>    static int
>>> @@ -1585,6 +1597,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
>>>    		unsigned long orig_ip = instruction_pointer(regs);
>>>    		int ret;
>>>    
>>> +		trace_current_kprobe_set(tk);
>>>    		ret = trace_call_bpf(call, regs);
>>>    
>>>    		/*
>>> @@ -1631,8 +1644,11 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>>>    	int size, __size, dsize;
>>>    	int rctx;
>>>    
>>> -	if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
>>> -		return;
>>> +	if (bpf_prog_array_valid(call)) {
>>> +		trace_current_kprobe_set(tk);
>>> +		if (!trace_call_bpf(call, regs))
>>> +			return;
>>> +	}
>>>    
>>>    	head = this_cpu_ptr(call->perf_events);
>>>    	if (hlist_empty(head))
>> [...]
> 
> 
