Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509ED574DDF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbiGNMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239438AbiGNMjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:39:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5045D58D;
        Thu, 14 Jul 2022 05:39:43 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f11so1427884pgj.7;
        Thu, 14 Jul 2022 05:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geWGB4qL+9406ISSoQRHApgTYUJeEyYKooNgFIGp6Gs=;
        b=qsemR54SFEwg2cjUWcUh4tC9rNUtUpqMSduXwQK5X7dioT5nL8sWlYXYQRY+VCmvo6
         hFjr5rnezJyIAcQYhH9MPSHmUkAV/mjjq6c8XGAAIxmxHTeZ7Qfy/tyvYtbRBiMRMAP2
         d9YV+Y3EP8jzqMFqYvTZTJGliYOtynMwQ7vj4eEX+t2UnR54Ps2Y8g+hKwwo3iZgQtyz
         14s0OjhHo/qpdn9/XrA6CCeVip5QkduYtOEhsQyIfMLeDcUDFs/dRMLnTQX7AsBOPHp+
         aouI8/01pBeo/cQr9XuJmq5w+v4f8tYu7Xwtf9TPtrhFKejq86zjSCKz+Q0AV8MLrd57
         Inhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geWGB4qL+9406ISSoQRHApgTYUJeEyYKooNgFIGp6Gs=;
        b=yVqapS03+ZhxNwONBpUH8a/JEAZhQjmkCSx5sFVQQdbKNsBthL4ZV1ikCnM0jaOfAz
         zBmlrNor2V8KYaHXNutuAQx+EjgtQvtY3IR9HjcaVfNfpByo6jQwSETwzbVi9UHl6sPG
         hqbyNt5Mvjd1y4tD7G1TWEBvTYQWPwsCMkTHztCW7cnfm/AGLSAZDtFZLmulFmXOwRkw
         VzzneInKI4fv6+CXQ06pRYEgJr1LKBQhy731rfDeB5sQhFcA4c98IvnbBWxrGZpcdJxN
         J6yZdSz3AOL4JHIkoWJd8p2Ol3SNANw9J/qT70VVGOeMWtiM/9jubTcZYS7zZH2q/CaG
         8ywg==
X-Gm-Message-State: AJIora+uER8Sfwdh09TKLJ4ZIJ0t9sKTvRX2nJzmP5cFl97nVWb3RycH
        5eJr5f4kAraiyAkJfZpHZE8Tz139uVR4N1Eyd5g=
X-Google-Smtp-Source: AGRyM1saLLVXjDkY9V9Wt3EDo4xf0+jyawRt5cU722x2AjkIScjFvNqeXZIuZ7rXlqnDcKxie74dlIiud0oEIhww2a4=
X-Received: by 2002:a65:6e95:0:b0:412:6f20:5f74 with SMTP id
 bm21-20020a656e95000000b004126f205f74mr7694302pgb.156.1657802382756; Thu, 14
 Jul 2022 05:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220707130842.49408-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220707130842.49408-1-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 14 Jul 2022 14:39:31 +0200
Message-ID: <CAJ8uoz0uaztjQ7dBrrnzJw5ghXV4uZ8GWjMaTd9GOR_FCKjo0g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] xsk: mark napi_id on sendmsg()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 3:20 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> When application runs in busy poll mode and does not receive a single
> packet but only sends them, it is currently
> impossible to get into napi_busy_loop() as napi_id is only marked on Rx
> side in xsk_rcv_check(). In there, napi_id is being taken from
> xdp_rxq_info carried by xdp_buff. From Tx perspective, we do not have
> access to it. What we have handy is the xsk pool.
>
> Xsk pool works on a pool of internal xdp_buff wrappers called
> xdp_buff_xsk. AF_XDP ZC enabled drivers call xp_set_rxq_info() so each
> of xdp_buff_xsk has a valid pointer to xdp_rxq_info of underlying queue.
> Therefore, on Tx side, napi_id can be pulled from
> xs->pool->heads[0].xdp.rxq->napi_id. Hide this pointer chase under
> helper function, xsk_pool_get_napi_id().
>
> Do this only for sockets working in ZC mode as otherwise rxq pointers
> would not be initialized.

Thanks Maciej.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>
> v2:
> * target bpf-next instead of bpf and don't treat it as fix (Bjorn)
> * hide pointer chasing under helper function (Bjorn)
>
>  include/net/xdp_sock_drv.h | 14 ++++++++++++++
>  net/xdp/xsk.c              |  5 ++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 4aa031849668..4277b0dcee05 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -44,6 +44,15 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
>         xp_set_rxq_info(pool, rxq);
>  }
>
> +static inline unsigned int xsk_pool_get_napi_id(struct xsk_buff_pool *pool)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +       return pool->heads[0].xdp.rxq->napi_id;
> +#else
> +       return 0;
> +#endif
> +}
> +
>  static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
>                                       unsigned long attrs)
>  {
> @@ -198,6 +207,11 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
>  {
>  }
>
> +static inline unsigned int xsk_pool_get_napi_id(struct xsk_buff_pool *pool)
> +{
> +       return 0;
> +}
> +
>  static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
>                                       unsigned long attrs)
>  {
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 19ac872a6624..86a97da7e50b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -637,8 +637,11 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
>         if (unlikely(need_wait))
>                 return -EOPNOTSUPP;
>
> -       if (sk_can_busy_loop(sk))
> +       if (sk_can_busy_loop(sk)) {
> +               if (xs->zc)
> +                       __sk_mark_napi_id_once(sk, xsk_pool_get_napi_id(xs->pool));
>                 sk_busy_loop(sk, 1); /* only support non-blocking sockets */
> +       }
>
>         if (xs->zc && xsk_no_wakeup(sk))
>                 return 0;
> --
> 2.27.0
>
