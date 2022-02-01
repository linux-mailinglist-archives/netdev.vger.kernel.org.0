Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5014A642E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiBASsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiBASsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:48:37 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DB6C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 10:48:36 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id w14so36402145edd.10
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 10:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=APvJbfP7gh0NQs9740XQGILxgS4pqWH9kAe+LpUSRKU=;
        b=O2GzlEDvoG+PUj6ABCRIURettw6hIhJCxilPjobcxzDEqEOOMhfDxAjoQgZ+1b+pvg
         ErBB2sF9keRJ7foG2oouI9NwgZtkdDWKf5ggBprEhftJu0KP6+SY43/zY3s+YS76f5dd
         hODVj/JEo/14uJ7a4afYK4vSP1/4zOL0Rnk9ueUw8YgPTRKu4Tq/f3QGoOIZ+cYUq0z9
         6P/I9pIItdNdSaslC2YzVtmka5Zv5l1KrM8aad1F7o7TheRVxcfz/q9L7pVekjAAujwM
         5PUlQI/p4QET6bG/Y0EugxFcVktHCsEnnxD2TVYPs9sxLWg1OXwrvqOrfGQ9bYi86sag
         /Ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=APvJbfP7gh0NQs9740XQGILxgS4pqWH9kAe+LpUSRKU=;
        b=p/82W9Crit3CgatjF8StANTu5YXc0QqJ8YDSJgEaIGzKuuJGpQYhnMUPGRX6lkWJuU
         sYw2bF3jNxYVv3HrSqP/MdtFFRwXSV5iaThmWIgNqvZhwEA4suOJIjLfxQDcEDykLTeN
         FGl6s/S/dG49ejQDFYzRoJfJylm+OpTZ0oSx7KXDchqJlGOE2LOKtomVYV8mU7FNecDq
         Vx5/KKI7wicGqcp2dEj3DskceYj/DU1v2ZSC7WqWuv8zpqHNxNhgziZ/pcqqu4aC9Ja1
         QPrNp8xcN9cYrGeqQlgzBjuQHryp80FEyycgOlNReyV+OsK6B7gZTeYHThc/+eym2ywy
         emgQ==
X-Gm-Message-State: AOAM530aobqM25nxKvRADjEhuO/U2ffgL1fuLf6PsdnDx9SvS8xl9Tw/
        OMb5/x4nn4zCxhddcaDOUGvKjHEdOrIDrs1z2oaw7vC4xIZbkudn
X-Google-Smtp-Source: ABdhPJw+kYzWjgvezPUkslIE/zK0waqEC6cuqnWGSpJx/bOqveGwtto6Zbhg10v0bUZrPfE4rQlHb6hcZQ1mgAmIa0I=
X-Received: by 2002:aa7:d412:: with SMTP id z18mr15792268edq.231.1643741315042;
 Tue, 01 Feb 2022 10:48:35 -0800 (PST)
MIME-Version: 1.0
References: <20220201184640.756716-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201184640.756716-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 1 Feb 2022 13:47:58 -0500
Message-ID: <CACSApvZ8vXXJ_zKf_HpoVgACwWxS2UvBw9QCv1ZnPX9ZpF3D_g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 1:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> tcp_shift_skb_data() might collapse three packets into a larger one.
>
> P_A, P_B, P_C  -> P_ABC
>
> Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
> because it was enough.
>
> In commit 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions"),
> this call was replaced by a call to tcp_skb_can_collapse(P_A, P_B)
>
> But the now needed test over P_C has been missed.
>
> This probably broke MPTCP.
>
> Then later, commit 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> added an extra condition to tcp_skb_can_collapse(), but the missing call
> from tcp_shift_skb_data() is also breaking TCP zerocopy, because P_A and P_C
> might have different skb_zcopy_pure() status.
>
> Fixes: 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions")
> Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

I wish there were some packetdrill tests for MPTCP. Thank you for the fix!

> ---
>  net/ipv4/tcp_input.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index dc49a3d551eb919baf5ad812ef21698c5c7b9679..bfe4112e000c09ba9d7d8b64392f52337b9053e9 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1660,6 +1660,8 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
>             (mss != tcp_skb_seglen(skb)))
>                 goto out;
>
> +       if (!tcp_skb_can_collapse(prev, skb))
> +               goto out;
>         len = skb->len;
>         pcount = tcp_skb_pcount(skb);
>         if (tcp_skb_shift(prev, skb, pcount, len))
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
