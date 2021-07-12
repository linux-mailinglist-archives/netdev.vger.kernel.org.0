Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1053C5DFD
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhGLOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:12:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231510AbhGLOMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626099003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=neGkZpupsKc9mPSleToe8G6vi9t5aXsb9YLyY2jJJG0=;
        b=ZJXTtkPv/ZRE7RIcsVzQ0VQTHzBqJfzBChgfWyvokBv1tKdXQcQAMLsJzKxVUOcFzezmZw
        Lt4B06sHdr4Pxv1knLoXX2okVpqWrvoEAugrhA/b+XSW3+cdaf9nuSEJEYgDzzAQAN8+vn
        p9Z1aTN2IJlCmjoTE//n5wEj9RNE/N4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-W-QjQ2TiOy68u3KGu4fiLw-1; Mon, 12 Jul 2021 10:10:02 -0400
X-MC-Unique: W-QjQ2TiOy68u3KGu4fiLw-1
Received: by mail-wm1-f72.google.com with SMTP id m31-20020a05600c3b1fb02902082e9b2132so7420184wms.5
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 07:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=neGkZpupsKc9mPSleToe8G6vi9t5aXsb9YLyY2jJJG0=;
        b=uf5xaTWLijJOL33nyGSfJhnhfmwA1+qcyhLXc15CARcTTbqh5gt5QKUxXNKJ+DvMM2
         DA+y+N+uHer1YQWCQ/xCB2ESl7NhA4OY4uOQjY5cs2W567s/M1TRst5MZQ6lDkLQkmau
         dit2fQxPfnBp8N6iuwydycfzQBwEVB+vzWypRayY9e7mO6+AKjLQYBEoqLwHidtVDfOC
         PAbKca8PWKEoaLrjis9FYAWAD9RPFqrGf/fX0rtEXkzBAPTnSdMLOH0lc8FHgTHSqChU
         vRTQHABqOweiR8pyggn3VmUieYf2d+4+paIRJvLbTCJr99ciIMQo/33UUu1WBf6gtOwC
         gKsg==
X-Gm-Message-State: AOAM5337WHIt8G7h15eoxnx/VfGYyiVmofxjcDEi9bWY9d5UZYLLbhZF
        va4nY5TfuJJn5d4ME/edTHcR0fvR/sgeRLXgoMSpU8RFQs7qs4QoVr2dxvUO5uwM584yB/1TINq
        G1lNuRGIX/SLfCIzT
X-Received: by 2002:a5d:60cb:: with SMTP id x11mr21436449wrt.355.1626099001315;
        Mon, 12 Jul 2021 07:10:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvKuLC+i2BacHXYC+ehiJSVdoUcI7nHU/FHh9lhPWUHTf2VPMEt/qKvzTmv86veBICKQXIng==
X-Received: by 2002:a5d:60cb:: with SMTP id x11mr21436429wrt.355.1626099001103;
        Mon, 12 Jul 2021 07:10:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id g15sm3961681wmh.44.2021.07.12.07.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:10:00 -0700 (PDT)
Message-ID: <81001aca6c025cb4f3dff523945f78142899eecb.camel@redhat.com>
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Mon, 12 Jul 2021 16:09:58 +0200
In-Reply-To: <74c28a85-ad6d-0b33-b5be-90b1bff7ca52@novek.ru>
References: <20210712005554.26948-1-vfedorenko@novek.ru>
         <20210712005554.26948-3-vfedorenko@novek.ru>
         <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
         <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru>
         <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
         <74c28a85-ad6d-0b33-b5be-90b1bff7ca52@novek.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 15:05 +0100, Vadim Fedorenko wrote:
> On 12.07.2021 14:37, Paolo Abeni wrote:
> > On Mon, 2021-07-12 at 13:45 +0100, Vadim Fedorenko wrote:
> > > > After this patch, the above chunk will not clear 'sk' for packets
> > > > targeting ESP in UDP sockets, but AFAICS we will still enter the
> > > > following conditional, preserving the current behavior - no ICMP
> > > > processing.
> > > 
> > > We will not enter following conditional for ESP in UDP case because
> > > there is no more check for encap_type or encap_enabled.
> > 
> > I see. You have a bug in the ipv6 code-path. With your patch applied:
> > 
> > ---
> >   	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
> >                                 inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
> >          if (sk && udp_sk(sk)->encap_enabled) {
> > 		//...
> >          }
> > 
> >          if (!sk || udp_sk(sk)->encap_enabled) {
> > 	// can still enter here...
> > ---	
> > 
> 
> Oh, my bad, thanks for catching this!
> 
> > > I maybe missing something but d26796ae5894 doesn't actually explain
> > > which particular situation should be avoided by this additional check
> > > and no tests were added to simply reproduce the problem. If you can
> > > explain it a bit more it would greatly help me to improve the fix.
> > 
> > Xin knows better, but AFAICS it used to cover the situation you
> > explicitly tests in patch 3/3 - incoming packet with src-port == dst-
> > port == tunnel port - for e.g. vxlan tunnels.
> > 
> 
> Ok, so my assumption was like yours, that's good.
> 
> > > > Why can't you use something alike the following instead?
> > > > 
> > > > ---
> > > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > > index c0f9f3260051..96a3b640e4da 100644
> > > > --- a/net/ipv4/udp.c
> > > > +++ b/net/ipv4/udp.c
> > > > @@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
> > > >           sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
> > > >                                  iph->saddr, uh->source, skb->dev->ifindex,
> > > >                                  inet_sdif(skb), udptable, NULL);
> > > > -       if (!sk || udp_sk(sk)->encap_type) {
> > > > +       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
> > > >                   /* No socket for error: try tunnels before discarding */
> > > >                   sk = ERR_PTR(-ENOENT);
> > > >                   if (static_branch_unlikely(&udp_encap_needed_key)) {
> > > > 
> > > > ---
> > 
> > Could you please have a look at the above ?
> > 
> Sure. The main problem I see here is that udp4_lib_lookup in udp_lib_err_encap
> could return different socket because of different source and destination port
> and in this case we will never check for correctness of originally found socket,
> i.e. encap_err_lookup will never be called and the ICMP notification will never
> be applied to that socket even if it passes checks.
> My point is that it's simplier to explicitly check socket that was found than
> rely on the result of udp4_lib_lookup with different inputs and leave the case
> of no socket as it was before d26796ae5894.
> 
> If it's ok, I will unify the code for check as Willem suggested and resend v2.

If the final code is small enough, please go ahead with that.

Thanks!

Paolo

