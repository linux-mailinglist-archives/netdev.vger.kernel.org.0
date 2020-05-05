Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64101C6168
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEET4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEET4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:56:14 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E9C061A0F;
        Tue,  5 May 2020 12:56:14 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s2so195365qtq.13;
        Tue, 05 May 2020 12:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cf/0i1AzurWniqV3J618DdxsQ8szFCFmkFE6Zuk0aZ4=;
        b=FIvmwxYMolp0anYF4K54TsNvQ6xq5+CuicohiNP9VaKRZViiWOf1Qao5R9+beEURrw
         zl3f8Pt65Dt9MNhHx4/Mf2lyjSkjIM1pUCj01wQWCXr846/7ysh0cUFe/8MUcGwHxGE7
         068iVYmbpLRFzqNfLEXNXK84FN/s6fKtfTDue+//uihtcC+0zkJM6yfW1EOC2Cvh0BiB
         TnSx9HeBeyDWc6hLUY1HI9FqoCmLKdUDVozVuhb80IrIhQQET8FWtS8v2LbvgsEP7fue
         BwRC5Z+PhCpYThXH1eO5x4m+p4J9iCHc0X7Sk0MuLUfexco7al21JTEWwK6uY4FGcXst
         at0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cf/0i1AzurWniqV3J618DdxsQ8szFCFmkFE6Zuk0aZ4=;
        b=kLYhHNh5cGVNKvfJzfDdQaFLjel8jYsKOrbrChHEIFcWOktxSh2hx/Y+MaPpxvL37R
         UIOISiPg8I4QOmnKYOB2uWDqwyBhi0ovPPZVEImRQAN9YftFJd9P6h08n6BbUciJSWP+
         /dYp1qILETLIabHvHRqVKaY/y4iqsAW3oSVwuYhgyBpslRPdxvvmk+jjYgyxfMnZtu4C
         qB7KPbBNMoroVzXxBq+ruuviMxsYjP1KoNKNxJIksiTxF1gGXeFf3QZAARnLEPWKtVjV
         PuGKtXnEKdIQoUOOE1ihB8kqoUiZeTl7YHwOLXbAxfKz7rBpsCVTeZEgTsIfv4PRIEGh
         J8yg==
X-Gm-Message-State: AGi0PuZE4O6qhKm9ZPd9v8Q3Sy0OJUBIlMRUHF7eb5bBscSu3FpAol1h
        29AhkIh18OnCYQarvj9ydLiTR74RQqAusSPI52Y=
X-Google-Smtp-Source: APiQypLaA1zdOkVrBf7dyyBfdi5uKanqW75P1/XiKIPwzxsRCapFZFBZ1d86YGLLBFH0hOuYPQD+gVNwbOxkQUN7i/4=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr4512593qtk.171.1588708573252;
 Tue, 05 May 2020 12:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062552.2047789-1-yhs@fb.com>
