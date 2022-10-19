Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A9B60525F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiJSV4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiJSVzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:55:48 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D6C18499D;
        Wed, 19 Oct 2022 14:55:33 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso22341857fac.6;
        Wed, 19 Oct 2022 14:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AdGMjnq7E++U/DphCr9ATKf5sHD8nmk5LlQJFPFavwY=;
        b=p+Yjqi45aiig6SqDsJNA7Lg2TwLPJzIeRScNb5/yHmuAquxLwviiXdxZVRTU0yuXxV
         QfWFpT7GjyotHvNaLQml1HmB4a+l9aK9mbRi9o8Y7SnKgNO7avG4bWkp86wetJHdL8CG
         fWsff+UFO1t7ODNFg2vwl8sfXkcyFBGq8nyN8iALmKG4BdeMjaG3AvtTM+DlPdcexrsb
         i7hLf7bZBfCfePjpLMEua4aIUbgGDELnhd3oUdnueV5P/5f8nVqBdduLXs0a+Q328IcD
         NXPqI+zVmDrSv8Y4lYHrRAcCG2sYl977QknoqeizpGyxXqmEK7SPCKE6oEeYo3qnpo0I
         GcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdGMjnq7E++U/DphCr9ATKf5sHD8nmk5LlQJFPFavwY=;
        b=4qfHokFnjOdJirDmwRKf681QiVZgk2cSBUQ7ZfRO8Usjk1OQYiaJCwVh+NUm/3/rJ6
         SbqWTnFw/Q6fmtiMLt3IVgFSS2Hr/YFmuYa1xEnMqgi23bB+lzr+aYnEcl+dl6oDfVSM
         GOBqFvOw68GxFoAhuxBqRRYBB5zAg8dP0XBCXAFc7NXtfY0FUyMmlr9hZPQsHf6sUJ+K
         RYIkiYy36cEtuxA8dfypNkBxRlAr5xPwOswoiuNLxAAwaFQBdzyGQC9vp1Pf4IPdNHh0
         MXfOI+M+6zQjaya5VxKHVHpFSRG0VSnYUVbc4KmhtXiDyOw6IXLCVGODlth+VRYMV3+z
         ip4A==
X-Gm-Message-State: ACrzQf0S2jPMGYtKBFHa4Apqg2BpKlm5p8GyjSBbtrmShKwSkf1xjRHT
        7xZHSW+rgeVTFwiCL2tVte9h67la4ziF2DH21l+2lZOVgEQ=
X-Google-Smtp-Source: AMsMyM7+Bkbr7wPYYyUnmLO5awDZ7A9AfENpLlYLCNs6UIGi+2WzT2MQwhPWVDixRSnOFvyryeY4AHnL4lJaKjF8hqI=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr23562948oaq.190.1666216532311; Wed, 19
 Oct 2022 14:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com> <20221019180735.161388-3-aleksei.kodanev@bell-sw.com>
In-Reply-To: <20221019180735.161388-3-aleksei.kodanev@bell-sw.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 19 Oct 2022 17:28:02 -0400
Message-ID: <CADvbK_dDWTuKUa9HWZbSm4XSONLpezfOasJVkaAcv5z4T8Orgg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] sctp: remove unnecessary NULL checks in sctp_enqueue_event()
To:     Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 2:36 PM Alexey Kodanev
<aleksei.kodanev@bell-sw.com> wrote:
>
> After commit 178ca044aa60 ("sctp: Make sctp_enqueue_event tak an
> skb list."), skb_list cannot be NULL.
>
> Detected using the static analysis tool - Svace.
> Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
> ---
>  net/sctp/stream_interleave.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index bb22b71df7a3..94727feb07b3 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -490,11 +490,8 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
>         if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
>                 goto out_free;
>
> -       if (skb_list)
> -               skb_queue_splice_tail_init(skb_list,
> -                                          &sk->sk_receive_queue);
> -       else
> -               __skb_queue_tail(&sk->sk_receive_queue, skb);
> +       skb_queue_splice_tail_init(skb_list,
> +                                  &sk->sk_receive_queue);
>
>         if (!sp->data_ready_signalled) {
>                 sp->data_ready_signalled = 1;
> @@ -504,10 +501,7 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
>         return 1;
>
>  out_free:
> -       if (skb_list)
> -               sctp_queue_purge_ulpevents(skb_list);
> -       else
> -               sctp_ulpevent_free(event);
> +       sctp_queue_purge_ulpevents(skb_list);
>
>         return 0;
>  }
> --
> 2.25.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
