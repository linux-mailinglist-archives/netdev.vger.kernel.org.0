Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363DF2DB696
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 23:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgLOWki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 17:40:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgLOWkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 17:40:03 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFMV94F032510;
        Tue, 15 Dec 2020 14:39:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4cpRdpqv/qVrdcG92Z8e1xTPUTMBsmwo41W6HTBxebc=;
 b=q6NjJovoo0RGiL8S++LD+1KSTmkazdQK1aiO9ntkjpyNbPyVL1QC2s6bCQic1B1/QxJk
 IBKPNVkMe93Hlff8e2u4uBJp1SzXpMd4Xs3dQuyfP75z0YenjK8jdmfeC8ZUSz+zkuk2
 WX2Qg3XMIi2UhLO9vrZvpkqz1NpgKoxp1oI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35eypsjmst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Dec 2020 14:39:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 14:39:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaxIPU0B22bxuevWAClhODhwRV/vIhOk6RQfyYr504QUoO4NclTL5PC3TYnpWk0eOcOTBJfwhH0MpmmQi1ZvOu7sam6noWk7Q8f3FZHlUWqnRGqo7NcbHnHYf4q9LkomNku6Z+xliijlbisbCCwsOX7V0d1IR/5V20kNTww+FR+zsW1c/n+OGGJ4LPbHkC4z9Mn66KdiNQlzUYY1hSO/qw/absuItq6x3SgdkLYHGfaxCVUcik495rVLhijrW7KZQ6xIqdRU+f4Q/NF+BCCfNsgG8bLKAzecsiYWI3tc/ZbCpleRZnUH6RCtBLwxMbDptxpZZmhb9CCAk+d6MstM5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cpRdpqv/qVrdcG92Z8e1xTPUTMBsmwo41W6HTBxebc=;
 b=CWwCkGaLIEBQsqfQsjBS2E2G/ycRVf84S9nL91f6vS3hyjORBzSmEnv/3YCl+eLcGDrG5HxrU6BiybbDIZhDoLKPHFpDSawFxKRgo/R5qe2BBPEF8hTFWzDc7wxCYqTfgMkJ//7QTGHxRM/OjmtH5iYtwKZF2xbMSmGOMQz3TGXJSXDOQ1QGRl3AZc7tk7fk0AQXvHcszYHUEZiJ2swyPZsozMMH35K+UBlxuFfP1H539QiMuyUtYrZe5WBff7aM7A+tFFwPq6zFCEADegq7H/3HgyNMgoBxQRupIeeOTqLcacr0gzqvlDQB2llaIl+D3u80n+bxyHk2RGOebVld5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cpRdpqv/qVrdcG92Z8e1xTPUTMBsmwo41W6HTBxebc=;
 b=Pg3kA6zy1nsiYNxtAQrmhHdQjzaaJp533bJ2tdAo+1r633MXzim/9XV6ThY06bgljLfVyc2anRCpLet6EB6NOwzPAXDA+J1M/T9/RdvFBmEcuMHoq960miZ8bwDujmTmUYkjSCItgdNdy04kQjE57hPjDvUukoxNpJL9MmGjXZA=
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN7PR15MB2242.namprd15.prod.outlook.com (2603:10b6:406:81::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.25; Tue, 15 Dec
 2020 22:39:03 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::99d5:a35d:b921:6699]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::99d5:a35d:b921:6699%7]) with mapi id 15.20.3611.042; Tue, 15 Dec 2020
 22:39:02 +0000
Subject: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support module
 BTF for BPF_TYPE_ID_TARGET CO-RE relocation
To:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20201205025140.443115-1-andrii@kernel.org>
 <alpine.LRH.2.23.451.2012071623080.3652@localhost>
 <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
 <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
 <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp>
 <alpine.LRH.2.23.451.2012092308240.26400@localhost>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
