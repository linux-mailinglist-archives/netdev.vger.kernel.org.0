Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C51AF833
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSHXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSHXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:23:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23FCC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 00:23:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a25so8060658wrd.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 00:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tz6tV5SlMTwt/MJHoHeeb3ibx0pZJPykEQQLlJO9HaA=;
        b=WaDI5+lJjEhGlJX+SqOxif9E2ChlCvEelu5fE3rCCSsmoTfkuiZU54BHSg7XlvqDVf
         ZhHu5nd+Wb88RBJuwl/4IULQ2OVd1ylJsz14OgFyjZCrv/RQ83ymKwG/FmWecwqO/t+H
         UXGWmRJurrcIEQhekcm7L71RK3D4quPyiAIDfAJJltv04RJc4nswazpsl/9n5wNs7iyr
         nw5zbqA+oId/UiAF+iD9Y0zSYGTS27KxgJRtuzbB9FAk+jzUYKBHNzbVeiHETPjNaUPd
         suAaEKyoj2zmgUzyzlIdXc/4ayevVEgXHfx+GOoO+T5LlaUxgKlgMWGRrwEJtEdIFpoP
         GoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tz6tV5SlMTwt/MJHoHeeb3ibx0pZJPykEQQLlJO9HaA=;
        b=Bn/PI1fIWB03JgQGlJAUhOKXCA6JzRAVFmHCRoxQ2L3wos9CGx/GRkASYnU9AunCML
         KD9DPsW5U04xgaOYynY31EEslm3El5daVxrsxXo0df6ZWqwbJV4xquSQhZROL1DRbQVn
         RZdTPNxuhVZTg9eNl30kx/vDzWiDSi8TwfjfNnm1sptDXok9VXYoux/yulclCgCtkG4X
         hw0dRpTjFGaGY5kiuVHNODDb+OW52xZNxJ2zJfaf66vmJaf5Uo1zJynpWR+G7e1L3fdN
         Twobqg13Zs2i3K/jheYT2pnqyQulffsbGXoqCqxsecWbRbriwFreo8q7OFjlZaOYkIFg
         6FEw==
X-Gm-Message-State: AGi0Pua+rV+rEiuIrnLwjeymk0SNvUbKr2qKKeFzEz1bMhEediwOI5la
        GF6kvC4BqvoVM2oyYssK5dQC58XAJyk+kCLuiuPBDA==
X-Google-Smtp-Source: APiQypId+oU0F9r+yPqWn1P0bLPkn+BEcL9axbLslNFVGHtFsLGI/GCY6LMY4qRTfkQXSIJFjP7zGfCTGm/MgXBzlRo=
X-Received: by 2002:a5d:4447:: with SMTP id x7mr12354671wrr.299.1587280981306;
 Sun, 19 Apr 2020 00:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <b1b39c63ff48deca9e7c8011d747dcf4db05a6c1.1586509678.git.lucien.xin@gmail.com>
In-Reply-To: <b1b39c63ff48deca9e7c8011d747dcf4db05a6c1.1586509678.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 19 Apr 2020 15:27:42 +0800
Message-ID: <CADvbK_cPp9Md06wXG19fF2jxFr7v07rnCNa5tmXGHOjNM9Ew1g@mail.gmail.com>
Subject: Re: [PATCH ipsec] esp4: support ipv6 nexthdrs process for beet gso segment
To:     network dev <netdev@vger.kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 5:08 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> For beet mode, when it's ipv6 inner address with nexthdrs set,
> the packet format might be:
>
>     ----------------------------------------------------
>     | outer  |     | dest |     |      |  ESP    | ESP |
>     | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
>     ----------------------------------------------------
>
> Before doing gso segment in xfrm4_beet_gso_segment(), the same
> thing is needed as it does in xfrm6_beet_gso_segment() in last
> patch 'esp6: support ipv6 nexthdrs process for beet gso segment'.
>
> Fixes: 384a46ea7bdc ("esp4: add gso_segment for esp4 beet mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/esp4_offload.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
> index 731022c..9dde4e3 100644
> --- a/net/ipv4/esp4_offload.c
> +++ b/net/ipv4/esp4_offload.c
> @@ -139,7 +139,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
>         struct xfrm_offload *xo = xfrm_offload(skb);
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         const struct net_offload *ops;
> -       int proto = xo->proto;
> +       u8 proto = xo->proto;
>
>         skb->transport_header += x->props.header_len;
>
> @@ -148,10 +148,16 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
>
>                 skb->transport_header += ph->hdrlen * 8;
>                 proto = ph->nexthdr;
> -       } else if (x->sel.family != AF_INET6) {
> +       } else if (x->sel.family == AF_INET6) {
> +               int offset = skb_transport_offset(skb);
> +               __be16 frag;
> +
> +               offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
> +               skb->transport_header += offset;
And this one too.

> +               if (proto == IPPROTO_TCP)
> +                       skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
> +       } else {
>                 skb->transport_header -= IPV4_BEET_PHMAXLEN;
> -       } else if (proto == IPPROTO_TCP) {
> -               skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
>         }
>
>         __skb_pull(skb, skb_transport_offset(skb));
> --
> 2.1.0
>
