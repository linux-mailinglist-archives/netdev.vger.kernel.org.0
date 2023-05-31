Return-Path: <netdev+bounces-6693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C7F717721
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01C55280A51
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091C979DD;
	Wed, 31 May 2023 06:48:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3C78F6F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:48:15 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126BA123
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:48:14 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so30045e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685515692; x=1688107692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pFwUv48IP36ZUNvtIci1j26z9IzHrM+IwZwR9z/cxs=;
        b=JXaOstH8Z8L7iKPzprV7XpWhS3byDAxR20PvKFoD9FQMglJ+NH4CCKB+MlI/CxgIUi
         kdIyv9tF8JLmjRJaj3R3gFY5WbQC2f1MW4Sl8xtovkoOjRW0x03uX+VgSGOrkHbktCcg
         ZrjFgHpXZgKI4qFmntq9zFzQSH8Pxspll9LRMQah0UDqJEZF+biycd319Aqm9u/Wrwiy
         OBln/79IQdKabPHFQtIyLLtHViADx5ng2bRKbPtakOfLHh/cNfnz5vpMjsEgg3AGbTJP
         sIBhysJK2blROuNCIHFQhU8+jOHpkECSmhFqbbevgj0x/yY8Q1S16CtlAln14H80KDii
         Gcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685515692; x=1688107692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pFwUv48IP36ZUNvtIci1j26z9IzHrM+IwZwR9z/cxs=;
        b=EL2fraJb8CtVLNFUnepS7um9GnQx/48FRf2zuLUlEwnPK2KNxLvUJXbAmDPeRq5SCo
         JOWDtqrBTdON03wll15xFg7Eu1Rg20jRHjXgh7jR+5TaLE16054JQGAmeISnR5fTNiGd
         A8THhzACUHaXIpvdIjsDgKUo+wX52fRx+mvru2QQAedZGqjAV5CGZgjnebY1kFmczsCw
         38gC0l/Azx0Vkg8lOfp/z7rz62mQeXyXVNAF5YJOfZy4lf0EKa9k4JjJ10So9GjJgghl
         dHYjyJCQ6r7dfHgsFAsJ12jWfr69MQuDXPsNTebovQkWUvGKvK7VQPOWoXmqjJ/bFYmM
         CMkA==
X-Gm-Message-State: AC+VfDwoDsWYaRIj3fBEI7tTd0B/VMSzwBCqbo4++DUPm1Ys7ZGHrKNp
	7TTLmmUQ4OwIqsXftBGpn0l8zX14CKZoKy/njAv4lQ==
X-Google-Smtp-Source: ACHHUZ4nNkxnMalasZUURD4NAdcRsrkFilgNezzvuD2hg+znVDgcWAePDnd7UZWh7iBdrjrv15HyZqXmWXa+YBdLFSE=
X-Received: by 2002:a05:600c:310f:b0:3f1:6fe9:4a95 with SMTP id
 g15-20020a05600c310f00b003f16fe94a95mr110930wmo.4.1685515692359; Tue, 30 May
 2023 23:48:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530155919.GA6803@didi-ThinkCentre-M920t-N000>
In-Reply-To: <20230530155919.GA6803@didi-ThinkCentre-M920t-N000>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 08:48:00 +0200
Message-ID: <CANn89iLm7m5FYmOZz14Vdkpz9r+NvomnWb=iTBEXqvLa_aYanA@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: fix mishandling when the sack compression is deferred
To: fuyuanli <fuyuanli@didiglobal.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>, Jason Xing <kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 6:03=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.com> =
wrote:
>
> In this patch, we mainly try to handle sending a compressed ack
> correctly if it's deferred.
>
> Here are more details in the old logic:
> When sack compression is triggered in the tcp_compressed_ack_kick(),
> if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
> and then defer to the release cb phrase. Later once user releases
> the sock, tcp_delack_timer_handler() should send a ack as expected,
> which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
> Therefore, the receiver would not sent an ack until the sender's
> retransmission timeout. It definitely increases unnecessary latency.
>
> Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkCen=
tre-M920t-N000/
> ---
> v3:
> 1) remove the flag which is newly added in v2 patch.
> 2) adjust the commit message.
>
> v2:
> 1) change the commit title and message
> 2) reuse the delayed ack logic when handling the sack compression
> as suggested by Eric.
> 3) "merge" another related patch into this one. See the second link.
> ---
>  include/net/tcp.h    |  1 +
>  net/ipv4/tcp_input.c |  2 +-
>  net/ipv4/tcp_timer.c | 16 +++++++++++++---
>  3 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 18a038d16434..6e1cd583a899 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -480,6 +480,7 @@ int tcp_disconnect(struct sock *sk, int flags);
>
>  void tcp_finish_connect(struct sock *sk, struct sk_buff *skb);
>  int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size);
> +void tcp_sack_compress_send_ack(struct sock *sk);
>  void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb);
>
>  /* From syncookies.c */


Minor nit, could you move this in the following section ?

/* tcp_input.c */
void tcp_rearm_rto(struct sock *sk);
void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
void tcp_reset(struct sock *sk, struct sk_buff *skb);
void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *s=
kb);
void tcp_fin(struct sock *sk);
void tcp_check_space(struct sock *sk);

tcp_sack_compress_send_ack() is in fact in tcp_input.c

Then add

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

