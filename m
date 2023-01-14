Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679C266A774
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjANAXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjANAXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:23:50 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892546E0C2
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:23:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q64so23961381pjq.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uyFe8Hiv6O2mfH/Vj1+Wj64Z370Ezwp6JCjnN4tqvqo=;
        b=g1I67YiwFjVYKgsHUYTIW+SYpmSr2e+PZPoR7G2RJkG/N+SkGyQwD4jGjV/Qz1Gpj8
         HMJJ99VwQ3z+qE6bK+L7cJxfaC0DJWe/TlgjBlUEAnAKF14+eFXwzGIi690SMDF0IqeT
         zAH8wVcwJcVBABT2DUePs+sQg6dlwXgzmsTn37XR0rdUgQabIet7QgyA37U5Ef1POA9/
         5uiAmr8kXe63qR9H/y/WcVtwmMCJMCC3XGxNRc2FwO+ydkb2FikrtlRm67QEP+IHxXtU
         UGlvyI0o4To+M8lNhw5pbt+xdR12XNFrVHDOVG0DuCYHb+bKaAQ5cZq9+eBe9YT+Pd49
         6sKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uyFe8Hiv6O2mfH/Vj1+Wj64Z370Ezwp6JCjnN4tqvqo=;
        b=8LOmKIoaClCQnW3Lf7l7l5P+Wy7Vfb6GoeaJ9qIVhYEE5S1FI1INH6nMtAPwbKMLYc
         fRhhMlo39t2h1/0lugQC3hcolmptFa3GUTQUCDdwrGVnVxrQIm/E1tD8Z0Mggja/ctOs
         JteDHlmEf9Cc1zIAQkArNC3eO3M/YvvHUGSys9bMjz6ocVlNgTszbFG+02r2v7ymhyXT
         6EWW6x4xHKnquwAufNInq0zVg9jMdb0rQ9GykHNojSM3KPnDWhMcpUVIuvSoFN9CaV+4
         1vuclPRYuaeeYAnxxkw1li1YHQ/nkMqBn9kFziNfYLFfK2P3Nm5a1/ooUs4VzMcQxwC1
         NqZQ==
X-Gm-Message-State: AFqh2kpMyG/goAdIH2+Z2I8t4NR4D4TMLWgAnbWyTOw5yheX1iaFFpkc
        lP2M+Nb5QKnGSlZTdXfxD5A0115pz2LxJA1FiFEX+reE
X-Google-Smtp-Source: AMrXdXsg1K15MKq3iirRL4kK4FUxxwT5OGX76KLekIccfKRRmZOFqsAdltrfdYEstzEk9J/YGDimbibbPqig5Kc/AQQ=
X-Received: by 2002:a17:902:82c7:b0:192:9101:a65a with SMTP id
 u7-20020a17090282c700b001929101a65amr113612plz.111.1673655827946; Fri, 13 Jan
 2023 16:23:47 -0800 (PST)
MIME-Version: 1.0
References: <20230113223619.162405-1-parav@nvidia.com> <20230113223619.162405-2-parav@nvidia.com>
 <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com> <PH0PR12MB5481C03EDED7C2D67395FCA4DCC29@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481C03EDED7C2D67395FCA4DCC29@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Jan 2023 16:23:36 -0800
Message-ID: <CAKgT0UenRh4gdcOOg3t7+JXXyu06daXE8U8a38oxUQWQ3UnQVg@mail.gmail.com>
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

On Fri, Jan 13, 2023 at 3:37 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Alexander H Duyck <alexander.duyck@gmail.com>
> > Sent: Friday, January 13, 2023 6:24 PM
> >
> > On Sat, 2023-01-14 at 00:36 +0200, Parav Pandit wrote:
> > > A smallest Ethernet frame defined by IEEE 802.3 is 60 bytes without
> > > any preemble and CRC.
> > >
> > > Current code only checks for minimal 14 bytes of Ethernet header leng=
th.
> > > Correct it to consider the minimum Ethernet frame length.
> > >
> > > Fixes: 296f96fcfc16 ("Net driver using virtio")
> > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > ---
> > >  drivers/net/virtio_net.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c inde=
x
> > > 7723b2a49d8e..d45e140b6852 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1248,7 +1248,7 @@ static void receive_buf(struct virtnet_info *vi=
,
> > struct receive_queue *rq,
> > >     struct sk_buff *skb;
> > >     struct virtio_net_hdr_mrg_rxbuf *hdr;
> > >
> > > -   if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> > > +   if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
> > >             pr_debug("%s: short packet %i\n", dev->name, len);
> > >             dev->stats.rx_length_errors++;
> > >             if (vi->mergeable_rx_bufs) {
> >
> > I'm not sure I agree with this change as packets are only 60B if they h=
ave gone
> > across the wire as they are usually padded out on the transmit side. Th=
ere may
> > be cases where software routed packets may not be 60B.
> >
> Do you mean Linux kernel software? Any link to it would be helpful.

The problem is there are several software paths involved and that is
why I am wanting to be cautious. As I recall this would impact Qemu
itself, DPDK, the Linux Kernel and several others if I am not
mistaken. That is why I am tending to err on the side of caution as
this is a pretty significant change.

> > As such rather than changing out ETH_HLEN for ETH_ZLEN I wonder if we
> > should look at maybe making this a "<=3D" comparison instead since that=
 is the
> > only case I can think of where the packet would end up being entirely e=
mpty
> > after eth_type_trans is called and we would be passing an skb with leng=
th 0.
>
> I likely didn=E2=80=99t understand your comment.
> This driver check is before creating the skb for the received packet.
> So, purpose is to not even process the packet header or prepare the skb i=
f it not an Ethernet frame.
>
> It is interesting to know when we get < 60B frame.

If I recall, a UDPv4 frame can easily do it since Ethernet is 14B, IP
header is 20, and UDP is only 8 so that only comes to 42B if I recall
correctly. Similarly I think a TCPv4 Frame can be as small as 54B if
you disable all the option headers.

A quick and dirty test would be to run something like a netperf UDP_RR
test. I know in the case of the network stack we see the transmits
that go out are less than 60B until they are padded on xmit, usually
by the device. My concern is wanting to make sure all those paths are
covered before we assume that all the packets will be padded.
