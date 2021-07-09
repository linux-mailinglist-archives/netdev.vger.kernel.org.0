Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D9A3C27A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhGIQi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhGIQi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 12:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625848574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ceEDiRlxYBNIyz1vvOORKa0xoxqQbqYqjBuKjZM21qQ=;
        b=HChcdI9Ik5OopTrA0ve6/CpYwOzJ8NcVbVwl1EJwWs5ckIhf7lDkIzorXPn59OPTMu5RCq
        4KbBj7vtg5QinEIQyu5tRjYFC1CVMyIGCYPELFmbTdu/SXVffGJSPZ0HWsEnpdbK/V/0gR
        rhE9uPH7rdjHAQly4TH66G9ys0mrIxE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-jUgKn6jtMDG88tfgw_0daw-1; Fri, 09 Jul 2021 12:36:13 -0400
X-MC-Unique: jUgKn6jtMDG88tfgw_0daw-1
Received: by mail-wr1-f71.google.com with SMTP id x4-20020a5d60c40000b029013cfb5f33b0so563566wrt.4
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 09:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ceEDiRlxYBNIyz1vvOORKa0xoxqQbqYqjBuKjZM21qQ=;
        b=jQgwQvFa07ex8pyi9cyUkEIudQ5FFwajonAbFjofW3DgLkRmo1NoycJmi9oOa4UewU
         iBHpln0F61WyfnfrcChTkycU9NNYjbbLLKDgcNSxmxVfTOnnGKxma5DTQfuBqeTkvjhW
         m78fE4p8ycCIMpvuPAdDKomEY9z1Ov5maR7TaqfNGVN1Lt5a6LtUuaOpqsSUkhgibN4c
         JXP0bDOEKMjrN0GXxKzv7TiRDJ4Yvs20VJOzc1EwQgjbPMdKyQrCJCZh64X4UHWQ62g6
         bFfv72wHXist/a61NV6/l/xFJoCfjEktHcWP6aiBdgWNHD0QFyEPYAFNdT/nugaHevo9
         wwbg==
X-Gm-Message-State: AOAM532wnMItQKD06doBF7khMdBI75Lb1wC1GO6nvf7VfWHkKxkZ7Cte
        I2o9NIvskfOMwatUXpufWbG7tJ9YVkCgZjQm1sxxncDGYCsSUpTP2CNi6qnwRZTWv+ThiYACaG2
        m5yxp9eI7piyxCuE9
X-Received: by 2002:a7b:ce82:: with SMTP id q2mr12645762wmj.60.1625848571920;
        Fri, 09 Jul 2021 09:36:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2plQvfrn9WO3DzKTfFWPF+pumjma0KGo3Ye8wFLbr0uLSV+ydRhTyXuG4NXVIaQUEteCYGg==
X-Received: by 2002:a7b:ce82:: with SMTP id q2mr12645739wmj.60.1625848571685;
        Fri, 09 Jul 2021 09:36:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id m29sm12165034wms.13.2021.07.09.09.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 09:36:11 -0700 (PDT)
Message-ID: <aa74017284590d724427e168eac220d108f287d1.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 09 Jul 2021 18:35:59 +0200
In-Reply-To: <87lf6feckr.fsf@toke.dk>
References: <cover.1625823139.git.pabeni@redhat.com>
         <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
         <878s2fvln4.fsf@toke.dk>
         <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
         <9c451d25fb36bc82e602bb93e384b262be743fbf.camel@redhat.com>
         <87lf6feckr.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-09 at 17:23 +0200, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> > On Fri, 2021-07-09 at 12:49 +0200, Paolo Abeni wrote:
> > > On Fri, 2021-07-09 at 12:15 +0200, Toke Høiland-Jørgensen wrote:
> > > > > +	if (netif_running(dev))
> > > > > +		veth_close(dev);
> > > > > +
> > > > > +	priv->num_tx_queues = ch->tx_count;
> > > > > +	priv->num_rx_queues = ch->rx_count;
> > > > 
> > > > Why can't just you use netif_set_real_num_*_queues() here directly (and
> > > > get rid of the priv members as above)?
> > > 
> > > Uhm... I haven't thought about it. Let me try ;)
> > 
> > Here there is a possible problem: if the latter
> > netif_set_real_num_*_queues() fails, we should not change the current
> > configuration, so we should revert the
> > first netif_set_real_num_*_queues() change.
> > 
> > Even that additional revert operation could fail. If/when that happen
> > set_channel() will leave the device in a different state from both the
> > old one and the new one, possibly with an XDP-incompatible number of
> > queues.
> > 
> > Keeping the  netif_set_real_num_*_queues() calls in veth_open() avoid
> > the above issue: if the queue creation is problematic, the device will
> > stay down.
> > 
> > I think the additional fields are worthy, WDYT?
> 
> Hmm, wouldn't the right thing to do be to back out the change and return
> an error to userspace? Something like:
> 
> +	if (netif_running(dev))
> +		veth_close(dev);
> +
> +	old_rx_queues = dev->real_num_rx_queues;
> +	err = netif_set_real_num_rx_queues(dev, ch->rx_count);
> +	if (err)
> +		return err;
> +
> +	err = netif_set_real_num_tx_queues(dev, ch->tx_count);
> +	if (err) {
> +		netif_set_real_num_rx_queues(dev, old_rx_queues);

I'm sorry, I was not clear enough. I mean: even the
above netif_set_real_num_rx_queues() can fail. When that happen we will
leave the device in an inconsistent state, possibly even with an
"unsupported" queue setting.

> +		return err;
> +	}
> +
> +	if (netif_running(dev))
> +		veth_open(dev);
> +	return 0;
> 
> 
> (also, shouldn't the result of veth_open() be returned? bit weird if you
> don't get an error but the device stays down...)

Agreed.

Thanks!

Paolo

