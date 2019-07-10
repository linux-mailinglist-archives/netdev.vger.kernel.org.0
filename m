Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDD4645E4
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGJLr2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 07:47:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbfGJLr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:47:28 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ABl1gH080723
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:47:27 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tncrsxnrc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:47:26 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 10 Jul 2019 12:47:24 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 10 Jul 2019 12:47:19 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6ABlIjD41746756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 11:47:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8341F4C044;
        Wed, 10 Jul 2019 11:47:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 398A14C04E;
        Wed, 10 Jul 2019 11:47:18 +0000 (GMT)
Received: from dyn-9-152-97-237.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jul 2019 11:47:18 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v3 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in
 userspace
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAEf4BzY0kO2si_ajouYNfsauaWdHkj042++bLaHe1W_G885i=g@mail.gmail.com>
Date:   Wed, 10 Jul 2019 13:47:17 +0200
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Y Song <ys114321@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        david.daney@cavium.com
Content-Transfer-Encoding: 8BIT
References: <20190709151809.37539-1-iii@linux.ibm.com>
 <20190709151809.37539-4-iii@linux.ibm.com>
 <CAEf4BzY0kO2si_ajouYNfsauaWdHkj042++bLaHe1W_G885i=g@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071011-4275-0000-0000-0000034B5687
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071011-4276-0000-0000-0000385B5A2E
Message-Id: <1F8BDE1D-08C9-4C71-A281-92804455F5EF@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 09.07.2019 um 19:48 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> 
> On Tue, Jul 9, 2019 at 8:19 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> 
>> Right now, on certain architectures, these macros are usable only with
>> kernel headers. This patch makes it possible to use them with userspace
>> headers and, as a consequence, not only in BPF samples, but also in BPF
>> selftests.
>> 
>> On s390, provide the forward declaration of struct pt_regs and cast it
>> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
>> of the full struct pt_regs, s390 exposes only its first member
>> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
>> (in selftests) and kernel (in samples) headers. It was added in commit
>> 466698e654e8 ("s390/bpf: correct broken uapi for
>> BPF_PROG_TYPE_PERF_EVENT program type").
>> 
>> Ditto on arm64.
>> 
>> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390 and
>> arm64, x86 provides struct pt_regs to both userspace and kernel, however,
>> with different member names.
>> 
>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> ---
> 
> Just curious, what did you use as a reference for which register
> corresponds to which PARM, RET, etc for different archs? I've tried to
> look it up the other day, and it wasn't as straightforward to find as
> I hoped for, so maybe I'm missing something obvious.

For this particular change I did not have to look it up, because it all
was already in the code, I just needed to adapt it to userspace headers.
Normally I would google for „abi supplement“ to find this information.
A lazy way would be to simply ask the (cross-)compiler:

cat <<HERE | aarch64-linux-gnu-gcc -x c -O3 -S - -o -
int f(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j);
int g() { return -f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10); }
HERE

I’ve just double checked the supported arches, and noticed that:

#define PT_REGS_PARM5(x) ((x)->uregs[4])
for bpf_target_arm (arm-linux-gnueabihf) looks wrong:
the 5th parameter should be passed on stack. This observation matches
[1].

#define PT_REGS_RC(x) ((x)->regs[1])
for bpf_target_mips (mips64el-linux-gnuabi64) also looks wrong:
the return value should be in register 2. This observation matches [2].

Since I’m not an expert on those architectures, my conclusions could be
incorrect (e.g. becase a different ABI is normally used in practice).
Adrian and David, could you please correct me if I’m wrong?

[1] http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042f/IHI0042F_aapcs.pdf
[2] ftp://www.linux-mips.org/pub/linux/mips/doc/ABI/psABI_mips3.0.pdf

>> tools/testing/selftests/bpf/bpf_helpers.h | 61 +++++++++++++++--------
>> 1 file changed, 41 insertions(+), 20 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
>> index 73071a94769a..212ec564e5c3 100644
>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
>> @@ -358,6 +358,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>> 
>> #if defined(bpf_target_x86)
>> 
>> +#ifdef __KERNEL__
>> #define PT_REGS_PARM1(x) ((x)->di)
>> #define PT_REGS_PARM2(x) ((x)->si)
>> #define PT_REGS_PARM3(x) ((x)->dx)
>> @@ -368,19 +369,35 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>> #define PT_REGS_RC(x) ((x)->ax)
>> #define PT_REGS_SP(x) ((x)->sp)
>> #define PT_REGS_IP(x) ((x)->ip)
>> +#else
>> +#define PT_REGS_PARM1(x) ((x)->rdi)
>> +#define PT_REGS_PARM2(x) ((x)->rsi)
>> +#define PT_REGS_PARM3(x) ((x)->rdx)
>> +#define PT_REGS_PARM4(x) ((x)->rcx)
>> +#define PT_REGS_PARM5(x) ((x)->r8)
>> +#define PT_REGS_RET(x) ((x)->rsp)
>> +#define PT_REGS_FP(x) ((x)->rbp)
>> +#define PT_REGS_RC(x) ((x)->rax)
>> +#define PT_REGS_SP(x) ((x)->rsp)
>> +#define PT_REGS_IP(x) ((x)->rip)
> 
> Will this also work for 32-bit x86?

Thanks, this is a good catch: this builds, but makes 64-bit accesses, as if it used the 64-bit
variant of pt_regs. I will fix this.
