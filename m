Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC291CB7A9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHSwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHSwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:52:20 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5BCC061A0C;
        Fri,  8 May 2020 11:52:20 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f13so2146765qkh.2;
        Fri, 08 May 2020 11:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSKGmHfI5bkIbAkbzqkR7HWpcZ5IXf1t3WO5eo8bzwo=;
        b=EFUgFQUk0+Ya9G8IyqXEaGH0Nlc6yCsUWOz06o2Cbkg148vfoCq7a9Z002lEKCKXVP
         7L/eFavxmwJTb32V3F8IOH/NmY5/l0nvKNHA+DaQie92CYRI1lpnVT9xRgaDpBUGWY48
         EAl/xJwha72KvmYZMQJ4gJ7133V3GSgfR+9bf5C/jT2lI9wGpwjyv+1J5Ckr1lcmGFcs
         0K6eNx1fkAvCtSGlXcbrsNhnw8QDoYlXUgNvwEc44vc8AX45RnSvpT2TuZReZYdeNbWY
         yfQdTKlB1xEBYwvS3U6QRel+WT+SWy13Q9ks9Y9a4fyUtlvjwxItWnPMroQ7NNlKEsKM
         elIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSKGmHfI5bkIbAkbzqkR7HWpcZ5IXf1t3WO5eo8bzwo=;
        b=gJWmJIh6zFC9DL7pBsaghKzlF1UttmvS7V25S7hwAgmP/PpiGpW9GYlZXlvZ0kCuvm
         +DOyAfLRl9jNmdN2kVeUU1E95B6irRyQ8T79JuLMzfkcUi8vwMYzs1lb6UqnxZ4KlS6g
         dD6ad4S9ggtpJF4mZZqp/ntIV6S+w+q5zJ0TDlNAA3shvuK7W9BQ00up6dTeoYMsJhKI
         eRHwWwsydokQwvUVeae0tacRxekOiLMakO96LnUhcTfQtW55BZi0uGxtL+F4xq8VpswJ
         B8gYmaLM8b7a3JQ/2KbqoFXjH173mvf8UCfzO57Mixz3FV/ImELFRyzOZPlgYldPfvRm
         Cb0Q==
X-Gm-Message-State: AGi0PuY22piREhVgVq5iN1NKSlmKp4VF4EKV2rifSyxPJMGSZHPMaZji
        bacPZXNcQzqH6SK3DEUry3/hc7mAKtLD3tzfsuQ=
X-Google-Smtp-Source: APiQypJHggJpAuKOpiafWUfIqRTpagarOz43HgytiKH4zIp+6p0C757wc/vaDELakJe2wORckGKOQAh4pJbNWf/Qsw4=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr4170452qkj.92.1588963939470;
 Fri, 08 May 2020 11:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053920.1542763-1-yhs@fb.com>
In-Reply-To: <20200507053920.1542763-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:52:08 -0700
Message-ID: <CAEf4BzZ_TnCdvTucUpr1CRiGqnf7GZfdyXmszToTTLYyQxbk4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/21] bpf: implement bpf_seq_read() for bpf iterator
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

On Wed, May 6, 2020 at 10:39 PM Yonghong Song <yhs@fb.com> wrote:
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

This loop is much simpler and more streamlined now, thanks a lot! I
think it's correct, see below about one confusing (but apparently
correct) bit, though. Either way:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/bpf_iter.c | 118 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
>
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 0542a243b78c..f198597b0ea4 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -26,6 +26,124 @@ static DEFINE_MUTEX(targets_mutex);
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
> +               if (!seq->buf) {
> +                       err = -ENOMEM;
> +                       goto done;

oh, thank you for converting to all lower-case label names! :)

> +               }
> +       }
> +
> +       if (seq->count) {
> +               n = min(seq->count, size);
> +               err = copy_to_user(buf, seq->buf + seq->from, n);
> +               if (err) {
> +                       err = -EFAULT;
> +                       goto done;
> +               }
> +               seq->count -= n;
> +               seq->from += n;
> +               copied = n;
> +               goto done;
> +       }
> +
> +       seq->from = 0;
> +       p = seq->op->start(seq, &seq->index);
> +       if (IS_ERR_OR_NULL(p))
> +               goto stop;

if start() returns IS_ERR(p), stop(p) below won't produce any output
(because BPF program is called only for p == NULL), so we'll just
return 0 with no error, do I interpret the code correctly? I think
seq_file's read actually returns PTR_ERR(p) as a result in this case.

so I think you need err = PTR_ERR(p); before goto stop here?

> +
> +       err = seq->op->show(seq, p);
> +       if (err > 0) {
> +               seq->count = 0;
> +       } else if (err < 0 || seq_has_overflowed(seq)) {
> +               if (!err)
> +                       err = -E2BIG;
> +               seq->count = 0;
> +               seq->op->stop(seq, p);
> +               goto done;
> +       }
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
> +               if (IS_ERR_OR_NULL(p)) {
> +                       err = PTR_ERR(p);
> +                       break;
> +               }
> +               if (seq->count >= size)
> +                       break;
> +
> +               err = seq->op->show(seq, p);
> +               if (err > 0) {
> +                       seq->count = offs;
> +               } else if (err < 0 || seq_has_overflowed(seq)) {
> +                       seq->count = offs;
> +                       if (!err)
> +                               err = -E2BIG;

nit: this -E2BIG is set unconditionally even for 2nd+ show(). This
will work, because it will get ignored on next iteration, but I think
it will be much more obvious if written as:

if (!err && offs = 0)
    err = -E2BIG;

It took me few re-readings of the code I'm pretty familiar with
already to realize that this is ok.

I had to write the below piece to realize that this is fine :) Just
leaving here just in case you find it useful:

else if (err < 0 || seq_has_overflowed(seq)) {
    if (!err && offs == 0) /* overflow in first show() output */
        err = -E2BIG;
    if (err) {             /* overflow in first show() or real error happened */
        seq->count = 0; /* not strictly necessary, but shows that we
are truncating output */
        seq->op->stop(seq, p);
        goto done; /* done will return err */
    }
    /* no error and overflow for 2nd+ show(), roll back output and stop */
    seq->count = offs;
    break;
}

> +                       if (offs == 0) {
> +                               seq->op->stop(seq, p);
> +                               goto done;
> +                       }
> +                       break;
> +               }
> +       }
> +stop:
> +       offs = seq->count;
> +       /* bpf program called if !p */
> +       seq->op->stop(seq, p);
> +       if (!p && seq_has_overflowed(seq)) {
> +               seq->count = offs;
> +               if (offs == 0) {
> +                       err = -E2BIG;
> +                       goto done;
> +               }
> +       }
> +
> +       n = min(seq->count, size);
> +       err = copy_to_user(buf, seq->buf, n);
> +       if (err) {
> +               err = -EFAULT;
> +               goto done;
> +       }
> +       copied = n;
> +       seq->count -= n;
> +       seq->from = n;
> +done:
> +       if (!copied)
> +               copied = err;
> +       else
> +               *ppos += copied;
> +       mutex_unlock(&seq->lock);
> +       return copied;
> +}
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>         struct bpf_iter_target_info *tinfo;
> --
> 2.24.1
>
