Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562E24A40D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgHSQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:25:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbgHSQZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:25:28 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JGKm1r003493;
        Wed, 19 Aug 2020 09:25:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+XHedlqRkAw0oYC1pNmjtVTIVqIMLLF1DfJsEUqelsU=;
 b=HaDGaMpN/8tBL4N/sdwfwNyefF/zhSljOWZ/If8pQ3ly2szjXpz/Ml+yj5tHw46Nu4Oc
 Kan1jJlOltu397QGv7gJMZJ8xwMnewtvPLHoC3VbJ9+XyM4L1axFSer7lhya/L0bQv2F
 WgLd1nuqhRhkdbhkQKi/RH7y+c8Ccrn6SD8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3hbx3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 09:25:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 09:25:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+vVjCGtpF/5ylo1+pvoyxFvS4RvXh2ohhxz+lcAl+eCoeGXSVjUlWljYt8je/FUXxKK4/cp02ESvwpxwizcHSrv0wLlx0nb/YWh6ZO9ZVsVq3OwRLuv26DRPfE8g1AS+LQ1ophXRkR9EW0DCeeJcPUSdkm9VmbUXFEz0Aa0LXKvWTe+oia3/h9/d7To+u3SiN0cKynCZv2mhy+B4302uQ7n7i9LN5XGFxIchpwQWfj1iPbjw82Y2/lo8M98ayg3C4kovDJrTj4MGKJ/Tth+7HLBBpT0B5D8HHukVxbguynCdDukbZBU92HbqOFTNvz/KgopLo3IZIYDDysqsBpquA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XHedlqRkAw0oYC1pNmjtVTIVqIMLLF1DfJsEUqelsU=;
 b=My1aTT6ra15hwcNRy1D9wt1tavu4qmxiTOPiGxw+itqG1WpHe+klBLKgY0Fho8lGR3wJwLGe4r2p7U7LSD1uFdIdqBitYyf1SRr/Wy+5uu7F9XrX51q7VkCm0JyzQ2FcV0zBYxdJnmzqqN3TWmo5oFYsS7AKKZWRyFkQNsGHQmfSeTIM+lHGoKDSoDdjDLIEuuckw46G7MI7cRa0js0RROwOrnZY+aapwSrOl9NCqFLe6vOsHDh0daYJ8dvCJk6Z/ag65nWPftPWsHA4SpoAjPy9F9luaN3k7LIUfy0at/kKfLYydH93RWZaTemod1BQQdgZKtTeHxcjtGB4MCM3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XHedlqRkAw0oYC1pNmjtVTIVqIMLLF1DfJsEUqelsU=;
 b=ErgqlP16mLruL9QCin4QCT8fkcScYqCJ2ibRSfJ2xYauG/APc96jNtZm9jHJzGSjqFsMLmWaFcZ/8UiDi+1OqrEEJyFU63AqMD/vkQyBSgbeAh7/nMBM17Ndi+Px55IMqi8OoZVNti0ANttpMiWCqnkEAru4h+is93XeR8q+8E4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2581.namprd15.prod.outlook.com (2603:10b6:a03:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 19 Aug
 2020 16:25:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 16:25:02 +0000
Subject: Re: [PATCH v2 bpf-next 0/5] Add support for type-based and enum
 value-based CO-RE relocations
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200819052849.336700-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e2cd666b-4b97-141f-6925-fc00d8b4aa5f@fb.com>
Date:   Wed, 19 Aug 2020 09:24:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819052849.336700-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:c0::39) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by MN2PR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:c0::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.16 via Frontend Transport; Wed, 19 Aug 2020 16:25:00 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b60fab7-2c26-4e7c-1255-08d8445c6c77
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25818144370D8D6FB6BD8522D35D0@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zGpJfLgDrlWVu2MZCyRNiPO2pJrm7IThelDhRwMB6mXqz5oFo2vxfgsYGjgmQvjwXb+QPxseClMVI0LTVuy+4p6+FcQheMjimBBj9Pb7d9iuQx2EqUU2JT3W/xa5ct9g6xSLpIEKuEneQ/FGrgNuaYG5DacJBdPFiB0Zm13wEePUB/o0EgMYSw3BlqS5pkrRWvMbCPsdocvyp6Fff3EFyubxgmuyCut4ZOkfucxxKjrzZ3P23F48vqEXoGkYGzUz3xPjNp4+DTC2KoaIS5y84DzOqQSO0cAxUe2qXaN+QZu3VGp/Q1FHwHWlmCmNKZhXcNabDCIDEiQY6whrcGEXQ/aaYWiy8wZeN5hVbEfwxXuQtxDRuMKvD28Tjw/qr4FyeQ73GMp9ls6X+vmpnqkVKtwLizbSnQLw3ZVKG6xOccZaNbgHinH6rF8hktDC/sVaNrDhUeeWbIB5iSGo9e5sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(4326008)(52116002)(83380400001)(31696002)(186003)(6486002)(36756003)(53546011)(8676002)(16526019)(316002)(5660300002)(8936002)(2616005)(966005)(478600001)(66476007)(6666004)(86362001)(66946007)(2906002)(31686004)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dEn1lYvc/tP6Gm7m3PffAvcLn0ZzvDJIXcV5MJv+3vPkSl88UVmLN9WIFKwRimlaKq+MN4ImDRbcRN9mM0hdrLfnFxDv+Wn5tJ2oj0HOEAqe9Q8N1iRjmhcoHo6C1CtylpoU0zUigTYRWekxKJwQ/eCn4P5g5A6SMkDb/GaNaFirmQt38S+pf+iAs1T4t6VYbzKC+4G+y6BLE7OTaVEiH2f1hRxx+2l0MiRP4Myv5KAMAL9NX3sg+ybkquYtfVA6G5C8q7zptlkuMWJ0VKWKvDi3WvPRDM/D0ZQQlVffy/rBF1o+uf0rJ7Gc/MT6Wbkfmb/JHjE3+3iPZcXYgaIY1br9RMHrWFmgR13MIWzT33rRDnJPe8KltsbxjGChZGRI1nYH+4jn+Fkjg1e5kXiYJ5VLNL8cXhbFG14mGGp9YSIypR6Hpj8pl6RT7k4z9jwsxLEuk8Q8zc9bLz8aFX1W5OuTad4D8GGLoY4AeUPDT/f7VUnypKepGvE/zX/mTIdSCfE/qr4UB1DOpP3qEBdmEwWoEC4Fb8ZUHMACWJOUAUhZ77hRBA1RDHFpGSry+e6HKjVsmkmgzePX5eELzRfg8uiJvggo12LP7v4kN5fCWntGB6wWH/Fx8a67UFhet+1+mQWNQD9KkvdHi+zHg8314jvfJJTmuIRDuNXsLj49+XRactzIAjOVNHocvhDfkBnJ
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b60fab7-2c26-4e7c-1255-08d8445c6c77
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 16:25:02.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPYmmF+rXskIhJ8yGPow78YIiTxprNiQW55jss+RPUFOWCZlOBMNYBu021+W5dJ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> This patch set adds libbpf support for two new classes of CO-RE relocations:
> type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
> value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
>    - TYPE_EXISTS allows to detect presence in kernel BTF of a locally-recorded
>      BTF type. Useful for feature detection (new functionality often comes with
>      new internal kernel types), as well as handling type renames and bigger
>      refactorings.
>    - TYPE_SIZE allows to get the real size (in bytes) of a specified kernel
>      type. Useful for dumping internal structure as-is through perfbuf or
>      ringbuf.
>    - TYPE_ID_LOCAL/TYPE_ID_TARGET allow to capture BTF type ID of a BTF type in
>      program's BTF or kernel BTF, respectively. These could be used for
>      high-performance and space-efficient generic data dumping/logging by
>      relying on small and cheap BTF type ID as a data layout descriptor, for
>      post-processing on user-space side.
>    - ENUMVAL_EXISTS can be used for detecting the presence of enumerator value
>      in kernel's enum type. Most direct application is to detect BPF helper
>      support in kernel.
>    - ENUMVAL_VALUE allows to relocate real integer value of kernel enumerator
>      value, which is subject to change (e.g., always a potential issue for
>      internal, non-UAPI, kernel enums).
> 
> I've indicated potential applications for these relocations, but relocations
> themselves are generic and unassuming and are designed to work correctly even
> in unintended applications. Furthermore, relocated values become constants,
> known to the verifier and could and would be used for dead branch code
> detection and elimination. This makes them ideal to do all sorts of feature
> detection and guarding functionality that's not available on some older (but
> still supported by BPF program) kernels, while having to compile and maintain
> one unified source code.
> 
> Selftests are added for all the new features. Selftests utilizing new Clang
> built-ins are designed such that they will compile with older Clangs and will
> be skipped during test runs. So this shouldn't cause any build and test
> failures on systems with slightly outdated Clang compiler.
> 
> LLVM patches adding these relocation in Clang:
>    - __builtin_btf_type_id() ([0], [1], [2]);
>    - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
> 
>    [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D74572&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Sr14A5U1sClCcGVCk0rEi3mKHUVfuqMPeiM1_clUDhA&s=aOQT0NmQAfxLsMwCsIJjEkiZHZEe_Gu3KbH_KzcvJwg&e=
>    [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D74668&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Sr14A5U1sClCcGVCk0rEi3mKHUVfuqMPeiM1_clUDhA&s=0Dal6DRCFzut_D-NAd72XZSra5qiBLDZD8E2YVQbIsQ&e=
>    [2] https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D85174&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Sr14A5U1sClCcGVCk0rEi3mKHUVfuqMPeiM1_clUDhA&s=1gWWaCVLCsmvdZalFuQNxINYvv1We4yRQ2VRyreJe3A&e=
>    [3] https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D83878&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Sr14A5U1sClCcGVCk0rEi3mKHUVfuqMPeiM1_clUDhA&s=HvZx6wUsq8kazfavPBRGWFH6zEDYjfkrpvvsC2UgWjI&e=
>    [4] https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D83242&d=DwIFAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=Sr14A5U1sClCcGVCk0rEi3mKHUVfuqMPeiM1_clUDhA&s=Y_Dg-Tl0lQOtbD36XQjZ20P2T7exTymmzqklOqC-USI&e=
> 
> v1->v2:
>    - selftests detect built-in support and are skipped if not found (Alexei).
> 
> Andrii Nakryiko (5):
>    libbpf: implement type-based CO-RE relocations support
>    selftests/bpf: test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
>    selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
>    libbpf: implement enum value-based CO-RE relocations
>    selftests/bpf: add tests for ENUMVAL_EXISTS/ENUMVAL_VALUE relocations
> 
>   tools/lib/bpf/bpf_core_read.h                 |  80 +++-
>   tools/lib/bpf/libbpf.c                        | 376 ++++++++++++++++--
>   tools/lib/bpf/libbpf_internal.h               |   6 +
>   .../selftests/bpf/prog_tests/core_reloc.c     | 349 ++++++++++++++--
>   .../bpf/progs/btf__core_reloc_enumval.c       |   3 +
>   .../progs/btf__core_reloc_enumval___diff.c    |   3 +
>   .../btf__core_reloc_enumval___err_missing.c   |   3 +
>   .../btf__core_reloc_enumval___val3_missing.c  |   3 +
>   .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
>   ...btf__core_reloc_type_based___all_missing.c |   3 +
>   .../btf__core_reloc_type_based___diff_sz.c    |   3 +
>   ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
>   .../btf__core_reloc_type_based___incompat.c   |   3 +
>   .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
>   ...tf__core_reloc_type_id___missing_targets.c |   3 +
>   .../selftests/bpf/progs/core_reloc_types.h    | 327 ++++++++++++++-
>   .../bpf/progs/test_core_reloc_enumval.c       |  73 ++++
>   .../bpf/progs/test_core_reloc_kernel.c        |   2 +
>   .../bpf/progs/test_core_reloc_type_based.c    | 111 ++++++
>   .../bpf/progs/test_core_reloc_type_id.c       | 107 +++++
>   20 files changed, 1408 insertions(+), 56 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___diff.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___err_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___val3_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___all_missing.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff_sz.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___fn_wrong_args.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___incompat.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
>   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___missing_targets.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enumval.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
> 

Thanks for implementing this new btf relocations in libbpf.
Hopefully people will find them useful and start to use them once clang 
12 becomes widely available.

I do have a few nits when I apply the patch to my local bpf-next and
one suggestion for change. With that,
Acked-by: Yonghong Song <yhs@fb.com>
