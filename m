Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB742E7C7E
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 21:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgL3U7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 15:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgL3U7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 15:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609361894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lDaf9gK/5CMnrHmaEEdNBnavCV6ONasVpqtwDHwq9uQ=;
        b=SEz4riUpY0XFouR1UUBnQISOrewKN0lqd6RBx9IXkyLBiMMBEKYGxY6vHWW/20+idShTDr
        iN5Tu5rstwvQ135NSbZYJquzixcYAJ2XjXeRORE4sufQZZAJ+OQYvMv3FDApZfKESdVE0m
        Y036NZ1PAbkg75jNO+sV98gki4ve1bs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-NcXki7NSMk-X4Yo59QDy8A-1; Wed, 30 Dec 2020 15:58:12 -0500
X-MC-Unique: NcXki7NSMk-X4Yo59QDy8A-1
Received: by mail-wm1-f72.google.com with SMTP id s130so2928137wme.0
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 12:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lDaf9gK/5CMnrHmaEEdNBnavCV6ONasVpqtwDHwq9uQ=;
        b=AISnMaNolUbr8GSHH1gOsHiutHAfzrfdxzqieK2D6o3PtrqDoIfXCm+McNGAr5nfSq
         CqmOnrrQEtkdU6Ty7MYtZHWj+JrYs42VJ6Fo9tCT6H9sozaKWDMLTpB7MxhGeclxl4I8
         rudVZGz26ZUjRhWgiVYVzNHVhKK40giY8HYtoWiulq4O1e8zYQ+9WiNkGSSHRqozLDXR
         7KniWYGWXyxUfd84exD8MK68Jw36Rz9ImB/BC5IUc2e6vkg/7LokAp/gF8Wg7MPROtkV
         299CiukI6PwFEI2A15ibt13q+9JQnozjughYhMAz46vyQdKiNccNPUrktdWCh8h7V+L3
         TLog==
X-Gm-Message-State: AOAM531ry1vYg+uT82jcMW2hgBiUvOa26+/o4jf5NhMWaSvmztMx97qF
        ORE6A6rLe/hqLyHwMhqdkk6wNoavpT2gOY+X7Uc5tJOb2W7iJ0g07GyfZdhjNdyJGWetzFRqHy9
        +eS3TC8YoBMsZ2x2x
X-Received: by 2002:a1c:5447:: with SMTP id p7mr9088165wmi.116.1609361891275;
        Wed, 30 Dec 2020 12:58:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4bdqLukNRVhkbPZzhHtiaz3QtqIPXIm1HllomjylrEHnRN3Uj4rvTqH8/DqgtuwFNl8qVpA==
X-Received: by 2002:a1c:5447:: with SMTP id p7mr9088150wmi.116.1609361891091;
        Wed, 30 Dec 2020 12:58:11 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id s12sm8405138wmh.29.2020.12.30.12.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 12:58:10 -0800 (PST)
Date:   Wed, 30 Dec 2020 15:58:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] vhost/vsock: support for SOCK_SEQPACKET socket.
Message-ID: <20201230155742-mutt-send-email-mst@kernel.org>
References: <20201229110634.275024-1-arseny.krasnov@kaspersky.com>
 <20201230155410-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230155410-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 03:56:03PM -0500, Michael S. Tsirkin wrote:
> On Tue, Dec 29, 2020 at 02:06:33PM +0300, Arseny Krasnov wrote:
> > 	This patch simply adds transport ops and removes
> > ignore of non-stream type of packets.
> > 
> > Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> 
> How is this supposed to work? virtio vsock at the moment
> has byte level end to end credit accounting at the
> protocol level. I suspect some protocol changes involving
> more than this tweak would
> be needed to properly support anything that isn't a stream.


oh this was not threaded correctly so I did not see rest of
patches. ignore this pls will respond there.

> > ---
> >  drivers/vhost/vsock.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index a483cec31d5c..4a36ef1c52d0 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -346,8 +346,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> >  		return NULL;
> >  	}
> >  
> > -	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
> > -		pkt->len = le32_to_cpu(pkt->hdr.len);
> > +	pkt->len = le32_to_cpu(pkt->hdr.len);
> >  
> >  	/* No payload */
> >  	if (!pkt->len)
> > @@ -416,6 +415,9 @@ static struct virtio_transport vhost_transport = {
> >  		.stream_is_active         = virtio_transport_stream_is_active,
> >  		.stream_allow             = virtio_transport_stream_allow,
> >  
> > +		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
> > +		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
> > +
> >  		.notify_poll_in           = virtio_transport_notify_poll_in,
> >  		.notify_poll_out          = virtio_transport_notify_poll_out,
> >  		.notify_recv_init         = virtio_transport_notify_recv_init,
> > -- 
> > 2.25.1

