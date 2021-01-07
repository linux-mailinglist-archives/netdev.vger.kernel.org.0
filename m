Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2F2EC9B8
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 05:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAGE6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 23:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGE6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 23:58:17 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE067C0612F0
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 20:57:36 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c7so6507717edv.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 20:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+/4R/9Cm7I8I2En+TkipAk58/u2aYOmrDIO8hzYxplI=;
        b=KeqhYc9C1h2i0wqvCdllQcIHaJnIadkG2wgFsisR35jtMIVe6MK6lxEzcn/Ixbo68E
         S2EyF4v4JHnsJLH7UCxd872CFTxhzxJnRBtqtoGJJEHGdtyiG3JEgDwTvyDtiPDiiJgA
         hENSdTFkqZIdXLLcVfgs5yyF0tNjIU1zDWBOOZuTSwrLUFhkQ4Z5suBt9EhDLQWZApw9
         dTc3TxDimsiwqrbAMIQelXhrF4NtadgcgCN6gy4pAZ4HW9h2Eyj9psB9iUDq4qQdfB//
         xr+FXY0CPxdBUmnBlD0qHWyV3vOuPlsSTYDFrTDTXpDGv6rOX6WY+e5e87Ngtv4+U2Rl
         +mLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+/4R/9Cm7I8I2En+TkipAk58/u2aYOmrDIO8hzYxplI=;
        b=ropnMmclJBS16Bv2+4Q47iENi0fmM1/mzrJAINU1m67w44NCQNJ2VyoVYrqtDWt3Yb
         r/aZbd4Bqs46PseJb+Ckf8/6pJoArrX98oZput1jTMUsp/8SGKnxzQHxrnME3c8lV2Lr
         66u4lI00BmElRH/cSVqJVKT5EFuFJXG49htb0t7lYdpg4FZr74Nfl8dGZw9d1AVrzj8J
         DOLE4ZmCU8/+Y3C7STK2nBwT/2LLPsyEIHI9JwnrQjczoIIbQseuifVU0gYKPXNot4lM
         Pd+4JOAKbPew33004Odj0DuNIKzzc2+DtS7UGoXEOYXYW6R4pUi3F1eeKzQedPayTmsO
         /rcA==
X-Gm-Message-State: AOAM530FCLRmaRqnpUCOShhQxSvO81lUWtJ+/kCJ0SIBWFtJ7IMkjLTj
        HiHK8zXdnYhlFuVYbCrOaAQxHF8rFa8IJajHjF0=
X-Google-Smtp-Source: ABdhPJwYuefC0+djFDiCmiJMFYZLh3Np0o/yWL9c0IXF8Rpm+KTT+Qe/iyLHTZ6j0ie6hfZtkz7eJcZtYiHR67ggrk0=
X-Received: by 2002:a50:9f4a:: with SMTP id b68mr309779edf.296.1609995455460;
 Wed, 06 Jan 2021 20:57:35 -0800 (PST)
MIME-Version: 1.0
References: <CABdVr8RVXj3dg-by_W99=fPSjdfB7fYXFRBW9sropQpYKD1xOQ@mail.gmail.com>
In-Reply-To: <CABdVr8RVXj3dg-by_W99=fPSjdfB7fYXFRBW9sropQpYKD1xOQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Jan 2021 23:56:59 -0500
Message-ID: <CAF=yD-+0m5Md8bjyv458Tszr_Ti-o=zDnS0TJs4cspjS2n8RLg@mail.gmail.com>
Subject: Re: Possible read of uninitialized array values in reuseport_select_sock?
To:     Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 10:54 PM Baptiste Lepers
<baptiste.lepers@gmail.com> wrote:
>
> Hello,
>
> While reading the code of net/core/sock_reuseport.c, I think I found a
> possible race in reuseport_select_sock. The current code has the
> following pattern:
>
>    socks = READ_ONCE(reuse->num_socks);
>    smp_rmb(); // paired with reuseport_add_sock to make sure
> reuse->socks[i < num_socks] are initialized
>    while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
>         if (i >= reuse->num_socks) // should be "socks" and not
> "reuse->num_socks"?
>
> The barrier seems to be here to make sure that all items of
> reuse->socks are initialized before being read, but the barrier only
> protects indexes < socks, not indexes < reuse->num_socks.
>
> I have a patch ready to fix this issue, but I wanted to confirm that
> the current code is indeed incorrect (if the code is correct for a
> non-obvious reason, I'd be happy to add some comments to document the
> behavior).
>
>
> Here is the diff of the patch I was planning to submit:
>
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index bbdd3c7b6cb5..b065f0a103ed 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -293,7 +293,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
>              i = j = reciprocal_scale(hash, socks);
>              while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
>                  i++;
> -                if (i >= reuse->num_socks)
> +                if (i >= socks)
>                      i = 0;
>                  if (i == j)
>                      goto out;
>
>
> Thanks,
> Baptiste.

Thanks for the clear description. Yes, I believe you're correct.
