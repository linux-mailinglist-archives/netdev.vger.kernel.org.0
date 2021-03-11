Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDB13370B9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCKLAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbhCKLAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 06:00:01 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6ECC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 03:00:00 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p186so21300406ybg.2
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 03:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FH9Tuemr6yEKKZ7zMO/X3RVvrhnQrqKx7Lo2YU1iHrI=;
        b=ooY3IFfYBXB9sWaYggyj/4jO1MUUeZ2RUoy2hxC+9X5Ae/rzs2DVmUn+2y/E4fBEe6
         XUjvPhSE/2ZODIgG+FWAEgLsRHQp1fLYjtppnYt5HGZ0eTZLXLcFjOBnrBFVMTKZdPeP
         kHqmyvE54Awn+HPODCrobdr9BAvVs1xNLcVDprQdRR7M6y7hxlJ94PPaZ/7CrNeh+IVJ
         yE17DY3w5Ir+63lRwMoIRiikJl+tb1Q3fpCGNasgiF8BI+wyx5RZZIMpmdotVlaIq0jR
         DG3Axiy89gj1noB2bQ5zUEDtVnmACT+NUEfl+73bgvQh+vwYJCWr5VugWW3+dhSq23mu
         98QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FH9Tuemr6yEKKZ7zMO/X3RVvrhnQrqKx7Lo2YU1iHrI=;
        b=HTxdh7wxUev3nFDgia1PDWY4XMOslFb1943T5nuarv6qPhu/C5CGUnZyHR1r2TI02y
         yR1jDAiNAprfiDRVhcOZgqLX/h7bjiyXd2bdkawVaJLLs480hlN1WtqyMTMJT1tgcf9C
         38mpre4ogxPN5EOaJItNBSmtaIAXUP4Q3KaCc0tdTqAZFnqDImDLpBFU3G7+8VW2ZHNz
         mtEJ9XmPXsKeKaysU5WHi2K7BUAVs5YZ5SYsgLF/wnlKt0rjGiva5QDMEQi5/9BbxKHo
         S5COTHI7h3JH8EmqqSUu6RTWSPf+gsKOOA3NwEx01x8mmtqHgNfNn/qO9vHhd9MzVCHg
         m51w==
X-Gm-Message-State: AOAM532vfjJNx6LrR0JR/avllu5j5yX0Ggr2gjMXRw7mMz6TcgO5ALPp
        8x6BTCbTpEOv7kyKqmr4dI2PMHOSVC8CNvyvjPalsw==
X-Google-Smtp-Source: ABdhPJw0rCRE8+qk/fPMpU0L9aogYiBwnxnxNWMrbbrimxvuY5FG9nvFEhzFPwzcg4hN1ro/ywbvb+xY48F5XutTO78=
X-Received: by 2002:a25:2307:: with SMTP id j7mr11255547ybj.518.1615460399894;
 Thu, 11 Mar 2021 02:59:59 -0800 (PST)
MIME-Version: 1.0
References: <20210311103446.5dwjcopeggy7k6gg@kewl-virtual-machine>
In-Reply-To: <20210311103446.5dwjcopeggy7k6gg@kewl-virtual-machine>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 11 Mar 2021 11:59:48 +0100
Message-ID: <CANn89iKyFJdBu4fuRaMHRy0zdzR2Jcisy7bz=5iNkoo8HB4h8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: core: datagram.c: Fix use of assignment in if condition
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mchehab+huawei@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:34 AM Shubhankar Kuranagatti
<shubhankarvk@gmail.com> wrote:
>
> The assignment inside the if condition has been changed to
> initialising outside the if condition.
>
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
> ---
>  net/core/datagram.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 15ab9ffb27fe..7b2204f102b7 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -427,7 +427,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>                 offset += n;
>                 if (n != copy)
>                         goto short_copy;
> -               if ((len -= copy) == 0)
> +               len -= copy
> +               if ((len) == 0)
>                         return 0;
>


Quite frankly I prefer the current style.

It also seems you have not even compiled your change, this is not a good start.

Lets keep reviewer time to review patches that really bring an improvement,
since stylistic changes like that make our backports more likely to
have conflicts.

Thanks.
