Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4776BBB9E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCOSCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCOSCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:02:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6D35941B;
        Wed, 15 Mar 2023 11:02:00 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FGsVao005253;
        Wed, 15 Mar 2023 18:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KKApXmimGXy7/MINZp0RPj2xdgPpbUWfkrvEb3j90Ng=;
 b=sjirzqjU+VTGNUQJ0zHeBh88CUsz99qb8OyMVsZFCOpd6BcbSmPwtfZ76ccQ8RR1YmlE
 EUMf+u4ZkJ114zKpVrTfkJv7KdbBLOi4FKq/nlbZ8D0tXfHvnlsExrl7BzeMDYeoeybP
 gGJL6eUxZCnRr09zgzTiCLVr8NEDg/3CMXLVQ77iCPpszgR7a7SO4D1zWQb7xZPCjvuF
 AhSFVGNnA+8r/z2tx6JUDn5cVGYTiTKuQWMcBQMTT1zeNqtqotIME22NnNFWenuF71yV
 dG/KrvQI72TOyQkC1v0uAhitOUG07kgXzJGGizPvh14W8Lnf0MkZ3I+Tt1VYRWckLKkQ sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbhy01pbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:00:56 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FHUB9j020267;
        Wed, 15 Mar 2023 18:00:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbhy01p9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:00:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FE4tA9032370;
        Wed, 15 Mar 2023 18:00:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pb29u94c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:00:51 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FI0nAw45417152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 18:00:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DFEF20049;
        Wed, 15 Mar 2023 18:00:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E5F2004B;
        Wed, 15 Mar 2023 18:00:48 +0000 (GMT)
Received: from [9.171.20.11] (unknown [9.171.20.11])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 18:00:48 +0000 (GMT)
Message-ID: <e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs
 built from XDP frames
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 15 Mar 2023 19:00:47 +0100
In-Reply-To: <de59c0fca26400305ab34cc89e468e395b6256ac.camel@linux.ibm.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
         <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
         <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
         <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
         <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
         <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
         <de59c0fca26400305ab34cc89e468e395b6256ac.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IKouWAsNf1OlMdG1mAA7jI7vSzBDlCSR
X-Proofpoint-ORIG-GUID: R-4AIjJXH0FgjPYjtyTtWFJWZgbeUlrB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_09,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-15 at 15:54 +0100, Ilya Leoshkevich wrote:
> On Wed, 2023-03-15 at 11:54 +0100, Alexander Lobakin wrote:
> > From: Alexander Lobakin <aleksander.lobakin@intel.com>
> > Date: Wed, 15 Mar 2023 10:56:25 +0100
> >=20
> > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Date: Tue, 14 Mar 2023 16:54:25 -0700
> > >=20
> > > > On Tue, Mar 14, 2023 at 11:52=E2=80=AFAM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > >=20
> > > [...]
> > >=20
> > > > test_xdp_do_redirect:PASS:prog_run 0 nsec
> > > > test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
> > > > test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
> > > > test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc:
> > > > actual
> > > > 220 !=3D expected 9998
> > > > test_max_pkt_size:PASS:prog_run_max_size 0 nsec
> > > > test_max_pkt_size:PASS:prog_run_too_big 0 nsec
> > > > close_netns:PASS:setns 0 nsec
> > > > #289 xdp_do_redirect:FAIL
> > > > Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
> > > >=20
> > > > Alex,
> > > > could you please take a look at why it's happening?
> > > >=20
> > > > I suspect it's an endianness issue in:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (*metadata !=3D 0x42)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return XDP_ABORTED;
> > > > but your patch didn't change that,
> > > > so I'm not sure why it worked before.
> > >=20
> > > Sure, lemme fix it real quick.
> >=20
> > Hi Ilya,
> >=20
> > Do you have s390 testing setups? Maybe you could take a look, since
> > I
> > don't have one and can't debug it? Doesn't seem to be Endianness
> > issue.
> > I mean, I have this (the below patch), but not sure it will fix
> > anything -- IIRC eBPF arch always matches the host arch ._.
> > I can't figure out from the code what does happen wrongly :s And it
> > happens only on s390.
> >=20
> > Thanks,
> > Olek
> > ---
> > diff --git
> > a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > index 662b6c6c5ed7..b21371668447 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > @@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 .attach_point =3D BPF_TC_INGRESS);
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(&data[sizeof(__u=
32)], &pkt_udp, sizeof(pkt_udp));
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data) =3D 0x42; /=
* metadata test value */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data) =3D htonl(0=
x42); /* metadata test value */
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skel =3D test_xdp_do_re=
direct__open();
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ASSERT_OK_PTR(skel=
, "skel"))
> > diff --git
> > a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > index cd2d4e3258b8..2475bc30ced2 100644
> > --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > @@ -1,5 +1,6 @@
> > =C2=A0// SPDX-License-Identifier: GPL-2.0
> > =C2=A0#include <vmlinux.h>
> > +#include <bpf/bpf_endian.h>
> > =C2=A0#include <bpf/bpf_helpers.h>
> > =C2=A0
> > =C2=A0#define ETH_ALEN 6
> > @@ -28,7 +29,7 @@ volatile int retcode =3D XDP_REDIRECT;
> > =C2=A0SEC("xdp")
> > =C2=A0int xdp_redirect(struct xdp_md *xdp)
> > =C2=A0{
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__u32 *metadata =3D (void *)=
(long)xdp->data_meta;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__be32 *metadata =3D (void *=
)(long)xdp->data_meta;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void *data_end =3D (voi=
d *)(long)xdp->data_end;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void *data =3D (void *)=
(long)xdp->data;
> > =C2=A0
> > @@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (metadata + 1 > data=
)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return XDP_ABORTED;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*metadata !=3D 0x42)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*metadata !=3D __bpf_hto=
nl(0x42))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return XDP_ABORTED;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*payload =3D=3D MAR=
K_XMIT)
>=20
> Okay, I'll take a look. Two quick observations for now:
>=20
> - Unfortunately the above patch does not help.
>=20
> - In dmesg I see:
>=20
> =C2=A0=C2=A0=C2=A0 Driver unsupported XDP return value 0 on prog xdp_redi=
rect (id
> 23)
> =C2=A0=C2=A0=C2=A0 dev N/A, expect packet loss!

I haven't identified the issue yet, but I have found a couple more
things that might be helpful:

- In problematic cases metadata contains 0, so this is not an
  endianness issue. data is still reasonable though. I'm trying to
  understand what is causing this.

- Applying the following diff:

--- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
=20
        *payload =3D MARK_IN;
=20
-       if (bpf_xdp_adjust_meta(xdp, 4))
+       if (false && bpf_xdp_adjust_meta(xdp, 4))
                return XDP_ABORTED;
=20
        if (retcode > XDP_PASS)

causes a kernel panic even on x86_64:

BUG: kernel NULL pointer dereference, address: 0000000000000d28      =20
...
Call Trace:           =20
 <TASK>                                                              =20
 build_skb_around+0x22/0xb0
 __xdp_build_skb_from_frame+0x4e/0x130
 bpf_test_run_xdp_live+0x65f/0x7c0
 ? __pfx_xdp_test_run_init_page+0x10/0x10
 bpf_prog_test_run_xdp+0x2ba/0x480
 bpf_prog_test_run+0xeb/0x110
 __sys_bpf+0x2b9/0x570
 __x64_sys_bpf+0x1c/0x30
 do_syscall_64+0x48/0xa0
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

I haven't looked into this at all, but I believe this needs to be
fixed - BPF should never cause kernel panics.
