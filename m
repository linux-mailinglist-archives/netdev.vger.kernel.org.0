Return-Path: <netdev+bounces-4649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D33B970DAC5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77D461C20D24
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9609B4A846;
	Tue, 23 May 2023 10:44:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C0A4A842
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:44:21 +0000 (UTC)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9272C119;
	Tue, 23 May 2023 03:44:16 -0700 (PDT)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-562108900acso67007487b3.2;
        Tue, 23 May 2023 03:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684838655; x=1687430655;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wAGJ7K0eTZatSWk95P2dmmFxGdpx5RiAx15TGeRGBa0=;
        b=FMRb7F2wf/7W58fsIYB46aD0jdmmCDrPqyyaWOFxdwwRyqahxxaNCKzpT80e5SURNQ
         klZU5fa16Isidz8x3vNPWVPgy0mO34i1fxus7ZHgV8E1v42UGSA3VyqDFbOQA97WMdat
         azp3XfE8P3CwajWf4F/BMl30/6gT8Qn9IequFLjyqesnc3WKgDE42iAm0g53T47nTvQa
         sXKU0AiJmlncjP6apVbmtjHvjZvegPpWocJN+UQpdbWzjgwTDz20fQwAWO+BQ4nwqIzi
         qomjM3UqwG70pWAew5WjWaoifAmqskTQxSif76FmOWQ2Sm6A4cGvxOqX9gVdbcnTyAHK
         mWJQ==
X-Gm-Message-State: AC+VfDxFFTC+Zyo2pxtR1h0TQvItSUiSpVzuYCCOJpn0tEitNLDCfeUh
	/FnvO49VHlTTiHrZrPzvC2dWX7udZNvqFg==
X-Google-Smtp-Source: ACHHUZ6YJ9zJvN0qE9S2BBzG8oNGio26IxwbglPykZdld8mltIWkKyzmWudRDShNKc3aUAXo7iiOsA==
X-Received: by 2002:a81:8283:0:b0:565:310:f615 with SMTP id s125-20020a818283000000b005650310f615mr6461794ywf.32.1684838654814;
        Tue, 23 May 2023 03:44:14 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id n14-20020a819e4e000000b00552ccda9bb3sm2704819ywj.92.2023.05.23.03.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 03:44:13 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-565014fc2faso25513187b3.1;
        Tue, 23 May 2023 03:44:13 -0700 (PDT)
X-Received: by 2002:a81:4603:0:b0:55a:7d83:7488 with SMTP id
 t3-20020a814603000000b0055a7d837488mr13085744ywa.9.1684838652890; Tue, 23 May
 2023 03:44:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
 <20230522133409.5c6e839a@kernel.org> <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
In-Reply-To: <20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
From: Luca Boccassi <bluca@debian.org>
Date: Tue, 23 May 2023 11:44:01 +0100
X-Gmail-Original-Message-ID: <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
Message-ID: <CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Christian Brauner <brauner@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 23 May 2023 at 10:49, Christian Brauner <brauner@kernel.org> wrote:
>
> On Mon, May 22, 2023 at 01:34:09PM -0700, Jakub Kicinski wrote:
> > On Mon, 22 May 2023 15:24:37 +0200 Alexander Mikhalitsyn wrote:
> > > v6:
> > >     - disable feature when CONFIG_UNIX=n/m (pidfd_prepare API is not exported to modules)
> >
> > IMHO hiding the code under #if IS_BUILTIN(CONFIG_UNRELATED) is
> > surprising to the user and.. ugly?
> >
> > Can we move scm_pidfd_recv() into a C source and export that?
> > That should be less controversial than exporting pidfd_prepare()
> > directly?
>
> I really would like to avoid that because it will just mean that someone
> else will abuse that function and then make an argument why we should
> export the other function.
>
> I think it would be ok if we required that unix support is built in
> because it's not unprecedented either and we're not breaking anything.
> Bpf has the same requirement:
>
>   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
>   struct bpf_unix_iter_state {
>           struct seq_net_private p;
>           unsigned int cur_sk;
>           unsigned int end_sk;
>           unsigned int max_sk;
>           struct sock **batch;
>           bool st_bucket_done;
>   };
>
> and
>
>   #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
>   DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
>                        struct unix_sock *unix_sk, uid_t uid)

Some data points: Debian, Ubuntu, Fedora, RHEL, CentOS, Archlinux all
ship with CONFIG_UNIX=y, so a missing SCM_PIDFD in unlikely to have a
widespread impact, and if it does, it might encourage someone to
review their kconfig.

As mentioned on the v5 thread, we are waiting for this API to get the
userspace side sorted (systemd/dbus/dbus-broker/polkit), so I'd be
really grateful if we could start with the simplest and most
conservative approach (which seems to be the current one in v6 to me),
and then eventually later decide whether to export more functions, or
to deprecate CONFIG_UNIX=m, or something else entirely, as that
doesn't really affect the shape of the UAPI, just the details of its
availability. Thank you.

Kind regards,
Luca Boccassi

