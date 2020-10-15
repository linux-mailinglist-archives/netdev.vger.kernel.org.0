Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8EF28F8EF
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391082AbgJOSxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391065AbgJOSxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:53:22 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC0EC061755;
        Thu, 15 Oct 2020 11:53:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f21so4218251ljh.7;
        Thu, 15 Oct 2020 11:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cCCE4YtFTVJq/2VDGFn6Aptk+OGDPex4RVpqANY0ajc=;
        b=eOe65PlCHYMlKyLKE79QtpMiCnRCGzMfDhTlnuTXa3H6yASakhYUZzKdgS7quLTmr7
         +LzLFH0sVg+A7dl+B7QH30Qal6DNSnBaLP1NFvF6okphNxdvpD8grAtKqPSBj8+ziAnm
         tXXryoWVNq2YMr3nwqgGwhLIb+B9N2JrjSapo3J4C+fb1OW/vSBPjBVuTJ9jA39uAEfP
         0e02tiBLTlzMRJuywWzbU6TPPfKj2wFW2hibwcU4qXMx3UQ6JsXeHrt8ftwWe0wO7VHM
         xxPHSNUurTX4iX68sOBEIy5B/Ocelnj4IarlZhbutkAfn8aFGCdbSK7YuMFsDu8iUV2t
         RDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCCE4YtFTVJq/2VDGFn6Aptk+OGDPex4RVpqANY0ajc=;
        b=ImkE5J/J8zbpr4rffVsxDXyqvIldd/l9GIuelQmiQjudqL5Nwj1MFj+6I3TdK08KTS
         yyGUBoQCzDNOXf9noVOPxTkBXuvUxqsN8soKu2Yo+ZP42w3agd6ib00kESkvZTU6RiQU
         hBxgjtDHZkAPKafpjM2wujWMSfyAUnUNs/Ij8Xd+kLkpatXt7UIX7pqqoRl3SwrXWNKE
         vG0ZJrJg7vHAXp+FrDQRokb+Y9iFziae/+w49L7XFQchrz3VbJolYvqtFbPmas3QlUvU
         2FwW79JgTngMPIyUGu2rC3MUQfkIgsQ4EZyPrA9GaeylL48XlpFct8qXpXhiDJqF03ky
         /Inw==
X-Gm-Message-State: AOAM5301zRW0KrEPZC1GFax4Id7pgk/ReScMs2q8Q9A4+KM+PCD1HTtd
        Fsntcw/oKvus+2KTlDBg6hbkY/F4edyIAEq2vtE=
X-Google-Smtp-Source: ABdhPJxnj+CpCo+jWWUGnPD/LssgI2suQ52wVLqo0qvlncvNzhCqO8GhZL4RmjkihtMJC9zkc/uQxQgGS8d8ruApKoQ=
X-Received: by 2002:a2e:a162:: with SMTP id u2mr55026ljl.283.1602788000220;
 Thu, 15 Oct 2020 11:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201014091749.25488-1-yuehaibing@huawei.com> <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Oct 2020 11:53:08 -0700
Message-ID: <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 9:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 14 Oct 2020 17:17:49 +0800 YueHaibing wrote:
> > IF CONFIG_BPFILTER_UMH is set, building fails:
> >
> > In file included from /usr/include/sys/socket.h:33:0,
> >                  from net/bpfilter/main.c:6:
> > /usr/include/bits/socket.h:390:10: fatal error: asm/socket.h: No such file or directory
> >  #include <asm/socket.h>
> >           ^~~~~~~~~~~~~~
> > compilation terminated.
> > scripts/Makefile.userprogs:43: recipe for target 'net/bpfilter/main.o' failed
> > make[2]: *** [net/bpfilter/main.o] Error 1
> >
> > Add missing include path to fix this.
> >
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
> Applied, thank you!

Please revert. The patch makes no sense.
Also please don't take bpf patches.
