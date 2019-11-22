Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E1107745
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKVSYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:24:39 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45899 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKVSYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:24:38 -0500
Received: by mail-qv1-f68.google.com with SMTP id d12so1309411qvv.12;
        Fri, 22 Nov 2019 10:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YTsaI7BopTi4XMsjV8DpF3t0VMG4B94cWtPIeSM/7EM=;
        b=S/h4d2B/NvJqKUpDXM1Fwlu7YpOPftTtPYFzSYbtXemhU9dQ3y3g3faXz7CaUdvQt5
         fxlr5Pn6sg/1ee08eOaGAU9D8ExN+0FUM31fPhowtPdmIz2JX2GkeIx0p2L+OOLn0Nq+
         DS4w/LFs2Ph93uxRCTFAZieHgcPSXbhCSuqKfa6Yr1TbjIh9Lg0XeJclX/9yNWXjTAxD
         evFZkxp/sebZAkSZDdFtbgOe1Q425YboHOg5W6QHNP9J2vtNhbjgtJmWQsWPaL/AO8gQ
         ltPZ7LTwV3Zq1uzWV4DFYbkOZUxt8YRFLywYU0rxdev9ufJ4nG0kblr2aqjVEn3VQQsO
         109w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTsaI7BopTi4XMsjV8DpF3t0VMG4B94cWtPIeSM/7EM=;
        b=msYYVC12zBjwNCSGSTLldKXlsptLQmjJwjAtB9L9GM2OK1s2DzvemZsLdGi/1f+rLi
         +8D83zYmlV4+rGkksy8uCZmibWUOHT5aXowiut8Xtl5tuUHiMTi5xhr61G3AIS8jorit
         c1NJz+cWNLsKgnBRSkryjOVy5/0h6kBq3/muxgB1R4f3je5d2SGNc55eNFWmss03nycZ
         Cgyza/GuM7nsNMoxBXXkrr/Kki4r7bZUEiYrGymfDQXi/qpkKDF8SiymzlD7C70dhq6I
         6MLrmxUOw6UR5OXLJN/hfsdfaetcRiWvm4TtFMEyuIfOD2Sp2AxlJyMbiMTEnUy7e9vA
         UVvg==
X-Gm-Message-State: APjAAAXvDsxF54Zpn98AoigHFBOwa8hmoAL2yqykxqX0z3Yrts2wnZfu
        4J9z9LN483mq2/dL+K+7CJ4kXMqp4YQYSbhvsnSBkA==
X-Google-Smtp-Source: APXvYqydu8aBRY8ikhCayDp5solTRhxZbrmvAxPQaZKUxjsS4dcZWjfYoFeJCa/L5TqZg6RueDi/dtN83u/61E4LwmI=
X-Received: by 2002:a0c:eb47:: with SMTP id c7mr15616746qvq.163.1574447075791;
 Fri, 22 Nov 2019 10:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20191121175900.3486133-1-andriin@fb.com> <CAADnVQ+=NVQg_=eUudG3Q9knGHbwBzx8bKH+1oWemtpn23HfwA@mail.gmail.com>
In-Reply-To: <CAADnVQ+=NVQg_=eUudG3Q9knGHbwBzx8bKH+1oWemtpn23HfwA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 10:24:24 -0800
Message-ID: <CAEf4BzZJOT3vNS7FeMZ9HKxHh8Qwe53iDx6iYJ5CG1hK1MS8mQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: ensure core_reloc_kernel is
 reading test_progs's data only
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 11:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 21, 2019 at 9:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > test_core_reloc_kernel.c selftest is the only CO-RE test that reads and
> > returns for validation calling thread's information (pid, tgid, comm). Thus it
> > has to make sure that only test_prog's invocations are honored.
> >
> > Fixes: df36e621418b ("selftests/bpf: add CO-RE relocs testing setup")
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/prog_tests/core_reloc.c        | 16 +++++++++++-----
> >  .../selftests/bpf/progs/test_core_reloc_kernel.c |  4 ++++
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > index ec9e2fdd6b89..05fe85281ff7 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > @@ -2,6 +2,7 @@
> >  #include <test_progs.h>
> >  #include "progs/core_reloc_types.h"
> >  #include <sys/mman.h>
> > +#include <sys/syscall.h>
> >
> >  #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
> >
> > @@ -452,6 +453,7 @@ static struct core_reloc_test_case test_cases[] = {
> >  struct data {
> >         char in[256];
> >         char out[256];
> > +       uint64_t my_pid_tgid;
> >  };
> >
> >  static size_t roundup_page(size_t sz)
> > @@ -471,9 +473,12 @@ void test_core_reloc(void)
> >         struct bpf_map *data_map;
> >         struct bpf_program *prog;
> >         struct bpf_object *obj;
> > +       uint64_t my_pid_tgid;
> >         struct data *data;
> >         void *mmap_data = NULL;
> >
> > +       my_pid_tgid = getpid() | ((uint64_t)syscall(SYS_gettid) << 32);
> > +
> >         for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> >                 test_case = &test_cases[i];
> >                 if (!test__start_subtest(test_case->case_name))
> > @@ -517,11 +522,6 @@ void test_core_reloc(void)
> >                                 goto cleanup;
> >                 }
> >
> > -               link = bpf_program__attach_raw_tracepoint(prog, tp_name);
> > -               if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> > -                         PTR_ERR(link)))
> > -                       goto cleanup;
> > -
> >                 data_map = bpf_object__find_map_by_name(obj, "test_cor.bss");
> >                 if (CHECK(!data_map, "find_data_map", "data map not found\n"))
> >                         goto cleanup;
> > @@ -537,6 +537,12 @@ void test_core_reloc(void)
> >
> >                 memset(mmap_data, 0, sizeof(*data));
> >                 memcpy(data->in, test_case->input, test_case->input_len);
> > +               data->my_pid_tgid = my_pid_tgid;
> > +
> > +               link = bpf_program__attach_raw_tracepoint(prog, tp_name);
> > +               if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> > +                         PTR_ERR(link)))
> > +                       goto cleanup;
> >
> >                 /* trigger test run */
> >                 usleep(1);
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > index a4b5e0562ed5..d2fe8f337846 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > @@ -11,6 +11,7 @@ char _license[] SEC("license") = "GPL";
> >  static volatile struct data {
> >         char in[256];
> >         char out[256];
> > +       uint64_t my_pid_tgid;
> >  } data;
>
> There was a conflict here, since global data support patchset was
> already applied.
> I resolved it and applied to bpf-next.
> Thanks

Ah, right, thanks!
