Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12782269156
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgINQVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgINQVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:21:06 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577BC20EDD;
        Mon, 14 Sep 2020 16:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600100465;
        bh=eAVAzgvUkh0wc/I1j1/s8lyQbeYVFTOGhBfWS8xzoY0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xVLWwgJwu9iq1HXV108sMD+XNOpS4ODsXAKTu4PFwOeB7Q+pGs4qxy+Al3QyU9Vsz
         GZNDkbbHKXyx+mwQUPDAKU1uInzXhTEOnT0hh7vGs+uM0RV0EnUODvSC+2WzEDhC3Q
         DhpE106v1VJBq8OqdhjMejVWFX2hljIgmnryzE+8=
Received: by mail-lj1-f178.google.com with SMTP id c2so151320ljj.12;
        Mon, 14 Sep 2020 09:21:05 -0700 (PDT)
X-Gm-Message-State: AOAM533vAPu0a9IZWm1tNINkBrbubPswf6Zb3PZmFNJob79AHpxUnQsy
        QDlYKXWfU1O9FQTdUTvZKXO1zJWjdB7r3nGEomg=
X-Google-Smtp-Source: ABdhPJwO3e8CVSM2h2kC53VTIZbFnvCMMpuEr2dDAgBR5ieztpYgRR6Cek/gSMFtFBdL6SgpgfNsPvTXlL3FMDQwm8Q=
X-Received: by 2002:a2e:98cf:: with SMTP id s15mr5625684ljj.446.1600100463625;
 Mon, 14 Sep 2020 09:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200914061206.2625395-1-yhs@fb.com> <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
In-Reply-To: <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 09:20:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Ja5if-DOPQn1FrbiEsH-YXXYVGzM59XQkyG5_xNmD-A@mail.gmail.com>
Message-ID: <CAPhsuW5Ja5if-DOPQn1FrbiEsH-YXXYVGzM59XQkyG5_xNmD-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 1:20 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 14/09/2020 07:12, Yonghong Song wrote:
> > When building bpf selftests like
> >   make -C tools/testing/selftests/bpf -j20
> > I hit the following errors:
> >   ...
> >   GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
> >   <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
> >   <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
> >   <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
> >   make[1]: *** Waiting for unfinished jobs....
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
> >   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
> >   ...
> >
> > I am using:
> >   -bash-4.4$ rst2man --version
> >   rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
> >   -bash-4.4$
> >
> > Looks like that particular version of rst2man prefers to have a blank line
> > after literal blocks. This patch added block lines in related .rst files
> > and compilation can then pass.
> >
> > Cc: Quentin Monnet <quentin@isovalent.com>
> > Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
> > Signed-off-by: Yonghong Song <yhs@fb.com>
>
>
> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
> setup. For the record my rst2man version is:
>
>         rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>
> Your patch looks good, but instead of having blank lines at the end of
> most files, could you please check if the following works?
>
> ------
>
> diff --git a/tools/bpf/bpftool/Documentation/Makefile
> b/tools/bpf/bpftool/Documentation/Makefile
> index 4c9dd1e45244..01b30ed86eac 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -32,7 +32,7 @@ RST2MAN_OPTS += --verbose
>
>  list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
>  see_also = $(subst " ",, \
> -       "\n" \
> +       "\n\n" \
>         "SEE ALSO\n" \
>         "========\n" \
>         "\t**bpf**\ (2),\n" \

Yes, this works (I am using the same rst2man as Yonghong's).

Thanks,
Song
