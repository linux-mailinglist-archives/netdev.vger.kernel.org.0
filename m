Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA32D44672D
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhKEQoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhKEQoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:44:13 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05B8C061205
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 09:41:33 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id x10so7255283qta.6
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 09:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7q+jfQZAGOoXONkVvMr1O3APE+0mzw7wvLCpsLQ5yEE=;
        b=M93/lYttEyFoawlHqosPXsTKc9vnPLLS1CaYFC6cwRp1pt4bU26xFU84mhl43MskyS
         aL5GEM+oa6r4+DeXLeDBOXLjLSuuQEkeTDhbWFTyezdLD0SBYPPrt564s0fukZ51z4P2
         G3msCPkqZ987wC5gM4bVSeaAdi/6tzfoWp9kvMvSjqUvKvYqNxV6z1qDKfmBcrPEru3s
         rbbGkhPv4Bxh2hPAEbTo0enZszZ73W+cKCFe73xUKhTRMjXuiilQOdetsny4+oHgRGVu
         1GV1jJLCn7al3OdYHlmy+757C0RMkDcXgWSNgxMpdTcb8ACNWd6ogCEw8V3ZIEzK/nhY
         jXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7q+jfQZAGOoXONkVvMr1O3APE+0mzw7wvLCpsLQ5yEE=;
        b=djrAGPtOXXAKu7517Hz1wcio7mtAgv6DAxKHw6EZG2HNOnHZNCbZEYRXaR0E13RsD1
         cSUtFlMjMHkPA/kxdIBjTkRDc/JVzm1ZumpRTCg8D/eZnmhY5TkI9J68ijU9OSZCGzbl
         HQgTfoAc3iowyIR6vsJ3SHzyCvjTWU66xYtAPvPjLoJvvJ9ykkl/vDBOW6LKZfJnO0t0
         Cr1cwBsZyefgzfq4na09LxWeGt3r2GySdx1XlmFMCs9TxunFkub6jF4MNsK7GdgIPY8U
         JbwyRxUIWZ2t4BK6HGa8Px44kh64OgV9fsgBwAuqT12hQYrahJbc4RtGiq9J+7wDr+3J
         zULA==
X-Gm-Message-State: AOAM533RX7wOd8PJguY5x92w9f05waVZId9f3BotrXPcxtHqjQcWIm8y
        rgScQU0gBiQpRrp91hmN3jipPwFgAfDb05NVx0mBNw==
X-Google-Smtp-Source: ABdhPJytwGk/ktwCaGpyVGo3rm6JWsnKTqt2sq/45uOo/AJVXLNqDhNO7ePXdMn7li5+deCeTjT/pAZErLF/ZWMAWBo=
X-Received: by 2002:ac8:7dc5:: with SMTP id c5mr56453550qte.287.1636130492828;
 Fri, 05 Nov 2021 09:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211104160311.4028188-1-sdf@google.com> <6fbd1539-c343-2d03-d153-11d2684effd6@isovalent.com>
