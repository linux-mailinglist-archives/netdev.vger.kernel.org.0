Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62171E6CA7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407305AbgE1UfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407190AbgE1Ue5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:34:57 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721AC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 13:34:56 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h7so238041otr.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 13:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KhxKKjyUN6FLmAJYIfSK0oBD+OdVgqtUi+M5rGq6E0U=;
        b=mku/u96SpTXBSYI3Dgz5eSk6rm3QVUTx2SqERPq4Bg53yEPX30EETNRqEiBqfqAdu4
         VfYnVlnbnij9abTdOHq82+uCCS9z/xYu1OFlPIhrh77N+83mJ2a3AMDLXWyo+eAtdT3p
         2L0zYTh5MWwhcDLWc2i5SGLJA7r9pVo8wYX8u5zsJvJCCtJtSQwOgRgVgdOZEO7Bgv63
         NAj2bubOKSwja2N4TigLIGPUp0Ph94G18syhpIViTeKzknIdzGzTKAR6EcUde/YoYUKR
         XpPGmob9r42l/c52yaYg5JfUJiJt2npb8PPvnV9UxjFIxmP2HYciyugoS8IOkGl+pLMH
         lV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KhxKKjyUN6FLmAJYIfSK0oBD+OdVgqtUi+M5rGq6E0U=;
        b=f8PStNkgqEhmzlaEVnH6fOwPubi3dWeJIcsq9uMz7doCgkX2M1QEgzOKXa0cfJiAxz
         aExYqAyqMQLcyQsISpDJWNJhDUQqhnn6YNYJbBQEoh6J3PooeOHAPO+Kvu8WpVMf24YN
         IqsIujKvP/FKcwf6Pw5DHiGSTsVnNj//O2o/Vx4DtA39PJFAkMmSN1XeabZinDQ7A6vB
         ug0DyrMvSfMPK074UIpqO48LAS0usNv9JzWbb+agMO73seiDgz+pgcZKILb0GEvMMNZE
         w3RE7BFxfm7PBY49su4rMzF7ccIL8QUvEHmLIWJ+02ngLGoufwx0jAgmVTZYU0YWDtAv
         zC8A==
X-Gm-Message-State: AOAM532reBfRw+QXrINdtaKSrw6C7UsMs/P/dgm1jjL0YYubE2GZu2XP
        JCVyAFN5Ey9ZeSecA2tzXDB6aiAFPuqluFOxvIU=
X-Google-Smtp-Source: ABdhPJyZQzYuRRj5JRdRB87bkZKUVSRH3YNKaY+n4M3V+n8IfOkchsDwOf8d3DJE5/KRLrqMZjeH3LLtJk6wwL/v7KI=
X-Received: by 2002:a9d:5a5:: with SMTP id 34mr3840946otd.196.1590698096216;
 Thu, 28 May 2020 13:34:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Thu, 28 May 2020 13:34:45 -0700
Message-ID: <CAGdtWsQCyrg3otDtxw62k8xeXp5td8rxxfXydhSzBOAMbH3VzA@mail.gmail.com>
Subject: Re: [PATCH net] tun: correct header offsets in napi frags mode
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 10:07 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> Tun in IFF_NAPI_FRAGS mode calls napi_gro_frags. Unlike netif_rx and
> netif_gro_receive, this expects skb->data to point to the mac layer.
>
> But skb_probe_transport_header, __skb_get_hash_symmetric, and
> xdp_do_generic in tun_get_user need skb->data to point to the network
> header. Flow dissection also needs skb->protocol set, so
> eth_type_trans has to be called.
>
> Temporarily pull ETH_HLEN to make control flow the same for frags and
> not frags. Then push the header just before calling napi_gro_frags.
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Acked-by: Petar Penkov <ppenkov@google.com>

> ---
>  drivers/net/tun.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 44889eba1dbc..b984733c6c31 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1871,8 +1871,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                 skb->dev = tun->dev;
>                 break;
>         case IFF_TAP:
> -               if (!frags)
> -                       skb->protocol = eth_type_trans(skb, tun->dev);
> +               if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
> +                       err = -ENOMEM;
> +                       goto drop;
> +               }
> +               skb->protocol = eth_type_trans(skb, tun->dev);
>                 break;
>         }
>
> @@ -1929,9 +1932,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>         }
>
>         if (frags) {
> +               u32 headlen;
> +
>                 /* Exercise flow dissector code path. */
> -               u32 headlen = eth_get_headlen(tun->dev, skb->data,
> -                                             skb_headlen(skb));
> +               skb_push(skb, ETH_HLEN);
> +               headlen = eth_get_headlen(tun->dev, skb->data,
> +                                         skb_headlen(skb));
>
>                 if (unlikely(headlen > skb_headlen(skb))) {
>                         this_cpu_inc(tun->pcpu_stats->rx_dropped);
> --
> 2.27.0.rc0.183.gde8f92d652-goog
>
