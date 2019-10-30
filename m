Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF1E9E19
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfJ3O54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:57:56 -0400
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:26436
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfJ3O54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 10:57:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA/0klbKcjwu9cZ3XjWpcRLxquPvnwBPZr2WjPeW+sGRJmumOPb2TM+y+fg+KgDtHmG54E00CaDssmagyHtwkBBvOx9SPME9zqVYBMUGMaJXvP/QLhO77bWkhK4MRonVAEOAH12fEG7OrxM4f1nGG8Rm5SY5/AcuHc7eUPYbuq69w7zXXATOqY47w5ApZNYWfKFSmE1wEbufQBorDoaejdOGs3iu2BNdOgvofmq4WqexRH/TK6a78s0tzGAZmSmNmRQOWcYPL5jqTf5mmHBq/1ji6kd4MtLYd6ZiVVm61fSPJ4Lx0Vw2HUa+mrIEhUrAtl+EdZytoeYppW0TJx+LYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojWlPwOfpcZPbtnj74IIxza15rdFmiCBno6SZ7TATBg=;
 b=UXfIyBNv8maG55oGqUllROVpXJJrTKkHUJBxigzL3GJtNIEzS2tvZvkR2YGaW6SsU0MIVC9Af1lyZnew19vtq34uAgSPxxUDJtYCegbtYQhvO0nM9CKOnSPmfA5Uzop9/3psVT8aR0mIW6lQkr6MTJ2O5O6wieVnXd5sE/9dc5jJqdImhYd7YZ+x80BM1W6YRfT4MU7HCBDsgyxmO9JEUMSo+QFzJ3r9adHuFcouIlVS+hjrgH0woqVSs8nn1XPQBZOAbdAm1XRSKHlrGij4KtnBRUG/XwMK7ACr0sBE32IoxxDXVf5WtqAI114cdy+v8G4iXA93qBp9IQlct9xPfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojWlPwOfpcZPbtnj74IIxza15rdFmiCBno6SZ7TATBg=;
 b=F5iWT95jaTC2Ta2xp7/wZkNgHYNeHlKefMP5ehxZCR6zdrMJG508DopfAtCbhR2jMgtuirhKN5B44Gq9fttTEzUtOxyVye/xcshkDvWhAAbdXhM1R1C9QKDdTAXb59DeYhvmHXCdzpq+747Bs1eVy9unbfXNXOEwM/WMxT6CDZk=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3390.namprd05.prod.outlook.com (10.174.175.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.15; Wed, 30 Oct 2019 14:57:48 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 14:57:48 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
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
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 04/14] vsock: add 'transport' member in the
 struct vsock_sock
Thread-Topic: [PATCH net-next 04/14] vsock: add 'transport' member in the
 struct vsock_sock
