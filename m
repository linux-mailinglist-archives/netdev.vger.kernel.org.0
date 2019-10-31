Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF6EABCA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJaIuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfJaIub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 04:50:31 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D96AD86662
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:50:29 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id b10so2086868wmh.6
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 01:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oaX09C79dj+CrWDwYtUCmw850lgrDEb634tch2TvtRo=;
        b=NHUqN7/qoqqS40Ah+LSLz0Ep2MFuaJYOVkVqAk6U4xBtSi136Vi8/1LwUIrj/dMKE6
         Idi06Gvjg3EuGYFaWjO+l9DGUeZxaMCDGPH3jnjmm5X+76/ooxBcVwZzsamlyGoJrW8a
         YcxaA8fnYsgkQwCAlbLuuXq6unS6mV20AW4/sfQu7EnmcbelpOWe1D9fgypc2XfW+Rik
         rHg3l1KPinRS1EKfdcGPvU3S4Grtv9A9uKBipBJgjzmZI4qfbZF3bx0YJll/UlYy/YcJ
         4Xa194pWM5VCfClIg8wVx/CeN+nRfnrpAqeiRk1C9NwKGPhX4A7Zzrc9hVthTRprM0jZ
         CWyg==
X-Gm-Message-State: APjAAAUWKkTN1C752Vr22LA7HRZ1VQz6MthW6XkE9xpfVvCYoEihLAwT
        zDI6oYgRlcEkJwC+FbWeqVH6maUaYWQA+EJt4s5UveLjnsl9P2oHWh80LzKUDp3R0fM3KdFKrCE
        O2U3X3BLWYqjGhDJ2
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr3941764wme.105.1572511828435;
        Thu, 31 Oct 2019 01:50:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwvPYC9e4iat9DMt3LE/bE/MTEu4KvW4XDfLA0TcaVWv+5SInqiUM92ylKxl9P6mTld7eA/FA==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr3941733wme.105.1572511828065;
        Thu, 31 Oct 2019 01:50:28 -0700 (PDT)
Received: from steredhat ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id o25sm3585866wro.21.2019.10.31.01.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:50:27 -0700 (PDT)
Date:   Thu, 31 Oct 2019 09:50:25 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>,
        Dexuan Cui <decui@microsoft.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
 core
Message-ID: <20191031085025.qc2wb3zill2km72n@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-8-sgarzare@redhat.com>
 <MWHPR05MB337657F8FFE2C0BB4F90B261DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR05MB337657F8FFE2C0BB4F90B261DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:08:15PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Wednesday, October 23, 2019 11:56 AM
