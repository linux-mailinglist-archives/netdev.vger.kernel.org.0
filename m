Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC92C3C22EF
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhGILjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230024AbhGILjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 07:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625830586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OcA0NiDPyHjWy8/Rt+bgKSOiJGaZbsmJimq14lPbh0=;
        b=bfxAJp4cz5d/rlXP4sqrXpjMXcvF74LuuFUVzR4vPl7NXy3jQeD+5R7frgLlAp69k/AIVT
        TNtuWCc2aaIQERepoDgtKewbZko4FJL9SWIYCTJhWf3BH+XMqa+7TYV9/xvg8hWRY17wAP
        Viy+RDCpZ6G/H8FOT60/THFxdzo281E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-EZdd70dSPmqpcQgCQCHDeA-1; Fri, 09 Jul 2021 07:36:25 -0400
X-MC-Unique: EZdd70dSPmqpcQgCQCHDeA-1
Received: by mail-ed1-f70.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso5075157edd.14
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 04:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0OcA0NiDPyHjWy8/Rt+bgKSOiJGaZbsmJimq14lPbh0=;
        b=ElS8kUM8WnM6XnxbQkhNlyiHmEAPKy3sqeJjH6uGqYcB6gKWkqii1h3RlG9cGoUWDT
         6OBdjqNge2WIYYuQd9Yl4C7sy8z3ipS+9yzmtxytFW/YmsE8m6qk3ljBY3T4KiiVhDyB
         oq93ZvcNqE+jgziEYSZUk7lqLFzM6knChKGeLvQt6G96hnIP0S8CJozYfSVCEHMasceU
         0zdWtqyztGRbEN9f0isKfxFnj8WlNxP0lFcHEhfKrYlr9I9neohuIduHsJSvmFmxeQn4
         kwdA3XR5Thx9Hms+z3Mb9ps/N+PmI4K8p2rN9HeIWF11xcvjGB1pd5WT1tCbr6Esi1S2
         wMUA==
X-Gm-Message-State: AOAM532gSt9VKO7wmll8iMG28yZYNG0OfYZ2v307iSAeGDk+sSiHbR/S
        wK8E31wyZljd4ABYIU/EAK+mP2cOLWHt/SvKpkYOaCOkM8empGu3DN6NinpwMZK10m8LL+YyhGI
        PhOKP204rvACntj5r
X-Received: by 2002:a17:906:38f:: with SMTP id b15mr11359965eja.186.1625830584245;
        Fri, 09 Jul 2021 04:36:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGnb58qb7OOjvkU3chVhCrfX8pHwkL/UrnCYSF6HNcAn0J7692jf4clrlhijAaLaDHfz8N1Q==
X-Received: by 2002:a17:906:38f:: with SMTP id b15mr11359931eja.186.1625830583879;
        Fri, 09 Jul 2021 04:36:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g8sm2865498edw.89.2021.07.09.04.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 04:36:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6FDF4180733; Fri,  9 Jul 2021 13:36:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool op
In-Reply-To: <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
 <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
 <878s2fvln4.fsf@toke.dk>
 <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Jul 2021 13:36:22 +0200
Message-ID: <87zguvu3bd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> Hello,
>
> On Fri, 2021-07-09 at 12:15 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > @@ -224,10 +226,49 @@ static void veth_get_channels(struct net_device =
*dev,
>> >  {
>> >  	channels->tx_count =3D dev->real_num_tx_queues;
>> >  	channels->rx_count =3D dev->real_num_rx_queues;
>> > -	channels->max_tx =3D dev->real_num_tx_queues;
>> > -	channels->max_rx =3D dev->real_num_rx_queues;
>> > +	channels->max_tx =3D dev->num_tx_queues;
>> > +	channels->max_rx =3D dev->num_rx_queues;
>> >  	channels->combined_count =3D min(dev->real_num_rx_queues, dev->real_=
num_tx_queues);
>> > -	channels->max_combined =3D min(dev->real_num_rx_queues, dev->real_nu=
m_tx_queues);
>> > +	channels->max_combined =3D min(dev->num_rx_queues, dev->num_tx_queue=
s);
>> > +}
>> > +
>> > +static int veth_close(struct net_device *dev);
>> > +static int veth_open(struct net_device *dev);
>> > +
>> > +static int veth_set_channels(struct net_device *dev,
>> > +			     struct ethtool_channels *ch)
>> > +{
>> > +	struct veth_priv *priv =3D netdev_priv(dev);
>> > +	struct veth_priv *peer_priv;
>> > +
>> > +	/* accept changes only on rx/tx */
>> > +	if (ch->combined_count !=3D min(dev->real_num_rx_queues, dev->real_n=
um_tx_queues))
>> > +		return -EINVAL;
>> > +
>> > +	/* respect contraint posed at device creation time */
>> > +	if (ch->rx_count > dev->num_rx_queues || ch->tx_count > dev->num_tx_=
queues)
>> > +		return -EINVAL;
>> > +
>> > +	if (!ch->rx_count || !ch->tx_count)
>> > +		return -EINVAL;
>> > +
>> > +	/* avoid braking XDP, if that is enabled */
>> > +	if (priv->_xdp_prog && ch->rx_count < priv->peer->real_num_tx_queues)
>> > +		return -EINVAL;
>> > +
>> > +	peer_priv =3D netdev_priv(priv->peer);
>> > +	if (peer_priv->_xdp_prog && ch->tx_count > priv->peer->real_num_rx_q=
ueues)
>> > +		return -EINVAL;
>>=20
>> An XDP program could be loaded later, so I think it's better to enforce
>> this constraint unconditionally.
>
> The relevant check is already present in veth_xdp_set(), the load will
> be rejected with an appropriate extack message.

Ah, right, of course; silly me, that's fine then... :)

> I enforcing the above contraint uncontiditionally will make impossible
> changing the number of real queues at runtime, as we must update dev
> and peer in different moments.
>
>> (What happens on the regular xmit path if the number of TX queues is out
>> of sync with the peer RX queues, BTW?)
>
> if tx < rx, the higly number of rx queue will not be used, if rx < tx,
> XDP/gro can't take place: the normal veth path is used.

Right, OK, that's probably also fine then :)

-Toke

