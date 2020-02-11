Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8A9158C27
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgBKJyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:54:11 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:55523
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728020AbgBKJyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 04:54:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsYNxvIzSUFiyF83pwb4m785XdRbMXWXowmG/ZVreeWtHYmdfaYqWG+mw9brV6OS/J18rCVdAJYLxfLzqwivk3M8efqzIl3/ymWVZlkBLq34sxwf+ho2nrFuFsj87XF10n/FmLLUhbHdvfOvgLhHex186TSsPJAdcfqmXzUYmHONtd8JQ01++RYGBaRbGFZAywLszpUHhCqv14mNo2uFv5J6V08uVTVHz1IPB/mtYRp3XSlWuBKH5MwXWx1ZHFZpAs6X43xKm8elQwN5pvuNF2CPC6g3s0n/kR9Z8GG8TjBOZ9P07dOsn8bqabCE2HwfGkFdRihNeK/Gw+zuz/QDTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxsFyuSYFN6ARU4xdVgmKePHxDX7VfzbrTRH6KSahyQ=;
 b=W9VGJEFgChSAutUf7v0Fc8igkbSBBGnOPR0uOWFB41vYipP8IUqF+x8Mtw/er3OLgqIP5BlgbIzMqwqtaLqjBk2jALCJZ2/Mbdh+oEZuLvlX6Z/CuzZXXJiQoT/9gTNiRwKJxVRCbQ9PVRXVLujQpRzlqiS6ous3vVcufYiqvd3D6FSWeXFqbHKUkwxBGiHVn31L49CQWqJ4uTTkSj/UgBRhHdg3QZiv81Yk8UVbIHWYAGu5IFS6ZlVDEEqzkhK9PVdbyZd1F9SJiKz18nbkOeVnk9ibfui0K+KLTifD5vhARXoy0ANx+e00GIB1FYcL/NlNzaP00U352FaL9MsgWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxsFyuSYFN6ARU4xdVgmKePHxDX7VfzbrTRH6KSahyQ=;
 b=UYGdKqu7ffndDuZTmk/1Rfbz0dm7eMNBe7D+QOLmg022ZLkEZWm2AfnxgrFh9+6fzFbTohHWNnCed+IDFT7gWFyVSAOmWU7l3N3s8M9OyN44XNGLsMk28Bi1eL6uaCNzqI2qBL18SDMCN8YS7Z0Ki1g6ZbF/R8xiOwD6sJ/JtCo=
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (10.168.126.17) by
 HE1PR0501MB2300.eurprd05.prod.outlook.com (10.168.29.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 09:53:54 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2707.030; Tue, 11 Feb
 2020 09:53:54 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "rgoodfel@isi.edu" <rgoodfel@isi.edu>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: RE: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finished
Thread-Topic: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finished
Thread-Index: AQHV4CaXGckPhJY83Ua+L52EU3+kYKgVwXrg
Date:   Tue, 11 Feb 2020 09:53:44 +0000
Deferred-Delivery: Tue, 11 Feb 2020 09:53:40 +0000
Message-ID: <HE1PR0501MB2570A5C385E2EA5A79CC1700D1180@HE1PR0501MB2570.eurprd05.prod.outlook.com>
References: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-originating-ip: [77.75.144.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9885e4ab-d73d-4ed7-edce-08d7aed84e7f
x-ms-traffictypediagnostic: HE1PR0501MB2300:
x-microsoft-antispam-prvs: <HE1PR0501MB2300B6578F2A0725B9ABD360D1180@HE1PR0501MB2300.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(478600001)(316002)(53546011)(4326008)(2906002)(71200400001)(6506007)(54906003)(52536014)(86362001)(6666004)(8676002)(76116006)(7696005)(66476007)(5660300002)(6916009)(66446008)(26005)(8936002)(64756008)(66556008)(66946007)(33656002)(81166006)(55016002)(9686003)(186003)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2300;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y2KCBrDEIpOiLEJvsVgam5JhIXE1TGydeJzUf1OeBwN1iY9gshNsFwe/wRqWdJfHrZsuArumD1RjFniAePnm3dxfKt5l+JbvGN/kCjMxq7wEvi7l/1Xw5ETlwJQHA76Cw9wb6aL+DNjrE9fpYzAupHF0NTUCqWmp7JDvj+s7yWhMiWus8IZ5IEmx3AI1nyNyjr013xl7ekGCw7xMhnkHVjHZ+f+zY/eWrPkc2WOnczEI7x7EKmBjs7DUwjKCpNySn1MxwX6E1SjdmALjAIFetxif54kGYhwd6jLsXVuIh+l4ao4G+WBvHYX9Y0UZdemcfGl23ZdfX97EPsFhaSRjjVQo7BIMCS+RmosCrHCFGwg1GRQRrrGHjpBo6ykx+kQd162Qb3cCKELACazCoO/997slGV7hWQrxUAwQ25glcAiphukkf+KgM3JBkBa1lL4S
x-ms-exchange-antispam-messagedata: BktyRGjB7ggzcdxAM6JC22BLMvif4RyILJ9gXbwlOAb9YiahRFUNNK23AI2/MVMl5Bd+/FkAPwv7ure4rwg9RUGIMsKyYWMMFzz1KqJvH57cX01IU/j5tJJn4cPnShPy2cFO4zyuIWJCnrn96a6eqg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9885e4ab-d73d-4ed7-edce-08d7aed84e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 09:53:54.8070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGKyfN4tx4qpgbFIyjcm7wVtVmOfxr04Ee+sULY2NpkmTOZ8tZwJfksTZV4vun5d+EGIy5nWy/c1SzfSw8fTiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-10 17:27, Magnus Karlsson wrote:
> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> introduced a much more lazy way of updating the global consumer
> pointers from the kernel side, by only doing so when running out of
> entries in the fill or Tx rings (the rings consumed by the
> kernel). This can result in a deadlock with the user application if
> the kernel requires more than one entry to proceed and the application
> cannot put these entries in the fill ring because the kernel has not
> updated the global consumer pointer since the ring is not empty.
>=20
> Fix this by publishing the local kernel side consumer pointer whenever
> we have completed Rx or Tx processing in the kernel. This way, user
> space will have an up-to-date view of the consumer pointers whenever it
> gets to execute in the one core case (application and driver on the
> same core), or after a certain number of packets have been processed
> in the two core case (application and driver on different cores).
>=20
> A side effect of this patch is that the one core case gets better
> performance, but the two core case gets worse. The reason that the one
> core case improves is that updating the global consumer pointer is
> relatively cheap since the application by definition is not running
> when the kernel is (they are on the same core) and it is beneficial
> for the application, once it gets to run, to have pointers that are
> as up to date as possible since it then can operate on more packets
> and buffers. In the two core case, the most important performance
> aspect is to minimize the number of accesses to the global pointers
> since they are shared between two cores and bounces between the caches
> of those cores. This patch results in more updates to global state,
> which means lower performance in the two core case.
>=20
> Fixes: 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
> Reported-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>

> ---
>   net/xdp/xsk.c       | 2 ++
>   net/xdp/xsk_queue.h | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index df60048..356f90e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -217,6 +217,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_bu=
ff *xdp)
>   static void xsk_flush(struct xdp_sock *xs)
>   {
>   	xskq_prod_submit(xs->rx);
> +	__xskq_cons_release(xs->umem->fq);
>   	sock_def_readable(&xs->sk);
>   }
>  =20
> @@ -304,6 +305,7 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem)
>  =20
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
> +		__xskq_cons_release(xs->tx);
>   		xs->sk.sk_write_space(&xs->sk);
>   	}
>   	rcu_read_unlock();
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index bec2af1..89a01ac 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -271,7 +271,8 @@ static inline void xskq_cons_release(struct xsk_queue=
 *q)
>   {
>   	/* To improve performance, only update local state here.
>   	 * Reflect this to global state when we get new entries
> -	 * from the ring in xskq_cons_get_entries().
> +	 * from the ring in xskq_cons_get_entries() and whenever
> +	 * Rx or Tx processing are completed in the NAPI loop.
>   	 */
>   	q->cached_cons++;
>   }
>
