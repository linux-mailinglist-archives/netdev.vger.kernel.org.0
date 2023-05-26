Return-Path: <netdev+bounces-5658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BD67125A8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7672281706
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED4D742F8;
	Fri, 26 May 2023 11:36:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD363AD24
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:36:36 +0000 (UTC)
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C187B1BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:36:04 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-38ea3f8e413so385520b6e.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685100963; x=1687692963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFd41XKJrUfCj+2pjpJ2godOowFfIUzHbTpvmgGBs4o=;
        b=sAWKejYv0HGnNQN0xF/x2qrDPcEyrTvU2yaVK5aDBrGSpp9XHKeZ7fa5prH3QPY5nm
         mwjpxNXfyDpScXBWao4sJr2uHWoUP7jFAtggZLlFErVHFFDFLOKhPXA0O9uqQpsrmzAg
         /S4rD1UYMaZQ3f++ATBLjuUcPKUiahZiTt4rTpsW970GshLxGC4KWqbV1yqB6RURYfEY
         294c7M1j0Ol5c6oOXzNIusHcPK8o/8M3nuXOs9tG8h/zkbmF4oF6ebZtPIDu+eUC4D1n
         UTQG02x1W3ts5UYn35kGoKrGBJUZhjATBf3/f9NsYeBFMz63XcDDJ2wKCNqUmQCb/Fjh
         SPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685100963; x=1687692963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFd41XKJrUfCj+2pjpJ2godOowFfIUzHbTpvmgGBs4o=;
        b=I5J2v2VZUHznZHjHf+uFpu8V46gvMIN179WAgjfG31cwx+K4UWTXu+VJBE0Iipc4B0
         Ux1c7Okqop4BAxip1ZyNTBBDoXQ9VL6jHdL5iny36A9qDau3V1uqiwCB46CxB6Hbh11L
         CRXl4bllbpQndP7Y1gtLGzR2cnZdl0kvy6rUNgEWw0Ld46tywlkuIakMKlXobyQLrjvl
         dzYhhu+An60ZZgEnzlkrOTwNIRzS3be/sSwYHSbmwuboOg3Yh5/hXMXGjXRbFdK3nosQ
         MTUxf4Ux41U9QUf6tlifinXrjLtCID3GQCwuj/E5oFMUQNQiwfCsOKB+jgV1yX69q8Qe
         TlPQ==
X-Gm-Message-State: AC+VfDzkFAFzGt027Hw5FWJbw1eFEPCYrdgy/8HLc76BX8XJVHXq6Zth
	dJIzfyko1ogy8RR8qFjwX8yE8foy4iHnGJ6JE4eLfgwKicnySHvK
X-Google-Smtp-Source: ACHHUZ6/2KoIIJx+ckBpAy7rmKlPZp+spTzeIdjlD36oXb35W/bCwWLHzFdoFMxjTfSvyRlENrnKyFULsV3gi3lxDnk=
X-Received: by 2002:aca:1318:0:b0:396:20fd:7362 with SMTP id
 e24-20020aca1318000000b0039620fd7362mr670061oii.28.1685100963378; Fri, 26 May
 2023 04:36:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524131331.56664-1-cambda@linux.alibaba.com>
In-Reply-To: <20230524131331.56664-1-cambda@linux.alibaba.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Fri, 26 May 2023 19:35:27 +0800
Message-ID: <CAL+tcoD__dnnEJbJXDcV5JLnQK3XC_1Ww6trhur_DhWejLp1bg@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Dust Li <dust.li@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, 
	Jack Yang <mingliang@linux.alibaba.com>, David Miller <davem@davemloft.net>, dsahern@kernel.org, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 9:14=E2=80=AFPM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> it's zero is probably a bug.
>
> With this change, getting TCP_MAXSEG before connecting will return
> default MSS normally, and return user_mss if user_mss is set.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=
=3D3u+UyLBmGmifHA@mail.gmail.com/#t
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6=
@linux.alibaba.com/
> Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
> ---
> v2:
> - Update Fixes tag with commit in current tree.
> - Add Jason's Reviewed-by tag.
>
> v1:
> - Return default MSS if user_mss not set for backwards compatibility.
> - Send patch to net instead of net-next, with Fixes tag.
> - Add Eric's tags.
> ---
>  net/ipv4/tcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 4d6392c16b7a..3e01a58724b8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4081,7 +4081,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
>         switch (optname) {
>         case TCP_MAXSEG:
>                 val =3D tp->mss_cache;
> -               if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LIS=
TEN)))
> +               if (tp->rx_opt.user_mss &&
> +                   ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
>                         val =3D tp->rx_opt.user_mss;
>                 if (tp->repair)
>                         val =3D tp->rx_opt.mss_clamp;
> --
> 2.16.6
>

Ah, I just realised that you didn't CC other maintainers though
reading the patchwork. Please run this command [1] before you submit a
patch next time.

[1]: $./scripts/get_maintainer.pl net/ipv4/tcp.c

+CC kuba, davem, dsahern

Thanks,
Jason

