Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C548A1C62AA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgEEVKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728135AbgEEVKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:10:30 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9209C061A0F;
        Tue,  5 May 2020 14:10:29 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i68so3327855qtb.5;
        Tue, 05 May 2020 14:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tADx304EulM4siLAnx60ijEqMOtRwMLQPD2dcNTwpp8=;
        b=vZx7LO694zIcHCHylzCNvcV1S6xK+wNUZZ6A1JBMttRIXS2LsB/p7KiaBTaSd0YYTk
         cBSQ4XhLt7DNMIeATMDPqUm3JjRzycGSo4LZTtywjM/CrKTh6oO8XsqpDPw39EnNYVzZ
         80e8gj+pMTF0wRY3PjLuk7TnuvHVZUrQVVBA/yLIKFuU7QkZBTWkMezD+zzZdhLa9ch2
         gs8JCVosQQXVMUWWc430FqBH52/Qic3/3+Ua2UcRYzQJ6ss1ChbIRXsrZsnTdQ1h3gPt
         Aedic2mog5gk688my4ISlrb01/i9dfBg36akZ5CA466jk1ZHIqZfGHr1kUZXvRbCsT2T
         BvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tADx304EulM4siLAnx60ijEqMOtRwMLQPD2dcNTwpp8=;
        b=A3O+x2pVcGlqWnjzCO2Vvt54Y6gjmn78lRsJJQ7x03kvlixvT9ZjcEPbiZ9bG62LOI
         taZyCz6OaJ9CM2IZrqOAhDCumqrLgEOz/NPDq8QoBFgxz1SwXVOdFMaBwyl32lQOK7A7
         ea53qePXzaHS4d5cXTgnMUCwBdUKsuHJ216xMIlMUZRpp3hEUytVA4Anc6yzwd/D5s7O
         8P2YGbj3yjFYa4UOrmCgzQhMAq/F8vJ2nJzTpF6DafDrYOEo3inNCugETw4AklONJhpD
         /rDR96EHDj4zxJo56K6RNiT7byvFy5Pxfj4e+8BHlwxizFijnidHZYp2DR8BfbSiSrYw
         GRMw==
X-Gm-Message-State: AGi0Puat8aIBkKHPCKzLvXnqMpzNa+Q6LTGjccKV7yeVrbwm5ClC8Kz2
        Ubj6AXjh+NoQA77ok/0Ny6hOAzD3IaVrAwvjq6sIKQ==
X-Google-Smtp-Source: APiQypIedD5CwZvHw6IREBzqlEDFKBzjH0kfSWm/qTrq9Z6Mgd7iu6orJ6AVS+pV6pOUQIMYtPyhsFkNmqE4yn2EwMw=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr4741340qtd.117.1588713028809;
 Tue, 05 May 2020 14:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062555.2048028-1-yhs@fb.com>
 <CAEf4BzZnzKrTX4sN+PJC8fhdv=+gXMTAan=OUfgRFtvusfnaWQ@mail.gmail.com> <2794c31e-c750-7488-5e2b-a72a8791082b@fb.com>
In-Reply-To: <2794c31e-c750-7488-5e2b-a72a8791082b@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:10:17 -0700
Message-ID: <CAEf4BzbkQjKztZ8aQhzKhbP23MEKzt-9bepCHnPSfFs86JsUXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/20] bpf: implement common macros/helpers
 for target iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 1:30 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/5/20 1:25 PM, Andrii Nakryiko wrote:
> > On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Macro DEFINE_BPF_ITER_FUNC is implemented so target
> >> can define an init function to capture the BTF type
> >> which represents the target.
> >>
> >> The bpf_iter_meta is a structure holding meta data, common
> >> to all targets in the bpf program.
> >>
> >> Additional marker functions are called before/after
> >> bpf_seq_read() show() and stop() callback functions
> >> to help calculate precise seq_num and whether call bpf_prog
> >> inside stop().
> >>
> >> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
> >> are implemented so target can get needed information from
> >> bpf_iter infrastructure and can run the program.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h   | 11 +++++
> >>   kernel/bpf/bpf_iter.c | 94 ++++++++++++++++++++++++++++++++++++++++---
> >>   2 files changed, 100 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 26daf85cba10..70c71c3cd9e8 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -1129,6 +1129,9 @@ int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
> >>   int bpf_obj_get_user(const char __user *pathname, int flags);
> >>
> >>   #define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
> >> +#define DEFINE_BPF_ITER_FUNC(target, args...)                  \
> >> +       extern int __bpf_iter__ ## target(args);                \
> >> +       int __init __bpf_iter__ ## target(args) { return 0; }
> >
> > Why is extern declaration needed here? Doesn't the same macro define
>
> Silence sparse warning. Apparently in kernel, any global function, they
> want a declaration?

Ah.. alright :)

>
> > global function itself? I'm probably missing some C semantics thingy,
> > sorry...
> >
> >>
> >>   typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
> >>   typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
> >> @@ -1141,11 +1144,19 @@ struct bpf_iter_reg {
> >>          u32 seq_priv_size;
> >>   };
> >>
> >> +struct bpf_iter_meta {
> >> +       __bpf_md_ptr(struct seq_file *, seq);
> >> +       u64 session_id;
> >> +       u64 seq_num;
> >> +};
> >> +
> >
> > [...]
> >
> >>   /* bpf_seq_read, a customized and simpler version for bpf iterator.
> >>    * no_llseek is assumed for this file.
> >>    * The following are differences from seq_read():
> >> @@ -83,12 +119,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> >>          if (!p || IS_ERR(p))
> >>                  goto Stop;
> >>
> >> +       bpf_iter_inc_seq_num(seq);
> >
> > so seq_num is one-based, not zero-based? So on first show() call it
> > will be set to 1, not 0, right?
>
> It is 1 based, we need to document this clearly. I forgot to adjust my
> bpf program for this. Will adjust them properly in the next revision.

I see. IMO, seq_num starting at 0 is more natural, but whichever way
is fine with me.

> >
> >>          err = seq->op->show(seq, p);
> >>          if (seq_has_overflowed(seq)) {
> >> +               bpf_iter_dec_seq_num(seq);
> >>                  err = -E2BIG;
> >>                  goto Error_show;
> >>          } else if (err) {
> >>                  /* < 0: go out, > 0: skip */
> >> +               bpf_iter_dec_seq_num(seq);
> >>                  if (likely(err < 0))
> >>                          goto Error_show;
> >>                  seq->count = 0;
> >
> > [...]
> >
