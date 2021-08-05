Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC043E19DD
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhHERAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:00:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48892 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhHERAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:00:17 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Go6ti016047;
        Thu, 5 Aug 2021 09:59:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=7/zzOQvAO7bHJQUrvc0BknWfvDqjjTRVZOrX1+Fn78o=;
 b=dmaFFQBTJLAjqyx/Gt8NtdXEWRJ8SfnkXBCG/OoKRcjbEKxUd5JD2eMf6C2cpdQ9R5rJ
 SI2Wh6D4Cn9tyfd6CbUEskzriwd93CAiIgT/t0Ciaf4S8qvdEFYPXttnxcDCsktvBMI+
 898qlap/66nkraXV1QGxt5L0nGC49J8/K14= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a8jh5gmcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Aug 2021 09:59:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 09:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLPRQPeguSHb83IN0psHSHQFKIBoB4H+gCHFT1ve8pGm7sdezZeOb+AgDkEyBFHcFl2jrKAW24deFjTqws13wK4N52ib8qDecMMuSSkjlp15SetPvvjN03JY8RToFj5uUBa3FLc6tEBG4IlXzovkli2g+LJJZ5lmZSxRt9/9dQrLuJX2+wQV9vsYet+fOzsZZFY/qfTt/n8QDSuP/lQvTwMQa/FTYy0RCO9xN/wGND9CXGZZpD6rB1O1S1xoQUN/zAY8w5q/JP69lNHBb0HOLt7TZK41odOx8lg7nnWMMH2AGKFNblGrELHUcI6WPhOif+1d0pILOXcGPIxyQGHcCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/zzOQvAO7bHJQUrvc0BknWfvDqjjTRVZOrX1+Fn78o=;
 b=CsEIhvFK6LS7aT8K6g0XZgclb4a7FD70msaIjuxkLTAb7htzjFfDHFUABq6ir6RyZSOwmQ6JRuJFHmub5B8Wp7PSKxZdcRTtNlUSG1/3tA6bOvPHC/ci86quSDzM42u+1Fayl9DdWJ2HRltuKF/NDNmpkXYFM5pmHSNhY2xzDD1OGbRDsYT9VdBFOzJZBPIK73YGWv00PjKmrx0vylqjL+QjMp3D3JYYXQCiDYaUf3QlquiKuqB8WupUaJoe0a/wepPYAwAre9BQugE0/1RD319iFkG5e2CmGPdySDvzkCHqFWbPEJA0dgDY3Md8Vd1A1L0WaA+xixQbvdrp4CNpoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4418.namprd15.prod.outlook.com (2603:10b6:806:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 16:59:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 16:59:42 +0000
Subject: Re: [PATCH v3 bpf-next 2/2] selftest/bpf: Implement sample UNIX
 domain socket iterator program.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210804070851.97834-1-kuniyu@amazon.co.jp>
 <20210804070851.97834-3-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <25688602-6151-d8f0-17ef-1661110ed26e@fb.com>
Date:   Thu, 5 Aug 2021 09:59:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210804070851.97834-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: SJ0PR05CA0203.namprd05.prod.outlook.com
 (2603:10b6:a03:330::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::13bf] (2620:10d:c090:400::5:9ce) by SJ0PR05CA0203.namprd05.prod.outlook.com (2603:10b6:a03:330::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Thu, 5 Aug 2021 16:59:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91647418-f45f-44d5-4e58-08d958326b47
X-MS-TrafficTypeDiagnostic: SA1PR15MB4418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4418D7D73A88A52BCCB2DFE2D3F29@SA1PR15MB4418.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:239;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8shZzAlVBuOcse+qKEXdHCENhoM38JD3DcpQY2qHhI12HZHTqT0IUYFy3LG+CzPfwrdZmz1i2SpfdU5Wq81CqghM3o151FZI250ToQTTj2D5soN6YVEeVprM0CifRI2UjRti7LvZlIB/BvqBdLT/TmoOT4JiE5Omc32+LjQT2NXL6Sc/jE5HlBhzK77JKtCsr3x6GK73hZm3oBjFzKmmjIiiECGrcaT//TfRH/bGphR40CpLPfMPs2RXvbNQfqTscliUs8/BhKRRWqWBF8Xehl19C4MgI9QJQ1vcZ/J9+tJ3GQroa6/KbENacSmSyjgpb4ZTihA/LeNURQPLIUKL4tmwMgOzaegl5dc+C/QubWQD5EqZAL14UU1Uia2IDtMmIHwqPZ/IeowBdKlleo+mMkjKWzjqE0DYuAcNNITRoUQ4taERP49IQ9j32YJ8LsyiT0uuKFsLIJaI7Dg6Wm8jGoPB8om0ng5PfAa2z/laR8Cv9S/ssSA4J37BUurnArOFx/WoDvX9A2E4QsS92D/iSEaP30lkESr8znxTBhS9RBpNDenfdUggZaohTGd9GkFuWKwtQXw8XYX7pICk3IiNQXqb1GLzw+W/cxZRyAtFchxdg1iHUv/Z2pZQ7AlOKmYPGO6wcUgkHm0Q6dRDWbfQp4eKygrq8ecdBEiiCG3HEXnz8sgLh34OheEC9T7da+5CaAMwv2evDOzN5k8pEKEOg+McLLuUodRUtOoPwHFpwFWc7xVmsYzPToGamxQGM1SP4tnYOrPuZwpGLh/rC0j4cBnQALTSeJxIUBCRxKsQ7fL8RnfsZwJMuqW/VcGVNoVR1pWDi8CF6PpOawimcpzOLXoHHnhKJWxAxqkLqR3kD9Zt/LMqxEG3k5+2OiXDnj+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(921005)(186003)(83380400001)(7416002)(31686004)(36756003)(4326008)(110136005)(54906003)(8936002)(52116002)(38100700002)(8676002)(53546011)(316002)(966005)(2616005)(6486002)(2906002)(66476007)(66556008)(66946007)(31696002)(86362001)(478600001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QitHWDVpY01qcmRQOTFiUzFrUnVtdU5qZ09CVzcrZnJaamV2aFhBcXpjbDlz?=
 =?utf-8?B?TTJhdnl6aXIwUU1abEtuK2QwWVZma1B2MGdHK2djb2NQVWxmK0tVQmhZWThs?=
 =?utf-8?B?dzMxRm1MbW1JaVVDSHhlQU5udDVOeUFNbVpKc1ZwUk5iSVc3TnRvWElFUWZo?=
 =?utf-8?B?Y3pTMklacXNnWUI3RzhCNS9Wdlppb1lhajlMdDN0NzNjbkxRbEtFVmNuZ0U5?=
 =?utf-8?B?SHN4NlRhNHA1NWpEOTlWRzltM0MyMXZ3THJPOHBEZzBIeWo5ekVmNEFobmtz?=
 =?utf-8?B?WDZjaHdnbUlqYjBOeGNKWjM4TmZTRnJwbVE2KzVzaW9wVzdiRkU4WDZFVVYv?=
 =?utf-8?B?T0xiMkZYSTloTFNxYVZKMC9BYW5makd0SUlrRG9zZFBONkNwZnRHZWcxN01W?=
 =?utf-8?B?Qk93QUVqdmdPbUpsRXZiMjh5d2dQQ1o3U1pXeTVHVUo2SG1JWE5Jb0U0YWtG?=
 =?utf-8?B?TGRQM2lKMHYwbWZnb0FGcjljWkQ0ak14azNNQ3JCUkZDZ3FRUmQ0OTdKSGc4?=
 =?utf-8?B?ak5mTEl0bFZjajVKb3hWWUxSUnllMVhZeWhXbXJLUEpaS1VlUXBpN1BpS09l?=
 =?utf-8?B?eU14T3dsbVZwaVA2NDA1NU9GZDErZFdZR2NZOGMyd21OTlBWTHduTjJWZU4w?=
 =?utf-8?B?L2FNaE1IR09tajVPZXpXVnZGdU9WS1JkTm5HNmNsbDFXcHd2UUszRTBMdUht?=
 =?utf-8?B?ck1TdlhtQytQR3Fhb3Y2MzJWWVRFbVRDdG52N0FnVURvM3pZeHgyaHozSTlK?=
 =?utf-8?B?eWp5dENrSUpYWFRFT2hrdVk3eTBPQkM2QnBieXJyWkpmZllOalkvL3pldStE?=
 =?utf-8?B?YzRURWNubHhMdjI1UlhXbGM5Q3BrYmhKakoxNVNmcG50MG9OV3dLa0R2MDJm?=
 =?utf-8?B?dFJCL2QzYnBlaHY0Qi9zYjVVdFRNbXliaHBjbitXbGk4OWk0WUdyUkl5UHJ4?=
 =?utf-8?B?OU1oTERCLzhPdTl2L1Rtb2taSXcra3pzWUUybTl5ZVZ4UElBZHo1dUlIUXpy?=
 =?utf-8?B?L1dDMzdHUXZCNDdnU25Ra2JJZlQzZmlzaVVKWGplYlhUa1IvcGRlN3l6cU9i?=
 =?utf-8?B?cnFUZW54amhDZTBBM1BvMlBPTXI1azBBVUxZNzF2MGZiL0NXdG5IWml4cXpz?=
 =?utf-8?B?Y00zQXVqTlFya0R6dHgyUk51RzYyRnlMMmI5bkphSm5Pb2ROdHRVYnVrbVZS?=
 =?utf-8?B?eVd5cGlzalE4cUdZcFJkWjgyR3RiNWdWRFQ1ZDZ5M1AwT0EwamVYNUpUOEtV?=
 =?utf-8?B?L2RqR1dVZG9kYzdnMnJSbjE1R0VWUUhtUXNOMkF4VjV5U2piSWUwZDY3MFNS?=
 =?utf-8?B?bVkwT0tpY1ZHK1QxbUUrZExaVVFkRkw5NkhFelA2UGVPcURZZlE4ekNVT0VK?=
 =?utf-8?B?UHBhWGVvNnlYZ0NiWkZzaHNUTmVSdmErWVN0ajFDZU5tZzIrK1FOeUhzVlZF?=
 =?utf-8?B?NVRTRkdzaXZCWG8wNkpqbTFNaHNHbnF0WThDOHZ0RVFTdkEyT2xvYVV4M240?=
 =?utf-8?B?VmJNY2RNc2g3dnMzdS9RbktubFFONWVxT2VlLzFrQ3ppTGZYT1I5MEtDYlNr?=
 =?utf-8?B?YWZVNFNMM0VYVk53ZWFTNEwwL3JJRXVRc0x0Kzl5dHVaT0d5elhzMW9rZXBx?=
 =?utf-8?B?QnFkb1RReXBhRFh4RW82TlJaVFBwOGw5TDhlc254R0pQR0VhZllTTFBGTzhi?=
 =?utf-8?B?cEh6V0Zieno1Nkpyb0REaWcycGhqT21lTDNvc1o3RmorY1pWQmtlYkxrSjlT?=
 =?utf-8?B?YTY3aXpqVzFUU3pCSklTZFdsYzRTYklqWmhsZGRVeUMycWFLdHloQjJETERw?=
 =?utf-8?B?YmF2VngrY1hvdTllVDM0UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91647418-f45f-44d5-4e58-08d958326b47
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 16:59:42.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Xu7M9i91CcO2fhl25JWpVhJq0H2hevBrIcSlYeVPc9QqYP3lyuMGwoQUhd2z9Ub
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4418
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: npV23TTQuGB3Ma0V86bGsgb7-EtUX8eU
X-Proofpoint-ORIG-GUID: npV23TTQuGB3Ma0V86bGsgb7-EtUX8eU
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_05:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/21 12:08 AM, Kuniyuki Iwashima wrote:
> If there are no abstract sockets, this prog can output the same result
> compared to /proc/net/unix.
> 
>    # cat /sys/fs/bpf/unix | head -n 2
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> 
>    # cat /proc/net/unix | head -n 2
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> 
> According to the analysis by Yonghong Song (See the link), the BPF verifier
> cannot load the code in the comment to print the name of the abstract UNIX
> domain socket due to LLVM optimisation.  It can be uncommented once the
> LLVM code gen is improved.

I have pushed the llvm fix to llvm14 trunk 
(https://reviews.llvm.org/D107483), and filed a request to backport to 
llvm13 (https://bugs.llvm.org/show_bug.cgi?id=51363), could you in the 
next revision uncomment the "for" loop code and tested it with latest 
llvm trunk compiler? Please also add an entry in selftests/bpf/README.rst
to mention the llvm commit https://reviews.llvm.org/D107483 is needed
for bpf_iter unix_socket selftest, otherwise, they will see an error
like ...

> 
> Link: https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
>   .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++++
>   .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
>   4 files changed, 114 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 1f1aade56504..77ac24b191d4 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -13,6 +13,7 @@
>   #include "bpf_iter_tcp6.skel.h"
>   #include "bpf_iter_udp4.skel.h"
>   #include "bpf_iter_udp6.skel.h"
> +#include "bpf_iter_unix.skel.h"
>   #include "bpf_iter_test_kern1.skel.h"
>   #include "bpf_iter_test_kern2.skel.h"
>   #include "bpf_iter_test_kern3.skel.h"
> @@ -313,6 +314,19 @@ static void test_udp6(void)
>   	bpf_iter_udp6__destroy(skel);
>   }
>   
> +static void test_unix(void)
> +{
> +	struct bpf_iter_unix *skel;
> +
> +	skel = bpf_iter_unix__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "bpf_iter_unix__open_and_load"))
> +		return;
> +
> +	do_dummy_read(skel->progs.dump_unix);
> +
> +	bpf_iter_unix__destroy(skel);
> +}
> +
[...]
> +	if (unix_sk->addr) {
> +		if (!UNIX_ABSTRACT(unix_sk)) {
> +			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> +		} else {
> +			BPF_SEQ_PRINTF(seq, " @");
> +
> +			/* The name of the abstract UNIX domain socket starts
> +			 * with '\0' and can contain '\0'.  The null bytes
> +			 * should be escaped as done in unix_seq_show().
> +			 * However, the BPF verifier cannot load the code below
> +			 * because of the optimisation by LLVM.  So, print only
> +			 * the first escaped byte here for now.  Once LLVM code
> +			 * gen is improved, remove the BPF_SEQ_PRINTF() above
> +			 * and uncomment the code below.
> +			 *
> +			 * int i, len;
> +			 *
> +			 * len = unix_sk->addr->len - sizeof(short);
> +			 *
> +			 * BPF_SEQ_PRINTF(seq, " @");
> +			 *
> +			 * // unix_mkname() tests this upper bound.
> +			 * if (len < sizeof(struct sockaddr_un))
> +			 *	for (i = 1 ; i < len; i++)
> +			 *		BPF_SEQ_PRINTF(seq, "%c",
> +			 *			       unix_sk->addr->name->sun_path[i] ?:
> +			 *			       '@');
> +			 */
> +		}
> +	}
> +
[...]
