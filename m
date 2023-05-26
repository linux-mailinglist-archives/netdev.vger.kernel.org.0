Return-Path: <netdev+bounces-5765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AFD712AF9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B2C81C210FA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F106027732;
	Fri, 26 May 2023 16:47:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52262CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:47:51 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF1DD3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:47:50 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso1665e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685119669; x=1687711669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgH2Cdrwxvw4IfwvJTzYeY7KIodASo/zB54J71C8SXg=;
        b=kFmq4/Ubiomw+bSsqMt5jQCtPHuEgbhKdix+7oMl8jygp6e/xbdU1rHaWGp6XxzdFZ
         eJyu4fpze/watbsoKe0EVFrHthAqk+FzLOywBlLBCK0ha9s7esYXtkSb36CewsJlO/gH
         U0V2hQ26/1rnlmQp/Y86IHBxkv55Op0K74qXQ3beUTDGGF9NiS68oRIOvg24+kjl6mZU
         pVXo53O392GyUDGU2GL+ZLpQ/z0IPKATdTRrt8M9ErhzbA2K57x2ioir4gm9fojNd1iQ
         CedzWO/QzZNftE2cgMKMstgBGdQ3c0e4fBxqdD4kFobF30kjuBI9SUBRsZE9B/utpJlH
         bt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685119669; x=1687711669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgH2Cdrwxvw4IfwvJTzYeY7KIodASo/zB54J71C8SXg=;
        b=jyL79d9g/N8p1RIlGJxoNNeOE5tF2QHvU5PGbaGICqWez0e5cYDKYCs/QU5+H7ryR7
         OE61rDDTgAUMV1AME8AGrAogdF9Lbqs/tOWdn/KVsnprLBppl+60ZE0xxSYOrcvuKAvV
         rf5W/+SnHAXGFoPoOkLIIN1e5Rm/x5sQl3VDevmtSOYwH3UqD9esyPz2QyULHNHaMqpx
         knGa+J8yBntserJhio3RVx+Fe2hpdqdSRetG2mnWDQYNYSR79fo1VeUCXaLF3nAvcYok
         9GmO8HwpkJl1CfBvrEEO6hGlav3bhDqfjJcRPZHrscW600/mv/EOFHdKzMQ8qqSvLnBr
         kI5w==
X-Gm-Message-State: AC+VfDyGSEzxGvCAKhx+hT+XQFtjmLMpvlch46ie7LZmtkXah9XUbSls
	tgBHTHweA5q3OU4a5xZn9q2kmFrhdAbaAbFg2Sqm2Q==
X-Google-Smtp-Source: ACHHUZ7/0H65ZD/H44M1y+JBCNzkWKJ3dgQZ+8Lbr2uPV0C4C5HK5fM5ucCTSf8USInqYp++NXhtlDOSXY2HHA4TS2g=
X-Received: by 2002:a05:600c:539b:b0:3f4:df95:17e0 with SMTP id
 hg27-20020a05600c539b00b003f4df9517e0mr118254wmb.5.1685119668896; Fri, 26 May
 2023 09:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526150806.1457828-1-VEfanov@ispras.ru> <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
 <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru> <CANn89iLGOVwW-KHBuJ94E+QoVARWw5EBKyfh0mPkOT+5ws31Fw@mail.gmail.com>
 <d3fccbd0-c92e-9aff-8c32-48c1171746c3@ispras.ru>
In-Reply-To: <d3fccbd0-c92e-9aff-8c32-48c1171746c3@ispras.ru>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 18:47:36 +0200
Message-ID: <CANn89i+UYRXD16epov9x7+Zr5vCKL+DTCidsOaQdMBjWMmK8CA@mail.gmail.com>
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
To: Vlad Efanov <vefanov@ispras.ru>
Cc: Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 6:41=E2=80=AFPM Vlad Efanov <vefanov@ispras.ru> wro=
te:
>
> sk_dst_set() is called by sk_setup_caps().
>
> sk_dst_set() replaces dst in socket using xchg() call and we still have
> two tasks use one socket but expect different dst in sk_dst_cache.
>
>
> __sk_dst_set() is rcu protected, but it checks for socket lock.
>
>
> static inline void
> __sk_dst_set(struct sock *sk, struct dst_entry *dst)
> {
>      struct dst_entry *old_dst;
>
>      sk_tx_queue_clear(sk);
>      sk->sk_dst_pending_confirm =3D 0;
>      old_dst =3D rcu_dereference_protected(sk->sk_dst_cache,
>                          lockdep_sock_is_held(sk));
>      rcu_assign_pointer(sk->sk_dst_cache, dst);
>      dst_release(old_dst);
> }

I am quite familiar with this code.

What are you trying to say exactly ?

Please come with a V2 without grabbing the socket lock.

