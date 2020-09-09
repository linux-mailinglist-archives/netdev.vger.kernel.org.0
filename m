Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF212632E1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgIIQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730996AbgIIQwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:52:46 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C915CC061756;
        Wed,  9 Sep 2020 09:52:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c17so2223683ybe.0;
        Wed, 09 Sep 2020 09:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0eRpso2JeKHjhIs7wrU/N/wZ4WhWl00NUYKklxxa8q4=;
        b=uAnFf1iOAnB3QnSzf4UFwg5PQsS6D/4IZonhBl1jstORHuiaIYf3DXj+GYxCZV7wFQ
         yyDib2GdMlhO3jie0otrLQOcaLJabdwpWQgDY3NvwSAOmQk65bjVEDIU1dh46L3omdiZ
         eLtRxfBr9D6zs4q2XQ1rZ53cfwtbtDcsOU7CJVwYmzng+84/ZQVLXvWCcwzpgylg2g0R
         ZDRpNqVVbuzQx7I+ilmN2Icqp1DZZV6vMNg64HV31+IVoeV4uElhCR9pGyWqdf2Wvg/q
         vpxVk39zZ0bcx+eCWwsCNDvxVqx0JnU8zmmVXIOdXXD6lVf/FsI/9kNM6nVQ3ZPIjIgk
         P7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0eRpso2JeKHjhIs7wrU/N/wZ4WhWl00NUYKklxxa8q4=;
        b=WPN5a9lDkiVDf9+59idJmLjU2A1l70C7CHT18Ed/1MtUxPPT3Cfpk5ZQxRv0TskSCE
         vb+xklhkcpNsIedGtJqiML5K6td8j8D7N5dpSj2wmsOAIpSQJEtC3PZkji+zmyZ3+54K
         waDcDoHY/4FLn8qFyC8n6Y8rC60Ca/GpJtQxqdTa+ZurbEh07t7Fsux0F/pwy02wbW3z
         VXAX1ixpVJoAtlgo9V+TmHYdgQd9L3YB+ui1J6/o2X1UXUIyoENbc4YIqVFKVtgKJI75
         GTsmg3LmrNDi+1T4d9FQXrjavFeMkjrmncVmruFSfh0YwYL/kvCa8BbXQX7u6GlPGXpf
         4ofg==
X-Gm-Message-State: AOAM533Kw9IygV3UYHbdnyQHPRP+AW7GhQtG0L0DYjDh7QRZZDJz41cT
        l7GBTM/cCnq8NNMfZvxy6IwlLaDLVYKniQUF+70=
X-Google-Smtp-Source: ABdhPJzNXGJE3ue+uShIP4GgGjkEOsw5/ZuCVdqphxaP7VN8MYwPPYSpC/xEzBw0p/QAef7P2lQrJ+ERE1paVFdMqj8=
X-Received: by 2002:a25:e655:: with SMTP id d82mr7455237ybh.347.1599670364859;
 Wed, 09 Sep 2020 09:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162251.15498-1-quentin@isovalent.com> <20200909162251.15498-3-quentin@isovalent.com>
 <CAEf4BzYaXsGFtX2K9pQF7U-e5ZcHFxMYanvjKanLORk6iF1+Xw@mail.gmail.com> <9574095f-f354-2f52-a476-8b832ffb1a7b@isovalent.com>
In-Reply-To: <9574095f-f354-2f52-a476-8b832ffb1a7b@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:52:33 -0700
Message-ID: <CAEf4BzZzeAwCO0EW+O_mK5Z3SGpRcMJYe9zU7LQYmPH6g1vM3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests, bpftool: add bpftool (and eBPF
 helpers) documentation build
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:51 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 09/09/2020 17:45, Andrii Nakryiko wrote:
> > On Wed, Sep 9, 2020 at 9:22 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> eBPF selftests include a script to check that bpftool builds correctly
> >> with different command lines. Let's add one build for bpftool's
> >> documentation so as to detect errors or warning reported by rst2man when
> >> compiling the man pages. Also add a build to the selftests Makefile to
> >> make sure we build bpftool documentation along with bpftool when
> >> building the selftests.
> >>
> >> This also builds and checks warnings for the man page for eBPF helpers,
> >> which is built along bpftool's documentation.
> >>
> >> This change adds rst2man as a dependency for selftests (it comes with
> >> Python's "docutils").
> >>
> >> v2:
> >> - Use "--exit-status=1" option for rst2man instead of counting lines
> >>   from stderr.
> >
> > It's a sane default to have non-zero exit code on error/warning, so
> > why not specifying it all the time?
>
> I hesitated to do so. I held off because a non-zero exit stops man pages
> generation (rst2man does pursue the creation of the current man page
> unless the error level is too high, but the Makefile will exit and not
> produce the following man pages). This sounds desirable for developers,
> but if distributions automatically build the doc to package it, I
> thought it would be better to carry on and build the other man pages
> rather than stopping the whole process.
>
> But I can change it as a follow-up if you think it would be best.
>

I don't really care, leave it as is then.

> Quentin
