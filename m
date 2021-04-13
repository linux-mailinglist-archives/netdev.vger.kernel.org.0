Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3664C35E1A9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346442AbhDMOe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343831AbhDMOeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618324425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03mb4LEKGQSjGCDEyQg3KiQjDam/TziPkhfoQlj9YcM=;
        b=Gp9KrT8Bnwk4zTGkbtWsyQsU5IvS6vmtrdHXOZCQWBrkKkODOT+9JUDOEnPHi/JsXNu+uT
        0tyXu8ypq5GXQwEPmJYIuhoI1tuf3CxE7Lg8BuLJtzKWHztI6FjwgN63GSometRStMY/nb
        BR+ZK+qaYActUjo170zz2ndy5FBxfXM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Em1t-DwkOw6DOE6NRTEKPA-1; Tue, 13 Apr 2021 10:33:43 -0400
X-MC-Unique: Em1t-DwkOw6DOE6NRTEKPA-1
Received: by mail-wm1-f69.google.com with SMTP id f15-20020a7bc8cf0000b029010bb9489e25so3098226wml.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=03mb4LEKGQSjGCDEyQg3KiQjDam/TziPkhfoQlj9YcM=;
        b=L7FNoe9C38dffxtz5jB/zGiS0zLMq+9xIe3BCrjGbfzDphSHyqq9Ksu8bQZZcqWDvY
         jKfG8oHtdjir37gwpWVYE0OUJ0CYQRpHi2QJ4HnbnSV/pXx9AVYICC+YrSm7WQqkBKQI
         EfYBA/LLFGUfn9/b74KAGYpVb0HUhk51SfSfMsTjxbxrgmdWMtEgQo5Oz9q6uSttPnkl
         VRdzoaKfHI7hRbFjqmVmJymt1e27x7qD66ASWm39uBGqy9pbuBMETJMlMyObEQ5V0Zt9
         kge5bF0BFWKEXlnk5Ucrg4OJcO/hG0CfjaWqkNXBgVEZ1FCr9qfbdQqPF+38U9aGX52E
         bxng==
X-Gm-Message-State: AOAM532Pb5Ebr4bYJiylz/4JC5yF1ASm7cmsSbNlnJRNYq+DiM2b/Zkx
        dzBTOlrXxLrEb9K31QTzrK34RyfMqr5l5PEgA+SM8RCis2XdpnnyJLygJ/Zgn+chB0FrpI/gviH
        di4eWhWk2gzHkK6pA
X-Received: by 2002:a1c:f715:: with SMTP id v21mr282040wmh.187.1618324421409;
        Tue, 13 Apr 2021 07:33:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTe7rBlLKqCoWn++/O8Aw6yKwfkrflupGRE+nGP0iUf29tGd26k1V89INwAeu3NGikNplrxg==
X-Received: by 2002:a1c:f715:: with SMTP id v21mr282029wmh.187.1618324421247;
        Tue, 13 Apr 2021 07:33:41 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id c6sm19518494wri.32.2021.04.13.07.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:33:40 -0700 (PDT)
Date:   Tue, 13 Apr 2021 10:33:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v2 2/4] virtio_net: disable cb aggressively
Message-ID: <20210413100314-mutt-send-email-mst@kernel.org>
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-3-mst@redhat.com>
 <43db5c1e-9908-55bb-6d1a-c6c8d71e2315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43db5c1e-9908-55bb-6d1a-c6c8d71e2315@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 04:53:32PM +0800, Jason Wang wrote:
> 
> 在 2021/4/13 下午1:47, Michael S. Tsirkin 写道:
> > There are currently two cases where we poll TX vq not in response to a
> > callback: start xmit and rx napi.  We currently do this with callbacks
> > enabled which can cause extra interrupts from the card.  Used not to be
> > a big issue as we run with interrupts disabled but that is no longer the
> > case, and in some cases the rate of spurious interrupts is so high
> > linux detects this and actually kills the interrupt.
> > 
> > Fix up by disabling the callbacks before polling the tx vq.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/net/virtio_net.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 82e520d2cb12..16d5abed582c 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1429,6 +1429,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
> >   		return;
> >   	if (__netif_tx_trylock(txq)) {
> > +		virtqueue_disable_cb(sq->vq);
> >   		free_old_xmit_skbs(sq, true);
> >   		__netif_tx_unlock(txq);
> 
> 
> Any reason that we don't need to enable the cb here?

Good point ... probably only if the vq isn't empty ...

> And as we discussed in the past, it's probably the time to have a single
> NAPI for both tx and rx?
> 
> Thanks


Donnu. I'd like to get a minimal bugfix in, refactoring on top ...

> 
> >   	}
> > @@ -1582,6 +1583,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >   	bool use_napi = sq->napi.weight;
> >   	/* Free up any pending old buffers before queueing new ones. */
> > +	virtqueue_disable_cb(sq->vq);
> >   	free_old_xmit_skbs(sq, false);
> >   	if (use_napi && kick)

