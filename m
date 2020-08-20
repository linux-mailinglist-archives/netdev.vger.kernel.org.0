Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6224AD43
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 05:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHTDXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 23:23:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbgHTDXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 23:23:53 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K3NT83010673;
        Wed, 19 Aug 2020 20:23:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XV6tVGQlmZvyp7GHZCVJuhF1YtgYJcv7KMEx5n0J5k0=;
 b=WUi2swl2mXV9OdNcoXSQGS1/q/HLPq1pFTQ5BHAs9K6c8j7wYF/lAXGbkKl67gCjLKXZ
 XUYlVZq5DuYp8FnpdIOY1FxqazfwrcnxZAnZBrbJ4W+o7ADUO2znDtq0kg7xn7R+OkBg
 TbzjhW/FMLlcFvo4A/ewEeCmF0cMMShO1T0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331crb8y8a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 20:23:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 20:23:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osc9Wg3qO1VjtJ5iiXsx7JEmAnTwUzVqZ/jIeH7pZR9gbQD5++l7IvfQRef6MCxsNQiXSM4tJDLo+nl2KW3c6r/G/i1Xg5N1ePJX52z5LzD6r9It3k/JoMHIkQAFnEA9uavXjVZvNSIHCftV4OAype0BAM+OXDOQN17pCz1yzfD77PBw0SekZsKlSBOor3b631DXOu6QzuCq0rEP3xheRMVcxtgCC8Wi2jkfv9zQ3LlgdDmxFtBKcgcOF3RH7vBGkbakN/1xA0o+tul7cb1YOnxI9+Ww2teFudg/N8m0pDlLZ3r3s2BYHIiZt7cOESaZtCEcCPs0zQ9bhtmNV+2wFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XV6tVGQlmZvyp7GHZCVJuhF1YtgYJcv7KMEx5n0J5k0=;
 b=YnK1+H0S+WL11pGhr/3OzenS0/M/1+fnkVrvf9ItN8NZmrH7JZwlY+tvIml2r+8PPigy6be/T5WMxCfT3hWiZISLawDZcnjxgqey5Hxi3laBnTZqdU/IZrip2woKyTJEtHnuFyw43PpBImSugcl1vBMr4IIrzIGdGM2am5+4drxhuhRIzre2oSUTx30r0f5m02BLpbfQD+pa8jFscg9RLYBKnQreSlJja7cdAAChtC0AXM6n/yc2pylM1v12l3f3d4vhXeR4KUJDJRF1pjuTeWSqMUBOx8uPMt0uJVdwUEHOExb1sYWxNDZ7pes66pNf9KylDc7EK/hb71aRYXxsvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XV6tVGQlmZvyp7GHZCVJuhF1YtgYJcv7KMEx5n0J5k0=;
 b=a/qZMVuIO9hxOfUF9QxppXIP37P7oc1jBuGMRu17vGw32IlpHVhG0fz75IGAH68eRC1RKw3YJmpAbTe/BcUerr095cScylpNDyu6qdANpwZC18PdSqb7DJbMXwcl2hezPNG77zH7fL7D9WlB6nA0j+4odJdtSvPca39x+TvBnRE=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3253.namprd15.prod.outlook.com (2603:10b6:a03:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Thu, 20 Aug
 2020 03:23:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 03:23:16 +0000
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
To:     =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mark Wielaard <mjw@redhat.com>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20200819092342.259004-1-jolsa@kernel.org>
 <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com> <20200819173618.GH177896@krava>
 <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
 <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
 <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
Date:   Wed, 19 Aug 2020 20:23:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:1330) by MN2PR15CA0060.namprd15.prod.outlook.com (2603:10b6:208:237::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 03:23:13 +0000
X-Originating-IP: [2620:10d:c091:480::1:1330]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c333d8bd-bb2f-4339-ac17-08d844b860db
X-MS-TrafficTypeDiagnostic: BYAPR15MB3253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32536C61FF362D3FAF276D1DD35A0@BYAPR15MB3253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uh2OXCieiz8me0wwlIj55QMp2DsyR+bXnHOy5pHfhN1bT7dqKc0+9lxbqpCwwXkQD7l7f/z4iIVau4SFbmgLyprQmA+Si4LZYuQSvrrEBl8kq08wfW4yTO6x/lpjtRSwD3JG99ae36vsq0VvDh+dUzWcnKOqAeRFPAT5RA1ucyvysjj845KVWqANZHfHig1q4+1tDXkshJDZ/u3JJ/woc2m1Oaemj7m+Bt8NIulz7sWW6ETJo5j8zKYCi/W2Brm61S9xC0lUvLjZNieYgWXPFBJ4p7IXeENro7q7FjJtOszuU9xFYPXp+qgeTlaykzjbDqatuRegA831LklxbC9Pti4lkEhroE6M5tP+5AoD1Fwa5g9tnmW6ectnrI0j5vPU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(6486002)(2906002)(31696002)(66574015)(16526019)(186003)(7416002)(52116002)(5660300002)(53546011)(478600001)(2616005)(83380400001)(31686004)(8936002)(54906003)(66556008)(36756003)(66476007)(66946007)(86362001)(316002)(110136005)(8676002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9deZNCZOwqnEoQ7JUNOi9DjwXzFBoWgKmtxGhE/dx4mo6Dzff8vVpJDPd0yCxZDPbaz/ISZSAe45CmoglvsWAHZJfVFFWgcaGfTmYX2kBN/GfOI9He6VaYbjK7OxhwABjKRiZTxmBggiEicQVrlF3CDrX7M2kkwLU/c/C4O9C4yp7jTyAYSkuoCrWjupYSPxNtcEqsDSnIt3AjwLvd+4cc4Y+xoY2lEVy7Lu5iKgvzYkEfmYKyM8bEJFdqNb29XuYnTLAz4Pu4rhELy7OuOPnFZsAT+gBmuit9WVfJNkQvQcV8QFCGRs6J2e1tKQwb0aZC91lAuY34ezT+A4gsLSlteWF4Bv+RXN4rjo9kXiCPW3VT9oCIk+OOb1o1l/y2F9AzM4/+Ki0miW+Y51N+5r6NrZNZXi2cW2famUMECCM5UhdifBECZI9BligStE0+STyG6X7goOD4rO1x2yPy8cNeQWXMe4DLk2Xv3We9WzOD4psFmJL4lAjiTWZBdvMVNwwWlMxYiQjsK/euU+QBriqAD++1h+/mTHtdETdqjWbT4XkbCUh7DhFDyoFUD1nHzE6sJWO8WC4zS6nsxD/FgTA1bU9GRBE/iypiAgXpWYqm0OOOx6QqGVVjBBoy7R9BamH5BHX6+SnMU8NTMMZI75bBuBhwaAjh0NnblUM/SR5aQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: c333d8bd-bb2f-4339-ac17-08d844b860db
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 03:23:16.5503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgvEc8zhduT88y35IU/+bZoSdiKfJNxtzX1TmxflN1I2PPQ/booMo4trOhYsZ4tH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 7:27 PM, Fāng-ruì Sòng wrote:
>>>>     section(36) .comment, size 44, link 0, flags 30, type=1
>>>>     section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 16, expected 8
>>>>     section(38) .debug_info, size 129104957, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 1, expected 8
>>>>     section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 1, expected 8
>>>>     section(40) .debug_line, size 7374522, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 1, expected 8
>>>>     section(41) .debug_frame, size 702463, link 0, flags 800, type=1
>>>>     section(42) .debug_str, size 1017571, link 0, flags 830, type=1
>>>>      - fixing wrong alignment sh_addralign 1, expected 8
>>>>     section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 1, expected 8
>>>>     section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
>>>>      - fixing wrong alignment sh_addralign 16, expected 8
>>>>     section(45) .symtab, size 2955888, link 46, flags 0, type=2
>>>>     section(46) .strtab, size 2613072, link 0, flags 0, type=3
> 
> I think this is resolve_btfids's bug. GNU ld and LLD are innocent.
> These .debug_* sections work fine if their sh_addralign is 1.
> When the section flag SHF_COMPRESSED is set, the meaningful alignment
> is Elf64_Chdr::ch_addralign, after the header is uncompressed.
> 
> On Wed, Aug 19, 2020 at 2:30 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/19/20 11:16 AM, Nick Desaulniers wrote:
>>> On Wed, Aug 19, 2020 at 10:36 AM Jiri Olsa <jolsa@redhat.com> wrote:
>>>>
>>>> On Wed, Aug 19, 2020 at 08:31:51AM -0700, Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 8/19/20 2:23 AM, Jiri Olsa wrote:
>>>>>> The data of compressed section should be aligned to 4
>>>>>> (for 32bit) or 8 (for 64 bit) bytes.
>>>>>>
>>>>>> The binutils ld sets sh_addralign to 1, which makes libelf
>>>>>> fail with misaligned section error during the update as
>>>>>> reported by Jesper:
>>>>>>
>>>>>>       FAILED elf_update(WRITE): invalid section alignment

Jiri,

Since Fangrui mentioned this is not a ld/lld bug, then changing
alighment from 1 to 4 might have some adverse effect for the binary,
I guess.

Do you think we could skip these .debug_* sections somehow in elf 
parsing in resolve_btfids? resolve_btfids does not need to read
these sections. This way, no need to change their alignment either.

Yonghong

>>>>>>
>>>>>> While waiting for ld fix, we can fix compressed sections
>>>>>> sh_addralign value manually.
>>>
>>> Is there a bug filed against GNU ld? Link?
>>>
>>>>>>
>>>>>> Adding warning in -vv mode when the fix is triggered:
>>>>>>
>>>>>>      $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
>>>>>>      ...
>>>>>>      section(36) .comment, size 44, link 0, flags 30, type=1
>>>>>>      section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 16, expected 8
>>>>>>      section(38) .debug_info, size 129104957, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 1, expected 8
>>>>>>      section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 1, expected 8
>>>>>>      section(40) .debug_line, size 7374522, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 1, expected 8
>>>>>>      section(41) .debug_frame, size 702463, link 0, flags 800, type=1
>>>>>>      section(42) .debug_str, size 1017571, link 0, flags 830, type=1
>>>>>>       - fixing wrong alignment sh_addralign 1, expected 8
>>>>>>      section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 1, expected 8
>>>>>>      section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
>>>>>>       - fixing wrong alignment sh_addralign 16, expected 8
>>>>>>      section(45) .symtab, size 2955888, link 46, flags 0, type=2
>>>>>>      section(46) .strtab, size 2613072, link 0, flags 0, type=3
>>>>>>      ...
>>>>>>      update ok for vmlinux
>>>>>>
>>>>>> Another workaround is to disable compressed debug info data
>>>>>> CONFIG_DEBUG_INFO_COMPRESSED kernel option.
>>>>>
>>>>> So CONFIG_DEBUG_INFO_COMPRESSED is required to reproduce the bug, right?
>>>>
>>>> correct
>>>>
>>>>>
>>>>> I turned on CONFIG_DEBUG_INFO_COMPRESSED in my config and got a bunch of
>>>>> build failures.
>>>>>
>>>>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
>>>>> decompress status for section .debug_info
>>>>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
>>>>> decompress status for section .debug_info
>>>>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
>>>>> decompress status for section .debug_info
>>>>> ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize
>>>>> decompress status for section .debug_info
>>>>> drivers/crypto/virtio/virtio_crypto_algs.o: file not recognized: File format
>>>>> not recognized
>>>>>
>>>>> ld: net/llc/llc_core.o: unable to initialize decompress status for section
>>>>> .debug_info
>>>>> ld: net/llc/llc_core.o: unable to initialize decompress status for section
>>>>> .debug_info
>>>>> ld: net/llc/llc_core.o: unable to initialize decompress status for section
>>>>> .debug_info
>>>>> ld: net/llc/llc_core.o: unable to initialize decompress status for section
>>>>> .debug_info
>>>>> net/llc/llc_core.o: file not recognized: File format not recognized
>>>>>
>>>>> ...
>>>>>
>>>>> The 'ld' in my system:
>>>>>
>>>>> $ ld -V
>>>>> GNU ld version 2.30-74.el8
>>>>>     Supported emulations:
>>>>>      elf_x86_64
>>>>>      elf32_x86_64
>>>>>      elf_i386
>>>>>      elf_iamcu
>>>>>      i386linux
>>>>>      elf_l1om
>>>>>      elf_k1om
>>>>>      i386pep
>>>>>      i386pe
>>>
>>> According to Documentation/process/changes.rst, the minimum supported
>>> version of GNU binutils for the kernels is 2.23.  Can you upgrade to
>>> that and confirm that you still observe the issue?  I don't want to
>>> spend time chasing bugs in old, unsupported versions of GNU binutils,
>>> especially as Jiri notes, 2.26 is required for
>>> CONFIG_DEBUG_INFO_COMPRESSED.  We can always strengthen the Kconfig
>>> check for it.  Otherwise, I'm not familiar with the observed error
>>> message.
>>
>> I built a "ld" with latest binutils-gdb repo and I can reproduced
>> the issue. Indeed applying the patch here fixed the issue. So
>> I think there is no need to investigate since upstream exhibits
>> the exact issue described here.
>>
>>>
>>>>> $
>>>>>
>>>>> Do you know what is the issue here?
>>>>
>>>> mine's: GNU ld version 2.32-31.fc31
>>>>
>>>> there's version info in commit:
>>>>     10e68b02c861 Makefile: support compressed debug info
>>>>
>>>>     Compress the debug information using zlib.  Requires GCC 5.0+ or Clang
>>>>     5.0+, binutils 2.26+, and zlib.
>>>>
>>>> cc-ing Nick Desaulniers, author of that patch.. any idea about the error above?
>>>>
>>>> thanks,
>>>> jirka
>>>>
>>>
>>>
> 
> 
> 
