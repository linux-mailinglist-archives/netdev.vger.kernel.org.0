Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809B03A0C52
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 08:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhFIGYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 02:24:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16162 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232134AbhFIGYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 02:24:03 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1596ELCb005254;
        Tue, 8 Jun 2021 23:21:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mtfLyya8tqE6qnogijZmoQnkqtAMJxu11AJSgGHQ4ZI=;
 b=FLKQFlfYt7iUsnKS6mPGwI8goN+jo/cc90vBZjiMM19vZG2C85YHGurWdFw5tYGmu/K0
 Dk82S+6FG0dxNp2ksO9ilBdXZBk/dhuuN9f0mz0XFQbO6jV5EvR5u5ZmN2sJXy1SKHZM
 OnXV/LJMBBI5Y2RGf6BZFLSMF3+CoAyCtmg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 391rhyt60m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Jun 2021 23:21:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 23:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieyNhLSVOdenEYITl8WurduaT+FukLtuCqA6CDvI3gXPJDjMe1taOwnBBjXBCkU1NuhPa7qM2ZN8DyTDM3n6ElFwrDan8ryPLlFXRB9o7IStuUH4j+8xlL/pzpUHIwUbNdz5T53Q77ESUN1z1mqMyJpaoYUxRnpzc9hEB6alvgWH2RfsIMsWlMRbXOn1YC/xkg/+PiD7pA6USR8wSgYe3hUkMt7qPAx7QncTJrL67MgRgRNnM38ZlzySuqpPBVOOrn+gRJhrrxkOqilT1psYA1AZ92s334a/9r/JYyjPWgfGI+5mLyXgEM9ONXHhfdMIKhtpul+B7zrQ0RGwef8T4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtfLyya8tqE6qnogijZmoQnkqtAMJxu11AJSgGHQ4ZI=;
 b=R8IRvq6zlWk+aJmdiHKdcORyMDvuNva1IX/Vc2hNYhg0eMZ9JlhjImFAAaOarTMpXvog1lrKk4xy/JjuFAGOCkc/Q4I0UdNDXZO4Z5f0Sli4EB97OE2ZPwdVUA+g4HofRD1QaLLs8fbiJSWXl/Ed5kjmz4Zwl9YrKFUBQHZeuJ0F9GulH1PFf7qHc50tVq5hGXpzir1Ei7xy3iSBZYTHUrLem/Zz1xbanApa7Ukm4+VzeBvO9htpCay2LEwh8TUGg3Z4VkwxvZkZd33oEfPUmumcMhsFMcXXRIzvOtYa36YM/mLj+uuDwdlCNZtLsjx3X2RUAwBXpKqwbThH2eD65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Wed, 9 Jun
 2021 06:21:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 06:21:51 +0000
