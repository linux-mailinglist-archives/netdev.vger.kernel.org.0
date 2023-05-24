Return-Path: <netdev+bounces-4938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF4070F486
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1CE11C20BEA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DD0C15C;
	Wed, 24 May 2023 10:48:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B741FB1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:48:16 +0000 (UTC)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBFE1A8;
	Wed, 24 May 2023 03:48:03 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-561f10b6139so7345777b3.2;
        Wed, 24 May 2023 03:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684925283; x=1687517283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnWIVHFoNbsQTI/EkqM6iBpWOcV5CSw3JS4i0UJMOqA=;
        b=gCIXS72YrHlzIeOO6bfhahYysz0R+nKKEVwaB7pVFp1Y4OBEw5KXwXXH+X1HnUUhP/
         JxgdLKsWHzt+MUzT7wSVFk1x/bdH2Xn81aJVPlW+0HickVg98davDmwyJPnos/2AKuUz
         8tkhHBtoGQl0kaJCAEDcoy5NbwlThbJnfT2HbAwUaA6nlj111GF5Zk+MUvtIn0xeyq9O
         r3KoGLoDb22GpWBPc6XSat5v3o02KeQCA8zkrug83WJY/SZeoohNTqQBEJNGMQ52i+gh
         vhSIq4GQrDa4II22N0AP3C9Akp427mCylGXKhhYWg2UvglG9r7Lus4be4FQUvzomqAYT
         TlJw==
X-Gm-Message-State: AC+VfDzq6hoF2oqU9/JetA4mVauUbIqI2r2jQTyv598GbnmdC9dSlqlc
	piNTKRsFkZeVqWAW09qtbThyT5UnVPI16A==
X-Google-Smtp-Source: ACHHUZ7XM7Y5p15ds3axmbh3RNuqUrz/Md0p+ksEKg0Wt7Cli5FfL3qJtQqaju5PnUgDLitlhj7OUQ==
X-Received: by 2002:a81:6c43:0:b0:561:a7fd:4fe4 with SMTP id h64-20020a816c43000000b00561a7fd4fe4mr18794588ywc.28.1684925282680;
        Wed, 24 May 2023 03:48:02 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id x11-20020a817c0b000000b0055a4fe11ce0sm1485796ywc.130.2023.05.24.03.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 03:48:01 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-563b1e5f701so7313997b3.3;
        Wed, 24 May 2023 03:48:01 -0700 (PDT)
X-Received: by 2002:a81:9245:0:b0:561:beec:89d3 with SMTP id
 j66-20020a819245000000b00561beec89d3mr20362339ywg.6.1684925281318; Wed, 24
 May 2023 03:48:01 -0700 (PDT)
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
In-Reply-To: <CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
From: Luca Boccassi <bluca@debian.org>
Date: Wed, 24 May 2023 11:47:50 +0100
X-Gmail-Original-Message-ID: <CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
Message-ID: <CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Christian Brauner <brauner@kernel.org>, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 24 May 2023 at 11:43, Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> On Tue, May 23, 2023 at 11:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> >
> > On Tue, 23 May 2023 11:44:01 +0100 Luca Boccassi wrote:
> > > > I really would like to avoid that because it will just mean that so=
meone
> > > > else will abuse that function and then make an argument why we shou=
ld
> > > > export the other function.
> > > >
> > > > I think it would be ok if we required that unix support is built in
> > > > because it's not unprecedented either and we're not breaking anythi=
ng.
> > > > Bpf has the same requirement:
> > > >
> > > >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
> > > >   struct bpf_unix_iter_state {
> > > >           struct seq_net_private p;
> > > >           unsigned int cur_sk;
> > > >           unsigned int end_sk;
> > > >           unsigned int max_sk;
> > > >           struct sock **batch;
> > > >           bool st_bucket_done;
> > > >   };
> > > >
> > > > and
> > > >
> > > >   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && def=
ined(CONFIG_PROC_FS)
> > > >   DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
> > > >                        struct unix_sock *unix_sk, uid_t uid)
> >
> > Don't think we should bring BPF into arguments about uAPI consistency :=
S
> >
> > > Some data points: Debian, Ubuntu, Fedora, RHEL, CentOS, Archlinux all
> > > ship with CONFIG_UNIX=3Dy, so a missing SCM_PIDFD in unlikely to have=
 a
> > > widespread impact, and if it does, it might encourage someone to
> > > review their kconfig.
> >
> > IDK how you can argue that everyone sets UNIX to =3Dy so hiding SCM_PID=
FD
> > is fine and at the same time not be okay with making UNIX a bool :S
> >
> > > As mentioned on the v5 thread, we are waiting for this API to get the
> > > userspace side sorted (systemd/dbus/dbus-broker/polkit), so I'd be
> > > really grateful if we could start with the simplest and most
> > > conservative approach (which seems to be the current one in v6 to me)=
,
> > > and then eventually later decide whether to export more functions, or
> > > to deprecate CONFIG_UNIX=3Dm, or something else entirely, as that
> > > doesn't really affect the shape of the UAPI, just the details of its
> > > availability. Thank you.
> >
> > Just throw in a patch to make UNIX a bool and stop arguing then.
>
> Dear Jakub,
>
> Thanks for your attention to these patch series!
>
> I'm ready to prepare/send a patch to make CONFIG_UNIX bool.
>
> I will send SO_PEERPIDFD as an independent patch too, because it
> doesn't require this change with CONFIG_UNIX
> and we can avoid waiting until CONFIG_UNIX change will be merged.
> I've a feeling that the discussion around making CONFIG_UNIX  to be a
> boolean won't be easy and fast ;-)

Thank you, that sounds great to me, I can start using SO_PEERPIDFD
independently of SCM_PIDFD, there's no hard dependency between the
two.

Kind regards,
Luca Boccassi

