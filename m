Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB9425EB4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhJGV0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhJGV0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:26:20 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8ADC061570;
        Thu,  7 Oct 2021 14:24:26 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g6so16515153ybb.3;
        Thu, 07 Oct 2021 14:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cohpP+WfqlcqHI/gHqxpG7Bq/Ceu+jNeCFoomYPbmFI=;
        b=DTyEtc3OB/GzlivGMG2mPogzIyRENYUannyaMpp70rLmhdmviYKuMkWaujnQff7m9L
         7nEVuFeWgIv+GZh1IIOkTVBtPO+rog25ZAqFzp4BtrqKy7LW+8I/TDdbBwQyykPp7uIC
         A3r1u+dEu22KeNFdjwh8aMhoFxFjk4Htvs18VlpAyUaXnh6a7sAqEjZ0ESYCUiruzd6v
         1zzVD+9yUNb+380/HmSxCX9LbBjysWFVQ+Bm9h0v0N2Klmw+00QiG8uZ/FfSzVCJV1J7
         suiDlXHeIrKFcxmdggRePaTLck9kNtc565XhoKFSCTc+Ju7aIqCLa4h5OwsGcqyOk8rH
         vm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cohpP+WfqlcqHI/gHqxpG7Bq/Ceu+jNeCFoomYPbmFI=;
        b=jV0jGec4Yxo65Z0vowjpzsdW0NS4YXWyIf+ZLqcNVX3b4XCvm4wdk2wyXh4xrKVNOU
         NFNg5EGVCArEYTppLG0vJ+N49eSyDqgx2C4KM1SyYDAXlokxSlREHsFkkfObvWgH3BXU
         sKd4HQjl7r5eFFfINat9p4r3I86Dqv6tFk9ByRL1I1Q/CiPrwbWV+ZFLaOhqmbHe91PI
         GaApRm2gfltm7JOhzUMFOtPe8yecgwH4wfZOYYHcs7c1EgTf1uIzGnLB6zFJYeyQbUXh
         BGjmFWaKDqi+hnlIMkRSVDPUTDi9o/+aLB2Wm7OLlQ9JA1jRAU/+Jos5HC5B6BW4MfHd
         3uXg==
X-Gm-Message-State: AOAM533s4ZIC8c86YbSCEfXFFnRq+D6PTvFsLEKeuP2ip7h1UXrEUEu2
        kw+YBtN0KFG0LCP8nmuXwgrCfgxRW9z4f+Zy7gI=
X-Google-Smtp-Source: ABdhPJx4YQKt5eDQrWnvx6FyZpRz1JeJzGeINoTrNnxOFkxLwUV4gcgvmSJMbyoP6lqVMCv85In/elL0lsxXXtK5WPk=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr7714180ybk.2.1633641865236;
 Thu, 07 Oct 2021 14:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <CAEf4Bzb1MftD6KEvBqgs=wR5VVSLrir_tVBPwwvLu2RvW5=tNA@mail.gmail.com>
 <CACdoK4+4iB-aquCgxXV9BYcXZpPrREZrnm+G8hau-SOt8QPtqQ@mail.gmail.com>