In-Reply-To: <20200504062552.2047789-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 12:56:02 -0700
Message-ID: <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com>
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

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> bpf iterator uses seq_file to provide a lossless
> way to transfer data to user space. But we want to call
> bpf program after all objects have been traversed, and
> bpf program may write additional data to the
> seq_file buffer. The current seq_read() does not work
> for this use case.
>
> Besides allowing stop() function to write to the buffer,
> the bpf_seq_read() also fixed the buffer size to one page.
> If any single call of show() or stop() will emit data
> more than one page to cause overflow, -E2BIG error code
> will be returned to user space.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/bpf_iter.c | 128 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 05ae04ac1eca..2674c9cbc3dc 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -26,6 +26,134 @@ static DEFINE_MUTEX(targets_mutex);
>  /* protect bpf_iter_link changes */
>  static DEFINE_MUTEX(link_mutex);
>
> +/* bpf_seq_read, a customized and simpler version for bpf iterator.
> + * no_llseek is assumed for this file.
> + * The following are differences from seq_read():
> + *  . fixed buffer size (PAGE_SIZE)
> + *  . assuming no_llseek
> + *  . stop() may call bpf program, handling potential overflow there
> + */
> +static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
> +                           loff_t *ppos)
> +{
> +       struct seq_file *seq = file->private_data;
> +       size_t n, offs, copied = 0;
> +       int err = 0;
> +       void *p;
> +
> +       mutex_lock(&seq->lock);
> +
> +       if (!seq->buf) {
> +               seq->size = PAGE_SIZE;
> +               seq->buf = kmalloc(seq->size, GFP_KERNEL);
> +               if (!seq->buf)
> +                       goto Enomem;

Why not just mutex_unlock and exit with -ENOMEM? Less goto'ing, more
straightforward.

> +       }
> +
> +       if (seq->count) {
> +               n = min(seq->count, size);
> +               err = copy_to_user(buf, seq->buf + seq->from, n);
> +               if (err)
> +                       goto Efault;
> +               seq->count -= n;
> +               seq->from += n;
> +               copied = n;
> +               goto Done;
> +       }
> +
> +       seq->from = 0;
> +       p = seq->op->start(seq, &seq->index);
> +       if (!p || IS_ERR(p))

IS_ERR_OR_NULL?

> +               goto Stop;
> +
> +       err = seq->op->show(seq, p);
> +       if (seq_has_overflowed(seq)) {
> +               err = -E2BIG;
> +               goto Error_show;
> +       } else if (err) {
> +               /* < 0: go out, > 0: skip */
> +               if (likely(err < 0))
> +                       goto Error_show;
> +               seq->count = 0;
> +       }

This seems a bit more straightforward:

if (seq_has_overflowed(seq))
    err = -E2BIG;
if (err < 0)
    goto Error_show;
else if (err > 0)
    seq->count = 0;

Also, I wonder if err > 0 (so skip was requested), should we ignore
overflow? So something like:

if (err > 0) {
    seq->count = 0;
} else {
    if (seq_has_overflowed(seq))
        err = -E2BIG;
    if (err)
        goto Error_show;
}

> +
> +       while (1) {
> +               loff_t pos = seq->index;
> +
> +               offs = seq->count;
> +               p = seq->op->next(seq, p, &seq->index);
> +               if (pos == seq->index) {
> +                       pr_info_ratelimited("buggy seq_file .next function %ps "
> +                               "did not updated position index\n",
> +                               seq->op->next);
> +                       seq->index++;
> +               }
> +
> +               if (!p || IS_ERR(p)) {

Same, IS_ERR_OR_NULL.

> +                       err = PTR_ERR(p);
> +                       break;
> +               }
> +               if (seq->count >= size)
> +                       break;
> +
> +               err = seq->op->show(seq, p);
> +               if (seq_has_overflowed(seq)) {
> +                       if (offs == 0) {
> +                               err = -E2BIG;
> +                               goto Error_show;
> +                       }
> +                       seq->count = offs;
> +                       break;
> +               } else if (err) {
> +                       /* < 0: go out, > 0: skip */
> +                       seq->count = offs;
> +                       if (likely(err < 0)) {
> +                               if (offs == 0)
> +                                       goto Error_show;
> +                               break;
> +                       }
> +               }

Same question here about ignoring overflow if skip was requested.

> +       }
> +Stop:
> +       offs = seq->count;
> +       /* may call bpf program */
> +       seq->op->stop(seq, p);
> +       if (seq_has_overflowed(seq)) {
> +               if (offs == 0)
> +                       goto Error_stop;
> +               seq->count = offs;

just want to double-check, because it's not clear from the code. If
all the start()/show()/next() succeeded, but stop() overflown. Would
stop() be called again on subsequent read? Would start/show/next
handle this correctly as well?

> +       }
> +
> +       n = min(seq->count, size);
> +       err = copy_to_user(buf, seq->buf, n);
> +       if (err)
> +               goto Efault;
> +       copied = n;
> +       seq->count -= n;
> +       seq->from = n;
> +Done:
> +       if (!copied)
> +               copied = err;
> +       else
> +               *ppos += copied;
> +       mutex_unlock(&seq->lock);
> +       return copied;
> +
> +Error_show:
> +       seq->op->stop(seq, p);
> +Error_stop:
> +       seq->count = 0;
> +       goto Done;
> +
> +Enomem:
> +       err = -ENOMEM;
> +       goto Done;
> +
> +Efault:
> +       err = -EFAULT;
> +       goto Done;

Enomem and Efault seem completely redundant and just add goto
complexity to this algorithm. Let's just inline `err =
-E(NOMEM|FAULT); goto Done;` instead?

> +}
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>         struct bpf_iter_target_info *tinfo;
> --
> 2.24.1
>
