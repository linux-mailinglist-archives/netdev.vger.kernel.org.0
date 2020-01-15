Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D08F413CB3F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAORof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:44:35 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42857 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:44:34 -0500
Received: by mail-qk1-f196.google.com with SMTP id z14so16438752qkg.9;
        Wed, 15 Jan 2020 09:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m6xoPR2neNY7jGKcJU1Zrb+VdDyMT3eChB1zKABN77U=;
        b=Lydwo7gZw7DHX1UX8PkZjddlzWtbrHgVeBQKfmcbrQQ2zg8nr/TdBbQ0YxU/giO6aR
         0TtxdBx4nVycooprexn/hDVNpFgiO3kl/AZtSSRBWfN8PJBDtoAaGV8NXDjphuCPPBxp
         sZ3t/cssjIigtX52RPxYRbfFD/41u4kxFdKs3hbXB5G3TAUn1bWfkWEXLxEMmvxxZtHH
         +hOLJto3HpzQxG8aOR1mIKwluA8te3ndO6L3iXF0XJAVtm/APh5WX5pLxsKq8VzJ9HmM
         x43V4757USzVgJFMzq0KU3H6VMStTxObsDnscBV90st+SHjNON+mpEBnSv8/WF2CaojS
         7vbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m6xoPR2neNY7jGKcJU1Zrb+VdDyMT3eChB1zKABN77U=;
        b=o/xVT8Tj9vMo44AepvlwbW84JKFRXKlHle20cu1RGpjPqxwSSxmhTGIVDbBmmPAE8M
         YqLnr50OQ8+15ahAVFyuesLbYDEgyGod7qDtKlXMx3FcPWOs3vr01pEhRtlHw97abq+2
         3dWcRG5BM70GeIn/zEdwinSsQD4uc0a4pkkdpdSxIW3+Aiif5pK+0ySfeojeIBdkV6xg
         +NbQxNKxYbvtFFX3nuXnhyHtIVlCAuxI0i8K6peI+9OSvHfdcLNRCEnJKC8X4WP01oXI
         GUJakXeasojiyDHmv7+E9HLrW1vGAthEWpSOyix9vnZLfwLsc2CCBce18tqPmFQrGY6S
         oqSA==
X-Gm-Message-State: APjAAAVko4lL37oIC5cdyysbTEBK6RFFd1Ue3ij6jRvLC1baA/TtEc2d
        L1dgd2u5l2LEDtGH8gRUrw1VSvgjtmDRqW08MDA=
X-Google-Smtp-Source: APXvYqzVE7hG98oGxZ/GsYNMIScGI3tkchCjPm5Bw57HzNx39uCyOLh6ur5DFPK7G8zjO1kCh1N9vis1zB3NdNxq8Vw=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr28882285qkj.36.1579110273560;
 Wed, 15 Jan 2020 09:44:33 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk> <157909757421.1192265.7677168164515639742.stgit@toke.dk>
In-Reply-To: <157909757421.1192265.7677168164515639742.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 09:44:22 -0800
Message-ID: <CAEf4BzZO4yV61zwjiU5fhARCSBqDDtVx+GmLfRueXFS43BPAhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/10] bpftool: Use consistent include paths
 for libbpf
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 6:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix bpftool to include libbpf header files with the bpf/ prefix, to be
> consistent with external users of the library. Also ensure that all
> includes of exported libbpf header files (those that are exported on 'mak=
e
> install' of the library) use bracketed includes instead of quoted.
>
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its include, remove tools/lib/bpf from the include path entirel=
y,
> and use tools/lib instead.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-gen.rst |    2 +-
>  tools/bpf/bpftool/Makefile                      |    2 +-
>  tools/bpf/bpftool/btf.c                         |    8 ++++----
>  tools/bpf/bpftool/btf_dumper.c                  |    2 +-
>  tools/bpf/bpftool/cgroup.c                      |    2 +-
>  tools/bpf/bpftool/common.c                      |    4 ++--
>  tools/bpf/bpftool/feature.c                     |    4 ++--
>  tools/bpf/bpftool/gen.c                         |   10 +++++-----
>  tools/bpf/bpftool/jit_disasm.c                  |    2 +-
>  tools/bpf/bpftool/main.c                        |    4 ++--
>  tools/bpf/bpftool/map.c                         |    4 ++--
>  tools/bpf/bpftool/map_perf_ring.c               |    4 ++--
>  tools/bpf/bpftool/net.c                         |    8 ++++----
>  tools/bpf/bpftool/netlink_dumper.c              |    4 ++--
>  tools/bpf/bpftool/perf.c                        |    2 +-
>  tools/bpf/bpftool/prog.c                        |    6 +++---
>  tools/bpf/bpftool/xlated_dumper.c               |    2 +-
>  17 files changed, 35 insertions(+), 35 deletions(-)
>

[...]

> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7ce09a9a6999..b0695aa543d2 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -12,15 +12,15 @@
>  #include <stdio.h>
>  #include <string.h>
>  #include <unistd.h>
> -#include <bpf.h>
> -#include <libbpf.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/mman.h>
>  #include <unistd.h>
> +#include <bpf/btf.h>
>
> -#include "btf.h"
> -#include "libbpf_internal.h"
> +#include "bpf/libbpf_internal.h"
>  #include "json_writer.h"
>  #include "main.h"
>
> @@ -333,7 +333,7 @@ static int do_skeleton(int argc, char **argv)
>                 #define %2$s                                             =
   \n\
>                                                                          =
   \n\
>                 #include <stdlib.h>                                      =
   \n\
> -               #include <libbpf.h>                                      =
   \n\
> +               #include <bpf/libbpf.h>                             \n\

please fix \n\ alignment

>                                                                          =
   \n\
>                 struct %1$s {                                            =
   \n\
>                         struct bpf_object_skeleton *skeleton;            =
   \n\

[...]
