Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA35A32C494
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444735AbhCDAPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1835793AbhCCSEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:04:55 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123HsEqd136888;
        Wed, 3 Mar 2021 13:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=9CISsQdf8MSiuy2ZFGtDxVRir8FLW3GgRdSNESZQ/XU=;
 b=Si0q4O7yAR7SRV86MlXXscmFpWJL14r4rN+XVIu03MHEq0KpufALgV+uS0rFUla2ujop
 UqqAE6UFoxJFaFq/McHe5CJQr9R+/PB6NJb/3pPwNPMenmRtZJqOcL+m3RT+mjB4SSzP
 U+aJ/EDHod72og1J9o6CDftkHiA9rPVE4xXJOCxoRQN+yO8Pz0pNBrs7PJ73uQRqrjmY
 HIyGGlVtdiTnqhxm+OnCg3oy1zccFgV2+PB/UT7CKwOD9vlYql2KVgIXpnPfXqj1c6XU
 Q6UMmS39XjraX5SudDcIt/qacu1NY+TT5ND9ngPX1OkYAYdBbb0hmrPDbby0ug1wR/Ld lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372f8w8bq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 13:03:43 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123I38Fo009270;
        Wed, 3 Mar 2021 13:03:42 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372f8w8bjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 13:03:42 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123I1qFq005464;
        Wed, 3 Mar 2021 18:03:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 36yj53218s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 18:03:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123I3Urf55705966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 18:03:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B1F2A4040;
        Wed,  3 Mar 2021 18:03:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62ED6A404D;
        Wed,  3 Mar 2021 18:03:29 +0000 (GMT)
Received: from localhost (unknown [9.79.222.129])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Mar 2021 18:03:28 +0000 (GMT)
Date:   Wed, 3 Mar 2021 12:10:43 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
 <YD4U1x2SbTlJF2QU@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4U1x2SbTlJF2QU@krava>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=38 bulkscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 spamscore=38 malwarescore=0 clxscore=1011 suspectscore=0 mlxscore=38
 mlxlogscore=21 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103030124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/03/02 11:35AM, Jiri Olsa wrote:
> On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
> > 
> > 
> > On 3/1/21 11:04 AM, Jiri Olsa wrote:
> > > When testing uprobes we the test gets GEP (Global Entry Point)
> > > address from kallsyms, but then the function is called locally
> > > so the uprobe is not triggered.
> > > 
> > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > > for powerpc arch.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > >   1 file changed, 17 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > @@ -2,6 +2,22 @@
> > >   #include <test_progs.h>
> > >   #include "test_attach_probe.skel.h"
> > > +#if defined(__powerpc64__)

This needs to be specific to ELF v2 ABI, so you'll need to check 
_CALL_ELF. See commit d5c2e2c17ae1d6 ("perf probe ppc64le: Prefer symbol 
table lookup over DWARF") for an example.

> > > +/*
> > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > > + * but then the function is called locally, so we need to adjust
> > > + * the address to get LEP (Local Entry Point).
> > 
> > Any documentation in the kernel about this behavior? This will
> > help to validate the change without trying with powerpc64 qemu...

I don't think we have documented this in the kernel anywhere, but this 
is specific to the ELF v2 ABI and is described there:
- 2.3.2.1.  Function Prologue: 
  http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240___RefHeading___Toc377640597.html
- 3.4.1.  Symbol Values:
   http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655241_95185.html

> 
> we got similar fix in perf:
> 
> 7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
> 
> CC-ing few other folks from ppc land for more info

Thanks.

> > 
> > > + */
> > > +#define LEP_OFFSET 8
> > > +
> > > +static ssize_t get_offset(ssize_t offset)
> > > +{
> > > +	return offset + LEP_OFFSET;
> > > +}
> > > +#else
> > > +#define get_offset(offset) (offset)
> > > +#endif
> > > +
> > >   ssize_t get_base_addr() {
> > >   	size_t start, offset;
> > >   	char buf[256];
> > > @@ -36,7 +52,7 @@ void test_attach_probe(void)
> > >   	if (CHECK(base_addr < 0, "get_base_addr",
> > >   		  "failed to find base addr: %zd", base_addr))
> > >   		return;
> > > -	uprobe_offset = (size_t)&get_base_addr - base_addr;
> > > +	uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
> > >   	skel = test_attach_probe__open_and_load();
> > >   	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > > 

As documented in the links above, the right way to identify local entry 
point (LEP) is by looking at the symbol table. Falling back to using a 
hardcoded offset of 8 is a reasonable workaround if we don't have access 
to the symbol table.

- Naveen

