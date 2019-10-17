Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C26DA5C9
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407834AbfJQGwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:52:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35582 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbfJQGwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:52:44 -0400
Received: by mail-qt1-f196.google.com with SMTP id m15so2093917qtq.2;
        Wed, 16 Oct 2019 23:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fm726N4OL0cMix5ocsI+MKixgvsQYeB4kCvOwJ5EfDU=;
        b=KXAq5Su98E4VeX9e/Xl3D2ZBIgeXtqX/JvhK3XXv3o0ERhYck8qBLyuiHFq5kbPakm
         SfKX5DlCXtrNwhq44hhF2a+sLvrW9AvH4Re9pNmYXDYQjqPIGrv0d28LYD7q8tWVT8Ey
         8Se8bmQ3dG3CDMNezpQhtpS5PB4ynHJuzJnrULIy93iyb9+zw8ILx+nnG/fLZcerb6ra
         p1QGEeHkv84CywldDSOdp8tyWoInNwJkowMmU5kMUm/mmVLCw+vQ7lobN9PJbvEliMjT
         CTf1IaVyDM7hnnxjnlS3utj9LTVhoeAx8ZNuWae8/e/c2oiaSsU7LdgWqMY40JMBQdaF
         zR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fm726N4OL0cMix5ocsI+MKixgvsQYeB4kCvOwJ5EfDU=;
        b=ExJRdmZBxXgzRvZzD3Vjg3zg9r5Ym5fxMorqHxafWVbMoKbK7aOjKoyTnUs+S3Tfhk
         I5Ds8LHI9h/4FM0hiU3VV1tmV8sgZTjlQKqrsxteBGywHfpxKEnud2gi4ImHH5zz+Srl
         VvbAI97wNT5nhwK3/OegtzjXI0TZoWS1Ya2cG8DcKrLPCQCBdqfnfupkR2yC+NANtpN1
         +A5q9hFZD13k2g+N88UKRvG5H7xdFnXnQhBcDFVpvUnR8UTU99CtdOlrDWSTH2y81VdO
         e6pmsQr3A21d+djpfa+PttJvBTmLYmVCQtq9inJJJ8/HPlLtVVkBYtttEc1farttND30
         du2A==
X-Gm-Message-State: APjAAAUKghSX30xyBvSLIisiEvwqYKyRV23OOhZVn5cPB2hoR6fcUuvP
        vdRqk1SyMMr9iNxhqkqYE83+9p9CD3aCLDQ+rZU=
X-Google-Smtp-Source: APXvYqzFT/yL9jIoRYtInLWDyNPCZ23KP0dwFFtr6WH61LtZ94iKncmlb/Y7Pk2pL6MAuYY4UeieBixpvfjl5svkOxI=
X-Received: by 2002:a0c:fde4:: with SMTP id m4mr2302401qvu.163.1571295162709;
 Wed, 16 Oct 2019 23:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <CAADnVQJKESit7tDy0atn0-Q7Se=kLhkCWGAmRPJSVPdNAS8BVg@mail.gmail.com>
In-Reply-To: <CAADnVQJKESit7tDy0atn0-Q7Se=kLhkCWGAmRPJSVPdNAS8BVg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 23:52:31 -0700
Message-ID: <CAEf4BzZaSznrp0xLZ6Skpt3yuompUJU6XV863zSOPQfq4VL-UA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/7] Fix, clean up, and revamp selftests/bpf Makefile
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
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

On Wed, Oct 16, 2019 at 9:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 16, 2019 at 4:49 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch set extensively revamps selftests/bpf's Makefile to generalize test
> > runner concept and apply it uniformly to test_maps and test_progs test
> > runners, along with test_progs' few build "flavors", exercising various ways
> > to build BPF programs.
> >
> > As we do that, we fix dependencies between various phases of test runners, and
> > simplify some one-off rules and dependencies currently present in Makefile.
> > test_progs' flavors are now built into root $(OUTPUT) directory and can be run
> > without any extra steps right from there. E.g., test_progs-alu32 is built and
> > is supposed to be run from $(OUTPUT). It will cd into alu32/ subdirectory to
> > load correct set of BPF object files (which are different from the ones built
> > for test_progs).
> >
> > Outline:
> > - patch #1 teaches test_progs about flavor sub-directories;
> > - patch #2 fixes one of CO-RE tests to not depend strictly on process name;
> > - patch #3 changes test_maps's usage of map_tests/tests.h to be the same as
> >   test_progs' one;
> > - patch #4 adds convenient short `make test_progs`-like targets to build only
> >   individual tests, if necessary;
> > - patch #5 is a main patch in the series; it uses a bunch of make magic
> >   (mainly $(call) and $(eval)) to define test runner "skeleton" and apply it
> >   to 4 different test runners, lots more details in corresponding commit
> >   description;
> > - patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
> >   BPF programs;
> > - patch #7 cleans up test_libbpf.sh/test_libbpf_open superseded by test_progs.
> >
> > v3->v4:
> > - remove accidentally checked in binaries;
>
> something really odd here.
> Before the patchset ./test_progs -n 27 passes
> after the patch it simply hangs.
> Though strace -f ./test_progs -n 27 passes.
> Any idea?

Interesting. For me test_progs -n27 passes by itself, whether with or
without Makefile changes. But when run together with #8
flow_dissector_reattach, it fails with
"(prog_tests/sockopt_inherit.c:28: errno: Network is unreachable) Fail
to connect to server", even without Makefile changes. It doesn't hang,
but the test has server and client threads being coordinated, so I
wouldn't be surprised that under some specific timing and error
conditions it can hang.

I bisected this failure to f97eea1756f3 ("selftests/bpf: Check that
flow dissector can be re-attached"), that's when
flow_dissector_reattach test was added. So apparently there is some
bad interaction there.

So I suspect my Makefile changes have nothing to do with this, it
would be really bizarre...

Jakub, do you mind checking as well?
