Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5A611D700
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfLLTYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:24:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43598 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730416AbfLLTYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:24:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCJK3WY015045;
        Thu, 12 Dec 2019 11:24:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=owOFYDLILPaIpkC7CF/JtxA6Y2/rK6V8ODt1ArJ/oAQ=;
 b=iqT8ucATtvCFbHx7E6fCP4tMAOjh9wfwIZeS8HVF1uPdc3HrVAhOmR5AkLfuxOhJJ7zo
 ZoiPQjQQFHPJzSlvHIoYi4kAoJnUXYBD01zedKIT88UKJvjGRvJ5rVrPV9KR7uyjPlow
 sorsyA2C2ZulPi7sPsGJUFKAatwzcreKlkk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wub46c7fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 11:24:02 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 12 Dec 2019 11:24:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Dec 2019 11:24:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo3nTbGBcuEWw9ioOSJbGqkHxMxIts3oT6erhIwG1fS/o6+6tKelPOGAlujPS1v8U2eOig1SvyTOlzJh6vLZkYW56fhqJEjMJubHB6wstO9/29+8A6dKLP4ZOJnEaLdjO3mK/9gIbuiK3unYYsSH8SCvl1lWXDB02+oOxWsRgV6e93Fv7nx+/c6Ls+gOklQB+d4O1f9yYR+JTZ4PxVo/QCa0l5hIHqjv81kAAarK1n24CEx96DMQbkGIGVWOyaRz58CR2QlwtiFIzZFA2W1PbH5EqlniKs0QYOxQr0+gCgJlV5r2ujxrgKVMgGlVHNc4dUUoudg8JBEOpHzIrVtrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owOFYDLILPaIpkC7CF/JtxA6Y2/rK6V8ODt1ArJ/oAQ=;
 b=gbEjI8s5BGVddZrhPz6onJtf5qwAlZ0UjN0Wl2edWxu+DSTeOp9mJTDiH4hmAZkdKkw1l2Y0m5tYYQynm6KJkwFILfZuPvvMQBnun3stuIGVMaCN2xs3Bxh4q8+CTM0CZc/iolHC82Hb2mZIwhvQY7hHdgKpaYtNcJwPYi4fjva020jC00OyPBhSdnXKb665jEKwxt+QPGmVkOTwRTheqCUUHvFsiVM9dRT7SUUSuMg3ddh65N8IFvHsiFXf2WXqpUIc4VCU1zjnCLlRjJnCL4yJl6TZ9ijo54YVD2JQzVxgOYflFMFStRun6O0SXoSx0H/m8fPte8HOiWRW6LhG7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owOFYDLILPaIpkC7CF/JtxA6Y2/rK6V8ODt1ArJ/oAQ=;
 b=YSM0RDDABnfHzUghGa76YqncEq8ZkS6/2BDvILa0XZE/JLwnjMi6GnOT5mG1cdBwpj3t8aQESHzlqjgsAMbsQ0uuYH0ME551u6RssKyIAH1yioqzm6F2F1l9j4kRSikSTVy99cAIdPixP1uhpjw4A2Y0R0bl4NwCkgIztUCKi/s=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3471.namprd15.prod.outlook.com (20.178.255.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 12 Dec 2019 19:23:59 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 19:23:59 +0000
From:   Martin Lau <kafai@fb.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Thread-Topic: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket
 inherit psock or its ops on copy
Thread-Index: AQHVoe5KSzr7pEIvm0S4q82BeKmlVKecflSAgAEhZoCAABbdgIAAFkmAgBXAO4CAAb20gIABL46AgACFKAA=
Date:   Thu, 12 Dec 2019 19:23:58 +0000
Message-ID: <20191212192354.umerwea5z4fpwbkq@kafai-mbp>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
 <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com>
 <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
 <87d0deo57q.fsf@cloudflare.com> <87sglsfdda.fsf@cloudflare.com>
 <20191211172051.clnwh5n5vdeovayy@kafai-mbp> <87pngtg4x4.fsf@cloudflare.com>
In-Reply-To: <87pngtg4x4.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0048.namprd21.prod.outlook.com
 (2603:10b6:300:129::34) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::97ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cebc8992-06fa-4a19-ad2a-08d77f38d661
x-ms-traffictypediagnostic: MN2PR15MB3471:
x-microsoft-antispam-prvs: <MN2PR15MB34711DF7A9961D37F690E27BD5550@MN2PR15MB3471.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(199004)(189003)(109986005)(6486002)(33716001)(66556008)(66476007)(64756008)(66446008)(186003)(53546011)(81156014)(1076003)(4326008)(66946007)(81166006)(71200400001)(86362001)(8936002)(52116002)(6506007)(5660300002)(478600001)(966005)(54906003)(9686003)(6512007)(316002)(2906002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3471;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KyZ6X5pS8HWpbd9IGurFtfmz6QPfip1Z8Omap0lgqnaxuj9GRBaLOtmkRI513yz+IaOG/4lAk959VPWDr9bI9/+TYJCN/wOzxZ6nVw5TVlgNVeXoepoZcXy5bbwcoqrekiWBksbgxAn3XMmnX9ZQpTTtQB4INsJ3MLpua258aIFDlB+3bfOVQ3Nv142KmuN5gtmi1gYxoku6UdQGnSOkLdo9NVoGa8ATPapNDvCJR92OmWsRSClqH8VGFYeVfC/tPgZFc4ZP4gMptkFe0l5Z267cqdrIJuuWLrOzIa7+QXy4uSi/qyAfeHMjuxozpAraWcxBcK2/26m5HugwIwXvoc7A66CYMmN6pnhsAjKReTiPJCa3S2hZWF5+BLq5F0qpNyo0XPSx6ShNzJR90yCz5qijfPPcrUBBT/X+MMx4rd5aw4xOSLhgtrkuvFTkGZW1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58B6ED0BDB6A494691ACC0D5E1C30886@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cebc8992-06fa-4a19-ad2a-08d77f38d661
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 19:23:58.9845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXT8HKjBgi6pIZHAGRFh3IxtXUB9caftGawJOX2kyeuIMZTmjqz7oWIWssaKa8ik
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3471
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_06:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120148
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 12:27:19PM +0100, Jakub Sitnicki wrote:
> On Wed, Dec 11, 2019 at 06:20 PM CET, Martin Lau wrote:
> > On Tue, Dec 10, 2019 at 03:45:37PM +0100, Jakub Sitnicki wrote:
> >> John, Martin,
> >>
> >> On Tue, Nov 26, 2019 at 07:36 PM CET, Jakub Sitnicki wrote:
> >> > On Tue, Nov 26, 2019 at 06:16 PM CET, Martin Lau wrote:
> >> >> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
> >> >>> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
> >> >>> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
> >> >>> > [ ... ]
> >> >>> >
> >> >>> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(=
struct sock *sk,
> >> >>> >>  			sk->sk_prot =3D psock->sk_proto;
> >> >>> >>  		psock->sk_proto =3D NULL;
> >> >>> >>  	}
> >> >>> >> +
> >> >>> >> +	if (psock->icsk_af_ops) {
> >> >>> >> +		icsk->icsk_af_ops =3D psock->icsk_af_ops;
> >> >>> >> +		psock->icsk_af_ops =3D NULL;
> >> >>> >> +	}
> >> >>> >>  }
> >> >>> >
> >> >>> > [ ... ]
> >> >>> >
> >> >>> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *s=
k,
> >> >>> >> +					  struct sk_buff *skb,
> >> >>> >> +					  struct request_sock *req,
> >> >>> >> +					  struct dst_entry *dst,
> >> >>> >> +					  struct request_sock *req_unhash,
> >> >>> >> +					  bool *own_req)
> >> >>> >> +{
> >> >>> >> +	const struct inet_connection_sock_af_ops *ops;
> >> >>> >> +	void (*write_space)(struct sock *sk);
> >> >>> >> +	struct sk_psock *psock;
> >> >>> >> +	struct proto *proto;
> >> >>> >> +	struct sock *child;
> >> >>> >> +
> >> >>> >> +	rcu_read_lock();
> >> >>> >> +	psock =3D sk_psock(sk);
> >> >>> >> +	if (likely(psock)) {
> >> >>> >> +		proto =3D psock->sk_proto;
> >> >>> >> +		write_space =3D psock->saved_write_space;
> >> >>> >> +		ops =3D psock->icsk_af_ops;
> >> >>> > It is not immediately clear to me what ensure
> >> >>> > ops is not NULL here.
> >> >>> >
> >> >>> > It is likely I missed something.  A short comment would
> >> >>> > be very useful here.
> >> >>>
> >> >>> I can see the readability problem. Looking at it now, perhaps it s=
hould
> >> >>> be rewritten, to the same effect, as:
> >> >>>
> >> >>> static struct sock *tcp_bpf_syn_recv_sock(...)
> >> >>> {
> >> >>> 	const struct inet_connection_sock_af_ops *ops =3D NULL;
> >> >>>         ...
> >> >>>
> >> >>>         rcu_read_lock();
> >> >>> 	psock =3D sk_psock(sk);
> >> >>> 	if (likely(psock)) {
> >> >>> 		proto =3D psock->sk_proto;
> >> >>> 		write_space =3D psock->saved_write_space;
> >> >>> 		ops =3D psock->icsk_af_ops;
> >> >>> 	}
> >> >>> 	rcu_read_unlock();
> >> >>>
> >> >>>         if (!ops)
> >> >>> 		ops =3D inet_csk(sk)->icsk_af_ops;
> >> >>>         child =3D ops->syn_recv_sock(sk, skb, req, dst, req_unhash=
, own_req);
> >> >>>
> >> >>> If psock->icsk_af_ops were NULL, it would mean we haven't initiali=
zed it
> >> >>> properly. To double check what happens here:
> >> >> I did not mean the init path.  The init path is fine since it init
> >> >> eveything on psock before publishing the sk to the sock_map.
> >> >>
> >> >> I was thinking the delete path (e.g. sock_map_delete_elem).  It is =
not clear
> >> >> to me what prevent the earlier pasted sk_psock_restore_proto() whic=
h sets
> >> >> psock->icsk_af_ops to NULL from running in parallel with
> >> >> tcp_bpf_syn_recv_sock()?  An explanation would be useful.
> >> >
> >> > Ah, I misunderstood. Nothing prevents the race, AFAIK.
> >> >
> >> > Setting psock->icsk_af_ops to null on restore and not checking for i=
t
> >> > here was a bad move on my side.  Also I need to revisit what to do a=
bout
> >> > psock->sk_proto so the child socket doesn't end up with null sk_prot=
o.
> >> >
> >> > This race should be easy enough to trigger. Will give it a shot.
> >>
> >> I've convinced myself that this approach is racy beyond repair.
> >>
> >> Once syn_recv_sock() has returned it is too late to reset the child
> >> sk_user_data and restore its callbacks. It has been already inserted
> >> into ehash and ingress path can invoke its callbacks.
> >>
> >> The race can be triggered with with a reproducer where:
> >>
> >> thread-1:
> >>
> >>         p =3D accept(s, ...);
> >>         close(p);
> >>
> >> thread-2:
> >>
> >> 	bpf_map_update_elem(mapfd, &key, &s, BPF_NOEXIST);
> >> 	bpf_map_delete_elem(mapfd, &key);
> >>
> >> This a dead-end because we can't have the parent and the child share t=
he
> >> psock state. Even though psock itself is refcounted, and potentially w=
e
> >> could grab a reference before cloning the parent, link into the map th=
at
> >> psock holds is not.
> >>
> >> Two ways out come to mind. Both involve touching TCP code, which I was
> >> hoping to avoid:
> >>
> >> 1) reset sk_user_data when initializing the child
> >>
> >>    This is problematic because tcp_bpf callbacks are not designed to
> >>    handle sockets with no psock _and_ with overridden sk_prot
> >>    callbacks. (Although, I think they could if the fallback was direct=
ly
> >>    on {tcp,tcpv6}_prot based on socket domain.)
> >>
> >>    Also, there are other sk_user_data users like DRBD which rely on
> >>    sharing the sk_user_data pointer between parent and child, if I rea=
d
> >>    the code correctly [0]. If anything, clearing the sk_user_data on
> >>    clone would have to be guarded by a flag.
> > Can the copy/not-to-copy sk_user_data decision be made in
> > sk_clone_lock()?
>=20
> Yes, this could be pushed down to sk_clone_lock(), where we do similar
> work (reset sk_reuseport_cb and clone bpf_sk_storage):
aha.  I missed your eariler "clearing the sk_user_data on clone would have
to be guarded by a flag..." part.  It turns out we were talking the same
thing on (1).  sock_flag works better if there is still bit left (and it
seems there is one),  although I was thinking more like adding
something (e.g. a func ptr) to 'struct proto' to mangle sk_user_data
before returning newsk....but not sure this kind of logic
belongs to 'struct proto'

>=20
> 	/* User data can hold reference. Child must not
> 	 * inherit the pointer without acquiring a reference.
> 	 */
> 	if (sock_flag(sk, SOCK_OWNS_USER_DATA)) {
> 		sock_reset_flag(newsk, SOCK_OWNS_USER_DATA);
> 		RCU_INIT_POINTER(newsk->sk_user_data, NULL);
> 	}
>=20
> I belive this would still need to be guarded by a flag.  Do you see
> value in clearing child sk_user_data on clone as opposed to dealying
> that work until accept() time?
It seems to me clearing things up front at the very beginning is more
straight forward, such that it does not have to worry about the
sk_user_data may be used in a wrong way before it gets a chance
to be cleared in accept().

Just something to consider, if it is obvious that there is no hole in
clearing it in accept(), it is fine too.

> >>
> >> 2) Restore sk_prot callbacks on clone to {tcp,tcpv6}_prot
> >>
> >>    The simpler way out. tcp_bpf callbacks never get invoked on the chi=
ld
> >>    socket so the copied psock reference is no longer a problem. We can
> >>    clear the pointer on accept().
> >>
> >>    So far I wasn't able poke any holes in it and it comes down to
> >>    patching tcp_create_openreq_child() with:
> >>
> >> 	/* sk_msg and ULP frameworks can override the callbacks into
> >> 	 * protocol. We don't assume they are intended to be inherited
> >> 	 * by the child. Frameworks can re-install the callbacks on
> >> 	 * accept() if needed.
> >> 	 */
> >> 	WRITE_ONCE(newsk->sk_prot, sk->sk_prot_creator);
> >>
> >>    That's what I'm going with for v2.
> >>
> >> Open to suggestions.
> >>
> >> Thanks,
> >> Jakub
> >>
> >> BTW. Reading into kTLS code, I noticed it has been limited down to jus=
t
> >> established sockets due to the same problem I'm struggling with here:
> >>
> >> static int tls_init(struct sock *sk)
> >> {
> >> ...
> >> 	/* The TLS ulp is currently supported only for TCP sockets
> >> 	 * in ESTABLISHED state.
> >> 	 * Supporting sockets in LISTEN state will require us
> >> 	 * to modify the accept implementation to clone rather then
> >> 	 * share the ulp context.
> >> 	 */
> >> 	if (sk->sk_state !=3D TCP_ESTABLISHED)
> >> 		return -ENOTCONN;
> >>
> >> [0] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__elixir.boot=
lin.com_linux_v5.5-2Drc1_source_drivers_block_drbd_drbd-5Freceiver.c-23L682=
&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DVQnoQ7LvghIj0gVEaiQSUw&m=3Dz2Cz1=
gEcqiw-8YqVOluxlUHh_CBs6PJWQN2vgirOyFk&s=3DWAiM0asZN0OkqrW02xm2mCMIzWhKQCc3=
KiY7pzMKNg4&e=3D
