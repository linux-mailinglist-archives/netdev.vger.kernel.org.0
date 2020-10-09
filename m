Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0A2890C2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390432AbgJIS0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390429AbgJIS0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:26:52 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6DFC0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 11:26:52 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o18so10030775ill.2
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 11:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKlDCJjsvYo0P5vGdgOWIXrtulmP1H0kYGa0iLKKXug=;
        b=qD3bQm3QF9uJuQ0BumahUTm2fjD9oRHTyb27jrLD2e7n2gC3/x57epR1+1aw9fDg4I
         TrVOHp3I8w1rW1f/4CK/txoa01lN+QeHTr90kQaQVetEj+CzzlFr9dva+sXCVNotr3YX
         Lc0I6rT/BAeHwgq28Jv+WAEpAen0pMQEoyV6XiNLKZU+DKdkSKoXN7NhDRtTQA8K1gb/
         ZNOa2mNcidh95mlHApLtF/kO++5k767E5pmx7QcHhOtWvQAPDoyy33+hdNw/du0DFV/y
         sG2s5531PVaJz0sdnq1B1i0hLputvX9fJcfx63HBlmRKyh1Rc/eGUC3QhpAvbjmuNd0K
         tLfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKlDCJjsvYo0P5vGdgOWIXrtulmP1H0kYGa0iLKKXug=;
        b=HHggZ1GrjDiKKbR0su6+kREZG5qXVohUQsA3uebINjluYJcgQIuOcpeUvngoiITuNE
         5QucuFW9aE3m1yCcApLDrnhRR+ujdk88vEdMYKjG3Xi0Oa4Z0JP2L0rJKpoxS2fEbWv1
         rlPqS36IS1q6AO1OSlvuvrYIZgiEjr3mou2wvkNwU/uMUJ4H6zqhSh8fz4voWs414y5H
         RSQ9iq11Xr5AVETISG8zPK/KVFymF32K+AW7eH84aAP1mZtX6zApLMuDq20TAA+dLj5S
         DLcZZZrNRmAkjmyNm61MfhdYIPFWasNGgg6WbVd266bgdrcOqRMlvD12paKo3ONUJr9f
         2Bcw==
X-Gm-Message-State: AOAM533NAtyh/bwfFKrbjcwioQzA4biuhygYLqpQolOpB17NdxQGlpax
        qGAz4l6GGEcBdTwcxpyqb5Oy74Vq8751ti5M6BXalg==
X-Google-Smtp-Source: ABdhPJxRNqtOvFo3Li7SkaWne5Ac+csCZLTieDdE4ei2z4CwY7yiJUDbnzCKUVCadeP6dPlt10kqJRIPTnAifIZ8dKQ=
X-Received: by 2002:a92:1503:: with SMTP id v3mr11354132ilk.56.1602268011188;
 Fri, 09 Oct 2020 11:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216614239.882446.4447190431655011838.stgit@firesoul> <20b1e1dc-7ce7-dc42-54cd-5c4040ccdb30@iogearbox.net>
In-Reply-To: <20b1e1dc-7ce7-dc42-54cd-5c4040ccdb30@iogearbox.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 9 Oct 2020 11:26:40 -0700
Message-ID: <CANP3RGd7dqog_v7qPd+FJ8iCqgPS=1trzQ778yeQ=9caGfxMGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 1/6] bpf: Remove MTU check in __bpf_skb_max_len
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
> > __bpf_skb_max_len() as the max-length. This function limit size against
> > the current net_device MTU (skb->dev->mtu).
> >
> > When a BPF-prog grow the packet size, then it should not be limited to the
> > MTU. The MTU is a transmit limitation, and software receiving this packet
> > should be allowed to increase the size. Further more, current MTU check in
> > __bpf_skb_max_len uses the MTU from ingress/current net_device, which in
> > case of redirects uses the wrong net_device.
> >
> > Keep a sanity max limit of IP6_MAX_MTU (under CONFIG_IPV6) which is 64KiB
> > plus 40 bytes IPv6 header size. If compiled without IPv6 use IP_MAX_MTU.
> >
> > V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   net/core/filter.c |   16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 05df73780dd3..ddc1f9ba89d1 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3474,11 +3474,11 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
> >       return 0;
> >   }
> >
> > -static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> > -{
> > -     return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > -                       SKB_MAX_ALLOC;
> > -}
> > +#ifdef IP6_MAX_MTU /* Depend on CONFIG_IPV6 */
> > +#define BPF_SKB_MAX_LEN IP6_MAX_MTU
> > +#else
> > +#define BPF_SKB_MAX_LEN IP_MAX_MTU
> > +#endif
>
> Shouldn't that check on skb->protocol? The way I understand it is that a number of devices
> including virtual ones use ETH_MAX_MTU as their dev->max_mtu, so the mtu must be in the range
> of dev->min_mtu(=ETH_MIN_MTU), dev->max_mtu(=ETH_MAX_MTU). __dev_set_mtu() then sets the user
> value to dev->mtu in the core if within this range. That means in your case skb->dev->hard_header_len
> for example is left out, meaning if we go for some constant, that would need to be higher.

I think in the past skb->protocol was not guaranteed to be correct -
could be zero...
(with [misconfigured] raw sockets - maybe that's fixed now?)
