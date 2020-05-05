Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DBF1C62A0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgEEVI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:08:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A50C061A0F;
        Tue,  5 May 2020 14:08:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n14so3909842qke.8;
        Tue, 05 May 2020 14:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3XeLjN9tvylOedvcMAbJadXpurYo65JccIGsAi4dvP4=;
        b=QUFfW9fU2pekoKT5G+hsXQiwpSE04Li+2eQV3VkCdtD403HGEOIm9EpRx5zRKSNMJw
         2uI3YWOYHoMH+TlmKCsEGRagQU5HVwchpbC6pnEStOQWqWIBAsLXoAb7sX1sG1rHN2M6
         EGlnn50rQbLh2ISNuTfLVq1fdVJN/20ciKbs33QQVfqM8jjc37gcZb4ODH9b/V0XI47U
         6TrK4I1acltiFHcAf26Q0GH/7I8jvCV72wCrFj1zhd2F9PL8J52pZ/ljSY/fBIZtKOV6
         NDDqAMS4XKKDB7XqgE0tddpDebNIXWEMZXlkkn6PDxTnVD/TNMTdeTQYks1vscmQggJk
         wKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3XeLjN9tvylOedvcMAbJadXpurYo65JccIGsAi4dvP4=;
        b=FZ+jpUpMb1WPx7WYblO6nTfVZeKXu/wB4yvH/syp+f7zUrVXFwjqWYZhaPbLSPXev3
         /hypOjNIA2xsqxlKMjH7ixMbCrB2q2kUwab4y6B3dLa5xU0/VXtBYqk52WemFuh/YKo5
         Ryz5WvAbwCw54sa112rxB7bHCGKykljP+5JHXLF68pNx3sZJ43tAk8xPruMBG5bkWIrY
         baw25T7FWqC2rIDmv5kxzHf1Vu/M6loLpIfzYnz/lNtXJXqwWvl8Je3eEfJvD2SKnou/
         9P17UQPwxN01w6r52iIFkYcf3KfeX04QYb+hn9qeE/wqcUNMvBVdC5iUaZg8rNDMwJN1
         Z1Vw==
X-Gm-Message-State: AGi0PuZToyQ6Tm107EYwBsilnsWJPpAbtZcGOAnO9IlE2QdiOVI58A62
        vHxF4f1b3FbjI9H5LKzmSmAoUI96piOMmzNSepU=
X-Google-Smtp-Source: APiQypLCg7X8djWitgw0l9swW1pH4mxI9uGdXLlUJGFPxOWjUFeYveffhbsRSkC840l1bbeT93BilEbm7LlIGFFSiTQ=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr5490517qkj.92.1588712905505;
 Tue, 05 May 2020 14:08:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062552.2047789-1-yhs@fb.com>
 <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com> <23105f0f-3d0a-7a40-8795-fe1a68349880@fb.com>
In-Reply-To: <23105f0f-3d0a-7a40-8795-fe1a68349880@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:08:14 -0700
Message-ID: <CAEf4BzbrUxjxnj0ncwYg7iLjGSrJDnTgwt=MdY-bD7=2xJ1iMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/20] bpf: implement bpf_seq_read() for bpf iterator
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