In-Reply-To: <6fbd1539-c343-2d03-d153-11d2684effd6@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 5 Nov 2021 09:41:22 -0700
Message-ID: <CAKH8qBvb87bGz9N9uOyCxHQheT+cWa9AyY2Uw8nfvrqgRZ1YGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: add option to enable libbpf's strict mode
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 4:02 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-11-04 09:03 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> > Otherwise, attaching with bpftool doesn't work with strict section names.
> >
> > Also:
> >
> > - by default, don't append / to the section name; in strict
> >   mode it's relevant only for a small subset of prog types
> > - print a deprecation warning when requested to pin all programs
> >
> > + bpftool prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> > Warning: pinning by section name is deprecated, use --strict to pin by function name.
> > See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> >
> > + bpftool prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> > Warning: pinning by section name is deprecated, use --strict to pin by function name.
> > See: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
> >
> > + bpftool --strict prog loadall tools/testing/selftests/bpf/test_probe_user.o /sys/fs/bpf/kprobe type kprobe
> > + bpftool --strict prog loadall tools/testing/selftests/bpf/xdp_dummy.o /sys/fs/bpf/xdp type xdp
> >
> > Cc: Quentin Monnet <quentin@isovalent.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Hi and thanks Stanislav! I have some reservations on the current
> approach, though.
>
> I see the new option is here to avoid breaking the current behaviour.
> However:
>
> - Libbpf has the API break scheduled for v1.0, and at this stage we
> won't be able to avoid breakage in bpftool's behaviour. This means that,
> eventually, "bpftool prog loadall" will load functions by func name and
> not section name, that section names with garbage prefixes
> ('SEC("xdp_my_prog")') will be rejected, and that maps with extra
> attributes in their definitions will be rejected. And save for the
> pinning path difference, we won't be able to tell from bpftool when this
> happens, because this is all handled by libbpf.
>
> - In that context, I'd rather have the strict behaviour being the
> default. We could have an option to restore the legacy behaviour
> (disabling strict mode) during the transition, but I'd rather avoid
> users starting to use everywhere a "--strict" option which becomes
> either mandatory in the future or (more likely) a deprecated no-op when
> we switch to libbpf v1.0 and break legacy behaviour anyway.
>
> - If we were to keep the current option, I'm not a fan of the "--strict"
> name, because from a user point of view, I don't think it reflects well
> the change to pinning by function name, for example. But given that the
> option interferes with different aspects of the loading process, I don't
> really have a better suggestion :/.

Yeah, not sure what's the best way here. Strict by default will break
users, but at least we can expect some action. Non-strict by default
will most likely not cause anybody to add --strict or react to that
warning.

I agree with your point though regarding --strict being default at
some point and polluting every bpftool call with it doesn't look good,
so I'll try to switch to strict by default in v2.

RE naming: we can use --legacy-libbpf instead, but it also doesn't
really tell what the real changes are.

> Aside from the discussion on this option, the code looks good. The
> optional '/' on program types on the command line works well, thanks for
> preserving the behaviour on the CLI. Please find also a few more notes
> below.
>
> > ---
> >  .../bpftool/Documentation/common_options.rst  |  6 +++
> >  tools/bpf/bpftool/main.c                      | 13 +++++-
> >  tools/bpf/bpftool/main.h                      |  1 +
> >  tools/bpf/bpftool/prog.c                      | 40 +++++++++++--------
> >  4 files changed, 43 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
> > index 05d06c74dcaa..28710f9005be 100644
> > --- a/tools/bpf/bpftool/Documentation/common_options.rst
> > +++ b/tools/bpf/bpftool/Documentation/common_options.rst
> > @@ -20,3 +20,9 @@
> >         Print all logs available, even debug-level information. This includes
> >         logs from libbpf as well as from the verifier, when attempting to
> >         load programs.
> > +
> > +-S, --strict
>
> The option does not affect all commands, and could maybe be moved to the
> pages of the relevant commands. I think that "prog" and "map" are affected?

True, but probably still a good idea to exercise that strict mode
everywhere in the bpftool itself? To make sure other changes don't
break it in a significant way.

> > +       Use strict (aka v1.0) libbpf mode which has more stringent section
> > +       name requirements.
> > +       See https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#pinning-path-differences
>
> There is more than just the pinning difference. The stricter section
> name handling and the changes for map declarations (drop of non-BTF and
> of unknown attributes) should also affect the way bpftool can load
> objects. Even the changes in the ELF section processing might affect the
> resulting objects.

Ack. Will add a better description here to point to the overall list
of libbpf-1.0 changes.

> > +       for details.
> Note that if we add a command line option, we'd also need to add it to
> the interactive help message and bash completion:
>
> https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/main.h#L57
> https://elixir.bootlin.com/linux/v5.15/source/tools/bpf/bpftool/bash-completion/bpftool#L263

Thanks, will do!
