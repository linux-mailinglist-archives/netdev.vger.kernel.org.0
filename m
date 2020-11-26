Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8992C5A97
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404410AbgKZR3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404105AbgKZR3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:29:16 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E453C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 09:29:14 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l1so2952005wrb.9
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 09:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1yco9Hx7vfD826JXYPzlpwvCNv8vxyJXRN6noZBQd8=;
        b=F4XuwnvYU3OHWZT4IgTzYOniONsm4A92UQJAmihe86iV7FoOrqTKOeRY5P0hVZIwMc
         Xanud+3xbpB+3ARB4RhRh6rLwkqbQ+Z8cxc+0s1gPF1WvE1io+ia2D+iWLAD89Icn/5m
         hO27Zv2dG5tWTvkgLarM729ld1Mzd/Uw6iE2b2GYESO4SFG3Pb07gtR1YtATnfilDfDb
         UfOHR0ms8Q22L/t0Rdv/uZhYqy8Ub0RbGPxGIWYFpuwdii2XpSvhBtKGT5BfFIOeByOv
         quSoa6NYT6dtieA1hnu19yeN61Rrxd5BblaklfKUETNRGeDY1GJSs8/EfnEfRJd6txnO
         xLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1yco9Hx7vfD826JXYPzlpwvCNv8vxyJXRN6noZBQd8=;
        b=JlNHYR0ePjHHg8+P6TZyEEHZK5/WZi0KmUr4GYS67pND/Jhn5oYiM66OQbxgIFPuhW
         wX80ALUNzJyNCoXeopSxDMKpv5/t3mllkmYNSD2NiPT3FhHI3EdviE2Bf5ll6SFYzNBf
         +KSg/tsMYC+LzZMsacOpNCZS/VDRdpUObRB7+qJnoX9NLz9ffKXuYaeNEyuVhygri6Ly
         US9AOpkLmBNjw8z1HBKaLwws+ChllXj3aTZA540Y6eOZr0sotp5oP/pULKbfoAYRgFIv
         JSVXCzsmPSn4zld2ONPJ4pDUkNQitUOrCzKZ65k/OEezuPFnu6jM5X04b7kThaHuwM9K
         h7Ug==
X-Gm-Message-State: AOAM5304zTcahZ2cMLPKMKoTN2R9uVMYasQsd8YvWKvB8AsWjWokIMoj
        56EqpVSWDKnpJAji/8fIpzkJ6A3Qv9IAW5q4VXup8A==
X-Google-Smtp-Source: ABdhPJwiS76G8Y9R09FPdJUcRFb+sjM5lJ6mue8bXTzJxo9Jt+2HAOcaPThp1zkkbgCzdHC4RARXKewXqlKoKNoiYCs=
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr5138305wrt.176.1606411752819;
 Thu, 26 Nov 2020 09:29:12 -0800 (PST)
MIME-Version: 1.0
References: <20201126151220.2819322-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20201126151220.2819322-1-willemdebruijn.kernel@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 26 Nov 2020 12:28:36 -0500
Message-ID: <CACSApvaWuwMK+PUDsxJ85FMqcoX2yoQOKP3HeBofPPu5qRyg_g@mail.gmail.com>
Subject: Re: [PATCH net] sock: set sk_err to ee_errno on dequeue from errq
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Ayush Ranjan <ayushranjan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 10:12 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> When setting sk_err, set it to ee_errno, not ee_origin.
>
> Commit f5f99309fa74 ("sock: do not set sk_err in
> sock_dequeue_err_skb") disabled updating sk_err on errq dequeue,
> which is correct for most error types (origins):
>
>   -       sk->sk_err = err;
>
> Commit 38b257938ac6 ("sock: reset sk_err when the error queue is
> empty") reenabled the behavior for IMCP origins, which do require it:
>
>   +       if (icmp_next)
>   +               sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;
>
> But read from ee_errno.
>
> Fixes: 38b257938ac6 ("sock: reset sk_err when the error queue is empty")
> Reported-by: Ayush Ranjan <ayushranjan@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for catching this!

> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1ba8f0163744..06c526e0d810 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4549,7 +4549,7 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk)
>         if (skb && (skb_next = skb_peek(q))) {
>                 icmp_next = is_icmp_err_skb(skb_next);
>                 if (icmp_next)
> -                       sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_origin;
> +                       sk->sk_err = SKB_EXT_ERR(skb_next)->ee.ee_errno;
>         }
>         spin_unlock_irqrestore(&q->lock, flags);
>
> --
> 2.29.2.454.gaff20da3a2-goog
>
