Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3FB30C5BD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhBBQ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbhBBQ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:27:12 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA467C06178C
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 08:26:30 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id f8so1425692ion.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 08:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2zQiZHmnRg8CO0Odf7A4HecWbMLkfiCigrv795XIA4=;
        b=JmuS9PGraWOtYFvEPQs+8tTBSGL1zW+lZn92nvMhLC6Ts8BtHgqQhwNha67Q9AykjR
         UIllufiJ4ibt6W7Bc+VbX6zRikgBJme9sYcQSzqzLLVO+aDQJNmfVYsoDYz5EvQ88Icw
         NJHtHDfolBVZRO3mPHHDYs/k2mO/VzNA9pVMvErXwM21KIyxG2e45zjNnbOFtu1c+oan
         ra16OjEmgI77qBD/0yAfDPqFbycyRpKyuQ0Ar/I6D/5QM+2u2tW3Qz6u3V2YcCaE9uCR
         Qgu5ImIryaJO9gakLQF8Uq8OAInKcPe6Yuj2Z7MOeezDIfxsJhzp/m2Q54XzZGSjC3Ub
         otnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B2zQiZHmnRg8CO0Odf7A4HecWbMLkfiCigrv795XIA4=;
        b=nuO7xBisZe+F99yGadkF/FBwF/DpsOEHRS18Vrc0DdL7x+k5GPHjc1A39Q/YFIvAJK
         dw4Krj+Ats4qXsRpLZkAITpy3jx5ivbkB7ssya6Hqsblhg+b6oRt9wz2Qgsgb3aHPWkl
         IyM+hLdXrQWr/T4vTSlTDoEMPCuZmLrFBKUzSOunMFsWwvz3zAfySTq+wKkC2p6z+uWF
         tXIU8dKyyDEI6Iaku6r0CqJ1Ok2i2EOlJ6SvKvD5RL5bxtj8cz0XPDDqMAmZu5Y7w1wy
         uirkRDvTI3FxDvdu7Dt6xab4RL/xRi3X/I0YL9qdo29ZiEG3YsmcCrku9d97AxWcgirV
         p0FA==
X-Gm-Message-State: AOAM533vLaku/rqUdyismMbj+paIopVWQHjVOztt7UZkko/S+wsA0egT
        CteJL2k/VWbRaw2CKMduluvoVfCoJVTyjbfU5cc=
X-Google-Smtp-Source: ABdhPJxFtkLlEcJv0CVt6R90d+HWQkQtxskICSpXTHciDeIDqKaQyN8qwvj3lxqNeF5Mp6rHO+fqE1PRBGfyHCkKYbI=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr18193308ioa.88.1612283190109;
 Tue, 02 Feb 2021 08:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20210131074426.44154-1-haokexin@gmail.com> <20210131074426.44154-3-haokexin@gmail.com>
In-Reply-To: <20210131074426.44154-3-haokexin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 2 Feb 2021 08:26:19 -0800
Message-ID: <CAKgT0UcnqCBWZBZ6ySaV0fhSPAPANbmvxGDZjSNSpEkyUjp5eg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net: Introduce {netdev,napi}_alloc_frag_align()
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 12:17 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current implementation of {netdev,napi}_alloc_frag(), it doesn't
> have any align guarantee for the returned buffer address, But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the {netdev,napi}_alloc_frag() are used by these hardwares
> for DMA.
>     buf = napi_alloc_frag(really_needed_size + align);
>     buf = PTR_ALIGN(buf, align);
>
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX. We have added the align
> support for the page_frag functions, so add the corresponding
> {netdev,napi}_frag functions.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
> v2: Inline {netdev,napi}_alloc_frag().
>
>  include/linux/skbuff.h | 22 ++++++++++++++++++++--
>  net/core/skbuff.c      | 25 +++++++++----------------
>  2 files changed, 29 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 9313b5aaf45b..7e8beff4ff22 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2818,7 +2818,19 @@ void skb_queue_purge(struct sk_buff_head *list);
>
>  unsigned int skb_rbtree_purge(struct rb_root *root);
>
> -void *netdev_alloc_frag(unsigned int fragsz);
> +void *netdev_alloc_frag_align(unsigned int fragsz, int align);
> +
> +/**
> + * netdev_alloc_frag - allocate a page fragment
> + * @fragsz: fragment size
> + *
> + * Allocates a frag from a page for receive buffer.
> + * Uses GFP_ATOMIC allocations.
> + */
> +static inline void *netdev_alloc_frag(unsigned int fragsz)
> +{
> +       return netdev_alloc_frag_align(fragsz, 0);
> +}
>

