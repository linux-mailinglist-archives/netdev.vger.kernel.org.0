Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB64468A6
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKESyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhKESyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 14:54:06 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1822C061714;
        Fri,  5 Nov 2021 11:51:26 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g17so863651ybe.13;
        Fri, 05 Nov 2021 11:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3M29MgklAqUlOwJPSRT2uIdBPNCR+GuSxw448+HhnaA=;
        b=IBt/KKc9bRW/kuy/DONEAZR1kA/ZuypECwcunXQPcFln7URkRE9Pvei2+E6B5duHbF
         LfPTbJH2gCu8PDppb62vLH22KskjWDlFsXgpuBwm6RLN3YLhfaOXEzvgux8S22oQGUQl
         ApBB0MhEbqKkHRhRJm4lefEZ0g7l+3BfHov72tDiktP8UuHxaNRp8mF9HDV1Fy0ItBHl
         ppnV0P3DXNvPRA+4jsCmA3TqbkuMgohnC0JSlyJbguwS29hQyI1D779sDL2l9/kh5acO
         PC1bjHNo4e+bwUbvEOriTR/UZSJPCE10+qPQjttUiZsi/tU8aN2EQ9UoCP+moNIhMxmP
         /59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3M29MgklAqUlOwJPSRT2uIdBPNCR+GuSxw448+HhnaA=;
        b=zxmlXC0bLo4pfBKYPus9NCqIawlKYD/23ORpY051pK/drczfJZDJtaCbYyO3YNYhTX
         UJKyXCBVVqWsnjLvEwbSEAZ6JQUaVMXffpoYZQ7haDRxDhOe5M+Hla1nH+Z3oQ21HZvv
         v/gvdNoj43btx0dA3kOCecKVY1Bi1rIAUiyxfYUn1kmKnnnkZIdhKcG1CAKDAc53aCMv
         MCNr7LkgnezeQ18+SbOHsIdKyzD4s2HDzhFjG1ocZe1JRyMtNW8TDmGywxiztvJLFS0Y
         5fPW+M4yVPRha9LI0QnHYAjdB/JLy6ql4Ry6ZlkDHWVD/FnozFmH43HOst60VFaTgRD/
         CQgQ==
X-Gm-Message-State: AOAM53263Jkj3bnKCkXevZdIjmvMlSvE4kNoTrj+4KKqwRfwUktKq/tP
        Q1x7aA/B2qtDhx3RNzihKT9CiU2h8GWtV9Jbgt4=
X-Google-Smtp-Source: ABdhPJzXVtLrmclooZxfMsMbwW96ZSYDs7WmYs98WuL8xKErBylm0hGWQIqn5AMJELH3QvXI9PbgGjsMMgBCoV6h3TY=
X-Received: by 2002:a25:d16:: with SMTP id 22mr56792692ybn.51.1636138286042;
 Fri, 05 Nov 2021 11:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211104160311.4028188-1-sdf@google.com> <6fbd1539-c343-2d03-d153-11d2684effd6@isovalent.com>
 <CAKH8qBvb87bGz9N9uOyCxHQheT+cWa9AyY2Uw8nfvrqgRZ1YGw@mail.gmail.com>
