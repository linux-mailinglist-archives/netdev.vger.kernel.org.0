Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAD17F9B1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 13:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCJM7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:59:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730002AbgCJM7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 08:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583845151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tnrkAMOENOWY5xddwTYBxc9Ezl4zlwF0QTGbSKE8c58=;
        b=hax0i8NnzINSTi+P9R5srPUNG+MM4r0oJ0Hm19w3XFlthQPSPgubJYEr3NvjTuuFopAURu
        0GK2CJ52TixJpqtMx/DIqPeR9/Sef1+soGLHtepi2Lyp8uW0eHDdMpjNPctQ5oNNqFPUmF
        ukkb4m++sCW7JadsvidhLta1m7YMv6Y=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Mx2fN4d3MRqCunb9dowGyA-1; Tue, 10 Mar 2020 08:59:07 -0400
X-MC-Unique: Mx2fN4d3MRqCunb9dowGyA-1
Received: by mail-qk1-f200.google.com with SMTP id d14so4823367qkj.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 05:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tnrkAMOENOWY5xddwTYBxc9Ezl4zlwF0QTGbSKE8c58=;
        b=NSy9ptBqUgPTFXnp1oL804f0colasb0CeXUFgmEgRCFQnhIW4KDxTRwhtYleOs1D34
         pnlO8dGlmsMHvSMa7oPSPb1RPx0jKAP4b2qAZ8DPRdQgIJXxwI/jFPSPQ4Dh2wCO3B4O
         uSgnosCqxbWbpHJytUYFdSH0OmjkmMqjCf5tQ3ELO1PM4LiqyK0kNlmJraVrUVbXmx1/
         uMvvKCl5KT6a0Ogvj5ykaKk6Gvo6U6yMKS6/HlLbn+io51ItCPaoESgrXcZjBD72TGVO
         LR4cD9+Wyy/3/MRTeGd7T8At0wBhJuG2rI9V5Fu5UVo+MAhmKXnoZeteshNI3Twp8cuZ
         sIcA==
X-Gm-Message-State: ANhLgQ2tkeBGj7oAs7tExJo/bOhdXWuhcW/YehqhvV9bTNYlYIGVgOSN
        YOxaJ8fhXb9B8ooA903mByfvPcgBhP5yLswKB9A5wbfUfKh7paYgHWosMLC4UWL+0cufgtAEog7
        MzZIwt2OkxWDFWx/p
X-Received: by 2002:ad4:4baf:: with SMTP id i15mr18557416qvw.148.1583845146677;
        Tue, 10 Mar 2020 05:59:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvxwVL7APpO7JUc8XcEYpUCmqp/lw+LwPwhzANKeuRgHJeyXoj5QrWt+o1SIK/AfNBhAwF4Rw==
X-Received: by 2002:ad4:4baf:: with SMTP id i15mr18557396qvw.148.1583845146437;
        Tue, 10 Mar 2020 05:59:06 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id 199sm5537521qkm.7.2020.03.10.05.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 05:59:05 -0700 (PDT)
Date:   Tue, 10 Mar 2020 08:59:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310085437-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org>
 <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > In one error case, tpacket_rcv drops packets after incrementing the
> > > ring producer index.
> > >
> > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > thus the reader is stalled for an iteration of the ring, causing out
> > > of order arrival.
> > >
> > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > to encountering an unknown GSO type.
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > >
> > > ---
> > >
> > > I wonder whether it should drop packets with unknown GSO types at all.
> > > This consistently blinds the reader to certain packets, including
> > > recent UDP and SCTP GSO types.
> >
> > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > thing to do here is actually to split these packets up, not drop them.
> 
> In the main virtio users, virtio_net/tun/tap, the packets will always
> arrive segmented, due to these devices not advertising hardware
> segmentation for these protocols.

Oh right. That's good then, sorry about the noise.

> So the issue is limited to users of tpacket_rcv, which is relatively
> new. There too it is limited on egress to devices that do advertise
> h/w offload. And on r/x to GRO.
> 
> The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> goes back to my (argh!) introduction of the feature on the egress
> path.
> 
> >
> > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > let the peer at least be aware of failure.
> > >
> > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> >
> > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > we'll need more flags to know whether it's safe to pass
> > these types to userspace.
> 
> Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> -EINVAL on unknown GSO types and its callers just drop these packets,
> it looks to me that the infra is future proof wrt adding new GSO
> types.

Oh I mean if we do want to add new types and want to pass them to
users, then virtio_net_hdr_from_skb will need to flag so it
knows whether that will or won't confuse userspace.

-- 
MST

