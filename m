Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDCC37067B
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 10:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhEAIwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhEAIv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 04:51:59 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B87EC06174A
        for <netdev@vger.kernel.org>; Sat,  1 May 2021 01:51:10 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id i11so538152oig.8
        for <netdev@vger.kernel.org>; Sat, 01 May 2021 01:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1UPAfPjzFnnorN8RUbK8TT+PO/XH/Es/cjci3Lg9iCI=;
        b=FyT/Q1Hx91JKGkvnzkQ7QwyITx+z14ztRobDh14fFuMbEJUJ9y6boJQgOtSp5Ycs5M
         xSMYwKDY7dpLbon3fmsF1GCYmcJo61z6bHVaTSNcQ3fja/n1z8QUEmF2UvbILuvkIdJ2
         jXRoh5re9hPqVO/2rUff0kyixURzv4h6KBzE++A5K7/BnhkxwZdRkhFHuF47VY36zCSD
         fo3DZo0DPg97hSijkftB2Y3nzd64yZ+f+wzA2BjS9kBCzXXDuL3C69Eu5lgM4QWVJHDq
         H9TTLgR0dgB+dybmey/vKkkvd9DIPHRmSTaznhlgV1a62L+8o9nH/NsGLEYViVptqYyz
         zo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1UPAfPjzFnnorN8RUbK8TT+PO/XH/Es/cjci3Lg9iCI=;
        b=rQ/C5vg8xrz5nMeJ3O3qLUtkWbDwGqY0OxL3ZdiN3CasnkhgoVnHEvtR/Kd+Zfo/33
         G4GGuJVuDA7J4g/9Sbfm6YqP81VYDuhi3u0sq+AKIPGBx/U3wCZ/nPYYQGCjwYH9iNZB
         EHUbmFEmo5ZMd61+8XBuhk8qTfJL/TcVn2j+nQMS6E/xZOpsy4VvMG59hDgIEvpyYePm
         WkUVNc09shUDYQb2iHRtIWRgJSTXuqP/L/2MEB2ryNVWKWnYefTSp4ksVeY6/eH9RT9F
         MqYeydqLY1rJAYxoJfNFHS0GtIkG+3X6E4pW8E3P2N1WOAxVEjhjAIKDB27ROPtw52lT
         IaVw==
X-Gm-Message-State: AOAM532BrHFqbAlFEwsqO98YxN2w02u1sJL2fl5ZEnzEHU641kiAyk3X
        DQVQtBlkQKt3TChFq4BouFK6K9PbC4KVvCblGBAK5aTr/zpWIA==
X-Google-Smtp-Source: ABdhPJwXHAw/4VvhV1Y8N8Qbbs3ZbO+1HeWAxKONQxJnhuw4zYsITStGa3Q6a7jlBHh9ksaqJuqtd8co7M9ttYgw7sQ=
X-Received: by 2002:aca:3446:: with SMTP id b67mr6921479oia.136.1619859069170;
 Sat, 01 May 2021 01:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210501082822.726-1-jonathon.reinhart@gmail.com>
In-Reply-To: <20210501082822.726-1-jonathon.reinhart@gmail.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Sat, 1 May 2021 04:50:43 -0400
Message-ID: <CAPFHKzc4OWiL+d6kuCHT3r4A4u13oydsVA09RfG0r2Sh9dCADg@mail.gmail.com>
Subject: Re: [PATCH] net: Only allow init netns to set default tcp cong to a
 restricted algo
To:     Linux Netdev List <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 1, 2021 at 4:29 AM Jonathon Reinhart
<jonathon.reinhart@gmail.com> wrote:
>
> tcp_set_default_congestion_control() is netns-safe in that it writes
> to &net->ipv4.tcp_congestion_control, but it also sets
> ca->flags |= TCP_CONG_NON_RESTRICTED which is not namespaced.
> This has the unintended side-effect of changing the global
> net.ipv4.tcp_allowed_congestion_control sysctl, despite the fact that it
> is read-only: 97684f0970f6 ("net: Make tcp_allowed_congestion_control
> readonly in non-init netns")
>
> Resolve this netns "leak" by only allowing the init netns to set the
> default algorithm to one that is restricted. This restriction could be
> removed if tcp_allowed_congestion_control were namespace-ified in the
> future.
>
> This bug was uncovered with
> https://github.com/JonathonReinhart/linux-netns-sysctl-verify
>
> Fixes: 6670e1524477 ("tcp: Namespace-ify sysctl_tcp_default_congestion_control")
> Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> ---
>  net/ipv4/tcp_cong.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index 563d016e7478..db5831e6c136 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -230,6 +230,10 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
>                 ret = -ENOENT;
>         } else if (!bpf_try_module_get(ca, ca->owner)) {
>                 ret = -EBUSY;
> +       } else if (!net_eq(net, &init_net) &&
> +                       !(ca->flags & TCP_CONG_NON_RESTRICTED)) {
> +               /* Only init netns can set default to a restricted algorithm */
> +               ret = -EPERM;
>         } else {
>                 prev = xchg(&net->ipv4.tcp_congestion_control, ca);
>                 if (prev)
> --
> 2.20.1
>

This should be targeting "net" (and stable), not "net-next". Sorry about that.
