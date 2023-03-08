Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EABE6B0AFA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCHOZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjCHOY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:24:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC79BDD31;
        Wed,  8 Mar 2023 06:24:58 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328DpfZn029661;
        Wed, 8 Mar 2023 14:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GalaoFiBxlSugZfpwR9bEdB639bhsjBH0gGHw+9zjhg=;
 b=qi0QPDp7WxNoVIGgeL6sOtTWOzq76VgA8czSI50O3kd/9Wh5Xg/HXO9CS94WeoywfCVI
 Q7wZxTGXtHfSd1w81zqdn88AxhYC+w+dhNxh8VxEHeszHCKoucsQr6U6GjGuWf4R1OAu
 73NHJi4H5dyxe7vlXJ/K20aqahRCZ/buRiNiTbi2GTBBRe4xtf+Hjnok4OPQBrFO/+85
 WjUcyhUMCBpgLxgbnT1GCT0o55S6UzpA7lXFFxtWNBXD7PrO0yZOuupyThKCOGX2FTDq
 PMnKXqUwPAJx4UEVkKIq2eM/3tRGeeJyBu6UmVKSpfB7lgNj3uNo2Ip2Rmz3Flk8tumn jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6sdf48rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 14:24:42 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328DoOdr011873;
        Wed, 8 Mar 2023 14:24:42 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6sdf48qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 14:24:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3280ckf3003354;
        Wed, 8 Mar 2023 14:24:39 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p6g0jgp2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 14:24:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328EObSO3146362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 14:24:37 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E750320049;
        Wed,  8 Mar 2023 14:24:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0787920040;
        Wed,  8 Mar 2023 14:24:36 +0000 (GMT)
Received: from [9.171.50.88] (unknown [9.171.50.88])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Mar 2023 14:24:35 +0000 (GMT)
Message-ID: <c27727cfabced2b9207eabbba71bed158ca35eec.camel@linux.ibm.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using
 dynptrs to parse skb and xdp buffers
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Date:   Wed, 08 Mar 2023 15:24:35 +0100
In-Reply-To: <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
         <20230301154953.641654-11-joannelkoong@gmail.com>
         <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
         <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
         <20230308015500.6pycr5i4nynyu22n@heavy>
         <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0LyfYgUowc6pFMm2kSsRLG1CdnhfJuef
X-Proofpoint-ORIG-GUID: JS-j-Uy4BRMeeFuO6iw1QE4SDJRKZW6T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_08,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-07 at 23:22 -0800, Joanne Koong wrote:
> On Tue, Mar 7, 2023 at 5:55=E2=80=AFPM Ilya Leoshkevich <iii@linux.ibm.co=
m>
> wrote:
> >=20
> > On Wed, Mar 01, 2023 at 08:28:40PM -0800, Joanne Koong wrote:
> > > On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >=20
> > > > On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong
> > > > <joannelkoong@gmail.com> wrote:
> > > > >=20
> > > > > 5) progs/dynptr_success.c
> > > > > =C2=A0=C2=A0 * Add test case "test_skb_readonly" for testing atte=
mpts
> > > > > at writes
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0 on a prog type with read-only skb ctx.
> > > > > =C2=A0=C2=A0 * Add "test_dynptr_skb_data" for testing that
> > > > > bpf_dynptr_data isn't
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0 supported for skb progs.
> > > >=20
> > > > I added
> > > > +dynptr/test_dynptr_skb_data
> > > > +dynptr/test_skb_readonly
> > > > to DENYLIST.s390x and applied.
> > >=20
> > > Thanks, I'm still not sure why s390x cannot load these programs.
> > > It is
> > > being loaded in the same way as other tests like
> > > test_parse_tcp_hdr_opt() are loading programs. I will keep
> > > looking
> > > some more into this
> >=20
> > Hi,
> >=20
> > I believe the culprit is:
> >=20
> > =C2=A0=C2=A0=C2=A0 insn->imm =3D BPF_CALL_IMM(bpf_dynptr_from_skb_rdonl=
y);
> >=20
> > s390x needs to know the kfunc model in order to emit the call (like
> > i386), but after this assignment it's no longer possible to look it
> > up in kfunc_tab by insn->imm. x86_64 does not need this, because
> > its
> > ABI is exactly the same as BPF ABI.
> >=20
> > The simplest solution seems to be adding an artificial kfunc_desc
> > like this:
> >=20
> > =C2=A0=C2=A0=C2=A0 {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .func_model =3D desc->func_m=
odel,=C2=A0 /* model must be
> > compatible */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .func_id =3D 0,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* unused at this point */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .imm =3D insn->imm,=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* new target */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .offset =3D 0,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* unused at this point */
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > here and also after this assignment:
> >=20
> > =C2=A0=C2=A0=C2=A0 insn->imm =3D BPF_CALL_IMM(xdp_kfunc);
> >=20
> > What do you think?
>=20
> Ohh interesting! This makes sense to me. In particular, you're
> referring to the bpf_jit_find_kfunc_model() call in bpf_jit_insn()
> (in
> arch/s390/net/bpf_jit_comp.c) as the one that fails out whenever
> insn->imm gets set, correct?

Precisely.

> I like your proposed solution, I agree that this looks like the
> simplest, though maybe we should replace the existing kfunc_desc
> instead of adding it so we don't have to deal with the edge case of
> reaching MAX_KFUNC_DESCS? To get the func model of the new insn->imm,

I wonder whether replacement is safe? This would depend on the
following functions returning the same value for the same inputs:

- may_access_direct_pkt_data() - this looks ok;
- bpf_dev_bound_resolve_kfunc() - I'm not so sure, any insights?

If it's not, then MAX_KFUNC_DESCS indeed becomes a concern.

> it seems pretty straightforward, it looks like we can just use
> btf_distill_func_proto(). or call add_kfunc_call() directly, which
> would do everything needed, but adds an additional unnecessary sort
> and more overhead for replacing (eg we'd need to first swap the old
> kfunc_desc with the last tab->descs[tab->nr_descs] entry and then
> delete the old kfunc_desc before adding the new one). What are your
> thoughts?

Is there a way to find BTF by function pointer?
IIUC bpf_dev_bound_resolve_kfunc() can return many different things,
and btf_distill_func_proto() and add_kfunc_call() need BTF.
A straightforward way that immediately comes to mind is to do kallsyms
lookup and then resolve by name, but this sounds clumsy.



I've been looking into this in context of fixing (kfunc=C2=A0
__bpf_call_base) not fitting into 32 bits on s390x. A solution that
would solve both problems that I'm currently thinking about is to
associate

struct {
    struct btf_func_model *m;
    unsigned long addr;
} kfunc_callee;

with every insn - during verification it could live in
bpf_insn_aux_data, during jiting in bpf_prog, and afterwards it can
be freed. Any thoughts about this?
