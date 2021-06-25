Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2159C3B3BE2
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 07:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFYFDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 01:03:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhFYFDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 01:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624597251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23iN2wKrRLlY7gWDFSjG07fB7tAE9PbI7cypAA1XICE=;
        b=WsnPfacUxYsFGiRchHFo9kAwmDkEUPbULjEkh2oLtkOoDD+RoHqy0bNRRbLhRnMLfu1amh
        dbaSodPyyy+3gTyFWgVgZjTF4Y+Ji+q1ET3IkTlVaEsPH0Qv+M8FqUpv0KSVSpB79rNwK4
        C1VwqZ1TVQW3ygeKyRBjWMVr0YFzbbg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-7p6DICtYN1y7IqYOpRcMzg-1; Fri, 25 Jun 2021 01:00:49 -0400
X-MC-Unique: 7p6DICtYN1y7IqYOpRcMzg-1
Received: by mail-pl1-f197.google.com with SMTP id p8-20020a1709028a88b029011c6ee150f3so3130229plo.1
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 22:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=23iN2wKrRLlY7gWDFSjG07fB7tAE9PbI7cypAA1XICE=;
        b=A/zvOzAhG9mZJM7evweAGx4Q3Mr9N/HaV8fghzPk5GXuD/ecJTBv2aw7BsRSwYSUSm
         bU/1z+hoKo6ZjkxK8KWBGBdI6rKGBRm7BvFxD3Ds8hcb+jlg2tF0vMMLlOa6EcxI/eap
         hBizgRn7IQkZKJk98rO/ViTqZw2Z3MN0EYgbyocrD5olfy8nDP5ibLtBxSg3T7MO0sgg
         wCO+cG4wKjUsRkmgcJSHgrDWlS/aq4qea6DTLrNBrKr6jaM+BqlSubZ+Sa2Ov3ygdIxJ
         xkhwjGPjcLVEw/JhVFHVuIEQiWvxGpqRgBr24H6Rspvzlv7sVkOIZww4i+S3flJ+a+aL
         w4mg==
X-Gm-Message-State: AOAM531z5CVg8PWFIxpWezxUz0B7jpOL8R70c65WgSTLH34nkcXIuPy6
        +vq5XoK2F/IFIHQyuGcWPZWHkL8zk79+4K55VWE/SOnyya6Kdx2kfcUFDQngLoacX4f0oZJGwLK
        RlQ3qghEKj2Nnocbv
X-Received: by 2002:a17:902:6e02:b029:128:977c:217d with SMTP id u2-20020a1709026e02b0290128977c217dmr1499819plk.44.1624597248127;
        Thu, 24 Jun 2021 22:00:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWQcUxvGOc5aTP+hAIo4L3yHh9DrMXmUKQwzq1+5vXkMrFGTbyDKd8i6EaJiNK4b52cHE73w==
X-Received: by 2002:a17:902:6e02:b029:128:977c:217d with SMTP id u2-20020a1709026e02b0290128977c217dmr1499801plk.44.1624597247877;
        Thu, 24 Jun 2021 22:00:47 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 133sm2245670pfx.39.2021.06.24.22.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 22:00:47 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] net: add header len parameter to tun_get_socket(),
 tap_get_socket()
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8bc0d9b7-b3d8-ddbb-bcdc-e0169fac7111@redhat.com>
Date:   Fri, 25 Jun 2021 13:00:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624123005.1301761-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/24 ÏÂÎç8:30, David Woodhouse Ð´µÀ:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The vhost-net driver was making wild assumptions about the header length
> of the underlying tun/tap socket.


It's by design to depend on the userspace to co-ordinate the vnet header 
setting with the underlying sockets.


>   Then it was discarding packets if
> the number of bytes it got from sock_recvmsg() didn't precisely match
> its guess.


Anything that is broken by this? The failure is a hint for the userspace 
that something is wrong during the coordination.


>
> Fix it to get the correct information along with the socket itself.


I'm not sure what is fixed by this. It looks to me it tires to let 
packet go even if the userspace set the wrong attributes to tap or 
vhost. This is even sub-optimal than failing explicitly fail the RX.


> As a side-effect, this means that tun_get_socket() won't work if the
> tun file isn't actually connected to a device, since there's no 'tun'
> yet in that case to get the information from.


This may break the existing application. Vhost-net is tied to the socket 
instead of the device that the socket is loosely coupled.


