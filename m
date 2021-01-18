Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E92FA945
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407809AbhARSuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:50:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407718AbhARSpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:45:44 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10IIbxR4001071;
        Mon, 18 Jan 2021 10:44:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zdcXkMI0brlHzakV3N18fHNxl2tGDD54ZYNpfJP0ZP8=;
 b=d32WlKOseYQ/IavGM4tJynbfpucRhPWQ3Ai9F1LsOYdIYZN43DklcHs4w0dZ8ZUWTuQf
 OSD751uFkCUTik844S2ZfjbbO2ezNK6nBO1OXDGhSVWCgNveYLS4B4ZM8SdEWd58iVfr
 7nJC1zEWy0EJeV6tJm7IBS9RNWC+tTYeAoM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 363vps0bqm-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Jan 2021 10:44:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 18 Jan 2021 10:44:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiLGroO7cIx0nn5hocMssgKegjTjBJwvMBqd4kVbIxQpmSEcpDdMlTlFobjpDcnDK0dFoZ+I5qqb5xr2CvPFlKw2Y54SMNJaizxce0KccCwyT5x/onSFAv6fOACyYEzWKwi7QfaXAjsVoxE8HZ+O5dLE8cOFGOkBWwvgKlNtyTKW/ysS/N0W71anes10DNROXzek2di2nic8x9l6pjW2F0eu6B6YxFlSxfBe3rVbB73BuBkA94ch8gZAxoeZJZV9oKukBa4GUS9BWOLrGaeH3O9h+uGOGnLsrNTqhw7e0pXiyTBb9cekzo0eul7x8mIv5PbE2IxdVbfItjwiOZgd6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdcXkMI0brlHzakV3N18fHNxl2tGDD54ZYNpfJP0ZP8=;
 b=dQcetQFuva/2WO3UlfkElMV6LwI4hHdeWa2t91t2m8XdpGQm3aAsOmU8rNBJO3Zp7cC/Hr4GGdGf5rEf/jmn58xlfQeuQPE/o54jmIM8tb9ftsCAfpd7U/Jb+l5x0TktwiKLK+sMO0Fc0piZmeaAFbqFgZTZzuP/TfSDoMfVU+YReScqUBMKSbpGXNdajvldaNzOBrUYgUHIgUNx2u+exAJ3SM+8Ct9OmG8RPho5TcRBZ09SNeHSHb5ynQxPiQ+ZcCA1HcMWUebuXTYDMaCRjpQHbe7C/Zq8kZOLKjruw/j5OPg5WXM6fiJ3gsTu3/sBlhuwDpr0qPkUjkJl2ySchA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdcXkMI0brlHzakV3N18fHNxl2tGDD54ZYNpfJP0ZP8=;
 b=BgaS+yAdEpKsUj6twiH+uVlMEMVVsV7g2TN2ojyouw05CAz/q7iKr7fSkSO76LngzSVi56P5f8H7wp/EDdVwMWYdVYYNlDUI98JYeDkDCnQhan6hmnrechodCTUCkkApSJNc6YcZKwSjazfZLOfvGyEJdYnJfYamJvsAUSVW77Y=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Mon, 18 Jan
 2021 18:44:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 18:44:36 +0000
Subject: Re: [PATCH bpf 1/2] samples/bpf: Set flag __SANE_USERSPACE_TYPES__
 for MIPS to fix build warnings
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <linux-sparse@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
 <1610535453-2352-2-git-send-email-yangtiezhu@loongson.cn>
 <e3eb5919-4573-4576-e6aa-bd8ff56409ed@fb.com>
 <f077bcae-97be-fc7f-c3fa-c6026bfe25d2@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <313a7ed5-a34d-5eed-4715-06fed4a75c40@fb.com>
