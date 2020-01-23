Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C58146374
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAWI1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:27:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgAWI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 03:27:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579768018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j3nJpNmmA8VPPXFQnXMF+G3MHJxAdA6R8eprK3mEFYk=;
        b=BWxy02gVy6mxF1CLfjd0RtkZMygwDVm1C4bnJEfBvOL8LBED8sJWDeTKZEOFIyDJqJ82EI
        eFJiEWRWL1dfaoKVPHnTboduVeLQqUyzNTuOQiKDGQI4XAS45e8a45VtHm2MBzAFznH8xn
        99fgRE/1bhvU7oP4jE6OpbzcNkgLsZk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-4E0_WHm4PkiiLYpkjJqNCg-1; Thu, 23 Jan 2020 03:26:57 -0500
X-MC-Unique: 4E0_WHm4PkiiLYpkjJqNCg-1
Received: by mail-wr1-f69.google.com with SMTP id h30so1386566wrh.5
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 00:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3nJpNmmA8VPPXFQnXMF+G3MHJxAdA6R8eprK3mEFYk=;
        b=K2QCZsnzJbOY7wTJ3Vts7OVOfx+LJzeVzrro3sgXv11njV2AlubxoZOyEp/XB7V2Ar
         Hg9L5kZpDZDeFk6wap7kRnOVD0/vbYzrsBHo/+a+eop2zlTqDZ8nJLWLaDeq73A8+6B5
         5qBxMAViQGfvxL6EzI9ys+ENlaWTDxKiKik9kkrAE35/v8QAzSbfvW0BIPjLKNBt3SIY
         pqxBUupdoPeI0GgnYwH9WgvRwP+qbW32qXP9jIruYXKVCUUWHAI5mpkrMFcMn/lR+q9N
         3gYKlLMkDq8VQui472ViJxb01c1eaAYrn5MeS/QsWxXD5UEQ1YHU5xmL+3xeqWl8p9bF
         pd4A==
X-Gm-Message-State: APjAAAWT732n/Pqr7pipovBw6vAhNKnmd+UI/SF29Avi5LOrsFrbr4mZ
        IqjFAk21rtqamSqcDS5HoVBhQqEWQfnh95TtpZTGrsQhicZqftK2iUTLyctzbVomeiF5BIVrAT/
        9vPvoFDULR0oVYPDs
X-Received: by 2002:a05:600c:d6:: with SMTP id u22mr2877447wmm.77.1579768015600;
        Thu, 23 Jan 2020 00:26:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxoH+iCs3AMSckyJdphf85pu3qwslE9ZLQVktvHxbB9U8UZwLcn0Lz7M6oNvkeUCa0AV7nzg==
X-Received: by 2002:a05:600c:d6:: with SMTP id u22mr2877409wmm.77.1579768015297;
        Thu, 23 Jan 2020 00:26:55 -0800 (PST)
Received: from redhat.com (bzq-79-176-0-156.red.bezeqint.net. [79.176.0.156])
        by smtp.gmail.com with ESMTPSA id f12sm1730443wmf.28.2020.01.23.00.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 00:26:54 -0800 (PST)
Date:   Thu, 23 Jan 2020 03:26:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, jbrouer@redhat.com, toke@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH bpf-next 07/12] vhost_net: user tap recvmsg api to access
 ptr ring
