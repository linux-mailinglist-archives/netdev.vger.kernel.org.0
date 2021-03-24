Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A216346F0E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhCXBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhCXBtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:49:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61387C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:49:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l4so30231728ejc.10
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBC3rmjxFpZkScp/zwk+BypjKuhZfkHU74K62cdOBVs=;
        b=DAoAF/LrWZ1dC4g+zPSA8no4JPObDVnLU+udRt1BY3V71RbrQuoH783NlGey0d/2nR
         +ZHlHgh3VrYARI7kYqZFuc4YEew3Avf1vP0Q6ZHCEzQymxZqXgTm3VcCAbZVXqpLkxnD
         AMQJYniLMirm7jO1lf3oIiCn079RhwUIqOGzgBu3v/wjIDKTnlPj3dQ7uubRshJw4HmF
         5hafKeQvnmNRjwJ8QQf/tTAW1MHj8vY8n/XpLUDN0QXcR3AMxpSiapx0/3h9s4RMTL7K
         5vIf4huiyAy2gLatkAa2K+4cfDyf5pSrOquG1C1AO4ryszfQkv3RZ+Iw/3pme7bUfmDi
         2ypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBC3rmjxFpZkScp/zwk+BypjKuhZfkHU74K62cdOBVs=;
        b=nbm8XASftaNeKgyTTYArW9/Z9xynYk5e4jT4RA/xu0eGzCKKu18eK03LnQghKtT10D
         R1gZO1Gpk/GRj5AygulZFjrhZhox1SZ9U3gokP3xHkPdwKGUNTjdxh4UQ3bk4gjIcH3q
         ZwScGuXPtGi8NJM/ndHlzNRdI8SlArBCe1VYcltIqujYuIZ/yJLYp0csuPLgjvBBILrd
         tXEuoXmqtm07HOEA4pqM5G1OTSLUiXjfFcHzq1NX+zyJ3jae2JXVyPAGIwNhVoX8nJ+F
         y15hXbqZYOSF1uO/jDjbsviipehLHwyh9rzCngh4MFyjJ2YYslgmlif7vg3fJsQnnUbh
         w9nw==
X-Gm-Message-State: AOAM532ysH85QSHsJnCH+7yp4dDweQsrZX5rZEHlnoOyfilxea0+VTU5
        uGVmTk1W1/rtFrKZaIW0BNPuPlSMQDQ=
X-Google-Smtp-Source: ABdhPJxowc8ptU13GOXgVl4OIchpjhNtMC49YA5ftOgLndRL5FbcVVed+4s4Ok/q1S40j5SvEXwsVw==
X-Received: by 2002:a17:906:3f88:: with SMTP id b8mr1135987ejj.36.1616550589828;
        Tue, 23 Mar 2021 18:49:49 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id s18sm368174edc.21.2021.03.23.18.49.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 18:49:49 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id c8so9871432wrq.11
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:49:49 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr700645wru.327.1616550588777;
 Tue, 23 Mar 2021 18:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
 <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
 <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com> <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
In-Reply-To: <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 21:49:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdV=vRGtNcmtdtnEVKLCSca4HyftNEntTGXAPQRFccuMA@mail.gmail.com>
Message-ID: <CA+FuTSdV=vRGtNcmtdtnEVKLCSca4HyftNEntTGXAPQRFccuMA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > @@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
> > > >  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > >  {
> > > >         struct sk_buff *next, *segs;
> > > > +       int csum_level;
> > > >         int ret;
> > > >
> > > >         if (likely(!udp_unexpected_gso(sk, skb)))
> > > > @@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > >
> > > >         BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
> > > >         __skb_push(skb, -skb_mac_offset(skb));
> > > > +       csum_level = !!(skb_shinfo(skb)->gso_type &
> > > > +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
> > > >         segs = udp_rcv_segment(sk, skb, true);
> > > >         skb_list_walk_safe(segs, skb, next) {
> > > >                 __skb_pull(skb, skb_transport_offset(skb));
> > > > +
> > > > +               /* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
> > > > +                * instead of adding another check in the tunnel fastpath, we can force valid
> > > > +                * csums here (packets are locally generated).
> > > > +                * Additionally fixup the UDP CB
> > > > +                */

Btw, instead of this comment plus a comment in the ipv6 code that
points back to this ipv4 comment, I would move the explanation to
the udp_post_segment_fix_csum function itself.
