Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD1D368944
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhDVXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:14:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9956 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230353AbhDVXOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:14:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MN65Bv026067;
        Thu, 22 Apr 2021 16:13:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1z4GPT0ioELn1BXw/Xi9v/4rNxnbr+RLVen6Nprs4p0=;
 b=UN95u5vwXL1aA+qXrh2GZuDsOAEOXcIBIEe1sMhzjktsayix0WEXY8XMzmAVNSiHmVJb
 92iThabWNkLbGbDA5Ls8v3uXnlAwgYs+zJ+6ucafvJkjfLu/97TO7U8GKvkyyZRL8t+7
 YH155bm80PNs6NArlJ8stTDtJQasUl7Puh8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3831khwsa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 16:13:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 16:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igVehg1Zc75+glW/nippO8ditWkn1d2PF/hcdSZyb2WxBD2F/6/K4B/4INnVdjGJl34XbaO5Z0IvlZSCVAEiKcyFX7MWfzv68yfFZGG/lOJQ0Z2lkGdK0xXoR/MdkSv6BOKO5L9PuYOkOr8u117o+MBDCH/5l6xhePRujAY/p9bagRY1EMfwuzyqCP9zp6tqVU5yiLkvBQk4zujYOxxxdVrS1162oiJ1okW40JhlNnJ60FziR5E7KVtHvwtu6Smu89uFcSquFs0GV6lV+nqz6YvQ6Q4k8v5PIsc/JLLxYEs5o6WwKST0xbKkx7IDvle2Q0GEtW+VgmnpKWNQeoRQ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1z4GPT0ioELn1BXw/Xi9v/4rNxnbr+RLVen6Nprs4p0=;
 b=HFfNQHj8B215iZ2k8ACquEfOkth25SYqNi7FvKDMpf6ZybmmKnq2DDTItBJ/DFnYP+JtLe7uNRlzNNDQqux6H93k8nF5J9No4oLBVTsshURFhF4rAnzm4rjSSpawXsp1zSfRlXcHaLjOFBcLxmsq3eZQHecGOWfGwsbJ+3EuogghiyTTUsFeK+WkR5ZlJFaSiNdNd4bTALiv1JM37lpHVD3muaEjsDElO8Ng0NkChhY2KFNMmUzm8KeGWZ987TG13vT8B9ewQS4L2ofH3F3LyhzeRQEFNtk3CQflxXkVwwq0NDvsZA14MwaWSFT13iy928esAzQaG/cc2HAMUkjxXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2413.namprd15.prod.outlook.com (2603:10b6:805:1b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.23; Thu, 22 Apr
 2021 23:13:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 23:13:30 +0000
Subject: Re: [PATCH v2 bpf-next 09/17] libbpf: extend sanity checking ELF
 symbols with externs validation
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-10-andrii@kernel.org>
 <7ad73fdc-e81a-9b4b-1dce-e8c304e88e0a@fb.com>
 <CAEf4BzZjry6=1tu=1Msx9JNGSwS8LOyCbZFioO-1CxWc-AzW6g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f2e46f09-775f-5ad0-f62b-c12e67902670@fb.com>
Date:   Thu, 22 Apr 2021 16:13:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzZjry6=1tu=1Msx9JNGSwS8LOyCbZFioO-1CxWc-AzW6g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:300:ef::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR22CA0011.namprd22.prod.outlook.com (2603:10b6:300:ef::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 23:13:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a9289f0-62cd-4402-c035-08d905e43e18
X-MS-TrafficTypeDiagnostic: SN6PR15MB2413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2413D47E4E97FF1BCBE56DFCD3469@SN6PR15MB2413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhqjyPC9AuimiRIPujO+3nzBhl4GP9+mXBlX2m5hUbwBV9DGaFz+bNoGi4xuPJiypAkgfSF7txikxD/ved6WHdaRZ6S0+b0IEew8PSo3NggrtFkmqo2PJgNYTw6nijIqavx1qE3Vr3pV+y+ke4imNflrlSeq4unEwObGiwcdoJ2spn7nwujzRXTXeDxgJKn5DIJjcIsootDmtdhfqQPQ6C4DJWuQ8JlHWgi3Cz5zzMWKMNF9vhq7WjjOEtCIodMKihE1d/KbVHiH4Hzf1PKAIW3uOr8R5qPkWfq65BMFb8nU4w0tpXWzF5edlOcAetiQJA4zk5AL26sXxNx0FR8dFiqTvI/A03e3MtCKF50AWp+bjYMB4PtfS/9PocgGNcz2gIBu6JgeafH3TiQAAgZDldXyDhbsEf8dLKJKrzU54WtGUptTYPwilIet8/RA6GVSX6COQ7Fg0XcQx0Nxhvs72ZfY9y+VQXrXOsOZ7MryrsC3jibmtFDVA4OsJ5tjUkhp4h9IyJ7olC2WxU0C0/hAhF2dgqo4jW4H62lQt735SJMAKNXKqXQ54xSgjbRj04zRuXO3jz+iNV6p59i+x7n0fGkNJDGeB7D+RJ1GxiNVfXWll8mWj5D9XZ0FTHV+aYWFitOKPCijw5X+8TIx5y21tLtIKHmKmd6LjOiK2QxN5K6g4Esgl1PvitPbbeaEg+Va
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(376002)(136003)(396003)(53546011)(66946007)(4326008)(52116002)(6666004)(2906002)(2616005)(66476007)(478600001)(6486002)(66556008)(8676002)(54906003)(316002)(6916009)(8936002)(36756003)(186003)(31696002)(86362001)(83380400001)(16526019)(38100700002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ODRTWTZ0UUorOEJsUVVZZERPZlNhb3VLQ1o1S0RJY0FvaERWYXBtc0VrQU5n?=
 =?utf-8?B?R3FJbXNWblFNMGwxODZTRW5kWGlMbDcrenNMcjBaUFpSa0JXL2VJaVpPejRJ?=
 =?utf-8?B?UlYxeDhFbzRiaXc1dGNXYlpaMVNUSlNVS040ek9oT0I5UWpveFE1QnU1MTNM?=
 =?utf-8?B?bHdOVElWODlrb0VHZHY2MExrOXcvZXdqM1FpTmpnbmNQS2FwVVhDMzZpV1Rz?=
 =?utf-8?B?UDZNUmlBQ0p2T05ZTXVCV0lub2xobnAvM0d1L3RjZU9OWHNlT0ZuZnpLVjJD?=
 =?utf-8?B?K3VvRUUvZnRyL3dRRC83RzJydEYzUHRHeVNmN3ZqdzZpczVKeGpmekdUbWNa?=
 =?utf-8?B?c0pXNGd4RjR0azVaRG8yS2taRUZteDVmaXRKT2NVRnIvQmt1M1VBODcxWnRu?=
 =?utf-8?B?MXRJdkxkRzNDN0lPYlA2RUk2ekNmSGhWMTF2NlJSWGpqdGhHdXI1NVJYbG9P?=
 =?utf-8?B?ODdqUHFseE9RaU55amdFRUhNS1FXVmlIQXRXVkNTRnNiNU5id0F5Vk9Sc0R1?=
 =?utf-8?B?VlNaZUdBc01sclNrQ01kOFdMOGlBSjE0RGlYQUt0ZER3ZmVJU1dGZVQ4YVRZ?=
 =?utf-8?B?SFU2RUpxYm5DZm4xMzJDTVJncFk1T3E2cnZ3VmRQTzBoc3Z6VFVRZ0RFb1lV?=
 =?utf-8?B?cll2bEpTaVV3M1B6VnFFdmVCbkhneEdWOUZETGNrS2JGcHlZb3hsWk45N09D?=
 =?utf-8?B?NFpKRUlic2F0WS9qVXFYMWJhb3RrSVZHeENMenNMSmR3YU1MbXZwUmlqZ0RK?=
 =?utf-8?B?ak5OUWpYa3BnWjdsVTNuWGtzM0V0dHhZOEhmdGVkdnpJTWp6SHgxYVZWNjZL?=
 =?utf-8?B?UXprRTVIOExsQTJGY1VwYmFjTG0weVFNUEM5NXoyTlJ6aGhSN24xbDlsbnZR?=
 =?utf-8?B?b0hJeDNjSUFRdWhTZ3J5R1ZXSVRrNVR2N0VCOHJrR2cwOE05cVo1N1VxNm9I?=
 =?utf-8?B?djVwa09uZ0VJR0xhaks5U21oTjhjd3Nuam81RDR5MGNTYm5BaHpQOVUzRU1K?=
 =?utf-8?B?K0d6ZEZJTFprdzNzMXpiMmZWQUhJVllLMDFSOGVGL1lyVW50M2x2cDMzSCtm?=
 =?utf-8?B?ZmMvN1pqanFqdEpOTU9YSXpqbkJsQ0treFJpaGRNUUI5VFltbDl0RW0wTnIx?=
 =?utf-8?B?TzdQb0U4VGVjT3hqVEFDWXpTK01TUmQ0bjR6VE9uTjVIYlUvNmN2UGxIZkpt?=
 =?utf-8?B?ZDhoWWxlYTBaNlFMVStZREdUUzRCRnc2VDFPWjl3eU45S0RqbVp5Sm5SNHhh?=
 =?utf-8?B?cXh5LzZ5WG1OOXVLdCtzcnBLRHRlenJMVHVLVGdqVE0zYVZyOU8wbklhanZI?=
 =?utf-8?B?bEdwUkJzZjNqMVVISDhKTXArSXFVNFhDYTh1RW1XYzdQS1ZIcWxJUVNsY0h5?=
 =?utf-8?B?U1RGdUJob0dxVzg0RFh4aDBzZ1BNNEt5dDU1WmN0YXNlc3Z6K1ZoTzBrVXdn?=
 =?utf-8?B?WHRUU1FWcE5yRlROeFVmS3RqRGdqUUcvbHNJWDA4bEc2ZkRPRGhhVjc4Y3lp?=
 =?utf-8?B?WTVqeUVFQ1c1UFNHOFBwTmJwaEQrRm1rMVc0bVBDR0hXQmtkSXczR3g0elRq?=
 =?utf-8?B?aHBxUDZQMk4yRlRHVUZWY2NOcEZDb0xKc20vTGJ1T0x4RFFubEN6djlJdjJv?=
 =?utf-8?B?eFRhK3BrTDkyUHB1enV6dHNVY3dQWDlpMCtsVFArTC8xQzRzcmJLYnhQbkor?=
 =?utf-8?B?N0xIcXZwUFNiWXQ2YXpCT3NDRlEwMzZnQldNNWxXdkxRNGhGeEI5YWJBTUp6?=
 =?utf-8?B?Vm92RG5PaWtvMGRJRUp5U1cyaDY0dzd2cm5mS0RuQmEvNEkrck4wYisxbXZt?=
 =?utf-8?Q?e8ZESWOHSHJCkrFKPJozSUxlPoYqxij4OtayA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9289f0-62cd-4402-c035-08d905e43e18
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 23:13:30.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pv6VXrzLe6mNquIRAZRjWjaAayQ7BmhO3PZuYoxmgF491lhb530Mxfne4biQJ2iQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2413
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: cTF2KtIQ6_wGqymA4_GKdWuEcen9xbB1
X-Proofpoint-GUID: cTF2KtIQ6_wGqymA4_GKdWuEcen9xbB1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220169
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 11:20 AM, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 9:35 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
>>> Add logic to validate extern symbols, plus some other minor extra checks, like
>>> ELF symbol #0 validation, general symbol visibility and binding validations.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/lib/bpf/linker.c | 43 +++++++++++++++++++++++++++++++++---------
>>>    1 file changed, 34 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
>>> index 1263641e8b97..283249df9831 100644
>>> --- a/tools/lib/bpf/linker.c
>>> +++ b/tools/lib/bpf/linker.c
>>> @@ -750,14 +750,39 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
>>>        n = sec->shdr->sh_size / sec->shdr->sh_entsize;
>>>        sym = sec->data->d_buf;
>>>        for (i = 0; i < n; i++, sym++) {
>>> -             if (sym->st_shndx
>>> -                 && sym->st_shndx < SHN_LORESERVE
>>> -                 && sym->st_shndx >= obj->sec_cnt) {
>>> +             int sym_type = ELF64_ST_TYPE(sym->st_info);
>>> +             int sym_bind = ELF64_ST_BIND(sym->st_info);
>>> +
>>> +             if (i == 0) {
>>> +                     if (sym->st_name != 0 || sym->st_info != 0
>>> +                         || sym->st_other != 0 || sym->st_shndx != 0
>>> +                         || sym->st_value != 0 || sym->st_size != 0) {
>>> +                             pr_warn("ELF sym #0 is invalid in %s\n", obj->filename);
>>> +                             return -EINVAL;
>>> +                     }
>>> +                     continue;
>>> +             }
>>
>> In ELF file, the first entry of symbol table and section table (index 0)
>> is invalid/undefined.
>>
>> Symbol table '.symtab' contains 9 entries:
>>      Num:    Value          Size Type    Bind   Vis       Ndx Name
>>        0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   UND
>>
>> Section Headers:
>>
>>     [Nr] Name              Type            Address          Off    Size
>>    ES Flg Lk Inf Al
>>     [ 0]                   NULL            0000000000000000 000000 000000
>> 00      0   0  0
>>
>> Instead of validating them, I think we can skip traversal of the index =
>> 0 entry for symbol table and section header table. What do you think?
> 
> In valid ELF yes. But then entire sanity check logic is not needed if
> we just assume correct ELF. But I don't want to make that potentially
> dangerous assumption :) Here I'm validating that ELF is sane with
> minimal efforts. I do skip symbol #0 later because I validated that
> it's all-zero one, as expected by ELF standard.

I just feel we can ignore entry 0 regardless of its contents. But I 
guess this is still useful since libbpf linker generates its own
ELF file and it is worthwhile to do an in-depth check for that.
So I am okay with this.

> 
>>
>>> +             if (sym_bind != STB_LOCAL && sym_bind != STB_GLOBAL && sym_bind != STB_WEAK) {
>>> +                     pr_warn("ELF sym #%d is section #%zu has unsupported symbol binding %d\n",
>>> +                             i, sec->sec_idx, sym_bind);
>>> +                     return -EINVAL;
>>> +             }
>>> +             if (sym->st_shndx == 0) {
>>> +                     if (sym_type != STT_NOTYPE || sym_bind == STB_LOCAL
>>> +                         || sym->st_value != 0 || sym->st_size != 0) {
>>> +                             pr_warn("ELF sym #%d is invalid extern symbol in %s\n",
>>> +                                     i, obj->filename);
>>> +
>>> +                             return -EINVAL;
>>> +                     }
>>> +                     continue;
>>> +             }
[...]
