Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279FC35A1D4
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhDIPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233970AbhDIPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617981485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lzkhCVK52hr31xmspSzO3ZwZPmZ41f+SKZiEeiUdlTY=;
        b=giOVrJcMCJrr8U1pWQ3ZQ//nb3v/RG4iTBFLi86RnP6z0E4R/FGJetuVbhrzllFSzAlJGr
        0RN7nBPIrPVhu/jPOylhRU+RMriCUliTZPPmVkN2WcNfwRip8DlB8jVv6nD4cbCCPKKvhH
        aFy+FXGt66DUg6CqpW8id/PyiHfI7tI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-7Id3aXVnMM21llCBOIKPRA-1; Fri, 09 Apr 2021 11:18:03 -0400
X-MC-Unique: 7Id3aXVnMM21llCBOIKPRA-1
Received: by mail-ed1-f69.google.com with SMTP id r6so2825546edh.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 08:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lzkhCVK52hr31xmspSzO3ZwZPmZ41f+SKZiEeiUdlTY=;
        b=HsgZLAst5KCTqy76mzMBPJw4HridFPNaDqqpt1zGI5WprQYKaxH0tEcDjGRNAHKZq+
         NZQlktl9/IMAUrOz0jLAH3ZMl8UoCf7qrt1dBmEovmZD3L55DmP39fFQ2gQHV8FfOIbC
         KSZmr8+dGkt9p27KTtTO1VnxM/uPWA/5ehHnNPG6IWPCKPmakan13ZLh1Z6//G2kEw6W
         n6jE6jN7w6Ao/7FKflg6iHu8RuJjdidEgq8Cu08VGS0rEMLZxNXBQQrP3dCPRmCRiKgb
         3PXyTTkUiVoAAL8WD5JVoUwDTrKuo4vKCujc6gfFmjQVENtmYkNJivK3VrURklXft7Rg
         6ptQ==
X-Gm-Message-State: AOAM5337Nx6JpJVVkDz+51/c4QawxZeVw7Pizqw+lm/GXTKIgV4e6Owv
        cGopYJB4IcoblA8fo1YXkT4dZFTzXmMCUZO6mnwJpdF9zkkyRR/S0mDkCdKDYTmNh88//NwXrKt
        /Xvc6moaobjEc1sEw
X-Received: by 2002:a05:6402:506:: with SMTP id m6mr17451111edv.157.1617981482754;
        Fri, 09 Apr 2021 08:18:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymS62nOm80UnwppTePIk0gQ2wTDphixuxwtNg89hpfO/rpWJ8D8x8IT5eqPoHhWdY+2VAj+w==
X-Received: by 2002:a05:6402:506:: with SMTP id m6mr17451096edv.157.1617981482585;
        Fri, 09 Apr 2021 08:18:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n3sm1348901ejj.113.2021.04.09.08.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 08:18:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 496E91802F9; Fri,  9 Apr 2021 17:18:01 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 3/4] veth: refine napi usage
In-Reply-To: <f40fd90aa5077896121b368027fa8c70e505a358.camel@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
 <b241da0e8aa31773472591e219ada3632a84dfbb.1617965243.git.pabeni@redhat.com>
 <87y2drtsic.fsf@toke.dk>
 <f40fd90aa5077896121b368027fa8c70e505a358.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Apr 2021 17:18:01 +0200
Message-ID: <87sg3ztrkm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> hello,
>
> On Fri, 2021-04-09 at 16:57 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Paolo Abeni <pabeni@redhat.com> writes:
>>=20
>> > After the previous patch, when enabling GRO, locally generated
>> > TCP traffic experiences some measurable overhead, as it traverses
>> > the GRO engine without any chance of aggregation.
>> >=20
>> > This change refine the NAPI receive path admission test, to avoid
>> > unnecessary GRO overhead in most scenarios, when GRO is enabled
>> > on a veth peer.
>> >=20
>> > Only skbs that are eligible for aggregation enter the GRO layer,
>> > the others will go through the traditional receive path.
>> >=20
>> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> > ---
>> >  drivers/net/veth.c | 23 ++++++++++++++++++++++-
>> >  1 file changed, 22 insertions(+), 1 deletion(-)
>> >=20
>> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>> > index ca44e82d1edeb..85f90f33d437e 100644
>> > --- a/drivers/net/veth.c
>> > +++ b/drivers/net/veth.c
>> > @@ -282,6 +282,25 @@ static int veth_forward_skb(struct net_device *de=
v, struct sk_buff *skb,
>> >  		netif_rx(skb);
>> >  }
>> >=20=20
>> > +/* return true if the specified skb has chances of GRO aggregation
>> > + * Don't strive for accuracy, but try to avoid GRO overhead in the mo=
st
>> > + * common scenarios.
>> > + * When XDP is enabled, all traffic is considered eligible, as the xm=
it
>> > + * device has TSO off.
>> > + * When TSO is enabled on the xmit device, we are likely interested o=
nly
>> > + * in UDP aggregation, explicitly check for that if the skb is suspec=
ted
>> > + * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
>> > + * to belong to locally generated UDP traffic.
>> > + */
>> > +static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
>> > +					 const struct net_device *rcv,
>> > +					 const struct sk_buff *skb)
>> > +{
>> > +	return !(dev->features & NETIF_F_ALL_TSO) ||
>> > +		(skb->destructor =3D=3D sock_wfree &&
>> > +		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
>> > +}
>> > +
>> >  static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *=
dev)
>> >  {
>> >  	struct veth_priv *rcv_priv, *priv =3D netdev_priv(dev);
>> > @@ -305,8 +324,10 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb,=
 struct net_device *dev)
>> >=20=20
>> >  		/* The napi pointer is available when an XDP program is
>> >  		 * attached or when GRO is enabled
>> > +		 * Don't bother with napi/GRO if the skb can't be aggregated
>> >  		 */
>> > -		use_napi =3D rcu_access_pointer(rq->napi);
>> > +		use_napi =3D rcu_access_pointer(rq->napi) &&
>> > +			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
>> >  		skb_record_rx_queue(skb, rxq);
>> >  	}
>>=20
>> You just changed the 'xdp_rcv' check to this use_napi, and now you're
>> conditioning it on GRO eligibility, so doesn't this break XDP if that
>> was the reason NAPI was turned on in the first place?
>
> Thank you for the feedback.
>
> If XDP is enabled, TSO is forced of on 'dev'
> and veth_skb_is_eligible_for_gro() returns true, so napi/GRO is always
> used - there is no functional change when XDP is enabled.

Ah, right, so it says right there in the comment; sorry for missing
that! :)

-Toke

