Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B06913CBA5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAOSGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:06:14 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42042 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgAOSGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:06:13 -0500
Received: by mail-qt1-f193.google.com with SMTP id j5so16546955qtq.9;
        Wed, 15 Jan 2020 10:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ELr/XxVqul6D20WrUY/+l7F3oFFhw69GAu+JHpk3Rbk=;
        b=mSPCnteKMSkRqwiFoHYESYY9gfGWLfp6Wj/BRJUP4Q4KxvpnfSxnw0X2O3+zDKrdi2
         ekhtzKXCQeB5Bs/+1KwVMaTkntDXBIcn8z87XMb0VBhZ9vRds4BnOJ1RRijlj0bhsXHM
         MZqAwB0pn1lfKVRjzfD44HEDbEIJxlOANTTPhWK6WNDmflh7dEDPIboreBKEPBUAh3kE
         IAx9DqhXMDYiSV+XZ3WFIbmx316U4AmPfTEFqArYRwMbcAj7g7BvaI+9n4mjdfVvUFP2
         s0RQjCh/hK3MfGFEow+MTXJv1aobh9vIOraqaNtR1Kin1ku2oqwOpZ5jPUKyq+siMEgq
         +tWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ELr/XxVqul6D20WrUY/+l7F3oFFhw69GAu+JHpk3Rbk=;
        b=o6P6EnTCuaZSr0tBobB7yb1CyQJQy+i75avetHdcLfLvhSlZRIPhgBTGLNZGWXUEVr
         qCDwXRkx+sH557gWzBs3EK0drowdhqEIDCxtr0yVP2SzHahmy/Mxg0bxzYvAYMCYxLco
         p27Bj7E3a9t/ylAGFj/sKqlgLuTELBlXhearyl1/RrgRQr5lYQNZa2+diHptJompcdUP
         yBz9tom61Edd6dNQrIYt55Drgg9N5S08cE6chlzxllccxzGpszm1+jymDdIew/qyfola
         HwqJPy2oO3LsaI7ZcWD0Zyf4aoanOHGtwSkIfFfCyOAT43Tk49gK7wWGDq6k9JEnNw9L
         CosA==
X-Gm-Message-State: APjAAAX1Y7CClWRwDv/055D8SB80n6uC+hQcEJjArGkuseilKvYokLLx
        U7skErymyYvvFUjiopK35x5LtoU1GblZjvbSWsg=
X-Google-Smtp-Source: APXvYqyxmKUFZijBXdkuTtHh/L21hbP+2dYNdVYZ+ehzOljvqjBV6f2i6/sb3FoGBrunVSLpiVTX+WlgbzOZ4rbNNQg=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr4640404qtj.59.1579111572469;
 Wed, 15 Jan 2020 10:06:12 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
In-Reply-To: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 10:06:01 -0800
Message-ID: <CAEf4Bza+dNoD7HbVQGtXBq=raz4DQg0yTShKZHRbCo+zHYfoSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/10] tools: Use consistent libbpf include
 paths everywhere
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

On Wed, Jan 15, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The recent commit 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h =
are
> taken from selftests dir") broke compilation against libbpf if it is inst=
alled
> on the system, and $INCLUDEDIR/bpf is not in the include path.
>
> Since having the bpf/ subdir of $INCLUDEDIR in the include path has never=
 been a
> requirement for building against libbpf before, this needs to be fixed. O=
ne
> option is to just revert the offending commit and figure out a different =
way to
> achieve what it aims for. However, this series takes a different approach=
:
> Changing all in-tree users of libbpf to consistently use a bpf/ prefix in
> #include directives for header files from libbpf.
>
> This turns out to be a somewhat invasive change in the number of files to=
uched;
> however, the actual changes to files are fairly trivial (most of them are=
 simply
> made with 'sed'). Also, this approach has the advantage that it makes ext=
ernal
> and internal users consistent with each other, and ensures no future chan=
ges
> breaks things in the same way as the commit referenced above.
>
> The series is split to make the change for one tool subdir at a time, whi=
le
> trying not to break the build along the way. It is structured like this:
>
> - Patch 1-2: Trivial fixes to Makefiles for issues I discovered while cha=
nging
>   the include paths.
>
> - Patch 3-7: Change the include directives to use the bpf/ prefix, and up=
dates
>   Makefiles to make sure tools/lib/ is part of the include path, but with=
out
>   removing tools/lib/bpf
>
> - Patch 8: Change the bpf_helpers file in libbpf itself to use the bpf/ p=
refix
>   when including (the original source of breakage).
>
> - Patch 9-10: Remove tools/lib/bpf from include paths to make sure we don=
't
>   inadvertently re-introduce includes without the bpf/ prefix.
>
> ---

Thanks, Toke, for this clean up! I tested it locally for my set up:
runqslower, bpftool, libbpf, and selftests all build fine, so it looks
good. My only concern is with selftests/bpf Makefile, we shouldn't
build anything outside of selftests/bpf. Let's fix that. Thanks!

>
> Toke H=C3=B8iland-J=C3=B8rgensen (10):
>       samples/bpf: Don't try to remove user's homedir on clean
>       tools/bpf/runqslower: Fix override option for VMLINUX_BTF
>       tools/runqslower: Use consistent include paths for libbpf
>       selftests: Use consistent include paths for libbpf
>       bpftool: Use consistent include paths for libbpf
>       perf: Use consistent include paths for libbpf
>       samples/bpf: Use consistent include paths for libbpf
>       libbpf: Fix include of bpf_helpers.h when libbpf is installed on sy=
stem
>       selftests: Remove tools/lib/bpf from include path
>       tools/runqslower: Remove tools/lib/bpf from include path
>
>

[...]
