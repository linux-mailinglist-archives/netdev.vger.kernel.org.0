Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E2C181B42
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgCKOc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:32:29 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40141 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbgCKOc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:32:29 -0400
Received: by mail-yw1-f65.google.com with SMTP id c15so2160555ywn.7
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 07:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a2GsYAB3RcpCslSrud7K9HZ5GVgS7PpH554PZ2fvYUw=;
        b=LqnocNJwKNcKSurYrXDjrQ6vsBi2tgBXE7OCuT0hE9ybhz4n6Pm9DIldp9o2S1+50m
         B0gkzvCyx4EZKeB4o3bi03eMdPctJj25TpJZUHLUfgyA44T1zDjzC4EWHOIosws113Ug
         RPA2CRPJpMafakPCjHUKtnQDHAlaAv3DXxGiNk14U4IdA5GwwfpQH9UuezlebTQhYsvX
         TUzx7WkKmD2FjvQLSqst3OIgSpa6bNM0iJOZrz+LlSV93aQ4wK/B4VYmPtbjshcSUvBg
         HcIIrsHHaBIoIviwKTHOCwQnHfEPuxbXMz6lKWwma5r1zpvZT2BZ40GDQPHNLsf8zERe
         p5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a2GsYAB3RcpCslSrud7K9HZ5GVgS7PpH554PZ2fvYUw=;
        b=B7aiL1HK+EgxqoX5HwqF5u4qAMeyn92f6lKWdXx/EvIqqSt5KkGZ8jw/xpsbh0LFwy
         K50eV6AFyTYJCD3ARC7PdfL1hRvZrP0AW5hXqzm5XmgJpILjlwCCDeB0Zcl9KVbK0LNM
         jtT2M3G7emPJ5Ltyno3SGSryS5uP83VSXiAY2K9jQ0Oo6nsPKkpBUM6cR08FSAg87iD0
         PreA/P7N0WqezFxDl2PpmJ+xH9cAtffmJ0OlIGRkqDAKHg1xcA6YCeHkQytpjQ0GXVk0
         iOTuvNpxxVXTLvGKsMlKioC9AJyFKRGjhEm3g6blKDFMFHjwXp2IovSq14aiQUN/5pdX
         46oA==
X-Gm-Message-State: ANhLgQ06kCRIkGkLM09MVS2IgKaXyDBjbEztAruW/Fi8M00dQt08xY9r
        T+EH59sVu7Ua0EEqIEurYCq1yNms
X-Google-Smtp-Source: ADFU+vv12GNjHQ7isty4RzUG/hJurliqVUaTfzj0/8/1hOUU81WeVSxunJR5o+ukrJ4SHMdqd7UU2g==
X-Received: by 2002:a81:5e09:: with SMTP id s9mr3537877ywb.348.1583937146655;
        Wed, 11 Mar 2020 07:32:26 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id g192sm21499311ywe.99.2020.03.11.07.32.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 07:32:25 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id x5so2127098ywb.13
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 07:32:25 -0700 (PDT)
X-Received: by 2002:a25:4904:: with SMTP id w4mr2048505yba.441.1583937144341;
 Wed, 11 Mar 2020 07:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200310023528-mutt-send-email-mst@kernel.org>
 <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org> <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org> <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
 <20200310172833-mutt-send-email-mst@kernel.org> <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
 <20200310175627-mutt-send-email-mst@kernel.org> <CA+FuTSd9ywydn-EShQkhSjUMXBHFgPMipBxmwx-t8bKQb-FuDQ@mail.gmail.com>
 <20200311035238-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200311035238-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Mar 2020 10:31:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSft5pSf7YJW1Ws=P7rYjWiwmZ6edYDPi7DVBafDWqcy-g@mail.gmail.com>
