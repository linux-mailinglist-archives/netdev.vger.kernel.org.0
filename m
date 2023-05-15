Return-Path: <netdev+bounces-2738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FF3703C36
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20409280FEC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1346617AA3;
	Mon, 15 May 2023 18:15:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B25C2C8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:14:59 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356814685
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:14:46 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso389535e9.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684174484; x=1686766484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOKorS2J4RYeRLpH2nZdhlw6zsIATdNqLobWtCvJD3c=;
        b=DpNqjRLY3IjEbVTtLp9Kk6Ri2D3jZqUZuaqV+eSWm/5pfZ3m00ggUO5t/pmOKiyAbl
         qO1P3zAi7M35RkwUqpB9tsiiL6rvYdQtBxjPe4f8RpmCM9Kt7GH+GtFWuw1YmS/6H4D0
         PsnMNk6Io7+y5yZFSE6SeN541sOPK2sTzZqBKb+xIW7eAqVuJtvv6119YLYt/yr+0AWN
         FVF0GOXUhBkfFAOPlYkpLlJXdMORcGy4FuuuWZObKxGNyDHc51QuRW0zx1ziylqq8ePf
         88NbIw8qSa60wDkwJixdlgXzSYNSsoWi5XgGxU7w890891Qjj+SnQM9ft0t3Wbplp+Cl
         YRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684174484; x=1686766484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOKorS2J4RYeRLpH2nZdhlw6zsIATdNqLobWtCvJD3c=;
        b=KPiLKaPMCqShAkVRniRwEeX53tY3q7+/aD6uedYVJq3XNYl/SblmG8+gGwHX4Pr4JJ
         iMz8DoJzUSK37otC0ujqr7BzBuGbG+fQvfEcX+led2u6dVTa16ZgRT3ThfKjOCuxwXDK
         O6BQnQCPV7UH+ZzyrjNvDr/XPrO4KWRJwDi8YxFc3mZE1IdQxvFlqw/xbLC9FODD4HNx
         bIn/CxM7psuzjmRO1qnSpOohPEk5Tmr4963FbZFKepTg7kiPSNuIP3iPlZdTwk2ohDJr
         SsKBHEQijGDTX7r5nlB3Y4BOlDqzVGQL/3U5FsbCsqYkCDI6bsiQikDeBfBfyTjxalJ7
         qmcw==
X-Gm-Message-State: AC+VfDwmFa2mwmFrHW0QB0xatxiCF1xnKdL1SO0FWe+iIQgODgfbnmQK
	jJ/t7T3d9FNZLGcseyNxKrO8KFtIta6ymDeI0Dm+xA==
X-Google-Smtp-Source: ACHHUZ61bSyFE689iTPi5t1L/hhfohsO49e6+ZdfQiMJj132LmBFGhlB75QCHHUgGdiWeKVMyUsIiD/J9fqaXUlrhww=
X-Received: by 2002:a05:600c:3547:b0:3f4:1dce:3047 with SMTP id
 i7-20020a05600c354700b003f41dce3047mr6981wmq.2.1684174484515; Mon, 15 May
 2023 11:14:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684166247.git.asml.silence@gmail.com> <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
In-Reply-To: <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 May 2023 20:14:32 +0200
Message-ID: <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf refcounting
To: David Ahern <dsahern@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 7:29=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 40f591f7fce1..3d18e295bb2f 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >       if ((flags & MSG_ZEROCOPY) && size) {
> >               if (msg->msg_ubuf) {
> >                       uarg =3D msg->msg_ubuf;
> > -                     net_zcopy_get(uarg);
> >                       zc =3D sk->sk_route_caps & NETIF_F_SG;
> >               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
> >                       skb =3D tcp_write_queue_tail(sk);
> > @@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >               tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
> >       }
> >  out_nopush:
> > -     net_zcopy_put(uarg);
> > +     /* msg->msg_ubuf is pinned by the caller so we don't take extra r=
efs */
> > +     if (uarg && !msg->msg_ubuf)
> > +             net_zcopy_put(uarg);
> >       return copied + copied_syn;
> >
> >  do_error:
> > @@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >       if (copied + copied_syn)
> >               goto out;
> >  out_err:
> > -     net_zcopy_put_abort(uarg, true);
> > +     /* msg->msg_ubuf is pinned by the caller so we don't take extra r=
efs */
> > +     if (uarg && !msg->msg_ubuf)
> > +             net_zcopy_put_abort(uarg, true);
> >       err =3D sk_stream_error(sk, flags, err);
> >       /* make sure we wake any epoll edge trigger waiter */
> >       if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err =3D=3D -EA=
GAIN)) {
>
> Both net_zcopy_put_abort and net_zcopy_put have an `if (uarg)` check.

Right, but here this might avoid a read of msg->msg_ubuf, which might
be more expensive to fetch.

Compiler will probably remove the second test (uarg) from net_zcopy_put()

Reviewed-by: Eric Dumazet <edumazet@google.com>

