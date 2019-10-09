Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 067ECD04CA
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfJIAes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:34:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbfJIAes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 20:34:48 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x990IQOJ029181;
        Tue, 8 Oct 2019 17:34:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=v2zP8X+RtpKEWqUt6Ao/z6KLhUqPL9wFCa8rGRnsSvM=;
 b=FNehFexfKH4PtbDwn+SQ0i/DwAx5mf0QsfdSzYK2qfLAFboBA0HnKw/JXAnc0OGDbwdA
 vmakvXNjy3a74BJ6lyzPDN4hdTKQg3bg9btKQzG9oo4TsJoWko9UbHzBjC82pYAM3o2Q
 2hKfYNmAH/T674dDcdCJsLR38xrmdJHnzSs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9mqm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Oct 2019 17:34:34 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 8 Oct 2019 17:34:33 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 17:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccZwyju5HwXmfhGzWR9GOKgabyrb5J0TlcZggFMVa9+/H6vMfDgC1MR+Kc2heQzApF0UYBWGh1/jCB59YvL25gUzQCk4r27awfwWz0+j8H4QUGpd6CiAeQ7Jq8PBb8Clmop6DNg8dSz866zcaZpaOfiuy/1MemksbitTkuC0iagN1fT6biFyWfr/hiFtWloxnGS5krRmYJeowd3y+qPKquCWcl0jtLiepEhq8YoFcngQI2rXq4CARvm9Dq2A5exYKWzym95hZwijT5g0Oaw91aSHvYcb6ohZUtGYftDzz0IzIa2P2LoG9Dl9bEt6meDTmxCjuiYHT0O/DngQ2ZsLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2zP8X+RtpKEWqUt6Ao/z6KLhUqPL9wFCa8rGRnsSvM=;
 b=URpdA7MiiK12p896jCeyJeJST9GmvYlUVu28vgeh9/Q8pJjSAUruVU6clF7aldKKIsxhfNgYhtVolDs4YAMES5q4vuTosV7PmReemcZ2rLeR+SL1RVHxBIQj49y+QOppgB2ePTZVcxfWu8Oy0HrvkccXZifNKZi62BaFWHj6zlLYJJcFlfpo8RNwPBrhc6041zpJdV8apz5LaMyUDK9j8+2fWfGjlVo2ZboFY4g0vOIY3PVvY5akoB8++fh34cdVqIeKaEgYnnonTpYpCatieccW6JWu1L5HMysqfqNMRhHVwcktXti0FrlUdtGdwH2Jd2bGE1mRKhz0hpFVLCmjUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2zP8X+RtpKEWqUt6Ao/z6KLhUqPL9wFCa8rGRnsSvM=;
 b=h3+E/mD2lpGbQp4UQ61RFMZvUICczFExXkeECkMTDn8Bcfb+GFwWa7NiFsBIkPAgF2kIljdWpKwnPRTNYDXP7MEzRrnaT1cGgH7YGkI0DLcD7KrNuupJcOrzuD4saUYB8PBpaslPg4abk2xCnSTeFnDlWIIx/xymV6BoeEmqEfg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2799.namprd15.prod.outlook.com (20.179.147.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 00:34:32 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2327.023; Wed, 9 Oct 2019
 00:34:32 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as
 scalars
Thread-Topic: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as
 scalars
Thread-Index: AQHVfhENq5XFICrTfUW95LiPtBist6dRSXeAgAAgdACAAAyMAA==
Date:   Wed, 9 Oct 2019 00:34:32 +0000
Message-ID: <20191009003424.ewbra36vpgla2rlj@kafai-mbp.dhcp.thefacebook.com>
References: <20191008194548.2344473-1-andriin@fb.com>
 <20191008194548.2344473-2-andriin@fb.com>
 <20191008215321.hrlrbgsdifnziji6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaLHY9MHbp27VxvVZcKWvbO43F2n6frKi_8kgqCXMDKMg@mail.gmail.com>
In-Reply-To: <CAEf4BzaLHY9MHbp27VxvVZcKWvbO43F2n6frKi_8kgqCXMDKMg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0025.namprd13.prod.outlook.com
 (2603:10b6:301:29::38) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:c9d3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0607cf89-7f1c-4a99-a95b-08d74c5073bb
x-ms-traffictypediagnostic: MN2PR15MB2799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2799E199F312F30FFE564360D5950@MN2PR15MB2799.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(396003)(39860400002)(199004)(189003)(4326008)(46003)(256004)(14444005)(386003)(6436002)(102836004)(6506007)(11346002)(486006)(476003)(446003)(76176011)(52116002)(99286004)(8676002)(9686003)(81156014)(6512007)(316002)(81166006)(6246003)(478600001)(54906003)(25786009)(8936002)(66946007)(66446008)(64756008)(66556008)(66476007)(6916009)(53546011)(7736002)(2906002)(5660300002)(186003)(86362001)(6486002)(6116002)(229853002)(71200400001)(71190400001)(14454004)(1076003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2799;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lCSk5WTZh0IjnIgAILiodwtghaEfu345zO7j2vLF7UGVwp5eUpadqDe/IEfJZXbtSm0GmYSpFNgV5tvPhk8fk8r3zc6C1KLkg+m2sEncb2jaOwekNU65ZyUebFlr3yCOyI/is/RMHUd9AHSqAGAMaoEVpbPUqD2QJSmZX7whVI8W2fCoDX6F3lO7MUgoy1btkNzUpytuh+MK2NR/l9kEJq3uvmgcEx1KB1f+lY31HK/SLS/C0KCpa4HY9JjcZc+RQ61u2X9+GQkC8ov0Gb378sckXcf73W/pmTIWGAT32ldU/aULXrI5BW8bSjqOMx20PXcyrCdNlRfPq+GJ1D3eSGNDgP/nyyOg73xGF0On4fWkflpyqTN3t6Lb1nuyhhEfHsOU8LeZmqpzEGMLulUbc04J26tRfWYe+YC85ZGk/V4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EEB8CB9E03BE6D47A4535E0AF24CC54A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0607cf89-7f1c-4a99-a95b-08d74c5073bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 00:34:32.1805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jgiKG4wFU6EdXmvoPvWaaf3avWo7MwXvBTMzHSF/cqtOk+l7uuu8CCmZVPOzMjh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2799
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_09:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 04:49:30PM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 8, 2019 at 2:53 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Tue, Oct 08, 2019 at 12:45:47PM -0700, Andrii Nakryiko wrote:
> > > Maps that are read-only both from BPF program side and user space sid=
e
> > > have their contents constant, so verifier can track referenced values
> > > precisely and use that knowledge for dead code elimination, branch
> > > pruning, etc. This patch teaches BPF verifier how to do this.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++=
--
> > >  1 file changed, 56 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index ffc3e53f5300..1e4e4bd64ca5 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_=
state *reg, int size)
> > >       reg->smax_value =3D reg->umax_value;
> > >  }
> > >
> > > +static bool bpf_map_is_rdonly(const struct bpf_map *map)
> > > +{
> > > +     return (map->map_flags & BPF_F_RDONLY_PROG) &&
> > > +            ((map->map_flags & BPF_F_RDONLY) || map->frozen);
> > > +}
> > > +
> > > +static int bpf_map_direct_read(struct bpf_map *map, int off, int siz=
e, u64 *val)
> > > +{
> > > +     void *ptr;
> > > +     u64 addr;
> > > +     int err;
> > > +
> > > +     err =3D map->ops->map_direct_value_addr(map, &addr, off + size)=
;
> > Should it be "off" instead of "off + size"?
>=20
> From array_map_direct_value_addr() code, offset is used only to check
> that access is happening within array value bounds.
The "size" check is done separately in the check_map_access(),
so "off" is offset alone, I think.

> It's not used to
> calculate returned pointer.
> But now re-reading its code again, I think this check is wrong:
>=20
> if (off >=3D map->value_size)
>         break;
>=20
> It has to be (off > map->value_size). But it seems like this whole
> interface is counter-intuitive.
>=20
> I'm wondering if Daniel can clarify the intent behind this particular beh=
avior.
>=20
> For now the easiest fix is to pass (off + size - 1). But maybe we
> should change the contract to be something like
>=20
> int map_direct_value_addr(const struct bpf_map *map, u64 off, int
> size, void *ptr)
>=20
> This then can validate that entire access in the range of [off, off +
> size) is acceptable to a map, and then return void * pointer according
> to given off. Thoughts?
>=20
> >
> > > +     if (err)
> > > +             return err;
> > > +     ptr =3D (void *)addr + off;
> > > +
> > > +     switch (size) {
> > > +     case sizeof(u8):
> > > +             *val =3D (u64)*(u8 *)ptr;
> > > +             break;
> > > +     case sizeof(u16):
> > > +             *val =3D (u64)*(u16 *)ptr;
> > > +             break;
> > > +     case sizeof(u32):
> > > +             *val =3D (u64)*(u32 *)ptr;
> > > +             break;
> > > +     case sizeof(u64):
> > > +             *val =3D *(u64 *)ptr;
> > > +             break;
> > > +     default:
> > > +             return -EINVAL;
> > > +     }
> > > +     return 0;
> > > +}
> > > +
> > >  /* check whether memory at (regno + off) is accessible for t =3D (re=
ad | write)
> > >   * if t=3D=3Dwrite, value_regno is a register which value is stored =
into memory
> > >   * if t=3D=3Dread, value_regno is a register which will receive the =
value from memory
> > > @@ -2776,9 +2812,27 @@ static int check_mem_access(struct bpf_verifie=
r_env *env, int insn_idx, u32 regn
> > >               if (err)
> > >                       return err;
> > >               err =3D check_map_access(env, regno, off, size, false);
> > > -             if (!err && t =3D=3D BPF_READ && value_regno >=3D 0)
> > > -                     mark_reg_unknown(env, regs, value_regno);
> > > +             if (!err && t =3D=3D BPF_READ && value_regno >=3D 0) {
> > > +                     struct bpf_map *map =3D reg->map_ptr;
> > > +
> > > +                     /* if map is read-only, track its contents as s=
calars */
> > > +                     if (tnum_is_const(reg->var_off) &&
> > > +                         bpf_map_is_rdonly(map) &&
> > > +                         map->ops->map_direct_value_addr) {
> > > +                             int map_off =3D off + reg->var_off.valu=
e;
> > > +                             u64 val =3D 0;
> > >
> > > +                             err =3D bpf_map_direct_read(map, map_of=
f, size,
> > > +                                                       &val);
> > > +                             if (err)
> > > +                                     return err;
> > > +
> > > +                             regs[value_regno].type =3D SCALAR_VALUE=
;
> > > +                             __mark_reg_known(&regs[value_regno], va=
l);
> > > +                     } else {
> > > +                             mark_reg_unknown(env, regs, value_regno=
);
> > > +                     }
> > > +             }
> > >       } else if (reg->type =3D=3D PTR_TO_CTX) {
> > >               enum bpf_reg_type reg_type =3D SCALAR_VALUE;
> > >
> > > --
> > > 2.17.1
> > >
