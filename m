Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622D928442E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 05:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgJFDGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 23:06:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52264 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725909AbgJFDGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 23:06:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09634j0q022944;
        Mon, 5 Oct 2020 20:05:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZmYUIt6Tsh94DlZ1X4ga3XvZkCkvptNNIVi9SGzeUF8=;
 b=WOkUpS5L5ppAPn86jMxgB1KsQnAIyrdjqk/dZ9rEzGHeIOoZtyKrLeLAC/m+VRv+iDrd
 A2RE9gkSDrCTC3GcGAkTWE29HY3xtE4iJoPiOc2TCmFFzmsaiN1eDQz82+XSEEqhYMJu
 O8oqx0qUKjquuABaPdzxu4KHel7c75Ofr0s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33xmt03107-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Oct 2020 20:05:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 20:05:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fa89Jx/Gdprifr2GBd3hFduumfSvsCo0MySo5kfG1WkMhfqw4KtN3FESXr3ZH2FnMWLsxtFpi1xp48fqqjXnjWk2jotd1juWO4sUdycm7bGzxolNEbHs9mEsngvW2Gu2CSksAv53cfND/CScnU7bGxe3+XkZcnLz68r70+dd2X8J0kloFc/KSh4r31SqQ9SbrrYk+DHtXAHBqiQcRvL3RzGtTsuSQa0oihOyKy9MRcIwWJj0HdiU1qszAy5mQRw/0+ed4tnFni6dX2RQwSLOyyGRgIwhxP+P8DrqHosv3TccKpYwaBopflvr2LSZipwnPFuCKNmo62cRrBVWLcNXzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmYUIt6Tsh94DlZ1X4ga3XvZkCkvptNNIVi9SGzeUF8=;
 b=G7NFAzZGWAFBAAu9tbaecmK9S2ulVf2jqX1rI3u6l8wDtT5ChDFLDAE55ChaFLCA/Nr0AVrlwgifE5PuwWX4TxOsxGln+ad/UZENNd1F2jLEDHtKZwL8t+q5mTDibXN27kYXct2galvtIx41UDroUpxcz6aUQUAV2g/WCYMtJz5pVHeGSUnJFaEVNURjb8P6CGXKaaNnC7yT5Tbk6HuhckYgVI+6Km5KHJeAzKsMFDxaiUQca1HpqT6fikyOcFldtMrI6wCjbzjPi07ZdvFHem1pI7lDt6m4a5jd1+nSBI4v8KnbBtsX08HTi8iBaU5xuCORZgTPlXHuBMeYaRHCEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmYUIt6Tsh94DlZ1X4ga3XvZkCkvptNNIVi9SGzeUF8=;
 b=iRvTLgPQwOrnGcyF03M2JJCYeuBPHrZ1svSy8jbG4Qw9/zcAl6PIxGKz5o4ts5B87vAkpO4FlT6kYTVVdEO5iIPPMjOQV8nty419BjSfjmPKsR6f4VWoz06WNEo3TpkdBddMK6DoL9QMUqpVVBL+Q5f36XvwOQHaY5REODkKoBQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2581.namprd15.prod.outlook.com (2603:10b6:a03:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Tue, 6 Oct
 2020 03:05:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 03:05:38 +0000
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: change Makefile to cope with
 latest llvm
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20201003021904.1468678-1-yhs@fb.com>
 <CAEf4BzZSg9TWF=kGVmiZ7HUbpyXwYUEqrvFMeZgYo0h7EC8b3w@mail.gmail.com>
 <9dba5b12-8a78-fa6b-ec43-224fb9297f48@fb.com>
 <CAEf4BzYXXFtfR5LqNP2DPmCZwq_s1Dx6xo9xWevRtsDZ5AQyvg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <54c7f0bf-7f6b-464e-0cce-b48ab1b05201@fb.com>
Date:   Mon, 5 Oct 2020 20:05:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <CAEf4BzYXXFtfR5LqNP2DPmCZwq_s1Dx6xo9xWevRtsDZ5AQyvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:16be]
X-ClientProxiedBy: MWHPR22CA0018.namprd22.prod.outlook.com
 (2603:10b6:300:ef::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::186f] (2620:10d:c090:400::5:16be) by MWHPR22CA0018.namprd22.prod.outlook.com (2603:10b6:300:ef::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 6 Oct 2020 03:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67027da2-32f9-480f-0b0b-08d869a4b3c2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25810CFC26B705750E2D23A6D30D0@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GiwedL3wHiGpymkA8iw75mlJhbtOTjYYERq4TekxN4je9r1m4HKCeqL2eiOlz5JYC8grp6IKuXhRoXMm9AoMZFXIP0KbpifmzU5GQC91+S4IbGXyw4QOR1is25QVB7U4yJ6i1+hXzVatVKsdQVu6FbhhF6l8E6TNUViQmi2BP14paSB09XfhWz3fLGReFqddrA19L9EBX33UafcZ2qmFkSSXr6OAzdbbCKok4rgIp82PbbHLuc1F7EB+cfuuInbSHSItQAt/nVRC96GDHSYBYJpAtj8ZaH568Y2KsW0incWdCGQOfItiFMjnXPiiiBtWl3O0LVRJnOJj2P1CoS7ZwxMCX2Q5zmM/mkdVvErxv/muFnX7I8G55+WwCpdRaYU6HDdBVkDWRNPo/7p9zCAn6GMQfW407nznhHO1unr2e+tjMpAdOCqHjNT/u32pmVDtxrPgh2X3u3cy2S2wxlVy/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83080400001)(6486002)(54906003)(53546011)(83380400001)(186003)(16526019)(5660300002)(4326008)(498600001)(31686004)(36756003)(52116002)(6916009)(2616005)(31696002)(8936002)(86362001)(966005)(2906002)(8676002)(66476007)(66946007)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RxxtgxzTVLfyqeUN6/HKyGS2BKBrvjx1ym5vqoNGzGGl7qf8oZo59pXmFcwBeipjPaa52gB3iaRbS23++FHnn8M4tdQbI7NyD+0mHx8CHWSAYw9NakQSW7nWIVT6UzmID/zTNG3EnnhVX2og77kGBjUf0AAT/Otus8R0KczvRtVw2rdQ9mEMfG65n3n5MK6B+nKRjsB4PPj21LgGDuio0/7r8xje+L1Gt9lPJlDn/2B4KniFCTGUJMhXDQzC0n3nN6/07zDpasPcTZsByIQkSPepuh/NyNOlgCA8MplCi/8ymXgmM4vSeE5gxIA0YHPZH3yNJ8qgd3BFLd7ttnfYNWNnYKuv+Z+aJFTUHzb36bkfTPwMvd09jmrbsUMgrtJqLyCA/EFN3d3hQwYFTX2xVX5d1RSlXbVoTyZdVdokXJVfXpauQuIMz7oCbA6qw/f+J+FJdKoB7492qASkCKNU7oMwRwZ+Ayovyb2DhyTcfA4twXUQHfgzv7jJlWiR8NyQ9xpdx/zxJZ2li2LjGA55nhd2451C8BRI/PTZVKTi214CrIeHu0Ve8QCRUTsJKFnqKqz4XOtAZMqPvQ4ZT3iIkqVwmIL0iLA3CIzN5c41bjc4GR9nMDEchjOy6c6VzdWOy3Zcl4+utDrjGUyMnD+i8+S4SirEJ+dV7KiZmkpx528=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67027da2-32f9-480f-0b0b-08d869a4b3c2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2020 03:05:38.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTYwM8IBueJbbephVAbtSAEKVF2a9No3WdrESHzlteelBwDuJFxYfICw/EMlCAfZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_01:2020-10-05,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010060018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/20 12:27 PM, Andrii Nakryiko wrote:
