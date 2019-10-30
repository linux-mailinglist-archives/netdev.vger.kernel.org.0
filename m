Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483D5E9E72
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfJ3PI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:08:26 -0400
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:13502
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726772AbfJ3PIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:08:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltU80vrugW/zyH/S9YltVLBZzf+e4KQVSLa0YoRmlm83PbsoZcvNE+p5QYvaN1oJ//f/1LqzOjpZ5pcpAeIcNaw6P1/VS8YS2F7QloWcbNOo7Q8pZEOwC/t4TeD9brjvZBvEbuNHqTxFoFpHpaz6E2kidDD1zjLKlR/e7desHeay2aXJMPUQskeAhrZ6jRASMU4S6dtctJb2goLaFsAze4PmKQAoc5l+3Okx+3AHn2Uy9O4hBcfwX1O3HlqTs1zs2jRLMTaXauSjHwfLC/cBm/prOrJzjShu7l4d/PDf8AZ8YbHVuS+R75t4UJoRenM78X3XwKW0L09bVlJPgP/hpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xTN++DicQ7o3CsrVs1g/6oyveqgE8/CyFmZ+w21XhM=;
 b=nfTC8qmHGTIrsidaXpXT1y+BwBwAt7ec/GsK6DwAREwTlTB8WTaojLOo1ik7hhFmf5J9S8YsicRnVsacGRzQiL+3OXE1KjhCiHpVP0v6QJ1ximSX5nG7AWyYngo+egsNnc/K5aOzfKe6TXsJaJrlAKy5S51mzPrMn/eUtoqCnI8NFHyiGhQjR7sr9xOtADDgcU2GQ4tqpCm3DUeutH5l0zpyNX0DJJIzY8LysvdMQNWOtzvT+SqlPvWBNVg8EwtXeMQt42t/5Mth/Szbp6SmOcCmfwsckqU6jX9HtBTygiNZ+YOX0pMIs/HMsf8DyCF0AS8cWTQIIyK+qM9N8dhfzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xTN++DicQ7o3CsrVs1g/6oyveqgE8/CyFmZ+w21XhM=;
 b=Um6AIbLNmJ6avRepP4IW1tnmdcJhvS+VECo4ca0zqOgnH7f/5YL6jLO6MsfZhQH3Dv5ax2wKaz0FuRDW0gYXKSKowdcdq2EGIO89iML4vaX2RQThHJ9abJuYhXJxg01bTzEeYsGZJ9/zvP1cFoxTyKFKPhxjoBuFrdBx3IIfSZI=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.13; Wed, 30 Oct 2019 15:08:15 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 15:08:15 +0000
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
Subject: RE: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
 core
Thread-Topic: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
 core
