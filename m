Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283362ABECD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgKIOgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgKIOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:36:52 -0500
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303E1C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 06:36:52 -0800 (PST)
Received: by mail-ua1-x944.google.com with SMTP id k12so2842181uad.11
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDniQAvxFLBjIKTPYpnf40KKSY2vMSiv1LR/tBJSqcA=;
        b=LxF1L+qGOIsxg05Lh0AzTGP5Iwb+FRJjDr/EMmjoNpyVVkoZAK0uPsRHh/wau4UHyD
         xh2hlTuIE0nsNZz9H+gMOuMzCX6gEHNOwVtmZZOo7wMGB8sPHTGPpaY1s0Y5TJ48nRWx
         lINJc8eu3GQFZBbrP/2MbKJgiFRoWYnrgOd0xb1B4no4COrC5vQiuj4bxlstYDKdMLkk
         Zp/0j7JV5Bg0FEsvyCQrkL/wM+Y7As52L6u9wKkSeIPdQ+oRw6cD/CNWA8ouiqSODa4a
         WilzHKCrQyEs4yPCINqM+NEE116rmHFQiJPxEd9pd4xyahqi+k8AnC+1He5l4QT/6tnJ
         I6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xDniQAvxFLBjIKTPYpnf40KKSY2vMSiv1LR/tBJSqcA=;
        b=ohcWjFRGiuStY5mJ6KiBinYWhQKlx5lmLipI5/JQW2eMw5ksUwA8c0ZueSeZytkyjF
         f66KYvO9Pk4IhSjSgrYrj0He8WybEHPkc5MtN+Ik9Ci6xVDRZerFoYRptd5cO8y+dE9U
         mtJFR5lM0Z+ZgHRjmWBJfdyB057HF9xjkyhyDVqH2GBHAs0fWZd5AObQzCCiXS2N4sSW
         MHiLsXvGj4ITl2rdiF81pH4nLVGDJ7iyNa8XfBJQPW5Y3ZJi8JJ4pqyGA8jxErP8bFMF
         14aou/SEZ53d0V3FXC+EYDcS7HR2BU6KZETaD9TjuVBpSUOsEolp+mVUSY5kSF1eQjGp
         BPhg==
X-Gm-Message-State: AOAM530slr7tHcR/Q9iXF75NW89wXNqLNxgxZMEVkn1Y9jkH+wXUl+1W
        oIBaEUkrXmdP9JSBHOYDSGK3+s8cPuo=
X-Google-Smtp-Source: ABdhPJwysSiZ8PHQvW+vXhFyaizrobol//EviDvplpjLDA25tyjtyTiNk9ttdcrQwu2g+aYa3yu/7Q==
X-Received: by 2002:ab0:403:: with SMTP id 3mr3679739uav.4.1604932611109;
        Mon, 09 Nov 2020 06:36:51 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id 59sm1058936uag.13.2020.11.09.06.36.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:36:50 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id p12so2843374uam.1
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 06:36:50 -0800 (PST)
X-Received: by 2002:a9f:2067:: with SMTP id 94mr6343749uam.141.1604932609475;
 Mon, 09 Nov 2020 06:36:49 -0800 (PST)
MIME-Version: 1.0
References: <YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch>
In-Reply-To: <YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Nov 2020 09:36:12 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfokZNJv2g2mCK284UTj7nN_-qXei42J4QWt7YniSrKog@mail.gmail.com>
Message-ID: <CA+FuTSfokZNJv2g2mCK284UTj7nN_-qXei42J4QWt7YniSrKog@mail.gmail.com>
Subject: Re: [PATCH net] net: udp: fix Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 8:11 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> While testing UDP GSO fraglists forwarding through driver that uses
> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> iperf packets:
>
> [ ID] Interval           Transfer     Bitrate         Jitter
> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
>
> Simple switch to napi_gro_receive() any other method without frag0
> shortcut completely resolved them.
>
> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> callback. While it's probably OK for non-frag0 paths (when all
> headers or even the entire frame are already in skb->data), this
> inline points to junk when using Fast GRO (napi_gro_frags() or
> napi_gro_receive() with only Ethernet header in skb->data and all
> the rest in shinfo->frags) and breaks GRO packet compilation and
> the packet flow itself.
> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> are typically used. UDP even has an inline helper that makes use of
> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> to get rid of the out-of-order delivers.
>
> Present since the introduction of plain UDP GRO in 5.0-rc1.
>
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/ipv4/udp_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index e67a66fbf27b..13740e9fe6ec 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -366,7 +366,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>                                                struct sk_buff *skb)
>  {
> -       struct udphdr *uh = udp_hdr(skb);
> +       struct udphdr *uh = udp_gro_udphdr(skb);
>         struct sk_buff *pp = NULL;
>         struct udphdr *uh2;
>         struct sk_buff *p;

Good catch. skb_gro_header_slow may fail and return NULL. Need to
check that before dereferencing uh below in

        /* requires non zero csum, for symmetry with GSO */
        if (!uh->check) {
                NAPI_GRO_CB(skb)->flush = 1;
                return NULL;
        }
