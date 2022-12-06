Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216D06444F1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiLFNvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiLFNvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:51:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD8E2B610;
        Tue,  6 Dec 2022 05:51:41 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6BxhRP007594;
        Tue, 6 Dec 2022 13:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BXck85uu3OcrWRJc4xeSgIxTzuVP8SUORZCxv4naybw=;
 b=W07OHO/Sw54vw816ohsL0SozdEyhDyHazcLnIvau6AepWqnbbU3xowQQRmtiXhHjNpVy
 6nDvj6DjcX+HH6dk9HvQmNvZ4pY70fxD3C1X/Y3pUbMVTDm/fVPZ1bwYAUr4p2iW7Oxf
 dcolZAGePmgxsZT1js5tE19V7zg8x2AwCRmYeS6ExjXS5dX7Rpsdgcdgq3gu3N1MaUAB
 8M7EGRBWTzytSRO65vFN+cGmcMlqOI3y+Frplk77MoP7ZcKpaWJBcJU4sApKSN2SLqs0
 CwMeXvyf/fnzxQOA+0mj8fg6qizNhFE5Btg2a+ozkOXy0Qo0BXjma2AJF2DdQqg85D1z pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma58bu4df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:51:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6CsLFJ014684;
        Tue, 6 Dec 2022 13:51:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma58bu4cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:51:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B69NQkp010888;
        Tue, 6 Dec 2022 13:51:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3m9kvb9g3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:51:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6DpLFt45023676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 13:51:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3159B4C046;
        Tue,  6 Dec 2022 13:51:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA3534C040;
        Tue,  6 Dec 2022 13:51:20 +0000 (GMT)
Received: from [9.171.16.157] (unknown [9.171.16.157])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 13:51:20 +0000 (GMT)
Message-ID: <b5a597efaf8f03d1416846799a3fea7b1d73bd5a.camel@linux.ibm.com>
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
Date:   Tue, 06 Dec 2022 14:51:20 +0100
In-Reply-To: <87sfhs3an1.fsf@all.your.base.are.belong.to.us>
References: <20221202103620.1915679-1-bjorn@kernel.org>
         <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
         <87sfhs3an1.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: r5HE3CcDS6xKMQS0qHyi8BabT9PGF5At
X-Proofpoint-GUID: 0WgMMf2G124izmTLO5PzchkSnsEwVDgs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_09,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=237
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-06 at 14:49 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> Ilya Leoshkevich <iii@linux.ibm.com> writes:
>=20
> > On Fri, 2022-12-02 at 11:36 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
> > >=20
> > > A BPF call instruction can be, correctly, marked with zext_dst
> > > set to
> > > true. An example of this can be found in the BPF selftests
> > > progs/bpf_cubic.c:
> > >=20
> > > =C2=A0 ...
> > > =C2=A0 extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
> > >=20
> > > =C2=A0 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
> > > =C2=A0 {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tcp_ren=
o_undo_cwnd(sk);
> > > =C2=A0 }
> > > =C2=A0 ...
> > >=20
> > > which compiles to:
> > > =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
> > > =C2=A0 1:=C2=A0 call -0x1
> > > =C2=A0 2:=C2=A0 exit
> > >=20
> > > The call will be marked as zext_dst set to true, and for some
> > > backends
> > > (bpf_jit_needs_zext() returns true) expanded to:
> > > =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
> > > =C2=A0 1:=C2=A0 call -0x1
> > > =C2=A0 2:=C2=A0 w0 =3D w0
> > > =C2=A0 3:=C2=A0 exit
> >=20
> > In the verifier, the marking is done by check_kfunc_call() (added
> > in
> > e6ac2450d6de), right? So the problem occurs only for kfuncs?
>=20
> I've only seen it for kfuncs, yes.
>=20
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Check return type */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 t =3D btf_type_skip_modifier=
s(desc_btf, func_proto->type,
> > NULL);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btf_type_is_scalar(t)) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mark_reg_unknown(env, regs, BPF_REG_0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mark_btf_func_reg_size(env, BPF_REG_0, t->size);
> >=20
> > I tried to find some official information whether the eBPF calling
> > convention requires sign- or zero- extending return values and
> > arguments, but unfortunately [1] doesn't mention this.
> >=20
> > LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
> > registers, but since assigning to W* leads to zero-extension, it
> > seems
> > to me that this is the case.
> >=20
> > If the above is correct, then shouldn't we rather use sizeof(void
> > *) in
> > the mark_btf_func_reg_size() call above?
>=20
> Hmm, or rather sizeof(u64) if I'm reading you correctly?

Whoops, you are right - that's indeed what I meant here.
