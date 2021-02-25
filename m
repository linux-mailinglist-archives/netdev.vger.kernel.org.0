Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A239325174
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhBYOZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:25:15 -0500
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:32865
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhBYOZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:25:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKNXFMWDcvGeEr4TmlZ4zdOFpKY6mckEBhA5k5lHEAg4tY07273Ubbz9oCq2fdOF58gQu0JJuMNMVE91qDpkpZ30lYZb0XH0/61jNFAISVzwtp0AQCzI0Tvw2IMyj7XfIQWgJvA3Ad/jo+QvZuCmi6ezS0SDqL/62j3/7l6nuM6PZ+a2qz7NZ+aCEQrvZZWeyg7iXDXUFvd+u7s6P3d8qHnfdCPVaw4F3G6en/wKjtdoPwTQa+cb21PAQek6uzlbZC03AORMmvck4nQW/Vh7yQJr5QXn4ipz5WQxGZeNX8nEeTNxZPDSveP27cQQEnSxeojhzwK9wbeXw5qwr8HEWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUoHGqgtelWCZoljcYfPre9P/E4XrR28OLleU+tOo2U=;
 b=fX8K3Zwc99iJvmzvDpTKV30whyDb1OYS9rGFLBU6p95iIatI4Buv9UNoxWveoC5lhDdO3no6q9Y1vDePYXifeFsuotEII66+YFPRuIDfn4B7Fw3qwUYymE2Ab2FylAC2sdYCXPDjBeRkenNG6YRQuYkC9/0D3fOvbkrDZloRW8cQa2+Rb+vXZGAX0RQVoWqc3oIFJCZU1h2CsL7x6p+asVQM4sFnj6Y+wLiVjie1PBBmOEnguNMC9hlIRzej4cZ0N/oy6hLZKiLJWco7QIz170tRIqPzHKaE+9NVV6FXznl4PoG7xz9OenUHS9IgEep/a7hlVM8yYFq5DRHf2Faw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUoHGqgtelWCZoljcYfPre9P/E4XrR28OLleU+tOo2U=;
 b=pRBE3Pe/e5OEIhecfhEXqguZNX9YimYRj0a+AcbakKGgC4zS4wMUnJaPCNIVHtZTkRyA1oWGvQ1rZnZeJPeI1GO+/rjoEpNTAKlcptUBumT8sp+Q6/nzGdsqJ3UKfPsQ/lAGD06GJYZtuFsenMl2zddi9twOw4FOmkcMAWKjESc=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DM6PR05MB4764.namprd05.prod.outlook.com (2603:10b6:5:10::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.17; Thu, 25 Feb 2021 14:24:18 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::6d72:f94:9524:f08]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::6d72:f94:9524:f08%4]) with mapi id 15.20.3805.007; Thu, 25 Feb 2021
 14:24:18 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 02/19] af_vsock: separate wait data loop
