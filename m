Return-Path: <netdev+bounces-6527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1AB716CD0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DC8F1C209E2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993AF20992;
	Tue, 30 May 2023 18:51:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F1817FE5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:51:44 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7F8106
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:51:40 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso13215e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685472699; x=1688064699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfcaQqLv1zYdIvq3YIyO/trBflJe8VuRf7FQypIS0A0=;
        b=y8EAZUQrKE+gHmlHfkoMJgf4ioDw3COw5LAYdaA+mKdA2Yx8G7TzQvfwHOfjs1NuTV
         k8K2PweKu9Z/CXK+zi2chdkvemnSEbBfwiDKMYNOmQUBxHBgcQhuddhHBX5T+zU4+87C
         x3EXkIOdxtASoKI4pukkR9ZAisL+H+F147ehSckOoA8Kkz0x00svvf6W24K1oACRr08s
         IpaIKr68dWpn7d7pGUJ85TpAb0nG3YwsNdyuC45ZyzGGtpay/tyWv4BjbyjugeQtrQlg
         ns9xKTP2VI1O/24m17PbVMr0wLK9M5JAatsTT1zHNxJ/N8Chrl1xX4ctWZ6MXbHZI/44
         s6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685472699; x=1688064699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfcaQqLv1zYdIvq3YIyO/trBflJe8VuRf7FQypIS0A0=;
        b=LGa/0snxka23cL8OxAk5VQRTlIHJk6KVu+XqOr4MOclA8Y5k1DnxfwUqIG0yFcMBkJ
         Rkc4zZWKjSPxDszpEXGO6YaYuYoh1hzgDJDTrPX/7G2JI9w2gN0GXWKD0AmJ07NCNqnz
         YZkU8r2KU17PdEBNAgXhcL9Ixsq2vESjfhAPbrWEOZ+JQ1CqXdm4NAZdN8GqXTz4ROSU
         75Za2jVGzJioK6FHRSncAGazkBgUg/91v68Tey5JLLkHz3+fW3lQdRqs6eCVUSUIjFt4
         IPgCQeW1VIMWmWYhsmoQfAMeGjlnxacJuBW7ugXnFACU9UgJ4KsBle6jKRgklwbCzD6p
         hSAw==
X-Gm-Message-State: AC+VfDxHUMivLvGYHME3neOtgomfcO48ghhLASU46GQ0pon6hTOEH66E
	CC7WP/iPu3MMaHN/5/oKEXIudhT1UObjjH3y72pilQ==
X-Google-Smtp-Source: ACHHUZ50X8Dw5dNyu4ojcs/WkGFLgA/3MxQwJq5nhQHi3vllssEhnqRfR7HJ0uYsunB2/PzS4tqUG1U1fAYHC+c8bkk=
X-Received: by 2002:a05:600c:4fce:b0:3f3:3855:c5d8 with SMTP id
 o14-20020a05600c4fce00b003f33855c5d8mr6461wmq.6.1685472698944; Tue, 30 May
 2023 11:51:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-8-john.fastabend@gmail.com> <CANn89iLNWH2=LvNdfyhBFCte5ZTsws13YBE4N263nzVStxccdQ@mail.gmail.com>
 <647641b8e9f3c_13ff820831@john.notmuch> <647643c4dc379_15101208bf@john.notmuch>
In-Reply-To: <647643c4dc379_15101208bf@john.notmuch>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 20:51:27 +0200
Message-ID: <CANn89i+1KBp9_8zktqfFrCK0xpqGOhnXbTy-A79n0_YBGWM7kQ@mail.gmail.com>
Subject: Re: [PATCH bpf v10 07/14] bpf: sockmap, wake up polling after data copy
To: John Fastabend <john.fastabend@gmail.com>
Cc: jakub@cloudflare.com, daniel@iogearbox.net, bpf@vger.kernel.org, 
	netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org, will@isovalent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 8:43=E2=80=AFPM John Fastabend <john.fastabend@gmai=
l.com> wrote:
>
> John Fastabend wrote:
> > Eric Dumazet wrote:
> > > On Tue, May 23, 2023 at 4:56=E2=80=AFAM John Fastabend <john.fastaben=
d@gmail.com> wrote:
> > > >
> > > > When TCP stack has data ready to read sk_data_ready() is called. So=
ckmap
> > > > overwrites this with its own handler to call into BPF verdict progr=
am.
> > > > But, the original TCP socket had sock_def_readable that would addit=
ionally
> > > > wake up any user space waiters with sk_wake_async().
> > > >
> > > > Sockmap saved the callback when the socket was created so call the =
saved
> > > > data ready callback and then we can wake up any epoll() logic waiti=
ng
> > > > on the read.
> > > >
> > > > Note we call on 'copied >=3D 0' to account for returning 0 when a F=
IN is
> > > > received because we need to wake up user for this as well so they
> > > > can do the recvmsg() -> 0 and detect the shutdown.
> > > >
> > > > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > > > Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > > ---
> > > >  net/core/skmsg.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > > > index bcd45a99a3db..08be5f409fb8 100644
> > > > --- a/net/core/skmsg.c
> > > > +++ b/net/core/skmsg.c
> > > > @@ -1199,12 +1199,21 @@ static int sk_psock_verdict_recv(struct soc=
k *sk, struct sk_buff *skb)
> > > >  static void sk_psock_verdict_data_ready(struct sock *sk)
> > > >  {
> > > >         struct socket *sock =3D sk->sk_socket;
> > > > +       int copied;
> > > >
> > > >         trace_sk_data_ready(sk);
> > > >
> > > >         if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
> > > >                 return;
> > > > -       sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > > > +       copied =3D sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > > > +       if (copied >=3D 0) {
> > > > +               struct sk_psock *psock;
> > > > +
> > > > +               rcu_read_lock();
> > > > +               psock =3D sk_psock(sk);
> > > > +               psock->saved_data_ready(sk);
> > > > +               rcu_read_unlock();
> > > > +       }
> > > >  }
> > > >
> > > >  void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psoc=
k)
> > > > --
> > > > 2.33.0
> > > >
> > >
> > > It seems psock could be NULL here, right ?
> > >
> > > What do you think if I submit the following fix ?
> > >
> > > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > > index a9060e1f0e4378fa47cfd375b4729b5b0a9f54ec..a29508e1ff3568583263b=
9307f7b1a0e814ba76d
> > > 100644
> > > --- a/net/core/skmsg.c
> > > +++ b/net/core/skmsg.c
> > > @@ -1210,7 +1210,8 @@ static void sk_psock_verdict_data_ready(struct =
sock *sk)
> > >
> > >                 rcu_read_lock();
> > >                 psock =3D sk_psock(sk);
> > > -               psock->saved_data_ready(sk);
> > > +               if (psock)
> > > +                       psock->saved_data_ready(sk);
> > >                 rcu_read_unlock();
> > >         }
> > >  }
> >
> > Yes please do presumably this is plausible if user delete map entry whi=
le
> > data is being sent and we get a race. We don't have any tests for this
> > in our CI though because we never delete socks after adding them and
> > rely on the sock close. This shouldn't happen in that path because of t=
he
> > data_ready is blocked on SOCK_DEAD flag iirc.
> >
> > I'll think if we can add some stress test to add map update/delete in
> > a tight loop with live socket sending/receiving traffic.
> >
> > Thanks
>
> I can also submit it if its easier just let me know.

 I will, this is based on a syzbot report I will also release,
thanks !

