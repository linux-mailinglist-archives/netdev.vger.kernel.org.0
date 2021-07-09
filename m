Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C373C227D
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhGIKw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:52:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229641AbhGIKw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625827814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p83o+aMbPDh4h88AiWWLaMRE7yX8WLUNTx7Dqv3Igy0=;
        b=S/8J30/tPU8X7ttWoim/xdRqHvjqkCENFdYEJKKaz9Wo8mrBSogM0ithgAurnTDx34p9aS
        Xh7tjV+VQfJ7LxaTh+gjAbkzSHP6u4kL6iEMZ1Y0lJEKFUOBW0fCFy9dxfVcoQLvcrpbz2
        +YJxzUFjpKZ82UYeHowLw/Xwd3N/yQE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Shm_kHwQNbazMfDPJzyZCA-1; Fri, 09 Jul 2021 06:50:11 -0400
X-MC-Unique: Shm_kHwQNbazMfDPJzyZCA-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so1961172wmj.8
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 03:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=p83o+aMbPDh4h88AiWWLaMRE7yX8WLUNTx7Dqv3Igy0=;
        b=F0WSnnuvFWqoEfwR9C9gAngv5zTHfwbr5KXCJCppPIY1gOT3TkGjKm8CgYMIaFWl2s
         hzNO8g0iATrXTsg9PueLhO8ATW/C9QWHPN5xAtfZlaWu52X4zPyQBGWCRvWNwtGPMjuA
         /IhJZSFU/TS4CASGHS1SaTCXPMYcQ4tYiizMSd8PnVTzbc6dkbp9vQd4kNcqSKbAX1NW
         NqLMJmncZNVFQAd1KHRVUDMyscUatMJuYHLT1rvPok+vXmF0WGn42DBHrqXqPiXLYCY/
         rGuq2VTE9+v88ISCODZlneUGJhI1aOfkasYcmozEWSwq31m/Mpgbm7p+an6fjc60oBeC
         XDhA==
X-Gm-Message-State: AOAM532ByVYUDJ+hsmfa3jFW9mod7JuPJ/nBmp9AGLy4oY+t+x3Aikt6
        UVg9BwvwP/U44KXWN4htxufBp8YdsrRWnjBk8lg8LgvAcfgGYArXt6QO4mBwwCzJ5LYzraLSrlG
        /rVFHfVi/TG96woGY
X-Received: by 2002:a5d:64c2:: with SMTP id f2mr28592806wri.158.1625827810712;
        Fri, 09 Jul 2021 03:50:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykMJIhLYaWz4Hfh8mscDLdmV2xbdzLG9SKn2S2Fl2YwxHkFka8guBCilGLj2d/kuyYB4WFuA==
X-Received: by 2002:a5d:64c2:: with SMTP id f2mr28592791wri.158.1625827810565;
        Fri, 09 Jul 2021 03:50:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id m6sm5942951wrw.9.2021.07.09.03.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 03:50:10 -0700 (PDT)
Message-ID: <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 09 Jul 2021 12:49:59 +0200
In-Reply-To: <878s2fvln4.fsf@toke.dk>
References: <cover.1625823139.git.pabeni@redhat.com>
         <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
         <878s2fvln4.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2021-07-09 at 12:15 +0200, Toke Høiland-Jørgensen wrote:
> > @@ -224,10 +226,49 @@ static void veth_get_channels(struct net_device *dev,
> >  {
> >  	channels->tx_count = dev->real_num_tx_queues;
> >  	channels->rx_count = dev->real_num_rx_queues;
> > -	channels->max_tx = dev->real_num_tx_queues;
> > -	channels->max_rx = dev->real_num_rx_queues;
> > +	channels->max_tx = dev->num_tx_queues;
> > +	channels->max_rx = dev->num_rx_queues;
> >  	channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
> > -	channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
> > +	channels->max_combined = min(dev->num_rx_queues, dev->num_tx_queues);
> > +}
> > +
> > +static int veth_close(struct net_device *dev);
> > +static int veth_open(struct net_device *dev);
> > +
> > +static int veth_set_channels(struct net_device *dev,
> > +			     struct ethtool_channels *ch)
> > +{
> > +	struct veth_priv *priv = netdev_priv(dev);
> > +	struct veth_priv *peer_priv;
> > +
> > +	/* accept changes only on rx/tx */
> > +	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
> > +		return -EINVAL;
> > +
> > +	/* respect contraint posed at device creation time */
> > +	if (ch->rx_count > dev->num_rx_queues || ch->tx_count > dev->num_tx_queues)
> > +		return -EINVAL;
> > +
> > +	if (!ch->rx_count || !ch->tx_count)
> > +		return -EINVAL;
> > +
> > +	/* avoid braking XDP, if that is enabled */
> > +	if (priv->_xdp_prog && ch->rx_count < priv->peer->real_num_tx_queues)
> > +		return -EINVAL;
> > +
> > +	peer_priv = netdev_priv(priv->peer);
> > +	if (peer_priv->_xdp_prog && ch->tx_count > priv->peer->real_num_rx_queues)
> > +		return -EINVAL;
> 
> An XDP program could be loaded later, so I think it's better to enforce
> this constraint unconditionally.

The relevant check is already present in veth_xdp_set(), the load will
be rejected with an appropriate extack message.

I enforcing the above contraint uncontiditionally will make impossible
changing the number of real queues at runtime, as we must update dev
and peer in different moments.

> (What happens on the regular xmit path if the number of TX queues is out
> of sync with the peer RX queues, BTW?)

if tx < rx, the higly number of rx queue will not be used, if rx < tx,
XDP/gro can't take place: the normal veth path is used.

> > +	if (netif_running(dev))
> > +		veth_close(dev);
> > +
> > +	priv->num_tx_queues = ch->tx_count;
> > +	priv->num_rx_queues = ch->rx_count;
> 
> Why can't just you use netif_set_real_num_*_queues() here directly (and
> get rid of the priv members as above)?

Uhm... I haven't thought about it. Let me try ;)

Thanks!

/P

