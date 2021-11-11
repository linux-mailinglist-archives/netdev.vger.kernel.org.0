Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DBC44D995
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhKKPzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKKPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:55:48 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8081BC061767
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:52:59 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso9475103otg.9
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOIv/URPqC6eVjwDrRR5fYOj9yjs4EkQ/pA34VIFsCI=;
        b=Eyhft6Xf2VI0gBV0H6/ONYORdlmtc9gr6jLIhwgFGDcXr7m5gGQCouC2n40kCVMDEn
         Donr40sJ+lx7Yr2GJ2XpK/gqU3Z9z+aIbAfhae3Zae05jc6Q5IrbFJP3MqerICkRSLSb
         fgPF24JHiLgQWAH4/HHnrRY9vljS8O3gqckNIbCA3LpA9fMsNpurzjtYMAuT09NJV6Kg
         HOIBIK/AQ8YRDstfGzUhdxn2q9gYvt0UbGyDOMrkOajRxI8TTeKhWaYe0SkH4/PB3PKv
         N9LdJW5MMIwLSBVEd1kaG4fDN6YBdKbihcItHB9yJFZW9gBxc5wzaeEzyBVGPwK7wUFX
         K42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOIv/URPqC6eVjwDrRR5fYOj9yjs4EkQ/pA34VIFsCI=;
        b=6/MpA6gsR1Xe+b9cN/XEllMNQERxt1QIDjdQpyXn3dY9VcqtreQ1bP8Kf1m28yB1E6
         0S76bOxGlNyFXZNtRiSiJtdTYFgNBnXhtxKZJeU80Dz6AViI7n7W432LgOiObs3t6Zqi
         gOl5Fph/Hq/o1TSoZQRfDNfBV6Vu1BUwbtYJ+TUnAv+GA8xwNF0XcLuN2OXmJRDbBW//
         puB/rcbNdwch2tVocM4vz2crpU7ovJkCXkZXOSCHM5dylfbVbL5zvMUMRlAIGkXcAi7J
         gu5dFddXS6ovUOGKREwaGdeReTXKEI912ZLtRP2z1IYTQmq8uem1UpA2+Ye2x9n6e1kI
         XClw==
X-Gm-Message-State: AOAM532vUyrQclYr30zrjboJcLUdVEKUXsY6PlHZKK6tSjArJ53n1Zzf
        2NUletn1Xvah19MUrS0olJMP/np9GfUTGBA47LixuHAU6Po=
X-Google-Smtp-Source: ABdhPJw29oJdBm4eo39mCVignGDLORgWk0k1N0EgIzqxbAugI1zvrSur0vpAQSd/U7TtjiqqSwEmA7WOYJ0I1vASkrw=
X-Received: by 2002:a9d:7548:: with SMTP id b8mr6647636otl.92.1636645978580;
 Thu, 11 Nov 2021 07:52:58 -0800 (PST)
MIME-Version: 1.0
References: <20211111003519.1050494-1-tadeusz.struk@linaro.org>
 <CANpmjNNcVFmnBV-1Daauqk5ww8YRUVRtVs_SXVAPWG5CrFBVPg@mail.gmail.com> <c410f4a0-cc06-8ef8-3765-d99e29012acb@linaro.org>
In-Reply-To: <c410f4a0-cc06-8ef8-3765-d99e29012acb@linaro.org>
From:   Marco Elver <elver@google.com>
Date:   Thu, 11 Nov 2021 16:52:46 +0100
Message-ID: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 at 16:46, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Hi Marco,
> On 11/11/21 01:51, Marco Elver wrote:
> > On Thu, 11 Nov 2021 at 01:36, Tadeusz Struk<tadeusz.struk@linaro.org>  wrote:
> >> Kernel throws a runtime object-size-mismatch error in skbuff queue
> >> helpers like in [1]. This happens every time there is a pattern
> >> like the below:
> >>
> >> int skbuf_xmit(struct sk_buff *skb)
> >> {
> >>          struct sk_buff_head list;
> >>
> >>          __skb_queue_head_init(&list);
> >>          __skb_queue_tail(&list, skb); <-- offending call
> >>
> >>          return do_xmit(net, &list);
> >> }
> >>
> >> and the kernel is build with clang and -fsanitize=undefined flag set.
> >> The reason is that the functions __skb_queue_[tail|head]() access the
> >> struct sk_buff_head object via a pointer to struct sk_buff, which is
> >> much bigger in size than the sk_buff_head. This could cause undefined
> >> behavior and clang is complaining:
> >>
> >> UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2023:28
> >> member access within address ffffc90000cb71c0 with insufficient space
> >> for an object of type 'struct sk_buff'
> > The config includes CONFIG_UBSAN_OBJECT_SIZE, right? Normally that's
> > disabled by default, probably why nobody has noticed these much.
>
> Right, in all the defconfigs CONFIG_UBSAN_OBJECT_SIZE is not set.
>
> >
> >> Suppress the error with __attribute__((no_sanitize("undefined")))
> >> in the skb helpers.
> > Isn't there a better way, because doing this might also suppress other
> > issues wholesale. __no_sanitize_undefined should be the last resort.
> >
>
> The other way to fix it would be to make the struct sk_buff_head
> equal in size with struct sk_buff:
>
>   struct sk_buff_head {
> -       /* These two members must be first. */
> -       struct sk_buff  *next;
> -       struct sk_buff  *prev;
> +       union {
> +               struct {
> +                       /* These two members must be first. */
> +                       struct sk_buff  *next;
> +                       struct sk_buff  *prev;
>
> -       __u32           qlen;
> -       spinlock_t      lock;
> +                       __u32           qlen;
> +                       spinlock_t      lock;
> +               };
> +               struct sk_buff  __prv;
> +       };
>   };
>
> but that's much more invasive, and I don't even have means to
> quantify this in terms of final binary size and performance
> impact. I think that would be a flat out no go.
>
>  From the other hand if you look at the __skb_queue functions
> they don't do much and at all so there is no much room for
> other issues really. I followed the suggestion in [1]:
>
> "if your function deliberately contains possible ..., you can
>   use __attribute__((no_sanitize... "

That general advice might not be compatible with what the kernel
wants, especially since UBSAN_OBJECT_SIZE is normally disabled and I
think known to cause these issues in the kernel.

I'll defer to maintainers to decide what would be the preferred way of
handling this.
