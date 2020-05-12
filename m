Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14541D0232
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbgELWZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731761AbgELWXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:23:30 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CBCC061A0E;
        Tue, 12 May 2020 15:23:30 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g16so11810474qtp.11;
        Tue, 12 May 2020 15:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6yncRg3AodPek2LTwgRud/wksmQN/WRehqVAdpiFuc=;
        b=tLI9oJPrXmFgChxoogMyJqERv/yMmE18ymsn0Zm1ciAVK3v58WLX9PwqdeUF9taBgb
         nzK9ZgoqbNZfz9nCzbWlNjcBuLUkoKb7THsNdgF9tTvKOFB1dq0ki3MycCsRsyMAyjkV
         KQ7gCS3J+AuFuPyn3o0fjMCBtIHVfpe2IVKBQwrsOvljT4Kl2LqdVneofMDc3Rub6meY
         2Rs5VurA96bKOo9jisNWWOmqg/wRGM5Fa0mFnahEOTL7sa6ykBMpOAa7uokrMFweo3jI
         +FLfdeH/4UBTUUczq5ZtgUujaTUskRf50iBjIVgolQH5/B9eC+KwlEGnhewNb++GH5ju
         xJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6yncRg3AodPek2LTwgRud/wksmQN/WRehqVAdpiFuc=;
        b=GO2Ir7xLA5xvwlQAHKio2SF/YlrmcrO0wHWCoEDvJliNp52s74+gmIwVyo6v2hwgYh
         2wE+eVv7CIpQ9lCAT5fYvNfd3sqUfREElbRaK9AqdVN+93xm65Nr46gIsZ1e9B/svwhj
         uMvWd4ywO93NwDDp1WK1IApR4N1iuH9GzxMSDAPWkZoEuOCKsknhNWwV5O7Sr7B78pmL
         zcoqoaU5YXo/Lgpg1oXubIzImC7M7P0wOixy0k+mIrd4PWKNaM/fcx7IwGE45M+l15Wv
         Ek2N/ogn7+jDF0S8VyM5FtQ+gEYaS7dcxV22V7kdxdjdOsWBziPvZBMPIeY1gTcTTci6
         CGlg==
X-Gm-Message-State: AGi0PuYKW9VvmGY85GUifzmX+LuXF/fMrL1ihpDyLr8zq0MLFgZoWGdo
        pbdmbDDSlSVTXX5bo0i6+nv770JKb5yHf5fVZyY=
X-Google-Smtp-Source: APiQypKHEKZnAtTFw5WisFw/Zh6CRTEZgB+6IQ+d4gC/zSig8BgkERDfcPQLTDx/CiFxUuTg8KDS1m5MLzie7KtWvQk=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr15825292qtm.171.1589322209264;
 Tue, 12 May 2020 15:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155236.1080458-1-yhs@fb.com>
In-Reply-To: <20200512155236.1080458-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:23:18 -0700
Message-ID: <CAEf4BzatHCQjabDDYPdQ6yAT2nZw7qQDOUpOB9AyZfbiPSw8Cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: add WARN_ONCE if bpf_seq_read show()
 return a positive number
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:54 AM Yonghong Song <yhs@fb.com> wrote:
>
> In seq_read() implementation, a positive integer return value
> of seq_ops->show() indicates that the current object seq_file
> buffer is discarded and next object should be checked.
> bpf_seq_read() implemented in a similar way if show()
> returns a positive integer value.
>
> But for bpf_seq_read(), show() didn't return positive integer for
> all currently supported targets. Let us add a WARN_ONCE for
> such cases so we can get an alert when things are changed.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/bpf_iter.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 0a45a6cdfabd..b0c8b3bdf3b0 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -120,6 +120,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>
>         err = seq->op->show(seq, p);
>         if (err > 0) {
> +               WARN_ONCE(1, "seq_ops->show() returns %d\n", err);

This makes it look like it's a bug or non-safe, honestly. I'd drop the
warning altogether, but if not, probably leaving a comment explaining
why we added WARN_ONCE here and that it's ok to remove it would be
good.

>                 /* object is skipped, decrease seq_num, so next
>                  * valid object can reuse the same seq_num.
>                  */
> @@ -156,6 +157,7 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>
>                 err = seq->op->show(seq, p);
>                 if (err > 0) {
> +                       WARN_ONCE(1, "seq_ops->show() returns %d\n", err);
>                         bpf_iter_dec_seq_num(seq);
>                         seq->count = offs;
>                 } else if (err < 0 || seq_has_overflowed(seq)) {
> --
> 2.24.1
>