Date:   Tue, 15 Dec 2020 14:38:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <alpine.LRH.2.23.451.2012092308240.26400@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:dcd7]
X-ClientProxiedBy: MW2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:907:1::28) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:dcd7) by MW2PR16CA0051.namprd16.prod.outlook.com (2603:10b6:907:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 22:39:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74554235-8b73-4242-7638-08d8a14a390f
X-MS-TrafficTypeDiagnostic: BN7PR15MB2242:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR15MB22426661EA39F860355E4E3BD7C60@BN7PR15MB2242.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtfRkEy5SUCongROGF24+BU8Qq/33WeuqbIgmo8hh3/K3km1R5RYgYMS0F+pr3JXMYwJQAha4/ZSu7f2jxluESGpIGb7idE7MYivcD0kMLoIiI9wLMeKgZYbki+AvTjEOqkgoN//fZO//5aabFrbYkFEZS3BAm0XgNMjBDriylhDSGEp1X8WzKa0ULd/fopQvBbp8vxX8elx2e5CNGNWluJBJTEfM0QSAM/kOhlbzo7twIaoEUDfm5EndKN/bPxwApZ9hoXpE3j+LP9ynavLDmlf4SvlEYFh8HG4iPTFkr9+e01jjOuSSDWL68I1CbK77xIKCrE8K0b2CS1Bu6GUAGTx6u+W1pUrZNosav7ekOJhKhL4OxlboAjS/onr1P9V9AeUdhdWKVTBxup9NdrdfWA3YxurrtaTR8a+OPvuBEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(66556008)(478600001)(316002)(66476007)(2906002)(6666004)(5660300002)(110136005)(54906003)(8936002)(31696002)(4326008)(36756003)(66946007)(16526019)(86362001)(2616005)(31686004)(6486002)(83380400001)(8676002)(52116002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R3NVSkt2SUFJWlAzSVJWbGRvdVF1eTVkU1N4T2NselFyZlRkOGs4WTBZcVJD?=
 =?utf-8?B?L1AvRFRhN3cxSThDRlBWaGoyV2w4UXp6OTc1TkRsS1F4aS9qNGZPZW5OdnhJ?=
 =?utf-8?B?clhMNTNjRE0wcjg0Y0pkOG9QNlEvbG5MU3F2aFlCS2pFR0FaWTljNkxJK1Y3?=
 =?utf-8?B?NVJEMGhlRVFUMHQ0dlFyeGRFRkJxaENtUzluTk9iZmR2aW1VY0dXR3R0aFZR?=
 =?utf-8?B?QThYZDdQOHBJdzhUcDZnM0gzTWNZZGljcDdveDAyM3B1NXNtajhtTjZwd0o1?=
 =?utf-8?B?ZjZmaW5vSCtLVk1IN2lrNk5JMmZEcjJpbVp3VlI3RjN1WlhhdktxTTN4Y0N4?=
 =?utf-8?B?dUdLbEhrRzh5T2F1V3JDMlFJeld4RkwxTElkNkZGRDlFMC9Rc2t2b29zTFlq?=
 =?utf-8?B?U1daUWpDSmFQeDF2VDJKTGpzU3JmMDdiRHJoeUR3MS9pNytJTC9ub3ZEelBL?=
 =?utf-8?B?czc2N285emhJZnU4Q2lxR1VEVnZUOHYzcjlpNG5PQjl0cG9aOStRMlh0d1dE?=
 =?utf-8?B?UVlnQnhEV0kwNzdkcy9PTTRSYkZFWXdNRXkrZUV2cTV6a3B4M1lteTFxYWZX?=
 =?utf-8?B?QStxcGxyd1F0N1IrWVZ3ZGtrWG1zZ095VktML2d5bU5OdnplWlQ2WHNiNVRx?=
 =?utf-8?B?SEJTQVpDWEV3cTdTNXRsRSt3V00wUmhMakVvczdXTnREWnNNakd6ekxodU80?=
 =?utf-8?B?SFpwWE1iZnZ0bHJJRkFoeXJDTUxkT2NrTS8rdStpUjkyTHhxb3lVTGs5a1Bh?=
 =?utf-8?B?eThscHZjbVQvVjgwbjV4aG5mdUVjSkpSeHZrMmVDQXFkZmRFZnlrM1k1dGx1?=
 =?utf-8?B?YWdOQUlSRGlVQ2FsSExhNTJ5Y2lxRmh4aFo1TzM1ODhCMGQ4VzVieWdHNlpZ?=
 =?utf-8?B?QU1EUXVDMGl2ZHpWcTJXdU1Ib0xuNXdKZzFTTUI3dXdxbnRCdW1lUVF5Zm42?=
 =?utf-8?B?ZEY1eTQyNnpSUjBHRUc5MENpL0tFbk5JRUI2dUtFZm5zUGQ2VXNjTDdldkNw?=
 =?utf-8?B?cE1oYllUVk9CbisvellncU1Jalc1Y2hPMUlKam0xYUNqMkJaZytLSTRyZUk4?=
 =?utf-8?B?ajFESjMrWTV6VFZzZE5KUExoL29ldG9HSVFaeGhlZFhBNzlFZkIvZTJKdXNo?=
 =?utf-8?B?ZEMxZFdXL24vL3psU2E1NU9ocXJOMHQ2Sm5IL0Q3ZGp4VDRLV0NMTnNCZmJv?=
 =?utf-8?B?cDIwclZlYnppeFF3dkhtYWt0WVBFbm9NaExLcmZpdUV1TFpTMXFJLzFKMERp?=
 =?utf-8?B?ODJmamJqRXg1WGFhT1lSMXh0QnYyWVdMa0RCRmY5R2tRYitldnl3Z3h3a3N0?=
 =?utf-8?B?YWZTaUM3amJoaTZRelV3M1AreTdCMzR0dnZ1bG9adDNoSUpzdENTaXQwZndI?=
 =?utf-8?B?TWtWNlZyVWtzc1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 22:39:02.9142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 74554235-8b73-4242-7638-08d8a14a390f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aY4XYAVJp3GJMbcYeKQCv7EB8X8id4+KZct9Gx0/hUP/6ZzDtNSbIHAADzAolTi3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2242
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1011 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150152
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:21:43PM +0000, Alan Maguire wrote:
> Right, that's exactly it.  A pair of generic tracing BPF programs are
> used, and they attach to kprobe/kretprobes, and when they run they
> use the arguments plus the map details about BTF ids of those 
> arguments to run bpf_snprintf_btf(), and send perf events to 
> userspace containing the results.
...
> That would be fantastic! We could do that from the context passed 
> into a kprobe program as the IP in struct pt_regs points at the 
> function. kretprobes seems a bit trickier as in that case the IP in 
> struct pt_regs is actually set to kretprobe_trampoline rather than 
> the function we're returning from due to how kretprobes work; maybe 
> there's another way to get it in that case though..

Yeah. kprobe's IP doesn't match kretprobe's IP which makes such tracing
use cases more complicated. Also kretprobe is quite slow. See
prog_tests/test_overhead and selftests/bpf/bench.
I think the key realization is that the user space knows all IPs
it will attach to. It has to know all IPs otherwise
hashmap{key=ip, value=btf_data} is not possible.
Obvious, right ? What it means that we can use this key observation
to build better interfaces at all layers. kprobes are slow to
setup one by one. It's also slow to execute. fentry/fexit is slow
to setup, but fast to execute. Jiri proposed a batching api for
fentry, but it doesn't quite make sense from api perspective
since user space has to give different bpf prog for every fentry.
bpf trampoline is unique for every target fentry kernel function.
The batched attach would make sense for kprobe because one prog
can be attached everywhere. But kprobe is slow.
This thought process justifies an addition of a new program
type where one program can attach to multiple fentry.
Since fentry ctx is no longer fixed the verifier won't be able to
track btf_id-s of arguments, but btf based pointer walking is fast
and powerful, so if btf is passed into the program there could
be a helper that does dynamic cast from long to PTR_TO_BTF_ID.
Since such new fentry prog will have btf in the context and
there will be no need for user space to populate hashmap and
mess with IPs. And the best part that batched attach will not
only be desired, but mandatory part of the api.
So I'm proposing to extend BPF_PROG_LOAD cmd with an array of
pairs (attach_obj_fd, attach_btf_id).
The fentry prog in .c file might even have a regex in attach pattern:
SEC("fentry/sys_*")
int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1,
              __u64 arg2, ...__u64 arg6)
{
   struct btf_ptr ptr1 = {
     .ptr = arg1,
     .type_id = bpf_core_type_id_kernel(struct foo),
     .btf_obj = btf_obj,
   },
   ptr2 = {
     .ptr = arg2,
     .type_id = bpf_core_type_id_kernel(struct bar),
     .btf_obj = btf_obj,
   };
   bpf_snprintf_btf(,, &ptr1, sizeof(ptr1), );
   bpf_snprintf_btf(,, &ptr1, sizeof(ptr2), );
}

