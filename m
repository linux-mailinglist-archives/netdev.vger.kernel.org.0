Return-Path: <netdev+bounces-6708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0EA5717818
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E7FC280C84
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41099A944;
	Wed, 31 May 2023 07:25:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29804946F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:25:05 +0000 (UTC)
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CFE113
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:25:03 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6af70ff2761so2511419a34.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685517902; x=1688109902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3XN5XywXlgVOwHgZASZA1BJXNhGpca/IzUInzTBpB8=;
        b=hzlk1OuRvx1eYGURihBjM9pqBUnL0H4MxM8nhgQUyJnOR+lbmN1KvHrM91Mvi/MN4G
         lQVAc1p7jIjGhg7WNyjjonXNch0uZ/GIqeO1ZJ9Z2AjgtX61TDLUy2+g+23KRL3sCYF0
         uOao1km7wdvHY/0r+uF5k5i6C5SkABQ8Kaz/d/ja/0CxevFqxjg4jC/GOABGjpsx05Hq
         CtKHLR5m5iMWKkPDKrI1D2T38ctxWylx2y1UbPHWVXMGK15umwpl9n0Aehh5IKrYt1XX
         P1dij94HN0R5guaAfoQm7916fLMWA2Hg+W56oZ4OmCfqjIF2dHlOtBA2xeIyvYUDPk6S
         GS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517902; x=1688109902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v3XN5XywXlgVOwHgZASZA1BJXNhGpca/IzUInzTBpB8=;
        b=bn7Vgj3+RJh3zTcko0BxJKBiKDfel2A5xFYy4yuv4Hx2b5psxv5REO3X9dNDp/8Nvt
         9nPzhzlU1l/pLxZNIuZ3F5D3Veu/P04AiQkMzdKLHf7WhBxtSUhFvN+D/QeaqVwQgFgZ
         9SVq9m48Wu9cIIGfkE4r8ooZ1eR+OkUFsb7d4F7i1pPntdomPQN8mBFUWtq6alubGV2R
         wbgkfIatylxF+pH5ml7snNOkQsjDXDBUwsqmEKjDKaeGELUamBsU+INeH3gGsgs3+Qbu
         mZvWcGTef9AS132BfYnALMTcrH71ZeuAhNUoFOKnPnxAsYdm21LEHiCx9ZmvTF5X6k4z
         ucZg==
X-Gm-Message-State: AC+VfDz3Ev6Qnrb2Uoe3FPVuYlPxhlgdtJZt/yfjHXjSSn415fVI6Vq3
	7habg6XEBL9TXo6KX9704m73cwn918Y12R5eV0Q=
X-Google-Smtp-Source: ACHHUZ5qNPFRx6ZaGIo1Su0FgyAWvj4i/1VCm+1vRNC0vyfrAzJ2Grp0QbYQPu9wy8k5hhgLbAygRSO8Kf2+LuUbdcs=
X-Received: by 2002:aca:1910:0:b0:396:12cb:1349 with SMTP id
 l16-20020aca1910000000b0039612cb1349mr2820836oii.38.1685517902656; Wed, 31
 May 2023 00:25:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530155919.GA6803@didi-ThinkCentre-M920t-N000> <CANn89iLm7m5FYmOZz14Vdkpz9r+NvomnWb=iTBEXqvLa_aYanA@mail.gmail.com>
In-Reply-To: <CANn89iLm7m5FYmOZz14Vdkpz9r+NvomnWb=iTBEXqvLa_aYanA@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 31 May 2023 15:24:26 +0800
Message-ID: <CAL+tcoCz=fSn89mCWb+RhOpBhykM-Y4tpYaoW6d=3JmniudDOA@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: fix mishandling when the sack compression is deferred
To: Eric Dumazet <edumazet@google.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 2:48=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, May 30, 2023 at 6:03=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.com=
> wrote:
> >
> > In this patch, we mainly try to handle sending a compressed ack
> > correctly if it's deferred.
> >
> > Here are more details in the old logic:
> > When sack compression is triggered in the tcp_compressed_ack_kick(),
> > if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
> > and then defer to the release cb phrase. Later once user releases
> > the sock, tcp_delack_timer_handler() should send a ack as expected,
> > which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
> > Therefore, the receiver would not sent an ack until the sender's
> > retransmission timeout. It definitely increases unnecessary latency.
> >
> > Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkC=
entre-M920t-N000/
> > ---
> > v3:
> > 1) remove the flag which is newly added in v2 patch.
> > 2) adjust the commit message.
> >
> > v2:
> > 1) change the commit title and message
> > 2) reuse the delayed ack logic when handling the sack compression
> > as suggested by Eric.
> > 3) "merge" another related patch into this one. See the second link.
> > ---
> >  include/net/tcp.h    |  1 +
> >  net/ipv4/tcp_input.c |  2 +-
> >  net/ipv4/tcp_timer.c | 16 +++++++++++++---
> >  3 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 18a038d16434..6e1cd583a899 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -480,6 +480,7 @@ int tcp_disconnect(struct sock *sk, int flags);
> >

[...]
> >  void tcp_finish_connect(struct sock *sk, struct sk_buff *skb);
> >  int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size);
> > +void tcp_sack_compress_send_ack(struct sock *sk);
> >  void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb);
> >
> >  /* From syncookies.c */
>
>
> Minor nit, could you move this in the following section ?

Sure, it's much better.

>
> /* tcp_input.c */
> void tcp_rearm_rto(struct sock *sk);
> void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
> void tcp_reset(struct sock *sk, struct sk_buff *skb);
> void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff =
*skb);
> void tcp_fin(struct sock *sk);
> void tcp_check_space(struct sock *sk);
>
> tcp_sack_compress_send_ack() is in fact in tcp_input.c
>
> Then add
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> Thanks !

Thanks for your review :)

Jason

