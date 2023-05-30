Return-Path: <netdev+bounces-6524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CE4716C97
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E798F1C20D3B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F2E200AD;
	Tue, 30 May 2023 18:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5E19924;
	Tue, 30 May 2023 18:34:39 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B5114;
	Tue, 30 May 2023 11:34:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso3640948b3a.1;
        Tue, 30 May 2023 11:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685471675; x=1688063675;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=me6VDNZKEhfsqugbjChbSuflMiKzd93kWd1fL/twBRI=;
        b=X9ZG3SXM/2LSUb0V4VLPCOMfpvFpUuVODM/kyQeERFk28Fix+8JR3ziOE858ZKcOns
         mkG968p6NhoiD4EAy7F8fBotjVj+mlX8CAefPb+C4ddPWpHrOXDQE2zNNol1B7SGJrjY
         hpaoges3mB1tYcGQa6hMj0Rms6RrtW/fM6sbfTpwXCczJXwTjxqxAV+JOHQLvMcRmcm7
         AfrXbXNfHwQxPj7TY7k7h8y3y5fYfKFwAqy9JL9ADw/sCOsobybP+tgV5GornIm9zDYr
         GFFcfkyAytQ+4T4a5HChHr1EH2DG3aWcFo3IACdKgtOyPRaBx+a7TkaIRNSjIW+XNvx7
         Nbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471675; x=1688063675;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=me6VDNZKEhfsqugbjChbSuflMiKzd93kWd1fL/twBRI=;
        b=SZmHAu1spACTDdZ35m+O3pSAGJTU23b9Pli7qKr58nCIhirbl1nX1hkjfp6p2JZnnT
         ZZYkaFLoGeRDdiWDF/SyTZEsoHF+uostQcBvzMS4Gk7EgWVcyvMXI562UwwBZQvVXLy2
         hKW+ERnDlDyLIwnF2YZpBr5u0+EPMjNA+EQxpskICiaDJg4GOZ3rSxlEE0rXgv2HHRFM
         BDIl6Mu2aZJJrgAwTtKed/+PI9ag0suONBG2Hz6co1p3ntHk6xO7Glm5u220JHbm7alM
         Ml+YdpZSISAdoVjNgQ4ae2YBn9oQRVLY6Aeu+6LcmReymbjo4VRFVq17htEABkvSz3mU
         5BCw==
X-Gm-Message-State: AC+VfDwUV9quiKkmq0CiXgi95Rf0OTWjAbf7B1+f6AGVUr4IDR5wNu3B
	rxzkA2r8LwQXc5rkbQHzKXM=
X-Google-Smtp-Source: ACHHUZ7Ck1alp7+ud9TRNpQUiCjDBDwQmxReTo0HJ+3Qxh03dkPAWdQI/MV3qkXYPrj/GKT1Y8C1tQ==
X-Received: by 2002:a05:6a20:3d1f:b0:10a:b885:cea6 with SMTP id y31-20020a056a203d1f00b0010ab885cea6mr3322614pzi.16.1685471675001;
        Tue, 30 May 2023 11:34:35 -0700 (PDT)
Received: from localhost ([2605:59c8:148:ba10:88bf:3da6:e71a:c5dc])
        by smtp.gmail.com with ESMTPSA id s11-20020a63e80b000000b0051b460fd90fsm9110443pgh.8.2023.05.30.11.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 11:34:34 -0700 (PDT)
Date: Tue, 30 May 2023 11:34:32 -0700
From: John Fastabend <john.fastabend@gmail.com>
To: Eric Dumazet <edumazet@google.com>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: jakub@cloudflare.com, 
 daniel@iogearbox.net, 
 bpf@vger.kernel.org, 
 netdev@vger.kernel.org, 
 ast@kernel.org, 
 andrii@kernel.org, 
 will@isovalent.com
Message-ID: <647641b8e9f3c_13ff820831@john.notmuch>
In-Reply-To: <CANn89iLNWH2=LvNdfyhBFCte5ZTsws13YBE4N263nzVStxccdQ@mail.gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-8-john.fastabend@gmail.com>
 <CANn89iLNWH2=LvNdfyhBFCte5ZTsws13YBE4N263nzVStxccdQ@mail.gmail.com>
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

Eric Dumazet wrote:
> On Tue, May 23, 2023 at 4:56=E2=80=AFAM John Fastabend <john.fastabend@=
gmail.com> wrote:
> >
> > When TCP stack has data ready to read sk_data_ready() is called. Sock=
map
> > overwrites this with its own handler to call into BPF verdict program=
.
> > But, the original TCP socket had sock_def_readable that would additio=
nally
> > wake up any user space waiters with sk_wake_async().
> >
> > Sockmap saved the callback when the socket was created so call the sa=
ved
> > data ready callback and then we can wake up any epoll() logic waiting=

> > on the read.
> >
> > Note we call on 'copied >=3D 0' to account for returning 0 when a FIN=
 is
> > received because we need to wake up user for this as well so they
> > can do the recvmsg() -> 0 and detect the shutdown.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index bcd45a99a3db..08be5f409fb8 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -1199,12 +1199,21 @@ static int sk_psock_verdict_recv(struct sock =
*sk, struct sk_buff *skb)
> >  static void sk_psock_verdict_data_ready(struct sock *sk)
> >  {
> >         struct socket *sock =3D sk->sk_socket;
> > +       int copied;
> >
> >         trace_sk_data_ready(sk);
> >
> >         if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
> >                 return;
> > -       sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > +       copied =3D sock->ops->read_skb(sk, sk_psock_verdict_recv);
> > +       if (copied >=3D 0) {
> > +               struct sk_psock *psock;
> > +
> > +               rcu_read_lock();
> > +               psock =3D sk_psock(sk);
> > +               psock->saved_data_ready(sk);
> > +               rcu_read_unlock();
> > +       }
> >  }
> >
> >  void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)=

> > --
> > 2.33.0
> >
> =

> It seems psock could be NULL here, right ?
> =

> What do you think if I submit the following fix ?
> =

> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index a9060e1f0e4378fa47cfd375b4729b5b0a9f54ec..a29508e1ff3568583263b93=
07f7b1a0e814ba76d
> 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -1210,7 +1210,8 @@ static void sk_psock_verdict_data_ready(struct so=
ck *sk)
> =

>                 rcu_read_lock();
>                 psock =3D sk_psock(sk);
> -               psock->saved_data_ready(sk);
> +               if (psock)
> +                       psock->saved_data_ready(sk);
>                 rcu_read_unlock();
>         }
>  }

Yes please do presumably this is plausible if user delete map entry while=

data is being sent and we get a race. We don't have any tests for this
in our CI though because we never delete socks after adding them and
rely on the sock close. This shouldn't happen in that path because of the=

data_ready is blocked on SOCK_DEAD flag iirc.

I'll think if we can add some stress test to add map update/delete in
a tight loop with live socket sending/receiving traffic.

Thanks=

