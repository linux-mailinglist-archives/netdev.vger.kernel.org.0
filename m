Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21B439EEF1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 08:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFHGtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 02:49:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34196 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhFHGtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 02:49:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1586hh9H023487;
        Mon, 7 Jun 2021 23:47:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jpfO9wA49iGPNcZYzi36c+0hr4BVIdcQmnE7/UF8l7I=;
 b=L6HvXV1hKxpdx6hLkAm/9FlLdB87fabnyMAWHHx/Yqsq/b5scaQqGkbqKB8d/OVvtP0e
 4VcfC5JUBDY8y4pwq+M+DLdCFRwB8NjEI/eKvKVFxB4KP5c5QzZ5c/tqlvFw4+I1YO7m
 voJdxFIvawIywqHDxv0yuHLeNjYmCd/BCTQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 391rhyk777-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 23:47:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 23:47:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idh0YBwc7fgtfiANH0PDl5gxmhkk3BEBx+wd9vmc8TD3EdG8gjbSJqk3MU4fhXIIcUYJZrl5UT5fA6LZquZxlNmwDwvg3sbeqRe/aHp60HYLz/aMIqb1YokR20JBsQjpEYd+3JiP/UG0PaMI8Eb/tGd81/RPyoyBLGg67GKzggaSV1u+UhDnK70ZhZoFqCewyh7WD/ArwzXZ7LFJk9TlaTRbRDKChu6JyR3gPoILlajVyPQ4zOMoeCMECHesED506Ydy62OIyMthhJvJPWRHI0Lk0ONA8JgT7NdIrEWp55yaXEhs4ZB2kGTPmS43CpzCk69cRICmJ+J9BtC/O1fi5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNLJwOY6Y18wb1L1FP4XhlEnqwwauGA+luEqjTqfuLg=;
 b=LYbUtSPmfl9nnsUQNkdWahfnHyJFttA1qY6Z7UAke9HxVwGWrf575gVewfu31Bo+tsHgsbze4RyZq9ZNIC+AaSMsoq0iozn762EIsEYX8gRNLuEjUklkRZUfALDbmslFeju57/DvAYu3SHPEBD3qpGiCmbgeSv4Bcn77fhgKzdBm2bNy7VZwb1OSLK/3oaU5UisMbsqxmZLS32uBTOGgycaPnTzzkVcaDOsl5JK7zceyvGqHQYU6NPrWzEZ/fY8jV0Oj38PKpVziGg9GrkpG8n9M3y5TqmJ6nqi9N1bptyNAZ8P2/azPV3dfTVtrIHEEhxFBgmtWuXE3ey8lZXHHtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4904.namprd15.prod.outlook.com (2603:10b6:806:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 06:47:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 06:47:11 +0000
Subject: Re: [PATCH v2 bpf-next 06/11] libbpf: add BPF static linker APIs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tom Stellard <tstellar@redhat.com>
CC:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20210313193537.1548766-7-andrii@kernel.org>
 <20210607231146.1077-1-tstellar@redhat.com>
 <CAEf4Bzad7OQj9JS7GVmBjAXyxKcc-nd77gxPQfFB8_hy_Xo+_g@mail.gmail.com>
 <b1bdf1df-e3a8-1ce8-fc33-4ab40b39fb06@redhat.com>
 <84b3cb2c-2dff-4cd8-724c-a1b56316816b@redhat.com>
 <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <43d9bd1c-fba6-f653-7374-cc593f01bc72@fb.com>
Date:   Mon, 7 Jun 2021 23:47:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:b270]
X-ClientProxiedBy: SJ0PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::7) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::108b] (2620:10d:c090:400::5:b270) by SJ0PR05CA0002.namprd05.prod.outlook.com (2603:10b6:a03:33b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 06:47:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 309bad1c-7dd5-4c44-4b72-08d92a493e1d
X-MS-TrafficTypeDiagnostic: SA1PR15MB4904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49040032DB99510838F38B98D3379@SA1PR15MB4904.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RVHv05esIE6KkAVdze6ijUfdA8jyDtixrgpyKQJ7NhXkw//oOFmOI4fQBhEuooNc5F91YA8KIQWPvotE51M9fAZdwy9dacEWp00DWWRpZZ8FuiB8xCjeEwY2O1r1cuzLoamqNfnf/tG/2pl88sF1gdFjTh6Y7OJ0aJfATn+I4A3KtMjMENbkxQU8YdkPaXewtto7Wk+7uYwD+dcuSrKEnKKcNtdM8A0NoCNg2bfNMkY3qQc364lf4NciiSurjnOkhRj300GwLO9xvIEBo86TlE6L3U4/cv2XDpJAsSymDP3HtvbNH1gYZ0tLfrOUu4exaqzu/knXgHNcneTFIkVWUASa6wEOyEh/eKUC7xDRs8HoR5QdxEKXI8/ig6+HbnpDsd5bw8JRWsJvoP070z1YhumCEdXDvl5QcEqonUVO6bJnaxClo8G63pvnFCLJ2/e7/QDiC1ekqc1Cs4JM/7ymvOIHtveTwLOPoAvEmEhuqyeiSwQt1lRzNLgnP3BoitHX9LA3mHduJP7NqInaKeonM6wuM/4CMUYaMBPt7Ptn640U36kF4Tj9aTPFjq9CE53wbHPCqxHkRs89QQvHNLk+TBILDYnzm1y31jIzgkI6yB3AM0Pcexlm8E2azt0tgs3A9WYUW0zG4Df+lOf1oQBdOSIWYwR+QGZCVK+z0FMicdLDCT7Gab3hhBXkyjc5gCzNl/RcIaAkU6aKfx00vy5mcTzp7k+kTZ1rzBAjZ3Wi+4eKjMue/jIo1D+XFqYf9VcNsQcVa9MA4g+NtpzsxLWgO0DIzRCJWY944jo/9ohCnTqNMNWnhoGdzn6BkLikT4j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(2616005)(31696002)(316002)(110136005)(5660300002)(6486002)(2906002)(66556008)(86362001)(53546011)(8936002)(186003)(16526019)(66476007)(54906003)(4326008)(66946007)(38100700002)(478600001)(83380400001)(31686004)(966005)(52116002)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: B8Icoh2EpIodmhI6NyBcnbN8e25YLi2fhtgA0d1eTHIdeg/c9kt74y3gVyWiwZVzM5bfojstsvqyC4f78jgJEjWKOGbIaDfxjVWW9z/s9p7gzklNajgM/08v8RWmmPiRWWYjgCTcwzM8cHa93MiV1l7NbmvR/w8C3UQM+nJhibPKEwl8xqvejC8XmYbjEkH6c36Tb6x+tuvUcq3y7bnYJvDmsEJGY4xzUEnfn3JnswxZNW0DA9yy8hbHa23Cilhmv4wwRAB8sFDKR5OPYissp6guvGjbw9UtTvUjZHKSXXXwCzPCLkorE3wceBpRUQ8uQ2y3vscc9mAFGbD11mPb5NarAX/dNUrbF8KEtuL10XaitKoFYV6XfPwnhw6OXSbo7KsAHtwp4ceK8ES3Mjk6qHoz7Z8N3EvUNDZrtsAJSaZqK1McJHC+a1IPQXg63TpVcIhU27i+M1FuOUKH1ejEjxyBHdzWy6PVDS6xQHW7DKTFzmN6l4rB2f1+O6nYD2epgiGwO4Ax68/XRKwgBbQW+6Xs6iWoG/JXc+g4WU96lCP3TQSGyfHfICI/AWj28aYRWYV/1tYOPg0ByMU/NdZAAWbcCF5+DppThFWxpl1lzy991xIJkUkGy5X/lYpYpSYXGlTUxSIdI6VFp5z8bDlANsjV8vb50bTXEVQUyLwPoJtR6+UWiGD21+xjHJ8Ok5ppj9lF9KkeN92olBMRG8HMAypZrMOqIID/Am2IAGapHA7SLMYVp1i5T64RnkOiDHC8+RkbhmBRucCwm9B2LTKOAg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 309bad1c-7dd5-4c44-4b72-08d92a493e1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 06:47:11.4171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U58bd2HwQytHdMZoTx+g9xKE40DTEKiNvRVYykNsgauSyY6MCUM4QRyayvarrEl1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4904
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kipMEtcmrlNfYlkoDSE4SyAw2n2bFhli
X-Proofpoint-ORIG-GUID: kipMEtcmrlNfYlkoDSE4SyAw2n2bFhli
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_05:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106080046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 9:08 PM, Andrii Nakryiko wrote:
> On Mon, Jun 7, 2021 at 7:41 PM Tom Stellard <tstellar@redhat.com> wrote:
>>
>> On 6/7/21 5:25 PM, Andrii Nakryiko wrote:
>>> On Mon, Jun 7, 2021 at 4:12 PM Tom Stellard <tstellar@redhat.com> wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>>> +                               } else {
>>>>> +                                       pr_warn("relocation against STT_SECTION in non-exec section is not supported!\n");
>>>>> +                                       return -EINVAL;
>>>>> +                               }
>>>>
>>>> Kernel build of commit 324c92e5e0ee are failing for me with this error
>>>> message:
>>>>
>>>> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen object /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.o
>>>> libbpf: relocation against STT_SECTION in non-exec section is not supported!
>>>>
>>>> What information can I provide to help debug this failure?
>>>
>>> Can you please send that bind_perm.o file? Also what's your `clang
>>> --version` output?
>>>
>>
>> clang version 12.0.0 (Fedora 12.0.0-2.fc35)
>>
>>>> I suspect this might be due to Clang commit 6a2ea84600ba ("BPF: Add
>>>> more relocation kinds"), but I get a different error on 324c92e5e0ee.
>>>> So meanwhile you might try applying 9f0c317f6aa1 ("libbpf: Add support
>>>> for new llvm bpf relocations") from bpf-next/master and check if that
>>>> helps. But please do share bind_perm.o, just to double-check what's
>>>> going on.
>>>>
>>
>> Here is bind_perm.o: https://fedorapeople.org/~tstellar/bind_perm.o
>>
> 
> So somehow you end up with .eh_frame section in BPF object file, which
> shouldn't ever happen. So there must be something that you are doing
> differently (compiler flags or something else) that makes Clang
> produce .eh_frame. So we need to figure out why .eh_frame gets
> generated. Not sure how, but maybe you have some ideas of what might
> be different about your build.

Tom,

I tried with latest release/12.x branch with top commit
   0826268d59c6 [PowerPC] Fix x86 vector intrinsics wrapper
                compilation under C++
and I cannot reproduce the issue.

$ clang --version
clang version 12.0.1 (https://github.com/llvm/llvm-project.git 
0826268d59c6e1bb3530dffd9dc5f6038774486d)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /home/yhs/work/llvm-project/llvm/build/install/bin

The following is my compilation flag, captured with
   make -C tools/testing/selftests/bpf -j60 V=1
$ cat log.sh
clang  -g -D__TARGET_ARCH_x86 -mlittle-endian 
-I/home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/include 
-I/home/yhs/work/bpf-next/tools/testing/selftests/bpf 
-I/home/yhs/work/bpf-next/tools/include/uapi 
-I/home/yhs/work/bpf-next/tools/testing/selftests/usr/include -idirafter 
/home/yhs/work/llvm-project/llvm/build.cur/install/lib/clang/13.0.0/include 
-idirafter /usr/local/include -idirafter /usr/include 
-Wno-compare-distinct-pointer-types -DENABLE_ATOMICS_TESTS -O2 -target 
bpf -c progs/bind_perm.c -o 
/home/yhs/work/bpf-next/tools/testing/selftests/bpf/bind_perm.o -mcpu=v3

Looking at progs/bind_perm.c, I can see
#include <linux/stddef.h>
#include <linux/bpf.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

So it included some system header files. Maybe some of these
header files changed some function attributes which triggered
.cfi_startproc/.cfi_endproc generation which enabled .eh_frame section
generation.

Maybe you can produce an .i file in your environment
so we can do some further analysis.

> 
>> Thanks,
>> Tom
>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Tom
>>>>>
>>>>
>>>
>>
