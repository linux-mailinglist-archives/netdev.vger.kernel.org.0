Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230344E43
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFMVTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:19:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfFMVTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:19:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DL8KKn009319;
        Thu, 13 Jun 2019 14:19:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8VFoAWD9I6crHApvpcVvd6eFcjh6E5LYDfxuA89/r00=;
 b=EsrzUFp7knp7+6NcO3uAaAEHTQsEX4KdmRJFitnFItIYos3BKV3nc8qoGZLf/B14Vzna
 FH5UPk6Cv0PKQqgizZsL6XjGkZfHsYBUsx41QLCF7xP3VWM35nJ2jzY+SiWZfwcrU7yV
 Mw34LkI9333FXlZzBhc6E11NKNVv7dUh3Lo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3pr5hqvk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Jun 2019 14:19:09 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 13 Jun 2019 14:19:00 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 14:19:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VFoAWD9I6crHApvpcVvd6eFcjh6E5LYDfxuA89/r00=;
 b=KBeLJz/7uF8KjtKGrSd1un+mMs11qkzk5y+YCRwXNjbXWduWdipW4oDt/0M2WjLJFcixyy92buQiBd5+CUajYkXat5qBxi5FUhvb/l34APE58RMwoKTFiofb25TULQoiWkc4mHr8bj2En+RlRcKuBwAp1INVHeM4N4ryVb94rOY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1230.namprd15.prod.outlook.com (10.175.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 21:18:59 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 21:18:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: net: Add SO_DETACH_REUSEPORT_BPF
Thread-Topic: [PATCH bpf-next 1/2] bpf: net: Add SO_DETACH_REUSEPORT_BPF
Thread-Index: AQHVIVINbsRiNwGa1EuW6ryOybfhaaaaBqUAgAAR7gA=
Date:   Thu, 13 Jun 2019 21:18:58 +0000
Message-ID: <20190613211856.2b54i5tlgqexmcmc@kafai-mbp.dhcp.thefacebook.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190537.2340206-1-kafai@fb.com>
 <CAEf4BzZvPsV5kva8Nn+xQjpHHGDTYZLJae5Y=eHSWekVZkmzcQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZvPsV5kva8Nn+xQjpHHGDTYZLJae5Y=eHSWekVZkmzcQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:a03:100::40) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:857]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dafa5ca-d75b-4fa6-712e-08d6f044bfda
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1230;
x-ms-traffictypediagnostic: MWHPR15MB1230:
x-microsoft-antispam-prvs: <MWHPR15MB1230D687F07211F2642E334DD5EF0@MWHPR15MB1230.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(39860400002)(366004)(376002)(189003)(199004)(14454004)(1076003)(71200400001)(6916009)(8936002)(316002)(14444005)(2906002)(229853002)(256004)(5024004)(71190400001)(86362001)(54906003)(6246003)(5660300002)(478600001)(99286004)(68736007)(7736002)(6116002)(66946007)(6506007)(8676002)(73956011)(66476007)(64756008)(53546011)(386003)(66556008)(102836004)(66446008)(4326008)(52116002)(53936002)(25786009)(81156014)(76176011)(186003)(81166006)(11346002)(9686003)(6512007)(46003)(6436002)(486006)(6486002)(446003)(476003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1230;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jaqxDy/wY66uja1R24sXJl/NkGnzZvq6aGoBTfBrZ8vMvDWKMEc3a0BbtW2798Gz06H494DmUlwlWkDliQsiWrmMfuba43QUg0XhA7Pa8M7L17wIP1Kr+R/+FrhMFcEYVtAhMrGqK1xlRC2i9SqlJJ8AjVGoxGFOmKl1c7pH1s7R44uWz4ELv/7QGOKyS8NFiM+NjS41+qfVSUmJKDwQJnoqaGSGpBaJ7slV8wnWadI7Ju8tyZTkP3+V3DxKuSa5uMKfLdwYP88Moeo+mcbqyU1BYOJsg2UxQcjDqcEg3hCLNzvjRHisr6Bhwl+xuOqIx998SwkG0kkX85xFllVzVcvv6ED4yzwXaelvCbNSeK3tZfqm+IUWfKIxp1JwwdZ0ji7uy478wVnenaSVoM7xyW/PfvqIbRFXuvQr0XHINcE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C6CFE1A680FCDE45B26E3E214CFC0199@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dafa5ca-d75b-4fa6-712e-08d6f044bfda
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 21:18:59.0123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1230
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 01:14:46PM -0700, Andrii Nakryiko wrote:
> On Wed, Jun 12, 2019 at 12:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > There is SO_ATTACH_REUSEPORT_[CE]BPF but there is no DETACH.
> > This patch adds SO_DETACH_REUSEPORT_BPF sockopt.  The same
> > sockopt can be used to undo both SO_ATTACH_REUSEPORT_[CE]BPF.
> >
> > reseport_detach_prog() is added and it is mostly a mirror
> > of the existing reuseport_attach_prog().  The differences are,
> > it does not call reuseport_alloc() and returns -ENOENT when
> > there is no old prog.
> >
> > Cc: Craig Gallek <kraig@google.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  arch/alpha/include/uapi/asm/socket.h  |  2 ++
> >  arch/mips/include/uapi/asm/socket.h   |  2 ++
> >  arch/parisc/include/uapi/asm/socket.h |  2 ++
> >  arch/sparc/include/uapi/asm/socket.h  |  2 ++
> >  include/net/sock_reuseport.h          |  2 ++
> >  include/uapi/asm-generic/socket.h     |  2 ++
> >  net/core/sock.c                       |  4 ++++
> >  net/core/sock_reuseport.c             | 24 ++++++++++++++++++++++++
> >  8 files changed, 40 insertions(+)
> >
> > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/=
uapi/asm/socket.h
> > index 976e89b116e5..de6c4df61082 100644
> > --- a/arch/alpha/include/uapi/asm/socket.h
> > +++ b/arch/alpha/include/uapi/asm/socket.h
> > @@ -122,6 +122,8 @@
> >  #define SO_RCVTIMEO_NEW         66
> >  #define SO_SNDTIMEO_NEW         67
> >
> > +#define SO_DETACH_REUSEPORT_BPF 68
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/ua=
pi/asm/socket.h
> > index d41765cfbc6e..d0a9ed2ca2d6 100644
> > --- a/arch/mips/include/uapi/asm/socket.h
> > +++ b/arch/mips/include/uapi/asm/socket.h
> > @@ -133,6 +133,8 @@
> >  #define SO_RCVTIMEO_NEW         66
> >  #define SO_SNDTIMEO_NEW         67
> >
> > +#define SO_DETACH_REUSEPORT_BPF 68
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/includ=
e/uapi/asm/socket.h
> > index 66c5dd245ac7..10173c32195e 100644
> > --- a/arch/parisc/include/uapi/asm/socket.h
> > +++ b/arch/parisc/include/uapi/asm/socket.h
> > @@ -114,6 +114,8 @@
> >  #define SO_RCVTIMEO_NEW         0x4040
> >  #define SO_SNDTIMEO_NEW         0x4041
> >
> > +#define SO_DETACH_REUSEPORT_BPF 0x4042
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/=
uapi/asm/socket.h
> > index 9265a9eece15..1895ac112a24 100644
> > --- a/arch/sparc/include/uapi/asm/socket.h
> > +++ b/arch/sparc/include/uapi/asm/socket.h
> > @@ -115,6 +115,8 @@
> >  #define SO_RCVTIMEO_NEW          0x0044
> >  #define SO_SNDTIMEO_NEW          0x0045
> >
> > +#define SO_DETACH_REUSEPORT_BPF  0x0046
>=20
>=20
> Oh, it's so nasty, there is
>=20
> #define SO_TIMESTAMP_NEW         0x0046
>=20
> few lines above this, completely out of order. Let's reorder it to
> avoid issues like this one.
I probably will not reorder any existing one in v3.  SO_TIMESTAMP_NEW
seems not the only one.  It may worth a separate patch effort.

I will use 0x0047.

>
> > +
> >  #if !defined(__KERNEL__)
> >
> >
> > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.=
h
> > index 8a5f70c7cdf2..d9112de85261 100644
> > --- a/include/net/sock_reuseport.h
> > +++ b/include/net/sock_reuseport.h
> > @@ -35,6 +35,8 @@ extern struct sock *reuseport_select_sock(struct sock=
 *sk,
> >                                           struct sk_buff *skb,
> >                                           int hdr_len);
> >  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *pro=
g);
> > +extern int reuseport_detach_prog(struct sock *sk);
> > +
> >  int reuseport_get_id(struct sock_reuseport *reuse);
> >
> >  #endif  /* _SOCK_REUSEPORT_H */
> > diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-gener=
ic/socket.h
> > index 8c1391c89171..77f7c1638eb1 100644
> > --- a/include/uapi/asm-generic/socket.h
> > +++ b/include/uapi/asm-generic/socket.h
> > @@ -117,6 +117,8 @@
> >  #define SO_RCVTIMEO_NEW         66
> >  #define SO_SNDTIMEO_NEW         67
> >
> > +#define SO_DETACH_REUSEPORT_BPF 68
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64 || (defined(__x86_64__) && defined(__ILP=
32__))
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 75b1c950b49f..06be30737b69 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1045,6 +1045,10 @@ int sock_setsockopt(struct socket *sock, int lev=
el, int optname,
> >                 }
> >                 break;
> >
> > +       case SO_DETACH_REUSEPORT_BPF:
> > +               ret =3D reuseport_detach_prog(sk);
> > +               break;
> > +
> >         case SO_DETACH_FILTER:
> >                 ret =3D sk_detach_filter(sk);
> >                 break;
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index dc4aefdf2a08..e0cb29469fa7 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -332,3 +332,27 @@ int reuseport_attach_prog(struct sock *sk, struct =
bpf_prog *prog)
> >         return 0;
> >  }
> >  EXPORT_SYMBOL(reuseport_attach_prog);
> > +
> > +int reuseport_detach_prog(struct sock *sk)
> > +{
> > +       struct sock_reuseport *reuse;
> > +       struct bpf_prog *old_prog;
> > +
> > +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > +               return sk->sk_reuseport ? -ENOENT : -EINVAL;
> > +
> > +       spin_lock_bh(&reuseport_lock);
> > +       reuse =3D rcu_dereference_protected(sk->sk_reuseport_cb,
> > +                                         lockdep_is_held(&reuseport_lo=
ck));
> > +       old_prog =3D rcu_dereference_protected(reuse->prog,
> > +                                            lockdep_is_held(&reuseport=
_lock));
> > +       RCU_INIT_POINTER(reuse->prog, NULL);
> > +       spin_unlock_bh(&reuseport_lock);
> > +
> > +       if (!old_prog)
> > +               return -ENOENT;
> > +
> > +       sk_reuseport_prog_free(old_prog);
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(reuseport_detach_prog);
> > --
> > 2.17.1
> >
