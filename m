Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8147E66A7BF
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjANAmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjANAlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:41:53 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8DEA702B
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:37:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso26012560pjf.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qgNFr3/ezXsDZIl7tdWNOPg0j+scXc5AL7Uadx41h+Q=;
        b=iR4kmvdyV/ZaYkmhVtyE8qa0q/p5nRWq/hgVWcQpjvji7VH6/t2YutICbE2prPh5FC
         ICaZaIaWB1bo6YQVuNSxzsNvOtfNLtp+FeMl/z0F4ehzFRt0kwRIToNY5Pkfzh1H8CfP
         MJwmpoXi+k3wtd7M7DkZtOOSqF5J7ogQi34AP4133pXDTPGOgeDaYw+DJKrDSJWq4ctg
         TBSX+SYDbKLIRW1XOd2UbixEmc/UJ4bulrMyCDk9rVY/iMVce4UhGKm77YX5WBhqxr4J
         +hx1krMM9tpwGDusAfTSK09hjL8LzV3GymAyAhMT3wZ3kDdPnIQM9+QQTIyegkrcUhTk
         C/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qgNFr3/ezXsDZIl7tdWNOPg0j+scXc5AL7Uadx41h+Q=;
        b=kQmFtxcV16f5PFlUOu8nCcrVp65IV2m8Yo7XS2N+iaNZRvfc9WKPNRGc2Az03imS9R
         OZHPzg5YFjt7AEHwBKfvKMFO3GL29rImvJKC3YIZP9+NvXvJau4HKrJt8fqbd6UH18pE
         PcAjz8OoGCMwNJto7N3gKG0rphQA7zFSK4sEDTwclz3RvDJM7KqgfzLmd7g4v0ZNQv6G
         52PJEKYBXnqdHh7k86aqmPsez5QDKv4J/+Ep6S4minoNT9isCX1CJb9MeaKVBpmm6CT1
         FWKnQeIAgdt5/VHqV/vUdQV6c539nBGvF0teYaPW0C9NxTrwJS2ScUq/+yS62h5NwIP4
         eN+w==
X-Gm-Message-State: AFqh2kq/l8FjBUxYiGzdCsShIVyeTvsll8hn6srT7XSrvBsggACFoBDU
        q9PjlpDOIiM2DdBjqGIcbd7TqiSh7/vzwulw3qo=
X-Google-Smtp-Source: AMrXdXutvktGPcR2EtUN7Ke7oh6I4rh95m6/IYTXGMnuxiqZ+nTUUC5M24rxo7waz2w83QJEg7IO8yclt232CZoJ0l8=
X-Received: by 2002:a17:90a:7f8d:b0:229:118f:c84c with SMTP id
 m13-20020a17090a7f8d00b00229118fc84cmr529502pjl.211.1673656622102; Fri, 13
 Jan 2023 16:37:02 -0800 (PST)
MIME-Version: 1.0
References: <20230113223619.162405-1-parav@nvidia.com> <20230113223619.162405-2-parav@nvidia.com>
 <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com>
 <PH0PR12MB5481C03EDED7C2D67395FCA4DCC29@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAKgT0UenRh4gdcOOg3t7+JXXyu06daXE8U8a38oxUQWQ3UnQVg@mail.gmail.com>
