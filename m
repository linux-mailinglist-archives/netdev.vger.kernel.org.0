Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91052D8A28
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407986AbgLLVhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407977AbgLLVhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 16:37:15 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38232C0613CF;
        Sat, 12 Dec 2020 13:36:35 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id r9so13178340ioo.7;
        Sat, 12 Dec 2020 13:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5uxw4W3MH+sfozX0Yv4bx6QSv9bj+5fDqpITK7K1vQ=;
        b=sGWTYQ6fbeXtfZ6e2R7yPxobM0ZaetVvLD+zg7ofZY1AVLFcAB7Ostz8w3Y7meLEv6
         4hCOPyj4q3k0qwlLE+mWOeO7JfkoUsocfUpBVl0CmRvTCAaOvu6szwjKtaGzwaW5Ir7A
         4RtTmNtBbafcnAHmtZpNnkh68WxmTXgR8lrGA6h/f0Ow8jhbKiwQkF6hF3t77PrZkf2V
         6v/DnZeNgxyrI+BdTH4C7vZjKbb0g72Jc5uG1k1Su6Fvz84OhlQ6VQ0DEYKQvMah76Aw
         ME0iWVyG7sehDhC4NuHeT+A2c8ei0LxSSjyN08/NaQ5Wut6fhdGgyENp7pVP0yWGidbg
         LX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5uxw4W3MH+sfozX0Yv4bx6QSv9bj+5fDqpITK7K1vQ=;
        b=Hx0Cp7lGw1CqoflTVQDpxevxuh2omEJ+rkHoeQbHMxbwliS5y1zIY/YufJczE04EUg
         o22ZS+h2lCIJpIL4YH2rCoCQYWvzCQE3cxThp7dtz5T8RQvF5e/KhlsgKnrqoxvlk9/4
         RtuNGs/6O8DzwAK0pSEHoSXdRxRknC+aRqz+WragWfE/9Xo0yVN+JDmC8FDCOFm1B1q5
         uMSLNx2S0ZYJjTt/IRR24tcWeMe6ya2QqD0X42pJPa2Oitjq9hP3cSr2Y4GU1sRDJ14F
         VYApBfLJo6Kc/Z6D2JfGGLTehwKsAcxGpZiJYpelAc8fsHC3UXCFk8UDY1iPGPsO2pTg
         uZCQ==
X-Gm-Message-State: AOAM530U+WOdYenay4639d8+oH0JZpgiVGXmrPfH9DnwGj6mqqRGlug2
        +kHccbDVNXNcR+v8xeL9+x3vpEZiRKl/jHVyUUI=
X-Google-Smtp-Source: ABdhPJyspFneOiLyVcT7sLJX0yncMfUy9xIzCMdmquH8Jt73xLFUgoiLz8g4/8kGFN13XNNqlt6dqf5ld+dtKSXjnqY=
X-Received: by 2002:a6b:f401:: with SMTP id i1mr22942750iog.142.1607808994486;
 Sat, 12 Dec 2020 13:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
 <20201211163749.31956-2-yonatanlinik@gmail.com> <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yonatan Linik <yonatanlinik@gmail.com>
Date:   Sat, 12 Dec 2020 23:39:20 +0200
Message-ID: <CA+s=kw3gmvk7CLu9NyiEwtBQ05eNFsTM2A679arPESVb55E2Xw@mail.gmail.com>
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

On Sat, Dec 12, 2020 at 9:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 11 Dec 2020 18:37:49 +0200 Yonatan Linik wrote:
> > proc_fs was used, in af_packet, without a surrounding #ifdef,
> > although there is no hard dependency on proc_fs.
> > That caused the initialization of the af_packet module to fail
> > when CONFIG_PROC_FS=n.
> >
> > Specifically, proc_create_net() was used in af_packet.c,
> > and when it fails, packet_net_init() returns -ENOMEM.
> > It will always fail when the kernel is compiled without proc_fs,
> > because, proc_create_net() for example always returns NULL.
> >
> > The calling order that starts in af_packet.c is as follows:
> > packet_init()
> > register_pernet_subsys()
> > register_pernet_operations()
> > __register_pernet_operations()
> > ops_init()
> > ops->init() (packet_net_ops.init=packet_net_init())
> > proc_create_net()
> >
> > It worked in the past because register_pernet_subsys()'s return value
> > wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
> > packet_init.").
> > It always returned an error, but was not checked before, so everything
> > was working even when CONFIG_PROC_FS=n.
> >
> > The fix here is simply to add the necessary #ifdef.
> >
> > Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>
>
> Hm, I'm guessing you hit this on a kernel upgrade of a real system?

Yeah, suddenly using socket with AF_PACKET didn't work,
so I checked what happened.

> It seems like all callers to proc_create_net (and friends) interpret
> NULL as an error, but only handful is protected by an ifdef.

I guess where there is no ifdef,
there should be a hard dependency on procfs,
using depends on in the Kconfig.
Maybe that's not the case everywhere it should be.

>
> I checked a few and none of them cares about the proc_dir_entry pointer
> that gets returned. Should we perhaps rework the return values of the
> function so that we can return success if !CONFIG_PROC_FS without
> having to yield a pointer?

Sometimes the pointer returned is used,
for example in drivers/acpi/button.c.
Are you suggesting returning a bool while
having the pointer as an out parameter?
Because that would still be problematic where the pointer is used.

>
> Obviously we can apply this fix so we can backport to 5.4 if you need
> it. I think the ifdef is fine, since it's what other callers have.
>

It would be great to apply this where the problem exists,
I believe this applies to other versions as well.

-- 
Yonatan Linik
