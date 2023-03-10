Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8E6B34E2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 04:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCJDkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 22:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCJDkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 22:40:36 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84759900A7;
        Thu,  9 Mar 2023 19:40:34 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32A2KI99032690;
        Fri, 10 Mar 2023 03:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Oe9DkjbAGC+t2Cs2WHfP96anfEA/BSeXwMFQurIvHes=;
 b=s5HalVHfRwGCYQXqmyfjH+brJyn1UiObuPwXMmo4ZM0/qJUV596T9rV2f8No6utPUrVF
 3E2+PbYkNEvSx6TaZqwt1UYPx0PURAd7LjKwv4owxjRNrsNhknd8V3uW0B/3WdgjLmUm
 5Zl8rY0enoygsquPzLtxEkXVxCMVRXf4Uyd5LFUyDOicRwZqcsIICyqonodxWnW9sFkm
 1UJu40+3OLDWw9LN00cTbUkUp0Rru+cNIZCtf6Cxc9/66xD3y6yVYa2hQC5xh74fvdWO
 es6Fi6z8BiDlRa9K6IRBmIf/9xh6HHNAP5XKvtWfEtzeCd4/yt5ob8JWcm6YkAX7H6DS wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p7fhy5jg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 03:40:17 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32A3ZPXE016376;
        Fri, 10 Mar 2023 03:40:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p7fhy5jfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 03:40:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 329GjKOH020036;
        Fri, 10 Mar 2023 03:40:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p6ftvk94d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 03:40:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32A3eCYY55116234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:40:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FB822004E;
        Fri, 10 Mar 2023 03:40:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5D5220043;
        Fri, 10 Mar 2023 03:40:11 +0000 (GMT)
Received: from [9.171.22.18] (unknown [9.171.22.18])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 03:40:11 +0000 (GMT)
Message-ID: <67a28d535a91396a20e7fb5ff4c322395c947eb8.camel@linux.ibm.com>
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
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Date:   Fri, 10 Mar 2023 04:40:11 +0100
In-Reply-To: <CAJnrk1Za8KaAq4=v7X=YEHRu5jc3upR059AcY9eanr-v_9VSqg@mail.gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
         <20230301154953.641654-11-joannelkoong@gmail.com>
         <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
         <CAJnrk1YNMoTEaWA6=wDS3iV4sV0A-5Afnn+p50hEvX8jR6GLHw@mail.gmail.com>
         <20230308015500.6pycr5i4nynyu22n@heavy>
         <CAJnrk1Y1ONmEJpwDqGzCUmyrkDf9s_HpDhR5mW=6fNKM6PiXew@mail.gmail.com>
         <c27727cfabced2b9207eabbba71bed158ca35eec.camel@linux.ibm.com>
         <CAJnrk1Za8KaAq4=v7X=YEHRu5jc3upR059AcY9eanr-v_9VSqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UHXqBJm0kcGzM1yZEr1eRNFHZHlhp_Sv
X-Proofpoint-GUID: 2pYApqgcbmmjTzWpZuI-sq--0axKIZ-F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-09 at 00:13 -0800, Joanne Koong wrote:
> On Wed, Mar 8, 2023 at 6:24=E2=80=AFAM Ilya Leoshkevich <iii@linux.ibm.co=
m>
> wrote:
> >=20
> > On Tue, 2023-03-07 at 23:22 -0800, Joanne Koong wrote:
> > > On Tue, Mar 7, 2023 at 5:55=E2=80=AFPM Ilya Leoshkevich
> > > <iii@linux.ibm.com>
> > > wrote:
> > > >=20
> > > > On Wed, Mar 01, 2023 at 08:28:40PM -0800, Joanne Koong wrote:
> > > > > On Wed, Mar 1, 2023 at 10:08=E2=80=AFAM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >=20
> > > > > > On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong
> > > > > > <joannelkoong@gmail.com> wrote:
> > > > > > >=20
> > > > > > > 5) progs/dynptr_success.c
> > > > > > > =C2=A0=C2=A0 * Add test case "test_skb_readonly" for testing
> > > > > > > attempts
> > > > > > > at writes
> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 on a prog type with read-only skb ct=
x.
> > > > > > > =C2=A0=C2=A0 * Add "test_dynptr_skb_data" for testing that
> > > > > > > bpf_dynptr_data isn't
> > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0 supported for skb progs.
> > > > > >=20
> > > > > > I added
> > > > > > +dynptr/test_dynptr_skb_data
> > > > > > +dynptr/test_skb_readonly
> > > > > > to DENYLIST.s390x and applied.
> > > > >=20
> > > > > Thanks, I'm still not sure why s390x cannot load these
> > > > > programs.
> > > > > It is
> > > > > being loaded in the same way as other tests like
> > > > > test_parse_tcp_hdr_opt() are loading programs. I will keep
> > > > > looking
> > > > > some more into this
> > > >=20
> > > > Hi,
> > > >=20
> > > > I believe the culprit is:
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0 insn->imm =3D BPF_CALL_IMM(bpf_dynptr_from_skb_r=
donly);
> > > >=20
> > > > s390x needs to know the kfunc model in order to emit the call
> > > > (like
> > > > i386), but after this assignment it's no longer possible to
> > > > look it
> > > > up in kfunc_tab by insn->imm. x86_64 does not need this,
> > > > because
> > > > its
> > > > ABI is exactly the same as BPF ABI.
> > > >=20
> > > > The simplest solution seems to be adding an artificial
> > > > kfunc_desc
> > > > like this:
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0 {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .func_model =3D desc->fu=
nc_model,=C2=A0 /* model must be
> > > > compatible */
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .func_id =3D 0,=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* unused at this
> > > > point */
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .imm =3D insn->imm,=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /* new target */
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .offset =3D 0,=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* unused at this
> > > > point */
> > > > =C2=A0=C2=A0=C2=A0 }
> > > >=20
> > > > here and also after this assignment:
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0 insn->imm =3D BPF_CALL_IMM(xdp_kfunc);
> > > >=20
> > > > What do you think?
> > >=20
> > > Ohh interesting! This makes sense to me. In particular, you're
> > > referring to the bpf_jit_find_kfunc_model() call in
> > > bpf_jit_insn()
> > > (in
> > > arch/s390/net/bpf_jit_comp.c) as the one that fails out whenever
> > > insn->imm gets set, correct?
> >=20
> > Precisely.
> >=20
> > > I like your proposed solution, I agree that this looks like the
> > > simplest, though maybe we should replace the existing kfunc_desc
> > > instead of adding it so we don't have to deal with the edge case
> > > of
> > > reaching MAX_KFUNC_DESCS? To get the func model of the new insn-
> > > >imm,
> >=20
> > I wonder whether replacement is safe? This would depend on the
> > following functions returning the same value for the same inputs:
> >=20
> > - may_access_direct_pkt_data() - this looks ok;
> > - bpf_dev_bound_resolve_kfunc() - I'm not so sure, any insights?
>=20
> For the bpf_dev_bound_resolve_kfunc() case (in fixup_kfunc_call()), I
> think directly replacing the kfunc_desc here is okay because
> bpf_dev_bound_resolve_kfunc() is findingthe target device-specific
> version of the kfunc (if it exists) to replace the generic version of
> the kfunc with, and we're using that target device-specific version
> of
> the kfunc as the new updated insn->imm to call

