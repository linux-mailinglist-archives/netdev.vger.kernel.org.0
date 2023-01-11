Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9316663A6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbjAKTUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbjAKTUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:20:18 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52E9B12;
        Wed, 11 Jan 2023 11:20:17 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vm8so39326293ejc.2;
        Wed, 11 Jan 2023 11:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xLIpamm73K4ie4BXAhLkIUoPzYibegmROoe6ODkct54=;
        b=PHqeMcNbA954+TtjRJ6R2SOZREY1UoHBFQLGf6oMO7k9NnjdWi+F8QUGsl4C8XLl4I
         v1OyZ0nsAwT0gjMgZ8Y+miWo9ycrdNKrJ3gUFJk8gOIqlF4IgidL4jF2C+YGG3VLEidc
         Rl+VN1jYUTJQ6KvpQtrDTpReUP8QLMqxH5SRNr5+DD5oQbDhBdZ5n+hLUIldqY7aqxxd
         Or0dma5VjxnNbfNG7LIHFKvyqKxmDYwSdN8ENFT26z9+476DZxcH9OOhRy5U0Ajx733t
         wkAaU0ML2Pdr+MJDXqcFPYC8vQ6N04AcwULk8P8nxWKln/kHkTEEiwqD4RER9A6vAyR0
         7FGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLIpamm73K4ie4BXAhLkIUoPzYibegmROoe6ODkct54=;
        b=BJUQSVk62CKaIBsYuuaCyHSQNVpOW9Q9R9ZWiNMGufmfygX5hv3hkgfGvoeR7pnFoS
         yQrH6lHwgAjM/zSP8W3B/ZW5bPhsu3VBXiriS9IOPnjpmmm+GY9vFifrXMONuTod6hpY
         8EC6HJtPUugNNbGCE/FBCqueZNPNkQ2ekfQSk01B08BRJHledcM19oHDL932xhDcqGDI
         qH9SQJLxbH64XvQ+HEORZUwBQhs7vKR3TmzOQBfsBuN0T7GK9/6/Z5/uAw4N6k60JpD9
         g9KHWpi08IkeIH+uvDGcJtp1Nz+m6TSiFFGK1BWYU0+pIONoUbT7yDMQH4Pn+R+EPWQP
         9Msg==
X-Gm-Message-State: AFqh2ko/HeOkJigTiyKoXQiwtyQfzaDSCpONeJDCqkV0jj1uJ0FqKGzI
        zyZN0L/Uh1U+vPp89qcgg+qLjox9uj8RXYF8GHWR01pNsZg=
X-Google-Smtp-Source: AMrXdXtgrqbksJmK1rkB7gTO5nWWWnpLsjFmyJ8t4f7jXmeNv4uN3R3yZXqL8XKH9IE4H5EmlHCrzYKbhzJ+O0JAb1Y=
X-Received: by 2002:a17:906:4d4f:b0:85c:86a7:ad7b with SMTP id
 b15-20020a1709064d4f00b0085c86a7ad7bmr721176ejv.745.1673464816295; Wed, 11
 Jan 2023 11:20:16 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com> <CAEf4BzYawc4dgjMsUQYKPEECm=qtytktGzzSnrECz56FSVgcRg@mail.gmail.com>
 <CAKH8qBvhnYLA5FpKtZ5JPp3LdJ5oCc=hA=4uD=yaDQ761ZRPpg@mail.gmail.com>
In-Reply-To: <CAKH8qBvhnYLA5FpKtZ5JPp3LdJ5oCc=hA=4uD=yaDQ761ZRPpg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Jan 2023 11:20:03 -0800
Message-ID: <CAEf4BzahRoqeKEHFfrJf0tZD3vzjm1jx1rdkfiyBj52uxVGW7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP program
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 4, 2023 at 3:44 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Wed, Jan 4, 2023 at 3:15 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jan 4, 2023 at 4:19 AM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Get rid of the built-in XDP program that was part of the old libbpf
> > > code in xsk.c and replace it with an eBPF program build using the
> > > framework by all the other bpf selftests. This will form the base for
> > > adding more programs in later commits.
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  2 +-
> > >  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
> > >  tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
> > >  tools/testing/selftests/bpf/xsk.h             |  6 +-
> > >  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
> > >  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
> > >  6 files changed, 88 insertions(+), 106 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 205e8c3c346a..a0193a8f9da6 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
> > >  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> > >  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> > >  $(OUTPUT)/xsk.o: $(BPFOBJ)
> >
> > shouldn't $(OUTPUT)/xsk_xdp_progs.skel.h be added as a dependency
> > here, at .o file?
>
> Not sure we can:
> xsk.o is a 'generic' library and xsk_xdp_progs.skel.h is xskxceiver-specific.

Oh, I'm just not very familiar with xskxceiver. What I meant was that
this skel.h header should be a dependency of an object file that
results from .c file that includes that skel.h header. It seems like
it's a xskxceiver.c -> xskxceiver.o in this case, that's where I'd add
dependency.

But it might not be possible for some reason (as we compile
test_verifier straight from test_verifier.c, bypassing .o creation),
which I might be forgetting.

>
> I was trying to see how it works for the other cases where we depend
> on the headers and saw the following:
>
> $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
>         $(call msg,BINARY,,$@)
>         $(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
>
> So at least for test_verifier, we explicitly filter out anything
> non-.[aoc]. Presumably because of the same issue?
> Should we do the same for xskxceiver? I've sent similar changes for my
> xdp_hw_metadata binary about an hour ago..

We do filter "irrelevant" inputs yes, as a general rule. And we can do
that for other binaries as well, yep.

>
> > > -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> > > +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h
> >
> > and not here. Is that why we have this clang compilation failure?
> >
> > >
> > >  BPFTOOL ?= $(DEFAULT_BPFTOOL)
> > >  $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
> >
> > [...]
