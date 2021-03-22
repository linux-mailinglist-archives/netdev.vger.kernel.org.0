Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF3344613
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVNm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCVNmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:42:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B58C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:42:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w18so19441845edc.0
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyr6JPEH1Rgoz3MMXEkoP0VgAc8QjJfCBzyuNx+YiLg=;
        b=hqcJf5TdOtWJfjyogj6rNjToz/mCLg6ML80dZVvg9m7AfUnaIGqScby8s6ngDJBekg
         JjjXcPju7tSrXSjWkvt8QXFBQCPioA2uEAHKkXCwA3cKaOslYP0nihQBn7vKOGBTs4rO
         APhyYvaAmj5pQC+I0PztT2E5lRIKJvkpsX1S0cIN5/WdbL8GFTJWKNxuWdderSj7G50T
         9y7+qifphiqYTy5J6+oM7UunSvRobxnyjXKxfdBGObeRBwZsrcHqpYIzymZNFMTQLqoq
         MVzyiHZ2DaXAHN7NeGxoSE3v4XpIuC+PItL7hCF3+8AxrgtgY/1zBdEinyCDrlXKatXk
         enGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyr6JPEH1Rgoz3MMXEkoP0VgAc8QjJfCBzyuNx+YiLg=;
        b=lIVEyKiFxfA529CRqG8VnrZ3ZuY7PqH9uv9V7NgovmN3UuLotlinJFRatysIgAfOai
         MfusbAGNd6DGWf7ZdE1pEG0nmw/pqm9U26UvYgBxUB0hHNm66gDNkL2/4zCQGRRxcKTD
         +lid3A6oDqNrgxaH6Gr1iXA5iQPYfFh6BFWge3QhC1QMmqen67FQd2QitR2z2Edt6CP+
         +TsT3icrA9MqmYkPLvTyHO27MjXsp8W86a8rUKzI3h32j/o/6YiSKCnCCXGTXe/aSKdX
         t/L/dzI/LbGOlabu1H/ou4R7RkATuB8Xcz+RwVAp5h+jq7G+/Dibd5Qyh+Kw2bIG7rEs
         iR3A==
X-Gm-Message-State: AOAM530CFm632ASJw1zB0PeCvKog716IpJ7mhIeZpTGRngyolLX3GFDX
        YurszSzJSIzoSPhLaKyK2YZcIUCS9Sc=
X-Google-Smtp-Source: ABdhPJzFoiap6HVNZxl6dQaAnM+vpwUkDNaaxVtaDHGfJh8scyobAaPII6Kzsmq54MHvXPhYGMciUg==
X-Received: by 2002:a05:6402:4241:: with SMTP id g1mr26175506edb.331.1616420563261;
        Mon, 22 Mar 2021 06:42:43 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id h13sm11479936edz.71.2021.03.22.06.42.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:42:42 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id o16so16879374wrn.0
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:42:42 -0700 (PDT)
X-Received: by 2002:adf:fa08:: with SMTP id m8mr18498827wrr.12.1616420561109;
 Mon, 22 Mar 2021 06:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
In-Reply-To: <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 22 Mar 2021 09:42:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
Message-ID: <CA+FuTSefLQ07od6Et6H2wO=p8+V2F28VYix4EgghHz6R0Bn9nw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Currently the UDP protocol delivers GSO_FRAGLIST packets to
> the sockets without the expected segmentation.
>
> This change addresses the issue introducing and maintaining
> a per socket bitmask of GSO types requiring segmentation.
> Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
> GSO_FRAGLIST packets are never accepted
>
> Note: this also updates the 'unused' field size to really
> fit the otherwise existing hole. It's size become incorrect
> after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").
>
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/udp.h | 10 ++++++----
>  net/ipv4/udp.c      | 12 +++++++++++-
>  2 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index aa84597bdc33c..6da342f15f351 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -51,7 +51,7 @@ struct udp_sock {
>                                            * different encapsulation layer set
>                                            * this
>                                            */
> -                        gro_enabled:1; /* Can accept GRO packets */
> +                        gro_enabled:1; /* Request GRO aggregation */

unnecessary comment change?

>         /*
>          * Following member retains the information to create a UDP header
>          * when the socket is uncorked.
> @@ -68,7 +68,10 @@ struct udp_sock {
>  #define UDPLITE_SEND_CC  0x2           /* set via udplite setsockopt         */
>  #define UDPLITE_RECV_CC  0x4           /* set via udplite setsocktopt        */
>         __u8             pcflag;        /* marks socket as UDP-Lite if > 0    */
> -       __u8             unused[3];
> +       __u8             unused[1];
> +       unsigned int     unexpected_gso;/* GSO types this socket can't accept,
> +                                        * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
> +                                        */

An extra unsigned int for this seems overkill.

Current sockets that support SKB_GSO_UDP_L4 implicitly also support
SKB_GSO_FRAGLIST. This patch makes explicit that the second is not
supported..

>         /*
>          * For encapsulation sockets.
>          */
> @@ -131,8 +134,7 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
>
>  static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
>  {
> -       return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
> -              skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
> +       return skb_is_gso(skb) && skb_shinfo(skb)->gso_type & udp_sk(sk)->unexpected_gso;

.. just update this function as follows ?

 -       return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
 -              skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
+       return skb_is_gso(skb) &&
+                 (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST ||
!udp_sk(sk)->gro_enabled)

where the latter is shorthand for

  (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->gro_enabled)

but the are the only two GSO types that could arrive here.
