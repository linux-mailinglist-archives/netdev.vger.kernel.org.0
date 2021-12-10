Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6634708B6
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhLJScG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:32:06 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237119AbhLJScG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:32:06 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1BAEaSuZ030514;
        Fri, 10 Dec 2021 10:28:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TgJrIs/rAR16zVKIt0gLgwzySwL9fDxjU7Tui1+r7vM=;
 b=BpI8n8v8SDjTNrG9RPaI0Q+6Ik13C7LDsJeTVlk8fvt0PGTdd2K1hOthe7yKNc86q4ZC
 Qu/m/UBxZo8hIEP01JZzRJasbotrlIIcRQoStStxGG7W29C/EnidsbUUdC9+owA7BAq9
 Ox4KC/0+Xz9zQqh+ffZ4BOkvPzvPH+62GLQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3cv8t4srn1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 10:28:17 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 10:28:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKADPzog90d/5FMoobZtNdFzlwYIW1ElqaYASwwQGVpqtCxrWAZeMDLvGlJlS5ntaBl2GZhk+g0tLwv1O0m0/AIUjMAbj4ZPr3E5rjCwVlSt1B0XsVWT6BhY6h4FuOGodQ1btrH8NlOG2Q/sCNAgUBhK6Ey2lj5UreccQb4eYe7eTUVe2yrzgy73rCer6nnkvR+Rjh8jS2eYJW+G++jcoJ+GQYBsdp10WSCwq0xZDLv0ZnYvJs8rzf7Z9vYsGBMD3eJ2AlSHq+OLO+gpAkzGSATMT3EHfJpoC/P0kVdBE+dW/wS+x4BXIsviaL44mb2/w11OPebZC6LnvIJPCy7oIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgJrIs/rAR16zVKIt0gLgwzySwL9fDxjU7Tui1+r7vM=;
 b=N+P34yPpBfNwTE4bIFxxU4AcoXo1JTqtg4U98LOG4vuYevAw3ixtLQv4XBfTxK3OlCDcTmhzPpuElJy64qMF/VZCNfyMnvsD3SXukfw6IHlfLVBS/x0+EhztJuDb8sWYbyqd8pddWMAeJoqg7Wm8pdpHd7ImwfUuCugbRa5+hTiI7VnYGqvAoPryCflKqB5UY8Kdr3GkYLi9eCzwgN2Ea64QBL1IY9gQWVefwE2zFbUxJuwirQcN74kMh60UgwqnWK2k04X+VG5Zbn4DjCRhcpDNvBtSjM8eI5fmGT3FtVv/cvLFIfZYJN9wcwqh3DL+XThM6lKP5grLlhWX88a+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Fri, 10 Dec
 2021 18:28:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 18:28:15 +0000
