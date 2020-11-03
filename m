Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6079C2A4ED3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgKCS2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgKCS2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:28:22 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BF8C0613D1;
        Tue,  3 Nov 2020 10:28:21 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k138so9164234ybk.6;
        Tue, 03 Nov 2020 10:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=574uwkGc0C4pv6VwNyYV5ghOFPzaIBGtNNA+ATbUcD0=;
        b=Z3H0xKgT3yy6E2OhwdLn+UtXkxXseQpV52TVnb17l/+tjgW5JEZhfTb1pXoTm2buSP
         uQFfjvDycYALsuz74klX4RLTDJjRpn1nkM5BH5A0Smrndc8L01nIkyxxDbVRlCH6kRuJ
         UjYlpooLj/qXk8mgEIcz8B7Ql3monZze1AIF5W70QdfrXPkLvK3ZimDETXoIT1Fpz+pG
         s5LpDh7re/MF3z7g14/zNWFAYTJIYv2UgTzcTEFe7BCk4HFaA+K3BTw0lYBEHS+FYftZ
         Iz8sRWwHzX/qpbkbqluH1mWAElWAnMhzaLZTD2MjpTBjVBSp8K5NYit3njOxFLTaijWp
         vCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=574uwkGc0C4pv6VwNyYV5ghOFPzaIBGtNNA+ATbUcD0=;
        b=euDfDO9DuXzFdhRtzc1bmtY3FJnl9nhB0KseGfYcwvpSyjPaDahiJnpgc3/P1SF1/R
         YPGtHB96u6SYmu8Q0v/11QuwRNt7kgCPuocOrQKZiirlMWbHW7b3EydMsryv4zWCb0a0
         vYtx4PfWRJQF7oxqi4GrBqmufg76ZNCUbO632xV7JnJSALhZIcg5A0mwnJtMby5BmbSG
         /vzqFcat3wB35QVBM1BNjyWhoWLpsCx0slfPpnzEkkG8EbDtih+EdZHgwqmI9VJthWBN
         f8k4Ys/aeNiuzL02J8drz+5ynZn0YJZUvuqEoppfogjbMrJF27H27lCbEbDc/I4iBVU0
         keUA==
X-Gm-Message-State: AOAM533j25xky+TS0fkfsNP6ko5OKjqxzv3TSuq+LeOWguwByioPB0gh
        3fzNL6ednO4xP1/kiVXpwv+ksFZjhFPwlZM4wCY=
X-Google-Smtp-Source: ABdhPJwJ4Fa4LUF+GFam6VBlbHxRnvjgh1ChJ2o0YbPa7D2ml4rpgZDH9dISkCzu/xPjRlP3ulmv0eWw3Qu6J1gyM78=
X-Received: by 2002:a25:c001:: with SMTP id c1mr28446659ybf.27.1604428099431;
 Tue, 03 Nov 2020 10:28:19 -0800 (PST)
MIME-Version: 1.0
References: <20201029111730.6881-1-david.verbeiren@tessares.net>
 <CAPhsuW7o7D-6VW-Z3Umdw8z-7Ab+kkZrJf2EU9nCDFh0Xbn7sA@mail.gmail.com>
 <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com> <CAHzPrnHhy00boU-e3e3ifBzpNSs4U_=Hd-j8h9KNKUwAgXjd8g@mail.gmail.com>
In-Reply-To: <CAHzPrnHhy00boU-e3e3ifBzpNSs4U_=Hd-j8h9KNKUwAgXjd8g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 10:28:08 -0800
Message-ID: <CAEf4BzYOrHNR_S1PzMS93AvgG7SEeY-Yxm9Vt=dKU7k2KEFy0g@mail.gmail.com>
Subject: Re: [PATCH bpf] selftest/bpf: Validate initial values of per-cpu hash elems
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 3:41 AM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> On Thu, Oct 29, 2020 at 11:37 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 11:36 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Thu, Oct 29, 2020 at 4:19 AM David Verbeiren
> > > <david.verbeiren@tessares.net> wrote:
> > > >
> > > > Tests that when per-cpu hash map or LRU hash map elements are
> > > > re-used as a result of a bpf program inserting elements, the
> > > > element values for the other CPUs than the one executing the
> > > > BPF code are reset to 0.
> > > >
> > > > This validates the fix proposed in:
> > > > https://lkml.kernel.org/bpf/20201027221324.27894-1-david.verbeiren@tessares.net/
> [...]
> > > > ---
> > > > +
> > > > +/* executes bpf program that updates map with key, value */
> > > > +static int bpf_prog_insert_elem(int fd, map_key_t key, map_value_t value)
> > > > +{
> > > > +       struct bpf_load_program_attr prog;
> > > > +       struct bpf_insn insns[] = {
> > > > +               BPF_LD_IMM64(BPF_REG_8, key),
> > > > +               BPF_LD_IMM64(BPF_REG_9, value),
> > > > +
> > > > +               /* update: R1=fd, R2=&key, R3=&value, R4=flags */
> > > > +               BPF_LD_MAP_FD(BPF_REG_1, fd),
> > > > +               BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > > > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > > > +               BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_8, 0),
> > > > +               BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
> > > > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -8),
> > > > +               BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_9, 0),
> > > > +               BPF_MOV64_IMM(BPF_REG_4, 0),
> > > > +               BPF_EMIT_CALL(BPF_FUNC_map_update_elem),
> > > > +
> > > > +               BPF_MOV64_IMM(BPF_REG_0, 0),
> > > > +               BPF_EXIT_INSN(),
> > > > +       };
> > >
> > > Impressive hand written assembly. ;-) I would recommend using skeleton
> > > for future work. For example:
> > >
> > >     BPF program: selftests/bpf/progs/bpf_iter_bpf_map.c
> > >     Use the program in tests:
> > > selftests/bpf/prog_tests/bpf_iter.c:#include "bpf_iter_bpf_map.skel.h"
> > >
> >
> > Let's keep a manually-constructed assembly to test_verifier tests only.
> >
> > David, please also check progs/test_endian.c and prog_tests/endian.c
> > as one of the most minimal self-tests with no added complexity, but
> > complete end-to-end setup.
>
> Thanks for the suggestion, Andrii. I tried using the same simple setup
> as prog_tests/endian.c but unfortunately when using sys_enter
> tracepoint, the bpf program runs several times, on various cpus.
> This invalidates the check in userspace to verify that the value was
> updated for only one cpu and was initialized to 0 for the other ones.
> I tried to change the bpf program so it would only run once but I bumped
> into the limitation that the return value of __sync_fetch_annd_add()
> (and family) cannot be used. Any suggestion for this? Can I combine
> skeleton with bpf_prog_test_run()?

Replied to the new version of the patch. You can use a bit more
selective tracepoint (so the test won't accidentally trigger it
multiple times) and filter on thread ID. And yes, of course you can
use bpf_prog_test_run() with skeleton. In the end it's all about FDs,
which you easily get from skeleton.
