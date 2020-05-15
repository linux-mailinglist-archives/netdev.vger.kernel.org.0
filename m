Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D481D5996
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgEOTBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:01:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgEOTBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:01:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FIraLY018303;
        Fri, 15 May 2020 12:00:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wo/YYfXQObid7TwnMq8b03mZqwQBMc5xnc5ThzRvb20=;
 b=FhcEGn4Us9wiu+WGWFdPUnh5pn6SkbpOCJ7VEIqtwtlQ5a9jYRCxvuCkoYPI+QOWa1bn
 sTAOCfSXSEW8y74Bx4YYLebHbQPjlFkgmQAEnB/FWP8XPnztgk7iQKhYjw+aFr7UeWxm
 z8AiyZHyS3jqliSYCAGcM1uydWCvI8CZ2sA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 311v2b1rnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 May 2020 12:00:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 15 May 2020 11:59:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX1XjojyITmC2AYcYTPQhBp4SmZcMXVAA0HOmZ58ke6AEly+2fS80cn/w7viyBDIRbHwZ2Um+cXc7UrI5hIeMR6U/DHv/0PkUGLThYXuuDHITK1ROcnbGuqxWWhU6BRUQ6/7SzPSx1hAq9KOhV1YSFcgD/VH/z0a+4bmCDJ/EaZfjUSf8bUYhwY4YUnQ5MXSU5UlY1zFQy0WiTGcXt7by/1grrUATFEGIgahFsTULIxNgztZ65fC/EWw3KMeJGLmoQBtjDpGshmJD/rPLdkVNBjGKFX6rJFuhy4mfvRQGg7yet80fU5bBhCIijoUNb04QWA/SKNp4or8czJoZRFTXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo/YYfXQObid7TwnMq8b03mZqwQBMc5xnc5ThzRvb20=;
 b=bXcKpaBiZ29Y1ks6PCfV7Vgnzux43WHVN4aeyyQFpopuQVYYaWomQbF/PTbEnEOFIw7x8SOIw/F9GHcm+LRWBPpASBQ0uLpH51y67q9NOkWyPg4sHEzknIVMWZknL0ECRqRIQvDqzb+bufRBiightE6kRnEBsWCjYUXsBukTo8h4fpBOdFL4GD7eMkfYCKe2R0gsqyfP6j2WOyACD8b94KU1OLJiMks6WvTursh4nmDSV8X+WMhLjA7hpKoLXu6ujpTioSPUpbfPB3RuF968AYMfNpYKTCQjP/sxKD+SSepWyBAQ9B5+0ri+TDFmoS14svOT2WO6H6UKimUMKzpNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo/YYfXQObid7TwnMq8b03mZqwQBMc5xnc5ThzRvb20=;
 b=B51lbI/t8UCCu7UjfFBeivXM5/ftFJhp4+wwl/56xsJJH+z8Gw/rpp1WGNlgtNefLnzp9r8Hx/sKFjj8i1VJjzRDojXz5KGH1z61C9VhiEepQp9qsAko8/yYh+KQ7X3BNDnrsKuePok2Z/nwyDQBrfgaakOrPyf25XWDkFYoUqc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2680.namprd15.prod.outlook.com (2603:10b6:a03:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Fri, 15 May
 2020 18:59:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 18:59:53 +0000
Subject: Re: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type printing
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c219a1ef-0fb0-ffde-745f-35d8b0b9a08a@fb.com>
Date:   Fri, 15 May 2020 11:59:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0031.prod.exchangelabs.com (2603:10b6:a02:80::44)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:a296) by BYAPR01CA0031.prod.exchangelabs.com (2603:10b6:a02:80::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Fri, 15 May 2020 18:59:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:a296]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4025065-6b00-47a2-4bf2-08d7f90226ce
X-MS-TrafficTypeDiagnostic: BYAPR15MB2680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2680C017016A0E580C7BC6E2D3BD0@BYAPR15MB2680.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7K1jKFtNQVLXBjSKUce3np9FyRQBvOL28ZKtVtfKLJR9A4Oyxg666ziefSzDQJsT7AtwxHQS5UVAmX2Q428Y79nK2rCCxnUJUu+vsvPd9oxIPPv2GoXPUkfUH7OmqTKasLPtrzyj6S0M/KK2Sx3/m719pU5dc1my7G2HYzljUnfE7ngWjzkoxewgZx78qoYAFgVILv8tT0ihHHXBdHYqNTUzTwLKWz0a24i2xZrsWAfGpytkAGHUlwWVcLPhz/KRARz7FzKaw6LUbf/GguM5kbaIniH36sgHxFzaxUD4qgy1cpI7X81FkW1MW7WsPEL4y4eBxicmEQsfW5pxsGb4q+l1v0lRNd54iYcMUPMZtTFJM6/HO0lptW9oXZjZuTqzTGB8O0c2rwngDxRZYFgXUYMhOOUNuwqrAz8JKa944/AUYuKlki7aOqpkwCYyA4/OmglI+1YKbngQZWT0xosMs6R4BCDjnX5iUeky5+uZQa5bebR5TFgYBbHggRsgud5XFO7LVEbVIRYHcxipBXT4haDjRqR7cLlydHQVKOlUZj2LgvYBmiIFvFSO+vOi6RjzYbKavANzRqauWJtQiFaInw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(2906002)(6512007)(478600001)(53546011)(6506007)(5660300002)(8936002)(52116002)(7416002)(86362001)(36756003)(8676002)(2616005)(31696002)(316002)(31686004)(966005)(16526019)(66946007)(66476007)(110136005)(66556008)(186003)(4326008)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MRfUAcNRosvbcj41Amvvrcvnt4raN3lqqjackUUOrT2jQiH2UExC98zGgTkRZxvNlKyeX9zDWeeAhcX/oHH+rIp9J0HWkxoGlJIbTxIb9lnoY6abTRGyIG70qfdVApO6pH9A7hKaKDneucw0q9LnYW4r4ZG1F/A751ouVKBhqGxpor/HZ4Vfgw2hMJ/Na3xn6cKSDemrdoDdpeFenT+0f3WK6bE1Yw4G3E/TFTG5NXWv1PiAZJ0Www25o1S0sqSWXjorvvKAZtdsAkqU+h3Typ736JYk/CYlX7y7Uy8q2ofbnhs71LogYVwX6GDLkKTjg5seEky+C84MgG21Zgc8txH//LGItLKC9PnK26jFMMIfjP2MkHbiq6asuJjysQ8icAyu3zFKlYVwejvwozQfRehjx5lj9V2hLLUjYWRe1Q93B5nmI4TPmBeih6pALd2+95fZ6tKS0jaU/pHxrowIWPTxjD9K95NVtRohSgo2UB8JikW7R3s52cWRfki2BkHGfkhNtuAnQUqAVzfWQrL7sg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e4025065-6b00-47a2-4bf2-08d7f90226ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 18:59:53.5407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0puyVdejiGyMcDB1jvf3LQgjoLpBV5pLj1RWBgKuilmocSpKp2hR/s/jTwDToCGM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2680
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 cotscore=-2147483648 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 3:24 PM, Alexei Starovoitov wrote:
> On Tue, May 12, 2020 at 06:56:38AM +0100, Alan Maguire wrote:
>> The printk family of functions support printing specific pointer types
>> using %p format specifiers (MAC addresses, IP addresses, etc).  For
>> full details see Documentation/core-api/printk-formats.rst.
>>
>> This patchset proposes introducing a "print typed pointer" format
>> specifier "%pT"; the argument associated with the specifier is of
>> form "struct btf_ptr *" which consists of a .ptr value and a .type
>> value specifying a stringified type (e.g. "struct sk_buff") or
>> an .id value specifying a BPF Type Format (BTF) id identifying
>> the appropriate type it points to.
>>
>> There is already support in kernel/bpf/btf.c for "show" functionality;
>> the changes here generalize that support from seq-file specific
>> verifier display to the more generic case and add another specific
>> use case; snprintf()-style rendering of type information to a
>> provided buffer.  This support is then used to support printk
>> rendering of types, but the intent is to provide a function
>> that might be useful in other in-kernel scenarios; for example:
>>
>> - ftrace could possibly utilize the function to support typed
>>    display of function arguments by cross-referencing BTF function
>>    information to derive the types of arguments
>> - oops/panic messaging could extend the information displayed to
>>    dig into data structures associated with failing functions
>>
>> The above potential use cases hint at a potential reply to
>> a reasonable objection that such typed display should be
>> solved by tracing programs, where the in kernel tracing records
>> data and the userspace program prints it out.  While this
>> is certainly the recommended approach for most cases, I
>> believe having an in-kernel mechanism would be valuable
>> also.
>>
>> The function the printk() family of functions rely on
>> could potentially be used directly for other use cases
>> like ftrace where we might have the BTF ids of the
>> pointers we wish to display; its signature is as follows:
>>
>> int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
>>                             char *buf, int len, u64 flags);
>>
>> So if ftrace say had the BTF ids of the types of arguments,
>> we see that the above would allow us to convert the
>> pointer data into displayable form.
>>
>> To give a flavour for what the printed-out data looks like,
>> here we use pr_info() to display a struct sk_buff *.
>>
>>    struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>>
>>    pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
>>
>> ...gives us:
>>
>> (struct sk_buff){
>>   .transport_header = (__u16)65535,
>>   .mac_header = (__u16)65535,
>>   .end = (sk_buff_data_t)192,
>>   .head = (unsigned char *)000000007524fd8b,
>>   .data = (unsigned char *)000000007524fd8b,
> 
> could you add "0x" prefix here to make it even more C like
> and unambiguous ?
> 
>>   .truesize = (unsigned int)768,
>>   .users = (refcount_t){
>>    .refs = (atomic_t){
>>     .counter = (int)1,
>>    },
>>   },
>> }
>>
>> For bpf_trace_printk() a "struct __btf_ptr *" is used as
>> argument; see tools/testing/selftests/bpf/progs/netif_receive_skb.c
>> for example usage.
>>
>> The hope is that this functionality will be useful for debugging,
>> and possibly help facilitate the cases mentioned above in the future.
>>
>> Changes since v1:
>>
>> - changed format to be more drgn-like, rendering indented type info
>>    along with type names by default (Alexei)
>> - zeroed values are omitted (Arnaldo) by default unless the '0'
>>    modifier is specified (Alexei)
>> - added an option to print pointer values without obfuscation.
>>    The reason to do this is the sysctls controlling pointer display
>>    are likely to be irrelevant in many if not most tracing contexts.
>>    Some questions on this in the outstanding questions section below...
>> - reworked printk format specifer so that we no longer rely on format
>>    %pT<type> but instead use a struct * which contains type information
>>    (Rasmus). This simplifies the printk parsing, makes use more dynamic
>>    and also allows specification by BTF id as well as name.
>> - ensured that BTF-specific printk code is bracketed by
>>    #if ENABLED(CONFIG_BTF_PRINTF)
> 
> I don't like this particular bit:
> +config BTF_PRINTF
> +       bool "print type information using BPF type format"
> +       depends on DEBUG_INFO_BTF
> +       default n
> 
> Looks like it's only purpose is to gate printk test.
> In such case please convert it into hidden config that is
> automatically selected when DEBUG_INFO_BTF is set.
> Or just make printk tests to #if IS_ENABLED(DEBUG_INFO_BTF)
> 
>> - removed incorrect patch which tried to fix dereferencing of resolved
>>    BTF info for vmlinux; instead we skip modifiers for the relevant
>>    case (array element type/size determination) (Alexei).
>> - fixed issues with negative snprintf format length (Rasmus)
>> - added test cases for various data structure formats; base types,
>>    typedefs, structs, etc.
>> - tests now iterate through all typedef, enum, struct and unions
>>    defined for vmlinux BTF and render a version of the target dummy
>>    value which is either all zeros or all 0xff values; the idea is this
>>    exercises the "skip if zero" and "print everything" cases.
>> - added support in BPF for using the %pT format specifier in
>>    bpf_trace_printk()
>> - added BPF tests which ensure %pT format specifier use works (Alexei).
>>
>> Outstanding issues
>>
>> - currently %pT is not allowed in BPF programs when lockdown is active
>>    prohibiting BPF_READ; is that sufficient?
> 
> yes. that's enough.
> 
>> - do we want to further restrict the non-obfuscated pointer format
>>    specifier %pTx; for example blocking unprivileged BPF programs from
>>    using it?
> 
> unpriv cannot use bpf_trace_printk() anyway. I'm not sure what is the concern.
> 
>> - likely still need a better answer for vmlinux BTF initialization
>>    than the current approach taken; early boot initialization is one
>>    way to go here.
> 
> btf_parse_vmlinux() can certainly be moved to late_initcall().
> 
>> - may be useful to have a "print integers as hex" format modifier (Joe)
> 
> I'd rather stick to the convention that the type drives the way the value is printed.
> For example:
>    u8 ch = 65;
>    pr_info("%pT", BTF_PTR_TYPE(&ch, "char"));
>    prints 'A'
> while
>    u8 ch = 65;
>    pr_info("%pT", BTF_PTR_TYPE(&ch, "u8"));
>    prints 65
> 
>>
>> Important note: if running test_printf.ko - the version in the bpf-next
>> tree will induce a panic when running the fwnode_pointer() tests due
>> to a kobject issue; applying the patch in
>>
>> https://lkml.org/lkml/2020/4/17/389
> 
> Thanks for the headsup!
> 
> BTF_PTR_ID() is a great idea as well.
> In the llvm 11 we will introduce __builtin__btf_type_id().
> The bpf program will be able to say:
> bpf_printk("%pT", BTF_PTR_ID(skb, __builtin_btf_type_id(skb, 1)));
> That will help avoid run-time search through btf types by string name.
> The compiler will supply btf_id at build time and libbpf will do
> a relocation into vmlinux btf_id prior to loading.

