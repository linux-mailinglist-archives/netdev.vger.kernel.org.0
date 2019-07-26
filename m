Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE257764C0
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfGZLpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:45:34 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37563 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfGZLpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:45:33 -0400
Received: by mail-yb1-f194.google.com with SMTP id i1so12174269ybo.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 04:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2LG0AzeYCrP2HPh4ReaU07gb34Xc8BwShnIuQhHSCaA=;
        b=eJy4qywY76PYX6Wq+0zlTbLlEE+um6eGdLbCQ4a9LkeyyavV0kCo1CzQ1MfPBYJRHx
         mKRuwgeGGdIj0sI0lJuhlCTGJhzBlwxAw8ouHd+LhwuTOL66GBFLIypxORhqhGAhgFwJ
         yIvoLtiCqbodpU3TEp26OSbXbBawiJr76Ul80QWH/Jlx8mbbIE2AwyLn4CzxpOiInTx4
         rMDYMjB8Mw7yi7UqypknsRP35NtBUQHseHV4y43s931zqUwIPBQbX+UQblxDYV3xivMA
         /lnWdjX2Wc0qBe9HTFcYuqET4O4jPnwNLYf3tMUBBNUmkmUOibQ3JMvBCaBkoIWtY5iI
         OVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2LG0AzeYCrP2HPh4ReaU07gb34Xc8BwShnIuQhHSCaA=;
        b=msi2yF9gJ0DgOE7cF7kJuiRHmXjPT90FoF3Kwwh5KtqnQRnpsUDs3rFxW/ETdwsoz2
         iOoNLzrGwX+ZuWPpRqb913n56FG8LoGO92ejUnT9E9+C5gtaibO69kjf7Xb3IaX+Q9mi
         mlO6OtGYYL2+iZrHvgPrjMgmsn8SiA2S++E/zmvYbGmKRz6bLwCbUz+SHhi2lAbHQrhB
         +gDUqVbrGNwamvs+dtGbDi93y2IsHBFPp8qz47NvmfSgyfQKncUvorYQPONPc7qxCAJL
         aa26o3eAs7djGe5ogiwtrYp17H4k4j1mtkCX4j0/UDjde0wln4RcavmCezcyM7qQzaf1
         SqqA==
X-Gm-Message-State: APjAAAX80HWBza1H4seAV0hvC1Rv9DmgvMipZ5dFvZndn9MJFHvDHIHZ
        NYde48DN6k/ggXXw1qYYUWgNONaG
X-Google-Smtp-Source: APXvYqw0/7IrNvS/M9cdsFIN7m0BIsMp7wnsYXCEJFYCHJf0jIkmT1DpjneJuTyImtAGFU/vubrabA==
X-Received: by 2002:a25:6b4c:: with SMTP id o12mr47508631ybm.270.1564141532027;
        Fri, 26 Jul 2019 04:45:32 -0700 (PDT)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id 15sm12211888ywo.74.2019.07.26.04.45.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 04:45:31 -0700 (PDT)
Received: by mail-yw1-f45.google.com with SMTP id z197so20234690ywd.13
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 04:45:30 -0700 (PDT)
X-Received: by 2002:a0d:c301:: with SMTP id f1mr53998273ywd.494.1564141530408;
 Fri, 26 Jul 2019 04:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190726080307.4414-1-baijiaju1990@gmail.com>
In-Reply-To: <20190726080307.4414-1-baijiaju1990@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Jul 2019 07:44:54 -0400
X-Gmail-Original-Message-ID: <CA+FuTSenOG7Y_RK7TTLKjXzQbX35YR_TyM5QGrf17ue5+JesXA@mail.gmail.com>
Message-ID: <CA+FuTSenOG7Y_RK7TTLKjXzQbX35YR_TyM5QGrf17ue5+JesXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: ipv6: Fix a possible null-pointer dereference in ip6_xmit()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 4:03 AM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
> In ip6_xmit(), there is an if statement on line 245 to check whether
> np is NULL:
>     if (np)
>
> When np is NULL, it is used on line 251:
>     ip6_autoflowlabel(net, np)
>         if (!np->autoflowlabel_set)
>
> Thus, a possible null-pointer dereference may occur.
>
> To fix this bug, np is checked before calling
> ip6_autoflowlabel(net,np).
>
> This bug is found by a static analysis tool STCheck written by us.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/ipv6/ip6_output.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 8e49fd62eea9..07db5ab6e970 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -247,8 +247,10 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
>         if (hlimit < 0)
>                 hlimit = ip6_dst_hoplimit(dst);
>
> -       ip6_flow_hdr(hdr, tclass, ip6_make_flowlabel(net, skb, fl6->flowlabel,
> -                               ip6_autoflowlabel(net, np), fl6));
> +       if (np) {
> +               ip6_flow_hdr(hdr, tclass, ip6_make_flowlabel(net, skb, fl6->flowlabel,
> +                                       ip6_autoflowlabel(net, np), fl6));
> +       }

I don't know when np can be NULL in ip6_xmit. But if so, must still
setup the ipv6 header.

A more narrow change would be in ip6_autoflowlabel

-        if (!np->autoflowlabel_set)
+       if (!np || !np->autoflowlabel_set)