Thread-Index: AQHViYhHSBrfdrNmrEudA6MYBlx3zadzUY5w
Date:   Wed, 30 Oct 2019 14:57:48 +0000
Message-ID: <MWHPR05MB3376CCAF1570067F1E0F915DDA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-5-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-5-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ac74f27-2fba-4765-6ac6-08d75d498777
x-ms-traffictypediagnostic: MWHPR05MB3390:
x-microsoft-antispam-prvs: <MWHPR05MB33902340DA8DBF5582D417A4DA600@MWHPR05MB3390.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(81156014)(33656002)(52536014)(55016002)(54906003)(4326008)(81166006)(2906002)(316002)(86362001)(25786009)(8676002)(478600001)(7416002)(256004)(14444005)(6436002)(14454004)(66066001)(8936002)(99286004)(9686003)(6116002)(71190400001)(64756008)(6246003)(102836004)(66476007)(66946007)(76116006)(6916009)(229853002)(53546011)(71200400001)(66446008)(74316002)(486006)(7696005)(6506007)(186003)(30864003)(11346002)(476003)(446003)(26005)(7736002)(305945005)(3846002)(76176011)(5660300002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3390;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rc/H18rysNeOtbSry2l0SyPT/s0x/3ZL69q/Kc8BW2q5XzyvALNwK0JowCF/URQGkktxnKc5dVo1G4PIjEIz6EM1ueK7MlOYB9ZP8/Ii65vOFoP/WXJUgYvxl5WwDXl/CKYbQTq4JgfZdVRzz5y4EtUC7n4o4EW6X21bOkKTGfZ2cJyzyLWq2sRDf1vR+UHJl0XdXyqYhmj9aOSM0ZciJ1HjWsauUkNT8CHBiUKFrRfI5w0wBXnr5AlWHSygvYLLDzj7R88gZwUJYwstVgPMnBjzbC88CLVmuJb9jKKDBTXw+vw6OJbHQF7jHu7iofhWjKgOukuf9cI9UORwAmTKPZjxKVf9LPtb3pxDrMe3tVoqEfxZHyda2qSjYA8gGPuuo/vWMH5eomElFF862UFEtuhEeqPeLzxtlQpU3OJ9Lr0MMGK7sCjYu4vmN2ChAegH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac74f27-2fba-4765-6ac6-08d75d498777
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:57:48.1711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ucv/JShLxl9VIN/LnMdRx2K6pBfaRD4wM7/5EhgExH5rHuKtgfbCn9zHcvZkQJAdPsQ5SFBEEKRIwU49WwPGyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> Subject: [PATCH net-next 04/14] vsock: add 'transport' member in the stru=
ct
> vsock_sock
>=20
> As a preparation to support multiple transports, this patch adds the
> 'transport' member at the 'struct vsock_sock'.
> This new field is initialized during the creation in the
> __vsock_create() function.
>=20
> This patch also renames the global 'transport' pointer to 'transport_sing=
le',
> since for now we're only supporting a single transport registered at run-=
time.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/net/af_vsock.h   |  1 +
>  net/vmw_vsock/af_vsock.c | 56 +++++++++++++++++++++++++++----------
> ---
>  2 files changed, 39 insertions(+), 18 deletions(-)
>=20
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h index
> c660402b10f2..a5e1e134261d 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -27,6 +27,7 @@ extern spinlock_t vsock_table_lock;  struct vsock_sock =
{
>  	/* sk must be the first member. */
>  	struct sock sk;
> +	const struct vsock_transport *transport;
>  	struct sockaddr_vm local_addr;
>  	struct sockaddr_vm remote_addr;
>  	/* Links for the global tables of bound and connected sockets. */ diff
> --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> 2f2582fb7fdd..c3a14f853eb0 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -126,7 +126,7 @@ static struct proto vsock_proto =3D {
>   */
>  #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
>=20
> -static const struct vsock_transport *transport;
> +static const struct vsock_transport *transport_single;
>  static DEFINE_MUTEX(vsock_register_mutex);
>=20
>  /**** UTILS ****/
> @@ -408,7 +408,9 @@ static bool vsock_is_pending(struct sock *sk)
>=20
>  static int vsock_send_shutdown(struct sock *sk, int mode)  {
> -	return transport->shutdown(vsock_sk(sk), mode);
> +	struct vsock_sock *vsk =3D vsock_sk(sk);
> +
> +	return vsk->transport->shutdown(vsk, mode);
>  }
>=20
>  static void vsock_pending_work(struct work_struct *work) @@ -518,7
> +520,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,  static =
int
> __vsock_bind_dgram(struct vsock_sock *vsk,
>  			      struct sockaddr_vm *addr)
>  {
> -	return transport->dgram_bind(vsk, addr);
> +	return vsk->transport->dgram_bind(vsk, addr);
>  }
>=20
>  static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr) @@ -
> 536,7 +538,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_=
vm
> *addr)
>  	 * like AF_INET prevents binding to a non-local IP address (in most
>  	 * cases), we only allow binding to the local CID.
>  	 */
> -	cid =3D transport->get_local_cid();
> +	cid =3D vsk->transport->get_local_cid();
>  	if (addr->svm_cid !=3D cid && addr->svm_cid !=3D VMADDR_CID_ANY)
>  		return -EADDRNOTAVAIL;
>=20
> @@ -586,6 +588,7 @@ struct sock *__vsock_create(struct net *net,
>  		sk->sk_type =3D type;
>=20
>  	vsk =3D vsock_sk(sk);
> +	vsk->transport =3D transport_single;
>  	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY,
> VMADDR_PORT_ANY);
>  	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY,
> VMADDR_PORT_ANY);
>=20
> @@ -616,7 +619,7 @@ struct sock *__vsock_create(struct net *net,
>  		vsk->connect_timeout =3D
> VSOCK_DEFAULT_CONNECT_TIMEOUT;
>  	}
>=20
> -	if (transport->init(vsk, psk) < 0) {
> +	if (vsk->transport->init(vsk, psk) < 0) {
>  		sk_free(sk);
>  		return NULL;
>  	}
> @@ -641,7 +644,7 @@ static void __vsock_release(struct sock *sk, int leve=
l)
>  		/* The release call is supposed to use lock_sock_nested()
>  		 * rather than lock_sock(), if a sock lock should be acquired.
>  		 */
> -		transport->release(vsk);
> +		vsk->transport->release(vsk);
>=20
>  		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
>  		 * version to avoid the warning "possible recursive locking
> @@ -670,7 +673,7 @@ static void vsock_sk_destruct(struct sock *sk)  {
>  	struct vsock_sock *vsk =3D vsock_sk(sk);
>=20
> -	transport->destruct(vsk);
> +	vsk->transport->destruct(vsk);
>=20
>  	/* When clearing these addresses, there's no need to set the family
> and
>  	 * possibly register the address family with the kernel.
> @@ -694,13 +697,13 @@ static int vsock_queue_rcv_skb(struct sock *sk,
> struct sk_buff *skb)
>=20
>  s64 vsock_stream_has_data(struct vsock_sock *vsk)  {
> -	return transport->stream_has_data(vsk);
> +	return vsk->transport->stream_has_data(vsk);
>  }
>  EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>=20
>  s64 vsock_stream_has_space(struct vsock_sock *vsk)  {
> -	return transport->stream_has_space(vsk);
> +	return vsk->transport->stream_has_space(vsk);
>  }
>  EXPORT_SYMBOL_GPL(vsock_stream_has_space);
>=20
> @@ -869,6 +872,7 @@ static __poll_t vsock_poll(struct file *file, struct
> socket *sock,
>  			mask |=3D EPOLLOUT | EPOLLWRNORM |
> EPOLLWRBAND;
>=20
>  	} else if (sock->type =3D=3D SOCK_STREAM) {
> +		const struct vsock_transport *transport =3D vsk->transport;
>  		lock_sock(sk);
>=20
>  		/* Listening sockets that have connections in their accept
> @@ -944,6 +948,7 @@ static int vsock_dgram_sendmsg(struct socket *sock,
> struct msghdr *msg,
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
>  	struct sockaddr_vm *remote_addr;
> +	const struct vsock_transport *transport;
>=20
>  	if (msg->msg_flags & MSG_OOB)
>  		return -EOPNOTSUPP;
> @@ -952,6 +957,7 @@ static int vsock_dgram_sendmsg(struct socket *sock,
> struct msghdr *msg,
>  	err =3D 0;
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>=20
>  	lock_sock(sk);
>=20
> @@ -1036,8 +1042,8 @@ static int vsock_dgram_connect(struct socket
> *sock,
>  	if (err)
>  		goto out;
>=20
> -	if (!transport->dgram_allow(remote_addr->svm_cid,
> -				    remote_addr->svm_port)) {
> +	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
> +					 remote_addr->svm_port)) {
>  		err =3D -EINVAL;
>  		goto out;
>  	}
> @@ -1053,7 +1059,9 @@ static int vsock_dgram_connect(struct socket
> *sock,  static int vsock_dgram_recvmsg(struct socket *sock, struct msghdr
> *msg,
>  			       size_t len, int flags)
>  {
> -	return transport->dgram_dequeue(vsock_sk(sock->sk), msg, len,
> flags);
> +	struct vsock_sock *vsk =3D vsock_sk(sock->sk);
> +
> +	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
>  }
>=20
>  static const struct proto_ops vsock_dgram_ops =3D { @@ -1079,6 +1087,8 @=
@
> static const struct proto_ops vsock_dgram_ops =3D {
>=20
>  static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)  {
> +	const struct vsock_transport *transport =3D vsk->transport;
> +
>  	if (!transport->cancel_pkt)
>  		return -EOPNOTSUPP;
>=20
> @@ -1115,6 +1125,7 @@ static int vsock_stream_connect(struct socket
> *sock, struct sockaddr *addr,
>  	int err;
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
>  	struct sockaddr_vm *remote_addr;
>  	long timeout;
>  	DEFINE_WAIT(wait);
> @@ -1122,6 +1133,7 @@ static int vsock_stream_connect(struct socket
> *sock, struct sockaddr *addr,
>  	err =3D 0;
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>=20
>  	lock_sock(sk);
>=20
> @@ -1365,6 +1377,7 @@ static int vsock_stream_setsockopt(struct socket
> *sock,
>  	int err;
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
>  	u64 val;
>=20
>  	if (level !=3D AF_VSOCK)
> @@ -1385,6 +1398,7 @@ static int vsock_stream_setsockopt(struct socket
> *sock,
>  	err =3D 0;
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>=20
>  	lock_sock(sk);
>=20
> @@ -1442,6 +1456,7 @@ static int vsock_stream_getsockopt(struct socket
> *sock,
>  	int len;
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
>  	u64 val;
>=20
>  	if (level !=3D AF_VSOCK)
> @@ -1465,6 +1480,7 @@ static int vsock_stream_getsockopt(struct socket
> *sock,
>  	err =3D 0;
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>=20
>  	switch (optname) {
>  	case SO_VM_SOCKETS_BUFFER_SIZE:
> @@ -1509,6 +1525,7 @@ static int vsock_stream_sendmsg(struct socket
> *sock, struct msghdr *msg,  {
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
>  	ssize_t total_written;
>  	long timeout;
>  	int err;
> @@ -1517,6 +1534,7 @@ static int vsock_stream_sendmsg(struct socket
> *sock, struct msghdr *msg,
>=20
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>  	total_written =3D 0;
>  	err =3D 0;
>=20
> @@ -1648,6 +1666,7 @@ vsock_stream_recvmsg(struct socket *sock, struct
> msghdr *msg, size_t len,  {
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
>  	int err;
>  	size_t target;
>  	ssize_t copied;
> @@ -1658,6 +1677,7 @@ vsock_stream_recvmsg(struct socket *sock, struct
> msghdr *msg, size_t len,
>=20
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> +	transport =3D vsk->transport;
>  	err =3D 0;
>=20
>  	lock_sock(sk);
> @@ -1872,7 +1892,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
>=20
>  	switch (cmd) {
>  	case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
> -		if (put_user(transport->get_local_cid(), p) !=3D 0)
> +		if (put_user(transport_single->get_local_cid(), p) !=3D 0)
>  			retval =3D -EFAULT;
>  		break;
>=20
> @@ -1919,7 +1939,7 @@ int __vsock_core_init(const struct vsock_transport
> *t, struct module *owner)
>  	if (err)
>  		return err;
>=20
> -	if (transport) {
> +	if (transport_single) {
>  		err =3D -EBUSY;
>  		goto err_busy;
>  	}
> @@ -1928,7 +1948,7 @@ int __vsock_core_init(const struct vsock_transport
> *t, struct module *owner)
>  	 * unload while there are open sockets.
>  	 */
>  	vsock_proto.owner =3D owner;
> -	transport =3D t;
> +	transport_single =3D t;
>=20
>  	vsock_device.minor =3D MISC_DYNAMIC_MINOR;
>  	err =3D misc_register(&vsock_device);
> @@ -1958,7 +1978,7 @@ int __vsock_core_init(const struct vsock_transport
> *t, struct module *owner)
>  err_deregister_misc:
>  	misc_deregister(&vsock_device);
>  err_reset_transport:
> -	transport =3D NULL;
> +	transport_single =3D NULL;
>  err_busy:
>  	mutex_unlock(&vsock_register_mutex);
>  	return err;
> @@ -1975,7 +1995,7 @@ void vsock_core_exit(void)
>=20
>  	/* We do not want the assignment below re-ordered. */
>  	mb();
> -	transport =3D NULL;
> +	transport_single =3D NULL;
>=20
>  	mutex_unlock(&vsock_register_mutex);
>  }
> @@ -1986,7 +2006,7 @@ const struct vsock_transport
> *vsock_core_get_transport(void)
>  	/* vsock_register_mutex not taken since only the transport uses this
>  	 * function and only while registered.
>  	 */
> -	return transport;
> +	return transport_single;
>  }
>  EXPORT_SYMBOL_GPL(vsock_core_get_transport);
>=20
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