So one thing we may want to do is actually split this up so that we
have a __netdev_alloc_frag_align function that is called by one of two
inline functions. The standard netdev_alloc_frag would be like what
you have here, however we would be passing ~0 for the mask.

The "align" version would be taking in an unsigned int align value and
converting it to a mask. The idea is that your mask value is likely a
constant so converting the constant to a mask would be much easier to
do in an inline function as the compiler can take care of converting
the value during compile time.

An added value to that is you could also add tests to the align value
to guarantee that the value being passed is a power of 2 so that it
works with the alignment mask generation as expected.

>  struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int length,
>                                    gfp_t gfp_mask);
> @@ -2877,7 +2889,13 @@ static inline void skb_free_frag(void *addr)
>         page_frag_free(addr);
>  }
>
> -void *napi_alloc_frag(unsigned int fragsz);
> +void *napi_alloc_frag_align(unsigned int fragsz, int align);
> +
> +static inline void *napi_alloc_frag(unsigned int fragsz)
> +{
> +       return napi_alloc_frag_align(fragsz, 0);
> +}
> +
>  struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
>                                  unsigned int length, gfp_t gfp_mask);
>  static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,

Same for the __napi_alloc_frag code. You could probably convert the
__napi_alloc_frag below into an __napi_alloc_frag_align that you pass
a mask to. Then you could convert the other two functions to either
pass ~0 or the align value and add align value validation.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 2af12f7e170c..a35e75f12428 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -374,29 +374,22 @@ struct napi_alloc_cache {
>  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
>  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
>
> -static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
> +static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask, int align)
>  {
>         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
>
> -       return page_frag_alloc(&nc->page, fragsz, gfp_mask);
> +       return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align);
>  }
>
> -void *napi_alloc_frag(unsigned int fragsz)
> +void *napi_alloc_frag_align(unsigned int fragsz, int align)
>  {
>         fragsz = SKB_DATA_ALIGN(fragsz);
>
> -       return __napi_alloc_frag(fragsz, GFP_ATOMIC);
> +       return __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
>  }
> -EXPORT_SYMBOL(napi_alloc_frag);
> +EXPORT_SYMBOL(napi_alloc_frag_align);
>
> -/**
> - * netdev_alloc_frag - allocate a page fragment
> - * @fragsz: fragment size
> - *
> - * Allocates a frag from a page for receive buffer.
> - * Uses GFP_ATOMIC allocations.
> - */
> -void *netdev_alloc_frag(unsigned int fragsz)
> +void *netdev_alloc_frag_align(unsigned int fragsz, int align)
>  {
>         struct page_frag_cache *nc;
>         void *data;
> @@ -404,15 +397,15 @@ void *netdev_alloc_frag(unsigned int fragsz)
>         fragsz = SKB_DATA_ALIGN(fragsz);
>         if (in_irq() || irqs_disabled()) {
>                 nc = this_cpu_ptr(&netdev_alloc_cache);
> -               data = page_frag_alloc(nc, fragsz, GFP_ATOMIC);
> +               data = page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align);
>         } else {
>                 local_bh_disable();
> -               data = __napi_alloc_frag(fragsz, GFP_ATOMIC);
> +               data = __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
>                 local_bh_enable();
>         }
>         return data;
>  }
> -EXPORT_SYMBOL(netdev_alloc_frag);
> +EXPORT_SYMBOL(netdev_alloc_frag_align);
>
>  /**
>   *     __netdev_alloc_skb - allocate an skbuff for rx on a specific device
> --
> 2.29.2
>