Thread-Topic: [RFC PATCH v5 02/19] af_vsock: separate wait data loop
Thread-Index: AQHXBbgT8xYZjtD2jUmP/0PaXiKqaKpo9yOA
Date:   Thu, 25 Feb 2021 14:24:17 +0000
Message-ID: <E5526501-3A87-4349-8D7F-61782AA1F513@vmware.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053637.1066959-1-arseny.krasnov@kaspersky.com>
In-Reply-To: <20210218053637.1066959-1-arseny.krasnov@kaspersky.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kaspersky.com; dkim=none (message not signed)
 header.d=none;kaspersky.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [83.92.5.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 864d0d56-5c6f-4850-3a25-08d8d9990933
x-ms-traffictypediagnostic: DM6PR05MB4764:
x-microsoft-antispam-prvs: <DM6PR05MB4764042A79AF48A244355C0BDA9E9@DM6PR05MB4764.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qVe7cPImi9dEsO3ybzYQoazFtHoFz8b0znBoqPtTiHoCHiDIdz8+oiUNlmHawC0YrDIDIjX9mQMpAkiP3DPatHQqcV/wvXHn0T/ilRNT4nhCWyrCcSqx32oztufxEcNU3smDBTTR6j9WM8bY2S2qSEgh2OfVB2crO8LKkL3f4Sh8IrCpPnRG0XMrPt4mdSCzgoRtktXtZsvzK4PePeIpx0eJUSCTtRdbZZZDlNGc9FWXE+rIhfmqiFkSwqpYbtLlxE5Xh62wzlDnuea26IGSUe4qSoKvydLnQhtNs1ZfEu4X1hw5AGvmuKGYNXgk6UDSOzXRjoZWpbrOtPnk48CgEdcKZCYDvUmhtMVYLhoaxsUotDdfKu3VYXts7R0wr6UjVIaWE/5PUkpGWtZWPb7hSYlpHK0VZC4CtJ8LKimRxgYJLUG/Q1aQXGtzME7o412roLVaJ88jcqtdf/yIUSUPtwB6r4l+iDsTrnH4ZzE3G3FzGuUWDnXoPn9bi/0udaM8oRRI/bWLgcDJk3fkDm+tKW1gwhFL+1aYhJU2ML4NMOHTk6BHOhW7WRy/B+cuO0pZOBfjeZ6uh9WI73FR+UyxDlzwX7keCW0e2vCc/Yp/2Jw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(4326008)(186003)(64756008)(26005)(478600001)(6506007)(53546011)(7416002)(83380400001)(8676002)(2906002)(76116006)(54906003)(6486002)(66476007)(8936002)(91956017)(2616005)(66946007)(316002)(6512007)(36756003)(33656002)(5660300002)(66446008)(6916009)(86362001)(71200400001)(66556008)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?crOnY383uEpgBIDnpMzC1g/f5YZnTjr+nAHZfXCfWpusy6IkqJM/qBaVnP3X?=
 =?us-ascii?Q?UkCX8Y8NmlC5hKoSJ8Yqty7bOFuOYaBfySzNrE2gBiDUGx23fnfX4X8KvABG?=
 =?us-ascii?Q?tr32AmGdnCyoy6KsaXe13ooQSRMa0WJSMC4Y9ko5ZkepbMSmlWJZMXcQZPwI?=
 =?us-ascii?Q?1t60uX/LEruPJN2BdFbuxUL+PNocHM+Y2MqNSkdQlXC4ajz+fT/u2QBTRNRU?=
 =?us-ascii?Q?JmHqIzT4GI9y2msFQVWyi8paEE4C6wIZyQd/Xd5fvG5iDOJgimB2QIWDp64U?=
 =?us-ascii?Q?cnAeFC4UwoX12RL38Ju9+Ox/Rwk8O4EslwjYLGvkIoIeK2X4nwZ1Nueb8TLA?=
 =?us-ascii?Q?f8BoJyMLgMon44mFwbIGFztOAPvjZdHLGNyss9DZVAcoXof26C43j1DOY8go?=
 =?us-ascii?Q?MtESME2OZa5xn/kjozkKhUv9BkY9rD/rZyIF/EZ8ZsrgPLfJkpaFJICtLJas?=
 =?us-ascii?Q?2b+iLbLz/1VvR38v63nO/jyb5+GljgmMomeD5620XVnpfEc9zzlnAK+DOOkl?=
 =?us-ascii?Q?EqiGGN+FMMbQJPkMtdN47GS8IpAIlYYQtgFybaW2/0c7LKE4qUsuUXPe16yL?=
 =?us-ascii?Q?laSUCH69dRngdBAgr+T9DIsr09AnwNb7k7U9P++B/8F7P5Mjw/Ckfmhp/rDJ?=
 =?us-ascii?Q?/QqmLlzuHtLXODdqvgTDJkeppJCOjC+3E/0Bw5Uf71YfQmzwoEDFB88YpU0j?=
 =?us-ascii?Q?l+xAxg8/tcLut0gOIIbCRBCE9iNnfpHgRtfMtktwyFY0om8pa8ZAbTn3pWZB?=
 =?us-ascii?Q?0ineSAucqeAkwxrVaj2ZxSySriVsJQzkjy0AI9lmmlhYLMZ9Wq6Ad8TZEN/X?=
 =?us-ascii?Q?zW411ywK6VfzbKskp5PBfqoeunPEsVlPVo4P0B3ACMl9eIV1umsvk6BcsO1+?=
 =?us-ascii?Q?bgZph9s/7C7Yhs1tk8VHKICP5lhuw198x7plPTQ3F70qPt0Uq2zbLGqo6K9/?=
 =?us-ascii?Q?KS63kVfD2cM4+hK4XABQmuqAxu/NI9BrW92ia9vyPXy0LzsdAVYaezVlYawb?=
 =?us-ascii?Q?kCNwavPnm/v7iaBZ1goHfxMLc/p5PJ3dYWIufoEXBS18C+d0PBaoj3aduxWD?=
 =?us-ascii?Q?8euQ3GGAs8bbCScAWBKwHnAI3OqBKZiLC3KENwSafedYFEpMn+AAG2la8DDj?=
 =?us-ascii?Q?bjAU42YHXYIMke1oHLdQYARZq+wCvWUnBoBXP/rssRkN/4iOHYVqRC5ecBMP?=
 =?us-ascii?Q?BPgKjp/vZVQ2YdPcMXNMPNp91/mc+NYJgu3JGXX794r0k+Qx5Y7oms6abUZ3?=
 =?us-ascii?Q?ff2aAMfEoYks4r7NdVEs3nbK05hTuim4ClMf/ycYtGR/cvgw3aWc7CsXKblB?=
 =?us-ascii?Q?LExuKoYOgZji69a3ZVMfa5as?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2DA3715B3C2C74A87E35C2975B4238E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR05MB3452.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864d0d56-5c6f-4850-3a25-08d8d9990933
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 14:24:17.9071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZnSOm+YiRDzpzUDUhKMVTXqBIhoZuOfLDKxCML+JZOmhu0D2VPdkkBhhJZ2Prs9KMPApMtjv5QADgDIsqeKZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 18 Feb 2021, at 06:36, Arseny Krasnov <arseny.krasnov@kaspersky.com> w=
rote:
>=20
> This moves wait loop for data to dedicated function, because later
> it will be used by SEQPACKET data receive loop.
>=20
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> ---
> net/vmw_vsock/af_vsock.c | 155 +++++++++++++++++++++------------------
> 1 file changed, 83 insertions(+), 72 deletions(-)
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 656370e11707..6cf7bb977aa1 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1832,6 +1832,68 @@ static int vsock_connectible_sendmsg(struct socket=
 *sock, struct msghdr *msg,
> 	return err;
> }
>=20
> +static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wai=
t,
> +			   long timeout,
> +			   struct vsock_transport_recv_notify_data *recv_data,
> +			   size_t target)
> +{
> +	const struct vsock_transport *transport;
> +	struct vsock_sock *vsk;
> +	s64 data;
> +	int err;
> +
> +	vsk =3D vsock_sk(sk);
> +	err =3D 0;
> +	transport =3D vsk->transport;
> +	prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
> +
> +	while ((data =3D vsock_stream_has_data(vsk)) =3D=3D 0) {

In the original code, the prepare_to_wait() is called for each iteration of=
 the while loop. In this
version, it is only called once. So if we do multiple iterations, the threa=
d would be in the
TASK_RUNNING state, and subsequent schedule_timeout() will return immediate=
ly. So
looks like the prepare_to_wait() should be move here, in case we have a spu=
rious wake_up.

> +		if (sk->sk_err !=3D 0 ||
> +		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
> +		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
> +			break;
> +		}
> +
> +		/* Don't wait for non-blocking sockets. */
> +		if (timeout =3D=3D 0) {
> +			err =3D -EAGAIN;
> +			break;
> +		}
> +
> +		if (recv_data) {
> +			err =3D transport->notify_recv_pre_block(vsk, target, recv_data);
> +			if (err < 0)
> +				break;
> +		}
> +
> +		release_sock(sk);
> +		timeout =3D schedule_timeout(timeout);
> +		lock_sock(sk);
> +
> +		if (signal_pending(current)) {
> +			err =3D sock_intr_errno(timeout);
> +			break;
> +		} else if (timeout =3D=3D 0) {
> +			err =3D -EAGAIN;
> +			break;
> +		}
> +	}
> +
> +	finish_wait(sk_sleep(sk), wait);
> +
> +	if (err)
> +		return err;
> +
> +	/* Internal transport error when checking for available
> +	 * data. XXX This should be changed to a connection
> +	 * reset in a later change.
> +	 */
> +	if (data < 0)
> +		return -ENOMEM;
> +
> +	return data;
> +}
> +
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t=
 len,
