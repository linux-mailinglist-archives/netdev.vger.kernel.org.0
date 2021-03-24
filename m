Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB359346F49
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 03:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhCXCOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 22:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhCXCOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 22:14:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C84C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:13:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x21so25805415eds.4
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4S7ATnAj94hgmdbhqclSsqhCbeP141Mqyrh4e4zIqKc=;
        b=qNUYNE7Mmy4tFn4Vv22OFj6Ef5U2CoVr83cwDFn+x97WZYIzeSToHIn2MGMZvnKRo3
         w1EZdWBXM1AfUfo+TBti3kDP7L79IOSVxYMdvUxn9WnjVeKCkQZTMgLaySN2fyhieDRc
         nYt1fRp2r7r2wjyiOoD7KYF4nv4URRelsQmFyu9mdOAGg9YvbwJzUofArsaD8BpKse70
         CCq06gjs6A/ytCr7b6fKQwZ0sqcX93IfoB8zUUJRS3Yj0drWFseyhI3OOUoON6YgtP62
         bioq01Ee1vuylsevUb+iWAhLWKzuIHwlr33wvWpWlGxGKUzhj1ivEkmMTQHsJP7Vkocl
         mD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4S7ATnAj94hgmdbhqclSsqhCbeP141Mqyrh4e4zIqKc=;
        b=TzpS7ns7De8cj+y3whHVELUdIyGC85bBOydSXbUyWOnNyN3urCUKCBzrrd17PJ+4hR
         DRfzMB/yZT/urndBkOJJamWDYh0eyIUsXYaJAYkrbPg1VdK6kkbCuTsybzRI171cUyT3
         3xW4/D0v8wa86IYArmxcTo+2RqXT7MREd8g4b7eJJcvf+ddYe7rkcPSfznEeK7PAKhpg
         CON2CbeifeKaMBZzQtghVC5eAq3k5arBdFS9j4G4z3CAU8ZroEvE26Liwl7BaaAjzfzw
         Zyl/xzIcYV81KILjN+3q2UMaambnQVHqGXnp0u9ZRRUCAVk0f80I+zp47xzOFj4AG1Us
         46ZQ==
X-Gm-Message-State: AOAM530AOqG7rGjjsoMWgHaDEpUq2QO65QHRHzkWQ1SPZNTZyIh+dvaX
        0KcRLlAXmaWYN76YMKxTodQ+JdA55AA=
X-Google-Smtp-Source: ABdhPJzbtjy/F922WLss+FDxeNSdSAQrAZJ32R257lMZqKMCGiWcoOTGtzJvRQJ/T+WjmoxDkdgzmw==
X-Received: by 2002:aa7:dd05:: with SMTP id i5mr877692edv.300.1616552031234;
        Tue, 23 Mar 2021 19:13:51 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id n26sm387020eds.22.2021.03.23.19.13.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 19:13:49 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id b9so22834494wrt.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:13:49 -0700 (PDT)
X-Received: by 2002:adf:fa08:: with SMTP id m8mr855278wrr.12.1616552028919;
 Tue, 23 Mar 2021 19:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <72d8fc8a6d35a74d267cca6c9eddb3ff7852868b.1616345643.git.pabeni@redhat.com>
 <CA+FuTSfpAzEEz0WZ0EqwKu3CzuvZiD1Vv5+kCos0mL=_Rudkrg@mail.gmail.com> <6d5fae11c4eecda3f59f9491426834fce8c37f7e.camel@redhat.com>
