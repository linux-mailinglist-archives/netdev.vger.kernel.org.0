Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B692E7C7D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 21:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgL3U5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 15:57:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbgL3U5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 15:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609361766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iFlZtz74xmTz/ktSlcFt8gctOusgNHUwrHkjcpUKl9Y=;
        b=IAFjOFKTzYuL0nPHFkOlMlBDN55g2RIpd3qxmTvzWZZXtDB1s4KAdcJ1pP69CE1fY1ctNx
        q6q+rFDLhV0D0P+D0cdK7aAfS6ZDGTfEx5myFI3Rvwv3taNkdSf0mY6qYAfczEItszerjN
        rJGJ2HmdOUvyJh0roeq78fGXVvdk1hA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-4ViUBrUYMVq-f3jyT0E2kg-1; Wed, 30 Dec 2020 15:56:05 -0500
X-MC-Unique: 4ViUBrUYMVq-f3jyT0E2kg-1
Received: by mail-wr1-f71.google.com with SMTP id i4so9302530wrm.21
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 12:56:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iFlZtz74xmTz/ktSlcFt8gctOusgNHUwrHkjcpUKl9Y=;
        b=uBBGhaj3BCCdU+VCGrZsfedqsKJpt/llKHBxPTbW3wTdgv42belpTBA83Q2URXciFL
         1LuCm5XmWjd/NYK5YZyCwRV3yXL7YRrJfcy75RWQQOQv5U/pCTVxKayCzL9ZHNud6jZ4
         nRExmkhGNWQrcHRO5oy7DmYm7odthAuKy7BXACk1b369TMV7coto+zSxWPsLiPDCc2VJ
         p+WPEfxlWb1Pw+PN59g+Jy26OSPd2cfRwLf6rbMD8N+lePK29VrzIXrG5biOf1rne8UR
         OEJwirgaSPIQOyIl9aNFq3JZuGou33njHqujL2kUkpxBw9FY9qcI/0Ojh5Oakdncfrr0
         DzRw==
X-Gm-Message-State: AOAM532vtztQd33MmwK5O5LXHcoH42QoKfu9iGqcfoEEpKQVFPHh1j+Y
        JospitGcE6ClYkY9mYiRYwbccX76JTL/g2cr3lorMiqIxUS9YRdYQUbKNW25ThDHdBhwfpAG2Cy
        o+lyhIMf0Jq0zCW/Z
X-Received: by 2002:a7b:c319:: with SMTP id k25mr9111291wmj.142.1609361763378;
        Wed, 30 Dec 2020 12:56:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB48GLoSLLN8yYRD+dbDksR16DwdSfBGhZ/WcRSvjWjsNVj0mfX0SAKJH/DWv1GhEP0T8aRA==
X-Received: by 2002:a7b:c319:: with SMTP id k25mr9111280wmj.142.1609361763191;
        Wed, 30 Dec 2020 12:56:03 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id i9sm64608892wrs.70.2020.12.30.12.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 12:56:02 -0800 (PST)
Date:   Wed, 30 Dec 2020 15:55:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] vhost/vsock: support for SOCK_SEQPACKET socket.
Message-ID: <20201230155410-mutt-send-email-mst@kernel.org>
References: <20201229110634.275024-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229110634.275024-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 02:06:33PM +0300, Arseny Krasnov wrote:
> 	This patch simply adds transport ops and removes
> ignore of non-stream type of packets.
> 
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>

How is this supposed to work? virtio vsock at the moment
has byte level end to end credit accounting at the
protocol level. I suspect some protocol changes involving
more than this tweak would
be needed to properly support anything that isn't a stream.

> ---
>  drivers/vhost/vsock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a483cec31d5c..4a36ef1c52d0 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -346,8 +346,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>  		return NULL;
>  	}
>  
> -	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
> -		pkt->len = le32_to_cpu(pkt->hdr.len);
> +	pkt->len = le32_to_cpu(pkt->hdr.len);
>  
>  	/* No payload */
>  	if (!pkt->len)
> @@ -416,6 +415,9 @@ static struct virtio_transport vhost_transport = {
>  		.stream_is_active         = virtio_transport_stream_is_active,
>  		.stream_allow             = virtio_transport_stream_allow,
>  
> +		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
> +		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
> +
>  		.notify_poll_in           = virtio_transport_notify_poll_in,
>  		.notify_poll_out          = virtio_transport_notify_poll_out,
>  		.notify_recv_init         = virtio_transport_notify_recv_init,
> -- 
> 2.25.1