Message-ID: <e23dbf45-d75b-8411-bc62-d0e26cccab8a@fb.com>
Date:   Fri, 10 Dec 2021 10:28:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] samples: bpf: fix tracex2 due to empty sys_write count
 argument
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20211210111918.4904-1-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211210111918.4904-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1a33] (2620:10d:c090:400::5:6dbd) by MW4PR03CA0201.namprd03.prod.outlook.com (2603:10b6:303:b8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 18:28:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 101793f3-d926-4304-0e81-08d9bc0ad493
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4919D0D209EB5729C62B627AD3719@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCwT7DEv12Ez+bbH8JVYoV0/I4iLovaCnsEu2ZRBOXd0hcynOkpV+wk8Cx1bBJIiKj2cP+IaPvNY9g4wu8J3oVst8kng++vV92okUEY8fkq/7j+2y/myGlh4i6zaa1T6eKAj8iq/GLRyryO5Xdv3kWGPmZS8ldB39CRjtY2ybPQAkT9JLFrsHS4EVfSCsOEsXSnwlCAJi1L4JC8atxJXQLKnSXqLfU7Fd3h5tnsXu+onutTyTjiUlJXhEBAGTo+QPQ4TUYN3xFfkYtWzLOZ3ufqX3oVLPTL3bRacb59vLRsV9Lyv5pTXcYZ23Ej8Y5nwy7mv1ZOkhXseEhCNtzXD/NBMUl/S85FYrKRM1xjriGxA4dJ4aaI56DyhhJRWD04FgPYICV0JKcSS1KPQcFJqxKy2ktwJeQGvqWzJZRsk5lPN8JWftEjNXHCryH6lbQbUosL4F9+UQ/hraPuvZEc4eEMgymuSm5L0v5ZcIBXOpMp5bQi/b8XDTGLTAPe3d9tIIy/9W4JY2GRqRTrgb0nQFCduz0KutfYxg34v1bE7a0HAxn4oPZecXAlWfe7/mXBGPK/7Eu+XJ24zBtRtl7G81DaHsR9HRhU4r66UyNQjtEfiUr0Qvtj7iE0CGJ34SkaAVPQYrbydjL2+C42ust03msT6prF6keEaRs9bNKzI2IEm4VGXmt5+FF8LqHl9ftyx+G6vorh5o2MHGqdcrOAS4yFSkIddZ1rimKPCPDNIoC8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(38100700002)(8676002)(2906002)(31696002)(31686004)(83380400001)(86362001)(6486002)(66556008)(66476007)(53546011)(66946007)(36756003)(5660300002)(110136005)(2616005)(52116002)(316002)(508600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWJlZEJheUZLbE54WG40UWpoYmUxbkd2OFVUMmdRbFVrOG40NGx5R3VjQUNV?=
 =?utf-8?B?WHV1d01vazA3Zmp2Q3lia25rUTkyb2xvMnYrdDlqTDNFQmtjK2QzS0xnekhD?=
 =?utf-8?B?RlIxUzJBWWx1YjhZdlpoaUdsM0M4d1dhZG9SUStLaFRmMnZrYUR6RURVblll?=
 =?utf-8?B?VVUwTDhGQkZsZnFYMjZxamFMdUVjc2ZxMCtob3hsZjR0VmgvdEI2RUZsOVln?=
 =?utf-8?B?ZUZjcG9IMGRiNFVOODJKdnNPVDJBYmhlM2ZvclFpS0hoT1BkZjAwQUJkZmd6?=
 =?utf-8?B?Yk1NZk1ybXJuWm90RHlIZDNMRS9qQ0xlZk5WTUN6MjlJakpYWXdnUXNDVU1i?=
 =?utf-8?B?V2xJRU9acXZlMEg1bjV0a2NVYmM5ZnUrRFFmQnRoUnJyL2t1dFBxdGw4WEUw?=
 =?utf-8?B?Q1BKam1VOW4vK2Q0TWtFZ2krTU5qcTZDT0FQTnVSa3JkdWhoL2dRaXQvTy9m?=
 =?utf-8?B?RC9WVVlGMm9ZNUxNbDd5S0hRY1ZQcmJjOEx3eEJ2dE0zSm9XSnZMSlNQTXVv?=
 =?utf-8?B?Vmt4QkdVWTRJb1BpNUw0T0tDV2JFc3Ixank2Rm41S2YxdUFYcUFYUElablJh?=
 =?utf-8?B?bk1rNmJubFhSdTRIdWJCcGdjZURlbVJXM3ljWFk1KzlzeDZCZDYwL0Q1T1A5?=
 =?utf-8?B?VEpuYU9hRHBlSVlNZEJjSU9CUFBrTEJLcTNRbCtyM29CMU9qZEMrZzVlbHEy?=
 =?utf-8?B?UzNoVk9iQUtQVVMxTzJQMlB6K0FkSnhFUm1kZnVSdU03aGRBekNUUkxhWWcr?=
 =?utf-8?B?NUdxVDFzVlg0NCtMY3lJWk4rZExyVjB6OGxNQXVvM2tsTUMzRkFjeStVTXk2?=
 =?utf-8?B?eVA4REVEeTQ5MVdlYXBQbUtOOTZ3aDR5TU9ZZDE1UXZ5K3BjYXBvbE9OZzJB?=
 =?utf-8?B?OTlldkRBQUF2ODRVbm9uN1Jqa2F0Q1A4VEFWczRDMGg1UXZMUVVmZk9KU2xB?=
 =?utf-8?B?eXZlbG1DUXRtbkhDNDJUUTRTMk9DYkFvWTNVbUdaZlAzSXhYNzM2UVh5bW1K?=
 =?utf-8?B?d0wrd0FoRGtOZzBaRERoODd0MVdVTmRubnAyd2ZXOWs2SjJPcE9vdVU5YnVh?=
 =?utf-8?B?cnB4aDNBOVIxS3IzSW4yN05QdUtXSkh2eThPVTRUV1J3TWxja0lkd3JkZ0la?=
 =?utf-8?B?bG95c0M3aWVtZ1VodHE3aGR6ZkdKTEQrV0J4MmphQ0RxL3Yvdm1pUEY3Z0Ur?=
 =?utf-8?B?NG10eGdEWVJQTkVnWk1MSFY3dUJqWmcxUlVkZk96Ykt6aVFxMjcyTmE2ODRR?=
 =?utf-8?B?NzlWSmtYK3VLTzYyMk5taGJqSmhKeVdkZExwSUFQVVhsaEgyMHNSR2ZWSVRW?=
 =?utf-8?B?R1BRVmNjUWZLTzB0WlN2cjJ4TFN3N080Tk9mNExqalFOU0xXNk5UV0RBQlMw?=
 =?utf-8?B?Z3pZVVI4VFVua2VFOEhJV0paeFUycWVDaUxyK0Q0VDEvZUhSOXZFZUoxRUlQ?=
 =?utf-8?B?dlBhSE5vSmRxRzVhSFl1WHgvcEhRbmlzQ0JOdVVyQ29DU0IvTDRha3JyQWhE?=
 =?utf-8?B?ZmJMdDQ4Z2w0aGF2VnN5QStvRC9OeHZtbjZ1cmJuWHY2a0FwREsrMnpER0Ju?=
 =?utf-8?B?OHgxWDlaLzhLb2RRN3Jsa2RZSTF3ZGV2M2RFamk2Tk9KTCttbXdyOHpFdnMy?=
 =?utf-8?B?b29hekMxRUVtNVAwajNLUHRHNDkzcFBGUVRBWlFuelpMMVZ2SnB4VEtpU0NQ?=
 =?utf-8?B?eVpBNU85U2VVajhFSkJmUC9uNkkyalZJYVJHOEpoS29UR04zcEhtRnROZ0V2?=
 =?utf-8?B?R2dMbzAwdzZwZGlyeEZzUHg5aVpKMWNzRjRiRTJ0SVo3ZlFBL1hMTWhBd0tr?=
 =?utf-8?B?ZTdySVpMQSs3VFo0MnRwU3oxd2JVZjhqYk9wbzI4dVJhTTFkQ0pmbnZpUFU2?=
 =?utf-8?B?bFh2bVJqMlExVWE3NEZDZ0xQOEdldXhqQlBxNlBNRFErZUlETVp5Q3duQ21L?=
 =?utf-8?B?MEw5eHhlYWlhS1JXUGpKQ3V6NHpjOGMrZEJ3QW9yTTVFQUx6cmJ3RkN3Y3p6?=
 =?utf-8?B?WkdtYTBqQmxZZXo1bENyVXlTT3hndzNuYWRjWG1qNmlDQWpFdFNsbU4rVVRy?=
 =?utf-8?B?VVk5WTIrVXJPVmpxc1g4d3dSVWNZNzRJc1lDNGJUazVmNTdZZ2p5SVpHV2lj?=
 =?utf-8?Q?UYnGnQ6NmWUeAQ3TN7J8lpm/T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 101793f3-d926-4304-0e81-08d9bc0ad493
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 18:28:15.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOGs7wSdvjXfTHN8ie/ouU3iXEIB0dnAwNk8Wpvnqrqe3AaxlJXD+feW3vmRwTjr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: nQsaVb6CgHc6uadcZAYyF3AnyqajgmW9
X-Proofpoint-GUID: nQsaVb6CgHc6uadcZAYyF3AnyqajgmW9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_07,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112100103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/21 3:19 AM, Daniel T. Lee wrote:
> Currently from syscall entry, argument can't be fetched correctly as a
> result of register cleanup.
> 
>      commit 6b8cf5cc9965 ("x86/entry/64/compat: Clear registers for compat syscalls, to reduce speculation attack surface")
> 
> For example in upper commit, registers are cleaned prior to syscall.
> To be more specific, sys_write syscall has count size as a third argument.
> But this can't be fetched from __x64_sys_enter/__s390x_sys_enter due to
> register cleanup. (e.g. [x86] xorl %r8d, %r8d / [s390x] xgr %r7, %r7)

is this the real reason? Did you build 32-bit user space application?
Note that the above commit is for compat syscalls.

> 
> This commit fix this problem by modifying the trace event to ksys_write
> instead of sys_write syscall entry.
> 
>      # Wrong example of 'write()' syscall argument fetching
>      # ./tracex2
>      ...
>      pid 50909 cmd dd uid 0
>             syscall write() stats
>       byte_size       : count     distribution
>         1 -> 1        : 4968837  |************************************* |
> 
>      # Successful example of 'write()' syscall argument fetching
>      # (dd's write bytes at a time defaults to 512)
>      # ./tracex2
>      ...
>      pid 3095 cmd dd uid 0
>             syscall write() stats
>       byte_size       : count     distribution
>      ...
>       256 -> 511      : 0        |                                      |
>       512 -> 1023     : 4968844  |************************************* |
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>   samples/bpf/tracex2_kern.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> index 5bc696bac27d..96dff3bea227 100644
> --- a/samples/bpf/tracex2_kern.c
> +++ b/samples/bpf/tracex2_kern.c
> @@ -78,7 +78,7 @@ struct {
>   	__uint(max_entries, 1024);
>   } my_hist_map SEC(".maps");
>   
> -SEC("kprobe/" SYSCALL(sys_write))
> +SEC("kprobe/ksys_write")
>   int bpf_prog3(struct pt_regs *ctx)
>   {
>   	long write_size = PT_REGS_PARM3(ctx);

I think the real reason of the failure is due to SYSCALL_WRAPPER.
Please take a look at test_probe_write_user_kern.c.

The issue with ksys_write() is that it can easily be inlined. For 
example, the source code,

ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count)
{
	...
}

SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
                 size_t, count)
{
         return ksys_write(fd, buf, count);
}

In my 5.12 kernel, I have
ffffffff81053b00 <__x64_sys_write>:
ffffffff81053b00: 0f 1f 44 00 00        nopl    (%rax,%rax)
ffffffff81053b05: 41 57                 pushq   %r15
ffffffff81053b07: 41 56                 pushq   %r14
ffffffff81053b09: 41 55                 pushq   %r13
ffffffff81053b0b: 41 54                 pushq   %r12
ffffffff81053b0d: 53                    pushq   %rbx
ffffffff81053b0e: 48 83 ec 10           subq    $16, %rsp
ffffffff81053b12: 65 48 8b 04 25 28 00 00 00    movq    %gs:40, %rax
ffffffff81053b1b: 48 89 44 24 08        movq    %rax, 8(%rsp)
ffffffff81053b20: 8b 47 70              movl    112(%rdi), %eax
ffffffff81053b23: 4c 8b 7f 60           movq    96(%rdi), %r15
ffffffff81053b27: 4c 8b 67 68           movq    104(%rdi), %r12
ffffffff81053b2b: 89 c7                 movl    %eax, %edi
ffffffff81053b2d: e8 6e a3 00 00        callq   0xffffffff8105dea0 
<__fdget_pos>
...

The ksys_write() is inlined.
