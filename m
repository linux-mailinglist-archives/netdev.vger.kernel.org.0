Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B663C5D68
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhGLNkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:40:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhGLNkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626097040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0B6y9XvXor57GA/hxJxR7W6Fn894NQsjTKulVQ8mTK4=;
        b=ey7L/lga4G4K6iAyPtHW9pL1c9h2BMvUo8isQKiCiVWiGuo4Z1PTGzJnqu7xF0drdJGSuJ
        l5RrwD7xDCX1upXej4UVXjSUN5uX1fueqw8Scjnq19NUoS1g0UY8XE1c5pt+BKZo/aA7N9
        ns19Z0DEXvUVLKCC3qYUuZK9H8tx82w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-zfxEE70BMriwtN0Tl6W7Ug-1; Mon, 12 Jul 2021 09:37:19 -0400
X-MC-Unique: zfxEE70BMriwtN0Tl6W7Ug-1
Received: by mail-wm1-f71.google.com with SMTP id f16-20020a1c6a100000b0290210c73f067aso2893579wmc.6
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 06:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0B6y9XvXor57GA/hxJxR7W6Fn894NQsjTKulVQ8mTK4=;
        b=cEkX9xOMIbBFsBMSpHpASW1ODQ0/pjfjDT0gsCj7ElsWq0u8Qr7QzW6VS1wrykyUFx
         fFUBGJBeAuyNsadEiPciceeZZCJZTnuOBQHN4magbYzuX9GOagoqcKpbTvhLgipfCv9M
         MhckHQQI4hfA9GydYTBreFZIu76sZHU/Qo0z7y3iiwRVGlKMlc7aD8b1pfI049uY8LFM
         TYiBDdasWQavUDSzQmYzL2DRFdzy2rGFGbM3epti0+BsGR1QWirIWxNFO7K1xzhvuco5
         Z8a8vzZ89h3jWKyM//BjkPQ8GRAg00eAa11CGfEj9vVm1TGMdpUFMWdJkALtDM15d39c
         gpww==
X-Gm-Message-State: AOAM533FmsrGOwmWKnPVIHLzt4emV8fMUrfhnOMAt4ajH/YZ/4aPK/5M
        H6GubVeLKAnh3TgOpA/+/6vKxtlJukR7puUaQtpkBFtIbsAB1CAw3BL//TQ2SIC8MHWM9f4cZcP
        2ad738UyR1vSKy3Dm
X-Received: by 2002:adf:a183:: with SMTP id u3mr39567070wru.175.1626097038496;
        Mon, 12 Jul 2021 06:37:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQvEjXp9mjD/4zB+hRQSwhkk3YjPcsE+XjvthJ54/x4Qhs7aE9axkgGisoHf47SJC870FIsA==
X-Received: by 2002:adf:a183:: with SMTP id u3mr39567043wru.175.1626097038205;
        Mon, 12 Jul 2021 06:37:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id c125sm18948351wme.36.2021.07.12.06.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 06:37:17 -0700 (PDT)
Message-ID: <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 15:37:16 +0200
In-Reply-To: <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-3-vfedorenko@novek.ru>
         <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
         <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 13:45 +0100, Vadim Fedorenko wrote:
> 
> > After this patch, the above chunk will not clear 'sk' for packets
> > targeting ESP in UDP sockets, but AFAICS we will still enter the
> > following conditional, preserving the current behavior - no ICMP
> > processing.
> 
> We will not enter following conditional for ESP in UDP case because
> there is no more check for encap_type or encap_enabled. 

I see. You have a bug in the ipv6 code-path. With your patch applied:

---
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
                               inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
        if (sk && udp_sk(sk)->encap_enabled) {
		//...
        }

        if (!sk || udp_sk(sk)->encap_enabled) {
	// can still enter here...
---	

> I maybe missing something but d26796ae5894 doesn't actually explain
> which particular situation should be avoided by this additional check
> and no tests were added to simply reproduce the problem. If you can
> explain it a bit more it would greatly help me to improve the fix.

Xin knows better, but AFAICS it used to cover the situation you
explicitly tests in patch 3/3 - incoming packet with src-port == dst-
port == tunnel port - for e.g. vxlan tunnels.

> > Why can't you use something alike the following instead?
> > 
> > ---
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index c0f9f3260051..96a3b640e4da 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
> >          sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
> >                                 iph->saddr, uh->source, skb->dev->ifindex,
> >                                 inet_sdif(skb), udptable, NULL);
> > -       if (!sk || udp_sk(sk)->encap_type) {
> > +       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
> >                  /* No socket for error: try tunnels before discarding */
> >                  sk = ERR_PTR(-ENOENT);
> >                  if (static_branch_unlikely(&udp_encap_needed_key)) {
> > 
> > ---

Could you please have a look at the above ?

Thanks!

/P

