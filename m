Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE321FD88
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgGNTkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbgGNTkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:40:08 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A031C08C5C1;
        Tue, 14 Jul 2020 12:40:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q4so25073469lji.2;
        Tue, 14 Jul 2020 12:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FaR9w5/0RD2++C/T8Zbo7Hqni0XY/GF9Elz9sYyM4QA=;
        b=hjQvBK9I2IG6JiGa7EiQ6Qz0aDn+hdJFkfQHw4GebZigj7Et0fJkm6AmUyMa9e+zTF
         EAb9zOEP6pcg/5xqZD3vm/z0+udCOmrucqQaqr8YOL7W2nwR0eUDyx18hVDtfDUYaVIL
         uSmTCCTL8F3fB6xO9WyTR3vWZwwLcwIbbgRnnwl9NKzl9nxQAkfNZlBW3IlRBSni2tQm
         lblvbBDOUW/4J2nSRhhkX59veDVOg/UZbfLQV5JsQkX0EwoH1RI/GK/xPntniu0mUmpK
         /Bmggco9P3fPMGcDESQ0IXhC9TiNU15shc/4sOMFQgpIQah+PlsEvZqGq6IDJwb6rHGF
         GJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FaR9w5/0RD2++C/T8Zbo7Hqni0XY/GF9Elz9sYyM4QA=;
        b=XtH1UVxzIYw3AfiB//YWX/2Qs8jeq/g96A9TMffn5e4NftZARi/LbefACh7K/18wC9
         Rgn/uPvPytKVskkwVfSYKW33o5Vy7zaaDI5qO0IraQrNCuSgWnj1g06waAw0FI6zujrp
         fzeLPq5K80LROS/fyoOqJVSzPFzdnXwNAdXzTpYLsYb+12NMsOSG0fABeHVKMtEH9ZrM
         3hYi+bIkUdoqEMZ7LlBGVlHa1U/mabp0um3VsczIHq5dIEPr84zmtgn9QkKQ2BL+lH/k
         rb1rhwLHn9ogXOUVbJ1V85chblFcdDLMfoRFD9tdeEhK2ssy1aALJENjR+xB9jwBjOP+
         hOpA==
X-Gm-Message-State: AOAM533aJY+sI5F2HVy2AJ2fScd4wR2uQwln5tHbVenBNI+MxeGbQh+S
        r4BNST/Y3x4Cj3szNisJL192OjTdJG92Kai0yJQ=
X-Google-Smtp-Source: ABdhPJyh49hXL2cG/s2k7Rx5OKIncgHt2pUNqas9VkOTV+0gOAczebhhNC16P1x3Aq6Sf3Yhs8IsvDnxbgwi9mpxZPo=
X-Received: by 2002:a2e:8216:: with SMTP id w22mr3124383ljg.2.1594755606518;
 Tue, 14 Jul 2020 12:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200701092644.762234-1-masahiroy@kernel.org> <20200701174609.mw5ovqe7d5o6ptel@ast-mbp.dhcp.thefacebook.com>
 <CAK7LNARTMt8kgRJqgRonaSHROT80yDNAG0wDiLGL=RSEz3CDig@mail.gmail.com>
In-Reply-To: <CAK7LNARTMt8kgRJqgRonaSHROT80yDNAG0wDiLGL=RSEz3CDig@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 12:39:55 -0700
Message-ID: <CAADnVQLE+3=k6r3RXR8=n8RUd6uJLN9H80g2i74J9e4QR5LHgA@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: allow to build bpfilter_umh as a module without
 static library
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Song Liu <songliubraving@fb.com>,
        =?UTF-8?Q?Valdis_Kl_=C4=93_tnieks?= <valdis.kletnieks@vt.edu>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 10:50 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Thu, Jul 2, 2020 at 2:46 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jul 01, 2020 at 06:26:44PM +0900, Masahiro Yamada wrote:
> > > Originally, bpfilter_umh was linked with -static only when
> > > CONFIG_BPFILTER_UMH=y.
> > >
> > > Commit 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build
> > > bpfilter_umh") silently, accidentally dropped the CONFIG_BPFILTER_UMH=y
> > > test in the Makefile. Revive it in order to link it dynamically when
> > > CONFIG_BPFILTER_UMH=m.
> > >
> > > Since commit b1183b6dca3e ("bpfilter: check if $(CC) can link static
> > > libc in Kconfig"), the compiler must be capable of static linking to
> > > enable CONFIG_BPFILTER_UMH, but it requires more than needed.
> > >
> > > To loosen the compiler requirement, I changed the dependency as follows:
> > >
> > >     depends on CC_CAN_LINK
> > >     depends on m || CC_CAN_LINK_STATIC
> > >
> > > If CONFIG_CC_CAN_LINK_STATIC in unset, CONFIG_BPFILTER_UMH is restricted
> > > to 'm' or 'n'.
> > >
> > > In theory, CONFIG_CC_CAN_LINK is not required for CONFIG_BPFILTER_UMH=y,
> > > but I did not come up with a good way to describe it.
> > >
> > > Fixes: 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build bpfilter_umh")
> > > Reported-by: Michal Kubecek <mkubecek@suse.cz>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> >
> > lgtm
> > Do you mind I'll take it into bpf-next tree?
> > Eric is working on a bunch of patches in this area. I'll take his set
> > into bpf-next as well and then can apply this patch.
> > Just to make sure there are no conflicts.
>
> Please go ahead.

I've merged Eric's set and applied yours on top.
Thanks
