Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5972A29AA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgKBLld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgKBLl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:41:28 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE77C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:41:26 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id dg9so13985211edb.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ebgImq9cX37i8dO2jYvT9G/MUOhzkfIEPnkqS0CcwWw=;
        b=V2/KNcjvvdIRo+YidKToPTdZexvzQqwOe+NmpcuEcFFHugVuwXQf0yzo+HMO0AkIa8
         Se18MfKQy5PIoIzZfthFOuf5BWV+Y/XN4PtOqrBnxGlynolSpFTXzrbj8icjyN+B/Mhy
         E0hnxWxrEof19PPCd20vBIa/ImOdhCQVwecF2QM55dLcV1DjAHFmeBN6u/0lmYnq1Krz
         03ENh2NAVOtMCPfbuVSCl7wdd1EiU1GTNUZN4BtosTOJ5/KNdims9LEJfDfpwlWbj3H+
         rYbgRVRSPGGGWy8rvEnV/F67zhc8RuqgwuCY3OycDFtCT8bBF5SITOdI4MBwETljFqtC
         rHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ebgImq9cX37i8dO2jYvT9G/MUOhzkfIEPnkqS0CcwWw=;
        b=f46+/0rMtNZgSOLbyVjVBhjReVXNxGlrA9DQOTc6k1/zGGaEumsuMR3oFLc1pK5bDk
         4yiBkE3BcWkLE2S5t6OpxO1BN2/gSjwpRj8IJgTTZaHlIqGUcX+qp6Jg6nm3gFKoqHmr
         kOvhYa4RaGYDb9Aa01RfNpDyAh4aphf/x+jST2d2sQuh3TTuUTVM01uqcX15sSk0BpWr
         QvwmdylVHm2exFeUcl0KI4TyYYrVUAh18tvyXWZbmATTAuTCnJhjf1T7MqaKA1ac5AZv
         Dvz3Y9cQ9AhCpnzIeC54J9ytyTfNwx6bbWxdt32ahCxp7XupTuH4w+4P/Y9MgnT2ZV6/
         xtqg==
X-Gm-Message-State: AOAM5316s5qxxyK+ih0CVwuoUTiQowddoLqoUzbpwz4UIVAaxqLT3UOR
        awgxzrMnpR3AXCJjnURj8A9t1de/+yJjk9a3bbezdA==
X-Google-Smtp-Source: ABdhPJwO7UaRSzxgz+ZwLIZj7Az0d+ReMZ3aP878ycRPtxEmfFI7g9C8pk2W4gQI8V5Sx95OvRps6nHorIYTWBJzFcI=
X-Received: by 2002:aa7:dc52:: with SMTP id g18mr16280212edu.369.1604317285393;
 Mon, 02 Nov 2020 03:41:25 -0800 (PST)
MIME-Version: 1.0
References: <20201029111730.6881-1-david.verbeiren@tessares.net>
 <CAPhsuW7o7D-6VW-Z3Umdw8z-7Ab+kkZrJf2EU9nCDFh0Xbn7sA@mail.gmail.com> <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com>
In-Reply-To: <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com>
From:   David Verbeiren <david.verbeiren@tessares.net>
Date:   Mon, 2 Nov 2020 12:41:09 +0100
Message-ID: <CAHzPrnHhy00boU-e3e3ifBzpNSs4U_=Hd-j8h9KNKUwAgXjd8g@mail.gmail.com>
Subject: Re: [PATCH bpf] selftest/bpf: Validate initial values of per-cpu hash elems
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 11:36 AM Song Liu <song@kernel.org> wrote:
> >
> > On Thu, Oct 29, 2020 at 4:19 AM David Verbeiren
> > <david.verbeiren@tessares.net> wrote:
> > >
> > > Tests that when per-cpu hash map or LRU hash map elements are
> > > re-used as a result of a bpf program inserting elements, the
> > > element values for the other CPUs than the one executing the
> > > BPF code are reset to 0.
> > >
> > > This validates the fix proposed in:
> > > https://lkml.kernel.org/bpf/20201027221324.27894-1-david.verbeiren@tessares.net/
[...]
> > > ---
> > > +
> > > +/* executes bpf program that updates map with key, value */
> > > +static int bpf_prog_insert_elem(int fd, map_key_t key, map_value_t value)
> > > +{
> > > +       struct bpf_load_program_attr prog;
> > > +       struct bpf_insn insns[] = {
> > > +               BPF_LD_IMM64(BPF_REG_8, key),
> > > +               BPF_LD_IMM64(BPF_REG_9, value),
> > > +
> > > +               /* update: R1=fd, R2=&key, R3=&value, R4=flags */
> > > +               BPF_LD_MAP_FD(BPF_REG_1, fd),
> > > +               BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > > +               BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_8, 0),
> > > +               BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
> > > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -8),
> > > +               BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_9, 0),
> > > +               BPF_MOV64_IMM(BPF_REG_4, 0),
> > > +               BPF_EMIT_CALL(BPF_FUNC_map_update_elem),
> > > +
> > > +               BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +               BPF_EXIT_INSN(),
> > > +       };
> >
> > Impressive hand written assembly. ;-) I would recommend using skeleton
> > for future work. For example:
> >
> >     BPF program: selftests/bpf/progs/bpf_iter_bpf_map.c
> >     Use the program in tests:
> > selftests/bpf/prog_tests/bpf_iter.c:#include "bpf_iter_bpf_map.skel.h"
> >
>
> Let's keep a manually-constructed assembly to test_verifier tests only.
>
> David, please also check progs/test_endian.c and prog_tests/endian.c
> as one of the most minimal self-tests with no added complexity, but
> complete end-to-end setup.

Thanks for the suggestion, Andrii. I tried using the same simple setup
as prog_tests/endian.c but unfortunately when using sys_enter
tracepoint, the bpf program runs several times, on various cpus.
This invalidates the check in userspace to verify that the value was
updated for only one cpu and was initialized to 0 for the other ones.
I tried to change the bpf program so it would only run once but I bumped
into the limitation that the return value of __sync_fetch_annd_add()
(and family) cannot be used. Any suggestion for this? Can I combine
skeleton with bpf_prog_test_run()?