Message-ID: <20200123030712-mutt-send-email-mst@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-8-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123014210.38412-8-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 06:42:05PM -0700, David Ahern wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
> 
> Currently vhost_net directly accesses ptr ring of tap driver to
> fetch Rx packet pointers. In order to avoid it this patch modifies
> tap driver's recvmsg api to do additional task of fetching Rx packet
> pointers.
> 
> A special struct tun_msg_ctl is already being passed via msg_control
> for tun Rx XDP batching. This patch extends tun_msg_ctl usage to
> send sub commands to recvmsg api. Now tun_recvmsg will handle commands
> to consume and unconsume packet pointers from ptr ring.
> 
> This will be useful in implementation of tx path XDP in tun driver,
> where XDP program will process the packet before it is passed to
> vhost_net.
> 
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  drivers/net/tap.c      | 22 ++++++++++++++++++-
>  drivers/net/tun.c      | 24 ++++++++++++++++++++-
>  drivers/vhost/net.c    | 48 +++++++++++++++++++++++++++++++-----------
>  include/linux/if_tun.h | 18 ++++++++++++++++
>  4 files changed, 98 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index a0a5dc18109a..a5ce44db11a3 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1224,8 +1224,28 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
>  		       size_t total_len, int flags)
>  {
>  	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
> -	struct sk_buff *skb = m->msg_control;
> +	struct tun_msg_ctl *ctl = m->msg_control;
> +	struct sk_buff *skb = NULL;
>  	int ret;
> +
> +	if (ctl) {
> +		switch (ctl->type) {
> +		case TUN_MSG_PKT:
> +			skb = ctl->ptr;
> +			break;
> +		case TUN_MSG_CONSUME_PKTS:
> +			return ptr_ring_consume_batched(&q->ring,
> +							ctl->ptr,
> +							ctl->num);
> +		case TUN_MSG_UNCONSUME_PKTS:
> +			ptr_ring_unconsume(&q->ring, ctl->ptr, ctl->num,
> +					   tun_ptr_free);
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
>  	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
>  		kfree_skb(skb);
>  		return -EINVAL;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 6f12c32df346..197bde748c09 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2544,7 +2544,8 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,

Hmm what about tap_recvmsg then?

>  {
>  	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
>  	struct tun_struct *tun = tun_get(tfile);
> -	void *ptr = m->msg_control;
> +	struct tun_msg_ctl *ctl = m->msg_control;
> +	void *ptr = NULL;
>  	int ret;
>  
>  	if (!tun) {
> @@ -2552,6 +2553,27 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>  		goto out_free;
>  	}
>  

there's an extra tun_get/tun_put above.
Do we need them?
And if yes isn't  tun_ptr_free(ptr) on error a problem?



> +	if (ctl) {
> +		switch (ctl->type) {
> +		case TUN_MSG_PKT:
> +			ptr = ctl->ptr;
> +			break;
> +		case TUN_MSG_CONSUME_PKTS:
> +			ret = ptr_ring_consume_batched(&tfile->tx_ring,
> +						       ctl->ptr,
> +						       ctl->num);
> +			goto out;
> +		case TUN_MSG_UNCONSUME_PKTS:
> +			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr,
> +					   ctl->num, tun_ptr_free);
> +			ret = 0;
> +			goto out;
> +		default:
> +			ret = -EINVAL;
> +			goto out_put_tun;
> +		}
> +	}
> +
>  	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC|MSG_ERRQUEUE)) {
>  		ret = -EINVAL;
>  		goto out_put_tun;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e158159671fa..482548d00105 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -175,24 +175,44 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
>  
>  static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
>  {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	struct socket *sock = vq->private_data;
>  	struct vhost_net_buf *rxq = &nvq->rxq;
> +	struct tun_msg_ctl ctl = {
> +		.type = TUN_MSG_CONSUME_PKTS,
> +		.ptr = (void *) rxq->queue,
> +		.num = VHOST_NET_BATCH,
> +	};
> +	struct msghdr msg = {
> +		.msg_control = &ctl,
> +	};
>  
>  	rxq->head = 0;
> -	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
> -					      VHOST_NET_BATCH);
> +	rxq->tail = sock->ops->recvmsg(sock, &msg, 0, 0);
> +	if (WARN_ON_ONCE(rxq->tail < 0))
> +		rxq->tail = 0;
> +
>  	return rxq->tail;
>  }

Hmm isn't there a way to avoid an indirect call here on data path?
ptr ring is a tun/tap thing anyway ...

>  
>  static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
>  {
> +	struct vhost_virtqueue *vq = &nvq->vq;
> +	struct socket *sock = vq->private_data;
>  	struct vhost_net_buf *rxq = &nvq->rxq;
> +	struct tun_msg_ctl ctl = {
> +		.type = TUN_MSG_UNCONSUME_PKTS,
> +		.ptr = (void *) (rxq->queue + rxq->head),

You don't really need to cast to void. An assignment will do.

> +		.num = vhost_net_buf_get_size(rxq),
> +	};
> +	struct msghdr msg = {
> +		.msg_control = &ctl,
> +	};
>  
> -	if (nvq->rx_ring && !vhost_net_buf_is_empty(rxq)) {
> -		ptr_ring_unconsume(nvq->rx_ring, rxq->queue + rxq->head,
> -				   vhost_net_buf_get_size(rxq),
> -				   tun_ptr_free);
> -		rxq->head = rxq->tail = 0;
> -	}
> +	if (!vhost_net_buf_is_empty(rxq))
> +		sock->ops->recvmsg(sock, &msg, 0, 0);
> +
> +	rxq->head = rxq->tail = 0;
>  }
>  
>  static int vhost_net_buf_peek_len(void *ptr)
> @@ -1109,6 +1129,7 @@ static void handle_rx(struct vhost_net *net)
>  		.flags = 0,
>  		.gso_type = VIRTIO_NET_HDR_GSO_NONE
>  	};
> +	struct tun_msg_ctl ctl;
>  	size_t total_len = 0;
>  	int err, mergeable;
>  	s16 headcount;
> @@ -1166,8 +1187,11 @@ static void handle_rx(struct vhost_net *net)
>  			goto out;
>  		}
>  		busyloop_intr = false;
> -		if (nvq->rx_ring)
> -			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
> +		if (nvq->rx_ring) {
> +			ctl.type = TUN_MSG_PKT;
> +			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
> +			msg.msg_control = &ctl;
> +		}
>  		/* On overrun, truncate and discard */
>  		if (unlikely(headcount > UIO_MAXIOV)) {
>  			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
> @@ -1346,8 +1370,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
>  	mutex_lock(&vq->mutex);
>  	sock = vq->private_data;
>  	vhost_net_disable_vq(n, vq);
> -	vq->private_data = NULL;
>  	vhost_net_buf_unproduce(nvq);
> +	vq->private_data = NULL;
>  	nvq->rx_ring = NULL;


So is rx_ring still in use?

>  	mutex_unlock(&vq->mutex);
>  	return sock;
> @@ -1538,8 +1562,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  		}
>  
>  		vhost_net_disable_vq(n, vq);
> -		vq->private_data = sock;
>  		vhost_net_buf_unproduce(nvq);
> +		vq->private_data = sock;
>  		r = vhost_vq_init_access(vq);
>  		if (r)
>  			goto err_used;
> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> index 49ca20063a35..9184e3f177b8 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -12,8 +12,26 @@
>  
>  #define TUN_XDP_FLAG 0x1UL
>  
> +/*
> + * tun_msg_ctl types
> + */
> +
>  #define TUN_MSG_UBUF 1
>  #define TUN_MSG_PTR  2
> +/*
> + * Used for passing a packet pointer from vhost to tun
> + */
> +#define TUN_MSG_PKT  3
> +/*
> + * Used for passing an array of pointer from vhost to tun.
> + * tun consumes packets from ptr ring and stores in pointer array.
> + */
> +#define TUN_MSG_CONSUME_PKTS    4
> +/*
> + * Used for passing an array of pointer from vhost to tun.
> + * tun consumes get pointer from array and puts back into ptr ring.
> + */
> +#define TUN_MSG_UNCONSUME_PKTS  5
>  struct tun_msg_ctl {
>  	unsigned short type;
>  	unsigned short num;
> -- 
> 2.21.1 (Apple Git-122.3)

