Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3711BA0E
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfLKRVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:21:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64106 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730816AbfLKRVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:21:23 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBBHLFxE018618;
        Wed, 11 Dec 2019 09:21:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=L0QFZ6QGn/JYTPMLwRGYeHGFazPfR2PMEe665HoDoTU=;
 b=ImL+tsWSH3D5plvWzt5dlPDiwaUip4z62bGkoHLksviC+TjwCjByc0b2qcfxwQOjsrYe
 PxhbJ/HjUYvscmdgPQ5Bj8lC/xXX/BnvWjK8H0Kuf10hMARj+PDH6Ku+fiftfnePu/0o
 IdOI91fANs8wKpTCt2gNMJaW0A++UovDwAY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wtpnekeer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 09:21:16 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 09:20:56 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 09:20:56 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 09:20:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhUrzZHHIAPLua1K5XAziljh+y+c6qbxmglDu++Mer12CQP9YgyBK0PHnNnQH7H34LOsV/9R6A0iA4F93128qcHvwzJW1UyDZ1gT6rYYUluLbAvIXRJO7w7RQ3K/KpIikYiam5U2uHFQvLNn7uZKjLXi1WO53t+KSmeUk7X1UN1yH9u10/0RiCG3luG1pHlF3E9W6d9Wyf9USDkJTjbHOvW041KTNu126DtclonCuqG4GXCqMY5plkvlg2AA0FG4DgVbwNizSbx3nZGQap2/lSd+ZWNh/PjnIS3v7lVNZ8RUd1l0oI5oO5iH25LcSIf42EnZHL/BBYlwrlPgZkV3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0QFZ6QGn/JYTPMLwRGYeHGFazPfR2PMEe665HoDoTU=;
 b=ZPMYeQymIXTTqzDiFMCN8ljvjOMldl5a1FSJ8wfHJQoMqT+sUT3rgMYzuBSmuovJciNND8mcHCX5AfpaRDVP9nDpMWF8rSvszRIjVi0JLpCc72ZozDmtFc0TdIv5g5sJH4Q6mSnzb4WFqsZGfqfNP9hzhUBqSTCQZaIQ5zUAPDnBQzhWE/aeg36mIX4UEf4b1OkOYJ/xY7R2y20eSmMQhMWKy1fouvOyvfIZSCFaZPJ2WmcDq+cCJZ58RWFSB4/dT5c3POb6NGUskDSmHeazS15f6urDrczu76Wt5nfem6eTQmTKT1Lw9F1E+aka8LmfqDUve/x7pJ7G03iIPINWsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0QFZ6QGn/JYTPMLwRGYeHGFazPfR2PMEe665HoDoTU=;
 b=dJd4ZB2Gpw+NrJL7mSKXwJuiI3GGZA/9ZhfzlSqV/gc23sGsgkifzvex5G+QRQYvZC5X3iYhqYeX2S0tKc2Z0YWEAESLVEoTfrSOuxrl6hjjHff8U2CoU0MMcSvS+zNs5gWNHq7qRXyXRNk3/NohLiDhsqQd+ijmn5mUjnCye24=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3277.namprd15.prod.outlook.com (20.179.23.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 17:20:54 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 17:20:54 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Thread-Topic: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket
 inherit psock or its ops on copy
Thread-Index: AQHVoe5KSzr7pEIvm0S4q82BeKmlVKecflSAgAEhZoCAABbdgIAAFkmAgBXAO4CAAb20gA==
Date:   Wed, 11 Dec 2019 17:20:54 +0000
Message-ID: <20191211172051.clnwh5n5vdeovayy@kafai-mbp>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
 <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com>
 <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
 <87d0deo57q.fsf@cloudflare.com> <87sglsfdda.fsf@cloudflare.com>
In-Reply-To: <87sglsfdda.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0034.namprd11.prod.outlook.com
 (2603:10b6:300:115::20) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad6e3d6f-6d99-4ef8-56e2-08d77e5e7a86
x-ms-traffictypediagnostic: MN2PR15MB3277:
x-microsoft-antispam-prvs: <MN2PR15MB3277F971DDCF5272C67586FAD55A0@MN2PR15MB3277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(66946007)(52116002)(64756008)(5660300002)(66556008)(66476007)(966005)(478600001)(81166006)(66446008)(54906003)(316002)(6486002)(6916009)(81156014)(6512007)(86362001)(8936002)(4326008)(2906002)(1076003)(33716001)(9686003)(186003)(53546011)(71200400001)(8676002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3277;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RaXIwyIg9/DRi6uDJxlFWWx7EcpjbSme2XMxaUzZQmtzECZlfMPl1SuULHAn92yYg1zLukPKBn+YkH9xKfn7udTXkD0WZQF7TTY7e4xZCjFsdmfmKZsgC8AQZuNJoERiSIN6ScRjJ9joCKsU87S/gXPxMClLvnE230clg4+PK4BUwvr3Wuzd41OQp68tfeadSL/Ql2ftsHhnjQMYDgChk7bg4ClyeiYorja3ytIb6j/NrGXETbjJgijE0ytjy4K64XLGAp9BQ2nqBXwARCmkUMpMCD0gcQ6PIVp7Fc4hZhMHdgifqIcypRlWq4co1+E01P0ZyZ4euQiSJg2NFbih5fz/tjxvZwlC3GPTgIiDWVGOO2jHHfWlAT4lKJC+++b36nkhkKeNBHIiLB78TExW2INpgaPKUbA9HeFVelluwtW5F4XWPD0mt5P6UdJ4ek1H/utaKyb/zDsP2vtFDiTgGMWZBvMBw81IWqCDXWiGRKs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9AC28D39CA56E48A4F7FA249BC1DBF6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6e3d6f-6d99-4ef8-56e2-08d77e5e7a86
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 17:20:54.5773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vUIgR7sEeUnPdPPFEAQ7Bb+zj1SIbUP9Id/aEIiZQAHJAghYzI05UKP4TeZFXnxs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_05:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 03:45:37PM +0100, Jakub Sitnicki wrote:
> John, Martin,
>=20
> On Tue, Nov 26, 2019 at 07:36 PM CET, Jakub Sitnicki wrote:
> > On Tue, Nov 26, 2019 at 06:16 PM CET, Martin Lau wrote:
> >> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
> >>> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
> >>> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
> >>> > [ ... ]
> >>> >
> >>> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(str=
uct sock *sk,
> >>> >>  			sk->sk_prot =3D psock->sk_proto;
> >>> >>  		psock->sk_proto =3D NULL;
> >>> >>  	}
> >>> >> +
> >>> >> +	if (psock->icsk_af_ops) {
> >>> >> +		icsk->icsk_af_ops =3D psock->icsk_af_ops;
> >>> >> +		psock->icsk_af_ops =3D NULL;
> >>> >> +	}
> >>> >>  }
> >>> >
> >>> > [ ... ]
> >>> >
> >>> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
> >>> >> +					  struct sk_buff *skb,
> >>> >> +					  struct request_sock *req,
> >>> >> +					  struct dst_entry *dst,
> >>> >> +					  struct request_sock *req_unhash,
> >>> >> +					  bool *own_req)
> >>> >> +{
> >>> >> +	const struct inet_connection_sock_af_ops *ops;
> >>> >> +	void (*write_space)(struct sock *sk);
> >>> >> +	struct sk_psock *psock;
> >>> >> +	struct proto *proto;
> >>> >> +	struct sock *child;
> >>> >> +
> >>> >> +	rcu_read_lock();
> >>> >> +	psock =3D sk_psock(sk);
> >>> >> +	if (likely(psock)) {
> >>> >> +		proto =3D psock->sk_proto;
> >>> >> +		write_space =3D psock->saved_write_space;
> >>> >> +		ops =3D psock->icsk_af_ops;
> >>> > It is not immediately clear to me what ensure
> >>> > ops is not NULL here.
> >>> >
> >>> > It is likely I missed something.  A short comment would
> >>> > be very useful here.
> >>>
> >>> I can see the readability problem. Looking at it now, perhaps it shou=
ld
> >>> be rewritten, to the same effect, as:
> >>>
> >>> static struct sock *tcp_bpf_syn_recv_sock(...)
> >>> {
> >>> 	const struct inet_connection_sock_af_ops *ops =3D NULL;
> >>>         ...
> >>>
> >>>         rcu_read_lock();
> >>> 	psock =3D sk_psock(sk);
> >>> 	if (likely(psock)) {
> >>> 		proto =3D psock->sk_proto;
> >>> 		write_space =3D psock->saved_write_space;
> >>> 		ops =3D psock->icsk_af_ops;
> >>> 	}
> >>> 	rcu_read_unlock();
> >>>
> >>>         if (!ops)
> >>> 		ops =3D inet_csk(sk)->icsk_af_ops;
> >>>         child =3D ops->syn_recv_sock(sk, skb, req, dst, req_unhash, o=
wn_req);
> >>>
> >>> If psock->icsk_af_ops were NULL, it would mean we haven't initialized=
 it
> >>> properly. To double check what happens here:
> >> I did not mean the init path.  The init path is fine since it init
> >> eveything on psock before publishing the sk to the sock_map.
> >>
> >> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not=
 clear
> >> to me what prevent the earlier pasted sk_psock_restore_proto() which s=
ets
> >> psock->icsk_af_ops to NULL from running in parallel with
> >> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
> >
> > Ah, I misunderstood. Nothing prevents the race, AFAIK.
> >
> > Setting psock->icsk_af_ops to null on restore and not checking for it
> > here was a bad move on my side.  Also I need to revisit what to do abou=
t
> > psock->sk_proto so the child socket doesn't end up with null sk_proto.
> >
> > This race should be easy enough to trigger. Will give it a shot.
>=20
> I've convinced myself that this approach is racy beyond repair.
>=20
> Once syn_recv_sock() has returned it is too late to reset the child
> sk_user_data and restore its callbacks. It has been already inserted
> into ehash and ingress path can invoke its callbacks.
>=20
> The race can be triggered with with a reproducer where:
>=20
> thread-1:
>=20
>         p =3D accept(s, ...);
>         close(p);
>=20
> thread-2:
>=20
> 	bpf_map_update_elem(mapfd, &key, &s, BPF_NOEXIST);
> 	bpf_map_delete_elem(mapfd, &key);
>=20
> This a dead-end because we can't have the parent and the child share the
> psock state. Even though psock itself is refcounted, and potentially we
> could grab a reference before cloning the parent, link into the map that
> psock holds is not.
>=20
> Two ways out come to mind. Both involve touching TCP code, which I was
> hoping to avoid:
>=20
> 1) reset sk_user_data when initializing the child
>=20
>    This is problematic because tcp_bpf callbacks are not designed to
>    handle sockets with no psock _and_ with overridden sk_prot
>    callbacks. (Although, I think they could if the fallback was directly
>    on {tcp,tcpv6}_prot based on socket domain.)
>=20
>    Also, there are other sk_user_data users like DRBD which rely on
>    sharing the sk_user_data pointer between parent and child, if I read
>    the code correctly [0]. If anything, clearing the sk_user_data on
>    clone would have to be guarded by a flag.
Can the copy/not-to-copy sk_user_data decision be made in
sk_clone_lock()?

>=20
> 2) Restore sk_prot callbacks on clone to {tcp,tcpv6}_prot
>=20
>    The simpler way out. tcp_bpf callbacks never get invoked on the child
>    socket so the copied psock reference is no longer a problem. We can
>    clear the pointer on accept().
>=20
>    So far I wasn't able poke any holes in it and it comes down to
>    patching tcp_create_openreq_child() with:
>=20
> 	/* sk_msg and ULP frameworks can override the callbacks into
> 	 * protocol. We don't assume they are intended to be inherited
> 	 * by the child. Frameworks can re-install the callbacks on
> 	 * accept() if needed.
> 	 */
> 	WRITE_ONCE(newsk->sk_prot, sk->sk_prot_creator);
>=20
>    That's what I'm going with for v2.
>=20
> Open to suggestions.
>=20
> Thanks,
> Jakub
>=20
> BTW. Reading into kTLS code, I noticed it has been limited down to just
> established sockets due to the same problem I'm struggling with here:
>=20
> static int tls_init(struct sock *sk)
> {
> ...
> 	/* The TLS ulp is currently supported only for TCP sockets
> 	 * in ESTABLISHED state.
> 	 * Supporting sockets in LISTEN state will require us
> 	 * to modify the accept implementation to clone rather then
> 	 * share the ulp context.
> 	 */
> 	if (sk->sk_state !=3D TCP_ESTABLISHED)
> 		return -ENOTCONN;
>=20
> [0] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__elixir.bootlin=
.com_linux_v5.5-2Drc1_source_drivers_block_drbd_drbd-5Freceiver.c-23L682&d=
=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DVQnoQ7LvghIj0gVEaiQSUw&m=3Dz2Cz1gE=
cqiw-8YqVOluxlUHh_CBs6PJWQN2vgirOyFk&s=3DWAiM0asZN0OkqrW02xm2mCMIzWhKQCc3Ki=
Y7pzMKNg4&e=3D=20