In-Reply-To: <CAKH8qBvb87bGz9N9uOyCxHQheT+cWa9AyY2Uw8nfvrqgRZ1YGw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Nov 2021 11:51:14 -0700
Message-ID: <CAEf4Bzav_FpYQisgqsgfTbMyin0Kwqi=nGukaFaYKuWKDXr02Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: add option to enable libbpf's strict mode
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 9:41 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Nov 5, 2021 at 4:02 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > 2021-11-04 09:03 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> > > Otherwise, attaching with bpftool doesn't work with strict section names.
> > >
> > > Also:
> > >
> > > - by default, don't append / to the section name; in strict
> > >   mode it's relevant only for a small subset of prog types
> > > - print a deprecation warning when requested to pin all programs
> > >
> > > + bpftool prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> > > Warning: pinning by section name is deprecated, use --strict to pin by function name.
> > > See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> > >
> > > + bpftool prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> > > Warning: pinning by section name is deprecated, use --strict to pin by function name.
> > > See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> > >
> > > + bpftool --strict prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> > > + bpftool --strict prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> > >
> > > Cc: Quentin Monnet <quentin@isovalent.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Hi and thanks Stanislav! I have some reservations on the current
> > approach, though.
> >
> > I see the new option is here to avoid breaking the current behaviour.
> > However:
> >
> > - Libbpf has the API break scheduled for v1.0, and at this stage we
> > won't be able to avoid breakage in bpftool's behaviour. This means that,
> > eventually, "bpftool prog loadall" will load functions by func name and
> > not section name, that section names with garbage prefixes
> > ('SEC("xdp_my_prog")') will be rejected, and that maps with extra
> > attributes in their definitions will be rejected. And save for the
> > pinning path difference, we won't be able to tell from bpftool when this
> > happens, because this is all handled by libbpf.
> >
> > - In that context, I'd rather have the strict behaviour being the
> > default. We could have an option to restore the legacy behaviour
> > (disabling strict mode) during the transition, but I'd rather avoid
> > users starting to use everywhere a "--strict" option which becomes
> > either mandatory in the future or (more likely) a deprecated no-op when
> > we switch to libbpf v1.0 and break legacy behaviour anyway.
> >
> > - If we were to keep the current option, I'm not a fan of the "--strict"
> > name, because from a user point of view, I don't think it reflects well
> > the change to pinning by function name, for example. But given that the
> > option interferes with different aspects of the loading process, I don't
> > really have a better suggestion :/.
>
> Yeah, not sure what's the best way here. Strict by default will break
> users, but at least we can expect some action. Non-strict by default
> will most likely not cause anybody to add --strict or react to that
> warning.
>
> I agree with your point though regarding --strict being default at
> some point and polluting every bpftool call with it doesn't look good,
> so I'll try to switch to strict by default in v2.
>
> RE naming: we can use --legacy-libbpf instead, but it also doesn't
> really tell what the real changes are.

maybe --relaxed or just --legacy then?

We can also have a warning or information message pointing to [0] for
details of what is changing? And feel free to contribute with whatever
important things that should be mentioned there as well.

  [0] https://github.com/libbpf/libbpf/wiki/Libbpf-1.0-migration-guide

>
> > Aside from the discussion on this option, the code looks good. The
> > optional '/' on program types on the command line works well, thanks for
> > preserving the behaviour on the CLI. Please find also a few more notes
> > below.
> >
> > > ---
> > >  .../bpftool/Documentation/common_options.rst  |  6 +++
> > >  tools/bpf/bpftool/main.c                      | 13 +++++-
> > >  tools/bpf/bpftool/main.h                      |  1 +
> > >  tools/bpf/bpftool/prog.c                      | 40 +++++++++++--------
> > >  4 files changed, 43 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
> > > index 05d06c74dcaa..28710f9005be 100644
> > > --- a/tools/bpf/bpftool/Documentation/common_options.rst
> > > +++ b/tools/bpf/bpftool/Documentation/common_options.rst
> > > @@ -20,3 +20,9 @@
> > >         Print all logs available, even debug-level information. This includes
> > >         logs from libbpf as well as from the verifier, when attempting to
> > >         load programs.
> > > +
> > > +-S, --strict
> >
> > The option does not affect all commands, and could maybe be moved to the
> > pages of the relevant commands. I think that "prog" and "map" are affected?
>
> True, but probably still a good idea to exercise that strict mode
> everywhere in the bpftool itself? To make sure other changes don't
> break it in a significant way.
>
> > > +       Use strict (aka v1.0) libbpf mode which has more stringent section
> > > +       name requirements.
> > > +       See https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> >
> > There is more than just the pinning difference. The stricter section
> > name handling and the changes for map declarations (drop of non-BTF and
> > of unknown attributes) should also affect the way bpftool can load
> > objects. Even the changes in the ELF section processing might affect the
> > resulting objects.
>
> Ack. Will add a better description here to point to the overall list
> of libbpf-1.0 changes.
>
> > > +       for details.
> > Note that if we add a command line option, we'd also need to add it to
> > the interactive help message and bash completion:
> >
> > https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/main.h#L57
> > https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/bash-completion/bpftool#L263
>
> Thanks, will do!
