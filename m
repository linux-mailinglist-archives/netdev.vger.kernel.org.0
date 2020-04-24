Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88791B7217
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDXKfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:35:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51724 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726716AbgDXKfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 06:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587724522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ntfPLZXoNyTvwSjnNtD9RbmeW0yN1V6v3M89sKls28c=;
        b=GfIpVg56lPhyI+NxLvoC/GewAJQ7o5QbTrnooQpXGS6TKmKrnQcoGYOJxnfYt74z28gCiJ
        qEgkINWYzn7Pb+KthUlTLGf0EHtcYJXe5BxGsWgXijIHkwtEglSuZP1oDhMBoVOE2+jdpf
        ECismCotVa1srnqXI2R7+7exW5Y0+hM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-G3wlaL_2PSqayeho7Re_AQ-1; Fri, 24 Apr 2020 06:35:20 -0400
X-MC-Unique: G3wlaL_2PSqayeho7Re_AQ-1
Received: by mail-wm1-f69.google.com with SMTP id v185so4027427wmg.0
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ntfPLZXoNyTvwSjnNtD9RbmeW0yN1V6v3M89sKls28c=;
        b=Zmulcn0nf0W5wAqrIqOC81OaLRzVt6tGWSNQwXzoSIpEOxDWAiiz9CmAnreFLgNgKI
         IMiRtWwXCxbWOVCg4ZTZDvCOMuXoVIOFxr99F/YVR0JyjfSV1cFa1k686s58YsyjT2kE
         RcspglAaJBYNhmn/0aq+PZOO2oCm5NrpIcNh4VMxeAd659NA3+dso6mP0tOmSPdt9q3A
         +YEYmRtsiCxQNFFRs/APvyeKDlWQis/eLlQi1rGtjCrSDsCqurlmMJCkJN9mBA3eX0Mk
         HjN5DH1KSuFwNAg1sgkLgilGn3jTJR0I+l41cbBA5WTwh3XZtSOA03//sP9jrVj/VuZM
         htCg==
X-Gm-Message-State: AGi0PuY3si8CqkIl/2joDyc63Kd/oPesS30yNS4TCqSJfOdrDuVQ1eWa
        6HOlViciZP6o9ExwW5cGAU61rHIov07l4DbqPTCX99P+Ah7wS8DH5dgegx5r6keQV54wkyz46rt
        8xGa3Dc1apveUO2Oa
X-Received: by 2002:a1c:3884:: with SMTP id f126mr9826289wma.91.1587724518698;
        Fri, 24 Apr 2020 03:35:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypJwafXiFz/67CLTHYy0TolHGXrpgwxNZZfuWGXn40Y8iNEzMExmzSW5yG6FLTxenAUETL6jWw==
X-Received: by 2002:a1c:3884:: with SMTP id f126mr9826249wma.91.1587724518274;
        Fri, 24 Apr 2020 03:35:18 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id 5sm2228287wmg.34.2020.04.24.03.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 03:35:17 -0700 (PDT)
Date:   Fri, 24 Apr 2020 12:35:15 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, davem@davemloft.net,
        Gerard Garcia <ggarcia@abra.uab.cat>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] vsock/virtio: postpone packet delivery to monitoring
 devices
Message-ID: <20200424103515.v62vldnnmtz3r6dm@steredhat>
References: <20200421092527.41651-1-sgarzare@redhat.com>
 <20200421154246.GA47385@stefanha-x1.localdomain>
 <20200421161724.c3pnecltfz4jajww@steredhat>
 <20200422165420.GL47385@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422165420.GL47385@stefanha-x1.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 05:54:20PM +0100, Stefan Hajnoczi wrote:
> On Tue, Apr 21, 2020 at 06:17:24PM +0200, Stefano Garzarella wrote:
> > On Tue, Apr 21, 2020 at 04:42:46PM +0100, Stefan Hajnoczi wrote:
> > > On Tue, Apr 21, 2020 at 11:25:27AM +0200, Stefano Garzarella wrote:
> > > > We delivering packets to monitoring devices, before to check if
> > > > the virtqueue has enough space.
> > > 
> > > "We [are] delivering packets" and "before to check" -> "before
> > > checking".  Perhaps it can be rewritten as:
> > > 
> > >   Packets are delivered to monitoring devices before checking if the
> > >   virtqueue has enough space.
> > > 
> > 
> > Yeah, it is better :-)
> > 
> > > > 
> > > > If the virtqueue is full, the transmitting packet is queued up
> > > > and it will be sent in the next iteration. This causes the same
> > > > packet to be delivered multiple times to monitoring devices.
> > > > 
> > > > This patch fixes this issue, postponing the packet delivery
> > > > to monitoring devices, only when it is properly queued in the
> > > 
> > > s/,//
> > > 
> > > > virqueue.
> > > 
> > > s/virqueue/virtqueue/
> > > 
> > 
> > Thanks, I'll fix in the v2!
> > 
> > > > @@ -137,6 +135,11 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> > > >  			break;
> > > >  		}
> > > >  
> > > > +		/* Deliver to monitoring devices all correctly transmitted
> > > > +		 * packets.
> > > > +		 */
> > > > +		virtio_transport_deliver_tap_pkt(pkt);
> > > > +
> > > 
> > > The device may see the tx packet and therefore receive a reply to it
> > > before we can call virtio_transport_deliver_tap_pkt().  Does this mean
> > > that replies can now appear in the packet capture before the transmitted
> > > packet?
> > 
> > hmm, you are right!
> > 
> > And the same thing can already happen in vhost-vsock where we call
> > virtio_transport_deliver_tap_pkt() after the vhost_add_used(), right?
> > 
> > The vhost-vsock case can be fixed in a simple way, but here do you think
> > we should serialize them? (e.g. mutex, spinlock)
> > 
> > In this case I'm worried about performance.
> > 
> > Or is there some virtqueue API to check availability?
> 
> Let's stick to the same semantics as Ethernet netdevs.  That way there
> are no surprises to anyone who is familiar with Linux packet captures.
> I don't know what those semantics are though, you'd need to check the
> code :).

IIUC, the packet is delivered to tap/monitoring devices before to call
the xmit() callback provided by the NIC driver.

At that point, if the packet is delayed/dropped/retransmitted by the driver
or the NIC, the monitoring application is not aware.

So, I think we can delivery it the first time that we see the packet,
before to queue it in the virtqueue (I should revert this change and fix
vhost-vsock), setting a flag in the 'struct virtio_vsock_pkt' to avoid
to delivery it multiple times.

I mean something like this:
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -157,7 +157,11 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)

 void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
 {
+       if (pkt->tap_delivered)
+               return;
+
        vsock_deliver_tap(virtio_transport_build_skb, pkt);
+       pkt->tap_delivered = true;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);


Let me know if you think it is a bad idea.

I'll send a v2 whit these changes.

Thanks,
Stefano

