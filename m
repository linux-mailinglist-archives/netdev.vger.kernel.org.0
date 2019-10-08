Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA9CFD8E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfJHP0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:26:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38598 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHP0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:26:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so10432414pgi.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ukGqWj5a1FeSJU0pzE0V4T+cj7qN53c/aquLzSv6y94=;
        b=dqkf+ZprkXFVcxFXkXIDOQAPKllrX1M6J7JTd3uE7yvdnmhEulq3lkYjnd+1DflPNk
         4mVwid7A90bJqpgVt2s3SZc4z9TIryZC1XqcvFFICMMu7YnA3gIbDYBUl2uwsl1dv+Z4
         t2mX8x3DiVccFyPARNRvAQJ8CgIWdvAVEUff1jRZHo3l4b6zZ6WZMd3ak45tQpdSA9/l
         7/XMnsW+WhTKdTlH91axXYBBq948GlGlTRAvQxgeF/iWnqRd4mVvFVzS81NVa3qqQXbT
         cOh2VsLcnhlcGhrvBnwM9j/P2CFOcpbnUBWF3I8PR8rJw3Ca5GkuFHwigJVGXtWn5Rjl
         Y2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ukGqWj5a1FeSJU0pzE0V4T+cj7qN53c/aquLzSv6y94=;
        b=BoUThLt3kIXOUXU9qyQwnsavnWz4dL2jkYq63GUbJmcsifh8ntEN+m376ABv0i4j7P
         UjB4Xgdapvj/S5jHF6Gos7dIzaShSF7+ZLGF9B0BcSnfZIuS1VkKv39IYgZtg+KMGnRc
         k2KKYk+slMR3gpGAdnTQpluRBBPRE3TdZxRe38qSaXmJzQOmskxUDj4n0+2teQW/Rgwz
         GhIx5qJGRLWy9hRZhZKA7n/QscQVqxn9+qp8ZmxNzLi6oShf2U4odkQY/P75ypIvz78w
         AA4FAoz5VkSHX6i1QJMnHK1fllk1HmLi5SPAEy4/Usgkr9p1+jdOtqb1e3EbGyHnylOU
         RZ1w==
X-Gm-Message-State: APjAAAUAsFd8nyMZKx/KMbEGIvAk9fGUU6i4ptpbPUiJrl+O0eZkS+Px
        S3m89OhExo6up2w7UxGPUAWdyg==
X-Google-Smtp-Source: APXvYqxBO2iZovZc62Tudrbl7YZA7NOxm4NfIRO8QC1VBoxV3wwBvdR/5hAlEFkUmwouqWE5jcxolw==
X-Received: by 2002:a63:6c89:: with SMTP id h131mr36854264pgc.380.1570548403251;
        Tue, 08 Oct 2019 08:26:43 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j25sm18518231pfi.113.2019.10.08.08.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:26:42 -0700 (PDT)
Date:   Tue, 8 Oct 2019 08:26:41 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: fix bpftool build by switching to
 bpf_object__open_file()
Message-ID: <20191008152641.GD2096@mini-arch>
References: <20191007212237.1704211-1-andriin@fb.com>
 <20191007214650.GC2096@mini-arch>
 <CAEf4Bzba7S=hUkxTvL3Y+QYxAxZ-am5w-mzk8Aks7csx-g0FPA@mail.gmail.com>
 <CAEf4BzYh4pN3FPYHRMRwAUFEK0E+wXqLSqjZE3FZEmyhzCwuig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYh4pN3FPYHRMRwAUFEK0E+wXqLSqjZE3FZEmyhzCwuig@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07, Andrii Nakryiko wrote:
> -- Andrii
> 
> On Mon, Oct 7, 2019 at 2:50 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Oct 7, 2019 at 2:46 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 10/07, Andrii Nakryiko wrote:
> > > > As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
> > > > populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
> > > > was removed from libbpf.h header. This broke bpftool, which relied on
> > > > that function. This patch fixes the build by switching to newly added
> > > > bpf_object__open_file() which provides the same capabilities, but is
> > > > official and future-proof API.
> > > >
> > > > Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
> > > > Reported-by: Stanislav Fomichev <sdf@google.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/bpf/bpftool/main.c |  4 ++--
> > > >  tools/bpf/bpftool/main.h |  2 +-
> > > >  tools/bpf/bpftool/prog.c | 22 ++++++++++++----------
> > > >  3 files changed, 15 insertions(+), 13 deletions(-)
> > > >
> 
> [...]
> 
> > > > --- a/tools/bpf/bpftool/prog.c
> > > > +++ b/tools/bpf/bpftool/prog.c
> > > > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> > > >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> > > >  {
> > > >       struct bpf_object_load_attr load_attr = { 0 };
> > > > -     struct bpf_object_open_attr open_attr = {
> > > > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > > > -     };
> > > > +     enum bpf_prog_type prog_type = BPF_PROG_TYPE_UNSPEC;
> > > >       enum bpf_attach_type expected_attach_type;
> > > >       struct map_replace *map_replace = NULL;
> 
> [...]
> 
> > > >
> > > >       bpf_object__for_each_program(pos, obj) {
> > > > -             enum bpf_prog_type prog_type = open_attr.prog_type;
> > > > +             enum bpf_prog_type prog_type = prog_type;
> > > Are you sure it works that way?
> >
> > Oh, I did this pretty mechanically, didn't notice I'm shadowing. In
> > either case I'd like to avoid shadowing, so I'll rename one of them,
> > good catch!
> >
> > >
> > > $ cat tmp.c
> > > #include <stdio.h>
> > >
> > > int main()
> > > {
> > >         int x = 1;
> > >         printf("outer x=%d\n", x);
> > >
> > >         {
> > >                 int x = x;
> 
> It's amazing `int x = x;` is compiled successfully when there is no x
> in outer scope. And it's also amazing that it's doing the wrong thing
> when there is a shadowed variable in outer scope. I can't imagine the
> case where this will be a meaningful behavior...
Enjoy your daily dose of undefined behavior :-D

> > >                 printf("inner x=%d\n", x);
> > >         }
> > >
> > >         return 0;
> > > }
> > >
> > > $ gcc tmp.c && ./a.out
> > > outer x=1
> > > inner x=0
> > >
> > > Other than that:
> > > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > >
> > > >
> > > > -             if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
> > > > +             if (prog_type == BPF_PROG_TYPE_UNSPEC) {
> > > >                       const char *sec_name = bpf_program__title(pos, false);
> > > >
> > > >                       err = libbpf_prog_type_by_name(sec_name, &prog_type,
> > > > --
> > > > 2.17.1
> > > >
