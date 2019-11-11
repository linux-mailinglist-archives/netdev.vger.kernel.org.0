Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E061F75A8
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfKKNxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:53:45 -0500
Received: from mail-eopbgr700084.outbound.protection.outlook.com ([40.107.70.84]:16352
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727466AbfKKNxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 08:53:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzbshyI2eJRLfinOx5oHDPIjmvqwYEuJS68DupfsqFW1V5/DA3vKhJs5whlmhHl1Be2PlwZ8wTJdu3WDZUbKFw28XvVQwBFfWPrvZZpl3lSHBKig0RM0vmvFd82imVrmTKTDBMu2Ss+mhHGG8HrxVnG/2XAPUbK36+6t51W8vhS73vWu/XoWyUL3nHcpkOnEQAj51uTbDV3+fXcd9/QW7QBwRVYy76HcpsbaUCoCoxotPXx7ckbyf/VehDAYALG+FXknKT+xDFy6uDGtqB1UWIkUTW/glsrCG+nv4nh7wnYTAcBzoEDGdyzksnkQlKXX8IdFVm75C3E+G0o6sVza1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyCueV73ssuYrOL2KOR092G62eXmGC+F1KvMfilPD18=;
 b=A1gsFjYM8Bg6oJ8C+q3k3GqClFKkJFWRd/aLHDimGaHn5j3aUcdqRCNtzcsL4Nt0PPSf9kbWLZfwD7TNJrGwoxdD0IjhqCephkwkn5mjevLPolby9A8e8QA9KtzAKWggqDmG3yp03lkpz2caR5ztipLYs7FBo9BT2eavMYmmDCs9CZ87d1d8A1GhNBcXsJTwBM3M/6NCgJvlkbQHgn4wJMYfbifXA1fUjGNePjDwZLU8xeXB4o26TnmihqpJY+QRz6ugiizxRr5XHOl7fVUM9XA25MliOyx+nVvSMqFABzNf9aGnc9lsbutjd30h6xvS7RTs/V1Km5Ngi2F+8j45ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyCueV73ssuYrOL2KOR092G62eXmGC+F1KvMfilPD18=;
 b=SE9tYWthcUekQDUSLfIoc3RK+HDEL4NYN2rLcfsmoV6h1WnJ0C+AbUwTCXCGaRUobG63viaw0zF1P3Npw9OIQE5JKWe/J2u9ZpjCDSRvwqfRmmpjJQvg7ksQXKV9SrcWGQAo2pDpLpNTqH9dHXdidnJwV457SIwgtbg/Lb/uAyA=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3407.namprd05.prod.outlook.com (10.174.175.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.19; Mon, 11 Nov 2019 13:53:39 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2451.018; Mon, 11 Nov 2019
 13:53:39 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Topic: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Index: AQHViYhm3+s3qIN1EEmJgzgCfyvFAqeGCo7Q
Date:   Mon, 11 Nov 2019 13:53:39 +0000
Message-ID: <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-12-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6a45ce2-9b09-4398-d5cc-08d766ae8e4b
x-ms-traffictypediagnostic: MWHPR05MB3407:
x-microsoft-antispam-prvs: <MWHPR05MB340797E6760B34904E25A4F4DA740@MWHPR05MB3407.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(199004)(189003)(8936002)(81156014)(8676002)(81166006)(2501003)(2906002)(66946007)(25786009)(110136005)(54906003)(66476007)(76116006)(316002)(66556008)(64756008)(66446008)(3846002)(6116002)(86362001)(99286004)(5660300002)(71200400001)(7416002)(14444005)(446003)(6506007)(11346002)(52536014)(76176011)(256004)(478600001)(55016002)(6246003)(7696005)(486006)(26005)(33656002)(476003)(186003)(71190400001)(66066001)(74316002)(7736002)(102836004)(14454004)(4326008)(6436002)(305945005)(229853002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3407;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1oOHCT0+3DRBsaAil9pJHUaI8tg0YNDArr6c7xCxM83Ez9Yz7YcoG2/zUrTevao1dsCzPEVi8KHiCpjFOUqblyFjgy1XLX8KKbV3oOPbq5sNg3MKIGcSEZb4CZGaions2uN3z6+6WnYppNHBcdULAofACPfC01CQIbZiDx+wfcJMjpkH/mr9Sv5co/zFbjwCIeJFmKjwmrGD6yRsdKk9B1J7OV6mTkOcm+lK4QYMqVAwOmPf7Ze4T1cCaYrzGPA2K7w1IIon4dKbo8wTnIpEGOzKViU8GQtpn2w5pmMY6hFZ+zqxDfx7BjDpAKxSM2O9SdMbg4TXakdzsMDIAd1URHFmHpPhG0XpYAjsAhrA2P6ZwHScI2r4AtHiHM8t4FS7ufNIVhH6RUPLd52Swe5Y1ONXcxV/SWoaTU6hjb7YoujPA4EI61f2fFMCUnPSFTsK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a45ce2-9b09-4398-d5cc-08d766ae8e4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 13:53:39.2222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qq6X0HBh3xwheDUiN6iz/33VrmnxS1Yqlw4p6veudJF+DeL2HvIYu07KHuZYSG8mLCF+KJcD9x7jPVYWBgYXlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM

Thanks a lot for working on this!

> With the multi-transports support, we can use vsock with nested VMs (usin=
g
> also different hypervisors) loading both guest->host and
> host->guest transports at the same time.
>=20
> Major changes:
> - vsock core module can be loaded regardless of the transports
> - vsock_core_init() and vsock_core_exit() are renamed to
>   vsock_core_register() and vsock_core_unregister()
> - vsock_core_register() has a feature parameter (H2G, G2H, DGRAM)
>   to identify which directions the transport can handle and if it's
>   support DGRAM (only vmci)
> - each stream socket is assigned to a transport when the remote CID
>   is set (during the connect() or when we receive a connection request
>   on a listener socket).

How about allowing the transport to be set during bind as well? That
would allow an application to ensure that it is using a specific transport,
i.e., if it binds to the host CID, it will use H2G, and if it binds to some=
thing
else it will use G2H? You can still use VMADDR_CID_ANY if you want to
initially listen to both transports.


>   The remote CID is used to decide which transport to use:
>   - remote CID > VMADDR_CID_HOST will use host->guest transport
>   - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> - listener sockets are not bound to any transports since no transport
>   operations are done on it. In this way we can create a listener
>   socket, also if the transports are not loaded or with VMADDR_CID_ANY
>   to listen on all transports.
> - DGRAM sockets are handled as before, since only the vmci_transport
>   provides this feature.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> RFC -> v1:
> - documented VSOCK_TRANSPORT_F_* flags
> - fixed vsock_assign_transport() when the socket is already assigned
>   (e.g connection failed)
> - moved features outside of struct vsock_transport, and used as
>   parameter of vsock_core_register()
> ---
>  drivers/vhost/vsock.c                   |   5 +-
>  include/net/af_vsock.h                  |  17 +-
>  net/vmw_vsock/af_vsock.c                | 237 ++++++++++++++++++------
>  net/vmw_vsock/hyperv_transport.c        |  26 ++-
>  net/vmw_vsock/virtio_transport.c        |   7 +-
>  net/vmw_vsock/virtio_transport_common.c |  28 ++-
>  net/vmw_vsock/vmci_transport.c          |  31 +++-
>  7 files changed, 270 insertions(+), 81 deletions(-)
>=20


> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> d89381166028..dddd85d9a147 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -130,7 +130,12 @@ static struct proto vsock_proto =3D {  #define
> VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)  #define
> VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
>=20
> -static const struct vsock_transport *transport_single;
> +/* Transport used for host->guest communication */ static const struct
> +vsock_transport *transport_h2g;
> +/* Transport used for guest->host communication */ static const struct
> +vsock_transport *transport_g2h;
> +/* Transport used for DGRAM communication */ static const struct
> +vsock_transport *transport_dgram;
>  static DEFINE_MUTEX(vsock_register_mutex);
>=20
>  /**** UTILS ****/
> @@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *vsk)
>  	return __vsock_bind(sk, &local_addr);
>  }
>=20
> -static int __init vsock_init_tables(void)
> +static void vsock_init_tables(void)
>  {
>  	int i;
>=20
> @@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
>=20
>  	for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
>  		INIT_LIST_HEAD(&vsock_connected_table[i]);
> -	return 0;
>  }
>=20
>  static void __vsock_insert_bound(struct list_head *list, @@ -376,6 +380,=
62
> @@ void vsock_enqueue_accept(struct sock *listener, struct sock
> *connected)  }  EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
>=20
> +/* Assign a transport to a socket and call the .init transport callback.
> + *
> + * Note: for stream socket this must be called when vsk->remote_addr is
> +set
> + * (e.g. during the connect() or when a connection request on a
> +listener
> + * socket is received).
> + * The vsk->remote_addr is used to decide which transport to use:
> + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> + *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport  */
> +int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock
> +*psk) {
> +	const struct vsock_transport *new_transport;
> +	struct sock *sk =3D sk_vsock(vsk);
> +
> +	switch (sk->sk_type) {
> +	case SOCK_DGRAM:
> +		new_transport =3D transport_dgram;
> +		break;
> +	case SOCK_STREAM:
> +		if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> +			new_transport =3D transport_h2g;
> +		else
> +			new_transport =3D transport_g2h;
> +		break;

You already mentioned that you are working on a fix for loopback
here for the guest, but presumably a host could also do loopback.
If we select transport during bind to a specific CID, this comment
Isn't relevant, but otherwise, we should look at the local addr as
well, since a socket with local addr of host CID shouldn't use
the guest to host transport, and a socket with local addr > host CID
shouldn't use host to guest.


> +	default:
> +		return -ESOCKTNOSUPPORT;
> +	}
> +
> +	if (vsk->transport) {
> +		if (vsk->transport =3D=3D new_transport)
> +			return 0;
> +
> +		vsk->transport->release(vsk);
> +		vsk->transport->destruct(vsk);
> +	}
> +
> +	if (!new_transport)
> +		return -ENODEV;
> +
> +	vsk->transport =3D new_transport;
> +
> +	return vsk->transport->init(vsk, psk); }
> +EXPORT_SYMBOL_GPL(vsock_assign_transport);
> +
> +static bool vsock_find_cid(unsigned int cid) {
> +	if (transport_g2h && cid =3D=3D transport_g2h->get_local_cid())
> +		return true;
> +
> +	if (transport_h2g && cid =3D=3D VMADDR_CID_HOST)
> +		return true;
> +
> +	return false;
> +}
> +
>  static struct sock *vsock_dequeue_accept(struct sock *listener)  {
>  	struct vsock_sock *vlistener;


> diff --git a/net/vmw_vsock/vmci_transport.c
> b/net/vmw_vsock/vmci_transport.c index 5955238ffc13..2eb3f16d53e7
> 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c

> @@ -1017,6 +1018,15 @@ static int vmci_transport_recv_listen(struct sock
> *sk,
>  	vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
>  			pkt->src_port);
>=20
> +	err =3D vsock_assign_transport(vpending, vsock_sk(sk));
> +	/* Transport assigned (looking at remote_addr) must be the same
> +	 * where we received the request.
> +	 */
> +	if (err || !vmci_check_transport(vpending)) {

We need to send a reset on error, i.e.,
  vmci_transport_send_reset(sk, pkt);

> +		sock_put(pending);
> +		return err;
> +	}
> +
>  	/* If the proposed size fits within our min/max, accept it. Otherwise
>  	 * propose our own size.
>  	 */

Thanks,
Jorgen