> > Subject: [PATCH net-next 07/14] vsock: handle buffer_size sockopts in the
> > core
> > 
> > virtio_transport and vmci_transport handle the buffer_size sockopts in a
> > very similar way.
> > 
> > In order to support multiple transports, this patch moves this handling in the
> > core to allow the user to change the options also if the socket is not yet
> > assigned to any transport.
> > 
> > This patch also adds the '.notify_buffer_size' callback in the 'struct
> > virtio_transport' in order to inform the transport, when the buffer_size is
> > changed by the user. It is also useful to limit the 'buffer_size' requested (e.g.
> > virtio transports).
> > 
> > Acked-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > RFC -> v1:
> > - changed .notify_buffer_size return to void (Stefan)
> > - documented that .notify_buffer_size is called with sk_lock held (Stefan)
> > ---
> >  drivers/vhost/vsock.c                   |  7 +-
> >  include/linux/virtio_vsock.h            | 15 +----
> >  include/net/af_vsock.h                  | 15 ++---
> >  net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
> >  net/vmw_vsock/hyperv_transport.c        | 36 -----------
> >  net/vmw_vsock/virtio_transport.c        |  8 +--
> >  net/vmw_vsock/virtio_transport_common.c | 79 ++++-------------------
> >  net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
> >  net/vmw_vsock/vmci_transport.h          |  3 -
> >  9 files changed, 65 insertions(+), 227 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c index
> > 92ab3852c954..6d7e4f022748 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -418,13 +418,8 @@ static struct virtio_transport vhost_transport = {
> >  		.notify_send_pre_block    =
> > virtio_transport_notify_send_pre_block,
> >  		.notify_send_pre_enqueue  =
> > virtio_transport_notify_send_pre_enqueue,
> >  		.notify_send_post_enqueue =
> > virtio_transport_notify_send_post_enqueue,
> > +		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> > 
> > -		.set_buffer_size          = virtio_transport_set_buffer_size,
> > -		.set_min_buffer_size      =
> > virtio_transport_set_min_buffer_size,
> > -		.set_max_buffer_size      =
> > virtio_transport_set_max_buffer_size,
> > -		.get_buffer_size          = virtio_transport_get_buffer_size,
> > -		.get_min_buffer_size      =
> > virtio_transport_get_min_buffer_size,
> > -		.get_max_buffer_size      =
> > virtio_transport_get_max_buffer_size,
> >  	},
> > 
> >  	.send_pkt = vhost_transport_send_pkt,
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h index
> > 96d8132acbd7..b79befd2a5a4 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -7,9 +7,6 @@
> >  #include <net/sock.h>
> >  #include <net/af_vsock.h>
> > 
> > -#define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
> > -#define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
> > -#define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
> >  #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> >  #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
> >  #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
> > @@ -25,11 +22,6 @@ enum {
> >  struct virtio_vsock_sock {
> >  	struct vsock_sock *vsk;
> > 
> > -	/* Protected by lock_sock(sk_vsock(trans->vsk)) */
> > -	u32 buf_size;
> > -	u32 buf_size_min;
> > -	u32 buf_size_max;
> > -
> >  	spinlock_t tx_lock;
> >  	spinlock_t rx_lock;
> > 
> > @@ -93,12 +85,6 @@ s64 virtio_transport_stream_has_space(struct
> > vsock_sock *vsk);
> > 
> >  int virtio_transport_do_socket_init(struct vsock_sock *vsk,
> >  				 struct vsock_sock *psk);
> > -u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk);
> > -u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk);
> > -u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk); -void
> > virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val); -void
> > virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val); -void
> > virtio_transport_set_max_buffer_size(struct vsock_sock *vs, u64 val);  int
> > virtio_transport_notify_poll_in(struct vsock_sock *vsk,
> >  				size_t target,
> > @@ -125,6 +111,7 @@ int
> > virtio_transport_notify_send_pre_enqueue(struct vsock_sock *vsk,
> >  	struct vsock_transport_send_notify_data *data);  int
> > virtio_transport_notify_send_post_enqueue(struct vsock_sock *vsk,
> >  	ssize_t written, struct vsock_transport_send_notify_data *data);
> > +void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64
> > +*val);
> > 
> >  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);  bool
> > virtio_transport_stream_is_active(struct vsock_sock *vsk); diff --git
> > a/include/net/af_vsock.h b/include/net/af_vsock.h index
> > 2ca67d048de4..4b5d16840fd4 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -65,6 +65,11 @@ struct vsock_sock {
> >  	bool sent_request;
> >  	bool ignore_connecting_rst;
> > 
> > +	/* Protected by lock_sock(sk) */
> > +	u64 buffer_size;
> > +	u64 buffer_min_size;
> > +	u64 buffer_max_size;
> > +
> >  	/* Private to transport. */
> >  	void *trans;
> >  };
> > @@ -140,18 +145,12 @@ struct vsock_transport {
> >  		struct vsock_transport_send_notify_data *);
> >  	int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
> >  		struct vsock_transport_send_notify_data *);
> > +	/* sk_lock held by the caller */
> > +	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> > 
> >  	/* Shutdown. */
> >  	int (*shutdown)(struct vsock_sock *, int);
> > 
> > -	/* Buffer sizes. */
> > -	void (*set_buffer_size)(struct vsock_sock *, u64);
> > -	void (*set_min_buffer_size)(struct vsock_sock *, u64);
> > -	void (*set_max_buffer_size)(struct vsock_sock *, u64);
> > -	u64 (*get_buffer_size)(struct vsock_sock *);
> > -	u64 (*get_min_buffer_size)(struct vsock_sock *);
> > -	u64 (*get_max_buffer_size)(struct vsock_sock *);
> > -
> >  	/* Addressing. */
> >  	u32 (*get_local_cid)(void);
> >  };
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> > eaea159006c8..90ac46ea12ef 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -126,6 +126,10 @@ static struct proto vsock_proto = {
> >   */
> >  #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
> > 
> > +#define VSOCK_DEFAULT_BUFFER_SIZE     (1024 * 256)
> > +#define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256) #define
> > +VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
> > +
> >  static const struct vsock_transport *transport_single;  static
> > DEFINE_MUTEX(vsock_register_mutex);
> > 
> > @@ -613,10 +617,16 @@ struct sock *__vsock_create(struct net *net,
> >  		vsk->trusted = psk->trusted;
> >  		vsk->owner = get_cred(psk->owner);
> >  		vsk->connect_timeout = psk->connect_timeout;
> > +		vsk->buffer_size = psk->buffer_size;
> > +		vsk->buffer_min_size = psk->buffer_min_size;
> > +		vsk->buffer_max_size = psk->buffer_max_size;
> >  	} else {
> >  		vsk->trusted = capable(CAP_NET_ADMIN);
> >  		vsk->owner = get_current_cred();
> >  		vsk->connect_timeout =
> > VSOCK_DEFAULT_CONNECT_TIMEOUT;
> > +		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
> > +		vsk->buffer_min_size =
> > VSOCK_DEFAULT_BUFFER_MIN_SIZE;
> > +		vsk->buffer_max_size =
> > VSOCK_DEFAULT_BUFFER_MAX_SIZE;
> >  	}
> > 
> >  	if (vsk->transport->init(vsk, psk) < 0) { @@ -1368,6 +1378,23 @@
> > static int vsock_listen(struct socket *sock, int backlog)
> >  	return err;
> >  }
> > 
> > +static void vsock_update_buffer_size(struct vsock_sock *vsk,
> > +				     const struct vsock_transport *transport,
> > +				     u64 val)
> > +{
> > +	if (val > vsk->buffer_max_size)
> > +		val = vsk->buffer_max_size;
> > +
> > +	if (val < vsk->buffer_min_size)
> > +		val = vsk->buffer_min_size;
> > +
> > +	if (val != vsk->buffer_size &&
> > +	    transport && transport->notify_buffer_size)
> > +		transport->notify_buffer_size(vsk, &val);
> > +
> > +	vsk->buffer_size = val;
> > +}
> > +
> >  static int vsock_stream_setsockopt(struct socket *sock,
> >  				   int level,
> >  				   int optname,
> > @@ -1405,17 +1432,19 @@ static int vsock_stream_setsockopt(struct socket
> > *sock,
> >  	switch (optname) {
> >  	case SO_VM_SOCKETS_BUFFER_SIZE:
> >  		COPY_IN(val);
> > -		transport->set_buffer_size(vsk, val);
> > +		vsock_update_buffer_size(vsk, transport, val);
> >  		break;
> > 
> >  	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
> >  		COPY_IN(val);
> > -		transport->set_max_buffer_size(vsk, val);
> > +		vsk->buffer_max_size = val;
> > +		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
> >  		break;
> > 
> >  	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
> >  		COPY_IN(val);
> > -		transport->set_min_buffer_size(vsk, val);
> > +		vsk->buffer_min_size = val;
> > +		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
> >  		break;
> > 
> >  	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
> > @@ -1456,7 +1485,6 @@ static int vsock_stream_getsockopt(struct socket
> > *sock,
> >  	int len;
> >  	struct sock *sk;
> >  	struct vsock_sock *vsk;
> > -	const struct vsock_transport *transport;
> >  	u64 val;
> > 
> >  	if (level != AF_VSOCK)
> > @@ -1480,21 +1508,20 @@ static int vsock_stream_getsockopt(struct socket
> > *sock,
> >  	err = 0;
> >  	sk = sock->sk;
> >  	vsk = vsock_sk(sk);
> > -	transport = vsk->transport;
> > 
> >  	switch (optname) {
> >  	case SO_VM_SOCKETS_BUFFER_SIZE:
> > -		val = transport->get_buffer_size(vsk);
> > +		val = vsk->buffer_size;
> >  		COPY_OUT(val);
> >  		break;
> > 
> >  	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
> > -		val = transport->get_max_buffer_size(vsk);
> > +		val = vsk->buffer_max_size;
> >  		COPY_OUT(val);
> >  		break;
> > 
> >  	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
> > -		val = transport->get_min_buffer_size(vsk);
> > +		val = vsk->buffer_min_size;
> >  		COPY_OUT(val);
> >  		break;
> > 
> > diff --git a/net/vmw_vsock/hyperv_transport.c
> > b/net/vmw_vsock/hyperv_transport.c
> > index bef8772116ec..d62297a62ca6 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -845,36 +845,6 @@ int hvs_notify_send_post_enqueue(struct
> > vsock_sock *vsk, ssize_t written,
> >  	return 0;
> >  }
> > 
> > -static void hvs_set_buffer_size(struct vsock_sock *vsk, u64 val) -{
> > -	/* Ignored. */
> > -}
> > -
> > -static void hvs_set_min_buffer_size(struct vsock_sock *vsk, u64 val) -{
> > -	/* Ignored. */
> > -}
> > -
> > -static void hvs_set_max_buffer_size(struct vsock_sock *vsk, u64 val) -{
> > -	/* Ignored. */
> > -}
> > -
> > -static u64 hvs_get_buffer_size(struct vsock_sock *vsk) -{
> > -	return -ENOPROTOOPT;
> > -}
> > -
> > -static u64 hvs_get_min_buffer_size(struct vsock_sock *vsk) -{
> > -	return -ENOPROTOOPT;
> > -}
> > -
> > -static u64 hvs_get_max_buffer_size(struct vsock_sock *vsk) -{
> > -	return -ENOPROTOOPT;
> > -}
> > -
> >  static struct vsock_transport hvs_transport = {
> >  	.get_local_cid            = hvs_get_local_cid,
> > 
> > @@ -908,12 +878,6 @@ static struct vsock_transport hvs_transport = {
> >  	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
> >  	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
> > 
> > -	.set_buffer_size          = hvs_set_buffer_size,
> > -	.set_min_buffer_size      = hvs_set_min_buffer_size,
> > -	.set_max_buffer_size      = hvs_set_max_buffer_size,
> > -	.get_buffer_size          = hvs_get_buffer_size,
> > -	.get_min_buffer_size      = hvs_get_min_buffer_size,
> > -	.get_max_buffer_size      = hvs_get_max_buffer_size,
> >  };
> > 
> >  static int hvs_probe(struct hv_device *hdev, diff --git
> > a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index 3756f0857946..fb1fc7760e8c 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -494,13 +494,7 @@ static struct virtio_transport virtio_transport = {
> >  		.notify_send_pre_block    =
> > virtio_transport_notify_send_pre_block,
> >  		.notify_send_pre_enqueue  =
> > virtio_transport_notify_send_pre_enqueue,
> >  		.notify_send_post_enqueue =
> > virtio_transport_notify_send_post_enqueue,
> > -
> > -		.set_buffer_size          = virtio_transport_set_buffer_size,
> > -		.set_min_buffer_size      =
> > virtio_transport_set_min_buffer_size,
> > -		.set_max_buffer_size      =
> > virtio_transport_set_max_buffer_size,
> > -		.get_buffer_size          = virtio_transport_get_buffer_size,
> > -		.get_min_buffer_size      =
> > virtio_transport_get_min_buffer_size,
> > -		.get_max_buffer_size      =
> > virtio_transport_get_max_buffer_size,
> > +		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> >  	},
> > 
> >  	.send_pkt = virtio_transport_send_pkt, diff --git
> > a/net/vmw_vsock/virtio_transport_common.c
> > b/net/vmw_vsock/virtio_transport_common.c
> > index 37a1c7e7c7fe..b2a310dfa158 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -456,17 +456,13 @@ int virtio_transport_do_socket_init(struct
> > vsock_sock *vsk,
> >  	if (psk) {
> >  		struct virtio_vsock_sock *ptrans = psk->trans;
> > 
> > -		vvs->buf_size	= ptrans->buf_size;
> > -		vvs->buf_size_min = ptrans->buf_size_min;
> > -		vvs->buf_size_max = ptrans->buf_size_max;
> >  		vvs->peer_buf_alloc = ptrans->peer_buf_alloc;
> > -	} else {
> > -		vvs->buf_size = VIRTIO_VSOCK_DEFAULT_BUF_SIZE;
> > -		vvs->buf_size_min =
> > VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE;
> > -		vvs->buf_size_max =
> > VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE;
> >  	}
> > 
> > -	vvs->buf_alloc = vvs->buf_size;
> > +	if (vsk->buffer_size > VIRTIO_VSOCK_MAX_BUF_SIZE)
> > +		vsk->buffer_size = VIRTIO_VSOCK_MAX_BUF_SIZE;
> > +
> > +	vvs->buf_alloc = vsk->buffer_size;
> > 
> >  	spin_lock_init(&vvs->rx_lock);
> >  	spin_lock_init(&vvs->tx_lock);
> > @@ -476,71 +472,20 @@ int virtio_transport_do_socket_init(struct
> > vsock_sock *vsk,  }  EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
> > 
> > -u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk) -{
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > -
> > -	return vvs->buf_size;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_get_buffer_size);
> > -
> > -u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk)
> > +/* sk_lock held by the caller */
> > +void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64
> > +*val)
> >  {
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > 
> > -	return vvs->buf_size_min;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_get_min_buffer_size);
> > -
> > -u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk) -{
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > -
> > -	return vvs->buf_size_max;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_get_max_buffer_size);
> > -
> > -void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val) -{
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > +	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> > +		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
> > 
> > -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> > -		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
> > -	if (val < vvs->buf_size_min)
> > -		vvs->buf_size_min = val;
> > -	if (val > vvs->buf_size_max)
> > -		vvs->buf_size_max = val;
> > -	vvs->buf_size = val;
> > -	vvs->buf_alloc = val;
> > +	vvs->buf_alloc = *val;
> > 
> >  	virtio_transport_send_credit_update(vsk,
> > VIRTIO_VSOCK_TYPE_STREAM,
> >  					    NULL);
> >  }
> > -EXPORT_SYMBOL_GPL(virtio_transport_set_buffer_size);
> > -
> > -void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
> > -{
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > -
> > -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> > -		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
> > -	if (val > vvs->buf_size)
> > -		vvs->buf_size = val;
> > -	vvs->buf_size_min = val;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_set_min_buffer_size);
> > -
> > -void virtio_transport_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
> > -{
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > -
> > -	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
> > -		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
> > -	if (val < vvs->buf_size)
> > -		vvs->buf_size = val;
> > -	vvs->buf_size_max = val;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_set_max_buffer_size);
> > +EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
> > 
> >  int
> >  virtio_transport_notify_poll_in(struct vsock_sock *vsk, @@ -632,9 +577,7
> > @@ EXPORT_SYMBOL_GPL(virtio_transport_notify_send_post_enqueue);
> > 
> >  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk)  {
> > -	struct virtio_vsock_sock *vvs = vsk->trans;
> > -
> > -	return vvs->buf_size;
> > +	return vsk->buffer_size;
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_stream_rcvhiwat);
> 
> While the VMCI transport uses a transport local consumer_size for stream_rcvhiwat,
> that consumer_size is always the same as buffer_size (a vmci queue pair allows the
> producer and consumer queues to be of different sizes, but vsock doesn't use that).
> So we could move the stream_rcvhiwat code to the common code as well, and just
> use buffer_size, if that simplifies things.
> 

Thanks to let me know. It could be another step to clean up the
transports. I'm only worried about hyperv_transport, because it returns
HVS_MTU_SIZE + 1.

@Dexuan Do you have any advice?


> > diff --git a/net/vmw_vsock/vmci_transport.c
> > b/net/vmw_vsock/vmci_transport.c index f8e3131ac480..8290d37b6587
> > 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -74,10 +74,6 @@ static u32 vmci_transport_qp_resumed_sub_id =
> > VMCI_INVALID_ID;
> > 
> >  static int PROTOCOL_OVERRIDE = -1;
> > 
> > -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN   128
> > -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
> > -#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
> > -
> >  /* Helper function to convert from a VMCI error code to a VSock error code.
> > */
> > 
> >  static s32 vmci_transport_error_to_vsock_error(s32 vmci_error) @@ -
> > 1025,11 +1021,11 @@ static int vmci_transport_recv_listen(struct sock *sk,
> >  	/* If the proposed size fits within our min/max, accept it. Otherwise
> >  	 * propose our own size.
> >  	 */
> > -	if (pkt->u.size >= vmci_trans(vpending)->queue_pair_min_size &&
> > -	    pkt->u.size <= vmci_trans(vpending)->queue_pair_max_size) {
> > +	if (pkt->u.size >= vpending->buffer_min_size &&
> > +	    pkt->u.size <= vpending->buffer_max_size) {
> >  		qp_size = pkt->u.size;
> >  	} else {
> > -		qp_size = vmci_trans(vpending)->queue_pair_size;
> > +		qp_size = vpending->buffer_size;
> >  	}
> > 
> >  	/* Figure out if we are using old or new requests based on the @@ -
> > 1098,7 +1094,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
> >  	pending->sk_state = TCP_SYN_SENT;
> >  	vmci_trans(vpending)->produce_size =
> >  		vmci_trans(vpending)->consume_size = qp_size;
> > -	vmci_trans(vpending)->queue_pair_size = qp_size;
> > +	vpending->buffer_size = qp_size;
> > 
> >  	vmci_trans(vpending)->notify_ops->process_request(pending);
> > 
> > @@ -1392,8 +1388,8 @@ static int
> > vmci_transport_recv_connecting_client_negotiate(
> >  	vsk->ignore_connecting_rst = false;
> > 
> >  	/* Verify that we're OK with the proposed queue pair size */
> > -	if (pkt->u.size < vmci_trans(vsk)->queue_pair_min_size ||
> > -	    pkt->u.size > vmci_trans(vsk)->queue_pair_max_size) {
> > +	if (pkt->u.size < vsk->buffer_min_size ||
> > +	    pkt->u.size > vsk->buffer_max_size) {
> >  		err = -EINVAL;
> >  		goto destroy;
> >  	}
> > @@ -1498,8 +1494,7 @@
> > vmci_transport_recv_connecting_client_invalid(struct sock *sk,
> >  		vsk->sent_request = false;
> >  		vsk->ignore_connecting_rst = true;
> > 
> > -		err = vmci_transport_send_conn_request(
> > -			sk, vmci_trans(vsk)->queue_pair_size);
> > +		err = vmci_transport_send_conn_request(sk, vsk-
> > >buffer_size);
> >  		if (err < 0)
> >  			err = vmci_transport_error_to_vsock_error(err);
> >  		else
> > @@ -1583,21 +1578,6 @@ static int vmci_transport_socket_init(struct
> > vsock_sock *vsk,
> >  	INIT_LIST_HEAD(&vmci_trans(vsk)->elem);
> >  	vmci_trans(vsk)->sk = &vsk->sk;
> >  	spin_lock_init(&vmci_trans(vsk)->lock);
> > -	if (psk) {
> > -		vmci_trans(vsk)->queue_pair_size =
> > -			vmci_trans(psk)->queue_pair_size;
> > -		vmci_trans(vsk)->queue_pair_min_size =
> > -			vmci_trans(psk)->queue_pair_min_size;
> > -		vmci_trans(vsk)->queue_pair_max_size =
> > -			vmci_trans(psk)->queue_pair_max_size;
> > -	} else {
> > -		vmci_trans(vsk)->queue_pair_size =
> > -			VMCI_TRANSPORT_DEFAULT_QP_SIZE;
> > -		vmci_trans(vsk)->queue_pair_min_size =
> > -			 VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN;
> > -		vmci_trans(vsk)->queue_pair_max_size =
> > -			VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX;
> > -	}
> > 
> >  	return 0;
> >  }
> > @@ -1813,8 +1793,7 @@ static int vmci_transport_connect(struct
> > vsock_sock *vsk)
> > 
> >  	if (vmci_transport_old_proto_override(&old_pkt_proto) &&
> >  		old_pkt_proto) {
> > -		err = vmci_transport_send_conn_request(
> > -			sk, vmci_trans(vsk)->queue_pair_size);
> > +		err = vmci_transport_send_conn_request(sk, vsk-
> > >buffer_size);
> >  		if (err < 0) {
> >  			sk->sk_state = TCP_CLOSE;
> >  			return err;
> > @@ -1822,8 +1801,7 @@ static int vmci_transport_connect(struct
> > vsock_sock *vsk)
> >  	} else {
> >  		int supported_proto_versions =
> >  			vmci_transport_new_proto_supported_versions();
> > -		err = vmci_transport_send_conn_request2(
> > -				sk, vmci_trans(vsk)->queue_pair_size,
> > +		err = vmci_transport_send_conn_request2(sk, vsk-
> > >buffer_size,
> >  				supported_proto_versions);
> >  		if (err < 0) {
> >  			sk->sk_state = TCP_CLOSE;
> > @@ -1876,46 +1854,6 @@ static bool
> > vmci_transport_stream_is_active(struct vsock_sock *vsk)
> >  	return !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle);
> >  }
> > 
> > -static u64 vmci_transport_get_buffer_size(struct vsock_sock *vsk) -{
> > -	return vmci_trans(vsk)->queue_pair_size;
> > -}
> > -
> > -static u64 vmci_transport_get_min_buffer_size(struct vsock_sock *vsk) -{
> > -	return vmci_trans(vsk)->queue_pair_min_size;
> > -}
> > -
> > -static u64 vmci_transport_get_max_buffer_size(struct vsock_sock *vsk) -{
> > -	return vmci_trans(vsk)->queue_pair_max_size;
> > -}
> > -
> > -static void vmci_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
> > -{
> > -	if (val < vmci_trans(vsk)->queue_pair_min_size)
> > -		vmci_trans(vsk)->queue_pair_min_size = val;
> > -	if (val > vmci_trans(vsk)->queue_pair_max_size)
> > -		vmci_trans(vsk)->queue_pair_max_size = val;
> > -	vmci_trans(vsk)->queue_pair_size = val;
> > -}
> > -
> > -static void vmci_transport_set_min_buffer_size(struct vsock_sock *vsk,
> > -					       u64 val)
> > -{
> > -	if (val > vmci_trans(vsk)->queue_pair_size)
> > -		vmci_trans(vsk)->queue_pair_size = val;
> > -	vmci_trans(vsk)->queue_pair_min_size = val;
> > -}
> > -
> > -static void vmci_transport_set_max_buffer_size(struct vsock_sock *vsk,
> > -					       u64 val)
> > -{
> > -	if (val < vmci_trans(vsk)->queue_pair_size)
> > -		vmci_trans(vsk)->queue_pair_size = val;
> > -	vmci_trans(vsk)->queue_pair_max_size = val;
> > -}
> > -
> >  static int vmci_transport_notify_poll_in(
> >  	struct vsock_sock *vsk,
> >  	size_t target,
> > @@ -2098,12 +2036,6 @@ static const struct vsock_transport vmci_transport
> > = {
> >  	.notify_send_pre_enqueue =
> > vmci_transport_notify_send_pre_enqueue,
> >  	.notify_send_post_enqueue =
> > vmci_transport_notify_send_post_enqueue,
> >  	.shutdown = vmci_transport_shutdown,
> > -	.set_buffer_size = vmci_transport_set_buffer_size,
> > -	.set_min_buffer_size = vmci_transport_set_min_buffer_size,
> > -	.set_max_buffer_size = vmci_transport_set_max_buffer_size,
> > -	.get_buffer_size = vmci_transport_get_buffer_size,
> > -	.get_min_buffer_size = vmci_transport_get_min_buffer_size,
> > -	.get_max_buffer_size = vmci_transport_get_max_buffer_size,
> >  	.get_local_cid = vmci_transport_get_local_cid,  };
> > 
> > diff --git a/net/vmw_vsock/vmci_transport.h
> > b/net/vmw_vsock/vmci_transport.h index 1ca1e8640b31..b7b072194282
> > 100644
> > --- a/net/vmw_vsock/vmci_transport.h
> > +++ b/net/vmw_vsock/vmci_transport.h
> > @@ -108,9 +108,6 @@ struct vmci_transport {
> >  	struct vmci_qp *qpair;
> >  	u64 produce_size;
> >  	u64 consume_size;
> > -	u64 queue_pair_size;
> > -	u64 queue_pair_min_size;
> > -	u64 queue_pair_max_size;
> >  	u32 detach_sub_id;
> >  	union vmci_transport_notify notify;
> >  	const struct vmci_transport_notify_ops *notify_ops;
> > --
> > 2.21.0
> 
> Reviewed-by: Jorgen Hansen <jhansen@vmware.com>

Thanks for the reviews,
Stefano
