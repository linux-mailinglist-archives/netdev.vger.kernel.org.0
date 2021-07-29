Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB73DA7B6
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbhG2Pjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:39:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52842 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237764AbhG2Pjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:39:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16TFdLbi023552;
        Thu, 29 Jul 2021 08:39:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Gcjy4qhNFnkVweRCjdMATvbkuPTn4duT2M+hkXDWZ8M=;
 b=YNXrBNv77oBmg4vZ+9Va8xgbMShu1F3tvqMjoadNKIjH7UVCcoH2L/J7U5OzfaF/NQTH
 UtLD+eIYGCOYG1HetqEIJrY9T8j4HJyFRlxvSawuo3Wn25JomrMv6X9Ll09sIL98IJ0U
 /pEKABTOGmMPB/UKPRsDktcU52Dct6mHLfY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3a37bf8epy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 08:39:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 08:39:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+c3k8I+BZY9fq0syFlOl8ZP1Kv2wXKj+U6n2j0wOV/xx0bN7CIijynouUfkxEQ+OFYjJh+T7/WFTNkdE9Kho7C83e96bODNjPthDvLmpoFm6Kiu3RedsmhsHRJt41bogH2Oe98HNs3E765y7AdJoR31EyV3oeNniZdhzgExEo6lF7pNtAHwtIbdFmw6nGYNhdN72Er3i5QSjORrFLnzfqY9rzMKcegWKn9TXGCTNG7Q1KNGS/YHHYAT4Vb+lD27MUhPQReTC5taaIy91UDASYoz7eTME1oudJQmyxTQ2+Cmknzac4xlZrYj9Sgg79rSRD8foyQg0yNWRqh0nLylgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gcjy4qhNFnkVweRCjdMATvbkuPTn4duT2M+hkXDWZ8M=;
 b=aylV+Y5Qf4bwD03iLzKU3KF6lpNAwRrFPVXht45VTcq7RPOCGTqHggQbiikE5e1SYEUrYuRoOwhaXEqb7U2EHk5buniZ0Uofb8t/voR3g5xdKEHbqC92klLxfC6IazYXvyodiQqSzqX6H3QG6AaEO4DnFB9fcCNYe/SEANHJEI0r6Oo7gIgdvsKA4uTviXNyjLEm6/Y3FVL6EnbtzMZs4y2ACY20rdAyZ261IihT0AE0kA7FIuPKuGLThIBv7WMP3gJtQmDHpnExyw4QQYRccuftgGJg6gL2tXHw8oVOsy+r6fjIJvZ7nU1i1qjn9geFvfdM1gAWREqjtnX+9FLluQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4014.namprd15.prod.outlook.com (2603:10b6:806:8e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 29 Jul
 2021 15:39:28 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 15:39:28 +0000
Subject: Re: [PATCH 06/14] bpf/tests: Add more BPF_LSH/RSH/ARSH tests for
 ALU64
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-7-johan.almbladh@anyfinetworks.com>
 <b134e3bc-a9f7-6c4f-21fe-8d5068ac029e@fb.com>
 <CAM1=_QQJ+uYXuU_nOVb3djW-G8wJs4Azz36pXk8mO3vQBuVouQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <12ed8726-41c6-b173-b30a-1bd625a12718@fb.com>
Date:   Thu, 29 Jul 2021 08:39:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAM1=_QQJ+uYXuU_nOVb3djW-G8wJs4Azz36pXk8mO3vQBuVouQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0380.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11d1] (2620:10d:c090:400::5:81b5) by SJ0PR03CA0380.namprd03.prod.outlook.com (2603:10b6:a03:3a1::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Thu, 29 Jul 2021 15:39:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c57a723-22cd-4af8-2434-08d952a70ce1
X-MS-TrafficTypeDiagnostic: SA0PR15MB4014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB4014275C99956B32B767B163D3EB9@SA0PR15MB4014.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/y6bd3esGHPCDhv9s7+9nV+lvh++Pt+LNo6gVBUtnaW+TtOzmIx8pkdwOcQIBmOqfaVhQOTkipDQuVzI7zFzOGb8SuACRM0BOSyIwsrQwM7+krGOLnVwmGLUxmBK0FvjIa7b3/fhth4xwZXxvxNPn5BtD16DNfggW/O69Z78MtoNIIYiat49cCaqFgp8qUOMkfURXtUD6irCaZ7hLyj4h/y+Y3Y6yLsO6hWZtFc/5zdnO6TuxyG7Eswoyb6Tjo96QXjr2/A0NLZCiNc5hppz62rJLbWEqSS3Uvn4MbMyEr6tRdoLFs1Lyx9WrLzA48IpQ4StCHbnCabeOCFSt3i0M8pl4eM7Z6XrkdUFyM8s3MYNqomvYV23qCg0hOqkZudem6f3lLeAnYHkmhhbUEhPerLvqEaJ82K8iz7n5NhYC76IWgRAvAuTy3mjEdO1d1n0PqIfyyNO98N/E3h2I5DBXFgLjs9se7pj0DvOnSCUMfIq24/MRd1dotu4gLfVNik4cwLMOQ8MS4xcMGPJuBzbaVQkOwHwcrZFuOa+oozJm7heQX+abQBmBkMVVs5K8zX2Y56Wrtqjs6meIKa2eCcK7D+q77ofzGAYdip57/PbH5fHmwodlOWrg6Iya1Has/aQth4EDJTeiqmMzjap72h9TpqT6DrQyb9qlH+9h84PhO0J0eFmf79r4qRt/5E1oiAM5r/3zVzJ4BVinZQOvgbLJOade38gWvVaSUVLUEFQc0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(54906003)(66556008)(508600001)(6916009)(316002)(5660300002)(186003)(86362001)(2906002)(8936002)(4326008)(6486002)(53546011)(8676002)(52116002)(36756003)(2616005)(31696002)(83380400001)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTJlaEIxYWpHYlFuWHB0aEthL3RMVVNyNi9FK3h4SEtzdEJGVDRTd3NOWDJC?=
 =?utf-8?B?cEJQNHZaZVUrTUpMclVNL0wrUGJWczZCTkdoenJKQVdiOWh4b2NVM0ozUy95?=
 =?utf-8?B?VUNUY3JGNlQ1ZGxocUxzOElHUEFTM2R4Z0NtMnovaW9VOFZqSUlRNVhOSlNJ?=
 =?utf-8?B?b2I0NzcyYkNtanNheHhIc1ROWXdMUzg4QnF6emZJNHlFMUZmOXVlUEpQOU9Q?=
 =?utf-8?B?bDVqMlRzRTJmajVzeXVNWVNyQTYwbUR6bVRJTzRBNHRhUmc3VXR6c3Joa2JQ?=
 =?utf-8?B?YWpjRW0zbFllb29IaE15R25FS3ZaTmNqb3I1NTNNMlk0ZzErR0tPWWRuWGEw?=
 =?utf-8?B?anIyWFVtTk16QitsQU1FNUplaG9heFdLWTRqdnVrQnF3K1JFM0psR3QwUTVx?=
 =?utf-8?B?NkhUMitNOEkwZUJDTFU3M2taSW55RFNLUGpmM1cxMzE2QWV0WjhadDg5Ykwz?=
 =?utf-8?B?VUdwNVB6MUZiRzdwMFlXUURUcU9NMkphaVYzRWd2L210K0hTcFY1eHpjZ1No?=
 =?utf-8?B?V2d6RzhqY21EZmdrc0F1MXRPQXF0aTNKZHNLcXF2Q2E2Y253Y2xxdXBlTm8x?=
 =?utf-8?B?TzNmVzdhK1VwZDA3T2JJZzkwMWxwWmw2K08xSGtwbTVLcjU1R000TDBJenEx?=
 =?utf-8?B?R2o3Z3RhMmZqV2FnUlJIRnoxZzRFSDA1ckZLcThBWFl6aHRiajc2cE1lR1ZD?=
 =?utf-8?B?dVo2ek44NXV0aFZ1RFl5eE9FeUd4dzlRdVJxWWMzRDV6VTZ5c05zSWprQ05Y?=
 =?utf-8?B?UzZteXJYL2JIV0tqeTZsS3dBUTZiSFFpM2I0TTJNQWduWkhTQlpDeEQ5c1pM?=
 =?utf-8?B?eWVzVDE4STdLNnFLT0FlVi96d3RZVUZvejljTDJ6NmlzZi9kWXdjTUNCL1Nt?=
 =?utf-8?B?NnBpSi85M2drYkNYRHVrNWw5OG1KOGlnWnRnVFVKbEZMNWwyQm50ZTRuTEtB?=
 =?utf-8?B?M3l6dFExK1JwMjRqNHlFWVAvSmtPU1p6akZ5OWxwK1dSblF3V1ZNYXg4enMx?=
 =?utf-8?B?blY5eFZsMkF2b01TRmU2TzByZGFJN1UrT2grZVVGemxTdGxUOWdXd2Q1YmdM?=
 =?utf-8?B?NnpLNGR4eWgzczMxZEp0dmhTTit5NjVjU2hwUmdvMnAxeDhFa2VRSGxFcGph?=
 =?utf-8?B?MU1OaTg0MUFNeVBGL0o4RHhCci9oOWhremg2aDEveHB3YTVWTDltTThFSWoy?=
 =?utf-8?B?a2xBalcwNllEbS8rSGVqRnVxd0I3Tk9FUkN4NWI3UGtMVUNaRXhYMGhwZ0hV?=
 =?utf-8?B?Ymkyd0YzY21semZzNlMxWVVKd0tyUlB2a2x1ckhIQW9MVGltVmQ0enA1ZTVj?=
 =?utf-8?B?MFI1WVlkT1FGdXlQUlEvVUYzWkF2dUV2eDl5MWtnQkZMM0swczkrbFhnd1RP?=
 =?utf-8?B?YTVpajhCbTlBNTBMMTRUWGxLV3E5dFhLVHZQYjJsTEdxTmVIWWQvZHFCekdH?=
 =?utf-8?B?ODJWNzBVQWdjR0tpMkl1NVZmY2dVQ2VUSG12dFVibExKMjJOVHI4cmRoWUN1?=
 =?utf-8?B?dnNiTDhLM251ektKaG9PWEFOdHNqbE5VVVgxYzVHZ2tIbWVmdWNxQll1Wjlm?=
 =?utf-8?B?Wmg5TTBXejArbVZHbVFzREduWXFKcXBqNFR4WTc1MGdjU3MrZFlRd3hlS3Fv?=
 =?utf-8?B?YzlhTGZoZU5HZUhscFY5OTZUODhLcURId2NXSG9VQ0Y4ejFiNUY4QUZhU1Rk?=
 =?utf-8?B?K3k5TkdIZUhYendTRW1yR3JHbGpscGNYVXRseDc1WFBtRldjVG1FWDNzNHJ6?=
 =?utf-8?B?UldTVy9nWFh5RHNXSWY5M25UaWpwdEFHdUdvRUoydG5wcmtUWHFRTjlHRXBC?=
 =?utf-8?Q?FGp9O/TvmBZ/lMUiZSCr3vrQm0H35g0O4sj7w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c57a723-22cd-4af8-2434-08d952a70ce1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:39:28.0352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4t/P6sevhDhokhoQM7vmXwvj1WUa/WUOz4E7ElbdN4cIsjuHag3w8Mr0nIAO6PM0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4014
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: u_altx2ZTa0Xu6tzoTgQll2RCyAphzdB
X-Proofpoint-GUID: u_altx2ZTa0Xu6tzoTgQll2RCyAphzdB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=753 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 5:34 AM, Johan Almbladh wrote:
> On Thu, Jul 29, 2021 at 1:30 AM Yonghong Song <yhs@fb.com> wrote:
>>> @@ -4139,6 +4139,106 @@ static struct bpf_test tests[] = {
>>>                { },
>>>                { { 0, 0x80000000 } },
>>>        },
>>> +     {
>>> +             "ALU64_LSH_X: Shift < 32, low word",
>>> +             .u.insns_int = {
>>> +                     BPF_LD_IMM64(R0, 0x0123456789abcdefLL),
>>> +                     BPF_ALU32_IMM(BPF_MOV, R1, 12),
>>> +                     BPF_ALU64_REG(BPF_LSH, R0, R1),
>>> +                     BPF_EXIT_INSN(),
>>> +             },
>>> +             INTERNAL,
>>> +             { },
>>> +             { { 0, 0xbcdef000 } }
>>
>> In bpf_test struct, the result is defined as __u32
>>           struct {
>>                   int data_size;
>>                   __u32 result;
>>           } test[MAX_SUBTESTS];
>>
>> But the above result 0xbcdef000 does not really capture the bpf program
>> return value, which should be 0x3456789abcdef000.
>> Can we change "result" type to __u64 so the result truly captures the
>> program return value?
> 
> This was also my though at first, but I don't think that is possible.
> As I understand it, the eBPF functions have the prototype int
> func(struct *ctx). While the context pointer will have a different
> size on 32-bit and 64-bit architectures, the return value will always
> be 32 bits on most, or all, platforms.

Thanks for explanation. Yes, all BPF_PROG_RUN variables have bpf program
return type u32, so you are right, we cannot really check prog return
value against a 64bit R0.

> 
>> We have several other similar cases for the rest of this patch.
> 
> I have used two ways to check the full 64-bit result in such cases.
> 
> 1) Load the expected result as a 64-bit value in a register. Then jump
> conditionally if the result matches this value or not. The jump
> destinations each set a distinct value in R0, which is finally
> examined as the result.
> 
> 2) Run the test twice. The first one returns the low 32-bits of R0.
> The second adds a 32-bit right shift to return the high 32 bits.
> 
> When I first wrote the tests I tried to use as few complex
> instructions not under test as possible, in order to test each
> instruction in isolation. Since the 32-bit right shift is a much
> simpler operation than conditional jumps, at least in the 32-bit MIPS
> JIT, I chose method (2) for most of the tests. Existing tests seem to
> use method (1), so in some cases I used that instead when adding more
> tests of the same operation. The motivation for the simple one-by-one
> tests is mainly convenience and better diagnostics during JIT
> development. Both methods (1) and (2) are equally valid of course.

it is totally okay to use (2). Your tests are fine in that regard.

> 
> By the way, thanks a lot for the review, Yonghong!

You are welcome!

> 
> Johan
> 
