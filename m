Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8560C43AB4E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhJZEaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 00:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhJZEaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 00:30:17 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C03C061745;
        Mon, 25 Oct 2021 21:27:53 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 67so31531617yba.6;
        Mon, 25 Oct 2021 21:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zTaGRoTAO+tE6H4Ja6qo7X3LLMJyYe1Khk9jDRfw24=;
        b=Wt42WYxDYqMxxNuzEgG525IinGRk06ceqh4uDi3NcNn20JM7Ezb3oGwXRERklUnXyK
         bwcsnbZdARD+WfwUIM4SmimWOmpaqgFm6BMozdHfWhcraPvpEDQ5Ks42+f1oD85ryId8
         xy/jCcfa7cKdU3IjOhSUONMckuKv1pCcEijpjWJXe2gvoSEcSfO9rrbSaiHSDpMLcxkO
         daKEiHBvDzQCYzYe71ZzIUWu0Nv+Hdo3V6Uh3JJdC2QBanLLMU3B8Uw2UQwjqTLE4FPO
         e8w3yYKwd9S0RTm01cM1f3+8fi7vkGW5o+2YcnmjC/iop4oUCvoKWXXBm45j42OA8PHm
         1cmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zTaGRoTAO+tE6H4Ja6qo7X3LLMJyYe1Khk9jDRfw24=;
        b=f636tI/JsWt3epYzjGNKfTaoqu4f580VrAfJZKn7nrBDRrePEDE5UPFPk/8AZX0Xsk
         rlpB7OQI4wyEBV7r5+FMw5uQPBYoqDniGnMeAklKI47J4ELOBH/gqkSMR3Q4v3z8op9b
         bOPb7qlphr0MFiGnY7+O+MNdjMDTcUBkXzloVba4HWdwu8hix1k2N5BWf+1z+8NfVmSe
         gc3eapnPvIi2kHIq3qUQtHVg+1JcHjIc7W3Hr14vjwFOJLKiAHlUKt/03fAcPE3CxbGA
         kqlSDEbA8c2vLskGKwZaQro2CYM/QXg5G1lOqvjno+F/OEByRHEEIk4Ek5gPkU9wXA5K
         ay/g==
X-Gm-Message-State: AOAM532Bvg9sK+q2g8TtMLQBeSJKVj6ohmPUgJyyZZCVnt6j3MKIBKCg
        ZIy1XE5mHXpqrIH9Tj/1y5iMLgIWIvGwmWgvFOE=
X-Google-Smtp-Source: ABdhPJwx/C6b59emScdUDcoPKKyLrXRMjcHEOXZlnGPcNXOtzjmHWgG19bXVNJZBrBJ3YR86L3K1k9chu+yuI15VBhg=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr20291800ybh.267.1635222473000;
 Mon, 25 Oct 2021 21:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com> <20211011155636.2666408-2-sdf@google.com>
 <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch> <CAKH8qBuR4bYn1POgu0TF428vApknvMNPAng5qMuiKXCpcg8CQQ@mail.gmail.com>
In-Reply-To: <CAKH8qBuR4bYn1POgu0TF428vApknvMNPAng5qMuiKXCpcg8CQQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 21:27:42 -0700
Message-ID: <CAEf4BzaUFAVZz2PHePbF4ypBHusUJEZi5W9HL0gT_fy1T71itg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
To:     Stanislav Fomichev <sdf@google.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 8:59 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Oct 22, 2021 at 10:05 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Stanislav Fomichev wrote:
> > > Otherwise, attaching with bpftool doesn't work with strict section names.
> > >
> > > Also, switch to libbpf strict mode to use the latest conventions
> > > (note, I don't think we have any cli api guarantees?).
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/bpf/bpftool/main.c |  4 ++++
> > >  tools/bpf/bpftool/prog.c | 15 +--------------
> > >  2 files changed, 5 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > > index 02eaaf065f65..8223bac1e401 100644
> > > --- a/tools/bpf/bpftool/main.c
> > > +++ b/tools/bpf/bpftool/main.c
> > > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> > >       block_mount = false;
> > >       bin_name = argv[0];
> > >
> > > +     ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > > +     if (ret)
> > > +             p_err("failed to enable libbpf strict mode: %d", ret);
> > > +
> >
> > Would it better to just warn? Seems like this shouldn't be fatal from
> > bpftool side?
> >
> > Also this is a potentially breaking change correct? Programs that _did_
> > work in the unstrict might suddently fail in the strict mode? If this
> > is the case whats the versioning plan? We don't want to leak these
> > type of changes across multiple versions, idealy we have a hard
> > break and bump the version.
> >
> > I didn't catch a cover letter on the series. A small
> > note about versioning and upgrading bpftool would be helpful.
>
> Yeah, it is a breaking change, every program that has non-strict
> section names will be rejected.
>
> I mentioned that in the bpftool's commit description:
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).
>
> So I'm actually not sure what's the best way to handle this migration
> and whether we really provide any cli guarantees to the users. I was
> always assuming that bpftool is mostly for debugging/introspection,
> but not sure.
>
> As Andrii suggested in another email, I can add a flag to disable this
> strict mode. Any better ideas?

Maybe the other way around for the transition period. Add a --strict
flag to turn on libbpf strict mode? This follows libbpf's opt-in
approach to breaking change. We can also emit warnings when people are
trying to pin programs and mention that they should switch to --strict
as in some future version this will be the default. Would that be
better for users?

>
>
>
>
> > >       hash_init(prog_table.table);
> > >       hash_init(map_table.table);
> > >       hash_init(link_table.table);
> > > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > > index 277d51c4c5d9..17505dc1243e 100644
> > > --- a/tools/bpf/bpftool/prog.c
> > > +++ b/tools/bpf/bpftool/prog.c
> > > @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> > >
> > >       while (argc) {
> > >               if (is_prefix(*argv, "type")) {
> > > -                     char *type;
> > > -
> > >                       NEXT_ARG();
> > >
> > >                       if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> > > @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> > >                       if (!REQ_ARGS(1))
> > >                               goto err_free_reuse_maps;
> > >
> > > -                     /* Put a '/' at the end of type to appease libbpf */
> > > -                     type = malloc(strlen(*argv) + 2);
> > > -                     if (!type) {
> > > -                             p_err("mem alloc failed");
> > > -                             goto err_free_reuse_maps;
> > > -                     }
> > > -                     *type = 0;
> > > -                     strcat(type, *argv);
> > > -                     strcat(type, "/");
> > > -
> > > -                     err = get_prog_type_by_name(type, &common_prog_type,
> > > +                     err = get_prog_type_by_name(*argv, &common_prog_type,
> > >                                                   &expected_attach_type);
> > > -                     free(type);
> > >                       if (err < 0)
> > >                               goto err_free_reuse_maps;
> >
> > This wont potentially break existing programs correct? It looks like
> > just adding a '/' should be fine.
> >
> > Thanks,
> > John
