Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3451AF832
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDSHVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSHVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:21:40 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C591EC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 00:21:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a81so7567591wmf.5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 00:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YiPd2NofDEMNB3Mwf+zO+1JRzl9rIW01jwpo7RFio6s=;
        b=oZR4z69hDUVl69qd6cXCm3lcBwV0acCyZpP++9hCDSyDBGrCG83SgOVfBlnvND/GT4
         jdtECNhrHYCibx43z5Yhl32EkfV1n1PY+qsUjSVF6uDPANXlfozXxolm3dB0gBHXc8LN
         gBCTWXBD89ExK1RkezdNEf133XH7h/rWxbJ8NnqIeuAJePES4ttsRw/SgO9VD5eBWtLZ
         o00g9euCYd1J4x4w9MZgONrRWOJ7i+onroHk71bB4oc4NtMxry4eky9AsRvNspFlVCv4
         A+DVl5tYpetxiZO965/2M+WcM7XeoQPfwc8zknq1cUtiAYsLdkltuuAZZ77KgOegmGRw
         pLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YiPd2NofDEMNB3Mwf+zO+1JRzl9rIW01jwpo7RFio6s=;
        b=b6yt7H6Z3m9I+mJ5PqdWkwCa4iQEvmNs/4Tk+q1jb6usdGXMP+NmPdPDRmXHMGWHaA
         /mn9RHYHklLx3gCQudySdXwpWni6Gfxxym1TYFkCjs5+rx6jQopqS9DCROarbodrjTnH
         NYFOKDdeqMTedmCE0Np1JR+0MbW8xlCwe4j+d29nznsvPhXdj9R8SfZx5wPKNv/0N5Gt
         tZNucyMB2ckgoJWlZ8uKAjzpiWho0dg+eQM8w9fV3HstfNsoh6oE2NEF1albY7nyterD
         oiJV61P6h5xMOZfb5cXX7TS/JKSZO+D8cof9SH7W4dDTHEgmyq2ewLm0I2R0hzfJOS+L
         j1Yw==
X-Gm-Message-State: AGi0PuZXEHtzTKP2SMNeToWPvhfg+mpItRAL6tAKMJYL5A7UfPT92evY
        ajrm6cFlPI6PWWeaOFq7jJrHWmGkVGsgBmDCxmqP9xdz
X-Google-Smtp-Source: APiQypJu8Ti2PjLKTmC8sFofS8RLugg5qE2QF2aEKWndhhn1Q8QtkkMYGf0K3lZoQT1vzYYSoRYKO1c5wQ7tbF0IQO0=
X-Received: by 2002:a1c:e284:: with SMTP id z126mr12106519wmg.32.1587280898511;
 Sun, 19 Apr 2020 00:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <ba8d9777f2da2906e744cace0836dc579190ccd7.1586509561.git.lucien.xin@gmail.com>
 <7607f06c9a9f39d8a4581dd76e6e6e5314ad2968.1586509651.git.lucien.xin@gmail.com>
 <20200415095620.GA3778335@bistromath.localdomain>
In-Reply-To: <20200415095620.GA3778335@bistromath.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 19 Apr 2020 15:26:19 +0800
Message-ID: <CADvbK_cNjMfFtSuzzbPQvNtLVBfA3+b2QoKLmdTHUKYMUdp5HA@mail.gmail.com>
Subject: Re: [PATCH ipsec] esp6: support ipv6 nexthdrs process for beet gso segment
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 5:56 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> 2020-04-10, 17:07:31 +0800, Xin Long wrote:
> > For beet mode, when it's ipv6 inner address with nexthdrs set,
> > the packet format might be:
> >
> >     ----------------------------------------------------
> >     | outer  |     | dest |     |      |  ESP    | ESP |
> >     | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
> >     ----------------------------------------------------
> >
> > Before doing gso segment in xfrm6_beet_gso_segment(), it should
> > skip all nexthdrs and get the real transport proto, and set
> > transport_header properly.
> >
> > This patch is to fix it by simply calling ipv6_skip_exthdr()
> > in xfrm6_beet_gso_segment().
> >
> > Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv6/esp6_offload.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
> > index b828508..021f58c 100644
> > --- a/net/ipv6/esp6_offload.c
> > +++ b/net/ipv6/esp6_offload.c
> > @@ -173,7 +173,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
> >       struct xfrm_offload *xo = xfrm_offload(skb);
> >       struct sk_buff *segs = ERR_PTR(-EINVAL);
> >       const struct net_offload *ops;
> > -     int proto = xo->proto;
> > +     u8 proto = xo->proto;
> >
> >       skb->transport_header += x->props.header_len;
> >
> > @@ -184,7 +184,13 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
> >               proto = ph->nexthdr;
> >       }
> >
> > -     if (x->sel.family != AF_INET6) {
> > +     if (x->sel.family == AF_INET6) {
> > +             int offset = skb_transport_offset(skb);
> > +             __be16 frag;
> > +
> > +             offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
> > +             skb->transport_header += offset;
>
> This seems a bit wrong: we start with offset = transport_offset, then
> ipv6_skip_exthdr adds the size of the extension headers to it.
>
> In a simple case where there's no extension header, ipv6_skip_exthdr
> returns offset. Now we add offset to skb->transport_header, so
> transport_header is increased, but it shouldn't have changed.
>
> What am I missing?
You're right, actually skb_transport_offset(skb) is always 0 in there.

I will post v2 with:
skb->transport_header += ipv6_skip_exthdr(skb, 0, &proto, &frag);

Thanks for reviewing.

>
> Thanks.
>
> --
> Sabrina
>
