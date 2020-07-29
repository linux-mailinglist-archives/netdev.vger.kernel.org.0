Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900F1232705
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgG2ViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgG2ViQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:38:16 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A38C061794;
        Wed, 29 Jul 2020 14:38:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a34so8302251ybj.9;
        Wed, 29 Jul 2020 14:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ajw4Ad2XIL03EcBjmcLSFrL4K69Ry7eAYMMRgYJSoP0=;
        b=nRupzO9PKS5/GgMrOwTGe/reEWhhfKS0n3knacnRqGpTzRq17Q/UThDuF6baQadUyn
         mFNClQcWA057mG0OuQJCRNthGXQN8FzROnjNp28CLP5Qzq8mUzyw5yJhGioq6RoRIMGQ
         4HchwHCnirdUsBMJtx10i+MIjajG+UsB5LI+vFvEcZjl8pSFuicq1LV7ZW1+e42PF+uT
         h175RmjxQNLhD3/rP37xF6zhHfS26keNpXkPeE0vcpLOrQQ6h/7cxQfEr074JiK9Vpf5
         uFX/51n76fB0f1MSWwbNb7lrcT6d7C2LuVIMA8t3bO1Y49uaGxj205uozdJxW2WOMObH
         NWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ajw4Ad2XIL03EcBjmcLSFrL4K69Ry7eAYMMRgYJSoP0=;
        b=IHlYnvHuQEQvIW2jv1qGqw3nq35UKCM7zjSzO+FmnkIwXRVcdtIj87Htyw73rwPXsU
         5pcLQVGd1trI+rLC1oVsRHsvkl/8hGcFKb236pCk9nkJvNeoSMcPhJPlwgBehoUEjZkA
         1wWdIu3EGnKqks1Ml9Z7bSsKmJlY3ZXfv1XatlnhTfqV77tAe08uBPjPTVAPjOrL0oKh
         hujC8/B4mJt/7h/knPf5qffLnznTsTh3boeqzyXQBMJg1+j0Lb5z9Xpm0lVWBX+3G3Sy
         LBR4ubsdpBzclqFRGziwygxTOUc9zsEgnq+R7KeZrHGR3mtcf/pNopW5C0RG+XrNztVu
         gF3A==
X-Gm-Message-State: AOAM533jNyVxsXuTs215tKlTQEp7FTdKrDss64jaIv0e1CXIJrNCK+2/
        2venx1/Iq1sbBeayoK7f/767dtuajX3k/SJYDmk=
X-Google-Smtp-Source: ABdhPJz5+MHpVudw/xmgI4//1CfSeqvf+ynCHzMknvvufGxaY8YS7zFuXoJnuk/FxjlgkeavUs3KdLLTcgWV0Q3cUeo=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr696705ybq.27.1596058695846;
 Wed, 29 Jul 2020 14:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-2-jolsa@kernel.org>
 <CAEf4Bzba08D8-zPBq3RpsG3fcRt8Q31VKd-_fV2LuJVwHGaY=w@mail.gmail.com> <20200729200657.GP1319041@krava>
In-Reply-To: <20200729200657.GP1319041@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jul 2020 14:38:04 -0700
Message-ID: <CAEf4BzapEaUmaGjquJcXX0sN7Zjr__-5mQw9Ag+4HzK6jz8jog@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 01/13] selftests/bpf: Fix resolve_btfids test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 1:07 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jul 28, 2020 at 01:27:49PM -0700, Andrii Nakryiko wrote:
> > On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > The linux/btf_ids.h header is now using CONFIG_DEBUG_INFO_BTF
> > > config, so we need to have it defined when it's available.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > sure, why not
>
> actually after rebase I realized Yonghong added
> CONFIG_DEBUG_INFO_BTF define in:
>   d8dfe5bfe856 ("tools/bpf: Sync btf_ids.h to tools")
>
> I think including 'autoconf.h' is more clean,
> on the other hand I don't think we'd get clean
> selftest compile without CONFIG_DEBUG_INFO_BTF
>
> should we keep the #define instead?
>

#define is fine with me

> thanks,
> jirka
>
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > > index 3b127cab4864..101785b49f7e 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > > @@ -1,5 +1,6 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > >
> > > +#include "autoconf.h"
> > >  #include <linux/err.h>
> > >  #include <string.h>
> > >  #include <bpf/btf.h>
> > > --
> > > 2.25.4
> > >
> >
>
