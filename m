Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC9932E691
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 11:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCEKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 05:40:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12982 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhCEKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 05:40:13 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125AXvrZ129651;
        Fri, 5 Mar 2021 05:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bHErTgvFn/7z0+gGvvDjNogND6V6dIHqBM4TFg1x9bY=;
 b=CVVEL2s6/GDbgdF1z1+bR2h5q0s/n3d3/0waq/OI/0kxuQQFufW/g9f/IKTzVPtkKikA
 PdmUm9O3q28cOAGQJN2j5gLlvlu5PoplvDmRnuDZgxrrlb/It/DLkXv1aBpZo5qBuEdy
 DJ7sH01Ojq04Mm1P5fvO/iD6ImDZI3P51WKbMsJyBgna8CDwcwzRgF2REK3TschdINBn
 gNFmiIpBCbTaBotXf7M8SNLrRxJJZhb8udLTbYLdDkQoQqWsJftL6g4NRZ7o1n5XCI7b
 HvvpSiuone0YYCvy15vX02SkWGaAFwmiidI7SwB8YaTdXnSMN8xKI3Yv97X7dnoXrdsw 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373fr9dm6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 05:39:45 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 125AYpbG134828;
        Fri, 5 Mar 2021 05:39:44 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373fr9dm5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 05:39:44 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125AcVUN004386;
        Fri, 5 Mar 2021 10:39:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmkkpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 10:39:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125AddHv40436092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 10:39:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5776042042;
        Fri,  5 Mar 2021 10:39:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE6042045;
        Fri,  5 Mar 2021 10:39:38 +0000 (GMT)
Received: from localhost (unknown [9.85.120.65])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 10:39:38 +0000 (GMT)
Date:   Thu, 4 Mar 2021 07:04:59 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Yonghong Song <yhs@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <20210304013459.GG1913@DESKTOP-TDPLP67.localdomain>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
 <YD4U1x2SbTlJF2QU@krava>
 <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
 <87blbzsq3g.fsf@mpe.ellerman.id.au>
 <YEEC8EiOiBaFhqxF@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEEC8EiOiBaFhqxF@krava>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_05:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=97 impostorscore=0 bulkscore=0
 mlxlogscore=-153 adultscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=97 spamscore=97
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/03/04 04:55PM, Jiri Olsa wrote:
> On Thu, Mar 04, 2021 at 11:46:27AM +1100, Michael Ellerman wrote:
> > "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
> > > On 2021/03/02 11:35AM, Jiri Olsa wrote:
> > >> On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
> > >> > 
> > >> > 
> > >> > On 3/1/21 11:04 AM, Jiri Olsa wrote:
> > >> > > When testing uprobes we the test gets GEP (Global Entry Point)
> > >> > > address from kallsyms, but then the function is called locally
> > >> > > so the uprobe is not triggered.
> > >> > > 
> > >> > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > >> > > for powerpc arch.
> > >> > > 
> > >> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >> > > ---
> > >> > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > >> > >   1 file changed, 17 insertions(+), 1 deletion(-)
> > >> > > 
> > >> > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > >> > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > >> > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > >> > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > >> > > @@ -2,6 +2,22 @@
> > >> > >   #include <test_progs.h>
> > >> > >   #include "test_attach_probe.skel.h"
> > >> > > +#if defined(__powerpc64__)
> > >
> > > This needs to be specific to ELF v2 ABI, so you'll need to check 
> > > _CALL_ELF. See commit d5c2e2c17ae1d6 ("perf probe ppc64le: Prefer symbol 
> > > table lookup over DWARF") for an example.
> > >
> > >> > > +/*
> > >> > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > >> > > + * but then the function is called locally, so we need to adjust
> > >> > > + * the address to get LEP (Local Entry Point).
> > >> > 
> > >> > Any documentation in the kernel about this behavior? This will
> > >> > help to validate the change without trying with powerpc64 qemu...
> > >
> > > I don't think we have documented this in the kernel anywhere, but this 
> > > is specific to the ELF v2 ABI and is described there:
> > > - 2.3.2.1.  Function Prologue: 
> > >   http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240___RefHeading___Toc377640597.html
> > > - 3.4.1.  Symbol Values:
> > >    http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655241_95185.html
> > 
> > There's a comment in ppc_function_entry(), but I don't think we have any
> > actual "documentation".
> > 
> > static inline unsigned long ppc_function_entry(void *func)
> > {
> > #ifdef PPC64_ELF_ABI_v2
> > 	u32 *insn = func;
> > 
> > 	/*
> > 	 * A PPC64 ABIv2 function may have a local and a global entry
> > 	 * point. We need to use the local entry point when patching
> > 	 * functions, so identify and step over the global entry point
> > 	 * sequence.
> 
> hm, so I need to do the instructions check below as well

It's a good check, but probably not necessary. In most functions, we 
expect to be able to probe two instructions later without much of a 
change to affect function tracing for userspace. For this reason, we 
just probe at an offset of 8 as a reasonable fallback.

It is definetely good if we can come up with a better approach though.

> 
> > 	 *
> > 	 * The global entry point sequence is always of the form:
> > 	 *
> > 	 * addis r2,r12,XXXX
> > 	 * addi  r2,r2,XXXX
> > 	 *
> > 	 * A linker optimisation may convert the addis to lis:
> > 	 *
> > 	 * lis   r2,XXXX
> > 	 * addi  r2,r2,XXXX
> > 	 */
> > 	if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
> > 	     ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
> > 	    ((*(insn+1) & OP_RT_RA_MASK) == ADDI_R2_R2))
> 
> is this check/instructions specific to kernel code?
> 
> In the test prog I see following instructions:
> 
> Dump of assembler code for function get_base_addr:
>    0x0000000010034cb0 <+0>:     lis     r2,4256
>    0x0000000010034cb4 <+4>:     addi    r2,r2,31488
>    ...
> 
> but first instruction does not match the check in kernel code above:
> 
> 	1.insn value:	0x3c4010a0
> 	2.insn value:	0x38427b00
> 
> the used defines are:
> 	#define OP_RT_RA_MASK   0xffff0000UL
> 	#define LIS_R2          0x3c020000UL
> 	#define ADDIS_R2_R12    0x3c4c0000UL
> 	#define ADDI_R2_R2      0x38420000UL

Good catch! That's wrong, and I suspect we haven't noticed since kernel 
almost always ends up using the addis variant. I will send a fix for 
this.

> 
> 
> maybe we could skip the check, and run the test twice: first on
> kallsym address and if the uprobe is not hit we will run it again
> on address + 8

Sure, like I mentioned, I'm fine with any approach. Offset'ing into the 
function by 8 is easy and generally works. Re-trying is fine too. The 
proper approach will requires us to consult the symbol table and check 
st_other field [see commit 0b3c2264ae30ed ("perf symbols: Fix kallsyms 
perf test on ppc64le")]

Thanks,
- Naveen
