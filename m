Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F061E32C497
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446377AbhCDAPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243486AbhCCSNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:13:11 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123I4hAG029853;
        Wed, 3 Mar 2021 13:10:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=mEmRB0j8W52c3PpFWBUGKZMFICC3DxY/s7hE9M/toeg=;
 b=QT0aLA6TRqU3KmEf5W8ysrkdBSPYWd7ulRjYnj0Jd2eeyV1tjuo/yQQQSFobXSVlsybi
 xy92n1fTqQ2GHOIr+o0vfbhyEHyve9mV2IwKUsY76MRao/ULMse9dLmY7OryfPc5r23V
 mbYX/+eF6GQF83tuYZEfcSWTcZ2LxvL3C/jERsVn+HyO1Whe1Y0jPgkIJ7E0s44TsFfl
 pa144roxOWQ/CF66WrilG3FprOjfId3ewtTg1bXnxp1ShABkzV6sUpqSEp32hFs5lqDl
 Ih9C1BEkYvH2LFENLV4fQblunDnmmftP4/yFH+sYwv1BtS2bDWxX+PxZ0QK5hfCc7gtX Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372f8y0fyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 13:10:29 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123I53tL031927;
        Wed, 3 Mar 2021 13:10:29 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372f8y0fwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 13:10:29 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123I3TqV025328;
        Wed, 3 Mar 2021 18:05:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmj0vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 18:05:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123I5NFn16908574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 18:05:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE2BFA4053;
        Wed,  3 Mar 2021 18:05:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40DD8A404D;
        Wed,  3 Mar 2021 18:05:23 +0000 (GMT)
Received: from localhost (unknown [9.79.222.129])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Mar 2021 18:05:23 +0000 (GMT)
Date:   Wed, 3 Mar 2021 12:12:39 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <20210303064239.GC1913@DESKTOP-TDPLP67.localdomain>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
 <YD4d+dmay+oKyiot@krava>
 <c18d94d3-3e5d-08f7-a8ba-f13bfa7eec05@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c18d94d3-3e5d-08f7-a8ba-f13bfa7eec05@fb.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/03/02 09:19AM, Yonghong Song wrote:
> 
> 
> On 3/2/21 3:14 AM, Jiri Olsa wrote:
> > On Mon, Mar 01, 2021 at 04:34:24PM -0800, Andrii Nakryiko wrote:
> > > On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > 
> > > > When testing uprobes we the test gets GEP (Global Entry Point)
> > > > address from kallsyms, but then the function is called locally
> > > > so the uprobe is not triggered.
> > > > 
> > > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > > > for powerpc arch.
> > > > 
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > > >   1 file changed, 17 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > @@ -2,6 +2,22 @@
> > > >   #include <test_progs.h>
> > > >   #include "test_attach_probe.skel.h"
> > > > 
> > > > +#if defined(__powerpc64__)
> > > > +/*
> > > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > > > + * but then the function is called locally, so we need to adjust
> > > > + * the address to get LEP (Local Entry Point).
> > > > + */
> > > > +#define LEP_OFFSET 8
> > > > +
> > > > +static ssize_t get_offset(ssize_t offset)
> > > 
> > > if we mark this function __weak global, would it work as is? Would it
> > > get an address of a global entry point? I know nothing about this GEP
> > > vs LEP stuff, interesting :)
> > 
> > you mean get_base_addr? it's already global
> > 
> > all the calls to get_base_addr within the object are made
> > to get_base_addr+0x8
> > 
> > 00000000100350c0 <test_attach_probe>:
> >      ...
> >      100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>
> >      ...
> >      100358a8:   91 f5 ff 4b     bl      10034e38 <get_base_addr+0x8>
> > 
> > 
> > I'm following perf fix we had for similar issue:
> >    7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
> > 
> > I'll get more info on that
> 
> Thanks. The patch
>    7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms
> lookup
> talked about offset + 8 for kernel symbols.
> I guess uprobe symbol might be in the same situation if using the
> same compilation mechanism as kernel. But it would be good
> to get confirmation from ppc people.

Yes, this is part of the ELF V2 ABI, so it applies to both kernel and 
userspace.

- Naveen

