Return-Path: <netdev+bounces-10054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C8A72BCC2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E12D281193
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81B317ADC;
	Mon, 12 Jun 2023 09:27:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6070156D3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:27:12 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA425B8C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:27:06 -0700 (PDT)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5D3F73F370
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686562025;
	bh=amvoj5+Gnj9e1Rhhe2pyCXjUM4LbjfgQaWycSbeLkIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=a6DzK9ENHXkiMDJvXQ7a6nVtMOuop/YY0NpAfthtroTPZJM+pxvkDHXLWeg6EtVfH
	 gUxbwkjiM2gOVrl/czbtsBKgbM4KIpubDyi4lGxwJjQownLygfuWkEtLOmWG6pMYjB
	 KvBDc5o2yHy8RsQp5qg7cFMBfMd00IEGDPqw4Gvp9KwAndlkr6Ml+WyJ6cm+m4r/5S
	 igCbZa62lP5B+atG+j/xke8zLguAPirk3PHNwZH+LaM3C56zYAI/eUGXzVe8PI4LQ8
	 nVrbLsLfNXjBj5E/Rhn4M5Fk7rjvjZrDnIfGyK/uxKZ8F8LxiaXTIW/aPqEiB5k06y
	 YIv0LCTtmHs1g==
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-568a85f180dso60502447b3.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562024; x=1689154024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amvoj5+Gnj9e1Rhhe2pyCXjUM4LbjfgQaWycSbeLkIw=;
        b=W5kS9iT/X6MJJPNa+N5Hc8qMr5TG7rtX7wOwZhZKlgREeBffpBIbx+DX2C/iFI3zft
         KJNYXA9PgvmYAaTXKGoKQju4j1N1O8JDI71EQ9Lf5Zw5AboRgy7R4drD13680wNAY9Qx
         fQjXHnMDIIILgln/j8e12axvNzeJulE0r5InsVeU/q8WnPCLo9RrmK6jPZBDTiX0mSwJ
         JZFZ+T17iBo/yxum+vve2XZ5p9W9RVQJ7pj9TUP4xHM6YJCpL9JOa0T/0bceuaRpLOKr
         BUPBu0bqyZPttJsCxuLXLz6Y95ecqL2TITTqPw7/tPObZlw0Jymgd37mvFqxFr16cJ7h
         X/wA==
X-Gm-Message-State: AC+VfDyIQ1gOteCpLrt9fE3zZ4HKs8JhbCxMg6Mr65Het/vZpHxhkrb1
	N1RiyKom0PYnqyR/Y/BrZUY51I9z9hH+7JlodPuFMFFUmNOOtUWS34j+27/+vMiVwJuo5er/00h
	Xdyym7fmlKpVEb7v12clj//n9fbXfSGykUkCfBcXd8+qwz12o0g==
X-Received: by 2002:a25:d009:0:b0:bc6:1cac:a4a with SMTP id h9-20020a25d009000000b00bc61cac0a4amr6005496ybg.3.1686562024334;
        Mon, 12 Jun 2023 02:27:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ72kRI/rhtDax/6I6nDQcgeRzwMCN8pOeJQ8my5S0dxky1/EzJyvjq2vW3t/PsJO5nRD4UTXPAOha2ZFie9248=
X-Received: by 2002:a25:d009:0:b0:bc6:1cac:a4a with SMTP id
 h9-20020a25d009000000b00bc61cac0a4amr6005476ybg.3.1686562024051; Mon, 12 Jun
 2023 02:27:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
 <20230608202628.837772-2-aleksandr.mikhalitsyn@canonical.com> <CANn89iLhQYHLxGYefhzVOxWx7BA_qk4uxuPjvZOGGnaJNESYXQ@mail.gmail.com>
In-Reply-To: <CANn89iLhQYHLxGYefhzVOxWx7BA_qk4uxuPjvZOGGnaJNESYXQ@mail.gmail.com>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Mon, 12 Jun 2023 11:26:53 +0200
Message-ID: <CAEivzxcreyGD=sB_OLDx+69U_+M5MQrJQZ71Rq4HyDS9cxNXQA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, 
	Christian Brauner <brauner@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:19=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Thu, Jun 8, 2023 at 10:26=E2=80=AFPM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTI=
ALS,
> > but it contains pidfd instead of plain pid, which allows programmers no=
t
> > to care about PID reuse problem.
> >
> > We mask SO_PASSPIDFD feature if CONFIG_UNIX is not builtin because
> > it depends on a pidfd_prepare() API which is not exported to the kernel
> > modules.
> >
> > Idea comes from UAPI kernel group:
> > https://uapi-group.org/kernel-features/
> >
> > Big thanks to Christian Brauner and Lennart Poettering for productive
> > discussions about this.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Cc: Luca Boccassi <bluca@debian.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Tested-by: Luca Boccassi <bluca@debian.org>
> > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks, Eric!

Kind regards,
Alex

