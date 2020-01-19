Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C20141CA8
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 07:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgASG4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 01:56:45 -0500
Received: from mail-eopbgr40063.outbound.protection.outlook.com ([40.107.4.63]:37860
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbgASG4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 01:56:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VY/+VBeByxm2hkVD+wtSa/6u+rUYVEMTx+m72IZjE35iF+tphvx5Nst+25ClfFmLS5fdalGVsKU1TCkjJnYrngmIaUiXhbsQmBUxBO9q+MtEReQky2dst8dq5pxbNM2Llsn/k/NUSrJU6prGNZp1Ml30sXMtiFkLi9n5FSy83kGcu68abmuT+tKBQSlLSJJxnE2KcX/6RZsya94Xi9bG7bLJWl4oSFSOlIaHgQaBtGB3pFcaBWSS5nk/n31W4UNv+gQSi9lj3lnAgn4KTejCoQOxWMVcpnDYhiixEbf9ysfEfz9drQU8gvWcdtyoM9NxO0uOD8hOxo3rLb/VOoA2xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34dK9SXUSwy9EbPm/GkcFgHquaZLRRrXkABo7YAeOck=;
 b=C6F23V13psoW45YVqJj0ywe/1Yd1VYebg7XT2nyH6Ev63bpgX01df0tjIZu9A5TTafm8eFxHB9L7Hgu8qZ3mtonSgFP/30I+XnfkEQURXUtfTZi07FaSdPYaT5IPhZDvymVepOJiPb2UifdvxnMt0vYZBnCKkFyINRVJEPzbdlyhfn0hLlLGUVZV9CRK9thqNDdh0gO4hpo93h6Mt0blzb+KGBkrNtKJr3p1ciLMy417FI5lBQw1jN4LhGGUTugrIZvwdfguVHNkhLgijabfycX2yFMe2h+aOqd0WBEu2vzG7Wmks5bIinzlbqI2jgsikEUJsCJYVqdHFXzVIGRMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34dK9SXUSwy9EbPm/GkcFgHquaZLRRrXkABo7YAeOck=;
 b=FA+ETKV8eE8umMAu4hQWDXM/Xt5Y1fEP5zf0ohUSfZdB+ydTDWyTXOG49WrbhCk2VaG7vdTcJZQfQLJprS3Hakx65fSrqPdD2vOLWsbghAeOoMrwMeQYRRRpG04mzrAluXopRVE0qoUm2BYQr9/mw5pmZysUBO1JZTeVTfXrIXM=
Received: from DB6SPR01MB07.eurprd03.prod.outlook.com (10.175.241.152) by
 VI1PR03MB3150.eurprd03.prod.outlook.com (10.165.191.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Sun, 19 Jan 2020 06:56:39 +0000
Received: from DB6SPR01MB07.eurprd03.prod.outlook.com
 ([fe80::8c11:6d77:4b77:63bb]) by DB6SPR01MB07.eurprd03.prod.outlook.com
 ([fe80::8c11:6d77:4b77:63bb%2]) with mapi id 15.20.2644.024; Sun, 19 Jan 2020
 06:56:39 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Subject: Re: [PATCH net] net: sched: act_ctinfo: fix memory leak
Thread-Topic: [PATCH net] net: sched: act_ctinfo: fix memory leak
Thread-Index: AQHVzoM8gitGxgukb0CjJy18o4R45KfxjimA
Date:   Sun, 19 Jan 2020 06:56:38 +0000
Message-ID: <6723D225-64A7-49F8-9FE3-8C4D0A74C7AA@darbyshire-bryant.me.uk>
References: <20200119044506.209726-1-edumazet@google.com>
In-Reply-To: <20200119044506.209726-1-edumazet@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cc7c94b-d3cc-47d3-e496-08d79cacbb82
x-ms-traffictypediagnostic: VI1PR03MB3150:
x-microsoft-antispam-prvs: <VI1PR03MB3150AC37E0D29136B4AB7CAFC9330@VI1PR03MB3150.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:216;
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39830400003)(34036004)(366004)(346002)(448600002)(189003)(199004)(2906002)(6916009)(8936002)(2616005)(186003)(66476007)(66556008)(64756008)(66446008)(66616009)(586005)(66946007)(81166006)(5660300002)(8676002)(6486002)(76116006)(91956017)(81156014)(38610400001)(6512007)(53546011)(71200400001)(86362001)(6506007)(54906003)(36756003)(4326008)(33656002)(102460200005)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB3150;H:DB6SPR01MB07.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RzWtKpaIifgwY/8dZQB8Hav9POV8WI6b5UkgFdFC7cMK2CykSWSghhMfrMPw46NlQQbvu9A3ZH9Ej9+G0ThheXa57sBGscHvTtDWGp6IWZZdLJxgnBnia7fvgiTxeJo0JWqqZepRRoLSbs+hBvkjbwE9fnU4MtjKHPU+C8mBd7N3QyojafZwqkNvt+iUput4T9mT7ZBxWiKN1/E7to2uOEbD+2J1FntO1cbauHtipJMHTt8kQ0TXMHUtNrmt4VpdaOBUQ337qGOAVG2DWaNI3wCUjeNEMPnWiMWPI5WnVDIhmssHHVtqA/WrOKfHM539t8ZHz/mumDl/L8wq+DzvCcNNiOezPcZhumFbsvLSDxn7ghdf4taXQo8aSwNVghLhv2grTt3RvdaflO4B3/xCTTRAplNFwwrsEbIqe3hA8YfAQBkUv72qgcg4OGaP8cPLpScRb7HLWoE+QuALJ63yjghqs5+FJCtERuBbzhqtbzCtw1AWKKZ1JDe+Gqx1X0+wE+45dCRgRbLwGIezrr/8ogfLUTlPSUXdDLex8CNqY4g=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        boundary="Apple-Mail=_E6DDF078-5D96-46BC-8BCD-C4544AD80C19";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc7c94b-d3cc-47d3-e496-08d79cacbb82
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2020 06:56:38.8930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Hrb/4IZl+PJJZISroOItXSeh4p1O9RYg3cCgWR/qeKMuG3xWp2/Na775X0Ei4PyqBpiOQ32tRrKfzDdh312i4mdG3q7Z3xZJPIKCINJJKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_E6DDF078-5D96-46BC-8BCD-C4544AD80C19
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 19 Jan 2020, at 04:45, Eric Dumazet <edumazet@google.com> wrote:
>=20
> Implement a cleanup method to properly free ci->params
>=20
> BUG: memory leak
> unreferenced object 0xffff88811746e2c0 (size 64):
>  comm "syz-executor617", pid 7106, jiffies 4294943055 (age 14.250s)
>  hex dump (first 32 bytes):
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    c0 34 60 84 ff ff ff ff 00 00 00 00 00 00 00 00  .4`.............
>  backtrace:
>    [<0000000015aa236f>] kmemleak_alloc_recursive =
include/linux/kmemleak.h:43 [inline]
>    [<0000000015aa236f>] slab_post_alloc_hook mm/slab.h:586 [inline]
>    [<0000000015aa236f>] slab_alloc mm/slab.c:3320 [inline]
>    [<0000000015aa236f>] kmem_cache_alloc_trace+0x145/0x2c0 =
mm/slab.c:3549
>    [<000000002c946bd1>] kmalloc include/linux/slab.h:556 [inline]
>    [<000000002c946bd1>] kzalloc include/linux/slab.h:670 [inline]
>    [<000000002c946bd1>] tcf_ctinfo_init+0x21a/0x530 =
net/sched/act_ctinfo.c:236
>    [<0000000086952cca>] tcf_action_init_1+0x400/0x5b0 =
net/sched/act_api.c:944
>    [<000000005ab29bf8>] tcf_action_init+0x135/0x1c0 =
net/sched/act_api.c:1000
>    [<00000000392f56f9>] tcf_action_add+0x9a/0x200 =
net/sched/act_api.c:1410
>    [<0000000088f3c5dd>] tc_ctl_action+0x14d/0x1bb =
net/sched/act_api.c:1465
>    [<000000006b39d986>] rtnetlink_rcv_msg+0x178/0x4b0 =
net/core/rtnetlink.c:5424
>    [<00000000fd6ecace>] netlink_rcv_skb+0x61/0x170 =
net/netlink/af_netlink.c:2477
>    [<0000000047493d02>] rtnetlink_rcv+0x1d/0x30 =
net/core/rtnetlink.c:5442
>    [<00000000bdcf8286>] netlink_unicast_kernel =
net/netlink/af_netlink.c:1302 [inline]
>    [<00000000bdcf8286>] netlink_unicast+0x223/0x310 =
net/netlink/af_netlink.c:1328
>    [<00000000fc5b92d9>] netlink_sendmsg+0x2c0/0x570 =
net/netlink/af_netlink.c:1917
>    [<00000000da84d076>] sock_sendmsg_nosec net/socket.c:639 [inline]
>    [<00000000da84d076>] sock_sendmsg+0x54/0x70 net/socket.c:659
>    [<0000000042fb2eee>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
>    [<000000008f23f67e>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
>    [<00000000d838e4f6>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
>    [<00000000289a9cb1>] __do_sys_sendmsg net/socket.c:2426 [inline]
>    [<00000000289a9cb1>] __se_sys_sendmsg net/socket.c:2424 [inline]
>    [<00000000289a9cb1>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424
>=20
> Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
> net/sched/act_ctinfo.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>=20
> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
> index =
40038c321b4a970dc940714ccda4b39f0d261d6a..19649623493b158b3008c82ce2409ae8=
0ffa6dc6 100644
> --- a/net/sched/act_ctinfo.c
> +++ b/net/sched/act_ctinfo.c
> @@ -360,6 +360,16 @@ static int tcf_ctinfo_search(struct net *net, =
struct tc_action **a, u32 index)
> 	return tcf_idr_search(tn, a, index);
> }
>=20
> +static void tcf_ctinfo_cleanup(struct tc_action *a)
> +{
> +	struct tcf_ctinfo *ci =3D to_ctinfo(a);
> +	struct tcf_ctinfo_params *cp;
> +
> +	cp =3D rcu_dereference_protected(ci->params, 1);
> +	if (cp)
> +		kfree_rcu(cp, rcu);
> +}
> +
> static struct tc_action_ops act_ctinfo_ops =3D {
> 	.kind	=3D "ctinfo",
> 	.id	=3D TCA_ID_CTINFO,
> @@ -367,6 +377,7 @@ static struct tc_action_ops act_ctinfo_ops =3D {
> 	.act	=3D tcf_ctinfo_act,
> 	.dump	=3D tcf_ctinfo_dump,
> 	.init	=3D tcf_ctinfo_init,
> +	.cleanup=3D tcf_ctinfo_cleanup,
> 	.walk	=3D tcf_ctinfo_walker,
> 	.lookup	=3D tcf_ctinfo_search,
> 	.size	=3D sizeof(struct tcf_ctinfo),
> --
> 2.25.0.341.g760bfbb309-goog
>=20

Oh wow & oops!  Thanks for fixing that.

Acked-by: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_E6DDF078-5D96-46BC-8BCD-C4544AD80C19
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl4j/aUACgkQs6I4m53i
M0o+3w//SqQYrVT186awr5wftoP9ylnF957YLS+LBv3Ynzkp4x3wDajG42RxKbNT
2CYId6sWtmk7n7NX7BWQcrACMwdjsn4ZYLZKhIQGX7MkDniWxNo0KoAhGnS0Qa6/
GahT7/Bl3LC/JqTMchgLfq0H/6DZdCC/cq+5hQhk+V5R7bsqo78ylLHc+XSmIFSg
Hrooum8Blw5n7u9J83SsObrFopw7ZclEH0gWfoqUSalWmtJXU1UxAFN7exZGRgUO
sC08aX/9BXcEjYgLs3HtxtuKxByvTXzfbUcFxU+DZZMVo+P3ylq5LlwKEZLisLK/
rWBxsAtthjhxW0J0WKTkXEXRAp4m5mDCD7FHoPy0I2njiXIf9XGXFJFOKvx0RvWg
8qKunflFeAJd0D5iCCx7cgv17OmpzA/S+S70dilcKCjuD1XS5ehxoTSIUHAun9Z1
/q3jvqdESZFXyK0MkuOk6II+BWHE/Z2ezM01Bz7zlIhWSnwhrb9XFmzPhc5kP3+X
sE3vuQZ6MaZAp7I4jaMD7FUclNXPb42ibOMdN7aC1hLH7xDUp3Uogy0ASBs/S18k
GxC22xZU99s67QHE91JWE7B74p1ziFKYiBgrhgTyRRWxE6n7oFtJ7ZzdA4OGJEg7
v3GbShczfcl+ifWAGTmrTvqcGijd81faeSZ+eNRuVi67k8npF7c=
=AIDD
-----END PGP SIGNATURE-----

--Apple-Mail=_E6DDF078-5D96-46BC-8BCD-C4544AD80C19--
