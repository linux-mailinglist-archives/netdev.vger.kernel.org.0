Return-Path: <netdev+bounces-4937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DE270F473
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F61F1C20C22
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E490C147;
	Wed, 24 May 2023 10:43:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1953D63
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:43:54 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E63A3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:43:51 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 568AB41AE6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684925028;
	bh=VcR2dM9dZkrtIAYuc+uEYt6q6RFFCfHdSpmFwxj+wQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=ICYhzP3alsOukQOEQWvvrws87UFBIOwILO305wzr8xWUwsG1L4ZC9c0oKite3wrPL
	 EseAWN1gLDwCqoX3G1/6Z8nMAfkDgMAPmA4HdaANqOUc7IlhRJsf+ZlnL3qXx8dKOT
	 9IuEpcRvvkymZJigK9A5WSkegXUrLgYF0YGQhSvn+RVQEMhmipANGe1WOoLhiOo6qK
	 HFnthkYPVbRSjYMocf5lqIbMy1ST66igp5lJXNyT2z7xUfmFcdb1jQOOI2VqKbahpi
	 rKzNsvbY31qL/+0z+2KTWUfYO+UFEU45GTtC6mykSut3tXiSaJ/0Rqcwj/bh/+nW0d
	 4mYdjt8HJCEYA==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5655d99d636so18132617b3.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684925027; x=1687517027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VcR2dM9dZkrtIAYuc+uEYt6q6RFFCfHdSpmFwxj+wQM=;
        b=CaxGoWwnxBEX/NDwDJAFumzivY+hVMNBwEgzhZJG95cWuI4YZGJQYz6zhYdvEbFHPM
         SENU+ybTZ8wAaHHv70EXeJOk/PXgtS/OiZQPh42sR3WVcooztis/Zlfy9xmivhxDBrEJ
         7wM3C3BKBU5HO4PZwOlVVTYRbFqSz5n5dnf7V2+NbMVijQk2XibW2edfM/Y4KIb+KQD9
         wy2g9zrYVv9wXeCyo4/n88gUEibmVHBY0gNKfRQyZVWhEekDJryKe4zVac/JULL2z/VC
         yS5GkovbiphNq6LIzf1NvpvBvhAYgl0fcwGod647WmnM8EPxyB2vX29kyga6K1DiiBR6
         R6ww==
X-Gm-Message-State: AC+VfDyzxxoZSSIyD84ZzzOALFr9xuudqI+FXVxCLlSuXXOeYZ0v+NWp
	GG9JCT+ZrA4DxOq8sPkhy2LfpBf2a3jVP9vDYRAYFtYHei78nCbG0TOP3jwydnZj0p7mipRbrN3
	4hFkd5ifx819pLaXqTU5njqsP7DbAP0kAs345bwT5Kb1bbRiEGg==
X-Received: by 2002:a81:ab50:0:b0:561:179b:1276 with SMTP id d16-20020a81ab50000000b00561179b1276mr16277648ywk.26.1684925027357;
        Wed, 24 May 2023 03:43:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4iOk/L3sMlt+J6yeXjbzBVkYzcNAS9i5TiiFe4XzBVBtPC3NhYAtD5clOw6pJbtiOOIbVSK/C8SNjWhkpcZOY=
X-Received: by 2002:a81:ab50:0:b0:561:179b:1276 with SMTP id
 d16-20020a81ab50000000b00561179b1276mr16277633ywk.26.1684925027137; Wed, 24
 May 2023 03:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
 <20230522133409.5c6e839a@kernel.org> <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
 <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com> <20230523140844.5895d645@kernel.org>
In-Reply-To: <20230523140844.5895d645@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 24 May 2023 12:43:36 +0200
Message-ID: <CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Jakub Kicinski <kuba@kernel.org>
Cc: Luca Boccassi <bluca@debian.org>, Christian Brauner <brauner@kernel.org>, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 11:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Tue, 23 May 2023 11:44:01 +0100 Luca Boccassi wrote:
> > > I really would like to avoid that because it will just mean that some=
one
> > > else will abuse that function and then make an argument why we should
> > > export the other function.
> > >
> > > I think it would be ok if we required that unix support is built in
> > > because it's not unprecedented either and we're not breaking anything=
.
> > > Bpf has the same requirement:
> > >
> > >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
> > >   struct bpf_unix_iter_state {
> > >           struct seq_net_private p;
> > >           unsigned int cur_sk;
> > >           unsigned int end_sk;
> > >           unsigned int max_sk;
> > >           struct sock **batch;
> > >           bool st_bucket_done;
> > >   };
> > >
> > > and
> > >
> > >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defin=
ed(CONFIG_PROC_FS)
> > >   DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
> > >                        struct unix_sock *unix_sk, uid_t uid)
>
> Don't think we should bring BPF into arguments about uAPI consistency :S
>
> > Some data points: Debian, Ubuntu, Fedora, RHEL, CentOS, Archlinux all
> > ship with CONFIG_UNIX=3Dy, so a missing SCM_PIDFD in unlikely to have a
> > widespread impact, and if it does, it might encourage someone to
> > review their kconfig.
>
> IDK how you can argue that everyone sets UNIX to =3Dy so hiding SCM_PIDFD
> is fine and at the same time not be okay with making UNIX a bool :S
>
> > As mentioned on the v5 thread, we are waiting for this API to get the
> > userspace side sorted (systemd/dbus/dbus-broker/polkit), so I'd be
> > really grateful if we could start with the simplest and most
> > conservative approach (which seems to be the current one in v6 to me),
> > and then eventually later decide whether to export more functions, or
> > to deprecate CONFIG_UNIX=3Dm, or something else entirely, as that
> > doesn't really affect the shape of the UAPI, just the details of its
> > availability. Thank you.
>
> Just throw in a patch to make UNIX a bool and stop arguing then.

Dear Jakub,

Thanks for your attention to these patch series!

I'm ready to prepare/send a patch to make CONFIG_UNIX bool.

I will send SO_PEERPIDFD as an independent patch too, because it
doesn't require this change with CONFIG_UNIX
and we can avoid waiting until CONFIG_UNIX change will be merged.
I've a feeling that the discussion around making CONFIG_UNIX  to be a
boolean won't be easy and fast ;-)

Kind regards,
Alex

