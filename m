Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8174935D6C8
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhDMFGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:06:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhDMFGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618290376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yk3x/SMpfREk/zOV4sftMFvMQg+J6weHzyZPLn+Zb8=;
        b=K4JULXpb7/c05zM1DTZCwPEiCb4iLsdSQmOH+OJF+kcpHcxKcJk4MNtxtt70llw3unHjIr
        0MebWwRi9ouD3T9S7EhlSwTHuf1+049e30zW+7EZNTkEw5MN22f5o+R3Jga5237jBx0vZK
        kR5MueRx6UdscEBwV1t43ns8Blwgg3o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-neqenIIlP7eCZVvBpbi45Q-1; Tue, 13 Apr 2021 01:06:15 -0400
X-MC-Unique: neqenIIlP7eCZVvBpbi45Q-1
Received: by mail-wr1-f70.google.com with SMTP id n16so283456wrm.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 22:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yk3x/SMpfREk/zOV4sftMFvMQg+J6weHzyZPLn+Zb8=;
        b=e9ftG6COgXU0/3teYhxGlPKnlUU77iYF8GHQcUIHzzlsfmIajbFX0W94xdrJFHXJH9
         m0sjtLuPrEiOXxWPJi+QvzI8qoYEMGbeWqr+3/uKrntnbFm7EMPb5c8nfcs56FlVHKia
         pewSoQ1URDVKXXQC6MdsMM4Hi22DguCjPSvujmsHoLCAQxPwxBnJ03sZdsIwveqfbBg/
         gjYDRROOxzQUUd1oghNqVhpEny0pFYMAyYvNL2dC4vTzSfj0n3STtXp2dN361d889JCM
         l1/Z0Q/1zhBGQyWpoUz8qlkRB6RO41C/xL5Uzi0vv4hdEG4TxO5/WuZTGtVJQKfg+XGk
         OByA==
X-Gm-Message-State: AOAM533BydhQAz+hFfo2glStiiGFUHjKivS58MwR4zhFkD7c5p+7X6m+
        i0HSJGK06YQ4OdqGkpB2/79PXzouDo04zMbmvfJJ4GSWBA63+I+XY7P2HC/oO76e/FBPGFkb5LF
        yCbrjGVBMyA2dWmIT
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr2227287wmj.26.1618290373626;
        Mon, 12 Apr 2021 22:06:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxraaCqJzAsUGqK1x4ZfxYE88R4+PkRQIo0V4mGnAEtSy7W9XIwo9Os5I+suQUauNsjM9ku5Q==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr2227274wmj.26.1618290373493;
        Mon, 12 Apr 2021 22:06:13 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id r2sm4909962wrt.79.2021.04.12.22.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 22:06:13 -0700 (PDT)
Date:   Tue, 13 Apr 2021 01:06:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next v3 5/5] virtio-net: keep tx interrupts disabled
 unless kick
Message-ID: <20210413010354-mutt-send-email-mst@kernel.org>
References: <20170424174930.82623-1-willemdebruijn.kernel@gmail.com>
 <20170424174930.82623-6-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424174930.82623-6-willemdebruijn.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2017 at 01:49:30PM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Tx napi mode increases the rate of transmit interrupts. Suppress some
> by masking interrupts while more packets are expected. The interrupts
> will be reenabled before the last packet is sent.
> 
> This optimization reduces the througput drop with tx napi for
> unidirectional flows such as UDP_STREAM that do not benefit from
> cleaning tx completions in the the receive napi handler.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/virtio_net.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9dd978f34c1f..003143835766 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1200,6 +1200,9 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	/* Free up any pending old buffers before queueing new ones. */
>  	free_old_xmit_skbs(sq);
>  
> +	if (use_napi && kick)
> +		virtqueue_enable_cb_delayed(sq->vq);
> +
>  	/* timestamp packet in software */
>  	skb_tx_timestamp(skb);


I have been poking at this code today and I noticed that is
actually does enable cb where the commit log says masking interrupts.
I think the reason is that with even index previously disable cb
actually did nothing while virtqueue_enable_cb_delayed pushed
the event index out some more.
And this likely explains why it does not work well for packed,
where virtqueue_enable_cb_delayed is same as virtqueue_enable_cb.

Right? Or did I miss something?

> -- 
> 2.12.2.816.g2cccc81164-goog