>
> On the receive side, where the tun device generates the virtio_net_hdr
> but VIRITO_NET_F_MSG_RXBUF was negotiated and vhost-net needs to fill
> in the 'num_buffers' field on top of the existing virtio_net_hdr, fix
> that to use 'sock_hlen - 2' as the location, which means that it goes
> in the right place regardless of whether the tun device is using an
> additional tun_pi header or not. In this case, the user should have
> configured the tun device with a vnet hdr size of 12, to make room.
>
> Fixes: 8dd014adfea6f ("vhost-net: mergeable buffers support")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   drivers/net/tap.c      |  5 ++++-
>   drivers/net/tun.c      | 16 +++++++++++++++-
>   drivers/vhost/net.c    | 31 +++++++++++++++----------------
>   include/linux/if_tap.h |  4 ++--
>   include/linux/if_tun.h |  4 ++--
>   5 files changed, 38 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..2170a0d3d34c 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1246,7 +1246,7 @@ static const struct proto_ops tap_socket_ops = {
>    * attached to a device.  The returned object works like a packet socket, it
>    * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible for
>    * holding a reference to the file for as long as the socket is in use. */
> -struct socket *tap_get_socket(struct file *file)
> +struct socket *tap_get_socket(struct file *file, size_t *hlen)
>   {
>   	struct tap_queue *q;
>   	if (file->f_op != &tap_fops)
> @@ -1254,6 +1254,9 @@ struct socket *tap_get_socket(struct file *file)
>   	q = file->private_data;
>   	if (!q)
>   		return ERR_PTR(-EBADFD);
> +	if (hlen)
> +		*hlen = (q->flags & IFF_VNET_HDR) ? q->vnet_hdr_sz : 0;
> +
>   	return &q->sock;
>   }
>   EXPORT_SYMBOL_GPL(tap_get_socket);
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 4cf38be26dc9..67b406fa0881 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3649,7 +3649,7 @@ static void tun_cleanup(void)
>    * attached to a device.  The returned object works like a packet socket, it
>    * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible for
>    * holding a reference to the file for as long as the socket is in use. */
> -struct socket *tun_get_socket(struct file *file)
> +struct socket *tun_get_socket(struct file *file, size_t *hlen)
>   {
>   	struct tun_file *tfile;
>   	if (file->f_op != &tun_fops)
> @@ -3657,6 +3657,20 @@ struct socket *tun_get_socket(struct file *file)
>   	tfile = file->private_data;
>   	if (!tfile)
>   		return ERR_PTR(-EBADFD);
> +
> +	if (hlen) {
> +		struct tun_struct *tun = tun_get(tfile);
> +		size_t len = 0;
> +
> +		if (!tun)
> +			return ERR_PTR(-ENOTCONN);
> +		if (tun->flags & IFF_VNET_HDR)
> +			len += READ_ONCE(tun->vnet_hdr_sz);
> +		if (!(tun->flags & IFF_NO_PI))
> +			len += sizeof(struct tun_pi);
> +		tun_put(tun);
> +		*hlen = len;
> +	}
>   	return &tfile->socket;
>   }
>   EXPORT_SYMBOL_GPL(tun_get_socket);
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index df82b124170e..b92a7144ed90 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1143,7 +1143,8 @@ static void handle_rx(struct vhost_net *net)
>   
>   	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
>   		vq->log : NULL;
> -	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
> +	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF) &&
> +		(vhost_hlen || sock_hlen >= sizeof(num_buffers));


So this change the behavior. When mergeable buffer is enabled, userspace 
expects the vhost to merge buffers. If the feature is disabled silently, 
it violates virtio spec.

If anything wrong in the setup, userspace just breaks itself.

E.g if sock_hlen is less that struct virtio_net_hdr_mrg_buf. The packet 
header might be overwrote by the vnet header.


>   
>   	do {
>   		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> @@ -1213,9 +1214,10 @@ static void handle_rx(struct vhost_net *net)
>   			}
>   		} else {
>   			/* Header came from socket; we'll need to patch
> -			 * ->num_buffers over if VIRTIO_NET_F_MRG_RXBUF
> +			 * ->num_buffers over the last two bytes if
> +			 * VIRTIO_NET_F_MRG_RXBUF is enabled.
>   			 */
> -			iov_iter_advance(&fixup, sizeof(hdr));
> +			iov_iter_advance(&fixup, sock_hlen - 2);


I'm not sure what did the above code want to fix. It doesn't change 
anything if vnet header is set correctly in TUN. It only prevents the 
the packet header from being rewrote.

Thanks

