Return-Path: <netdev+bounces-12148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B877736695
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155EC1C20B64
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC56BE68;
	Tue, 20 Jun 2023 08:46:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0042F848A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:46:32 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451D2E72
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:46:31 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f9d619103dso514221cf.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687250790; x=1689842790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpMN46255pLt0PRsCdWTS+xfZSx8+DsL9WPhOXxZ9yk=;
        b=PUqQz1EyhdM75s0SWzyaBzQzX0HnVw8z2tsr6Op5/cN/cUW4/9lVAm4tjUratYJjg6
         SAa1qHvWrjcDlnMecddAd8WdeBu5dKN6auGzZvp0P3LIZh1iETIFzdrWTUvD2wJE77qs
         2mLe8avFtMO/Ojubc766CY+rkfUD6VLkkeJ2sAPs9vMP+Iwa80zNJWBCR80BFGoGUkhi
         Fel8EfzQOxpGz9H+TJM8B0dV0ED1LULnMJPqQjmOoK+IbKR6NSdoy6B1QGfJ8QBASrbb
         VSrGJh6JuDJhShsGdLPxvy8QD+vwPBIL/1kPhfa45ywAyoSQiWFdkEBIbwP21rucqh1B
         nmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687250790; x=1689842790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WpMN46255pLt0PRsCdWTS+xfZSx8+DsL9WPhOXxZ9yk=;
        b=g5hZ7RC4VbTo34n7fcj28FEhsHmu4sQdtEuAEspOjXMgMp3iCvXiTELQp3VsoKxF0w
         pACtO/T/wrLL+sQd78xgC+dTy7HisMbAYc+U0fLuYr2Xm0mf+VAY+re1QacuF5MDWKCn
         pXMenBNCVWuKRdmLIyfxYIUpljR/yIeBZaxqTr/qvbXZIH6eyOhMHKMu8NAca+0MYyW7
         yxNhJQe364tZFlyeW1zIgbSLfQzNwt3+iWuOfvdfHgaWAGZkAr8I1pkg3RhDPVgkuaqT
         AaL0hH1VmaLsqavQKifL8crWmlQq9QVv5hSUY2KlRfbKykYZR4o+SRDyJi6KR1QB9wY2
         3v2w==
X-Gm-Message-State: AC+VfDypEIWmGfbiAhLNplfG1c1LJ/tFpxfdrAwhfiFkzaGfi+6eriM/
	Th3N36TeCLLjkCJgmp65dtx1+vU6o04HGg8n7I8qPHmUNoc48ibsBMA=
X-Google-Smtp-Source: ACHHUZ7c7mEXwzWWmZ4Mt+o83/SYAZ8LwUtMYoMBccyXZedPSaPV4i/RlxgZcYvPYMXK14Xt5u73mUccGJ/IHDfsjYE=
X-Received: by 2002:ac8:5c4d:0:b0:3f9:ab2c:88b9 with SMTP id
 j13-20020ac85c4d000000b003f9ab2c88b9mr1096161qtj.25.1687250790235; Tue, 20
 Jun 2023 01:46:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230619082547.73929-1-wuyun.abel@bytedance.com>
 <CANn89i+deprQWB0dmsUD1sRmy1VQCQwKnZUkLu_AEGV=ow=PKQ@mail.gmail.com> <6ed78c81-c1ac-dba4-059c-12f6b2bb9c53@bytedance.com>
In-Reply-To: <6ed78c81-c1ac-dba4-059c-12f6b2bb9c53@bytedance.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 20 Jun 2023 10:46:19 +0200
Message-ID: <CANn89iK4hme4XmUyZVjTXMZYqAm8w+9tbwnrtHyJ3N28cAFYTw@mail.gmail.com>
Subject: Re: Re: [PATCH net-next] inet: Save one atomic op if no memcg to charge
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 5:04=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com> =
wrote:
>
> On 6/19/23 6:08 PM, Eric Dumazet wrote:
> > On Mon, Jun 19, 2023 at 10:26=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.=
com> wrote:
> >>
> >> If there is no net-memcg associated with the sock, don't bother
> >> calculating its memory usage for charge.
> >>
> >> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> >> ---
> >>   net/ipv4/inet_connection_sock.c | 18 +++++++++++-------
> >>   1 file changed, 11 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connectio=
n_sock.c
> >> index 65ad4251f6fd..73798282c1ef 100644
> >> --- a/net/ipv4/inet_connection_sock.c
> >> +++ b/net/ipv4/inet_connection_sock.c
> >> @@ -706,20 +706,24 @@ struct sock *inet_csk_accept(struct sock *sk, in=
t flags, int *err, bool kern)
> >>   out:
> >>          release_sock(sk);
> >>          if (newsk && mem_cgroup_sockets_enabled) {
> >> -               int amt;
> >> +               int amt =3D 0;
> >>
> >>                  /* atomically get the memory usage, set and charge th=
e
> >>                   * newsk->sk_memcg.
> >>                   */
> >>                  lock_sock(newsk);
> >>
> >> -               /* The socket has not been accepted yet, no need to lo=
ok at
> >> -                * newsk->sk_wmem_queued.
> >> -                */
> >> -               amt =3D sk_mem_pages(newsk->sk_forward_alloc +
> >> -                                  atomic_read(&newsk->sk_rmem_alloc))=
;
> >>                  mem_cgroup_sk_alloc(newsk);
> >> -               if (newsk->sk_memcg && amt)
> >> +               if (newsk->sk_memcg) {
> >> +                       /* The socket has not been accepted yet, no ne=
ed
> >> +                        * to look at newsk->sk_wmem_queued.
> >> +                        */
> >> +                       amt =3D sk_mem_pages(newsk->sk_forward_alloc +
> >> +                                          atomic_read(&newsk->sk_rmem=
_alloc));
> >> +
> >> +               }
> >> +
> >> +               if (amt)
> >>                          mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
> >>                                                  GFP_KERNEL | __GFP_NO=
FAIL);
> >
> > This looks correct, but claiming reading an atomic_t is an 'atomic op'
> > is a bit exaggerated.
>
> Yeah, shall I change subject to 'inet: Skip usage calculation if no
> memcg to charge'? Or do you have any suggestions?

I would call this a cleanup or refactoring, maybe...