I'm worried that its return value is going to change while we are
doing the rewriting. It looks as if
__bpf_offload_dev_netdev_unregister() can cause this. So if we have
two instructions that use the same generic kfunc, they may end up
pointing to two different device-specific kfuncs, and the kfunc_tab
will contain only one of the two.

This sounds dangerous, but maybe I don't see some safeguard that
already prevents or mitigates the effects of this?

Stanislav, could you as the bpf_dev_bound_resolve_kfunc() author
give your opinion please? I've seen your comment:

+       /* We don't hold bpf_devs_lock while resolving several
+        * kfuncs and can race with the unregister_netdevice().
+        * We rely on bpf_dev_bound_match() check at attach
+        * to render this program unusable.
+        */

and I'm wondering whether you meant bpf_prog_dev_bound_match(), and
whether it protects against the ABA problem, i.e., if
__bpf_offload_dev_netdev_unregister() is called twice, and we get
aux->offload and aux->offload->netdev at the same addresses?

> > If it's not, then MAX_KFUNC_DESCS indeed becomes a concern.
> >=20
> > > it seems pretty straightforward, it looks like we can just use
> > > btf_distill_func_proto(). or call add_kfunc_call() directly,
> > > which
> > > would do everything needed, but adds an additional unnecessary
> > > sort
> > > and more overhead for replacing (eg we'd need to first swap the
> > > old
> > > kfunc_desc with the last tab->descs[tab->nr_descs] entry and then
> > > delete the old kfunc_desc before adding the new one). What are
> > > your
> > > thoughts?
> >=20
> > Is there a way to find BTF by function pointer?
> > IIUC bpf_dev_bound_resolve_kfunc() can return many different
> > things,
> > and btf_distill_func_proto() and add_kfunc_call() need BTF.
> > A straightforward way that immediately comes to mind is to do
> > kallsyms
> > lookup and then resolve by name, but this sounds clumsy.
> >=20
>=20
> I'm not sure whether there's a way to find the function's BTF by its
> pointer, but I think maybe we can use the vmlinux btf (which we can
> get through the bpf_get_btf_vmlinux() api) to get the func proto?

The device-specific function may come from a kernel module (e.g.,
veth). But on second thought we don't need this at all; we should
really just take func_model of the generic function, that we already
have. If it is not the same as the model of the device-specific
function, it must be a bug.

> > I've been looking into this in context of fixing (kfunc
> > __bpf_call_base) not fitting into 32 bits on s390x. A solution that
>=20
> Sorry, I'm not fully understanding - can you elaborate a little on
> what the issue is? why doesn't the __bpf_call_base address fit on
> s390x? my understanding is that s390x is a 64-bit architecture?

On s390x modules and kernel are far away from each other, so
BPF_CALL_IMM() may return ~40 significant bits. This makes the
insn->imm rewriting trick unusable, because insn->imm is just 32 bits
and cannot be extended. There is even a safeguard against this in
add_kfunc_call() ("address of kernel function %s is out of range"
check).

I had a patch that kept BTF ID in insn->imm, but it was decided that
since it required adjusting several JITs, we should not be doing it.

When the s390x JIT sees a kfunc call, it needs to find the respective
kfunc's address and model.=C2=A0Normally this is done using kfunc_tab
lookup. kfunc_tab is indexed by insn->imm values, which we cannot use
for reasons outlined above. Hence the idea below: create another
(unfortunately much less memory-efficient) kfunc_tab indexed by insn
numbers.

Conveniently, this would also solve the problem that we are seeing
here.

> > would solve both problems that I'm currently thinking about is to
> > associate
> >=20
> > struct {
> > =C2=A0=C2=A0=C2=A0 struct btf_func_model *m;
> > =C2=A0=C2=A0=C2=A0 unsigned long addr;
> > } kfunc_callee;
> >=20
> > with every insn - during verification it could live in
> > bpf_insn_aux_data, during jiting in bpf_prog, and afterwards it can
> > be freed. Any thoughts about this?