Hi, Just for your information, __builtin_btf_type_id() helper has been
merged in llvm trunk.

https://github.com/llvm/llvm-project/commit/072cde03aaa13a2c57acf62d79876bf79aa1919f

For the above case, you can do
   bpf_printk("%pT", BTF_PTR_ID(skb, __builtin_btf_type_id(*skb, 1)));

Basically,
   __builtin_btf_type_id(*skb, 1)
is to
    - return the type of "*skb", i.e., struct sk_buff
    - generate a relocation (against vmlinux) for this type id

The libbpf work is needed, not implemented yet, for the relocation
to actually happen.

__builtin_btf_type_id(skb, 1) will return a type for "skb" which
is a pointer type to "struct sk_buff".

> 
> Also I think there should be another flag BTF_SHOW_PROBE_DATA.
> It should probe_kernel_read() all data instead of direct dereferences.
> It could be implemented via single probe_kernel_read of the whole BTF data
> structure before pringing the fields one by one. So it should be simple
> addition to patch 2.
> This flag should be default for printk() from bpf program,
> since the verifier won't be checking that pointer passed into bpf_trace_printk
> is of correct btf type and it's a real pointer.
> Whether this flag should be default for normal printk() is arguable.
> I would make it so. The performance cost of extra copy is small comparing
> with no-crash guarantee it provides. I think it would be a good trade off.
> 
> In the future we can extend the verifier so that:
> bpf_safe_printk("%pT", skb);
> will be recognized that 'skb' is PTR_TO_BTF_ID and corresponding and correct
> btf_id is passed into printk. Mistakes will be caught at program
> verification time.
> 
