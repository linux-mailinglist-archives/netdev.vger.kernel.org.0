Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFD916F98D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgBZIYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:24:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36574 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727311AbgBZIYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582705449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axeNxuwVzLh9+6WHrifmT3/K6ZVO5b41Nj4aK9DIR2w=;
        b=D3ybdi2sQKAa0SveFykEvhcJx4zQZLRDEUsy9nrj7gRld3Yk790nbdvJNyIWE67VxgQy8V
        qVia2WIXojq7YU8zTZq3STLPRUhC58MounNPEXniy75X0OG0jIfsu64Wwe2OJA/kRoZjh+
        WrHTUju/WHnhH0MX2XaTN4ztdAIkVAI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-rcUkIjwrN9qrRgncVqZ7aw-1; Wed, 26 Feb 2020 03:24:08 -0500
X-MC-Unique: rcUkIjwrN9qrRgncVqZ7aw-1
Received: by mail-il1-f197.google.com with SMTP id s71so2848590ill.6
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:24:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=axeNxuwVzLh9+6WHrifmT3/K6ZVO5b41Nj4aK9DIR2w=;
        b=WGGI8I942NG8kyVLnQWnwLVZlmeofV9M6PuzNj97kmvQ0DlSMS6aJudfAECSUWRODu
         m4tqd9Z23/gCFs6hgfEqO3N18d22dGZYDxoauo/JCeS6LyC0lVa2VyxTAuewGxLP7gf2
         2fm4Z+atpqgdudqSiJ8UcBp1JsDsmjUkqfECB0OgAoCbyqUS+3vfoW8fT0R/4iURtl1F
         XJ2vPRch+JhU3aLc1alnlX3OgM8xdJFFfLa4ON9ayea6Edutgfb2TdN4HcGFftqk0xrW
         S2cAoJTNJuA8/C4IAUc1NBdDl8+Umn5/xc0soi935izMI6Xz7GTo6tc60LXA364l5MDK
         9Qiw==
X-Gm-Message-State: APjAAAXB6zJZW7ftquaULhxpI7wqpIsc7h/kmFp+TVBmR/3iErsApfUF
        uAGACN4kaIrgCJc8TeWFvnksH2RaNWr/Uf6MI4ij8ri/1QnapELu1cA8IzXmpy3Mq41ltWWMcr4
        tx1X26JY5gOb0++qq
X-Received: by 2002:a02:8587:: with SMTP id d7mr2804984jai.39.1582705446969;
        Wed, 26 Feb 2020 00:24:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNGtokikJLjt5IWioTO0CM1HHV1W+Vw7qQ6W4uRXA40eiOCfu4PkMws4PyUYZcJVsxq3EcFQ==
X-Received: by 2002:ae9:e90f:: with SMTP id x15mr4433182qkf.437.1582705445306;
        Wed, 26 Feb 2020 00:24:05 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id t29sm747118qtt.20.2020.02.26.00.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:24:04 -0800 (PST)
Date:   Wed, 26 Feb 2020 03:23:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226032204-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <87wo89zroe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wo89zroe.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:19:45AM +0100, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
> > On 2/25/20 8:00 PM, Jason Wang wrote:
> >> 
> >> On 2020/2/26 上午8:57, David Ahern wrote:
> >>> From: David Ahern <dahern@digitalocean.com>
> >>>
> >>> virtio_net currently requires extra queues to install an XDP program,
> >>> with the rule being twice as many queues as vcpus. From a host
> >>> perspective this means the VM needs to have 2*vcpus vhost threads
> >>> for each guest NIC for which XDP is to be allowed. For example, a
> >>> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> >>>
> >>> The extra queues are only needed in case an XDP program wants to
> >>> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> >>> additional queues. Relax the queue requirement and allow XDP
> >>> functionality based on resources. If an XDP program is loaded and
> >>> there are insufficient queues, then return a warning to the user
> >>> and if a program returns XDP_TX just drop the packet. This allows
> >>> the use of the rest of the XDP functionality to work without
> >>> putting an unreasonable burden on the host.
> >>>
> >>> Cc: Jason Wang <jasowang@redhat.com>
> >>> Cc: Michael S. Tsirkin <mst@redhat.com>
> >>> Signed-off-by: David Ahern <dahern@digitalocean.com>
> >>> ---
> >>>   drivers/net/virtio_net.c | 14 ++++++++++----
> >>>   1 file changed, 10 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index 2fe7a3188282..2f4c5b2e674d 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -190,6 +190,8 @@ struct virtnet_info {
> >>>       /* # of XDP queue pairs currently used by the driver */
> >>>       u16 xdp_queue_pairs;
> >>>   +    bool can_do_xdp_tx;
> >>> +
> >>>       /* I like... big packets and I cannot lie! */
> >>>       bool big_packets;
> >>>   @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct
> >>> net_device *dev,
> >>>               len = xdp.data_end - xdp.data;
> >>>               break;
> >>>           case XDP_TX:
> >>> +            if (!vi->can_do_xdp_tx)
> >>> +                goto err_xdp;
> >> 
> >> 
> >> I wonder if using spinlock to synchronize XDP_TX is better than dropping
> >> here?
> >
> > I recall you suggesting that. Sure, it makes for a friendlier user
> > experience, but if a spinlock makes this slower then it goes against the
> > core idea of XDP.
> 
> IMO a spinlock-arbitrated TX queue is something that should be available
> to the user if configured (using that queue abstraction Magnus is
> working on), but not the default, since as you say that goes against the
> "performance first" mantra of XDP.
> 
> -Toke

OK so basically there would be commands to configure which TX queue is
used by XDP. With enough resources default is to use dedicated queues.
With not enough resources default is to fail binding xdp program
unless queues are specified. Does this sound reasonable?
It remains to define how are changes in TX queue config handled.
Should they just be disallowed as long as there's an active XDP program?

