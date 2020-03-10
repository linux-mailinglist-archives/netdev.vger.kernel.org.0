Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E654218007B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgCJOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:44:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35478 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726469AbgCJOoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583851445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r7DW29M0+TzeXu0pNf375DSNzTsvYhWFNUXMXsjlL1Q=;
        b=HPgjSCKM0lbN3P19CBlTHFPPTPGVJHce0nND4y7F+WUYXE8ZSIyQajf71m02aIeQ5F0Ei2
        J0QjpSX0jzYFcwakzRKJOI4Qg0GwqIYsuikGFtTs0ELt/9Dx8Ro0GWbOXcjC1qppNVNFa1
        yijKGu9kZZ4aBpHye5E9CkwJ/3fSRyg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-WwMWccoWPV246vTwbOrnMA-1; Tue, 10 Mar 2020 10:44:04 -0400
X-MC-Unique: WwMWccoWPV246vTwbOrnMA-1
Received: by mail-qv1-f70.google.com with SMTP id fc5so9203919qvb.17
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 07:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7DW29M0+TzeXu0pNf375DSNzTsvYhWFNUXMXsjlL1Q=;
        b=RCD5trkAfWLR3JkgAmsUFx2XYdVsmLpmaTwHzd4VTPqMbpN4edvUr8iaoN+7W30SIv
         MTRmFoHAz1vdStZ2lGJMTqBMDiWuB9YX16Xa1rBvbxcpSYsLgEhOSL50zoGApzmmrtaq
         eovHzUeOl1It4RuEAKHs6vL7T8+s3ZmBFLFQtXa0YuH892G6foG/mkF131z5lmkSB3qq
         SKE/nXx1hVuXPbnNGxAc2eBXOp3VA3gJdF/mevdE9ulLRThZBO4NnOCc/HVfdt85g3v7
         ttQriWXWBi1HdQDsdQfDDsG1/zulzG5SpLy+jEtOi9NXklPfk84uom28qNq+3LBI5q4I
         Y+gA==
X-Gm-Message-State: ANhLgQ1O7ill7xWlMztVXSK3kqEKzgSy0nGb+7xNVMv9x4UnHulWvZiR
        QJOdT+WvZDPKEhnnY2k6mpntK7y7StfvUHYar6RepvCs/LmqQNgmWP3UXbgx+5MQXyDaMZ+NvHn
        GudrcsoMwH74AQiJX
X-Received: by 2002:a37:4bd3:: with SMTP id y202mr20331311qka.32.1583851442875;
        Tue, 10 Mar 2020 07:44:02 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt/zFQSS4mrA5rIUftZlI6zcvX86peTmmZb08zgXAcCEhCileBpOOPu71TeJ6FzB7dFxM2PfQ==
X-Received: by 2002:a37:4bd3:: with SMTP id y202mr20331278qka.32.1583851442494;
        Tue, 10 Mar 2020 07:44:02 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id j1sm21180113qtd.66.2020.03.10.07.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:44:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:43:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310104024-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org>
 <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org>
 <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > From: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > ring producer index.
> > > > >
> > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > of order arrival.
> > > > >
> > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > to encountering an unknown GSO type.
> > > > >
> > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > ---
> > > > >
> > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > This consistently blinds the reader to certain packets, including
> > > > > recent UDP and SCTP GSO types.
> > > >
> > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > thing to do here is actually to split these packets up, not drop them.
> > >
> > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > arrive segmented, due to these devices not advertising hardware
> > > segmentation for these protocols.
> >
> > Oh right. That's good then, sorry about the noise.
> 
> Not at all. Thanks for taking a look!
> 
> > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > new. There too it is limited on egress to devices that do advertise
> > > h/w offload. And on r/x to GRO.
> > >
> > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > goes back to my (argh!) introduction of the feature on the egress
> > > path.
> > >
> > > >
> > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > let the peer at least be aware of failure.
> > > > >
> > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > >
> > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > we'll need more flags to know whether it's safe to pass
> > > > these types to userspace.
> > >
> > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > it looks to me that the infra is future proof wrt adding new GSO
> > > types.
> >
> > Oh I mean if we do want to add new types and want to pass them to
> > users, then virtio_net_hdr_from_skb will need to flag so it
> > knows whether that will or won't confuse userspace.
> 
> I'm not sure how that would work. Ignoring other tun/tap/virtio for
> now, just looking at tpacket, a new variant of socket option for
> PACKET_VNET_HDR, for every new GSO type?

Maybe a single one with a bitmap of legal types?

> In practice the userspace I'm aware of, and any sane implementation,
> will be future proof to drop and account packets whose type it cannot
> process. So I think we can just add new types.

Well if packets are just dropped then userspace breaks right?
So we'll really need to split up packets when this happens.


> In the worst case, arrival of these packets is under admin control with ethtool.

It's common to enable this by default since hey offload, must be good.

-- 
MST

