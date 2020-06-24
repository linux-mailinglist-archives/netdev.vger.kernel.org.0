Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98654206904
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbgFXAZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:25:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53428 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388127AbgFXAZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:25:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05O0BG7X023351;
        Tue, 23 Jun 2020 17:25:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/D6Osp/hQO+fNoxH8+o6/RnKQGkH58YBmTyESP1vyjM=;
 b=EuyHIAvHwrJeK83HXD0xDOrMajBxSUB72BAxVLDIpHspDLejv2VKgkTFPXYbSHJSWjUK
 Z6fIXHx7lqB/jBdYYoYaDjovYnB674RKwcdVA/mdvBwa7HFtPbo0CH1PmExANiGmfDb7
 r4N3NKefHVco33DTvnLLXsO62aeyChAgVDk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31uuqr848w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 17:25:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 17:25:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cnt20HoT6Idr+7NKpKGVuIM//I3yX2NCdvXRxwoX/D8q/0KmyAMGn42wKYfUAHXmrcm50Xhzf0et3VjHX/ykP+wCiK1LTnIKTv359/X6FcFxyutX+uxA76V86TqeNtqMTLsW4xu+PRCNcdx0lnRcj/TG9ceUnl6b0yVXz/DMJcYmogT0I6uX140DS3RPcE0iXybYEu6CcrYjCxB4jDRj4gDjOsSKs7pS97XFR08Wk3vnVanYKvMLIka6wWj1gz8lMMEyXYOi8GzI9HtMZl9c9+Gx9UFqYBlreyoXGYNu8hHC1EOuT+txZ48YU+yTUz+y/H8JoJ+mAFNuyB/QFayi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D6Osp/hQO+fNoxH8+o6/RnKQGkH58YBmTyESP1vyjM=;
 b=eMaxARP0prR0seMEyCMbyg7wnXejk1+Z3G6o4aLyfmydDRpCrNpyalRM0qUzZY8Cy9quyoMii814I3fCIB8Yl28NpGz0PNcF1M+mvbbHBILKiwNUnyEXrJG3vQaFlxBNrGfaDFBoILB5ylvgKnlyLwBm8yQRGKwxVh7OZqTIQNYkHgT8nsrGV2T14/p3OppZqGgCR7yjJiMOv7dOh88H+HR1MArM756rcSh1AXIXlERjpNVnjpL6iuyUnRPvPKFD4PbRJaK/mxMZtVdvWSWOhH/YjuyTi2/8h7AEch+t1bXgEINeGhPYCRy1gzG9pVfpMLUBNX9UJHkBLTphDfmc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D6Osp/hQO+fNoxH8+o6/RnKQGkH58YBmTyESP1vyjM=;
 b=Z9ldbnS/adXrhplCXhEZzWHjpZ+tMNxC2sOQPry+8bchDwX0sP+bD1iIhfePTcb3b5w8zzDPuYPp0uAwg5uiA/a+uUu6laCBTb6yaO4N+B2AFRU3+pCEjjjCmyOEa1ipZoyzCKgwOBq+1hl2uPpE2HyUcPXXg9tdPusglhxNWNc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2997.namprd15.prod.outlook.com (2603:10b6:a03:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 00:25:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 00:25:15 +0000
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200623032224.4020118-1-andriin@fb.com>
 <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
 <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net>
 <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com>
Date:   Tue, 23 Jun 2020 17:25:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:254::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BY3PR05CA0021.namprd05.prod.outlook.com (2603:10b6:a03:254::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Wed, 24 Jun 2020 00:25:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0b60594-2ba5-4a4f-eee5-08d817d510ca
X-MS-TrafficTypeDiagnostic: BYAPR15MB2997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2997C420C9EC62F8DB6331E5D3950@BYAPR15MB2997.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tT91jPHhqCwWsJRve50cUAwr2pPBbo6HaUfXXO0cmq/yy8rPp+TxF67Hb6Ew2qxLK5cTyrnSQ0vBz+13UEhYnh3iF/Ix9hts1uOZrThtSi64dt7/6W5jnVZ642/We3PO0vVv9jc/6T6gYNyaTugThItt9XZmNt7M7S5CgZzGBhCfDXWx+Ny2VM8fE4O/MG6klIV3ZndT4i1z0L7Sbnht9jW+JqZib/y6k2r6icRt60OTFah8AURRJBdt0vH1yG0/Z6d8Hvt3UILDcAI6jSwgjJse8VzXH0jACMes7/rYXX6mFwMibETWylzuByia9vZHHy122W6oryv4QyvK27de8YgXJcRWfipfwQpqzwfvt7RbvDALVoBh75oKTpNfG9d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(31696002)(2616005)(6486002)(6666004)(316002)(4326008)(52116002)(5660300002)(53546011)(54906003)(110136005)(66476007)(2906002)(186003)(16526019)(86362001)(36756003)(478600001)(8676002)(31686004)(66556008)(66946007)(83380400001)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: aqMUIBWaSblOhWXVwHpdKpJ7fCMLNMTMMjsPm2O0hGC2uGRRpBpZIHhpmSdz31px8MAq05zHrj/T2ixmQlAktvBi1BrzJjedK0Pkwhp1Kxgcjcpd3+9NMC/khbU121mtH237d4Q5zTybx7ai354x4uOHG7utQOmzsCZRZpa4vuyDK0D7MM4wSGfoEv0Bl+DMvXNVw7xXpMXdLUpmgITP1WIRtDmOIuLi4ur4TRULGMaeKbyD3Yqt4boa9rR23nuvkSCjFadeJgmg8OLxoJsUJCdSAc28eyu/fy26w/bzSVwPcSl9hRA7/csfjWw4UNrKh1wjwNTaPi07d14mayeg9lBwPeK6MCTSty/1WpRxoRj7icuxUwBS2PFFpoWJxRtvCg8WjN1W7gj7nty/4oMEmmCDeoxPQOaF2l7RfIfFR0nwGkqJwc8O3FFJe+laEMoF0InSCtq8X1ccEbS8Udr+AiY60cJ4BI88aQNbcSu3iIHPiezjYwSt8HCAODKMhilCSwbBgLt5FDjovp41TrU71w==
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b60594-2ba5-4a4f-eee5-08d817d510ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 00:25:15.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KqNA4LDb2Ac6kNx/U3fqF4GFVPZPAlrLOFXKpdAi6XWMDkt43fMR1R9t7gXYzbv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2997
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 4:25 PM, Alexei Starovoitov wrote:
> On Tue, Jun 23, 2020 at 11:15:58PM +0200, Daniel Borkmann wrote:
>> On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
>>> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
>>>>> Add selftest that validates variable-length data reading and concatentation
>>>>> with one big shared data array. This is a common pattern in production use for
>>>>> monitoring and tracing applications, that potentially can read a lot of data,
>>>>> but overall read much less. Such pattern allows to determine precisely what
>>>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
>>>>>
>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>
>>>> Currently getting the below errors on these tests. My last clang/llvm git build
>>>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
>>>> loop when[...]"):
>>>
>>> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
>>> return amount of data read on success") from bpf tree.
>>
>> Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
>> to wait.
>>
>>> I'm eagerly awaiting bpf being merged into bpf-next :)
>>
>> I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
>> these out.
> 
> I've merged the bpf_probe_read_kernel_str() fix into bpf-next and 3 extra commits
> prior to that one so that sha of the bpf_probe_read_kernel_str() fix (02553b91da5de)
> is exactly the same in bpf/net/linus/bpf-next. I think that shouldn't cause
> issue during bpf-next pull into net-next and later merge with Linus's tree.
> Crossing fingers, since we're doing this experiment for the first time.
> 
> Daniel pushed these 3 commits as well.
> Now varlen and kernel_reloc tests are good, but we have a different issue :(
> ./test_progs-no_alu32 -t get_stack_raw_tp
> is now failing, but for a different reason.
> 
> 52: (85) call bpf_get_stack#67
> 53: (bf) r8 = r0
> 54: (bf) r1 = r8
> 55: (67) r1 <<= 32
> 56: (c7) r1 s>>= 32
> ; if (usize < 0)
> 57: (c5) if r1 s< 0x0 goto pc+26
>   R0=inv(id=0,smax_value=800) R1_w=inv(id=0,umax_value=800,var_off=(0x0; 0x3ff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=4,vs=1600,imm=0) R8_w=inv(id=0,smax_value=800) R9=inv800 R10=fp0 fp-8=mmmm????
> ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> 58: (1f) r9 -= r8
> ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> 59: (bf) r2 = r7
> 60: (0f) r2 += r1
> regs=1 stack=0 before 52: (85) call bpf_get_stack#67
> ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> 61: (bf) r1 = r6
> 62: (bf) r3 = r9
> 63: (b7) r4 = 0
> 64: (85) call bpf_get_stack#67
>   R0=inv(id=0,smax_value=800) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=1600,umax_value=800,var_off=(0x0; 0x3ff),s32_max_value=1023,u32_max_value=1023) R3_w=inv(id=0,umax_value=9223372036854776608) R4_w=inv0 R6=ctx(id=0?
> R3 unbounded memory access, use 'var &= const' or 'if (var < const)'
> 
> In the C code it was this:
>          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
>          if (usize < 0)
>                  return 0;
> 
>          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
>          if (ksize < 0)
>                  return 0;
> 
> We used to have problem with pointer arith in R2.
> Now it's a problem with two integers in R3.
> 'if (usize < 0)' is comparing R1 and makes it [0,800], but R8 stays [-inf,800].
> Both registers represent the same 'usize' variable.
> Then R9 -= R8 is doing 800 - [-inf, 800]
> so the result of "max_len - usize" looks unbounded to the verifier while
> it's obvious in C code that "max_len - usize" should be [0, 800].
> 
> The following diff 'fixes' the issue for no_alu32:
> diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> index 29817a703984..93058136d608 100644
> --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> @@ -2,6 +2,7 @@
> 
>   #include <linux/bpf.h>
>   #include <bpf/bpf_helpers.h>
> +#define var_barrier(a) asm volatile ("" : "=r"(a) : "0"(a))
> 
>   /* Permit pretty deep stack traces */
>   #define MAX_STACK_RAWTP 100
> @@ -84,10 +85,12 @@ int bpf_prog1(void *ctx)
>                  return 0;
> 
>          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> +       var_barrier(usize);
>          if (usize < 0)
>                  return 0;
> 
>          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> +       var_barrier(ksize);
>          if (ksize < 0)
>                  return 0;
> 
> But it breaks alu32 case.
> 
> I'm using llvm 11 fwiw.
> 
> Long term Yonghong is working on llvm support to emit this kind
> of workarounds automatically.
> I'm still thinking what to do next. Ideas?

The following source change will make both alu32 and non-alu32 happy:

  SEC("raw_tracepoint/sys_enter")
  int bpf_prog1(void *ctx)
  {
-       int max_len, max_buildid_len, usize, ksize, total_size;
+       int max_len, max_buildid_len, total_size;
+       long usize, ksize;
         struct stack_trace_t *data;
         void *raw_data;
         __u32 key = 0;

I have not checked the reason why it works. Mostly this confirms to
the function signature so compiler generates more friendly code.
