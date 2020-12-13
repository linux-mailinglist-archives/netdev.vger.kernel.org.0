Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B542D8C8B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 10:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405676AbgLMJtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 04:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgLMJtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 04:49:07 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BF2C0613CF;
        Sun, 13 Dec 2020 01:48:27 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id i9so14013816ioo.2;
        Sun, 13 Dec 2020 01:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DrGbDyNeh25uekmQEz9FpP8pASRopkwZQwpthWnr/M8=;
        b=Yaw5EQYbZRDwxMnl1nVENrrQ9HFFMXqbkqfWi7CgXPelJ0VCxe7Xzb7RhEF6Omuazx
         Y5+eg6YKKlLd1fbpp/ll9qUxvcz0phRsbusah7xqoL31/+nyb2HFjhz+qlzsInF1LfrP
         4Fsc8Ljwvw2uK3PqgmQ1swGtZ/jC1NzEUAjtZZ7t8Dc7zgQOn+TOohoGUwwXPqimyAgG
         n5sZr+SrFVNa6SQ6EtBugzr2wRIVqgP4Q+WffGTiOOgJmZnfmdtEpXJUENU5JWRDqeMv
         C1L/EPZSF29+LeTsL5jz/KT2BWMpcccOWvA5dGd1Wrj2C53I8S61WHTIIIUmqU67rOrX
         1jiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DrGbDyNeh25uekmQEz9FpP8pASRopkwZQwpthWnr/M8=;
        b=i+31aL+6etXSBatRE2YYg7AQSArdP+iFlq4khUYxeXViUgQgfHhAiAbpOagmBIcThc
         K5eJnHloQYho6DRk2WU1PLRWU/xm35cGsyEgPLYNXNB9GPKzR0CKG1aWXwGMMTNm5xaO
         Xq3BFRJ3w5mMvfxM7mjrhqPx06QZY0z0K8xM36mJp3NhBe4EiRa+kSErcTovvTla9qbk
         pWBgu3uqQj+BfkiqBwJPAJBaHr2R6I6Xz3YMtKMYJKkX84PIWN1MSmMikkxBkZA9SFi5
         ScsMy6FvIosV3rFyp9lwaPCmgXU0CCG+vAAT2oko+cBf8UCgYbKFvbL068N/PNnmwgCz
         k0CA==
X-Gm-Message-State: AOAM532zGfVX5J1UyHsR8zSQTeOphU1joGf9Mf0LWNwGoS8j6VZOWrHS
        Jkyul9hYCOMUvg1iYophRp3u2bvumjkfWEouOWs=
X-Google-Smtp-Source: ABdhPJwk8FoE15Szg8cwx7iAei7vz3MxELq08xWu1OFUF1gb5aZMI53l/lJzE/iatVqQiGcN+m6O8VmUiENZ4K6+7Ko=
X-Received: by 2002:a6b:8ec9:: with SMTP id q192mr26733029iod.28.1607852906625;
 Sun, 13 Dec 2020 01:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
 <20201211163749.31956-2-yonatanlinik@gmail.com> <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+s=kw3gmvk7CLu9NyiEwtBQ05eNFsTM2A679arPESVb55E2Xw@mail.gmail.com> <20201212135119.0db6723e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212135119.0db6723e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yonatan Linik <yonatanlinik@gmail.com>
Date:   Sun, 13 Dec 2020 11:48:15 +0200
Message-ID: <CA+s=kw3xw-_Q846CigmygetaHXfr0KFHNsmO9a=Ww9Z=G6yT7w@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Willem de Bruijn <willemb@google.com>,
        john.ogness@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Mao Wenan <maowenan@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        orcohen@paloaltonetworks.com, Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 12 Dec 2020 23:39:20 +0200 Yonatan Linik wrote:
> > On Sat, Dec 12, 2020 at 9:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Fri, 11 Dec 2020 18:37:49 +0200 Yonatan Linik wrote:
> > > > proc_fs was used, in af_packet, without a surrounding #ifdef,
> > > > although there is no hard dependency on proc_fs.
> > > > That caused the initialization of the af_packet module to fail
> > > > when CONFIG_PROC_FS=n.
> > > >
> > > > Specifically, proc_create_net() was used in af_packet.c,
> > > > and when it fails, packet_net_init() returns -ENOMEM.
> > > > It will always fail when the kernel is compiled without proc_fs,
> > > > because, proc_create_net() for example always returns NULL.
> > > >
> > > > The calling order that starts in af_packet.c is as follows:
> > > > packet_init()
> > > > register_pernet_subsys()
> > > > register_pernet_operations()
> > > > __register_pernet_operations()
> > > > ops_init()
> > > > ops->init() (packet_net_ops.init=packet_net_init())
> > > > proc_create_net()
> > > >
> > > > It worked in the past because register_pernet_subsys()'s return value
> > > > wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
> > > > packet_init.").
> > > > It always returned an error, but was not checked before, so everything
> > > > was working even when CONFIG_PROC_FS=n.
> > > >
> > > > The fix here is simply to add the necessary #ifdef.
> > > >
> > > > Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>
> > >
> > > Hm, I'm guessing you hit this on a kernel upgrade of a real system?
> >
> > Yeah, suddenly using socket with AF_PACKET didn't work,
> > so I checked what happened.
> >
> > > It seems like all callers to proc_create_net (and friends) interpret
> > > NULL as an error, but only handful is protected by an ifdef.
> >
> > I guess where there is no ifdef,
> > there should be a hard dependency on procfs,
> > using depends on in the Kconfig.
> > Maybe that's not the case everywhere it should be.
>
> You're right, on a closer look most of the places have a larger #ifdef
> block (which my grep didn't catch) or are under Kconfig. Of those I
> checked only TLS looks wrong (good job me) - would you care to fix that
> one as well, or should I?

I can fix that as well, you are talking about tls_proc.c, right?
