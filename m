Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD84F180A72
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCJVaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:30:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29473 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgCJVaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583875803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmgPTtn1NCZvgIDF1tL2iE3NUIATHqy5qUo0os9nc0g=;
        b=VbWVMGXFBG4C4HtSDcQ3dd8ch9tMLueeOhFmjeR7Ir2IKmt9MCGSIA1RPjdMl7TKjyKcND
        wx9o4yurgpy4XbHHTyRKZqv46mF85qh0KcoQcN9UQizakr1TFtgwKv+sJchDN1tzvb5FPp
        K26U6t7+qFjZnCB5Q08EN6b+Q5RrSLM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-Im9uUAzjPIuIUihJ_RF9fg-1; Tue, 10 Mar 2020 17:30:01 -0400
X-MC-Unique: Im9uUAzjPIuIUihJ_RF9fg-1
Received: by mail-qk1-f197.google.com with SMTP id 22so64690qkc.7
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LmgPTtn1NCZvgIDF1tL2iE3NUIATHqy5qUo0os9nc0g=;
        b=p1FSWQZW74LFANsxpGboK+Edzbhx/AacDzTMpRm7asKThs3LSutT6elxPgUvvJD7+A
         MSkMvy0+5akjrd8wM7gfRLzZTOYT2v8680/tHFCoUICUWXrSG4X60EosU33qvjPkC4S2
         36Wjsa0GLAX6zMtS/Pxv1+T9q8JFCZNyQguW0HEu+CSttEEqZG01g+lFYRjon/ejk1TH
         z6Vf0QJNGPN9EWYTP+T+XtQ/Vg6XgMii3G9zWOI8Hf68ym/+lAwKgQc6zT4rVd+Vmmxt
         bngjvto9G+Dqv5J2U1Hz9pvVrQnAeXpEMjJlyzzEh8xQjvecCVjcfnvgRUWrgZhQGKTF
         NYKQ==
X-Gm-Message-State: ANhLgQ15b5uxwMZ0T5ZHJuveV0SBltIOeV8y8O3bgjtdZf/xFzFfHuJ/
        0lN6UjkzktXZPwWcNOcvenKmbTgHCy3AH/gJWhxgB5JQvKsn3GAo2v0gamXnRxdkpGhsawrw7iJ
        ZV/dLQ1LxHIr4twnx
X-Received: by 2002:a05:620a:3c5:: with SMTP id r5mr21612650qkm.228.1583875800911;
        Tue, 10 Mar 2020 14:30:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vspifsoHLo9NT95iPCeT19iE64+UJJeYOr95SH4+1elEcIku5fQmH8YB49cauduR2CHUBLz4A==
X-Received: by 2002:a05:620a:3c5:: with SMTP id r5mr21612627qkm.228.1583875800598;
        Tue, 10 Mar 2020 14:30:00 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id w18sm7818093qkw.130.2020.03.10.14.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:29:59 -0700 (PDT)
Date:   Tue, 10 Mar 2020 17:29:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310172833-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org>
 <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org>
 <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org>
 <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:38:16AM -0400, Willem de Bruijn wrote:
> On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > > >
> > > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > > ring producer index.
> > > > > > >
> > > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > > of order arrival.
> > > > > > >
> > > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > > to encountering an unknown GSO type.
> > > > > > >
> > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > >
> > > > > > > ---
> > > > > > >
> > > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > > This consistently blinds the reader to certain packets, including
> > > > > > > recent UDP and SCTP GSO types.
> > > > > >
> > > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > > thing to do here is actually to split these packets up, not drop them.
> > > > >
> > > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > > arrive segmented, due to these devices not advertising hardware
> > > > > segmentation for these protocols.
> > > >
> > > > Oh right. That's good then, sorry about the noise.
> > >
> > > Not at all. Thanks for taking a look!
> > >
> > > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > > new. There too it is limited on egress to devices that do advertise
> > > > > h/w offload. And on r/x to GRO.
> > > > >
> > > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > > goes back to my (argh!) introduction of the feature on the egress
> > > > > path.
> > > > >
> > > > > >
> > > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > > let the peer at least be aware of failure.
> > > > > > >
> > > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > > >
> > > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > > we'll need more flags to know whether it's safe to pass
> > > > > > these types to userspace.
> > > > >
> > > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > > types.
> > > >
> > > > Oh I mean if we do want to add new types and want to pass them to
> > > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > > knows whether that will or won't confuse userspace.
> > >
> > > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > > now, just looking at tpacket, a new variant of socket option for
> > > PACKET_VNET_HDR, for every new GSO type?
> >
> > Maybe a single one with a bitmap of legal types?
> >
> > > In practice the userspace I'm aware of, and any sane implementation,
> > > will be future proof to drop and account packets whose type it cannot
> > > process. So I think we can just add new types.
> >
> > Well if packets are just dropped then userspace breaks right?
> 
> It is an improvement over the current silent discard in the kernel.
> 
> If it can count these packets, userspace becomes notified that it
> should perhaps upgrade or use ethtool to stop the kernel from
> generating certain packets.
> 
> Specifically for packet sockets, it wants to receive packets as they
> appear "on the wire". It does not have to drop these today even, but
> can easily parse the headers.
> 
> For packet sockets at least, I don't think that we want transparent
> segmentation.

Well it's GSO is in the way then it's no longer "on the wire", right?
Whether we split these back to individual skbs or we don't
it's individual packets that are on the wire. GSO just allows
passing them to the application in a more efficient way.

> 
> > So we'll really need to split up packets when this happens.

