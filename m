Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECDBAEC8
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 09:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405591AbfIWH6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 03:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404503AbfIWH6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 03:58:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75B6385538
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 07:58:35 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w8so4551321wrm.3
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 00:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9WKA+WhADA6m5tO2INYGO3d/2B7vs6iFqq3kcuFfazA=;
        b=Vw7nFyNPZvGT84y1n/Y+7irVhrivwh/TgPOWWKWzEQN9KWYGUTAraVhS3NBZbv2TBX
         dYZ0ohURt6U1Iu09S3TSJWlm1dTY6E3PQtDLv3DYtrtD3sbOZZEP/EEZ8lNQIZh2U8K1
         ETfj7Ut0Bl5aMbeI6cIhNHCoNBkgWkVvP+wi8lPts5GbN+Uvacp+MKPOjmIrT82PHfnP
         r+4feyDmduqTHmlVRHVWIrHj3QppPngjrptqoiHGw7iR+hxE11lr8EWktKzjKTpKYgjB
         ESXrlO/qR+v4y+JceRpScxHPj8f9V8n8GMOAm/bd2zRebG/9EOQG/F5zjUuCR2FZ6w/v
         ZrUA==
X-Gm-Message-State: APjAAAWfv1TwJWfV9DV16QaYSG0QEq0YAkZDWWHFMH+ZQgG0XrAmzM2P
        qbIDnGl7EBYa9ZQDJFdPn6gi+UpzizH0IZGCJx+fGbDTf/AshSNxGQewHy0Z7wW3eD1ffqyq88w
        9b+sC/XlAekM4AkGr
X-Received: by 2002:a1c:6508:: with SMTP id z8mr13334117wmb.93.1569225514192;
        Mon, 23 Sep 2019 00:58:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqywRzpbSPc3I/T0HiQ3vLyqomtoGHN75D+xXsibaZU6MPSciXTHKp4KwamMtyvbmdFON3ncxg==
X-Received: by 2002:a1c:6508:: with SMTP id z8mr13334103wmb.93.1569225513884;
        Mon, 23 Sep 2019 00:58:33 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id l18sm11651891wrc.18.2019.09.23.00.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 00:58:33 -0700 (PDT)
Date:   Mon, 23 Sep 2019 09:58:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] VSOCK: add support for MSG_PEEK
Message-ID: <20190923075830.a6sjwffnkljmyyqm@steredhat>
References: <1569174507-15267-1-git-send-email-matiasevara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569174507-15267-1-git-send-email-matiasevara@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matias,
thanks for this patch!

Since this patch only concerns virtio_transport,
I'd use the 'vsock/virtio' prefix in the commit title:
"vsock/virtio: add support for MSG_PEEK"

Some comments below:

On Sun, Sep 22, 2019 at 05:48:27PM +0000, Matias Ezequiel Vara Larsen wrote:
> This patch adds support for MSG_PEEK. In such a case, packets are not
> removed from the rx_queue and credit updates are not sent.
> 
> Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++++++++++++++--
>  1 file changed, 56 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 94cc0fa..830e890 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -264,6 +264,59 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
>  }
>  
>  static ssize_t
> +virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> +				struct msghdr *msg,
> +				size_t len)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t bytes, off = 0, total = 0;
> +	int err = -EFAULT;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +

What about using list_for_each_entry() to cycle through the queued packets?

> +	if (list_empty(&vvs->rx_queue)) {
> +		spin_unlock_bh(&vvs->rx_lock);
> +		return 0;
> +	}
> +
> +	pkt = list_first_entry(&vvs->rx_queue,
> +			       struct virtio_vsock_pkt, list);
> +	do {

pkt->off contains the offset inside the packet where the unread data starts.
So here we should initialize 'off':

		off = pkt->off;

Or just use pkt->off later (without increasing it as in the dequeue).

> +		bytes = len - total;
> +		if (bytes > pkt->len - off)
> +			bytes = pkt->len - off;
> +
> +		/* sk_lock is held by caller so no one else can dequeue.
> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +		 */
> +		spin_unlock_bh(&vvs->rx_lock);
> +
> +		err = memcpy_to_msg(msg, pkt->buf + off, bytes);
> +		if (err)
> +			goto out;
> +
> +		spin_lock_bh(&vvs->rx_lock);
> +
> +		total += bytes;

Using list_for_each_entry(), here we can just do:
(or better, at the beginning of the cycle)

		if (total == len)
			break;

removing the next part...

> +		off += bytes;
> +		if (off == pkt->len) {
> +			pkt = list_next_entry(pkt, list);
> +			off = 0;
> +		}
> +	} while ((total < len) && !list_is_first(&pkt->list, &vvs->rx_queue));

...until here.

> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	return total;
> +
> +out:
> +	if (total)
> +		err = total;
> +	return err;
> +}
> +
> +static ssize_t
>  virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  				   struct msghdr *msg,
>  				   size_t len)
> @@ -330,9 +383,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>  				size_t len, int flags)
>  {
>  	if (flags & MSG_PEEK)
> -		return -EOPNOTSUPP;
> -
> -	return virtio_transport_stream_do_dequeue(vsk, msg, len);
> +		return virtio_transport_stream_do_peek(vsk, msg, len);
> +	else
> +		return virtio_transport_stream_do_dequeue(vsk, msg, len);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>  

The rest looks good to me!

Thanks,
Stefano