Subject: Re: [PATCH bpf 1/2] bpf: Fix null ptr deref with mixed tail calls and
 subprogs
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c777e392-330b-478c-68a4-6d3ca80e4f53@fb.com>
Date:   Tue, 8 Jun 2021 23:21:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <162318061518.323820.4329181800429686297.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb78]
X-ClientProxiedBy: MWHPR17CA0063.namprd17.prod.outlook.com
 (2603:10b6:300:93::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:bb78) by MWHPR17CA0063.namprd17.prod.outlook.com (2603:10b6:300:93::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 06:21:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9861e470-8ed0-4b68-35e1-08d92b0ede35
X-MS-TrafficTypeDiagnostic: SA1PR15MB4657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4657227D9CCA352F50492D40D3369@SA1PR15MB4657.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSiGR911eqaLyogW4P8ygo18oP38AAX3637t208CUUDi9WnWeI+roNjgLrIKb3zjv1uHUr8JTcknCnFmCYP2RRoHWoC7fsI+ew0YQx8J4I/HnvNLAhE+pUJNkcUQG0JDRLTYa8sp4n19G6O6pFPbLZUHEjSZSOiy/WPsTgXPvB11qIxvM1BhhKqWt7hkWwZYIlyNg5GMNhX4jIEFATgyRKxg9/35wLH6yfip1IpRQVTtSze/NYos3+cmmI+pZ5sWNl1NgB3O4T1OxR3wpGdXDkhXddFiMXHG73ZsgnNPcKJv/krIwO45UnezkjPt7eWZhiYSk8IUdbogVECcSmIKr07VlN+2MKFgbNF+OFrVAgNzVy9AaKPsFXcYmU1wdo2Wcjlr/fzKypuTCZRuEPgjwtwLkzk7VGhtaTXIojfp337+UYsY2LuW/YHDZYCqe8z4yX9EipzYFMWOO7hhZdCGZybGtPapIWvt3zLjmQlVWfaWxN249haUimpaLohAklu7i8a5hPIzSqglCoIpAwR8YTp3xee/LmyRC8BgFU96DDRUwFGQAL1+sAHi7NerZtER/ErEBKJqiVo5anzQhCpT5ygoKvBg91N7o3azYRKDuPX8QbZf3m17/U91kRHNY63Q97DgsqqFkMhlTUrYK2UaXzovvko0WzDIbkDsqLMHKqvFZS/b01oTt6P1F0Oft+RZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(16526019)(186003)(4326008)(2616005)(316002)(31686004)(6666004)(6486002)(2906002)(8676002)(8936002)(53546011)(86362001)(66556008)(66946007)(66476007)(36756003)(5660300002)(31696002)(478600001)(52116002)(38100700002)(6636002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?disvUjZRbnlYdzd6SnFHNGhuTC9odU5ydHMwV0h6dExnZjBZZUQ0a3l2R0VS?=
 =?utf-8?B?R0xIL2s3NmR5UjhoVWh1dkNuejA5bXh5NE9DNllnV1ZDanoyWkcxVE14QXhM?=
 =?utf-8?B?TXA4T3hrT3REaGpsR214bDFCeUdUUHpHY29Hc3NWNHZBc2RkbFUxc3hKWVpk?=
 =?utf-8?B?YW4zRlJ6MDRZQzF3aGFiSFRDN1ZiVU4yZjZkOUlha2F1RlowVEZUUmdQakYy?=
 =?utf-8?B?emYxTjFRRHRSL1p1ajZ1bHdyS2I1VzEzZ3Z2VkpJT1UxWDRjdm9CWm9yMEdK?=
 =?utf-8?B?aFZtcTdnSkxzRzduTVlPZGNRZ2VZOTlkTEJuemU0ZllhNDNQY3g1SVZQZjBr?=
 =?utf-8?B?cEpDTGJ4VWZ5elMvYWlKZFNyRXJUVERKaW1IUkVpSTBod2VFbXNMUFZqenpN?=
 =?utf-8?B?OENkbkQxaEs0WVlQdTFkakQ5bi8wWUJSeUZmSndZOWFkcjFrMGJRb2t4cndt?=
 =?utf-8?B?SXNnSkdMZ1A1WENWREZGb2NOVm5QbzFLSi9BZzF2M2RIN3RldFcvcVZKWE9o?=
 =?utf-8?B?allIWjd2bFRuVFkrVjZCSFRhM0xqMnRJYU9mWkthZWpoT1VuVWtqZjlLRk9x?=
 =?utf-8?B?bXVZN3VoZFprNWVnd29ZdWJXcWdhakxEZzJmTWVTVi9OWlVXRnRMUDFqTWdz?=
 =?utf-8?B?OHFPdDhZL2gxNmNOSm00aVh4WE45YTNKekJDVG1wWk1oanQ0emFhUVgwdktx?=
 =?utf-8?B?NU42bFgzZXRlQmJWbGdHNjJLTEY0c3pDQXg5UFVnVkpsZ21SdVQwTXpFcDZy?=
 =?utf-8?B?NytXTXVmd1Z4VjVLYW1lR0xlckkraDNqK2FwajlsWUJLZ2lIZGFWa2xNMndy?=
 =?utf-8?B?ZWQvZUhNMHY0Z25OZWpTeCtMSzRIbGNKVUZjSnkrb3J5QXYva1VYNEQxdjcv?=
 =?utf-8?B?cHJRanRTOWNQNHZ3aEQwM0lpOXRyeDhKV0xhTGUyQWIxQWdiZEFSb0tuMnlo?=
 =?utf-8?B?VlE1WlZxQ01ka052Z3c1Mmc0L0RuU3J3RGlybS84b2dQU29hTVRnU3diWFFD?=
 =?utf-8?B?TkViWkVDTmVJN3IyMDVpWVo4b09odVo1Y0FYVGhidzVOQVNsdmxraFlXRVNV?=
 =?utf-8?B?RlI0L3k2SjhWa3NCU3V1NS9kaWhGNDZsYXN5dkk4K3RHOUtHdXhYaFZhSGMr?=
 =?utf-8?B?endRaHRmSGV0R2ZFazE4UDBFdW5Da3hsNmgxM0lvbnJJNmlUc2lFeTg1bVk5?=
 =?utf-8?B?V3VlQVJIYm5pMCtkOHNndEFqSTY5ZEJ4SFFncms4dEtFSytBNTQxNDNTVkg0?=
 =?utf-8?B?RVRCcUZLTzY2aDdTY21MV291ZzR0bnA2TVJSWHJhQWNaNXZRL3hxbTE4U0lP?=
 =?utf-8?B?OFIvcFp3RHlNVHNkZU1jWmZ3bHJtRmV2c1dZMWsxYWdVY3NJWEpQdEJZYzJD?=
 =?utf-8?B?MEp3OEg5blkrWXE4VTQyVFFCSkFYMGswbmZjQm8ySEd0QW1SVTVFS1N2RjBu?=
 =?utf-8?B?UVhSMFZYanRlWEdCdFkveG5EMWRkMUNJVzc4MkV6RXFWWUpnZkoybW9vcmZK?=
 =?utf-8?B?Q3ZLclZlS2RBdWNSMHJYTmcvOEVjd3ZzbXEvcjZoUGo4UHdYellPWmQvOHhh?=
 =?utf-8?B?YlA2YThvWXhQcWpqVGVORVBya2l2c21zZG1zTTU1OEk4bEtyNVBVbU5qNVhX?=
 =?utf-8?B?RG9tVXVYc0pYdDlwTytGU3ZmSHJhM2N5eVNPd3FBTTR5VjV1L0JpWlF2K2VO?=
 =?utf-8?B?UTdudUMwNmRuTFBQTWJUaFZkaHR6L3NWRWM3SHA4V2tua09yZ0IyYmY0Skdn?=
 =?utf-8?B?Y2dybENDbFE1VkhLQjB0VGs2c0ZCUFRvcnBZeWVyNXNYSWR4dmlMVjNSeG9Q?=
 =?utf-8?B?Qk9JT0FvUW5BdExhNmxiZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9861e470-8ed0-4b68-35e1-08d92b0ede35
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 06:21:51.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3nDCCy2Q+4IuLXAZp+k+uFz1hAd3YUCMHQCPk4P2JL4Dx2RAt2eO6L+L5rW63Z4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: SnT2ibR4vRjbu8r9y4VfKhajAwfogUKL
X-Proofpoint-ORIG-GUID: SnT2ibR4vRjbu8r9y4VfKhajAwfogUKL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106090021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/21 12:30 PM, John Fastabend wrote:
> The sub-programs prog->aux->poke_tab[] is populated in jit_subprogs() and
> then used when emitting 'BPF_JMP|BPF_TAIL_CALL' insn->code from the
> individual JITs. The poke_tab[] to use is stored in the insn->imm by
> the code adding it to that array slot. The JIT then uses imm to find the
> right entry for an individual instruction. In the x86 bpf_jit_comp.c
> this is done by calling emit_bpf_tail_call_direct with the poke_tab[]
> of the imm value.
> 
> However, we observed the below null-ptr-deref when mixing tail call
> programs with subprog programs. For this to happen we just need to
> mix bpf-2-bpf calls and tailcalls with some extra calls or instructions
> that would be patched later by one of the fixup routines. So whats
> happening?
> 
> Before the fixup_call_args() -- where the jit op is done -- various
> code patching is done by do_misc_fixups(). This may increase the
> insn count, for example when we patch map_lookup_up using map_gen_lookup
> hook. This does two things. First, it means the instruction index,
> insn_idx field, of a tail call instruction will move by a 'delta'.
> 
> In verifier code,
> 
>   struct bpf_jit_poke_descriptor desc = {
>    .reason = BPF_POKE_REASON_TAIL_CALL,
>    .tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
>    .tail_call.key = bpf_map_key_immediate(aux),
>    .insn_idx = i + delta,
>   };
> 
> Then subprog start values subprog_info[i].start will be updated
> with the delta and any poke descriptor index will also be updated
> with the delta in adjust_poke_desc(). If we look at the adjust
> subprog starts though we see its only adjusted when the delta
> occurs before the new instructions,
> 
>          /* NOTE: fake 'exit' subprog should be updated as well. */
>          for (i = 0; i <= env->subprog_cnt; i++) {
>                  if (env->subprog_info[i].start <= off)
>                          continue;
> 
> Earlier subprograms are not changed because their start values
> are not moved. But, adjust_poke_desc() does the offset + delta
> indiscriminately. The result is poke descriptors are potentially
> corrupted.
> 
> Then in jit_subprogs() we only populate the poke_tab[]
> when the above insn_idx is less than the next subprogram start. From
> above we corrupted our insn_idx so we might incorrectly assume a
> poke descriptor is not used in a subprogram omitting it from the
> subprogram. And finally when the jit runs it does the deref of poke_tab
> when emitting the instruction and crashes with below. Because earlier
> step omitted the poke descriptor.
> 
> The fix is straight forward with above context. Simply move same logic
> from adjust_subprog_starts() into adjust_poke_descs() and only adjust
> insn_idx when needed.
> 
> [   88.487438] BUG: KASAN: null-ptr-deref in do_jit+0x184a/0x3290
> [   88.487455] Write of size 8 at addr 0000000000000008 by task test_progs/5295
> [   88.487490] Call Trace:
> [   88.487498]  dump_stack+0x93/0xc2
> [   88.487515]  kasan_report.cold+0x5f/0xd8
> [   88.487530]  ? do_jit+0x184a/0x3290
> [   88.487542]  do_jit+0x184a/0x3290
>   ...
> [   88.487709]  bpf_int_jit_compile+0x248/0x810
>   ...
> [   88.487765]  bpf_check+0x3718/0x5140
>   ...
> [   88.487920]  bpf_prog_load+0xa22/0xf10
> 
> CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Fixes: a748c6975dea3 ("bpf: propagate poke descriptors to subprograms")
> Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
