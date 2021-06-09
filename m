Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D273A1DD3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 21:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhFITsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 15:48:20 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:33651 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFITsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 15:48:19 -0400
Received: by mail-ed1-f54.google.com with SMTP id f5so24883385eds.0
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 12:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHlW+S5466iVOZLyCOhoxRhctVC3g1V4iMRZKlGZs/I=;
        b=WMQsyVo0Jegz15yNBpHu0sswY2d/44EuG6bq9/6aI580rKI4ZJtBz8IyT3wDJzUPNG
         yLo3t2nm2lfjMVbR4wm2TQelNrCiRxMk4ZTKQLaoMnPnD1sfwuMuamz7N02VwmgGx5wr
         vH51ZCJic9rCx1jcgaPz5Wv7SoEYEXHV4RYCLGq4koR6l8r1y0ZZVfaY8ngUV27g0TGv
         21KETKMwXsywMnUAG6NZVB7oa/K4iyz0LGQDdXcFPBAoua3QYqveNygBRR0f+cl+13Pw
         BkNoYN2ePYlJDwiwmsD8VT3TGQK8wdDmLk4GcgxBu/+1Rv8HZNLYpjbRkGTLgvFrkrBZ
         S96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHlW+S5466iVOZLyCOhoxRhctVC3g1V4iMRZKlGZs/I=;
        b=UZp2ny+vsMbP7iEEsyEN98XPtUocMy7PrIEhKm0yXLiyCwKVDNOkFF3Sc3x6irphqj
         U/iDfvoxNHTgtyZ/lSf9YD1je8hm9U8P1exGdq1p2/HbP/IxEaCy15JPFPhHgaCeXjpR
         lL9DNKJfBZrkLW6QuYFfyC37G8xKWQlvfw/mlMNzWbta65rxq9Mot62Ha32Rd+eJ/5Wf
         1UruY01/kuNF/ICvR6cO42wmYICRAmLq4C3G382KGEkiNwHqvPupKYylbUExgExJ0FnA
         MY6lAEVbOeWtV1aWKSAIkZU35kdsKQP09z3K4k20GpNBS/uZzskYdpIqn+wwdYOoATb+
         Jsdg==
X-Gm-Message-State: AOAM532zGS3jSViP33p6LqcgTuBgmqhlPGehRQZAq52rll8bWu35Sr2u
        1e6kcePomJxLbuSxlfgd7Xz7LH1Na+k=
X-Google-Smtp-Source: ABdhPJyVhzp53ymJDsgrYdk3/3ZMYlJL3jdbF8Wb6kP3lFbprA1qClznBSIk9ETaZwjSOZ5HF8d4PQ==
X-Received: by 2002:aa7:cf0f:: with SMTP id a15mr993795edy.313.1623267923943;
        Wed, 09 Jun 2021 12:45:23 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id r2sm227426ejc.78.2021.06.09.12.45.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 12:45:23 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso5053496wmg.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 12:45:22 -0700 (PDT)
X-Received: by 2002:a1c:2456:: with SMTP id k83mr1405196wmk.87.1623267922516;
 Wed, 09 Jun 2021 12:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <87a6nzrqe0.fsf@factor-ts.ru>
In-Reply-To: <87a6nzrqe0.fsf@factor-ts.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Jun 2021 15:44:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf7WbEN_yhf_LR9RxZzgxHUcdb-OeMEA2--rci+HN2dqw@mail.gmail.com>
Message-ID: <CA+FuTSf7WbEN_yhf_LR9RxZzgxHUcdb-OeMEA2--rci+HN2dqw@mail.gmail.com>
Subject: Re: [PATCH] udp: compute_score and sk_bound_dev_if regression
To:     Peter Kosyh <p.kosyh@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Mikhail Smirnov <smirnov@factor-ts.ru>,
        "David S. Miller" <davem@davemloft.net>,
        mmanning@vyatta.att-mail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 11:50 AM Peter Kosyh <p.kosyh@gmail.com> wrote:
>
>
> udp: commit 6da5b0f027a825df2aebc1927a27bda185dc03d4

For completeness, this is commit 6da5b0f027a8 ("net: ensure unbound
datagram socket to be chosen when not in a VRF"). Adding the author.

> introduced regression in compute_score() Previously for addr_any sockets an
> interface bound socket had a higher priority than an unbound socket that
> seems right. For example, this feature is used in dhcprelay daemon and now it
> is broken.
> So, this patch returns the old behavior and gives higher score for sk_bound_dev_if sockets.
>
> Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
> ---
>  net/ipv4/udp.c | 3 ++-
>  net/ipv6/udp.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 15f5504adf5b..4239ffa93c6f 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -390,7 +390,8 @@ static int compute_score(struct sock *sk, struct net *net,
>                                         dif, sdif);
>         if (!dev_match)
>                 return -1;
> -       score += 4;
> +       if (sk->sk_bound_dev_if)
> +               score += 4;
>
>         if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
>                 score++;
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 199b080d418a..c2f88b5def25 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -133,7 +133,8 @@ static int compute_score(struct sock *sk, struct net *net,
>         dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
>         if (!dev_match)
>                 return -1;
> -       score++;
> +       if (sk->sk_bound_dev_if)
> +               score++;
>
>         if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
>                 score++;
> --
> 2.31.1