In-Reply-To: <CAKgT0UenRh4gdcOOg3t7+JXXyu06daXE8U8a38oxUQWQ3UnQVg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Jan 2023 16:36:50 -0800
Message-ID: <CAKgT0UdsazCNA+P7P_H5u36m9RELDPScBxwA6G=ZCjVH4ZEeDA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] virtio_net: Fix short frame length check
To:     Parav Pandit <parav@nvidia.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 4:23 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jan 13, 2023 at 3:37 PM Parav Pandit <parav@nvidia.com> wrote:
> >
> >
> > > From: Alexander H Duyck <alexander.duyck@gmail.com>
> > > Sent: Friday, January 13, 2023 6:24 PM
> > >
> > > On Sat, 2023-01-14 at 00:36 +0200, Parav Pandit wrote:
> > > > A smallest Ethernet frame defined by IEEE 802.3 is 60 bytes without
> > > > any preemble and CRC.
> > > >
> > > > Current code only checks for minimal 14 bytes of Ethernet header le=
ngth.
> > > > Correct it to consider the minimum Ethernet frame length.
> > > >
> > > > Fixes: 296f96fcfc16 ("Net driver using virtio")
> > > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c in=
dex
> > > > 7723b2a49d8e..d45e140b6852 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -1248,7 +1248,7 @@ static void receive_buf(struct virtnet_info *=
vi,
> > > struct receive_queue *rq,
> > > >     struct sk_buff *skb;
> > > >     struct virtio_net_hdr_mrg_rxbuf *hdr;
> > > >
> > > > -   if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> > > > +   if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
> > > >             pr_debug("%s: short packet %i\n", dev->name, len);
> > > >             dev->stats.rx_length_errors++;
> > > >             if (vi->mergeable_rx_bufs) {
> > >
> > > I'm not sure I agree with this change as packets are only 60B if they=
 have gone
> > > across the wire as they are usually padded out on the transmit side. =
There may
> > > be cases where software routed packets may not be 60B.
> > >
> > Do you mean Linux kernel software? Any link to it would be helpful.
>
> The problem is there are several software paths involved and that is
> why I am wanting to be cautious. As I recall this would impact Qemu
> itself, DPDK, the Linux Kernel and several others if I am not
> mistaken. That is why I am tending to err on the side of caution as
> this is a pretty significant change.
>
> > > As such rather than changing out ETH_HLEN for ETH_ZLEN I wonder if we
> > > should look at maybe making this a "<=3D" comparison instead since th=
at is the
> > > only case I can think of where the packet would end up being entirely=
 empty
> > > after eth_type_trans is called and we would be passing an skb with le=
ngth 0.
> >
> > I likely didn=E2=80=99t understand your comment.
> > This driver check is before creating the skb for the received packet.
> > So, purpose is to not even process the packet header or prepare the skb=
 if it not an Ethernet frame.
> >
> > It is interesting to know when we get < 60B frame.
>
> If I recall, a UDPv4 frame can easily do it since Ethernet is 14B, IP
> header is 20, and UDP is only 8 so that only comes to 42B if I recall
> correctly. Similarly I think a TCPv4 Frame can be as small as 54B if
> you disable all the option headers.
>
> A quick and dirty test would be to run something like a netperf UDP_RR
> test. I know in the case of the network stack we see the transmits
> that go out are less than 60B until they are padded on xmit, usually
> by the device. My concern is wanting to make sure all those paths are
> covered before we assume that all the packets will be padded.

I was curious so I decided to try verifying things with a qemu w/ user
networking and virtio-net. From what I can tell it looks like it is
definitely not padding them out.

19:34:38.331376 IP (tos 0x0, ttl 64, id 31799, offset 0, flags [DF],
proto UDP (17), length 29)
    localhost.localdomain.59579 > _gateway.52701: [udp sum ok] UDP, length =
1
        0x0000:  5255 0a00 0202 5254 0012 3456 0800 4500
        0x0010:  001d 7c37 4000 4011 a688 0a00 020f 0a00
        0x0020:  0202 e8bb cddd 0009 c331 6e
19:34:38.331431 IP (tos 0x0, ttl 64, id 45459, offset 0, flags [none],
proto UDP (17), length 29)
    _gateway.52701 > localhost.localdomain.59579: [udp sum ok] UDP, length =
1
        0x0000:  5254 0012 3456 5255 0a00 0202 0800 4500
        0x0010:  001d b193 0000 4011 b12c 0a00 0202 0a00
        0x0020:  020f cddd e8bb 0009 c331 6e
