Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2171B2C6B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUQRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:17:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgDUQRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587485854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6AGRVLAb8VV2GGBt9FCUOJrCOZqz3yE3pnkPMqPpaZ4=;
        b=FMtdgkMnMJ1OgpstLAbrp+TAPL2xJoTs6OZRgKQlWrJo5L1qkQFlw2vetUf4M96nQ9BNnn
        vf7R/cgp8phhtZQWTmHg36rGEJIXwMm1/+kJU/7LN3llIUm5+Vs6eChUnSM1ROhMOwi90l
        2JLNnhE2tCw3me/yG4/ulAuq4E+YCUg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-iT_YMuokOhaigeJPqwb-wQ-1; Tue, 21 Apr 2020 12:17:30 -0400
X-MC-Unique: iT_YMuokOhaigeJPqwb-wQ-1
Received: by mail-wm1-f72.google.com with SMTP id h22so1716750wml.1
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 09:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6AGRVLAb8VV2GGBt9FCUOJrCOZqz3yE3pnkPMqPpaZ4=;
        b=dMn/YKGmVlSDPRZqceh7K+Wh6moU52x7pHkh19qNJfYAZeczz4SnH9j4VFIH67kRfO
         yHHbPB+BQUkNijM94MMqSWxhVO+5JtA++2GGXxj1y5i3RHjy+KInOdqCTH73mVkWybG+
         8gXNVQn/Wsm6QL/cxcNk4TsGEl7TMmSdTqcSfqC8jgM+lzgBUn6p6tbAJYfADV61493W
         7LUBO+SRPl7w3BcD4U9imQvcJ4tU7OOfDLBk+UEMXyoLcJGQJjTsKauTM4CDdLusirgO
         VlREc86NiqlTkLFriBkeXxY59MFzFTfQZpK92ZwOXZCzTjgtcNT7LDHJ4ejgC3SePT3K
         6M9Q==
X-Gm-Message-State: AGi0PuaPZiOa0/SNA8aQEUyooVUG+7zfauJc7r8uL+fAP1GIHB3/L04y
        0KJo2GDqDBV1kktqb7NVdPpwWgb3cmZSoC6AW3qE/0OCLkD8O2h98CgyihpWHai6DCk5iQqukd5
        daX062oG6rCBD7XDI
X-Received: by 2002:adf:db41:: with SMTP id f1mr23709653wrj.13.1587485849055;
        Tue, 21 Apr 2020 09:17:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypINqkJ2dm7HlXLMWrMoVJcXlSBgzF2ec7b2hdUNDNYkmeWZUjNIFZKliARHFyJyRzZXDY7ReQ==
X-Received: by 2002:adf:db41:: with SMTP id f1mr23709639wrj.13.1587485848793;
        Tue, 21 Apr 2020 09:17:28 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id h2sm4500324wro.9.2020.04.21.09.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 09:17:27 -0700 (PDT)
Date:   Tue, 21 Apr 2020 18:17:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     davem@davemloft.net, Gerard Garcia <ggarcia@abra.uab.cat>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] vsock/virtio: postpone packet delivery to monitoring
 devices
Message-ID: <20200421161724.c3pnecltfz4jajww@steredhat>
References: <20200421092527.41651-1-sgarzare@redhat.com>
 <20200421154246.GA47385@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421154246.GA47385@stefanha-x1.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 04:42:46PM +0100, Stefan Hajnoczi wrote:
> On Tue, Apr 21, 2020 at 11:25:27AM +0200, Stefano Garzarella wrote:
> > We delivering packets to monitoring devices, before to check if
> > the virtqueue has enough space.
> 
> "We [are] delivering packets" and "before to check" -> "before
> checking".  Perhaps it can be rewritten as:
> 
>   Packets are delivered to monitoring devices before checking if the
>   virtqueue has enough space.
> 

Yeah, it is better :-)

> > 
> > If the virtqueue is full, the transmitting packet is queued up
> > and it will be sent in the next iteration. This causes the same
> > packet to be delivered multiple times to monitoring devices.
> > 
> > This patch fixes this issue, postponing the packet delivery
> > to monitoring devices, only when it is properly queued in the
> 
> s/,//
> 
> > virqueue.
> 
> s/virqueue/virtqueue/
> 

Thanks, I'll fix in the v2!

> > @@ -137,6 +135,11 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> >  			break;
> >  		}
> >  
> > +		/* Deliver to monitoring devices all correctly transmitted
> > +		 * packets.
> > +		 */
> > +		virtio_transport_deliver_tap_pkt(pkt);
> > +
> 
> The device may see the tx packet and therefore receive a reply to it
> before we can call virtio_transport_deliver_tap_pkt().  Does this mean
> that replies can now appear in the packet capture before the transmitted
> packet?

hmm, you are right!

And the same thing can already happen in vhost-vsock where we call
virtio_transport_deliver_tap_pkt() after the vhost_add_used(), right?

The vhost-vsock case can be fixed in a simple way, but here do you think
we should serialize them? (e.g. mutex, spinlock)

In this case I'm worried about performance.

Or is there some virtqueue API to check availability?

Thanks,
Stefano

