Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B1F16B641
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgBYAIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:08:05 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36359 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:08:05 -0500
Received: by mail-qk1-f195.google.com with SMTP id f3so7470123qkh.3;
        Mon, 24 Feb 2020 16:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7U/Xnopp7HziZ6TTtjf/x259n7uyOH8t1WEbO/vN4yM=;
        b=hcKKDpU3QLRiUU8hbG1AJHAHjcbjCiYGn7DeSGek8JpcBaPU5YcdXb2MO49g+acldF
         ekZeERF2Oubb0HcXnpodGn9nW+xkaWdm42seNEVZ6BwbbdOqs4xaPSBXTnbeMixmu+Or
         Fs5j58ArmyAubIAVbkwn8fU5UTONtrxdlpGIfX88ZtHUd7KDPAFD/eUa6uqp81SABQcy
         /Vm8rx9PEq1ayGlrMRbYHbGc2iJ4PEmAxK2RMpglPsz57SAMcDfQJb4zaWT357rkFUYl
         L3msNsxV09qW1CyM2Is8JX+oJLTxco6rhEJcTu9YR07VooiDVnOrq/efzYnij/nshoUU
         UMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7U/Xnopp7HziZ6TTtjf/x259n7uyOH8t1WEbO/vN4yM=;
        b=tOkVRNenoV8iIFDiQKFHnFIlDEq9bnzU1KXUlrSoDKIQU5kmzcZefaQRab8ZSvodVi
         rDjzfKQi6ZLPSnu/JG+yfrqltCpLr3FW7PBvcjpySBkQKGUL1irhMJFCqJhBpkQKzFax
         KXdPuqmG5x8+70lUwgwacfoOYksEmUwkCK446J9qwb9E7ZATIlAfqeoXQf9ZM5gIMyYC
         Xpzzk0fWOnF8hY9uOYn8Q539fxAUPaWfyzWSYEWjWNjmlovv5hMk8gtNvXSTLkCJ6/Db
         6+NEifw9X0Tnw2M3+1g/IDKippQUxaLtUKnn5btV50fpQS+rz7I0nkoZQETDnfGyot0s
         YgkQ==
X-Gm-Message-State: APjAAAXD/201/cHWkTtMw54IqhWkGWmD4B2PsSzHaGKAfzIkIXm80VaJ
        em93kXIzyt0s5oqiauMYAWYON3nzWdudXS3Rn7M=
X-Google-Smtp-Source: APXvYqyT4CZdvF3zAxy0NP7TeQlB3pw66yBObLfwa7fJmcq7TSDSQNXrp4OpKMVAHSeBG/gix22gH9ukAWPgRwITRMc=
X-Received: by 2002:a37:a70c:: with SMTP id q12mr5119547qke.36.1582589283607;
 Mon, 24 Feb 2020 16:08:03 -0800 (PST)
MIME-Version: 1.0
References: <20200223054320.2006995-1-andriin@fb.com> <0614970B-8A37-470F-82F3-2F4C36E873C0@fb.com>
In-Reply-To: <0614970B-8A37-470F-82F3-2F4C36E873C0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Feb 2020 16:07:51 -0800
Message-ID: <CAEf4BzZLL_=VeVhx3+WnoWwn=G4soUnpPaB_-RAzsxNZfzW6gQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: print backtrace on SIGSEGV in test_progs
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 1:34 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Feb 22, 2020, at 9:43 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Due to various bugs in test clean up code (usually), if host system is
> > misconfigured, it happens that test_progs will just crash in the middle of
> > running a test with little to no indication of where and why the crash
> > happened. For cases where coredump is not readily available (e.g., inside
> > a CI), it's very helpful to have a stack trace, which lead to crash, to be
> > printed out. This change adds a signal handler that will capture and print out
> > symbolized backtrace:
> >
> >  $ sudo ./test_progs -t mmap
> >  test_mmap:PASS:skel_open_and_load 0 nsec
> >  test_mmap:PASS:bss_mmap 0 nsec
> >  test_mmap:PASS:data_mmap 0 nsec
> >  Caught signal #11!
> >  Stack trace:
> >  ./test_progs(crash_handler+0x18)[0x42a888]
> >  /lib64/libpthread.so.0(+0xf5d0)[0x7f2aab5175d0]
> >  ./test_progs(test_mmap+0x3c0)[0x41f0a0]
> >  ./test_progs(main+0x160)[0x407d10]
> >  /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2aab15d3d5]
> >  ./test_progs[0x407ebc]
> >  [1]    1988412 segmentation fault (core dumped)  sudo ./test_progs -t mmap
> >
> > Unfortunately, glibc's symbolization support is unable to symbolize static
> > functions, only global ones will be present in stack trace. But it's still a
> > step forward without adding extra libraries to get a better symbolization.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/testing/selftests/bpf/Makefile     |  2 +-
> > tools/testing/selftests/bpf/test_progs.c | 26 ++++++++++++++++++++++++
> > 2 files changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 2a583196fa51..50c63c21e6fd 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -20,7 +20,7 @@ CLANG               ?= clang
> > LLC           ?= llc
> > LLVM_OBJCOPY  ?= llvm-objcopy
> > BPF_GCC               ?= $(shell command -v bpf-gcc;)
> > -CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)           \
> > +CFLAGS += -g -rdynamic -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR) \
> >         -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)     \
> >         -Dbpf_prog_load=bpf_prog_test_load                            \
> >         -Dbpf_load_program=bpf_test_load_program
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index bab1e6f1d8f1..531ab3e7e5e5 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -6,6 +6,8 @@
> > #include "bpf_rlimit.h"
> > #include <argp.h>
> > #include <string.h>
> > +#include <signal.h>
> > +#include <execinfo.h> /* backtrace */
> >
> > /* defined in test_progs.h */
> > struct test_env env = {};
> > @@ -617,6 +619,22 @@ int cd_flavor_subdir(const char *exec_name)
> >       return chdir(flavor);
> > }
> >
> > +#define MAX_BACKTRACE_SZ 128
> > +void crash_handler(int signum)
> > +{
> > +     void *bt[MAX_BACKTRACE_SZ];
> > +     size_t sz;
> > +
> > +     sz = backtrace(bt, ARRAY_SIZE(bt));
> > +
> > +     if (env.test)
> > +             dump_test_log(env.test, true);
> > +     stdio_restore();
> > +
> > +     fprintf(stderr, "Caught signal #%d!\nStack trace:\n", signum);
> > +     backtrace_symbols_fd(bt, sz, STDERR_FILENO);
> > +}
> > +
> > int main(int argc, char **argv)
> > {
> >       static const struct argp argp = {
> > @@ -624,8 +642,16 @@ int main(int argc, char **argv)
> >               .parser = parse_arg,
> >               .doc = argp_program_doc,
> >       };
> > +     struct sigaction sigact = {
> > +             .sa_handler = crash_handler,
> > +             .sa_flags = SA_RESETHAND,
> > +     };
> >       int err, i;
> >
> > +     env.stdout = stdout;
> > +     env.stderr = stderr;
>
> We have the same code in stdio_hijack(). Maybe remove those in
> stdio_hijack()?

Yeah, this is ugly. I'll just check for (!env.stdout) in signal
handler instead. Sending v2...

>
> > +     sigaction(SIGSEGV, &sigact, NULL);
> > +
> >       err = argp_parse(&argp, argc, argv, 0, NULL, &env);
> >       if (err)
> >               return err;
> > --
> > 2.17.1
> >
>
