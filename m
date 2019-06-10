Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28063BBD5
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbfFJS3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:29:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33880 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFJS3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:29:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so5800774pfc.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 11:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wxek0fx6s3KddrvpU4oKL76nIQmH9qs+TlcDE0JEbIk=;
        b=YZN36eEawrMxHODDnV8WczaMoDAiuRJdDSk6AesfddpU/KW0pnNup7G0XKqgSRjFtj
         S88CLwGzAxyQ4qMtIx3uWwsdFPvZwXQq32UJVMYHBnrFFuO5e3e8tB4Z+hStWAE7ataW
         M4bR0zpFlNYBNEJrxofdY3Hx2q6bABKHi5TY83uBUsvJ3u7ArN9F5m4L59RiVMI+MPpq
         UmcpPVm/yHScgw7LoxWv7O0F84YskknCnf00lSPQJ2Sg1g/rhI4pTMJ91RxqksS/jeNf
         JJP0F99PQzgvwb4tHt9T8ACe+5f4grt7An2ZnUV+3AX0USECNf02mQIYKeueiraUM/bH
         bMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wxek0fx6s3KddrvpU4oKL76nIQmH9qs+TlcDE0JEbIk=;
        b=Myv8B4lF2NM7i6ulMsgDZf9jgBwcbg/UmgEwEbOqLA6HopBQhK4qldu5/35XP3zF++
         TVpjA9kBw+3mn73tCIGVgpLieNf1u/wjMkb05rG6BcfoLxbui2VZaPSBP3LNHUFT5e93
         xQMEMaNOXVhaQVRKtp/Mk/sOm+4yFOvC3S/Jh2z2Gk3kl68KTawbO1xVAMVZipYtxjwk
         XCPiRPgxJTN0D/hcs8s1vqPF+kBgCkKfyrrC+McYRj5sQfyEuLN6e7+lOLcoqJRqWVpA
         +KC1oCXjoOmY2DS+z5T5ptyFL+3z3rhX/dERHP2rw6ZpO62E0LcEcZOqtmv83JCx9GT6
         L20g==
X-Gm-Message-State: APjAAAX/VPCi+Cxc+aaOs0OxAsGJ5F+Q9ILWesgYhmrXqM8/ZEJvOCVS
        /4eBKWvHBGJVnPt1dgSsAUwIZA==
X-Google-Smtp-Source: APXvYqy8PisKXmSQXG/OSrVuBZ8vbZywZ5Spo3c5zekDLT1Q9NFs+rKIZVcwRkC4TfabqB6yhczoCw==
X-Received: by 2002:a62:b40a:: with SMTP id h10mr76674102pfn.216.1560191393563;
        Mon, 10 Jun 2019 11:29:53 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id t11sm10563709pgp.1.2019.06.10.11.29.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 11:29:53 -0700 (PDT)
Date:   Mon, 10 Jun 2019 11:29:52 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v4 0/8] bpf: getsockopt and setsockopt hooks
Message-ID: <20190610182952.GG9660@mini-arch>
References: <20190610163421.208126-1-sdf@google.com>
 <CAEf4BzYvvBwWP9qaCc=saJx-tPmX1qz8TXACfKwBOUW4Q_7bcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYvvBwWP9qaCc=saJx-tPmX1qz8TXACfKwBOUW4Q_7bcA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10, Andrii Nakryiko wrote:
> On Mon, Jun 10, 2019 at 9:39 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > This series implements two new per-cgroup hooks: getsockopt and
> > setsockopt along with a new sockopt program type. The idea is pretty
> > similar to recently introduced cgroup sysctl hooks, but
> > implementation is simpler (no need to convert to/from strings).
> >
> > What this can be applied to:
> > * move business logic of what tos/priority/etc can be set by
> >   containers (either pass or reject)
> > * handle existing options (or introduce new ones) differently by
> >   propagating some information in cgroup/socket local storage
> >
> > Compared to a simple syscall/{g,s}etsockopt tracepoint, those
> > hooks are context aware. Meaning, they can access underlying socket
> > and use cgroup and socket local storage.
> 
> It's customary to include version change log for the whole patch set
> in a cover letter vs first patch. Please include it in the future.
> Thanks!
I don't think there is a precedent that strongly favors one way or
the other. If you search the mailing list, you can find both versions:
cover letter has short version log vs each patch has detailed version
log.

My reasoning for putting version log in the particular patches is to
make life of people who review the changes easier. For example, if
a particular patch doesn't have a version change log, it means that
the patch is in the same state as in the previous version and doesn't
need another round of scrutiny.

> > Stanislav Fomichev (8):
> >   bpf: implement getsockopt and setsockopt hooks
> >   bpf: sync bpf.h to tools/
> >   libbpf: support sockopt hooks
> >   selftests/bpf: test sockopt section name
> >   selftests/bpf: add sockopt test
> >   selftests/bpf: add sockopt test that exercises sk helpers
> >   bpf: add sockopt documentation
> >   bpftool: support cgroup sockopt
> >
> >  Documentation/bpf/index.rst                   |   1 +
> >  Documentation/bpf/prog_cgroup_sockopt.rst     |  39 +
> >  include/linux/bpf-cgroup.h                    |  29 +
> >  include/linux/bpf.h                           |  45 +
> >  include/linux/bpf_types.h                     |   1 +
> >  include/linux/filter.h                        |  13 +
> >  include/uapi/linux/bpf.h                      |  13 +
> >  kernel/bpf/cgroup.c                           | 262 ++++++
> >  kernel/bpf/core.c                             |   9 +
> >  kernel/bpf/syscall.c                          |  19 +
> >  kernel/bpf/verifier.c                         |  15 +
> >  net/core/filter.c                             |   2 +-
> >  net/socket.c                                  |  18 +
> >  .../bpftool/Documentation/bpftool-cgroup.rst  |   7 +-
> >  .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
> >  tools/bpf/bpftool/bash-completion/bpftool     |   8 +-
> >  tools/bpf/bpftool/cgroup.c                    |   5 +-
> >  tools/bpf/bpftool/main.h                      |   1 +
> >  tools/bpf/bpftool/prog.c                      |   3 +-
> >  tools/include/uapi/linux/bpf.h                |  14 +
> >  tools/lib/bpf/libbpf.c                        |   5 +
> >  tools/lib/bpf/libbpf_probes.c                 |   1 +
> >  tools/testing/selftests/bpf/.gitignore        |   2 +
> >  tools/testing/selftests/bpf/Makefile          |   4 +-
> >  .../testing/selftests/bpf/progs/sockopt_sk.c  |  67 ++
> >  .../selftests/bpf/test_section_names.c        |  10 +
> >  tools/testing/selftests/bpf/test_sockopt.c    | 773 ++++++++++++++++++
> >  tools/testing/selftests/bpf/test_sockopt_sk.c | 156 ++++
> >  28 files changed, 1514 insertions(+), 10 deletions(-)
> >  create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
> >  create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
> >  create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
> >  create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c
> >
> > --
> > 2.22.0.rc2.383.gf4fbbf30c2-goog
