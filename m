Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7113A3285
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhFJR4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:56:02 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:39888 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJR4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:56:00 -0400
Received: by mail-lj1-f180.google.com with SMTP id c11so6080677ljd.6;
        Thu, 10 Jun 2021 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=on0Tnjo9EX+wZkS0PcGQkLK+8ozdHMxgRM2ZPf0mD60=;
        b=j9utiUZQhGBbTOtjugU9fdt/FXWpsia1oR3qKOXO/TPLUkuvy8TaWMJ5/wiA8q+zGK
         rNeb/Lo9SaW23+goSZYwxCL81gW4lJ2d8mT/R/NRu3wGbc/KRlVewK+k0Xb/KI26YLLZ
         Cz27Cvxmt+KcIx3sxWdN1VTqPBcHoO/BqkNz4bhpyD4axCSB4iFhYAMvxuKNOOFgSmZq
         9W74zfrKa813xMYFi5ra7SMIN7Y+cZ+aIUMj96Lr5DWGVPUHiAc4QJsseTdfTp221f6e
         1fNG4bxiKO5JWNKCJ4Ampld4s8EJ6RLZ1P5vXV/V17ditBBYMdDdswCtE4Y9BLTqyJ7F
         bvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=on0Tnjo9EX+wZkS0PcGQkLK+8ozdHMxgRM2ZPf0mD60=;
        b=Gnkpj4Kn8pGlOOJhXkoS1wgv59gOQhXoxFLloPZbIlY36i/g/e0P9bZIDnmDY2gs9C
         gfYnDpS7NQub+SHuo9s2LpNr0V/n9GABTPDqzxO99b+q6HtjmCzfrW4/GCQOPCYvtVnL
         UMap1R0uV+ibyMN2pM0PlGQTz3eFRrPv1NxoU/byf/ZBQHJ9iOWuakYLAEde5AVh30pr
         aQna9AtSq5MxW2dForp1rR4AK0JAWKCtpmkbhlWVz+G/zxpWfgZRswkh+n12nPgszdl0
         70gbY44PYZgPQ5XlbMcN08FSBmn85953RKtlyJVDTljXDB45WSy3vJvqsd8uYwOj4pMW
         yusA==
X-Gm-Message-State: AOAM530VAoMvcB0/pqkXsHcl42fKQqI16BUkEyudMirCs881JzFeiNGz
        r9VoQO7n63ZvD6NayGdgbWezAgv8+rTP2FSEKgc=
X-Google-Smtp-Source: ABdhPJws5IUcrVuyFh3x8K8w0l/lXTFkf9nHIYvn2dADR0QD7VRdNZF2eqVjHmAmOhded8cSA4fG+o+m8KFwXjKW8mw=
X-Received: by 2002:a2e:b5c8:: with SMTP id g8mr3170497ljn.204.1623347568936;
 Thu, 10 Jun 2021 10:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210602212726.7-1-fuzzybritches0@gmail.com> <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon> <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook> <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook>
In-Reply-To: <202106101002.DF8C7EF@keescook>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Jun 2021 10:52:37 -0700
Message-ID: <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Kees Cook <keescook@chromium.org>
Cc:     Yonghong Song <yhs@fb.com>, Dmitry Vyukov <dvyukov@google.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        nathan@kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:06 AM Kees Cook <keescook@chromium.org> wrote:
>
> > > I guess the main question: what should happen if a bpf program writer
> > > does _not_ use compiler nor check_shl_overflow()?
>
> I think the BPF runtime needs to make such actions defined, instead of
> doing a blind shift. It needs to check the size of the shift explicitly
> when handling the shift instruction.

Such ideas were brought up in the past and rejected.
We're not going to sacrifice performance to make behavior a bit more
'defined'. CPUs are doing it deterministically. It's the C standard
that needs fixing.

> Sure, but the point of UBSAN is to find and alert about undefined
> behavior, so we still need to fix this.

No. The undefined behavior of C standard doesn't need "fixing" most of the time.
