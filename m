Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14599148F2B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbgAXUNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:13:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387535AbgAXUNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 15:13:36 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00OKDOmj011190;
        Fri, 24 Jan 2020 12:13:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=38WSE+glkFZRFrwcPSlI69oHzKL+PJJJzmTPaKJHKIQ=;
 b=l1fL+zFkAfr8mqZef74L2V2eE908FMRT8+WJdqLAaPFd6zEWioGWdfox8hOMQ8WCovmL
 AZiHb1PlYjnE/u1OnmK3A4aYcXOw9S/csD6/VzmpF074NFItuGKOTp50zY4M0/onLwkl
 YOyi7/KsHjyOYWyUyBQFtHIZbpVSMObkJCs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xr61ngdyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Jan 2020 12:13:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 24 Jan 2020 12:12:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7BVPu3qZF5aIB/d4B4AsYuHB9ldIgzZ0mK2QhuRKxjULcaFJTS9iiSxMresvKO8HYlhB12m9XLV6FGOsp0l0xwvyV9/xRiLqUp5vtfdpS0CZushQLhm2f0FHtSzFiGr2GnWkKEPOgJ0dHoLuQok58fLkwV2prTHeap1MomeIMPpcQbosR91zblgiJ4Wx9bEa4G/D0upNthuy7pvtJTIFRXWvy80jeZZDThYZ1DC+5iRPI3j3CzHVtgoUT/7AQkMGFSY/3MsL0igFemHcTppe28GyTrMBUz9g7k6h8XUtbtktsGx6B4vosLZ+OB1I3OSD7xenE/HA3kVIuuTn9WNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38WSE+glkFZRFrwcPSlI69oHzKL+PJJJzmTPaKJHKIQ=;
 b=EUuY4RlYGM3Yt6TGyrUUTxQm+KfgLb9KsnIgzes/8DeVo0BIG+6Kl6ApstHEecJDd735CfYLLzOgNCiReBsPF3dpPUlUpswaIj9VEeb4Swi1FNUyv1Wiu5b+2cspJnf7hsJPRcs2p9ykm7bEAFPvQ2eRZZ9csaTntZtixvc4UvKfx8l6CKdqEKjWIPtfxCsIYaf3eyECDoSjz6Zg+hK75hjMa/mL0Y509AU3EaQmKMHrNsO+WXTs57HlH9Kh2M0XYi9K0R0hRSxpkMZAXBqyZZXWc5hnvQpDihHl7/GmHEVjTZXQmvkm4aNBiY9Br9k9aJ4HVgDjnr/Q1pi8LPfTTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38WSE+glkFZRFrwcPSlI69oHzKL+PJJJzmTPaKJHKIQ=;
 b=eWA2pfiuDQk8zdDkoJPxR75StN+0RqeTy+wROcO9bcxjdLT1Ps3qIhDGxWjifeL4JkREbR7ZV3qI7Um0ZxC/aAnSWQlJaSggPwU4IUiuXQ73LEkrxuK2v00kjub6z4PU6bNRKCmvxEYaZZxq7jLy/yifqvD99cilVGJxUHFCMCk=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2896.namprd15.prod.outlook.com (20.178.251.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 24 Jan 2020 20:12:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 20:12:45 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::beb1) by CO2PR07CA0075.namprd07.prod.outlook.com (2603:10b6:100::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 20:12:44 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
Thread-Topic: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
Thread-Index: AQHV0niPDYdGIcPm+U6Ab9Oo5xV7Xqf5aK8AgAC7AACAAByigA==
Date:   Fri, 24 Jan 2020 20:12:45 +0000
Message-ID: <20200124201241.722pbppudaiw4cz4@kafai-mbp.dhcp.thefacebook.com>
References: <20200124053837.2434679-1-andriin@fb.com>
 <20200124072054.2kr25erckbclkwgv@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbM7s8JWM8bPq=JdFX-ujkbYUifD7hNUQOGSJpJ7x5NJw@mail.gmail.com>
In-Reply-To: <CAEf4BzbM7s8JWM8bPq=JdFX-ujkbYUifD7hNUQOGSJpJ7x5NJw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0075.namprd07.prod.outlook.com (2603:10b6:100::43)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::beb1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c41a1e0e-8221-427c-cb83-08d7a109c68b
x-ms-traffictypediagnostic: MN2PR15MB2896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB28967554FC6DFE6EC7325527D50E0@MN2PR15MB2896.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(136003)(396003)(346002)(199004)(189003)(5660300002)(66446008)(64756008)(6916009)(66476007)(66556008)(66946007)(186003)(52116002)(7696005)(55016002)(6506007)(16526019)(53546011)(9686003)(54906003)(2906002)(316002)(8676002)(81166006)(81156014)(71200400001)(86362001)(1076003)(8936002)(4326008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2896;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0ld7/UyTdvfyHX69sGyGPXjsiTv7VEItCP+kDyrweWxP7qBTkhoWzABiDHQl9RCP94pT1pZsCuOYIa+qJBaxQuhusUYt+ijL1Xi3kQ+MTaoDw4/B+MkkomqKZsaXXp3rtp3vrXUe+griQ2nMRkiemHHdha3IoR5QtmNQSJjB35UDzyRqsCAikcOsvwz1BzS1SVGA4iZf+xwtPShM1sv6JomcwtFQrShOEeBATXN1RSLeABWuAGFUcnecMOv/TKmlPf6T4f+XziNmXB/+M0gW7G64AzZPRhqtZcDev66GwRrXr/0AE2UcBZ0/4Tk45zB22XMUK+rwHWPj37EQPCUMgTZLvzTkGxJr2grECA5ugqCvr4exzT2p1Vw6g8SEH8HkhGyn98okquD384vNVlIR6p2+vFw6V2InimOfIvNts9gJ6rIPUX9aSW5xqeD9Blw
x-ms-exchange-antispam-messagedata: DulbWp7d3QmrrsuV+q69chTxoaGLhkXCLM8lo7YQjD18TZ3bMzT2h2+R+uhW3UR1Ie6KQbo6tudnIzh5427PYSr+5hMw9lQpo2cFF+vRXIi0ITZOVT30X482s7rMsTa/VyNDxriOQUG5a4uN2KVHivXGL5yeZROC/8ByoEbGxtw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <360B2441AA2F4F4493C0D5122A9F95BC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c41a1e0e-8221-427c-cb83-08d7a109c68b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:12:45.6890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ycrZI/lDGp1LqrYEkbvrIFyggH+KYaEvgTJSn4s5ass/PclddH43Jpo33Rafe3CV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2896
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_06:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001240166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 10:30:12AM -0800, Andrii Nakryiko wrote:
> On Thu, Jan 23, 2020 at 11:21 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Thu, Jan 23, 2020 at 09:38:37PM -0800, Andrii Nakryiko wrote:
> > > Previously, if libbpf failed to resolve CO-RE relocation for some
> > > instructions, it would either return error immediately, or, if
> > > .relaxed_core_relocs option was set, would replace relocatable offset=
/imm part
> > > of an instruction with a bogus value (-1). Neither approach is good, =
because
> > > there are many possible scenarios where relocation is expected to fai=
l (e.g.,
> > > when some field knowingly can be missing on specific kernel versions)=
. On the
> > > other hand, replacing offset with invalid one can hide programmer err=
ors, if
> > > this relocation failue wasn't anticipated.
> > >
> > > This patch deprecates .relaxed_core_relocs option and changes the app=
roach to
> > > always replacing instruction, for which relocation failed, with inval=
id BPF
> > > helper call instruction. For cases where this is expected, BPF progra=
m should
> > > already ensure that that instruction is unreachable, in which case th=
is
> > > invalid instruction is going to be silently ignored. But if instructi=
on wasn't
> > > guarded, BPF program will be rejected at verification step with verif=
ier log
> > > pointing precisely to the place in assembly where the problem is.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 95 +++++++++++++++++++++++++---------------=
--
> > >  tools/lib/bpf/libbpf.h |  6 ++-
> > >  2 files changed, 61 insertions(+), 40 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index ae34b681ae82..39f1b7633a7c 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -345,7 +345,6 @@ struct bpf_object {
> > >
> > >       bool loaded;
> > >       bool has_pseudo_calls;
> > > -     bool relaxed_core_relocs;
> > >
> > >       /*
> > >        * Information when doing elf related work. Only valid if fd
> > > @@ -4238,25 +4237,38 @@ static int bpf_core_calc_field_relo(const str=
uct bpf_program *prog,
> > >   */
> > >  static int bpf_core_reloc_insn(struct bpf_program *prog,
> > >                              const struct bpf_field_reloc *relo,
> > > +                            int relo_idx,
> > >                              const struct bpf_core_spec *local_spec,
> > >                              const struct bpf_core_spec *targ_spec)
> > >  {
> > > -     bool failed =3D false, validate =3D true;
> > >       __u32 orig_val, new_val;
> > >       struct bpf_insn *insn;
> > > +     bool validate =3D true;
> > >       int insn_idx, err;
> > >       __u8 class;
> > >
> > >       if (relo->insn_off % sizeof(struct bpf_insn))
> > >               return -EINVAL;
> > >       insn_idx =3D relo->insn_off / sizeof(struct bpf_insn);
> > > +     insn =3D &prog->insns[insn_idx];
> > > +     class =3D BPF_CLASS(insn->code);
> > >
> > >       if (relo->kind =3D=3D BPF_FIELD_EXISTS) {
> > >               orig_val =3D 1; /* can't generate EXISTS relo w/o local=
 field */
> > >               new_val =3D targ_spec ? 1 : 0;
> > >       } else if (!targ_spec) {
> > > -             failed =3D true;
> > > -             new_val =3D (__u32)-1;
> > > +             pr_debug("prog '%s': relo #%d: substituting insn #%d w/=
 invalid insn\n",
> > > +                      bpf_program__title(prog, false), relo_idx, ins=
n_idx);
> > > +             insn->code =3D BPF_JMP | BPF_CALL;
> > > +             insn->dst_reg =3D 0;
> > > +             insn->src_reg =3D 0;
> > > +             insn->off =3D 0;
> > > +             /* if this instruction is reachable (not a dead code),
> > > +              * verifier will complain with the following message:
> > > +              * invalid func unknown#195896080
> > > +              */
> > > +             insn->imm =3D 195896080; /* =3D> 0xbad2310 =3D> "bad re=
lo" */
> > Should this value become a binded contract in uapi/bpf.h so
> > that the verifier can print a more meaningful name than "unknown#195896=
080"?
> >
>=20
> It feels a bit premature to fix this in kernel. It's one of many ways
> we can do this, e.g., alternative would be using invalid opcode
> altogether. It's not yet clear what's the best way to report this from
> kernel. Maybe in the future verifier will have some better way to
> pinpoint where and what problem there is in user's program through
> some more structured approach than current free-form log.
>=20
> So what I'm trying to say is that we should probably get a bit more
> experience using these features first and understand what
> kernel/userspace interface should be for reporting issues like this,
> before setting anything in stone in verifier. For now, this
> "unknown#195896080" should be a pretty unique search term :)
Sure.  I think this value will never be used for real in the life time.
I was mostly worry this message will be confusing.  May be the loader
could be improved to catch this and interpret it in a more meaningful
way.

The change lgtm,

Acked-by: Martin KaFai Lau <kafai@fb.com>
