Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CE52CFEDA
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgLEUgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:36:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgLEUgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 15:36:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B5KZKiO031857;
        Sat, 5 Dec 2020 12:35:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/DbJ5vIqMtUjS1yazN2HfMbqCKjE7oNRORHqrBHV21U=;
 b=TLF8AWdxyj8t3EA+PsoU4JbVK7nKVmePJ1mp4A9KFOhrWYu7uGOAYdYY+8fc6aDUalPT
 EPAoOwHT1kTr7sYMBlZSn/mN+744eVf28Ihq/2RBta0HotbQNPyrkkAINxHMQMnynDwa
 uhP3KDn82fC20NZIf4HoCkKR2AI1AN8Lvm4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3588tv9dt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Dec 2020 12:35:20 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 5 Dec 2020 12:35:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nirZi0DCEhRgGZMnc6wqKl2EcD8qCKMcgAGqbKWEglWH8ggUla6Yu65REqginvLOlWgl1bObWH4dLCJIBYoePQjKc+sc7VaAwhwwsSNF/tbmjBZojz2dBSOoHt31UShAAOxen3y9O2ouS2sGPEPs45ejYnl/yDWE6rRTKIBe66E6ukT4XE9f6e2tW3ie+3bieno8lQsfPjDyALEVHnK+ioBp9An6zdUd/B9EF+HKPbGos71QzU5jbziIURlpQz3C0RR4J/J303lb4Nfl7by2akNfd6M5V4WiufRtpNpFA6LkAMrdhiGsO4tOvyCAoKAw8J+4fYcdWnaHk7Issg2H+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DbJ5vIqMtUjS1yazN2HfMbqCKjE7oNRORHqrBHV21U=;
 b=RykP0WTIYbBjjU6cX43vgSl5mlvNAyJ4Y4riAXpRk9al2fs5TZT7YGGlMBUN2Ujvacmd3aDPpmi3k253Bv4b1s8T0CQr0mAWPa/w7gHklVE3smFvKcm311MzYfqXtxUXbI2sDCwbVaDaA4nEyDJ2+5wEXh5ShIBpy7fdv686AI/gYdOqhwOOuLGZVJAW4boqIhIm6YX/PJrdadENsvVFXhUy7TFze2BMtmvRHUIrRARHtIkWxqXWQbMBYIgC4x6ebJTZO4hJyc+3qYge7+hJ80+nSLywvDVRXbE16+iMZ50LUOrsQKSuMOAx17o4sInug1xpafA1nDkuzDj3cya3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DbJ5vIqMtUjS1yazN2HfMbqCKjE7oNRORHqrBHV21U=;
 b=StrPCzUCQX8YiGlw4Dz8Mn8oESTDfaWPBgofmojuvJb1OOfUACUbi9L2V4m0ZiAFa44XU49jYz64ZP8lyPapst7B03en1+nMHm+uPYVpbmTkJQnY2HKUiMMbAt8Ugaanale+Y3D9Bohu4+F9mQduRG9QmyPHpB3lSKI7jXJDPZI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Sat, 5 Dec
 2020 20:35:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 20:35:15 +0000
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display
 helpers
To:     Alan Maguire <alan.maguire@oracle.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <quentin@isovalent.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <shuah@kernel.org>, <lmb@cloudflare.com>,
        <linux-kselftest@vger.kernel.org>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
