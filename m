Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC832A755B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgKECW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKECW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 21:22:57 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1228C0613CF;
        Wed,  4 Nov 2020 18:22:57 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id c129so656893yba.8;
        Wed, 04 Nov 2020 18:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/cUsKBy9aLzWUWC4mZ7IACQUgXjiEVgWxOTM1gmtNM=;
        b=lJQGK9GnG7+J1uANBdbm8uKpq19z1gyaLw66X3197v/Eh+m5OlnLslNEYbVlu8g8CK
         ZZCnFYLl5Bg0lLnvaFFI1+OYo7uzQVhzaiqM6sHwmLyZ9/KoO3qTEUZkhQcgB9KRfnN8
         eBdIre3o2wwrMhl29bF+4M29TxDUhxpZKGuUz1EFvsuPhwlVpdYE7NaiLIrNBLmW+yRK
         fjVq88UCPkLDlKQXQfSHgItIJYak4Ljuwd4tMTACe9e6YmQ9YE7US7DwHu4bArcX5+a6
         j4txsOjCj/2V7wFzO1I6TLS6nAiHUfJ8LxaIomR58GCxyFdn5cWMEb+SRFCpj8rQMXas
         48/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/cUsKBy9aLzWUWC4mZ7IACQUgXjiEVgWxOTM1gmtNM=;
        b=USs2oOA9l7cEf+ri2zh9DSD1gmsqOqfElq/Ejj58i8cXVX0sLHvKrDtVE/MLi3M315
         o4N+czi150b9VGEtTPOirkdfTBROSfJY+5fodMwVdHKkwxOvHhY/EMURLnRBcj04vXAf
         AcLWLKdMLUdXngufmCIXF7h6GobF/Ladpw28q1Svv3wqAzu8KAqe09g+GjvFztuLR07N
         iVICTM3oTbvQxlofnHY/dhRAuyw3nFmjhRDRh1Qp96vucnc0aVem+eCkqbPGzCWaRo4w
         cGk+ELS6VfNGiTtPc9WroIqEOjNZHsuypf5wkBD6ntcoeEUdgxuOBoJqJC6Vm8t7xool
         zlZw==
X-Gm-Message-State: AOAM531WjYji2XwWqpgZ68Ks8VrKmeEF/6e3HgIkblf7xktxkrhOqbBX
        ei+/q99uJri5O/Vf4PSXLbfGCx6YJkLln/myPlY=
X-Google-Smtp-Source: ABdhPJzNhaZ8T0cY5P/wh86IVEQo+Ph/kiGxD5Z+mYUIy/qaoPMQYrjpqQBI12hm6aFBmXdv28Ug9NWJ3cexImZ50Do=
X-Received: by 2002:a25:bf89:: with SMTP id l9mr709494ybk.22.1604542976980;
 Wed, 04 Nov 2020 18:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20201104191052.390657-1-ndesaulniers@google.com>
In-Reply-To: <20201104191052.390657-1-ndesaulniers@google.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 5 Nov 2020 03:22:46 +0100
Message-ID: <CANiq72m9xX78==qAyu5dKPv-26tPh=ia4xORivvpvwbtoENSqQ@mail.gmail.com>
Subject: Re: [PATCH] compiler-clang: remove version check for BPF Tracing
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chen Yu <yu.chen.surf@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 8:11 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> bpftrace parses the kernel headers and uses Clang under the hood. Remove
> the version check when __BPF_TRACING__ is defined (as bpftrace does) so
> that this tool can continue to parse kernel headers, even with older
> clang sources.

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
