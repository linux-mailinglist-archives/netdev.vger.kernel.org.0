Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16E368B1C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbhDWChe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:37:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25138 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231261AbhDWChd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:37:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N2Yg13006524;
        Thu, 22 Apr 2021 19:36:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=U+MTWGRcL0upv34cKag+vp303wg0lsoCzJvCPEZoY/I=;
 b=WHPyOA9aCmnrEmTw+52XY7tegZrbMg2kf1CMlUKX51crxgZycq6w6i4kKK4d2qMbwWvO
 1qbSUPEef5XbBj3nHw9SSnVwZVlsptUvclgJ8WmRVvjfknGTP3SjpvyLO8GEitfYGT0L
 KVbo+2Pp8FN62LUzxK5Xg6guCZt2+D4ODeM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3831khxnx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 19:36:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 19:36:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXBcjkTQhaJJanAPwNZxG/FSlE1xEpjGRwbyCrgjGspMd9pBGsu+otKaquOF4+Rtd2lWW9HuXqljfpnYK4+pxMaVXbjr024O/S8ufrK4gVO96znLvqm45mGdpPM3ea48avUIMnMMlNXc+iD68jCTXYWU7e3bGoN58BNOVPPOZuWBXSueej91GHRwqJyMPQ42ZoHpZYYrIdF5F3pppXfvVkEVMBcNCLGaiOQeXt6YdgV6+eKTSKDZlt2/WygOBj9K7f+7C/4Ux736xnpPIGX+gycymlQv63BegKcSesQd21H3vhw8Xz9Pavw9tFQ+IuHoPF68jNqQaF5FM4d71YNwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+MTWGRcL0upv34cKag+vp303wg0lsoCzJvCPEZoY/I=;
 b=UHSsfeq9DEYVI4nG7pC8miHNMX2X/s+684q1p36d5XMeO4LJzOyKKfXZsbVuFNHb/uikzq6XeuAkQXjeNNV3feVVB6bF/Qn8u2tqx2E+WJvRtEBYIoluFzinmgvJIK8Ei70zQHDL1z/PGtOF2RQiVq5ntJQjb4djpIaFFD/6ecVdIdbZGmLP9mcf9Yls6GELNvq4v+qP6oHZ1Or8Nxao7zmqRdG8tgnZju1b08W4Xm1Vt1Oqf4FZZKVq0knaVY42JQhEDXZt+ZZ2S6n7ANijrSz0gz3xtVFVR0C1DPgafXgIKTflH4+SReDLtnjLLF07TGptlay8eEHzKpvI3k/JUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3920.namprd15.prod.outlook.com (2603:10b6:806:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 02:36:41 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 02:36:41 +0000
Subject: Re: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution
 support for functions and global variables
From:   Yonghong Song <yhs@fb.com>
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
 <cffdf4e2-220d-cc2e-67e9-b83e848bdddf@fb.com>
Message-ID: <8c6d3655-f9c7-d0b0-b10f-00f679c44c1e@fb.com>
Date:   Thu, 22 Apr 2021 19:36:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <cffdf4e2-220d-cc2e-67e9-b83e848bdddf@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: CO2PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:104:4::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by CO2PR04CA0166.namprd04.prod.outlook.com (2603:10b6:104:4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 02:36:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ae96596-6277-4923-ce0f-08d90600a09e
X-MS-TrafficTypeDiagnostic: SA0PR15MB3920:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3920DBD53629AF97BFBF6B22D3459@SA0PR15MB3920.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2Q7CT6uxZdQiRuXEU0p2kQ68IA7lgKdtoors96oOKJyqeSe2j1l/4W/hI3dFEvuB/drQo1NuSjeHG/l/eioxdeVKlQn3pPAPKOPHTXrXm7UbVrCmhc+jQ/jQu2xBMn5GDxOvXODNbwNvwqKX9ICgzBrH3oiMikLtu/7WxzJyLEtw9Qc+k2prFwJIAj03pkO2C3vrdUSCc+rAHQpz8H0UDOOR2WPGZs/nQJISc/JsLyETCZuuIQcQJOcWuVX7XhA4NMfcldny9p+zh47tA+3dR6L7xNea2bHlvDI1Y/Eg1E8hpWrA5MtJM7J7i+KfMhW0MeN/E7k9ezdJUrKCbPPov1BjD39Wdg+KV3B5rBwVANT+Q1U//TJBrcCpzXoCe8XrRdiQ6xa+knUSBIkGlepMiOotAFcaQ5NB7BMtjXv6sUq6NL0s7YuRx+1d+/juAYsN7sMGAXXDUK9yC8Z2cD3vcQ+St1xmieKKHH5rMi+u5h0sRQlN3thkQVRNEax3UJPDhKTLfM3Co8m+FPmsPg/VVEe1KNkeDfB7lO4zxzUekldm/GI2XY8k6wk36B8Djo3hTcL4iu13SSocG50owZC6Hi/k9kt9G+nWraD+QrTuuoFBrmIff/eW9SWlgGRvJA2bZ54gCANOwM1e9mib9sszc9UHozE/BzfhttaQl+USQv1la6tbee4iMJGOvfI8bRH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(86362001)(8676002)(31696002)(52116002)(16526019)(316002)(186003)(5660300002)(6486002)(2906002)(4326008)(53546011)(31686004)(36756003)(66556008)(54906003)(6916009)(478600001)(66476007)(8936002)(2616005)(66946007)(6666004)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TkJyNzRUZGF3M3huVVU5RXBmWElaWGJ0WkVnYTFnV2x3aW1kaUFONkxUMndR?=
 =?utf-8?B?WXowZ2dtOHN1STJxMzVZaGY2OXBIbVM3QkNZazJaOWsxcjUvU3liR2JSV2hK?=
 =?utf-8?B?UWV0T0czclRMeWxTVllUSlN1eEFtVEVCNzFlZ0w1cURUdXBxZHdNVlhKaUFU?=
 =?utf-8?B?Rm5jZG5YalZ4WTlBdUhTRUY2ZTQ1YWw2cHZNQzNYalFNbDEvRkZGVVlsNzJY?=
 =?utf-8?B?cVhFMkp4VnJCTFJoWFVocWVVdVdPSWMvanJ0NjVnRC9xN1V2cTMxY3N1ZnBX?=
 =?utf-8?B?SmRSZmk1L3RhT0NmcGhXRThHODlSNTNHV2pScU1HWHZUZlEzVFc2SEovK3pF?=
 =?utf-8?B?c0NGZnQwb2t0V0crdnFUZklsVDVENEpXeEdSRWt6R09iVVZvN3lJZDBPVGhD?=
 =?utf-8?B?NTJ4UkFMY3NpQXVOMGNzb2UrQWRtbm5XY2dxUTlyY3FuZFNDeFR5K2pHUVpR?=
 =?utf-8?B?ZjBqZ1ZtMHlpbFk2c0hUQWVKYnhTdG5KWCs3SFB5dUQzQXI1MHFycG9jVEVj?=
 =?utf-8?B?YmI1V0lwRmUwM3h3N0VlUHBXaUxkR3J1cXd2SzV1RTVkK1VtVVE1NWk0K3VS?=
 =?utf-8?B?OFdnM2l6SENPODVmck5Rc0Y5dklZdjV3bjNUcjZWSlloTWtIVVFuaVN0bGFn?=
 =?utf-8?B?cjRjckxUZnhubDE5c2U5K29ydzNEVy81VzJMTTBtWHRUekw4ZWVzYkZnUS8y?=
 =?utf-8?B?RC9BK1BWaGxSZkpOenplcDNzUzRNd2pZY1JEalgrVkpUWFN6d3VMSnpHYjZJ?=
 =?utf-8?B?bTNadnNRSTRmd3pvcnlhZlFnM05Gdm4vSlJzNjdkQk82a3A0UkF4bGl2MVBJ?=
 =?utf-8?B?U09TT0tta3JXK3NpZlZFUURqZDlRemZmS1NpS3FwdnRidko4VGR3ODArcGVI?=
 =?utf-8?B?Nk9XTFN0WFFFL2RLTjVaQUZ0OVErNlV0WklMWGNuODRGanRMWGtOZTdhRHYx?=
 =?utf-8?B?WWpDRXdMYVhUR3BZK20wUDZjMlErUjZiWDJ5bGdCQjR0N3J4cDlwZ054VHhv?=
 =?utf-8?B?cGRkUTA1anRFYUhuL1VxUzR4WTNhU1pTTXEzQk9hSWpKYUVCd283bEQ2bjl1?=
 =?utf-8?B?Sm54N3A5U0xFaXVsMjZrVVZhNGZDVjRBekhqUytaQnVXeEozUU1PMEFyVWFh?=
 =?utf-8?B?K2VtbUxFQ0gwZ3N1U1FHakdYV1FxREZBUURrSWJEbkRNbzRhclNlME9XdVJ1?=
 =?utf-8?B?WnN6RUdHV01VWGN3OENjQVRIZk1ZSmwramExc05VVmJmc09UcEhXK3hvdXRu?=
 =?utf-8?B?TEZ0MDlVcktuMUdZSUpqNHNxMGVFS0RueXQxZmMybGVlU0x3Wm5jZmpVSkRB?=
 =?utf-8?B?b3NQTmxtOXgyaytYbFdrQURncjRnQWFTVGlLM0lRbnlwQU9rZzVGb2ZWTUU3?=
 =?utf-8?B?b1FXSlV6UjdwV2tDZ0lDRmZnOHBwbEV1aC9Ya2F0c2xlMlRZTTEvNEU0L1dM?=
 =?utf-8?B?aERMaG53Q1lndGVwRGhNSDlkaDAwZnlzUlF2a2NBaGFoN29VRTJUUEt5eTJQ?=
 =?utf-8?B?am02Zjl0QkZNeFNlT0tKVUluWUczNmVQaHJaNWlmNDhzU3QyVnAwYTFkSGZl?=
 =?utf-8?B?RTZOTmxkWGNPQmJWMHlXNHNMbFpVN3JQUENOOWhQakRxdWtQVm40aExPTGZs?=
 =?utf-8?B?TjBUZlE4UXRCcDdWNGVxd2N6bEszZjQxZGJVeVNGc1JtSUNPS0tGaGhHZHNP?=
 =?utf-8?B?V056dlhWOE51b1FqVmorUE9YVU9sQTd6VmlJckRkR2pCRTE3MWN5dGNxTUdC?=
 =?utf-8?B?TTRoYXhiOW5CUEhQVmNHV2gvTDEvZ0EyM3ZaYURKdTh6Mis4clQraE8zZmJB?=
 =?utf-8?Q?Xi3eTNSB5sDqhBSDZ+kUiv9rMnGARxgYnfCHo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae96596-6277-4923-ce0f-08d90600a09e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 02:36:41.5034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmi6C7nDwIbGMH0TG1wnZHVMWXXXXCCNI1hNXRsthvK5aQEp2jqwN6mfEQPjPPeB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3920
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: cA8dlYsKozZtdB_Hg_1QQtuvRKcYEIEq
X-Proofpoint-GUID: cA8dlYsKozZtdB_Hg_1QQtuvRKcYEIEq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230016
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 4:57 PM, Yonghong Song wrote:
> 
> 
> On 4/22/21 3:12 PM, Andrii Nakryiko wrote:
>> On Thu, Apr 22, 2021 at 2:27 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
>>>> Add BPF static linker logic to resolve extern variables and 
>>>> functions across
>>>> multiple linked together BPF object files.
>>>>
>>>> For that, linker maintains a separate list of struct glob_sym 
>>>> structures,
>>>> which keeps track of few pieces of metadata (is it extern or 
>>>> resolved global,
>>>> is it a weak symbol, which ELF section it belongs to, etc) and ties 
>>>> together
>>>> BTF type info and ELF symbol information and keeps them in sync.
>>>>
>>>> With adding support for extern variables/funcs, it's now possible 
>>>> for some
>>>> sections to contain both extern and non-extern definitions. This 
>>>> means that
>>>> some sections may start out as ephemeral (if only externs are 
>>>> present and thus
>>>> there is not corresponding ELF section), but will be "upgraded" to 
>>>> actual ELF
>>>> section as symbols are resolved or new non-extern definitions are 
>>>> appended.
>>>>
>>>> Additional care is taken to not duplicate extern entries in sections 
>>>> like
>>>> .kconfig and .ksyms.
>>>>
>>>> Given libbpf requires BTF type to always be present for .kconfig/.ksym
>>>> externs, linker extends this requirement to all the externs, even 
>>>> those that
>>>> are supposed to be resolved during static linking and which won't be 
>>>> visible
>>>> to libbpf. With BTF information always present, static linker will 
>>>> check not
>>>> just ELF symbol matches, but entire BTF type signature match as 
>>>> well. That
>>>> logic is stricter that BPF CO-RE checks. It probably should be 
>>>> re-used by
>>>> .ksym resolution logic in libbpf as well, but that's left for follow up
>>>> patches.
>>>>
>>>> To make it unnecessary to rewrite ELF symbols and minimize BTF type
>>>> rewriting/removal, ELF symbols that correspond to externs initially 
>>>> will be
>>>> updated in place once they are resolved. Similarly for BTF type 
>>>> info, VAR/FUNC
>>>> and var_secinfo's (sec_vars in struct bpf_linker) are staying 
>>>> stable, but
>>>> types they point to might get replaced when extern is resolved. This 
>>>> might
>>>> leave some left-over types (even though we try to minimize this for 
>>>> common
>>>> cases of having extern funcs with not argument names vs concrete 
>>>> function with
>>>> names properly specified). That can be addresses later with a 
>>>> generic BTF
>>>> garbage collection. That's left for a follow up as well.
>>>>
>>>> Given BTF type appending phase is separate from ELF symbol
>>>> appending/resolution, special struct glob_sym->underlying_btf_id 
>>>> variable is
>>>> used to communicate resolution and rewrite decisions. 0 means
>>>> underlying_btf_id needs to be appended (it's not yet in final 
>>>> linker->btf), <0
>>>> values are used for temporary storage of source BTF type ID (not yet
>>>> rewritten), so -glob_sym->underlying_btf_id is BTF type id in 
>>>> obj-btf. But by
>>>> the end of linker_append_btf() phase, that underlying_btf_id will be 
>>>> remapped
>>>> and will always be > 0. This is the uglies part of the whole 
>>>> process, but
>>>> keeps the other parts much simpler due to stability of sec_var and 
>>>> VAR/FUNC
>>>> types, as well as ELF symbol, so please keep that in mind while 
>>>> reviewing.
>>>
>>> This is indeed complicated. I has some comments below. Please check
>>> whether my understanding is correct or not.
>>>
>>>>
>>>> BTF-defined maps require some extra custom logic and is addressed 
>>>> separate in
>>>> the next patch, so that to keep this one smaller and easier to review.
>>>>
>>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>>> ---
>>>>    tools/lib/bpf/linker.c | 844 
>>>> ++++++++++++++++++++++++++++++++++++++---
>>>>    1 file changed, 785 insertions(+), 59 deletions(-)
>>>>
[...]
>>>
>>>> +             src_sec = &obj->secs[sym->st_shndx];
>>>> +             if (src_sec->skipped)
>>>> +                     return 0;
>>>> +             dst_sec = &linker->secs[src_sec->dst_id];
>>>> +
>>>> +             /* allow only one STT_SECTION symbol per section */
>>>> +             if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
>>>> +                     obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
>>>> +                     return 0;
>>>> +             }
>>>> +     }
>>>> +
>>>> +     if (sym_bind == STB_LOCAL)
>>>> +             goto add_sym;
>>>> +
>>>> +     /* find matching BTF info */
>>>> +     err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id, 
>>>> &btf_id);
>>>> +     if (err)
>>>> +             return err;
>>>> +
>>>> +     if (sym_is_extern && btf_sec_id) {
>>>> +             const char *sec_name = NULL;
>>>> +             const struct btf_type *t;
>>>> +
>>>> +             t = btf__type_by_id(obj->btf, btf_sec_id);
>>>> +             sec_name = btf__str_by_offset(obj->btf, t->name_off);
>>>> +
>>>> +             /* Clang puts unannotated extern vars into
>>>> +              * '.extern' BTF DATASEC. Treat them the same
>>>> +              * as unannotated extern funcs (which are
>>>> +              * currently not put into any DATASECs).
>>>> +              * Those don't have associated src_sec/dst_sec.
>>>> +              */
>>>> +             if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
>>>> +                     src_sec = find_src_sec_by_name(obj, sec_name);
>>>> +                     if (!src_sec) {
>>>> +                             pr_warn("failed to find matching ELF 
>>>> sec '%s'\n", sec_name);
>>>> +                             return -ENOENT;
>>>> +                     }
>>>> +                     dst_sec = &linker->secs[src_sec->dst_id];
>>>> +             }
>>>> +     }
>>>> +
>>>> +     glob_sym = find_glob_sym(linker, sym_name);
>>>> +     if (glob_sym) {
>>>> +             /* Preventively resolve to existing symbol. This is
>>>> +              * needed for further relocation symbol remapping in
>>>> +              * the next step of linking.
>>>> +              */
>>>> +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
>>>> +
>>>> +             /* If both symbols are non-externs, at least one of
>>>> +              * them has to be STB_WEAK, otherwise they are in
>>>> +              * a conflict with each other.
>>>> +              */
>>>> +             if (!sym_is_extern && !glob_sym->is_extern
>>>> +                 && !glob_sym->is_weak && sym_bind != STB_WEAK) {
>>>> +                     pr_warn("conflicting non-weak symbol #%d (%s) 
>>>> definition in '%s'\n",
>>>> +                             src_sym_idx, sym_name, obj->filename);
>>>> +                     return -EINVAL;
>>>>                }
>>>>
>>>> +             if (!glob_syms_match(sym_name, linker, glob_sym, obj, 
>>>> sym, src_sym_idx, btf_id))
>>>> +                     return -EINVAL;
>>>> +
>>>> +             dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
>>>> +
>>>> +             /* If new symbol is strong, then force dst_sym to be 
>>>> strong as
>>>> +              * well; this way a mix of weak and non-weak extern
>>>> +              * definitions will end up being strong.
>>>> +              */
>>>> +             if (sym_bind == STB_GLOBAL) {
>>>> +                     /* We still need to preserve type (NOTYPE or
>>>> +                      * OBJECT/FUNC, depending on whether the 
>>>> symbol is
>>>> +                      * extern or not)
>>>> +                      */
>>>> +                     sym_update_bind(dst_sym, STB_GLOBAL);
>>>> +                     glob_sym->is_weak = false;
>>>> +             }
>>>> +
>>>> +             /* Non-default visibility is "contaminating", with 
>>>> stricter
>>>> +              * visibility overwriting more permissive ones, even 
>>>> if more
>>>> +              * permissive visibility comes from just an extern 
>>>> definition
>>>> +              */
>>>> +             if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
>>>> +                     sym_update_visibility(dst_sym, sym_vis);
>>>
>>> For visibility, maybe we can just handle DEFAULT and HIDDEN, and others
>>> are not supported? DEFAULT + DEFAULT/HIDDEN => DEFAULT, HIDDEN + HIDDEN
>>> => HIDDEN?

Looking at your selftest. Your current approach, DEFAULT + DEFAULT -> 
DEFAULT, HIDDEN + HIDDEN/DEFAULT -> HIDDEN should work fine. This is
also align with ELF principal to accommodate the least permissive
visibility.

>>>
>>
>> Sure, we can restrict this to STV_DEFAULT and STV_HIDDEN for now. >>
[...]
