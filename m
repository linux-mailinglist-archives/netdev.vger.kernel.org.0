Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B065107CE5
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfKWFAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:00:47 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44174 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfKWFAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:00:47 -0500
Received: by mail-qv1-f66.google.com with SMTP id d3so3757341qvs.11;
        Fri, 22 Nov 2019 21:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqTK+wymepS6hco9Q7DT4TCBoCuFZ6oJekLdM+N+7Us=;
        b=F4iAdJOiC0X9vp/chYu2f46tT4jWhlL7pyGy2xb6SrYMqdS9BoDLVcNMq+37WUeYQE
         kL4+UYOedkhv0b6QNE1ZW3I4ldCRfBq3BpZnnPrqoJqMGHOItlaK64dm6ONf+oudlXbs
         FqTCVK9xZQtv440YOPtxo2SD6+FeYMPJf4N65qtfREAcURv1c97Qio1kK3/t4o5+OHV7
         eZyRNjG3ce7kYRcvgdflCeC41IECo5nrIna8lolnajdMjH2ZsLAteZtPEKw3sZYbivx+
         DerznCsASRei8+7RiHdn0pD5G6/MsjJc4ZTeYdvNskf1IYopH3wncCGAnrdJsUbNc8pN
         y8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqTK+wymepS6hco9Q7DT4TCBoCuFZ6oJekLdM+N+7Us=;
        b=kbC6YBbWw7KbMJ73zd7O6+WRfssx9CSTAHBnXSXZkppIG8MFJz61Tk2adv1IL51dul
         Q0s2kwoK/eb+sh8thkGSt0vI3dm86FdChwEnibm5tGkDJqub5hA1jfUwCxVbhipLhA+j
         1t/ByqWBA9gic6iL7ATQ+Sy5JSv4/+uYoTmB5+L580HS0XV1QgEZIiXxzOFTPf2w6ycQ
         wz9KGtpbSw/VWtNvzMzagzA5DcZTjONQitC0GHGTxragnEI5xUlisHJbf8smR+scQUxA
         eMmfv+czFP51lTJV2OBHKXshtAFDcSINtNkYOyHWT3Qw7tTa/XYNmrN2XS20ESjgQk0A
         jCkg==
X-Gm-Message-State: APjAAAUeIwtUy+RUOIqIFQs0YgKgeikIcrAis0OpERVCzWu+or8aJvKa
        4w87DpbFKHT0aLZE62S4MroBrfEFpHY3bIrjdovA0w==
X-Google-Smtp-Source: APXvYqzleydYs8FS5XyxhgCfFUc0lfhKaI/tYLYpDyeRZQAGg+kZe8YIY/7K6br3AVWwNnPzVke9jtnDRxGclAxl+vY=
X-Received: by 2002:ad4:4042:: with SMTP id r2mr17670352qvp.196.1574485246200;
 Fri, 22 Nov 2019 21:00:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <6ada4c1c9d35eeb5f4ecfab94593dafa6b5c4b09.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com>
 <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net> <CAADnVQJqYE5TAdJ=o8nHSF1mXoXpsVNXcJtWSPQJDn7wUvxR=Q@mail.gmail.com>
In-Reply-To: <CAADnVQJqYE5TAdJ=o8nHSF1mXoXpsVNXcJtWSPQJDn7wUvxR=Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 21:00:35 -0800
Message-ID: <CAEf4BzZS-yAfYXruzG5+_Wh0Ob4-ChPMPuhcDx4zDoGwUQygcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] bpf, x86: emit patchable direct jump as
 tail call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 6:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Nov 22, 2019 at 3:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >> +       case BPF_MOD_CALL_TO_NOP:
> > >> +       case BPF_MOD_JUMP_TO_NOP:
> > >> +               if (old_addr && !new_addr) {
> > >> +                       memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
> > >> +
> > >> +                       prog = old_insn;
> > >> +                       ret = emit_patch_fn(&prog, old_addr, ip);
> > >> +                       if (ret)
> > >> +                               return ret;
> > >> +                       break;
> > >> +               }
> > >> +               return -ENXIO;
> > >> +       default:
> > >
> > > There is this redundancy between BPF_MOD_xxx enums and
> > > old_addr+new_addr (both encode what kind of transition it is), which
> > > leads to this cumbersome logic. Would it be simpler to have
> > > old_addr/new_addr determine whether it's X-to-NOP, NOP-to-Y, or X-to-Y
> > > transition, while separate bool or simple BPF_MOD_CALL/BPF_MOD_JUMP
> > > enum determining whether it's a call or a jump that we want to update.
> > > Seems like that should be a simpler interface overall and cleaner
> > > implementation?
> >
> > Right we can probably simplify it further, I kept preserving the original
> > switch from Alexei's code where my assumption was that having the transition
> > explicitly spelled out was preferred in here and then based on that doing
> > the sanity checks to make sure we don't get bad input from any call-site
> > since we're modifying kernel text, e.g. in the bpf_trampoline_update() as
> > one example the BPF_MOD_* is a fixed constant input there.
>
> I guess we can try adding one more argument
> bpf_arch_text_poke(ip, BPF_MOD_NOP, old_addr, BPF_MOD_INTO_CALL, new_addr);

I was thinking along the lines of:

bpf_arch_text_poke(ip, BPF_MOD_CALL (or BPF_MOD_JMP), old_addr, new_addr);

old_addr/new_addr being possibly NULL determine NOP/not-a-NOP.

> Not sure whether it's gonna be any cleaner.
> Intuitively doesn't feel so.
