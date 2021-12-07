Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7454A46BDAB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbhLGOc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237898AbhLGOcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:32:05 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700FC061748
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:28:34 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id r15so26940609uao.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 06:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+pTq/rNRb0GVVWsWFqooCtbaZQV3QoTUSDWZ/1ESNo=;
        b=iMF1KwZbiDUEssdyUY1GU5d4NT6EKJXVavUG68A3NKd4pA8WtCwY4EfUNA29xnzfBv
         t3W8eoUiyOvMNLfbplaBM4QioXPpoEKtNIww0hEqIi+4gHQdwIagcYhxFUap18lo2zWb
         xIQ1qBfco/VdfdF1FkvN3Fqx5dP3bQaIdS078mUsprDw7ZESXsil7ZbXbZLP98UBMyWP
         oE6L9dfEZhKLY4i2NI7kySGfOl7c3JWc9wlbKYTtTntm7fEcBf0fRxzYQmRADVhQkz8W
         dTBPNlJIgXWPjPo+J64VNbO4XjWaRre6skfpdvSsHuUdpdjfmYRdVXhUXx53Rvfwi3uf
         ljuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+pTq/rNRb0GVVWsWFqooCtbaZQV3QoTUSDWZ/1ESNo=;
        b=g8zG5anJHdbvjKFOeU/ficdhoVvt5HCFNoEDp3gg65rTVr4hp+o4MY+gi7kllEZUjZ
         FEATqeVJ9PtW1+Ocmx0BoLOqRfZaY12+K+GiA8+3VsQkYLhC2rT+mhuvy5f89S1DvBK8
         3kgnUCrOZq1QA5HjQYoYOtd3mgm4J+5MXmR7IsGz3hOc3Y8nmUhFh/p01dQ576USEArc
         2t5DXY9ZHR/Zhbd2plyCETfxTe3OQhZyxaXd384xYUvT374FGNfjZM+IzgTSjTpLhNNa
         arIyc8yuUOuYqOpmFUt7s88Z5US+WD39keFTtJ0bgwZ3Kwa7SshI0eycym4FlfDb0BN1
         Nqkg==
X-Gm-Message-State: AOAM532ycNkt+F3hJDrBtzstCAhcaqP5ZJGWKVhqFOyIueauEvs/BNE8
        jrsFZyxoTHY8EoKCkyuU3cJ4hSJl+7M=
X-Google-Smtp-Source: ABdhPJxOfXbdDwM2Eza4pdXiDc7Nqfq3yH4a52krROdjQqgHWOqpWtCp6bfllbcqroflcDtaAW3WDA==
X-Received: by 2002:a05:6102:38c7:: with SMTP id k7mr45389512vst.45.1638887313404;
        Tue, 07 Dec 2021 06:28:33 -0800 (PST)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id w17sm6509596uar.18.2021.12.07.06.28.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 06:28:33 -0800 (PST)
Received: by mail-vk1-f182.google.com with SMTP id b192so9402266vkf.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 06:28:32 -0800 (PST)
X-Received: by 2002:a1f:c9c2:: with SMTP id z185mr52743193vkf.26.1638887312607;
 Tue, 07 Dec 2021 06:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20211207020102.3690724-1-kafai@fb.com> <20211207020108.3691229-1-kafai@fb.com>
In-Reply-To: <20211207020108.3691229-1-kafai@fb.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 7 Dec 2021 09:27:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
Message-ID: <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 9:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The skb->tstamp may be set by a local sk (as a sender in tcp) which then
> forwarded and delivered to another sk (as a receiver).
>
> An example:
>     sender-sk => veth@netns =====> veth@host => receiver-sk
>                              ^^^
>                         __dev_forward_skb
>
> The skb->tstamp is marked with a future TX time.  This future
> skb->tstamp will confuse the receiver-sk.
>
> This patch marks the skb if the skb->tstamp is forwarded.
> Before using the skb->tstamp as a rx timestamp, it needs
> to be re-stamped to avoid getting a future time.  It is
> done in the RX timestamp reading helper skb_get_ktime().
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/skbuff.h | 14 +++++++++-----
>  net/core/dev.c         |  4 +++-
>  net/core/skbuff.c      |  6 +++++-
>  3 files changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index b609bdc5398b..bc4ae34c4e22 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -867,6 +867,7 @@ struct sk_buff {
>         __u8                    decrypted:1;
>  #endif
>         __u8                    slow_gro:1;
> +       __u8                    fwd_tstamp:1;
>
>  #ifdef CONFIG_NET_SCHED
>         __u16                   tc_index;       /* traffic control index */
> @@ -3806,9 +3807,12 @@ static inline void skb_copy_to_linear_data_offset(struct sk_buff *skb,
>  }
>
>  void skb_init(void);
> +void net_timestamp_set(struct sk_buff *skb);
>
> -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
> +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
>  {
> +       if (unlikely(skb->fwd_tstamp))
> +               net_timestamp_set(skb);
>         return ktime_mono_to_real_cond(skb->tstamp);

This changes timestamp behavior for existing applications, probably
worth mentioning in the commit message if nothing else. A timestamp
taking at the time of the recv syscall is not very useful.

If a forwarded timestamp is not a future delivery time (as those are
scrubbed), is it not correct to just deliver the original timestamp?
It probably was taken at some earlier __netif_receive_skb_core.

>  }
>
> -static inline void net_timestamp_set(struct sk_buff *skb)
> +void net_timestamp_set(struct sk_buff *skb)
>  {
>         skb->tstamp = 0;
> +       skb->fwd_tstamp = 0;
>         if (static_branch_unlikely(&netstamp_needed_key))
>                 __net_timestamp(skb);
>  }
> +EXPORT_SYMBOL(net_timestamp_set);
>
>  #define net_timestamp_check(COND, SKB)                         \
>         if (static_branch_unlikely(&netstamp_needed_key)) {     \
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f091c7807a9e..181ddc989ead 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
>  {
>         struct sock *sk = skb->sk;
>
> -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {

There is a slight race here with the socket flipping the feature on/off.

>
>                 skb->tstamp = 0;
> +               skb->fwd_tstamp = 0;
> +       } else if (skb->tstamp) {
> +               skb->fwd_tstamp = 1;
> +       }

SO_TXTIME future delivery times are scrubbed, but TCP future delivery
times are not?

If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
scrub based on that. That is also not open to the above race.
