Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44B20CAAF
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgF1U5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgF1U5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:57:41 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963ACC03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:57:41 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t11so4758934qvk.1
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0wJ/vueFVQ63Ub0C1WVcKkJjZz6CIejPpxgzwLAp8s=;
        b=kkcEIG1dnKtjpEQTwlG9ErbByBx35BTdXyReTGvV5Mc8ov0YTTU1JuyF/IhcN3eUv1
         eofQVPM6RWg/J7+90AhhamQr8fSnp0aYj8TrMjDKN7CgAGX2F0PIlGr8ixv/2TsmFYk8
         fiBOhaY2CWGgB26qmokT9c3C7Utid29jFFC6SVmG8PMIJx7f92cA4FbPl1SfnMMyT3c3
         jQ15nVBQDeP3jzsVqCvnXhyWUzHC5U+FlZqLfNL/DJV52bG6nLeKAYAihjSmNgzsPoju
         MaQagtkP7DNBAlP19BwFdskZjD/8XLWILD1w43zeL6eBoUKX8az33EGpXxOe+dc/1yjW
         I1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0wJ/vueFVQ63Ub0C1WVcKkJjZz6CIejPpxgzwLAp8s=;
        b=aCyp661Z8Sj1inIEg/A5Sfndl3JSP1jbPVo9sSv1pRuoy7HIWBPXrRcjEgzeME67wd
         mAnM/P0fyeBBrCJnzCPdlMGc1WcBLqKUVZLmUGjmqvQkDJqaDmH6LYpVMHNhUsctfT1b
         WMz0CnVFJzEYvJ+Z5kxoGRkQtAwBfik/Lv4zarZTYF4jYZtu5nVSPobXAIWQC7VSKAhe
         yFcYZQEQFKGdPfxaf1KZXniAp7RJPtDKqGhI6vpDizihBmsE3cnKqJl8x8wGUzTbyGcv
         adLftn/Ro1IbW6pSAJUJOAm0JwDkzc9kYyORPTw+0hPRn4qepq0H2KB282lMjeVxyaA0
         wM7Q==
X-Gm-Message-State: AOAM531FxyGLE/mlji8StvPEqEqm7pPO/W5zOJedD62K3v2vxzzAUsE/
        fmRbX/fYnvlNLgDB76fbtabKiCR5
X-Google-Smtp-Source: ABdhPJye1m1gKMEUenVc9VacRXkWxLTvrkBs8TqPUGfetr2C3WSLFxj7tKbi4KvQx6ZYrqFmtzddCQ==
X-Received: by 2002:a0c:e789:: with SMTP id x9mr11797996qvn.135.1593377860031;
        Sun, 28 Jun 2020 13:57:40 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id f3sm16438727qta.44.2020.06.28.13.57.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 13:57:39 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id e197so3427671yba.5
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:57:38 -0700 (PDT)
X-Received: by 2002:a5b:5c8:: with SMTP id w8mr22027085ybp.178.1593377858397;
 Sun, 28 Jun 2020 13:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200627040535.858564-1-ysseung@google.com> <20200627040535.858564-2-ysseung@google.com>
In-Reply-To: <20200627040535.858564-2-ysseung@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Jun 2020 16:57:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfDH+75DHeT36O_nQGSodnv_z3ju_YbDkWE+mY-L-JSxg@mail.gmail.com>
Message-ID: <CA+FuTSfDH+75DHeT36O_nQGSodnv_z3ju_YbDkWE+mY-L-JSxg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue()
To:     Yousuk Seung <ysseung@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 12:06 AM Yousuk Seung <ysseung@google.com> wrote:
>
> Currently tp->delivered is updated with sacked packets but not
> cumulatively acked when SCP_TSTAMP_ACK is timestamped. This patch moves
> a tcp_ack_tstamp() call in tcp_clean_rtx_queue() to later in the loop so
> that when a skb is fully acked OPT_STATS of SCM_TSTAMP_ACK will include
> the current skb in the delivered count. When not fully acked
> tcp_ack_tstamp() is a no-op and there is no change in behavior.
>
> Signed-off-by: Yousuk Seung <ysseung@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> ---
>  net/ipv4/tcp_input.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index f3a0eb139b76..2a683e785cca 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3078,8 +3078,6 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
>                 u8 sacked = scb->sacked;
>                 u32 acked_pcount;
>
> -               tcp_ack_tstamp(sk, skb, prior_snd_una);
> -
>                 /* Determine how many packets and what bytes were acked, tso and else */
>                 if (after(scb->end_seq, tp->snd_una)) {
>                         if (tcp_skb_pcount(skb) == 1 ||
> @@ -3143,6 +3141,8 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
>                 if (!fully_acked)
>                         break;
>
> +               tcp_ack_tstamp(sk, skb, prior_snd_una);
> +
>                 next = skb_rb_next(skb);
>                 if (unlikely(skb == tp->retransmit_skb_hint))
>                         tp->retransmit_skb_hint = NULL;

This moves tcp_ack_tstamp beyond these two breaks:

                tcp_ack_tstamp(sk, skb, prior_snd_una);

                /* Determine how many packets and what bytes were
acked, tso and else */
                if (after(scb->end_seq, tp->snd_una)) {
                        if (tcp_skb_pcount(skb) == 1 ||
                            !after(tp->snd_una, scb->seq))
                                break;

                        acked_pcount = tcp_tso_acked(sk, skb);
                        if (!acked_pcount)
                                break;
                        fully_acked = false;
                } else {
                        acked_pcount = tcp_skb_pcount(skb);
                }

but tcp_ack_tstamp does not necessarily act on the end_seq in the
packet, it acts on shinfo->tskey:

        if (!before(shinfo->tskey, prior_snd_una) &&
            before(shinfo->tskey, tcp_sk(sk)->snd_una)) {
                tcp_skb_tsorted_save(skb) {
                        __skb_tstamp_tx(skb, NULL, sk, SCM_TSTAMP_ACK);
                } tcp_skb_tsorted_restore(skb);
        }

on the next call to tcp_clean_rtx_queue tcp_sk(sk)->snd_una will be
beyond tskey, so can this result in missing notifications?
