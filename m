Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85322CFEDF
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgLEUl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:41:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgLEUl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 15:41:26 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0B5KdwWI024633;
        Sat, 5 Dec 2020 12:39:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CjHj/aHuULW06cWSf5GLPB6isdkqKgmGp5dn8WDLQ40=;
 b=Nw/h9VgbZ0wlafiFwZ6VbXayzYCJwc3rdq69DArVg4jMbsbyqcOTpIJpUhxu/z9MWw8T
 p67vnYKC8hmRGLtOjYUyqYhWQk5o5QOc9hqVJgNzONN8BY9EYmnl795IZTdRVX5VBTUK
 jTbgGHby+HCKJbw3yv/WAMATkaIV8jSRJDQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 358801sj2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Dec 2020 12:39:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 5 Dec 2020 12:39:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4r1JNEFwCphDBJbL0IfbGqtkbgN9mFgKA3oEstvyvPunwAAThJ3Uru+fdS+Hx+ih+ZJthmMx2DO55qJSIbRrdFzemm5l6b7E9imbTkp/DmYhg6BosvyXED+A6sDZL9px4TpBkCc2kDB5Wh/cztQhBrHRWBlw6YKIeHi/80wA3eORsPLO5F/Nj2hocbK7Tf4Gh+jyReUT/WjC+VshyyV2c8+TQfv3ryZdrC8CM9W3h+0+LxqbqUcBJeQTpjr3eyLQkgHKDQSxjWvSxPwGfC41WtDk3/wWthtU9IUTSk69RYqp6cg25Cy9s3duGyXM7bWQWvIryp9XlQLITFa3MiVCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjHj/aHuULW06cWSf5GLPB6isdkqKgmGp5dn8WDLQ40=;
 b=Bp9W8IhfKue6Vi7je1nEfZv7chlFisaMmzgAdrcIgB8OsxlcOGTE99zzPbEUNUfq3MojI6BpPyEBPYJlnOZZXyMvpzPgYNPw6AQAe6Ta5gnpouxXUm65BpZbILX96CZmJDAKDFpUVJ4RyC0X5SYFY6Psp1yK1B7ge2EAlfN5/o79A0jH2MS/R7JtGWRQbRzC8IQ55BMDDKGIfQ1dYO5yMpxCU3cnk9+edR+2DvFAttj4H0nicFQ89+hP77qd4qtzYyuUbPzu/dw6kmBsZVllS8TdznvdPchNkqmH0CPbeLroJSel9SJARi3+VfUOBa/bp5LaJrwMZhC6N2u9eJdzQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjHj/aHuULW06cWSf5GLPB6isdkqKgmGp5dn8WDLQ40=;
 b=USa68u+6MfbQuwTDJwt5sNbYqXP5dRnZktt35Po8fvdSoE1JdSX/QT3qlbQ38/wpTbCm2aHxYutJ+Y08aJWu2YCXfXd3vzc7Le+R/41pRcJzL9HFQcSUlc94B3r9j9Rh5cr0KRh1vX/pr2lmXKnR9VDcz7k+OZKQNupdneotw2M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Sat, 5 Dec
 2020 20:39:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 20:39:55 +0000
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display
 helpers
From:   Yonghong Song <yhs@fb.com>
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
 <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
