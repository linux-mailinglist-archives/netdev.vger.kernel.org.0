Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D405B21E436
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgGNACH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNACH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:02:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC251C061755;
        Mon, 13 Jul 2020 17:02:06 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id d17so20285670ljl.3;
        Mon, 13 Jul 2020 17:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0cfrkzzv7XgU7cyUuzXAx+2nPotIXfhcv+12wgA2PU=;
        b=Uo6J2KIaVi5iU9mYcgcqzhVJBqxlVa4sYe1wJAUnnbea4/LUpZMBgnxgFadQoedtGJ
         OuH4hfjd0FSrVHyokDb3dobfnJ4J13kG23lMdkYO87RuDq5eac/8AGiIFFKlkS3C5Wat
         71/xV22dzhJL5hiXv1sFI0Yayeo3aVTr3ML24asM2kGs0bkESZ8meoTLnDt6nH2byEfk
         DnQ5PvOffeJq+oYlmdPsY52SsgTrCBY4M2PQxlbrsztQxfE6rg+fYiqUc7JodnftFm9k
         ai34hbCWTYyLZc5L3zMpszTx2mAqL94AsWYfx5vlF+X27gkfbH8ZhjWwUt+5oW0T1fMN
         HIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0cfrkzzv7XgU7cyUuzXAx+2nPotIXfhcv+12wgA2PU=;
        b=gWxEDg768C8cFiD/pSziQoX/m/+LyaCZGnazjkTcU86OO5yCYuuSdC9q6eabLVDcPu
         kmGvETX0z3SkmPO9j0R6sDi43wC7CilTd5dQ7iWtRsCoNR8Lp8QNka+up3e6VVoLY2dF
         xxOkXc4gzCMw2sKwWKsSHpl0HIRAIRyR8QBjzau6j5zyTutTHFH08kFhUc665S5x5Z94
         GsHSY8WRkZO5RqHIWhP3UVNeoPXoSlX5i3y3cU4lpUMjIiDtqfH2bl0jzqJDNUtvcaAf
         jVQbeuUPZdPomb1SeCfNJzCmrs5yuFpidDL7OaLZI8RzRTTJGCv8vu90TBCgShnJEBV+
         Xjqg==
X-Gm-Message-State: AOAM530dvNfNOgO+MrdBhPQ8ZFXFqYO2O6ngiyzudmmAocTtlulF6vIC
        xmIvuPeO5V0pPWQ4WrhNSc+SSwqTgAlo56YKfRY=
X-Google-Smtp-Source: ABdhPJyWXrP4OKhLSQynsQ3WHaYu7RkyIxlewG61uW/dnYgJxXYryPcW5+IGLewX0Oxs/Mz1G5tjSbXwF94RYlStLms=
X-Received: by 2002:a2e:8216:: with SMTP id w22mr985388ljg.2.1594684925231;
 Mon, 13 Jul 2020 17:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jul 2020 17:01:53 -0700
Message-ID: <CAADnVQ+zBgz0DBJr0sLK3PsfCYgfSLp6fZMh=m7XtMKfSOupEQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/2] bpf: fix use of trace_printk() in BPF
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 4:53 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Steven suggested a way to resolve the appearance of the warning banner
> that appears as a result of using trace_printk() in BPF [1].
> Applying the patch and testing reveals all works as expected; we
> can call bpf_trace_printk() and see the trace messages in
> /sys/kernel/debug/tracing/trace_pipe and no banner message appears.
>
> Also add a test prog to verify basic bpf_trace_printk() helper behaviour.
>
> Changes since v2:
>
> - fixed stray newline in bpf_trace_printk(), use sizeof(buf)
>   rather than #defined value in vsnprintf() (Daniel, patch 1)
> - Daniel also pointed out that vsnprintf() returns 0 on error rather
>   than a negative value; also turns out that a null byte is not
>   appended if the length of the string written is zero, so to fix
>   for cases where the string to be traced is zero length we set the
>   null byte explicitly (Daniel, patch 1)
> - switch to using getline() for retrieving lines from trace buffer
>   to ensure we don't read a portion of the search message in one
>   read() operation and then fail to find it (Andrii, patch 2)
>
> Changes since v1:
>
> - reorder header inclusion in bpf_trace.c (Steven, patch 1)
> - trace zero-length messages also (Andrii, patch 1)
> - use a raw spinlock to ensure there are no issues for PREMMPT_RT
>   kernels when using bpf_trace_printk() within other raw spinlocks
>   (Steven, patch 1)
> - always enable bpf_trace_printk() tracepoint when loading programs
>   using bpf_trace_printk() as this will ensure that a user disabling
>   that tracepoint will not prevent tracing output from being logged
>   (Steven, patch 1)
> - use "tp/raw_syscalls/sys_enter" and a usleep(1) to trigger events
>   in the selftest ensuring test runs faster (Andrii, patch 2)
>
> [1]  https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home

Applied. Thanks