libbpf will process the attach regex and find all matching functions in
the kernel and in the kernel modules. Then it will pass this list of
(fd,btf_id) pairs to the kernel. The kernel will find IP addresses and
BTFs of all functions. It will generate single bpf trampoline to handle
all the functions. Either one trampoline or multiple trampolines is an
implementation detail. It could be one trampoline that does lookup based
on IP to find btf_obj, btf_id to pass into the program or multiple
trampolines that share most of the code with N unique trampoline
prefixes with hardcoded btf_obj, btf_id. The argument save/restore code
can be the same for all fentries. The same way we can support single
fexit prog attaching to multiple kernel functions. And even single
fmod_ret prog attaching to multiple. The batching part will make
attaching to thousands of functions efficient. We can use batched
text_poke_bp, etc.

As far as dynamic btf casting helper we could do something like this:
SEC("fentry/sys_*")
int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1, __u64
arg2, ...__u64 arg6)
{
   struct sk_buff *skb;
   struct task_struct *task;

   skb = bpf_dynamic_cast(btf_obj, btf_id, 1, arg1,
                          bpf_core_type_id_kernel(skb));
   task = bpf_dynamic_cast(btf_obj, btf_id, 2, arg2,
                           bpf_core_type_id_kernel(task));
   skb->len + task->status;
}
The dynamic part of the helper will walk btf of func_proto that was
pointed to by 'btf_id' argument. It will find Nth argument and
if argument's btf_id matches the last u32 passed into bpf_dynamic_cast()
it will return ptr_to_btf_id. The verifier needs 5th u32 arg to know
const value of btf_id during verification.
The execution time of this casting helper will be pretty fast.
Thoughts?