Message-ID: <34728846-dbec-cc94-f1bc-7badefca5bbf@fb.com>
Date:   Sat, 5 Dec 2020 12:39:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:d155]
X-ClientProxiedBy: MWHPR2201CA0037.namprd22.prod.outlook.com
 (2603:10b6:301:16::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1033] (2620:10d:c090:400::5:d155) by MWHPR2201CA0037.namprd22.prod.outlook.com (2603:10b6:301:16::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 20:39:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9566f69a-e662-489e-814d-08d8995decb6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29507659C84F265B1F11972BD3F00@BYAPR15MB2950.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D88MmvysIYI80+vzRXIeeOMUpaP/+kLjAKDeqx/aj/vESG8qVcAS+/Od4ozzJ2m/jQVXKK8pfiGyb+bVagTTt7tQv/UCaxo5e8z7t9lD5d/eYb7RbGNgJWAxflfcKNHozGuEscBbAt1QNT++mfMDjcH0Ed87lDnJ0Znjbbw6lZSTFvXakzNb7RVaeSz+SpkqKn8pmtJuQOPkeQu1NhzHR01zwREU/szvN/vEnXNg9QyVv5clV0+vBqwTy3Avdz3gcttIjhdFD0z/+PNCt2Hz7KpfpwWdVPhOM7Yro/mqJT+Z1ae7bJRylmXB6CbDk4GldyuNUs123nxIDA0qnZwz02h3a8yHKBjJ0eaJ1jRRE6KMML9htOJXaHglR5Z3TUdvlm8k3njLY2TK+R2v2906SA6Lcywc1qEI1wUmC+/R3g8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(6486002)(83380400001)(53546011)(31696002)(2906002)(2616005)(7416002)(478600001)(8936002)(316002)(8676002)(52116002)(66476007)(16526019)(186003)(86362001)(5660300002)(36756003)(66556008)(31686004)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nk5ydVpOeXRaWHZjTmhZUUxqNGlzZ05RY2hEenVCVGE3L28ySTQxQk1vcGZi?=
 =?utf-8?B?VmhqeUJTSlBHVDVnMXBOUTlOQ003U1VVbHY1UnJrSVpJYlFqOFl3S29UV2ZF?=
 =?utf-8?B?WktEcGNLcThia1BpMlVyckxyeEVJQVNUL01hdlloSW8vSjQzaXpoZm1iMGdz?=
 =?utf-8?B?NFZNNEN0cGJrYW5OMndocWpsdE9RdDhmdWFvN1gwdGc3dnRXTm5WNjlDVzJH?=
 =?utf-8?B?Z0t4cUpqYStJS1ZXbjM1TjJvUEZyemZaQ2V6ckM5MHVMOXczM2NFaFJmL2FQ?=
 =?utf-8?B?Q2JEUnhxd0ljWFNHSXNMTXlnVHI1VFBDcnJlMjV2NlJWWjBIWlRXdStQb2FL?=
 =?utf-8?B?WWwrbk9Hd3AvZDNTOEZwNnBBUmpleFN5WVRhMGlnc1lzdmJLckMzRzJBR3Jz?=
 =?utf-8?B?Q3lsTTVGWGJUS0M5Q3lEVnhTYmMxMHN4dGowME1MWXA4Q05CVmtmVFh2SEha?=
 =?utf-8?B?QnNXaHVQcmpOQ3dNVlFnZVUwUjhnbEtSYXhHKzJHMTdzZzZNYTVLNlNnMkFY?=
 =?utf-8?B?QUNCb1RIelNwN0RDa2podkZGWTc4TEE1a0F2OEVDMEF4SzBUNmZCdUN2ZVQz?=
 =?utf-8?B?V0FCRUk5b01ZWlk1bzRMWlBTSEoremc5QWR0amRIcXN6OWU5ZFBWT1lacFFs?=
 =?utf-8?B?eWVXQVc2b1ZVa1lKanBJdy9JYnFsOVc3b05rMzIzSTJxSnljQXFwVzBLcEJV?=
 =?utf-8?B?QkRPaHc0ZDB3cTFldTRQQm5UMlo2OWVWWHB6Nnl3bjUyRVJmeWR3U0tmSEhT?=
 =?utf-8?B?N1I3VHpWZ1JKOGpJWjhxUjhZWUR5ai9tMVlUampycWpka3ZYZWg1VHBFdnc5?=
 =?utf-8?B?a1NwTnVnY1JYV2lTb25xZVRSdFNzY29DcUM1UURLRFBYVW9MT3FibWpsQ29t?=
 =?utf-8?B?RXE3Ukdncno1RThxUWMrbWhYKzN1U2VtOUlsSk93RzhuWW5odzF0YXFHTTgx?=
 =?utf-8?B?a1IvMVBMVFNTajVpNTlMTTNWYjE3QURnMmtsdjFWVmhyVDRuRTQ1WEV5b1U3?=
 =?utf-8?B?MU9icW5lSHlUaWxISlp2NHZ0VVk5ZHBLMll3N3AzK1JlNFR2VnVPSGFjVjk2?=
 =?utf-8?B?allNMDdwa2FCMkRkZmg2K3lLUkVLditySVk2cGUzb3ZiWEE1UkRGNGk0bkpo?=
 =?utf-8?B?Y0Fkc0dwSm1iK0xvS3RYL2FwMzFkSm9HUXIvOWxNaWY4bmM0NEEyb05CSlQz?=
 =?utf-8?B?WnNGbVhpUUdwYlZJdU9odzREQ0NrMFZ4NG0zdkFKc1BpMi9ja3lYajhNUU5R?=
 =?utf-8?B?N0hLdjdKOTFEVndQRytROWs5NE1SckV3RXNteWpVR3VEUWpEbjh5VVZqbXpl?=
 =?utf-8?B?c053QmkxbStpbHNoY1FBWVlaN211aDZTNnZWRjFYK0FFaEw1SGRuQnY3MFQ2?=
 =?utf-8?B?T29xaEkwUlZ6Q1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 20:39:55.4087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 9566f69a-e662-489e-814d-08d8995decb6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1+VsMUgIOmMTjPgVj5Eps4vQ6v9X2lr9QfqwYw1NSimAicjt88fa5lNqyNiabXO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-05_18:2020-12-04,2020-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/20 12:35 PM, Yonghong Song wrote:
> 
> 
> On 12/4/20 10:48 AM, Alan Maguire wrote:
>> This series aims to add support to bpf_snprintf_btf() and
>> bpf_seq_printf_btf() allowing them to store string representations
>> of module-specific types, as well as the kernel-specific ones
>> they currently support.
>>
>> Patch 1 removes the btf_module_mutex, as since we will need to
>> look up module BTF during BPF program execution, we don't want
>> to risk sleeping in the various contexts in which BPF can run.
>> The access patterns to the btf module list seem to conform to
>> classic list RCU usage so with a few minor tweaks this seems
>> workable.
>>
>> Patch 2 replaces the unused flags field in struct btf_ptr with
>> an obj_id field,  allowing the specification of the id of a
>> BTF module.  If the value is 0, the core kernel vmlinux is
>> assumed to contain the type's BTF information.  Otherwise the
>> module with that id is used to identify the type.  If the
>> object-id based lookup fails, we again fall back to vmlinux
>> BTF.
>>
>> Patch 3 is a selftest that uses veth (when built as a
>> module) and a kprobe to display both a module-specific
>> and kernel-specific type; both are arguments to veth_stats_rx().
>> Currently it looks up the module-specific type and object ids
>> using libbpf; in future, these lookups will likely be supported
>> directly in the BPF program via __builtin_btf_type_id(); but
>> I need to determine a good test to determine if that builtin
>> supports object ids.
> 
> __builtin_btf_type_id() is really only supported in llvm12
> and 64bit return value support is pushed to llvm12 trunk
> a while back. The builtin is introduced in llvm11 but has a
> corner bug, so llvm12 is recommended. So if people use the builtin,
> you can assume 64bit return value. libbpf support is required
> here. So in my opinion, there is no need to do feature detection.

if people use llvm11 which may cause test to fail, we can add
an entry in selftest README file to warn people this specific
test needs llvm12.

> 
> Andrii has a patch to support 64bit return value for
> __builtin_btf_type_id() and I assume that one should
> be landed before or together with your patch.
> 
> Just for your info. The following is an example you could
> use to determine whether __builtin_btf_type_id()
> supports btf object id at llvm level.
> 
> -bash-4.4$ cat t.c
> int test(int arg) {
>    return __builtin_btf_type_id(arg, 1);
> }
> 
> Compile to generate assembly code with latest llvm12 trunk:
>    clang -target bpf -O2 -S -g -mcpu=v3 t.c
> In the asm code, you should see one line with
>    r0 = 1 ll
> 
> Or you can generate obj code:
>    clang -target bpf -O2 -c -g -mcpu=v3 t.c
> and then you disassemble the obj file
>    llvm-objdump -d --no-show-raw-insn --no-leading-addr t.o
> You should see below in the output
>    r0 = 1 ll
> 
> Use earlier version of llvm12 trunk, the builtin has
> 32bit return value, you will see
>    r0 = 1
> which is a 32bit imm to r0, while "r0 = 1 ll" is
> 64bit imm to r0.
> 
>>
>> Changes since RFC
>>
>> - add patch to remove module mutex
>> - modify to use obj_id instead of module name as identifier
>>    in "struct btf_ptr" (Andrii)
>>
>> Alan Maguire (3):
>>    bpf: eliminate btf_module_mutex as RCU synchronization can be used
>>    bpf: add module support to btf display helpers
>>    selftests/bpf: verify module-specific types can be shown via
>>      bpf_snprintf_btf
>>
>>   include/linux/btf.h                                |  12 ++
>>   include/uapi/linux/bpf.h                           |  13 ++-
>>   kernel/bpf/btf.c                                   |  49 +++++---
>>   kernel/trace/bpf_trace.c                           |  44 ++++++--
>>   tools/include/uapi/linux/bpf.h                     |  13 ++-
>>   .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 124 
>> +++++++++++++++++++++
>>   tools/testing/selftests/bpf/progs/bpf_iter.h       |   2 +-
>>   tools/testing/selftests/bpf/progs/btf_ptr.h        |   2 +-
>>   tools/testing/selftests/bpf/progs/veth_stats_rx.c  |  72 ++++++++++++
>>   9 files changed, 292 insertions(+), 39 deletions(-)
>>   create mode 100644 
>> tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c
>>
