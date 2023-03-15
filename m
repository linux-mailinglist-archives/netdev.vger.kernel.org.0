Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACED6BBC09
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCOS11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCOS1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:27:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4270574DF8;
        Wed, 15 Mar 2023 11:27:15 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHBISe031841;
        Wed, 15 Mar 2023 18:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Z7yewDR2kJgqIKYE6+yJQnyeCY6LySWzvukuj52kWHg=;
 b=lEpWSsMMVHdYjVPKV39f4W7CXFRvwjVR9d84rClToaWJFl4fO1kDsO4YNrEzpauQ34x5
 j2QngtDYxujIklQ4VIP6dtaidFWSDBvwopBy/rdl5Z6QPWL8IdgM8gaMaNNnkGjr5khH
 jpUXGeT6iSaL1wSl1P7WkRmKooZfaYjyElKplS+V59QBMoV+Bjdf2MkSjA7nwhIkxh+d
 SQkPue6rx8ObO/IdScr/myzSy2zMYniOp+0FKS94sLvZdNgrGA0i1l+DPEghd+43e92X
 ZQKH9I9EKwVhysHRgnN+Fe9OeDsi5sfVLWcwleXxk9Aj3OVWQKASwO6i/ywFcMM1F2+i yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbgey543n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:26:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FFDsei009778;
        Wed, 15 Mar 2023 18:26:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbgey542x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:26:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FE0kIW009944;
        Wed, 15 Mar 2023 18:26:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pb29sh4yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 18:26:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FIQ25i48300450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 18:26:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FD9720040;
        Wed, 15 Mar 2023 18:26:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C967720049;
        Wed, 15 Mar 2023 18:26:00 +0000 (GMT)
Received: from [9.171.20.11] (unknown [9.171.20.11])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 18:26:00 +0000 (GMT)
Message-ID: <8341c1d9f935f410438e79d3bd8a9cc50aefe105.camel@linux.ibm.com>
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
Date:   Wed, 15 Mar 2023 19:26:00 +0100
In-Reply-To: <62f8f903-4eaf-1b82-a2e9-43179bcd10a1@intel.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
         <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
         <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
         <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
         <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
         <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
         <de59c0fca26400305ab34cc89e468e395b6256ac.camel@linux.ibm.com>
         <e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com>
         <62f8f903-4eaf-1b82-a2e9-43179bcd10a1@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d_JiPc7C1_7HNkpUd-i7NuRN6FViFsmX
