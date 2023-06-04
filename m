Return-Path: <netdev+bounces-7811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03780721920
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 20:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B1828119F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA7610965;
	Sun,  4 Jun 2023 18:07:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2662101FE
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:07:25 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03892B0
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 11:07:23 -0700 (PDT)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 330D13F43B
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1685902042;
	bh=eXPLCKZ8Jj450duZJrO5FmwhWWg+s1j3KuC7Lhd1iI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=UT+GSj6ZbTUtj0SZd4TFaqO7MhJn4MztOSWUZXe2Qsu7VkQJHhD+JGb2c3I73+yUE
	 9ZHrCaREQv4acw+vhpIWfXMagxGjsqEhVryW2YzC+n5gqHJ2UqwcGdpg9FWFRokwpV
	 8HxJ3daXWjWBIdhwNSsDf0+nT2ZfK5/kmAgo9VRr5BiQPdslscoLxEyWZ/XSn/z5B4
	 r0MZPXBUewPVcBHXs+mcVw8V4zes4gTQcJN0UzetByCswdsB+XxeXVe3en7Acjak31
	 NJMplBoYvL5yKYLpYd4bvy2TaPFu8cK+BZ3tSsJfapcKPRz06pbP6xlyDYgk/WCtM9
	 J6UD8FdVAPZ5w==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-561ceb5b584so69616697b3.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 11:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685902041; x=1688494041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eXPLCKZ8Jj450duZJrO5FmwhWWg+s1j3KuC7Lhd1iI4=;
        b=NJ7dZCsidyr/wZqR4Ri8dR/5ujekINeZt0qnhP/5eMgr9P+tvzBvRc0LCNBXCFsvCr
         3PtSX9jlxfwIa3Kao+rAAjGJ7h7SC059rQ1NeZDeK3K+hpslt9AOZ6Y8t+ZdlC5HN5KV
         VhH1+Vt42bPKlGTbFqLmTW2RWqv9dO28ZbTlWoL61CmzA8v6B+I/LmcSrhYoS0nbqj+v
         230Fr4v/ZkWdM9MsKS/Xzgc5M5DIgyCUgRxtbBHMIch/kLrj+tPGn83IoPF+KaQ1pmQm
         swY/oTbox1bzj8dzWsjyADyYT8kDFHRh+3f/D0ESm7a0c+69h144U+MvPUTVoiL8N0t3
         zHIg==
X-Gm-Message-State: AC+VfDwtoUpTdWBYo1oho6MziB8oBhDK+ZIJkWYlityvLIH8XEgMPSPa
	jdTfjCILNweADA15b1FaOJxH1YxYDShGQrrZSvbCRM5vEgTnH9VAi16GhwsjomkOj6f/SIld9P2
	DpakKm45DVovMsJL9eWncpI1f9a30m0j/LnRjrmpSzfz+/aXYww==
X-Received: by 2002:a25:210b:0:b0:b9d:7887:4423 with SMTP id h11-20020a25210b000000b00b9d78874423mr6768242ybh.16.1685902040981;
        Sun, 04 Jun 2023 11:07:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ41k0JQ0Rgb4oamIPtOl2YDqXm2k+gWqhdlPbfMaObYYGP+EpFNoMd2Xr14SJFNxI1Y9SMEiabdS0cOpOTA3WE=
X-Received: by 2002:a25:210b:0:b0:b9d:7887:4423 with SMTP id
 h11-20020a25210b000000b00b9d78874423mr6768237ybh.16.1685902040769; Sun, 04
 Jun 2023 11:07:20 -0700 (PDT)
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
 <20230604110211.3f6401c6@kernel.org>
In-Reply-To: <20230604110211.3f6401c6@kernel.org>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Sun, 4 Jun 2023 20:07:09 +0200
Message-ID: <CAEivzxeVeuFW+ADJFO-kCBtyn345nTX=T3aKTdwWY01JgsLPQg@mail.gmail.com>
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

On Sun, Jun 4, 2023 at 8:02=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 24 May 2023 17:45:25 +0200 Aleksandr Mikhalitsyn wrote:
> > > How about you put the UNIX -> bool patch at the end of the series,
> > > (making it a 4 patch series) and if there's a discussion about it
> > > I'll just skip it and apply the first 3 patches?
> >
> > Sure, I will do that!
>
> Hi Aleksandr! Did you disappear? Have I missed v7?

Dear Jakub,

of course I'm not, I've just got distracted with other things last
week. Will send -v7 this week!
Thanks for paying attention to the series ;-)

Kind regards,
Alex

