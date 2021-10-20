Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F35435613
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJTWtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTWtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 18:49:22 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35155C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:47:06 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id r15so4648587qkp.8
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 15:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OcdaLpyzI+d3Ps5CvXGV0e/TLiMXLJLHeYv3RgrgEHw=;
        b=PNlGG/fxqdEgTxPKs0sU8vNqffXcoVrXqBh4flSCQ+oMDy3zc4c+QUVO/8TUVxG7JM
         KDLtEhL+kSmNwEaO/NAg0qrNpWr1nVGM5CpPojs7HWty3oIRi39RBlZX+yqJ4x1F1W7+
         NZqg4hHflYPkYLp5p0nzPTDAoSxoH4F+M6iWAF0rcA9LNk8j5Ljq/kIoGus3XOVqMoLE
         pOEsEcUprxka6Fq4aBPU6YnHEFyA336ppJ8sMzmPJHEFOuHDQTOO0G3tZCwg/4vT68Qd
         eqtJn2WfazTRROgOiog4yxePGIyb4PeKHXQkkt2nz2qpq1lcOMHevKNUl4+cujFa1tBm
         0X2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcdaLpyzI+d3Ps5CvXGV0e/TLiMXLJLHeYv3RgrgEHw=;
        b=S4HLUjCWfs+U2hEnY1JMwMYlo2XzvHqbTkwifBCm64g2E1o5DLjBxXPO+l7IYipgnz
         aobmFYzvIXNs146aqoI6MT799yJCU6BoUpMmApjEr4UBNu6GjMjrEXO5TJaX65zAJvUz
         JzS358U5Ku+abwUgJIWJkzwlbFRL5lD9GBySIX2gkZXub9MtTJ4SDODsvsOeU3MQwotX
         ly3D6sAKEDUDkshct9QsGDRnYYk17Jg7YpsIEZ2vOrt7V+4FspY16FU3N8KCFEARAxw+
         LRtc0e8T0Npj8mhPqflTuS2U+mDYLoJbenCoUJmn4H2DnkHviVxV9FqRWaMOd/KTAhZO
         c3GQ==
X-Gm-Message-State: AOAM532RZErdJwJ3q7ytSeLgUh+ZuOr0rjkgDITHEfRU0fEEfl8mGJT8
        HXvsi4HQil+LB7zCHho6nyXGOgsiju1TSuysY9G1mAXeHCRVkA==
X-Google-Smtp-Source: ABdhPJyrreYBubm8EMRYX9mT3qrI+i5Z2qCIuVTyoRhLqgL99wwIwJ4E5yZG5tIqW0jKi2mbIGnEKlIOSU6QMp344ns=
X-Received: by 2002:a37:6194:: with SMTP id v142mr1640866qkb.351.1634770025152;
 Wed, 20 Oct 2021 15:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com> <20211012161544.660286-3-sdf@google.com>
 <CAEf4Bza3wYs7sjtp2UNDhT58yH+49C5sQonVssbnDko7kkpMaA@mail.gmail.com>
In-Reply-To: <CAEf4Bza3wYs7sjtp2UNDhT58yH+49C5sQonVssbnDko7kkpMaA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 20 Oct 2021 15:46:54 -0700
Message-ID: <CAKH8qBsDGPMnw=302poLcv1eoY+mDVLDttUc3HPQXJoVddbC6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpftool: don't append / to the progtype
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:12 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 12, 2021 at 9:15 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Otherwise, attaching with bpftool doesn't work with strict section names.
> >
> > Also, switch to libbpf strict mode to use the latest conventions
> > (note, I don't think we have any cli api guarantees?).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/bpf/bpftool/main.c |  4 ++++
> >  tools/bpf/bpftool/prog.c | 15 +--------------
> >  2 files changed, 5 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > index 02eaaf065f65..8223bac1e401 100644
> > --- a/tools/bpf/bpftool/main.c
> > +++ b/tools/bpf/bpftool/main.c
> > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> >         block_mount = false;
> >         bin_name = argv[0];
> >
> > +       ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
>
> Quentin, any concerns about turning strict mode for bpftool? Either
> way we should audit bpftool code to ensure that at least error
> handling is done properly (see my comments on Dave's patch set about
> == -1 checks).
>
> > +       if (ret)
> > +               p_err("failed to enable libbpf strict mode: %d", ret);
> > +
> >         hash_init(prog_table.table);
> >         hash_init(map_table.table);
> >         hash_init(link_table.table);
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index 277d51c4c5d9..17505dc1243e 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >
> >         while (argc) {
> >                 if (is_prefix(*argv, "type")) {
> > -                       char *type;
> > -
> >                         NEXT_ARG();
> >
> >                         if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> > @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >                         if (!REQ_ARGS(1))
> >                                 goto err_free_reuse_maps;
> >
> > -                       /* Put a '/' at the end of type to appease libbpf */
> > -                       type = malloc(strlen(*argv) + 2);
> > -                       if (!type) {
> > -                               p_err("mem alloc failed");
> > -                               goto err_free_reuse_maps;
> > -                       }
> > -                       *type = 0;
> > -                       strcat(type, *argv);
> > -                       strcat(type, "/");
> > -
> > -                       err = get_prog_type_by_name(type, &common_prog_type,
> > +                       err = get_prog_type_by_name(*argv, &common_prog_type,
> >                                                     &expected_attach_type);
>
> Question not specifically to Stanislav, but anyone who's using bpftool
> to load programs. Do we need to support program type overrides? Libbpf
> has been inferring the program type for a long time now, are there
> realistic use cases where this override logic is necessary? I see
> there is bpf_object__for_each_program() loop down the code, it
> essentially repeats what libbpf is already doing on
> bpf_object__open(), why keep the duplicated logic?
>
> libbpf_prog_type_by_name() is also a bad idea (IMO) and I'd like to
> get rid of that in libbpf 1.0, so if we can stop using that from
> bpftool, it would be great.
>
> Thoughts?

IMO it's all legacy at this point. If we can remove / simplify by
calling higher level abstraction from libbpf - there is no reason not
to do it.