In-Reply-To: <6d5fae11c4eecda3f59f9491426834fce8c37f7e.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 22:13:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd1R1mU+yP3g=8hzdQXKjGXY=sYvozj10+25-kzTSwWfA@mail.gmail.com>
Message-ID: <CA+FuTSd1R1mU+yP3g=8hzdQXKjGXY=sYvozj10+25-kzTSwWfA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] udp: properly complete L4 GRO over UDP
 tunnel packet
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 1:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-03-22 at 09:30 -0400, Willem de Bruijn wrote:
> > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > After the previous patch the stack can do L4 UDP aggregation
> > > on top of an UDP tunnel.
> > >
> > > The current GRO complete code tries frag based aggregation first;
> > > in the above scenario will generate corrupted frames.
> > >
> > > We need to try first UDP tunnel based aggregation, if the GRO
> > > packet requires that. We can use time GRO 'encap_mark' field
> > > to track the need GRO complete action. If encap_mark is set,
> > > skip the frag_list aggregation.
> > >
> > > On tunnel encap GRO complete clear such field, so that an inner
> > > frag_list GRO complete could take action.
> > >
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  net/ipv4/udp_offload.c | 8 +++++++-
> > >  net/ipv6/udp_offload.c | 3 ++-
> > >  2 files changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > > index 25134a3548e99..54e06b88af69a 100644
> > > --- a/net/ipv4/udp_offload.c
> > > +++ b/net/ipv4/udp_offload.c
> > > @@ -642,6 +642,11 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
> > >                 skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
> > >                                         : SKB_GSO_UDP_TUNNEL;
> > >
> > > +               /* clear the encap mark, so that inner frag_list gro_complete
> > > +                * can take place
> > > +                */
> > > +               NAPI_GRO_CB(skb)->encap_mark = 0;
> > > +
> > >                 /* Set encapsulation before calling into inner gro_complete()
> > >                  * functions to make them set up the inner offsets.
> > >                  */
> > > @@ -665,7 +670,8 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
> > >         const struct iphdr *iph = ip_hdr(skb);
> > >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> > >
> > > -       if (NAPI_GRO_CB(skb)->is_flist) {
> > > +       /* do fraglist only if there is no outer UDP encap (or we already processed it) */
> > > +       if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
> >
> > Sorry, I don't follow. I thought the point was to avoid fraglist if an
> > outer udp tunnel header is present. But the above code clears the mark
> > and allows entering the fraglist branch exactly when such a header is
> > encountered?
>
> The relevant UDP packet has gone through:
>
> [l2/l3 GRO] -> udp_gro_receive  -> udp_sk(sk)->gro_receive -> [some
> more GRO layers] -> udp_gro_receive (again)
>
> The first udp_gro_receive set NAPI_GRO_CB(skb)->encap_mark, the
> latter udp_gro_receive set NAPI_GRO_CB(skb)->is_flist.
>
> Then, at GRO complete time:
>
> [l2/l3 GRO] -> udp{4,6}_gro_complete -> udp_sk(sk)->gro_complete ->
> [more GRO layers] -> udp{4,6}_gro_complete (again).
>
> In the first udp{4,6}_gro_complete invocation 'encap_mark' is 1, so
> with this patch we do the 'udp_sk(sk)->gro_complete' path. In the
> second udp{4,6}_gro_complete invocation 'encap_mark' has been cleared
> (by udp_gro_complete), so we do the SKB_GSO_FRAGLIST completion.
>
> In case SKB_GSO_FRAGLIST with no UDP tunnel, 'encap_mark' is 0 and we
> do the SKB_GSO_FRAGLIST completion.
>
> Another alternative, possibly more readable, would be avoid clearing
> 'encap_mark' in udp_gro_complete() and replacing the above check with:
>
>         if (NAPI_GRO_CB(skb)->is_flist &&
>             (!NAPI_GRO_CB(skb)->encap_mark ||
>              (NAPI_GRO_CB(skb)->encap_mark && skb->encapsulation))) {
>
> I opted otherwise to simplify the conditional expression.
>
> Please let me know if the above is somewhat more clear and if you have
> preferecens between the two options.

Got it now, thanks. Yes, this patch makes sense.

When the GRO layer has built a GSO packet with both inner UDP
(GSO_UDP_L4) and UDP tunnel header (GSO_UDP_TUNNEL), then on
completion udp{4,6}_gro_complete will be called twice. This function
will enter its is_flist branch immediately, even though that is only
correct on the second call, as GSO_FRAGLIST is only relevant for the
inner packet. Skip this while encap_mark == 1, identifying processing
of the outer tunnel header. Clear the field to enter the path on the next
round, for the inner header.

This is subject to only supporting a single layer of encap, but that
is indeed the current state afaik.