In-Reply-To: <CACdoK4+4iB-aquCgxXV9BYcXZpPrREZrnm+G8hau-SOt8QPtqQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Oct 2021 14:24:14 -0700
Message-ID: <CAEf4BzaQf1tXWpxFZ=2apFZrF-8KM81=ke7W+4Y1JUUTBqDc+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] install libbpf headers when using the library
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 12:43 PM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> On Wed, 6 Oct 2021 at 19:28, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
> >
> > On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> =
wrote:
> > >
> > > Libbpf is used at several locations in the repository. Most of the ti=
me,
> > > the tools relying on it build the library in its own directory, and i=
nclude
> > > the headers from there. This works, but this is not the cleanest appr=
oach.
> > > It generates objects outside of the directory of the tool which is be=
ing
> > > built, and it also increases the risk that developers include a heade=
r file
> > > internal to libbpf, which is not supposed to be exposed to user
> > > applications.
> > >
> > > This set adjusts all involved Makefiles to make sure that libbpf is b=
uilt
> > > locally (with respect to the tool's directory or provided build direc=
tory),
> > > and by ensuring that "make install_headers" is run from libbpf's Make=
file
> > > to export user headers properly.
> > >
> > > This comes at a cost: given that the libbpf was so far mostly compile=
d in
> > > its own directory by the different components using it, compiling it =
once
> > > would be enough for all those components. With the new approach, each
> > > component compiles its own version. To mitigate this cost, efforts we=
re
> > > made to reuse the compiled library when possible:
> > >
> > > - Make the bpftool version in samples/bpf reuse the library previousl=
y
> > >   compiled for the selftests.
> > > - Make the bpftool version in BPF selftests reuse the library previou=
sly
> > >   compiled for the selftests.
> > > - Similarly, make resolve_btfids in BPF selftests reuse the same comp=
iled
> > >   library.
> > > - Similarly, make runqslower in BPF selftests reuse the same compiled
> > >   library; and make it rely on the bpftool version also compiled from=
 the
> > >   selftests (instead of compiling its own version).
> > > - runqslower, when compiled independently, needs its own version of
> > >   bpftool: make them share the same compiled libbpf.
> > >
> > > As a result:
> > >
> > > - Compiling the samples/bpf should compile libbpf just once.
> > > - Compiling the BPF selftests should compile libbpf just once.
> > > - Compiling the kernel (with BTF support) should now lead to compilin=
g
> > >   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
> > > - Compiling runqslower individually should compile libbpf just once. =
Same
> > >   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators=
.
> > >
> > > (Not accounting for the boostrap version of libbpf required by bpftoo=
l,
> > > which was already placed under a dedicated .../boostrap/libbpf/ direc=
tory,
> > > and for which the count remains unchanged.)
> > >
> > > A few commits in the series also contain drive-by clean-up changes fo=
r
> > > bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. P=
lease
> > > refer to individual commit logs for details.
> > >
> > > v3:
> >
> > Please see few problems with libbpf_hdrs phony targets. Seems like
> > they all can be order-only dependencies and not causing unnecessary
> > rebuilds.
>
> Nice catch, I didn't realise it would force rebuilding :(. I'll
> address it in the next version. I'll also add a few adjustments to
> libbpf's and bpftool's Makefiles to make sure we don't recompile when
> not necessary, because of the header files that are currently
> installed unconditionally.
>
> > Can you please also normalize your patch prefixes for bpftool and
> > other tools? We've been using a short and simple "bpftool: " prefix
> > for bpftool-related changes, and for other tools it would be just
> > "tools/runqslower" or "tools/resolve_btfids". Please update
> > accordingly. Thanks!
>
> $ git log --oneline --pretty=3D'format:%s' -- tools/bpf/bpftool/ | \
>         grep -oE '^(bpftool:|tools: bpftool:)' | sort | uniq -c
>    128 bpftool:
>    194 tools: bpftool:
>

But then:

$ git log --oneline --pretty=3D'format:%s' -- tools/testing/selftests/bpf/ =
| \
        grep -oE '^(selftests/bpf:|selftests: bpf:)' | sort | uniq -c
    925 selftests/bpf:
     98 selftests: bpf:

And if we expand your search a bit:

$ git log --oneline --pretty=3D'format:%s' -- tools/bpf/bpftool/ | \
         grep -oE '^(bpftool:|tools: bpftool:|tools/bpftool:)' | sort | uni=
q -c
    130 bpftool:
     52 tools/bpftool:
    194 tools: bpftool:

bpftool: + tools/bpftool: almost matches up with tools: bpftool: ;)

I think the most prevailing convention was "dir1/dir2: " style overall.

> ... And =E2=80=9Cwe=E2=80=9D've been using =E2=80=9Ctools: bpftool:=E2=80=
=9D since the early days :).
> But yeah sure, I'll adjust. Shorter looks better. Just wondering, are
> those prefixes documented anywhere?

I don't think so.


>
> Thanks,
> Quentin