> 			  int flags)
> @@ -1911,85 +1973,34 @@ vsock_connectible_recvmsg(struct socket *sock, st=
ruct msghdr *msg, size_t len,
>=20
>=20
> 	while (1) {
> -		s64 ready;
> -
> -		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> -		ready =3D vsock_stream_has_data(vsk);
> -
> -		if (ready =3D=3D 0) {
> -			if (sk->sk_err !=3D 0 ||
> -			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
> -			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
> -				finish_wait(sk_sleep(sk), &wait);
> -				break;
> -			}
> -			/* Don't wait for non-blocking sockets. */
> -			if (timeout =3D=3D 0) {
> -				err =3D -EAGAIN;
> -				finish_wait(sk_sleep(sk), &wait);
> -				break;
> -			}
> +		ssize_t read;
>=20
> -			err =3D transport->notify_recv_pre_block(
> -					vsk, target, &recv_data);
> -			if (err < 0) {
> -				finish_wait(sk_sleep(sk), &wait);
> -				break;
> -			}
> -			release_sock(sk);
> -			timeout =3D schedule_timeout(timeout);
> -			lock_sock(sk);
> +		err =3D vsock_wait_data(sk, &wait, timeout, &recv_data, target);
> +		if (err <=3D 0)
> +			break;
>=20
> -			if (signal_pending(current)) {
> -				err =3D sock_intr_errno(timeout);
> -				finish_wait(sk_sleep(sk), &wait);
> -				break;
> -			} else if (timeout =3D=3D 0) {
> -				err =3D -EAGAIN;
> -				finish_wait(sk_sleep(sk), &wait);
> -				break;
> -			}
> -		} else {
> -			ssize_t read;
> -
> -			finish_wait(sk_sleep(sk), &wait);
> -
> -			if (ready < 0) {
> -				/* Invalid queue pair content. XXX This should
> -				* be changed to a connection reset in a later
> -				* change.
> -				*/
> -
> -				err =3D -ENOMEM;
> -				goto out;
> -			}
> -
> -			err =3D transport->notify_recv_pre_dequeue(
> -					vsk, target, &recv_data);
> -			if (err < 0)
> -				break;
> +		err =3D transport->notify_recv_pre_dequeue(vsk, target,
> +							 &recv_data);
> +		if (err < 0)
> +			break;
>=20
> -			read =3D transport->stream_dequeue(
> -					vsk, msg,
> -					len - copied, flags);
> -			if (read < 0) {
> -				err =3D -ENOMEM;
> -				break;
> -			}
> +		read =3D transport->stream_dequeue(vsk, msg, len - copied, flags);
> +		if (read < 0) {
> +			err =3D -ENOMEM;
> +			break;
> +		}
>=20
> -			copied +=3D read;
> +		copied +=3D read;
>=20
> -			err =3D transport->notify_recv_post_dequeue(
> -					vsk, target, read,
> -					!(flags & MSG_PEEK), &recv_data);
> -			if (err < 0)
> -				goto out;
> +		err =3D transport->notify_recv_post_dequeue(vsk, target, read,
> +						!(flags & MSG_PEEK), &recv_data);
> +		if (err < 0)
> +			goto out;
>=20
> -			if (read >=3D target || flags & MSG_PEEK)
> -				break;
> +		if (read >=3D target || flags & MSG_PEEK)
> +			break;
>=20
> -			target -=3D read;
> -		}
> +		target -=3D read;
> 	}
>=20
> 	if (sk->sk_err)
> --=20
> 2.25.1
>=20

