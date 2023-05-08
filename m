Return-Path: <netdev+bounces-917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B510F6FB5F3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 551A3281061
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C4B6101;
	Mon,  8 May 2023 17:31:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800220F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:31:25 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829C35BBA
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:31:24 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f38824a025so275871cf.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 10:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683567083; x=1686159083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjQoY/dFGBGaBjurV9YmQlxqkdm9+wrPFk0Rm84lESI=;
        b=v2m4W2RJ6DoAmrY0w1B7ktvBtYve36K7Or4x2m4u/Kkjbk1RkRpFkVBY2nPp9qEX/b
         T7WkiLiIwesuqyWJ9XKxi7+p0k9ZZutWJIldINtRoTP545rZc/z00XqYR1G9I5lnaSwr
         eL1A0Azhka6BTLGkdm4YwyXazRCk2W7aA+S/qNCIB6FCKHEMH2rYa4ItZgPVShBVP7q8
         drCyCfDRClWhLjJ19EytSvwVl+l8NNYDWX9cGyc89E7Uoyf24xY2BcYMiFIcyZqzncmx
         aqFCzT+W/qXSOs/t2x1/03sesNSwlSvmiTs2vWT4qtFQm7z3Uwc3NtNGCF7FaI+iMN8F
         L6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683567083; x=1686159083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjQoY/dFGBGaBjurV9YmQlxqkdm9+wrPFk0Rm84lESI=;
        b=OYdtb2iW3RKV4MpzznSvb1Bte7hjA8T3wP042hIb9FrWfRkQQQruWXCmRigL/WFaaN
         qYn5HLer6lANCaO1Idew8HVYvKudMXOZKo1Z3RJ4oMJdJv657GZm+NxUFQGEcnyxfvEU
         +3ZSdvgiMsp0SUdmVX90Jp4jVRMYjMgy5hMDzYdp4KdOjVCF9/4Se0Odyu62mzZJ1ibt
         +QCXS3pXqSdWQhVWuZ7VIlae0LGnCJKsM7M5jBN2TyOvmiXggZsN3W77ZAskt48pmQt6
         i8qUONAE1EjxQA8C4TB6zgW91cROn/3RXYyTBhukFLSapekaDUEo/gMNQL2QRCwC8Df1
         VJ6A==
X-Gm-Message-State: AC+VfDxAFSmoXDtuuooEU4bNSdKOvkQB6JEjtBSMAzHkD9qRjZLelTRE
	2ccbv/2hFPMR8cMPoryNYkpQKwIRpf/ROu0RumR5Rr3EJRGyibD4HvPc/w==
X-Google-Smtp-Source: ACHHUZ5tUTRubsNQ5XfY479PRTR7h6yF34lF+gKqFUAmeOa5iUW754XDSSfWyRuEv+H5OKQ6nswYesfFEIYxftq+drs=
X-Received: by 2002:ac8:5b15:0:b0:3f2:939:e125 with SMTP id
 m21-20020ac85b15000000b003f20939e125mr638476qtw.12.1683567083367; Mon, 08 May
 2023 10:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89i+JJ3747u5B89XMzxHQXgHiiXmftGZd2LV-ejJ3-g68CQ@mail.gmail.com>
 <20230508172016.49942-1-kuniyu@amazon.com>
In-Reply-To: <20230508172016.49942-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 May 2023 19:31:12 +0200
Message-ID: <CANn89iJAZ+OYVebm-x4pJgjYTdj8RiXc8iLnQC8X6JC3RUywuA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: Fix sk->sk_stamp race in sock_recv_cmsgs().
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 7:20=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 8 May 2023 19:08:58 +0200
> > On Mon, May 8, 2023 at 6:58=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon=
.com> wrote:
> > >
> > > KCSAN found a data race in sock_recv_cmsgs() [0] where the read acces=
s
> > > to sk->sk_stamp needs READ_ONCE().
> > >
> > > Also, there is another race like below.  If the torn load of the high
> > > 32-bits precedes WRITE_ONCE(sk, skb->tstamp) and later the written
> > > lower 32-bits happens to match with SK_DEFAULT_STAMP, the final resul=
t
> > > of sk->sk_stamp could be 0.
> > >
> > >   sock_recv_cmsgs()  ioctl(SIOCGSTAMP)      sock_recv_cmsgs()
> > >   |                  |                      |
> > >   |- if (sock_flag(sk, SOCK_TIMESTAMP))     |
> > >   |                  |                      |
> > >   |                  `- sock_set_flag(sk, SOCK_TIMESTAMP)
> > >   |                                         |
> > >   |                                          `- if (sock_flag(sk, SOC=
K_TIMESTAMP))
> > >   `- if (sk->sk_stamp =3D=3D SK_DEFAULT_STAMP)      `- sock_write_tim=
estamp(sk, skb->tstamp)
> > >       `- sock_write_timestamp(sk, 0)
> > >
> > > Even with READ_ONCE(), we could get the same result if READ_ONCE() pr=
ecedes
> > > WRITE_ONCE() because the SK_DEFAULT_STAMP check and WRITE_ONCE(sk_sta=
mp, 0)
> > > are not atomic.
> > >
> > > Let's avoid the race by cmpxchg() on 64-bits architecture or seqlock =
on
> > > 32-bits machines.
> > >
> >
> > I disagree. Please use WRITE_ONCE(), even if we know it is racy on 32bi=
t.
> >
> > sock_read_timestamp() and sock_write_timestamp() already are racy, and
> > we do not care.
>
> I think it's not racy since commit 3a0ed3e96197 ("sock: Make sock->sk_sta=
mp
> thread-safe"), which introduced seqlock in sock_read_timestamp() and
> sock_write_timestamp().

Please note I do not care of 32bit.

It is definitely racy on 64bit.

Please look at

commit f75359f3ac855940c5718af10ba089b8977bf339
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Nov 4 21:38:43 2019 -0800

    net: prevent load/store tearing on sk->sk_stamp


We can not use cmpxchg() only in one place and not the others.

cmpxchg() is expensive, we do not want it here on our fast path.

Thanks.

