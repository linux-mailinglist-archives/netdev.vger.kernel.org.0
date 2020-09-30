Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DE427DEED
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 05:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgI3DYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 23:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgI3DYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 23:24:12 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9261C061755;
        Tue, 29 Sep 2020 20:24:11 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so305540ljk.8;
        Tue, 29 Sep 2020 20:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeYKiV1LlnGE4ZUELRBmCLDTr7v+GXQIuTlENX7Xwp4=;
        b=q3N5OZpTNYs5uDXTHfHqnDI1xiFUxWQ76gKS/EOE+HuAHXiHQ1samk2JdnxO565FAd
         lryyIbDNhGo3OUIsjNKvIo59ajug1MbzXbM4A07op6by5j4Se8sWiMomiQhJdmehkLt9
         66OMp0HZgCDpGTX2/MuKPRXznrEjR2N/gmCuU7jd4EOxcJqIg/LQCFInMlLzucQE3nLS
         cvy1inE47Am5BRtfp+adwP06pLQjZBiWyyvUK2fiSWVR9byJAEpP/rNHrQK2Kty9Sl1A
         mk/2ms36HDnG7Y7RBm2sUBYkIGAoHj+ZzY4cWzmogeqg9wSwPiG2W2lmy5OLVZxupTIF
         yEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeYKiV1LlnGE4ZUELRBmCLDTr7v+GXQIuTlENX7Xwp4=;
        b=YLyXWmGZ4E2zv++gBNaK2ipX91VAMBBWtNdEIXsPP8X+lH8JmDx9NLlDSw+uikENXi
         Q0x5Z7e/GIIkd9tLcTRioaD4NVpVv6pu2D3XXwdLIpCZHtnAw8/3eku0LTtoynSXlYrH
         U1XYxv33xETjf175JZ7fPzvPByjFfd4UVUnGMPnVYo9dXIhOCPFTcHYQZufZuH0TA4MM
         L1AtqDN/7k7tqk/j46k6vKSDZgybzoBE8OUFCGHIoxAJeyi7icK943xSauM/UujFOYOa
         WyobyvXwRVaD38i1Joeq87tpPY1Rj2aWODi1IZ6hqmcHuuZA6ad9FkiETeZsy4o+Mi45
         LI+A==
X-Gm-Message-State: AOAM5314cSREuBgHnNcEnpNtSU3XoRsw2P1LidHEAzo4Xnr7nf4c/2lR
        zd4aN960ijjOiWhGpPW1ZcictOOo7k457KQxLSc=
X-Google-Smtp-Source: ABdhPJz0Ul0ZPMg7H4/0bkrHNPN5WnxXjJqyRmFVUFh0NNFE973bM+jU1iBtL41YvEknKOwONmEdiF9BPaSbh7T8+6U=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr200969lji.290.1601436250294;
 Tue, 29 Sep 2020 20:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200930002011.521337-1-songliubraving@fb.com>
In-Reply-To: <20200930002011.521337-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 20:23:58 -0700
Message-ID: <CAADnVQ+jaUfJkD0POaRyrmrLueVP9x-rN8bcN5eEz4XPBk96bw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
To:     Song Liu <songliubraving@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 5:20 PM Song Liu <songliubraving@fb.com> wrote:
>
> In preempt kernel, BPF_PROG_TEST_RUN on raw_tp triggers:
>
> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
> code: new_name/87
> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615bd02bf #1
> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1ubuntu1 04/01/2014
> [   35.916941] Call Trace:
> [   35.919660]  dump_stack+0x77/0x9b
> [   35.923273]  check_preemption_disabled+0xb4/0xc0
> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.933872]  ? selinux_bpf+0xd/0x70
> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
> [   35.941570]  ? find_held_lock+0x2d/0x90
> [   35.945687]  ? vfs_write+0x150/0x220
> [   35.949586]  do_syscall_64+0x2d/0x40
> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Fix this by calling migrate_disable() before smp_processor_id().
>
> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
>
> ---
> Changes v1 => v2:
> 1. Keep rcu_read_lock/unlock() in original places. (Alexei)
> 2. Use get_cpu() instead of smp_processor_id(). (Alexei)

Applying: bpf: fix raw_tp test run in preempt kernel
Using index info to reconstruct a base tree...
error: patch failed: net/bpf/test_run.c:293
error: net/bpf/test_run.c: patch does not apply
error: Did you hand edit your patch?