On Tue, May 5, 2020 at 1:25 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/5/20 12:56 PM, Andrii Nakryiko wrote:
> > On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> bpf iterator uses seq_file to provide a lossless
> >> way to transfer data to user space. But we want to call
> >> bpf program after all objects have been traversed, and
> >> bpf program may write additional data to the
> >> seq_file buffer. The current seq_read() does not work
> >> for this use case.
> >>
> >> Besides allowing stop() function to write to the buffer,
> >> the bpf_seq_read() also fixed the buffer size to one page.
> >> If any single call of show() or stop() will emit data
> >> more than one page to cause overflow, -E2BIG error code
> >> will be returned to user space.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   kernel/bpf/bpf_iter.c | 128 ++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 128 insertions(+)
> >>
> >> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> >> index 05ae04ac1eca..2674c9cbc3dc 100644
> >> --- a/kernel/bpf/bpf_iter.c
> >> +++ b/kernel/bpf/bpf_iter.c
> >> @@ -26,6 +26,134 @@ static DEFINE_MUTEX(targets_mutex);
> >>   /* protect bpf_iter_link changes */
> >>   static DEFINE_MUTEX(link_mutex);
> >>
> >> +/* bpf_seq_read, a customized and simpler version for bpf iterator.
> >> + * no_llseek is assumed for this file.
> >> + * The following are differences from seq_read():
> >> + *  . fixed buffer size (PAGE_SIZE)
> >> + *  . assuming no_llseek
> >> + *  . stop() may call bpf program, handling potential overflow there
> >> + */
> >> +static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> >> +                           loff_t *ppos)
> >> +{
> >> +       struct seq_file *seq = file->private_data;
> >> +       size_t n, offs, copied = 0;
> >> +       int err = 0;
> >> +       void *p;
> >> +
> >> +       mutex_lock(&seq->lock);
> >> +
> >> +       if (!seq->buf) {
> >> +               seq->size = PAGE_SIZE;
> >> +               seq->buf = kmalloc(seq->size, GFP_KERNEL);
> >> +               if (!seq->buf)
> >> +                       goto Enomem;
> >
> > Why not just mutex_unlock and exit with -ENOMEM? Less goto'ing, more
> > straightforward.
> >
> >> +       }
> >> +
> >> +       if (seq->count) {
> >> +               n = min(seq->count, size);
> >> +               err = copy_to_user(buf, seq->buf + seq->from, n);
> >> +               if (err)
> >> +                       goto Efault;
> >> +               seq->count -= n;
> >> +               seq->from += n;
> >> +               copied = n;
> >> +               goto Done;
> >> +       }
> >> +
> >> +       seq->from = 0;
> >> +       p = seq->op->start(seq, &seq->index);
> >> +       if (!p || IS_ERR(p))
> >
> > IS_ERR_OR_NULL?
>
> Ack.
>
> >
> >> +               goto Stop;
> >> +
> >> +       err = seq->op->show(seq, p);
> >> +       if (seq_has_overflowed(seq)) {
> >> +               err = -E2BIG;
> >> +               goto Error_show;
> >> +       } else if (err) {
> >> +               /* < 0: go out, > 0: skip */
> >> +               if (likely(err < 0))
> >> +                       goto Error_show;
> >> +               seq->count = 0;
> >> +       }
> >
> > This seems a bit more straightforward:
> >
> > if (seq_has_overflowed(seq))
> >      err = -E2BIG;
> > if (err < 0)
> >      goto Error_show;
> > else if (err > 0)
> >      seq->count = 0;
> >
> > Also, I wonder if err > 0 (so skip was requested), should we ignore
> > overflow? So something like:
>
> Think about overflow vs. err > 0 case, I double checked seq_file()
> implementation again, yes, it is skipped. So your suggestion below
> looks reasonable.
>
> >
> > if (err > 0) {
> >      seq->count = 0;
> > } else {
> >      if (seq_has_overflowed(seq))
> >          err = -E2BIG;
> >      if (err)
> >          goto Error_show;
> > }
> >
> >> +
> >> +       while (1) {
> >> +               loff_t pos = seq->index;
> >> +
> >> +               offs = seq->count;
> >> +               p = seq->op->next(seq, p, &seq->index);
> >> +               if (pos == seq->index) {
> >> +                       pr_info_ratelimited("buggy seq_file .next function %ps "
> >> +                               "did not updated position index\n",
> >> +                               seq->op->next);
> >> +                       seq->index++;
> >> +               }
> >> +
> >> +               if (!p || IS_ERR(p)) {
> >
> > Same, IS_ERR_OR_NULL.
>
> Ack.
>
> >
> >> +                       err = PTR_ERR(p);
> >> +                       break;
> >> +               }
> >> +               if (seq->count >= size)
> >> +                       break;
> >> +
> >> +               err = seq->op->show(seq, p);
> >> +               if (seq_has_overflowed(seq)) {
> >> +                       if (offs == 0) {
> >> +                               err = -E2BIG;
> >> +                               goto Error_show;
> >> +                       }
> >> +                       seq->count = offs;
> >> +                       break;
> >> +               } else if (err) {
> >> +                       /* < 0: go out, > 0: skip */
> >> +                       seq->count = offs;
> >> +                       if (likely(err < 0)) {
> >> +                               if (offs == 0)
> >> +                                       goto Error_show;
> >> +                               break;
> >> +                       }
> >> +               }
> >
> > Same question here about ignoring overflow if skip was requested.
>
> Yes, we should prioritize err > 0 over overflow.
>
> >
> >> +       }
> >> +Stop:
> >> +       offs = seq->count;
> >> +       /* may call bpf program */
> >> +       seq->op->stop(seq, p);
> >> +       if (seq_has_overflowed(seq)) {
> >> +               if (offs == 0)
> >> +                       goto Error_stop;
> >> +               seq->count = offs;
> >
> > just want to double-check, because it's not clear from the code. If
> > all the start()/show()/next() succeeded, but stop() overflown. Would
> > stop() be called again on subsequent read? Would start/show/next
> > handle this correctly as well?
>
> I am supposed to handle this unless there is a bug...
> The idea is:
>     - if start()/show()/next() is fine and stop() overflow,
>       we will skip stop() output and move on.
>       (if we found out, we skip to the beginning of the
>        buffer, we will return -E2BIG. Otherwise, we will return
>        0 here, the user read() may just exit.)
>     - next time, when read() called again, the start() will return
>       NULL (since previous next() returns NULL) and the control
>       will jump to stop(), which will try to do another dump().
>

Right, sounds reasonable :)

> >
> >> +       }
> >> +
> >> +       n = min(seq->count, size);
> >> +       err = copy_to_user(buf, seq->buf, n);
> >> +       if (err)
> >> +               goto Efault;
> >> +       copied = n;
> >> +       seq->count -= n;
> >> +       seq->from = n;
> >> +Done:
> >> +       if (!copied)
> >> +               copied = err;
> >> +       else
> >> +               *ppos += copied;
> >> +       mutex_unlock(&seq->lock);
> >> +       return copied;
> >> +
> >> +Error_show:
> >> +       seq->op->stop(seq, p);
> >> +Error_stop:
> >> +       seq->count = 0;
> >> +       goto Done;
> >> +
> >> +Enomem:
> >> +       err = -ENOMEM;
> >> +       goto Done;
> >> +
> >> +Efault:
> >> +       err = -EFAULT;
> >> +       goto Done;
> >
> > Enomem and Efault seem completely redundant and just add goto
> > complexity to this algorithm. Let's just inline `err =
> > -E(NOMEM|FAULT); goto Done;` instead?
>
> We can do this. This is kind of original seq_read() coding
> style. Agree that we do not need to follow them.
>
> >
> >> +}
> >> +
> >>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
> >>   {
> >>          struct bpf_iter_target_info *tinfo;
> >> --
> >> 2.24.1
> >>
