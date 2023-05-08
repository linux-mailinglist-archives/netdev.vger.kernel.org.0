Return-Path: <netdev+bounces-913-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE5A6FB5B7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DA061C20A13
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08660566D;
	Mon,  8 May 2023 17:09:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AC320F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:09:12 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38FB83
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:09:11 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f38a9918d1so248201cf.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683565750; x=1686157750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJgxX+h3++wZi3lWbn/rInw5fVkCX1ZVU9ajUWRyhkw=;
        b=6DN+m+WO+uoH73ARo4DohfKEHVYLbFqvcFePiLtz+6nq3sIwOd9xDlBJ0f50mf51kp
         QfxyC1DEcDFpk2vWWoo928Wbg6OWwLAjAkw/8aOyDIUTYKY/Qw8CDwgEDn6u+fqXP/YT
         WTND3LiYJXtXdeGgtOa5I5HtlrWR+FCiPrI2ajPSOHK7V/DUlSTP3GXNZtvyioybFpcr
         jNOg1ycMMz6WaO5kEz/NbNawDnKGJgQ6zDIvZIS2ReEgNBmAxJeCx5LxB82Wo3eX+qTB
         APbantl90DcYl3wBf5rYTtN4EdzWVO7HGvQZDF7DIDII4IppXS2If5Q+xBMRRRKKHSse
         iE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683565750; x=1686157750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJgxX+h3++wZi3lWbn/rInw5fVkCX1ZVU9ajUWRyhkw=;
        b=eOrMteRbMWslZOoPI3jyBUlrHZ/dw0wMN9APric2qeVuFRDYcgEdRmVjM4szVdjulN
         W8ow8GLSj4b2hKKvUO/Uoobh4pMV6BZ5HkG7WR21ZAxWHCK8hGcnX1DuKryIlbYu6cN0
         1rKzpUSw6jJS9LFWt1bfl+lKy23mnCm1EBwxS8h8SYyRqAupzUxIRcH+GBSw4g5VUGNY
         DW5e5LK+27U7qFWd0sxj8GH0qN735WnOD0etI9KYXOLrNbQTAVQYpW54JNtNG0+/B+w3
         eCDvNwwoHV1mrbbIqXtENrzgfI/vrqYWFqQuw3qXzKT8xGAlk3aCySOnMvAfppcpRjA1
         fWtg==
X-Gm-Message-State: AC+VfDy/U3Rs0R2L3OMU2rzCfqIERKcFO8tkNbjtDvWylbA5EAV4rLuD
	5M19nfHw8WtCHeDR0NtK7KDZMbsSiGlK5ebO88IL+g==
X-Google-Smtp-Source: ACHHUZ6ygMSmrfA7OtjFHHluQv1/9xro6DcHig7GQCsrrZLdEkHKn/MW04elooI3FoMBM5Rx4gF5pXB2hNf2D+J/oGs=
X-Received: by 2002:a05:622a:1488:b0:3ef:5008:336f with SMTP id
 t8-20020a05622a148800b003ef5008336fmr579604qtx.1.1683565750409; Mon, 08 May
 2023 10:09:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508165815.45602-1-kuniyu@amazon.com>
In-Reply-To: <20230508165815.45602-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 May 2023 19:08:58 +0200
Message-ID: <CANn89i+JJ3747u5B89XMzxHQXgHiiXmftGZd2LV-ejJ3-g68CQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 6:58=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> KCSAN found a data race in sock_recv_cmsgs() [0] where the read access
> to sk->sk_stamp needs READ_ONCE().
>
> Also, there is another race like below.  If the torn load of the high
> 32-bits precedes WRITE_ONCE(sk, skb->tstamp) and later the written
> lower 32-bits happens to match with SK_DEFAULT_STAMP, the final result
> of sk->sk_stamp could be 0.
>
>   sock_recv_cmsgs()  ioctl(SIOCGSTAMP)      sock_recv_cmsgs()
>   |                  |                      |
>   |- if (sock_flag(sk, SOCK_TIMESTAMP))     |
>   |                  |                      |
>   |                  `- sock_set_flag(sk, SOCK_TIMESTAMP)
>   |                                         |
>   |                                          `- if (sock_flag(sk, SOCK_TI=
MESTAMP))
>   `- if (sk->sk_stamp =3D=3D SK_DEFAULT_STAMP)      `- sock_write_timesta=
mp(sk, skb->tstamp)
>       `- sock_write_timestamp(sk, 0)
>
> Even with READ_ONCE(), we could get the same result if READ_ONCE() preced=
es
> WRITE_ONCE() because the SK_DEFAULT_STAMP check and WRITE_ONCE(sk_stamp, =
0)
> are not atomic.
>
> Let's avoid the race by cmpxchg() on 64-bits architecture or seqlock on
> 32-bits machines.
>

I disagree. Please use WRITE_ONCE(), even if we know it is racy on 32bit.

sock_read_timestamp() and sock_write_timestamp() already are racy, and
we do not care.

