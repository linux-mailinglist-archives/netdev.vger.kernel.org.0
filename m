Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E78773BD
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfGZVvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:51:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36990 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfGZVvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:51:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id d15so40144367qkl.4;
        Fri, 26 Jul 2019 14:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxCG/LtUcoA1bixXRCryEr2O5M63WixV2r9AVEj8Yxo=;
        b=NNPK6DcsJjS/uxX86TnE+qcX/T6MHfsrjT/VH7d378uqlyjNleQpAW+5j2KVQSUrsz
         Cq1PDHDMTBbP2ll881KJx0wmaxP8RWqAQngpy5z8RFBBjMt0GfI393FwALk0KIJZQb4d
         2etq/Bx/4s4CVuw4dGpaJ88EJGCa1+hnH3vkysa2MILnuM4+fD9qWpUKa4E5ga0tX+LT
         bunxq73spAlWJnd6VYriUTOjXvUQLSJJ+IbJlJxovgjAJLKtESOinlAOCwsy6hTn97HM
         TKbaHfXwRi8vXtG+pLaKumyXPQ5TcJYoQhJGtx6iledaI8iZOXQjEO4df2xzY8q66CU+
         a8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxCG/LtUcoA1bixXRCryEr2O5M63WixV2r9AVEj8Yxo=;
        b=eH9LoufLacjVovrx4idRk72Y8VwM1EsMYfJAWElczbq+uFabnp3dbHpU76gD59IAzS
         Iz1MJEcQYPcu98CUWUUP3rkUWDbsF3OJw5qwNyrAdnFU+/c9tHofhDdwDbotGhffBxHQ
         Y6Z2qYvImsTZnHoFUOC92i0Rn1omqux6VNg7z6SSAHJf91uFuYRv250nEA8aWro4EQVt
         AB15hzKmE0g/h0o2b3LNxKkoRFKKXJ4UWXwwRlyLQQmy510pHpqyh0zwtXkbc4FY05va
         7EMa2NkhB1PjYbpESwnW6pemVCZaR2U+5R/AguHB9LPlVVbX5eTEskJ45sRUkQMftW/r
         Ipow==
X-Gm-Message-State: APjAAAWfSfdHMx8Q04qeGvu2eYR+PZIUEmQCRH0TWPw6Y4ss8nG2mbIo
        vOiArau5Dj6wOMVy9us2yK6UdwIGzDyvex0KSyI=
X-Google-Smtp-Source: APXvYqwHAfHikZVuy/Qh7VYhzgf1iF6k7R0jYWlMEm48i1cYLyDyd2pbE4i6VTrDxfeZq1BrceHoXMtzoiaL5yxyOdE=
X-Received: by 2002:a37:660d:: with SMTP id a13mr37202282qkc.36.1564177906962;
 Fri, 26 Jul 2019 14:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-7-andriin@fb.com>
 <20190726213104.GD24397@mini-arch>
In-Reply-To: <20190726213104.GD24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 14:51:36 -0700
Message-ID: <CAEf4BzaVCdHT_U+m7niJLsSmbf+M9DrFjf_PNOmQQZvuHsr9Xg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] selftests/bpf: abstract away test log output
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

On Fri, Jul 26, 2019 at 2:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > This patch changes how test output is printed out. By default, if test
> > had no errors, the only output will be a single line with test number,
> > name, and verdict at the end, e.g.:
> >
> >   #31 xdp:OK
> >
> > If test had any errors, all log output captured during test execution
> > will be output after test completes.
> >
> > It's possible to force output of log with `-v` (`--verbose`) option, in
> > which case output won't be buffered and will be output immediately.
> >
> > To support this, individual tests are required to use helper methods for
> > logging: `test__printf()` and `test__vprintf()`.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
> >  .../bpf/prog_tests/bpf_verif_scale.c          |  31 ++--
> >  .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
> >  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
> >  .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
> >  .../selftests/bpf/prog_tests/send_signal.c    |   8 +-
> >  .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
> >  .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
> >  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
> >  .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
> >  tools/testing/selftests/bpf/test_progs.c      | 135 +++++++++++++-----
> >  tools/testing/selftests/bpf/test_progs.h      |  37 ++++-
> >  12 files changed, 173 insertions(+), 73 deletions(-)
> >

[...]

> >               error_cnt++;
> > -             printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > +             test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> #define printf(...) test__printf(...) in tests.h?
>
> A bit ugly, but no need to retrain everyone to use new printf wrappers.

I try to reduce amount of magic and surprising things, not add new
ones :) I also led by example and converted all current instances of
printf usage to test__printf, so anyone new will just copy/paste good
example, hopefully. Even if not, this non-buffered output will be
immediately obvious to anyone who just runs `sudo ./test_progs`. And
author of new test with this problem should hopefully be the first and
the only one to catch and fix this.

>
> >       }
> >  out:
> >       bpf_object__close(obj);
> > diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > index ee99368c595c..2e78217ed3fd 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > @@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)

[...]