Date:   Sat, 5 Dec 2020 12:35:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d155]
X-ClientProxiedBy: MWHPR12CA0050.namprd12.prod.outlook.com
 (2603:10b6:300:103::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1033] (2620:10d:c090:400::5:d155) by MWHPR12CA0050.namprd12.prod.outlook.com (2603:10b6:300:103::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 20:35:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82db3712-5900-4c65-b4d8-08d8995d45d1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB224538536845DCA415E1CE3DD3F00@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lBnTSLGiGesS/Ss73ggefgJ3wnsYhtIuCEjvTXiScN6pjaVBsrHSndpc9n8K74/s3lNNOIXcCRDtZNIbgFQyZE8DdA8ZqYaerTUr+GA03Lp8HJgaNVmm5kDSDVKh4CVzIvAfW5jUZe76xCdo1geIqjloanxfrmBh1VdXDC3ejhYZONPnS2Nq9O6SzpytIl7MdmnCAgEoXMV68V7XsY+a1RPfb1mkQ1TZudJIJuV5hrOrJnaDoAZRu8GFTZJC5U0ND17wES3zfDHFQBK3RnmMabVZ7zOOjxhcJ/bFPXY3nm9sQ2r9A/uEd565vCYHjDEdFyuvE1f4LkBU10CIG9kmCz/R6XXTVo9t3ojWngh9Pe6msASRv+mb6jkEElxrVvd6SPAQvrPK2ioB/UqYh5WT0jT2mNpv2nlUj2O5Pw8JvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(5660300002)(83380400001)(186003)(2616005)(4326008)(6486002)(2906002)(7416002)(86362001)(16526019)(53546011)(31696002)(31686004)(478600001)(66556008)(8676002)(52116002)(66946007)(36756003)(316002)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVRRSnc5Q053SndRN1cxcHR3NEdueWJ1UFRmZHlzM004a2NrQ05OK3BUSmVR?=
 =?utf-8?B?TDFTUXlsS3FNU2c5SnAreXhGb1A4SlFsNnJ4Q2lyRGtWdGcrb0ZXTkJ3Q0p4?=
 =?utf-8?B?V01jZ21ubDNqRE0vbjRCdFBlMXZYaXhGOVlEK0VGNVVacTBxNHNUS05yRjZ6?=
 =?utf-8?B?UHdvSWtzajZsT3pud2RVSGNoZWpITzUzeCtWUThFdXZpWkpJNkVTS3puUGJw?=
 =?utf-8?B?SlBpN0pDYklQTGk0ZlpKSU5SbDdJUU95UjF4UDZUVDVrZVB0LzJRWWp4SGVJ?=
 =?utf-8?B?dDlqVlNPdHdjV3VHZEl0MXJvN3hwZCtiM0hlaEtOZjJhRUdHWTRFekF5Wkp5?=
 =?utf-8?B?MkdQay9Vd0lHZFA1VkVJNnpCYXBhb1dacTQ0eng1TXJhbE5MVWpZU3cwNUZ2?=
 =?utf-8?B?RkFKWDZGU3NGemN2N1g1VDhsWW9BVXpCK2ZaM2dyQmtwYWhtcEVNODNOZlV0?=
 =?utf-8?B?VXV2QlBaRjNMZGV4MzU1anlUeWoyNUt6NE95TUd2a0VUZ2t4MnB6TEdGNFdR?=
 =?utf-8?B?aTRZUkFYNk9QZE9oOUtNNXRDQi9sVWp2bVZLN2tObnEyQ2JtYlFVTmxucUt4?=
 =?utf-8?B?Q2pvM1dTNkRrN3ZnNmVTL2xLbXBOcTdpRXB3T3d4dG80NW1xMWFCOHNEZUdE?=
 =?utf-8?B?cmM0VGNNUTJIeWJVd2x5dHJZdGJNYkZWbXpvSXFjSVhsdnpqRWxUZmpFSDN5?=
 =?utf-8?B?cnRaczRJdWxERTZ3Tkp1SEZNR0FXdENkL2xKQ3dVZk9TbjJpOHZkbnIrSU1R?=
 =?utf-8?B?WlNTNUZBdFpTNkNwTHNvSFBGUFNhamk0RVY5Z0ZsSFJ5YkNNeE5FSExQb0JL?=
 =?utf-8?B?eXBLdUhJVVdVNXJzd3FMTXhaMWh6eG81cTlUNWFJUkhuTFRhZnFHLzNKQ05B?=
 =?utf-8?B?NXVIeWhDWEdMZnRVQ3hDNTNUV3dIeld0RkZwYlZaeC9PZ1FOQ1VkYWcrNXVk?=
 =?utf-8?B?alFxOEVHenJaQWNVczY5R2o5cjY2cXg4TFdHOFcxYVBZNkVXeVZvVE42cnU3?=
 =?utf-8?B?U01IOVhQVkFzNzh3Sko2NnRycjFmbkpBQ2pFdDI3QVdrNjVEYWQyVVN1azVR?=
 =?utf-8?B?TlIrMDNUQSswOXVCYWdNTHhVeU1Hekc1RmtRM1BtV0lNTFp1czErQSs5OEVM?=
 =?utf-8?B?cFFxVmo0TjB4Q29ZVi9VOFpMbUtIek1xdmRmaXNoaGNraGNTWlNQL0JvUkJJ?=
 =?utf-8?B?TWdXdHdjMThKdlFvTUdOMGphbmIyU3BzbHVHMUFoeTduTmEwL3N6d2FSR2FW?=
 =?utf-8?B?Qk1aMkpIYis5K3V1bXJYSktkODRRSm5zSHB5RnhyU1l2MXV3dFFpMzFMWVVK?=
 =?utf-8?B?RVBOVFNvbmtJblZxeGlDNUVJU0N2Y2diQklhN0hZa2JseTFxaUpjdHNXMU5m?=
 =?utf-8?B?MWlzbWJoaWpKbnc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 20:35:15.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 82db3712-5900-4c65-b4d8-08d8995d45d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UT7a5FVmeZm1w8I5YpnoelCGzo89b1jlCM42upV1Ke5SkgrVEF6vbL6rk8t/AxjQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-05_18:2020-12-04,2020-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/20 10:48 AM, Alan Maguire wrote:
> This series aims to add support to bpf_snprintf_btf() and
> bpf_seq_printf_btf() allowing them to store string representations
> of module-specific types, as well as the kernel-specific ones
> they currently support.
> 
> Patch 1 removes the btf_module_mutex, as since we will need to
> look up module BTF during BPF program execution, we don't want
> to risk sleeping in the various contexts in which BPF can run.
> The access patterns to the btf module list seem to conform to
> classic list RCU usage so with a few minor tweaks this seems
> workable.
> 
> Patch 2 replaces the unused flags field in struct btf_ptr with
> an obj_id field,  allowing the specification of the id of a
> BTF module.  If the value is 0, the core kernel vmlinux is
> assumed to contain the type's BTF information.  Otherwise the
> module with that id is used to identify the type.  If the
> object-id based lookup fails, we again fall back to vmlinux
> BTF.
> 
> Patch 3 is a selftest that uses veth (when built as a
> module) and a kprobe to display both a module-specific
> and kernel-specific type; both are arguments to veth_stats_rx().
> Currently it looks up the module-specific type and object ids
> using libbpf; in future, these lookups will likely be supported
> directly in the BPF program via __builtin_btf_type_id(); but
> I need to determine a good test to determine if that builtin
> supports object ids.

__builtin_btf_type_id() is really only supported in llvm12
and 64bit return value support is pushed to llvm12 trunk
a while back. The builtin is introduced in llvm11 but has a
corner bug, so llvm12 is recommended. So if people use the builtin,
you can assume 64bit return value. libbpf support is required
here. So in my opinion, there is no need to do feature detection.

Andrii has a patch to support 64bit return value for
__builtin_btf_type_id() and I assume that one should
be landed before or together with your patch.

Just for your info. The following is an example you could
use to determine whether __builtin_btf_type_id()
supports btf object id at llvm level.

-bash-4.4$ cat t.c
int test(int arg) {
   return __builtin_btf_type_id(arg, 1);
}

Compile to generate assembly code with latest llvm12 trunk:
   clang -target bpf -O2 -S -g -mcpu=v3 t.c
In the asm code, you should see one line with
   r0 = 1 ll

Or you can generate obj code:
   clang -target bpf -O2 -c -g -mcpu=v3 t.c
and then you disassemble the obj file
   llvm-objdump -d --no-show-raw-insn --no-leading-addr t.o
You should see below in the output
   r0 = 1 ll

Use earlier version of llvm12 trunk, the builtin has
32bit return value, you will see
   r0 = 1
which is a 32bit imm to r0, while "r0 = 1 ll" is
64bit imm to r0.

> 
> Changes since RFC
> 
> - add patch to remove module mutex
> - modify to use obj_id instead of module name as identifier
>    in "struct btf_ptr" (Andrii)
> 
> Alan Maguire (3):
>    bpf: eliminate btf_module_mutex as RCU synchronization can be used
>    bpf: add module support to btf display helpers
>    selftests/bpf: verify module-specific types can be shown via
>      bpf_snprintf_btf
> 
>   include/linux/btf.h                                |  12 ++
>   include/uapi/linux/bpf.h                           |  13 ++-
>   kernel/bpf/btf.c                                   |  49 +++++---
>   kernel/trace/bpf_trace.c                           |  44 ++++++--
>   tools/include/uapi/linux/bpf.h                     |  13 ++-
>   .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 124 +++++++++++++++++++++
>   tools/testing/selftests/bpf/progs/bpf_iter.h       |   2 +-
>   tools/testing/selftests/bpf/progs/btf_ptr.h        |   2 +-
>   tools/testing/selftests/bpf/progs/veth_stats_rx.c  |  72 ++++++++++++
>   9 files changed, 292 insertions(+), 39 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
>   create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c
> 