X-Proofpoint-ORIG-GUID: rRN38xYHafh3jbGTHDT0jyWAQn7MFOZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_10,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-15 at 19:12 +0100, Alexander Lobakin wrote:
> From: Ilya Leoshkevich <iii@linux.ibm.com>
> Date: Wed, 15 Mar 2023 19:00:47 +0100
>=20
> > On Wed, 2023-03-15 at 15:54 +0100, Ilya Leoshkevich wrote:
> > > On Wed, 2023-03-15 at 11:54 +0100, Alexander Lobakin wrote:
> > > > From: Alexander Lobakin <aleksander.lobakin@intel.com>
> > > > Date: Wed, 15 Mar 2023 10:56:25 +0100
> > > >=20
> > > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > Date: Tue, 14 Mar 2023 16:54:25 -0700
> > > > >=20
> > > > > > On Tue, Mar 14, 2023 at 11:52=E2=80=AFAM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >=20
> > > > > [...]
> > > > >=20
> > > > > > test_xdp_do_redirect:PASS:prog_run 0 nsec
> > > > > > test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
> > > > > > test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
> > > > > > test_xdp_do_redirect:FAIL:pkt_count_tc unexpected
> > > > > > pkt_count_tc:
> > > > > > actual
> > > > > > 220 !=3D expected 9998
> > > > > > test_max_pkt_size:PASS:prog_run_max_size 0 nsec
> > > > > > test_max_pkt_size:PASS:prog_run_too_big 0 nsec
> > > > > > close_netns:PASS:setns 0 nsec
> > > > > > #289 xdp_do_redirect:FAIL
> > > > > > Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
> > > > > >=20
> > > > > > Alex,
> > > > > > could you please take a look at why it's happening?
> > > > > >=20
> > > > > > I suspect it's an endianness issue in:
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (*metadata !=3D 0=
x42)
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return XDP_ABORTED;
> > > > > > but your patch didn't change that,
> > > > > > so I'm not sure why it worked before.
> > > > >=20
> > > > > Sure, lemme fix it real quick.
> > > >=20
> > > > Hi Ilya,
> > > >=20
> > > > Do you have s390 testing setups? Maybe you could take a look,
> > > > since
> > > > I
> > > > don't have one and can't debug it? Doesn't seem to be
> > > > Endianness
> > > > issue.
> > > > I mean, I have this (the below patch), but not sure it will fix
> > > > anything -- IIRC eBPF arch always matches the host arch ._.
> > > > I can't figure out from the code what does happen wrongly :s
> > > > And it
> > > > happens only on s390.
> > > >=20
> > > > Thanks,
> > > > Olek
> > > > ---
> > > > diff --git
> > > > a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > > > b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > > > index 662b6c6c5ed7..b21371668447 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> > > > @@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 .attach_point =3D BPF_TC_INGRESS);
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(&data[sizeof=
(__u32)], &pkt_udp,
> > > > sizeof(pkt_udp));
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data) =3D 0x4=
2; /* metadata test value */
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data) =3D hto=
nl(0x42); /* metadata test value
> > > > */
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skel =3D test_xdp_d=
o_redirect__open();
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ASSERT_OK_PTR(=
skel, "skel"))
> > > > diff --git
> > > > a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > > > b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > > > index cd2d4e3258b8..2475bc30ced2 100644
> > > > --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > > > +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > > > @@ -1,5 +1,6 @@
> > > > =C2=A0// SPDX-License-Identifier: GPL-2.0
> > > > =C2=A0#include <vmlinux.h>
> > > > +#include <bpf/bpf_endian.h>
> > > > =C2=A0#include <bpf/bpf_helpers.h>
> > > > =C2=A0
> > > > =C2=A0#define ETH_ALEN 6
> > > > @@ -28,7 +29,7 @@ volatile int retcode =3D XDP_REDIRECT;
> > > > =C2=A0SEC("xdp")
> > > > =C2=A0int xdp_redirect(struct xdp_md *xdp)
> > > > =C2=A0{
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__u32 *metadata =3D (voi=
d *)(long)xdp->data_meta;
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__be32 *metadata =3D (vo=
id *)(long)xdp->data_meta;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void *data_end =3D =
(void *)(long)xdp->data_end;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void *data =3D (voi=
d *)(long)xdp->data;
> > > > =C2=A0
> > > > @@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (metadata + 1 > =
data)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return XDP_ABORTED;
> > > > =C2=A0
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*metadata !=3D 0x42)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*metadata !=3D __bpf=
_htonl(0x42))
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return XDP_ABORTED;
> > > > =C2=A0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (*payload =3D=3D=
 MARK_XMIT)
> > >=20
> > > Okay, I'll take a look. Two quick observations for now:
> > >=20
> > > - Unfortunately the above patch does not help.
> > >=20
> > > - In dmesg I see:
> > >=20
> > > =C2=A0=C2=A0=C2=A0 Driver unsupported XDP return value 0 on prog xdp_=
redirect
> > > (id
> > > 23)
> > > =C2=A0=C2=A0=C2=A0 dev N/A, expect packet loss!
> >=20
> > I haven't identified the issue yet, but I have found a couple more
> > things that might be helpful:
> >=20
> > - In problematic cases metadata contains 0, so this is not an
> > =C2=A0 endianness issue. data is still reasonable though. I'm trying to
> > =C2=A0 understand what is causing this.
> >=20
> > - Applying the following diff:
> >=20
> > --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> > @@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *payload =3D MARK_IN;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bpf_xdp_adjust_meta(xdp, 4))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (false && bpf_xdp_adjust_meta(=
xdp, 4))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return XDP_ABORTED;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (retcode > XDP_PASS)
> >=20
> > causes a kernel panic even on x86_64:
> >=20
> > BUG: kernel NULL pointer dereference, address:
> > 0000000000000d28=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
> > ...
> > Call Trace:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=20
> > =C2=A0<TASK>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0
> > =C2=A0=C2=A0=20
> > =C2=A0build_skb_around+0x22/0xb0
> > =C2=A0__xdp_build_skb_from_frame+0x4e/0x130
> > =C2=A0bpf_test_run_xdp_live+0x65f/0x7c0
> > =C2=A0? __pfx_xdp_test_run_init_page+0x10/0x10
> > =C2=A0bpf_prog_test_run_xdp+0x2ba/0x480
> > =C2=A0bpf_prog_test_run+0xeb/0x110
> > =C2=A0__sys_bpf+0x2b9/0x570
> > =C2=A0__x64_sys_bpf+0x1c/0x30
> > =C2=A0do_syscall_64+0x48/0xa0
> > =C2=A0entry_SYSCALL_64_after_hwframe+0x72/0xdc
> >=20
> > I haven't looked into this at all, but I believe this needs to be
> > fixed - BPF should never cause kernel panics.
>=20
> This one is basically the same issue as syzbot mentioned today
> (separate
> subthread). I'm waiting for a feedback from Toke on which way of
> fixing
> he'd prefer (I proposed 2). If those zeroed metadata magics that you
> observe have the same roots with the panic, one fix will smash 2
> issues.
>=20
> Thanks,
> Olek

