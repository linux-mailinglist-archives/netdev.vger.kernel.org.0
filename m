Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F430644479
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiLFNWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiLFNWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:22:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9133AEB8;
        Tue,  6 Dec 2022 05:22:20 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6Bxcim024328;
        Tue, 6 Dec 2022 13:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ebCnlux+96ksM5zPKoRnRob4fbCGJZT59f1yr9KTJIY=;
 b=coD+XsnSRKBv/y5toP9LJWpqJjyNkcXmxbrKmb0xCYGXlCCO4eneSkTtNYPbsdp0yKOr
 sNFgcmbHrawzttE27XP00iyX7DdjmjALkb4fBylk1mTnE43PIWWHvkWTYtId+puMm+bW
 TMo93O4VeSn3Py9bUsrkkP+LSRITxLpN/VB/BAAnLh7E7x25UGfbGwegS6DWgZ2Owk3D
 oBcJOtgjsv2nsRpUh1k+s1PZK+bXmGx2bfdfzsG+Y4iD0Js54GZ+3lljIciUW40xRqwu
 2PmY+eCriZhM4iR9G9CHLE8I0+npzlXyb46xblnKfTyp/l/oKvE0tIMTfVWeDv/ybLwZ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma59bt63p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:22:00 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6CqF99008000;
        Tue, 6 Dec 2022 13:22:00 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ma59bt62r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:21:59 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5K5aDY003030;
        Tue, 6 Dec 2022 13:21:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3m9kur128b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:21:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com ([9.149.105.62])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6DLtoh23790282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 13:21:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C4E6AE04D;
        Tue,  6 Dec 2022 13:21:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9015AE045;
        Tue,  6 Dec 2022 13:21:54 +0000 (GMT)
Received: from [9.171.16.157] (unknown [9.171.16.157])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 13:21:54 +0000 (GMT)
Message-ID: <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
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
Date:   Tue, 06 Dec 2022 14:21:54 +0100
In-Reply-To: <20221202103620.1915679-1-bjorn@kernel.org>
References: <20221202103620.1915679-1-bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nHeNlSXTIcfStJ5JmGK2XIjWsAqfL1AO
X-Proofpoint-ORIG-GUID: wGUpdwcrUBBAL4FoXea0jfhBDAxouiox
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_09,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=881 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212060107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-12-02 at 11:36 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>=20
> A BPF call instruction can be, correctly, marked with zext_dst set to
> true. An example of this can be found in the BPF selftests
> progs/bpf_cubic.c:
>=20
> =C2=A0 ...
> =C2=A0 extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>=20
> =C2=A0 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
> =C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tcp_reno_un=
do_cwnd(sk);
> =C2=A0 }
> =C2=A0 ...
>=20
> which compiles to:
> =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
> =C2=A0 1:=C2=A0 call -0x1
> =C2=A0 2:=C2=A0 exit
>=20
> The call will be marked as zext_dst set to true, and for some
> backends
> (bpf_jit_needs_zext() returns true) expanded to:
> =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
> =C2=A0 1:=C2=A0 call -0x1
> =C2=A0 2:=C2=A0 w0 =3D w0
> =C2=A0 3:=C2=A0 exit

In the verifier, the marking is done by check_kfunc_call() (added in
e6ac2450d6de), right? So the problem occurs only for kfuncs?

        /* Check return type */
        t =3D btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);

        ...

        if (btf_type_is_scalar(t)) {
                mark_reg_unknown(env, regs, BPF_REG_0);
                mark_btf_func_reg_size(env, BPF_REG_0, t->size);

I tried to find some official information whether the eBPF calling
convention requires sign- or zero- extending return values and
arguments, but unfortunately [1] doesn't mention this.

LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
registers, but since assigning to W* leads to zero-extension, it seems
to me that this is the case.

If the above is correct, then shouldn't we rather use sizeof(void *) in
the mark_btf_func_reg_size() call above?

> The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
> the zext patching, relies on insn_def_regno() to fetch the register
> to
> zero-extend. However, this function does not handle call instructions
> correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the
> verification.
>=20
> Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
> instructions.
>=20
> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in
> insn_has_def32()")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
> ---
> I'm not super happy about the additional special case -- first
> cmpxchg, and now call. :-( A more elegant/generic solution is
> welcome!
> ---
> =C2=A0kernel/bpf/verifier.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 264b3dc714cc..4f9660eafc72 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13386,6 +13386,9 @@ static int
> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn=
))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0con=
tinue;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (insn.code =3D=3D (BPF_JMP | BPF_CALL))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0load_reg =
=3D BPF_REG_0;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (WARN_ON(load_reg =3D=3D -1)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ver=
bose(env, "verifier bug. zext_dst is set,
> but no reg is defined\n");
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret=
urn -EFAULT;
>=20
> base-commit: 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1

[1]
https://docs.kernel.org/bpf/instruction-set.html#registers-and-calling-conv=
ention
