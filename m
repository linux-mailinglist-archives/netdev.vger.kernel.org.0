Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C78773CF
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfGZWBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:01:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45585 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfGZWBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:01:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so25357402pgp.12
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VCURgvPO2uyeKeMOwC50fJGBqS/hafAAfd0wm72aLhg=;
        b=fdamLSpQuFpmYWW7UddSqVwixOZTD5C9FelqbpUZnFR1hb7GGfk1kAf0hWjs7/iSjr
         mzQyJyVWD9heKK2bKmuQHblyvI1qFRbnwP36Xm4YPsP+6kGvrEbpJpk3mlBIcp/XIRxG
         9k2P0MkCR0O6KdiRU9ZBc1kdvaMYa8JuYaCfiJgsw6QdBwNEFx2Gsul9oeQvOXHKVbsQ
         gecx++tkt3UUiNbCZgDiLqofNr4ZLkHc7C7k0clmKQnOaaVALVXOlI9H73+FWksa4lLN
         4FV14QEfE/Jb3eBvTB5gbWkOn1+cPey54bxRUyN92aRqdvQvqJigWfOfg5gg4+tn6O8J
         A3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VCURgvPO2uyeKeMOwC50fJGBqS/hafAAfd0wm72aLhg=;
        b=pXu7xMcaJ5oJdL7Z6xjOncUwMuSiXbVdRGMWgk9zuEgdrLqneb5iiJ3VTKoKMu+TlC
         ADcJYIyig7QyrVHo1UFU/wr5+0FmmMDZBkobW7o/28mz+RSAOLBONgeDX1Eg4F5rE7Q3
         l7p3EzbenPor9JWHnz3Oal1i+PNy5CI+dyd0xhCoVBy4YcSZQvcvwPdTJJYHk6uKh/6M
         R1ElxtoWfA84O2I1EuGiT6Y5FEqgAj4vPAwpWfEe0Sr8QZQVDGACziy4TIYtVwhKOUn6
         L1v/sBAHoIkedweBUIvzesvnZEI0an6uOZX9rNFTeppl3awFXWtX39IH8fnCHSfU8tLP
         zH9Q==
X-Gm-Message-State: APjAAAWjvTKKPlqPFcemHLsmLd2sLzqbJpqSRAzUKlE7U1kxRWj1R4E7
        S1Gdw0tAh7rOI198EBdcc14=
X-Google-Smtp-Source: APXvYqxQr8en+h0Ls9Ch/mblDkNAUysruAtUjO9g3XiMTINHvVLrdAh1dhuojb6yUvXmkbL1DmkgBw==
X-Received: by 2002:a65:6256:: with SMTP id q22mr92925007pgv.408.1564178480847;
        Fri, 26 Jul 2019 15:01:20 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id x25sm77450829pfa.90.2019.07.26.15.01.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:01:20 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:01:19 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/9] selftests/bpf: prevent headers to be
 compiled as C code
Message-ID: <20190726220119.GE24397@mini-arch>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-2-andriin@fb.com>
 <20190726212152.GA24397@mini-arch>
 <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/26, Andrii Nakryiko wrote:
> On Fri, Jul 26, 2019 at 2:21 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/26, Andrii Nakryiko wrote:
> > > Apprently listing header as a normal dependency for a binary output
> > > makes it go through compilation as if it was C code. This currently
> > > works without a problem, but in subsequent commits causes problems for
> > > differently generated test.h for test_progs. Marking those headers as
> > > order-only dependency solves the issue.
> > Are you sure it will not result in a situation where
> > test_progs/test_maps is not regenerated if tests.h is updated.
> >
> > If I read the following doc correctly, order deps make sense for
> > directories only:
> > https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
> >
> > Can you maybe double check it with:
> > * make
> > * add new prog_tests/test_something.c
> > * make
> > to see if the binary is regenerated with test_something.c?
> 
> Yeah, tested that, it triggers test_progs rebuild.
> 
> Ordering is still preserved, because test.h is dependency of
> test_progs.c, which is dependency of test_progs binary, so that's why
> it works.
> 
> As to why .h file is compiled as C file, I have no idea and ideally
> that should be fixed somehow.
I guess that's because it's a prerequisite and we have a target that
puts all prerequisites when calling CC:

test_progs: a.c b.c tests.h
	gcc a.c b.c tests.h -o test_progs

So gcc compiles each input file.

I'm not actually sure why default dependency system that uses 'gcc -M'
is not working for us (see scripts/Kbuild.include) and we need to manually
add tests.h dependency. But that's outside of the scope..

> I also started with just removing header as dependency completely
> (because it's indirect dependency of test_progs.c), but that broke the
> build logic. Dunno, too much magic... This works, tested many-many
> times, so I was satisfied enough :)
Yeah, that's my only concern, too much magic already and we add
quite a bit more.

> > Maybe fix the problem of header compilation by having '#ifndef
> > DECLARE_TEST #define DECLARE_TEST() #endif' in tests.h instead?
> 
> That's ugly, I'd like to avoid doing that.
That's your call, but I'm not sure what's uglier: complicating already
complex make rules or making a header self contained.

> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 11c9c62c3362..bb66cc4a7f34 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -235,7 +235,7 @@ PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
> > >  PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
> > >  test_progs.c: $(PROG_TESTS_H)
> > >  $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
> > > -$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_H) $(PROG_TESTS_FILES)
> > > +$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
> > >  $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
> > >       $(shell ( cd prog_tests/; \
> > >                 echo '/* Generated header, do not edit */'; \
> > > @@ -256,7 +256,7 @@ MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
> > >  MAP_TESTS_FILES := $(wildcard map_tests/*.c)
> > >  test_maps.c: $(MAP_TESTS_H)
> > >  $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> > > -$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_H) $(MAP_TESTS_FILES)
> > > +$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
> > >  $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
> > >       $(shell ( cd map_tests/; \
> > >                 echo '/* Generated header, do not edit */'; \
> > > @@ -277,7 +277,7 @@ VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
> > >  VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
> > >  test_verifier.c: $(VERIFIER_TESTS_H)
> > >  $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
> > > -$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
> > > +$(OUTPUT)/test_verifier: test_verifier.c | $(VERIFIER_TEST_FILES) $(VERIFIER_TESTS_H)
> > >  $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
> > >       $(shell ( cd verifier/; \
> > >                 echo '/* Generated header, do not edit */'; \
> > > --
> > > 2.17.1
> > >
