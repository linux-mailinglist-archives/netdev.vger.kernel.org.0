Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6570C3A22C3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhFJD2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJD2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 23:28:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AFAC06175F
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 20:16:05 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj8so31084666edb.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 20:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sFWAe2ALPDKGhy3OZyUvHuuEB8Ewhkz6l9ClApaZjNo=;
        b=XPY5fqVrtCZq5R90ISxsw+IakFoZ38rNGIqlncqohjQUihGjjpGgBW2YzwyIAtdEEJ
         rjaGlnz0iAXwg0zEjdLAXPRAwTHVPzUoAw1qTonYyhPrK+L5ZWjDhMcU3tGekDUm4APq
         Nug2o3kExNv1UeSA54+KnoBbmQW658pD/Y38QLuz8wvwK50QZw3bxyzyI9n+ZME+FOkR
         dVAu3EmNpEMQdE3PZFmPXh7361zv5XS6qyDaSVKNhBh3PR35DJJRvnJPYioy49+ZcNKf
         WV0lZ914uS8mcw46HKeIcqgxUgGqhQ1DOac8ceKMRxwR3T6gaAx1GMXUNvn0z1aFq2Ly
         qigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sFWAe2ALPDKGhy3OZyUvHuuEB8Ewhkz6l9ClApaZjNo=;
        b=nUFVjndmBfi2edprdAN1Kpw7xpwpTwFhv9uAd5MJtynD+nir0kTQ6pirSz0YVsUsNC
         BD8NYcpHejCxQ/jxXvu2k4fWQrvMfX+EYm39OPP9CYMslKUqxk4XhxGFlD1qD/1jm4Ii
         MJe2VAqKvJSi5YddY32x4HOQJO6ykLtufhw90JDH7elg2K3Hr4anhp4xANZ8ZZCGxRUk
         Fit6UiIbm0jzQ3oUwAKGa6iZx092v4YByC9WW4pfZVNrZX+tdmOpKw870TPQ+3g9oHf1
         4Wa+20WDMo44RxZxLR9xcl1R9V2ryIowJofaceuWACFZuwD/HU5tOGxkEzKg/d/Cfjxa
         IvLw==
X-Gm-Message-State: AOAM5300O2F2t3qBwXO08suXi0LRL1W+yB9mExOMcULEkdoLCyzdtlQt
        e0eddgaPF0yMRvJiuCnqkDtNgK4GNKhJow==
X-Google-Smtp-Source: ABdhPJzBRA6MzZWt9ByVJ2B9H7rHTko9M+hk2ctkNoSxjIv80/nagDAOdQFSVyFc5K9eisjmHOFzBA==
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr2482961edw.322.1623294963849;
        Wed, 09 Jun 2021 20:16:03 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id p13sm471847ejr.87.2021.06.09.20.16.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:16:03 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id m3so10703wms.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 20:16:02 -0700 (PDT)
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr408383wmq.70.1623294962541;
 Wed, 09 Jun 2021 20:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
In-Reply-To: <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Jun 2021 23:15:25 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
Message-ID: <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 11:09 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/9 =E4=B8=8A=E5=8D=881:02, Tanner Love =E5=86=99=E9=81=93=
:
> >   retry:
> > -                     if (!skb_flow_dissect_flow_keys_basic(NULL, skb, =
&keys,
> > +                     /* only if flow dissection not already done */
> > +                     if (!static_branch_unlikely(&sysctl_flow_dissect_=
vnet_hdr_key) &&
> > +                         !skb_flow_dissect_flow_keys_basic(NULL, skb, =
&keys,
> >                                                             NULL, 0, 0,=
 0,
> >                                                             0)) {
>
>
> So I still wonder the benefit we could gain from reusing the bpf flow
> dissector here. Consider the only context we need is the flow keys,

Maybe I misunderstand the comment, but the goal is not just to access
the flow keys, but to correlate data in the packet payload with the fields
of the virtio_net_header. E.g., to parse a packet payload to verify that
it matches the gso type and header length. I don't see how we could
make that two separate programs, one to parse a packet (flow dissector)
and one to validate the vnet_hdr.

> we
> had two choices
>
> a1) embed the vnet header checking inside bpf flow dissector
> a2) introduce a dedicated eBPF type for doing that
>
> And we have two ways to access the vnet header
>
> b1) via pesudo __sk_buff
> b2) introduce bpf helpers
>
> I second for a2 and b2. The main motivation is to hide the vnet header
> details from the bpf subsystem.

b2 assumes that we might have many different variants of
vnet_hdr, but that all will be able to back a functional
interface like "return the header length"? Historically, the
struct has not seen such a rapid rate of change that I think
would warrant introducing this level of indirection.

The little_endian field does demonstrate one form of how
the struct can be context sensitive -- and not self describing.

I think we can capture multiple variants of the struct, if it ever
comes to that, with a versioning field. We did not add that
right away, because that can be introduced later, when a
new version arrives. But we have a plan for the eventuality.
>
> Thanks
>
