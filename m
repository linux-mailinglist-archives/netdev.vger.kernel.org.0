Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C2E20DDAA
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733177AbgF2URy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732647AbgF2TZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:25:41 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C0AC061755;
        Mon, 29 Jun 2020 12:25:41 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w73so3661687ila.11;
        Mon, 29 Jun 2020 12:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awRqujOiMrDdEv/OOzJOIKIzdh+u8WQaaIXpTu/mSk0=;
        b=SQQbB8OZtY8KVolOJ6QYhRlc/DURbUQ07ItMEpjAbF+W+aNVxTkluJqoo1+6a6daKx
         ZEbfRLv9nmOVSirZ8lGn8Dav3wQCKjRCKzUoLt+tl5+9c/W+tlNYG8h/0Ib48YKCzfuu
         lLS1MbHrqAK0VfOAEI9AO4kw3kcJ/1D8Q8X3bJ5n07fzpreXbbHU/SV6YdK3KSHl/W3a
         /J2MYTo+x5fduZAUyqHx1tPp7RHthfbJ2VavWzQsWG5KIuozx+5d0TTh3faKtwbHhWxz
         xGIIyN4M0G9RTV9irrAdM1B757qpwPeTGtOFc8lG+CkT0Co1yiIaUc4+fAtKCq21udCy
         NTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awRqujOiMrDdEv/OOzJOIKIzdh+u8WQaaIXpTu/mSk0=;
        b=GRqeNNSKLvLg9jMvN0hb6JI9i6s9MMC3MX7vjelROZ8l3ny/r5VzWI0X829PxciUBQ
         DgobQgnG8HsLLX2hTbrnsBOT/ZFDkjjRMl9N0thAVNvj8PajFd47Lx7UG/sHCprZ3zYa
         LF2jkf7/l7R9/3CrxefTxrrB8Gs8XsQiT87MDQ0JUXXx5z48VkE5QHgKL4U9RAkPC74H
         xHpDfWRS99PYzSMecPxLytRVHymudgVaCBglIEbLTRW7SJHwKCKduIVr6+VFFZ5fLGx5
         Ve4WX+VR8cQQGRUvqyCmfH4hKv8rluVTKGGilHl/3Nz8fWLnG4JUzo/657+J7o9kXrnj
         Ldmw==
X-Gm-Message-State: AOAM5328MFXXMM26V997rIxJTHatqCWAfJ7RxJ0gv+RntUZ/c4rm3O0o
        jHO+Y77T7UWN8x44DsxvSMCQAgE33teKO8pDhW8=
X-Google-Smtp-Source: ABdhPJw/Lp5J7VJZzWUMpKXFLNVSc2m8IqqQPvYMNlTYwBZMTO4BHXQsap8uE9Ir128HGPXlXy8p6kDi/w+RvplAavs=
X-Received: by 2002:a92:6b05:: with SMTP id g5mr16679410ilc.120.1593458741165;
 Mon, 29 Jun 2020 12:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200629055530.3244342-1-songliubraving@fb.com>
In-Reply-To: <20200629055530.3244342-1-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 12:25:29 -0700
Message-ID: <CAEf4BzbUh-Q=7a0cyxWm+=DA9hhovpLRcBGsq2ocXoCWpC2SUA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 11:54 AM Song Liu <songliubraving@fb.com> wrote:
>
> This set introduces a new helper bpf_get_task_stack(). The primary use case
> is to dump all /proc/*/stack to seq_file via bpf_iter__task.
>
> A few different approaches have been explored and compared:
>
>   1. A simple wrapper around stack_trace_save_tsk(), as v1 [1].
>
>      This approach introduces new syntax, which is different to existing
>      helper bpf_get_stack(). Therefore, this is not ideal.
>
>   2. Extend get_perf_callchain() to support "task" as argument.
>
>      This approach reuses most of bpf_get_stack(). However, extending
>      get_perf_callchain() requires non-trivial changes to architecture
>      specific code. Which is error prone.
>
>   3. Current (v2) approach, leverages most of existing bpf_get_stack(), and
>      uses stack_trace_save_tsk() to handle architecture specific logic.
>
> [1] https://lore.kernel.org/netdev/20200623070802.2310018-1-songliubraving@fb.com/
>
> Changes v3 => v4:
> 1. Simplify the selftests with bpf_iter.h. (Yonghong)
> 2. Add example output to commit log of 4/4. (Yonghong)
>
> Changes v2 => v3:
> 1. Rebase on top of bpf-next. (Yonghong)
> 2. Sanitize get_callchain_entry(). (Peter)
> 3. Use has_callchain_buf for bpf_get_task_stack. (Andrii)
> 4. Other small clean up. (Yonghong, Andrii).
>
> Changes v1 => v2:
> 1. Reuse most of bpf_get_stack() logic. (Andrii)
> 2. Fix unsigned long vs. u64 mismatch for 32-bit systems. (Yonghong)
> 3. Add %pB support in bpf_trace_printk(). (Daniel)
> 4. Fix buffer size to bytes.
>
> Song Liu (4):
>   perf: expose get/put_callchain_entry()
>   bpf: introduce helper bpf_get_task_stack()
>   bpf: allow %pB in bpf_seq_printf() and bpf_trace_printk()
>   selftests/bpf: add bpf_iter test with bpf_get_task_stack()
>
>  include/linux/bpf.h                           |  1 +
>  include/linux/perf_event.h                    |  2 +
>  include/uapi/linux/bpf.h                      | 36 ++++++++-
>  kernel/bpf/stackmap.c                         | 75 ++++++++++++++++++-
>  kernel/bpf/verifier.c                         |  4 +-
>  kernel/events/callchain.c                     | 13 ++--
>  kernel/trace/bpf_trace.c                      | 12 ++-
>  scripts/bpf_helpers_doc.py                    |  2 +
>  tools/include/uapi/linux/bpf.h                | 36 ++++++++-
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
>  .../selftests/bpf/progs/bpf_iter_task_stack.c | 37 +++++++++
>  11 files changed, 220 insertions(+), 15 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
>
> --
> 2.24.1

Thanks for working on this! This will enable a whole new set of tools
and applications.

Acked-by: Andrii Nakryiko <andriin@fb.com>
