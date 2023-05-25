Return-Path: <netdev+bounces-5390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B5B71105F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 237232815B7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633F61B901;
	Thu, 25 May 2023 16:06:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5390C19E7F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:06:39 +0000 (UTC)
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07659139;
	Thu, 25 May 2023 09:06:38 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id 71dfb90a1353d-457201c47f6so230433e0c.1;
        Thu, 25 May 2023 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685030797; x=1687622797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTQjVZFJMl2htBgjAjUwo8aIlAxuNE/XuYEOm2kKnTQ=;
        b=XpMqAQAAxJalriEaDTX546Y/3brDNZIWDjllLOtGdZ7RkhNk0iDJMFGbcoiYE6ieYZ
         OKbMRGJKkXsz52ZJsnrkB0arczm7svC2EFp1RcvgEotx1Z93Q61OJx7DZVmaPGM3YQtp
         hxiBZNxEGAbXpapu8Do2eXZS1+Qh2dnBP4tKJE8QQOKRVlKKQ93DOh9ddqv9hgjuJ+0W
         pLqZkoCvJndyvUREwF3Bg4mERq9hUyGWH1H1bds5TPn7OWeEfufc6rkFFDv9WG/hfYdf
         N1TZBXzmAUeEuOkQfjB8LhsRul6QvLIQNRc1yH8cWz64lW9+3KXRyzs7lMsC2sHI7evQ
         2ukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685030797; x=1687622797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTQjVZFJMl2htBgjAjUwo8aIlAxuNE/XuYEOm2kKnTQ=;
        b=LozfSw+IeMTVbWShXmqjGLOEX7cdk+7+bc0jnI4yaoXumDt9sQxj7qXRbr+p8xLZTK
         pN/aVh3GIi+Hyg4RLmlmqFwN/ZioywE6L9IY4+KEF2RiWmQUKPN6eOM4+r59/GGWZcO7
         SLZykQNPefk5wCxa/nbbH2KCya4SEIFQjsjfwJ4NANMiXwBUwCQZG8Nav3bna2xuP/nS
         J1eqwZM5JRDmw9nC4Xmpus7b3/HjZlvbyPrTrde3DkEbRCXXAI5TNRfaBnfeq9PgdOgw
         OT6kgTWKRvop+nubE2OY0DgjTiJ+A85yk0hufbxRr4yZrpB5dc+gyNp5djxVPrj5VZdg
         uEdA==
X-Gm-Message-State: AC+VfDy+RTp0P4dRQcSGBUFceWr5FntID12LIDF9SQ7WXyp7o2Wez9eI
	hsuwZIYLUs+MCEUrsiFtyV+Zcp/jL2HgXNvDUlo=
X-Google-Smtp-Source: ACHHUZ53VhbedOtIoTjgfxe0fR2ZQYEQ+cMOtRhvGEegt7oEKztTJNywr/nJj5wpHjemDNWOECt7zc4J8aDNTRKxLs0=
X-Received: by 2002:a67:e30b:0:b0:439:5b03:5a2 with SMTP id
 j11-20020a67e30b000000b004395b0305a2mr3248739vsf.30.1685030797019; Thu, 25
 May 2023 09:06:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525125503.400797-1-leitao@debian.org> <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
 <a1074987-c3ce-56cd-3005-beb5a3c55ef9@kernel.org>
In-Reply-To: <a1074987-c3ce-56cd-3005-beb5a3c55ef9@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 25 May 2023 12:06:00 -0400
Message-ID: <CAF=yD-LXcufhJBpkEcUuphFpR1TA4=QwUXw4sKFsSiEL_mwG4Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
To: David Ahern <dsahern@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Remi Denis-Courmont <courmisch@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Matthieu Baerts <matthieu.baerts@tessares.net>, 
	Mat Martineau <martineau@kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk, asml.silence@gmail.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dccp@vger.kernel.org, 
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:34=E2=80=AFAM David Ahern <dsahern@kernel.org> w=
rote:
>
> On 5/25/23 9:05 AM, Willem de Bruijn wrote:
> >> +/* A wrapper around sock ioctls, which copies the data from userspace
> >> + * (depending on the protocol/ioctl), and copies back the result to u=
serspace.
> >> + * The main motivation for this function is to pass kernel memory to =
the
> >> + * protocol ioctl callbacks, instead of userspace memory.
> >> + */
> >> +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> >> +{
> >> +       int rc =3D 1;
> >> +
> >> +       if (ipmr_is_sk(sk))
> >> +               rc =3D ipmr_sk_ioctl(sk, cmd, arg);
> >> +       else if (ip6mr_is_sk(sk))
> >> +               rc =3D ip6mr_sk_ioctl(sk, cmd, arg);
> >> +       else if (phonet_is_sk(sk))
> >> +               rc =3D phonet_sk_ioctl(sk, cmd, arg);
> >
> > I don't understand what this buys us vs testing the sk_family,
> > sk_protocol and cmd here.
>
> To keep protocol specific code out of core files is the reason I
> suggested it.

I guess you object to demultiplexing based on per-family
protocol and ioctl cmd constants directly in this file?

That only requires including the smaller uapi headers.

But now net/core/sock.h now still has to add includes
linux/mroute.h, linux/mroute6.h and net/phonet/phonet.h.

Aside on phonet_is_sk, if we're keeping this: this should be
sk_is_phonet? Analogous to sk_is_tcp and such. And, it should suffice
to  demultiplex based on the protocol family, without testing the
type or protocol. The family is defined in protocol-independent header
linux/socket.h. The differences between
PN_PROTO_PHONET and PN_PROTO_PIPE should be handled inside the family
code. So I think it is cleaner just to open-coded as `if
(sk->sk_family =3D=3D PF_PHONET)`

