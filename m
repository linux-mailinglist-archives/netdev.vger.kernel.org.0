Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4D2F2047
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391319AbhAKUBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389880AbhAKUBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:01:07 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34E8C061786;
        Mon, 11 Jan 2021 12:00:13 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id o6so895228iob.10;
        Mon, 11 Jan 2021 12:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=goT5IWT5P9ja4vCJx8N393EOK2IFNhGkcxSpp3GtoZI=;
        b=jjRVrZszqODR6rhGYZpNgsaBV6qa5L9DyqSGjmAwyHFZkJfjAD+qor+FbnQtqVmAEG
         dP5IGJRXjKD/k7Vik7qYUs/vU5eAiKBGMrfN8QFr1WZ2+cTfZkoJjIfsrja699rrwpMU
         bniH3sMqps8edGFlkjrYO9/6km3U4j0IsfNUmWbWybmtF9Uhu58ltFtKomLcUuXO/oex
         VD/UvCasLXCmXUV/n6ez9bxIUzEvPJkHvDXY2mIocgjJ6Npmh4j8UBCSSQ2+ECWuFqBq
         B0hbLj4EhnysgIguBA1NDLRDJ+25EozXcDmO0znXDrjdhq1UsGo9EWYepA2kxRjPX1g/
         JrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=goT5IWT5P9ja4vCJx8N393EOK2IFNhGkcxSpp3GtoZI=;
        b=HgNz55Ou5WNYs8fxT1edzsMnJU+NrYOyOZ+7TT13bf4NlzQidJMZEJ1iQ7zmU4TRhR
         3X1kVU8AuC7jjBw2R5duN/bvVtXsT77XqOtGRJ+UnBNZ96DJq4h1p9KKpREm+H6X0aaq
         cIKNfPJbT+nGTu+uGZx4BflPD1yPSvH08Z/Rq2FxszAG3OzqhntsXAbN5xHFuubwzNx/
         X+06SEKp2UYbLZc+oPU4Ts54eVqn8tf5JR4XTHBuwuTeO7zIhHdba97cUoAXY9AjJw8C
         giLGslN54OuyJJPMqoVhXNZo5EpT37TDIEbZzDq35sUKKMGCwlcT+JbEDyLGwecyRZpn
         C/yA==
X-Gm-Message-State: AOAM5324X2bAtiDOn0w/wkp5YzamOi6/N5na1VInEUSUK5xJ+7/OM89M
        RkC/qrqa58tKxoy8be9laqA=
X-Google-Smtp-Source: ABdhPJxNCjsZ4aVbzvK4xd1uVps8hqyqrzFNgKMzoNE9F8bSJBYz41tc6A5yF1Piv3+saee72uDHKQ==
X-Received: by 2002:a6b:c414:: with SMTP id y20mr734574ioa.150.1610395213257;
        Mon, 11 Jan 2021 12:00:13 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id l78sm426963ild.30.2021.01.11.12.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:00:12 -0800 (PST)
Date:   Mon, 11 Jan 2021 13:00:10 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
Message-ID: <20210111200010.GA3635011@ubuntu-m3-large-x86>
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
 <20210111193400.GA1343746@ubuntu-m3-large-x86>
 <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 04:50:50AM +0900, Masahiro Yamada wrote:
> On Tue, Jan 12, 2021 at 4:34 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 04:19:01AM +0900, Masahiro Yamada wrote:
> > > On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
> > > <natechancellor@gmail.com> wrote:
> > > >
> > > > After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> > > > vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> > > > copy of pahole results in a kernel that will fully compile but fail to
> > > > link. The user then has to either install pahole or disable
> > > > CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> > > > has failed, which could have been a significant amount of time depending
> > > > on the hardware.
> > > >
> > > > Avoid a poor user experience and require pahole to be installed with an
> > > > appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> > > > standard for options that require a specific tools version.
> > > >
> > > > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > >
> > >
> > >
> > > I am not sure if this is the right direction.
> > >
> > >
> > > I used to believe moving any tool test to the Kconfig
> > > was the right thing to do.
> > >
> > > For example, I tried to move the libelf test to Kconfig,
> > > and make STACK_VALIDATION depend on it.
> > >
> > > https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/
> > >
> > > It was rejected.
> > >
> > >
> > > In my understanding, it is good to test target toolchains
> > > in Kconfig (e.g. cc-option, ld-option, etc).
> > >
> > > As for host tools, in contrast, it is better to _intentionally_
> > > break the build in order to let users know that something needed is missing.
> > > Then, they will install necessary tools or libraries.
> > > It is just a one-time setup, in most cases,
> > > just running 'apt install' or 'dnf install'.
> > >
> > >
> > >
> > > Recently, a similar thing happened to GCC_PLUGINS
> > > https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673
> > >
> > >
> > >
> > >
> > > Following this pattern, if a new pahole is not installed,
> > > it might be better to break the build instead of hiding
> > > the CONFIG option.
> > >
> > > In my case, it is just a matter of 'apt install pahole'.
> > > On some distributions, the bundled pahole is not new enough,
> > > and people may end up with building pahole from the source code.
> >
> > This is fair enough. However, I think that parts of this patch could
> > still be salvaged into something that fits this by making it so that if
> > pahole is not installed (CONFIG_PAHOLE_VERSION=0) or too old, the build
> > errors at the beginning, rather at the end. I am not sure where the best
> > place to put that check would be though.
> 
> Me neither.
> 
> 
> Collecting tool checks to the beginning would be user-friendly.
> However, scattering the related code to multiple places is not
> nice from the developer point of view.
> 
> How big is it a problem if the build fails
> at the very last stage?
> 
> You can install pahole, then resume "make".
> 
> Kbuild skips unneeded building, then you will
> be able to come back to the last build stage shortly.

There will often be times where I am testing multiple configurations in
a row serially and the longer that a build takes to fail, the longer it
takes for me to get a "real" result. That is my motivation behind this
change. If people are happy with the current state of things, I will
just stick with universally disabling CONFIG_DEBUG_INFO_BTF in my test
framework.

Cheers,
Nathan
