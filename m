Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7103CCAEB
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhGRVdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhGRVda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 17:33:30 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC456C061762;
        Sun, 18 Jul 2021 14:30:31 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r135so24613097ybc.0;
        Sun, 18 Jul 2021 14:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IlvWyDGxD9tWgU/FomNaOA1mZxQ0zxCTG62cnhWUquM=;
        b=Gdj50dY5VcPs48R7bq2KSt1+H35bk6T2ODn/0BZXmh3A1nS/F17UCdEtyjNBYBlgG/
         rwJcmUuUDj8sewzMKilnyjW8ljsGJR0Iy3kI8fMvFxtQRqjjTFHtqnsqQNPCPnWvfjyV
         K/ZLj4UXQToZW9rlZXH4xuJ2UkpUfMdCQhIgRon6MO9//Kce9j6Wq+2DyHrgMxrmzJrL
         j/2tF6g0osBUK7KIz4DW2b396TtjKt0eRXqyB6XCwgF6Bgjd2/U6t0BQIlxunuKrZc/G
         z0mHBjCzzLgDy+H/eKELU65aHAUOYUcPUorvDJCqmNXPukZ+E4cii4rzZdRqjDmWT8fj
         DLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IlvWyDGxD9tWgU/FomNaOA1mZxQ0zxCTG62cnhWUquM=;
        b=rioBNc9a7YNAOp/f8knMTL9PX2AWeUSxAIOONkxA6h52zWJMxjpVC5kpI9pIVKboLI
         zCv3GQZfz/cOatbaY4wP2Sqzh792oaW3yGRztyktyB3hBn+pU9d8sqzBm7sFAi/KNhzR
         ukvjBSycfHxMV69sZqbPV/ax7svDj/U9gRePi+NG9YL/DRwZ1Fv/LkPnDklYFQKZe77H
         VRt8chRsrGWa3T6jHJrFyUA9VzaoHJoBK0tKfwsnaHI/ypMzmv+8pG+1hLatxIGFHH5x
         qodTD/SBXinJ9FkhsLnI6DJSlohVvS2FVC+f/RETBLYRjoBvCncvlCpcesqus2wktMoE
         D/sA==
X-Gm-Message-State: AOAM531nwqHNqskhpDG9cnGnCOnGoFEDRTytulkOLogf84rYnjybWpxk
        Ov0WXFsobSUOhtWQPz4NM4T5losXxq6CY4LDgzE=
X-Google-Smtp-Source: ABdhPJy4M4IUM4nYo8+Pohr4pHTdkI2TRZHzehqwDfDmScZXlkox/fCELKiA5J2KnkxdZLgoppiwsg29R3KTlygK9Fg=
X-Received: by 2002:a25:3787:: with SMTP id e129mr26059448yba.459.1626643831141;
 Sun, 18 Jul 2021 14:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210714094400.396467-1-jolsa@kernel.org> <20210714094400.396467-7-jolsa@kernel.org>
 <CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com> <YPSBs51JR5cWVuc1@krava>
In-Reply-To: <YPSBs51JR5cWVuc1@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 18 Jul 2021 14:30:20 -0700
Message-ID: <CAEf4BzajXLe7Yx+r024A9bhaR6Dwy+t+n2sqA=8NXQ9m0sp1mQ@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 6/8] libbpf: Add bpf_program__attach_kprobe_opts
 function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 12:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Jul 16, 2021 at 06:41:59PM -0700, Andrii Nakryiko wrote:
> > On Wed, Jul 14, 2021 at 2:45 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding bpf_program__attach_kprobe_opts that does the same
> > > as bpf_program__attach_kprobe, but takes opts argument.
> > >
> > > Currently opts struct holds just retprobe bool, but we will
> > > add new field in following patch.
> > >
> > > The function is not exported, so there's no need to add
> > > size to the struct bpf_program_attach_kprobe_opts for now.
> >
> > Why not exported? Please use a proper _opts struct just like others
> > (e.g., bpf_object_open_opts) and add is as a public API, it's a useful
> > addition. We are going to have a similar structure for attach_uprobe,
> > btw. Please send a follow up patch.
>
> there's no outside user.. ok

because there is no API :) I've seen people asking about the ability
to attach to kprobe+offset in some PRs.

>
> >
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++---------
> > >  1 file changed, 25 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 88b99401040c..d93a6f9408d1 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -10346,19 +10346,24 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> > >         return pfd;
> > >  }
> > >
> > > -struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> > > -                                           bool retprobe,
> > > -                                           const char *func_name)
> > > +struct bpf_program_attach_kprobe_opts {
> >
> > when you make it part of libbpf API, let's call it something shorter,
> > like bpf_kprobe_opts, maybe? And later we'll have bpf_uprobe_opts for
> > uprobes. Short and unambiguous.
>
> ok
>
> jirka
>
> >
> > > +       bool retprobe;
> > > +};
> > > +
> > > +static struct bpf_link*
> > > +bpf_program__attach_kprobe_opts(struct bpf_program *prog,
> > > +                               const char *func_name,
> > > +                               struct bpf_program_attach_kprobe_opts *opts)
> > >  {
> > >         char errmsg[STRERR_BUFSIZE];
> > >         struct bpf_link *link;
> > >         int pfd, err;
> > >
> >
> > [...]
> >
>
