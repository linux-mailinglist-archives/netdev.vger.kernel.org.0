Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15598278061
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 08:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgIYGNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 02:13:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbgIYGNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 02:13:42 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P6DRt7011818;
        Thu, 24 Sep 2020 23:13:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kn2y0O0bRRlK8j5qWPGR/hozDJBX06RFD7gPAkrjj24=;
 b=eiKBK7MSNmhJjyZjBe1eDQ8peI9dtAwxLeQEEAMbqYEA4usO04AcgypJxqXtSAFGB8VC
 roLoauu4WuwFLCCgGhOfdeS+lP64OSqmNmeUpVOH1WeN1ToHVgPYX8aIZsOHMCQOoYZD
 57mmw+ZrkZ8ZRbx8LS/qeFm5NkxHLqNZ62E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp55y14-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Sep 2020 23:13:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 23:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giQMlmfoGq0dXjP2vRH/7kRpnDi7EFRLeLU+RPnJyS0M62z1kduZsayh4bxSoKpIgILBQTlm51VRXh600uZCWpTgkeHIrSjFF8CW5kFi5ch1CxhOsedROnL1P943yeFL9nynJcQc/7dai0vclvhPRFGSiWk/qQBwPG6NPB45jyzSpHGxz/CPAJb7J32vRPKMKuk9Bq9gErRdCfRmdjdl+04S0yMU+9sjiLBKNMyAIeHadfOcsNxaJ4ttwOc3NDQ2YIQPgeP6A6edrP+uEKz7OqwWXMdVahxqiFnOVBtcDjQy5INgoShFfV2bwyYLrqjTzy1ts6DsSfTsrw4/VrKXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn2y0O0bRRlK8j5qWPGR/hozDJBX06RFD7gPAkrjj24=;
 b=YU9SRjTpVer0c78kTHHB8xQRb83GUvkJpbW2isJJlCFSwRVqLVba1vnaNZ/3PMxNR1N1Ad7uFtwAExlcma6zPWtg4GCSpiRTe5lI1y85uKo3V4kYW3xGwsatptVTpBskSn2ON4/nyxBxBXg1p+n/X3DqKoqRvwnp3EsF2MRnxOjEgNtUqSlD7llA2jlVSlJr9ncm+0NBJEF+ApE6q0EJylaN2/OIJNrNKZQAZIs9qcdTKOR87pxUAY2+LDTWYyY7zYyWLUhPSjYdzNZEbGY5VoyvGTJIdk0uARpgFaoqYpIQcxLs832YBXU3GJUh2vuFlM2dQ5M9HRayCJHVxNbODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn2y0O0bRRlK8j5qWPGR/hozDJBX06RFD7gPAkrjj24=;
 b=GdGzHXJUO9BwKV850YDDTxDqhJWXEIilDWuEpTYS8U/GnK6bDYqCo5VQIHJFupAjCNpluyzREqFvik6V7XaHcHhqlnHRZaoxuG46UMxgtNvl87ohw1klOqdbxeSbkMTlSqDUhS8fO55tf8k0O0UGO8u2/s7Kzlm4F6VrDHia/Co=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 06:13:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3412.020; Fri, 25 Sep 2020
 06:13:08 +0000
Subject: Re: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper
 for bpf programs
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <cover.1600967205.git.daniel@iogearbox.net>
 <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c5996fbb-e546-d6e1-7903-f773e2ffb43e@fb.com>
