Return-Path: <netdev+bounces-4921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB1870F2CB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA84C281245
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF540C8C3;
	Wed, 24 May 2023 09:31:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A04C2F0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:31:16 +0000 (UTC)
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332097
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:31:15 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-394440f483fso21928b6e.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684920674; x=1687512674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uf99Uy+0c+4BQsmOOBb+vJ9dhas3yxhHs2DZnOp4VCA=;
        b=eXSB6WsPwairggrDaS8CyDr544YSEc7WoDikOa+M3eNUKNlEbo6bhpq6JWJLp/Wi2c
         FXEcOWPeGAoijUrxaaPPBN6ZLbL38HC/nc4pAYiZRZW346603hN6i7abPFE3Mthl9Win
         PiSivb2tQg+sQfBwbSVT4pQgWOTNC5NYA8Kd0qLjUCKkrBoURiWuJdkd5kzE4EbosMEh
         OwqHV1K9nv3ubp7UjmtXx/vEpiQwl1j5VfrwDi+FNwY5ty8o8WPgYOC+3k8RLNSE69Pk
         5r4VOck7bAa/KSZNKBqTMIeW8Xflou99+kW+WXJYVQfchZRRjP/ZEDG8wUdU4S49vjPP
         gWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684920674; x=1687512674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uf99Uy+0c+4BQsmOOBb+vJ9dhas3yxhHs2DZnOp4VCA=;
        b=XYQeVrNTE9w3fbnzwOliXYwp4hgvN2IxtTmhkaXWQyz2Wwf7Mmnnsg9QtqEpWuuCYb
         5lCSC+D/HfybmFBUBHNSVudjNb4lTATWbokrAzyw/bE5Itjg3GkuHuOROhGRUCztJ7EQ
         ovh5PsayoGFG2XJhanBgqM9CpZgEeb20/xOHtfOTPeJSkg5cBUUrapkVmtKI2qJMofYG
         2MoC17AniYJ0tNk+ar+nv0JaVrCPr9gSxPYMI2JGNLUFyS/t3OB6sRbPgijUD90QNMG9
         V5BWDfJ8h19eAm1WVLZmIS64deOJvTMsdpuYjhbbdhgrMfctoIuggk4wBEmy4aSxHMEA
         o23Q==
X-Gm-Message-State: AC+VfDxTSl8nP3nqHVFgQ1cBuFE7YEXd/7Y03Chxy7SaUYw4xNgfapTu
	0bLMrg9GCAFeowbhX/7vW8NZjoykZYX/V1VZr1U=
X-Google-Smtp-Source: ACHHUZ5SbkJ+Vicj46xeNZ/Nw2yUct5tVOlpvhIO+XkRiOl9cZw2T4GMTJDL6nDthInE3Ea+LRUlk9fhcJOY5MU5h9Q=
X-Received: by 2002:a54:478b:0:b0:398:450f:fb95 with SMTP id
 o11-20020a54478b000000b00398450ffb95mr1175712oic.0.1684920674285; Wed, 24 May
 2023 02:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <20230519080118.25539-1-cambda@linux.alibaba.com> <f55cd2026c6cc01e19f2248ef4ed27b7b8ad11e1.camel@redhat.com>
 <CANn89iJmsM1YH01MsuDovn2LAKTQopOBjg6LNP8Uy_jOJh1+5Q@mail.gmail.com> <14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com>
In-Reply-To: <14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 24 May 2023 17:30:38 +0800
Message-ID: <CAL+tcoDi-=WAjyoM9n01JjYBj_p5_yrOMBJW4M_SCYFw9YGimg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 3:10=E2=80=AFPM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
> After I did a deep search about the TCP_MAXSEG, I found this is a bit
> more complicated than I think before.
>
> I don't know whether the TCP_MAXSEG is from BSD or not, but if the
> "UNIX Network Programming" is right, getting TCP_MAXSEG returns default
> MSS before connecting is as expect, that's what FreeBSD does. If we
> simply remove the !val check for it, getting TCP_MAXSEG will return zero
> before connecting, because tp->rx_opt.user_mss is initialized with zero
> on Linux, while tp->t_maxseg is initialized with default MSS on FreeBSD.
>
> I googled to see how it's used by developers now, and I think getting
> TCP_MAXSEG should return default MSS if before connecting and user_mss
> not set, for backward compatibility.
>
> But the !val check is a bug also, and the problem is not discovered for
> the first time.
> https://stackoverflow.com/questions/25996741/why-getsockopt-does-not-retu=
rn-the-expected-value-for-tcp-maxseg
>
> I think it should be:
>
> - if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> + if (tp->rx_opt.user_mss && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LI=
STEN)))

Good catch, It makes sense to me. With this modification, it could
prevent getsockopt returning zero with TCP_MAXSEG flag when the socket
stays in the close/listen state.

Thanks,
Jason

>
> With this change, getting TCP_MAXSEG will return default MSS as book
> described, and return user_mss if user_mss is set and before connecting.
> The tp->t_maxseg will only decrease on FreeBSD and we don't. I think
> our solution is better.
>
> I'll send a new patch later.
>
>
> Regards,
> Cambda