> On Fri, Oct 2, 2020 at 10:16 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 10/2/20 9:22 PM, Andrii Nakryiko wrote:
>>> On Fri, Oct 2, 2020 at 7:19 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> With latest llvm trunk, bpf programs under samples/bpf
>>>> directory, if using CORE, may experience the following
>>>> errors:
>>>>
>>>> LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.index
>>>> PLEASE submit a bug report to https://urldefense.proofpoint.com/v2/url?u=https-3A__bugs.llvm.org_&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8Pa1ZM&s=BwTAvhipPl-Az_WaiJDbqU8yl__NvG8W4HmCqWqHdqg&e=  and include the crash backtrace.
>>>> Stack dump:
>>>> 0.      Program arguments: llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
>>>> 1.      Running pass 'Function Pass Manager' on module '<stdin>'.
>>>> 2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on function '@bpf_prog1'
>>>>    #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&, int)
>>>>       (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x183c26c)
>>>> ...
>>>>    #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x17c375e)
>>>>    #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::SDNode*)
>>>>       (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16a75c5)
>>>>    #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm::SDNode*, unsigned char const*,
>>>>       unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16ab4f8)
>>>> ...
>>>> Aborted (core dumped) | llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
>>>>
>>>> The reason is due to llvm change https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D87153&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8Pa1ZM&s=fo_LvXqHJx_m0m0pJJiDdOUcOzVXm2_iYoxPhpqpzng&e=
>>>> where the CORE relocation global generation is moved from the beginning
>>>> of target dependent optimization (llc) to the beginning
>>>> of target independent optimization (opt).
>>>>
>>>> Since samples/bpf programs did not use vmlinux.h and its clang compilation
>>>> uses native architecture, we need to adjust arch triple at opt level
>>>> to do CORE relocation global generation properly. Otherwise, the above
>>>> error will appear.
>>>>
>>>> This patch fixed the issue by introduce opt and llvm-dis to compilation chain,
>>>> which will do proper CORE relocation global generation as well as O2 level
>>>> optimization. Tested with llvm10, llvm11 and trunk/llvm12.
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>    samples/bpf/Makefile | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>>>> index 4f1ed0e3cf9f..79c5fdea63d2 100644
>>>> --- a/samples/bpf/Makefile
>>>> +++ b/samples/bpf/Makefile
>>>> @@ -211,6 +211,8 @@ TPROGLDLIBS_xsk_fwd         += -pthread
>>>>    #  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>>>>    LLC ?= llc
>>>>    CLANG ?= clang
>>>> +OPT ?= opt
>>>> +LLVM_DIS ?= llvm-dis
>>>>    LLVM_OBJCOPY ?= llvm-objcopy
>>>>    BTF_PAHOLE ?= pahole
>>>>
>>>> @@ -314,7 +316,9 @@ $(obj)/%.o: $(src)/%.c
>>>>                   -Wno-address-of-packed-member -Wno-tautological-compare \
>>>>                   -Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
>>>>                   -I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
>>>> -               -O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
>>>> +               -O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
>>>> +               $(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
>>>> +               $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
> 
> This is an extremely unusual set of steps, and might be worthwhile to
> leave a comment explaining what's going on, so that I or someone else
> doesn't ask the same question few months later :)

Sure. Will add some comments and send v2.

> 
> At any rate, this fixes the issue, so:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
>>>
>>> I keep forgetting exact details of why we do this native clang + llc
>>> pipeline instead of just doing `clang -target bpf`? Is it still
>>
>> samples/bpf programs did not use vmlinux.h. they directly use
>> kernel-devel headers, hence they need to first compile with native arch
>> for clang but later change target arch to bpf to generate final byte code.
>> They cannot just do 'clang -target bpf' without vmlinux.h.
> 
> Ok, right, thanks for explanation. I wonder if this "native" clang +
> llc pass will also help with vmlinux.h on 32-bit architectures (though
> with my recent patches that shouldn't be necessary, so this is more of
> a curiosity, rather than the need).

Yes, I think this should help 32-bit as all the 32-bit long/ptr size is 
captured in IR. I probably tried before with 32bit x86 uprobe, but I 
forgot details...

> 
>>
>> But changing to use vmlinux.h is a much bigger project and I merely
>> want to make it just work so people won't make/compile samples/bpf
>> and get compilation errors.
> 
> Right, of course.
> 
>>
>>> relevant and necessary, or we can just simplify it now?
>>>
>>>>    ifeq ($(DWARF2BTF),y)
>>>>           $(BTF_PAHOLE) -J $@
>>>>    endif
>>>> --
>>>> 2.24.1
>>>>
