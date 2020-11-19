Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D772B8B10
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgKSFky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgKSFkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 00:40:53 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB35C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 21:40:53 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id t8so4669691iov.8
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 21:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAkA6JCfmaGYTSKrOsabR0pHYgeUubNA1pcl3TptuMI=;
        b=aloGKGg4dUlCBUdAKoDdFA2q+BAplgpmt3rl5KLHYAZAo+/ZFAoWP3DnCbfWllDZz6
         7eMqo8f9hVRiNZM3coVCQykfikY6qUlybWbm9lOjceOJrl+OQYzTkD4xRvnqTX7mwA9w
         BO75P2cnjaEj3a4kVvouKpj1xyruMVRCG8ph1lrLarnpgCyiHcuc41ra4Cp8uMJCnqlC
         Dxc/k9wjyxNIneH6zCvhjh0+r8drEgS3OYv4CrlIdwfMv4D1WD8sPp8AUz8xHFskwbz0
         VmXCUFeaeqNzhaOLfk7CJO25qgNueOlHkcD3sj7T/8PnWq88Ntwmi1JMDS5HJFmCAkFi
         jVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAkA6JCfmaGYTSKrOsabR0pHYgeUubNA1pcl3TptuMI=;
        b=d7kN0p2Vd2wh202MMckgF68RAdsjbuTf1a9M9quq30qWzngCkw9ZlP2RQthDUo1hXZ
         Lv537l694Y2COKYt9nHxQAcWboGdrOCUVRQNvjN6HCWJA0Bm00bjsW/kh9NsGkgFRB1a
         ADa9m3WOKmySpvvo3W1CHd/Xo+6hCMueJQY16jcBWU8DMDhHo4wJfzmFqjlxboRPCH/O
         PKQ4sNamYlwZmIW3sjO89RwVHD6aEdb/cPV3/TbRmnKuMIzyWmXzMmQmiNXeuWkIEfPQ
         VYJ4ECJej4TZYW0Cf//G0/2OamPkyJ/GvN4jq4lUithJ5RiQLQqgCqBw9XIoLoKLWGfq
         Wviw==
X-Gm-Message-State: AOAM530nEjU+Scff+F7ot+663capsJczrTuPw+Acmhu4FiuJqxjrXR+/
        pbRoooVgAaSb0P8zpPWusjzb3X2PqSFX0Ny/Pcl7kFsF3Po=
X-Google-Smtp-Source: ABdhPJwgijqL7GHIOMIWE/xlw7iryL9Mer1OB3UdjJjJjbU1Yf3eXg1CIYNkpAb8BKzdcvboR1cjQ2yUudwcyhykCu4=
X-Received: by 2002:a02:7797:: with SMTP id g145mr12209524jac.103.1605764451498;
 Wed, 18 Nov 2020 21:40:51 -0800 (PST)
MIME-Version: 1.0
References: <20201116023140.28975-1-tseewald@gmail.com> <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tom Seewald <tseewald@gmail.com>
Date:   Wed, 18 Nov 2020 23:40:40 -0600
Message-ID: <CAARYdbg+HsjCBu5vU=aHg-OU8L6u52RUBzrYUTuUMke6bXuV3g@mail.gmail.com>
Subject: Re: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 4:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 15 Nov 2020 20:31:40 -0600 Tom Seewald wrote:
> > After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > building the kernel with CHELSIO_T4=y and CHELSIO_TLS_DEVICE=n results
> > in the following error:
> >
> > ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
> > `cxgb_select_queue':
> > cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'
> >
> > This is caused by cxgb_select_queue() calling cxgb4_is_ktls_skb() without
> > checking if CHELSIO_TLS_DEVICE=y. Fix this by calling cxgb4_is_ktls_skb()
> > only when this config option is enabled.
> >
> > Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > ---
> >  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > index 7fd264a6d085..8e8783afd6df 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > @@ -1176,7 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
> >               txq = netdev_pick_tx(dev, skb, sb_dev);
> >               if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> >                   skb->encapsulation ||
> > -                 cxgb4_is_ktls_skb(skb) ||
> > +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> > +             cxgb4_is_ktls_skb(skb) ||
> > +#endif /* CHELSIO_TLS_DEVICE */
> >                   (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
> >                       txq = txq % pi->nqsets;
> >
>
> The tls header already tries to solve this issue, it just does it
> poorly. This is a better fix:
>
> diff --git a/include/net/tls.h b/include/net/tls.h
> index baf1e99d8193..2ff3f4f7954a 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -441,11 +441,11 @@ struct sk_buff *
>  tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
>                       struct sk_buff *skb);
>
>  static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
>  {
> -#ifdef CONFIG_SOCK_VALIDATE_XMIT
> +#ifdef CONFIG_TLS_DEVICE
>         return sk_fullsock(sk) &&
>                (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
>                &tls_validate_xmit_skb);
>  #else
>         return false;
>
>
> Please test this and submit if it indeed solves the problem.
>
> Thanks!

Hi Jakub,

Thanks for the reply, unfortunately that patch does not resolve the
issue, I still get the same error as before. After looking into this a
bit further, the issue seems to be with CONFIG_TLS=m as everything
works when CONFIG_TLS=y.

I also see that there was a similar issue [1] reported by Intel's
kbuild test robot where the cxgb4 driver isn't able to see the TLS
symbols when CONFIG_TLS=m.

[1] https://lkml.org/lkml/2020/8/7/601