Thread-Index: AQHViYhdZbV9o4+EZE+ME3JDZVbPyKdzUtpg
Date:   Wed, 30 Oct 2019 15:08:15 +0000
Message-ID: <MWHPR05MB337657F8FFE2C0BB4F90B261DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-8-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-8-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eab1b0d5-7254-4654-3864-08d75d4afd7e
x-ms-traffictypediagnostic: MWHPR05MB3376:
x-microsoft-antispam-prvs: <MWHPR05MB3376A717040A3378DB31E905DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(199004)(189003)(11346002)(476003)(256004)(4326008)(81166006)(486006)(76176011)(478600001)(14444005)(6916009)(55016002)(102836004)(5660300002)(81156014)(14454004)(186003)(66066001)(7696005)(86362001)(446003)(8676002)(52536014)(229853002)(3846002)(316002)(7736002)(305945005)(2906002)(6436002)(25786009)(33656002)(30864003)(6246003)(7416002)(76116006)(9686003)(99286004)(6506007)(53546011)(71200400001)(71190400001)(74316002)(64756008)(8936002)(66446008)(66476007)(66556008)(6116002)(66946007)(54906003)(26005)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3376;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IEJNFiyGZ44+GO7dIb9akaCovO5t9eQT1kbsG2kHZ9iNlcrwSHCUkXaXjWkP3NCdediFTqoTvKnR3VKBMGfDAaHemWPH5X49i/DVGDWO5hnA2aHrUsMToOc4z10WXwQTOu73a/510ezmp3HG+26jmOnda6c9uSHXGO3Bg05heNx/Rj+khDHcO+oHD18urAE9VZLTliDUNMqms/xcGkXaQybU2525zJumWzML/QPJwNEfX/HkXIbk0+IifMBZKW2mxjt1AX8+dN11RtKRhvAkRU8KFlK+l+2t9XLnn8JV+9Eg4Yfk33bgmLbPPu10MJ3P2HNGYdvRx0ctEge+foW0lwc/3e5Xj5YKeeOs33UU2PRPTqlnhI1JtHQT9M8SninyIkBR/lrP4sDS7tdjOfz7T78P5JK3HGQrLN60TW3IYvTeuBNbfRJEGQiNLGWXprLP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab1b0d5-7254-4654-3864-08d75d4afd7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:08:15.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4FV+zKJGK3wcXzOp7M7ZQyriB62kzSd1QwhhXhUU+R5lEWfFhj9LTUUu2SZwWbceLSTMGi+Moe9Tv5eF/hP6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> Subject: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
> core
>=20
> virtio_transport and vmci_transport handle the buffer_size sockopts in a
> very similar way.
>=20
> In order to support multiple transports, this patch moves this handling i=
n the
> core to allow the user to change the options also if the socket is not ye=
t
> assigned to any transport.
>=20
> This patch also adds the '.notify_buffer_size' callback in the 'struct
> virtio_transport' in order to inform the transport, when the buffer_size =
is
> changed by the user. It is also useful to limit the 'buffer_size' request=
ed (e.g.
> virtio transports).
>=20
> Acked-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> RFC -> v1:
> - changed .notify_buffer_size return to void (Stefan)
> - documented that .notify_buffer_size is called with sk_lock held (Stefan=
)
> ---
>  drivers/vhost/vsock.c                   |  7 +-
>  include/linux/virtio_vsock.h            | 15 +----
>  include/net/af_vsock.h                  | 15 ++---
>  net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
>  net/vmw_vsock/hyperv_transport.c        | 36 -----------
>  net/vmw_vsock/virtio_transport.c        |  8 +--
>  net/vmw_vsock/virtio_transport_common.c | 79 ++++-------------------
>  net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
>  net/vmw_vsock/vmci_transport.h          |  3 -
>  9 files changed, 65 insertions(+), 227 deletions(-)
>=20
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c index
> 92ab3852c954..6d7e4f022748 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -418,13 +418,8 @@ static struct virtio_transport vhost_transport =3D {
>  		.notify_send_pre_block    =3D
> virtio_transport_notify_send_pre_block,
>  		.notify_send_pre_enqueue  =3D
> virtio_transport_notify_send_pre_enqueue,
>  		.notify_send_post_enqueue =3D
> virtio_transport_notify_send_post_enqueue,
> +		.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
>=20
> -		.set_buffer_size          =3D virtio_transport_set_buffer_size,
> -		.set_min_buffer_size      =3D
> virtio_transport_set_min_buffer_size,
> -		.set_max_buffer_size      =3D
> virtio_transport_set_max_buffer_size,
> -		.get_buffer_size          =3D virtio_transport_get_buffer_size,
> -		.get_min_buffer_size      =3D
> virtio_transport_get_min_buffer_size,
> -		.get_max_buffer_size      =3D
> virtio_transport_get_max_buffer_size,
>  	},
>=20
>  	.send_pkt =3D vhost_transport_send_pkt,
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h =
index
> 96d8132acbd7..b79befd2a5a4 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -7,9 +7,6 @@
>  #include <net/sock.h>
>  #include <net/af_vsock.h>
>=20
> -#define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
> -#define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
> -#define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
>  #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
>  #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
>  #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
> @@ -25,11 +22,6 @@ enum {
>  struct virtio_vsock_sock {
>  	struct vsock_sock *vsk;
>=20
> -	/* Protected by lock_sock(sk_vsock(trans->vsk)) */
> -	u32 buf_size;
> -	u32 buf_size_min;
> -	u32 buf_size_max;
> -
>  	spinlock_t tx_lock;
>  	spinlock_t rx_lock;
>=20
> @@ -93,12 +85,6 @@ s64 virtio_transport_stream_has_space(struct
> vsock_sock *vsk);
>=20
>  int virtio_transport_do_socket_init(struct vsock_sock *vsk,
>  				 struct vsock_sock *psk);
> -u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk);
> -u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk);
> -u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk); -void
> virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val); -void
> virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val); -v=
oid
> virtio_transport_set_max_buffer_size(struct vsock_sock *vs, u64 val);  in=
t
> virtio_transport_notify_poll_in(struct vsock_sock *vsk,
>  				size_t target,
> @@ -125,6 +111,7 @@ int
> virtio_transport_notify_send_pre_enqueue(struct vsock_sock *vsk,
>  	struct vsock_transport_send_notify_data *data);  int
> virtio_transport_notify_send_post_enqueue(struct vsock_sock *vsk,
>  	ssize_t written, struct vsock_transport_send_notify_data *data);
> +void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64
> +*val);
>=20
>  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);  bool
> virtio_transport_stream_is_active(struct vsock_sock *vsk); diff --git
> a/include/net/af_vsock.h b/include/net/af_vsock.h index
> 2ca67d048de4..4b5d16840fd4 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -65,6 +65,11 @@ struct vsock_sock {
>  	bool sent_request;
>  	bool ignore_connecting_rst;
>=20
> +	/* Protected by lock_sock(sk) */
> +	u64 buffer_size;
> +	u64 buffer_min_size;
> +	u64 buffer_max_size;
> +
>  	/* Private to transport. */
>  	void *trans;
>  };
> @@ -140,18 +145,12 @@ struct vsock_transport {
>  		struct vsock_transport_send_notify_data *);
>  	int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
>  		struct vsock_transport_send_notify_data *);
> +	/* sk_lock held by the caller */
> +	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
>=20
>  	/* Shutdown. */
>  	int (*shutdown)(struct vsock_sock *, int);
>=20
> -	/* Buffer sizes. */
> -	void (*set_buffer_size)(struct vsock_sock *, u64);
> -	void (*set_min_buffer_size)(struct vsock_sock *, u64);
> -	void (*set_max_buffer_size)(struct vsock_sock *, u64);
> -	u64 (*get_buffer_size)(struct vsock_sock *);
> -	u64 (*get_min_buffer_size)(struct vsock_sock *);
> -	u64 (*get_max_buffer_size)(struct vsock_sock *);
> -
>  	/* Addressing. */
>  	u32 (*get_local_cid)(void);
>  };
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> eaea159006c8..90ac46ea12ef 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -126,6 +126,10 @@ static struct proto vsock_proto =3D {
>   */
>  #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
>=20
> +#define VSOCK_DEFAULT_BUFFER_SIZE     (1024 * 256)
> +#define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256) #define
> +VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
> +
>  static const struct vsock_transport *transport_single;  static
> DEFINE_MUTEX(vsock_register_mutex);
>=20
> @@ -613,10 +617,16 @@ struct sock *__vsock_create(struct net *net,
>  		vsk->trusted =3D psk->trusted;
>  		vsk->owner =3D get_cred(psk->owner);
>  		vsk->connect_timeout =3D psk->connect_timeout;
> +		vsk->buffer_size =3D psk->buffer_size;
> +		vsk->buffer_min_size =3D psk->buffer_min_size;
> +		vsk->buffer_max_size =3D psk->buffer_max_size;
>  	} else {
>  		vsk->trusted =3D capable(CAP_NET_ADMIN);
>  		vsk->owner =3D get_current_cred();
>  		vsk->connect_timeout =3D
> VSOCK_DEFAULT_CONNECT_TIMEOUT;
> +		vsk->buffer_size =3D VSOCK_DEFAULT_BUFFER_SIZE;
> +		vsk->buffer_min_size =3D
> VSOCK_DEFAULT_BUFFER_MIN_SIZE;
> +		vsk->buffer_max_size =3D
> VSOCK_DEFAULT_BUFFER_MAX_SIZE;
>  	}
>=20
>  	if (vsk->transport->init(vsk, psk) < 0) { @@ -1368,6 +1378,23 @@
> static int vsock_listen(struct socket *sock, int backlog)
>  	return err;
>  }
>=20
> +static void vsock_update_buffer_size(struct vsock_sock *vsk,
> +				     const struct vsock_transport *transport,
> +				     u64 val)
> +{
> +	if (val > vsk->buffer_max_size)
> +		val =3D vsk->buffer_max_size;
> +
> +	if (val < vsk->buffer_min_size)
> +		val =3D vsk->buffer_min_size;
> +
> +	if (val !=3D vsk->buffer_size &&
> +	    transport && transport->notify_buffer_size)
> +		transport->notify_buffer_size(vsk, &val);
> +
> +	vsk->buffer_size =3D val;
> +}
> +
>  static int vsock_stream_setsockopt(struct socket *sock,
>  				   int level,
>  				   int optname,
> @@ -1405,17 +1432,19 @@ static int vsock_stream_setsockopt(struct socket
> *sock,
>  	switch (optname) {
>  	case SO_VM_SOCKETS_BUFFER_SIZE:
>  		COPY_IN(val);
> -		transport->set_buffer_size(vsk, val);
> +		vsock_update_buffer_size(vsk, transport, val);
>  		break;
>=20
>  	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
>  		COPY_IN(val);
> -		transport->set_max_buffer_size(vsk, val);
> +		vsk->buffer_max_size =3D val;
> +		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
>  		break;
>=20
>  	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
>  		COPY_IN(val);
> -		transport->set_min_buffer_size(vsk, val);
> +		vsk->buffer_min_size =3D val;
> +		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
>  		break;
>=20
>  	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
> @@ -1456,7 +1485,6 @@ static int vsock_stream_getsockopt(struct socket
> *sock,
>  	int len;
>  	struct sock *sk;
>  	struct vsock_sock *vsk;
> -	const struct vsock_transport *transport;
>  	u64 val;
>=20
>  	if (level !=3D AF_VSOCK)
> @@ -1480,21 +1508,20 @@ static int vsock_stream_getsockopt(struct socket
> *sock,
>  	err =3D 0;
>  	sk =3D sock->sk;
>  	vsk =3D vsock_sk(sk);
> -	transport =3D vsk->transport;
>=20
>  	switch (optname) {
>  	case SO_VM_SOCKETS_BUFFER_SIZE:
> -		val =3D transport->get_buffer_size(vsk);
> +		val =3D vsk->buffer_size;
>  		COPY_OUT(val);
>  		break;
>=20
>  	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
> -		val =3D transport->get_max_buffer_size(vsk);
> +		val =3D vsk->buffer_max_size;
>  		COPY_OUT(val);
>  		break;
>=20
>  	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
> -		val =3D transport->get_min_buffer_size(vsk);
> +		val =3D vsk->buffer_min_size;
>  		COPY_OUT(val);
>  		break;
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c
> b/net/vmw_vsock/hyperv_transport.c
> index bef8772116ec..d62297a62ca6 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -845,36 +845,6 @@ int hvs_notify_send_post_enqueue(struct
> vsock_sock *vsk, ssize_t written,
>  	return 0;
>  }
>=20
> -static void hvs_set_buffer_size(struct vsock_sock *vsk, u64 val) -{
> -	/* Ignored. */
> -}
> -
> -static void hvs_set_min_buffer_size(struct vsock_sock *vsk, u64 val) -{
> -	/* Ignored. */
> -}
> -
> -static void hvs_set_max_buffer_size(struct vsock_sock *vsk, u64 val) -{
> -	/* Ignored. */
> -}
> -
> -static u64 hvs_get_buffer_size(struct vsock_sock *vsk) -{
> -	return -ENOPROTOOPT;
> -}
> -
> -static u64 hvs_get_min_buffer_size(struct vsock_sock *vsk) -{
> -	return -ENOPROTOOPT;
> -}
> -
> -static u64 hvs_get_max_buffer_size(struct vsock_sock *vsk) -{
> -	return -ENOPROTOOPT;
> -}
> -
>  static struct vsock_transport hvs_transport =3D {
>  	.get_local_cid            =3D hvs_get_local_cid,
>=20
> @@ -908,12 +878,6 @@ static struct vsock_transport hvs_transport =3D {
>  	.notify_send_pre_enqueue  =3D hvs_notify_send_pre_enqueue,
>  	.notify_send_post_enqueue =3D hvs_notify_send_post_enqueue,
>=20
> -	.set_buffer_size          =3D hvs_set_buffer_size,
> -	.set_min_buffer_size      =3D hvs_set_min_buffer_size,
> -	.set_max_buffer_size      =3D hvs_set_max_buffer_size,
> -	.get_buffer_size          =3D hvs_get_buffer_size,
> -	.get_min_buffer_size      =3D hvs_get_min_buffer_size,
> -	.get_max_buffer_size      =3D hvs_get_max_buffer_size,
>  };
>=20
>  static int hvs_probe(struct hv_device *hdev, diff --git
> a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 3756f0857946..fb1fc7760e8c 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -494,13 +494,7 @@ static struct virtio_transport virtio_transport =3D =
{
>  		.notify_send_pre_block    =3D
> virtio_transport_notify_send_pre_block,
>  		.notify_send_pre_enqueue  =3D
> virtio_transport_notify_send_pre_enqueue,
>  		.notify_send_post_enqueue =3D
> virtio_transport_notify_send_post_enqueue,
> -
> -		.set_buffer_size          =3D virtio_transport_set_buffer_size,
> -		.set_min_buffer_size      =3D
> virtio_transport_set_min_buffer_size,
> -		.set_max_buffer_size      =3D
> virtio_transport_set_max_buffer_size,
> -		.get_buffer_size          =3D virtio_transport_get_buffer_size,
> -		.get_min_buffer_size      =3D
> virtio_transport_get_min_buffer_size,
> -		.get_max_buffer_size      =3D
> virtio_transport_get_max_buffer_size,
> +		.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
>  	},
>=20
>  	.send_pkt =3D virtio_transport_send_pkt, diff --git
> a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> index 37a1c7e7c7fe..b2a310dfa158 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -456,17 +456,13 @@ int virtio_transport_do_socket_init(struct
> vsock_sock *vsk,
>  	if (psk) {
>  		struct virtio_vsock_sock *ptrans =3D psk->trans;
>=20
> -		vvs->buf_size	=3D ptrans->buf_size;
> -		vvs->buf_size_min =3D ptrans->buf_size_min;
> -		vvs->buf_size_max =3D ptrans->buf_size_max;
>  		vvs->peer_buf_alloc =3D ptrans->peer_buf_alloc;
> -	} else {
> -		vvs->buf_size =3D VIRTIO_VSOCK_DEFAULT_BUF_SIZE;
> -		vvs->buf_size_min =3D
> VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE;
> -		vvs->buf_size_max =3D
> VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE;
>  	}
>=20
> -	vvs->buf_alloc =3D vvs->buf_size;
> +	if (vsk->buffer_size > VIRTIO_VSOCK_MAX_BUF_SIZE)
> +		vsk->buffer_size =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
> +
> +	vvs->buf_alloc =3D vsk->buffer_size;
>=20
>  	spin_lock_init(&vvs->rx_lock);
>  	spin_lock_init(&vvs->tx_lock);
> @@ -476,71 +472,20 @@ int virtio_transport_do_socket_init(struct
> vsock_sock *vsk,  }  EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
>=20
> -u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk) -{
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> -
> -	return vvs->buf_size;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_get_buffer_size);
> -
> -u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk)
> +/* sk_lock held by the caller */
> +void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64
> +*val)
>  {
>  	struct virtio_vsock_sock *vvs =3D vsk->trans;
>=20
> -	return vvs->buf_size_min;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_get_min_buffer_size);
> -
> -u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk) -{
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> -
> -	return vvs->buf_size_max;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_get_max_buffer_size);
> -
> -void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val) -=
{
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> +	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> +		*val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
>=20
> -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> -		val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
> -	if (val < vvs->buf_size_min)
> -		vvs->buf_size_min =3D val;
> -	if (val > vvs->buf_size_max)
> -		vvs->buf_size_max =3D val;
> -	vvs->buf_size =3D val;
> -	vvs->buf_alloc =3D val;
> +	vvs->buf_alloc =3D *val;
>=20
>  	virtio_transport_send_credit_update(vsk,
> VIRTIO_VSOCK_TYPE_STREAM,
>  					    NULL);
>  }
> -EXPORT_SYMBOL_GPL(virtio_transport_set_buffer_size);
> -
> -void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 va=
l)
> -{
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> -
> -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> -		val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
> -	if (val > vvs->buf_size)
> -		vvs->buf_size =3D val;
> -	vvs->buf_size_min =3D val;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_set_min_buffer_size);
> -
> -void virtio_transport_set_max_buffer_size(struct vsock_sock *vsk, u64 va=
l)
> -{
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> -
> -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> -		val =3D VIRTIO_VSOCK_MAX_BUF_SIZE;
> -	if (val < vvs->buf_size)
> -		vvs->buf_size =3D val;
> -	vvs->buf_size_max =3D val;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_set_max_buffer_size);
> +EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
>=20
>  int
>  virtio_transport_notify_poll_in(struct vsock_sock *vsk, @@ -632,9 +577,7
> @@ EXPORT_SYMBOL_GPL(virtio_transport_notify_send_post_enqueue);
>=20
>  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk)  {
> -	struct virtio_vsock_sock *vvs =3D vsk->trans;
> -
> -	return vvs->buf_size;
> +	return vsk->buffer_size;
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_stream_rcvhiwat);

While the VMCI transport uses a transport local consumer_size for stream_rc=
vhiwat,
that consumer_size is always the same as buffer_size (a vmci queue pair all=
ows the
producer and consumer queues to be of different sizes, but vsock doesn't us=
e that).
So we could move the stream_rcvhiwat code to the common code as well, and j=
ust
use buffer_size, if that simplifies things.

> diff --git a/net/vmw_vsock/vmci_transport.c
> b/net/vmw_vsock/vmci_transport.c index f8e3131ac480..8290d37b6587
> 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -74,10 +74,6 @@ static u32 vmci_transport_qp_resumed_sub_id =3D
> VMCI_INVALID_ID;
>=20
>  static int PROTOCOL_OVERRIDE =3D -1;
>=20
> -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN   128
> -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
> -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
> -
>  /* Helper function to convert from a VMCI error code to a VSock error co=
de.
> */
>=20
>  static s32 vmci_transport_error_to_vsock_error(s32 vmci_error) @@ -
> 1025,11 +1021,11 @@ static int vmci_transport_recv_listen(struct sock *sk=
,
>  	/* If the proposed size fits within our min/max, accept it. Otherwise
>  	 * propose our own size.
>  	 */
> -	if (pkt->u.size >=3D vmci_trans(vpending)->queue_pair_min_size &&
> -	    pkt->u.size <=3D vmci_trans(vpending)->queue_pair_max_size) {
> +	if (pkt->u.size >=3D vpending->buffer_min_size &&
> +	    pkt->u.size <=3D vpending->buffer_max_size) {
>  		qp_size =3D pkt->u.size;
>  	} else {
> -		qp_size =3D vmci_trans(vpending)->queue_pair_size;
> +		qp_size =3D vpending->buffer_size;
>  	}
>=20
>  	/* Figure out if we are using old or new requests based on the @@ -
> 1098,7 +1094,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
>  	pending->sk_state =3D TCP_SYN_SENT;
>  	vmci_trans(vpending)->produce_size =3D
>  		vmci_trans(vpending)->consume_size =3D qp_size;
> -	vmci_trans(vpending)->queue_pair_size =3D qp_size;
> +	vpending->buffer_size =3D qp_size;
>=20
>  	vmci_trans(vpending)->notify_ops->process_request(pending);
>=20
> @@ -1392,8 +1388,8 @@ static int
> vmci_transport_recv_connecting_client_negotiate(
>  	vsk->ignore_connecting_rst =3D false;
>=20
>  	/* Verify that we're OK with the proposed queue pair size */
> -	if (pkt->u.size < vmci_trans(vsk)->queue_pair_min_size ||
> -	    pkt->u.size > vmci_trans(vsk)->queue_pair_max_size) {
> +	if (pkt->u.size < vsk->buffer_min_size ||
> +	    pkt->u.size > vsk->buffer_max_size) {
>  		err =3D -EINVAL;
>  		goto destroy;
>  	}
> @@ -1498,8 +1494,7 @@
> vmci_transport_recv_connecting_client_invalid(struct sock *sk,
>  		vsk->sent_request =3D false;
>  		vsk->ignore_connecting_rst =3D true;
>=20
> -		err =3D vmci_transport_send_conn_request(
> -			sk, vmci_trans(vsk)->queue_pair_size);
> +		err =3D vmci_transport_send_conn_request(sk, vsk-
> >buffer_size);
>  		if (err < 0)
>  			err =3D vmci_transport_error_to_vsock_error(err);
>  		else
> @@ -1583,21 +1578,6 @@ static int vmci_transport_socket_init(struct
> vsock_sock *vsk,
>  	INIT_LIST_HEAD(&vmci_trans(vsk)->elem);
>  	vmci_trans(vsk)->sk =3D &vsk->sk;
>  	spin_lock_init(&vmci_trans(vsk)->lock);
> -	if (psk) {
> -		vmci_trans(vsk)->queue_pair_size =3D
> -			vmci_trans(psk)->queue_pair_size;
> -		vmci_trans(vsk)->queue_pair_min_size =3D
> -			vmci_trans(psk)->queue_pair_min_size;
> -		vmci_trans(vsk)->queue_pair_max_size =3D
> -			vmci_trans(psk)->queue_pair_max_size;
> -	} else {
> -		vmci_trans(vsk)->queue_pair_size =3D
> -			VMCI_TRANSPORT_DEFAULT_QP_SIZE;
> -		vmci_trans(vsk)->queue_pair_min_size =3D
> -			 VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN;
> -		vmci_trans(vsk)->queue_pair_max_size =3D
> -			VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX;
> -	}
>=20
>  	return 0;
>  }
> @@ -1813,8 +1793,7 @@ static int vmci_transport_connect(struct
> vsock_sock *vsk)
>=20
>  	if (vmci_transport_old_proto_override(&old_pkt_proto) &&
>  		old_pkt_proto) {
> -		err =3D vmci_transport_send_conn_request(
> -			sk, vmci_trans(vsk)->queue_pair_size);
> +		err =3D vmci_transport_send_conn_request(sk, vsk-
> >buffer_size);
>  		if (err < 0) {
>  			sk->sk_state =3D TCP_CLOSE;
>  			return err;
> @@ -1822,8 +1801,7 @@ static int vmci_transport_connect(struct
> vsock_sock *vsk)
>  	} else {
>  		int supported_proto_versions =3D
>  			vmci_transport_new_proto_supported_versions();
> -		err =3D vmci_transport_send_conn_request2(
> -				sk, vmci_trans(vsk)->queue_pair_size,
> +		err =3D vmci_transport_send_conn_request2(sk, vsk-
> >buffer_size,
>  				supported_proto_versions);
>  		if (err < 0) {
>  			sk->sk_state =3D TCP_CLOSE;
> @@ -1876,46 +1854,6 @@ static bool
> vmci_transport_stream_is_active(struct vsock_sock *vsk)
>  	return !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle);
>  }
>=20
> -static u64 vmci_transport_get_buffer_size(struct vsock_sock *vsk) -{
> -	return vmci_trans(vsk)->queue_pair_size;
> -}
> -
> -static u64 vmci_transport_get_min_buffer_size(struct vsock_sock *vsk) -{
> -	return vmci_trans(vsk)->queue_pair_min_size;
> -}
> -
> -static u64 vmci_transport_get_max_buffer_size(struct vsock_sock *vsk) -{
> -	return vmci_trans(vsk)->queue_pair_max_size;
> -}
> -
> -static void vmci_transport_set_buffer_size(struct vsock_sock *vsk, u64 v=
al)
> -{
> -	if (val < vmci_trans(vsk)->queue_pair_min_size)
> -		vmci_trans(vsk)->queue_pair_min_size =3D val;
> -	if (val > vmci_trans(vsk)->queue_pair_max_size)
> -		vmci_trans(vsk)->queue_pair_max_size =3D val;
> -	vmci_trans(vsk)->queue_pair_size =3D val;
> -}
> -
> -static void vmci_transport_set_min_buffer_size(struct vsock_sock *vsk,
> -					       u64 val)
> -{
> -	if (val > vmci_trans(vsk)->queue_pair_size)
> -		vmci_trans(vsk)->queue_pair_size =3D val;
> -	vmci_trans(vsk)->queue_pair_min_size =3D val;
> -}
> -
> -static void vmci_transport_set_max_buffer_size(struct vsock_sock *vsk,
> -					       u64 val)
> -{
> -	if (val < vmci_trans(vsk)->queue_pair_size)
> -		vmci_trans(vsk)->queue_pair_size =3D val;
> -	vmci_trans(vsk)->queue_pair_max_size =3D val;
> -}
> -
>  static int vmci_transport_notify_poll_in(
>  	struct vsock_sock *vsk,
>  	size_t target,
> @@ -2098,12 +2036,6 @@ static const struct vsock_transport vmci_transport
> =3D {
>  	.notify_send_pre_enqueue =3D
> vmci_transport_notify_send_pre_enqueue,
>  	.notify_send_post_enqueue =3D
> vmci_transport_notify_send_post_enqueue,
>  	.shutdown =3D vmci_transport_shutdown,
> -	.set_buffer_size =3D vmci_transport_set_buffer_size,
> -	.set_min_buffer_size =3D vmci_transport_set_min_buffer_size,
> -	.set_max_buffer_size =3D vmci_transport_set_max_buffer_size,
> -	.get_buffer_size =3D vmci_transport_get_buffer_size,
> -	.get_min_buffer_size =3D vmci_transport_get_min_buffer_size,
> -	.get_max_buffer_size =3D vmci_transport_get_max_buffer_size,
>  	.get_local_cid =3D vmci_transport_get_local_cid,  };
>=20
> diff --git a/net/vmw_vsock/vmci_transport.h
> b/net/vmw_vsock/vmci_transport.h index 1ca1e8640b31..b7b072194282
> 100644
> --- a/net/vmw_vsock/vmci_transport.h
> +++ b/net/vmw_vsock/vmci_transport.h
> @@ -108,9 +108,6 @@ struct vmci_transport {
>  	struct vmci_qp *qpair;
>  	u64 produce_size;
>  	u64 consume_size;
> -	u64 queue_pair_size;
> -	u64 queue_pair_min_size;
> -	u64 queue_pair_max_size;
>  	u32 detach_sub_id;
>  	union vmci_transport_notify notify;
>  	const struct vmci_transport_notify_ops *notify_ops;
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