Sounds good, I will wait for an update then.

In the meantime, I found the code that overwrites the metadata:

#0  0x0000000000aaeee6 in neigh_hh_output (hh=3D0x83258df0,
skb=3D0x88142200) at linux/include/net/neighbour.h:503
#1  0x0000000000ab2cda in neigh_output (skip_cache=3Dfalse,
skb=3D0x88142200, n=3D<optimized out>) at linux/include/net/neighbour.h:544
#2  ip6_finish_output2 (net=3Dnet@entry=3D0x88edba00, sk=3Dsk@entry=3D0x0,
skb=3Dskb@entry=3D0x88142200) at linux/net/ipv6/ip6_output.c:134
#3  0x0000000000ab4cbc in __ip6_finish_output (skb=3D0x88142200, sk=3D0x0,
net=3D0x88edba00) at linux/net/ipv6/ip6_output.c:195
#4  ip6_finish_output (net=3D0x88edba00, sk=3D0x0, skb=3D0x88142200) at
linux/net/ipv6/ip6_output.c:206
#5  0x0000000000ab5cbc in dst_input (skb=3D<optimized out>) at
linux/include/net/dst.h:454
#6  ip6_sublist_rcv_finish (head=3Dhead@entry=3D0x38000dbf520) at
linux/net/ipv6/ip6_input.c:88
#7  0x0000000000ab6104 in ip6_list_rcv_finish (net=3D<optimized out>,
head=3D<optimized out>, sk=3D0x0) at linux/net/ipv6/ip6_input.c:145
#8  0x0000000000ab72bc in ipv6_list_rcv (head=3D0x38000dbf638,
pt=3D<optimized out>, orig_dev=3D<optimized out>) at
linux/net/ipv6/ip6_input.c:354
#9  0x00000000008b3710 in __netif_receive_skb_list_ptype
(orig_dev=3D0x880b8000, pt_prev=3D0x176b7f8 <ipv6_packet_type>,
head=3D0x38000dbf638) at linux/net/core/dev.c:5520
#10 __netif_receive_skb_list_core (head=3Dhead@entry=3D0x38000dbf7b8,
pfmemalloc=3Dpfmemalloc@entry=3Dfalse) at linux/net/core/dev.c:5568
#11 0x00000000008b4390 in __netif_receive_skb_list (head=3D0x38000dbf7b8)
at linux/net/core/dev.c:5620
#12 netif_receive_skb_list_internal (head=3Dhead@entry=3D0x38000dbf7b8) at
linux/net/core/dev.c:5711
#13 0x00000000008b45ce in netif_receive_skb_list
(head=3Dhead@entry=3D0x38000dbf7b8) at linux/net/core/dev.c:5763
#14 0x0000000000950782 in xdp_recv_frames (dev=3D<optimized out>,
skbs=3D<optimized out>, nframes=3D62, frames=3D0x8587c600) at
linux/net/bpf/test_run.c:256
#15 xdp_test_run_batch (xdp=3Dxdp@entry=3D0x38000dbf900,
prog=3Dprog@entry=3D0x37fffe75000, repeat=3D<optimized out>) at
linux/net/bpf/test_run.c:334

namely:

static inline int neigh_hh_output(const struct hh_cache *hh, struct
sk_buff *skb)
   ...
   memcpy(skb->data - HH_DATA_MOD, hh->hh_data, HH_DATA_MOD);

It's hard for me to see what is going on here, since I'm not familiar
with the networking code - since XDP metadata is located at the end of
headroom, should not there be something that prevents the network stack
from overwriting it? Or can it be that netif_receive_skb_list() is
free to do whatever it wants with that memory and we cannot expect to
receive it back intact?
