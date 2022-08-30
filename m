Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A975A5866
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiH3AYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiH3AYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:24:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEBB82756
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:24:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso309407wmr.3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Uf0Nzwg/eLbFsZ9xx+gCHqUze7sCJrVqLEAt+R8qQDw=;
        b=LhIoieDQouo6Ng0y9V0FUPsBKca3hzt2SW5Q6W8jxFHiN1d8kfLaw7TSQ/Ug8EN+Z5
         ZDMQ4kjEVQLc6erVGfrOd7Vau5MA2IxT2DJYmuvLr3YFzg0uz65/iwAAdOJ48NOzfPuL
         F2IUdORMcjOYK5Sne1pA7R3SInGlKGaiCV+TmPVYrMPP0qDYvFvlDhKDlJICLpQWhROA
         Jf7rlZ8h21ysxjRGufeCNIg9FKFwbf8uT4ev5PeEp20NtgAuhWUGrB8a5nTsEOFSUE+x
         QKnOJ7kq5y1+8zuJVm3swaWpDZXWMk4Ih0q9OqwXeqRHj90Q6WTCW0dJLUhjthAuVP+9
         9adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Uf0Nzwg/eLbFsZ9xx+gCHqUze7sCJrVqLEAt+R8qQDw=;
        b=i8mQhAiI6SNfLbMSeSlFmm9abBTD6EhWZlh8nglqD8idzDenMYRzcFG7MXgXPznQLG
         hGMgTdAJK06/0224EBK0ivyqqY5u+MoSpjKqD06rKuWTRiNanxfQTeEQF9iY6JsaUi8O
         ymRlJmxi0tIVH30itdjv4L/NjKpzcMj7XVZoWJwoqFG+7yuLPlfc/kn37QopaKmIdiY/
         kzrJvLvghD21HQDpLDeExnufRaiR3Fu8gYYoHvBHL/3+yBA/pNYlo9SFqYMH9DCaqvvU
         sYDZg1M2FWIQg7nDOrn5KAy42mFd/xBUY8z/d8ssMSytH0qm+FDsjR0RN1DrETNwlcCf
         z6hA==
X-Gm-Message-State: ACgBeo1wbxq/wcL7nUeh3RlaoaPJlXtWsPHaulvLmgNtA130Pm1RQ6G7
        eAd64CQRI6WWPXdgsYwtS4WB9dvD1kocQVc0KljKzg==
X-Google-Smtp-Source: AA6agR7wieSxDieky3m+JdewXXkLhOe3u0jx2gN/IqAXWjOi2P42ZSHzq99EVXJDHRScShieZa0jD97Mi1tXtflXVEM=
X-Received: by 2002:a05:600c:19d1:b0:3a6:14e5:4725 with SMTP id
 u17-20020a05600c19d100b003a614e54725mr7837816wmq.141.1661819075369; Mon, 29
 Aug 2022 17:24:35 -0700 (PDT)
MIME-Version: 1.0
References: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 29 Aug 2022 17:23:58 -0700
Message-ID: <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
Subject: Re: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as lost
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 1:21 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> if rack is enabled, when skb marked as lost we can remove it from
> tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
> in tcp_rack_detect_loss

Did you test the case where an skb is marked lost again after
retransmission? I can't quite remember the reason I avoided this
optimization. let me run some test and get back to you.


>
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> ---
>  net/ipv4/tcp_input.c    | 15 +++++++++------
>  net/ipv4/tcp_recovery.c |  1 -
>  2 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index ab5f0ea..01bd644 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1082,6 +1082,12 @@ static void tcp_notify_skb_loss_event(struct tcp_sock *tp, const struct sk_buff
>         tp->lost += tcp_skb_pcount(skb);
>  }
>
> +static bool tcp_is_rack(const struct sock *sk)
> +{
> +       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
> +               TCP_RACK_LOSS_DETECTION;
> +}
> +
>  void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
>  {
>         __u8 sacked = TCP_SKB_CB(skb)->sacked;
> @@ -1105,6 +1111,9 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
>                 TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
>                 tcp_notify_skb_loss_event(tp, skb);
>         }
> +
> +       if (tcp_is_rack(sk))
> +               list_del_init(&skb->tcp_tsorted_anchor);
>  }
>
>  /* Updates the delivered and delivered_ce counts */
> @@ -2093,12 +2102,6 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
>         tp->undo_retrans = tp->retrans_out ? : -1;
>  }
>
> -static bool tcp_is_rack(const struct sock *sk)
> -{
> -       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
> -               TCP_RACK_LOSS_DETECTION;
> -}
> -
>  /* If we detect SACK reneging, forget all SACK information
>   * and reset tags completely, otherwise preserve SACKs. If receiver
>   * dropped its ofo queue, we will know this due to reneging detection.
> diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
> index 50abaa9..ba52ec9e 100644
> --- a/net/ipv4/tcp_recovery.c
> +++ b/net/ipv4/tcp_recovery.c
> @@ -84,7 +84,6 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
>                 remaining = tcp_rack_skb_timeout(tp, skb, reo_wnd);
>                 if (remaining <= 0) {
>                         tcp_mark_skb_lost(sk, skb);
> -                       list_del_init(&skb->tcp_tsorted_anchor);
>                 } else {
>                         /* Record maximum wait time */
>                         *reo_timeout = max_t(u32, *reo_timeout, remaining);
> --
> 1.8.3.1
>
