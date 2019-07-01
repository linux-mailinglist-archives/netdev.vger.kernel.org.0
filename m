Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7369D5B2E0
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 04:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGACGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 22:06:21 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43039 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfGACGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 22:06:21 -0400
Received: by mail-yw1-f65.google.com with SMTP id t2so7700744ywe.10
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 19:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=px7jl3R0t8qj3XTt9vErOdqhrcGMXDF1TChG470cWgg=;
        b=RJK06uOUsdGWf2XF6gFibRSUtA7jy4usfoWbM9sO1R2jIDQCh1TM0DGKYoCnJZD9ec
         EeuDt0DfbFGciTG6tseBgWXXYfREkSHlNbxH+jrizXZHUCiHOC8Kj7PPOGlYX39J6DYi
         j35soWaY4XT9gXzpr/zkSrJV1sbTiLsUU8X5dC6GivuBROAMzxOoHVOY8UfoAFMbkhhB
         p6oWBWGuur6n+8VWFsVSC7hD+nNBjVd960QXO7xIuAhIeqI7yYVm1IP/7I5a+5tupZr9
         4MhZ8RJvcVhL5XWX1Pw0cXL58HCtx4EP72+VCX/Z0p4yn5+KEHOKMA5K8FGsu7K9l7RD
         n5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=px7jl3R0t8qj3XTt9vErOdqhrcGMXDF1TChG470cWgg=;
        b=Fg8KVL+5zJrYkEmUpzq+GC2kupl/ObtCPIXtabg+ilTv15Am+wPQxZ5lI/0wGKL/Ei
         1PCzxVFF2lCrrOfMM6xTWkGQbO7tx5WX0M0UK4cOaB89sFEyiTzwbDwsg+GKupX0eyBp
         E4qrHyqVO+V8kgRlniMLMgS3jdCSWjoKQpyhEgxL7BOjjuDBpjq8S99SeCf46weoslsx
         tsiwSM/GveyBX6oqmp8/ePDt97b95nfKpDyG1ltlmGb5GFWO6KOXuZ7OMqO8OQjR9pBW
         kSCQcxiVAUNoUbqQTaPxSTyvdwnKpKH2vq7Ocb1BV95p6xjcHRHehs88FUM1ZJN6u3AK
         ATyg==
X-Gm-Message-State: APjAAAVhlZtLJFFF1+GPhUCuzbH3yqyTEHaWDQNMU+bl4rjjdp7Teibc
        ZTp2H10TpxRHuk0jRFcViJLuGoQc
X-Google-Smtp-Source: APXvYqwzegluGH0cmPQMrE2sB/5zlNx4eB3PXRtzvUJY9cjILXrsRg4/tph/vA9DakGCXrnIpGuySA==
X-Received: by 2002:a81:710a:: with SMTP id m10mr12828681ywc.277.1561946779905;
        Sun, 30 Jun 2019 19:06:19 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id j9sm2262473ywc.43.2019.06.30.19.06.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 19:06:19 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id n127so4589353ywd.9
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 19:06:19 -0700 (PDT)
X-Received: by 2002:a81:1a05:: with SMTP id a5mr13754568ywa.111.1561946778706;
 Sun, 30 Jun 2019 19:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
In-Reply-To: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 30 Jun 2019 22:05:41 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
Message-ID: <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] macsec: add brackets and indentation after
 calling macsec_decrypt
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> At this point, skb could only be a valid pointer, so this patch does
> not introduce any functional change.

Previously, macsec_post_decrypt could be called on the original skb if
the initial condition was false and macsec_decrypt is skipped. That
was probably unintended. Either way, then this is a functional change,
and perhaps a bugfix?

> Signed-off-by: Andreas Steinmetz <ast@domdv.de>
>
> --- a/drivers/net/macsec.c      2019-06-30 22:05:17.785683634 +0200
> +++ b/drivers/net/macsec.c      2019-06-30 22:05:20.526171178 +0200
> @@ -1205,21 +1205,22 @@
>
>         /* Disabled && !changed text => skip validation */
>         if (hdr->tci_an & MACSEC_TCI_C ||
> -           secy->validate_frames != MACSEC_VALIDATE_DISABLED)
> +           secy->validate_frames != MACSEC_VALIDATE_DISABLED) {
>                 skb = macsec_decrypt(skb, dev, rx_sa, sci, secy);
>
> -       if (IS_ERR(skb)) {
> -               /* the decrypt callback needs the reference */
> -               if (PTR_ERR(skb) != -EINPROGRESS) {
> -                       macsec_rxsa_put(rx_sa);
> -                       macsec_rxsc_put(rx_sc);
> +               if (IS_ERR(skb)) {
> +                       /* the decrypt callback needs the reference */
> +                       if (PTR_ERR(skb) != -EINPROGRESS) {
> +                               macsec_rxsa_put(rx_sa);
> +                               macsec_rxsc_put(rx_sc);
> +                       }
> +                       rcu_read_unlock();
> +                       return RX_HANDLER_CONSUMED;
>                 }
> -               rcu_read_unlock();
> -               return RX_HANDLER_CONSUMED;
> -       }
>
> -       if (!macsec_post_decrypt(skb, secy, pn))
> -               goto drop;
> +               if (!macsec_post_decrypt(skb, secy, pn))
> +                       goto drop;
> +       }
>
>  deliver:
>         macsec_finalize_skb(skb, secy->icv_len,
>