Message-ID: <CA+FuTSft5pSf7YJW1Ws=P7rYjWiwmZ6edYDPi7DVBafDWqcy-g@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 3:56 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 07:13:41PM -0400, Willem de Bruijn wrote:
> > On Tue, Mar 10, 2020 at 5:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 05:35:55PM -0400, Willem de Bruijn wrote:
> > > > On Tue, Mar 10, 2020 at 5:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Mar 10, 2020 at 11:38:16AM -0400, Willem de Bruijn wrote:
> > > > > > On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > > > > > > > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > > > > > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > > > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > > > > > > > >
> > > > > > > > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > > > > > > > ring producer index.
> > > > > > > > > > > >
> > > > > > > > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > > > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > > > > > > > of order arrival.
> > > > > > > > > > > >
> > > > > > > > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > > > > > > > to encountering an unknown GSO type.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > > > > > > >
> > > > > > > > > > > > ---
> > > > > > > > > > > >
> > > > > > > > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > > > > > > > This consistently blinds the reader to certain packets, including
> > > > > > > > > > > > recent UDP and SCTP GSO types.
> > > > > > > > > > >
> > > > > > > > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > > > > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > > > > > > > thing to do here is actually to split these packets up, not drop them.
> > > > > > > > > >
> > > > > > > > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > > > > > > > arrive segmented, due to these devices not advertising hardware
> > > > > > > > > > segmentation for these protocols.
> > > > > > > > >
> > > > > > > > > Oh right. That's good then, sorry about the noise.
> > > > > > > >
> > > > > > > > Not at all. Thanks for taking a look!
> > > > > > > >
> > > > > > > > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > > > > > > > new. There too it is limited on egress to devices that do advertise
> > > > > > > > > > h/w offload. And on r/x to GRO.
> > > > > > > > > >
> > > > > > > > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > > > > > > > goes back to my (argh!) introduction of the feature on the egress
> > > > > > > > > > path.
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > > > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > > > > > > > let the peer at least be aware of failure.
> > > > > > > > > > > >
> > > > > > > > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > > > > > > > >
> > > > > > > > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > > > > > > > we'll need more flags to know whether it's safe to pass
> > > > > > > > > > > these types to userspace.
> > > > > > > > > >
> > > > > > > > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > > > > > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > > > > > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > > > > > > > types.
> > > > > > > > >
> > > > > > > > > Oh I mean if we do want to add new types and want to pass them to
> > > > > > > > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > > > > > > > knows whether that will or won't confuse userspace.
> > > > > > > >
> > > > > > > > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > > > > > > > now, just looking at tpacket, a new variant of socket option for
> > > > > > > > PACKET_VNET_HDR, for every new GSO type?
> > > > > > >
> > > > > > > Maybe a single one with a bitmap of legal types?
> > > > > > >
> > > > > > > > In practice the userspace I'm aware of, and any sane implementation,
> > > > > > > > will be future proof to drop and account packets whose type it cannot
> > > > > > > > process. So I think we can just add new types.
> > > > > > >
> > > > > > > Well if packets are just dropped then userspace breaks right?
> > > > > >
> > > > > > It is an improvement over the current silent discard in the kernel.
> > > > > >
> > > > > > If it can count these packets, userspace becomes notified that it
> > > > > > should perhaps upgrade or use ethtool to stop the kernel from
> > > > > > generating certain packets.
> > > > > >
> > > > > > Specifically for packet sockets, it wants to receive packets as they
> > > > > > appear "on the wire". It does not have to drop these today even, but
> > > > > > can easily parse the headers.
> > > > > >
> > > > > > For packet sockets at least, I don't think that we want transparent
> > > > > > segmentation.
> > > > >
> > > > > Well it's GSO is in the way then it's no longer "on the wire", right?
> > > > > Whether we split these back to individual skbs or we don't
> > > > > it's individual packets that are on the wire. GSO just allows
> > > > > passing them to the application in a more efficient way.
> > > >
> > > > Not entirely. With TSO enabled, packet sockets will show the TCP TSO
> > > > packets, not the individual segment on the wire.
> > >
> > > But nothing breaks if it shows a segment on the wire while linux
> > > processes packets in batches, right? It's just some extra info that
> > > an app can't handle, so we hide it from the app...
> >
> > I don't entirely follow. Are we on the same page here and agree that
> > we should just show the GSO packet to userspace?
>
> So we are talking about a hypothetical case where we add a GSO type,
> then a hypothetical userspace that does not know about a specific GSO
> type, right? I feel there must be some kind of negotiation
> and kernel must detect and show individual packets to such
> userspace. In fact, a similar change for the checksum has
> broken old dhcp clients and some of them are broken to this
> day, with ip tables rules used to work around the issue.

Interesting. Had to look that up. [1] summarizes it well. The issue is
with virtio-net devices advertising tx + rx checksum offload and thus
passing packets between VMs on the same host with bogus checksum
field. And the DHCP process reading such a packet, trying to verify
the checksum, failing and dropping.

Can we separate the virtio/tun/tap and packet socket use-cases of
virtio_net_hdr?

I would expect packet sockets to behave the same with and without
po->has_vnet_hdr. Without, they already pass all GSO packets up to
userspace as is. Which is essential for debugging with tcpdump or
wirehark. I always interpreted has_vnet_hdr as just an option to
receive more metadata along, akin to PACKET_AUXDATA. Not something
that subtly changes the packet flow.

That was my intend, but I only extended it to tpacket_rcv. Reading up
on the original feature that was added for packet_rcv, it does mention
"allows GSO/checksum offload to be enabled when using raw socket
backend with virtio_net". I don't know what that raw socket back-end
with virtio-net is. Something deprecated, but possibly still in use
somewhere?

For virtio/tun/tap, as long as we do not add NETIF_F_GSO_.. options to
dev->features and dev->hw_features, we have nothing to worry about.
Eventually we probably do want to add opt-in gso support. And I think
this ethtool negotiation will suffice. We just have to add new
VIRTIO_NET_HDR_GSO_.. types and update virtio_net_hdr_{from, to}_skb
before expanding dev->features.

[1] https://bugs.launchpad.net/ubuntu/+source/isc-dhcp/+bug/930962/comments/5
