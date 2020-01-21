Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACA81447E2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAUWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:47:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3260 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgAUWrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:47:41 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LMYsli029611;
        Tue, 21 Jan 2020 14:47:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VkdzUmDqBKkovm5Zc82u3P6FOpHvgOPWGsMH8VAiMns=;
 b=j8JBkeU/Q5jjkCwIiBqV/iGGs6FoKH4UfxwNYMLWMoYbf8evg2ThyjyJt5Wh4O067COJ
 to/3VixiEZd0C9pQLA0tZxvETMghm7RDovO5qoV+UKq8iN4YFckBQ4QKWftmzaI607y5
 wmjdkK3nWPdHVX7NbBQ3PW6vEWTdjS0OYFQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xp49x9yqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jan 2020 14:47:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 14:47:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heJEnbjo0EBZigqcdzg0bB8MEgC73fNns0QweNMINrNLp+JPfGmVdzjLsiJNaNYfuK0FLnTdc2+EvuY59XKYTAFHbC7vgaEa/UouLBoCkov3Pq8fUOORvf/AQjxcrCuC2yO8tHNZu75OZuTIb7XOhx7NQ0PKylfm0nsVxrNUG0ZoLp5VllYooOjffg0qminFagcS5s7gwsxV7cWrhqrCSU5pqE6V9+jAnrnzCQMqk2/NAa7Ra72gW0AXpXImMXEg2Js8suICG7hAL+RyRzlQe3DpdK+1KeZjfm3vviH5MNPpJDtwewblHuW8DKeJfqPsuM5xJFjTjgkXhAfunKLS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkdzUmDqBKkovm5Zc82u3P6FOpHvgOPWGsMH8VAiMns=;
 b=I0RFSEp+nl3fxdttH5gPzNIHcBb5yiYlu/CvTQl5jx8pOOjXisVDSimEFUbTdMyeRMGDM+Xqxlcb7QUIu5PlvMVejFBS5ZCUxVLbH9NfUuLdZ50lJFxiNhZWRRXgwgi/q3fG5EAVoMZGKIYEINBw6dcdff+NiDVbtX5m9D8De989nhh296Dly4xof9tqsXdH9oqv5sFQIqGbnZ7alOAgKdpoXORrn4gTTPaPCi+bL/Cae1JgqZ5UYcjg3CeLqRyAGzD4nNnWfrV/frR8ng9QddCiyc8Ue2HywgBgUmh7S6tDxLDQmyou4E43Nu1OYJBMTMVk4gkTQK8Ux1Pd+QfK9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkdzUmDqBKkovm5Zc82u3P6FOpHvgOPWGsMH8VAiMns=;
 b=WoqJOuvZVchb5mEMiCS4tN21AziWJbj+TBPWpmOVGro10+0dMBa7YljXjOe0HqjetumY6chDPxG8oB0Rw+LLYpisi0oN4ta3Kb0NECaUmgIaMHTPTSYqWDtJiBGUMF87hN8szTf6/BeRhS3RpB1rv7PCUWpzdNBWV6b7R5QHjMc=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3038.namprd15.prod.outlook.com (20.178.254.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Tue, 21 Jan 2020 22:47:22 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 22:47:22 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::aa6d) by MWHPR03CA0011.namprd03.prod.outlook.com (2603:10b6:300:117::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.23 via Frontend Transport; Tue, 21 Jan 2020 22:47:20 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: Add BPF_FUNC_jiffies64
Thread-Topic: [PATCH bpf-next 1/3] bpf: Add BPF_FUNC_jiffies64
Thread-Index: AQHV0JSU0YOsFpl0GEKkw6qzvP/pgKf1tpIAgAABvAA=
Date:   Tue, 21 Jan 2020 22:47:22 +0000
Message-ID: <20200121224718.nu3xh6gmivmt4tj3@kafai-mbp.dhcp.thefacebook.com>
References: <20200121195408.3756734-1-kafai@fb.com>
 <20200121195414.3757563-1-kafai@fb.com>
 <e2a6aeb5-b495-7ed5-0395-bf3f78abd05f@iogearbox.net>
In-Reply-To: <e2a6aeb5-b495-7ed5-0395-bf3f78abd05f@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:300:117::21) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::aa6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43eb7fe9-e03e-4b27-289c-08d79ec3e073
x-ms-traffictypediagnostic: MN2PR15MB3038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3038ECB94CF7226086E2E363D50D0@MN2PR15MB3038.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(136003)(346002)(39860400002)(189003)(199004)(81156014)(81166006)(8676002)(86362001)(2906002)(55016002)(9686003)(6916009)(4326008)(16526019)(186003)(316002)(54906003)(8936002)(66446008)(7696005)(52116002)(66556008)(64756008)(66476007)(66946007)(1076003)(53546011)(6506007)(5660300002)(478600001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3038;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EKRQyEu+g5O04PQ4IeYa25u13UKNpKBbgAo8uL6FNIIwiXSPajxsw0OV0l2HOAME+KmJyyofVh/uLHGg+BFb88PDZN32NdTIQb3UhRu308Llh3PGuIRI9hX1lcMb8w8fpf3nVmuQyABry7KJ1z+osO079GtDxKeNoKVXMqKNTakk09BlXsnOql1Nr9BtdEoVrnqcfxFSdem8FbS0Uk6Xa4gl7v98sD1XEKTtCRs+lL/fL3bhiIb6XG2+rg8Dg+Z/9TGVQePrK3YkyrTtgZaENOpybIt848pauM9oZNIACZK0cjrjlGehh71tH/fd7jPOGq8BZNfAOtuElYBE4YnX9C2/bDoUfMI/0ho89frIj8PJInU3YkFuG2ZiumVICPI5hwuiQkaz5b/Xwp+tZp/JjAmFSwiZiwEa90hxtprAFyxBnuq9j0bjrpHdoZmN/HxZ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FD3F86283261341B8EC4DDFC3B6EF3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 43eb7fe9-e03e-4b27-289c-08d79ec3e073
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 22:47:22.0257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkfU6O9G3LgLNT/ro99fYwJUNYFflV2SIwji3WTleubQt+zUgfM7cCp05He06ucq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3038
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 11:41:06PM +0100, Daniel Borkmann wrote:
> On 1/21/20 8:54 PM, Martin KaFai Lau wrote:
> > This patch adds a helper to read the 64bit jiffies.  It will be used
> > in a later patch to implement the bpf_cubic.c.
> >=20
> > The helper is inlined.  "gen_inline" is added to "struct bpf_func_proto=
"
> > to do that.  This helper is available to CAP_SYS_ADMIN.
> >=20
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   include/linux/bpf.h      |  2 ++
> >   include/uapi/linux/bpf.h |  9 ++++++++-
> >   kernel/bpf/core.c        |  1 +
> >   kernel/bpf/helpers.c     | 27 +++++++++++++++++++++++++++
> >   kernel/bpf/verifier.c    | 18 ++++++++++++++++++
> >   net/core/filter.c        |  2 ++
> >   6 files changed, 58 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 8e3b8f4ad183..3d85ef44b247 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -258,6 +258,7 @@ enum bpf_return_type {
> >    */
> >   struct bpf_func_proto {
> >   	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
> > +	u32 (*gen_inline)(struct bpf_insn *insn_buf);
> >   	bool gpl_only;
> >   	bool pkt_access;
> >   	enum bpf_return_type ret_type;
> > @@ -1406,6 +1407,7 @@ extern const struct bpf_func_proto bpf_get_local_=
storage_proto;
> >   extern const struct bpf_func_proto bpf_strtol_proto;
> >   extern const struct bpf_func_proto bpf_strtoul_proto;
> >   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > +extern const struct bpf_func_proto bpf_jiffies64_proto;
> >   /* Shared helpers among cBPF and eBPF. */
> >   void bpf_user_rnd_init_once(void);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 033d90a2282d..d17c6bcd50cd 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2885,6 +2885,12 @@ union bpf_attr {
> >    *		**-EPERM** if no permission to send the *sig*.
> >    *
> >    *		**-EAGAIN** if bpf program can try again.
> > + *
> > + * u64 bpf_jiffies64(void)
> > + *	Description
> > + *		Obtain the 64bit jiffies
> > + *	Return
> > + *		The 64 bit jiffies
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -3004,7 +3010,8 @@ union bpf_attr {
> >   	FN(probe_read_user_str),	\
> >   	FN(probe_read_kernel_str),	\
> >   	FN(tcp_send_ack),		\
> > -	FN(send_signal_thread),
> > +	FN(send_signal_thread),		\
> > +	FN(jiffies64),
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 29d47aae0dd1..973a20d49749 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2137,6 +2137,7 @@ const struct bpf_func_proto bpf_map_pop_elem_prot=
o __weak;
> >   const struct bpf_func_proto bpf_map_peek_elem_proto __weak;
> >   const struct bpf_func_proto bpf_spin_lock_proto __weak;
> >   const struct bpf_func_proto bpf_spin_unlock_proto __weak;
> > +const struct bpf_func_proto bpf_jiffies64_proto __weak;
> >   const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
> >   const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index cada974c9f4e..b241cfd350c4 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -11,6 +11,7 @@
> >   #include <linux/uidgid.h>
> >   #include <linux/filter.h>
> >   #include <linux/ctype.h>
> > +#include <linux/jiffies.h>
> >   #include "../../lib/kstrtox.h"
> > @@ -312,6 +313,32 @@ void copy_map_value_locked(struct bpf_map *map, vo=
id *dst, void *src,
> >   	preempt_enable();
> >   }
> > +static u32 bpf_jiffies64_gen_inline(struct bpf_insn *insn_buf)
> > +{
> > +	struct bpf_insn *insn =3D insn_buf;
> > +#if BITS_PER_LONG =3D=3D 64
> > +	struct bpf_insn ld_jiffies_addr[2] =3D {
> > +		BPF_LD_IMM64(BPF_REG_0, (unsigned long)&jiffies),
> > +	};
> > +
> > +	BUILD_BUG_ON(sizeof(jiffies) !=3D sizeof(unsigned long));
> > +
> > +	*insn++ =3D ld_jiffies_addr[0];
> > +	*insn++ =3D ld_jiffies_addr[1];
> > +	*insn++ =3D BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0);
> > +#else
> > +	*insn++ =3D BPF_EMIT_CALL(BPF_CAST_CALL(get_jiffies_64));
> > +#endif
> > +
> > +	return insn - insn_buf;
> > +}
> > +
> > +const struct bpf_func_proto bpf_jiffies64_proto =3D {
> > +	.gen_inline	=3D bpf_jiffies64_gen_inline,
> > +	.gpl_only	=3D false,
> > +	.ret_type	=3D RET_INTEGER,
> > +};
> > +
> >   #ifdef CONFIG_CGROUPS
> >   BPF_CALL_0(bpf_get_current_cgroup_id)
> >   {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index ca17dccc17ba..91818aad2f80 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9447,6 +9447,24 @@ static int fixup_bpf_calls(struct bpf_verifier_e=
nv *env)
> >   patch_call_imm:
> >   		fn =3D env->ops->get_func_proto(insn->imm, env->prog);
> > +		if (fn->gen_inline) {
> > +			cnt =3D fn->gen_inline(insn_buf);
> > +			if (cnt =3D=3D 0 || cnt >=3D ARRAY_SIZE(insn_buf)) {
> > +				verbose(env, "bpf verifier is misconfigured\n");
> > +				return -EINVAL;
> > +			}
> > +
> > +			new_prog =3D bpf_patch_insn_data(env, i + delta,
> > +						       insn_buf, cnt);
> > +			if (!new_prog)
> > +				return -ENOMEM;
> > +
> > +			delta    +=3D cnt - 1;
> > +			env->prog =3D prog =3D new_prog;
> > +			insn      =3D new_prog->insnsi + i + delta;
> > +			continue;
> > +		}
>=20
> We do most of the inlining in fixup_bpf_calls() directly today, why
> breaking with that here with a special callback? (Agree it could probably
> be refactored in general, but such rework should also take the other
> helpers into account.)
Thanks for the review.

I will remove bpf_jiffies64_gen_inline() and move those logic
into fixup_bpf_calls().
