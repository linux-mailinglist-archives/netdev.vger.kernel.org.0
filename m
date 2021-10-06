Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959B24242EE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhJFQpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhJFQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:45:06 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FA3C061746;
        Wed,  6 Oct 2021 09:43:13 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id z5so6886476ybj.2;
        Wed, 06 Oct 2021 09:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H2Nxy5WQkjsv0PqqH9xg8BGM+6zsa6wq4n2ifRHLn5c=;
        b=RqaaDyTlCh+L73wdsWILeXqCPgbU9joOe2hkw6gTjcmkShQsxGPdXtqJrx6GuUBYUB
         wsivUOUY9XDQK0nfUujZ59SQsV4PC8WY2129SOAYU+EgtwUCRFkPkuSarf+wwU3ecIzv
         nK/St6xsYiJHyhybUENW6A6aYvypk7WuNfFQYzz/iGn7LwiDqtGz1NKN4RK2dPNyxmgf
         jOqXHFMqosF4U0fPPLQHkfkTLotg9NZfTRUbBB2I48B5gLSP8DPNs5ZpCrgRyCwJdEy4
         EdmOziwmB6q023sFPe4Ukeap+JEtRJasf45BkxWLz/OTfL2ySpCNLxh2Bmt/a8EZU6mI
         Euqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H2Nxy5WQkjsv0PqqH9xg8BGM+6zsa6wq4n2ifRHLn5c=;
        b=jJag+/Z3WURC4fiwHjSiDnrjPCv5I2TIHo8LaaBLGSWUNBjsFuUZ55TzdUniLzGWVF
         fCro7AWJz6pB8Z/ut8aBj0a6QP1DRIjmYvxsPhAbtdmJGJUSyCEeUuF+SfSQ6lJEVAhc
         I/1UX1PniPsoSYRAKwNy8Lgl+5PANcHXl0z8JHkaDt7G/J9xwGDgIsj9ZB9On2AHmggm
         nzpqkT+X+iis/TvKEFrt27tRvlriOIaKnYxObLhsKkHnJ5kNAAIzaD4zHcFU3qdQnMNb
         nMJXN+VS7ibT6l7kCk90nKg9WXX9lc8QZfOCxjQ5opMPg2Ce7cAsCKgSAO//FLntnS3k
         LuVA==
X-Gm-Message-State: AOAM532mF06/qgwyEUiAf58k4Q4tOR7RQQkQdY+o8juOdgzXhYj07E98
        wibpY4WL7azeGXn+My7qoSxQYy4DXrrWqFKbNn38Mmyz02M=
X-Google-Smtp-Source: ABdhPJzl4SjSCR2BX6hSFEmdhv6SfU76BzgdqDTTN/UXJMl6DCh+mu/S1KveJv6qphJjgA9G+oybQ/h5LkBX/1HzG5w=
X-Received: by 2002:a25:1884:: with SMTP id 126mr30028311yby.114.1633538592883;
 Wed, 06 Oct 2021 09:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com> <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain>
In-Reply-To: <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 09:43:01 -0700
Message-ID: <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > >
> > > Since the code assumes in various places that BTF fd for modules is
> > > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> > > fd 0 being free for allocation is usually an application error, it is
> > > still possible that we end up getting fd 0 if the application explicitly
> > > closes its stdin. Deal with this by getting a new fd using dup and
> > > closing fd 0.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index d286dec73b5f..3e5e460fe63e 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
> > >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> > >                         return err;
> > >                 }
> > > +               /* Make sure module BTF fd is never 0, as kernel depends on it
> > > +                * being > 0 to distinguish between vmlinux and module BTFs,
> > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> > > +                */
> > > +               if (!fd) {
> > > +                       fd = dup(0);
> >
> > This is not the only place where we make assumptions that fd > 0 but
> > technically can get fd == 0. Instead of doing such a check in every
> > such place, would it be possible to open (cheaply) some FD (/dev/null
> > or whatever, don't know what's the best file to open), if we detect
> > that FD == 0 is not allocated? Can we detect that fd 0 is not
> > allocated?
> >
>
> We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
> open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I

yeah, I like this idea, let's go with it

> leave it lingering, or should I close(0) if we created it on destroy?

I don't mind leaving it open indefinitely, but can you please check
that it doesn't trigger LeakSanitizer errors?

>
> > Doing something like that in bpf_object__open() or bpf_object__load()
> > would make everything much simpler and we'll have a guarantee that fd
> > == 0 is not going to be allocated (unless someone accidentally or not
> > accidentally does close(0), but that's entirely different story).
> >
> > > +                       if (fd < 0) {
> > > +                               err = -errno;
> > > +                               pr_warn("failed to dup BTF object #%d FD 0 to FD > 0: %d\n", id, err);
> > > +                               close(0);
> > > +                               return err;
> > > +                       }
> > > +                       close(0);
> > > +               }
> > >
> > >                 len = sizeof(info);
> > >                 memset(&info, 0, sizeof(info));
> > > --
> > > 2.33.0
> > >
>
> --
> Kartikeya
