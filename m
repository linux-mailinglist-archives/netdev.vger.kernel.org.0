Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C900F35A0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfKGRXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:23:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58934 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfKGRXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:23:08 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HA37O019443;
        Thu, 7 Nov 2019 09:22:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7+cdWADptjpJ4KVY2HVx1kdfTTW70ThsyBuXdXvIKPQ=;
 b=Fva56fD8AEAmkNBn+QaAiKCyCvJzgTcBeENs62Yg+003O7YqrFGFj1cf5wAHvu/gO8yC
 m5IhgmcR5yWi/3O7TZNvNjoidT6D1V2seH2VrDEL/TB9FhX432jt27btwMbpijKbvL2k
 UG1cDOVXTprycyh5DmkA+ISBnfUdWB9Rvto= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0p9dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 09:22:52 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:22:52 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:22:52 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 09:22:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaHTF8/IHn0NyclQgLKwubuINmmSUo3iPUcK1sqwHSKVl+UFDjEHTE+Cn/LE9bRGIrSX68jkr8m2+0LcOkcwPvS9ckpb0ekBwivQua6Tk1EGa94dEvvHsigYgFv79LO5FEvtQhrDQc87SDAXvuqfVleTmwg6mD5+uIJUb6mJvM/KIJKT7PqNr91vqab9EU9Su8zsgIcka+EPLtYRDC9wUF43uu6MulCc4OdVUDiqrCGXoAlIrv5hopvF+Nw8uWDnOBEr9T0e6VCOp/LdIJE62rJQXGKdUpHAPqBjj9brHiUtUcTxiZD+fX7F/Eh+ncsCjhW500jav0HXk6soAHMaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+cdWADptjpJ4KVY2HVx1kdfTTW70ThsyBuXdXvIKPQ=;
 b=C+v3s5+Shq9IdjnApiMon1ZtUlEVwI1z+ebegrPjquEg2tPWLa90k0IGRT3j0T5+9gQ6ppUM9JtW7iTvxtkKqauqNgwSjpdX2u0PPqp9MP7LIDm8HOrQvl+6b/pYPeY24nJLE10Vjwpv+jW4K7fjWgUrxtjKlqru/bmRzQ1VuUVIuh5C6e/jVXMwRAA+nxoCkZYeV14GibQfUw9vbefwCgtCzPRCwCzPp9U0OVdpu67ymcpF8UQaLW+Ntj1IZr/LI58RePNZPmVI8hdUVe6+wiDJAlpWUXBAjOvwQFDJHS/jCXbpCU4OqpLmrC72QfHVmYQWJyxWyAVexHL+9mWGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+cdWADptjpJ4KVY2HVx1kdfTTW70ThsyBuXdXvIKPQ=;
 b=cqKxrge1YWynaKGquKHeoL2lavOntnH4Z2UyIACQ8BC5IySzH0cPbFoPbZO+cQMc9b+qArUDmAHl0iXcCBUxP5BwimiE6rKsfl49RWpbBKrKXNb0Xr+o8UcyyCZs6Cla1kuk5v/eQsnwPRzxlfZXflaYQ9fuJ29FbsiL1dXKJF8=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2991.namprd15.prod.outlook.com (20.178.252.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 17:22:47 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2408.028; Thu, 7 Nov 2019
 17:22:47 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: Add array support to
 btf_struct_access
Thread-Topic: [PATCH v3 bpf-next 2/3] bpf: Add array support to
 btf_struct_access
Thread-Index: AQHVlRTec1YDPBeGSEq2yD+jQLjRZ6d/9cOA
Date:   Thu, 7 Nov 2019 17:22:47 +0000
Message-ID: <20191107172243.ptq3yqeacxjkmkbq@kafai-mbp>
References: <20191107014639.384014-1-kafai@fb.com>
 <20191107014643.384298-1-kafai@fb.com>
 <CAEf4BzaQOEjbJwV9Ycb1QdBVkFRQLB_3cyw1sfXTz-iV_pt4Yw@mail.gmail.com>
In-Reply-To: <CAEf4BzaQOEjbJwV9Ycb1QdBVkFRQLB_3cyw1sfXTz-iV_pt4Yw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0076.namprd22.prod.outlook.com
 (2603:10b6:301:5e::29) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f7b8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2790a0c9-edf3-4563-6992-08d763a71b78
x-ms-traffictypediagnostic: MN2PR15MB2991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2991C5AD69D4D6EDC1DFABEDD5780@MN2PR15MB2991.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(6246003)(229853002)(5660300002)(86362001)(64756008)(53546011)(76176011)(486006)(52116002)(81166006)(81156014)(305945005)(6512007)(386003)(66946007)(7736002)(66556008)(2906002)(66446008)(33716001)(476003)(66476007)(46003)(6506007)(8936002)(11346002)(54906003)(71200400001)(316002)(14444005)(256004)(8676002)(99286004)(446003)(9686003)(102836004)(4326008)(14454004)(1076003)(71190400001)(478600001)(25786009)(6116002)(6486002)(6436002)(186003)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2991;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cdets6ydc5ofxzrUfQibOrK+fBdkdmMZYW0fdpezb4JPvxTGtWSZh0pi489N6mfNJzp8tKgcVc7TPw3XEyjx8i9EsEByOBNWUVik7g8oXpYduFVYL4+SFIs3msZA6w0W0Fs9qlScRJje0qEWtbL3kpXuedwddO4vV/BHNuTPh4J13FpmrTkSnvhWFZwB5JQGE/npH0iiRjFP14gWtybFQxFd6CMryFMu8NoYH39uULSxDdrXpsspmJMaKk8JREf6/hVmgrxVPAFqR6PblCTLzXWYYbVgAWvSlniaUGlze7qJdAw8JcQWlM/M/FZRye9I0UyBQeyNol4Ky6kR1h8jeggOEa9k9r947SbKGcn9cQIEehwzijrCLnHdezPxcffbIGPG5Z3UofdGw/bg/DWGxL7pIDPk1ifebNuqhbdSF1meixEqHymkdvWbVx6rMmZQ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <323B75AAAA4B674989E28DDA51B0F6E2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2790a0c9-edf3-4563-6992-08d763a71b78
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:22:47.0697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XVrGiyf2bZypb1+xjDzPcJAwNITLq4GuVGIF5coYzI9PgrTvcqUGSI4UlvIDI2JA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2991
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 06:41:15PM -0800, Andrii Nakryiko wrote:
> On Wed, Nov 6, 2019 at 5:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds array support to btf_struct_access().
> > It supports array of int, array of struct and multidimensional
> > array.
> >
> > It also allows using u8[] as a scratch space.  For example,
> > it allows access the "char cb[48]" with size larger than
> > the array's element "char".  Another potential use case is
> > "u64 icsk_ca_priv[]" in the tcp congestion control.
> >
> > btf_resolve_size() is added to resolve the size of any type.
> > It will follow the modifier if there is any.  Please
> > see the function comment for details.
> >
> > This patch also adds the "off < moff" check at the beginning
> > of the for loop.  It is to reject cases when "off" is pointing
> > to a "hole" in a struct.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> Looks good, just two small nits.
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
> >  kernel/bpf/btf.c | 187 +++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 157 insertions(+), 30 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 128d89601d73..5c4b6aa7b9f0 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -1036,6 +1036,82 @@ static const struct resolve_vertex *env_stack_pe=
ak(struct btf_verifier_env *env)
> >         return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
> >  }
> >
>=20
> [...]
>=20
> > -               if (off + size <=3D moff / 8)
> > -                       /* won't find anything, field is already too fa=
r */
> > +               /* offset of the field in bytes */
> > +               moff =3D btf_member_bit_offset(t, member) / 8;
> > +               if (off + size <=3D moff)
>=20
> you dropped useful comment :(
good catch. will undo.

>=20
> >                         break;
> > +               /* In case of "off" is pointing to holes of a struct */
> > +               if (off < moff)
> > +                       continue;
> >
>=20
> [...]
>=20
> > +
> > +               mtrue_end =3D moff + msize;
>=20
> nit: there is no other _end, so might be just mend (in line with moff)
I prefer to keep it.  For array, this _end is not the end of mtype.
The intention is to distinguish it from the mtype/msize convention
such that it is the true_end of the current struct's member.  I will
add some comments to clarify.

>=20
> > +               if (off >=3D mtrue_end)
> >                         /* no overlap with member, keep iterating */
> >                         continue;
> > +
>=20
> [...]
