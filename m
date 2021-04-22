Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4321136898F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhDVX7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:59:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236851AbhDVX64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:58:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13MNr3Ic016270;
        Thu, 22 Apr 2021 16:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BSq32aelL8zDxqx+m9gmpcnxm+6LvGUtJHBhGO1wvkE=;
 b=mBhzLXwXRMvbAr9bcE7bx9cDosGMFzimtov0WpUK/yP+yI1uzOrOX+F9n2vf8rWcsNLK
 IJZDCbC2thPMm2QysGfFAgHiSRzY+QblsoIZPoAwDonVUyM6Fb3lMecBVNFz2xSUUdSM
 Od1EysNoGPBSwNUjBmcfKZCClDLvu1FeK94= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3839vukkpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 16:58:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 16:58:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlj6ETnC5h65mhy0EoBKDgLaYmhdkno9lErz22iaQ1k/GXGvsztAZiDOcvxVxT9xOJvVV0wyq/aHCZFIdkoR/AOfVIMWConyT54WLOHzKzlm5n41GDQyJlSSiHi4rfbKR59npJKDKbTH+dc3MZJwh0Jqn71vr0s9peWHd8+Rte4Z4QsA990r0dGYABPlp555rVN4uIy/RbtfPJoc6AgRj4diKr50wGvPzs3DL4imtkmIeRB+GeQi+zE600sOhoe6ByFo+vCcqWZru0s2DEbZDZTT4XsNn2VOrjfsckB/CxuEMH1PTdEt//rUUhhilX8Ztuu7nNYNJSNlG8thw/576g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSq32aelL8zDxqx+m9gmpcnxm+6LvGUtJHBhGO1wvkE=;
 b=IUqaUWR3abvwEPoSE/RxYmRMrkzgNtl7Cx5vLZeEQDNw0de17u8mGyzNtRhclDQCsxr4B4J55mYcLaORbn5GCNCcdIsQdtbQlkEPWXD+mTUOI+IZU9QyWiTcob1ZHXbTAZC2I+0PFPuywWNG3ozXwGDT6B+dx2somX6WYSDvbD5FCFpDzQ0kXHoz9NU8ipJzix89zI8C2eOufxKSbS1FZTqEQdR3zodLA8/9rPM+3ys2q0zhAhHxgTO7AiQE/f9/SuzMElYIXXZNMB6YKXYfeUC1O6Q3R5r/E5+Z1gGwwGi+prQZIE3E/cdAHYsYf3M6UElZ0N0ubSc7KUesLThy/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2414.namprd15.prod.outlook.com (2603:10b6:805:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 23:58:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 23:58:03 +0000
Subject: Re: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution
 support for functions and global variables
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-12-andrii@kernel.org>
 <d6297a28-855f-4c46-7754-b0c0b1f11d6b@fb.com>
 <CAEf4BzYzML_5O-+6=bW6U=jCc9aG86GBJH6fwrsU5gSacbjL7w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <cffdf4e2-220d-cc2e-67e9-b83e848bdddf@fb.com>
Date:   Thu, 22 Apr 2021 16:57:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzYzML_5O-+6=bW6U=jCc9aG86GBJH6fwrsU5gSacbjL7w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR1601CA0015.namprd16.prod.outlook.com
 (2603:10b6:300:da::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR1601CA0015.namprd16.prod.outlook.com (2603:10b6:300:da::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 23:58:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cef7e95e-d304-4946-60c3-08d905ea7728
X-MS-TrafficTypeDiagnostic: SN6PR15MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB241454BED09606C07FEF25E3D3469@SN6PR15MB2414.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8VMZky90H8hAtmHL3Z6i1B1GKg7A+way3Nk8rF2vn1paRr+SuE1nsjfquHu81gt4vuAQQKNuM0fFk80SQuWlMa8ugY/W4BdSoVEs5zn9uF/dAVSFux8h2rbngdM6mA8jrhMlUKwfVuE1PS0/BPG/SAF7dUihK28tQ/ilE2jk+zhF1qZYqaRkPS9IVcvn+Fed0knkC4wMKA6jInmKuZdlFUclSvSswv2F5da4Ir/VxjsatRL5ZLlca1yYVNIXqHiYRZzvTfwvfPF4jporxxOn4VRXMxlQKT51HSCgUMeUezmIjkX1Vwq63V6+l+lSK7aFnsYRijoAcNgiYypBf7t+wMQrf6dhBZ/jQrOD1+hu6KNcY11gNSDAXatSKY+xvrfpe6r1o7l2rscuI9r1zpWWt5FcoXKaNazvTrWBUPX5d8njoKHMpy2hH305/GCB6z6ohSnl1peSrfe3BR6G/BLdVRK2ApDqTLtmSZK6zJMEsfXMmuSc0y7y0Ty9lAvgghDrEqpwja3/IJa0KMkiNZHeu1Z4GHmaFw58MXc08J6UT1Ge4rMaLRTZsZNPFQzuQAl8VvgtUgf/yrEpmetc6C3lYQT+mPteZWKGmC3CCQADqeqimklxHSniuuOb7fW9VHqV2L9pl/WE9cSINlodGkeEo35oH1lTIHByPb0d/78hGJVYSDPQ/Rwwgy9ywbTvoeb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(346002)(136003)(83380400001)(316002)(54906003)(66946007)(478600001)(66556008)(66476007)(6916009)(30864003)(53546011)(36756003)(52116002)(31686004)(4326008)(8676002)(6486002)(8936002)(31696002)(186003)(5660300002)(16526019)(2616005)(6666004)(2906002)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L1drSUFTSWpVTnNQeG5ibGF3K25nN1F2SkU4VVh3eHUwbkR4Q21JUGFLN1VU?=
 =?utf-8?B?SmQ5dkRxQlRSR2FMci9FVERVa29PZitBaXlLKzVRSDhwdXhJMThhQThQcEZD?=
 =?utf-8?B?ZENDTnZDbEtsemRvaW0xSTlUU1pOMFBoSWkwQ3hEUWU4Slh1NnFoa3BSRFpG?=
 =?utf-8?B?bEhaL2JRSjlaT2FvQ080UGxRbGhmNXgwWExrcEppRzNoTlNEMGY1ZlpSVzFu?=
 =?utf-8?B?eUt1VCt0Q3kycTQzdXRvYWFBaC9CYnlySnlQTnVxSVhObVFFdERBZWVhVnFS?=
 =?utf-8?B?Ky9HdWVqYmI5TUw1aGY2aUxzRzhwVFRuRExnVGJpUUs4VjE1WWtqcmJBMG4x?=
 =?utf-8?B?cU9tQlVydFN4dDRCMDBnbDB4SnNqQkZyWC83bXdiWnhRUHlUSHVQUFFiazBW?=
 =?utf-8?B?cjN3QUNDalFLa2thMTczSEFSNzA1WmMxRXlXRkxQajluWVV6UXM0ZnVIdWdp?=
 =?utf-8?B?MHlhQWJaSEZwTVFMR3pSbzliOHMwVzdmY3h2b3BKOW92S25uY054c0dRN250?=
 =?utf-8?B?UHFKeEhyMHI4M0RDWHNiVDdkSXNIYm1DYy9GU3pOQVAySHlDM1ozWjVGWHYw?=
 =?utf-8?B?cGFCT05Ba1FLS1Q0NWRrZjgzakI0TG5ZOUtPZklaVFJ0WHc5WUtRV1VlOXJH?=
 =?utf-8?B?MVZHSHNYMmdZdGJnRVVTc3dYUWZ2ZDRlSmVaVmw3alZ3dTZPaWRISFl0RHVF?=
 =?utf-8?B?VlFPazladGt3REg5dzlvcHl2S2I4S3JEV242OUhEWWYwSmNvczJpbUdHTnpE?=
 =?utf-8?B?RVBDd3g3S2ZHZjJtUkVtK0lleXhuREwySUFBRmsyZ24zK2MvSXdXdS9ETThR?=
 =?utf-8?B?TlllTzBuR05JYk93Ym5lTmZmWUEwWjdJblRzZ01WdDBxYitlRWZnZVFidmYw?=
 =?utf-8?B?eWtjbkJ6MGhpQ1IvV3dZV1ozUHRDS0R4SDJmc0FyN1hoTjdTOTlKaHlTK1lN?=
 =?utf-8?B?Rzk4dVFueUYyemt4ZGt0c281bjRFNm9KRVI1UDZVblUyVWJNY214NjFpMGRB?=
 =?utf-8?B?NEs4ZHhTYnBCRFhSWlFuckxLaXpNSVJZZGxqMkVZaC9HcWhKZytCZHVobEI2?=
 =?utf-8?B?WndmdDlVd3dERDBWdGFuSkd4U1lsV0NkVy90bXJmaHhCK1J1WW5VNytiUVhF?=
 =?utf-8?B?K2NiT2JKUEt0Vi9kMnYwSGUvczd2bUhhY3NNdjEyNnN2SjdaSE1xMEtQQXhS?=
 =?utf-8?B?b1RYS2cyKzJZOEtJU0ZPbDczcTZIeU5Pb0p5UnYyTktBaitROTlLMDcxamJE?=
 =?utf-8?B?RFdDb2dIYTEzR0txL3hIc3Q0TThuYkN6WGp5VjhVMTNwRS9rOXZqL3VUc1ZY?=
 =?utf-8?B?cFdydGlkSXNUaG5ZY3FoZWMyQ3NBL3Jza2FDQ3p3N21yQXUweTNvbUNjZlVr?=
 =?utf-8?B?bUdzWVZ0ZmcwVWQrdzA0WnBiL0prK3dFNDhCK1l5eE1LbXV1QUNnM2xKdGRu?=
 =?utf-8?B?NnZyTHZlNm91clJHOWlaMHQ4NkFqU3crL0VTalV3UHpJT0Y2MUthTXFCMlNp?=
 =?utf-8?B?cGROYzhsMCtpakhnVVRzUmVldllpN1YxZ2hjaFRubDg4SFUvakdCWTFLWVE5?=
 =?utf-8?B?MFpDUzk1R0s4Uk1WWXNOVm8vemN5NjBIM29CQ0xXdzlHVmNERmJiaWhRemNP?=
 =?utf-8?B?bzFDU3FKMEZadHhLZWhiLzFUWTdXTzgrbVN2RlJLM09aWGtTUDlrMXhCemMy?=
 =?utf-8?B?ZmFzbWN6ODdPNnJLZkNqbnJmSDhQVmJHcEdBSmJ3REFxTForOUZOTUhybk1i?=
 =?utf-8?B?TmozcVpqWUlkM2g4RDBwMUVwSXpPZ0UyM0krQ1dwd0JZSzBkMHU3YVNxa2ZJ?=
 =?utf-8?Q?Ih44l7sVaFj8juZZ+zQ7e/IremWwvW22w+QdU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cef7e95e-d304-4946-60c3-08d905ea7728
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 23:58:03.1175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q86ArOMMVAOwKi4iZAC/iPfwH1LCfGtvTXNO8JgBIMrRftkc6KgPIfIxbXkyKHOV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2414
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 74lwrrDCE2mxcIoSucgIifeoMYAS9KeE
X-Proofpoint-GUID: 74lwrrDCE2mxcIoSucgIifeoMYAS9KeE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220176
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 3:12 PM, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 2:27 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
>>> Add BPF static linker logic to resolve extern variables and functions across
>>> multiple linked together BPF object files.
>>>
>>> For that, linker maintains a separate list of struct glob_sym structures,
>>> which keeps track of few pieces of metadata (is it extern or resolved global,
>>> is it a weak symbol, which ELF section it belongs to, etc) and ties together
>>> BTF type info and ELF symbol information and keeps them in sync.
>>>
>>> With adding support for extern variables/funcs, it's now possible for some
>>> sections to contain both extern and non-extern definitions. This means that
>>> some sections may start out as ephemeral (if only externs are present and thus
>>> there is not corresponding ELF section), but will be "upgraded" to actual ELF
>>> section as symbols are resolved or new non-extern definitions are appended.
>>>
>>> Additional care is taken to not duplicate extern entries in sections like
>>> .kconfig and .ksyms.
>>>
>>> Given libbpf requires BTF type to always be present for .kconfig/.ksym
>>> externs, linker extends this requirement to all the externs, even those that
>>> are supposed to be resolved during static linking and which won't be visible
>>> to libbpf. With BTF information always present, static linker will check not
>>> just ELF symbol matches, but entire BTF type signature match as well. That
>>> logic is stricter that BPF CO-RE checks. It probably should be re-used by
>>> .ksym resolution logic in libbpf as well, but that's left for follow up
>>> patches.
>>>
>>> To make it unnecessary to rewrite ELF symbols and minimize BTF type
>>> rewriting/removal, ELF symbols that correspond to externs initially will be
>>> updated in place once they are resolved. Similarly for BTF type info, VAR/FUNC
>>> and var_secinfo's (sec_vars in struct bpf_linker) are staying stable, but
>>> types they point to might get replaced when extern is resolved. This might
>>> leave some left-over types (even though we try to minimize this for common
>>> cases of having extern funcs with not argument names vs concrete function with
>>> names properly specified). That can be addresses later with a generic BTF
>>> garbage collection. That's left for a follow up as well.
>>>
>>> Given BTF type appending phase is separate from ELF symbol
>>> appending/resolution, special struct glob_sym->underlying_btf_id variable is
>>> used to communicate resolution and rewrite decisions. 0 means
>>> underlying_btf_id needs to be appended (it's not yet in final linker->btf), <0
>>> values are used for temporary storage of source BTF type ID (not yet
>>> rewritten), so -glob_sym->underlying_btf_id is BTF type id in obj-btf. But by
>>> the end of linker_append_btf() phase, that underlying_btf_id will be remapped
>>> and will always be > 0. This is the uglies part of the whole process, but
>>> keeps the other parts much simpler due to stability of sec_var and VAR/FUNC
>>> types, as well as ELF symbol, so please keep that in mind while reviewing.
>>
>> This is indeed complicated. I has some comments below. Please check
>> whether my understanding is correct or not.
>>
>>>
>>> BTF-defined maps require some extra custom logic and is addressed separate in
>>> the next patch, so that to keep this one smaller and easier to review.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/lib/bpf/linker.c | 844 ++++++++++++++++++++++++++++++++++++++---
>>>    1 file changed, 785 insertions(+), 59 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
>>> index d5dc1d401f57..67d2d06e3cb6 100644
>>> --- a/tools/lib/bpf/linker.c
>>> +++ b/tools/lib/bpf/linker.c
>>> @@ -22,6 +22,8 @@
>>>    #include "libbpf_internal.h"
>>>    #include "strset.h"
>>>
>>> +#define BTF_EXTERN_SEC ".extern"
>>> +
>>>    struct src_sec {
>>>        const char *sec_name;
>>>        /* positional (not necessarily ELF) index in an array of sections */
>>> @@ -74,11 +76,36 @@ struct btf_ext_sec_data {
>>>        void *recs;
>>>    };
>>>
>>> +struct glob_sym {
>>> +     /* ELF symbol index */
>>> +     int sym_idx;
>>> +     /* associated section id for .ksyms, .kconfig, etc, but not .extern */
>>> +     int sec_id;
>>> +     /* extern name offset in STRTAB */
>>> +     int name_off;
>>> +     /* optional associated BTF type ID */
>>> +     int btf_id;
>>> +     /* BTF type ID to which VAR/FUNC type is pointing to; used for
>>> +      * rewriting types when extern VAR/FUNC is resolved to a concrete
>>> +      * definition
>>> +      */
>>> +     int underlying_btf_id;
>>> +     /* sec_var index in the corresponding dst_sec, if exists */
>>> +     int var_idx;
>>> +
>>> +     /* extern or resolved/global symbol */
>>> +     bool is_extern;
>>> +     /* weak or strong symbol, never goes back from strong to weak */
>>> +     bool is_weak;
>>> +};
>>> +
>>>    struct dst_sec {
>>>        char *sec_name;
>>>        /* positional (not necessarily ELF) index in an array of sections */
>>>        int id;
>>>
>>> +     bool ephemeral;
>>> +
>>>        /* ELF info */
>>>        size_t sec_idx;
>>>        Elf_Scn *scn;
>>> @@ -120,6 +147,10 @@ struct bpf_linker {
>>>
>>>        struct btf *btf;
>>>        struct btf_ext *btf_ext;
>>> +
>>> +     /* global (including extern) ELF symbols */
>>> +     int glob_sym_cnt;
>>> +     struct glob_sym *glob_syms;
>>>    };
>>>
>> [...]
>>> +
>>> +static bool glob_sym_btf_matches(const char *sym_name, bool exact,
>>> +                              const struct btf *btf1, __u32 id1,
>>> +                              const struct btf *btf2, __u32 id2)
>>> +{
>>> +     const struct btf_type *t1, *t2;
>>> +     bool is_static1, is_static2;
>>> +     const char *n1, *n2;
>>> +     int i, n;
>>> +
>>> +recur:
>>> +     n1 = n2 = NULL;
>>> +     t1 = skip_mods_and_typedefs(btf1, id1, &id1);
>>> +     t2 = skip_mods_and_typedefs(btf2, id2, &id2);
>>> +
[...]
>>> +
>>> +     case BTF_KIND_TYPEDEF:
>>> +     case BTF_KIND_VOLATILE:
>>> +     case BTF_KIND_CONST:
>>> +     case BTF_KIND_RESTRICT:
>>
>> We already did skip_mods_and_typedefs() before. Unless something serious
>> wrong, we should not hit the above four types. So I think we can skip
>> them here.
> 
> This is the way of documenting explicitly that I'm aware of those
> kinds and they shouldn't be encountered. Otherwise one might wonder if
> we just forgot to handle them.

maybe add a short comment like "shouldn't happen due to 
skip_mods_and_typedefs(), added here for completeness"?

> 
>>
>>> +     case BTF_KIND_DATASEC:
>>> +     default:
>>> +             pr_warn("global '%s': unsupported BTF kind %s\n",
>>> +                     sym_name, btf_kind_str(t1));
>>> +             return false;
>>> +     }
>>> +}
>>> +
>>> +static bool glob_syms_match(const char *sym_name,
>>> +                         struct bpf_linker *linker, struct glob_sym *glob_sym,
>>> +                         struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
>>> +{
>>> +     const struct btf_type *src_t;
>>> +
>>> +     /* if we are dealing with externs, BTF types describing both global
>>> +      * and extern VARs/FUNCs should be completely present in all files
>>> +      */
>>> +     if (!glob_sym->btf_id || !btf_id) {
>>> +             pr_warn("BTF info is missing for global symbol '%s'\n", sym_name);
>>> +             return false;
>>> +     }
>>> +
>>> +     src_t = btf__type_by_id(obj->btf, btf_id);
>>> +     if (!btf_is_var(src_t) && !btf_is_func(src_t)) {
>>> +             pr_warn("only extern variables and functions are supported, but got '%s' for '%s'\n",
>>> +                     btf_kind_str(src_t), sym_name);
>>> +             return false;
>>> +     }
>>> +
>>> +     if (!glob_sym_btf_matches(sym_name, true /*exact*/,
>>> +                               linker->btf, glob_sym->btf_id, obj->btf, btf_id))
>>> +             return false;
>>> +
>>> +     return true;
>>> +}
>>> +
>> [...]
>>> +
>>> +static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
>>> +{
>>> +     /* libelf doesn't provide setters for ST_VISIBILITY,
>>> +      * but it is stored in the lower 2 bits of st_other
>>> +      */
>>> +     sym->st_other &= 0x03;
>>> +     sym->st_other |= sym_vis;
>>> +}
>>> +
>>> +static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
>>> +                              Elf64_Sym *sym, const char *sym_name, int src_sym_idx)
>>> +{
>>> +     struct src_sec *src_sec = NULL;
>>> +     struct dst_sec *dst_sec = NULL;
>>> +     struct glob_sym *glob_sym = NULL;
>>> +     int name_off, sym_type, sym_bind, sym_vis, err;
>>> +     int btf_sec_id = 0, btf_id = 0;
>>> +     size_t dst_sym_idx;
>>> +     Elf64_Sym *dst_sym;
>>> +     bool sym_is_extern;
>>> +
>>> +     sym_type = ELF64_ST_TYPE(sym->st_info);
>>> +     sym_bind = ELF64_ST_BIND(sym->st_info);
>>> +     sym_vis = ELF64_ST_VISIBILITY(sym->st_other);
>>> +     sym_is_extern = sym->st_shndx == SHN_UNDEF;
>>> +
>>> +     if (sym_is_extern) {
>>> +             if (!obj->btf) {
>>> +                     pr_warn("externs without BTF info are not supported\n");
>>> +                     return -ENOTSUP;
>>> +             }
>>> +     } else if (sym->st_shndx < SHN_LORESERVE) {
>>
>> So what happens if sym->st_shndx >= SHN_LORESERVE. Maybe return failures
>> here? In general, bpf program shouldn't hit sym->st_shndx >= SHN_LORESERVE.
> 
> There is at least SHN_ABS (0xfff1), which is an informational STT_FILE
> symbol. libbpf doesn't error out on such special symbols, and linker
> will just pass-through them and append to the final object file.

Okay, I see. Never paid attention to it.

> 
>>
>>> +             src_sec = &obj->secs[sym->st_shndx];
>>> +             if (src_sec->skipped)
>>> +                     return 0;
>>> +             dst_sec = &linker->secs[src_sec->dst_id];
>>> +
>>> +             /* allow only one STT_SECTION symbol per section */
>>> +             if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
>>> +                     obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
>>> +                     return 0;
>>> +             }
>>> +     }
>>> +
>>> +     if (sym_bind == STB_LOCAL)
>>> +             goto add_sym;
>>> +
>>> +     /* find matching BTF info */
>>> +     err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id, &btf_id);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     if (sym_is_extern && btf_sec_id) {
>>> +             const char *sec_name = NULL;
>>> +             const struct btf_type *t;
>>> +
>>> +             t = btf__type_by_id(obj->btf, btf_sec_id);
>>> +             sec_name = btf__str_by_offset(obj->btf, t->name_off);
>>> +
>>> +             /* Clang puts unannotated extern vars into
>>> +              * '.extern' BTF DATASEC. Treat them the same
>>> +              * as unannotated extern funcs (which are
>>> +              * currently not put into any DATASECs).
>>> +              * Those don't have associated src_sec/dst_sec.
>>> +              */
>>> +             if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
>>> +                     src_sec = find_src_sec_by_name(obj, sec_name);
>>> +                     if (!src_sec) {
>>> +                             pr_warn("failed to find matching ELF sec '%s'\n", sec_name);
>>> +                             return -ENOENT;
>>> +                     }
>>> +                     dst_sec = &linker->secs[src_sec->dst_id];
>>> +             }
>>> +     }
>>> +
>>> +     glob_sym = find_glob_sym(linker, sym_name);
>>> +     if (glob_sym) {
>>> +             /* Preventively resolve to existing symbol. This is
>>> +              * needed for further relocation symbol remapping in
>>> +              * the next step of linking.
>>> +              */
>>> +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
>>> +
>>> +             /* If both symbols are non-externs, at least one of
>>> +              * them has to be STB_WEAK, otherwise they are in
>>> +              * a conflict with each other.
>>> +              */
>>> +             if (!sym_is_extern && !glob_sym->is_extern
>>> +                 && !glob_sym->is_weak && sym_bind != STB_WEAK) {
>>> +                     pr_warn("conflicting non-weak symbol #%d (%s) definition in '%s'\n",
>>> +                             src_sym_idx, sym_name, obj->filename);
>>> +                     return -EINVAL;
>>>                }
>>>
>>> +             if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
>>> +                     return -EINVAL;
>>> +
>>> +             dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
>>> +
>>> +             /* If new symbol is strong, then force dst_sym to be strong as
>>> +              * well; this way a mix of weak and non-weak extern
>>> +              * definitions will end up being strong.
>>> +              */
>>> +             if (sym_bind == STB_GLOBAL) {
>>> +                     /* We still need to preserve type (NOTYPE or
>>> +                      * OBJECT/FUNC, depending on whether the symbol is
>>> +                      * extern or not)
>>> +                      */
>>> +                     sym_update_bind(dst_sym, STB_GLOBAL);
>>> +                     glob_sym->is_weak = false;
>>> +             }
>>> +
>>> +             /* Non-default visibility is "contaminating", with stricter
>>> +              * visibility overwriting more permissive ones, even if more
>>> +              * permissive visibility comes from just an extern definition
>>> +              */
>>> +             if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
>>> +                     sym_update_visibility(dst_sym, sym_vis);
>>
>> For visibility, maybe we can just handle DEFAULT and HIDDEN, and others
>> are not supported? DEFAULT + DEFAULT/HIDDEN => DEFAULT, HIDDEN + HIDDEN
>> => HIDDEN?
>>
> 
> Sure, we can restrict this to STV_DEFAULT and STV_HIDDEN for now.
> 
>>> +
>>> +             /* If the new symbol is extern, then regardless if
>>> +              * existing symbol is extern or resolved global, just
>>> +              * keep the existing one untouched.
>>> +              */
>>> +             if (sym_is_extern)
>>> +                     return 0;
>>> +
>>> +             /* If existing symbol is a strong resolved symbol, bail out,
>>> +              * because we lost resolution battle have nothing to
>>> +              * contribute. We already checked abover that there is no
>>> +              * strong-strong conflict. We also already tightened binding
>>> +              * and visibility, so nothing else to contribute at that point.
>>> +              */
>>> +             if (!glob_sym->is_extern && sym_bind == STB_WEAK)
>>> +                     return 0;
>>> +
>>> +             /* At this point, new symbol is strong non-extern,
>>> +              * so overwrite glob_sym with new symbol information.
>>> +              * Preserve binding and visibility.
>>> +              */
>>> +             sym_update_type(dst_sym, sym_type);
>>> +             dst_sym->st_shndx = dst_sec->sec_idx;
>>> +             dst_sym->st_value = src_sec->dst_off + sym->st_value;
>>> +             dst_sym->st_size = sym->st_size;
>>> +
>>> +             /* see comment below about dst_sec->id vs dst_sec->sec_idx */
>>> +             glob_sym->sec_id = dst_sec->id;
>>> +             glob_sym->is_extern = false;
>>> +             /* never relax strong to weak binding */
>>> +             if (sym_bind == STB_GLOBAL)
>>> +                     glob_sym->is_weak = false;
>>
>> In the above, we already set glob_sym->is_weak to false if STB_GLOBAL.
> 
> yep, you are right, this is unnecessary, I'll remove
> 
>>
>>> +
>>> +             if (complete_extern_btf_info(linker->btf, glob_sym->btf_id,
>>> +                                          obj->btf, btf_id))
>>> +                     return -EINVAL;
>>> +
>>> +             /* request updating VAR's/FUNC's underlying BTF type when appending BTF type */
>>> +             glob_sym->underlying_btf_id = 0;
>>> +
>>> +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
>>> +             return 0;
>>> +     }
>>> +
>>> +add_sym:
>>> +     name_off = strset__add_str(linker->strtab_strs, sym_name);
>>> +     if (name_off < 0)
>>> +             return name_off;
>>> +
>>> +     dst_sym = add_new_sym(linker, &dst_sym_idx);
>>> +     if (!dst_sym)
>>> +             return -ENOMEM;
>>> +
>>> +     dst_sym->st_name = name_off;
>>> +     dst_sym->st_info = sym->st_info;
>>> +     dst_sym->st_other = sym->st_other;
>>> +     dst_sym->st_shndx = dst_sec ? dst_sec->sec_idx : sym->st_shndx;
>>> +     dst_sym->st_value = (src_sec ? src_sec->dst_off : 0) + sym->st_value;
>>> +     dst_sym->st_size = sym->st_size;
>>> +
>>> +     obj->sym_map[src_sym_idx] = dst_sym_idx;
>>> +
>>> +     if (sym_type == STT_SECTION && dst_sym) {
>>> +             dst_sec->sec_sym_idx = dst_sym_idx;
>>> +             dst_sym->st_value = 0;
>>> +     }
>>> +
>>> +     if (sym_bind != STB_LOCAL) {
>>> +             glob_sym = add_glob_sym(linker);
>>> +             if (!glob_sym)
>>> +                     return -ENOMEM;
>>> +
>>> +             glob_sym->sym_idx = dst_sym_idx;
>>> +             /* we use dst_sec->id (and not dst_sec->sec_idx), because
>>> +              * ephemeral sections (.kconfig, .ksyms, etc) don't have
>>> +              * sec_idx (as they don't have corresponding ELF section), but
>>> +              * still have id. .extern doesn't have even ephemeral section
>>> +              * associated with it, so dst_sec->id == dst_sec->sec_idx == 0.
>>> +              */
>>> +             glob_sym->sec_id = dst_sec ? dst_sec->id : 0;
>>> +             glob_sym->name_off = name_off;
>>> +             /* we will fill btf_id in during BTF merging step */
>>> +             glob_sym->btf_id = 0;
>>> +             glob_sym->is_extern = sym_is_extern;
>>> +             glob_sym->is_weak = sym_bind == STB_WEAK;
>>>        }
>>>
>>>        return 0;
>>> @@ -1256,7 +1887,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
>>>                dst_sec->shdr->sh_info = dst_linked_sec->sec_idx;
>>>
>>>                src_sec->dst_id = dst_sec->id;
>>> -             err = extend_sec(dst_sec, src_sec);
>>> +             err = extend_sec(linker, dst_sec, src_sec);
>>>                if (err)
>>>                        return err;
>>>
>>> @@ -1309,21 +1940,6 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
>>>        return 0;
>>>    }
>>>
>> [...]
>>> @@ -1442,6 +2078,7 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>>>    {
>>>        const struct btf_type *t;
>>>        int i, j, n, start_id, id;
>>> +     const char *name;
>>>
>>>        if (!obj->btf)
>>>                return 0;
>>> @@ -1454,12 +2091,40 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>>>                return -ENOMEM;
>>>
>>>        for (i = 1; i <= n; i++) {
>>> +             struct glob_sym *glob_sym = NULL;
>>> +
>>>                t = btf__type_by_id(obj->btf, i);
>>>
>>>                /* DATASECs are handled specially below */
>>>                if (btf_kind(t) == BTF_KIND_DATASEC)
>>>                        continue;
>>>
>>> +             if (btf_is_non_static(t)) {
>>> +                     /* there should be glob_sym already */
>>> +                     name = btf__str_by_offset(obj->btf, t->name_off);
>>> +                     glob_sym = find_glob_sym(linker, name);
>>> +
>>> +                     /* VARs without corresponding glob_sym are those that
>>> +                      * belong to skipped/deduplicated sections (i.e.,
>>> +                      * license and version), so just skip them
>>> +                      */
>>> +                     if (!glob_sym)
>>> +                             continue;
>>> +
>>> +                     if (glob_sym->underlying_btf_id == 0)
>>> +                             glob_sym->underlying_btf_id = -t->type;
>>
>> Is this needed? If glob_sym->btf_id is not NULL, then
>> glob_sym->underlying_btf_id has been set by the previous object.
>> If it is NULL, it will set probably after this
>> if (btf_is_non_static(t)) { ...}, is this right?
> 
> I think it's still needed. Here's the scenario.
> 
> 1. Obj file A contains extern symbol X. We create corresponding
> glob_sym (with is_extern=true), and store btf_id to point to
> BTF_KIND_VAR, and btf_underlying_id to point to the type that
> BTF_KIND_VAR points to.
> 
> 2. Obj file B contains non-extern symbol X. At this point
> linker_append_elf_sym() will update glob_sym to is_extern = false, it
> will keep btf_id to re-use already appended BTF_KIND_VAR, but it will
> zero-out underlying_btf_id, because for externs type could be
> incomplete (e.g. for functions it won't contain function argument
> names, for maps it could differ even more drastically later). So then
> we get here, we see that glob_sym->underlying_btf_id is zero, so needs
> updating. We store it as -Y, because Y is BTF type ID in obj->btf, not
> in linker->btf (yet). Then the if (glob_sym->btf_id) below sees that
> glob_sym->btf_id is already set, so we just keep using already
> appended BTF_KIND_VAR (we already set its linkage to
> BTF_VAR_GLOBAL_ALLOCATED in complete_extern_btf_info(), called from
> linker_append_elf_sym(). So we'll skip appending another BTF_KIND_VAR.
> But we do want to point existing BTF_KIND_VAR to a new type that
> corresponds to ID -Y.

Thanks for explanation, I missed the code in
       /* request updating VAR's/FUNC's underlying BTF type when
  appending BTF type */
       glob_sym->underlying_btf_id = 0;

  in linker_append_elf_sym().

Maybe add a comment above the code with something like
  underlying_btf_id may have been reset to 0 due to the presence of
  a strong global variable.
?

> 
>>
>>> +
>>> +                     /* globals from previous object files that match our
>>> +                      * VAR/FUNC already have a corresponding associated
>>> +                      * BTF type, so just make sure to use it
>>> +                      */
>>> +                     if (glob_sym->btf_id) {
>>> +                             /* reuse existing BTF type for global var/func */
>>> +                             obj->btf_type_map[i] = glob_sym->btf_id;
>>> +                             continue;
>>> +                     }
>>> +             }
>>> +
>>>                id = btf__add_type(linker->btf, obj->btf, t);
>>>                if (id < 0) {
>>>                        pr_warn("failed to append BTF type #%d from file '%s'\n", i, obj->filename);
>>> @@ -1467,6 +2132,12 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>>>                }
>>>
>>>                obj->btf_type_map[i] = id;
>>> +
>>> +             /* record just appended BTF type for var/func */
>>> +             if (glob_sym) {
>>> +                     glob_sym->btf_id = id;
>>> +                     glob_sym->underlying_btf_id = -t->type;
>>> +             }
>>>        }
>>>
>>>        /* remap all the types except DATASECs */
>>> @@ -1478,6 +2149,22 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>>>                        return -EINVAL;
>>>        }
>>>
>>> +     /* Rewrite VAR/FUNC underlying types (i.e., FUNC's FUNC_PROTO and VAR's
>>> +      * actual type), if necessary
>>> +      */
>>> +     for (i = 0; i < linker->glob_sym_cnt; i++) {
>>> +             struct glob_sym *glob_sym = &linker->glob_syms[i];
>>> +             struct btf_type *glob_t;
>>> +
>>> +             if (glob_sym->underlying_btf_id >= 0)
>>> +                     continue;
>>> +
>>> +             glob_sym->underlying_btf_id = obj->btf_type_map[-glob_sym->underlying_btf_id];
>>
>> After this point, any new *extern* variables will hit the below in the
>> previous code:
> 
> Right, but we want to hit this for existing glob_syms that went from
> extern to non-extern or from weak to non-weak. See
> 
>      /* request updating VAR's/FUNC's underlying BTF type when
> appending BTF type */
>      glob_sym->underlying_btf_id = 0;
> 
> in linker_append_elf_sym().
> 
> And we'll use that even more extensively when extending __weak and
> extern map definitions later.
> 
>>   > +                    if (glob_sym->btf_id) {
>>   > +                            /* reuse existing BTF type for global var/func */
>>   > +                            obj->btf_type_map[i] = glob_sym->btf_id;
>>   > +                            continue;
>>   > +                    }
>>
>>> +
>>> +             glob_t = btf_type_by_id(linker->btf, glob_sym->btf_id);
>>> +             glob_t->type = glob_sym->underlying_btf_id;
>>> +     }
>>> +
>>>        /* append DATASEC info */
>>>        for (i = 1; i < obj->sec_cnt; i++) {
>>>                struct src_sec *src_sec;
>>> @@ -1505,6 +2192,42 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>> [...]
