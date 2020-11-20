Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF502BA2B3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 07:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKTGyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 01:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgKTGyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 01:54:12 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B64C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 22:54:12 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id d17so8884476ion.4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 22:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zn7mEi9+IBvEMYdy7wk6S5Hi8ABmndxF4rBsjDTQ3kA=;
        b=Vkaruz+pwjMrjm+FO0cGU8NkhMRmk1BIQTzdplnkhoXxF29PKQyxomHVOI7tgyfqRN
         M14bF3yTJgLSUpOwrWWsgo1dSSANuqA+jB7+jnlNILCm461+RfoHaaZ2KKRgpVDQk1hA
         gcwB923ULSgZpzYve8e7iqI6i+Z8cH5yC1hkCzokRZKI4rONZjdFN6SSJ3OVcWC2ThK2
         Qej4sNL0zuSho+15BQdi29iei6bGRV9PTSeCM61TNZVnhoqcMgS46QQQEsBMj9pGbYPu
         8Iky3ZqvzIyHAz/RdMYQbbKZ/Gj0qAol2MyQ6XkrSVee1BI/5iu9gUQxkx4wp1Peexc9
         uHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zn7mEi9+IBvEMYdy7wk6S5Hi8ABmndxF4rBsjDTQ3kA=;
        b=Pkn8+yTcGeOsiw2UkzutKqmKPgk2B4luIGaM/pJeH4UOUF60swyVUkIc8PIGhQM0OH
         tx2XXExzozEQrb3gy/jENzisOhgbLRxDdy6/YrE3yROUfStm8VsghwOJk9mPl6b2+nv0
         f2R0iUui50pP4uhXBl0GYYzI59WOenwKwi3ubUxxk48/0/er9hdek8bcWYIkw+rgdaTn
         h/jc5gyeFpi7VPtTBo0cq4dqejUWLSTEn7o1dIqDhIs42CtMoF5OvdizDGddAuuZ3Kny
         Dglr84RvlvrU43MdYHU4ZXLqXpReu2gebJH6Opiqcc+UC8Gxsh7g8rp3amHdxZpKZhnF
         G7yA==
X-Gm-Message-State: AOAM533AGL/8ANRF7tagTQ5nE3Fq2k8Dupf6umgPW+FzCOMhbZepjkBG
        Bm9JrUePgthINFA9MALeatf2dOjse9sVZRzouxROKjozs2E=
X-Google-Smtp-Source: ABdhPJzddgIwhL+OUTCrcAOiSqaWqmrvVzcwPYztP/mVWeUoHqfJze/w8VQKLuAATpPOzOYfbJPIwxaLlnG3AqPbPF4=
X-Received: by 2002:a02:7797:: with SMTP id g145mr17263368jac.103.1605855251234;
 Thu, 19 Nov 2020 22:54:11 -0800 (PST)
MIME-Version: 1.0
References: <20201116023140.28975-1-tseewald@gmail.com> <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAARYdbg+HsjCBu5vU=aHg-OU8L6u52RUBzrYUTuUMke6bXuV3g@mail.gmail.com> <20201119093719.15f19884@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119093719.15f19884@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tom Seewald <tseewald@gmail.com>
Date:   Fri, 20 Nov 2020 00:54:00 -0600
Message-ID: <CAARYdbivN7N-xwqvgq7pdyeY9UOBL=aGr97AHMsMP1TvR-3Qog@mail.gmail.com>
Subject: Re: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 11:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 23:40:40 -0600 Tom Seewald wrote:
> > On Tue, Nov 17, 2020 at 4:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Sun, 15 Nov 2020 20:31:40 -0600 Tom Seewald wrote:
> > > > After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > > > building the kernel with CHELSIO_T4=y and CHELSIO_TLS_DEVICE=n results
> > > > in the following error:
> > > >
> > > > ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
> > > > `cxgb_select_queue':
> > > > cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'
> > > >
> > > > This is caused by cxgb_select_queue() calling cxgb4_is_ktls_skb() without
> > > > checking if CHELSIO_TLS_DEVICE=y. Fix this by calling cxgb4_is_ktls_skb()
> > > > only when this config option is enabled.
> > > >
> > > > Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> > > > Signed-off-by: Tom Seewald <tseewald@gmail.com>
> > > > ---
> > > >  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > > index 7fd264a6d085..8e8783afd6df 100644
> > > > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> > > > @@ -1176,7 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
> > > >               txq = netdev_pick_tx(dev, skb, sb_dev);
> > > >               if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> > > >                   skb->encapsulation ||
> > > > -                 cxgb4_is_ktls_skb(skb) ||
> > > > +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> > > > +             cxgb4_is_ktls_skb(skb) ||
> > > > +#endif /* CHELSIO_TLS_DEVICE */
> > > >                   (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
> > > >                       txq = txq % pi->nqsets;
> > > >
> > >
> > > The tls header already tries to solve this issue, it just does it
> > > poorly. This is a better fix:
> > >
> > > diff --git a/include/net/tls.h b/include/net/tls.h
> > > index baf1e99d8193..2ff3f4f7954a 100644
> > > --- a/include/net/tls.h
> > > +++ b/include/net/tls.h
> > > @@ -441,11 +441,11 @@ struct sk_buff *
> > >  tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
> > >                       struct sk_buff *skb);
> > >
> > >  static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
> > >  {
> > > -#ifdef CONFIG_SOCK_VALIDATE_XMIT
> > > +#ifdef CONFIG_TLS_DEVICE
> > >         return sk_fullsock(sk) &&
> > >                (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
> > >                &tls_validate_xmit_skb);
> > >  #else
> > >         return false;
> > >
> > >
> > > Please test this and submit if it indeed solves the problem.
> > >
> > > Thanks!
> >
> > Hi Jakub,
> >
> > Thanks for the reply, unfortunately that patch does not resolve the
> > issue, I still get the same error as before. After looking into this a
> > bit further, the issue seems to be with CONFIG_TLS=m as everything
> > works when CONFIG_TLS=y.
> >
> > I also see that there was a similar issue [1] reported by Intel's
> > kbuild test robot where the cxgb4 driver isn't able to see the TLS
> > symbols when CONFIG_TLS=m.
>
> Interesting. Does your original patch solve the allyesconfig + TLS=m
> problem?

No it does not solve it, my original patch was incorrect and should
not be applied. It only masks the issue when using my specific kernel
config.

> Seems to me that CHELSIO_T4 should depend on (TLS || TLS=n), the
> CONFIG_CHELSIO_TLS_DEVICE has the dependency but AFAICT nothing prevents
> CONFIG_CHELSIO_TLS_DEVICE=m and CHELSIO_T4=y and cxgb4_main.c is under
> the latter.

You are right, adding (TLS || TLS=n) for CHELSIO_T4 resolves the build
error I am encountering.
