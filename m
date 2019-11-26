Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30E610A33D
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbfKZRRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:17:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48510 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727532AbfKZRRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:17:32 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQHHQUi031843;
        Tue, 26 Nov 2019 09:17:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/DBIoq70DOoCU2xwyaFe2esHupuRXFmiudqT+wIZAVY=;
 b=qrzLrIbgwSOxOCs09CNfqRm5riQfc3mMZQZr7xGhYkPdj6TuXi9Syo9I8gnjkKSU7hLo
 XGyDiLkJqQNhUUellciIQuwpTuYZMHw6xkgoKGFGr15afIjCQ0kmcsQDODn2Dvo8g3Qf
 DTTO001PKEjW/I7XD+CI7wOacykpJC3ZZA0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wgqgv4q07-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Nov 2019 09:17:29 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Nov 2019 09:16:50 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 09:16:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XasOXsgFEuXjvzY4BVP7orVuagREacvXieqkMLgqN2FuVk/y5xjGz/68m5bhJ2c2h5/iehNL+rvzhoGXuj1Tm/qks/E1uK3DKbd8T26bJuFQYP/ZQRv7qJ2bFmQ5Mz9Ui63+I598qTkifaWHZUJRKmzu6G7BdGvuCQSryh+fbH+hoBCEELHPrf1cJr9SABOseIqecd3suivWssNYqdKUVIlsUZnCZykKi2sDGGU7kQwtmPYldfMt3mkawTal400PB8ZlC2n6UyqKGuehqazZ3Ap8hSK0fcZ8I2bPTPi5nn5Xk9bqsuAQszop6ImQgqIuvGhDOwKSxIgAi9tXGaVr1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DBIoq70DOoCU2xwyaFe2esHupuRXFmiudqT+wIZAVY=;
 b=VqVhvfU9F+oYw7xlrWCYnp/ZFuTOJz+T7u1HBioi2yNq1xKCG2kz1FjLZNuvzc7P/cOE47DT9JdyKHkwsWZlMWX+pL3G4A29nqQeHBJv4Y2h3GfD/RpOPetkAyZa90aQ+5TWi8kuUtgXROxzt5iWNMdS38vnG8BXWEQW7P1+loruMuksrSJFDxHMz7jPumEmJQdajPbXKoWEkZ4IHOnccHuCeGI4SL7VdtsiNdjhBo9ovzW49WQ8iZZefdStlloWN4gkbYA/EEhE7XgdiAmp2YNeqYDolB2cdeCo+cnoRqnJexDgVrO8ons2fq3HAgu28j1rbfkWjuGDNxEye0AFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DBIoq70DOoCU2xwyaFe2esHupuRXFmiudqT+wIZAVY=;
 b=SVQ44NhVrACj301gOLkbYnY+N7+/EBZWDEJfIQOhLh/LFSKyhoHVL2vcZqbjLeE23JFTxlgCy0QEravhayERyQwhM/h09EnLrnxsuIhCG7tVdvaLGLw6Cr6+Y5SArwH/I9i5+HPxIPWM5GM4V3iy+Q2eUX7l/55UYuZFjpVuCNI=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3389.namprd15.prod.outlook.com (20.179.21.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Tue, 26 Nov 2019 17:16:29 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 17:16:29 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Thread-Topic: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket
 inherit psock or its ops on copy
Thread-Index: AQHVoe5KSzr7pEIvm0S4q82BeKmlVKecflSAgAEhZoCAABbdgA==
Date:   Tue, 26 Nov 2019 17:16:29 +0000
Message-ID: <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
 <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com>
In-Reply-To: <87ftiaocp2.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:de8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebeb2183-7444-4bf0-a176-08d772946036
x-ms-traffictypediagnostic: MN2PR15MB3389:
x-microsoft-antispam-prvs: <MN2PR15MB3389A07B3BE5FF4BBE2AAF32D5450@MN2PR15MB3389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(51914003)(189003)(199004)(8676002)(66556008)(54906003)(71190400001)(46003)(64756008)(6506007)(6916009)(256004)(7736002)(498600001)(102836004)(86362001)(186003)(52116002)(305945005)(25786009)(6512007)(9686003)(6246003)(4326008)(53546011)(76176011)(66446008)(66476007)(6116002)(2906002)(386003)(5660300002)(81166006)(81156014)(66946007)(8936002)(14454004)(6436002)(1076003)(11346002)(229853002)(446003)(99286004)(6486002)(14444005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3389;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KnQrDhoH2xp6dd2Aakr5JPDRbYmCxG1n0jhxB9lvvX+KyxQC5xinl0ztJlQ8uyzPs304J1pqnXH28b8xCRby6LvBUbPgULamxC7ZDElHt/qBWWTjm5p0tCPPAJFJMEOreQOMhjy1muCw6LLrvSz9MdYywnAWHrzkEVYArsxC+MHpASqT4oJMUTD/lTWvBm2BKf7adU00k4YsX49eNHUXUS6dJ6Q6oAtQOS7peVZVmY9A2nJ0Mb/HWEsSjDHgRQuMKTgUKc1/O0GZvN9tHfhw5jVx1HgbNVlgoRt4Ej1+D4nOsitQxSMdL1TqQ7fDaAjAr8YxaD/63ra3tagwGiXuvPTyE27dfbsFkAwaFz7N1oWJmkCsVnQZ3EdknwQtXTOAfP9OxHdAPwzcdTBu7R27ZgT+UqrsxMdFUPVKvkCq8FiBYAITOegG8panRWWpQYC+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <360E70EBD08C954782EA63DAFCF02F24@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ebeb2183-7444-4bf0-a176-08d772946036
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 17:16:29.2652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T5m26kWkChcJXp2KOaN4dTKZOLA+79wnq5meXPzq7EXYe9JhCnm97zkxolB2TZGd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_05:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=940 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
> > [ ... ]
> >
> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct =
sock *sk,
> >>  			sk->sk_prot =3D psock->sk_proto;
> >>  		psock->sk_proto =3D NULL;
> >>  	}
> >> +
> >> +	if (psock->icsk_af_ops) {
> >> +		icsk->icsk_af_ops =3D psock->icsk_af_ops;
> >> +		psock->icsk_af_ops =3D NULL;
> >> +	}
> >>  }
> >
> > [ ... ]
> >
> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
> >> +					  struct sk_buff *skb,
> >> +					  struct request_sock *req,
> >> +					  struct dst_entry *dst,
> >> +					  struct request_sock *req_unhash,
> >> +					  bool *own_req)
> >> +{
> >> +	const struct inet_connection_sock_af_ops *ops;
> >> +	void (*write_space)(struct sock *sk);
> >> +	struct sk_psock *psock;
> >> +	struct proto *proto;
> >> +	struct sock *child;
> >> +
> >> +	rcu_read_lock();
> >> +	psock =3D sk_psock(sk);
> >> +	if (likely(psock)) {
> >> +		proto =3D psock->sk_proto;
> >> +		write_space =3D psock->saved_write_space;
> >> +		ops =3D psock->icsk_af_ops;
> > It is not immediately clear to me what ensure
> > ops is not NULL here.
> >
> > It is likely I missed something.  A short comment would
> > be very useful here.
>=20
> I can see the readability problem. Looking at it now, perhaps it should
> be rewritten, to the same effect, as:
>=20
> static struct sock *tcp_bpf_syn_recv_sock(...)
> {
> 	const struct inet_connection_sock_af_ops *ops =3D NULL;
>         ...
>=20
>         rcu_read_lock();
> 	psock =3D sk_psock(sk);
> 	if (likely(psock)) {
> 		proto =3D psock->sk_proto;
> 		write_space =3D psock->saved_write_space;
> 		ops =3D psock->icsk_af_ops;
> 	}
> 	rcu_read_unlock();
>=20
>         if (!ops)
> 		ops =3D inet_csk(sk)->icsk_af_ops;
>         child =3D ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_r=
eq);
>=20
> If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
> properly. To double check what happens here:
I did not mean the init path.  The init path is fine since it init
eveything on psock before publishing the sk to the sock_map.

I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clea=
r
to me what prevent the earlier pasted sk_psock_restore_proto() which sets
psock->icsk_af_ops to NULL from running in parallel with
tcp_bpf_syn_recv_sock()?  An explanation would be useful.

>=20
> In sock_map_link we do a setup dance where we first create the psock and
> later initialize the socket callbacks (tcp_bpf_init).
>=20
> static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *prog=
s,
> 			 struct sock *sk)
> {
>         ...
> 	if (psock) {
>                 ...
> 	} else {
> 		psock =3D sk_psock_init(sk, map->numa_node);
> 		if (!psock) {
> 			ret =3D -ENOMEM;
> 			goto out_progs;
> 		}
> 		sk_psock_is_new =3D true;
> 	}
>         ...
>         if (sk_psock_is_new) {
> 		ret =3D tcp_bpf_init(sk);
> 		if (ret < 0)
> 			goto out_drop;
> 	} else {
> 		tcp_bpf_reinit(sk);
> 	}
>=20
> The "if (sk_psock_new)" branch triggers the call chain that leads to
> saving & overriding socket callbacks.
>=20
> tcp_bpf_init -> tcp_bpf_update_sk_prot -> sk_psock_update_proto
>=20
> Among them, icsk_af_ops.
>=20
> static inline void sk_psock_update_proto(...)
> {
>         ...
> 	psock->icsk_af_ops =3D icsk->icsk_af_ops;
> 	icsk->icsk_af_ops =3D af_ops;
> }
>=20
> Goes without saying that a comment is needed.
>=20
> Thanks for the feedback,
> Jakub