Date:   Mon, 18 Jan 2021 10:44:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <f077bcae-97be-fc7f-c3fa-c6026bfe25d2@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:4199]
X-ClientProxiedBy: SJ0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::10cf] (2620:10d:c090:400::5:4199) by SJ0PR13CA0006.namprd13.prod.outlook.com (2603:10b6:a03:2c0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Mon, 18 Jan 2021 18:44:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 052e3727-a8fd-4fa0-a296-08d8bbe11a8f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28880DCF9FAB63F478618247D3A40@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dT2+a9PcL+sp77zMLyZgZkySxD6KGeh/9ZRZGxOHYyiWRFHNJO4TN5O595yhLDFqoWx/PXRdgc6e9NEMbWlrLa0MsFu+9vVsABSNTh/3MEqMs6nfajY0azjX3iF3lfVeoEHQ6ZIhi/0fqnbnNyKxJc/PA8KuuJvsmjiEira3Tmn8rIW/QecDAoPVaZoxMboGTdC9919yHdrqie1slSso7mZL6q258j6AKcuYZMHGRIjm7Vw/U6Q0/vi0KCx1V8R2EU6Rgn6ZBOXwNDHJaCJz454REj9I0t+xUy2Jg3iwmy6Qeab5QZwIuRHajwKn13TnlaEDvo5fGBjtE/DL2H5Nx19177PlXXdeiE9/7DJOohlqJy9tx3gWv/QZo0AYlNS38EdWfgEedX0uQSzLSd2b4yNEqz/R6zBN2RFuP97LW+tjIG8t5ddrx2vlfEEVduNMsIHVRMPgQCVqus1QR7HX9VOgpC7edkj1dx9FscLjW6jZT0rcCOoqtZxdglnQIx8tcETZUuWGI5m73innRRyFTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(8676002)(66556008)(8936002)(31696002)(86362001)(66946007)(66476007)(2906002)(5660300002)(36756003)(921005)(31686004)(110136005)(478600001)(2616005)(52116002)(7416002)(316002)(186003)(83380400001)(6486002)(16526019)(4326008)(53546011)(3714002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnhzNTNkSnY2VzFuKzc5cjFISHV3c29TczZyU05BN3lZaEpkUEx0S2xaNUVW?=
 =?utf-8?B?RDZXV0hWQ0U5eDUvQmNMSGRnTTZ2djE2cEloQkhCdFcvMW11UzNqcTdpV1E2?=
 =?utf-8?B?QU1XRjF2cW1oWDRJRUNqRFh1bjRQWnY5UTgzalc2SXVpMGt6Z1dlM3d1NW84?=
 =?utf-8?B?NnRqWi90U3FuSVhnQ0ljZkhhdDlzRDNVekhMVnhKc1c5dEk1aXAwT0ZsaXBt?=
 =?utf-8?B?ZHBQOE9sU3VZUVlEejNTS2VoUXNNVHVvSEw4OFU2QTJPYzBkV284SmY1RDAy?=
 =?utf-8?B?ZWM3Tm5RUCtnZ0sxV1Voa1p1NC9YcG5zOVorbWlmT3lHb0REUUlJeEVsdGF1?=
 =?utf-8?B?aHRFZVdVRUFZd05jMHROUC9qd05kRUhGZnpuV3lFcnJ3TXlRbnpsZzBUZTM2?=
 =?utf-8?B?TldZWWZINGlZcTYvKzdFVzZ1NFhQRXI5R2QyQ2MrT2xDWGZkRDY2OE15QTg3?=
 =?utf-8?B?VE1TZE1tU0ZuaUtqQXkzVlM0Q0hRQmN4c1MwcUtPTjlZcGNKamlvcThEOVJ5?=
 =?utf-8?B?Z1RRZFVTZ1paaWpLY2hqT0FsT2NQSWIwYWI0blVXSnk0aUVENjFxUCtSSWpY?=
 =?utf-8?B?VTU2a0taTXcrT1ZsUjVXa1Y0dHN0TzBuZVIxNi9Wa240NTI4djV1Zlk5cldL?=
 =?utf-8?B?WWFqMW1iTWhIY3hBV0NCSWtyUktnNnF4NmdFU1N5amw4bW43ZzhNNGMwOWxI?=
 =?utf-8?B?UWZHaHZIemREVmhHeUhsRExnLzUyT3drS3JoRVFxb0tFbk9TanVjUjlxVE1T?=
 =?utf-8?B?K1BacFBlZmVUUStFeWhnMmRWbzVLNjh2aDJ2TlRNNTdBdmZMWnozZnRFcERO?=
 =?utf-8?B?MEdiSVN0V2QvNk94MXZmQldSV1dGVld1b1ZxYnRvVFZOK3BPSWZ0S29TL0Js?=
 =?utf-8?B?ZXNGVlh3RDhjOG9BZW1JMUZNMFpvcGZaQ1c1bVNLTjBsd0VxZFVZUWlnRGtD?=
 =?utf-8?B?NmlNbFB6a1lKUEhZY2VRZCtRbWFFZmVkblc3WVZaZFdvNnZKRmJRRlZkWmpG?=
 =?utf-8?B?ZFY1dVhEOUlVdGJudHVGbGl2bE9qV2tzVDVZMkk5UytYT3Y0UDBaUzRPNm5R?=
 =?utf-8?B?UWh4eVdLUnFzandEOTcrUjA4ZUxCaUpyVzVTMHJJOFR4aDdaRyt5L3FYTU95?=
 =?utf-8?B?cjNLMHhNdWdVVEE2OWYvaEJpMGZ3Z2FRSnpDMXBEQXprZStrU0NicTRWcENo?=
 =?utf-8?B?MEdpRTJHNHlKQ0M3UUJGRUJGM3NxTjlCeExyTndxdTl6cnIrc0llbFVQN2N6?=
 =?utf-8?B?VkFyajZ4cmVBamFjQ0xCSitpejVLQ3NVdzhLY0JkRzFNdmt3NDRNKzFWeVR3?=
 =?utf-8?B?TlZUK2pKVG0wdWZzNGcvRXZ2Yk9IbjhtRXI1a3JwS3QxYjBJb2VVcjRNYnFs?=
 =?utf-8?B?cE5JMzlqU3JLRVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 052e3727-a8fd-4fa0-a296-08d8bbe11a8f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 18:44:36.2630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xuFn0UPomPSW5O/AmOkE8oykEtuhU9TZlTyAhjLWrwVvUOajGSKI3ApvlSOWCdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_14:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/21 7:22 PM, Tiezhu Yang wrote:
> On 01/14/2021 01:12 AM, Yonghong Song wrote:
>>
>>
>> On 1/13/21 2:57 AM, Tiezhu Yang wrote:
>>> MIPS needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
>>> 'int-ll64.h' in arch/mips/include/uapi/asm/types.h and avoid compile
>>> warnings when printing __u64 with %llu, %llx or %lld.
>>
>> could you mention which command produces the following warning?
> 
> make M=samples/bpf
> 
>>
>>>
>>>      printf("0x%02x : %llu\n", key, value);
>>>                       ~~~^          ~~~~~
>>>                       %lu
>>>     printf("%s/%llx;", sym->name, addr);
>>>                ~~~^               ~~~~
>>>                %lx
>>>    printf(";%s %lld\n", key->waker, count);
>>>                ~~~^                 ~~~~~
>>>                %ld
>>>
>>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>>> ---
>>>   samples/bpf/Makefile        | 4 ++++
>>>   tools/include/linux/types.h | 3 +++
>>>   2 files changed, 7 insertions(+)
>>>
>>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>>> index 26fc96c..27de306 100644
>>> --- a/samples/bpf/Makefile
>>> +++ b/samples/bpf/Makefile
>>> @@ -183,6 +183,10 @@ BPF_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
>>>   TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
>>>   endif
>>>   +ifeq ($(ARCH), mips)
>>> +TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
>>> +endif
>>> +
>>
>> This change looks okay based on description in
>> arch/mips/include/uapi/asm/types.h
>>
>> '''
>> /*
>>  * We don't use int-l64.h for the kernel anymore but still use it for
>>  * userspace to avoid code changes.
>>  *
>>  * However, some user programs (e.g. perf) may not want this. They can
>>  * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
>>  */
>> '''
>>
>>>   TPROGS_CFLAGS += -Wall -O2
>>>   TPROGS_CFLAGS += -Wmissing-prototypes
>>>   TPROGS_CFLAGS += -Wstrict-prototypes
>>> diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
>>> index 154eb4e..e9c5a21 100644
>>> --- a/tools/include/linux/types.h
>>> +++ b/tools/include/linux/types.h
>>> @@ -6,7 +6,10 @@
>>>   #include <stddef.h>
>>>   #include <stdint.h>
>>>   +#ifndef __SANE_USERSPACE_TYPES__
>>>   #define __SANE_USERSPACE_TYPES__    /* For PPC64, to get LL64 types */
>>> +#endif
>>
>> What problem this patch fixed?
> 
> If add "TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__" in
> samples/bpf/Makefile, it appears the following error:
> 
> Auto-detecting system features:
> ...                        libelf: [ on  ]
> ...                          zlib: [ on  ]
> ...                           bpf: [ OFF ]
> 
> BPF API too old
> make[3]: *** [Makefile:293: bpfdep] Error 1
> make[2]: *** [Makefile:156: all] Error 2
> 
> With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
> the above error has gone.
> 
>> If this header is used, you can just
>> change comment from "PPC64" to "PPC64/MIPS", right?
> 
> If include <linux/types.h> in the source files which have compile warnings
> when printing __u64 with %llu, %llx or %lld, it has no effect due to 
> actually
> it includes usr/include/linux/types.h instead of 
> tools/include/linux/types.h,
> this is because the include-directories in samples/bpf/Makefile are 
> searched
> in the order, -I./usr/include is in the front of -I./tools/include.
> 
> So I think define __SANE_USERSPACE_TYPES__ for MIPS in samples/bpf/Makefile
> is proper, at the same time, add #ifndef __SANE_USERSPACE_TYPES__ in
> tools/include/linux/types.h can avoid build error and have no side effect.
> 
> I will send v2 later with mention in the commit message that this is
> mips related.

It would be good if you can add the above information to the commit
message so people will know what the root cause of the issue.

If I understand correctly, if we could have include path
"tools/include" earlier than "usr/include", we might not have this 
issue. The problem is that "usr/include" is preferred first (uapi)
than "tools/include" (including kernel dev headers).

I am wondering whether we could avoid changes in 
tools/include/linux/types.h, e.g., by undef __SANE_USER_SPACE_TYPES 
right before include
path tools/include. But that sounds like a ugly hack and actually
the change in tools/include/linux/types.h does not hurt other
compilations.

So your current change looks good to me, but please have better
explanation of the problem and why for each change in the commit
message.

> 
> Thanks,
> Tiezhu
> 
>>
>>> +
>>>   #include <asm/types.h>
>>>   #include <asm/posix_types.h>
>>>
> 
