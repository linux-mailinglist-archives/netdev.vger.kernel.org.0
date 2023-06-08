Return-Path: <netdev+bounces-9362-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEBF728971
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 775C42812AE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7B4209A3;
	Thu,  8 Jun 2023 20:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A191DCBF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:30:02 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B209430C5
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:29:29 -0700 (PDT)
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CF9843F36C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686256147;
	bh=qREPRnbFoZDSkGcbr3ixpo6NMxfZ+kQ8GXlQeYCh42M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=Htu1rTcgCJMupUbMIPAxKJSnF+9Yt/X34k0Ym4wrXFPF+UtR0NEQURwtHAwtelFbF
	 1OfyNLo1U7xdIuoEcCt3EQuxy6UABjTMBq2tSqQ6MU57QFi5y1e8ZGUb7J+i5fOowy
	 P0YxTYEJt4Yu3FmuORL9EEngbNjckwJzWEmGtflH8xJloZd9piTwHLqoQKE0lewy9X
	 vnahNcmYXnGBcxc//iMNE/1FJFOHJXoqSf5NbSNo+WCKZkHAa3BJ2RoXGA506bjsmb
	 fJ45dmwh6rkirFQvqf/C94OsuxRFNQZFhDylcItyYD/li7e8PupwxIPAsGEgduTPmw
	 oq+DcpeT7udHQ==
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3922d2460afso81874b6e.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 13:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686256146; x=1688848146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qREPRnbFoZDSkGcbr3ixpo6NMxfZ+kQ8GXlQeYCh42M=;
        b=a9V/V5Ngyvf495ySvq7Jmt6knkfCQLKk8rEuxdmt91ihqdn6nMNJel1y4CZoc5UGsk
         B5Ugue8OkNec+qu3PMOtYDQWW0gC2/MFQ+hfFEoV4JJPR6yz14K000gIt+RjYqqfgyEu
         +hf6hw26EbRVRjlYguDLMbIgej2bPssYnfvBlRmafduWXyKy+pnt6tDIeZXmb2mrHbsV
         GdKschi6Ra5OhSkxHACwaAucexYwCIEJEGNSz0OaVM8B82rRib1Id1yu0jsdQloIqKUA
         FZ4vsIL0lEgB9f+9OlGujtyzmPjSAOsblhLe/3l03GE/xQ0uM0T2pUSE1FXg2w22oYeh
         ntMg==
X-Gm-Message-State: AC+VfDwtY+g4SONlEFf4+1Is8OL04hZWpTBt5hIrhZB0mSQOPKlQwRM1
	BbARnB8/XsVtJCUhTNswfeZJdV4AyArXniDFzO5Auyh7s+F5j45qpUfm6AMbAEcaYr9t7tWpqGA
	0v1kCQvpzKITZgxFT7wNcHI8IabTlBr1mUYEWWsnXwVcLwDX8DA==
X-Received: by 2002:a05:6808:1382:b0:39c:9433:97ad with SMTP id c2-20020a056808138200b0039c943397admr595871oiw.36.1686256146043;
        Thu, 08 Jun 2023 13:29:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ72K6gWbgyk1dbG1psn5iv219LzIs2MMeLeVtQcb1DQ4+7XfA+UeHix9z/VOcUqfx86K9lSQiK1HTQioy3qmrc=
X-Received: by 2002:a05:6808:1382:b0:39c:9433:97ad with SMTP id
 c2-20020a056808138200b0039c943397admr595861oiw.36.1686256145821; Thu, 08 Jun
 2023 13:29:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
 <20230522133409.5c6e839a@kernel.org> <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
 <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
 <20230523140844.5895d645@kernel.org> <CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
 <CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
 <20230524081933.44dc8bea@kernel.org> <CAEivzxcTEghPqk=9hQMReSGzE=ruWnJyiuPhW5rGd7eUOEg12A@mail.gmail.com>
 <20230604110211.3f6401c6@kernel.org> <CAEivzxeVeuFW+ADJFO-kCBtyn345nTX=T3aKTdwWY01JgsLPQg@mail.gmail.com>
In-Reply-To: <CAEivzxeVeuFW+ADJFO-kCBtyn345nTX=T3aKTdwWY01JgsLPQg@mail.gmail.com>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Thu, 8 Jun 2023 22:28:54 +0200
Message-ID: <CAEivzxfpih_5ES-pC=jdH4D8H2KN4qJqngC35Ce9KNUnjT2ddg@mail.gmail.com>
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

On Sun, Jun 4, 2023 at 8:07=E2=80=AFPM Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> On Sun, Jun 4, 2023 at 8:02=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >
> > On Wed, 24 May 2023 17:45:25 +0200 Aleksandr Mikhalitsyn wrote:
> > > > How about you put the UNIX -> bool patch at the end of the series,
> > > > (making it a 4 patch series) and if there's a discussion about it
> > > > I'll just skip it and apply the first 3 patches?
> > >
> > > Sure, I will do that!
> >
> > Hi Aleksandr! Did you disappear? Have I missed v7?
>
> Dear Jakub,
>
> of course I'm not, I've just got distracted with other things last
> week. Will send -v7 this week!
> Thanks for paying attention to the series ;-)
>
> Kind regards,
> Alex

Dear Jakub,

I've sent -v7:
https://lore.kernel.org/all/20230608202628.837772-1-aleksandr.mikhalitsyn@c=
anonical.com/

Kind regards,
Alex

