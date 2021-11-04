Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B760445401
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhKDNjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:39:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhKDNja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:39:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4D0vks029134;
        Thu, 4 Nov 2021 13:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0NKqOHkWn584dsEUZYyC9VqUTTaZlKGwsHtttpGsRiM=;
 b=JMy7EwaEriTsEHZtmKzajkEfhUKEQRZfIG08C4YGBF/jL1IwtQ3e9p/noPfpI8/CnT93
 SLL5cHgHLCCydgbtawQjOyZ3zAH4fbil9EpYTOiZZlS9rWmtfNYU0aEd5XxRFOUsnHtq
 pB8mkOI6WjaEKNJU9ia+QUKxtkaSVO+iw0AUXfSiH38VbqITuZnUNV7ZE7LaVnoZdh6s
 g9AP9/F5Bs13LJUIX8LwbIOaLzkPmEC4JtpqP4s1apjTUjPpUjcNFShj/TVzs9BDHETb
 40uvMSbNC2dT+AiMvwarSVF516O2Z+eXHneDX43xkps5Wil3ueZQXRmZgYt4yrholJIH xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4ftuh1wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 13:36:29 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4D0xAL029437;
        Thu, 4 Nov 2021 13:36:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4ftuh1vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 13:36:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4DXAKb022342;
        Thu, 4 Nov 2021 13:36:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c0wak09fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 13:36:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4DTtLN56295772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 13:29:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C91611C066;
        Thu,  4 Nov 2021 13:36:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5033711C064;
        Thu,  4 Nov 2021 13:36:22 +0000 (GMT)
Received: from sig-9-145-12-156.uk.ibm.com (unknown [9.145.12.156])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 13:36:22 +0000 (GMT)
Message-ID: <b74fc5436d0b21ccd72917cf94b8bbc7eb9e5179.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next v5] bpf: Change value of MAX_TAIL_CALL_CNT from
 32 to 33
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, naveen.n.rao@linux.ibm.com,
        luke.r.nels@gmail.com, xi.wang@gmail.com, bjorn@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, udknight@gmail.com,
        davem@davemloft.net
Date:   Thu, 04 Nov 2021 14:36:22 +0100
In-Reply-To: <1635990610-4448-1-git-send-email-yangtiezhu@loongson.cn>
References: <1635990610-4448-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HSMrYqAgnVrtL1PAH8GO7nx43JvD8AKD
X-Proofpoint-GUID: GLT032ugz6i9mkefpO58Nv7IY-mLvh1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_04,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-04 at 09:50 +0800, Tiezhu Yang wrote:
> In the current code, the actual max tail call count is 33 which is
> greater
> than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not
> consistent
> with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and
> need to
> spend some time to think about the reason at the first glance.
> 
> We can see the historical evolution from commit 04fd61ab36ec ("bpf:
> allow
> bpf programs to tail-call other bpf programs") and commit
> f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit").
> 
> In order to avoid changing existing behavior, the actual limit is 33
> now,
> this is reasonable.
> 
> After commit 874be05f525e ("bpf, tests: Add tail call test suite"),
> we can
> see there exists failed testcase.
> 
> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>  # echo 0 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
> 
> On some archs:
>  # echo 1 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf
>  # dmesg | grep -w FAIL
>  Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> 
> Although the above failed testcase has been fixed in commit
> 18935a72eb25
> ("bpf/tests: Fix error in tail call limit tests"), it is still
> necessary
> to change the value of MAX_TAIL_CALL_CNT from 32 to 33 to make the
> code
> more readable, then do some small changes of the related code.
> 
> With this patch, it does not change the current limit 33,
> MAX_TAIL_CALL_CNT
> can reflect the actual max tail call count, the related tailcall
> testcases
> in test_bpf and selftests can work well for the interpreter and the
> JIT.
> 
> Here are the test results on x86_64:
> 
>  # uname -m
>  x86_64
>  # echo 0 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf test_suite=test_tail_calls
>  # dmesg | tail -1
>  test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [0/8 JIT'ed]
>  # rmmod test_bpf
>  # echo 1 > /proc/sys/net/core/bpf_jit_enable
>  # modprobe test_bpf test_suite=test_tail_calls
>  # dmesg | tail -1
>  test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
>  # rmmod test_bpf
>  # ./test_progs -t tailcalls
>  #142 tailcalls:OK
>  Summary: 1/11 PASSED, 0 SKIPPED, 0 FAILED
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> Acked-by: Björn Töpel <bjorn@kernel.org>
> ---
> 
> v5: Use RV_REG_TCC directly to save one move for RISC-V,
>     suggested by Björn Töpel, thank you.
> 
> v4: Use >= as check condition,
>     suggested by Daniel Borkmann, thank you.
> 
>  arch/arm/net/bpf_jit_32.c         |  5 +++--
>  arch/arm64/net/bpf_jit_comp.c     |  5 +++--
>  arch/mips/net/bpf_jit_comp32.c    |  2 +-
>  arch/mips/net/bpf_jit_comp64.c    |  2 +-
>  arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
>  arch/powerpc/net/bpf_jit_comp64.c |  4 ++--
>  arch/riscv/net/bpf_jit_comp32.c   |  6 ++----
>  arch/riscv/net/bpf_jit_comp64.c   |  7 +++----
>  arch/s390/net/bpf_jit_comp.c      |  6 +++---
>  arch/sparc/net/bpf_jit_comp_64.c  |  2 +-
>  arch/x86/net/bpf_jit_comp.c       | 10 +++++-----
>  arch/x86/net/bpf_jit_comp32.c     |  4 ++--
>  include/linux/bpf.h               |  2 +-
>  include/uapi/linux/bpf.h          |  2 +-
>  kernel/bpf/core.c                 |  3 ++-
>  lib/test_bpf.c                    |  4 ++--
>  tools/include/uapi/linux/bpf.h    |  2 +-
>  17 files changed, 35 insertions(+), 35 deletions(-)

[...]

> diff --git a/arch/s390/net/bpf_jit_comp.c
> b/arch/s390/net/bpf_jit_comp.c
> index 1a374d0..3553cfc 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -1369,7 +1369,7 @@ static noinline int bpf_jit_insn(struct bpf_jit
> *jit, struct bpf_prog *fp,
>                                  jit->prg);
>  
>                 /*
> -                * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
> +                * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
>                  *         goto out;
>                  */
>  
> @@ -1381,9 +1381,9 @@ static noinline int bpf_jit_insn(struct bpf_jit
> *jit, struct bpf_prog *fp,
>                 EMIT4_IMM(0xa7080000, REG_W0, 1);
>                 /* laal %w1,%w0,off(%r15) */
>                 EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0,
> REG_15, off);
> -               /* clij %w1,MAX_TAIL_CALL_CNT,0x2,out */
> +               /* clij %w1,MAX_TAIL_CALL_CNT-1,0x2,out */
>                 patch_2_clij = jit->prg;
> -               EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1,
> MAX_TAIL_CALL_CNT,
> +               EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1,
> MAX_TAIL_CALL_CNT - 1,
>                                  2, jit->prg);
>  
>                 /*

For the s390 part:

Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

[...]