Date:   Thu, 24 Sep 2020 23:13:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:da27]
X-ClientProxiedBy: MW2PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:302:1::39) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::13df] (2620:10d:c090:400::5:da27) by MW2PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:302:1::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7 via Frontend Transport; Fri, 25 Sep 2020 06:13:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 078cb844-1b90-4f5b-0a06-08d8611a1293
X-MS-TrafficTypeDiagnostic: BYAPR15MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2568F4F55AFC459F40846464D3360@BYAPR15MB2568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swtFRSN3Dh2Kd5GiIONVWU88nGxSuOdI3EJE1wap0pQBxqnk3BW+jUAl6QIRXNNu8XrEqxUgGysGHAXCOlWszTR4GDLWPr5nJq3u4p/4/L98ilaPqDDEi91g/Lg860j5T1vjtN9UFy73Jma21nnLW/xuf11h5FRh+e401ErDxS80Z5monJZyixvoXxHTHFCuVvJu7Q+w4o6EQWPE96x47y8UNzlEA9Vv2Rd2jRF+2a0oFczugnFTQYLI3fhXiVsmFwPUx52a15CopV7GUqC3UyhUZbCNyAeyzHEvGyfONpm3LCPBMe5ZzOPoXV5K9zwqrfH3Y8uSm053x2SRr8PxyWpNNM7SyFISl8VVmEz06MlONsdFOAJ5cUlQKyRTUW9rLhDc/3Bd7FzavYcNCexn5gCrl5xd/I6SblTHXwXiUCpqqejNNt5dSyplgyKmgxFW7FoFSk+4gazZ9oUbvVmQKqYfPzFWpQnB5/3qYw69vx3OWNRrfaCW4cyKrJ2s3jRR4/SQFQu4oKeBzRd2Kq76qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(31696002)(2616005)(966005)(16526019)(186003)(86362001)(4326008)(8936002)(316002)(53546011)(52116002)(5660300002)(8676002)(36756003)(31686004)(66556008)(66476007)(6486002)(2906002)(478600001)(66946007)(60764002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VQ18UAjrdiReI4OxK3FnNJPLSLSvdmqppaigSFP5lUrc/nXVdj6UYE71xa461aCw0Kn9EJQyoU/9xvp8aUbfYBWuOk3hyFVpCheYYgu151x+zFfddKhbDKqL9LqOav0ik+BymyWqR7tApf+aDWnu5oE1aZPfNbLqIMpgCuqPXvbH/f7oTjf/p/EsUy30/EzVssFSDjq3yu7x6D7P7pLA4AeC8+lngTkAybHYR1+/WjTNryJ8eLsyKAM23X6WRVtIRSq1sL+fhE28d6RGwDGeTc0uu8/SuhwsAMncFQsB/uqI3kVFoobTJemT0FHMTA0Qk1iM992pHYqzHK9K2eDx4WiRdgFUfo3JACsqjjgrBgciis36WQICjT2fdn38rWed5yP6d/dvjdp9osiRSkjG/C/4QKwqJKKCWeKdkONJU2YEt5hGXVdgx0s/OtpqMZpvJIg3zg7meFqO+isRVIjdIXsHtue5L6p86Lnxcl4DBZhAZKJQ87dz5dESy7cm8yhEww25ZnveIqFvH0WgcSpLLQqXLYjRUJeENZduVzsAt+0MWHvJDvq09RM9Z3fG7alKxsxJ7w/dvzCghNFe5vlfj6ON3EqIj1pUIGg9rqAwUN/KrPoHk0oKPqdw0JCTM1Hd8BureEmyjryGJZh/UsDmzzGkvT3egBXwdtBVYLoCaGI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 078cb844-1b90-4f5b-0a06-08d8611a1293
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 06:13:08.6432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFsD2uUTvbMw3NIdDqxwMqGfjxwBfEqeJEVx135lnJw1e4BfWGMrErFcS0vDjhMs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_02:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/20 11:21 AM, Daniel Borkmann wrote:
> Port of tail_call_static() helper function from Cilium's BPF code base [0]
> to libbpf, so others can easily consume it as well. We've been using this
> in production code for some time now. The main idea is that we guarantee
> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
> JITed BPF insns with direct jumps instead of having to fall back to using
> expensive retpolines. By using inline asm, we guarantee that the compiler
> won't merge the call from different paths with potentially different
> content of r2/r3.
> 
> We're also using __throw_build_bug() macro in different places as a neat
> trick to trigger compilation errors when compiler does not remove code at
> compilation time. This works for the BPF backend as it does not implement
> the __builtin_trap().
> 
>    [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>   tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 1106777df00b..18b75a4c82e6 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -53,6 +53,38 @@
>   	})
>   #endif
>   
> +/*
> + * Misc useful helper macros
> + */
> +#ifndef __throw_build_bug
> +# define __throw_build_bug()	__builtin_trap()

Just some general comments below. The patch itself is fine to me.

I guess we will never implement a 'trap' insn? The only possible
use I know is for failed CORE relocation, which currently encoded
as an illegal call insn.

> +#endif
> +
> +static __always_inline void
> +bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
> +{
> +	if (!__builtin_constant_p(slot))
> +		__throw_build_bug();
> +
> +	/*
> +	 * Don't gamble, but _guarantee_ that LLVM won't optimize setting
> +	 * r2 and r3 from different paths ending up at the same call insn as
> +	 * otherwise we won't be able to use the jmpq/nopl retpoline-free
> +	 * patching by the x86-64 JIT in the kernel.
> +	 *
> +	 * Note on clobber list: we need to stay in-line with BPF calling
> +	 * convention, so even if we don't end up using r0, r4, r5, we need
> +	 * to mark them as clobber so that LLVM doesn't end up using them
> +	 * before / after the call.
> +	 */
> +	asm volatile("r1 = %[ctx]\n\t"
> +		     "r2 = %[map]\n\t"
> +		     "r3 = %[slot]\n\t"
> +		     "call 12\n\t"
> +		     :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
> +		     : "r0", "r1", "r2", "r3", "r4", "r5");

Clever scheme to enforce a constant!

This particular case is to avoid sinking common code.
We have a similar use case in https://reviews.llvm.org/D87153
which is to avoid PHI merging of two relocation globals like
    phi = [reloc_global1, reloc_global2]  // reachable from two paths
    ... phi ...

The solution is to insert bpf internal __builtin
    val = __builtin_bpf_passthrough(seq_num, val)
in proper places to prevent sinking common code.

I guess in this example, we could prevent this with
compiler inserting passthrough builtin's like
    ...
    ret = bpf_tail_call(ctx, map, slot)
    ret = __builtin_bpf_passthrough(seq_num, ret)
    ...

If in the future, such a builtin is proved useful for bpf program
writers as well. we could just define
    val = __builtin_bpf_passthrough(val)
and internally, it will be transformed to
    val = llvm.bpf.passthrough(seq_num, val)

> +}
> +
>   /*
>    * Helper structure used by eBPF C program
>    * to describe BPF map attributes to libbpf loader
> 
