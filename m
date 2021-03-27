Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A334B9BD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 23:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhC0WI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 18:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhC0WIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 18:08:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EC0C0613B1;
        Sat, 27 Mar 2021 15:08:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v8so2605779plz.10;
        Sat, 27 Mar 2021 15:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPDOyXNW0EaFOC3IXvy9pws7OopUmnF/ICER5vmRqrQ=;
        b=AysFk3gUq6fmvn4km4gvmW7ew4kWqsFZzhLS9Gc2fIyjxsBinblpLGYfTKfvHPbHSO
         6oa0nwZ7RW+kh69xa4iAIBYf2HP18SCeeKA4yNLtB2FheEU6TVLUMfdoIRKCiwCITfwB
         StmQGMa5v9+nlQ2NVipvbf7410KwAJlqswSWKPkARISVne7XlA5flkSbqbZRITaMMxL0
         t0rGk1X3hX9nZ+5baLllXf94IE+4PsIFwbMFCXxj43JPoTSbjbdstKaxE1RbkV9z9sit
         TS1xdkbhkQuw4MwA1+J26QATqp4E3EnaGPCfEyQ99WSJLMKvX1RcQWUL4oLjuxacDstn
         uDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPDOyXNW0EaFOC3IXvy9pws7OopUmnF/ICER5vmRqrQ=;
        b=jU77IsDqnF8w+p5b/YkRJyhGexheK1m6SZYE4wGEH5JwBhfYGNHfZnhlX4cdv+D6pb
         JvvmttlJJ2OfiGmEhtf+Os4eiHX2h32/xp+6dI4H0HvivsxnEOoTD3Z/z0KzVh7h2eZ2
         7zdF2ktWamgNYwYxfkFat83tLLrZQirqXOMlc0NzqVNcAhIsI9SwCzGjSbDziYa9fody
         BilaSlPg0KhfJTrkP9FvponL4CpP4h6tInnA1D0vxhrsicWystI1fNZXdtn1cSHo+Eeu
         8QGVu3PF3gBzCwJQ7VJPQq4p6hhFykIKlaEnY3kBwcZw1YrZXeBWjIgrMX5Dx7zqi6o7
         hLtw==
X-Gm-Message-State: AOAM533fZHjFhk/1OwbGftjBXP560npDhPyJXJTUnv/COka9az0p742W
        BbJNUvnLp6Jop5afeyLC3Qv9uy1MCinZ3aT/lT8=
X-Google-Smtp-Source: ABdhPJzfz4qSHaARstZ21CWuB38RArwzLf2UAtIk3sIwtuaj+P9nxLQ+NhA8on9lxxj3lM7XP9zT1VS3XZB6B/UqejA=
X-Received: by 2002:a17:902:c407:b029:e7:3568:9604 with SMTP id
 k7-20020a170902c407b02900e735689604mr6417894plk.31.1616882890220; Sat, 27 Mar
 2021 15:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
In-Reply-To: <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 27 Mar 2021 15:07:59 -0700
Message-ID: <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 2:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 27, 2021 at 2:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wed, Mar 24, 2021 at 8:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > Martin KaFai Lau (14):
> > >   bpf: Simplify freeing logic in linfo and jited_linfo
> > >   bpf: Refactor btf_check_func_arg_match
> > >   bpf: Support bpf program calling kernel function
> > >   bpf: Support kernel function call in x86-32
> > >   tcp: Rename bictcp function prefix to cubictcp
> > >   bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
> >
> > I got the following link error which is likely caused by one of your
> > patches in this series.
> >
> > FAILED unresolved symbol cubictcp_state
> > make: *** [Makefile:1199: vmlinux] Error 255
>
> I don't see it and bpf CI doesn't see it either.
> Without steps to reproduce your observation isn't helpful.

Just `make` is sufficient to reproduce it here:

# make
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
  DESCEND  bpf/resolve_btfids
  CHK     include/generated/compile.h
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.btf
  BTF     .btf.vmlinux.bin.o
  LD      .tmp_vmlinux.kallsyms1
  KSYMS   .tmp_vmlinux.kallsyms1.S
  AS      .tmp_vmlinux.kallsyms1.S
  LD      .tmp_vmlinux.kallsyms2
  KSYMS   .tmp_vmlinux.kallsyms2.S
  AS      .tmp_vmlinux.kallsyms2.S
  LD      vmlinux
  BTFIDS  vmlinux
FAILED unresolved symbol cubictcp_state
make: *** [Makefile:1199: vmlinux] Error 255

I suspect it is related to the kernel config or linker version.

# grep TCP_CONG .config
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
CONFIG_TCP_CONG_CDG=m
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_TCP_CONG="cubic"

# gcc --version
gcc (Debian 8.3.0-6) 8.3.0
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# pahole --version
v1.17

Also, reverting this whole patchset also makes it go away.

Thanks.
