Return-Path: <netdev+bounces-6526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA65716CB2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7021A1C20D26
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85FC206A6;
	Tue, 30 May 2023 18:43:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE06B168CC;
	Tue, 30 May 2023 18:43:25 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB6410C7;
	Tue, 30 May 2023 11:43:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b010338d82so32312455ad.0;
        Tue, 30 May 2023 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685472198; x=1688064198;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upIp0zEWi+BYJyjJ5QSBflYLzTOlUQKKExuiyIfaXBI=;
        b=JLK7/OrZfrDyVHXlZQf5DTunB8EbgnkyvksbLah4FSFHCUnPIJJOzKbwYpfDaHi6SZ
         JG+crwgc2u8U6szazUpam7LxscVyNMiwEfDW4zP0wvuTQS7/5wQWEHpPuMfKaHtsYybZ
         qfjjhJHuhKVUp51uAScSttNcCuObFli1wSIM4vpr+KoNnizlPwaPxBVAPade8GxDxtq2
         qCFAPmXHUHVbckFsD01mhKFQV/at7x5w79xEOrGn+YUgIpQV59kNxaCia+t1v+fpkv2f
         GjyIHPlPMKWxrVnR3lEWtpwEDfD6vFK9nZ7fzHHeF9JDhcnMCg9xSmxsp5RsJcfg+3UK
         ttFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685472198; x=1688064198;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=upIp0zEWi+BYJyjJ5QSBflYLzTOlUQKKExuiyIfaXBI=;
        b=b8ClhI9CZF8nOEZ4JQ3c3WhIIzffkOMV0vm6aXTjTrjDzylj8Yrg1T6QbRhkLAO5dj
         tCDvKT5tlHhbY5ZhvIUHRWVOirNZivpfowXGS8emUyCueOVE0+OdJmm58omxE3p7RyvK
         N9x5Uduo7WkSVZE07+2TWxrn+zA/ywl0qPNWJVs/TdDvb0sMvi6ByQSsT5UQX+2J/Uu8
         +Sn8yXfqUGl2rq/craYHTCMIoo+FN7eif63z3WTXbvEkf9G87ujq802lmfPiySJqB61f
         5IJKpMNIfRQBwEafsOuItCXFGQ49fRy6eWexUPDI+P7KMxgHlvbXKBW5q0iJ19RzCVQ0
         Fgbw==
X-Gm-Message-State: AC+VfDw1/820IH+d3GpJGyCKIO26Y/+ljDiAt+/rS9d43IAteQAfud5w
	aFDOfiCcNryTItNxczAcoYA=
X-Google-Smtp-Source: ACHHUZ6ziLAreITwvZ+EvPpwD/S7wIIEnF1bLRq0HttyoxJ5xUdsQ2T8e6XratAQsi7oxkWyo4GQeg==
X-Received: by 2002:a17:902:6b05:b0:1b0:5e0f:16a5 with SMTP id o5-20020a1709026b0500b001b05e0f16a5mr2336213plk.11.1685472198565;
        Tue, 30 May 2023 11:43:18 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:88bf:3da6:e71a:c5dc])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001a6cd1e4205sm10598862plj.279.2023.05.30.11.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 11:43:18 -0700 (PDT)
Date: Tue, 30 May 2023 11:43:16 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: John Fastabend <john.fastabend@gmail.com>, 
 Eric Dumazet <edumazet@google.com>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: jakub@cloudflare.com, 
 daniel@iogearbox.net, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 ast@kernel.org, 
 andrii@kernel.org, 
 will@isovalent.com
Message-ID: <647643c4dc379_15101208bf@john.notmuch>
In-Reply-To: <647641b8e9f3c_13ff820831@john.notmuch>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-8-john.fastabend@gmail.com>
 <CANn89iLNWH2=LvNdfyhBFCte5ZTsws13YBE4N263nzVStxccdQ@mail.gmail.com>
 <647641b8e9f3c_13ff820831@john.notmuch>
Subject: Re: [PATCH bpf v10 07/14] bpf: sockmap, wake up polling after data
 copy
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

John Fastabend wrote:
> Eric Dumazet wrote:
> > On Tue, May 23, 2023 at 4:56=E2=80=AFAM John Fastabend <john.fastaben=
d@gmail.com> wrote:
> > >
> > > When TCP stack has data ready to read sk_data_ready() is called. So=
ckmap
> > > overwrites this with its own handler to call into BPF verdict progr=
am.
> > > But, the original TCP socket had sock_def_readable that would addit=
ionally
> > > wake up any user space waiters with sk_wake_async().
> > >
> > > Sockmap saved the callback when the socket was created so call the =
saved
> > > data ready callback and then we can wake up any epoll() logic waiti=
ng
> > > on the read.
> > >
> > > Note we call on 'copied >=3D 0' to account for returning 0 when a F=
IN is
> > > received because we need to wake up user for this as well so they
> > > can do the recvmsg() -> 0 and detect the shutdown.
> > >
> > > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > > Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> > >  net/core/skmsg.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > > index bcd45a99a3db..08be5f409fb8 100644
> > > --- a/net/core/skmsg.c
> > > +++ b/net/core/skmsg.c
> > > @@ -1199,12 +1199,21 @@ static int sk_psock_verdict_recv(struct soc=
k *sk, struct sk_buff *skb)
> > >  static void sk_psock_verdict_data_ready(struct sock *sk)
> > >  {
> > >         struct socket *sock =3D sk->sk_socket;
> > > +       int copied;
> > >
> > >         trace_sk_data_ready(sk);
> > >
> > >         if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
> > >                 return;
> > > -       sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > > +       copied =3D sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > > +       if (copied >=3D 0) {
> > > +               struct sk_psock *psock;
> > > +
> > > +               rcu_read_lock();
> > > +               psock =3D sk_psock(sk);
> > > +               psock->saved_data_ready(sk);
> > > +               rcu_read_unlock();
> > > +       }
> > >  }
> > >
> > >  void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psoc=
k)
> > > --
> > > 2.33.0
> > >
> > =

> > It seems psock could be NULL here, right ?
> > =

> > What do you think if I submit the following fix ?
> > =

> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index a9060e1f0e4378fa47cfd375b4729b5b0a9f54ec..a29508e1ff3568583263b=
9307f7b1a0e814ba76d
> > 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -1210,7 +1210,8 @@ static void sk_psock_verdict_data_ready(struct =
sock *sk)
> > =

> >                 rcu_read_lock();
> >                 psock =3D sk_psock(sk);
> > -               psock->saved_data_ready(sk);
> > +               if (psock)
> > +                       psock->saved_data_ready(sk);
> >                 rcu_read_unlock();
> >         }
> >  }
> =

> Yes please do presumably this is plausible if user delete map entry whi=
le
> data is being sent and we get a race. We don't have any tests for this
> in our CI though because we never delete socks after adding them and
> rely on the sock close. This shouldn't happen in that path because of t=
he
> data_ready is blocked on SOCK_DEAD flag iirc.
> =

> I'll think if we can add some stress test to add map update/delete in
> a tight loop with live socket sending/receiving traffic.
> =

> Thanks

I can also submit it if its easier just let me know.

