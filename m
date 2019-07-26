Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDCF77393
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfGZVmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:42:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40597 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGZVmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:42:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so54042671qtn.7;
        Fri, 26 Jul 2019 14:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SCTKIdPrtnXrsQ9utu/qLU47WG+4TA5IDdCWht7vPsA=;
        b=cp3JhUiKDq7bySxu3vj6uNzV+rKX39vs8VgudglyqYDY2cLkdJPhldnfHo8pfp8dGU
         UvbB4rRIKnUMsexsju7detoq0+wdS26MXvlrwh8ne5NC/MHEn4lIjc1sRx0qV1mvj3a0
         8WS4nITvwP6jQGNWlYH4FBU/DY6E2Y+lFbRkoXs9nMVjEx98A7kx8hS57Zfx/ZFfSH4S
         jpr4L1yGvP7lc1/npfSkPpYBPE8mHVFVq/RmnzPL6vb8jpdVkBlZrQqugY4USnED+O2A
         ewRPy01ybhaJjRuP3U9m97oV0iNw3MgrBdFJzTqrGQANr9mzFMhDmp5S8wdXeO2jl7Hd
         P94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCTKIdPrtnXrsQ9utu/qLU47WG+4TA5IDdCWht7vPsA=;
        b=Kf9vau5+d5CEEShvqf9OFR3OX7raaml2tqXuTTmv9OlIb89HfxQFgFyZu2DRVJeOZj
         D+nSya72uccamSAVSLlz/Ltb1Po7dK46RdLT3aNvAMNM5r7mAsK19U/JSM+R7KWVmjlN
         wBJAXOzBPFhHxPYTmjE42iW4a7r0yvLw6mYMrxFVrVKpaL+fH6G3Qsy2V3C0o/UXsiBP
         LlNX33YbCS3r/d8c0irUGeUfyTJOycQW3bj3p/wEM6K/6DDbAB/1+pwBhA8I1mHBki+Z
         lQ5fVU06Zz9P54OwPkVYLYCwZREfwmkX9WuivWltKaVZ7qEgL6gHToI+ACzg2uXN31Tc
         Gx1Q==
X-Gm-Message-State: APjAAAXW7j7fAvJhzMmWb57jQeCxGH2T2VXlgnibcn/PUFCUK990lz5Q
        MauGIBxWFsiPCbysDEWiaTJw8C4c4xzHKjq75pySgtb+
X-Google-Smtp-Source: APXvYqzP3bc9YAD1iIfXsgedjEger2H2VAxiUluVM2RFMZnP38IHeNISI9dRwRqkOQzHGQ8xW8uXUJb4JYEhDVua6os=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr66177739qvd.162.1564177355370;
 Fri, 26 Jul 2019 14:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-2-andriin@fb.com>
 <20190726212152.GA24397@mini-arch>
In-Reply-To: <20190726212152.GA24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 14:42:23 -0700
Message-ID: <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests/bpf: prevent headers to be
 compiled as C code
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 2:21 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > Apprently listing header as a normal dependency for a binary output
> > makes it go through compilation as if it was C code. This currently
> > works without a problem, but in subsequent commits causes problems for
> > differently generated test.h for test_progs. Marking those headers as
> > order-only dependency solves the issue.
> Are you sure it will not result in a situation where
> test_progs/test_maps is not regenerated if tests.h is updated.
>
> If I read the following doc correctly, order deps make sense for
> directories only:
> https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
>
> Can you maybe double check it with:
> * make
> * add new prog_tests/test_something.c
> * make
> to see if the binary is regenerated with test_something.c?

Yeah, tested that, it triggers test_progs rebuild.

Ordering is still preserved, because test.h is dependency of
test_progs.c, which is dependency of test_progs binary, so that's why
it works.

As to why .h file is compiled as C file, I have no idea and ideally
that should be fixed somehow.

I also started with just removing header as dependency completely
(because it's indirect dependency of test_progs.c), but that broke the
build logic. Dunno, too much magic... This works, tested many-many
times, so I was satisfied enough :)

>
> Maybe fix the problem of header compilation by having '#ifndef
> DECLARE_TEST #define DECLARE_TEST() #endif' in tests.h instead?

That's ugly, I'd like to avoid doing that.

>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 11c9c62c3362..bb66cc4a7f34 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -235,7 +235,7 @@ PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
> >  PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
> >  test_progs.c: $(PROG_TESTS_H)
> >  $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
> > -$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_H) $(PROG_TESTS_FILES)
> > +$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
> >  $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
> >       $(shell ( cd prog_tests/; \
> >                 echo '/* Generated header, do not edit */'; \
> > @@ -256,7 +256,7 @@ MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
> >  MAP_TESTS_FILES := $(wildcard map_tests/*.c)
> >  test_maps.c: $(MAP_TESTS_H)
> >  $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> > -$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_H) $(MAP_TESTS_FILES)
> > +$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
> >  $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
> >       $(shell ( cd map_tests/; \
> >                 echo '/* Generated header, do not edit */'; \
> > @@ -277,7 +277,7 @@ VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
> >  VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
> >  test_verifier.c: $(VERIFIER_TESTS_H)
> >  $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
> > -$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
> > +$(OUTPUT)/test_verifier: test_verifier.c | $(VERIFIER_TEST_FILES) $(VERIFIER_TESTS_H)
> >  $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
> >       $(shell ( cd verifier/; \
> >                 echo '/* Generated header, do not edit */'; \
> > --
> > 2.17.1
> >
